/*********************************************************************************************************
      Name : ClsBatch_DeleteMonthlyBBB_data
       Org : C2S
 Copyright : Â© 2013 TE Connectivity 
==========================================================================================================================
   Summary :Batch class is using  for deleting the Last two years data from "BBB_Month_Bill_Book_Cust__c" and 
            "Monthly Billings/Bookings by Part". This batch class called by "Cls_Schedule_DeleteMonthlyBBB_data" Class.
============================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    09/06/2013   Initial Development      R-1244               
******************************************************************************************************************/



Global class ClsBatch_DeleteMonthlyBBB_data implements Database.Batchable<SObject>, Database.Stateful{
    
    Global string Query;
    Global Boolean Call_Query;
    
      
    global ClsBatch_DeleteMonthlyBBB_data(String qry){Query=qry;}
    
    global Database.QueryLocator start(Database.BatchableContext BC){return Database.getQueryLocator(Query);}    
    
    global void execute(Database.BatchableContext BC, list<Sobject> SobjList)
    {
        if(SobjList != null && SobjList.size()>0) 
        delete SobjList;
        Database.emptyRecycleBin(SobjList);
    }     
       
    global void finish(Database.BatchableContext info){
        
        // Retrieve the current job information from "AsyncApexJob" Object. 
        AsyncApexJob Apexjob = [SELECT Id, Status,MethodName, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: info.getJobId()];
        
        // Send an email to the Apex job's submitter notifying of job completion. 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {Userinfo.getuseremail()};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Delete last two years data on MBBB BY Account/part ' + Apexjob.Status);
        mail.setPlainTextBody('"Cls_Schedule_DeleteMonthlyBBB_data"  Apex job processed ' + Apexjob.TotalJobItems + ' batches with '+ Apexjob.NumberOfErrors + ' Errors.');
        if(!test.isRunningTest()){
	        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	    }
    
        Cls_Schedule_DeleteMonthlyBBB_data ClsSD = new Cls_Schedule_DeleteMonthlyBBB_data();
        string Schtime = '0 1 10 1 10 ? '+string.valueof(Date.Today().Year()+1);
        Double RandomNum=Math.random();
        if(Call_Query==true){
            system.schedule('MonthlyBBB delete - '+RandomNum ,Schtime, ClsSD);
        }
	    
    } 
}