@isTest(seeAllData=true)
private class TestWebToCaseContExtML {
  
  public testMethod static void testWebToCaseContExtML() {
        Case testCase = new Case();
        PIC_Language__c vPICLanObj = new PIC_Language__c();
        
        Test.startTest();     
              
               
        string queryString = 'p_email.addr=test@te.com&p_name.first=test&p_name.last=test&p_addr.country_id=us&p_company_name=TEC&p_competitor_part_no=23&p_lg=en&p_competitor_name=76&p_product=Test';
        queryString = Encodingutil.base64Encode(blob.valueOf(queryString));
        queryString  = Encodingutil.UrlEncode(queryString,'UTF-8');
        PageReference ref = new PageReference('/apex/emailus_ML?'+queryString); 
        Test.setCurrentPage(ref);
        system.debug('queryString *****'+queryString);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        
        WebToCaseContExtML contExt = new WebToCaseContExtML(sc);
        system.debug('queryString after*****'+contExt.paramUrl);
        
        PICMLanguage objPic = new PICMLanguage (sc);
        
        contExt.init();
        
        contExt.renderStyleBlock = true;      
        
       
        
        contExt.caseInstance.SuppliedEmail = 'testmail@te.com';
        
        contExt.checkEmail();
        
       
        String testSubject = 'Test Subject';
        String testQuestion = 'Test Description';
        
        contExt.caseInstance.Subject = testSubject;
        contExt.caseInstance.Description = testQuestion;
        
        contExt.caseInstance.Category__c = 'test1,test2,test3';
        contExt.caseInstance.Country__c  = 'USA';
        insert contExt.caseInstance;
        
        contExt.attachment.Description = testQuestion;
        contExt.attachment.name = testQuestion;
        contExt.fileBody = blob.valueOf('Test Attachment Body.');
        contExt.upload();           
        contExt.saveCase();
        
        
        contExt.successfulString = 'true';
        contExt.init();
       
        
        
        Test.stopTest();
    }
    
}