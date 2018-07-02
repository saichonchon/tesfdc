@isTest
public class InterestTagMonthlyCleanupBatch_Test{
    
    static testMethod void intesrestTag_Test1(){
    
        //prepare custom settings data
        AIT_Clean_Up_Date_range__c testRecord = new AIT_Clean_Up_Date_range__c(Name='Raw data',Months_old__c=6);
        insert testRecord;
        
        system.debug('=testRecord=>'+testRecord);
        
        Batch_Email_message_Users__c bemail=new Batch_Email_message_Users__c();
        bemail.Email_ID__c='nagaraju.gorli@capgemini.com;nagaraju.gorli@te.com;';
        bemail.Name='AITCleanUpActivity';
        insert bemail;
        
        
        system.debug('=bemail=>'+bemail);
        Id rawdatRTId= Schema.SObjectType.Interest_Tag__c.getRecordTypeInfosByName().get('Raw Data').getRecordTypeId();
        system.debug('====rawdatRTId===>'+rawdatRTId);
        
        //prepare Activity stage data
        Interest_Tag__c interestObj= new Interest_Tag__c();
        interestObj.Area_of_Interest__c='Manual';
        interestObj.CurrencyIsoCode='USD';
        interestObj.Activity_Record_Created__c=true;
        interestObj.Completely_Converted__c = true;
        interestObj.Activity_Class_Code__c= 'IN12';
        interestObj.Activity_Date_Time__c=system.today();
        interestObj.RecordTypeId=rawdatRTId;
        insert interestObj;
        Test.setCreatedDate(interestObj.Id, DateTime.newInstance(2012,12,12));
        
        Test.startTest();
        User u = ClsTestHelp.createTestUsers();
        u.email = 'nagaraju.gorli@capgemini.com';
        insert u;        
        
        InterestTagMonthlyCleanupBatch interestBC= new InterestTagMonthlyCleanupBatch();
        Database.executebatch(interestBC,200);
        Test.stopTest();
    }
     static testMethod void intesrestTag_Test2(){
    
        //prepare custom settings data      
        List<AIT_Clean_Up_Date_range__c> testRecords = new AIT_Clean_Up_Date_range__c[] 
        {new AIT_Clean_Up_Date_range__c(Name='Manual Tag',Months_old__c=6),
		 new AIT_Clean_Up_Date_range__c(Name='Raw data',Months_old__c=6),
		 new AIT_Clean_Up_Date_range__c(Name='Web Activity',Months_old__c=6),
		 new AIT_Clean_Up_Date_range__c(Name='Opportunity tag',Months_old__c=6)};
        insert testRecords;                        
        
        system.debug('=testRecord=>'+testRecords);
        
        Batch_Email_message_Users__c bemail=new Batch_Email_message_Users__c();
        bemail.Email_ID__c='333@222.com;';
        bemail.Name='AITCleanUpActivity';
        insert bemail;
        Id manualRTId= Schema.SObjectType.Interest_Tag__c.getRecordTypeInfosByName().get('Manual Interest Tag').getRecordTypeId();
        system.debug('====manualRTId===>'+manualRTId);
       
        
        //prepare Activity stage data
        Interest_Tag__c interestObj= new Interest_Tag__c();
        interestObj.Area_of_Interest__c='Manual';
        interestObj.CurrencyIsoCode='USD';
        interestObj.Activity_Record_Created__c=true;
        interestObj.Completely_Converted__c = true;
        interestObj.Activity_Class_Code__c= 'IN12';
        interestObj.Activity_Date_Time__c=system.today();
        interestObj.RecordTypeId=manualRTId;
        insert interestObj;
        Test.setCreatedDate(interestObj.Id, DateTime.newInstance(2012,12,12));
        
        Test.startTest();                
        InterestTagMonthlyCleanupBatch interestBC= new InterestTagMonthlyCleanupBatch();
        Database.executebatch(interestBC,200);
        Test.stopTest();        
    }
    
 }