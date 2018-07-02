/* 
 * sfdcEventFeed
 * JQuery Extension to invoke @RemoteAction method and return events array
 * to the fullCalendar plugin. 
 * This function was previously in it's own file, but has been moved here in an effort to
 * expedite development in the process of refactoring for Javascript remoting from
 * the previously used 'WebService' annotation. 
 * 
 * Added some shared variables for error array to this file - Jordan, 2/28/2012
 */
if (typeof console === "undefined"){ console={}; console.log = function(){ return; }; console.time = function(){return;}; console.timeEnd = function(){return;}; }
var errorArray = [],	//array for storing error messages from the server
allEvents = [],
lastFilterId,
resetEvents=false;

(function($) {
    $.fullCalendar.sfdcEventFeed = function(options) {
        options = options || {};

    return function(start, end, timezone, callback) {
        // Retrieve the campaigns for the dates being displayed
        if (headerControls.listViewControls.getCurrentListView().id == null || headerControls.listViewControls.getCurrentListView().id == '') {
                    // No list view selected
                    showMaskMessage('Please select a list view above', '#blccCalendar', 'loadmask-warning', 0);
		}
		else{
		var startDate = start.year()+"-"+(start.month()+1)+"-"+start.date();
		var endDate = (end!=null) ? end.year()+"-"+(end.month()+1)+"-"+end.date() : startDate;
		//If we are just changing months
		if(lastFilterId == headerControls.listViewControls.getCurrentListView().id && !resetEvents){callback(allEvents);$j('#blccCalendar').unmask();return;}
		lastFilterId = headerControls.listViewControls.getCurrentListView().id;
		CAMPAIGNCAL.ccMonthViewController.getCampaigns(headerControls.listViewControls.getCurrentListView().id,function(e,result){
       	 // CAMPAIGNCAL.ccMonthViewController.getCampaignsDateRange(blccFilterId, startDate, endDate, function(e,result){
			if(result.status == true){	
	           	var events = [];
	            $.each(result.result, function(i, event) {
	            	var brokenName=wbr(event.name,9);
	            	brokenName=$j('<div/>').html(brokenName).text();
	            	var endMoment = moment(new Date(event.endYear, event.endMonth-1, event.endDay, 0, 0, 0, 0));
	            	var startMoment = moment(new Date(event.startYear, event.startMonth-1, event.startDay, 0, 0, 0, 0));
                //With the new full calendar end dates are exclusive, to make cc inclusive we need to render a day out
                // if(startMoment.diff(endMoment,'days')!==0){
                  endMoment.add(1,'days');  
                // }
                
	                events.push({
	                    id: event.id,
	                    title: brokenName,
	                    // start: new Date(event.startYear, event.startMonth-1, event.startDay, 0, 0, 0, 0),
	                    // end: new Date(event.endYear, event.endMonth-1, event.endDay, 0, 0, 0, 0),
	                    // start: startMoment.format('YYYY-MM-DD'),
	                    // end: endMoment.format('YYYY-MM-DD'),
	                    start: startMoment,
	                    end: endMoment,
	                    allDay: true,
	                    type: event.campaignType,
	                    status: event.campaignStatus,
	                    ownerPhoto: event.ownerPhoto,
	                    ownerName: event.ownerName,
	                    ownerEmail: event.ownerEmail,
	                    numberOfLeads: event.numberOfLeads,
	                    numberOfContacts: event.numberOfContacts,
	                    numberOfOpportunities: event.numberOfOpportunities,
	                    AmountAllOpportunities: event.AmountAllOpportunities,
	                    textColor: event.textColor,
	                    backgroundColor: event.color,
	                    borderColor: event.borderColor,
	                    className: options.className,
	                    editable: options.editable || true,
	                    total: event.total,
	                    name: event.name,
	                    description: event.description
	                });
	            });
				allEvents =events;
				resetEvents = false;
	            $j('#blccCalendar').unmask();
            	if(events.length >= 2000){
            			// showMaskMessage('Some '+campaignsPlural+' may be not be shown.<br />Please select a list view that contains less than 2,000 '+campaignsPlural+'. You may also try adding a date constraint to the list view filter.', '#blccCalendar', 'loadmask-warning', 5000);
            			handleError('Some '+campaignsPlural+' may be not be shown.<br />Please select a list view that contains less than 2,000 '+campaignsPlural+'. You may also try adding a date constraint to the list view filter.',true);
            	}
            	events.sort(function(a,b){
            		return a.start-b.start;
            	})
            	callback(events);	
	           }
	           else{
   		            $j('#blccCalendar').unmask();
		           	errorArray.push(result);
		           	if(!isPrintView){
		           		handleError(result.message,false);
						// var availableFilters=[];
						// $j.each('.campaignCalendarViewSelect option',function(){
						// 	availableFilters.push($j(this).val());
						// });
						// currentFilterId=$j('.campaignCalendarViewSelect option:selected').val();
						// var msgContainsFilter = (result.message.indexOf(currentFilterId)!==-1) ? true:false;
						// var selectContainsFilter = ($j.inArray(currentFilterId,availableFilters)!==-1) ? true:false;
						
						// if(!msgContainsFilter && !selectContainsFilter){
				  //          	//This accounts for the failure on navigating away from the page when a remote action is inflight
				  //          	if(result.message!='Unable to connect to the server.')
				  //          	{
		           		// showMaskMessage('An error occurred fetching information from the server.</br></br> Would you like to send an error report to Bracket Labs?</br></br><input class="btn" onclick="$j(\'.bracketLabsFeedbackButton\').click();" value="Report An Error" style="width:100px; text-align: center;"/>&nbsp;&nbsp;<input class="btn" onclick="$j(\'#blccCalendar\').unmask();" value="Dismiss" style="width:100px; text-align: center;">', '#blccCalendar', 'loadmask-top loadmask-error', 0);
				           	// }
				        // }
		           	}
		           	else{
		           		showMaskMessage('An error occurred fetching information from the server. </br></br>Please close this pop-up, and try refreshing your list view.','body', 'loadmask-top loadmask-error', 0);
		           	}
	           }
           	});
           }
    	}
	}
})(jQuery);
