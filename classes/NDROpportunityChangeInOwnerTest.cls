/**********************************************************************************************************************************************
*******
Name: NDROpportunityChangeInOwnerTest   
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================
Purpose: This test class vers test coverage for OpportunityBI_NDROpportunity_Routing trigger and NDROpportunityChangeInOwnerTest class.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  01/24/2013    Test Class                       
***********************************************************************************************************************************************
       Pradeepti Saxena    04/30/2017    Test Class
*****/

@isTest(seeAllData=false)
public class NDROpportunityChangeInOwnerTest{
    static testmethod void NDROppChangeOwnerTest(){
/*------------- Varible declaration and initialisation --------------------*/   
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        List<Opportunity> vLstOppty = new List<Opportunity>();
        List<Opportunity_Part__c> vOppparttestlst = new List<Opportunity_Part__c >();
        RecordType vRT = [select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
        RecordType vRTOppPart = [select id from RecordType where sObjectType =: 'Opportunity_Part__c' and name =: 'NDR Opportunity Parts'];  
        
        Profile p = [Select Id, Name From Profile 
                     where Name = 'Service Account' 
                        or Name ='System Administrator' 
                        or Name ='Systemadministrator' limit 1];
/*------------------ User created for Test ------------------------------*/                        
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.Email = 'ownerchng@test.com';
        u.username = 'ownerchng@test.com';
        u.Alias = 'abc';
        u.CommunityNickname = 'TsMD';
        u.ProfileId = p.Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        insert u;
        
        User u1 =new User();
        u1.FirstName ='Second';
        u1.LastName = 'Tester';
        u1.Email = 'ownerchng1@test.com';
        u1.username = 'ownerchng1@test.com';
        u1.Alias = 'owner';
        u1.CommunityNickname = 'owner';
        u1.ProfileId = p.Id;
        u1.TimeZoneSidKey = 'America/Chicago';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.LanguageLocaleKey = 'en_US';
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




/*------code changes by Pradeepti---------*/
 Apex_Helper_Settings__c ah=new Apex_Helper_Settings__c(name='Channel profile ids',value__c='00eE00000010eNi',active__c=true);
 Apex_Helper_Settings__c ah1=new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
 
 Opportunity_Record_Type_Groups__c org=new Opportunity_Record_Type_Groups__c(name='test',Active__c=true,Group__c='RFQ 2.0 Quotes',RecordTypeID__c='0120L00000068GBQAY');
 Opportunity_Record_Type_Groups__c org1=new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true);
 
 Route_NDR_Opportunity rnd=new Route_NDR_Opportunity();
 NDR_Region_Sales_and_Cust_Region_Mapping__c nrs=new NDR_Region_Sales_and_Cust_Region_Mapping__c(name='test',Customer_Region__c='South America;North America',Region_Sales__c='test', NDR_END_Customer_Country__c='test');
 
 account acc=new account(Name='Test',Type='Prospect',Industry_Code_Description__c='Appliances',CurrencyIsoCode='USD');
 insert acc;       
 account acc1=new account(Name='Test1',Type='Prospect',Industry_Code_Description__c='Appliances',CurrencyIsoCode='USD');       
  insert acc1;      
        
        
        
/*-------------------- Bulk Test reords ----------------------------------*/
        for(Integer i=0;i<13;i++){
            Opportunity vTestOppty = ClsTestHelp.createTestOpportunity();
            vTestOppty.recordtypeid = vRT.id;
            vTestOppty.NDR_DMM_Email_Address__c = 'test@test.com';
            vTestOppty.NDR_SAP_Region__c = 'EMEA';
            vTestOppty.ownerid = u.id;
            vTestOppty.accountid=acc.id;
            vTestOppty.NDR_END_Customer_Country__c='JP';
            vTestOppty.recordtypeid ='0120L00000068GBQAY';
            vLstOppty.add(vTestOppty);
        }  
        list<opportunity> vLstOppty1=new list<opportunity>();
        for(Integer i=0;i<5;i++){
            Opportunity vTestOppty1 = ClsTestHelp.createTestOpportunity();
            vTestOppty1.recordtypeid = vRT.id;
            vTestOppty1.NDR_DMM_Email_Address__c = 'test@test1.com';
            vTestOppty1.NDR_SAP_Region__c = 'EMEA';
            vTestOppty1.ownerid = u.id;
            vTestOppty1.accountid=acc1.id;
            vTestOppty1.NDR_END_Customer_Country__c='JP';
            vTestOppty1.recordtypeid ='0120L00000068GBQAY';
            vLstOppty1.add(vTestOppty1);
        }  
        
/*----------------- Opportunity routed to correct DMM ---------------------*/            
        Opportunity vOppty = ClsTestHelp.createTestOpportunity();
        vOppty.recordtypeid ='0120L00000068GBQAY';
        vOppty.NDR_DMM_Email_Address__c = 'test@test.com';
        vOppty.NDR_SAP_Region__c = 'EMEA';
        vOppty.ownerid = u.id;
       // vLstOppty.add(vOppty);
/*----------------- Opportunity routed to defualt DMM ----------------------*/        
        Opportunity vOppty1 = ClsTestHelp.createTestOpportunity();
        vOppty1.recordtypeid = vRT.id;
        vOppty1.NDR_DMM_Email_Address__c = 'test@test.in';
        vOppty1.NDR_SAP_Region__c = 'EMEA';
        vOppty1.accountId=acc.id;
       // vLstOppty.add(vOppty1);
        
/*--------------- Run this test as User u ----------------------------------*/                
        system.runAs(u){
            test.starttest();
            insert ah;
            insert ah1;
            insert org;
            insert org1;
            insert vOppty;
            insert vOppty1;
            insert vLstOppty;
            insert nrs;
            
            Map<Id,Opportunity> mappy=new Map<Id,Opportunity>();
            for(opportunity opp:vLstOppty1){
                mappy.put(opp.id, opp);
                
            }
           rnd.AssignDMMtoNDROpportunity(vLstOppty);
           rnd.UpdateENDandPOSAccountFields(vLstOppty,mappy);
         //Added opportunity part to test SFDC-SAP integration path
          for(Opportunity opp : vLstOppty){ 
          system.debug('----------------****'+opp.id);          
            Opportunity_Part__c vOpptypart2 = ClsTestHelp.createTestOpportunityPart();
            vOpptypart2.Opportunity__c = opp.Id;
            vOpptypart2.Part__c = part.Id;
            vOpptypart2.GPL__c = ph.Id;
            vOpptypart2.recordtypeid =vRTOppPart.id;
            vOpptypart2.NDR_Rejection_Reason__c='Other';
            vOpptypart2.NDR_Rejection_Comments__c='Other';
            vOpptypart2.Red_Flag_Reason__c='1,2';
            vOpptypart2.NDR_Approve_Reject_Indicator__c = 'A';
            vOpptypart2.Status__c = 'Lost';
            vOpptypart2.Lost_Reason__c = 'Other';
            vOpptypart2.Lost_Reason_Text__c = null;
            vOpptypart2.Process_Status__c = 'Lost';
            vOppparttestlst.add(vOpptypart2);
           }
            insert vOppparttestlst;
            NDRUtility.NDRboolean = false;
            update vLstOppty;
            
            NDRUtility.NDRboolean = false;
            vOppty.ownerid = u1.id;
            vOppty.AccountId=null;
            vOppty.POS_Account__c=acc1.Id;
            update vOppty;
            vOppty1.NDR_SAP_Region__c ='Region Not Found';
            //vOppty1.AccountId=acc1.Id;
            vOppty1.POS_Account__c=acc1.Id;
            update vOppty1;
            Opportunity vOppTest = [select id,ownerid from Opportunity where id =: vOppty.id ];
            System.assert(vOppTest.ownerid == u1.id,'Please verify owner of opportunity changed or not');
         test.stoptest();  
        }
            NDRUtility.NDRboolean = false;
            vOppty.ownerid = u1.id;
            vOppty.AccountId=null;
            vOppty.POS_Account__c=acc1.Id;
            update vOppty;
         Account AccOpp=new Account();
         accOpp.Name = 'Test1';
         accOpp.BillingStreet = 'XXXXXXX';
         AccOpp.BillingCity = 'YYY';
         AccOpp.BillingCountry = 'ZZZZZ';
         AccOpp.BillingPostalCode = '239932';
        insert AccOpp;
        List<Opportunity> AccOpp1=new list<Opportunity>();
        list<Opportunity> Opp=[Select Id,End_Customer_Name__c,NDR_END_Customer_Street__c,NDR_END_Customer_City__c,NDR_END_Customer_Country__c,NDR_END_Customer_Zip_Code__c from Opportunity where Id=:AccOpp.id];
        for(Opportunity op:Opp){
           op.Id = accOpp.id;
           op.End_Customer_Name__c = AccOpp.Name;
           op.NDR_END_Customer_street__c = AccOpp.BillingStreet;
           op.NDR_END_Customer_City__c = AccOpp.BillingCity;
           op.NDR_END_Customer_Country__c = AccOpp.BillingCountry;
           op.NDR_END_Customer_Zip_Code__c = AccOpp.BillingPostalCode;
            Accopp1.add(op);
        }
        update AccOpp1;
         
    }// End of NDROppRoutingTest() test method
/*---------------------------------------------------------------------------*/    
}// End of Test Class