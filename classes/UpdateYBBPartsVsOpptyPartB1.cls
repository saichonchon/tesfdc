/***********************************************************************************************************************
      Name : UpdateYBBPartsVsOpptyPartB1
       Org : C2S
 Copyright : © 2014 TE Connectivity 
========================================================================================================================
   Summary : Batch class to update the fields for Average Cost and Average Margin on the Opportunity Part object.
             The fields get the values upon rollups of YBB records having Bill Type=Direct.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL                                       User Story #                  
________________________________________________________________________________________________________________________
     1.0 Chiranjeevi  2013-09-07 Initial Development                              1200 
     1.1 Nooreen      2014-08-04 Updated to copy values                           1200
                                 from formula fields on Opportunity Part.   
     1.2 Nooreen      2015-04-07 Updated class for calculation through        Case# 00765212      
                                 batch instead of rollup fields on Part object.                                          
***********************************************************************************************************************/
global class UpdateYBBPartsVsOpptyPartB1 implements Database.Batchable<sObject>,Database.Stateful{

   global String QueryString;
   global Boolean istest;
   //Set<Id> partsIdSet = new Set<Id>();
   Map<Id,Decimal> avgCostMap = new Map<Id,Decimal>();
   Map<Id,Decimal> avgMarginMap = new Map<Id,Decimal>();
   List<Part__c> partList = new List<Part__c>(); 
   global static map<String, Apex_Helper_Settings__c> HelperSettingsmap = Apex_Helper_Settings__c.getall(); 
   public static String filter = '';
   public map<string, string> mapError = new map<string, string>();
   public string executionName = '';
   global Database.QueryLocator start(Database.BatchableContext BC){
        if(QueryString == null || QueryString == ''){
            QueryString = 'Select Id from Part__c';
        }
       return Database.getQueryLocator(QueryString+filter);  
   }
   
   global void execute(Database.BatchableContext BC, List<Part__c> scope){
      
       ID partId;
       List<Part__c> updatePartsList = new List<part__c>();
       List<Opportunity_Part__c> updateOppPartsList = new List<Opportunity_Part__c>();     
       System.debug('*****sssss****'+scope);
       map<id, Part__c> mapPart = new map<id, Part__c>(scope);
           
       AggregateResult[] ybbQueryResult = [Select SUM(Bill_Amount_on_YBB__c) ybbAmount ,SUM(Bill_Cost_on_YBB__c) ybbCost ,SUM(Bill_Quantity_on_YBB__c) ybbQuantity,Part__c 
                                           From BBB_Year_Bill_Book_Cust_PN__c 
                                           Where Bill_Type__c = 'Direct' and Part__c in : mapPart.keyset()
                                           Group By Part__c ];     
       system.debug('*****ybbQueryResult*******'+ybbQueryResult);
    
       for(AggregateResult ar : ybbQueryResult){
        Decimal totalYbbAmount = 0.0;
        Decimal totalYbbCost = 0.0;   
        Decimal totalYbbQuantity = 0;
        Decimal avgCost = 0.0;
        Decimal avgMargin = 0.0;
        totalYbbCost  = (Decimal)ar.get('ybbCost');        
        totalYbbQuantity = (Decimal)ar.get('ybbQuantity');    
        totalYbbAmount = (Decimal)ar.get('ybbAmount');  
        partId = (ID)ar.get('Part__c');     
        
        Part__c oPart = mapPart.get(partId);

        if(totalYbbQuantity > 0)
            oPart.Avg_Cost__c = totalYbbCost/totalYbbQuantity ; 
        else
            oPart.Avg_Cost__c = 0; 
           
        if(totalYbbAmount > 0)
           oPart.Avg_Margin__c = (totalYbbAmount-totalYbbCost)/totalYbbAmount; 
        else
           oPart.Avg_Margin__c = 0;

        updatePartsList.add(oPart);
       } 
 
      if(updatePartsList.size()>0){                          
       Database.SaveResult[] srList = Database.update(updatePartsList,false);  
           for(Database.SaveResult sr : srList){
                if(!sr.isSuccess()) {                   
                   for(Database.Error err : sr.getErrors()) 
                       mapError.put(sr.getId(), (mapError.get(sr.getId()) + err.getStatusCode() + ': ' + err.getMessage()));
                }             
           }
       }              
   }   
   
   global void finish(Database.BatchableContext BC){        
            
        List<String> Strmap = new List<String>();
        Strmap.add('Quarterly-1 Month');
        Strmap.add('Quarterly-2 Month');
        Strmap.add('Quarterly-3 Month');
        Strmap.add('Quarterly-4 Month');       
        Map<String, String> StrMap2= new Map<String, String>();
        StrMap2.put('Quarterly-1 Month', 'Quarterly-1 Date');
        StrMap2.put('Quarterly-2 Month', 'Quarterly-2 Date');
        StrMap2.put('Quarterly-3 Month', 'Quarterly-3 Date');
        StrMap2.put('Quarterly-4 Month', 'Quarterly-4 Date');       
        
        DateTime CurrentDT = DateTime.Now();                        
        DateTime ValidDate;
        DateTime NextDate;   
        DateTime LastQuarterDate;
        Boolean ActiveFlag=TRUE;          
        Apex_Helper_Settings__c CustRecTemp = HelperSettingsmap.get('Quarterly-4 Month');
        
        LastQuarterDate = datetime.valueOfGMT(String.valueOf(CurrentDT.year())  + '-' + CustRecTemp.value__c + '-' + HelperSettingsmap.get(StrMap2.get('Quarterly-4 Month')).value__c + ' ' + '1' + ':' + '1' +  ':' + '1');
        System.debug('******** LastQuarterDate ***'+ LastQuarterDate );
            
        for(String S:Strmap){
            if(ActiveFlag==TRUE){
                Apex_Helper_Settings__c CustRec = HelperSettingsmap.get(S);                   
                System.debug('********CustRec***'+CustRec);
                
                ValidDate = datetime.valueOfGMT(CurrentDT.year()  + '-' + CustRec.value__c + '-' + HelperSettingsmap.get(StrMap2.get(S)).value__c + ' ' + '1' + ':' + '1' +  ':' + '1');
                System.debug('********ValidDate***'+ValidDate);
                if(ValidDate>=CurrentDT){
                    ActiveFlag=False;
                    NextDate=ValidDate;
                    System.debug('********NextDate***'+NextDate);
                }  
                if(CurrentDT >= LastQuarterDate){
                    String Year;
                    if(String.valueOf( CurrentDT.Month()) >= CustRecTemp.value__c ){
                        Year = String.valueOf( CurrentDT.year()+1);
                    }
                    else{
                        Year = String.valueOf( CurrentDT.year());
                    }
                    System.debug('***Year***'+Year);
                    ValidDate = datetime.valueOfGMT(Year  + '-' + HelperSettingsmap.get('Quarterly-1 Month').value__c + '-' + HelperSettingsmap.get(StrMap2.get('Quarterly-1 Month')).value__c + ' ' + '1' + ':' + '1' +  ':' + '1');                   
                    ActiveFlag=False;
                    NextDate=ValidDate;
                    System.debug('********NextDate-Last Q***'+NextDate);
                }
            }
        }
        
        String BatchName= executionName + 'AvgCost Batch Run on ['+String.valueof(NextDate)+']';
        String NextSchedulesch = String.valueof(NextDate.second())+' '+String.valueof(NextDate.Minute())+' '+String.valueof(NextDate.Hour())+' '+String.valueof(NextDate.Day())+' '+String.valueof(NextDate.Month())+' ? '+String.valueof(NextDate.year());   
        String NextScheduleschEmailALert3days = String.valueof(NextDate.second())+' '+String.valueof(NextDate.Minute())+' '+String.valueof(NextDate.Hour())+' '+String.valueof(NextDate.addDays(-3).Day())+' '+String.valueof(NextDate.Month())+' ? '+String.valueof(NextDate.year());   
        String NextScheduleschEmailALert1day = String.valueof(NextDate.second())+' '+String.valueof(NextDate.Minute())+' '+String.valueof(NextDate.Hour())+' '+String.valueof(NextDate.addDays(-1).Day())+' '+String.valueof(NextDate.Month())+' ? '+String.valueof(NextDate.year());   
        
        clsscheduled_SendScheduledEmailAlert oclsscheduled_SendScheduledEmailAlert3days = new clsscheduled_SendScheduledEmailAlert();
        oclsscheduled_SendScheduledEmailAlert3days.BatchName = 'UpdateYBBPartsVsOpptyPartB1EmailAlert';
        oclsscheduled_SendScheduledEmailAlert3days.EmailSubject = BatchName;
        oclsscheduled_SendScheduledEmailAlert3days.EmailBody = 'Hi, \n\nBatch Run for Average Cost and Margin: \nThis is to inform you that batch job for Average Cost and Average Margin is scheduled to run after 3 days. \n\nRegards';
        
        clsscheduled_SendScheduledEmailAlert oclsscheduled_SendScheduledEmailAlert1day = new clsscheduled_SendScheduledEmailAlert();
        oclsscheduled_SendScheduledEmailAlert1day.BatchName = 'UpdateYBBPartsVsOpptyPartB1EmailAlert';
        oclsscheduled_SendScheduledEmailAlert1day.EmailSubject = BatchName;
        oclsscheduled_SendScheduledEmailAlert1day.EmailBody = 'Hi, \n\nBatch Run for Average Cost and Margin: \nThis is to inform you that batch job for Average Cost and Average Margin is scheduled to run after 1 day. \n\nRegards';
        
        //sending alert prior to batch  run
        system.schedule(BatchName + ' 3 days alert', NextScheduleschEmailALert3days, oclsscheduled_SendScheduledEmailAlert3days);
        system.schedule(BatchName + ' 1 day alert', NextScheduleschEmailALert1day, oclsscheduled_SendScheduledEmailAlert1day);
        
        QuarterlyTriggerScedularS1 p = new QuarterlyTriggerScedularS1();        
        system.debug('-----------'+NextSchedulesch+'--------'+String.valueof(NextDate));
        //Scheduling the batch for next run
        system.schedule(BatchName, NextSchedulesch, p);
        
        if(mapError.size() > 0){
            Batch_Email_message_Users__c oBatchEmailmessageUsers = Batch_Email_message_Users__c.getValues('Error_UpdateYBBPartsVsOpptyPartB1');
            if(oBatchEmailmessageUsers != null && oBatchEmailmessageUsers.Email_ID__c != null){
                string strEmailBody = '';
                for(string strPartID :mapError.keyset())
                    strEmailBody += strPartID + '-' + mapError.get(strPartID) + '\n';
                    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> lstToAddresses = oBatchEmailmessageUsers.Email_ID__c.split(';');
                mail.setToAddresses(lstToAddresses);
                mail.setSubject('Some error occurred during batch job UpdateYBBPartsVsOpptyPartB1');
                mail.setPlainTextBody('Hi, \n\nSome error occurred during batch run of class UpdateYBBPartsVsOpptyPartB1. Please see details below. \n\n' + strEmailBody + '\n\nRegards');
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
   }
}