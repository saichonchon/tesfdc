/**
 * This class is used for updating Account lookups to Sales hierarchy to null when TED update text fields to null
 *  
 * @author Anil Kumar Attelli (anil.attelli@zensar.in)
 * @created 2014-04-01
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 */
global class ClsBatch_Accountupdate_saleshierarchy implements Database.Batchable<SObject>{
    
  public String query;
 // public List<Account> acc;
  Apex_Helper_Settings__c accountRT = Apex_Helper_Settings__c.getInstance('Account Record Type Id');
  
  global String recordtypeId = accountRT.value__c;   
  
   // global String accountId= '001g000001j3jFpAAI';   
  
  global Database.QueryLocator start(Database.BatchableContext BC){ 
    
       System.debug('accountRT899909009'+accountRT);
    if (query == '' || query == null){
        
        query = 'Select Id, Sales_Hierarchy__c, Relay_Hierarchy__c, FE_Hierarchy__c,Parent__c,Parent.GAMCD__c, FE_Hierarchy__r.Level_7_Territory_code__c , Sales_Hierarchy__r.Level_7_Territory_code__c ,ParentId, Relay_Hierarchy__r.Level_7_Territory_code__c , Sales_Hierarchy_GAM__c,Sales_Hierarchy_MM__c,SALES_TERRITORY_CDE__c,GAMCD__c,Relay_Specialist_Territory_Code__c,MKTMGRCDE__c,ACCTMGRCD__c from Account where RecordTypeId=\''+recordtypeId+'\'';
        
        //where RecordTypeId =\''+recordtypeId+'\''; //where (SALES_TERRITORY_CDE__c = null OR GAMCD__c = null OR Relay_Specialist_Territory_Code__c = null OR ACCTMGRCD__c = null)';
         
              if(Test.isRunningTest()){
           query+=' limit 200';
        }
           
    }
      System.debug('query'+query);
      System.debug('results'+Database.getQueryLocator(query));
      return Database.getQueryLocator(query);  
  }

  global void execute(Database.BatchableContext BC, List<Account> scope){
      system.debug('sccccc'+scope);
    List<Account> accsToUpdate = new List<Account>();
    Boolean vFlag;
     
     for(Account a : scope){ 
            system.debug('bbbbbb'+scope);
           vFlag = false;
               
          if(a.Sales_Hierarchy__c != null && (SalesforceUtil.isNull(a.SALES_TERRITORY_CDE__c) || a.SALES_TERRITORY_CDE__c != a.Sales_Hierarchy__r.Level_7_Territory_code__c)){
               system.debug('aaaaaaa'+a.Sales_Hierarchy__c);
              a.Sales_Hierarchy__c=null;
              vFlag = true;
           }
                   
           
           if(a.ParentId != null && (SalesforceUtil.isNull(a.GAMCD__c) || a.GAMCD__c  != a.Parent.GAMCD__c)){
             a.ParentId =null;
             vFlag = true;
           }
                      
           if(a.Relay_Hierarchy__c != null && (SalesforceUtil.isNull(a.Relay_Specialist_Territory_Code__c) || a.Relay_Specialist_Territory_Code__c != a.Relay_Hierarchy__r.Level_7_Territory_code__c)){
              a.Relay_Hierarchy__c=null;
              vFlag = true;
           }
                      
           if(a.FE_Hierarchy__c != null && (SalesforceUtil.isNull(a.ACCTMGRCD__c) || a.ACCTMGRCD__c != a.FE_Hierarchy__r.Level_7_Territory_code__c)){
              a.FE_Hierarchy__c=null;
              vFlag = true;
           }
           
           If(vFlag == true){
           accsToUpdate.add(a); 
           }
       }
       if(accsToUpdate != null || accsToUpdate.size()>0){ 
          try{
          System.debug('@@@@ updated accounts @@@@'+accsToUpdate.size());
          System.debug('@@@@ updated accounts @@@@'+accsToUpdate);
          update accsToUpdate;
           
          }
          catch(exception E){
                Catchblocktest_Handler.sendemail(E.getmessage());
          }
       }
  }

    global void finish(Database.BatchableContext info){ 
    
        System.debug('@@@'+info.getJobId());
        
        // Retriving the current job information from "AsyncApexJob" Object. 
        AsyncApexJob Apexjob = [SELECT Id, Status,MethodName, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: info.getJobId()];
        
        
        // Send an email to the Apex job's submitter notifying of job completion. 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(Userinfo.getuserId());
        mail.setSubject('Accounts Update with sales hierarchies ' + Apexjob.Status);
        mail.setPlainTextBody('"ClsBatch_Accountupdate_saleshierarchy "  Apex job processed ' + Apexjob.TotalJobItems + ' batches with '+ Apexjob.NumberOfErrors + ' Errors.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           
    }    
}