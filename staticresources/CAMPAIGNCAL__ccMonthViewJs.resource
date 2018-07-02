/*
 * Provides Bracket Labs Campaign Calendar functionality and related
 * event handlers.
 *	Jordan, 9/28/11 - 	Added '.pageTitleIcon' URL set due to some unexpected behavior with
 *						the icon in Winter '12 Dev. preview. Also note, that unobfascated code
 *						may not contain some hotfixes that are present in obfascated packaged
 *						Javascript, when using this code until otherwise noted, be sure to 
 *						check for regression error.
 *						Moved jQuery shortcut from '$' to '$j'
 *						
 */
beenFocused = true;
var blccFilterId;
var lastFaultCode;
var dialog;
var loadText = 'Loading...';
var qtipTimeout;
var suspendTooltips = false;

/**
 * Load and render the calendar after page load
 */ 
var $j = jQuery.noConflict();
$j(document).ready(function() {
	$j('.pageTitleIcon').removeAttr('height');
	$j('.pageTitleIcon').removeAttr('width');
	$j('.campaignCalendarViewSelect').customSelect();
	$j('.campaignCalendarViewSelect').width($j('.customStyleSelectBox').outerWidth());
	$j('.campaignCalendarViewSelect').height($j('.customStyleSelectBox').outerHeight());
	// $j('#ccViewSelect').buttonset();
	$j('#ccViewSelect').show();
	// $j('.previousIncrement').button();
	// $j('.nextIncrement').button();
	// $j('.incrementToToday').button();
	if($j.cookie('apex__blccView') == 'planningView')
	{
		window.location = planningViewURL;
	}
	
    if ($j('#blccCalendar').length > 0) {
        blccCalendar();
    }
    
    blccInitHandlers();	
    headerControls.initHeader();
	$j('.pageTitleIcon').attr('src',campaignCalendarIcon);
	
    $j('[data-toggle="tooltip"]').tooltip();
    // createColorLegend();
    attachModalMethods();
    refreshCalendarHeight();
});

/**
 * Construct the calendar view and render it into the document page.
 */
var eventCount = 0;
var eventCountInfo = {};
function blccCalendar() {
    $j('#blccCalendar').fullCalendar({
        lang: currentUserLocale,
        theme: true,
        header: '',
    	columnFormat: {
    		month: 'dddd'
		},
        // height: 250,
        aspectRatio: 1.833,
        disableDragging: disableDragging,
        weekMode: 'liquid',
        //firstDay: (blccStartOfWeek != null) ? blccStartOfWeek : 0,
        selectable: true,
        selectHelper: true,
        editable: true,
        allDayDefault: true,
        loading: function(isLoading, view) {
            if (isLoading) {
                // Begin loading from SFDC
				$j('#blccCalendar').mask(loadText);
                $j('.loadmask-msg').addClass('initial-load-msg');
            }
          },
    	fetchDelay: 225,
    	refetchDateRange: false,
        events: $j.fullCalendar.sfdcEventFeed(),
        eventClick: function(event, jsEvent, view) {
            presentCampaignModal(event.id);
            
            $j('.ui-dialog-content').mask('Loading...');
            return false;
        },
       eventMouseover: function(event, jsEvent, view) {
        },

        eventDragStart: function(event, jsEvent, ui, view) {
            suspendTooltips = true;
        },
        eventDragStop: function(event, jsEvent, ui, view) {
            suspendTooltips = false;
        },
        /*
         * Changing to remote methods, changes the way we handle responses and errors, Jordan 2/7/2012
         */
        eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc, jsEvent, ui, view) {
            updateEventStartEndDate(event);	
        },
        eventResizeStart: function(event, jsEvent, ui, view) {
            suspendTooltips = true;
        },
        eventResizeStop: function(event, jsEvent, ui, view) {
            suspendTooltips = false;
        },
        eventResize: function(event, dayDelta, minuteDelta, revertFunc, jsEvent, ui, view) {
            updateEventStartEndDate(event);
        },
        eventRender: function(event,element){
            // console.log(event,element);
            if(eventCountInfo[event.id]==null){eventCountInfo[event.id]=0;}
            else{eventCountInfo[event.id]=eventCountInfo[event.id]+1;}
            var $element = $j(element);
            var tagId = event.id+'-'+eventCountInfo[event.id];
            fieldId = tagId;
            $element.attr('id',tagId);
        },
        eventAfterAllRender:function(){
            $j('#campaign-counter').html(_.keys(eventCountInfo).length);
            var moment = $j('#blccCalendar').fullCalendar('getDate');
            $j('#filter-description').text(moment.format('MMM YYYY'));
            eventCount = 0;
            eventCountInfo={};
        },
        select: function(start, end, allDay) {
            var endMoment = moment(new Date(end.year(), end.month(), end.date(), 0, 0, 0, 0));
            endMoment.subtract(1,'days');
            if(!campaignsCreatable){ return; }
            var startStr = start.year()+'-'+(start.month()+1)+'-'+start.date();
            var endStr = endMoment.year()+'-'+(endMoment.month()+1)+'-'+endMoment.date();
            presentCampaignModal('new',{start:startStr, end:endStr});
            $j('.ui-dialog-content').mask('Loading...');
            $j('#blccCalendar').fullCalendar('unselect');
        },
        dayNames: [dayLabelArr[1],dayLabelArr[2],dayLabelArr[3],dayLabelArr[4],dayLabelArr[5],dayLabelArr[6],dayLabelArr[7]]
    });

}

/**
 * Initialize extra calendar handlers.
 */
function blccInitHandlers() {
    // hover intent  
    var config = {   
        interval: 850,
        over: function(){ 
            if(suspendTooltips){return;}
            var campaignId = $j(this).parents('.fc-event').attr('id').split('-')[0];
            var domId = $j(this).attr('id',campaignId+'-title').attr('id');
            hideAllLookupHoverPreviews(domId);
            LookupHoverDetail.getHover(domId, '/'+campaignId+'/m?retURL=/'+campaignId+'&isAjaxRequest=1').show();
                
        }, // function = onMouseOver callback (REQUIRED)    
        timeout: 0, // number = milliseconds delay before onMouseOut    
        out: function(){
            var campaignId = $j(this).parents('.fc-event').attr('id').split('-')[0];
            var domId = $j(this).attr('id',campaignId+'-title').attr('id');
            LookupHoverDetail.getHover(domId, '/'+campaignId+'/m?retURL=/'+campaignId+'&isAjaxRequest=1').hide();
        } // function = onMouseOut callback (REQUIRED)    
        ,
        selector: '.fc-title'
    };

    $j('#blccCalendar').hoverIntent(config);    
}

function getIsIE()
{
    return (/Trident\/7\./).test(navigator.userAgent) ? true : false
}

function saveContent(fileContents, fileName)
{
    link = document.createElement('a');
    link.download = fileName;
    link.href = 'data:,' + fileContents;
    link.click();
}

/**
 * Update the calendar heading.
 */
function updateCalendarHeading() {
    // var myDate = $j('#blccCalendar').fullCalendar('getDate');
    // $j('.pageDescription').html($j.fullCalendar.formatDate(myDate, 'MMMM yyyy'));
}

/**
 * Reload the campaign data.
 */
function updateCalendar(filterId) {
    blccFilterId = filterId;
	$j('#blccCalendar').mask(loadText);
	$j('#blccCalendar').removeClass('loadmask-warning');
	$j("#blccCalendar").fullCalendar("refetchEvents")
}

/**
 * Call out to Salesforce-based web service to update a single
 * event's start and stop dates.
 */ 
function updateEventStartEndDate(event) {
	var startDate = event.start.year()+"-"+event.start.month()+"-"+event.start.date();
    var endDate = startDate;
    if(event.end!=null){
        var endMoment = moment(event.end).subtract(1,'days');
        endDate=endMoment.year()+"-"+endMoment.month()+"-"+endMoment.date()
    }
    var result;
    // hit the @RemoteAction to update the event
    CAMPAIGNCAL.ccMonthViewController.updateCampaignStartEndDate(event.id,startDate,endDate, function(e,result){
        if(result.status){
            //Update allEvents for ics
            $j.each(allEvents,function(index,campaign){
                if(campaign.id===event.id){
                    var startDateArr = startDate.split('-');
                    campaign.start = moment(new Date(startDateArr[0], startDateArr[1], startDateArr[2], 0, 0, 0, 0));
                    var endDateArr = endDate.split('-');
                    campaign.end = moment(new Date(endDateArr[0], endDateArr[1], endDateArr[2], 0, 0, 0, 0)).add(1,'days');
                }
            });
        }
    	/* 
    	 *	Error handling 
    	 */
    	else{
		    //revertFunc();
			//errorArray.push(result);
			//$j("#blccCalendar").fullCalendar("refetchEvents");
			// regex=/first\serror\:.*/;
			// parsedMsg=result.message;
			// if(result.message.match(regex)[0]!=null){
			// 	parsedMsg=parsedMsg.match(regex)[0].replace('first error:','');
			// }
    		// showMaskMessage(parsedMsg+'&nbsp;&nbsp;<input class="btn" onclick="updateCalendar($j(\'.campaignCalendarViewSelect option:selected\').val())" value="Dismiss" style="width:100px; text-align: center;">', '#blccCalendar', 'loadmask-top loadmask-error', 0);	
            handleError(result.message,true);
    	}
    });
}

/**
 * Update a user's chatter status.
 * Update to @RemoteAction, Jordan 2/7/2012
 */
function updateChatterStatus() {
	CAMPAIGNCAL.ccMonthViewController.updateChatterStatus($j('#campaignCalendarPublisherField').val(),function(e,result){
		if(result.status == true){
			var statusField = $j('#campaignCalendarPublisherField');
		    statusField.val('');
    		statusField.blur();
		    showMaskMessage('Your chatter status has been updated.', 'body', 'loadmask-top loadmask-warning', 2500);
		}
		else{
			errorArray.push(result);
			showMaskMessage('The Chatter status update failed, please ensure you are logged in and connected to the Internet.</br></br> Would you like to send an error report to Bracket Labs?</br></br><input class="btn" onclick="$j(\'.bracketLabsFeedbackButton\').click();" value="Report An Error" style="width:100px; text-align: center;"/>&nbsp;&nbsp;<input class="btn" onclick="$j(\'#blccCalendar\').unmask();" value="Dismiss" style="width:100px; text-align: center;">', '#blccCalendar', 'loadmask-top loadmask-error', 0);	
		}
	});    
}

/**
 * Display a warning or error message to the user.
 */
function showMaskMessage(text, element, classNames, timeout) {
    $j(element).addClass(classNames);
    $j(element).mask(text);
    if (timeout > 0) {
        setTimeout(function() {
            $j(element).unmask();
            $j(element).removeClass(classNames);
        }, timeout);
    }
}

// function createColorLegend(){
// 	$j('#colorSettingsButton').qtip({
// 		content: {
// 			title: {
// 				text: 'Color Legend - '+$j('#active-color-field').val()
// 			},
// 			text: $j('#color-appendix').clone()
// 		},
// 		position: {
// 			my: 'right middle',
// 			at: 'left middle'
// 		},
// 		style: {
// 	    	classes: 'ui-tooltip-light ui-tooltip-shadow'
// 	  	}
// 	});
// }

(function($){
 $.fn.extend({
 
 	customSelect : function(options) {
	  // if(!$.browser.msie || ($.browser.msie&&$.browser.version>6)){
	  return this.each(function() {
	  
			var currentSelected = $(this).find(':selected');
			var html = currentSelected.html();
			if(!html){ html='&nbsp;'; }
			$(this).after('<span class="customStyleSelectBox"><span class="customStyleSelectBoxInner">'+html+'</span></span>').css({position:'absolute', opacity:0,fontSize:$(this).next().css('font-size')});
			var selectBoxSpan = $(this).next();
			var selectBoxWidth = parseInt($(this).width()) - parseInt(selectBoxSpan.css('padding-left')) -parseInt(selectBoxSpan.css('padding-right'));			
			var selectBoxSpanInner = selectBoxSpan.find(':first-child');
			selectBoxSpan.css({display:'inline-block'});
			selectBoxSpanInner.css({width:selectBoxWidth, display:'inline-block'});
			var selectBoxHeight = parseInt(selectBoxSpan.height()) + parseInt(selectBoxSpan.css('padding-top')) + parseInt(selectBoxSpan.css('padding-bottom'));
			$(this).height(selectBoxHeight).change(function(){
				// selectBoxSpanInner.text($(this).val()).parent().addClass('changed');   This was not ideal
			selectBoxSpanInner.text($(this).find(':selected').text()).parent().addClass('changed');
				// Thanks to Juarez Filho & PaddyMurphy
			});
			
	  });
	  //}
	}
 });
})(jQuery);

function wbr(str, num) {  
  return str.replace(RegExp("(\\w{" + num + "})(\\w)", "g"), function(all,text,char){
    return text + "&#8203;" + char;
  });
}

function presentICS(){
    var startDate = $j('#blccCalendar').fullCalendar('getView')['start'];
    var endDate = $j('#blccCalendar').fullCalendar('getView')['end'];

    var icsData = [];
    var clonedEvents = _.cloneDeep(allEvents);
    /*$j.each(clonedEvents,function(index,campaign){
        if(campaign.start._d >= startDate._d && campaign.start._d <= endDate._d){
            campaign.start=campaign.start._d;
            campaign.end=campaign.end._d;
            icsData.push(campaign);
        } else if(campaign.end._d >= startDate._d && campaign.end._d <= endDate._d){
            campaign.start=campaign.start._d;
            campaign.end=campaign.end._d;
            icsData.push(campaign);
        } else if(campaign.start._d <= startDate._d && campaign.end._d >=endDate._d){
            campaign.start=campaign.start._d;
            campaign.end=campaign.end._d;
            icsData.push(campaign);
        }
    });*/
    $j.each(clonedEvents,function(index,campaign){
        // var endDate = moment(campaign.end).subtract(1,'days')._d;
        if(campaign.start._d >= startDate._d && campaign.start._d <= endDate._d){
            campaign.start=campaign.start._d;
            //Since we have incremented the end date for displaying in the new full calendar we need to decrement it
            campaign.end=moment(campaign.end).subtract(1,'days')._d;
            icsData.push(campaign);
        } else if(campaign.end._d >= startDate._d && campaign.end._d <= endDate._d){
            campaign.start=campaign.start._d;
            //Since we have incremented the end date for displaying in the new full calendar we need to decrement it
            campaign.end=moment(campaign.end).subtract(1,'days')._d;
            icsData.push(campaign);
        } else if(campaign.start._d <= startDate._d && campaign.end._d >=endDate._d){
            campaign.start=campaign.start._d;
            //Since we have incremented the end date for displaying in the new full calendar we need to decrement it
            campaign.end=moment(campaign.end).subtract(1,'days')._d;
            icsData.push(campaign);
        }
    });

    //IE conditional for datauri
    if(getIsIE()){
       var blob = new Blob([generateICSString(icsData)]);
        window.navigator.msSaveOrOpenBlob(blob, 'Calendar.ics');
    } else{
        window.open( "data:text/calendar;charset=utf8," + escape(generateICSString(icsData)));
    }
}

function presentColorPickerModal(){
    $j('#campaign-frame').prop('src', colorSettingsPage);
    $j('#campaign-modal').modal('show');
}

var headerControls = (function(){
    var currentListViewId = $j.cookie('apex__blccFilterId');
    var datepicker = null;
    var attachEventListeners = function(){
        $j('#cc-header').on('click',function(e){
            var $target = $j(e.target);
            // console.log(e);
            if(e.type=='click'){
                if($target.hasClass('list-view-dropdown-option')){
                    var listViewId = $target.attr('id');
                    headerControls.listViewControls.setCurrentListView(listViewId);
                } else if($target.hasClass('navigate-to-page')){
                    if($target.attr('page-to-nav-to')=='planview'){
                        $j.cookie('apex__blccView', 'planningView', {expires:365});
                        window.location.href = planningViewURL;
                    } else if($target.attr('page-to-nav-to')=='monthview'){
                        $j.cookie('apex__blccView', 'monthView', {expires:365});
                        window.location.href = monthViewURL;
                    }
                } else if($target.hasClass('previousIncrement')){
                    if(currentPage == 'month'){
                        $j('#blccCalendar').fullCalendar('prev');
                        updateCalendarHeading();
                        hideAllLookupHoverPreviews();
                    }
                } else if($target.hasClass('nextIncrement')){
                    if(currentPage == 'month'){
                        $j('#blccCalendar').fullCalendar('next');
                        updateCalendarHeading();
                        hideAllLookupHoverPreviews();
                    }
                } else if($target.hasClass('incrementToToday')){
                    if(currentPage == 'month'){
                        $j('#blccCalendar').fullCalendar('today');
                        updateCalendarHeading();
                        hideAllLookupHoverPreviews();
                    }
                } else if($target.hasClass('currentIncrementSelect')){
                    datepicker.editable('show');
                } else if($target.hasClass('printBtn')){
                    var myDate = $j('#blccCalendar').fullCalendar('getDate');
                    var myDateString = myDate.format('MMMM YYYY');
                    var querystring = new Array();
                    querystring = myDateString.split(' ');
                    var url = calendarPage + '?pCalMonth=' + querystring[0] + '&pCalYear=' + querystring[1] + '&filterId=' + blccFilterId;
                    var printWindow = window.open(url,'','scrollbars=1,status=0,width=1000,height=900'); 
                } else if($target.hasClass('icsDownloadButton') || ($target.hasClass('ics') && $target.hasClass('toolbarHeaderIcon')) ){
                    presentICS();
                } else if($target.hasClass('colorSettingsButton') || $target.parents('.colorSettingsButton').length >0){
                    presentColorPickerModal();
                } else if($target.hasClass('newCampaignButton') || $target.parents('.newCampaignButton').length >0){
                    presentCampaignModal('new');
                }
            } 
        });
    };
    return{
        listViewControls : {
            init: function(){
                //Update the toggle to the current list view
                $j('#list-view-dropdown-toggle-text').html(this.getCurrentListView().label);
                var ulContainer = $j('#list-view-dropdown-container .dropdown-menu');
                ulContainer.empty();
                var frag = document.createDocumentFragment();
                _.forEach(listViewOptions,function(listViewOption){
                    var li = document.createElement("li");
                    var a = document.createElement("a");
                    a.className = 'list-view-dropdown-option pointer';
                    a.innerHTML = listViewOption.label;
                    a.id = listViewOption.id;
                    li.setAttribute('role','presentation');
                    li.appendChild(a);
                    frag.appendChild(li);
                });
                ulContainer[0].appendChild(frag);
                $j('#list-view-dropdown-menu').dropdown();
                $j('#list-view-info-icon').popover();
            },
            getCurrentListView: function(){
                var currentListViewInfo = _.filter(listViewOptions,function(listViewOption){
                    if(currentListViewId == null && listViewOption.id == ''){return true;}
                    else if(currentListViewId == listViewOption.id){ return true; }
                    return false;
                })[0];
                if(currentListViewInfo){
                    return currentListViewInfo;
                } else{
                    return listViewOptions[0];
                }
                
            },
            setCurrentListView: function(listViewId){
                $j.cookie('apex__blccFilterId', listViewId, {expires:365});
                currentListViewId = listViewId;
                $j('#list-view-dropdown-toggle-text').html(this.getCurrentListView().label);
                updateCalendar(this.getCurrentListView().id);
            }
        },
        initHeader: function(){
            this.listViewControls.init();
            datepicker = $j('span.currentIncrementSelect');
            datepicker.editable(
                {
                    type:'date', 
                    container: '.campaignCalendarMonthView',
                    url: function(params){
                        var valArr = params.value.split('-');
                        var year=valArr[0];
                        var month=valArr[1];
                        var date = valArr[2];
                        var dateObj = new Date(year, month-1, date);
                        $j('#blccCalendar').fullCalendar( 'gotoDate', dateObj );
                    },
                    savenochange: true,
                    placement: 'auto',
                    display: false,
                    datepicker: {minViewMode: 'months'}
                });
            datepicker.on('shown',function(e,editable){
                if(arguments.length == 2){
                    $j('.editable-popup i.icon-arrow-right').addClass('glyphicon glyphicon-arrow-right').removeClass('icon-arrow-right');
                    $j('.editable-popup i.icon-arrow-left').addClass('glyphicon glyphicon-arrow-left').removeClass('icon-arrow-left');
                }
            });
            $j('.colorSettingsButton').popover(
                {
                    html: true,
                    content: function(){
                        // return 'wat';
                        return $j('#color-appendix').clone().html();
                    },
                    placement:'bottom',
                    trigger: 'hover',
                    title: function(){
                        return $j('#legend-source-string').text()+' - '+ $j('#active-color-field-string').text();
                    }
                }
            );
            attachEventListeners();
        }
    }
})();

var lazyLayout = _.debounce(refreshCalendarHeight, 500);

$j(window).on('resize', lazyLayout);

function refreshCalendarHeight(){
    //var spacer=($j('#AppBodyHeader:visible').height()+$j('.bPageFooter').height()+$j('#taskboard-header').height());
    var windowHeight = $j(window).height();
    var spacer=($j('#AppBodyHeader:visible').height()+$j('.bPageFooter:visible').height()+$j('#task-board-header').height()+$j('#globalHeaderBar').height());
    var padding = ($j('#AppBodyHeader').is(':visible')) ? 80 : 16;
    
    var toolbarHeight = $j('#cc-header').height();
    
    var heightForCal = windowHeight-toolbarHeight-spacer-padding;
    $j('#blccCalendar').fullCalendar('option', 'height', heightForCal);

}

function presentCampaignModal(campaignId, newOptions){
    var campaignPageURL = '';
    if(campaignId == 'new'){
        campaignPageURL = campaignNewPage;
        if(newOptions){
            campaignPageURL = (campaignPageURL.indexOf('?') === -1) ? campaignPageURL+ '?startDate=' + newOptions.start + '&endDate=' + newOptions.end : campaignPageURL+ '&startDate=' + newOptions.start + '&endDate=' + newOptions.end;
        }
    } else{
        campaignPageURL = (campaignEditPage.indexOf('?') === -1) ? campaignEditPage+'?Id='+campaignId : campaignEditPage+'&Id='+campaignId;
    }
    $j('#campaign-frame').prop('src', campaignPageURL);
    $j('#campaign-modal').modal('show');
}

var inlineEditsFromModal = false;
function attachModalMethods(){
    /*Modal Methods*/
    $j('body').on('show.bs.modal','.modal', function(e) {
        //Kludge for OSX 10.7+ Bug with scrollbars having a higher z-index than the modals
        // $j('.task-column .sortable-list').css('overflow-y','hidden');
        // $j('#task-board-viewport').css('overflow-x','hidden');
        var modal = $j(this);
        var modalContent = $j(this).find('.modal-content');
        var modalDialog = $j(this).find('.modal-dialog');
        //If the modal is too tall, resize it
        if($j(modalDialog).height()>=$j(window).height()){
            $j(modalDialog).height($j(window).height()-20);
        }
        //If the modal is too wide, resize it
        if($j(modalDialog).width()>=$j(window).width()){
            $j(modalDialog).width($j(window).width()-20);
        }
        //Vertically center the modal
        var minHeight = ($j(modalDialog).height() == 0) ? 200 : $j(modalDialog).height();
        $j(modalDialog).css('margin-top',($j(window).height()-minHeight)/2+'px');

        var iframe = $j(this).find('iframe');
        if(iframe.length>0 && !$j(this).hasClass('help-modal')){
            var frameDoc = iframe[0].contentDocument || iframe[0].contentWindow.document;
            try{
                frameDoc.removeChild(frameDoc.documentElement);
            } catch(e){

            }
        }

        return this;
    });
    
    $j('.modal').on('hide.bs.modal',function(e){
        if(inlineEditsFromModal && $j(this).is(':visible')){ 
            var modal = this;
            bootbox.setDefaults({container:'.cc-bs'});
            bootbox.dialog({
                message: 'Are you sure you want to close? Edits are pending.',
                title: 'Edits Pending',
                buttons: {
                    cancel: {
                        label: 'Cancel',
                        className: "btn-default",
                        callback: function() {
                            $j(this).modal('hide');
                        }
                    },
                    danger: {
                        label: 'Ok',
                        className: "btn-warning",
                        callback: function() {
                            inlineEditsFromModal=false;$j(modal).modal('hide'); 
                        }
                    }
                }
            });

            return false; 
        }

    });

    $j('.modal').on('hidden.bs.modal',function(e){
        // if(this.id == 'project-modal'){ chatterGroupIds = null; }
        inlineEditsFromModal=false;
        //Empty all of the input boxes
        $j(this).find('input').val('');
    });
}

function hideAllLookupHoverPreviews(doNotHideThisId){
    if(LookupHoverDetail.hovers){
        _.forEach(LookupHoverDetail.hovers,function(hoverDetail){
            if(doNotHideThisId && hoverDetail.id == doNotHideThisId){
                //Don't hide this fellow
            } else{
                hoverDetail.hide();
            }
        });
    }
}

function handleError(error,fadeOut){
    var parsedMsg=error.replace(/.*First\sexception.*first\serror\:\s\w*,/,'').replace(': []','');
    if(parsedMsg.indexOf('Unable to connect to the server') !== -1){return ;}
    if(parsedMsg.indexOf('Error parsing json response') !== -1 && parsedMsg.indexOf('Logged in?') !== -1){window.location.reload();return;}
    if(parsedMsg.indexOf('Remoting request invalid for your session. Refresh page and re-submit request') !== -1){window.location.reload();return;}
    var errorMsg=$j('<div class="alert alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><span></span></div>');
    $j(errorMsg).children('span').text(parsedMsg);
    $j('.blcc_alert').append(errorMsg);
    if(fadeOut){
        setTimeout(function(){errorMsg.fadeOut(300, function() { $j(this).remove(); });},10000);
    }
}
