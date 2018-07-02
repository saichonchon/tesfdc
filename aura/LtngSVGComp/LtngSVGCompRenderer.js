({
	// Your renderer method overrides go here
	render: function(component, helper) {
        var ret = this.superRender();
        helper.helperAfterRender(component);
        return ret;
	}
})