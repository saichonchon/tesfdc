/**********************************************************************************************************************************************
*******
Name: OpportunityBIU_NDROpportunity_RoutingTest   
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class vers test coverage for OpportunityBI_NDROpportunity_Routing trigger and Route_NDR_Opportunity class.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  01/24/2013    Test Class                       
***********************************************************************************************************************************************
*****/
@isTest(seeAllData=true)
public class OpportunityBIU_NDROpportunityRoutingTest{
    static testmethod void NDROppRoutingTest(){
/*------------- Varible declaration and initialisation --------------------*/    
        List<Opportunity> vLstOppty = new List<Opportunity>();
        List<Opportunity> vLstOppty1 = new List<Opportunity>();
        RecordType vRT = [select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
        RecordType vRTOppPart = [select id from RecordType where sObjectType =: 'Opportunity_Part__c' and name =: 'NDR Opportunity Parts'];  
    
        Profile p = [Select Id, Name From Profile 
                     where Name = 'Channel Standard User' 
                        or Name = 'Service Account' 
                        or Name ='System Administrator' 
                        or Name ='Systemadministrator' limit 1];
/*------------------ User created for Test ------------------------------*/                        
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'test@test.com';
        u.username = 'dmmrouting@test.com';
        u.Alias = 'abc';
        u.CommunityNickname = 'TsMD';
        u.ProfileId = p.Id;
        insert u;
        
        User u1 = ClsTestHelp.createTestUsers();
        u1.Email = 'test123@test.com';
        u1.username = 'AccMngrrouting@test.com';
        u1.Alias = 'abcde';
        u1.CommunityNickname = 'TsMDab';
        u1.ProfileId = p.Id;
        insert u1;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.name = 'Test Zensar';
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial';
        insert ph;
        Part__c part = new Part__c();
        part.name = 'Test Zensar';
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
        insert part;
        
        Account acct = new Account();
        acct.Name = 'Focus Account';
        acct.BillingCountry = 'CN';
        acct.BillingCountry='CN';
        acct.Account_Manager__c = u1.id;
        acct.Channel_Target_Account__c = true;
        insert acct;
        System.assertEquals(acct.Account_Manager__c,u1.id);
        Account acct1 = new Account();
        acct1.Name = 'Not a focus Account';
        acct1.BillingCountry = 'CN';
        acct1.BillingCountry='CN';
        acct1.Account_Manager__c = u1.id;
        acct1.Channel_Target_Account__c = false;
        insert acct1;
        
        
/*-------------------- Bulk Test reords ----------------------------------*/
        for(Integer i=0;i<10;i++){
            Opportunity vTestOppty = ClsTestHelp.createTestOpportunity();
            vTestOppty.recordtypeid = vRT.id;
            vTestOppty.NDR_DMM_Email_Address__c = 'test@test.com';
            vTestOppty.NDR_SAP_Region__c = 'EMEA';
            vLstOppty.add(vTestOppty);
        }  
/*----------------- Opportunity routed to Acc Manager for Focus account ---------------------*/            
        Opportunity vOppty3 = ClsTestHelp.createTestOpportunity();
        vOppty3.recordtypeid = vRT.id;
        vOppty3.AccountId = acct.Id;
        vOppty3.NDR_DMM_Email_Address__c = 'test@test.com';
        vOppty3.NDR_SAP_Region__c = 'AP';
        vLstOppty1.add(vOppty3);
        
/*----------------- Opportunity routed to correct DMM ---------------------*/            
        Opportunity vOppty = ClsTestHelp.createTestOpportunity();
        vOppty.recordtypeid = vRT.id;
        vOppty.AccountId = acct1.Id;
        vOppty.NDR_DMM_Email_Address__c = 'test@test.com';
        vOppty.NDR_SAP_Region__c = 'EMEA';
        vLstOppty1.add(vOppty);
/*----------------- Opportunity routed to defualt DMM ----------------------*/        
        Opportunity vOppty1 = ClsTestHelp.createTestOpportunity();
        vOppty1.recordtypeid = vRT.id;
        vOppty1.AccountId = acct1.Id;
        //vOppty1.NDR_DMM_Email_Address__c = 'test@test.in';
        vOppty1.NDR_SAP_Region__c = 'EMEA';
        vLstOppty1.add(vOppty1);
        
/*--------------- Run this test as User u ----------------------------------*/                
        system.runAs(u){
            test.starttest();
                Apex_Helper_Settings__c ahs9 = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c ahs10 : [select Id,Value__c from Apex_Helper_Settings__c where Name = 'NDR Opportunity Parts' limit 1]){
            ahs9 = ahs10;
        }
        if(ahs9.Value__c == null){
            ahs9.Name = 'NDR Opportunity Parts';
            ahs9.Value__c = vRTOppPart.id;
            insert ahs9;
        } 
        Apex_Helper_Settings__c ahs1 = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c ahs2 : [select Id,Value__c from Apex_Helper_Settings__c where Name = 'NDR Opportunity' limit 1]){
            ahs1 = ahs2;
        }
        if(ahs1.Value__c == null){
            ahs1.Name = 'NDR Opportunity';
            ahs1.Value__c = vRT.id;
            insert ahs1;
        }
                insert vLstOppty1;
                insert vLstOppty;
                Opportunity vOppty4 = [select Id,OwnerId from Opportunity where id = : vOppty.id];
                
                
        vOppty4.ownerId = u.Id;
        NDRUtility.NDRboolean = false;
        Update vOppty4;
        Opportunity vOppty5 = [select Id,OwnerId,AccountId from Opportunity where id = : vOppty.id];
        vOppty5.AccountId = acct.Id;
        vOppty5.POS_Account__c = acct.Id;
        NDRUtility.NDRboolean = false;
        Update vOppty5;
            //Added opportunity part to test SFDC-SAP integration path           
            Opportunity_Part__c vOpptypart2 = ClsTestHelp.createTestOpportunityPart();
            vOpptypart2.Opportunity__c = vOppty.Id;
            vOpptypart2.Part__c = part.Id;
            vOpptypart2.GPL__c = ph.Id;
            vOpptypart2.recordtypeid =vRTOppPart.id;
            vOpptypart2.NDR_Rejection_Reason__c='Other';
            vOpptypart2.NDR_Rejection_Comments__c='Other';
            vOpptypart2.Red_Flag_Reason__c='1,2';
            vOpptypart2.NDR_Approve_Reject_Indicator__c = 'A';
            insert vOpptypart2;
            Opportunity vOppTest = [select id,NDR_Initiate_SFDC_SAP_Integration__c from Opportunity where id =: VOppty.id];
            System.assert(vOppTest.NDR_Initiate_SFDC_SAP_Integration__c == 'Y','CI Orch path not tested');
            test.stoptest();
        }
    }// End of NDROppRoutingTest() test method
    static testmethod void NDROppRoutingTest2(){
    RecordType vRT = [select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
     Opportunity vOppty2 = ClsTestHelp.createTestOpportunity();
        vOppty2.recordtypeid = vRT.id;
        //vOppty1.NDR_DMM_Email_Address__c = 'test@test.in';
        vOppty2.NDR_SAP_Region__c = 'AP';
    insert vOppty2;
    }
/*---------------------------------------------------------------------------*/    
}// End of Test Class