/**********************************************************************************************************************************************
*******
Name: MassCloseCase_CCPController 
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is used to close case .
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  11/14/2013    Class                       
***********************************************************************************************************************************************
*****/
public class MassCloseCase_CCPController {
    public string vCsurl;
    public List<string> vCaseids;
    public List<Case> vCsLst=  new List<case>();
    public String Status {  set; get;}
    public String Reason {  set; get;}
    public case c1{set;get;}
    public String c { get; set; }

    public MassCloseCase_CCPController (){
        c1=new case();
        vCsurl = ApexPages.CurrentPage().getParameters().get('ids');
           if(vCsurl !=null){
              vCaseids= vCsurl.split(',');
          vCsLst = [select id,status,Inquiry_Type__c,Close_Date_Comments__c,Other_Inquiry_Type__c from case where id in :vCaseids];
          } 

    }
    public PageReference Canclefields() {
        PageReference vCancel=new PageReference ('/500?isdtp=nv');
        return vCancel;
    }


    public PageReference Savefields() {
    try{
        PageReference vSave=new PageReference ('/500?isdtp=nv');
       for (Case c :vCsLst){
           c.status = Status;
           if(c1.Inquiry_Type__c==null)
           {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter Inquiry Type'));  
                return null; 
           }
              if(c1.Inquiry_Type__c=='Other' && c1.Other_Inquiry_Type__c==null )
           {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select Other Inquiry type'));  
                return null; 
           }
           if(c1.Close_Date_Comments__c==null)
           {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please  enter Close Date Comments'));  
                return null; 
           }
          
           
           c.Inquiry_Type__c= c1.Inquiry_Type__c;
           c.Close_Date_Comments__c=c1.Close_Date_Comments__c;
           c.Other_Inquiry_Type__c = c1.Other_Inquiry_Type__c;
       }
       update vCsLst;
       return vSave;
       }catch(Exception e){
               CCP_Exception_Util.CCP_Exception_Mail(e);
               return null;
       }
    }
}