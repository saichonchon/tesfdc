/************************************************************************************************************************************************************************************************************************************************
Name: MassChangeOwnerCase_CCPController_Test
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
=================================================================================================================================================================================================================================================
   Summary : Summary : This class contain positive behavioral test methods and negative behavioral test methods for 'MassChangeOwnerCase_CCPController'
_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
 Apex class whose code is covered : MassChangeOwnerCase_CCPController
=================================================================================================================================================================================================================================================
 Code Coverage History:                                                        
_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
VERSION               AUTHOR                    DATE              DETAIL                           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 1.0               Ramakrishna Singara         04/23/2014        Test Class                       
*************************************************************************************************************************************************************************************************************************************************
 1.0               Ramakrishna Singara         05/26/2014        Test Class   
 Purpose: This Modification helps to changed method name.
*************************************************************************************************************************************************************************************************************************************************/

@IsTest(SeeAllData=true)
public class MassChangeOwnerCase_CCPController_Test{
    public static testMethod void MassChangeOwnerCaseTest(){        
        test.startTest();         
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User activeUser = new User(Alias = 'stand', Email='ram1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std456@testorg.com');
        insert activeUser;
        Schema.DescribeSObjectResult cfrAccSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrAccSchema.getRecordTypeInfosByName(); 
        Id CPPCasertId = CaseRecordTypeInfo.get('Customer Care Cloud').getRecordTypeId();
        
        Account acc =  ClsTestHelp.createTestAccounts();
        insert acc;
        
        Contact con;
        con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        insert con;
        
        Case Cs = new Case();
        cs.OwnerId= userinfo.getuserid();
        Cs.Origin = 'Email-cip1';
        Cs.Inquiry_Type__c = 'Other';
        Cs.Other_Inquiry_Type__c = 'Other';
        Cs.Status= 'In Progress';
        Cs.Description = 'Test Description';
        Cs.RecordTypeId = CPPCasertId;
        Cs.AccountId = acc.id;
        cs.contactId=con.Id;
        insert cs;
        
        Case Cs1 = new Case();
        Cs1.OwnerId= userinfo.getuserid();
        Cs1.Origin = 'Email-cip1';
        Cs1.Inquiry_Type__c = 'Other';
        Cs1.Other_Inquiry_Type__c = 'Other';
        Cs1.Status= 'In Progress';
        Cs1.Description = 'Test Description';
        Cs1.RecordTypeId = CPPCasertId;
        Cs1.AccountId = acc.id;
        Cs1.contactId=con.Id;
        insert Cs1;
        string s=Cs.id+','+Cs1.id;        
        
         PageReference page = new PageReference('/apex/MassChangeOwnerCaseVF'); 
         Test.setCurrentPageReference(page);
         ApexPages.StandardController stdController = new ApexPages.StandardController(Cs1);
         ApexPages.currentpage().getParameters().put('ids',s);                 
         MassChangeOwnerCase_CCPController mCOwner = new MassChangeOwnerCase_CCPController();            
         mCOwner.cRec = Cs1;         
         mCOwner.Save(); 
         mCOwner.Cancel();        
         
         MassChangeOwnerCase_CCPController mCOwner1 = new MassChangeOwnerCase_CCPController();            
         mCOwner1.cRec = Cs1;         
         mCOwner1.cRec.Other_Inquiry_Type__c = null;
         try{             
             mCOwner1.Save(); 
         }
         catch(DMLException e){            
             System.assertEquals(e.getDmlMessage(0),'Please enter Other Inquiry type');
         }         
         mCOwner1.Cancel();
         
         MassChangeOwnerCase_CCPController mCOwner2 = new MassChangeOwnerCase_CCPController();            
         mCOwner2.cRec = Cs1;         
         mCOwner2.cRec.Inquiry_Type__c = null;
         try{             
             mCOwner2.Save(); 
         }
         catch(DMLException e){             
             System.assertEquals(e.getDmlMessage(0),'Please select Inquiry Type');
         }         
         mCOwner2.Cancel();
         
         MassChangeOwnerCase_CCPController mCOwner3 = new MassChangeOwnerCase_CCPController();            
         mCOwner3.cRec = Cs1;         
         mCOwner3.cRec.OwnerId = null;
         try{
             system.debug('*****try***********');
             system.debug('*****mCOwner3.cRec***********');
             mCOwner3.Save(); 
         }
         catch(DMLException e){
             system.debug('*******catch*********');
             system.debug('*******mCOwner3.cRec*********');
             System.assertEquals(e.getDmlMessage(0),'Case Owner: You must enter a value');
         }         
         mCOwner3.Cancel();
        test.StopTest();
    }
}