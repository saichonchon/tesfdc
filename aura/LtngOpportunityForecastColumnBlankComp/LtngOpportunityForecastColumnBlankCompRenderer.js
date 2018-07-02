({
	// Your renderer method overrides go here
    afterRender: function(component, helper) {
        helper.doInit(component);
        this.superAfterRender();
    },
    
    rerender: function(component, helper) {
        helper.doInit(component);
        this.superRerender();
    },
    
    unrender: function(component, helper) {
        this.superUnrender();
    }
})