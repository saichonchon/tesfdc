/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   A test class for Fetch_Records.cls.
Inputs:        
Test Class:    
History
2018-03-19     Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
@isTest
public class Fetch_RecordsTest {
    
    static testMethod void myUnitTest1() {
    	User objUser = [SELECT Id, Name,Profile.Name FROM User WHERE Id =: Userinfo.getUserId()];
    	Reports_Dashboard_Permission_Conf__c rdpc = new Reports_Dashboard_Permission_Conf__c();
    	rdpc.Profile__c = objUser.Profile.Name;
    	insert rdpc;
    	Fetch_Records f = new Fetch_Records();
    	f.getUserTypes();
    	f.changeUsertype();
    }
    
}