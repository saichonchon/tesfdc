/**
 * Planning View for Campaign Calendar by Bracket Labs
 * Copyright (c) 2011 Bracket Labs - bracketlabs.com
 * Ken Hua 
 * 06/21/2011 - Modified list view
 * 07/05/2011 - Date block functionality completed
 * 07/06/2011 - Date blocks now obey the CC color settings. Changed to work with outputLinks and actionFunctions from the List page. 
 *				This allows specific parts of the page to load decreasing load times. Year manipulation is now local to this resource
 *				in order to avoid a distributed issue.
 * 07/07/2011 - The campaign description is now displayed in an expandable row for each campaign.
 * 07/08/2011 - Clickable name and date blocks for each campaign.
 * Erty Seidel  
 * 07/05/2011 - Changed to render view using tables with nested divs instead of straight divs
 * 
 * Jordan Baucke
 * 10/28/2011 - Optimize to the javascript, load *all* campaign data in a single request to the server and than render
 * 				the arrays seperately for each year (speeds up page response)
 * 				-Show/hide dates checkbox functionality improved, removed animations (overloaded browser on large page) -
 * 				-Set custom setting for 'show/hide date' checkbox value so it is now saved in the user database
 * 				-Added partial refresh to the page
 * 				-Loading masks, and hover intent on the 'date' text when it is deactiviated. 
 * 				-See various github commits and notes - Winter '12 hotfix, and patches as well as some MSIE bugs fixed.
 * 		
 */
if (typeof console === "undefined"){ console={}; console.log = function(){ return; }; console.time = function(){return;}; console.timeEnd = function(){return;}; }
var data = {};
var persistedData={};
var planningViewTable_year;
var planningViewPage = true;
var maskFlag = false;
var unselected = false;
var faultFlag = false;
var pageMessage = '';
var errorArray = [];	//array for storing error messages from the server
var currentPlanningView='year';
var currentYear='0';
var currentDate=new Date();
var currentMonth=currentDate.getMonth()+1;
var planningViewMonth = currentDate.getMonth(); 
var showHierarchy=false;

$j = jQuery.noConflict();

$j('document').ready(function(){
	$j('.pageTitleIcon').removeAttr('height');
	$j('.pageTitleIcon').removeAttr('width');
	headerControls.initHeader();
	//bug fix for webkit
	// $j('.campaignCalendarViewSelect').width($j('.customStyleSelectBox').outerWidth());
	// $j('.campaignCalendarViewSelect').height($j('.customStyleSelectBox').outerHeight());
	if($j.cookie('blcc_showHierarchy')=='true'){
		showHierarchy=true;
		$j('#showHierarchy').attr('checked','checked');
	}
	attachPageClickHandlers();
	attachModalMethods();
	$j('.pageTitleIcon').attr('src',campaignCalendarIcon);
	loadDataTable();
	createColorLegend();
	$j('[data-toggle="tooltip"]').tooltip();
});

function loadDataTable(){
	if ((blccFilterId == null || blccFilterId == '') && $j('#filterId').val() =='') {
		// No list view selected
		showMaskMessage('Please select a list view above', '#planningView', 'loadmask-warning', 0);
	}
	else {
		//Optimization for the scroll function
		loadAndRenderCampaignData('Loading...');
	}
}

//Keep the table head at the top of the page when the user scrolls down
$j(window).scroll(function(){
	if(!isPrintView){
		var planningViewTable_year = $j('#planningViewTable_year');
		var planningViewTable_quarter = $j('#planningViewTable_quarter');
		var planningViewTable_month = $j('#planningViewTable_month');
		if($j(window).scrollTop() > planningViewTable_year.offset().top || $j(window).scrollTop() > planningViewTable_quarter.offset().top || $j(window).scrollTop() > planningViewTable_month.offset().top){
			planningViewTable_year.children('thead').addClass('planningViewTable_yearTheadFixed');
			planningViewTable_quarter.children('thead').addClass('planningViewTable_quarterTheadFixed');
			planningViewTable_month.children('thead').addClass('planningViewTable_monthTheadFixed');
		} else{
			planningViewTable_year.children('thead').removeClass('planningViewTable_yearTheadFixed');
			planningViewTable_quarter.children('thead').removeClass('planningViewTable_quarterTheadFixed');
			planningViewTable_month.children('thead').removeClass('planningViewTable_monthTheadFixed');
		}
	}
});

/*
 * loadAndRenderCampaignData()
 * 
 * Loads campaign data from the server (and renders it to the page.
 * 
 * Used on pageload, list view change, campaigns being added, or other items being changed.
 * 
 */
 var inflight=null;
function loadAndRenderCampaignData(message){

	data = {}; //reset data array
	$j('.planningViewData').html('');	//clear the datatable
	$j('#planningView').removeClass('loadmask-warning');
	$j('#planningView').removeClass('loadmask-error');
	$j('#planningView').mask(message);
	$j('.loadmask-msg').addClass('initial-load-msg');

	if(inflight!=null){clearTimeout(inflight);}
	inflight=setTimeout("getDataAndRenderMasked()",250);
	
}

function getDataAndRenderMasked(){
	getPlanningViewData(function(maxFlag){
		if(maxFlag)	{
			// showMaskMessage('Some '+campaignsPlural+' may be not be shown.<br />Please select a list view that contains less than 4,000 '+campaignsPlural+'. You may also try adding a date constraint to the list view filter.', '#planningView', 'loadmask-warning', 5000);
			handleError('Some '+campaignsPlural+' may be not be shown. Please select a list view that contains less than 4,000 '+campaignsPlural+'. You may also try adding a date constraint to the list view filter.',true);
		}
		//if (data.hasOwnProperty(currentYear)) {
			renderPlanningView(function(){
				if(isPrintView){printViewBGToBorders(); }
				var selYear = $j('#year').text();
				if(isPrintView){selYear=printCurrentYear;}
				var campaignsInYear = (data.hasOwnProperty(selYear)) ? data[selYear].length.toString() : '0';
				var campaignsInView=campaignsInYear;
				if(currentPlanningView=='year'){
					if(isPrintView){
						$j('.pageDescription').html(selYear +' - '+ campaignsInView + ' '+campaignsPlural); //update the page header
					} else{
						$j('#filter-description').html(selYear);
						$j('#campaign-counter').html(campaignsInView);
					}
				}	
				else if(currentPlanningView=='quarter'){
					campaignsInView=0;
					$j.each(data,function(key,arr){campaignsInView=campaignsInView+arr.length;});
					if(isPrintView){
						$j('.pageDescription').html(getMonthLabel(currentMonth) +' - '+ getMonthLabel(currentMonth+2) +' - '+ campaignsInView + ' '+campaignsPlural); //update the page header
					} else{
						$j('#filter-description').html(getMonthLabel(currentMonth) +' - '+ getMonthLabel(currentMonth+2));
						$j('#campaign-counter').html(campaignsInView);
					}
				}
				else if(currentPlanningView=='month'){
					campaignsInView=0;
					$j.each(data,function(key,arr){campaignsInView=campaignsInView+arr.length;});
					if(isPrintView){
						$j('.pageDescription').html(getMonthLabel(currentMonth) +' - '+ campaignsInView + ' '+campaignsPlural); //update the page header
					} else{
						$j('#filter-description').html(getMonthLabel(currentMonth));
						$j('#campaign-counter').html(campaignsInView);	
					}
				}
				if (!maxFlag) {
					$j('#planningView').unmask();
				}
				maxFlag = false; //reset the flag for next-time we try to reload the listview (;
				if(campaignsInView==0){showMaskMessage('The current list view contains no '+campaignsPlural+' that begin or end during the selected date range. Please select a different list view or change the date range.', '#planningView', 'loadmask-warning', 0);}
			});
		/*}
		else{
			showMaskMessage('The current list view contains no '+campaignsPlural+' that begin or end during the current year.<br /> Please select a different list view or year.', '#planningView', 'loadmask-warning', 0);
		}*/
	});
}

/*
 * renderView();
 * 
 * Renders the view without reloading campaign data from the server - (used from changing years)
 */
function renderView(){
	var campaignsInYear = (data.hasOwnProperty(currentYear)) ? data[currentYear].length.toString() : '0';
	$j('.pageDescription').html( currentYear +' - '+ campaignsInYear + ' Campaigns'); //update the page header
	$j('#planningView').removeClass('loadmask-warning');
	$j('#planningView').removeClass('loadmask-error');
	$j('.planningViewData').html(''); //clear the datatable
	$j('#planningView').mask('Loading...');
	setTimeout("renderViewMasked()",250);
}

function renderViewMasked(){
		//the data array has some campaigns in this year so render the view
	if (data.hasOwnProperty(currentYear)) {
		renderPlanningView(function(){
			$j('#planningView').unmask();
		});
	}
	else {
		showMaskMessage('The current list view contains no campaigns that begin or end during ' + $j('#year').text() + '. Please select a different list view or year.', '#planningView', 'loadmask-warning', 0);
	}
}

/*
 * Adds a slight delay to the loadAndRenderCampaign function to allow for the dialog box to close
 * before reloading the data
 * 
 * This function is defined here so as to set the scope correctly when the function is setTimeout
 * because otherwise the parent.____ wouldn't work with setTimeout in the dialog, Jordan, 10/24/11
 */
function loadAndRenderWithDelay(message)
{
	pageMessage = message;
	setTimeout("loadAndRenderCampaignData(pageMessage);",250);
}

function getPlanningViewData(callback){
	var maxFlag = false;
	var results = [];
	currentYear = parseInt($j('#year').text());
	var currentFilterId = headerControls.listViewControls.getCurrentListView().id;
	if(isPrintView){currentFilterId=printCurrentFilterId;currentYear=printCurrentYear;currentMonth=printCurrentMonth;currentPlanningView=printCurrentPlanningView;}
	if(currentFilterId == ''){
		showMaskMessage('Please select a list view above', '#planningView', 'loadmask-warning', 0);	
	}
	else{
		CAMPAIGNCAL.ccPlanningViewController.getCampaignsPV1(currentFilterId,currentYear.toString(), function(event, result){
	            if(result.status == true){
					var events = [];
					$j.each(result.result, function(i, event){
						events.push({
							id: event.id,
							name: event.name,
							startSortDate: new Date(event.startYear, event.startMonth-1, event.startDay),
							endSortDate: new Date(event.endYear, event.endMonth-1, event.endDay),
							startDate: event.startDate,
							endDate: event.endDate,
							startYear: event.startYear,
							startMonth: event.startMonth,
							startDay: event.startDay,
							endYear: event.endYear,
							endMonth: event.endMonth,
							endDay: event.endDay,
							textColor: event.textColor,
							backgroundColor: event.color,
							borderColor: event.borderColor,
							type: event.campaignType,
							description: event.description,
                            endLocaleDate: event.endLocaleDate,
                            startLocaleDate: event.startLocaleDate,
                            parentId: event.parentId,
                            ownerName: event.ownerName,
                            ownerEmail: event.ownerEmail
						});
					});
					events.sort(function(a, b){
						var dateAStart = new Date(a.startSortDate), dateBStart = new Date(b.startSortDate);
						var dateAEnd = new Date(a.endSortDate), dateBEnd = new Date(b.endSortDate);
						if(dateAStart>dateBStart){return 1;}
						else if(dateAStart<dateBStart){return -1;}
						
						if(dateAEnd>=dateBEnd){return 1;}
						else if(dateAEnd<dateBEnd){return -1;}
						
						if(a.name>=b.name){return 1;}
						else if(a.name<b.name){return -1;}

						return 0;
					});
					data={};
					//organize the campaigns by year
					if(currentPlanningView=='year'){
						$j.each(events, function(i, event){
						if(event.startyear != event.endYear)
						{
							var i = parseInt(event.startYear);
							for(i; i <= parseInt(event.endYear); i++)
							{
								addCampaignToArray(event,i);
							}
						}
						else{
							addCampaignToArray(event,event.startYear);
							}		
						});
					}
					else if(currentPlanningView=='quarter'){
						$j.each(events, function(i, event){
							rangeStart=new Date(currentYear, currentMonth-1, 1);
							rangeEnd=new Date(currentYear, currentMonth+2, 0);
							testDateStart=new Date(event.startYear, event.startMonth-1, event.startDay);
							testDateEnd=new Date(event.endYear, event.endMonth-1, event.endDay);
							/*if(event.name=='last two years'){
								console.log(rangeStart);
								console.log(rangeEnd);
								console.log(testDateStart);
								console.log(testDateEnd);
								console.log(isWithinDateRange(rangeStart,rangeEnd,testDateStart,testDateEnd));
							}*/

							if(isWithinDateRange(rangeStart,rangeEnd,testDateStart,testDateEnd)){
								addCampaignToArray(event,event.startYear);
							}
							//console.log(data);
						});
					}
					else if(currentPlanningView=='month'){
						$j.each(events, function(i, event){
							rangeStart=new Date(currentYear, currentMonth-1, 1);
							rangeEnd=new Date(currentYear, currentMonth, 0);
							testDateStart=new Date(event.startYear, event.startMonth-1, event.startDay);
							testDateEnd=new Date(event.endYear, event.endMonth-1, event.endDay);
							/*console.log(rangeStart);
							console.log(rangeEnd);
							console.log(testDateStart);
							console.log(testDateEnd);*/
							if(isWithinDateRange(rangeStart,rangeEnd,testDateStart,testDateEnd)){
								addCampaignToArray(event,event.startYear);
							}
						});
					}
					
					if(events.length >= 4000){
						maxFlag = true;
					}
	
					callback(maxFlag);
	
				}
				else{
   		            $j('#planningView').unmask();
   		            handleError(result.message,false);
   		      //       var availableFilters=[];
   		      //       $j('.campaignCalendarViewSelect option').each(function(){
   		      //       	availableFilters.push($j(this).val());
   		      //       });
   		      //       var msgContainsFilter = (result.message.indexOf(currentFilterId)!==-1 || result.message.indexOf(currentFilterId.substr(0,14))!==-1) ? true:false;
   		      //       var selectContainsFilter = ($j.inArray(currentFilterId,availableFilters)!==-1) ? true:false;

		         //   	if(!msgContainsFilter && selectContainsFilter){
			        //    	errorArray.push(result);
			        //    	//This accounts for the failure on navigating away from the page when a remote action is inflight
			        //    	if(result.message!='Unable to connect to the server.')
			        //    	{
			        //    		showMaskMessage('An error occurred fetching information from the server.</br></br> Would you like to send an error report to Bracket Labs?</br></br><input class="btn" onclick="$j(\'.bracketLabsFeedbackButton\').click();" value="Report An Error" style="width:100px; text-align: center;"/>&nbsp;&nbsp;<input class="btn" onclick="$j(\'#planningView\').unmask();" value="Dismiss" style="width:100px; text-align: center;">', '#planningView', 'loadmask-top loadmask-error', 0);
			        //    	}
			        // }
	           }
		});
	}
}	

/*
 * addCampaignToArray()
 * 
 * Adds the campaign to the array based on the year target
 */
function addCampaignToArray(event,yearTarget)
{
	if (data.hasOwnProperty(yearTarget)) {
		data[yearTarget].push(event);
	}
	else {
		var array = [];
		array.push(event);
		data[yearTarget] = array; //add the year array to the object
	}	
}

/* 
 * renderPlanningView()
 * 
 * Takes an array of campaign data and renders HTML representing the planning view for that page
 * and appends it to the DOM
 * 
 */
function renderPlanningView(callback){
	/*
	 * Check the faultFlag if the data loader returned an error
	 */
	//$j('#planningViewTable_month').empty();
	$j('#planningViewTable_year tbody').empty();
	$j('#planningViewTable_quarter tbody').empty();
	$j('#planningViewTable_month tbody').empty();
	var childrenCampaigns=[];
	var selYear = $j('#year').text();
	if(isPrintView){selYear=printCurrentYear;}
	var temp = [];
	var tableContainer = $j('#planningViewTable_year .planningViewData');
	var displayDateClass = (displayDates) ? '' : 'hidden';
	$j('.planningViewTables').hide();
	if(currentPlanningView=='month'){ 
		//populate the monthly table
		var d= new Date(currentYear, currentMonth, 0);
    	maxDateInMonth=d.getDate();
    	var dateTds=[];
    	for (var i=1;i<=maxDateInMonth;i++)
		{
			dateTds.push('<th tdtype="calendar" year="'+currentYear+'" month="'+currentMonth+'" date="'+i+'">'+i+'</th>');
		}
		i=0;
		$j('#planningViewTable_month th[tdtype="calendar"]').each(function(){
			if(i!=0){$j(this).remove();}
			i++;
		});
		$j('#planningViewTable_month th[tdtype="calendar"]').replaceWith(dateTds.join(''));
		$j('#planningViewTable_month').show();
		var allRows=[];
		$j.each(data,function(key,value){
			$j.each(value,function(subkey,campaign){
				if(typeof campaign.parentId !=='undefined'  && showHierarchy){childrenCampaigns.push(campaign);return true;}
				row=generatePVRow_month(campaign,0);
				allRows.push(row);
			});
		});
		$j('#planningViewTable_month tbody').html(allRows.join(''));
	}
	else if(currentPlanningView=='quarter'){
	//console.log('is quarter');
		//set the month names in the thead
		var i=0;
		$j('#planningViewTable_quarter th').each(function(){
			if(i==0){$j(this).attr('tdtype','name');}
			if(i==1){
				$j(this).attr('tdtype','previous');
				monthInfo=getMonthInfo(currentMonth);
				$j(this).attr('month',monthInfo['month']);
				$j(this).attr('year',monthInfo['year']);
			}
			if(i==2){
				$j(this).text(getMonthLabel(currentMonth));
				monthInfo=getMonthInfo(currentMonth);
				$j(this).attr('tdtype','calendar');
				$j(this).attr('month',monthInfo['month']);
				$j(this).attr('year',monthInfo['year']);
			}
			else if(i==3){
				$j(this).text(getMonthLabel(currentMonth+1));
				monthInfo=getMonthInfo(currentMonth+1);
				$j(this).attr('tdtype','calendar');
				$j(this).attr('month',monthInfo['month']);
				$j(this).attr('year',monthInfo['year']);
			}
			else if(i==4){
				$j(this).text(getMonthLabel(currentMonth+2));
				monthInfo=getMonthInfo(currentMonth+2);
				$j(this).attr('tdtype','calendar');
				$j(this).attr('month',monthInfo['month']);
				$j(this).attr('year',monthInfo['year']);
			}
			else if(i==5){
				$j(this).attr('tdtype','next');
				monthInfo=getMonthInfo(currentMonth+2);
				$j(this).attr('month',monthInfo['month']);
				$j(this).attr('year',monthInfo['year']);
			}
			if(i==6){$j(this).attr('tdtype','description');}
			i++;
		});
		$j('#planningViewTable_quarter').show();
		var allRows=[];
		$j.each(data,function(key,value){
			$j.each(value,function(subkey,campaign){
				if(typeof campaign.parentId !=='undefined' && showHierarchy){childrenCampaigns.push(campaign);return true;}
				row=generatePVRow_quarter(campaign,0);
				allRows.push(row);
			});
		});
		$j('#planningViewTable_quarter tbody').html(allRows.join(''));
	}
	else if(currentPlanningView=='year'){
		var rowCounter=0;
		$j('#planningViewTable_year').show();
		if(data[selYear]!==undefined){
			for (var j = 0; j < data[selYear].length; j++) {
				if(typeof data[selYear][j] !=='undefined' && typeof data[selYear][j].parentId !=='undefined'  && showHierarchy){childrenCampaigns.push(data[selYear][j]);continue;}
				temp.push(generatePVRow_year(data[selYear][j],0));
				if((j % 25) == 0){
					tableContainer.append(temp.join(''));
					temp = []; //clear the array
				}
			}
			
			//append the data
			tableContainer.append(temp.join(''));
			temp = []; //clear the array
		}
	}
	
	//Add children as needed
	if(childrenCampaigns.length>0){
		populateChildrenCampaigns(currentPlanningView,childrenCampaigns,6);
		
	}

	//Campaign
	$j('#planningView').off('click').on('click', function(e){
		var $target = $j(e.target);
		var $td = $target.closest('td');
		var $row = $target.parents('tr.master');
		if($row.length > 0){
			var rowId = $row.attr('id');
			var campaignId = rowId.replace('row-','');
			if($td.is(':last-child')){
				presentDescriptionModal(campaignId);
			} else{
				presentCampaignModal(campaignId);
			}
		}
	})

	// hover intent	 
	var config = {   
	 interval: 175,
     over: function(){ 
     	var $row= $j(this).closest('tr');
		if(!displayDates){
			$row.children().find('.textDate, .inlineTextDate').removeClass('hidden');
		}	
		// console.log($j(this));
		var rowId = $row.attr('id');
		var campaignId = rowId.replace('row-','');
		var tempId = rowId.replace('row-','temp-');
		$row.find('.campaignBracket:last').attr('id',tempId);
		hideAllLookupHoverPreviews(tempId);
		LookupHoverDetail.getHover(tempId, '/'+campaignId+'/m?retURL=/'+campaignId+'&isAjaxRequest=1').show();
            
	 }, // function = onMouseOver callback (REQUIRED)    
     timeout: 0, // number = milliseconds delay before onMouseOut    
     out: function(){
     	var $row= $j(this).closest('tr');
		if(!displayDates){
			$row.children().find('.textDate, .inlineTextDate').addClass('hidden');
		}
		var rowId = $row.attr('id');
		var campaignId = rowId.replace('row-','');
		var tempId = rowId.replace('row-','temp-');
		$row.find('.campaignBracket:last').attr('id',tempId);
		LookupHoverDetail.getHover(tempId, '/'+campaignId+'/m?retURL=/'+campaignId+'&isAjaxRequest=1').hide();
	 } // function = onMouseOut callback (REQUIRED)    
	 ,
	 selector: '.campaignBracket'
	};
	 
	$j('#planningView').hoverIntent(config);
	
	callback();
}

function populateChildrenCampaigns(currentPlanningView,childrenCampaigns,loopCount){
	//console.log(childrenCampaigns);
	//Sort the campaigns by the start date
	childrenCampaigns.sort(function(a, b){
		var dateAStart = new Date(a.startSortDate), dateBStart = new Date(b.startSortDate);
		var dateAEnd = new Date(a.endSortDate), dateBEnd = new Date(b.endSortDate);

		if(dateAStart>dateBStart){return 1;}
		else if(dateAStart<dateBStart){return -1;}
		
		if(dateAEnd>=dateBEnd){return 1;}
		else if(dateAEnd<dateBEnd){return -1;}

		if(a.name>=b.name){return 1;}
		else if(a.name<b.name){return -1;}

		return 0;
	});
	
	//Find out if a campaign is an orphan, and add it
	var childrenCampaignIds=[];
	$j.each(childrenCampaigns,function(index,childCampaign){
		childrenCampaignIds.push(childCampaign.id);
	});
	var orphans=[];
	campaignIndicesToRemove=[];
	//Look for the currently displayed campaigns too
	var currentlyDisplayedCampaigns=[];
	$j('.planningViewData tr .name').each(function(){
		currentlyDisplayedCampaigns.push($j(this).attr('id'));
	});
	$j.each(childrenCampaigns,function(index,childCampaign){
		if(childCampaign!=undefined){
			//If the campaign's parent is not in the children Id's or currently displayed, it is an orphan
			if($j.inArray(childCampaign.parentId,childrenCampaignIds) ===-1 && $j.inArray(childCampaign.parentId,currentlyDisplayedCampaigns) ===-1){
				orphans.push(childCampaign);
				campaignIndicesToRemove.push(index);
			}	
		}
	});
	//Remove these so we do not try to place them again
	$j.each(campaignIndicesToRemove.reverse(),function(arrindex,remindex){
		childrenCampaigns.splice(remindex,1);
	});
	//Add these orphans to the dom. It's important this happens before the big loop so we can
	$j.each(orphans,function(index,childCampaign){
		if(childCampaign != undefined){
			var newRow='';
			if(currentPlanningView=='year'){
				newRow=generatePVRow_year(childCampaign,0);
			}
			else if(currentPlanningView=='quarter'){
				newRow=generatePVRow_quarter(childCampaign,0);
			}
			else if(currentPlanningView=='month'){
				newRow=generatePVRow_month(childCampaign,0);
			}
			childStartEpoch=childCampaign.startSortDate.getTime();
			var matchFound=false;
			$j('.planningViewData tr').each(function(rowindex,row){
				if($j(row).attr('childLevel')==0){
					if($j(row).attr('startDateEpoch')>=childStartEpoch){
						$j('#'+$j(row).attr('id')).before(newRow);
						//console.log(childCampaign.name+' inserted before '+$j(row).attr('id'));
						//console.log(childCampaign.name+': '+childStartEpoch+' should be before '+$j(row).children('.name').text()+': '+$j(row).attr('startDateEpoch'));
						matchFound=true;
						return false;
					}	
				}
			});
			if(matchFound==false){
				$j('#planningViewTable_'+currentPlanningView).append(newRow);
				//$j('.planningViewData').append(newRow);
			}
		}
	});

	//Now that we have placed the orphans we can loop through the last remaining children to place them in the hierarchy. 
	//We have to do the multiple loops to ensure everything gets placed.
	childCount={};
	for (var i=0;i<loopCount && childrenCampaigns.length!=0;i++){
		var currentlyDisplayedCampaigns=[];
		$j('.planningViewData tr .name').each(function(){
			currentlyDisplayedCampaigns.push($j(this).attr('id'));
		});
		//console.log(currentlyDisplayedCampaigns);
		campaignIndicesToRemove=[];
		$j.each(childrenCampaigns,function(index,childCampaign){
			//console.log(childCampaign);
			if(childCampaign!==undefined){
				if($j.inArray(childCampaign.parentId,currentlyDisplayedCampaigns) !== -1){
					//console.log('match found for '+childCampaign.id+' with parent '+childCampaign.parentId);
					//get the parent child level
					if(childCount[childCampaign.parentId]==undefined){childCount[childCampaign.parentId]=1;}
					else{childCount[childCampaign.parentId]=childCount[childCampaign.parentId]+1;}
					var childLevel=parseInt($j('#'+childCampaign.parentId).attr('childLevel'))+1;
					//Add the child campaign below the parent
					var newRow='';
					if(currentPlanningView=='year'){
						newRow=generatePVRow_year(childCampaign,childLevel);
					}
					else if(currentPlanningView=='quarter'){
						newRow=generatePVRow_quarter(childCampaign,childLevel);
					}
					else if(currentPlanningView=='month'){
						newRow=generatePVRow_month(childCampaign,childLevel);
					}
					
					//console.log(childCampaign.name+' : '+childCount[childCampaign.parentId]+' : '+childCampaign.parentId );
					if(childCount[childCampaign.parentId]==1){$j('#row-'+childCampaign.parentId).after(newRow);}
					else{
						//Insert after the last tr with the same parent id. we have already sorted the campaigns appropriately prior to the loop.
						$j('.planningViewData tr[parentid='+childCampaign.parentId+']:last').after(newRow);
					}
					//remove the child campaign from the childrenCampaigns array
					campaignIndicesToRemove.push(index);
				}
				else{
					/*console.log('has no parent atm');
					console.log(childCampaign);*/
				}
			}
		});
		$j.each(campaignIndicesToRemove.reverse(),function(index,indextodel){
			childrenCampaigns.splice(indextodel,1);
		})
	}

}

var rowCounter=0;
function generatePVRow_year(campaign,childLevel){
	var selYear = $j('#year').text();
	if(isPrintView){selYear=printCurrentYear;}
	var displayDateClass = (displayDates) ? '' : 'hidden';
	var rowReturned='';
	var startDate = campaign.startDate;
	startDate = startDate.split(" ");
	startDate = startDate[0];
            
	var endDate = campaign.endDate;
	endDate = endDate.split(" ");
	endDate = endDate[0];
            
	var startMonth = campaign.startMonth;
	var endMonth = campaign.endMonth;
	var startYear = campaign.startYear;
	var endYear = campaign.endYear;
	var startDay = campaign.startDay;
	var endDay = campaign.endDay;
	
    startDate=campaign.startLocaleDate;
    endDate=campaign.endLocaleDate;
    var startDateEpoch = new Date(startYear, startMonth-1, startDay).getTime();

    var name = campaign.name;

	var id = campaign.id;
	//var campaignRow = $j(document.createElement('tr'));
	rowCounter++;
	var rowId = 'row' + rowCounter;
	var startOffset = ((100 * startDay) / 31); //Percentage from the left
	if (startOffset > 90) 
		startOffset = 90; //Make sure there's always 10% width
	var endOffset = (100 - ((100 * endDay) / 31)); //Percentage from the right
	if (endOffset > 90) 
		endOffset = 90; //Make sure there's always 10% width
	//campaignRow.attr('id', rowId);
	//campaignRow.attr('class', 'master');
	parentAttr="parentid=''";
	if(campaign.parentId){parentAttr="parentid='"+campaign.parentId+"'";}
	rowReturned = '<tr id="row-'+campaign.id+'" class="master" startDateEpoch="'+startDateEpoch+'" childLevel="'+childLevel+'"  '+parentAttr+'>';
	var leftMargin="0px";
	if(childLevel>0){
		leftMarginInt=20*childLevel
		leftMargin=leftMarginInt+'px';
	}
	
	rowReturned += '<td class="name" style="text-align: left;" id="' + id + '" childLevel="'+childLevel+'"><div style="margin-left:'+leftMargin+'">' + name + '</div></td>';
	// Out of year start, in year end
	if (startYear < selYear && endYear == selYear) {
		rowReturned += '<td><div class="tdWrapper"><div class="campaignStart campaignBracket block' + id + '" style="left: 0; background-color: '+campaign.backgroundColor+';"><div style="color:'+campaign.textColor+';" class="'+displayDateClass+' inlineTextDate textDateStart">' + startDate + '</div></div>' + '&nbsp;' + '</div></td>';
		for (i = 0; i < 13; i++) {
			if (i < endMonth - 1) {
				rowReturned += '<td><div class="tdWrapper"><div class="campaignMid block' + id + '" style="background-color: '+campaign.backgroundColor+';"></div>' + '&nbsp;' + '</div></td>';
			}
			else 
				if (i == endMonth - 1) {
					rowReturned += '<td><div class="tdWrapper"><div class="campaignEnd campaignBracket block' + id + '" style="right: ' + endOffset + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateEnd">' + monthString(endMonth) + " " + endDay + '</div></div>' + '&nbsp;' + '</div></td>';
				}
				else {
					rowReturned += '<td><div class="tdWrapper">' + '&nbsp;' + '</div></td>';
				}
		}
	}
	// In year start, out of year end
	else 
		if (startYear == selYear && endYear > selYear) {
			rowReturned += '<td><div class="tdWrapper">' + '&nbsp;' + '</div></td>';
			for (i = 0; i < 12; i++) {
				if (i < startMonth - 1) {
					rowReturned +='<td><div class="tdWrapper">' + '&nbsp;' + '</div></td>';
				}
				else 
					if (i == startMonth - 1) {
						rowReturned +='<td><div class="tdWrapper"><div class="campaignStart campaignBracket block' + id + '" style="left: ' + startOffset + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateStart">' + monthString(startMonth) + " " + startDay + '</div></div>' + '&nbsp;' + '</div></td>';
					}
					else {
						rowReturned += '<td><div class="tdWrapper"><div class="campaignMid block' + id + '" style="background-color: '+campaign.backgroundColor+';"></div>' + '&nbsp;' + '</div></td>';
					}
			}
			rowReturned += '<td><div class="tdWrapper"><div class="campaignEnd block' + id + '" style="right: 0; background-color: '+campaign.backgroundColor+';"><div style="color:'+campaign.textColor+';" class="'+displayDateClass+' inlineTextDate textDateEnd">' + endDate + '</div></div>' + '&nbsp;' + '</div></td>';
		}
		// Out of year start and end
		else 
			if (startYear < selYear && endYear > selYear) {
				rowReturned += '<td><div class="tdWrapper"><div class="campaignStart block' + id + '" style="left: 0; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' inlineTextDate textDateStart" style="color:'+campaign.textColor+';">' + startDate + '</div></div>' + '&nbsp;' + '</div></td>';
				for (i = 0; i < 12; i++) {
					rowReturned += '<td><div class="tdWrapper"><div class="campaignMid block' + id + '" style="background-color: '+campaign.backgroundColor+';"></div>' + '&nbsp;' + '</div></td>';
				}
				rowReturned += '<td><div class="tdWrapper"><div class="campaignEnd block' + id + '" style="right: 0; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' inlineTextDate textDateEnd" style="color:'+campaign.textColor+';" >' + endDate + '</div></div>' + '&nbsp;' + '</div></td>';
			}
			// In year start and end, single month
			else 
				if (startYear == selYear && endYear == selYear && startMonth == endMonth) {
					rowReturned += '<td><div class="tdWrapper">' + '&nbsp;' + '</div></td>';
					for (i = 0; i < 12; i++) {
						if (i == startMonth - 1) {
							//rowReturned += '<td><div class="tdWrapper"><div class="campaignOne campaignBracket block' + id + '" style="left: ' + startOffset + '%; right:' + (95 - startOffset) + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateStart">' + monthString(startMonth) + " " + startDay + '</div><div class="'+displayDateClass+' textDate textDateEnd">' + monthString(endMonth) + " " + endDay + '</div></div>' + '&nbsp;' + '</div></td>';
							rowReturned += '<td><div class="tdWrapper"><div class="campaignOne campaignBracket block' + id + '" style="left: ' + startOffset + '%; right:' + (endOffset) + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateStart">' + monthString(startMonth) + " " + startDay + '</div><div class="'+displayDateClass+' textDate textDateEnd">' + monthString(endMonth) + " " + endDay + '</div></div>' + '&nbsp;' + '</div></td>';
						}
						else 
							rowReturned += '<td><div class="tdWrapper">' + '&nbsp;' + '</div></td>';
					}
					rowReturned += '<td><div class="tdWrapper">' + '&nbsp;' + '</div></td>';
				}
				// In year start and end, multiple months		
				else {
					rowReturned += '<td><div class="tdWrapper">' + '&nbsp;' + '</div></td>';
					for (i = 0; i < 13; i++) {
						if (i == startMonth - 1) {
							rowReturned += '<td><div class="tdWrapper"><div class="campaignStart campaignBracket block' + id + '" style="left: ' + startOffset + '%; background-color: '+campaign.backgroundColor+';+"><div class="'+displayDateClass+' textDate textDateStart">' + monthString(startMonth) + " " + startDay + '</div></div>' + '&nbsp;' + '</div></td>';
						}
						else 
							if (i > startMonth - 1 && i < endMonth - 1) {
								rowReturned += '<td><div class="tdWrapper"><div class="campaignMid block' + id + '" style="background-color: '+campaign.backgroundColor+';"></div>' + '&nbsp;' + '</div></td>';
							}
							else 
								if (i == endMonth - 1) {
									rowReturned += '<td><div class="tdWrapper"><div class="campaignEnd campaignBracket block' + id + '" style="right: ' + endOffset + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateEnd">' + monthString(endMonth) + " " + endDay + '</div></div>' + '&nbsp;' + '</div></td>';
								}
								else 
									rowReturned += '<td><div class="tdWrapper">' + '&nbsp;' + '</div></td>';
					}
				}
	var descriptionLength = campaign.description.length;
	var campaignDescription = campaign.description;
	if (descriptionLength > 90) {
		campaignDescription = campaignDescription.substring(0, 75) + '&hellip; <span class="readMore">Read More</span>';
	}
	rowReturned += '<td class="click" id="' + id + '"><div style="max-height: 60px; overflow: hidden; text-align: left;">' + campaignDescription + '</div></td>';
	rowReturned += '</tr>';
	return rowReturned;
}

function generatePVRow_quarter(campaign,childLevel){
	var displayDateClass = (displayDates) ? '' : 'hidden';
	var campaignStartDate=new Date(campaign.startYear, campaign.startMonth-1, campaign.startDay);
	var campaignEndDate=new Date(campaign.endYear, campaign.endMonth-1, campaign.endDay);
	var startDateEpoch=campaignStartDate.getTime();
	var headers=[];
	$j('#planningViewTable_quarter th').each(function()
	{
		var thObj={tdtype:$j(this).attr('tdtype'),month:$j(this).attr('month'),year:$j(this).attr('year')};
		headers.push(thObj);
	});

	/*console.log(campaignStartDate);
	console.log(campaignEndDate);*/
	//loop through all of the td's to see if the campaign applies to them
	rowArr=[];

	var leftMargin="0px";
	if(childLevel>0){
		leftMarginInt=20*childLevel
		leftMargin=leftMarginInt+'px';
	}
	
	parentAttr="parentid=''";
	if(campaign.parentId){parentAttr="parentid='"+campaign.parentId+"'";}

	$j.each(headers,function(key,thObj){
		if(thObj['tdtype']=='name'){
			rowArr[key]='<tr id="row-'+campaign.id+'" class="master" startDateEpoch="'+startDateEpoch+'" childLevel="'+childLevel+'" '+parentAttr+'><td class="name" style="text-align: left;" id="' + campaign.id + '" childLevel="'+childLevel+'"><div style="margin-left:'+leftMargin+'">' + campaign.name + '</div></td>';
		}
		
		else if(thObj['tdtype']=='previous'){
			previousCutoffDate=new Date(thObj['year'],thObj['month']-1,0);
			/*console.log(previousCutoffDate);
			console.log(campaignStartDate);
			console.log(campaignEndDate);
			console.log(campaignStartDate<=previousCutoffDate && campaignEndDate>previousCutoffDate);*/
			if(campaignStartDate<=previousCutoffDate && campaignEndDate>previousCutoffDate){
				//console.log('should be in previous');
				rowArr[key]='<td><div class="tdWrapper"><div class="campaignStart campaignBracket block' + campaign.id + '" style="left: 0; background-color: '+campaign.backgroundColor+';"><div style="color:'+campaign.textColor+';" class="'+displayDateClass+' inlineTextDate textDateStart">' + campaign.startDate + '</div></div>' + '&nbsp;' + '</div></td>';
			}
			else{rowArr[key]='<td></td>';}
		}

		else if(thObj['tdtype']=='calendar'){
			var rangeStart=new Date(thObj['year'],thObj['month']-1,1);
			var rangeEnd=new Date(thObj['year'],thObj['month'],0);
			if(isWithinDateRange(rangeStart,rangeEnd,campaignStartDate,campaignEndDate)){
			var startOffset = ((100 * campaignStartDate.getDate()) / 31); //Percentage from the left
			if (startOffset > 90) 
				startOffset = 90; //Make sure there's always 10% width
			var endOffset = (100 - ((100 * campaignEndDate.getDate()) / 31)); //Percentage from the right
			if (endOffset > 90) 
				endOffset = 90; //Make sure there's always 10% width
				//the campaign both starts and ends in this cell
				if(campaignStartDate>=rangeStart && campaignStartDate<=rangeEnd && campaignEndDate>=rangeStart && campaignEndDate<=rangeEnd){
					rowArr[key]='<td class="pv_QuarterViewMonth"><div class="tdWrapper"><div class="campaignOne campaignBracket block' + campaign.id + '" style="left: ' + startOffset + '%; right:' + (endOffset) + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateStart">' + monthString(campaign.startMonth) + " " + campaign.startDay + '</div><div class="'+displayDateClass+' textDate textDateEnd">' + monthString(campaign.endMonth) + " " + campaign.endDay + '</div></div>' + '&nbsp;' + '</div></td>';
				}
				//the campaign starts in this cell
				else if(campaignStartDate>=rangeStart){
					rowArr[key]='<td class="pv_QuarterViewMonth"><div class="tdWrapper"><div class="campaignStart campaignBracket block' + campaign.id + '" style="left: '+startOffset+'%; background-color: '+campaign.backgroundColor+';"><div style="" class="'+displayDateClass+' textDate textDateStart">' + monthString(campaign.startMonth) + " " + campaign.startDay + '</div></div>' + '&nbsp;' + '</div></td>';
				}
				//the campaign ends in this cell
				else if(campaignEndDate<=rangeEnd){
					rowArr[key]='<td class="pv_QuarterViewMonth"><div class="tdWrapper"><div class="campaignEnd campaignBracket block' + campaign.id + '" style="right: ' + endOffset + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateEnd">' + monthString(campaign.endMonth) + " " + campaign.endDay + '</div></div>' + '&nbsp;' + '</div></td>';
				}
				//the campaign spans this cell
				
				else if(campaignStartDate<=rangeStart && campaignEndDate>=rangeEnd){
					rowArr[key]='<td class="pv_QuarterViewMonth"><div class="tdWrapper"><div class="campaignMid block' + campaign.id + '" style="background-color: '+campaign.backgroundColor+';"></div>' + '&nbsp;' + '</div></td>';
				}

				//the campaign isn't in this cell somehow
				else{rowArr[key]='<td class="pv_QuarterViewMonth"></td>';}
				/*console.log(campaignStartDate);
				console.log(campaignEndDate);
				console.log(rangeStart);
				console.log(rangeEnd);*/
			}
			else{rowArr[key]='<td class="pv_QuarterViewMonth"></td>';}
		}
		
		else if(thObj['tdtype']=='next'){
			nextCutoffDate=new Date(thObj['year'],thObj['month'],0);
			/*console.log(previousCutoffDate);
			console.log(campaignStartDate);
			console.log(campaignEndDate);
			console.log(campaignStartDate<=previousCutoffDate && campaignEndDate>previousCutoffDate);*/
			if(campaignStartDate<=nextCutoffDate && campaignEndDate>nextCutoffDate){
				rowArr[key]='<td><div class="tdWrapper"><div class="campaignEnd campaignBracket block' + campaign.id + '" style="right: 0; background-color: '+campaign.backgroundColor+';"><div style="color:'+campaign.textColor+';" class="'+displayDateClass+' inlineTextDate textDateStart">' + campaign.endDate + '</div></div>' + '&nbsp;' + '</div></td>';
			}
			else{rowArr[key]='<td></td>';}
		}
		
		else if(thObj['tdtype']=='description'){
			var descriptionLength = campaign.description.length;
			var campaignDescription = campaign.description;
			if (descriptionLength > 90) {
				campaignDescription = campaignDescription.substring(0, 75) + '&hellip; <span class="readMore">Read More</span>';
			}
			rowArr[key] = '<td class="click" id="' + campaign.id + '"><div style="max-height: 60px; overflow: hidden; text-align: left;">' + campaignDescription + '</div></td>';
		}
	});
	return rowArr.join('')+'</tr>';
}

function generatePVRow_month(campaign,childLevel){
	var displayDateClass = (displayDates) ? '' : 'hidden';
	var campaignStartDate=new Date(campaign.startYear, campaign.startMonth-1, campaign.startDay);
	var campaignEndDate=new Date(campaign.endYear, campaign.endMonth-1, campaign.endDay);
	var startDateEpoch=campaignStartDate.getTime();
	var headers=[];
	var leftMargin="0px";
	if(childLevel>0){
		leftMarginInt=20*childLevel
		leftMargin=leftMarginInt+'px';
	}
	$j('#planningViewTable_month th').each(function()
	{
		if($j(this).attr('tdtype')=='previous'){
			monthInfo=getMonthInfo(currentMonth);
			$j(this).attr('month',monthInfo['month']);
			$j(this).attr('year',monthInfo['year']);
			$j(this).attr('date',1);
		}
		if($j(this).attr('tdtype')=='next'){
			monthInfo=getMonthInfo(currentMonth);
			$j(this).attr('month',monthInfo['month']);
			$j(this).attr('year',monthInfo['year']);
			$j(this).attr('date',maxDateInMonth);
		}
		var thObj={tdtype:$j(this).attr('tdtype'),date:$j(this).attr('date'),month:$j(this).attr('month'),year:$j(this).attr('year')};
		headers.push(thObj);
	});

	/*console.log(campaignStartDate);
	console.log(campaignEndDate);*/
	//loop through all of the td's to see if the campaign applies to them
	rowArr=[];
	//console.log(campaign);
	parentAttr="parentid=''";
	if(campaign.parentId){parentAttr="parentid='"+campaign.parentId+"'";}
	$j.each(headers,function(key,thObj){
		if(thObj['tdtype']=='name'){
			rowArr[key]='<tr id="row-'+campaign.id+'" class="master" startDateEpoch="'+startDateEpoch+'" childLevel="'+childLevel+'" '+parentAttr+'><td class="name" style="text-align: left;" id="' + campaign.id + '" childLevel="'+childLevel+'"><div style="margin-left:'+leftMargin+'">'+ campaign.name + '</div></td>';
		}
		
		else if(thObj['tdtype']=='previous'){
			previousCutoffDate=new Date(thObj['year'],thObj['month']-1,0);
			/*console.log(previousCutoffDate);
			console.log(campaignStartDate);
			console.log(campaignEndDate);
			console.log(campaignStartDate<=previousCutoffDate && campaignEndDate>previousCutoffDate);*/
			if(campaignStartDate<=previousCutoffDate && campaignEndDate>previousCutoffDate){
				//console.log('should be in previous');
				rowArr[key]='<td class="planningMonth_previous"><div class="tdWrapper"><div class="campaignStart campaignBracket block' + campaign.id + '" style="left: 0; background-color: '+campaign.backgroundColor+';"><div style="color:'+campaign.textColor+';" class="'+displayDateClass+' inlineTextDate textDateStart">' + campaign.startDate + '</div></div>' + '&nbsp;' + '</div></td>';
			}
			else{rowArr[key]='<td class="planningMonth_previous"></td>';}
		}

		else if(thObj['tdtype']=='calendar'){
			var rangeStart=new Date(thObj['year'],thObj['month']-1,thObj['date']);
			var rangeEnd=new Date(thObj['year'],thObj['month']-1,thObj['date']);
			/*console.log(campaign.name);
			console.log(rangeStart);
			console.log(rangeEnd);*/
			if(isWithinDateRange(rangeStart,rangeEnd,campaignStartDate,campaignEndDate)){
				//console.log(campaign.name+' is within range');
				var startOffset = 0;
				var endOffset = 0;
				//the campaign both starts and ends in this cell
				if(campaignStartDate>=rangeStart && campaignStartDate<=rangeEnd && campaignEndDate>=rangeStart && campaignEndDate<=rangeEnd){
					rowArr[key]='<td><div class="tdWrapper"><div class="campaignOne campaignBracket block' + campaign.id + '" style="left: ' + startOffset + '%; right:' + (endOffset) + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateStart">' + monthString(campaign.startMonth) + " " + campaign.startDay + '</div><div class="'+displayDateClass+' textDate textDateEnd">' + monthString(campaign.endMonth) + " " + campaign.endDay + '</div></div>' + '&nbsp;' + '</div></td>';
				}
				//the campaign starts in this cell
				else if(campaignStartDate>=rangeStart){
					rowArr[key]='<td><div class="tdWrapper"><div class="campaignStart campaignBracket block' + campaign.id + '" style="left: '+startOffset+'%; background-color: '+campaign.backgroundColor+';"><div style="" class="'+displayDateClass+' textDate textDateStart">' + monthString(campaign.startMonth) + " " + campaign.startDay + '</div></div>' + '&nbsp;' + '</div></td>';
				}
				//the campaign ends in this cell
				else if(campaignEndDate<=rangeEnd){
					rowArr[key]='<td><div class="tdWrapper"><div class="campaignEnd campaignBracket block' + campaign.id + '" style="right: ' + endOffset + '%; background-color: '+campaign.backgroundColor+';"><div class="'+displayDateClass+' textDate textDateEnd">' + monthString(campaign.endMonth) + " " + campaign.endDay + '</div></div>' + '&nbsp;' + '</div></td>';
				}
				//the campaign spans this cell
				
				else if(campaignStartDate<=rangeStart && campaignEndDate>=rangeEnd){
					rowArr[key]='<td><div class="tdWrapper"><div class="campaignMid block' + campaign.id + '" style="background-color: '+campaign.backgroundColor+';"></div>' + '&nbsp;' + '</div></td>';
				}

				//the campaign isn't in this cell somehow
				else{rowArr[key]='<td></td>';}
				/*console.log(campaignStartDate);
				console.log(campaignEndDate);
				console.log(rangeStart);
				console.log(rangeEnd);*/
			}
			else{rowArr[key]='<td></td>';}
		}
		
		else if(thObj['tdtype']=='next'){
			nextCutoffDate=new Date(thObj['year'],thObj['month'],0);
			/*console.log(previousCutoffDate);
			console.log(campaignStartDate);
			console.log(campaignEndDate);
			console.log(campaignStartDate<=previousCutoffDate && campaignEndDate>previousCutoffDate);*/
			if(campaignStartDate<=nextCutoffDate && campaignEndDate>nextCutoffDate){
				rowArr[key]='<td class="planningMonth_next"><div class="tdWrapper"><div class="campaignEnd campaignBracket block' + campaign.id + '" style="right: 0; background-color: '+campaign.backgroundColor+';"><div style="color:'+campaign.textColor+';" class="'+displayDateClass+' inlineTextDate textDateStart">' + campaign.endDate + '</div></div>' + '&nbsp;' + '</div></td>';
			}
			else{rowArr[key]='<td class="planningMonth_next"></td>';}
		}
		else if(thObj['tdtype']=='description'){
			var descriptionLength = campaign.description.length;
			var campaignDescription = campaign.description;
			if (descriptionLength > 90) {
				campaignDescription = campaignDescription.substring(0, 75) + '&hellip; <span class="readMore">Read More</span>';
			}
			rowArr[key] = '<td class="click" id="' + campaign.id + '"><div style="max-height: 60px; overflow: hidden; text-align: left;">' + campaignDescription + '</div></td>';
		}
	});
	return rowArr.join('')+'</tr>';
}

function monthString(i){
	months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
	return months[i - 1];
}

function attachPageClickHandlers(){	
	    
	
	/*
	 * Increment whatever filter view we are in down one
	 */
	$j('#previousIncrement').click(function(e){
		e.preventDefault();
		if(currentPlanningView=='year'){
			currentYear=currentYear-1;
		}
		else if(currentPlanningView=='quarter'){
			currentMonth=currentMonth-1;
		}
		else if(currentPlanningView=='month'){
			currentMonth=currentMonth-1;
		}
		if(currentMonth<1){currentMonth=currentMonth+12; currentYear--;}
		if(currentMonth>12){currentMonth=currentMonth-12; currentYear++;}
		updatePlanningViewIncrementLabels();
		//renderView();
		loadAndRenderCampaignData('Loading...');
	});
	
	/*
	 * Increment whatever filter view we are in up one
	 */		
	$j('#nextIncrement').click(function(e){
		e.preventDefault();
		if(currentPlanningView=='year'){
			currentYear=currentYear+1;
		}
		else if(currentPlanningView=='quarter'){
			currentMonth=currentMonth+1;
		}
		else if(currentPlanningView=='month'){
			currentMonth=currentMonth+1;
		}
		if(currentMonth<1){currentMonth=currentMonth+12; currentYear--;}
		if(currentMonth>12){currentMonth=currentMonth-12; currentYear++;}
		updatePlanningViewIncrementLabels();
		//renderView();
		loadAndRenderCampaignData('Loading...');
	});	
	
	// Handle the planning view radio buttons
	$j('.planningButtonViews button').click(function(){
		currentPlanningView=$j(this).attr('id').split('-')[1];
		$j('.planningButtonViews button').removeClass('active');
		$j(this).addClass('active').blur();
		$j('.incrementedValue').hide();
		updatePlanningViewIncrementLabels();
		$j('#planningView').mask('Loading...');
		
		loadDataTable();
	});
	
	// Handle the print click
	$j('.printBtn.toolbarHeaderIcon').click(function(e){
		if(currentPlanningView=='year'){
			//window.open(planningViewPrintPage+'?filterId='+$j('.campaignCalendarViewSelect option:selected').val()+'&currentYear='+currentYear);
			window.open(planningViewBrowserPrintPage+'?filterId='+encodeURIComponent(headerControls.listViewControls.getCurrentListView().id)+'&filterName='+encodeURIComponent($j('#list-view-dropdown-toggle-text').text())+'&currentYear='+encodeURIComponent(currentYear)+'&currentMonth='+encodeURIComponent(currentMonth)+'&currentPlanningView=year');
		}
		else if(currentPlanningView=='quarter'){
			window.open(planningViewBrowserPrintPage+'?filterId='+encodeURIComponent(headerControls.listViewControls.getCurrentListView().id)+'&filterName='+encodeURIComponent($j('#list-view-dropdown-toggle-text').text())+'&currentYear='+encodeURIComponent(currentYear)+'&currentMonth='+encodeURIComponent(currentMonth)+'&currentPlanningView=quarter');
		}
		else if(currentPlanningView=='month'){
			window.open(planningViewBrowserPrintPage+'?filterId='+encodeURIComponent(headerControls.listViewControls.getCurrentListView().id)+'&filterName='+encodeURIComponent($j('#list-view-dropdown-toggle-text').text())+'&currentYear='+encodeURIComponent(currentYear)+'&currentMonth='+encodeURIComponent(currentMonth)+'&currentPlanningView=month');
		}
	});
	
	//Handle the "today" click
	$j('#incrementToToday').click(function(e){
		var today = new Date();
		currentYear=today.getFullYear();
		currentMonth=today.getMonth()+1;
		updatePlanningViewIncrementLabels();
		loadAndRenderCampaignData('Loading...');
	});
	

	  $j('.icsDownloadButton').click(function(e){
	  	var campaignIds = $j.map($j('.name'),function(td){return $j(td).attr('id');});
	  	var icsData = [];
	  	$j.each(data,function(year,yearData){
	  		$j.each(yearData,function(index,campaign){
	  			if($j.inArray(campaign.id,campaignIds) !== -1){
	  				icsData.push(campaign);
	  			}
	  		});
	  	});

		if(getIsIE()){
           var blob = new Blob([generateICSString(icsData)]);
            window.navigator.msSaveOrOpenBlob(blob, 'Calendar.ics');
        } else{
            window.open( "data:text/calendar;charset=utf8," + escape(generateICSString(icsData)));
        }
	  });
}

function getIsIE()
{
    return (/Trident\/7\./).test(navigator.userAgent) ? true : false
}

/**
 * Update a user's chatter status.
 * 9/15/2011 - Jordan, Can be moved to shared.
 */
function updateChatterStatus() {
	CAMPAIGNCAL.ccPlanningViewController.updateChatterStatus($j('#campaignCalendarPublisherField').val(),function(event,result){
			if(result.status == true){
			    var statusField = $j('#campaignCalendarPublisherField');
				statusField.val(""), statusField.blur(), showMaskMessage("Your chatter status has been updated.", "body", "loadmask-top loadmask-warning", 2500)
			    statusField.val('');
			    statusField.blur();
			    showMaskMessage('Your chatter status has been updated.', 'body', 'loadmask-top loadmask-warning', 2500);
			}
			else{
				// errorArray.push(result);
				// showMaskMessage('The Chatter status update failed, please ensure you are logged in and connected to the Internet.</br></br> Would you like to send an error report to Bracket Labs?</br></br><input class="btn" onclick="$j(\'.bracketLabsFeedbackButton\').click();" value="Report An Error" style="width:100px; text-align: center;"/>&nbsp;&nbsp;<input class="btn" onclick="$j(\'#planningView\').unmask();" value="Dismiss" style="width:100px; text-align: center;">', '#planningView', 'loadmask-top loadmask-error', 0);	
				handleError(result.message,true);
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

/*
 * 
 */
function toggleShowDates(checkBox){
	CAMPAIGNCAL.ccPlanningViewController.toggleDisplayDates(
		$j(checkBox).is(':checked')
	,function(event, result){
		var showHide = '';
		var textdate = $j('.textDate'); //get all the textdate selectors on the 
		//page into a single list
		var length = textdate.length;
		var index = 0;
		
		if (!$j(checkBox).is(':checked')) {
			$j('.inlineTextDate').addClass('hidden');
			displayDates = false;
			var process = function(){
				$j('.inlineTextDate').addClass('hidden');
				for (; index < length; index++) {
					var toProcess = textdate[index];
					// Perform xml processing
					$j(toProcess).addClass('hidden');
					if (index + 1 < length && index % 25 == 0) {
						setTimeout(process, 5);
					}
				}
			};
		}
		else {
			var process = function(){
				displayDates = true;
				$j('.inlineTextDate').removeClass('hidden');
				for (; index < length; index++) {
					var toProcess = textdate[index];
					// Perform xml processing
					$j(toProcess).removeClass('hidden');
					if (index + 1 < length && index % 25 == 0) {
						setTimeout(process, 5);
					}
				}
			};
		}
		process();
	},{escape:true});
}

/*
 *
*/
function toggleShowHierarchy(checkbox){
	if($j(checkbox).is(':checked')){
		showHierarchy=true;
		$j.cookie('blcc_showHierarchy', 'true', { expires: 365, path: '/' });	
		loadDataTable();
	}
	else{
		showHierarchy=false;
		$j.cookie('blcc_showHierarchy', 'false', { expires: 365, path: '/' });	
		loadDataTable();
	}
	
}

function isWithinDateRange(rangeStart,rangeEnd,testDateStart,testDateEnd){
	//Check if the test date spans the range
	if(testDateStart<=rangeStart && testDateEnd>=rangeEnd){ return true;}
	//Check if the test date starts in the range
	else if(testDateStart>=rangeStart && testDateStart<=rangeEnd){ return true; }
	//Check if the test date ends in the range
	else if(testDateEnd>=rangeStart && testDateEnd<=rangeEnd){ return true; }
	else { return false; }
}

function getMonthLabel(monthInt){
	var displayYear=currentYear;
	var nextYear=false;
	var previousYear=false;
	if(monthInt>12){monthInt=monthInt-12; nextYear=true;}
	if(monthInt<1){monthInt=monthInt+12;previousYear=true;}
	if(nextYear==true){displayYear++;}
	if(previousYear==true){displayYear--;}
	return monthLabelArr[monthInt]+' '+displayYear;
}

function getMonthInfo(monthInt){
	var displayYear=currentYear;
	var nextYear=false;
	var previousYear=false;
	if(monthInt>12){monthInt=monthInt-12; nextYear=true;}
	if(monthInt<1){monthInt=monthInt+12;previousYear=true;}
	if(nextYear==true){displayYear++;}
	if(previousYear==true){displayYear--;}
	var returnObj={};
	returnObj['month']=monthInt;
	returnObj['year']=displayYear;
	return returnObj;
}

function updatePlanningViewIncrementLabels(){
	$j('#year').text(currentYear);
	$j('#month').text(getMonthLabel(currentMonth));
	var endMonth=getMonthLabel(currentMonth+2);
	$j('#quarter').text(getMonthLabel(currentMonth)+' - '+endMonth);
	if(currentPlanningView=='year'){
			$j('#year').show();
		}
	else if(currentPlanningView=='quarter'){
		$j('#quarter').show();
	}
	
	else if(currentPlanningView=='month'){
		$j('#month').show();
	}
}


function createColorLegend(){
	// $j('#colorSettingsButton').qtip({
	// 	content: {
	// 		title: {
	// 			text: 'Color Legend - '+$j('#active-color-field').val()
	// 		},
	// 		text: $j('#color-appendix').clone()
	// 	},
	// 	position: {
	// 		my: 'right middle',
	// 		at: 'left middle'
	// 	},
	// 	style: {
	//     	classes: 'ui-tooltip-light ui-tooltip-shadow'
	//   	}
	// });
}

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
	  // }
	}
 });
})(jQuery);


String.prototype.repeat = function( num )
{
    return new Array( num + 1 ).join( this );
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
                    }
                } else if($target.hasClass('nextIncrement')){
                    if(currentPage == 'month'){
                        $j('#blccCalendar').fullCalendar('next');
                        updateCalendarHeading();
                    }
                } else if($target.hasClass('incrementToToday')){
                    if(currentPage == 'month'){
                        $j('#blccCalendar').fullCalendar('today');
                        updateCalendarHeading();
                    }
                } else if($target.hasClass('currentIncrementSelect')){
                    datepicker.editable('show');
                } else if($target.hasClass('icsDownloadButton')){
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
            	if(!isPrintView){
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
	            }
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
                blccFilterId = currentListViewId;
                $j('#filterId').val(blccFilterId);
                $j('#list-view-dropdown-toggle-text').html(this.getCurrentListView().label);
                // updateCalendar(this.getCurrentListView().id);
                loadDataTable();
            }
        },
        initHeader: function(){
            this.listViewControls.init();
            if(!isPrintView){
				datepicker = $j('span.currentIncrementSelect');
				datepicker.editable(
					{
						type:'date', 
						container: '.campaignCalendarPlanView',
					 	url: function(params){
					 		var valArr = params.value.split('-');
							currentMonth=valArr[1];
							currentYear=valArr[0];
							updatePlanningViewIncrementLabels();
							loadAndRenderCampaignData('Loading...');
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
			}

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

function presentDescriptionModal(campaignId){
	var descPageURL = '';
    descPageURL = (descPageURL.indexOf('?') === -1) ? campaignDescriptionPage+'?Id='+campaignId : campaignDescriptionPage+'&Id='+campaignId;
    $j('#description-frame').prop('src', descPageURL);
    $j('#description-modal').modal('show');
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
	$j('#planningView').unmask();
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

function getLocaleDateString(){
	var formats = {
    'af_ZA': 'yyyy/mm/dd',
	'am_ET': 'd/m/yyyy',
	'ar': 'dd/mm/yy',
	'ar_AE': 'dd/mm/yyyy',
	'ar_BH': 'dd/mm/yyyy',
	'ar_DZ': 'dd-mm-yyyy',
	'ar_EG': 'dd/mm/yyyy',
	'ar_IQ': 'dd/mm/yyyy',
	'ar_JO': 'dd/mm/yyyy',
	'ar_KW': 'dd/mm/yyyy',
	'ar_LB': 'dd/mm/yyyy',
	'ar_LY': 'dd/mm/yyyy',
	'ar_mA': 'dd-mm-yyyy',
	'ar_Om': 'dd/mm/yyyy',
	'ar_QA': 'dd/mm/yyyy',
	'ar_SA': 'dd/mm/yy',
	'ar_SY': 'dd/mm/yyyy',
	'ar_TN': 'dd-mm-yyyy',
	'ar_YE': 'dd/mm/yyyy',
	'arn_CL': 'dd-mm-yyyy',
	'as_IN': 'dd-mm-yyyy',
	'az_AZ': 'dd.mm.yyyy',
	'az_Cyrl_AZ': 'dd.mm.yyyy',
	'az_Latn_AZ': 'dd.mm.yyyy',
	'ba_RU': 'dd.mm.yy',
	'be_BY': 'dd.mm.yyyy',
	'bg': 'dd.m.yyyy',
	'bg_BG': 'dd.m.yyyy',
	'bn_BD': 'dd-mm-yy',
	'bn_IN': 'dd-mm-yy',
	'bo_CN': 'yyyy/m/d',
	'br_FR': 'dd/mm/yyyy',
	'bs': 'd.m.yyyy',
	'bs_BA': 'd.m.yyyy',
	'bs_Cyrl_BA': 'd.m.yyyy',
	'bs_Latn_BA': 'd.m.yyyy',
	'ca': 'dd/mm/yyyy',
	'ca_ES': 'dd/mm/yyyy',
	'ca_ES_EURO': 'dd/mm/yyyy',
	'co_FR': 'dd/mm/yyyy',
	'cs': 'd.m.yyyy',
	'cs_CZ': 'd.m.yyyy',
	'cy': 'dd/mm/yyyy',
	'cy_GB': 'dd/mm/yyyy',
	'cy_GB]': 'dd/mm/yyyy',
	'da': 'dd-mm-yyyy',
	'da_DK': 'dd-mm-yyyy',
	'de': 'dd.mm.yyyy',
	'de_AT': 'dd.mm.yyyy',
	'de_AT_EURO': 'dd.mm.yyyy',
	'de_CH': 'dd.mm.yyyy',
	'de_DE': 'dd.mm.yyyy',
	'de_DE_EURO': 'dd.mm.yyyy',
	'de_LI': 'dd.mm.yyyy',
	'de_LU': 'dd.mm.yyyy',
	'de_LU_EURO': 'dd.mm.yyyy',
	'dsb_DE': 'd. m. yyyy',
	'dv_mV': 'dd/mm/yy',
	'el': 'd/m/yyyy',
	'el_GR': 'd/m/yyyy',
	'en_029': 'mm/dd/yyyy',
	'en_AU': 'd/mm/yyyy',
	'en_BB': 'm/d/yyyy',
	'en_BM': 'm/d/yyyy',
	'en_BZ': 'dd/mm/yyyy',
	'en_CA': 'dd/mm/yyyy',
	'en_GB': 'dd/mm/yyyy',
	'en_GH': 'm/d/yyyy',
	'en_ID': 'm/d/yyyy',
	'en_IE': 'dd/mm/yyyy',
	'en_IE_EURO': 'm/d/yyyy',
	'en_IN': 'dd-mm-yyyy',
	'en_Jm': 'dd/mm/yyyy',
	'en_mY': 'd/m/yyyy',
	'en_NG': 'm/d/yyyy',
	'en_NZ': 'd/mm/yyyy',
	'en_PH': 'm/d/yyyy',
	'en_PK': 'm/d/yyyy',
	'en_SG': 'd/m/yyyy',
	'en_TT': 'dd/mm/yyyy',
	'en_US': 'm/d/yyyy',
	'en_ZA': 'yyyy/mm/dd',
	'en_ZW': 'm/d/yyyy',
	'es': 'dd/mm/yyyy',
	'es_AR': 'dd/mm/yyyy',
	'es_BO': 'dd/mm/yyyy',
	'es_CL': 'dd-mm-yyyy',
	'es_CO': 'dd/mm/yyyy',
	'es_CR': 'dd/mm/yyyy',
	'es_DO': 'dd/mm/yyyy',
	'es_EC': 'dd/mm/yyyy',
	'es_ES': 'dd/mm/yyyy',
	'es_ES_EURO': 'dd/mm/yyyy',
	'es_GT': 'dd/mm/yyyy',
	'es_HN': 'dd/mm/yyyy',
	'es_mX': 'dd/mm/yyyy',
	'es_NI': 'dd/mm/yyyy',
	'es_PA': 'mm/dd/yyyy',
	'es_PE': 'dd/mm/yyyy',
	'es_PR': 'dd/mm/yyyy',
	'es_PY': 'dd/mm/yyyy',
	'es_SV': 'dd/mm/yyyy',
	'es_US': 'm/d/yyyy',
	'es_UY': 'dd/mm/yyyy',
	'es_VE': 'dd/mm/yyyy',
	'et': 'd.mm.yyyy',
	'et_EE': 'd.mm.yyyy',
	'eu': 'yyyy/mm/dd',
	'eu_ES': 'yyyy/mm/dd',
	'fa_IR': 'mm/dd/yyyy',
	'fi': 'd.m.yyyy',
	'fi_FI': 'd.m.yyyy',
	'fi_FI_EURO': 'd.m.yyyy',
	'fil_PH': 'm/d/yyyy',
	'fo_FO': 'dd-mm-yyyy',
	'fr': 'dd/mm/yyyy',
	'fr_BE': 'd/mm/yyyy',
	'fr_CA': 'yyyy-mm-dd',
	'fr_CH': 'dd.mm.yyyy',
	'fr_FR': 'dd/mm/yyyy',
	'fr_FR_EURO': 'dd/mm/yyyy',
	'fr_LU': 'dd/mm/yyyy',
	'fr_mC': 'dd/mm/yyyy',
	'fy_NL': 'd-m-yyyy',
	'ga': 'dd/mm/yyyy',
	'ga_IE': 'dd/mm/yyyy',
	'gd_GB': 'dd/mm/yyyy',
	'gl_ES': 'dd/mm/yy',
	'gsw_FR': 'dd/mm/yyyy',
	'gu_IN': 'dd-mm-yy',
	'ha_Latn_NG': 'd/m/yyyy',
	'he_IL': 'dd/mm/yyyy',
	'hi': 'dd-mm-yyyy',
	'hi_IN': 'dd-mm-yyyy',
	'hr': 'd.m.yyyy',
	'hr_BA': 'd.m.yyyy.',
	'hr_HR': 'd.m.yyyy',
	'hsb_DE': 'd. m. yyyy',
	'hu': 'yyyy. mm. dd.',
	'hu_HU': 'yyyy. mm. dd.',
	'hy': 'dd.mm.yyyy',
	'hy_Am': 'dd.mm.yyyy',
	'id_ID': 'dd/mm/yyyy',
	'ig_NG': 'd/m/yyyy',
	'ii_CN': 'yyyy/m/d',
	'in': 'dd/mm/yyyy',
	'in_ID': 'dd/mm/yyyy',
	'is': 'd.m.yyyy',
	'is_IS': 'd.m.yyyy',
	'it': 'dd/mm/yyyy',
	'it_CH': 'dd.mm.yyyy',
	'it_IT': 'dd/mm/yyyy',
	'iu_Cans_CA': 'd/m/yyyy',
	'iu_Latn_CA': 'd/mm/yyyy',
	'iw': 'dd/mm/yyyy',
	'iw_IL': 'dd/mm/yyyy',
	'ja': 'yyyy/mm/dd',
	'ja_JP': 'yyyy/mm/dd',
	'ka': 'dd.mm.yyyy',
	'ka_GE': 'dd.mm.yyyy',
	'kk_KZ': 'dd.mm.yyyy',
	'kl_GL': 'dd-mm-yyyy',
	'km_KH': 'yyyy-mm-dd',
	'kn_IN': 'dd-mm-yy',
	'ko': 'yyyy-mm-dd',
	'ko_KR': 'yyyy-mm-dd',
	'kok_IN': 'dd-mm-yyyy',
	'ky_KG': 'dd.mm.yy',
	'lb': 'dd/mm/yyyy',
	'lb_LU': 'dd/mm/yyyy',
	'lo_LA': 'dd/mm/yyyy',
	'lt': 'yyyy.mm.dd',
	'lt_LT': 'yyyy.mm.dd',
	'lv': 'yyyy.mm.dd.',
	'lv_LV': 'yyyy.mm.dd.',
	'mi_NZ': 'dd/mm/yyyy',
	'mk': 'dd.mm.yyyy',
	'mk_mK': 'dd.mm.yyyy',
	'ml_IN': 'dd-mm-yy',
	'mn_mN': 'yy.mm.dd',
	'mn_mong_CN': 'yyyy/m/d',
	'moh_CA': 'm/d/yyyy',
	'mr_IN': 'dd-mm-yyyy',
	'ms': 'dd/mm/yyyy',
	'ms_BN': 'dd/mm/yyyy',
	'ms_mY': 'dd/mm/yyyy',
	'mt': 'dd/mm/yyyy',
	'mt_mT': 'dd/mm/yyyy',
	'nb_NO': 'dd.mm.yyyy',
	'ne_NP': 'm/d/yyyy',
	'nl': 'd-m-yyyy',
	'nl_BE': 'd/mm/yyyy',
	'nl_NL': 'd-m-yyyy',
	'nl_SR': 'd-m-yyyy',
	'nn_NO': 'dd.mm.yyyy',
	'no': 'dd.mm.yyyy',
	'no_NO': 'dd.mm.yyyy',
	'nso_ZA': 'yyyy/mm/dd',
	'oc_FR': 'dd/mm/yyyy',
	'or_IN': 'dd-mm-yy',
	'pa_IN': 'dd-mm-yy',
	'pl': 'yyyy-mm-dd',
	'pl_PL': 'yyyy-mm-dd',
	'prs_AF': 'dd/mm/yy',
	'ps_AF': 'dd/mm/yy',
	'pt': 'dd/mm/yyyy',
	'pt_AO': 'dd/mm/yyyy',
	'pt_BR': 'dd/mm/yyyy',
	'pt_PT': 'dd-mm-yyyy',
	'qut_GT': 'dd/mm/yyyy',
	'quz_BO': 'dd/mm/yyyy',
	'quz_EC': 'dd/mm/yyyy',
	'quz_PE': 'dd/mm/yyyy',
	'rm': 'dd/mm/yyyy',
	'rm_CH': 'dd/mm/yyyy',
	'ro': 'dd.mm.yyyy',
	'ro_MD': 'dd.mm.yyyy',
	'ro_RO': 'dd.mm.yyyy',
	'ru': 'dd.mm.yyyy',
	'ru_RU': 'dd.mm.yyyy',
	'rw_RW': 'm/d/yyyy',
	'sa_IN': 'dd-mm-yyyy',
	'sah_RU': 'mm.dd.yyyy',
	'se_FI': 'd.m.yyyy',
	'se_NO': 'dd.mm.yyyy',
	'se_SE': 'yyyy-mm-dd',
	'sh': 'dd.mm.yyyy',
	'sh_BA': 'dd.mm.yyyy',
	'sh_CS': 'dd.mm.yyyy',
	'sh_ME': 'dd.mm.yyyy',
	'si_LK': 'yyyy-mm-dd',
	'sk': 'd. m. yyyy',
	'sk_SK': 'd. m. yyyy',
	'sl': 'd.m.yyyy',
	'sl_SI': 'd.m.yyyy',
	'sma_NO': 'dd.mm.yyyy',
	'sma_SE': 'yyyy-mm-dd',
	'smj_NO': 'dd.mm.yyyy',
	'smj_SE': 'yyyy-mm-dd',
	'smn_FI': 'd.m.yyyy',
	'sms_FI': 'd.m.yyyy',
	'sq_AL': 'yyyy-mm-dd',
	'sr': 'd.m.yyyy',
	'sr_BA': 'd.m.yyyy',
	'sr_CS': 'd.m.yyyy',
	'sr_Cyrl_BA': 'd.m.yyyy',
	'sr_Cyrl_CS': 'd.m.yyyy',
	'sr_Cyrl_mE': 'd.m.yyyy',
	'sr_Cyrl_RS': 'd.m.yyyy',
	'sr_Latn_BA': 'd.m.yyyy',
	'sr_Latn_CS': 'd.m.yyyy',
	'sr_Latn_mE': 'd.m.yyyy',
	'sr_Latn_RS': 'd.m.yyyy',
	'sv': 'yyyy-mm-dd',
	'sv_FI': 'd.m.yyyy',
	'sv_SE': 'yyyy-mm-dd',
	'sw_KE': 'm/d/yyyy',
	'syr_SY': 'dd/mm/yyyy',
	'ta_IN': 'dd-mm-yyyy',
	'te_IN': 'dd-mm-yy',
	'tg_Cyrl_TJ': 'dd.mm.yy',
	'tg_TJ': 'dd.mm.yy',
	'th': 'd/m/yyyy',
	'th_TH': 'd/m/yyyy',
	'tk_Tm': 'dd.mm.yy',
	'tl': 'dd-mm-yyyy',
	'tl_PH': 'dd-mm-yyyy',
	'tn_ZA': 'yyyy/mm/dd',
	'tr': 'dd.mm.yyyy',
	'tr_TR': 'dd.mm.yyyy',
	'tt_RU': 'dd.mm.yyyy',
	'tzm_Latn_DZ': 'dd-mm-yyyy',
	'ug_CN': 'yyyy-m-d',
	'uk': 'dd.mm.yyyy',
	'uk_UA': 'dd.mm.yyyy',
	'ur': 'dd/mm/yyyy',
	'ur_PK': 'dd/mm/yyyy',
	'uz_Cyrl_UZ': 'dd.mm.yyyy',
	'uz_Latn_UZ': 'dd/mm yyyy',
	'vi': 'dd/mm/yyyy',
	'vi_VN': 'dd/mm/yyyy',
	'wo_SN': 'dd/mm/yyyy',
	'xh_ZA': 'yyyy/mm/dd',
	'yo_NG': 'd/m/yyyy',
	'zh': 'yyyy/m/d',
	'zh_CN': 'yyyy/m/d',
	'zh_CN_PINYIN': 'yyyy/m/d',
	'zh_CN_STROKE': 'yyyy/m/d',
	'zh_HK': 'd/m/yyyy',
	'zh_HK_STROKE': 'yyyy/m/d',
	'zh_mO': 'd/m/yyyy',
	'zh_SG': 'd/m/yyyy',
	'zh_TW': 'yyyy/m/d',
	'zh_TW_STROKE': 'yyyy/m/d',
	'zu_ZA': 'yyyy/mm/dd'
	};

	var lang = currentUserLocale;
	lang = lang.replace('-','_');
	var foundFormat;
	
	if(formats[lang]!=null){foundFormat=formats[lang];}

	return foundFormat || 'dd/mm/yyyy';
}
