/**
*  This class is test class for clsBatch_UpdateAccountShipping.
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
private class clsBatch_UpdateAccountShipping_Test
{
    static testmethod void clsBatch_UpdateAccountShipping_TM()
    {
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();       
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();     
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getBatchEmailmessageUsers();
        ClsTestCustomSettingHelper.getTimeframeSetting();        
        
        list<Account> lstAccount = new list<account>();
        Account oAccount = new Account(name = 'testaccount', BillingCountry = 'US',NPS_Overall_Score__c=90.00);
        lstAccount.add(oAccount);
        Account oAccount2 = new Account(name = 'testaccount', BillingCountry = 'US',NPS_Overall_Score__c=90.00);
        lstAccount.add(oAccount2);
        insert lstAccount;

        Load_Status__c oLoadStatus = new Load_Status__c(name = 'Delivery_Performance__c', Current_Date__c = date.today());
        insert oLoadStatus;
        
        Product_Hierarchy__c oProductHierarchy = new Product_Hierarchy__c(name = 'testProduct_Hierarchy__c');
        insert oProductHierarchy;
        
        Part__c oPart = new Part__c(name = 'testpart', Product_Hierarchy__c = oProductHierarchy.Id);
        insert oPart;

        Manufacturing_plant__c oPlant = new Manufacturing_plant__c(Manufacturing_Organization_Id__c = 'testMagOrgID2');
        insert oPlant;
        
        Plant_Account_Shipment__c oPlantAccountShipment = new Plant_Account_Shipment__c(account__c = oAccount2.Id, Manufacturing_Plant__c = oPlant.Id);
        insert oPlantAccountShipment;
        
        Delivery_Performance__c oDeliveryPerformance = new Delivery_Performance__c(BUILDING_NBR_MFG__c='123456',Account__c = oAccount.Id, Manufacturing_Organization_Id__c = 'testMagOrgID', Shipped_Date__c = date.NewInstance( date.today().year(), date.today().Month()-1, 1), Part__c = oPart.Id);
        //insert oDeliveryPerformance;
        
        Delivery_Performance__c oDeliveryPerformance2 = new Delivery_Performance__c(BUILDING_NBR_MFG__c='123456',Account__c = oAccount.Id, Manufacturing_Organization_Id__c = 'testMagOrgID', Shipped_Date__c = date.today(), Part__c = oPart.Id);
        insert new List<Delivery_Performance__c>{oDeliveryPerformance,oDeliveryPerformance2};

        test.starttest();
            clsBatch_UpdateAccountShipping o = new clsBatch_UpdateAccountShipping();
            o.mapError.put(oAccount.Id, 'test');
            database.executeBatch(o);
            o = new clsBatch_UpdateAccountShipping(date.Today());
            database.executeBatch(o);
        test.stoptest();
      
    }
}