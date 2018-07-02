/************************************************************************************************************************************************************************************************************************
Name: CaseTrigger
===========================================================================================================================================================================================================
Purpose: This trigger was part of Central org and moved in C2S for PIC Migration for Case object. 
The methods are provided in CaseServices class and would be used to fill business hours,owner lookup and create case from live chat transcript for Pic.
===========================================================================================================================================================================================================
Author: 2012-08-09: Dmytro Smirnov - Initial Development.
Modified : 2015-08-10 : Nooreen Shaikh - Commented some below methods as C2S has separate triggers defined on Case object.

***********************************************************************************************************************************************************************************************************************/

trigger CaseTrigger on Case (before insert, before update) {
    
    String vStrError = ''; 
    Boolean isWithin;
    BusinessHours stdBusinessHours = [SELECT Id, Name, MondayStartTime, MondayEndTime, TuesdayStartTime, TuesdayEndTime, WednesdayStartTime, WednesdayEndTime, ThursdayStartTime, ThursdayEndTime, FridayStartTime, FridayEndTime FROM BusinessHours where name ='ICT Business Hours' limit 1];                                                                                       
    system.debug('==stdBusinessHours===>'+stdBusinessHours); 
    Timezone tz = Timezone.getTimeZone('America/New_York');
    Datetime now = Datetime.now();
    Integer offset = tz.getOffset(now);
    Datetime targetDate = now.addSeconds(offset/1000);
    
    
    
    system.debug('==now===>'+now );   
    system.debug('==targetDate===>'+targetDate );   
    
    Try{
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                CaseServices.updateContact(Trigger.new);
                //Method added to capture existing contact for new webform from TE site
            }
            //Some of the below methods have been commented as in C2S separate triggers are already present for same functionality defined in methods-comment added by Nooreen
            //method commented for originating queue as its populated using workflow-comment added by Nooreen
            //if( !Trigger.isDelete ){ //For future
            //CaseServices.updateCaseTimes( Trigger.isInsert, Trigger.new, Trigger.oldMap );
            //CaseServices.fillinOriginatingQueue( Trigger.new, Trigger.oldMap );
            //CaseServices.roundRobin( Trigger.isUpdate, Trigger.new, Trigger.oldMap );
            CaseServices.fillinOwnerLookup( Trigger.new, Trigger.oldMap );
            //}
            if( Trigger.isUpdate ){
                CaseServices.fillinBusinessHoursLookup( Trigger.new );                             
            }
        }        
       
        //Adding Logic for Business Hours -Capgemini
        string EntitlemntId= [SELECT Id,  name, BusinessHours.Name From Entitlement where name ='ICT Entitlement' and BusinessHours.Name='ICT Business Hours' Limit 1].Id;
        //List<Case>updateCaseList=new List<Case>();
        for (Case c: Trigger.New){
            system.debug('==CaseDetails=='+c.TE_Enquiry_Flag__c+c.Origin+c.Priority+c.Status);
            
            if(c.TE_Enquiry_Flag__c==true && c.Origin=='Web' && c.Priority=='Medium' && c.Status=='Assigned'){            
               
                    c.BusinessHoursId=stdBusinessHours.id; 
                    if(EntitlemntId!=null) c.EntitlementId =EntitlemntId;
                   system.debug('==BusinessHoursId===>'+c.BusinessHoursId);     
               
            }
            
        }
    
    }
    Catch(Exception Error){
        vStrError += 'Error Type = ' + Error.getTypeName();                                                                     
        vStrError += 'Error Line = ' + Error.getLineNumber() + '';                                                              
        vStrError += 'Error Stack = ' + Error.getStackTraceString(); 
        vStrError += 'Error Message = ' + Error.getMessage();
        
        SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                     SalesforceConstant.strError, '', '', '', '5','','','Exception', Error.getLineNumber() + '',Error.getStackTraceString());  
        
    }
}