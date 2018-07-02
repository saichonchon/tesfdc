@IsTest 
public class Cls_TestDNDJDAPartForecast{

     public static testMethod void insertdata() {
         test.startTest();
         CSD_Sales_Forecast__c SalesForecast = new CSD_Sales_Forecast__c();
         SalesForecast.Billing_Region__c= 'AMERICAS';
         SalesForecast.Sold_To_Number__c='Test';
         SalesForecast.Sale_Territory__c='Test1';
         SalesForecast.Forecast__c= 100.00;
         SalesForecast.Quantity__c=2356;
         SalesForecast.Price__c=5600;
         SalesForecast.Type__c='OEM';
         SalesForecast.Samsung_Type__c ='Non SoldTo';
         SalesForecast.Fiscal_Year__c = '2016';
         SalesForecast.Fiscal_Month__c = '01'; 
         insert SalesForecast;
         
         
         INFRA__JDA_Connector_Config__c config = new INFRA__JDA_Connector_Config__c();
         config.Name = 'DND';
         config.INFRA__Default_Period_Indicator__c='401';
         config.INFRA__Site_Indicator__c = '103';
         config.INFRA__Site__c='OTHER';  
         insert config;
         ClsTestHelp.initAPLTestData();
        Account oAccount = ClsTestHelp.createTestAccounts();
        insert oAccount;
 
        Product_Hierarchy__c oProductHierarchy = new Product_Hierarchy__c();
        insert oProductHierarchy;
        
        Part__c oPart = new Part__c(Product_Hierarchy__c = oProductHierarchy.id);
        insert oPart;
         List<CSD_Sales_Forecast__c> csdsalesforecast = new List<CSD_Sales_Forecast__c>();   
         CSD_Sales_Forecast__c SalesForecast2 = new CSD_Sales_Forecast__c();
         SalesForecast2.Billing_Region__c= 'AMERICAS';
         SalesForecast2.Sold_To_Number__c='Test';
         SalesForecast2.Sale_Territory__c='Test1';
         SalesForecast2.Forecast__c= 100.00;
         SalesForecast2.Quantity__c=2356;
         SalesForecast2.Price__c=5600;
         SalesForecast2.Type__c='OEM'; 
         SalesForecast2.OEM__c=oAccount.Id;
         SalesForecast2.Part__c=oPart.Id;
         SalesForecast2.Samsung_Type__c ='Non Part';
         SalesForecast2.Fiscal_Year__c = '2016';
         SalesForecast2.Fiscal_Month__c = '01';
         
         csdsalesforecast.add(SalesForecast2);
          
         CSD_Sales_Forecast__c SalesForecast3 = new CSD_Sales_Forecast__c();
         SalesForecast3.Billing_Region__c= 'AMERICAS';
         SalesForecast3.Sold_To_Number__c='Test';
         SalesForecast3.Sale_Territory__c='Test1';
         SalesForecast3.Forecast__c= 100.00;
         SalesForecast3.Quantity__c=2356;
         SalesForecast3.Price__c=5600;
         SalesForecast3.Type__c='OEM'; 
         SalesForecast3.OEM__c=oAccount.Id;
         SalesForecast3.Samsung_Type__c ='Non Part';
         SalesForecast3.Fiscal_Year__c = '2016';
         SalesForecast3.Fiscal_Month__c = '01';
         csdsalesforecast.add(SalesForecast3);
         
         
         CSD_Sales_Forecast__c SalesForecast4 = new CSD_Sales_Forecast__c();
         SalesForecast4.Billing_Region__c= 'AMERICAS';
         SalesForecast4.Sold_To_Number__c='Test';
         SalesForecast4.Sale_Territory__c='Test1';
         SalesForecast4.Forecast__c= 100.00;
         SalesForecast4.Quantity__c=2356;
         SalesForecast4.Price__c=5600;
         SalesForecast4.Type__c='OEM';
         SalesForecast4.Samsung_Type__c ='Non SoldTo';
         SalesForecast4.Fiscal_Year__c = '2017';
         SalesForecast4.Fiscal_Month__c = '01';
         csdsalesforecast.add(SalesForecast4); 
                  
         CSD_Sales_Forecast__c SalesForecast5 = new CSD_Sales_Forecast__c();
         SalesForecast5.Billing_Region__c= 'AMERICAS';
         SalesForecast5.Sold_To_Number__c='Test';
         SalesForecast5.Sale_Territory__c='Test1';
         SalesForecast5.Forecast__c= 100.00;
         SalesForecast5.Quantity__c=2356;
         SalesForecast5.Price__c=5600;
         SalesForecast5.Type__c='OEM'; 
         SalesForecast5.OEM__c=oAccount.Id;
         SalesForecast5.Part__c=oPart.Id;
         SalesForecast5.Samsung_Type__c ='Non Part';
         SalesForecast5.Fiscal_Year__c = '2017';
         SalesForecast5.Fiscal_Month__c = '01';
         
         csdsalesforecast.add(SalesForecast5);
                           
         CSD_Sales_Forecast__c SalesForecast6 = new CSD_Sales_Forecast__c();
         SalesForecast6.Billing_Region__c= 'AMERICAS';
         SalesForecast6.Sold_To_Number__c='Test';
         SalesForecast6.Sale_Territory__c='Test1';
         SalesForecast6.Forecast__c= 100.00;
         SalesForecast6.Quantity__c=2356;
         SalesForecast6.Price__c=5600;
         SalesForecast6.Type__c='OEM'; 
         SalesForecast6.OEM__c=oAccount.Id;
         SalesForecast6.Samsung_Type__c ='Non Part';
         SalesForecast6.Fiscal_Year__c = '2017';
         SalesForecast6.Fiscal_Month__c = '01';
         
         csdsalesforecast.add(SalesForecast6);
         
         insert csdsalesforecast;
         
         
           /* PRABHANJAN 14-Jun-16 Case:00901003  ADDDING CountingForward__c, CountingBack__c VARIABLES */  
         
         INFRA_JDA_Settings__c Config2 = new INFRA_JDA_Settings__c(name='DND',N_th_Day_of_Fiscal_Month__c=2.0, 
                                                                   CountingForward__c=10, CountingBack__c= -6);
         insert Config2;
         
Cls_BatchDNDJDAPartForecast sf= new Cls_BatchDNDJDAPartForecast();
Database.executeBatch(sf);
test.stopTest();

}
}