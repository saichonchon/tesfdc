/**  
 * @Author: Subba Vanipenta
 * @Date :09/24/2015
 * @Description : This test class is used for testing the Batch_FreezeUserNotificationToBUAdmins
 * @Version:1 - Initial Development
 */

@isTest
public class Batch_FreezeUserNoticeToBUAdmin_Test {
    static testmethod void testDataForBatch(){
        list<User> vTestUsers = createTestUsers();
        insert vTestUsers;
        system.assert(string.isNotBlank(vTestUsers[0].FederationIdentifier));
        system.assertEquals(8, vTestUsers.size());
        system.runAs(vTestUsers[0]){
            ClsTestCustomSettingHelper.getAllSettings();
        	list<Contact> vTestContacts = createTestContacts();
        	insert vTestContacts; 
            system.assertEquals(9, vTestContacts.size());
            system.assertEquals(true, vTestContacts[0].Inactive__c);
            ClsTestCustomSettingHelper.getOrgWideSettings();            
            list<FreezeUserNotificationToBUAdmins__c> vFreezeUserCS = createFreezeUserSettingsList();
            Test.startTest();            
        	Batch_FreezeUserNotificationToBUAdmins vTestObjBatchClass = new Batch_FreezeUserNotificationToBUAdmins();
            Database.BatchableContext BC;             
            vTestObjBatchClass.start(BC);
            vTestObjBatchClass.execute(BC,vTestUsers);  
            vTestObjBatchClass.finish(BC);     
            Test.stopTest();
        }
    }
    //Prepare test Contact
    public static list<contact> createTestContacts(){
        //Insert Parent Account data to refer in contacts;
        Account vTestAccount = createTestAccount();
        insert vTestAccount;
        //prepare test data
        list<contact> vTestContactList = new list<Contact>();
        contact vTestContact;  
        Id vRecordTypeId = contactRecordTypeTeInternalContact().id;
        for(integer i=0; i<9; i++){
            vTestContact = ClsTestHelp.createTestContacts();
            vTestContact.AccountId = vTestAccount.id;
            vTestContact.email = 'test'+i+'@email.com';
            vTestContact.Inactive__c = true;
            vTestContact.RecordTypeId = vRecordTypeId;
            vTestContactList.add(vTestContact);
        }
        return vTestContactList;
    }
    
    //Prepare contacat record type TE Iternal Contact.
    public static RecordType contactRecordTypeTeInternalContact(){ 
    		Id vRecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('TE Internal Contact').getRecordTypeId();
        	system.debug('***** vRecordTypeId:'+vRecordTypeId);
            if(vRecordTypeId != Null){
                return new RecordType(Id=vRecordTypeId,DeveloperName = 'TE_Internal_Contact',Name='TE Internal Contact',SobjectType = 'Contact');
            }else{
                RecordType vRecordType = [select Id,Name from RecordType where SobjectType = 'Contact' and DeveloperName = 'TE_Internal_Contact'];
            	system.debug('***** vRecordTypeId in if :'+vRecordType);
            	return vRecordType; 
            }
    }
    //prepare test Account
    public static Account createTestAccount(){
        RecordType vRecordType = ClsTestHelp.createTestRecordType8();
        Account vTestAccount = ClsTestHelp.createTestAccounts();         
        vTestAccount.RecordTypeId = vRecordType.Id;
        return vTestAccount;
    }
    // prepare test users
    public static list<User>  createTestUsers() {
        //Perform data preparation
        list<User> vTestUserList = new list<User>();
        string[] vGibuArray = new string[]{'Appliances','Channel','Data & Devices','Industrial','Other','TEIS','Consumer Devices','Channel'};
        User vTestUser;
        for(integer i = 0; i < 8; i++){
        	vTestUser= new User();
			vTestUser = ClsTestHelp.createTestUsers();
            vTestUser.email = 'test'+i+'@email.com';
            vTestUser.FederationIdentifier = 'test'+i+'@email.com';
            vTestUSer.GIBU__c= vGibuArray[i];
            vTestUser.CommunityNickname ='cname'+i;
            vTestuser.MED_Region__c='EMEA';
            vTestuser.isActive = true;
            vTestUserList.add(vTestUser);
        }
    	return vTestUserList;
    }
    
    public static list<FreezeUserNotificationToBUAdmins__c> createFreezeUserSettingsList(){
        list<FreezeUserNotificationToBUAdmins__c> vFreezeUserSettings = new list<FreezeUserNotificationToBUAdmins__c>();
        vFreezeUserSettings.add(createFreezeUserSettings('Appliances','test1@email.com'));
        vFreezeUserSettings.add(createFreezeUserSettings('Channel','test2@email.com')); 
        vFreezeUserSettings.add(createFreezeUserSettings('Other BU Admins','test3@email.com'));
        vFreezeUserSettings.add(createFreezeUserSettings('Medical','test4@email.com,test5@email.com'));
        insert vFreezeUserSettings;
        return vFreezeUserSettings;
    }
    public static FreezeUserNotificationToBUAdmins__c createFreezeUserSettings(string vGibu, string vEmail){
        FreezeUserNotificationToBUAdmins__c vFreezeUserSettings = new FreezeUserNotificationToBUAdmins__c();
        vFreezeUserSettings.name = vGibu;
        vFreezeUserSettings.BU_Admin_User_Emails__c=vEmail;
        return vFreezeUserSettings;
    }
        

}