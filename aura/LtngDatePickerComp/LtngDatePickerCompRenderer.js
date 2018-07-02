({
	// Your renderer method overrides go here
	afterRender: function() {
        return this.superAfterRender();
    },

    rerender: function(component, helper) {
        helper.renderGrid(component);
        this.superRerender();
    }
})