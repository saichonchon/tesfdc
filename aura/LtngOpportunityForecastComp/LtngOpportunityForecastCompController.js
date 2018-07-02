({
	myAction : function(component, event, helper) {
		
	},
	
	scriptsLoaded: function(component, event, helper) {
		var that=this;
        that.ltngUtil.addListener(window, 'resize', that.ltngUtil.event_document_resize, {'that': that, 'comp': component, 'event': event});
	},

    handleModeEvt: function(component, event, helper) {
		helper.handleModeEvt(component, event);
	},
    
})