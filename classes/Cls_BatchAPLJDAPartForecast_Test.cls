@istest(seeAllData=false)
public class Cls_BatchAPLJDAPartForecast_Test
{
    public static testmethod void Cls_BatchAPLJDAPartForecast_UT()
    {
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings(); 
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getCaseFinalVariables();        
        ClsTestCustomSettingHelper.getWebToCaseStrings();
        ClsTestCustomSettingHelper.getINFRA_JDA_Settings();
        ClsTestCustomSettingHelper.getINFRA_JDA_Connector_Config();
        list<Period> lstYearPeriod = [SELECT StartDate, EndDate FROM Period where Enddate > :Date.Today() AND Startdate < :Date.Today() and type = :'Year' order by startdate limit 1];
        list<Period> lstCurrPeriod = [SELECT StartDate, EndDate, NUMBER FROM Period where Enddate > :Date.Today() AND Startdate < :Date.Today() and type = :'Quarter' order by startdate limit 1];
            
        
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
        insert acc; 
        
        APL_Sales_Forecast__c oAPL_Sales_Forecast1 = new APL_Sales_Forecast__c(Customer__c = acc.id, Type__c = 'GPL', RSM_Quantity__c = 1, RSM_Forecast__c = 1, Fiscal_Year__c = string.ValueOf(lstYearPeriod[0].Enddate.year()), Fiscal_Quarter__c = string.ValueOf('0' + lstCurrPeriod[0].Number));
        APL_Sales_Forecast__c oAPL_Sales_Forecast2 = new APL_Sales_Forecast__c(Customer__c = acc.id, Type__c = 'Relay Product Code', RSM_Quantity__c = 1, RSM_Forecast__c = 1, Fiscal_Year__c = string.ValueOf(lstYearPeriod[0].Enddate.year()), Fiscal_Quarter__c = string.ValueOf('0' + lstCurrPeriod[0].Number));
        APL_Sales_Forecast__c oAPL_Sales_Forecast3 = new APL_Sales_Forecast__c(Customer__c = acc.id, Type__c = 'Other CBC2', RSM_Quantity__c = 1, RSM_Forecast__c = 1, Fiscal_Year__c = string.ValueOf(lstYearPeriod[0].Enddate.year()), Fiscal_Quarter__c = string.ValueOf('0' + lstCurrPeriod[0].Number));
        insert new list<APL_Sales_Forecast__c> {oAPL_Sales_Forecast1, oAPL_Sales_Forecast2, oAPL_Sales_Forecast3};
        
        Cls_BatchAPLJDAPartForecast o = new Cls_BatchAPLJDAPartForecast();
        
        
        test.starttest();
                Cls_BatchAPLJDAPartForecast.getExchangeRate();
                System.schedule('testCls_BatchAPLJDAPartForecast' + Math.random(),  '0 0 0 3 9 ? 2032',  new Cls_SchedularAPLJDAPartForecast());
        test.stoptest();
    
    }
}