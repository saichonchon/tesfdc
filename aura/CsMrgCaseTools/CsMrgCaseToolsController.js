({
	init : function(component, event, helper) {
		var recentEnabled = component.get('v.showRecent');
		var dupeDetectorEnabled = component.get('v.showDupeDetector');
		var action = component.get("c.initializeComponent");
		action.setParams({'caseId' : component.get('v.recordId'), 'dupeDetectorEnabled' : dupeDetectorEnabled, 'recentEnabled' : recentEnabled});
		action.setCallback(this,function(response) {
			var errorOccured = false;
			var state = response.getState();
			if(state === 'SUCCESS') {
				var initObj = response.getReturnValue();
				if(helper.exists(initObj)) {
					// Dupe Text
					if(dupeDetectorEnabled) {
						component.set('v.duplicatesText',initObj.dupeText);
						component.set('v.dupesFound', initObj.dupesFound);
					}

					// Recent Cases
					if(recentEnabled) {
						component.set('v.recentCases', initObj.recentCases);
					}
					helper.makeElementVisible(component.find('cmpContent'));
				}
				else {
					errorOccured = true;
					component.set('v.errorMessage', 'Error: No data retrieved.');
				}
			}
            else {
            	errorOccured = true;
                var errors = response.getError();
                if (errors) {
                	var errorMessage = '';
                	for(var i = 0; i < errors.length; i++) {
                		errorMessage += errors[i].message + '\n';
                	}
                	errorMessage = errorMessage.slice(0,-1); // cut off the last new line
                	component.set('v.errorMessage', errorMessage);
                } 
            }
            component.set('v.showSpinner', false);
            if(errorOccured) {
            	if(!helper.exists(component.get('v.errorMessage')) || component.get('v.errorMessage').trim() === '') {
            		component.set('v.errorMessage', 'Error: An unknown error occured');
            	}
            	component.set('v.showError', true);
            }
		});
		if(dupeDetectorEnabled || recentEnabled) {
			$A.enqueueAction(action);
		}
	},

	// hide spinner if neither tool is selected
	onRender : function(component, event, helper) {
		if(!(component.get('v.showRecent') || component.get('v.showDupeDetector'))) {
			component.set('v.showSpinner', false);
		}
	},

	goToMerge : function(component,event,helper) {
		helper.goToUrl('/apex/csmrgp__CsMrgSelect?cs1=' + component.get('v.recordId') + '&cs2=' + component.find('recentCaseSelect').get('v.value'));
	},

	goToFind: function(component,event,helper) {
		var recordId = component.get('v.recordId');
		helper.goToUrl('/apex/csmrgp__CsMrgFind' + (helper.exists(recordId) ? ('?cid=' + recordId) : ''));
	}
})