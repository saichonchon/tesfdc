/**
*   This test class covers Classes: Cls_BatchDNDJDAAccountForecast(88%), Cls_BatchDNDJDAPartForecast(88%)
*
@  author Rajendra Shahane
@  created 2016-09-14
*
*/
@istest(seeAllData=false)
private class Cls_BatchDNDJDAAccountForecast_Test
{
    public static testmethod void TestCls_BatchDNDJDAAccountForecast()
    {
        ClsTestCustomSettingHelper.getINFRA_JDA_Settings();
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();        
        ClsTestCustomSettingHelper.getWebToCaseStrings();
        ClsTestCustomSettingHelper.getINFRA_JDA_Connector_Config();
        
        Sales_Hierarchy__c sh1 = new Sales_Hierarchy__c();
        sh1.Level_1_Territory_Code__c = '102260';
        sh1.Level_7_Territory_Code__c = '102260';
        sh1.Level_7_Default_Owner__c = UserInfo.getuserId();
        sh1.Level_7_Assigned_User_Network_Ids__c = 'TE901311';
        sh1.Hierarchy_Type__c  = 'Sales Hierarchy (AM)';
        insert sh1;
      
        Account acc=new Account();  
        acc.Name='Test1000';
        acc.BillingCountry='US';
        acc.STATDESC__c = 'Active';
        acc.SALES_TERRITORY_CDE__c = '1111';
        acc.Sales_Hierarchy__c = sh1.id;
        acc.Company_Organization_ID__c = '0791';
        acc.AccountNumber = '1111:11111111';
        acc.OEM_ID__c = '111';
        insert acc; 
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'DND';
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;            
        insert part;
        
        
        Date vManSchDate = Date.Today();
        Period vCurrPeriod = [SELECT StartDate, EndDate FROM Period WHERE Type = 'Month' AND StartDate <=: vManSchDate AND EndDate >=: vManSchDate];
        date vFiscalStartDate = vCurrPeriod.StartDate;
        Integer vCurrentFiscalYear = Integer.valueof(ClsOppyForecastUtil.getFiscalYear());
        Integer vCurrentFiscalMonth = Integer.valueof(ClsBudgetPlanningUtil.getFiscalMonth(vFiscalStartDate));
        date fiscalMonth1Date = Date.newInstance(vCurrentFiscalYear, vCurrentFiscalMonth+1, 1);
        
        CSD_Sales_Forecast__c CSDFcst = new CSD_Sales_Forecast__c(Billing_Region__c='AMERICAS',Sold_To_Number__c='5555',OEM__c=acc.id,Fiscal_Month__c=string.valueOf(fiscalMonth1Date.month()),Fiscal_Year__c =string.valueOf(fiscalMonth1Date.year()));
        CSD_Sales_Forecast__c CSDFcst1 = new CSD_Sales_Forecast__c(Part__c =part.Id, Billing_Region__c='AMERICAS',Sold_To_Number__c='5555',OEM__c=acc.id,Fiscal_Month__c=string.valueOf(fiscalMonth1Date.month()),Fiscal_Year__c =string.valueOf(fiscalMonth1Date.year()));
        insert new List<CSD_Sales_Forecast__c>{CSDFcst,CSDFcst1};

        test.startTest();
        
        Cls_BatchDNDJDAAccountForecast objbatch = new Cls_BatchDNDJDAAccountForecast();
        database.executeBatch(objbatch);
        
        Cls_BatchDNDJDAPartForecast objbatch1 = new Cls_BatchDNDJDAPartForecast();
        database.executeBatch(objbatch1);
            
        test.stopTest();
    }
    
}