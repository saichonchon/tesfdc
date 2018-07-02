({
	myAction : function(component, event, helper) {
		
	},
    event_mouse_over: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_mouse_over(o);
	},
    event_mouse_out: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_mouse_out(o);
	},
    
})