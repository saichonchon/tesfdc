Public Class FundClaim {
    id Claimid;
    public list<SFDC_MDF_Claim__c> ClaimDetails{get;set;}
     //public datetime dateformat1{get;set;}
     public List<String> months=new List<String>{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
   public FundClaim(){
 
   Claimid = apexpages.currentpage().getparameters().get('id');
   ClaimDetails = [Select id,Name,Remit_to__r.Name,Amount__c,Owner.Name,Remit_to__r.BillingStreet,Remit_to__r.BillingPostalCode,
   Remit_to__r.BillingCity,Remit_to__r.BillingState,Remit_to__r.BillingCountry,Claim_Details__c,Owner_City__c,Owner_Country__c,
   Claim_Paid_Date__c,Remit_to__r.CUST__c,Remit_to_Attention__c,Final_Approver__c,Final_Approved_Date__c,Initial_Approver__c,Intial_Approved_Date__c from SFDC_MDF_Claim__c where id=:Claimid];
   }
  
  public String anzDateFormat(Datetime myDate,Datetime myDate1){
    
      if(myDate!=null)
       {        string test= 'P.M';
        string test1= 'A.M';
              String str= mydate.format();
              Integer month=mydate.month();
              Integer todays_day=mydate.day();
              Integer curyear=mydate.year();
              integer curhours=mydate.hour();
              Integer curmins=mydate.minute();
              string curgm=null;
             String monthstring=null;   
             String formateddate=null;      
             monthstring= months[month-1];
             if( curhours>12){
             curgm=test;
             }else {
             curgm=test1;
             }
             formateddate=todays_day+' '+monthstring+''+' '+curyear+''+' ' + curhours+':'+curmins+' '+' '+ curgm;
              System.debug('Today---Date-->'+mydate);
             
           return formateddate;
        }
        else
        {
             return null;
        }
  } 
   public String getDateformat() 
  {
   datetime myDate = ClaimDetails[0].Intial_Approved_Date__c;
 
   return anzDateFormat(myDate,null);
  }
  public String getDateformat1() 
  {
   
   datetime myDate1 = ClaimDetails[0].Final_Approved_Date__c;
   return anzDateFormat(myDate1,null);
  }
  
}