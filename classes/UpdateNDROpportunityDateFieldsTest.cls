/**********************************************************************************************************************************************
*******
Name: UpdateNDROpportunityDateFieldsTest   
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class vers test coverage for OpportunityBI_NDROpportunity_Routing trigger and Update_NDR_Opportunity_Date_Fields class.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  01/24/2013    Test Class                       
***********************************************************************************************************************************************
*****/
@isTest(seeAllData=true)
public class UpdateNDROpportunityDateFieldsTest{
    static testmethod void NDROppRoutingTest(){
/*------------- Varible declaration and initialisation --------------------*/    
        List<Opportunity> vLstOppty = new List<Opportunity>();
        Date DefDate = date.newInstance(1900,1,1);   
        RecordType vRT = [select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
        
        Profile p = [Select Id, Name From Profile 
                     where Name = 'Channel Standard User' 
                        or Name = 'Service Account' 
                        or Name ='System Administrator' 
                        or Name ='Systemadministrator' limit 1];
/*------------------ User created for Test ------------------------------*/                        
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'test@test.com';
        u.Alias = 'abc';
        u.CommunityNickname = 'TsMD';
        u.ProfileId = p.Id;
        insert u;
        
        
           
/*-------------------- Bulk Test reords ----------------------------------*/
        for(Integer i=0;i<10;i++){
            Opportunity vTestOppty = ClsTestHelp.createTestOpportunity();
            vTestOppty.recordtypeid = vRT.id;
            vTestOppty.NDR_DMM_Email_Address__c = 'test@test.com';
            vTestOppty.NDR_SAP_Region__c = 'EMEA';
            vTestOppty.NDR_Quote_Effective_Date__c = DefDate ;
            vTestOppty.NDR_Quote_Requested_date__c = DefDate ;
            vTestOppty.NDR_Quote_Expiration_Date__c = DefDate ;
            vTestOppty.Initial_Order_Date__c= DefDate ;
            vTestOppty.Prototype_Date__c= DefDate ;
            vLstOppty.add(vTestOppty);
        }  
/*----------------- Opportunity routed to correct DMM ---------------------*/            
        Opportunity vOppty = ClsTestHelp.createTestOpportunity();
        vOppty.recordtypeid = vRT.id;
        vOppty.NDR_DMM_Email_Address__c = 'test@test.com';
        vOppty.NDR_SAP_Region__c = 'EMEA';
        vOppty.NDR_Quote_Effective_Date__c = DefDate ;
        vOppty.NDR_Quote_Requested_date__c = DefDate ;
        vOppty.NDR_Quote_Expiration_Date__c = DefDate ;
        vOppty.Initial_Order_Date__c= DefDate ;
        vOppty.Prototype_Date__c= DefDate ;
   
/*--------------- Run this test as User u ----------------------------------*/                
        system.runAs(u){
            test.starttest();
                Apex_Helper_Settings__c mycs = [select Id,Name,Value__c from Apex_Helper_Settings__c where Name = 'NDR Opportunity' limit 1];
  
                if(mycs == null) {
                mycs = new Apex_Helper_Settings__c(Name= 'NDR Opportunity');
                mycs.Value__c = vRT.id;
                insert mycs;
              }
                System.debug('Custom setting record***'+mycs);  
                insert vOppty;
                insert vLstOppty;
                Opportunity vOppTest = [select id,NDR_Quote_Effective_Date__c,NDR_Quote_Requested_date__c,NDR_Quote_Expiration_Date__c,Initial_Order_Date__c from Opportunity where id=:vOppty.id];
                system.assert(vOppTest.NDR_Quote_Effective_Date__c == null,'Please verify NDR_Quote_Effective_Date__c date field');
                system.assert(vOppTest.NDR_Quote_Requested_date__c == null,'Please verify NDR_Quote_Requested_date__c date field');
                system.assert(vOppTest.NDR_Quote_Expiration_Date__c == null,'Please verify NDR_Quote_Expiration_Date__c  date field');
                system.assert(vOppTest.Initial_Order_Date__c == null,'Please verify Initial_Order_Date__c date field');
            
            test.stoptest();
        }
    }// End of NDROppRoutingTest() test method
/*---------------------------------------------------------------------------*/    
}// End of Test Class