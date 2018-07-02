/**********************************************************************
Name: ADMForecastDetailsDelete_Schedule_Test
Copyright © 2017
==========================================================================================================
==========================================================================================================
Purpose:Test class for Schedule class to run batch class for Forecast detail Deletion                                                      
==========================================================================================================
==========================================================================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Kartik            10/12/2017       INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class ADMForecastDetailsDelete_Schedule_Test {
    
    @TestSetup
    public static void testDataSetup() 
    {
        List<Product_Hierarchy__c> ProdHierchy = new List<Product_Hierarchy__c>();
        ProdHierchy = ADMTestDataFactory.productHierarchyDetails('Test GPLName', 'cbc2', 'cbc3', 'cbc4', 'GPL description');
        Id prodHcyId = ProdHierchy[0].id;
        
        //Create Forecast Record with type Portfolio
        Forecast__c frCast = new Forecast__c();       
        frCast= ADMTestDataFactory.createForecastObj('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','Part Level',prodHcyId,'Australiaregion','Portfolio'); 
        
        //Create Forecast Detail records
        Forecast_Detail__c frcDetail = new Forecast_Detail__c();
        
        frcDetail = ADMTestDataFactory.createForecastDetailsForHistorical(frCast.id,'2014','Forecast');
        
        ErrorLog__c newErrorObj = new ErrorLog__c();
        newErrorObj.Class__c          = 'ADM_ForecastDetailDelete_Batch';
        newErrorObj.Method_Name__c    = 'execute';
        //   String RecordId=(String)scope[cnt].get('Id');
        //  newErrorObj.SFDC_Record_Id__c = RecordId;
        newErrorObj.Error_Message__c = '';
        insert newErrorObj;
    }

    
     public static testmethod void schedulerBatchADMForecastDetailsDeleteTest(){
     Test.startTest();
        
        ADMForecastDetailsDelete_Schedule bc = new  ADMForecastDetailsDelete_Schedule();
    
        String sch = '0  00 1 3 * ?';
        string jobid = system.schedule('Test',sch,bc);
  
    Test.stopTest();
   }

}