({
	helperMethod : function() {
		
	},

    handleModeEvt: function(comp, event) {
        comp.set('v.isAPL', event.getParam('isAPL'));
        comp.set('v.isView', event.getParam('isView'));
        comp.set('v.isShowMussUpdate', event.getParam('isShowMussUpdate'));
	},

    
})