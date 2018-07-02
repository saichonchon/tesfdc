/**********************************************************************************************************************************************
*******
Name: OEMDetailcls
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This controller prepopulate Fiscal Year and Fiscal Month from Account record.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0      Padmaja       15/01/2014    Controller                       
***********************************************************************************************************************************************
*****/


public with sharing class OEMDetailcls {

    public id idval{get;set;}
    public string fiscalyear{get;set;}
    public OEM_Details__c oemdetails{get;set;}
    public string mon{get;set;}
    public String ErrorMessage{get;set;}
    public Boolean DisplayMessage{get;set;}
    
    //constructor to get the current record id 
    public OEMDetailcls(){
    idval=ApexPages.CurrentPage().getParameters().get('idval');
        
        
    DisplayMessage=FALSE;
    // instantiate new OEM Deatils Object 
    oemdetails=new OEM_Details__c();
    // assign fiscal Year to the current year
    fiscalyear=string.valueof(System.today().year());
    // assign month  to the current month  of current year 
    mon=string.valueof(System.today().month());
    for(integer i=1;i <= 9; i++){
    if(mon == string.valueof(i)){
    mon=string.valueof(i+3);
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    i=10;    
    }
    }       
    
   /* if(mon == '1'){
    mon='04';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon == '2'){
    mon='05';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon == '3'){
    mon='06';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    
    }
    else if(mon == '4'){
    mon='07';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon == '5'){
    mon='08';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon == '6'){
    mon='09';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon == '7'){
    mon='10';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon == '8'){
    mon='11';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon == '9'){
    mon='12';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }*/
    if(mon == '10'){
    mon='1';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon == '11'){
    mon='2';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    }
    else if(mon =='3'){
    mon='3';
    oemdetails=new OEM_Details__c(OEM__c=idval,Fiscal_Year__c = fiscalyear,Fiscal_Month__c = mon);
    
    }
    
 }
    //method to redirect the user to the current page 
    public PageReference canceloemdetail() {
        pagereference ref=new pagereference('/'+idval);
        return ref;
    }
    
    /*method to insert the Oem Detail Record into database
       and to  redirect the user to the current page */
        public PageReference saveoemdetail() {
        try{    
            system.debug('-----------------------'+oemdetails.Cutoff_Date__c);
            insert oemdetails;
            pagereference ref=new pagereference('/'+idval);
            ref.setredirect(true);        
            return ref;
        }
        Catch(Exception ex){
            DisplayMessage=TRUE;
            System.debug('************error message**************'+ex.getMessage());        
            //ErrorMessage = ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,''));
            ErrorMessage = ex.getDmlMessage(0);
        }
        return null;    
    }
}