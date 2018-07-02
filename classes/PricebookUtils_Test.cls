@isTest
Private class PricebookUtils_Test {
    static testMethod void testPricebookUtils() {
        Global_Account__c GlAcc =  new Global_Account__c(Name='Test',Description__c='test',Pricebook_Id__c=test.getStandardPricebookId(),GAM_Code__c='0123456789');
        insert GlAcc;
        
        account a = clstesthelp.createTestAccounts();
        a.AccountNumber ='0000:00000000';
        a.WWCORPACCT__c ='00000000';
        a.BillingCountry='CN';
        a.Global_Account__c = GlAcc.Id;
        //a.name ='Test Account One';
        a.Account_Manager__c = UserInfo.getUserId();
        a.OwnerId = UserInfo.getUserId();
        
        Market__c mrkt = new Market__c(Name='Test',Pricebook_Id__c=test.getStandardPricebookId());
        insert mrkt; 
        
        test.startTest();
        
        PricebookUtils.GetPricebooksForAccounts(new List<Id>{a.id});
        PricebookUtils.GetPricebooksForMarkets(new List<Id>{mrkt.id});
        try
        {
            PricebookUtils.GetPricebooksForAccounts(null);
        	
        }
        catch(exception ex)
        {
            system.debug('Error because of seealldata=false' + ex);
        }
        try
        {
            PricebookUtils.GetStandardPriceBookId();
        }
        catch(exception ex)
        {
            system.debug('Error because of seealldata=false' + ex);
        }
        try
        {
            PricebookUtils.GetPricebooksForMarkets(null);
        }
        catch(exception ex)
        {
            system.debug('Error because of seealldata=false' + ex);
        }
        test.stopTest();
    }

}