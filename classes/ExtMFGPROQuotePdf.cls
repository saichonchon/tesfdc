/*------------------------------------------------------------
Author:        Yuan Yao <yuan.yao@capgemini.com>
Description:   Controller class to load quote and quote line item records in MFGPROQuotePdf.page.
               The user story number is W-00130.
Inputs:        "stdCtrl" - ApexPages.standardController of Energy_Quote__c
Test Class:    ExtMFGPROQuotePdf_Test
History
2017-09-18     Yuan Yao <yuan.yao@capgemini.com> Created
------------------------------------------------------------*/
public class ExtMFGPROQuotePdf {
    //public List<Energy_Quote_Line_Item__c> quolineitem { get; set; }
    public list<LineItem> quolineitem { get; set; }
    public Energy_Quote__c QuoteDetails{get;set;} 
    Public User u{get;set;}
    ID i;       
    public String quoteLanguage{get;set;}
    public String acctSoldToBillingCity {get; set;}
    public String endCustomerBillingCity {get; set;}
    
    public ExtMFGPROQuotePdf(ApexPages.StandardController controller) {
        
        
        i=apexpages.currentpage().getparameters().get('id'); 
        //qd= new List<Quotelineitem> ();
        QuoteDetails = [select CreatedById,id,CreatedDate ,Quote_Number__c,Name,CreatedBy.name,CreatedBy.phone,CreatedBy.Email, contact__r.Name,Comments__c,
                        Account_name__r.name,Account_name__r.billingStreet,Account_name__r.billingCity,Account_name__r.billingcountry,
                        Account_name__r.billingState, Account_name__r.BillingPostalCode, Account_name__r.AccountNumber,
                        
                        //modified by Tangyong Li 2018-02-08 by email Let's do some REAL coding again! 1)d)
                        //Account_name__r.Payment_terms_Desc__c,Override_Payment_Terms_Description__c,
                        Account_name__r.Payment_terms_Desc__c, Language__c,
                        End_Customer__r.Name,End_Customer__r.billingcountry,Opportunity_Name__r.Name,
                        End_Customer__r.billingStreet,End_Customer__r.billingCity, End_Customer__r.billingState,
                        End_Customer__r.BillingPostalCode,contact__r.phone,contact__r.Email,TotalPrice__c,Email__c,Phone__c
                        from Energy_Quote__c where id=:i];
        //Modified by mei xing for Functional Testing Issues - 5/1 point 8 2018/5/2
        this.quoteLanguage = 'en';
        if(QuoteDetails.Language__c == 'English'){
            quoteLanguage = 'en';
        }else if(QuoteDetails.Language__c == 'Spanish'){
            quoteLanguage = 'es';
        }else if(QuoteDetails.Language__c == 'Portuguese'){
            quoteLanguage = 'pt-br';
        }
        
        u = new User();
        u=[SELECT Id, Name, Email, Phone FROM User where id =: QuoteDetails.CreatedById]; 
        
        /*
        quolineitem=[select id,Name,Comment__c,Part_Number__c ,Catalog_Number__c, Quantity__c,Part__r.RPN_Part__c,Part__r.RPN_Description__c
                     ,Opportunity_Part__r.NDR_Customer_Requested_Price_UOM__c,Seq_No__c,LineNumber__c,
                     Max_Qty_in_Standard_lead_time__c,Description__c,Lead_Time__c,UnitPrice__c,
                     Sold_Price__c,TotalPrice__c,Part__c,Part__r.name, Quote_Number__c,Primary_Pack_Quantity__c,
                     Energy_Quote_Name__r.Quote_Number__c
                     from Energy_Quote_Line_Item__c where Energy_Quote_Name__c=:i 
                     order by Seq_No__c asc]; 
        */
        quolineitem = new list<LineItem>();
        for(Energy_Quote_Line_Item__c item : [select id,Name,Comment__c,Part_Number__c ,Catalog_Number__c, Quantity__c,Part__r.RPN_Part__c,Part__r.RPN_Description__c
						                     ,Opportunity_Part__r.NDR_Customer_Requested_Price_UOM__c,Seq_No__c,LineNumber__c,
						                     Max_Qty_in_Standard_lead_time__c,Description__c,Lead_Time__c,UnitPrice__c,
						                     Sold_Price__c,TotalPrice__c,Part__c,Part__r.name, Quote_Number__c,Primary_Pack_Quantity__c,
						                     Energy_Quote_Name__r.Quote_Number__c
						                     from Energy_Quote_Line_Item__c where Energy_Quote_Name__c=:i 
						                     order by Seq_No__c asc]) {
        	LineItem lineItem = new LineItem();
        	lineItem.quoteLineItem = item;
        	lineItem.quoteNum = item.Energy_Quote_Name__r.Quote_Number__c;
        	if(lineItem.quoteNum != null && !lineItem.quoteNum.startsWith('RS')) {
        		lineItem.quoteNum = ('RS' + lineItem.quoteNum);
        	}
        	quolineitem.add(lineItem);
        } 
        
        //Modified by mei xing for Functional Testing Issues - 5/1 point 6 2018/5/2
        acctSoldToBillingCity = '';
        acctSoldToBillingCity += ((QuoteDetails.Account_name__c == null 
        						|| QuoteDetails.Account_name__r.billingCity == null
        						|| QuoteDetails.Account_name__r.billingCity == '')?'':QuoteDetails.Account_name__r.billingCity+',');
        
        endCustomerBillingCity = '';
        endCustomerBillingCity += ((QuoteDetails.End_Customer__c == null
        						|| QuoteDetails.End_Customer__r.billingCity == null
        						|| QuoteDetails.End_Customer__r.billingCity == '')?'':QuoteDetails.End_Customer__r.billingCity+',');
    } 
    
    public class LineItem {
    	public Energy_Quote_Line_Item__c quoteLineItem{get; set;}
    	public String quoteNum{get; set;}
    }
    
}