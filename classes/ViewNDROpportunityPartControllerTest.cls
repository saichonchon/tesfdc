/****
************************************************************************************************************************
      Name : NDRPartsControllerTest
       Org : C2S-ChannelDev
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods and negative behavioral test methods for 
             'NDRPartsController'
________________________________________________________________________________________________________________________
 Apex class whose code is covered : NDRPartsController
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER             DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0                     24/4/2013    Test Class
***********************************************************************************************************************
****/

@isTest(seeAllData=true)
class ViewNDROpportunityPartControllerTest{
    static testMethod void ViewNDROpportunityPartTest() {
    /*------------- Varible declaration and initialisation --------------------*/    
    List<Opportunity> vLstOppty = new List<Opportunity>();
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
    insert vOpptypart1;
    
    Opportunity_Part__c vOpptypart2 = ClsTestHelp.createTestOpportunityPart();
    vOpptypart2.Opportunity__c = vOppty.Id;
    vOpptypart2.Part__c = part.Id;
    vOpptypart2.GPL__c = ph.Id;
    //vOpptypart1.recordtypeid =vRTOppPart.id;
    insert vOpptypart2;
    
/*------------ Set page reference to NDRParts page -------------------*/       
            PageReference ref = Page.ViewNDROpportunityPart; 
            Test.setCurrentPageReference(ref);
            ApexPages.StandardController stdController = new ApexPages.StandardController(vOpptypart1);             
            ApexPages.currentpage().getParameters().put('id',vOpptypart1.id);
            ViewNDROpportunityPartController cmc = new ViewNDROpportunityPartController(stdController);
            cmc.Redirect();
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(vOpptypart2);             
            ApexPages.currentpage().getParameters().put('id',vOpptypart2.id);
            ViewNDROpportunityPartController cmc1 = new ViewNDROpportunityPartController(stdController1);
            cmc1.Redirect();

            Test.stopTest(); 
        }
    }
}//End of testclass
/*------------------------------------------------------------------------------------------------
--------*/