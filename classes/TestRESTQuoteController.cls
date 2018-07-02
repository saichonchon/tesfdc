@isTest(SeeAllData=false)
public class TestRESTQuoteController{
	@testSetup static void createConfig(){
		ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        ClsTestCustomSettingHelper.getQuoteValiditySetting();
        ClsTestCustomSettingHelper.getQuoteExpirationSetting();
        ClsTestCustomSettingHelper.getADMTerritoryCode();
        ClsTestHelp.createTestOPTG4();
        ClsTestHelp.createTestOrgWideSettings1();
	}
	
     static testmethod void testQuoteList() {
       
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/QuoteData/';
        
        RestContext.request.addParameter('qstatus', 'Approved');        
        List<Energy_Quote_Line_Item__c> output =RESTQuoteController.getQuoteDetails();        
    }
     
    static testmethod void testQuoteList2() {
       
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/QuoteData/';
        
        RestContext.request.addParameter('qstatus', '');        
        List<Energy_Quote_Line_Item__c> output1 =RESTQuoteController.getQuoteDetails();  
    }
    
     public static testMethod void testUpdatedQuotes() {
         ClsTestCustomSettingHelper.getOrgWideSettings();
     	Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Name = 'testOppy2';
        oppy.RecordTypeId = ClsTestHelp.createTestRecordType32().Id;
        oppy.Probability__c = '30';
        insert oppy;
		Energy_Quote__c quoteItem = new Energy_Quote__c();
		quoteItem.Opportunity_Name__c = oppy.Id;
		insert quoteItem;
	     List<Energy_Quote__c> qts = [select id,Approval_Status__c from Energy_Quote__c limit 2];
	     if(qts.size() >  0){     
	         String quotes = '<?xml version="1.0"?>'
	                         +'<quotes>';                                   
	         for(Energy_Quote__c q:qts)
	             quotes+= '<quote id="' + String.valueOf(q.id) + '">Approved</quote>';            
	        
	         quotes+= '</quotes>';
	         System.RestContext.request = new RestRequest();           
	         RestContext.request.requestURI = '/QuoteData/';
	         RestContext.request.httpMethod = 'POST';
	         RestContext.request.requestBody = Blob.valueOf(quotes);
	         String response = RESTQuoteController.updateQuoteStatus();
	     }    
     }
     
     public static testMethod void testUpdatedQuotes2() {
	         ClsTestCustomSettingHelper.getOrgWideSettings();
	         String quotes = '<?xml version="1.0"?>'
	                         +'<quotes></quotes>';                                   
	         System.RestContext.request = new RestRequest();           
	         RestContext.request.requestURI = '/QuoteData/';
	         RestContext.request.httpMethod = 'POST';
	         RestContext.request.requestBody = Blob.valueOf(quotes);
	         String response = RESTQuoteController.updateQuoteStatus();
	         RestRequest req = RestContext.request;
	         Blob body = req.requestBody;
	         Dom.Document doc = new Dom.Document();
	         doc.load(body.toString());
	         Dom.XMLNode quo = doc.getRootElement();
	         RESTQuoteController.QuoteUpdates(quo);
     }
}