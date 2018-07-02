({
	// Your renderer method overrides go here
    afterRender: function(component, helper) {
        helper.helperRender(component);
        this.superAfterRender();
    },
})