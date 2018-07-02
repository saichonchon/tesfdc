({
	// Your renderer method overrides go here
		// Your renderer method overrides go here
	render: function(component, helper) {
        return this.superRender();
    },
    
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