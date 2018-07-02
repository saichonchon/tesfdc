/************************************************************************************************************************************************************************************************************************************************
Name: OutOfOffice_Controller_Test
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
=================================================================================================================================================================================================================================================
   Summary : Summary : This class contain positive behavioral test methods and negative behavioral test methods for 'OutOfOffice_Controller_Test'
_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
 Apex class whose code is covered : OutOfOffice_Controller
=================================================================================================================================================================================================================================================
 Code Coverage History:                                                        
_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
VERSION               AUTHOR                    DATE              DETAIL                           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 1.0               Ramakrishna Singara         25/02/2014        Test Class                       
*************************************************************************************************************************************************************************************************************************************************/
@IsTest
public class OutOfOffice_Controller_Test{
    public static testMethod void OutOfOfficeTest(){
        
         test.startTest();
             PageReference page = new PageReference('/apex/OutOfOffice'); 
             Test.setCurrentPageReference(page);
             
             //Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
             Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
             
             User activeUser = new User(Alias = 'stand', Email='ram1@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std456@testorg.com');
             insert activeUser;
             
             User outOfUser = new User(Out_Of_Office__c = true, Alternate_User1__c= activeUser.Id, Alias = 'stand', Email='ram@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p1.Id, TimeZoneSidKey='America/Los_Angeles', UserName='std123@testorg.com');
             insert outOfUser;
             outOfUser.Alternate_User1__c=activeUser.id;
             update outOfUser;
             
             OutOfOffice_Controller outOfOffice;
             Set<String> UserOptions = new Set<String>();
             UserOptions.add('User');
             UserOptions.add('QueueSobject');
             
             System.RunAs(outOfUser){
                 for(String Option: UserOptions){
                     outOfOffice = new OutOfOffice_Controller();
                     outOfOffice.getOwners();
                     outOfUser.Alternate_User1__c=activeUser.id;
                     outOfOffice.vSelect_Owner=Option;
                     outOfOffice.vSelectedId = activeUser.id;
                     outOfUser.Out_Of_Office__c = true;
                     outOfOffice.SearchText='Testing';                  
                     outOfOffice.ClearSearch();
                     outOfOffice.runsearch();                     
                     outOfOffice.Assign_New_Owner();
                     activeUser.Out_Of_Office__c =false;
                     update activeUser;
                     outOfOffice.Assign_New_Owner();                     
                     outOfOffice.save();
                     
                     outOfUser.Out_Of_Office__c =false;    
                     outOfOffice.vSelectedId ='';
                     outOfOffice.save();                 
                 }
             }
                                       
         test.StopTest();
    }
}