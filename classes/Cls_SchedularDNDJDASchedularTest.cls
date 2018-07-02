@IsTest(SeeAllData=false)
public class Cls_SchedularDNDJDASchedularTest {
    
    public static testMethod void testschedule() {
        
        /* PRABHANJAN 14-Jun-16 Case:00901003  ADDDING CountingForward__c, CountingBack__c VARIABLES */  
        
        INFRA_JDA_Settings__c Config = new INFRA_JDA_Settings__c(name='DND',N_th_Day_of_Fiscal_Month__c=2.0, 
                                                                  CountingForward__c=10, CountingBack__c= -6);
        insert Config;
        INFRA__Part_Forecast__c PartForecast=new INFRA__Part_Forecast__c();
        PartForecast.INFRA__Business_Unit__c='DND';
        PartForecast.INFRA__Data_Stream__c='India';
        PartForecast.INFRA__Product_Code__c='Test';
        PartForecast.INFRA__Product_Hierarchy_Indicator__c='Test';
        insert PartForecast;
        
        INFRA__Account_Forecast__c AccountForecast= new INFRA__Account_Forecast__c();
        AccountForecast.INFRA__Business_Unit__c='test';
        AccountForecast.INFRA__Customer_Indicator__c = 'India1';
        AccountForecast.INFRA__Customer__c='test';
        AccountForecast.INFRA__Data_Stream__c='tst';
        AccountForecast.INFRA__Forecast_Key__c='test';
        
        Period vPeriod = [SELECT StartDate, EndDate 
                          FROM Period 
                          WHERE Type = 'Month' 
                          AND StartDate <= TODAY 
                          AND EndDate >= TODAY];
        system.debug('+++++++++++++'+vPeriod);                         
        
        Period objPeriod  = new Period ();
        objPeriod .Type = 'Month' ;
        objPeriod .StartDate= system.today()-1 ;
        objPeriod .EndDate= system.today()+1 ;
        //insert objPeriod;   
        
        insert AccountForecast;
        //delete AccountForecast;
        //delete PartForecast;
        
        
        
        Test.StartTest();
        Cls_SchedularDNDJDASchedular sc=new Cls_SchedularDNDJDASchedular();
        
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sc);
        //Cls_BatchJDAPartForecast vBatch = new Cls_BatchJDAPartForecast();
        //     Id batchInstanceId = Database.executeBatch(vBatch, 100);  
        
        Test.stopTest();
    }
}