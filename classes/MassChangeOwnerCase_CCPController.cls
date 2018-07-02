/**********************************************************************************************************************************************
*******
Name: MassChangeOwnerCase_CCPController 
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This Class will help to change customer care multiple case records owners in a same time.
         This controller is used by 'MassChangeOwnerCaseVF' page
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Ramakrishna Singara   04/23/2014    Controller                       
***********************************************************************************************************************************************
 2.0   Ramakrishna Singara   05/26/2014    Controller     
       Purpose: This Modification helps to change method name with return Null and Closing the visualforce tab in service console and included exception handling.               
***********************************************************************************************************************************************
*****/
public class MassChangeOwnerCase_CCPController { 
    
    // Variables Declaration
    public string vCsurl;
    public List<string> vCaseids;
    public static List<string> vCaseidss;
    
    public List<Case> vCsLst=  new List<case>();
    public static List<Case> vCsLst2=  new List<case>();
    
    public case cRec{set;get;} 
    
    // New Variables By Ramakrishna Singara Start (05/26/2014)
    public Boolean RefreshTag{get;set;}
    public Boolean hiddeninput{get;set;}
    // New Variables By Ramakrishna Singara End (05/26/2014)
    
    // Constructor 
    public MassChangeOwnerCase_CCPController(){ 
        cRec=new case();
        vCsurl = ApexPages.CurrentPage().getParameters().get('ids');  
        if(vCsurl !=null){
            vCaseids= vCsurl.split(',');            
            vCsLst = [select id,OwnerId,recordTypeId, status,Inquiry_Type__c,Close_Date_Comments__c,Other_Inquiry_Type__c from case where id in :vCaseids];            
        }      
    }
    
    
    // Save Method helps to update the case records with provided data in Visualforce Page and close the tab
    public PageReference Save() {  
        hiddeninput=false;        
        for (Case c :vCsLst){              
            if(cRec.OwnerId==null){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Label.CC_MassChangeOwnerCase_Error)); 
                hiddeninput=false;
                return null; 
            } 
            else{
                c.OwnerId = cRec.OwnerId;
                hiddeninput=true;
            }
            if(cRec.Inquiry_Type__c=='Other' && cRec.Other_Inquiry_Type__c==null ){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,Label.CC_MassChangeOwnerCase_Warning));  
                hiddeninput=false;
                return null; 
            }
            else{
                c.Inquiry_Type__c= cRec.Inquiry_Type__c;            
                c.Other_Inquiry_Type__c = cRec.Other_Inquiry_Type__c;
                 hiddeninput=true;
            }
        }
        // Modified By Ramakrishna Singara Start (05/26/2014)
        try{
            if(vCsLst!=null && vCsLst.size()>0){
                update vCsLst;
            }
        }
        catch(Exception e){
            CCP_Exception_Util.CCP_Exception_Mail(e);
        }
        return null; 
    }
    
    // Cancle Method helps to close the visualforce tab with out update any case records
    public PageReference Cancel() {      
        return null;
    }   
    // Modified By Ramakrishna Singara End (05/26/2014)
}