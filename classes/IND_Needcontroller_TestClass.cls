@isTest(SeeAllData=true)
/* -------------------------------------------------------------------------------------
 Test Class Written by Deepak Kumar 04/06/2015
* ------------------------------------------------------------------------------------- */
private class IND_Needcontroller_TestClass {

    static testMethod void myUnitTest1() {

      Test.startTest();
      
         // User Record
        //Profile p = [SELECT Id FROM Profile WHERE Name='Bu Admin']; 
        
       // User u = new User(GIBU__c='Consumer Devices', Alias = 'standt', Email='test432@testorg.com', EmailEncodingKey='UTF-8', LastName='Tes', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName='test432@testorg.com', CSD_Region__c='Taiwan');
       
       Account a = new account();
    a.Name= 'test account';
    a.RecordTypeId='012E0000000I9EG';
    a.STATDESC__c= 'Not Active';
    a.BillingCountry = 'US';
     
     insert a;   
        //Opportunity Record types
       // Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Opportunity; 
      //  Map<String,Schema.RecordTypeInfo> OpportunityRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
      //  Id CSDrtId = OpportunityRecordTypeInfo.get('IND - Sales Project').getRecordTypeId();
        
        
       
     opportunity opp = new opportunity(name='test',AccountID=a.id,Type='New Business', Request_Type__c= 'sales only',Description__c='test',stagename = 'new',closedate = date.today()+5, Currency_Confirm__c = true);
   
         //insert opp;       
        try{insert opp;}
            
       catch(exception e){}
        
          Contact conta= new contact(lastname= 'test');
            insert conta;
       // opportunity oppp1=[select id from opportunity limit 1];
        //Contact conta=[select id from contact limit 1];
     
      
      Custom_Opportunity_Contact_Role__c Controle = new Custom_Opportunity_Contact_Role__c(Contact__c=conta.id,Opportunity__c=opp.id);
      
      insert Controle;
      
      Need__c need = new Need__c(Contact_Role__c=Controle.id,Need__c='test',Need_Status__c='Expressed');  
      
      insert need;
      
      Need__c need1 = new Need__c(Contact_Role__c=Controle.id);  
      
      insert need1; 
      
      
      PageReference pageRef = Page.IND_Need_Layout;
        pageRef.getParameters().put('id', String.valueOf(Controle.Id));
        test.setCurrentPage(pageRef);
        ApexPages.StandardController str= new ApexPages.StandardController(Controle);
        IND_NEED_Controller partiClass = new IND_NEED_Controller(str); 
        partiClass.AddNeed();
        partiClass.Customsave();
        //partiClass.CustomCancel();
        
      Test.StopTest();
     }  
  
     
}