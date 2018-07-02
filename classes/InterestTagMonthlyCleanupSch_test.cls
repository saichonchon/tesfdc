/**
*  
* @author      :Nagaraju Gorli
* @created     :2017-07-25                                                          
*     
*/
@istest
public class InterestTagMonthlyCleanupSch_test{

    static testMethod void activitytest(){
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
        
        InterestTagMonthlyCleanupSch it= new InterestTagMonthlyCleanupSch();
        SchedulableContext SC;
        it.execute(sc); 
    }
}