/***********************************************************************************************************************
      Name : NDR_Distributor_update_test
       Org : C2S
 Copyright : © 2014 TE Connectivity 
========================================================================================================================
   Summary : This class using for code coverage 'NDR_Distributor_update' trigger
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION  AUTHOR       DATE              DETAIL            User Story #                  
________________________________________________________________________________________________________________________
    1.0   Ravi         1/13/2014     Initial Development       D-1330
    2.0   Anil Attelli 5/22/2014     Enhancement               D-1330
***********************************************************************************************************************/


@isTest(seeAllData=true)
public class NDR_Distributor_update_test{
    static testmethod void NDR_Distributor_update_test(){
    
    Test.startTest();
    
        RecordType vRT = [select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
         
         Profile p = [Select Id, Name From Profile 
                     where Name = 'Service Account' 
                        or Name ='System Administrator' 
                        or Name ='Systemadministrator' limit 1];

          User u = new User();
        u.FirstName ='Test';
        u.LastName = 'Tester';
        u.Email = 'testDistributor1@test.com';
        u.username = 'testdistributor1@test.com';
        u.Alias = 'abc';
        u.CommunityNickname = 'TsMD';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
         
        Opportunity vOppty = ClsTestHelp.createTestOpportunity();
        vOppty.recordtypeid = vRT.id;
        vOppty.ownerid = u.id;
        Voppty.NDR_Sold_to_Account_Name__c='Arrow';
        insert Voppty;
        Voppty.NDR_Sold_to_Account_Name__c='avnet';
        update Voppty;
        
        Opportunity vOppty1= ClsTestHelp.createTestOpportunity();
        vOppty1.recordtypeid = vRT.id;
        vOppty1.ownerid = u.id;
        vOppty1.NDR_Sold_to_Account_Name__c='Arrow Electronics';
        
                    
            insert Voppty1;
            vOppty1.NDR_Sold_to_Account_Name__c='Unidux';
            update Voppty1;

        
         Test.stopTest();
        }
        static testmethod void StringSearchhandlerutil_test(){
        
             StringSearchhandlerutil.search('Arrow','Arrow Electronics INC');
        }
        
}