/**********************************************************************************************************************************************
*******
Name: AssignEntltoContact_CCP
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is used to check recordtype of selected cases .
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  11/14/2013    Class                       
***********************************************************************************************************************************************
*****/
public class CheckCaseRTController {
    public List<String> vCaseIds;
    public String vCaseIdLst;
    public List<Case> vCsLst;
    public Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
    public CheckCaseRTController(ApexPages.StandardController controller) {
        vCaseIds = new List<String>();
        vCsLst = new List<Case>();
        vCaseIdLst = ApexPages.currentPage().getparameters().get('ids');
        vCaseIDs = ApexPages.currentPage().getparameters().get('ids').split(',');
    }

    public PageReference CheckRT(){
        vCsLst = [Select id,recordtypeid from case where id in: vCaseIds];
        if(vCsLst[0].recordtypeid == vCaseRT.Value__c){
            PageReference pgrf = new PageReference('/apex/MassCloseCase_CCP?ids='+vCaseIdLst);
            return pgrf;    
        }else{
            PageReference pgrf = new PageReference('/apex/MassCloseCaseVF?ids='+vCaseIdLst);
            return pgrf;
        }    
    }
}