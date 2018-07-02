({
	exists : function(obj) {
		return typeof obj !== 'undefined' && obj !== null;
	},

	goToUrl : function(url) {
		var urlEvent = $A.get("e.force:navigateToURL");
		urlEvent.setParams({
			"url": url
		});
		urlEvent.fire();
	},

	hideElement : function(el) {
		$A.util.addClass(el,'slds-hide');
	},

	showElement : function(el) {
		$A.util.removeClass(el, 'slds-hide');
	},

	makeElementVisible: function(el) {
		$A.util.removeClass(el,'notVisible');
	}
})