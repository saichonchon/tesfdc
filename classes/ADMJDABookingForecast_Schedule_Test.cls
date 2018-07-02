/**********************************************************************
Name:  ADMJDABookingForecast_Schedule_Test 
Copyright © 2017
======================================================
======================================================
Purpose: Test  Class for ADMJDABookingForecast_Schedule
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               
0.1        Kartik G          10/11/2017         INITIAL DEVELOPMENT     
***********************************************************************/
@isTest
public class ADMJDABookingForecast_Schedule_Test {
    
 public static testmethod void schedulerBatchADMJDABookingForecastTest(){
    Test.startTest();
   
    ADMJDABookingForecast_Schedule bc = new  ADMJDABookingForecast_Schedule();
    
    String sch = '0  00 1 3 * ?';
    string jobid = system.schedule('Test',sch,bc);
  
    Test.stopTest();
     
   }
}