/**
*  This class is test class for clsBatch_UpdatePlantSurveyScore.
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
@isTest(seeAllData=false)
public class clsBatch_UpdatePlantSurveyScore_Test
{
    static testmethod void clsBatch_UpdatePlantSurveyScore_TM()
    {
    
        Batch_Email_message_Users__c oBatch_Email_message_Users = new Batch_Email_message_Users__c(name = 'Error_clsBatch_CalculateSurveyScore', email_ID__c = 'test@test.test');
        insert oBatch_Email_message_Users;
        
        Time_frame_Setting__c oTFS = new Time_frame_Setting__c(Name = 'ACCOUNT_SURVEY', Period__c = 60, Period_Type__c = 'MONTH');
        insert oTFS;
        
        List<Apex_Helper_Settings__c> lstApex_Helper_Settings = new List<Apex_Helper_Settings__c>();
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'System Admin Profile Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Service Account Profile Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'TEIS Admin User Id', Value__c = ''));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Account Record Type Id', Value__c = ''));        
        insert lstApex_Helper_Settings;
        
        list<Consumer_Device_Opportunity_Record_Types__c> lstConsumer_Device_Opportunity_Record_Types = new list<Consumer_Device_Opportunity_Record_Types__c>();
        lstConsumer_Device_Opportunity_Record_Types.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'OEM', Record_Type_Id__c = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId()));
        lstConsumer_Device_Opportunity_Record_Types.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Sales Opportunity-CSD', Record_Type_Id__c = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId()));
        lstConsumer_Device_Opportunity_Record_Types.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Engineering Opportunity-CSD', Record_Type_Id__c = Schema.Sobjecttype.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId()));
        
        insert lstConsumer_Device_Opportunity_Record_Types;
        
        Object_field_mapping__c oFieldMapping = new Object_field_mapping__c(Source_Object__c = 'Account', Target_Object__c = 'Plant_Account_Shipment__c', Field_Mapping_Purpose__c = 'ACCOUNT_SURVEY_SCORE_FOR_PLANT', Target_Object_Field__c = 'NPS_Business_Understanding__c', Source_Object_Field__c = 'NPS_Business_Understanding__c', Name = 'AccountPlantNPSBusinessUnderstanding');
        insert oFieldMapping;

        list<Account> lstAccount = new list<account>();
        Account oAccount = new Account(name = 'testaccount', BillingCountry = 'US');
        lstAccount.add(oAccount);
        Account oAccount2 = new Account(name = 'testaccount', BillingCountry = 'US');
        lstAccount.add(oAccount2);
        insert lstAccount;
        
        Manufacturing_Plant__c oPlant = new Manufacturing_Plant__c(MANUFACTURING_ORGANIZATION_ID__c = 'test');
        
        insert oPlant;
        
        Plant_Account_Shipment__c oPlantAccountShipment = new Plant_Account_Shipment__c(Account__c = oAccount.Id, Manufacturing_Plant__c = oPlant.Id, Shipped_Date__c = date.today().addDays(-100));
        insert oPlantAccountShipment;
        
        test.starttest();
            clsBatch_UpdatePlantSurveyScore o = new clsBatch_UpdatePlantSurveyScore();
            o.mapError.put(oAccount.Id, 'test');
            database.executeBatch(o);
            oTFS = new Time_frame_Setting__c(Id = oTFS.ID, Name = 'ACCOUNT_SURVEY', Period__c = 60, Period_Type__c = 'DAY');
            update oTFS;
            o = new clsBatch_UpdatePlantSurveyScore();
            oTFS = new Time_frame_Setting__c(Id = oTFS.ID, Name = 'ACCOUNT_SURVEY', Period__c = 60, Period_Type__c = 'YEAR');
            update oTFS;
            o = new clsBatch_UpdatePlantSurveyScore();
            
              o.Query = 'select id, IsCurrent__c, Shipped_Date__c, account__c,manufacturing_Plant__r.BUILDING_NBR_MFG__c from Plant_Account_Shipment__c';
            database.executeBatch(o);
            
        test.stoptest();    
    }   
}