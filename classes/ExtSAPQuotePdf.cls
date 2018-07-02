/*------------------------------------------------------------
Author:        Yuan Yao <yuan.yao@capgemini.com>
Description:   Controller class to load quote and quote line item records in SAPQuotePdf.page.
               The user story number is W-00130.
Inputs:        "stdCtrl" - ApexPages.standardController of Energy_Quote__c
Test Class:    ExtSAPQuotePdf_Test
History
2017-09-18     Yuan Yao <yuan.yao@capgemini.com> Created
------------------------------------------------------------*/
public class ExtSAPQuotePdf {
    public List<Energy_Quote_Line_Item__c> quolineitem { get; set; }
    //public List<quotelineitem> allqli{get;set;}
    //public List<innerClass> allWrapperCls{get;set;}
    public Energy_Quote__c QuoteDetails{get;set;} 
    Public User u{get;set;}
    public String quoteLanguage{get;set;}
    ID i;
    public Datetime validityDateEnd{get;set;}
    public String validFrom {get;set;}
    public String acctSoldToBillingCity {get; set;}
    public String endCustomerBillingCity {get; set;}
   
    public ExtSAPQuotePdf(ApexPages.StandardController controller) {
        i=apexpages.currentpage().getparameters().get('id'); 
        QuoteDetails = [select CreatedById,id,CreatedDate ,Opportunity_Name__r.owner.name,Quote_Number__c,Name,CreatedBy.name,CreatedBy.phone,Quote_Type__c,
                            //modified by Tangyong Li 2018-02-08 by email Let's do some REAL coding again! 1)d)
                            //CreatedBy.Email, contact__r.Name,contact__r.email,contact__r.phone, Comments__c,Override_Incoterms_Details__c,Override_Payment_Terms_Description__c,
                            CreatedBy.Email, contact__r.Name,contact__r.email,contact__r.phone, Comments__c,Override_Incoterms_Details__c,
                            Account_name__r.name,Account_name__r.billingStreet,Account_name__r.billingCity,Account_name__r.billingcountry,
                            Account_name__r.billingState, Account_name__r.BillingPostalCode, Account_name__r.AccountNumber,
                            End_Customer__r.ShippingStreet,End_Customer__r.shippingCity, End_Customer__r.shippingState,End_Customer__r.Name,
                            End_Customer__r.ShippingPostalCode,End_Customer__r.AccountNumber,Valid_Days__c,Actual_Total_Price__c,CurrencyIsoCode,
                            Language__c, Valid_From__c,Account_Name__r.Incoterms_Details__c, Account_Name__r.Payment_terms_Desc__c,Header_Level_Comments__c,
                            End_Customer__r.billingStreet,End_Customer__r.billingCity,End_Customer__r.billingState,End_Customer__r.BillingPostalCode 
                            from Energy_Quote__c where id=:i];
        this.quoteLanguage = 'en';
        if(QuoteDetails.Language__c == 'English'){
            quoteLanguage = 'en';
        }else if(QuoteDetails.Language__c == 'Spanish'){
            quoteLanguage = 'es';
        }else if(QuoteDetails.Language__c == 'Portuguese'){
            quoteLanguage = 'pt-br';
        }
        System.debug('---quoteLanguage:::' + quoteLanguage);
        u = new User();
        u=[SELECT Id, Name, Email, Phone FROM User where id =: QuoteDetails.CreatedById]; 
        quolineitem=[select id,Name,Comment__c,Part_Number__c ,Catalog_Number__c,Unit_of_Measure__c,Country_of_Origin__c,
                     Description__c,NDR_Minimum_Order_Quantity__c,NDR_Unit_Package_Type__c,NDR_Delivery_Unit__c,NDR_Minimum_Delivery_Quantity__c,
                     UnitPrice__c,TotalPrice__c,Quantity__c,Opportunity_Part__r.NDR_Customer_Requested_Price_UOM__c,LineNumber__c,
                     Lead_time__c,Customer_Part_Number__c,Part__r.RPN_Part__c,Part__r.RPN_Description__c, Customer_Part_Number1__c,Customer_Part_Number1__r.Name,
                     NDR_Customer_Comments__c
                     from Energy_Quote_Line_Item__c where Energy_Quote_Name__c=:i ];    
            
        validFrom = QuoteDetails.CreatedDate.format('MM/dd/yyyy', String.valueOf(UserInfo.getTimeZone()));
        system.debug('valid from:::   ' + QuoteDetails.Valid_From__c);
        system.debug('valid from:::   ' + QuoteDetails.Valid_Days__c);
        if(QuoteDetails.Valid_Days__c != null && QuoteDetails.Valid_From__c != null){
            validityDateEnd = QuoteDetails.Valid_From__c.addDays(Integer.valueOf(QuoteDetails.Valid_Days__c));
        }
        //Modified by mei xing for Functional Testing Issues - 5/1 point 6 2018/5/2
        acctSoldToBillingCity = '';
        acctSoldToBillingCity += ((QuoteDetails.Account_name__c == null 
        						|| QuoteDetails.Account_name__r.billingCity == null
        						|| QuoteDetails.Account_name__r.billingCity == '')?'':QuoteDetails.Account_name__r.billingCity+',');
        
        endCustomerBillingCity = '';
        endCustomerBillingCity +=((QuoteDetails.End_Customer__c == null
        						|| QuoteDetails.End_Customer__r.billingCity == null
        						|| QuoteDetails.End_Customer__r.billingCity == '')?'':QuoteDetails.End_Customer__r.billingCity+',');
    }
}