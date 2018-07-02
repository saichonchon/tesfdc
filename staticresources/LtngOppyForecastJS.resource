(function(w){
    "use strict"; //Optional because LC on LockerService active runs in strict mode

    var utilMethods = {
        
    	'event_document_resize': function (dt){
	        var leftTabWidth=document.getElementById('leftTab').offsetWidth;
	        document.getElementById('rigthScroll').style.width = (w.innerWidth - leftTabWidth - 40)+'px';        
	    },
	    
	    'event_fixedHeight_layout': function (dt){

	    	var height='auto', fullScreen=(w.location.pathname.indexOf('ExtOppyForecastEntry_Ltng') != -1 ? 'Back to Opportunity' : 'Full Screen'),
	    		fcBody=(document.getElementById('viewFcBody') ? document.getElementById('viewFcBody') : document.getElementById('editFcBody'));
	    		
	    	
	    	dt['comp'].find('screenBtn').getElement().innerHTML = fullScreen;
	    	
	    	if(w.location.pathname.indexOf('ExtOppyForecastEntry_Ltng') == -1){
	    		height = (w.innerHeight > 300 ? (w.innerHeight-80)+'px' : height);
	        }
	        
	        fcBody.style.height = height;
	    },
		
	    'event_fullscreen_click': function(dt) {
        
	        if(w.location.pathname.indexOf('ExtOppyForecastEntry_Ltng') != -1){
	            w.location.href = '/'+dt['comp'].get('v.originalId');
	            return;
	        }
	        
			var vfPageEvt=$A.get("e.c:LtngOpportunityForecastVfPageEvt");
	        vfPageEvt.setParams({ param: 'full' });
	        vfPageEvt.fire();	// Fire the event
		},
	    
		'event_displayfc_click': function(dt) {
	        var target=dt['event'].currentTarget, id=target.getAttribute('id');
	        if(target.checked){
	            isExp(true, id);
	            return;
	        }
	
	        isExp(false, id);
	        
	        function isExp(flg, id){
	            var vTarget=dt['comp'].get('v.target');
	            if(id == 'total'){
	                vTarget.isExp = flg;
	                dt['comp'].set('v.target', vTarget);
	                
	                $A.util.toggleClass(target.parentNode.parentNode, 'slds-border-bottom-transparent');
	                $A.util.toggleClass(target.parentNode.parentNode.nextSibling, 'slds-border-bottom-transparent');
	                return;
	            }
	            
	            var list_trs=document.querySelectorAll('#viewFcBody tr.'+id);

	            list_trs = (list_trs.length == 0 ? document.querySelectorAll('#editFcBody tr.'+id) : list_trs);
	            
	            if(flg){
	                $(list_trs).removeClass('custom-display-none');
	            }else{
	                $(list_trs).addClass('custom-display-none');
	            }
	            
	        }
	        
		},
		
		'event_edit_click': function(dt) {
	        var modeEvent=dt['comp'].getEvent("modeEvent"), vTarget=dt['comp'].get('v.target');
	        
	        if(vTarget['notifyContactRoleMessage']){
	        	dt['comp'].find('notifyMessage').elements[0].innerHTML = vTarget['notifyContactRoleMessage'];
	        	$A.util.removeClass(dt['comp'].find('notifyAlert'), 'slds-hide');
	        	return;
	        }
	        
	        var o={'isView': false, 'isAPL': vTarget['isAPL'], 'isShowMussUpdate': vTarget['isShowMussUpdate']};
	        o['isShowMussUpdate'] = (vTarget['isIND'] ? false : true);
	        modeEvent.setParams(o);
	        modeEvent.fire();	// Fire the event
		},
		
		'event_mouse_over': function(dt) {
	        var target=dt['event'].currentTarget, rowIndex=target.rowIndex;
	        if($A.util.hasClass(target, 'custom-table-left')){
	        	$('#rigthScroll table tr:eq('+rowIndex+')').addClass('in');
	        }else{
                $('#leftTab tr:eq('+rowIndex+')').addClass('in');
	        }
		},
		
	    'event_mouse_out': function(dt) {
			var target=dt['event'].currentTarget, rowIndex=target.rowIndex;
	        if($A.util.hasClass(target, 'custom-table-left')){
	        	$('#rigthScroll table tr:eq('+rowIndex+')').removeClass('in');
	        }else{
	        	$('#leftTab tr:eq('+rowIndex+')').removeClass('in');
	        }
		},
		
	    'ltngAction': function(action, comp, event, param, callResult, callError, finallyCall){
	        action.setParams({ "param" : JSON.stringify(param) });
	        action.setCallback(this, function(response) { 
	            var state = response.getState();
	            if (comp.isValid() && state === "SUCCESS") {  
	                var values=response.getReturnValue();
					callResult(values);
	            } else if (state === "ERROR") { 
	                var errors = response.getError(), message='Unknown error.';
	
	                if (errors) {
	                    if(errors[0]['message']){
	                        message = errors[0]['message'];
	                    }else if(errors[0]['pageErrors'].length != 0){
	                        message = errors[0]['pageErrors'][0]['message'];
	                    }else if(errors[0]['fieldErrors']){
	                        for(var field in errors[0]['fieldErrors']){
	                            message += field+' in '+errors[0]['fieldErrors'][field][0]['message'];
	                        }                    		
	                    }
	                }
	                callError(message);
	                console.log('ltngAction ->', message);
	            }
	            finallyCall();
	        });
	        $A.enqueueAction(action);// Enqueue the action
	        
	    },
	    
	    
	    
	    
	    
	    
	    
    	'addListener': function (element, event, fn, params) {
        
	        var debounce = function (func, threshold, execAsap) {
				var timeout;
	          	return function debounced () {
					var obj=this, args=arguments;
	                params['that'] = obj;
	              	function delayed () {
	                	if (!execAsap)
	                    	func.apply(params, args);
	                  		timeout = null;
	              	};
	    
	              	if (timeout) clearTimeout(timeout);
	              	else if (execAsap) func.apply(params, args);
	              	timeout = setTimeout(delayed, threshold || 100);
				};
	      	}
	
	        
		    if (window.attachEvent) {
		        element.attachEvent('on' + debounce(fn));
		    } else {
		        element.addEventListener(event, debounce(fn), false);
		    }
	        
		}
    	
    };

    
    
    
    
    

    w.ltngUtil = utilMethods;

})(window);


