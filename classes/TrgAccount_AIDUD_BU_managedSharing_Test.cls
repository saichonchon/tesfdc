/**
*   This test class is for account_AIDUD_BU_managedSharing.
*
@author Di Chen
@created 2012-02-23
@version 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 80%
*/
@isTest
private class TrgAccount_AIDUD_BU_managedSharing_Test {

     static testMethod void testCondition1() {
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
                        
        ClsSharingUtil.TriggerRecursion4SalesHierarchy = true;
        
        Test.startTest(); 
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A006864';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Level_7_Assigned_User_Network_Ids__c = 'US030941';
        insert sh;
        
        Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
        sh2.Level_7_Territory_Code__c = 'K1234';
        sh2.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh2.Level_7_Assigned_User_Network_Ids__c = 'LB008981';
        insert sh2;
                
        RecordType rt2 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Global_Account'];
        RecordType rt3 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Account'];
        
        List<Account> list_acc = new list<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'axx';
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Global Account';
        acc.GAMCD__c = 'A006864';
        acc.Sales_Hierarchy_GAM__c = sh.Id;
        acc.Sales_Hierarchy_MM__c  = sh2.Id;
        list_acc.add(acc);
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Name = 'axx1';
        acc1.RecordTypeId = rt2.Id;
        acc1.Customer_Classification__c = 'A';
        acc1.Type = 'Grouped B';
        acc1.GAMCD__c = 'A006823';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//  
        acc1.MKTMGRCDE__c = 'A006e873';
        acc1.IND_KAM_Code__c = 'A006e873';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//  
        acc1.Sales_Hierarchy_MM__c = sh.Id;
        list_acc.add(acc1);


        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'axx2';
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Grouped B';
        acc2.GAMCD__c = 'K1234';
        acc2.Sales_Hierarchy_GAM__c = sh.Id;
        acc2.Sales_Hierarchy_MM__c  = sh2.Id;
        
        list_acc.add(acc2);             

        Account acc3 = ClsTestHelp.createTestAccounts();
        acc3.Name = 'axx3';
        acc3.RecordTypeId = rt3.Id;
        acc3.Customer_Classification__c = 'A';
        acc3.Type = 'Grouped B';
        acc2.GAMCD__c = 'K1234';
        acc3.Sales_Hierarchy_GAM__c = sh.Id;
        acc3.Sales_Hierarchy_MM__c  = sh2.Id;
        list_acc.add(acc3);  
        
        insert list_acc;    
        
        RecordType rt4 = ClsTestHelp.createTestRecordType2();
        
        Contact contact = ClsTestHelp.createTestContacts();
        contact.FirstName = 'sand';
        insert contact;    
            
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt4.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Field Engineer (FE)';
        insert AccTeam;
        
        acc1.Sales_Hierarchy_MM__c = null;
                    
        acc2.Type = 'Global Account';  
        acc2.Sales_Hierarchy_GAM__c = sh2.Id;    
        
        acc3.Type = 'Global Account';  
        acc3.Sales_Hierarchy_GAM__c = sh2.Id; 
        ClsSharingUtil.TriggerRecursionDefense = false; 
        update list_acc;   
        
        system.assert(true);
        Test.stopTest();
    }    
    
    static testMethod void testConditionGroupedB() {
        
        ClsSharingUtil.TriggerRecursion4SalesHierarchy = true;
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
                
        Test.startTest(); 
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A006864';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Level_7_Assigned_User_Network_Ids__c = 'US030941';
        insert sh;
        
        Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
        sh2.Level_7_Territory_Code__c = 'K1234';
        sh2.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh2.Level_7_Assigned_User_Network_Ids__c = 'LB008981';
        insert sh2;
                
        RecordType rt2 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Global_Account'];
        RecordType rt3 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Account'];
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'axx';
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Grouped B';
        acc.GAMCD__c = null;
        acc.Sales_Hierarchy_GAM__c = null;
        acc.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc.MKTMGRCDE__c = 'K1234';
        acc.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        insert acc;
        
        acc.RecordTypeId = rt3.Id;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }  
    static testMethod void testConditionRecordType1() {
        
        ClsSharingUtil.TriggerRecursion4SalesHierarchy = true;
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
                
        Test.startTest(); 
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A006864';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Level_7_Assigned_User_Network_Ids__c = 'US030941';
        insert sh;
        
        Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
        sh2.Level_7_Territory_Code__c = 'K1234';
        sh2.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh2.Level_7_Assigned_User_Network_Ids__c = 'LB008981';
        insert sh2;
                
        RecordType rt2 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Global_Account'];
        RecordType rt3 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Account'];
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'axx';
        acc.RecordTypeId = rt3.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Grouped B';
        acc.GAMCD__c = null;
        acc.Sales_Hierarchy_GAM__c = null;
        acc.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc.MKTMGRCDE__c = 'K1234';
        acc.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        insert acc;

        Contact contact = ClsTestHelp.createTestContacts();
        contact.FirstName = 'sand';
        insert contact;    
                
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.Account__c = acc.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Field Engineer (FE)';
        insert AccTeam;     
        
        acc.Sales_Hierarchy_MM__c = sh.Id;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }  
   static testMethod void testConditionRecordType2() {
        
        ClsSharingUtil.TriggerRecursion4SalesHierarchy = true;
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
                
        Test.startTest(); 
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A006864';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Level_7_Assigned_User_Network_Ids__c = 'US030941';
        insert sh;
        
        Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
        sh2.Level_7_Territory_Code__c = 'K1234';
        sh2.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh2.Level_7_Assigned_User_Network_Ids__c = 'LB008981';
        insert sh2;
                
        RecordType rt2 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Global_Account'];
        RecordType rt3 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Account'];
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'axx';
        acc.RecordTypeId = rt3.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Global Account';
        acc.GAMCD__c = 'K1234';
        acc.Sales_Hierarchy_GAM__c = sh.Id;
        insert acc;

        Contact contact = ClsTestHelp.createTestContacts();
        contact.FirstName = 'sand';
        insert contact;    
                
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.Account__c = acc.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Field Engineer (FE)';
        insert AccTeam;     
        
        acc.Sales_Hierarchy_MM__c = sh.Id;
        update acc;
        
        system.assert(true);
        Test.stopTest();
    }      
    static testMethod void testCondition2() {
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
                        
        ClsSharingUtil.TriggerRecursion4SalesHierarchy = true;
        
        Test.startTest(); 
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A006864';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Level_7_Assigned_User_Network_Ids__c = 'US030941';
        insert sh;
        
        Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
        sh2.Level_7_Territory_Code__c = 'K1234';
        sh2.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh2.Level_7_Assigned_User_Network_Ids__c = 'LB008981';
        insert sh2;
                
        RecordType rt2 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Global_Account'];
        RecordType rt3 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Account'];
        
        List<Account> list_acc = new list<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'axx';
        acc.RecordTypeId = rt2.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Global Account';
        acc.GAMCD__c = 'A006864';
        acc.Sales_Hierarchy_GAM__c = sh.Id;
        acc.Sales_Hierarchy_MM__c  = sh2.Id;
        list_acc.add(acc);
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Name = 'axx1';
        acc1.RecordTypeId = rt2.Id;
        acc1.Customer_Classification__c = 'A';
        acc1.Type = 'Grouped B';
        acc1.GAMCD__c = 'A006823';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc1.IND_KAM_Code__c = 'A006e873';
        acc1.MKTMGRCDE__c = 'A006e873';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        acc1.Sales_Hierarchy_MM__c = sh.Id;
        list_acc.add(acc1);


        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'axx2';
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Grouped B';
        acc2.GAMCD__c = 'K1234';
        acc2.Sales_Hierarchy_GAM__c = sh.Id;
        acc2.Sales_Hierarchy_MM__c  = sh2.Id;
        
        list_acc.add(acc2);             

        Account acc3 = ClsTestHelp.createTestAccounts();
        acc3.Name = 'axx3';
        acc3.RecordTypeId = rt3.Id;
        acc3.Customer_Classification__c = 'A';
        acc3.Type = 'Grouped B';
        acc2.GAMCD__c = 'K1234';
        acc3.Sales_Hierarchy_GAM__c = sh.Id;
        acc3.Sales_Hierarchy_MM__c  = sh2.Id;
        list_acc.add(acc3);  
        
        insert list_acc;    
        
        RecordType rt4 = ClsTestHelp.createTestRecordType2();
        
        Contact contact = ClsTestHelp.createTestContacts();
        contact.FirstName = 'sand';
        insert contact;    
            
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt4.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Field Engineer (FE)';
        insert AccTeam;
        
        acc1.Sales_Hierarchy_MM__c = null;
                    
        acc2.Type = 'Grouped B';  
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc2.MKTMGRCDE__c = 'K1234';
        acc2.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        acc2.Sales_Hierarchy_GAM__c = sh2.Id;    
        
        acc3.Type = 'Grouped B'; 
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****// 
        acc3.MKTMGRCDE__c = 'K1234';
        acc3.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        acc3.Sales_Hierarchy_GAM__c = sh2.Id; 
        ClsSharingUtil.TriggerRecursionDefense = false; 
        update list_acc;   
        
        system.assert(true);
        Test.stopTest();
    }       
    
    static testMethod void testCondition3() {
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
                        
        ClsSharingUtil.TriggerRecursion4SalesHierarchy = true;
        
        Test.startTest(); 
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A006864';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Level_7_Assigned_User_Network_Ids__c = 'US030941';
        insert sh;
        
        Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
        sh2.Level_7_Territory_Code__c = 'K1234';
        sh2.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh2.Level_7_Assigned_User_Network_Ids__c = 'LB008981';
        insert sh2;
                
        RecordType rt2 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Global_Account'];
        RecordType rt3 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Account'];
        
        List<Account> list_acc = new list<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'axx';
        acc.RecordTypeId = rt3.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Global Account';
        acc.GAMCD__c = 'A006864';
        acc.Sales_Hierarchy_GAM__c = sh.Id;
        acc.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc.MKTMGRCDE__c = 'K1234';
        acc.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        list_acc.add(acc);
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Name = 'axx1';
        acc1.RecordTypeId = rt2.Id;
        acc1.Customer_Classification__c = 'A';
        acc1.Type = 'Grouped B';
        acc1.GAMCD__c = 'A006823';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc1.IND_KAM_Code__c = 'A006e873';
        acc1.MKTMGRCDE__c = 'A006e873';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        acc1.Sales_Hierarchy_GAM__c = sh.Id;
        acc1.Sales_Hierarchy_MM__c  = sh2.Id;
        list_acc.add(acc1);


        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'axx2';
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Grouped B';
        acc2.GAMCD__c = 'K1234';
        acc2.Sales_Hierarchy_GAM__c = sh.Id;
        acc2.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc2.IND_KAM_Code__c = 'A006e873';
        acc2.MKTMGRCDE__c = 'A006e873';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        list_acc.add(acc2);             

        Account acc3 = ClsTestHelp.createTestAccounts();
        acc3.Name = 'axx3';
        acc3.RecordTypeId = rt3.Id;
        acc3.Customer_Classification__c = 'A';
        acc3.Type = 'Grouped B';
        acc3.GAMCD__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc3.IND_KAM_Code__c = 'A006e873';
        acc3.MKTMGRCDE__c = 'A006e873';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        acc3.Sales_Hierarchy_GAM__c = sh.Id;
        acc3.Sales_Hierarchy_MM__c  = sh2.Id;
        list_acc.add(acc3);  
        
        insert list_acc;    
        
        RecordType rt4 = ClsTestHelp.createTestRecordType2();
        
        Contact contact = ClsTestHelp.createTestContacts();
        contact.FirstName = 'sand';
        insert contact;    
            
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt4.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Field Engineer (FE)';
        insert AccTeam;
        
        acc.Type = 'Grouped B';
        acc.GAMCD__c = 'A006864';
        acc.Sales_Hierarchy_GAM__c = sh.Id;
        acc.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc.MKTMGRCDE__c = 'K1234';
        acc.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                
        acc2.Type = 'Global Account';  
        acc2.GAMCD__c = 'A006864';
        acc2.Sales_Hierarchy_GAM__c = sh.Id;
        acc2.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc2.MKTMGRCDE__c = 'K1234';  
        acc2.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        
        acc3.Type = 'Global Account'; 
        acc3.GAMCD__c = 'A006864';
        acc3.Sales_Hierarchy_GAM__c = sh.Id;
        acc3.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc3.MKTMGRCDE__c = 'K1234';  
        acc3.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        ClsSharingUtil.TriggerRecursionDefense = false; 
        update list_acc;   
        
        system.assert(true);
        Test.stopTest();
    }       
    static testMethod void testCondition4() {
        
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();
                        
        ClsSharingUtil.TriggerRecursion4SalesHierarchy = true;
        
        Test.startTest(); 
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A006864';
        sh.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh.Level_7_Assigned_User_Network_Ids__c = 'US030941';
        insert sh;
        
        Sales_Hierarchy__c sh2 = new Sales_Hierarchy__c();
        sh2.Level_7_Territory_Code__c = 'K1234';
        sh2.Level_7_Default_Owner__c = UserInfo.getUserId();
        sh2.Level_7_Assigned_User_Network_Ids__c = 'LB008981';
        insert sh2;
                
        RecordType rt2 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Global_Account'];
        RecordType rt3 = [Select Id from RecordType where SObjectType = 'Account' and DeveloperName= 'CIS_Account'];
        
        List<Account> list_acc = new list<Account>();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Name = 'axx';
        acc.RecordTypeId = rt3.Id;
        acc.Customer_Classification__c = 'A';
        acc.Type = 'Global Account';
        acc.GAMCD__c = 'A006864';
        acc.Sales_Hierarchy_GAM__c = sh.Id;
        acc.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc.MKTMGRCDE__c = 'K1234';
        acc.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        list_acc.add(acc);
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Name = 'axx1';
        acc1.RecordTypeId = rt2.Id;
        acc1.Customer_Classification__c = 'A';
        acc1.Type = 'Grouped B';
        acc1.GAMCD__c = 'A006823';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc1.MKTMGRCDE__c = 'A006e873';
        acc1.IND_KAM_Code__c = 'A006e873';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        acc1.Sales_Hierarchy_GAM__c = sh.Id;
        acc1.Sales_Hierarchy_MM__c  = sh2.Id;
        list_acc.add(acc1);


        Account acc2 = ClsTestHelp.createTestAccounts();
        acc2.Name = 'axx2';
        acc2.RecordTypeId = rt2.Id;
        acc2.Customer_Classification__c = 'A';
        acc2.Type = 'Grouped B';
        acc2.GAMCD__c = 'K1234';
        acc2.Sales_Hierarchy_GAM__c = sh.Id;
        acc2.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc2.MKTMGRCDE__c = 'A006e873';
        acc2.IND_KAM_Code__c = 'A006e873';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        list_acc.add(acc2);             

        Account acc3 = ClsTestHelp.createTestAccounts();
        acc3.Name = 'axx3';
        acc3.RecordTypeId = rt3.Id;
        acc3.Customer_Classification__c = 'A';
        acc3.Type = 'Grouped B';
        acc3.GAMCD__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc3.MKTMGRCDE__c = 'A006e873';
        acc3.IND_KAM_Code__c = 'A006e873';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        acc3.Sales_Hierarchy_GAM__c = sh.Id;
        acc3.Sales_Hierarchy_MM__c  = sh2.Id;
        list_acc.add(acc3);  
        
        insert list_acc;    
        
        RecordType rt4 = ClsTestHelp.createTestRecordType2();
        
        Contact contact = ClsTestHelp.createTestContacts();
        contact.FirstName = 'sand';
        insert contact;    
            
        Account_Team__c AccTeam = new Account_Team__c();
        AccTeam.RecordTypeId = rt4.Id;
        AccTeam.Account__c = acc2.Id;
        AccTeam.Team_Member__c = UserInfo.getUserId();
        AccTeam.Team_Member_Contact__c = contact.Id;
        AccTeam.Role__c = 'Field Engineer (FE)';
        insert AccTeam;
        
        acc.Type = 'Grouped B';
        acc.GAMCD__c = null;
        acc.Sales_Hierarchy_GAM__c = null;
        acc.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc.MKTMGRCDE__c = 'K1234';
        acc.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                
        acc2.Type = 'Global Account';  
        acc2.GAMCD__c = null;
        acc2.Sales_Hierarchy_GAM__c = null;
        acc2.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc2.MKTMGRCDE__c = 'K1234';  
        acc2.IND_KAM_Code__c = 'K1234'; 
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        
        acc3.Type = 'Global Account'; 
        acc3.GAMCD__c = null;
        acc3.Sales_Hierarchy_GAM__c =null;
        acc3.Sales_Hierarchy_MM__c  = sh2.Id;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        acc3.MKTMGRCDE__c = 'K1234';  
        acc3.IND_KAM_Code__c = 'K1234';
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
        ClsSharingUtil.TriggerRecursionDefense = false; 
        update list_acc;   
        
        system.assert(true);
        Test.stopTest();
    }     
    
}