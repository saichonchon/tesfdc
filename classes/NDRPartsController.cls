/**********************************************************************************************************************************************
*******
Name: NDRPartsController  
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This controller handles the approval process of NDR Opportunity Parts based on the
            information received from SAP and GPMS System.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   04/01/2013    Controller  
 1.1   Mrunal Parate        18/11/2015    Modified Class to fix DMM Response Interface Calling for For NDR Phase II Enhancement project
 1.2   Rajendra Shahane     04/08/2016    Modified by Rajendra Shahane for case 00829354    
 1.3   Raghu Rama Y         16/11/2016    Modified by Raghu Rama Y for CCR Project
***********************************************************************************************************************************************
*****/

public class NDRPartsController {
  
/*------------------- D1 Collection variable declaration----------------------*/
    public List<Opportunity_Part__c> vNDRPartsList{get;set;}
    public List<NDRwrapper> vNDRWrapperList {get; set;}   
   
/*------------------- D2 Primitive variable declaration----------------------*/ 
    public Id vOppId{get;set;}
    public String vSoql{get;set;}
    public String vSelectedId = '';
    public String vSetParamId{get;set;}
    public String ndrcomment{get;set;}
    public String vSelectedRecordId{get;set;}
    public Integer appRejCount;//Added by Mrunal For NDR Phase II Enhancement project
    private String sortDirection = 'ASC';
    private String sortExp = 'NDR_DMM_Response_on_GMPS_Response__c';
    public boolean DisplayconfirmPopup{get;set;}
    public boolean DisplayApproveconfirmPopup{get;set;}
    public boolean vDisplayPopup{get;set;}
    public boolean vDisplayApprovePopup{get;set;}
    public boolean Rectyp{get;set;}    // Added boolean variable part of CCR 
/*------------------- D3 Object variable declaration----------------------*/    
    public Opportunity_Part__c vActiononNDR{get;set;}
    public Opportunity_Part__c vAgreeDisagreeonNDR{get;set;}
    public Profile vProfileName{get;set;}
    public Id vNDRRT;
    public Apex_Helper_Settings__c vNDROppRT;
/*------------------- Controller method   --------------------------------*/
    public NDRPartsController(ApexPages.StandardController controller) {
        vNDRPartsList = new List<Opportunity_Part__c>();
        vNDROppRT  = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');
        vNDRRT=vNDROppRT.Value__c;
        runQuery();
    }//End of controller
    
/*------------------- runQuery() method -----------------------------------*/ 
    public PageReference runQuery(){
        vOppId = System.currentPageReference().getParameters().get( 'id' );
        vSoql = 'select id,recordtypeid,NDR_GPMS_Signal__c,NDR_DMM_Response_on_GMPS_Response__c,'+
                'NDR_DMM_Response_on_Price_Information__c,NDR_Approve_Reject_Indicator__c,NDR_Item_Number__c,'+
                'NDR_Part_Description__c,NDR_Customer_Requested_Price__c, Quantity__c,NDR_GPMS_Approval_Flag_formula__c,'+
                'NDR_Item_Total_Price_Total_Value__c,NDR_Ship_and_Debit_Price__c,NDR_Award_Type_Description__c,'+
                'Opportunity__c,NDR_GPMS_Approval_Flag__c,NDR_GPMS_Approval_Price__c,NDR_Range__c,Code_for_unit_of_measurement__c,'+
                'NDR_GPMS_Approved_Currency__c, NDR_Price_Effective_Date__c,NDR_Price_Expiration_Date__c,'+
                'NDR_Final_Approver_Name__c,NDR_Comment__c,NDR_Rejection_Reason__c,NDR_Customer_Comments__c,'+
                'NDR_Rejection_Comments__c,Part__c,Part__r.name,NDR_Part_URL__c,NDR_GPMS_Status__c,NDR_Current_Stage__c,'+
                'NDR_DMM_Response__c,Red_Flag_Reason__c,NDR_Part_URL_Custom_Link__c,NDR_Competitor_Part_Number__c,NDR_Competitor_Name__c,Competitor_Price__c,'+
                'NDR_Item_Status_Desc__c,Opportunity__r.NDR_GPMS_ID__c,Opportunity__r.Opportunity_Part_Count__c'+//Added Opportunity_Part_Count__c field by Mrunal For NDR Phase II Enhancement project
                ' FROM Opportunity_Part__c WHERE Opportunity__c =: vOppId and recordtypeid =:vNDRRT'; 
                system.debug('vOppId'+vOppId);
               
        		//Added below code by Raghu For CCR project - CCR Changes Starts here              		   		
                opportunity oppRec = [select recordtypeid from opportunity where id =: vOppId];                
                system.debug('Opp Rec Id'+oppRec.recordtypeid);
                Opportunity_Record_Type_Groups__c CCR_Rec = Opportunity_Record_Type_Groups__c.getInstance('CCR Opportunity');
                system.debug('~~~~~~~~~~0'+oppRec.recordtypeid);
                Rectyp = false;             
                if(oppRec.recordtypeid == CCR_Rec.RecordTypeID__c) {
                Rectyp = true;
                } 
                //  CCR Changes ends here                                              
        if(sortDir == 'asc') {
        vNDRPartsList =  Database.query(vSoql+ ' order by ' + sortField + ' ' + sortDir );
        }else{
        vNDRPartsList =  Database.query(vSoql+ ' order by ' + sortField + ' ' + sortDir + ' nulls last');
        }
        vNDRWrapperList= new List<NDRwrapper>();
        appRejCount = 0;//Added by Mrunal For NDR Phase II Enhancement project  
        for(Opportunity_Part__c vOP: vNDRPartsList) {
            if(vOP.NDR_Approve_Reject_Indicator__c!= null){
                appRejCount++;//Added by Mrunal For NDR Phase II Enhancement project
                }
            NDRwrapper vNDRW;
            if(vOP.Red_Flag_Reason__c != null){
                vNDRW = new NDRwrapper(vOP,vOP.Red_Flag_Reason__c.split(','));//Initialising the wrapper constuctor with red flag reason
            }
            else{
                vNDRW = new NDRwrapper(vOP); //Initialising the wrapper constuctor
            }
            vNDRWrapperList.add(vNDRW);
        }
     
        return null;
  }// End of 'runQuery()' method.


/*----------------- Getter method for vSelectedId -------------------------*/  
    public String getvSelectedId() {
        return vSelectedId;
    }
/*----------------- Setter method for vSelectedId -------------------------*/        
    public void setvSelectedId(String slcsid) {
         vSelectedId = slcsid;
    }
/*----------------- Getter-Setter to get Sorting Direction ----------------*/    
    public String sortDir {
        get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
        set;
    }
/*----------------- Getter-Setter to get Sorting Field -------------------*/  
    public String sortField {
       get  { if (sortField == null) {sortField = 'NDR_DMM_Response_on_GMPS_Response__c'; } return sortField;  }
       set;
    }
/*----------------- Method to Sort the records ---------------------------*/   
    public void toggleSort() {
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        runQuery();
    } //End of 'toggleSort()' method.
  
/*---------- Method to Redirect to NDR Part detail page ------------------*/    
    public pagereference pageRefId(){
         pagereference pageref= new pagereference ('/'+vSetParamId);
         return  pageref;
    }// End of pageRefId() method
    
   
/*---------- Method to get selected NDR Part rejection comment ------------*/   
    Public void rejectActionOnNDR(){
        for(NDRwrapper n: vNDRWrapperList ){
            if(n.vNDR.id == vSelectedRecordId){
                vActiononNDR = n.vNDR;
                //displayConfirmPopup = true;
                vdisplayPopup = true;
            }
        }
    }
    public void ShowRejectPopup(){
        vdisplayPopup = true;
        displayConfirmPopup = false;
    }
/*---------- Method to get selected NDR Part approval comment ------------*/    
    Public void approveActionOnNDR(){
        for(NDRwrapper n: vNDRWrapperList ){
            if(n.vNDR.id == vSelectedRecordId){
                vActiononNDR = n.vNDR;
               // DisplayApproveconfirmPopup = true;  //change made on 25-6-2013 according to swathi's mail
            }
        }
        saveApproveComments();
    } 
    public void ShowApprovePopup(){
        for(NDRwrapper n: vNDRWrapperList ){
            if(n.vNDR.id == vSelectedRecordId){
                vActiononNDR = n.vNDR;
                displayApproveconfirmPopUp= true;
            }
        }
         
       // vDisplayApprovePopup = true;
    } 
/*---------- Method to save selected NDR Part rejection comment & status ------------*/     
    public PageReference saveRejectComments(){
        
        if(vActiononNDR.NDR_Rejection_Reason__c == null || vActiononNDR.NDR_Rejection_Comments__c == null){
             ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Please select rejection reason and enter comments.'));
             return null;
        }
        else{
        vActiononNDR.NDR_Current_Stage__c = 'Part rejected';
        vActiononNDR.NDR_DMM_Response_on_GMPS_Response__c = 'Rejected';
        vActiononNDR.NDR_Approve_Reject_Indicator__c = 'R';
        update vActiononNDR;
        //Change start by Mrunal For NDR Phase II Enhancement project
        runQuery();
        system.debug('>>>>SAPCallReject'+appRejCount+'----partcnt--'+vActiononNDR.Opportunity__r.Opportunity_Part_Count__c);
        if(vActiononNDR.Opportunity__r.Opportunity_Part_Count__c == appRejCount){
            NDRInitiateSFDC2SAP.InitiateOrch(vActiononNDR.Opportunity__c);
        }
        //Change End by Mrunal For NDR Phase II Enhancement project
        vActiononNDR = null;
        vDisplayPopup = false;
        return null;
        }
    }
/*---------- Method to save selected NDR Part approval comment & status ------------*/  
    public void saveApproveComments(){
     
        vActiononNDR.NDR_Current_Stage__c = 'Part approved';
        vActiononNDR.NDR_DMM_Response_on_GMPS_Response__c = 'Approved';
        vActiononNDR.NDR_Approve_Reject_Indicator__c = 'A';   
        vActiononNDR.NDR_Comment__c=ndrcomment; 
        update vActiononNDR;
        //Change start by Mrunal For NDR Phase II Enhancement project
        runQuery();
        system.debug('>>>>SAPCallApprove'+appRejCount+'----partcnt--'+vActiononNDR.Opportunity__r.Opportunity_Part_Count__c);
        if(vActiononNDR.Opportunity__r.Opportunity_Part_Count__c == appRejCount){
            NDRInitiateSFDC2SAP.InitiateOrch(vActiononNDR.Opportunity__c);
        }
        //Change End by Mrunal For NDR Phase II Enhancement project
        DisplayApproveconfirmPopup = false;
        vActiononNDR = null;
     }
/*---------- Method to close rejection comment popup ------------------*/   
    public void closeRejectPopup(){
        DisplayconfirmPopup =false;        
        vDisplayPopup = false;    
    } 
/*---------- Method to close approval comment popup ------------------*/    
    public void closeApprovePopup(){ 
        runQuery();       
        DisplayApproveconfirmPopup =false;
        vDisplayApprovePopup = false;    
    }
    
    public void agreeActiononNDR(){
        for(NDRwrapper n: vNDRWrapperList ){
            if(n.vNDR.id == vSelectedRecordId){
                vAgreeDisagreeonNDR = n.vNDR;
                n.vDisplayAgreeConfirmPopup = true;
            }
        }
    }
    public void disagreeActionOnNDR(){
        for(NDRwrapper n: vNDRWrapperList ){
            if(n.vNDR.id == vSelectedRecordId){
                vAgreeDisagreeonNDR = n.vNDR;
                n.vDisplayDisagreeConfirmPopup = true;
             }
        }
    }
    public void closeAgreepopup(){
        for(NDRwrapper n: vNDRWrapperList ){
            if(n.vNDR.id == vSelectedRecordId){
               n.vDisplayAgreeConfirmPopup = false;
            }
        }
        vAgreeDisagreeonNDR= null;
    }
    public void closeDisagreepopup(){
       for(NDRwrapper n: vNDRWrapperList ){
            if(n.vNDR.id == vSelectedRecordId){
                n.vDisplayDisagreeConfirmPopup = false;
            }
        }
        vAgreeDisagreeonNDR= null;
    }
/*---------------------- Method to agree GPMS price ------------------*/ 
    public void agreeNDR(){
        vAgreeDisagreeonNDR.NDR_Current_Stage__c = 'Price agreed';
        vAgreeDisagreeonNDR.NDR_DMM_Response_on_Price_Information__c = 'Agreed';
        vAgreeDisagreeonNDR.NDR_DMM_Response__c = 'Y';
        vAgreeDisagreeonNDR.NDR_Item_Status_Desc__c = 'In Process';// Added by Mrunal for NDR Phase II Enhancement project to Update Item Status Desc field to In Process when DMM Updates comment and it goes to GPMS.
        update vAgreeDisagreeonNDR ;
        runQuery();//Added by Rajendra Shahane for case 00829354 04/08/2016
        //if(vAgreeDisagreeonNDR.Opportunity__r.NDR_GPMS_ID__c != null){ //Commented by Rajendra Shahane for case 00829354 04/08/2016
        if(vAgreeDisagreeonNDR.Opportunity__r.NDR_GPMS_ID__c != null && vAgreeDisagreeonNDR.Opportunity__r.Opportunity_Part_Count__c == appRejCount){//Added by Rajendra Shahane for case 00829354 04/08/2016
        NDRInitiateSFDC2GPMS.InitiateOrch(vAgreeDisagreeonNDR.id);
        }
        closeAgreepopup();
        update vNDRPartsList;
        
        runQuery();
    }
/*---------------------- Method to disagree GPMS price ------------------*/ 
    public void disAgreeNDR(){
        vAgreeDisagreeonNDR.NDR_Current_Stage__c = 'Price disagreed';
        vAgreeDisagreeonNDR.NDR_DMM_Response_on_Price_Information__c = 'Disagreed';
        vAgreeDisagreeonNDR.NDR_DMM_Response__c = 'N';
        vAgreeDisagreeonNDR.NDR_Item_Status_Desc__c = 'In Process';// Added by Mrunal for NDR Phase II Enhancement project to Update Item Status Desc field to In Process when DMM Updates comment and it goes to GPMS.
        update vAgreeDisagreeonNDR;
        runQuery();//Added by Rajendra Shahane for case 00829354 04/08/2016
        //if(vAgreeDisagreeonNDR.Opportunity__r.NDR_GPMS_ID__c != null ){ //Commented by Rajendra Shahane for case 00829354 04/08/2016
        if(vAgreeDisagreeonNDR.Opportunity__r.NDR_GPMS_ID__c != null && vAgreeDisagreeonNDR.Opportunity__r.Opportunity_Part_Count__c == appRejCount){//Added by Rajendra Shahane for case 00829354 04/08/2016
        NDRInitiateSFDC2GPMS.InitiateOrch(vAgreeDisagreeonNDR.id);
        }
        closeDisagreepopup();
        update vNDRPartsList;
        runQuery();
   }
 /*----------------------------- Method called to save cooment of a NDR Part --------------------*/    
    public void SaveComment(){
        update vNDRPartsList;
    }//End of SaveComment method.   
/*---------- Wrapper class ------------------*/ 
    public class NDRwrapper{
        public Opportunity_Part__c vNDR {get; set;}
        public String vRFRLst{get;set;}
        public Map<String,NDR_red_flag_reason__c> vNametoReasonMap{get;set;}
        public boolean vDisplayAgreeConfirmPopup{get;set;}
        public boolean vDisplayDisagreeConfirmPopup{get;set;}
        public NDRwrapper() {
            
        }
        public NDRwrapper(Opportunity_Part__c pNDRWrapper) {
            vNDR  = pNDRWrapper;
            vDisplayAgreeConfirmPopup = false;
            vDisplayDisagreeConfirmPopup = false;
        }
        public NDRwrapper(Opportunity_Part__c pNDRWrapper,List<String> pRFRLst) {
            vRFRLst ='';
            vNametoReasonMap =NDR_red_flag_reason__c.getAll();
            for(Integer i=0;i<pRFRLst.size();i++){
                vRFRLst =vRFRLst+vNametoReasonMap.get(pRFRLst[i]).name+'. '+vNametoReasonMap.get(pRFRLst[i]).Red_Flag_Reason__c+'<br/>';
                system.debug('vRFRLst'+vRFRLst);
            }
            vNDR  = pNDRWrapper;
            vDisplayAgreeConfirmPopup = false;
            vDisplayDisagreeConfirmPopup = false;
        }
    } 
}