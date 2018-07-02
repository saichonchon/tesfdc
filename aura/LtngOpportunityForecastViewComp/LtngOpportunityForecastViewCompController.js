({
	myAction : function(component, event, helper) {
		
	},
    
    jsLoaded: function(component, event, helper) {
    	var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_document_resize(o);
		that.ltngUtil.event_fixedHeight_layout(o);        
		
        helper.doInit(component, event, that.ltngUtil);
        
	},
	
    event_displayfc_click: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_displayfc_click(o);
	},

    event_edit_click: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_edit_click(o);
	},
    
    event_mouse_over: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_mouse_over(o);
	},
    event_mouse_out: function(component, event, helper) {
		var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_mouse_out(o);
	},
    event_fullscreen_click: function(component, event, helper) {
        var that=this, o={'that': that, 'comp': component, 'event': event};
        that.ltngUtil.event_fullscreen_click(o);
	},
})