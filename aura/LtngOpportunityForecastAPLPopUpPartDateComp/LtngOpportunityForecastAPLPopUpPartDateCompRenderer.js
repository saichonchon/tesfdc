({
	// Your renderer method overrides go here
	rerender: function(component, helper) {
        helper.renderDate(component);
        this.superRerender();
    }
})