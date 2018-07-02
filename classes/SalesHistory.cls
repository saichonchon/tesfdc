/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   Controller class to show Energy_Quote_Line_Item__c data SalesHistory.page.
			   The user story number is W-00018.
Inputs:        
Test Class:    SalesHistoryTest
History
2017-08-11 	   Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
public class SalesHistory {
	
	public list<Energy_Quote_Line_Item__c> list_energyQuoteLineItems {get; set;}
	public list<Energy_Quote_Line_Item__c> list_energyQuoteLineItems1 {get; set;}
	public String partNum {get; set;}
	public Opportunity oppy {get; set;}
	id pid,Accountid;
	
	/*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   The contsructor
	Inputs:        
	Returns:       
	History
	2017-08-11 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    public SalesHistory() {
	    String pid =ApexPages.currentPage().getParameters().get('id');
	    String oppyId =ApexPages.currentPage().getParameters().get('oppyId'); 
	    partNum = [SELECT Id, Name FROM Part__c WHERE Id =: pid].Name;
	    oppy = [SELECT Id, AccountId, Account.Name FROM Opportunity WHERE Id =: oppyId];
	    
	    list_energyQuoteLineItems = [SELECT Id, Energy_Quote_Name__c, Energy_Quote_Name__r.Quote_Number__c, Opportunity_Part__c, Part__r.Name, 
	    									Opportunity_Part__r.Status__c, Energy_Quote_Name__r.Account_Name__r.Name, Energy_Quote_Name__r.Account_Name__r.Company_Number__c, 
	    									Quantity__c, UnitPrice__c, ServiceDate__c 
	    							 FROM Energy_Quote_Line_Item__c 
	    							 //WHERE Part__c =: pid AND Energy_Quote_Name__r.Opportunity_Name__c =: oppyId AND Opportunity_Part__r.Status__c != 'No Bid'];
	    							 where Part__c =: pid and Energy_Quote_Name__r.Opportunity_Name__r.AccountId =: oppy.AccountId and Energy_Quote_Name__r.Expiration_Date__c >= today];
	    							 
	    list_energyQuoteLineItems1 = [SELECT Id, Energy_Quote_Name__c, Energy_Quote_Name__r.Quote_Number__c, Opportunity_Part__c, Part__r.Name, 
	    									Opportunity_Part__r.Status__c, Energy_Quote_Name__r.Account_Name__r.Name, Energy_Quote_Name__r.Account_Name__r.Company_Number__c, 
	    									Quantity__c, UnitPrice__c, ServiceDate__c 
	    							 FROM Energy_Quote_Line_Item__c 
	    							 //WHERE Part__c =: pid AND Energy_Quote_Name__r.Opportunity_Name__c !=: oppyId AND Opportunity_Part__r.Status__c != 'No Bid'];
	    							 WHERE Part__c =: pid AND Energy_Quote_Name__r.Opportunity_Name__r.AccountId !=: oppy.AccountId AND Opportunity_Part__r.Status__c != 'No Bid'];
	    
    }
}