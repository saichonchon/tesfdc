/**
*  This class used Calculate average survey score for account.
*
@author Pankaj Raijade
@created 4/2/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  93%
* 
* 
4/2/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
*/
global class clsBatch_CalculateSurveyScore implements Database.Batchable<sObject>
{
    public map<string, string> mapSurvey_Question_field_mappings = new map<string, string>();
    public set<string> setQuestions = new set<string>();
    public string Query;
    public date dateSurveyStart = date.today().addMonths(-6);
    public date dateSurveyEnd = date.today();
    public map<string, string> mapError = new map<string, string>();
    public boolean RunPlantScoreUpdate = true;
    public boolean IgnoreisCurrent = false;
    public clsBatch_CalculateSurveyScore()
    {
        dateSurveyEnd = date.NewInstance( date.today().year(), date.today().Month(), 1);
        //get Time frame setting for Account survey.
        Time_frame_Setting__c AccountSurveyTimeFrame = Time_frame_Setting__c.getValues('ACCOUNT_SURVEY');
        if(AccountSurveyTimeFrame != null && AccountSurveyTimeFrame.Period_Type__c != null && AccountSurveyTimeFrame.Period__c != null)
        {
            if('YEAR'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addYears((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            if('MONTH'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addMonths((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            if('DAY'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addDays((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
        }
        //get Survey question field mapping from custom setting for account.
        for(Survey_Question_field_mappings__c oSQFM :[select id, Survey_Name__c, Survey_Question__c, Survey_Score_Field__c from Survey_Question_field_mappings__c where Object__c = :'Account'])
            if(!mapSurvey_Question_field_mappings.containskey(oSQFM.Survey_Name__c+'-'+oSQFM.Survey_Question__c))
               mapSurvey_Question_field_mappings.put(oSQFM.Survey_Name__c+'-'+oSQFM.Survey_Question__c, oSQFM.Survey_Score_Field__c);    
    }
    public clsBatch_CalculateSurveyScore(date CurrentDate)
    {
        dateSurveyEnd = date.NewInstance( CurrentDate.year(), CurrentDate.Month(), 1);
        //get Time frame setting for Account survey.
        Time_frame_Setting__c AccountSurveyTimeFrame = Time_frame_Setting__c.getValues('ACCOUNT_SURVEY');
        if(AccountSurveyTimeFrame != null && AccountSurveyTimeFrame.Period_Type__c != null && AccountSurveyTimeFrame.Period__c != null)
        {
            if('YEAR'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addYears((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            if('MONTH'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addMonths((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            if('DAY'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addDays((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
        }
        //get Survey question field mapping from custom setting for account.
        for(Survey_Question_field_mappings__c oSQFM :[select id, Survey_Name__c, Survey_Question__c, Survey_Score_Field__c from Survey_Question_field_mappings__c where Object__c = :'Account'])
            if(!mapSurvey_Question_field_mappings.containskey(oSQFM.Survey_Name__c+'-'+oSQFM.Survey_Question__c))
               mapSurvey_Question_field_mappings.put(oSQFM.Survey_Name__c+'-'+oSQFM.Survey_Question__c, oSQFM.Survey_Score_Field__c);    
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(Query != null)
            return Database.getQueryLocator(Query);
        else 
            return Database.getQueryLocator([select id, NPS_Business_Understanding__c, NPS_Competitive_Price__c, NPS_Customer_Care_Support__c, NPS_Delivery_Performance__c, NPS_Engineering_Responsiveness__c, NPS_Field_Tech_Support__c, NPS_Overall_Score__c, NPS_Product_Innovation__c, NPS_Product_Quality__c, NPS_Technology_needs_met__c from account]);
    }

    global void execute(Database.BatchableContext BC, List<sObject> lstAccount)
    {
        map<id, sObject> mapAccount = new map<id, sObject>(lstAccount);
        map<id, sObject> mapAccountUpdate = new map<id, sObject>();
        set<id> setAccountUpdate = new set<id>();
        map<id, map<string, Object>> mapAggregateResult = new map<id, map<string, Object>>();
        
        //Query average score for account and each qeustion mapped in survey question field setting.
        list<AggregateResult> groupedResults = new list<AggregateResult>();
        //if(IgnoreisCurrent)
            groupedResults = [SELECT Contact__r.accountid accID,  Survey_Name_Survey_Question__c Survey_Name_Question, AVG(Answer_Value__c) avgScore FROM Answer__c where Question__r.Question_Type__c = :'0...10' and Contact__r.accountid != null AND Contact__r.accountid in:mapAccount.Keyset() and Survey_Name_Survey_Question__c in :mapSurvey_Question_field_mappings.Keyset() AND Survey_date__c >= :dateSurveyStart AND Survey_date__c < :dateSurveyEnd group by Contact__r.accountid, Survey_Name_Survey_Question__c];//
        //else 
            //groupedResults = [SELECT Contact__r.accountid accID,  Survey_Name_Survey_Question__c Survey_Name_Question, AVG(Answer_Value__c) avgScore FROM Answer__c where Question__r.Question_Type__c = :'0...10' and Current__c = :true and Contact__r.accountid != null AND Contact__r.accountid in:mapAccount.Keyset() and Survey_Name_Survey_Question__c in :mapSurvey_Question_field_mappings.Keyset() AND Survey_date__c >= :dateSurveyStart AND Survey_date__c < :dateSurveyEnd group by Contact__r.accountid, Survey_Name_Survey_Question__c];//        
        for(AggregateResult oAggRes :groupedResults)
        {
            if(mapAggregateResult.containsKey((id)oAggRes.get('accID')))
               mapAggregateResult.get((id)oAggRes.get('accID')).put((string)oAggRes.get('Survey_Name_Question'), oAggRes.get('avgScore'));
            else
               mapAggregateResult.put((id)oAggRes.get('accID'), new map<string, Object>{(string)oAggRes.get('Survey_Name_Question') => oAggRes.get('avgScore')}); 
        }
        
        
        for(ID AccountID :mapAccount.Keyset())
        {
            sObject oAccount;
            if(mapAccountUpdate.containsKey(AccountId))
                oAccount = mapAccountUpdate.get(AccountId);
            else
                oAccount = mapAccount.get(AccountId); 
            Boolean isAccountUpdated = false;
            if(mapAggregateResult.containsKey(AccountId))
            {
               map<string, Object> mapAggregateResultAccount = mapAggregateResult.get(AccountId);
               for(string str :mapSurvey_Question_field_mappings.Keyset()) 
               {
                   if(mapAggregateResultAccount.containsKey(str))
                   {
                       if(oAccount.get(mapSurvey_Question_field_mappings.get(str)) != mapAggregateResultAccount.get(str))
                       {
                           oAccount.put(mapSurvey_Question_field_mappings.get(str), mapAggregateResultAccount.get(str));
                           isAccountUpdated = true;
                       }
                   }
                   else
                   {
                        oAccount.put(mapSurvey_Question_field_mappings.get(str), null);
                        isAccountUpdated = true;
                   }
               }
            }
            else
            {
                isAccountUpdated = true;
                for(string str :mapSurvey_Question_field_mappings.Keyset())
                    oAccount.put(mapSurvey_Question_field_mappings.get(str), null);
            }
            if(isAccountUpdated)
                mapAccountUpdate.put(AccountId, oAccount);
        }
        if(mapAccountUpdate.size() > 0)
        {
            list<Database.SaveResult> lstSaveResult = database.update(mapAccountUpdate.values(), false);
            for (Database.SaveResult sr : lstSaveResult) 
                if (!sr.isSuccess()) 
                    for(Database.Error err : sr.getErrors()) 
                        mapError.put(sr.getId(),  (mapError.get(sr.getId()) + err.getStatusCode() + ': ' + err.getMessage()));
            
        }
        
    }

    global void finish(Database.BatchableContext BC)
    {
        if(RunPlantScoreUpdate)
        {
            //Run batch for Update plant survey score.
            Batch_size_setting__c oBatchsize = Batch_size_setting__c.getInstance('clsBatch_UpdateAccountShipping');
            if(oBatchsize != null && oBatchsize.Batch_size__c != null && oBatchsize.Batch_size__c > 0)
            {
                clsBatch_UpdateAccountShipping oclsBatch_UpdateAccountShipping = new clsBatch_UpdateAccountShipping();
                database.executeBatch(oclsBatch_UpdateAccountShipping, (Integer)oBatchsize.Batch_size__c);
            }
            else
            {
                clsBatch_UpdateAccountShipping oclsBatch_UpdateAccountShipping = new clsBatch_UpdateAccountShipping();
                database.executeBatch(oclsBatch_UpdateAccountShipping);
            }
        }
        if(mapError.size() > 0)
        {
            Batch_Email_message_Users__c oBatchEmailmessageUsers = Batch_Email_message_Users__c.getValues('Error_clsBatch_CalculateSurveyScore');
            if(oBatchEmailmessageUsers != null && oBatchEmailmessageUsers.Email_ID__c != null)
            {
                string strEmailBody = '';
                for(string strAccountID :mapError.keyset())
                    strEmailBody += strAccountID + '-' + mapError.get(strAccountID) + '\n';
                    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> lstToAddresses = oBatchEmailmessageUsers.Email_ID__c.split(';');
                mail.setToAddresses(lstToAddresses );
                mail.setSubject('Some error occurred during clsBatch_CalculateSurveyScore');
                mail.setPlainTextBody('Hi, \n\nSome error occurred during clsBatch_CalculateSurveyScore. Please see details below. \n\n' + strEmailBody + '\n\n Regards,');
                
                if(!test.isRunningTest()) { 
                	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
        }
    }
}