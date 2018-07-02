/**********************************************************************
Name:  ADMEntryScreenHelper_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMEntrySreenHelper
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               Description
1.0        Suresh Aepoor         8/29/2017         INITIAL DEVELOPMENT ADMEntryScreenHelper class Test Class
***********************************************************************/
@isTest
public class ADMEntryScreenHelper_Test {
    static List<Forecast__c> frCastList; 
    static List<Forecast_Detail__c> frDetailList; 
    static Account acc;
    static List<Product_Hierarchy__c> productList;
    static List<Sales_Hierarchy__c> saleshirarchyList;   
    
    //Testing the ADMEntryScreenHelper class functionality
    Public static testmethod void ADMEntryScreenHelperTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='ADM Standard User']; 
        User u = new User( ADM_User_Type__c= 'Sales Engineer Manager',Te_Network_Id__c='TE3241861',Alias = 'ktest', Email='test6.test@te.com', 
                          UserName='test6.test@te.com.admdev',EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');
        System.RunAs(u) {      
            
            Test.StartTest();  
             
            ClsTestCustomSettingHelper.getTriggerConfigurationSettings();        
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();        
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();        
            ClsTestCustomSettingHelper.getApex_Helper_Settings();  
            ADMTestDataFactory.getADM_CustomSetting();           
            
            String Level7AssignedUser = UserInfo.getUserId();
            String TEID = u.Te_Network_Id__c;
            Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
            sh = ADMTestDataFactory.CreateSalesHierarchy('Test','A001989','test',TEID);        
            update sh;    
            System.Debug('sh=====>'+sh);    
            
            List<Product_Hierarchy__c> ProdList = new List<Product_Hierarchy__c>();
            ProdList = ADMTestDataFactory.productHierarchyDetails('GPL', 'CBC2', 'CBC3', 'CBC4', 'GPLDec');
            insert ProdList;
            List<account> acc = ADMTestDataFactory.accountDetails('TestAccount', 'SoldToCustomerNum', 'Musterstadt','CN', 'OEM','072','77777' );
            
            Test.StopTest();
            
            String CurrentUserid = UserInfo.getUserId();
            ADMEntryScreenHelper.getforecastrec('OEM', acc[0].id, acc[0].id, '1234','EMEA', 'district', 'sbuval', 'userid', 'Sales Engineer', CurrentUserid, 'SoldToCustomerNum','CBC3',100,50,null); 
            ADMEntryScreenHelper.getforecastrec('OEM', acc[0].id, acc[0].id, '1234','EMEA', 'district', 'sbuval', 'userid', 'Sales Engineer Manager', CurrentUserid, 'SoldToCustomerNum','CBC3',100,50,null); 
            ADMEntryScreenHelper.getforecastrec('Distributor', acc[0].id, acc[0].id, '1234','EMEA', 'district', 'sbuval' , 'userid', 'Distribution Manager', CurrentUserid, 'SoldToCustomerNum','CBC3',100,50,null);
            Set<String> SetId = new Set<String>();
            for(integer i=0; i<110; i++) {
                SetId.add('Test'+i);
            }
            ADMEntryScreenHelper.getExMonthlyActualSales(SetId);  
            ADMEntryScreenHelper.getExForecastDailyActual(SetId); 
            Set<String> SetId1 = new Set<String>();
            SetId1.add('1234');
            SetId1.add('12345');
            ADMEntryScreenHelper.getExMonthlyActualSales(SetId1);  
            ADMEntryScreenHelper.getExForecastDailyActual(SetId1);  
        }     
    }          
}