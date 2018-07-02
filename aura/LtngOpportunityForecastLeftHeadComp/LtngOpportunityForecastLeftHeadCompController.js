({
	myAction : function(component, event, helper) {
		
	},
    
    event_allDisplayfc_click: function(component, event, helper) {
		
		var target=event.currentTarget;
		
        $('#leftTab tbody input[type="checkbox"]:not(.masscheckbox)').each(function(){
        	if(target.checked != this.checked){
        		this.click();
        	}
        });
        /*
        var $list_cols=$('#leftTab col').clone(), $list_tr=$('#leftThead tr').clone();
        
        $('#leftTfoot').append($list_cols).append($list_tr);
        */
	},
    
    
    
})