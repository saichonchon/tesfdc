@isTest(SeeAllData =true)
private class OpportunityAPLRouting_Test {
    static testMethod void testMostMethods() {  //Test is approved
        Profile profile = [SELECT Name, Id FROM Profile where Name in('Appliance Engineering User w/Cost','Appliance Standard User','Appliance User w/ Cost') limit 1];
               Test.startTest();
        User user1 = new User();
        user1.Username = 'tes11t@test.com.axde';
        user1.LastName = 'TestAdmi11n';
        user1.TimeZoneSidKey = 'Europe/Berlin';
        user1.LocaleSidKey = 'de_DE_EURO';
        user1.EmailEncodingKey = 'ISO-8859-1';
        user1.ProfileId = profile.Id;
        user1.LanguageLocaleKey = 'de';
        user1.Email = 'test@tes1tcompany1231.com';
        user1.Alias = 'bnmmf123';
        user1.CommunityNickname = 'NO.1232';
        user1.PLM_User__c = true;
        user1.EmployeeNumber = 'testxxx1';
        user1.EmployeeNumber = '11111';
        user1.Te_Network_Id__c = 'sdfd1';
        insert user1;

        User user = new User();
        user.Username = 'test@test.com.axde';
        user.LastName = 'TestAdmin';
        user.APL_Regional_Sale_Leader__c = user1.Id;
        user.TimeZoneSidKey = 'Europe/Berlin';
        user.LocaleSidKey = 'de_DE_EURO';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = profile.Id;
        user.LanguageLocaleKey = 'de';
        user.Email = 'test@testcompany1231.com';
        user.Alias = 'Number1';
        user.CommunityNickname = 'NO.2';
        user.PLM_User__c = true;
        user.EmployeeNumber = 'testxxx';
        user.EmployeeNumber = '111';
        user.Te_Network_Id__c = 'sdfd';
        user.ManagerId = user1.Id;
        insert user;
        system.runAs(user){
                        
            Account acc = ClsTestHelp.createTestAccounts();
            RecordType rt2 = ClsTestHelp.createTestRecordType(); 

            acc.Name = 'axx';
            acc.RecordTypeId = rt2.Id;
            acc.Customer_Classification__c = 'A';
            acc.Type = 'Grouped B';      
            acc.MKTMGRCDE__c = '123';           
            acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
            insert acc;
                                                              
            
            RecordType rt1 = ClsTestHelp.createTestRecordType10();
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.RecordTypeId = rt1.Id;
            insert oppy;
            
           
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
            oppy.Product_Market_Size__c = 12345; //JNV 10/22 - change to valid value
            oppy.AccountId = acc.Id;
            oppy.Name='TestMethod13Opp';
            oppy.Amount = 100000;
            oppy.Request_Type__c = 'Extension';
            oppy.Regional_PM__c = user1.Id;
            update oppy;            
            
           /* Approval.ProcessSubmitRequest submitForApproval = new Approval.ProcessSubmitRequest();
            submitForApproval.setComments('Submitting request for approval.');
            submitForApproval.setObjectId(oppy.id);
            submitForApproval.setNextApproverIds(new Id[] {user.id});
            
            Approval.ProcessResult result = Approval.process(submitForApproval);
            List<Id> newWorkItemIds1 = result.getNewWorkitemIds();
            Approval.ProcessWorkitemRequest approveOpportunity1 = new Approval.ProcessWorkitemRequest();
            approveOpportunity1.setComments('Approving request.');
            approveOpportunity1.setAction('Pending' );
            approveOpportunity1.setWorkitemId(newWorkItemIds1.get(0));
            oppy.Is_approved_Regional_Sales_Director__c =true;
           try{
            update oppy;
            }catch(Exception e){
            system.debug(e.getmessage());*/
               
               // system.assert(e.getmessage().contains('Please select APL ENG routing Process'));
                //system.assert(e.getmessage().contains('1231321321321321321s'));

           
           //}  
          //  system.assert(true);
        }
        Test.stopTest();
    } 
  
  }