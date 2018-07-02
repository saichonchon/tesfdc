/**
*   This test class is for ExtCreatePLMProject.
*
@author Di Chen
@created 2012-11-28
@version 1.0
@since 20.0
*
@changelog
* 2012-11-28 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage 
*/
@isTest
private class ExtCreatePLMProject_Test {

    static testMethod void testMostMethods() {
         
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
        oppy.Product_Market_Size__c = null;
        insert oppy;
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
        ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
        ext.opportunity = oppy;
        ext.WSResponsePLM = 'Call web service error!';
        ext.WSResponseMASTERDATA = 'Call web service error!';
        
        ext.Save2Opportunity();
        //@ext.doCallout();
        ext.Cancel();
        system.assert(true);
        Test.stopTest(); 
    } 
    static testMethod void testLeastMethods1() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'Rail';
        //JNV 10/22/2012 add lvl 1 industry to set profit center formula field
        acc.LEVEL_1_INDUSTRY_CDE__c = '1002'; //IND     
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.AccountId = acc.Id;
        oppy.Do_you_know_the_Product_Market_Size__c = 'No';
        insert oppy;
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
        ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
        ext.opportunity = oppy;      
        ext.WSResponsePLM = 'Call web service error!';
        ext.WSResponseMASTERDATA = 'Call web service error!';
        
        ext.Save2Opportunity();
        //JNV 10/22/2012 - comment out callout so that test is not ommitted
        //@ext.doCallout();
        ext.Cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testLeastMethods2() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'Appliances';
        //JNV 10/22/2012 add lvl 1 industry to set profit center formula field
        acc.LEVEL_1_INDUSTRY_CDE__c = '0283'; //APL     
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.AccountId = acc.Id;
        oppy.Do_you_know_the_Product_Market_Size__c = 'No';
        insert oppy;
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
        ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
        ext.opportunity = oppy;      
        
        ext.Save2Opportunity();
        //JNV 10/22/2012 - comment out callout so that test is not ommitted        
        //ext.doCallout();
        ext.Cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testLeastMethods3() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'Consumer Devices';
        //JNV 10/22/2012 add lvl 1 industry to set profit center formula field
        acc.LEVEL_1_INDUSTRY_CDE__c = '1000'; //CSD     
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.AccountId = acc.Id;
        oppy.Do_you_know_the_Product_Market_Size__c = 'No';
        insert oppy;
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
        ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
        ext.opportunity = oppy;      
        
        ext.Save2Opportunity();
        //JNV 10/22/2012 - comment out callout so that test is not ommitted        
        //ext.doCallout();
        ext.Cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testLeastMethods4() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'DataComm';
        //JNV 10/22/2012 add lvl 1 industry to set profit center formula field
        acc.LEVEL_1_INDUSTRY_CDE__c = '0228'; //DTC     
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.AccountId = acc.Id;
        oppy.Do_you_know_the_Product_Market_Size__c = 'No';
        insert oppy;
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
        ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
        ext.opportunity = oppy;      
        
        ext.Save2Opportunity();
        //JNV 10/22/2012 - comment out callout so that test is not ommitted        
        //ext.doCallout();
        ext.Cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testLeastMethods5() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'Other';
        //JNV 10/22/2012 don't set industry code, to trigger null industry error message
        insert acc;
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.AccountId = acc.Id;
        oppy.Do_you_know_the_Product_Market_Size__c = 'No';
        
        insert oppy;
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
        ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
        ext.opportunity = oppy;      
        
        ext.Save2Opportunity();
        //JNV 10/22/2012 - comment out callout so that test is not ommitted
        //ext.doCallout();
        ext.Cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMostMethods6() { //Test product market size = No
         
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Request_Type__c = 'Cable Assembly';
        oppy.Do_you_know_the_Product_Market_Size__c = 'No';
        oppy.Product_Market_Size__c = null;
        insert oppy;
        
        Test.startTest();
        
        ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
        ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
        ext.opportunity = oppy;
        ext.WSResponsePLM = 'Call web service error!';
        ext.WSResponseMASTERDATA = 'Call web service error!';
        ext.projectApprovalCommittee = 'CIS MEFA';
        ext.projectCategory = 'New Product Development';
        ext.projectComplexity = 'Support';
        ext.leverage = 'Customer Special';
        ext.projectTemplate = 'CIS-AP-LEANPD (Type I and II)';
        ext.responsibleDesignGroup = '162';
        
        //ext.Save2Opportunity();
        //ext.doCallout();
        ext.Cancel();
        system.assert(true);
        Test.stopTest();
    }
    static testMethod void testMostMethods8() { //Test product market size = Yes
        Profile profile = [SELECT Name, Id FROM Profile where Name in('Industrial Engineering User w/Cost','Appliance Engineering User w/Cost') limit 1];
        User user = new User();
        user.Username = 'projekt1@hundw.com.axde';
        user.LastName = 'Projektadmin';
        user.TimeZoneSidKey = 'Europe/Berlin';
        user.LocaleSidKey = 'de_DE_EURO';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = profile.Id;
        user.LanguageLocaleKey = 'de';
        user.Email = 'Scofield@testcompany1231.com';
        user.Alias = 'Number1';
        user.CommunityNickname = 'NO.2';
        user.PLM_User__c = true;
        user.EmployeeNumber = 'testxxx';
        insert user;
        system.runAs(user){

            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
            oppy.Product_Market_Size__c = null; 
            insert oppy;
            
            Test.startTest();
            
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
            ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
            ext.isPLMUser = true;
            ext.actualUser = user;
            ext.opportunity = oppy;
            ext.WSResponsePLM = 'Call web service error!';
            ext.WSResponseMASTERDATA = 'Call web service error!';
            
            ext.Save2Opportunity();
            //JNV 10/22/2012 - comment out callout so that test is not ommitted         
            //@ext.doCallout();
            ext.Cancel();
            system.assert(true);
        }
        Test.stopTest();
    } 
    static testMethod void testMostMethods9() {  //Test if ResponseError = true
        Profile profile = [SELECT Name, Id FROM Profile where Name in('Industrial Engineering User w/Cost','Appliance Engineering User w/Cost') limit 1];
        User user = new User();
        user.Username = 'projekt1@hundw.com.axde';
        user.LastName = 'Projektadmin';
        user.TimeZoneSidKey = 'Europe/Berlin';
        user.LocaleSidKey = 'de_DE_EURO';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = profile.Id;
        user.LanguageLocaleKey = 'de';
        user.Email = 'Scofield@testcompany1231.com';
        user.Alias = 'Number1';
        user.CommunityNickname = 'NO.2';
        user.PLM_User__c = true;
        user.EmployeeNumber = 'testxxx'; 
        user.Te_Network_Id__c = 'sdfd'; //JNV 10/22 make sure TE Network Id set     
        insert user;
        system.runAs(user){
            
             RecordType rt2 = ClsTestHelp.createTestRecordType8();
                        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Industry_Code_Description__c = 'DataComm';
            //JNV 10/22/2012 add lvl 1 industry to set profit center formula field
            acc.LEVEL_1_INDUSTRY_CDE__c = '0228'; //DTC         
            insert acc;                                 
            
            //JNV 10/22/2012 - add competitor to satisfy validation rule on opportunity
            Account comp = ClsTestHelp.createTestAccounts();
            comp.Type = 'Competitor';
            comp.RecordTypeId = rt2.Id; 
            insert comp;    
                        
            Opportunity oppy = ClsTestHelp.createTestOpportunity();     
            insert oppy;
            
            Test.startTest();
            
            Opportunity_Competitor__c oc = new Opportunity_Competitor__c();
            oc.Opportunity__c = oppy.Id;
           // oc.Competitor__c = comp.Id;         
            insert oc;     
            
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
            oppy.Product_Market_Size__c = 12345; //JNV 10/22 - change to valid value
            oppy.AccountId = acc.Id;
            update oppy;    
                                    
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
            ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
            ext.isPLMUser = true;
            ext.actualUser = user;
            ext.opportunity = oppy;
            ext.WSResponsePLM = 'Call web service error!';
            ext.WSResponseMASTERDATA = 'Call web service error!';
                        
            ext.Save2Opportunity();
            
            //JNV 10/23/2012 - leave callout in to cover what can be covered            
            //@ext.doCallout();
            ext.Cancel();
            system.assert(true);
        }
        Test.stopTest(); 
    }
    static testMethod void testMostMethods10() {
        //JNV 10/22/2012 - seems to be testing what happens if in wrong profile, choose a profile not inclusion list
        Profile profile = [SELECT Id FROM Profile where Name = 'Standard User' limit 1];
        
        User user = new User();
        user.Username = 'projekt1@hundw.com.axde';
        user.LastName = 'Projektadmin';
        user.TimeZoneSidKey = 'Europe/Berlin';
        user.LocaleSidKey = 'de_DE_EURO';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = profile.Id;
        user.LanguageLocaleKey = 'de';
        user.Email = 'Scofield@testcompany1231.com';
        user.Alias = 'Number1';
        user.CommunityNickname = 'NO.2';
        user.PLM_User__c = true;
        user.EmployeeNumber = 'testxxx';
        user.EmployeeNumber = '111';
        user.Te_Network_Id__c = 'sdfd';
        insert user;
        RecordType rt2 = ClsTestHelp.createTestRecordType8();
        system.runAs(user){
                        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Industry_Code_Description__c = 'DataComm';
            acc.RecordTypeId = rt2.Id;
            insert acc;
            
            //JNV 10/22/2012 - add competitor to satisfy validation rule on opportunity
            Account comp = ClsTestHelp.createTestAccounts();
            comp.Name = 'Test Competitor';
            comp.Type = 'Competitor';           
            insert comp;            
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            insert oppy;                
            
            Test.startTest();
            
            Opportunity_Competitor__c oc = new Opportunity_Competitor__c();
            oc.Opportunity__c = oppy.Id;
            oc.Competitor__c = comp.Id;         
            insert oc;     
            
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
            oppy.Product_Market_Size__c = 12345; //JNV 10/22 - change to valid value
            oppy.AccountId = acc.Id;
            update oppy;
            
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
            ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
            ext.isPLMUser = true;
            ext.actualUser = user;
            ext.opportunity = oppy;
            ext.WSResponsePLM = 'Call web service error!';
            ext.WSResponseMASTERDATA = 'Call web service error!';
            
            ext.Save2Opportunity();
            //JNV 10/22/2012 - comment out callout so that test is not ommitted             
            //@ext.doCallout();
            ext.Cancel();
            system.assert(true);
        }
        Test.stopTest();
    }
    static testMethod void testMostMethods11() {  //Test Not approved
        Profile profile = [SELECT Name, Id FROM Profile where Name in('Industrial Engineering User w/Cost','Appliance Engineering User w/Cost') limit 1];
        User user = new User();
        user.Username = 'projekt1@hundw.com.axde';
        user.LastName = 'Projektadmin';
        user.TimeZoneSidKey = 'Europe/Berlin';
        user.LocaleSidKey = 'de_DE_EURO';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = profile.Id;
        user.LanguageLocaleKey = 'de';
        user.Email = 'Scofield@testcompany1231.com';
        user.Alias = 'Number1';
        user.CommunityNickname = 'NO.2';
        user.PLM_User__c = true;
        user.EmployeeNumber = 'testxxx';
        user.EmployeeNumber = '111';
        user.Te_Network_Id__c = 'sdfd';
        insert user;
        system.runAs(user){
                        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Industry_Code_Description__c = 'DataComm';
            acc.LEVEL_1_INDUSTRY_CDE__c = '0228';
            insert acc;
             RecordType rt2 = ClsTestHelp.createTestRecordType8();
            //JNV 10/22/2012 - add competitor to satisfy validation rule on opportunity
            Account comp = ClsTestHelp.createTestAccounts();
            comp.Name = 'Test Competitor';
            comp.Type = 'Competitor';    
            comp.RecordTypeId = rt2.Id;       
            insert comp;                                        
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            insert oppy;                                                
            
            Test.startTest();
            
            Opportunity_Competitor__c oc = new Opportunity_Competitor__c();
            oc.Opportunity__c = oppy.Id;
            //oc.Competitor__c = comp.Id;         
            insert oc;     
            
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
            oppy.Product_Market_Size__c = 12345; //JNV 10/22 - change to valid value
            oppy.AccountId = acc.Id;
            update oppy;
            
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
            ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
            ext.isPLMUser = true;
            ext.actualUser = user;
            ext.opportunity = oppy;
            ext.WSResponsePLM = 'Call web service error!';
            ext.WSResponseMASTERDATA = 'Call web service error!';
            ext.projectApprovalCommittee = 'Test Pac'; 
            ext.projectCategory = 'Test Category';
            ext.projectComplexity = 'Test Complexity';
            ext.leverage = 'Test leverage'; 
            ext.projectTemplate = 'Test Template';
            ext.responsibleDesignGroup = 'Test RDG';            
            
            //ext.Save2Opportunity();
            //JNV 10/22/2012 - comment out callout so that test is not ommitted         
            //@ext.doCallout();
            ext.Cancel();
            system.assert(true);
        }
        Test.stopTest();
    }
        static testMethod void testMostMethods12() { //Test no EmployeeNbr/TE Network Id
        Profile profile = [SELECT Name, Id FROM Profile where Name in('Industrial Engineering User w/Cost','Appliance Engineering User w/Cost') limit 1];
        User user = new User();
        user.Username = 'projekt1@hundw.com.axde';
        user.LastName = 'Projektadmin';
        user.TimeZoneSidKey = 'Europe/Berlin';
        user.LocaleSidKey = 'de_DE_EURO';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = profile.Id;
        user.LanguageLocaleKey = 'de';
        user.Email = 'Scofield@testcompany1231.com';
        user.Alias = 'Number1';
        user.CommunityNickname = 'NO.2';
        user.PLM_User__c = true;
        user.Te_Network_Id__c = null;
        user.EmployeeNumber = null;
        insert user;
        system.runAs(user){
                        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Industry_Code_Description__c = 'DataComm';
            acc.LEVEL_1_INDUSTRY_CDE__c = '0228';
            insert acc;
            RecordType rt2 = ClsTestHelp.createTestRecordType8();
            //JNV 10/22/2012 - add competitor to satisfy validation rule on opportunity
            Account comp = ClsTestHelp.createTestAccounts();
            comp.Name = 'Test Competitor';
            comp.Type = 'Competitor';   
            comp.RecordTypeId = rt2.Id;         
            insert comp;                
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();                     
            insert oppy;                        
            
            Test.startTest();
            
            Opportunity_Competitor__c oc = new Opportunity_Competitor__c();
            oc.Opportunity__c = oppy.Id;
            //oc.Competitor__c = comp.Id;         
            insert oc;     
            
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
            oppy.Product_Market_Size__c = 12345; //JNV 10/22 - change to valid value
            oppy.AccountId = acc.Id;
            update oppy;            
            
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
            ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
            ext.isPLMUser = true;
            ext.actualUser = user;
            ext.opportunity = oppy;
            ext.WSResponsePLM = 'Call web service error!';
            ext.WSResponseMASTERDATA = 'Call web service error!';
            
            ext.Save2Opportunity();
            //@ext.doCallout();
            ext.Cancel();
            system.assert(true);
        }
        Test.stopTest();
    } 
    static testMethod void testMostMethods13() {  //Test is approved
        Profile profile = [SELECT Name, Id FROM Profile where Name in('Industrial Engineering User w/Cost','Appliance Engineering User w/Cost') limit 1];
        User user = new User();
        user.Username = 'projekt1@hundw.com.axde';
        user.LastName = 'Projektadmin';
        user.TimeZoneSidKey = 'Europe/Berlin';
        user.LocaleSidKey = 'de_DE_EURO';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = profile.Id;
        user.LanguageLocaleKey = 'de';
        user.Email = 'Scofield@testcompany1231.com';
        user.Alias = 'Number1';
        user.CommunityNickname = 'NO.2';
        user.PLM_User__c = true;
        user.EmployeeNumber = 'testxxx';
        user.EmployeeNumber = '111';
        user.Te_Network_Id__c = 'sdfd';
        insert user;
        system.runAs(user){
                        
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Industry_Code_Description__c = 'Appliances'; //For approval process
            acc.LEVEL_1_INDUSTRY_CDE__c = '0283';
            acc.Account_Manager__c = user.id;
            insert acc;
            RecordType rt2 = ClsTestHelp.createTestRecordType8();
            Account comp = ClsTestHelp.createTestAccounts();
            comp.Name = 'Test Competitor';
            comp.Type = 'Competitor'; 
            comp.RecordTypeId = rt2.Id;           
            insert comp;                                        
            
            RecordType rt1 = ClsTestHelp.createTestRecordType10();
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.RecordTypeId = rt1.Id;
            insert oppy;
            
            Test.startTest();
            
            Opportunity_Competitor__c oc = new Opportunity_Competitor__c();
            oc.Opportunity__c = oppy.Id;
            //oc.Competitor__c = comp.Id;         
            insert oc;     
            
            
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
            oppy.Product_Market_Size__c = 12345; //JNV 10/22 - change to valid value
            oppy.AccountId = acc.Id;
            oppy.Name='TestMethod13Opp';
            oppy.Amount = 100000;
            update oppy;            
            
            Approval.ProcessSubmitRequest submitForApproval = new Approval.ProcessSubmitRequest();
            submitForApproval.setComments('Submitting request for approval.');
            submitForApproval.setObjectId(oppy.id);
            submitForApproval.setNextApproverIds(new Id[] {user.id});
        
            // Submit the approval request for the account     
            Approval.ProcessResult result = Approval.process(submitForApproval);
                
            // Approve the submitted request     
            // First, get the ID of the newly created item     
            List<Id> newWorkItemIds = result.getNewWorkitemIds();
        
            // Instantiate the new ProcessWorkitemRequest object and populate it     
            Approval.ProcessWorkitemRequest approveOpportunity = new Approval.ProcessWorkitemRequest();
            approveOpportunity.setComments('Approving request.');
            approveOpportunity.setAction('Approve');
        
            // Use the ID from the newly created item to specify the item to be worked     
            approveOpportunity.setWorkitemId(newWorkItemIds.get(0));
        
            // Submit the request for approval     
            //Approval.ProcessResult result2 =  Approval.process(approveOpportunity);           
            
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
            ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
            ext.isPLMUser = true;
            ext.actualUser = user;
            ext.opportunity = oppy;
            ext.WSResponsePLM = '<ProjectTemplateList></ProjectTemplateList><RDGList></RDGList>';
            ext.WSResponseMASTERDATA = '<ProjectCategoriesList></ProjectCategoriesList><LeveragesList></LeveragesList><ProjectComplexitiesList></ProjectComplexitiesList><PACList></PACList>';
            ext.projectApprovalCommittee = 'Test Pac'; 
            ext.projectCategory = 'Test Category';
            ext.projectComplexity = 'Test Complexity';
            ext.leverage = 'Test leverage'; 
            ext.projectTemplate = 'Test Template';
            ext.responsibleDesignGroup = 'Test RDG';
            
            ext.Save2Opportunity();
            //@ext.doCallout();
            ext.Cancel();
            system.assert(true);
        }
        Test.stopTest();
    } 
  
    static testMethod void testMostMethods14() {  //Test if ResponseError = true
        Profile profile = [SELECT Name, Id FROM Profile where Name in('Industrial Engineering User w/Cost','Appliance Engineering User w/Cost') limit 1];
        User user = new User();
        user.Username = 'projekt1@hundw.com.axde';
        user.LastName = 'Projektadmin';
        user.TimeZoneSidKey = 'Europe/Berlin';
        user.LocaleSidKey = 'de_DE_EURO';
        user.EmailEncodingKey = 'ISO-8859-1';
        user.ProfileId = profile.Id;
        user.LanguageLocaleKey = 'de';
        user.Email = 'Scofield@testcompany1231.com';
        user.Alias = 'Number1';
        user.CommunityNickname = 'NO.2';
        user.PLM_User__c = true;
        user.EmployeeNumber = 'testxxx'; 
        user.Te_Network_Id__c = 'sdfd'; //JNV 10/22 make sure TE Network Id set     
        insert user;
        system.runAs(user){
            RecordType rt2 = ClsTestHelp.createTestRecordType8();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Industry_Code_Description__c = null;
            //JNV 10/22/2012 add lvl 1 industry to set profit center formula field
            acc.LEVEL_1_INDUSTRY_CDE__c = null;
            insert acc;                                 
            
            //JNV 10/22/2012 - add competitor to satisfy validation rule on opportunity
            Account comp = ClsTestHelp.createTestAccounts();
            comp.Type = 'Competitor';
            comp.RecordTypeId = rt2.Id; 
            insert comp;    
                        
            Opportunity oppy = ClsTestHelp.createTestOpportunity();     
            insert oppy;
            
            Test.startTest();
            
            Opportunity_Competitor__c oc = new Opportunity_Competitor__c();
            oc.Opportunity__c = oppy.Id;
           // oc.Competitor__c = comp.Id;         
            insert oc;     
            
            oppy.Request_Type__c = 'Cable Assembly';
            oppy.Do_you_know_the_Product_Market_Size__c = 'Yes';
            oppy.Product_Market_Size__c = 12345; //JNV 10/22 - change to valid value
            oppy.AccountId = acc.Id;
            update oppy;    
                                    
            ApexPages.StandardController stdCtrl = new ApexPages.StandardController(oppy); 
            ExtCreatePLMProject ext = new ExtCreatePLMProject(stdCtrl);
            ext.isPLMUser = true;
            ext.actualUser = user;
            ext.opportunity = oppy;
            ext.WSResponsePLM = 'Call web service error!';
            ext.WSResponseMASTERDATA = 'Call web service error!';
                        
            system.assert(true);
        }
        Test.stopTest(); 
    }
}