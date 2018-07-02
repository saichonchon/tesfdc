({
	emailTemplateClick: function(cmp, e, helper) {
		var emailEvent = cmp.getEvent("emailEvent");

        emailEvent.fire();
        helper.closeModal(cmp);
	},
	templateBuilderClick: function(cmp, e, helper) {
		var templateBuilderEvent = cmp.getEvent("templateBuilderEvent");
        templateBuilderEvent.fire();
        helper.closeModal(cmp);
	},
})