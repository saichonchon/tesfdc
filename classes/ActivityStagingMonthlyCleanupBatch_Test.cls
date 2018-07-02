@isTest
public class ActivityStagingMonthlyCleanupBatch_Test{
 
    static testMethod void AcuivityBatchCls_Test1(){
    
        //prepare custom settings data
        AIT_Clean_Up_Date_range__c testRecord = new AIT_Clean_Up_Date_range__c(Name='ActivityStage',Months_old__c=6);
        insert testRecord;
        system.debug('=testRecord=>'+testRecord);
        
        Batch_Email_message_Users__c bemail=new Batch_Email_message_Users__c();
        bemail.Email_ID__c='nagaraju.gorli@capgemini.com';
        bemail.Name='AITCleanUpActivity';
        insert bemail;
        
        system.debug('=bemail=>'+bemail);
        //prepare Activity stage data
        Key_Activity_Staging__c KASnputs = new Key_Activity_Staging__c();
        KASnputs.Name = 'JOB12';
        KASnputs.CurrencyIsoCode='USD';
        insert KASnputs;
        Test.setCreatedDate(KASnputs.Id, DateTime.newInstance(2012,12,12));
        
        system.debug('====KASnputs===>'+KASnputs);        
        
        Test.startTest();
        User u = ClsTestHelp.createTestUsers();
        u.email = 'nagaraju.gorli@capgemini.com';
        insert u;        
        ActivityStagingMonthlyCleanupBatch BC1= new ActivityStagingMonthlyCleanupBatch();
        Database.executebatch(BC1,200);
        Test.stopTest();
    }
    static testMethod void AcuivityBatchCls_Test2(){
    
        //prepare custom settings data
        AIT_Clean_Up_Date_range__c testRecord = new AIT_Clean_Up_Date_range__c(Name='ActivityStage',Months_old__c=6);
        insert testRecord;
        system.debug('=testRecord=>'+testRecord);
        
        Batch_Email_message_Users__c bemail=new Batch_Email_message_Users__c();
        bemail.Email_ID__c='nagaraju.gorli@capgemini.com;te123@te.com';
        bemail.Name='AITCleanUpActivity';
        insert bemail;
        
        system.debug('=bemail=>'+bemail);
        //prepare Activity stage data
        Key_Activity_Staging__c KASnputs = new Key_Activity_Staging__c();
        KASnputs.Name = 'JOB12';
        KASnputs.CurrencyIsoCode='USD';
        insert KASnputs;
        Test.setCreatedDate(KASnputs.Id, DateTime.newInstance(2012,12,12));
        
        system.debug('====KASnputs===>'+KASnputs);
        
        Test.startTest();
        ActivityStagingMonthlyCleanupBatch BC1= new ActivityStagingMonthlyCleanupBatch();
        Database.executebatch(BC1,200);
        Test.stopTest();
    }
 
 }