@isTest
public class ADMJDABookingForecastOEMMA_Batch_Test{
    @TestSetup
    public static void testDataSetup() 
    {
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        
        ADM_Region__c setting = new ADM_Region__c();
        setting.Name = 'Test Setting';
        setting.Region_Label__c = 'Test Setting';
        setting.Region_Value__c = 'Test Region';
        insert setting;
                
        ADMTerritoryCode__c ADMTeritoryCode = new ADMTerritoryCode__c();
        ADMTeritoryCode.Name = 'ADMTerritoryCode';
        ADMTeritoryCode.Territory_Code__c ='101485';
        insert ADMTeritoryCode;
   
        List<ADM_Custom_Setting__c> admSettingList = new List<ADM_Custom_Setting__c>();
        
        ADM_Custom_Setting__c admConfig = new ADM_Custom_Setting__c();
        admConfig.Name = 'ADM_DISTYForecastLevel';
        admConfig.Value__c = 'CBC3 Level';
        admSettingList.add(admConfig);
        
        ADM_Custom_Setting__c admConfig1 = new ADM_Custom_Setting__c();
        admConfig1.Name = 'ADM_OEMForecastLevel';
        admConfig1.Value__c = 'GPL Level';
        admSettingList.add(admConfig1);
        
        insert admSettingList;
   }  
    
    static testMethod void testJDABooking(){
        
       Test.startTest();
        Id ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();      
        
        Product_Hierarchy__c prod = new Product_Hierarchy__c();
        prod.Name = 'Hierarchy1';
        insert prod;
        
        Account acc1 = new Account();
        acc1.Name = 't'+system.now().millisecond()+math.round(math.random()*10000);
        insert acc1; 
        
        //for OEM
        Forecast__c frCast1 = ADMTestDataFactory.createForecastObj('TestForecastExtid002','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Portfolio');
        frCast1.Forecast_Level__c = 'GPL Level';
        
        update frCast1;
        
        List<Forecast_Detail__c> frcDetailsList1 = new List<Forecast_Detail__c>();        
        frcDetailsList1=ADMTestDataFactory.createForCastDetails(frCast1.id,'Forecast');
                
        ADMJDABookingForecastOEMMA_Batch bookJDA = new  ADMJDABookingForecastOEMMA_Batch();
        Database.executeBatch(bookJDA);
        
       Test.stopTest();
    }   
    static testMethod void testJDABooking1(){
     
       Test.startTest();
        Id ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
        
        Product_Hierarchy__c prod = new Product_Hierarchy__c();
        prod.Name = 'Hierarchy1';
        insert prod;
        
        Account acc1 = new Account();
        acc1.Name = 't'+system.now().millisecond()+math.round(math.random()*10000);
        insert acc1; 
        
        //for OEM
        Forecast__c frCast1 = ADMTestDataFactory.createForecastObj('TestForecastExtid002','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Market Adjustment');
        frCast1.Forecast_Level__c = 'CBC3 Level';
        
        update frCast1;
        
        List<Forecast_Detail__c> frcDetailsList = new List<Forecast_Detail__c>();        
        frcDetailsList=ADMTestDataFactory.createForCastDetails(frCast1.id,'Forecast');
        
        ADMJDABookingForecastOEMMA_Batch bookJDA = new  ADMJDABookingForecastOEMMA_Batch();
        Database.executeBatch(bookJDA);
        
       Test.stopTest();
    }
    
       
}