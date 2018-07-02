/**********************************************************************************************************************************************
*******
Name: MassCloseCaseVFController 
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
public class MassCloseCaseVFController {

    public String Internalcomments { get; set; }
    public string myurl;
    public List<string> vCaseids;
    public List<Case> vCsLst=  new List<case>();
    public String Status {  set; get;}
    public String Reason {  set; get;}
    public case c1{set;get;}
    public String c { get; set; }
    
    public MassCloseCaseVFController (){
        c1=new case();
        vCaseids = ApexPages.CurrentPage().getParameters().get('ids').split(',');
        if(vCaseids.size() > 0){
            vCsLst = [select id,status,reason from case where id in: vCaseids ];
        } 
    }
    
    public PageReference Canclefields() {
        PageReference vCancel=new PageReference ('/500?isdtp=nv');
        return vCancel;
    }
    

    public PageReference Savefields() {
        try{
        PageReference vSave=new PageReference ('/500?isdtp=nv');
        list<CaseComment> lstcom=new list<CaseComment>();
        for (Case c :vCsLst){
        c.status = Status;
        c.reason=c1.reason;
        CaseComment cc=new CaseComment();
        cc.CommentBody=internalcomments;
        cc.ParentId=c.id;
        lstcom.add(cc);
            if(c1.reason==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please enter a Reason'));  
                return null; 
            }  
        }
        
        update vCsLst;
        insert lstcom;
        return vSave;
        }catch(Exception e){
                CCP_Exception_Util.CCP_Exception_Mail(e);
                return null;
        }
    }
}