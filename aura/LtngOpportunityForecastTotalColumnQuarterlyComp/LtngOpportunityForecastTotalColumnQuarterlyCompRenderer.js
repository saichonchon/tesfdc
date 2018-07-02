({
	// Your renderer method overrides go here
    afterRender: function(component, helper) {
        helper.doInit(component);
        return this.superAfterRender();
    },
    
    rerender: function(component, helper) {
        helper.doInit(component);
        this.superRerender();
    },

})