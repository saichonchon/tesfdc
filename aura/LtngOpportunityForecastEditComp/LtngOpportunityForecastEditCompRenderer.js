({
	// Your renderer method overrides go here
	render: function(component, helper) {
        return this.superRender();
    },
    
    afterRender: function(component, helper) {
        this.superAfterRender();
    },
    
    rerender: function(component, helper) {
        this.superRerender();
    },
    
    unrender: function(component, helper) {
        this.superUnrender();
    },
    
})