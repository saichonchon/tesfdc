({
	handleClick : function(cmp, evt, helper) {
        var treeEvent = cmp.getEvent("behaviorSelect");
        var componentToLoad = evt.currentTarget.id;
        var message = "";
        
        if(componentToLoad == "emailNode") {
        	message = "APXTConga4:EmailBehaviorSettings";
        }
        else if(componentToLoad == "saveACopyNode") {
        	message = "APXTConga4:SaveACopyBehaviorSettings";
        }
        else if(componentToLoad == "activityLoggingNode") {
        	message = "APXTConga4:ActivityLoggingBehaviorSettings";
        }
        else if(componentToLoad == "generatedFileSettingsNode") {
        	message = "APXTConga4:GeneratedFileBehaviorSettings";
        }
        else if(componentToLoad == "eSignatureSettingsNode") {
        	message = "APXTConga4:ESignatureBehaviorSettings";
        }
        
        treeEvent.setParam("message", message);
        treeEvent.fire();
	}
})