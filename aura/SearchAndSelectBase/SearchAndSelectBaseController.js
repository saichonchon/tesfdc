({
  init : function(cmp, e, helper) {
      //Override this function to populate v.items
   },
  searchKeyChange: function(cmp, e, helper) {
        helper.searchKeyChange(cmp, e, helper);
    },
    
    handleFocus: function(cmp, e, helper) {
    	//Remove error class and error message manually to prevent bug where
    	//an option can not be selected from the drop-down after the field
    	//is marked as an error. In the future, possibly removable.
    	var input = e.getSource();
    	$A.util.removeClass(input, "slds-has-error"); // remove red border
    	$A.util.addClass(input, "hide-error-message"); // hide error message
    },
    
    handleBlur: function(cmp, e, helper) {
    	var input = e.getSource();
    	if (input.get("v.validity").valid) {
    		$A.util.removeClass(input, "slds-has-error");
    		$A.util.addClass(input, "hide-error-message");
    	}
    	else {
    		$A.util.addClass(input, "slds-has-error");
    		$A.util.removeClass(input, "hide-error-message");
		}
    }
})