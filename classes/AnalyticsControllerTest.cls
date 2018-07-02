@isTest
public with sharing class AnalyticsControllerTest {
    static testMethod void testMethod1(){
        
        /** test controller */
        AnalyticsController ctrlCons = new AnalyticsController();
        ctrlCons.aLink = 'test';
        String str_result = ctrlCons.getALink();
    }
    
}