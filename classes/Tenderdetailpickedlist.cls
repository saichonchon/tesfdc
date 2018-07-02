/***********************************************************************************************************************
      Name : Tenderdetailpickedlist
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Apex page controller on "Tender_detail_newpage " 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    07/15/2013  Initial Development         1206                     
***********************************************************************************************************************/


public with sharing class Tenderdetailpickedlist
{
    Public String vTargetId{get;set;}
    public Tender__c vTenderObj{get;set;}
    public List<PageTable> PageTableList{get;set;}
    public List<Tender_Details__c> TenderDetailsList{get;set;}


    public Tenderdetailpickedlist(ApexPages.StandardController controller) {    
        system.debug('------------------------'+apexPages.currentPage().getUrl());    
        vTenderObj = (Tender__c )controller.getRecord();
        PageTableList=new List<PageTable>();
        TenderDetailsList = new List<Tender_Details__c>([Select Comment__c,  PAM__c, Product_Line__c,  TAM__c,PAM_Total__c,TAM_Total__c,
                                Total_PAM__c, Total_TAM__c, Tender__c, CurrencyIsoCode from Tender_Details__c where Tender__c =: apexpages.currentpage().getparameters().get('id')]);                                        
                                //Total_PAM__c, Total_TAM__c, Tender__c from Tender_Details__c where Comment__c !=null Limit 3]);
                                
        PageTable PT;          
        PageTable PTComm;                            
        for(Tender_Details__c T:TenderDetailsList){
            PT=new PageTable();
            PTComm=new PageTable();            
            PT.ProductLine=T.Product_Line__c;
            PT.PAMPC.PAM__c=T.PAM__c;
            PT.TAMPC.TAM__c=T.TAM__c;
            PT.TPAM.Total_PAM__c=T.Total_PAM__c;
            PT.TTAM.Total_TAM__c=T.Total_TAM__c;
            PT.PAMTot.PAM_Total__c=T.PAM_Total__c;
            PT.TAMTot.TAM_Total__c=T.TAM_Total__c;
            PT.TendDetail=T.Tender__c;
            PT.Detail=T.ID;     
            PT.ActionPlan=True;
            PT.strCurrency = T.CurrencyIsoCode;       
            PTComm.ProductLine=t.comment__c;
            PageTableList.add(PT);
            PTComm.ActionPlan=False;
            PageTableList.add(PTComm);
      }
        
        for(Tender_Details__c T:TenderDetailsList){
            /*if(t.comment__c==null)
            {            
            T.Comment__c='Enter comment';
            } */
        }
        //vTargetId = '';
    }

    public PageReference redirect() { 
        //system.debug('***vTargetId****'+vTargetId); 
        String setURl = '/'+vTargetId+'/e?retURL=%2F'+vTenderObj.Id;
        system.debug('****************************'+apexpages.currentpage().getparameters().get('URL')); 
        PageReference page =new PageReference(setURl );
        return page ;        
    }
    
    public PageReference cancle() {
        PageReference p=new PageReference('/'+apexpages.currentpage().getparameters().get('retURL'));
       
        return null;
    }

    public PageReference save() {  
        PageReference p=new PageReference('/'+apexpages.currentpage().getparameters().get('retURL'));
        return null;        
    }
    public class PageTable{
        public string ProductLine{get;set;}
        public Tender_Details__c PAMPC{get;set;}
        public Tender_Details__c TAMPC{get;set;}
        public Tender_Details__c TPAM{get;set;}
        public Tender_Details__c TTAM{get;set;}
        public Tender_Details__c PAMTot{get;set;}        
        public Tender_Details__c TAMTot{get;set;}
        public string Detail{get;set;}
        public Boolean ActionPlan{get;set;}
        public string TendDetail{get;set;}
        public string strCurrency {get;set;}    
        public PageTable(){
            PAMPC=new Tender_Details__c();
            TAMPC=new Tender_Details__c();
            TPAM=new Tender_Details__c();
            TTAM=new Tender_Details__c();
            PAMTot=new Tender_Details__c();
            TAMTot=new Tender_Details__c();
        }
    }
}