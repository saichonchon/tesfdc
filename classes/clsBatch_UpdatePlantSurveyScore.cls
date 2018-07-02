/**
*  This class is Used for update NPS score from Account to Plant Account shipping object.
*
@author Pankaj Raijade
@created 4/3/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  93%
* 
* 
4/3/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
*/
global class clsBatch_UpdatePlantSurveyScore implements Database.Batchable<sObject>, Database.Stateful
{
    public map<string, string> mapSurvey_Question_field_mappings = new map<string, string>();
    public set<string> setQuestions = new set<string>();
    public string Query;
    public date dateSurveyStart = date.today().addMonths(-6);
    public date dateSurveyEnd = date.today();
    public date dateSurvey = date.today();
    public map<string, string> mapFieldMapping = new map<string, string>();
    public map<ID, string> mapError = new map<ID, string>();

    public clsBatch_UpdatePlantSurveyScore()
    {
        dateSurveyEnd = date.NewInstance( date.today().year(), date.today().Month(), 1);
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
         for(Object_field_mapping__c oFieldMapping :[select id, Source_Object_Field__c, Target_Object_Field__c from Object_field_mapping__c where Source_Object__c = :'Account' and Target_Object__c = :'Plant_Account_Shipment__c' AND Field_Mapping_Purpose__c = :'ACCOUNT_SURVEY_SCORE_FOR_PLANT' AND Target_Object_Field__c != null AND Source_Object_Field__c != null])
               mapFieldMapping.put(oFieldMapping.Target_Object_Field__c, oFieldMapping.Source_Object_Field__c);
        dateSurvey = date.NewInstance( dateSurveyEnd.year(),dateSurveyEnd.Month() - 1, 15);

    }
     public clsBatch_UpdatePlantSurveyScore(Date TempCurrentdate)
    {
        dateSurveyEnd = date.NewInstance( TempCurrentdate.year(), TempCurrentdate.Month(), 1);
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
         for(Object_field_mapping__c oFieldMapping :[select id, Source_Object_Field__c, Target_Object_Field__c from Object_field_mapping__c where Source_Object__c = :'Account' and Target_Object__c = :'Plant_Account_Shipment__c' AND Field_Mapping_Purpose__c = :'ACCOUNT_SURVEY_SCORE_FOR_PLANT' AND Target_Object_Field__c != null AND Source_Object_Field__c != null])
               mapFieldMapping.put(oFieldMapping.Target_Object_Field__c, oFieldMapping.Source_Object_Field__c);
        dateSurvey = date.NewInstance( dateSurveyEnd.year(),dateSurveyEnd.Month() - 1, 15);

    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        dateSurvey = date.NewInstance( dateSurveyEnd.year(),dateSurveyEnd.Month() - 1, 15);
        if(Query != null)
            return Database.getQueryLocator(Query);
        else 
            return Database.getQueryLocator([select id, IsCurrent__c, Shipped_Date__c, account__c, manufacturing_Plant__r.BUILDING_NBR_MFG__c from Plant_Account_Shipment__c where shipped_date__c = :dateSurvey]);
            //return Database.getQueryLocator([select id, NPS_Business_Understanding__c, NPS_Competitive_Price__c, NPS_Customer_Care_Support__c, NPS_Delivery_Performance__c, NPS_Engineering_Responsiveness__c, NPS_Field_Tech_Support__c, NPS_Overall_Score__c, NPS_Product_Innovation__c, NPS_Product_Quality__c, NPS_Technology_needs_met__c from account]);
    }

    global void execute(Database.BatchableContext BC, List<Plant_Account_Shipment__c> lstPlantAccountShipment)
    {
        if(mapFieldMapping != null && mapFieldMapping.size() > 0)
        {
            set<id> setAccountID = new set<id>();
            set<string> setPlant = new set<string>();
            map<string, id> mapPlantName = new map<string, id>();
            map<string, integer> mapcount = new map<string, integer>();
            for(Plant_Account_Shipment__c oPAS :lstPlantAccountShipment)
            {
                setAccountID.add(oPAS.account__c);
                setPlant.add(oPAS.manufacturing_Plant__r.BUILDING_NBR_MFG__c);
                mapPlantName.put(oPAS.manufacturing_Plant__r.BUILDING_NBR_MFG__c, oPAS.manufacturing_Plant__c);
            }
            map<id, Account> mapAccount = new map<id, Account>([select id, NPS_Business_Understanding__c, NPS_Competitive_Price__c, NPS_Customer_Care_Support__c, NPS_Delivery_Performance__c, NPS_Engineering_Responsiveness__c, NPS_Field_Tech_Support__c, NPS_Overall_Score__c, NPS_Product_Innovation__c, NPS_Product_Quality__c, NPS_Technology_needs_met__c from account where id in :setAccountID]);
            
            list<AggregateResult> lstDP = [select count(id)cnt, account__c, BUILDING_NBR_MFG__c from Delivery_Performance__c where shipped_date__c >= :dateSurveyStart and shipped_date__c < :dateSurveyend and BUILDING_NBR_MFG__c in :setPlant and Account__c in :setAccountID group by account__c, BUILDING_NBR_MFG__c];
            for (AggregateResult ar : lstDP)  
                mapcount.put(ar.get('account__c') + '-' + mapPlantName.get(''+ar.get('BUILDING_NBR_MFG__c')), (integer)ar.get('cnt'));

            for(Plant_Account_Shipment__c oPAS :lstPlantAccountShipment)
            {
                if(mapAccount.containsKey(oPAS.Account__c))
                {
                    Account oAccount = mapAccount.get(oPAS.Account__c);
                    for(string strTargetField :mapFieldMapping.Keyset())
                    {
                        string strSourceField = mapFieldMapping.get(strTargetField); 
                        oPAS.put(strTargetField, oAccount.get(strSourceField));
                    }
                }
                if(mapcount.containsKey(oPAS.Account__c + '-' + oPAS.manufacturing_Plant__c))
                {
                    system.debug('oPAS1===>>>' + oPAS );
                    oPAS.Shipment_Count__c = mapcount.get(oPAS.Account__c + '-' + oPAS.manufacturing_Plant__c);
                    oPAS.IsCurrent__c = true;
                }
                else
                {
                    system.debug('oPAS0===>>>' + oPAS );
                    oPAS.Shipment_Count__c = 0; 
                    oPAS.IsCurrent__c = true;
                }
            }
            
            if(lstPlantAccountShipment.size() > 0)
            {
                list<Database.SaveResult> lstSaveResult = database.update(lstPlantAccountShipment, false);
                for (Database.SaveResult sr : lstSaveResult) 
                    if (!sr.isSuccess()) 
                        for(Database.Error err : sr.getErrors()) 
                            mapError.put(sr.getId(),  (mapError.get(sr.getId()) + err.getStatusCode() + ': ' + err.getMessage()));
                
            }
        }
    }

    global void finish(Database.BatchableContext BC)
    {
        system.debug('dateSurvey===>>>' + dateSurvey );
        List<Plant_Account_Shipment__c> lstPlantAccountShipment = [select id, IsCurrent__c from Plant_Account_Shipment__c where shipped_date__c <> :dateSurvey and IsCurrent__c = :true];
        for(Plant_Account_Shipment__c oPAS :lstPlantAccountShipment)
        {
                system.debug('oPAS=false===>>>' + oPAS);
                oPAS.IsCurrent__c = false;
        }
        if(lstPlantAccountShipment.size() > 0)
            update lstPlantAccountShipment;
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
                mail.setSubject('Some error occurred during clsBatch_UpdatePlantSurveyScore');
                mail.setPlainTextBody('Hi, \n\nSome error occurred during clsBatch_UpdatePlantSurveyScore. Please see details below. \n\n' + strEmailBody + '\n\n Regards,');
                
                if(!test.isRunningTest()) { 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                } 
            }
        }
    }
}