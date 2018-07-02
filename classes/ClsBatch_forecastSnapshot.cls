/** 
*    batch class for forecast snapshot
*
@author Xia Tong
@created 2013-01-09 
@version 1.0
@since 26.0 (Force.com ApiVersion)
*
@changelog
* 2013-01-09 Xia Tong <xia.tong@itbconsult.com>
* - Created
* 2013-02-18 Bin Yu <bin.yu@itbconsult.com>
* - added the the date fields "Date", "Fiscal Year", "Fiscal Quarter"
* 2014-01-06 shreyas Mangalvedhekar <shreyas.mangalvedhekar@te.com>
*- added the the logic to work with CSD type as well
* 2014-05-12 Bin Yuan<bin.yuan@itbconsult.com>
*- added PMV record type into query
* 2015-06-02 Mrunal Parate  
* - modified - Changed logic by replacing hardcoded Record types with Custom setting containing same record type along with new record type 'Channel_Sales_Opportunity' and 'Channel_Engineering_Opportunity'
*   for MINI SPIN Project
* 2015-07-14 Mrunal Parate  
* - modified - Commented Code where Opportunity record type forcast Snapshot was getting created. Now batch will create Forecast Snapshot for only Part Record Type of Opportunity Forecast
*   for Case 00789971.
*
* 2016-08-10 Pankaj Raijade
* - modified - Modified code to catch error while insert and resubmit batch for errored records. Send success or error mail to Admins.for Case 00900737.
*/
global class ClsBatch_forecastSnapshot implements Database.Batchable<SObject>,Database.Stateful{
    public String outsideQuery;
    public String filter;
    public list<Opportunity_Forecast__c> listexceptionOpportunityForecast = new list<Opportunity_Forecast__c>();//Pankaj: 00900737: Added
    public list<Opportunity_Forecast__c> listErrorOpportunityForecast = new list<Opportunity_Forecast__c>();//Pankaj: 00900737: Added
    public boolean isErrored = false;
    public map<id, string> mapOtherErrorOpportunity = new map<id, string>();    
    private static final string queryfc = 'SELECT Id, CurrencyIsoCode, CreatedDate, CreatedById, Sales_Price__c, Date__c,' 
                                      + 'Fiscal_Year__c, Fiscal_Quarter__c, ' //added by BYU 2013-02-18
                                      + 'Quantity__c, Amount__c, Opportunity__c, Part__c,Part__r.Won_Fiscal_Year__c, Counts_for_IND_Conversion__c, Counts_for_IND_Pipeline__c, ' //18-09-2015 Change by Pankaj- Case 00875907.
                                      + 'Part__r.Won_Fiscal_Quarter__c,Part__r.Won_Date__c,Part__r.Status__c,part__r.BU_profit_center__c,'
                                      + 'Part__r.Process_Status__c,Opportunity__r.ownerId,Opportunity__r.LastModifiedDate,'
                                      + 'Opportunity__r.StageName,Opportunity__r.CloseDate,Opportunity__r.RecordType.DeveloperName ,'
                                      + 'Opportunity__r.Manufacturing_Start_Date__c, Opportunity__r.PLM_Id__c, Opportunity__r.Probability,'
                                      + 'Opportunity__r.Days_since_last_user_update__c,Opportunity__r.Provide_to_customer_Quotation_Date__c,Opportunity__r.Quotation_Due_Date__c,'
                                      + 'Opportunity__r.Quotation_Request_Date__c, Opportunity__r.Mass_prod_Status__c, Opportunity__r.Two_Years_Revenue__c FROM Opportunity_Forecast__c where Opportunity__r.StageName !=\'Lost/Dead - closed\' AND'
                                      // Change start By Mrunal for MINI SPIN project, Commented hard coded record type values and Used Custom setting 'Opportunity Record type Group' for the same.
                                      /*Opportunity__r.RecordType.DeveloperName = \'Opportunity_Sales_Parts_Only\' or Opportunity__r.RecordType.DeveloperName = \'Opportunity_Engineering_Project\'  or Opportunity__r.RecordType.DeveloperName = \'Opportunity_Product_Platform\' or Opportunity__r.RecordType.DeveloperName = \'Engineering_Opportunity_CSD\' or Opportunity__r.RecordType.DeveloperName = \'Sales_Opportunity_CSD\'' 
                                      + ' or Opportunity__r.RecordType.DeveloperName = \'NDR_Opportunity\'*/
                                      + ' (Opportunity__r.RecordType.DeveloperName IN: set_recTyps or Opportunity__r.RecordTypeId IN : set_PMVRTIds) AND Amount__c > 0 AND Part__c != null';// Added by Toshi(Zensar Team) on 06-03-2014.// Part__c != null filter added by Mrunal for Case 00789971.
    //private static final string queryOppy = 'select id from Opportunity where (RecordType.DeveloperName = \'Opportunity_Sales_Parts_Only\' or RecordType.DeveloperName = \'Opportunity_Engineering_Project\')';// and id=\'006L0000002G7JM\'';
    private Id fcSnapPartRecordTypeId;
    //private Id fcSnapOppyRecordTypeId;//Commented by Mrunal for Case 00789971.
    public set<string> set_recTyps = new set<string>();// Added By Mrunal for MINI SPIN project
    global ClsBatch_forecastSnapshot(){
        for(RecordType rt: [select id, DeveloperName from RecordType where SobjectType ='Forecast_Snapshot__c']){
            if(rt.DeveloperName == 'Part'){
                fcSnapPartRecordTypeId = rt.Id;
            }/*else if(rt.DeveloperName == 'Opportunity'){
                fcSnapOppyRecordTypeId = rt.Id;
            }*/
            //Above else part Commented by Mrunal for Case 00789971.
        }
        //Start: Added by Mrunal for MINI SPIN
        List<Opportunity_Record_Type_Groups__c> cusSet = Opportunity_Record_Type_Groups__c.getall().values();
            for (Opportunity_Record_Type_Groups__c rt : cusSet){
                if(rt.Active__c && rt.Group__c == 'Forecast Snapshot Batch RT' && rt.API_Name__c!= null)
                    set_recTyps.add(rt.API_Name__c);        
            }
        system.debug('>>>set_recTyps'+set_recTyps);
        //End 
    }
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        String query;
        set<Id> set_PMVRTIds = ClsPMV_Util.getAllPMVRecordtypes();
        if(outsideQuery == null || outsideQuery == ''){
            Apex_Helper_Settings__c forecastyear = Apex_Helper_Settings__c.getInstance('forecastSnapshotYears');
            if(forecastyear != null && forecastyear.Value__c != null && forecastyear.Active__c == true){
                list<String> list_year = forecastyear.Value__c.split(';');
                query = queryfc + ' AND ( ';
                for(String year : list_year){
                    if(year != ''){
                        query += 'Fiscal_Year__c =\'' + year +'\' or ';
                    }
                }
                if(query.trim().endsWith('or')){
                    query = query.subString(0, query.length() - 3);
                }
                system.debug('####query: '  + query);
                query += ') ';
            }
            else{
                Period p = [select FiscalYearSettings.Name from Period where StartDate<=Today and EndDate >=Today and Type = 'year'];
                String currentYear = p.FiscalYearSettings.Name;
                String nextYear = String.valueOf(Integer.valueOf(currentYear) + 1);
                query = queryfc + ' and (Fiscal_Year__c =\'' + currentYear +'\' or Fiscal_Year__c =\'' + nextYear + '\')';
            }
            
            
            //query += ' and id =\'a0vL0000000JiDSIA0\'';      
            //system.debug('tongxia:'+query);
        }else{
            query = outsideQuery;
        }
        
            
        if(filter != null) query += filter;
        //Pankaj: 00900737: change start
        if(!listexceptionOpportunityForecast.isempty())
            query += ' and id IN :listexceptionOpportunityForecast ';
        //Pankaj: 00900737: change End
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, list<Opportunity_Forecast__c> scope){
        list<Forecast_Snapshot__c> list_fs2Insert = new list<Forecast_Snapshot__c>();
        list<Forecast_Snapshot__c> list_fs2Delete = new list<Forecast_Snapshot__c>();
        set<Id> set_oppyId = new set<Id>();
       
        for(Opportunity_Forecast__c ofc: scope){
            Forecast_Snapshot__c fs = new Forecast_Snapshot__c();
            //Change Start by Mrunal for Case 00789971.
            /*if(ofc.Opportunity__c != null && ofc.Part__c != null){
                fs.RecordTypeId = (id)fcSnapPartRecordTypeId;
                fs.Part__c = ofc.Part__c;
            }
            else{
                fs.RecordTypeId = (id)fcSnapOppyRecordTypeId;
            }*/
            fs.RecordTypeId = (id)fcSnapPartRecordTypeId;
            fs.Part__c = ofc.Part__c;
            fs.BU_Profit_Center_Snapshot__c = fs.Part__r.BU_profit_center__c;
            //Change End by Mrunal for Case 00789971.
            system.debug('fs.RecordTypeId:' + fs.RecordTypeId);
            fs.Quantity__c = ofc.Quantity__c;
            fs.CurrencyIsoCode = ofc.CurrencyIsoCode;
            fs.Sales_Price__c = ofc.Sales_Price__c;
            fs.Amount__c = ofc.Amount__c;
            fs.Opportunity__c = ofc.Opportunity__c;
            fs.Forecast_Owner__c = ofc.CreatedById;
            fs.Timestamp__c = ofc.CreatedDate;
            fs.Opportunity_Stage__c = ofc.Opportunity__r.StageName;
            fs.Forecast_Date__c = ofc.Date__c;
            fs.Part_Won_Fiscal_Year__c = ofc.Part__r.Won_Fiscal_Year__c;
            fs.Part_Won_Fiscal_Quarter__c = ofc.Part__r.Won_Fiscal_Quarter__c;
            fs.Won_Date__c = ofc.Part__r.Won_Date__c;
            if(!test.isRunningTest())
                fs.Days_since_last_user_update__c = ofc.Opportunity__r.LastModifiedDate.date().daysBetween(system.today());
            fs.Part_Confidence__c = ofc.Part__r.Status__c;
            fs.Process_Status__c = ofc.Part__r.Process_Status__c;
            fs.Opportunity_Owner_Id__c = ofc.Opportunity__r.ownerId;  
            //18-09-2015 Change Start by Pankaj- Case 00875907.
            fs.Count_Conversion__c = ofc.Counts_for_IND_Conversion__c; 
            fs.Count_Pipeline__c = ofc.Counts_for_IND_Pipeline__c;              
            //18-09-2015 Change end by Pankaj- Case 00875907.
            fs.Snapshot_Type__c = 'Monthly';
            
            //added by BYU 2013-02-18:START
            fs.Days_since_last_user_update__c = ofc.Opportunity__r.Days_since_last_user_update__c;
            fs.Date__c = ofc.Date__c;
            fs.Fiscal_Year__c = ofc.Fiscal_Year__c;
            fs.Fiscal_Quarter__c = ofc.Fiscal_Quarter__c;
            //added by BYU 2013-02-18:END
            //Added by Shreyas 2014-01-07 : START
            if(ofc.Opportunity__r.RecordType.DeveloperName == 'Engineering_Opportunity_CSD' ||  
                ofc.Opportunity__r.RecordType.DeveloperName == 'Sales_Opportunity_CSD'){
                
                fs.CloseDate__c = ofc.Opportunity__r.CloseDate;
                fs.Massproduction_date__c = ofc.Opportunity__r.Manufacturing_Start_Date__c;
                if(ofc.Opportunity__r.PLM_Id__c!= null && ofc.Opportunity__r.PLM_Id__c != ''){
                    fs.PLMID__c = ofc.Opportunity__r.PLM_Id__c;
                }
                fs.Probability__c = ofc.Opportunity__r.Probability;
                if(ofc.Opportunity__r.Provide_to_customer_Quotation_Date__c != null)
                    fs.ProvideQuotation_date__c = ofc.Opportunity__r.Provide_to_customer_Quotation_Date__c;
                if(ofc.Opportunity__r.Quotation_Due_Date__c != null)
                    fs.QuotationDue_Date__c =  ofc.Opportunity__r.Quotation_Due_Date__c  ;
                if(ofc.Opportunity__r.Quotation_Request_Date__c != null )   
                    fs.QuotationRequest_Date__c =  ofc.Opportunity__r.Quotation_Request_Date__c ;  
                 fs.S_OP__c = ofc.Opportunity__r.Mass_prod_Status__c;
                 fs.TwoYears_Revenue__c = ofc.Opportunity__r.Two_Years_Revenue__c; 
            }
            //Added by Shreyas 2014-01-07 : END
            //Add defined records to insert list
            list_fs2Insert.add(fs);
        }
        //if(!list_fs2Delete.isEmpty()) delete list_fs2Delete;
        if(!list_fs2Insert.isEmpty()) 
        {
            //Pankaj: 00900737: change start
            if(!isErrored )
            {
                boolean isFirstError = false;
                list<Database.SaveResult> lstSaveResult = Database.insert(list_fs2Insert, false);
                for (integer i = 0; i < lstSaveResult.size(); i++)
                {
                    Database.SaveResult oSR = lstSaveResult[i];
                    if(!oSR.isSuccess())
                    {
                        isFirstError = true;
                        break;
                    }
                }
                if(isFirstError)
                    listErrorOpportunityForecast.addAll(scope);
            }
            else
            {
                list<Database.SaveResult> lstSaveResult = Database.insert(list_fs2Insert, true);
                for (integer i = 0; i < lstSaveResult.size(); i++)
                {
                    Database.SaveResult oSR = lstSaveResult[i];
                    if(!oSR.isSuccess())
                    {
                        for(Database.Error err : oSR.getErrors())
                        {
                            if(!mapOtherErrorOpportunity.containsKey(list_fs2Insert[i].Opportunity__c))
                                mapOtherErrorOpportunity.put(list_fs2Insert[i].Opportunity__c, '');
                            mapOtherErrorOpportunity.put(list_fs2Insert[i].Opportunity__c, mapOtherErrorOpportunity.get(list_fs2Insert[i].Opportunity__c) + err.getMessage());
                         }
                     }
                 }
             }
             //Pankaj: 00900737: change end
        }        
    }
    global void finish(Database.BatchableContext BC)
    {
        //Pankaj: 00900737: change start
        string strEmailBody = '';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Batch_Email_message_Users__c oBatchEmailmessageUsers = Batch_Email_message_Users__c.getValues('Error_ClsBatch_forecastSnapshot');
        List<String> lstToAddresses = oBatchEmailmessageUsers.Email_ID__c.split(';');
        mail.setToAddresses(lstToAddresses );
        if(!listErrorOpportunityForecast.isempty())
        {
            if(!isErrored)
            {
                for(Opportunity_Forecast__c oFS :listErrorOpportunityForecast)
                    strEmailBody += oFS.id + '\n';

                mail.setSubject('First time error occurred during ClsBatch_forecastSnapshot-Records being resubmitted');
                mail.setPlainTextBody('Hi, \n\nFirst time error occurred during ClsBatch_forecastSnapshot . Please see details below. \n\n' + strEmailBody + '\n\n Regards,');
                
                ClsBatch_forecastSnapshot oClsBatch_forecastSnapshot = new ClsBatch_forecastSnapshot();
                oClsBatch_forecastSnapshot.listexceptionOpportunityForecast = listErrorOpportunityForecast;
                oClsBatch_forecastSnapshot.isErrored = true;
                database.executebatch(oClsBatch_forecastSnapshot);
            }
        }
        
        if(oBatchEmailmessageUsers != null && oBatchEmailmessageUsers.Email_ID__c != null)
        {
            if(!mapOtherErrorOpportunity.isEmpty())
            {
                for(string strOppyID :mapOtherErrorOpportunity.keyset())
                    strEmailBody += strOppyID + '-' + mapOtherErrorOpportunity.get(strOppyID) + '\n';

                mail.setSubject('Some error occurred during ClsBatch_forecastSnapshot ');
                mail.setPlainTextBody('Hi, \n\nSome error occurred during ClsBatch_forecastSnapshot . Please see details below. \n\n' + strEmailBody + '\n\n Regards,');
                
            }
            else if(listErrorOpportunityForecast.isempty())
            {
                mail.setSubject('ClsBatch_forecastSnapshot Batch completed successfully');
                mail.setPlainTextBody('Hi, \n\nClsBatch_forecastSnapshot Batch completed successfully\n\n Regards,');

            }
            if(!test.isRunningTest())
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        //Pankaj: 00900737: change end
    }

}