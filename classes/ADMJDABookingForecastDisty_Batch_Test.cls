@isTest
public class ADMJDABookingForecastDisty_Batch_Test{
    @TestSetup
    public static void testDataSetup() 
    {
        Forecast__c frCast = new Forecast__c();
        //frCast= ADMTestDataFactory.createForecastObj('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Portfolio'); 
        
        ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        
        List<Forecast_Detail__c> frcDetailsList = new List<Forecast_Detail__c>();
        frcDetailsList=ADMTestDataFactory.createForCastDetails(frCast.id,'Forecast');              
         
        ADM_Region__c setting = new ADM_Region__c();
        setting.Name = 'Test Setting';
        setting.Region_Label__c = 'Test Setting';
        setting.Region_Value__c = 'Test Region';
        insert setting;
                
        ADMTerritoryCode__c ADMTeritoryCode = new ADMTerritoryCode__c();
        ADMTeritoryCode.Name = 'ADMTerritoryCode';
        ADMTeritoryCode.Territory_Code__c ='101485';
        insert ADMTeritoryCode;
   
        ADM_Custom_Setting__c admConfig = new ADM_Custom_Setting__c();
        admConfig.Name = 'ADM_DISTYForecastLevel';
        admConfig.Value__c = 'CBC3 Level';
        insert admConfig;
        
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
        
        Forecast__c frCast= ADMTestDataFactory.createForecastObj('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Portfolio');
        frCast.Forecast_Level__c = 'CBC3 Level';
        frCast.RecordTypeId = ForecastRecordTypeId;
        update frCast;
        
        List<Forecast_Detail__c> frcDetailsList = new List<Forecast_Detail__c>();        
        frcDetailsList=ADMTestDataFactory.createForCastDetails(frCast.id,'Forecast');       
        
        ADMJDABookingForecastDisty_Batch bookJDA = new  ADMJDABookingForecastDisty_Batch();
        Database.executeBatch(bookJDA);
        
       Test.stopTest();
    }   
    
}