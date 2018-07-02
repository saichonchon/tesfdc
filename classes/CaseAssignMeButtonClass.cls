/************************************************************************************************************************************************************************************************************************
Class Name: CaseAssignMeButtonClass
Test Class Coverage: 
Copyright © 2018 TE Connectivity | Salesforce Instance : C2S Org
===========================================================================================================================================================================================================
Purpose: This class is intended for the functionality of updating the caseOwnerId will be refered from Lightining component 
===========================================================================================================================================================================================================
VERSION       AUTHOR                      DATE                                   
 1.0          Vinod Kumar               22/01/2018  
*/

public class CaseAssignMeButtonClass {
   
    @AuraEnabled   
    public static boolean checkOwner(Id caseId, Boolean check){
        
       // boolean disab;
        if(caseId != null) {
            Case c = [SELECT id,OwnerId FROM Case WHERE Id = :caseId];
            if( c.OwnerId == UserInfo.getUserId()){check=TRUE;
            }
            else{
                check=FALSE;
            }
        }
        system.debug('bool from c '+caseId + check);
        return check;
    }
    
    @AuraEnabled
    public static Case changeOwnerMethod(Id caseId) {
        
        if(caseId != null) {
            Case c = [SELECT id,OwnerId FROM Case WHERE Id = :caseId];
            c.OwnerId = UserInfo.getUserId();
            
            //update case Ownerid with loggedin userid.
            try{
                update c;
                system.debug('updated case '+c);
                return c;
            }
            catch (DmlException e) { throw new AuraHandledException('Error :'+ e.getDmlMessage(0));
            }        
        }
        return null;
    }
}