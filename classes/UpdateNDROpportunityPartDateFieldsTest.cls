/****
************************************************************************************************************************
      Name : UpdateNDROpportunityPartDateFieldsTest
       Org : C2S-ChannelDev
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods and negative behavioral test methods for 
             'UpdateNDROpportunityPartDateFields'
________________________________________________________________________________________________________________________
 Apex class whose code is covered : UpdateNDROpportunityPartDateFields
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER             DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0                     24/4/2013    Test Class
***********************************************************************************************************************
****/

@isTest(seeAllData=true)
class UpdateNDROpportunityPartDateFieldsTest{
    static testMethod void TestNDRParts() {
    
    /*------------- Varible declaration and initialisation --------------------*/    
  
   Date DefDate = date.newInstance(1900,1,1);
    RecordType vRTOpp = [select id from RecordType where sObjectType =: 'Opportunity' and name =: 'NDR Opportunity'];  
    RecordType vRTOppPart = [select id from RecordType where sObjectType =: 'Opportunity_Part__c' and name =: 'NDR Opportunity Parts'];  
    
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
    
    system.runas(u){
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
            ahs1.Value__c = vRTOpp.id;
            insert ahs1;
        } 
    /*--------------------- Insert Opportunity -----------------------------*/
    Opportunity vOppty = ClsTestHelp.createTestOpportunity();
    vOppty.RecordTypeId = vRTOpp.Id;
    vOppty.NDR_SAP_Region__c='AP';
    insert vOppty;
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
    /*------------------ Insert Opportunity Part ---------------------------*/
    Opportunity_Part__c vOpptypart1 = ClsTestHelp.createTestOpportunityPart();
    vOpptypart1.Opportunity__c = vOppty.Id;
    vOpptypart1.Part__c = part.Id;
    vOpptypart1.GPL__c = ph.Id;
    vOpptypart1.recordtypeid =vRTOppPart.id;
    vOpptyPart1.NDR_Price_Expiration_Date__c = DefDate ;
    vOpptyPart1.NDR_Price_Effective_Date__c =DefDate ;
    vOpptyPart1.NDR_final_approver_Name__c = '0';
    insert vOpptypart1;
    Opportunity_Part__c vOppPartTest = [select id,NDR_Price_Expiration_Date__c,NDR_Price_Effective_Date__c from Opportunity_Part__c where id=:vOpptypart1.id];
    system.assert(vOppPartTest.NDR_Price_Expiration_Date__c== null,'Please verify NDR_Price_Expiration_Date__c date field');
    system.assert(vOppPartTest.NDR_Price_Effective_Date__c== null,'Please verify NDR_Price_Effective_Date__cdate field');
                
            
}
}
}