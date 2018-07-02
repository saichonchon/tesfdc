/**
*   This class is a help class.
*
@author Subramanian
@created 2018-02-03
@vercreateTestRecordType23sion 1.0
@since 20.0
*
*
*/

@isTest
public class ClsTestHelp2 {

List<TEMarketing__MQLRecord__c> MQLRecordList = new List<TEMarketing__MQLRecord__c>();
         
    public static TEMarketing__MQLRecord__c getMQLRecord(){
         TEMarketing__MQLRecord__c MQLRecord = new TEMarketing__MQLRecord__c();
         MQLRecord.TEMarketing__MQL_Date__c = system.now();
         
         return MQLRecord;
    }
    public static RecordType createTestRecordType1() {
        Id RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Central Lead').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Central_Lead',Name='Central Lead',SobjectType = 'Lead');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Lead' and DeveloperName = 'Central_Lead'];
            return rt;
        }
    } 
    
    public static Lead getLead(){
        Lead leadObj = new Lead(FirstName = 'xyzc', LastName = 'abcd', Email = 'FirstName.LastName@sampledomain.com', Company = 'Company 1', Status = 'Assigned Unaccepted');
        return leadObj;
    }
}