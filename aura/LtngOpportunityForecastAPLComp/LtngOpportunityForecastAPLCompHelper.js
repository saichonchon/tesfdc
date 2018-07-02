({
	helperMethod : function() {
		
	},
    
    helperRender: function(comp){
        var isAPL=comp.get('v.isAPL');
        if(!isAPL){
            return;
        }
        var that=this, style=comp.get('v.style'), className=comp.get('v.class'), sId=comp.get('v.id')+'_ck', 
        	attributes={tag: comp.get('v.tagName'), body: '', HTMLAttributes: {'data-id': '', 'style': style, 'class': className} };

        $A.createComponent(
            'aura:html', attributes,
            function(newComp){
                if (comp.isValid()) {
                    comp.set("v.body", newComp);
                    if(comp.get('v.checkbox')){
                        that.createCheckboxComponent(comp, newComp, sId);
                    }
                }
            }
        );

    },

    createCheckboxComponent: function(comp, nComp, sId){
        
        var body=nComp.get('v.body'), onclick=comp.getReference('c.event_checkbox_click'), 
            cls=(sId == 'allck_ck' ? 'masscheckbox' : 'masscheckbox msupd'),
            labelAttr={tag: 'label', body: '', HTMLAttributes: {'for': sId} }, 
            checkboxAttr={tag: 'input', body: '', HTMLAttributes: {'id': sId,  'onclick': onclick, 'type': 'checkbox', 'style': 'display:none;', 'class': cls} };

        $A.createComponent(
            'aura:html', checkboxAttr,
            function(newComp){
                if (nComp.isValid()) {
                    body.push(newComp);
                }
            }
        );
        $A.createComponent(
            'aura:html', labelAttr,
            function(newComp){
                if (nComp.isValid()) {
                    body.push(newComp);
                }
            }
        );
        nComp.set("v.body", body);
    },
    
    event_checkbox_click: function(comp, event){
        var id=comp.get('v.id'), target=event.currentTarget, aplCheckedEvent=comp.getEvent('aplCheckedEvent');
        
        aplCheckedEvent.setParams({'id': id, 'checked': target.checked});
        aplCheckedEvent.fire();	// Fire the event
    },

})