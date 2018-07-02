/*------------------------------------------------------------
Author:        Yuan Yao <yuan.yao@capgemini.com>
Description:   Controller class to load quote and quote line item records in AMPICSQuotePdf.page.
			   The user story number is W-00130.
Inputs:        "stdCtrl" - ApexPages.standardController of Energy_Quote__c
Test Class:    ExtAMPICSQuotePdf_Test
History
2017-09-18 	   Yuan Yao <yuan.yao@capgemini.com> Created
------------------------------------------------------------*/
public class ExtAMPICSQuotePdf {
	
	ID i;
	private Integer renderclause=0; 
	private Integer render_Insurance=0;
	public User currentUser {get;set;}
    public Opportunity oppPLDesc {get;set;}
    public Energy_Quote__c energyQuote2getOpp {get;set;}
	public Energy_Quote__c energyQuote {get;set;}
	public boolean ApproveStatus{get;set;}
	public String uname{get;set;}
	public list<Energy_Quote_Line_Item__c> list_energyQuoteLineItem {get;set;}
    List<ANZ_Clause__c> anzClause;
    List<Opportunitylineitem> opplineitem;
    public Decimal totalExcludGST {get; set;}
    public Decimal totalExcludGSTUSD {get; set;}
    public Decimal totalExcludGST_10 {get; set;}
    public Decimal totalExcludGST_10_USD {get; set;}
    public Decimal totalIncludGST {get; set;}
    public Decimal totalIncludGSTUSD {get; set;}
  
	public List<String> months=new List<String>{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
  
	public ExtAMPICSQuotePdf(ApexPages.StandardController controller) {
        System.debug('in contruct');
		i=controller.getid();
			currentUser = [select id,Phone,Email,PostalCode,Country,City,State,Street,Name,Division,Title from User where id =:userInfo.getUserID()];
			uname = currentUser.Name;
			list_energyQuoteLineItem = [SELECT Id, Name, Quantity__c,Seq_No__c,Opportunity_Part__r.Customer_Part_Number__c,Opportunity_Part__r.Part_Name__c,Opportunity_Part__r.Name,
                                        Part_Number__c, UnitPrice__c, Price_List__c, Product2__r.name, Description__c,LineNumber__c,Part__r.Name,
										TotalPrice__c, Opportunity_Part__r.Ex_Stock__c,Part__r.Proposal_Part__c,Part__r.Description__c,
                                        Opportunity_Part__r.Reason_Lost_Comments__c,ANZ_Item_Id__c,Deliver_Work_Weeks__c 
                                        FROM Energy_Quote_Line_Item__c 
										WHERE Energy_Quote_Name__c =: i
                                        Order by Seq_No__c asc];
            energyQuote =(Energy_Quote__c)controller.getRecord();
        try{
            energyQuote2getOpp = [SELECT Id, Name, Opportunity_Name__c,Actual_Total_Price__c,currencyIsoCode FROM Energy_Quote__c Where Id =: i];
            oppPLDesc = [select id,Amount,currencyIsoCode,Approved__c,TE_Reference_Number__c ,Product_Line_Description__c,Air_Freight_Cost__c,Customer_Reference_Number__c,Days_prices_valid__c,Sales_Engineer__c,Internal_Sales_Officer__c,Date_Quoted__c from Opportunity where id =: energyQuote2getOpp.Opportunity_Name__c];
        	totalExcludGST = energyQuote2getOpp.Actual_Total_Price__c;
            totalExcludGSTUSD = (totalExcludGST == null?0:ClsAPLForecastUtil.transformIsoCode(totalExcludGST,energyQuote2getOpp.currencyIsoCode,'USD'));
    		totalExcludGST = (totalExcludGST == null?0:totalExcludGST);
            totalExcludGST = totalExcludGST.setScale(2);
            totalExcludGSTUSD = totalExcludGSTUSD.setScale(2);
            
            totalExcludGST_10 = (totalExcludGST*0.1).setScale(2);
            totalExcludGST_10_USD = ClsAPLForecastUtil.transformIsoCode(totalExcludGST_10,energyQuote2getOpp.currencyIsoCode,'USD').setScale(2);
            
            totalIncludGST = (totalExcludGST + totalExcludGST_10).setScale(2);
            totalIncludGSTUSD = ClsAPLForecastUtil.transformIsoCode(totalIncludGST,energyQuote2getOpp.currencyIsoCode,'USD').setScale(2);
        }catch(Exception e){
            //ErrorLogging.Log(e);
            String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        }
        if(oppPLDesc.Approved__c==false)
            ApproveStatus=true;
        /*
        String s1 = oppPLDesc.Customer_Reference_Number__c;
        String s2 = oppPLDesc.Days_prices_valid__c;
        String s3 = oppPLDesc.Sales_Engineer__c;
        String s4 = String.valueOf(oppPLDesc.Air_Freight_Cost__c);
        String s5 = oppPLDesc.Internal_Sales_Officer__c;     
        String s6 = currentUser.Name;
        String s7 = currentUser.Phone;
        String s8 = currentUser.Email;
        */
        String s1 = (oppPLDesc.Customer_Reference_Number__c == null ? '' : oppPLDesc.Customer_Reference_Number__c);
        String s2 = (oppPLDesc.Days_prices_valid__c == null ? '' : oppPLDesc.Days_prices_valid__c);
        String s3 = (oppPLDesc.Sales_Engineer__c == null ? '' : oppPLDesc.Sales_Engineer__c);
        String s4 = (oppPLDesc.Air_Freight_Cost__c == null ? '' : String.valueOf(oppPLDesc.Air_Freight_Cost__c));
        String s5 = (oppPLDesc.Internal_Sales_Officer__c == null ? '' : oppPLDesc.Internal_Sales_Officer__c);
        String s6 = (currentUser.Name == null ? '' : currentUser.Name);
        String s7 = (currentUser.Phone == null ? '' : currentUser.Phone);
        String s8 = (currentUser.Email == null ? '' : currentUser.Email);
        
        try{
            anzClause=[select Name,Insurance__c,Company_Name__c,Sequence_No__c from ANZ_Clause__c where Opportunity__c=: oppPLDesc.Id ORDER BY Sequence_No__c ASC NULLS FIRST];
            //anzClause.sort("Sequence_No__c");
            for(ANZ_Clause__c a:anzClause){ 
               /*
            	String s = a.Company_Name__c;
               a.Insurance__c = a.Insurance__c.replaceAll('Fetch Validity Period',s2);
               a.Insurance__c = a.Insurance__c.replaceAll('Fetch Account',s);     
               a.Insurance__c = a.Insurance__c.replaceAll('Fetch CRef No',s1);          
               a.Insurance__c = a.Insurance__c.replaceAll('Fetch SE',s3);
               a.Insurance__c = a.Insurance__c.replaceAll('Fetch ISO',s5);  
               a.Insurance__c = a.Insurance__c.replaceAll('Fetch CurrentUsername',s6);       
               a.Insurance__c = a.Insurance__c.replaceAll('Not Applicable',s4); 
               a.Insurance__c = a.Insurance__c.replaceAll('Fetch UserEmail',s8); 
               a.Insurance__c = a.Insurance__c.replaceAll('Fetch UserPhone',s7);
               */
               String s = (a.Company_Name__c == null ? '' : a.Company_Name__c);
               a.Insurance__c = (s2 == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Fetch Validity Period',s2));
               a.Insurance__c = (s == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Fetch Account',s));
               a.Insurance__c = (s1 == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Fetch CRef No',s1));
               a.Insurance__c = (s3 == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Fetch SE',s3));
               a.Insurance__c = (s5 == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Fetch ISO',s5));
               a.Insurance__c = (s6 == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Fetch CurrentUsername',s6));
               a.Insurance__c = (s4 == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Not Applicable',s4));
               a.Insurance__c = (s8 == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Fetch UserEmail',s8));
               a.Insurance__c = (s7 == '' ? a.Insurance__c : a.Insurance__c.replaceAll('Fetch UserPhone',s7));
               if(a.Insurance__c != null){
                   a.Insurance__c = a.Insurance__c.replace('•', '<br/> • ');
                   a.Insurance__c = a.Insurance__c.replace('', '');
               }
          	}   
        }catch(Exception e){
        	system.debug('Exception::'+ e.getStackTraceString()+'::'+e.getMessage());
            //ErrorLogging.Log(e);
            String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        }
    }
    
    public List<ANZ_Clause__c> getANZClause() {
        return anzclause;     
    }
    
	/*------------------------------------------------------------
	Author:        Yuan Yao <yuan.yao@capgemini.com>
	Description:   Display today's date in teh format--day,Month Name,Year(ex: 26 april,2012)
	Inputs:        
	Returns:       formateddate
	History
	2017-09-18 	   Yuan Yao <yuan.yao@capgemini.com> created
	------------------------------------------------------------*/
	public String getDateformat() {
		date myDate = date.today();
		String str= mydate.format();
		Integer month=mydate.month();
		Integer todays_day=mydate.day();
		Integer curyear=mydate.year();
		String monthstring=null;   
		String formateddate=null;      
        monthstring=months[month-1];
        
		formateddate=todays_day+' '+monthstring+''+', '+curyear;
		System.debug('Today---Date-->'+mydate);
		return formateddate;
	}
	//  Display today's date in teh format--day,Month Name,Year(ex: 26 april,2012)    
}