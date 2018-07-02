/**********************************************************************************************************************************************
*******
Name: bucketAccountupdate
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger updates case account id if case contact Account Id belongs to PIC Universal Customer Account
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Padmaja Dadi        20/08/2015       Trigger
  
 @changelog
 * 2016-16-09 Srinath Thallapally <srinath.thallapally@te.com> - added IF condition at line 25.  to bypass this tigger while  "BatchCls_DeleteSObjects" batch process is running     
                   
***********************************************************************************************************************************************/

trigger bucketAccountupdate on Case (before insert,before update)
{   
    Set<ID> Conids=new Set<ID>();
    Id PICUniverId = Apex_Helper_Settings__c.getInstance('PIC Universal Customer Account').Value__c; 
    Id CCInternalAccId=Apex_Helper_Settings__c.getInstance('Internal Account').Value__c;   
    if(StaticBooleanValue.checkflag == true){
    for (Case cas : Trigger.new)
    {
      Conids.add(cas.ContactId);
      System.debug('******Conids*****'+Conids);
     }
     
     if(Conids!=null){
        Map<ID, Contact> conMap=new Map<ID, Contact>([select Id,AccountId,Account.Primary_Account__c from Contact where ID In :Conids]);
        for (Case c : Trigger.new) {        
            if(conMap!=null){
                if(c.ContactId != null){
                     if(conMap.get(c.ContactId).AccountId==PICUniverId ||conMap.get(c.ContactId).AccountId==CCInternalAccId) { 
                         c.AccountId=conMap.get(c.ContactId).Account.Primary_Account__c;
                     }
                }
            }
        }  
     } 
     }  
}