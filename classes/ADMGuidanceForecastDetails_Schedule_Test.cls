/**********************************************************************
Name: ADMGuidanceForecastDetails_Schedule_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMGuidanceForecastDetails_Schedule
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL              
0.1        Kartik G          9/20/2017         INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class ADMGuidanceForecastDetails_Schedule_Test {
    
    public static testmethod void schedulerBatchGuiFcstTest(){
        Test.startTest();
        
        ADMGuidanceForecastDetails_Schedule bc = new  ADMGuidanceForecastDetails_Schedule();
        
            ADM_Forecast_Page_Customization__c GuiFcstDay = new  ADM_Forecast_Page_Customization__c();
        GuiFcstDay.Name ='CommentWidthandColorCoding';
        System.debug(' GuiFcstDay.Name...'+ GuiFcstDay.Name);
        GuiFcstDay.GuiFcstDay__c='15';
        GuiFcstDay.Color_Coding__c='#008000';
        GuiFcstDay.Comment_Width__c='150';
        insert GuiFcstDay;
        
        String sch = '0  00 1 3 * ?';
        string jobid = system.schedule('Test',sch,bc);
        
        Test.stopTest();
        
    }
}