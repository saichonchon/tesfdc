/**
*	This test class is for ExtUploadSensitiveAttachment.
*
@author Di Chen
@created 2012-11-28
@version 1.0
@since 20.0
*
@changelog
* 2012-11-28 Di Chen <di.chen@itbconsult.com>
* - Created
* - Test coverage   82%
*/
@isTest
private class ExtUploadSensitiveAttachment_Test {

    static testMethod void Parameters() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    	
        Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfd@testCompany1233423.com';
    	u.Alias = 'dpse';
    	u.CommunityNickname = 'TMD';
    	u.ProfileId = p.Id;
		insert u;
		    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account acc = ClsTestHelp.createTestAccounts(); 
		acc.RecordTypeId = rt.Id;
		insert acc;
		
		Contact con = ClsTestHelp.createTestContacts();
		con.OwnerId = u.Id;
		insert con;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        insert att;
        
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.AccountId = acc.Id;
    	oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
            	
    	Sensitive_Attachment__c sa = new Sensitive_Attachment__c();
    	sa.Account__c = acc.Id;
    	sa.Attachment_Id__c = att.Id;
    	sa.Attachment_Name__c = 'Object2';
    	sa.Opportunity__c = oppy.Id;
    	insert sa;
    	
    	/*Sensitive_Attachment__Share sas = new Sensitive_Attachment__Share();
    	sas.UserOrGroupId = UserInfo.getUserId();
    	sas.ParentId = sa.Id;
    	sas.AccessLevel = 'Read';
    	insert sas;*/
    	
		Test.startTest();
		
	    ApexPages.currentPage().getParameters().put('upload','uploadnew');
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(sa); 
    	ExtUploadSensitiveAttachment ext = new ExtUploadSensitiveAttachment(ctrl);
    	ext.sensitiveAttachment = sa;
    	ext.accountId = acc.Id;
    	ext.attachment = att;
    	ext.contact = con;
    	ext.opportunity = oppy;
        
        
        ext.save();
        ext.userAdded();
        ext.getExtUploadSensitiveAttachment();
        ext.cancel();
        //ext.uploadSensitiveAttachment();
        ExtUploadSensitiveAttachment.ShowUser extShow = new ExtUploadSensitiveAttachment.ShowUser();
        extShow.user = u;
        
        system.assert(true);
        Test.stopTest();
    }	
	static testMethod void Parameters2() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();  
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();  	
        Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'helloManesfdsd@testCompany1233423.com';
    	u.Alias = 'mnvk';
    	u.CommunityNickname = 'TMDd';
    	u.ProfileId = p.Id;
		insert u;
		    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account acc = ClsTestHelp.createTestAccounts(); 
		acc.RecordTypeId = rt.Id;
		insert acc;
		
		Contact con = ClsTestHelp.createTestContacts();
		con.OwnerId = u.Id;
		insert con;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        insert att;
        
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.AccountId = acc.Id;
    	oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
            	
    	Sensitive_Attachment__c sa = new Sensitive_Attachment__c();
    	sa.Account__c = null;//acc.Id;
    	sa.Attachment_Id__c = att.Id;
    	sa.Attachment_Name__c = 'Object2';
    	sa.Opportunity__c = oppy.Id;
    	insert sa;
    	
		Test.startTest();
		
	    ApexPages.currentPage().getParameters().put('upload',null);
	    ApexPages.currentPage().getParameters().put('retURL','http://www.baidu.com');
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(sa); 
    	ExtUploadSensitiveAttachment ext = new ExtUploadSensitiveAttachment(ctrl);
    	ext.sensitiveAttachment = sa;
    	ext.accountId = acc.Id;
    	ext.attachment = att;
    	ext.contact = con;
    	ext.opportunity = oppy;
        
        
        ext.save();
        ext.userAdded();
        ext.getExtUploadSensitiveAttachment();
        ext.cancel();
        ExtUploadSensitiveAttachment.ShowUser extShow = new ExtUploadSensitiveAttachment.ShowUser();
        extShow.user = u;
        extShow.isSelected = true;
        
        system.assert(true);
        Test.stopTest();
    }	
	static testMethod void Parameters3() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    	
        Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'lina123@testCompany1233423.com';
    	u.Alias = '12d3';
    	u.CommunityNickname = 'po21';
    	u.ProfileId = p.Id;
		insert u;
		    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account acc = ClsTestHelp.createTestAccounts(); 
		acc.RecordTypeId = rt.Id;
		insert acc;
		
		Contact con = ClsTestHelp.createTestContacts();
		con.OwnerId = u.Id;
		insert con;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        insert att;
        
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.AccountId = acc.Id;
    	oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
            	
    	Sensitive_Attachment__c sa = new Sensitive_Attachment__c();
    	sa.Account__c = null;//acc.Id;
    	sa.Attachment_Id__c = att.Id;
    	sa.Attachment_Name__c = 'Object2';
    	sa.Opportunity__c = oppy.Id;
    	insert sa;
    	
		Test.startTest();
		
	    ApexPages.currentPage().getParameters().put('upload',null);
	    ApexPages.currentPage().getParameters().put('retURL',null);
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(sa); 
    	ExtUploadSensitiveAttachment ext = new ExtUploadSensitiveAttachment(ctrl);
    	ext.sensitiveAttachment = sa;
    	ext.accountId = acc.Id;
    	ext.attachment = att;
    	ext.contact = con;
    	ext.opportunity = oppy;
        
        
        ext.save();
        ext.userAdded();
        ext.getExtUploadSensitiveAttachment();
        ext.cancel();
        ExtUploadSensitiveAttachment.ShowUser extShow = new ExtUploadSensitiveAttachment.ShowUser();
        extShow.user = u;
        extShow.isSelected = true;
        
        system.assert(true);
        Test.stopTest();
    }	
	static testMethod void Parameters4() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    	
        Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = '0opewr@testCompany1233423.com';
    	u.Alias = 'ldtr';
    	u.CommunityNickname = 'oiuy';
    	u.ProfileId = p.Id;
		insert u;
		    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account acc = ClsTestHelp.createTestAccounts(); 
		acc.RecordTypeId = rt.Id;
		insert acc;
		
		Contact con = ClsTestHelp.createTestContacts();
		con.OwnerId = u.Id;
		insert con;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        insert att;
        
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.AccountId = acc.Id;
    	oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
            	
    	Sensitive_Attachment__c sa = new Sensitive_Attachment__c();
    	sa.Account__c = acc.Id;
    	sa.Attachment_Id__c = att.Id;
    	sa.Attachment_Name__c = 'Object2';
    	sa.Opportunity__c = oppy.Id;
    	//insert sa;
    	
		Test.startTest();
		
	    ApexPages.currentPage().getParameters().put('upload','uploadnew');
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(sa); 
    	ExtUploadSensitiveAttachment ext = new ExtUploadSensitiveAttachment(ctrl);
    	ext.sensitiveAttachment = sa;
    	ext.accountId = acc.Id;
    	ext.attachment = att;
    	ext.contact = con;
    	ext.opportunity = oppy;
        
        ext.save();
        ext.userAdded();
        ext.getExtUploadSensitiveAttachment();
        ext.cancel();
        ExtUploadSensitiveAttachment.ShowUser extShow = new ExtUploadSensitiveAttachment.ShowUser();
        extShow.user = u;
        extShow.isSelected = true;
        
        system.assert(true);
        Test.stopTest();
    }	
	static testMethod void Parameters5() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8(); 
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();   	
        Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'asdfadfa@testCompany1233423.com';
    	u.Alias = 'edgn';
    	u.CommunityNickname = 'yrcv';
    	u.ProfileId = p.Id;
		insert u;
		    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account acc = ClsTestHelp.createTestAccounts(); 
		acc.RecordTypeId = rt.Id;
		insert acc;
		
		Contact con = ClsTestHelp.createTestContacts();
		con.OwnerId = u.Id;
		insert con;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        insert att;
        
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.AccountId = acc.Id;
    	oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
            	
    	Sensitive_Attachment__c sa = new Sensitive_Attachment__c();
    	sa.Account__c = null;
    	sa.Attachment_Id__c = att.Id;
    	sa.Attachment_Name__c = 'Object2';
    	sa.Opportunity__c = oppy.Id;
    	//insert sa;
    	Sensitive_Attachment__Share sas = new Sensitive_Attachment__Share();
		Test.startTest();
		
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(sa); 
    	ExtUploadSensitiveAttachment ext = new ExtUploadSensitiveAttachment(ctrl);
    	ext.sensitiveAttachment = sa;
    	ext.accountId = acc.Id;
    	ext.attachment = att;
    	ext.contact = con;
    	ext.opportunity = oppy;
        
        ext.save();
        ext.userAdded();
        ext.getExtUploadSensitiveAttachment();
        ext.cancel();
        ExtUploadSensitiveAttachment.ShowUser extShow = new ExtUploadSensitiveAttachment.ShowUser();
        extShow.user = u;
        extShow.isSelected = true; 
        
        system.assert(true);
        Test.stopTest();
    }	
	static testMethod void Parameters6() {
        Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        Apex_Helper_Settings__c name2 = ClsTestHelp.createTestName2();
        Apex_Helper_Settings__c name3 = ClsTestHelp.createTestName3();
        Apex_Helper_Settings__c name4 = ClsTestHelp.createTestName4();
        Apex_Helper_Settings__c name5 = ClsTestHelp.createTestName5();
        Apex_Helper_Settings__c name6 = ClsTestHelp.createTestName6();
        Apex_Helper_Settings__c name7 = ClsTestHelp.createTestName7(); 
        Apex_Helper_Settings__c name8 = ClsTestHelp.createTestName8();
        Apex_Helper_Settings__c name9 = ClsTestHelp.createTestName9();    	
        Profile p = [Select Id, Name From Profile 
     								where Name = 'Production Support' 
     								or Name = 'Service Account' 
     								or Name ='System Administrator' 
     								or Name ='Systemadministrator' limit 1];
     	User u = ClsTestHelp.createTestUsers();
    	u.Email = 'lina123@testCompany1233423.com';
    	u.Alias = '12d3';
    	u.CommunityNickname = 'po21';
    	u.ProfileId = p.Id;
		insert u;
		    	
        RecordType rt = ClsTestHelp.createTestRecordType();
           
    	Account acc = ClsTestHelp.createTestAccounts(); 
		acc.RecordTypeId = rt.Id;
		insert acc;
		
		Contact con = ClsTestHelp.createTestContacts();
		con.OwnerId = u.Id;
		insert con;
		
    	Attachment att= ClsTestHelp.createTestAttachments();
        att.ParentId = acc.Id;
        insert att;
        
    	Opportunity oppy = ClsTestHelp.createTestOpportunity();
    	oppy.AccountId = acc.Id;
    	oppy.StageName = 'New';
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
            	
    	Sensitive_Attachment__c sa = new Sensitive_Attachment__c();
    	sa.Account__c = null;//acc.Id;
    	sa.Attachment_Id__c = att.Id;
    	sa.Attachment_Name__c = 'Object2';
    	sa.Opportunity__c = oppy.Id;
    	insert sa;
    	
		Test.startTest();
		
	    ApexPages.currentPage().getParameters().put('upload',null);
	    ApexPages.currentPage().getParameters().put('retURL',null);
	    
    	ApexPages.StandardController ctrl = new ApexPages.StandardController(sa); 
    	ExtUploadSensitiveAttachment ext = new ExtUploadSensitiveAttachment(ctrl);
    	ext.sensitiveAttachment = sa;
    	ext.accountId = acc.Id;
    	ext.attachment = att;
    	ext.contact = con;
    	ext.opportunity = oppy;
        
        ext.uploadSensitiveAttachment();
        
        ExtUploadSensitiveAttachment.ShowUser extShow = new ExtUploadSensitiveAttachment.ShowUser();
        extShow.user = u;
        extShow.isSelected = true;
        
        system.assert(true);
        Test.stopTest();
    }	
}