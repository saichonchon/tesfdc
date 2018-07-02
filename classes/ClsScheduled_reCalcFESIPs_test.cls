/**
 * This class contains unit tests for validating the behavior of ClsScheduled_reCalcFESIPs
 *
 @author Bin Yuan
 @created 2014-01-08
 @version 1.0
 @since 29.0
 *
 @changelog
 * coverage 88% 
 * 
 * 2014-01-08 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
@isTest
private class ClsScheduled_reCalcFESIPs_test{
    static testMethod void testSchedule() {
            
        
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        if(min <= 58) {
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        }
        else {         
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        }
        
        test.startTest(); 
        User user = new User();
        user=ClsTestHelp.createTestUsers();
        user.Te_Network_Id__c = 'testUser';
        insert user;
        
        Load_Status__c ls = new Load_Status__c();
        String recordTypeFE;
        for (RecordType recordType : [select Id, Name, DeveloperName from RecordType where SobjectType = 'SIP__c' and IsActive = true and DeveloperName = 'FE_Plan' ]) {		
            recordTypeFE = recordType.Id; 
        } 
        SIP_master__c sipMaster = new SIP_master__c();
        sipMaster.Name = 'Test Master';
        insert sipMaster;
        
        SIP__c sipFE = new SIP__c();
        sipFE.Plan_Participant__c = user.Id;
        sipFE.RecordTypeId = recordTypeFE;
        sipFE.Plan_Year__c = '2013';
        sipFE.Name = 'test FE';
        sipFE.Approver__c = user.Id;
        sipFE.SIP_master_record__c = sipMaster.Id;
        sipFE.Prev_Year_YTD_Direct_billings__c  = 100;
        insert sipFE;
        ClsScheduled_reCalcFESIPs cls = new ClsScheduled_reCalcFESIPs();
        String jobId = system.schedule('test', sch, cls); 
            
        Test.stopTest(); 
    }
}