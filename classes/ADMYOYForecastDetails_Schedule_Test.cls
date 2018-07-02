/**********************************************************************
Name: ADMYOYForecastDetails_Schedule_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMYOYForecastDetails_Schedule
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL                   Description
=================================================================================================================================
1.0          Altaf	            11/06/2017        INITIAL DEVELOPMENT	   Test class for ADMYOYForecastDetails_Schedule
**********************************************************************************************************************************/

@isTest
public class ADMYOYForecastDetails_Schedule_Test {
    
    public static testmethod void schedulerBatchGuiFcstTest(){
        Test.startTest();
        
        ADMYOYForecastDetails_Schedule bc = new  ADMYOYForecastDetails_Schedule();
        
        ADM_Forecast_Page_Customization__c GuiFcstDay = new  ADM_Forecast_Page_Customization__c();
        GuiFcstDay.Name ='CommentWidthandColorCoding';
        System.debug(' GuiFcstDay.Name...'+ GuiFcstDay.Name);
        GuiFcstDay.GuiFcstDay__c='15';
        GuiFcstDay.Color_Coding__c='#008000';
        GuiFcstDay.Comment_Width__c='150';
        insert GuiFcstDay;
        
        ADM_Custom_Setting__c batchSize = new ADM_Custom_Setting__c();
            batchSize.Name = 'Forecast_BatchSize';
            batchSize.Value__c = '50';
            insert batchSize;
        
        String sch = '0  00 1 4 * ?';
        string jobid = system.schedule('Test',sch,bc);
        
        Test.stopTest();        
    }
}