/**********************************************************************
Name:  ADMForecastTriggerHandler_Test
======================================================
======================================================
Purpose: Test Class for ADMForecastTriggerHandler
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               Description
0.1        Kartik G          10/07/2017         INITIAL DEVELOPMENT
***********************************************************************/
@istest
public class ADMForecastTriggerHandler_Test
{
    //Change the Forecast record type either from Portfolio to Non-Portfolio or viceversa
    //Forecast Detail record of Type YoY Variance and Forecast/Auto-forecast for CFY and NFY will get deleted
    
    @istest
    Public static void forecastTriggerNonPortfolio(){
        
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        String currentyr = currentfisobj.name;
        String nextyr= String.valueOf(Integer.ValueOf(currentyr)+1);
        List<String> listyrs = new list<String>{currentyr, nextyr};
        
        //Insert Custom Setting
        Trigger_Configuration__c tcadm = new Trigger_Configuration__c();
        tcadm.Name='DeleteForecastdetailrec';
        tcadm.isRun__c=true;
        insert tcadm;
        
        //Create Forecast Record with type Portfolio
        Forecast__c frCast = ADMTestDataFactory.createForecastObj('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Portfolio'); 
        
        //Create Forecast Detail records
        List<Id> fdNonDeleteIdList = new List<Id>();
        List<Forecast_Detail__c> fdlist = new List<Forecast_Detail__c>();
        
        fdlist.addAll(ADMTestDataFactory.createForCastDetails(frCast.id,'Guidance Forecast'));
        fdlist.addAll(ADMTestDataFactory.createForCastDetails(frCast.id,'Actuals'));
        // Add Ids of records that should not be deleted to the list
        for(Forecast_Detail__c fd: fdlist){
            fdNonDeleteIdList.add(fd.id);
        }
        fdlist.addall(ADMTestDataFactory.createForCastDetails(frCast.id,'YoY Variance'));
        fdlist.addall(ADMTestDataFactory.createForCastDetails(frCast.id,'Forecast'));
        
        Test.startTest();
        
        System.assert([Select id from Forecast_Detail__c where Parent_Forecast__c = :frCast.id AND Period__c IN :listyrs AND Type__c In ('YoY Variance','Forecast')].size()>0);
        
        // Change Forecast Type to Non-Portfolio
        frCast.Type__c='Non-Portfolio';
        update frCast;
        
        //Verify that only Forecast and YoY Variance records are deleted
        
        System.assert([Select id from Forecast_Detail__c where Parent_Forecast__c = :frCast.id AND Period__c IN :listyrs AND Type__c In ('YoY Variance','Forecast')].size()==0);
        Test.stopTest();
    }
    @istest
    Public static void forecastTriggerPortfolio(){
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        String currentyr = currentfisobj.name;
        String nextyr= String.valueOf(Integer.ValueOf(currentyr)+1);
        List<String> listyrs = new list<String>{currentyr, nextyr};
       
        //Insert Custom Setting
        Trigger_Configuration__c tcadm = new Trigger_Configuration__c();
        tcadm.Name='DeleteForecastdetailrec';
        tcadm.isRun__c=true;
        insert tcadm;
        
        //Create Forecast Record with type Non-Portfolio
        Forecast__c frCast = ADMTestDataFactory.createForecastObj('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Non-Portfolio'); 
        
        //Create Forecast Detail records
        List<Id> fdNonDeleteIdList = new List<Id>();
        List<Forecast_Detail__c> fdlist = new List<Forecast_Detail__c>();
        
        fdlist.addAll(ADMTestDataFactory.createForCastDetails(frCast.id,'Guidance Forecast'));
        fdlist.addAll(ADMTestDataFactory.createForCastDetails(frCast.id,'Actuals'));
        // Add Ids of records that should not be deleted to the list
        for(Forecast_Detail__c fd: fdlist){
            fdNonDeleteIdList.add(fd.id);
        }
        fdlist.addall(ADMTestDataFactory.createForCastDetails(frCast.id,'YoY Variance'));
        fdlist.addall(ADMTestDataFactory.createForCastDetails(frCast.id,'Auto-Forecast'));
        
        System.assert([Select id from Forecast_Detail__c where Parent_Forecast__c = :frCast.id AND Period__c IN :listyrs AND Type__c In ('YoY Variance','Auto-Forecast')].size()>0);
        // Change Forecast Type to Portfolio
        frCast.Type__c='Portfolio';
        update frCast;
        //Verify that only Forecast and YoY Variance records are deleted
        System.assert([Select id from Forecast_Detail__c where Parent_Forecast__c = :frCast.id AND Period__c IN :listyrs AND Type__c In ('YoY Variance','Auto-Forecast')].size()==0);
        
    }
}