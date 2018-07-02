/**************************************************************************************************************************************************
Name:  Cls_TestINFRAJDAClasses
Copyright © 2014 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for INFRA Batch Classes
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer      Date         Detail                User Story#
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Shantinath     12/09/2011   Initial Development   R42                                                     
**************************************************************************************************************************************************/
@IsTest
public class Cls_TestINFRAJDAClasses{
    @IsTest(SeeAllData=true)
    public static void TestOpportunityBatch(){
    
        //ClsTestCustomSettingHelper.getINFRA_JDA_Settings();
        //ClsTestCustomSettingHelper.getAllSettings();
        
        Account oAccount = ClsTestHelp.createTestAccounts();
        insert oAccount;

        
        
        Opportunity oOPP = ClsTestHelp.createTestOpportunity();
        oOPP.AccountID = oAccount.Id;
        insert oOPP;
        Product_Hierarchy__c oProductHierarchy = new Product_Hierarchy__c();
        insert oProductHierarchy;
        
        Part__c oPart = new Part__c(Product_Hierarchy__c = oProductHierarchy.id);
        insert oPart;
        
        Opportunity_Part__c oOPart = ClsTestHelp.createTestOpportunityPart();
        oOpart.Part__c = oPart.Id;
        oOPart.Opportunity__c = oOPP.Id;
        //oOPart.Part_Number__c = '11111';
        insert oOPart;
        oOPart = [select id, Part_Number__c from Opportunity_Part__c where id = :oOPart.Id];
        INFRA__Part_Forecast__c oINFRAPartForecast = new INFRA__Part_Forecast__c(INFRA__Product_Code__c = oOPart.Part_Number__c, INFRA__BU_Forecast_Source_Id__c = oOPP.Id, INFRA__Business_Unit__c = 'testBU', INFRA__Data_Stream__c = 'testdS', INFRA__Product_Hierarchy_Indicator__c = 'testPHI');
        insert oINFRAPartForecast;
        
        List<CurrencyType> currencyTypeList = [select IsoCode, ConversionRate from CurrencyType];
        Map<String, Decimal> vConversionMap = new Map<String, Decimal>();
        for(CurrencyType vTempCurrency : currencyTypeList){
            vConversionMap.put(vTempCurrency.IsoCode, vTempCurrency.ConversionRate);
        }
        Test.StartTest();
            Cls_BatchJDAPartForecast vBatch = new Cls_BatchJDAPartForecast(vConversionMap);
            vBatch.vQuery = 'select id, Part_Number__c, Opportunity__c, Opportunity__r.AccountId, Opportunity__r.Account.Account_Number_JDA_bridge_format__c from Opportunity_Part__c where id = \''+oOPart.id +'\'';
            Id batchInstanceId = Database.executeBatch(vBatch, 100);  

        Test.StopTest();
    }
}