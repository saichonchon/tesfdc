@RestResource(urlMapping='/QuoteData/*')
global with sharing class RESTQuoteController {

    @HttpGet
    global static List<Energy_Quote_Line_Item__c> getQuoteDetails() {
        String qstatus = RestContext.request.params.get('qstatus');
        if(qstatus != '' || qstatus  != null){
            //List<Quotelineitem> qts =  [select Qad_Product_Number__c,Quantity,LineNumber, Sold_Price__c,quote.QuoteNumber,quote.name,quote.Account_Number__c,id,quoteid,Catalog_Number__c,quote.Comments__c,Comment__c,quote.Create_By_Email__c,quote.Valid_Days__c,quote.te_sales_office__c from Quotelineitem where (quote.Status =:qstatus and  part_number__c != '')];
            //List<Energy_Quote_Line_Item__c> qts =  [select Qad_Product_Number__c,Quantity__c,LineNumber__c, Sold_Price__c,Energy_Quote_Name__r.QuoteNumber__c,Energy_Quote_Name__r.name,
            List<Energy_Quote_Line_Item__c> qts =  [select Qad_Product_Number__c,Quantity__c,LineNumber__c,unitPrice__c,Energy_Quote_Name__r.Quote_Number__c,Energy_Quote_Name__r.name,
                                                            Energy_Quote_Name__r.Account_Number__c,id,Energy_Quote_Name__c,Catalog_Number__c,Energy_Quote_Name__r.Comments__c,Comment__c,
                                                            Energy_Quote_Name__r.Create_By_Email__c,Energy_Quote_Name__r.Valid_Days__c,Energy_Quote_Name__r.te_sales_office__c 
                                                            from Energy_Quote_Line_Item__c 
                                                            where (Energy_Quote_Name__r.Approval_Status__c =:qstatus and  Part_Number__c != '')
                                                            //Added by Yiming Shen <yiming.shen@capgemini.com> at 2017-11-30
                                                            AND Energy_Quote_Name__r.Opportunity_Name__r.ERP_For_Pricing__c = 'MFGPRO'
                                                            //End
                                                   ];
            return qts;
        }
        else return null; 
    }


    @HttpPost
    global static String updateQuoteStatus(){ 
        RestRequest req = RestContext.request;
        Blob body = req.requestBody;
        String saldata=XMLParser(body.toString()); 
        
        return saldata;
    }
    
    public static String XMLParser(String strXml){
        Dom.Document doc = new Dom.Document();
        try {
            doc.load(strXml); // Load XML
            Dom.XMLNode quotes = doc.getRootElement();
            return QuoteUpdates(quotes);
        }catch(XMLException e){ // invalid XML
        	ErrorLogging.Log(e);
            return 'XML is not correct =>' +' '+ e.getMessage();
        }
    }
    
    
    public static String QuoteUpdates(DOM.XMLNode quotes){
        Map<Id, String> qtIdUpList = new Map<Id, String>(); 
        for(Dom.XMLNode child : quotes.getChildren()) {
            if(child.getName() == 'quote'){
                Id quoteid =  Id.valueOf(child.getAttribute('id',null));
                String quoteStatus =  child.getText();
                qtIdUpList.put(quoteid,quoteStatus);
                //System.debug('QUOTE ID and QOUTE  STATUS' + quoteId + ' '+ quoteStatus);
            }
        }
        //List<Quote> qts = [select id,status from quote where id in :qtIdUpList.keySet()];
        List<Energy_Quote__c> qts = [select id,Approval_Status__c from Energy_Quote__c where id in :qtIdUpList.keySet()];
        if(qts.size() > 0) {
            for(Energy_Quote__c qt: qts){
                qt.Approval_Status__c = qtIdUpList.get(qt.id);
            } 
            try{
            	update qts;
            }catch(Exception e){
            	ErrorLogging.Log(e);
            }
            return 'Successfully Updated';
        } else {
            return 'FAILED to process the quote';
        } 
        //return 'UNDER CONSTRUCTION';
    }
    
    
}