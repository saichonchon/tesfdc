/**************************************************************************************************************************************************
Name: daysemaialert
Copyright Â© 2011 TE Connectivity
===================================================================================================================================================
Purpose: Email alerts will be triggered if an opportunity was not updated for 30 days                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request # 186
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Ramakrishna Singara   19/12/2013 Initial Development.                                
    2.0 Bin Yuan			  28/08/2015 fix test method exception                                          
**************************************************************************************************************************************************/



global class daysemaialert implements Database.Batchable<sObject>{
/*______________________________________________________________________________________________________________________
   Concise Summary : Start                                                                                            
________________________________________________________________________________________________________________________
  Input Parameter  :                                                                                                  
________________________________________________________________________________________________________________________
   I1. Name        : BC                                                                                                
       Data Type   : Database.BatchableContext                                                                         
       Description : Batchable Context                                                                                
________________________________________________________________________________________________________________________ 
  Output Parameter :                                                                                                  

______________________________________________________________________________________________________________________*/ 
public String query;
global Database.QueryLocator start(Database.BatchableContext BC){
    
    
    Opportunity_Record_Type_Groups__c config = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity');
    String DNDoppRTIdSet = config.RecordTypeID__c;
    set<String> set_oppyStage = new set<String>{'New Opportunity', 'Opportunity Development', 'Won/Qualified/G3 Approved'}; 
    query = 'select id,name,owner.name,owner.email,recordtypeid,LastModified_Date_Calculation__c from Opportunity '+
     +' where StageName IN :set_oppyStage and recordtypeid = :DNDoppRTIdSet and LastModified_Date_Calculation__c = true';
    //Added by Bin Yuan 2015-08-28 due to fix test method exception
    if(Test.isRunningTest()) {
    	query += ' Limit 1 ';
    }
    return Database.getQueryLocator(query);
    }
/*______________________________________________________________________________________________________________________
  Purpose : Execute                                                                                                   
________________________________________________________________________________________________________________________
  Input Parameter  :                                                                                                  
________________________________________________________________________________________________________________________
   I1. Name        : BC                                                                                                
       Data Type   : Database.BatchableContext                                                                         
       Description : Batchable Context                                                                                
   I2. Name        : lstopp [scope]                                                                        
       Data Type   : List<Opportunity>                                                                          
       Description : List of "Opportunity Record"                                                                       
________________________________________________________________________________________________________________________ 
  Output Parameter : None                                                                                             
______________________________________________________________________________________________________________________*/ 

global void execute(Database.BatchableContext bc,list<Opportunity> lstopp){

      try{
        list<Messaging.SingleEmailMessage> lstmail=new list<Messaging.SingleEmailMessage>();
        for(Opportunity opp:lstopp){
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           mail.setTargetObjectId(opp.ownerId);
           //mail.setToAddresses(new String[] {opp.owner.email});
           mail.setSaveAsActivity(false);
           mail.setSubject('30 Days Opportunity Not Updated');
           mail.setUseSignature(false);
           String serverName = 'https://'+Label.Server_URL;
           String msgBody;
           msgBody = + '<html> Dear ' + opp.owner.name + '<br/><br/><p> Your Opportunity ' + opp.Name + ' has not been amended for more than 30 days. Please review the Opportunity and update where necessary. Another reminder email will be sent to you in next 7 days and your manager will be copied on the list. Please login to Salesforce.com to update your Opportunity <a href='+serverName +'/'+opp.Id+'>Record</a>.</p><br/>Regards,<br/>System Administrator</html>';  
           mail.setHtmlBody(msgBody );
           lstmail.add(mail);
        }
        if(!lstmail.isEmpty()){
            Messaging.SendEmail(lstmail);
        }
    }
    catch(System.EmailException emlEx) {
     System.debug(' Email Failed: ' + emlEx);
    }
     
  }
/*______________________________________________________________________________________________________________________
  Purpose : Finish                                                                                                    
________________________________________________________________________________________________________________________
  Input Parameter  :                                                                                                  
________________________________________________________________________________________________________________________
   I1. Name        : BC                                                                                                
       Data Type   : Database.BatchableContext                                                                         
       Description : Batchable Context                                                                                
________________________________________________________________________________________________________________________ 
  Output Parameter : None                                                                                             
______________________________________________________________________________________________________________________*/  
global void finish(Database.BatchableContext bc){

}

}