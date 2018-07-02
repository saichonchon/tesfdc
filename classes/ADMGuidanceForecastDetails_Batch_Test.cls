/**********************************************************************
Name:  ADMGuidanceForecastDetails_Batch_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMGuidanceForecastDetails_Batch
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               Description
0.1        Supriya A          9/21/2017         INITIAL DEVELOPMENT     Test Class for ADMGuidanceForecastDetails_Batch
***********************************************************************/
@isTest
public class ADMGuidanceForecastDetails_Batch_Test{
    
    
    @TestSetup
    public static void testDataSetup() 
    {
        //Create Forecast Record with type Portfolio
        Forecast__c frCast = new Forecast__c();
        
        frCast= ADMTestDataFactory.createForecastObj('TestForecastExtid001','CON','BA','CAM','TestComments','Australia','Part Level',null,'Australiaregion','Portfolio'); 
        
        //Create Forecast Detail records
        List<Forecast_Detail__c> frcDetailsList = new List<Forecast_Detail__c>();
        
        frcDetailsList=ADMTestDataFactory.createForCastDetails(frCast.id,'Forecast');
        
        ADM_Forecast_Page_Customization__c GuiFcstDay = new  ADM_Forecast_Page_Customization__c();
        GuiFcstDay.Name ='CommentWidthandColorCoding';
        System.debug(' GuiFcstDay.Name...'+ GuiFcstDay.Name);
        GuiFcstDay.GuiFcstDay__c='15';
        GuiFcstDay.Color_Coding__c='#008000';
        GuiFcstDay.Comment_Width__c='150';
        insert GuiFcstDay;
        
        Trigger_Configuration__c tcadm = new Trigger_Configuration__c();
        tcadm.Name = 'DeleteForecastdetailrec';
        tcadm.isRun__c = true;
        insert tcadm;
        
    }
    
    //If there is no forecast detail record
    static testmethod void batchGuiFcstTest() {
        
        Forecast__c frCast= [ select Id,Name, External_ID__c from Forecast__c where External_ID__c=: 'TestForecastExtid001' ];
        Test.startTest();
        
        ADMGuidanceForecastDetails_Batch BatchGuiFcst  = new  ADMGuidanceForecastDetails_Batch();
        Database.executeBatch(BatchGuiFcst);
        Test.stopTest();
        System.debug([Select id, Type__c, Period__c from Forecast_Detail__c where Parent_Forecast__c =:frCast.id]);
        System.assert([Select id from Forecast_Detail__c where Parent_Forecast__c =:frCast.id AND Type__c = 'Guidance Forecast' ].size()>0);
        
    }
    
    //For forecast detail record for Current Fiscal Year
    Public static testmethod void batchGuiFcstCurrentYear(){
        
        String currentyr=String.valueOf(System.Today().year());
        Forecast__c frCast= [ select Id,Name, External_ID__c from Forecast__c where External_ID__c=: 'TestForecastExtid001' ];
        //Create Forecast Detail records of Type Guidance Forecast
        Forecast_Detail__c GuidanceFcstdet = new Forecast_Detail__c();
        GuidanceFcstdet.Type__c='Guidance Forecast';
        
        GuidanceFcstdet.M1__c=0;
        GuidanceFcstdet.M2__c=0;
        GuidanceFcstdet.M3__c=0;
        
        GuidanceFcstdet.M4__c=0;
        GuidanceFcstdet.M5__c=0;
        GuidanceFcstdet.M6__c=0;
        GuidanceFcstdet.M7__c=0;
        GuidanceFcstdet.M8__c=0;
        GuidanceFcstdet.M9__c=0;
        GuidanceFcstdet.M10__c=0;
        GuidanceFcstdet.M11__c=0;
        GuidanceFcstdet.M12__c=0;
        
        GuidanceFcstdet.Parent_Forecast__c=frCast.id;
        GuidanceFcstdet.Period__c=currentyr;
        System.debug('Period__c...'+GuidanceFcstdet.Period__c);
        insert GuidanceFcstdet;
        Test.startTest();
        ADMGuidanceForecastDetails_Batch BatchGuiFcst  = new  ADMGuidanceForecastDetails_Batch ();
        
        Database.executeBatch(BatchGuiFcst);
        
        Test.stopTest();
        
        
        
    }
    
    //For forecast detail record for Next Fiscal Year
    Public static testmethod void batchGuiFcstNextYear(){
        
        String nextyr=String.valueOf(System.Today().year()+1);  
        Forecast__c frCast= [ select Id,Name, External_ID__c from Forecast__c where External_ID__c=: 'TestForecastExtid001' ];
        
        //Create Forecast Detail records of Type Guidance Forecast
        Forecast_Detail__c GuidanceFcstdet = new Forecast_Detail__c();
        GuidanceFcstdet.Type__c='Guidance Forecast';
        
        GuidanceFcstdet.M1__c=0;
        GuidanceFcstdet.M2__c=0;
        GuidanceFcstdet.M3__c=0;
        GuidanceFcstdet.M4__c=0;
        GuidanceFcstdet.M5__c=0;
        GuidanceFcstdet.M6__c=0;
        GuidanceFcstdet.M7__c=0;
        GuidanceFcstdet.M8__c=0;
        GuidanceFcstdet.M9__c=0;
        GuidanceFcstdet.M10__c=0;
        GuidanceFcstdet.M11__c=0;
        GuidanceFcstdet.M12__c=0;
        GuidanceFcstdet.Parent_Forecast__c=frCast.id;
        GuidanceFcstdet.Period__c=nextyr;
        System.debug('Period__c...'+GuidanceFcstdet.Period__c);
        insert GuidanceFcstdet;
        
        Test.startTest();
        ADMGuidanceForecastDetails_Batch BatchGuiFcst  = new  ADMGuidanceForecastDetails_Batch();
        system.debug('BatchGuiFcst...'+BatchGuiFcst);
        Database.executeBatch(BatchGuiFcst);
        Test.stopTest();
        
    }
}