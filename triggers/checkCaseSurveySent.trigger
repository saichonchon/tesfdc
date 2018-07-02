/**********************************************************************************************************************************************
*******
Name: checkCaseSurveySent
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger updates case survey if status is changed to closed
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra    22/11/2013       Trigger 
 1.1   Mrunal Parate      20/04/2015       Trigger Modified for Case 00783725 to sent Survey only when the Case status = 'Closed'
 1.2   Padmaja            17/08/2015       Trigger Modified for PIC migration                   
***********************************************************************************************************************************************/
trigger checkCaseSurveySent on Case (before update){
    set<Id> conIds= new set<Id>();
    Map<Id,Contact> mapcon;
    //piccontactids added by Padmaja for PIC migration project on 17/08/2015 , cis_picIds added by 
     Set<Id> piccontactids=new Set<Id>();
     // Set<Id> cis_picIds=new Set<Id>();  // Pidikiti, Rajesh has commented this code for case# 00901186
     Id PICrecId = Apex_Helper_Settings__c.getInstance('PIC Service Cloud').Value__c;     
     Id ccrecId = Apex_Helper_Settings__c.getInstance('Customer Care Cloud').Value__c;
     Id cccrecId = Apex_Helper_Settings__c.getInstance('Customer Care Cloud -Case Close').Value__c;
    for(case c:trigger.new){
        system.debug('-------con'+c.contactId+'--'+c.status);
        // Changed if Condition from (c.isClosed == true||c.status=='Closed') to (c.status=='Closed') for Case 00783725 By Mrunal Parate,Pic recordtype condition added by Padmaja for PIC migration
        if(c.status=='Closed' && trigger.oldmap.get(c.Id).isClosed==false && trigger.oldmap.get(c.Id).status!='Closed' && c.Survey_Sent__c==False && c.contactId!=null){
            if(c.RecordtypeId==ccrecId || c.RecordtypeId==cccrecId)
                conIds.add(c.contactId);
            if(c.RecordtypeId==PICrecId)
                piccontactids.add(c.contactid);      
        }
        /*
        //added below condition for case 900400
         if(c.status=='Closed-Inside Sales' && trigger.oldmap.get(c.Id).isClosed==false && trigger.oldmap.get(c.Id).status!='Closed-Inside Sales' && c.Survey_Sent__c==False && c.contactId!=null){         
             if(c.RecordtypeId==PICrecId)            
                 cis_picIds.add(c.contactid);            
         }
         */ // Pidikiti, Rajesh has commented this code for case# 00901186       
    }
    try
    {
        //if(!conIds.isEmpty() || !piccontactids.isEmpty() || !cis_picIds.isEmpty()){ // Pidikiti, Rajesh has commented this code for case# 00901186
        if(!conIds.isEmpty() || !piccontactids.isEmpty()){
            //mapcon=new Map<Id,Contact>([select id,Survey_Sent__c,email,Date_of_Last_Survey__c,RecordTypeId,Survey_Sent_PIC__c,Date_of_Last_Survey_PIC__c from Contact where (id=:conIds OR id=:piccontactids OR id=:cis_picIds) AND Survey_Sent__c=false AND Customer_Survey_Opt_Out__c= false]); // Pidikiti, Rajesh has commented this code for case# 00901186
            mapcon=new Map<Id,Contact>([select id,Survey_Sent__c,email,Date_of_Last_Survey__c,RecordTypeId,Survey_Sent_PIC__c,Date_of_Last_Survey_PIC__c from Contact where (id=:conIds OR id=:piccontactids) AND Survey_Sent__c=false AND Customer_Survey_Opt_Out__c= false]);
            System.debug('#####'+mapcon);
            for(case c:trigger.new){
                //added condition on 8/26/2014 for controlling survey emails to internal contacts
                // Changed if Condition from (c.isClosed == true||c.status=='Closed') to (c.status=='Closed') and added one more condition (trigger.oldmap.get(c.Id).isClosed==false) for Case 00783725 By Mrunal Parate, Pic recordtype condition added by Padmaja for PIC migration project on 17/08/2015, Value "c.status=Closed-Inside Sales" added by Nooreen for case 900400
                /*
                if(mapcon.containsKey(c.contactId) && (c.RecordTypeId==ccrecId || c.RecordTypeId==cccrecId || c.RecordTypeId==PICrecId) && c.Survey_Sent__c==False && (c.status=='Closed' || c.status == 'Closed-Inside Sales') && trigger.oldmap.get(c.Id).isClosed==false && mapcon.get(c.contactId).email!=null &&
                (!mapcon.get(c.contactId).email.contains('@te.com')) && (!mapcon.get(c.contactId).email.contains('@tycoelectronics.com'))){
                */ // Pidikiti, Rajesh has commented this code for case# 00901186  
                
                if(mapcon.containsKey(c.contactId) && (c.RecordTypeId==ccrecId || c.RecordTypeId==cccrecId || c.RecordTypeId==PICrecId) && c.Survey_Sent__c==False && c.status=='Closed' && trigger.oldmap.get(c.Id).isClosed==false && mapcon.get(c.contactId).email!=null &&
                (!mapcon.get(c.contactId).email.contains('@te.com')) && (!mapcon.get(c.contactId).email.contains('@tycoelectronics.com'))){     
                     c.Survey_Sent__c=True;
                     mapcon.remove(c.contactId);
                     System.debug('&&&&*****&&&&&&');
                 }
            }
       }             
    }
    catch(Exception e){
         CCP_Exception_Util.CCP_Exception_Mail(e);
    }
}