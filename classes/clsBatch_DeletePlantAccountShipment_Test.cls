/**
*  This class test class for clsBatch_DeletePlantAccountShipment.
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
@isTest(seeAllData=false)
public class clsBatch_DeletePlantAccountShipment_Test
{
    static testmethod void clsBatch_DeletePlantAccountShipment_TM()
    {
        Batch_Email_message_Users__c oBatch_Email_message_Users = new Batch_Email_message_Users__c(name = 'Error_clsBatch_CalculateSurveyScore', email_ID__c = 'test@test.test');
        insert oBatch_Email_message_Users;
        
        Time_frame_Setting__c oTFS = new Time_frame_Setting__c(Name = 'Delete_Plant_Account_Shipment_Period', Period__c = 1, Period_Type__c = 'MONTH');
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
        
        list<Account> lstAccount = new list<account>();
        Account oAccount = new Account(name = 'testaccount', BillingCountry = 'US');
        lstAccount.add(oAccount);
        Account oAccount2 = new Account(name = 'testaccount', BillingCountry = 'US');
        lstAccount.add(oAccount2);
        insert lstAccount;

        Manufacturing_plant__c oPlant = new Manufacturing_plant__c(Manufacturing_Organization_Id__c = 'testMagOrgID2');
        insert oPlant;
        
        Plant_Account_Shipment__c oPlantAccountShipment = new Plant_Account_Shipment__c(account__c = oAccount2.Id, Manufacturing_Plant__c = oPlant.Id, Shipped_date__C = date.today().addMonths(-2));
        insert oPlantAccountShipment;
         test.starttest();
            clsBatch_DeletePlantAccountShipment o = new clsBatch_DeletePlantAccountShipment();
            database.executeBatch(o);
        test.stoptest();
    }
}