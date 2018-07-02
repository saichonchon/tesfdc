({
    
    doCheck :function(component, event, helper) {
        var check;
        var caseId = component.get("v.recordId");
        //  alert('check'+caseId);
        var action1 = component.get("c.checkOwner");
        // alert('check2 '+action1);
        
        action1.setParams({
            caseId : caseId,
            check : check
        });
        
        action1.setCallback(this, function(response) {
            // alert(response.getState());
            if(response.getState() === "SUCCESS") {
                check = response.getReturnValue();
                if(check){
                    component.set("v.stat",'Assigned');
                }
                
                else{
                    component.set("v.stat",'Assign Me');
                }
                component.set("v.disabl",check);
                
                
            }else {//alert(response.getError());
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
                
            }
            
        });
        
        
        $A.enqueueAction(action1);
        $A.get('e.force:refreshView').fire();
        
        
        
    },
    doInit : function(component, event, helper) {
        var caseId = component.get("v.recordId");
        var action = component.get("c.changeOwnerMethod");
        action.setParams({
            caseId : caseId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                
                component.set("v.disabl",'TRUE');
                component.set("v.stat",'Assigned');
                console.log("Case Owner Changed To Current login User");
                var rec = response.getReturnValue();
                console.log(rec.OwnerId);
            }else {//alert(response.getError());
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
                
            }
            
        });
        $A.enqueueAction(action);
        
        $A.get('e.force:refreshView').fire();
    }
})