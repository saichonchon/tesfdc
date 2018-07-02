/**************************************************************************************************************************************************
Name:  CSD_CloneOpptyWithPartsCtrlTest
Copyright © 2014 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for CSD_CloneOpptyWithPartsCtrl
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : CSD_CloneOpptyWithPartsCtrl                                                             
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Prabanjan       18/04/2014  Initial Development                                                       
**************************************************************************************************************************************************/
@isTest(SeeAllData=true) 
private class CSD_CloneOpptyWithPartsCtrlTest {
        
        RecordType rt = [select id,Name, DeveloperName from RecordType where SobjectType = 'Account' and DeveloperName = 'OEM'];
        RecordType rt2 = [select id,name from recordtype where sobjecttype='Opportunity' and name ='Sales Opportunity-CSD'];
        RecordType rt3 = [select id,name from recordtype where sobjecttype='Opportunity' and name ='Opportunity - Engineering Project'];
        RecordType rt4 = [select id,name from recordtype where sobjecttype='Opportunity' and name ='Opportunity - Product Platform'];
              
         
    
  static testMethod void testmethod1() {
      
        user testuser = ClsTestHelp.createTestUsers(); 
        insert testuser;
    
      System.runAs(testuser) {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM'; 
        insert acc;
        RecordType rt = [select id,Name, DeveloperName from RecordType where SobjectType = 'Account' and DeveloperName = 'OEM'];
        RecordType rt2 = [select id,name from recordtype where sobjecttype='Opportunity' and name ='Sales Opportunity-CSD'];
           
        Account oemacc = new account (recordtypeid = rt.id, name='test oem');
        insert oemacc;
      
        Opportunity oppy2 = new Opportunity();
        oppy2.RecordTypeId = rt2.Id;
        oppy2.StageName = 'New Opportunity';
        oppy2.Name = 'SandKing1';
        oppy2.currency_confirm__c = true;
        oppy2.CloseDate = date.today();  
        oppy2.Type = 'New Business';
        oppy2.Request_Type__c = 'Extension';
        oppy2.description = 'naah'; 
        oppy2.Manufacturing_Start_Date__c=date.today();
        oppy2.Amount=101010;
        oppy2.OEM_Name__c = oemacc.id;
        oppy2.Explanation_of_Change__c= 'test';
        insert oppy2;  
        
        Opportunity oppy = new Opportunity();
        oppy.RecordTypeId = rt2.Id; 
        oppy.OEM_Name__c = oemacc.id;
        oppy.Amount=101010;
        oppy.StageName = 'New Opportunity';
        oppy.currency_confirm__c = true;
        oppy.Name = 'SandKing';
        oppy.CloseDate = date.today();  
        oppy.Program__c = oppy2.Id;   
        oppy.Type = 'New Business';
        oppy.Request_Type__c = 'Extension';
        oppy.description = 'naah'; 
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        insert oppy;
        
              
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy.Id;
        oppypart.Part__c = part.Id;
        insert oppypart;
        
        Opportunity_Forecast__c oppyForecast = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast.Opportunity__c = oppy.Id;
        oppyForecast.Quantity__c = 12;
        oppyForecast.Part__c = oppypart.Id;
        oppyForecast.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast.Amount__c = 1;
        insert oppyForecast;
        
        Opportunity_Forecast__c oppyForecast2 = ClsTestHelp.createTestOpportunityForecasts();
        oppyForecast2.Opportunity__c = oppy.Id;
        oppyForecast2.Quantity__c = 12;
        oppyForecast2.Part__c = oppypart.Id;
        oppyForecast2.Date__c = date.newInstance(2012, 09, 28);
        oppyForecast2.Amount__c = 1;
        insert oppyForecast2;
      
      
        test.startTest();
        PageReference clonepage = Page.CSD_CloneOpptyWithParts;
        clonepage.getParameters().put('Id', oppy.Id);
        test.setCurrentPage(clonepage);
   
        apexpages.StandardController sc=new apexpages.StandardController(oppy);  
        CSD_CloneOpptyWithPartsCtrl plmv=new CSD_CloneOpptyWithPartsCtrl(sc);      
    
        PageReference pageRef = plmv.CloneOpty();  
        
        test.stopTest();
      }
  }
  static testMethod void testmethod2() { 
      
        user testuser2 = ClsTestHelp.createTestUsers(); 
        insert testuser2;
    
    System.runAs(testuser2) {      
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM'; 
        insert acc;
        RecordType rt = [select id,Name, DeveloperName from RecordType where SobjectType = 'Account' and DeveloperName = 'OEM'];
        RecordType rt3 = [select id,name from recordtype where sobjecttype='Opportunity' and name ='Opportunity - Engineering Project'];
          
        Account oemacc = new account (recordtypeid = rt.id, name='test oem');
        insert oemacc;
      
        Opportunity oppy3 = new Opportunity();
        oppy3.RecordTypeId = rt3.Id; 
        oppy3.OEM_Name__c = oemacc.id;
        oppy3.Amount=101010;
        oppy3.StageName = 'New Opportunity';
        oppy3.Name = 'SandKing';
        oppy3.CloseDate = date.today();  
        oppy3.currency_confirm__c = true;
         oppy3.Type = 'New Business';
        oppy3.Request_Type__c = 'Extension';
        oppy3.description = 'naah'; 
        oppy3.Method__c = 'BOM';
        oppy3.Level__c = 'Yearly';
        oppy3.Amount = 1;
        oppy3.CurrencyIsoCode = 'EUR';
        oppy3.Five_Year_Revenue__c = 1;
        oppy3.Explanation_of_Change__c= 'test';
        insert oppy3;

        
        test.startTest();
        PageReference clonepage3 = Page.CSD_CloneOpptyWithParts;
        clonepage3.getParameters().put('Id', oppy3.Id);
        test.setCurrentPage(clonepage3);
   
        apexpages.StandardController sc3=new apexpages.StandardController(oppy3);  
        CSD_CloneOpptyWithPartsCtrl plmv3=new CSD_CloneOpptyWithPartsCtrl(sc3);      
    
        PageReference pageRef3 = plmv3.CloneOpty();  
        
        test.stopTest(); 
    }
  }
  static testMethod void testmethod3() { 
        user testuser3 = ClsTestHelp.createTestUsers(); 
        insert testuser3;
       
      System.runAs(testuser3) {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM'; 
        insert acc;
        RecordType rt = [select id,Name, DeveloperName from RecordType where SobjectType = 'Account' and DeveloperName = 'OEM'];
        RecordType rt4 = [select id,name from recordtype where sobjecttype='Opportunity' and name ='Opportunity - Product Platform'];
         
        Account oemacc = new account (recordtypeid = rt.id, name='test oem');
        insert oemacc;
         
        Opportunity oppy4 = new Opportunity();
        oppy4.RecordTypeId = rt4.Id; 
        oppy4.OEM_Name__c = oemacc.id;
        oppy4.Amount=101010;
        oppy4.StageName = 'New Opportunity';
        oppy4.currency_confirm__c = true;
        oppy4.Name = 'SandKing';
        oppy4.CloseDate = date.today();  
         oppy4.Type = 'New Business';
        oppy4.Request_Type__c = 'Extension';
        oppy4.description = 'naah'; 
        oppy4.Method__c = 'BOM';
        oppy4.Level__c = 'Yearly';
        oppy4.Amount = 1;
        oppy4.CurrencyIsoCode = 'EUR';
        oppy4.Five_Year_Revenue__c = 1;
        insert oppy4;
          
        test.startTest();
        PageReference clonepage4 = Page.CSD_CloneOpptyWithParts;
        clonepage4.getParameters().put('Id', oppy4.Id);
        test.setCurrentPage(clonepage4);
   
        apexpages.StandardController sc4=new apexpages.StandardController(oppy4);  
        CSD_CloneOpptyWithPartsCtrl plmv4=new CSD_CloneOpptyWithPartsCtrl(sc4);      
    
        PageReference pageRef4 = plmv4.CloneOpty();  
        
        test.stopTest();
      }       
 }

}