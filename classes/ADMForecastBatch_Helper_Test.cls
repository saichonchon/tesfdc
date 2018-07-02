/**********************************************************************
Name:  ADMForecastBatch_Helper_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test  Class for ADMForecastBatch_Helper
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               
0.1        Kartik G          10/11/2017         INITIAL DEVELOPMENT     
***********************************************************************/
@isTest
public class ADMForecastBatch_Helper_Test{
    
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
    
    //For testing helper delete method
    static testMethod void testFDDeleteBatch(){
        Id ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
        //Adding Forecast Detail records in List
        List<Forecast__c> fclist = new List<Forecast__c>();
        Forecast__c fc = [Select Id,name  from Forecast__c LIMIT 1];
        fc.RecordTypeId = ForecastRecordTypeId ;
        fc.id = null;
        System.debug('fc...'+fc);
        fclist.add(fc);
        
        Forecast_Detail__c frcDetail = new Forecast_Detail__c();
        List<Forecast_Detail__c> fdList = new List<Forecast_Detail__c>();
        
       
        frcDetail = ADMTestDataFactory.createForecastDetailsForHistorical(fclist[0].id,'2014','Forecast');
        fdList.add(frcDetail);
        
        //We created forecast detail again for checking exception code
        Forecast_Detail__c frcDetail1 = new Forecast_Detail__c();
        frcDetail1 = ADMTestDataFactory.createForecastDetailsForHistorical(fclist[0].id,'2011','Forecast');
        Id fdid= frcDetail1.id;
        Delete frcDetail1;
        
        Forecast_Detail__c fde = new Forecast_Detail__c();
        fde.id = fdid;
        fdList.add(fde);
        
        System.debug('fdList----'+fdList);
        Database.DeleteResult[] result= Database.delete(fdList, false);        
        ADMForecastBatch_Helper.deletedForecastDetail(fdList,result); 
    
    }
   
    //For testing helper Update method
    static testMethod void testFDUpdateBatch(){  
        //Adding Forecast Detail records in List
        List<Forecast_Detail__c> fclist = new List<Forecast_Detail__c>();
        Forecast_Detail__c fc = [Select Id,Type__c,Parent_Forecast__c  from Forecast_Detail__c LIMIT 1]; 
        System.debug('fc...'+fc);
        fc.type__c='test';
        fclist.add(fc);
        
        
        Database.SaveResult[] result = Database.update(fclist, false);
        ADMForecastBatch_Helper.updatedForecastDetail(fclist,result);
        //ADMForecastDetailDelete_Helper.save(fc.id);
        
    }
    
     //For testing helper upsert method
    static testMethod void testupsertBatch(){
        Test.startTest();
        //Adding Forecast Detail records in List
        List<Forecast_Detail__c> fclist = new List<Forecast_Detail__c>();
        Forecast_Detail__c fc = [Select Id,Type__c,Parent_Forecast__c  from Forecast_Detail__c LIMIT 1]; 
        fclist.add(fc);
        
        //Adding Invalid Forecast Detail Type
        if(!fclist.isEmpty())
        fclist[0].type__c='test';
        Database.UpsertResult[] result1 = Database.upsert(fclist, false);
       ADMForecastBatch_Helper.upsertedForecastDetail(fclist,result1);
        
        Test.stopTest();
    }
    
}