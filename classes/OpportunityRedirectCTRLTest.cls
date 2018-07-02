/**
*   This test class is for OpportunityRedirectCTRLTest.
*
@author Satyabrat Mohapatra
@created 2017-02-08
@version 1.0
*
* - Test coverage -82%
*/
@isTest
public class OpportunityRedirectCTRLTest {
       static testmethod void testMethod1(){
            
            PageReference pageRef = Page.Opportunity_Redirect_Page;
            Test.setCurrentPage(pageRef); 
           // ID accRecid = [Select Id,Name from RecordType where Name = 'Prospect'].Id;
           ID oRTid1 = [Select Id,Name from RecordType where Name = 'Opportunity - Sales Project'].Id;
           Opportunity opp = new Opportunity();
           opp.RecordTypeId = oRTid1;
           ApexPages.currentPage().getParameters().put('RecordType','ADM');
            
            OpportunityRedirectCTRL optrc=new OpportunityRedirectCTRL(new ApexPages.StandardController(opp));
           
            optrc.redirect();
           SelectedRecordType__c opRec=new SelectedRecordType__c();
        }
         static testmethod void testMethod2(){
         
             User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
            System.runAs ( thisUser ){
            //UserRole ur = [Select PortalType, PortalAccountId From UserRole where PortalType =:'CustomerPortal' limit 1];
            Profile p = [select Id,name From Profile Where Name='DND Standard User' limit 1];
            
            User newUser = new User(
                profileId = p.id, 
                username = 'newUser1234@yahoo.com', 
                email = 'pb@ff.com', 
                emailencodingkey = 'UTF-8', 
                localesidkey = 'en_US', 
                languagelocalekey = 'en_US', 
                timezonesidkey = 'America/Los_Angeles', 
                alias='nuser', 
                lastname='lastname' 
                );
              insert newUser;   
            SelectedRecordType__c cs = new SelectedRecordType__c();
            ID oRTid1 = [Select Id,Name from RecordType where Name = 'DND Opportunity'].Id;
			cs.SelRecordType__c ='DND Opportunity';
			cs.SelRecordType__c = oRTid1;
        	cs.Name = 'Test';
			upsert cs;  
            }
             
            ID oRTid = [Select Id,Name from RecordType where Name = 'Opportunity - Sales Project'].Id;
            Opportunity opp = new Opportunity();
              opp.RecordTypeId = oRTid;
            PageReference pageRef = Page.Opportunity_Redirect_Page;
            Test.setCurrentPage(pageRef); 
            ID accRecid = [Select Id,Name from RecordType where Name = 'Prospect'].Id;
            ApexPages.currentPage().getParameters().put('RecordType','ADM');
            ApexPages.currentPage().getParameters().put('Id',opp.RecordTypeId);//Pass Id to page 
            
            
            OpportunityRedirectCTRL optrc=new OpportunityRedirectCTRL(new ApexPages.StandardController(opp));
            optrc.redirect();
        }
    
}