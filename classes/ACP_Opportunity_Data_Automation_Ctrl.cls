/***************************************************************************************
Name:ACP_Opportunity_Data_Automation_Ctrl
Test Class:ACP_Opp_Data_Automation_Ctrl_Test
Copyright © 2017 TE Connectivity
========================================================================================
Requirement:
Controller for Opportunity TAM Reports and Market Competition Reports.
========================================================================================
Purpose:
Controller to update the Opportunity TAM Revenue record with latest Grand Totals of different BU reports
And also for Market and Competition update from Report functionality.
===================================================================================    ======
History
-------
Version      Author                     Date              Detail
1.0          Haripriya Maturi           08/09/17          Initial Development
2.0          Esther Ethelbert           15/09/17          Added methods for Market and Competition Reports
3.0          Haripriya Maturi           27/11/17          Implementation of Channel BU, added comments, and code optimization
****************************************************************************************/
public with sharing class ACP_Opportunity_Data_Automation_Ctrl {
    public String acpId {
        get;
        set;
    }
    public Id MarketId {
        get;
        set;
    }
    public List < ACP_Opportunity_TAM_Revenue__c > oppTAMRevRecords = new List < ACP_Opportunity_TAM_Revenue__c > ();
    public List < ACP_Opportunity_TAM_Revenue__c > oppTAMRevRec;
    public ACP_Market_and_Competition__c markCompRecords = new ACP_Market_and_Competition__c ();
    public List < ACP_Market_and_Competition__c > markCompRec;
    public ACP_Account_Plan__c aPlan {
        get;
        set;
    }
    public String userBU{get;set;}
    
    //below boolean variables used to get the respective BU's FieldSet, Record Type, to get the field values, and to assign the values to respective filters
    private Boolean IND=false;
    private Boolean APL=false;
    private Boolean DND=false;
    private Boolean MED=false;
    private Boolean ADM=false;
    private Boolean CHN=false;
    
    private RecordType recordType{get;set;}
    public String oppTamRevRecordId{get;set;}
    private transient Map<String, Schema.Fieldset> FSMap;
    private List<ACP_Oppty_TAM_Report__c> selectedBUList = new List<ACP_Oppty_TAM_Report__c>();
    
    //below are the variables to store PL4Q report filter values from "Opportunity TAM Report" Object
    private String processStatus_PL4Q;
    private String type_PL4Q;
    private String days_sincelastUpdate_PL4Q;
    private String wonDate_PL4Q;
    private String conf_PL4Q;
    private String date_PL4Q;
    private String oppGrp_PL4Q;
    private String conf2_PL4Q;
    private String aplActive_PL4Q;
    private String medOppStatus_PL4Q;
    private String medPortfolio_PL4Q;
    private String phase_PL4Q;
    private String buProfitCenter_PL4Q;
    private String oppRecordType_PL4Q;
    private String oppRecordType2_PL4Q;
    private String days_sincelastUpdate2_PL4Q;
    private String distributor_PL4Q;
    private String distributor2_PL4Q;
    
    //below are the variables to store Conversion report filter values from "Opportunity TAM Report" Object
    private String processStatus_Conv;
    private String type_Conv;
    private String wonDate_Conv;
    private String conf_Conv;
    private String oppGrp_Conv;
    private String date_Conv;
    private String medOppStatus_Conv;
    private String medPortfolio_Conv;
    private String lostDate_Conv;
    private String phase_Conv;
    private String buProfitCenter_Conv;
    private String oppRecordType_Conv;
    private String distributor_Conv;
    private String distributor2_Conv;
    
    //below are the variables to store Lost report filter values from "Opportunity TAM Report" Object
    private String oppGrp_Lost;
    private String phase_Lost;
    private String lostDate_Lost;
    private String conf_Lost;
    private String date_Lost;
    private String medPortfolio_Lost;
    private String wonDate_Lost;
    private String buProfitCenter_Lost;
    private String oppRecordType_Lost;
    private String partConfidence_Lost;
    private String type_Lost;
    private String date2_Lost;
    private String distributor_Lost;
    private String distributor2_Lost;
    
    //below are the variables to store Won report filter values from "Opportunity TAM Report" Object
    private String processStatus_Won;
    private String oppGrp_Won;
    private String phase_Won;
    private String wonDate_Won;
    private String conf_Won;
    private String date_Won;
    private String medPortfolio_Won;
    private String lostDate_Won;
    private String buProfitCenter_Won;
    private String oppRecordType_Won;
    private String partConfidence_Won;
    private String type_Won;
    private String date2_Won;
    private String distributor_Won;
    private String distributor2_Won;
    
    //below are the variables to store CY Pipeline report filter values from "Opportunity TAM Report" Object
    private String processStatus_CY;
    private String type_CY;
    private String days_sincelastUpdate_CY;
    private String wonDate_CY;
    private String conf_CY;
    private String date_CY;
    private String oppGrp_CY;
    private String conf2_CY;
    private String aplActive_CY;
    private String medOppStatus_CY;
    private String medPortfolio_CY;
    private String phase_CY;
    private String buProfitCenter_CY;
    private String oppRecordType_CY;
    private String distributor_CY;
    private String distributor2_CY;
    
    //below are the variables to store NY Pipeline report filter values from "Opportunity TAM Report" Object
    private String processStatus_NY;
    private String type_NY;
    private String days_sincelastUpdate_NY;
    private String wonDate_NY;
    private String conf_NY;
    private String date_NY;
    private String oppGrp_NY;
    private String conf2_NY;
    private String aplActive_NY;
    private String medPortfolio_NY;
    private String phase_NY;
    private String buProfitCenter_NY;
    private String oppRecordType_NY;
    private String oppRecordType2_NY;
    private String days_sincelastUpdate2_NY;
    private String distributor_NY;
    private String distributor2_NY;
    
    //below are the variables to store 5Y Pipeline report filter values from "Opportunity TAM Report" Object
    private String processStatus_5Y;
    private String type_5Y;
    private String days_sincelastUpdate_5Y;
    private String wonDate_5Y;
    private String conf_5Y;
    private String date_5Y;
    private String oppGrp_5Y;
    private String conf2_5Y;
    private String aplActive_5Y;
    private String medPortfolio_5Y;
    private String phase_5Y;
    private String buProfitCenter_5Y;
    private String oppRecordType_5Y;
    private String oppRecordType2_5Y;
    private String days_sincelastUpdate2_5Y;
    private String distributor_5Y;
    private String distributor2_5Y;
    
    //below are the boolean variables used to execute respective report one after the other for current BU
    private Boolean PL4QReport = false;
    private Boolean ConvReport = false;
    private Boolean LostReport = false;
    private Boolean WonReport = false;
    private Boolean CYReport = false;
    private Boolean NYReport = false;
    private Boolean Five5YReport = false;
    
    //below are the Constant variables to hold API name of FieldSet for respective BU
    private final String ADMFieldSet = 'ACP_ADM_Fieldset';
    private final String APLFieldSet = 'ACP_Appliances_FieldSet';
    private final String CHNFieldSet = 'ACP_Channel_Fieldset';
    private final String DNDFieldSet = 'ACP_DND_Fieldset';
    private final String INDFieldSet = 'ACP_Industrial_Fieldset';
    private final String MEDFieldSet = 'ACP_Medical_Fieldset';
    
    //below variable is used to store the logged in person UserBU's Field set API Name
    private String selectedFieldSet;
    
    public ACP_Opportunity_Data_Automation_Ctrl(ApexPages.StandardController stdController) {
        acpId = ApexPages.currentPage().getParameters().get('acpId');
        aplan = new ACP_Account_Plan__c();
        System.Debug('aplan :- '+aplan);
        aPlan = [select id, ACP_Account_Name__c, ACP_Account_Name__r.Id, Account_Plan_Type__c, ACP_GAMCode__c, ACP_KAMCode__c, ACP_WWAcNo__c from ACP_Account_Plan__c where Id =: acpId];
        System.Debug('aPlan Account_Plan_Type__c : ' + aPlan.Account_Plan_Type__c);
        if(!Test.IsRunningTest()){
            userBU = [Select GIBU__c From User Where Id = : UserInfo.getUserId()][0].GIBU__c;  
        }        
    }
    //below method is to get the list of fields from the respective FieldSet of logged in User BU
    public List<ACP_Oppty_TAM_Report__c> getBUFiltersList(String acpId, String fSet) {
        try{
            transient String query = 'SELECT ';
            FSMap = Schema.SObjectType.ACP_Oppty_TAM_Report__c.fieldSets.getMap();
            List<Schema.FieldSetMember> fieldList = FSMap.get(fSet).getFields();
            for (Schema.FieldSetMember f: fieldList) {
                query += f.getFieldPath() + ',';
            }    
            query += 'Id FROM ACP_Oppty_TAM_Report__c where recordtypeid = \'' + recordType.id + '\'' ;
            
            return Database.query(query);
        }catch(Exception e){
            ErrorLogging.Log(e, 'ACP_Opportunity_Data_Automation_Ctrl', 'getBUFiltersList',acpId);
            ApexPages.addMessages(e);
            return null;
        }    
    }
    //on click of "Update" button from "Opportunity TAM Vs Revenue" section, below method will get executed
    public pageReference updateRecords() {
        try {
            //below Map "userBUs" is used to store BU names from custom setting
            Map<String,ACP_User_BU__c> userBUs = ACP_User_BU__c.getAll();
            System.Debug('userBUs Key===> '+userBUs.keySet()+' userBUs Values===> '+userBUs.values());
            if(userBU != null){
                if(userBU == userBUs.get('ACP_ADM').UserBU__c){
                    ADM = true;
                    selectedFieldSet = ADMFieldSet;
                }else if(userBU == userBUs.get('ACP_Industrial').UserBU__c){
                    IND = true;
                    selectedFieldSet = INDFieldSet;
                }else if(userBU == userBUs.get('ACP_Appliances').UserBU__c){
                    APL = true;
                    selectedFieldSet = APLFieldSet;
                }else if(userBU == userBUs.get('ACP_Channel').UserBU__c){
                    CHN = true;
                    selectedFieldSet = CHNFieldSet;
                }else if(userBU == userBUs.get('ACP_DND').UserBU__c){
                    DND = true;
                    selectedFieldSet = DNDFieldSet;
                }else if(userBU == userBUs.get('ACP_Medical').UserBU__c){
                    MED = true;
                    selectedFieldSet = MEDFieldSet;
                }else{
                    MED = true;// If user belongs to any other BU, Medical BU will taken as default BU.
                    selectedFieldSet = MEDFieldSet;
                }
            }
            if(ADM || IND || APL || CHN || DND || MED){  
                System.Debug('userBU :- '+userBU);
                recordType = [select Id,name from RecordType where Name =:userBU and SobjectType = 'ACP_Oppty_TAM_Report__c'];
            }
            System.Debug('recordType :-'+recordType);
            
            //below code to add the current BU's list of fields to "selectedBUList"
            for(ACP_Oppty_TAM_Report__c rep : getBUFiltersList(acpId,selectedFieldSet)){ 
                selectedBUList.add(rep);
            }               
            /* Below code to get the field values with the help of getBUFiltersList() method from Opportunity TAM Report object's
             * current BU's Field Set, and then to check whether fields which have values or not, 
             * if value avaliable then it will be assign to the Filter variables.
                         */            
            
            for(ACP_Oppty_TAM_Report__c rep : selectedBUList){      
                // start of PL4Q
                
                date_PL4Q = rep.ACP_PL4Q_Date__c;
                if(date_PL4Q != null && date_PL4Q != ''){
                    date_PL4Q = date_PL4Q.trim();
                }
                if(!APL){
                    wonDate_PL4Q = rep.ACP_PL4Q_Won_Date__c;
                    if(wonDate_PL4Q != null && wonDate_PL4Q != '')
                        wonDate_PL4Q = wonDate_PL4Q.trim();
                }
                if(IND || CHN){
                    if(rep.ACP_PL4Q_Type__c != null && rep.ACP_PL4Q_Type__c != ''){
                        type_PL4Q = rep.ACP_PL4Q_Type__c.replace(';', ',');
                    }
                    if(rep.ACP_PL4Q_Days_since_last_user_update__c != null){
                        days_sincelastUpdate_PL4Q = String.ValueOf(rep.ACP_PL4Q_Days_since_last_user_update__c);
                    }
                }   
                if(IND || ADM || DND || CHN){
                    if(rep.ACP_PL4Q_Confidence__c != null && rep.ACP_PL4Q_Confidence__c != ''){
                        conf_PL4Q = rep.ACP_PL4Q_Confidence__c.replace(';', ',');
                    }
                }
                if(ADM || DND || CHN){
                    if(rep.ACP_PL4Q_Oppty_Rec_Type__c != null && rep.ACP_PL4Q_Oppty_Rec_Type__c != ''){
                        oppRecordType_PL4Q = rep.ACP_PL4Q_Oppty_Rec_Type__c.replace(';',',');
                    }                   
                }
                if(IND || DND || CHN){
                    conf2_PL4Q = rep.ACP_PL4Q_Confidence2__c;
                    if(conf2_PL4Q != null && conf2_PL4Q != '')
                        conf2_PL4Q = conf2_PL4Q.trim();
                }
                if(IND){
                    if(rep.ACP_PL4Q_Process_Status__c != null && rep.ACP_PL4Q_Process_Status__c != ''){
                        processStatus_PL4Q = rep.ACP_PL4Q_Process_Status__c.replace(';', ',');
                    }
                    if(rep.ACP_PL4Q_Opp_Group__c != null && rep.ACP_PL4Q_Opp_Group__c != ''){
                        oppGrp_PL4Q = rep.ACP_PL4Q_Opp_Group__c.replace(';', ',');
                    }                    
                }
                if(APL){
                    if(rep.ACP_PL4Q_aplActivePL__c){
                        aplActive_PL4Q = 'Yes';
                    }else
                        aplActive_PL4Q = 'No';
                }
                if(MED){                   
                    if(rep.ACP_PL4Q_MEDOppStatus__c != null && rep.ACP_PL4Q_MEDOppStatus__c != ''){
                        medOppStatus_PL4Q = rep.ACP_PL4Q_MEDOppStatus__c.replace(';',',');
                    }                    
                    medPortfolio_PL4Q = rep.ACP_PL4Q_MED_Portfolio__c;
                    if(medPortfolio_PL4Q != null && medPortfolio_PL4Q != '')
                        medPortfolio_PL4Q = medPortfolio_PL4Q.trim();
                }
                if(ADM){
                    if(rep.ACP_PL4Q_Phase__c != null && rep.ACP_PL4Q_Phase__c != ''){
                        phase_PL4Q = rep.ACP_PL4Q_Phase__c.replace(';', ',');
                    }
                }
                if(DND){
                    if(rep.ACP_PL4Q_BU_Profit_Center__c != null && rep.ACP_PL4Q_BU_Profit_Center__c != ''){
                        buProfitCenter_PL4Q = rep.ACP_PL4Q_BU_Profit_Center__c.replace(';',',');
                    }
                }
                if(CHN){
                    if(rep.ACP_PL4Q_Opportunity_Record_Type2__c != null && rep.ACP_PL4Q_Opportunity_Record_Type2__c != ''){
                        oppRecordType2_PL4Q = rep.ACP_PL4Q_Opportunity_Record_Type2__c.replace(';',',');
                    }
                    if(rep.ACP_PL4Q_DISTRIBUTOR__c != null && rep.ACP_PL4Q_DISTRIBUTOR__c != ''){
                        distributor_PL4Q = rep.ACP_PL4Q_DISTRIBUTOR__c.replace(';',',');
                    }
                    if(rep.ACP_PL4Q_DISTRIBUTOR2__c != null && rep.ACP_PL4Q_DISTRIBUTOR2__c != ''){
                        distributor2_PL4Q = rep.ACP_PL4Q_DISTRIBUTOR2__c.replace(';',',');
                    }
                    if(rep.ACP_PL4Q_Days_since_last_user_update2__c != null){
                        days_sincelastUpdate2_PL4Q = String.ValueOf(rep.ACP_PL4Q_Days_since_last_user_update2__c);
                    }
                }
                
                //End of PL4Q
                
                //Start of Conv                              
                
                wonDate_Conv = rep.ACP_Conv_Won_Date__c;
                if(wonDate_Conv != null && wonDate_Conv != '')
                    wonDate_Conv = wonDate_Conv.trim();                
                if(IND || APL || CHN){
                    if(rep.ACP_Conv_Process_Status__c != null && rep.ACP_Conv_Process_Status__c != ''){
                        processStatus_Conv = rep.ACP_Conv_Process_Status__c.replace(';', ','); 
                    }
                }
                if(IND || APL || ADM || DND || CHN){
                    if(rep.ACP_Conv_Confidence__c != null && rep.ACP_Conv_Confidence__c != ''){
                        conf_Conv = rep.ACP_Conv_Confidence__c.replace(';', ',');
                    }
                }
                if(IND || CHN){
                    if(rep.ACP_Conv_Type__c != null && rep.ACP_Conv_Type__c != ''){
                        type_Conv = rep.ACP_Conv_Type__c.replace(';', ',');
                    }
                }
                if(IND){ 
                    if(rep.ACP_Conv_Opp_Group__c != null && rep.ACP_Conv_Opp_Group__c != ''){
                        oppGrp_Conv = rep.ACP_Conv_Opp_Group__c.replace(';', ',');
                    }
                }
                if(APL || MED || ADM || DND || CHN){
                    date_Conv = rep.ACP_Conv_Date__c;
                    if(date_Conv != null && date_Conv != '')
                        date_Conv = date_Conv.trim();
                }
                if(ADM || DND || CHN){
                    if(rep.ACP_Conv_Oppty_Rec_Type__c != null && rep.ACP_Conv_Oppty_Rec_Type__c != ''){
                        oppRecordType_Conv = rep.ACP_Conv_Oppty_Rec_Type__c.replace(';',',');
                    }
                }
                if(MED){
                    if(rep.ACP_Conv_MEDOppStatus__c != null && rep.ACP_Conv_MEDOppStatus__c != ''){
                        medOppStatus_Conv = rep.ACP_Conv_MEDOppStatus__c.replace(';',',');
                    }                    
                    medPortfolio_Conv = rep.ACP_Conv_MED_Portfolio__c;
                    if(medPortfolio_Conv != null && medPortfolio_Conv != '')
                        medPortfolio_Conv = medPortfolio_Conv.trim();
                    
                    lostDate_Conv = rep.ACP_Conv_Lost_Date__c;
                    if(lostDate_Conv != null && lostDate_Conv !='')
                        lostDate_Conv = lostDate_Conv.trim();
                }
                if(ADM){
                    if(rep.ACP_Conv_Phase__c != null && rep.ACP_Conv_Phase__c != ''){
                        phase_Conv = rep.ACP_Conv_Phase__c.replace(';', ',');
                    }                    
                }
                if(DND){
                    if(rep.ACP_Conv_BU_Profit_Center__c != null && rep.ACP_Conv_BU_Profit_Center__c != ''){
                        buProfitCenter_Conv = rep.ACP_Conv_BU_Profit_Center__c.replace(';',',');
                    }
                }
                if(CHN){
                    if(rep.ACP_Conv_DISTRIBUTOR__c != null && rep.ACP_Conv_DISTRIBUTOR__c != ''){
                        distributor_Conv = rep.ACP_Conv_DISTRIBUTOR__c.replace(';',',');
                    }
                    if(rep.ACP_Conv_DISTRIBUTOR2__c != null && rep.ACP_Conv_DISTRIBUTOR2__c != ''){
                        distributor2_Conv = rep.ACP_Conv_DISTRIBUTOR2__c.replace(';',',');
                    }
                }
                //End of Conv
                
                //Start of Lost
                //System.Debug('oppGrp_Lost Value:'+rep.ACP_Lost_Opp_Group__c);
                lostDate_Lost = rep.ACP_Lost_Lost_Date__c;
                if(lostDate_Lost != null && lostDate_Lost != '')
                    lostDate_Lost = lostDate_Lost.trim();
                
                if(IND){
                    if(rep.ACP_Lost_Opp_Group__c != null && rep.ACP_Lost_Opp_Group__c != ''){
                        oppGrp_Lost = rep.ACP_Lost_Opp_Group__c.replace(';', ',');
                    }
                    if(rep.ACP_Lost_Phase__c != null && rep.ACP_Lost_Phase__c != ''){
                        phase_Lost = rep.ACP_Lost_Phase__c.replace(';', ',');
                    }
                }
                if(APL || ADM || DND){
                    if(rep.ACP_Lost_Confidence__c != null && rep.ACP_Lost_Confidence__c != ''){
                        conf_Lost = rep.ACP_Lost_Confidence__c.replace(';', ',');
                    }
                }
                if(APL || ADM || MED || DND || CHN){
                    date_Lost = rep.ACP_Lost_Date__c;
                    if(date_Lost != null && date_Lost != '')
                        date_Lost = date_Lost.trim();
                }
                if(ADM || DND || CHN){
                    if(rep.ACP_Lost_Oppty_Rec_Type__c != null && rep.ACP_Lost_Oppty_Rec_Type__c != ''){
                        oppRecordType_Lost = rep.ACP_Lost_Oppty_Rec_Type__c.replace(';',',');
                    }
                }
                if(MED){
                    medPortfolio_Lost = rep.ACP_Lost_MED_Portfolio__c;
                    if(medPortfolio_Lost != null && medPortfolio_Lost != '')
                        medPortfolio_Lost = medPortfolio_Lost.trim();
                    
                    wonDate_Lost = rep.ACP_Lost_Won_Date__c;
                    if(wonDate_Lost != null && wonDate_Lost != '')
                        wonDate_Lost = wonDate_Lost.trim();
                }
                if(DND){
                    if(rep.ACP_Lost_BU_Profit_Center__c != null && rep.ACP_Lost_BU_Profit_Center__c != ''){
                        buProfitCenter_Lost = rep.ACP_Lost_BU_Profit_Center__c.replace(';',',');
                    }
                }
                if(CHN){
                    if(rep.ACP_Lost_Type__c != null && rep.ACP_Lost_Type__c != ''){
                        type_Lost = rep.ACP_Lost_Type__c.replace(';',',');
                    }
                    if(rep.ACP_Lost_DISTRIBUTOR__c != null && rep.ACP_Lost_DISTRIBUTOR__c != ''){
                        distributor_Lost = rep.ACP_Lost_DISTRIBUTOR__c.replace(';',',');
                    }
                    if(rep.ACP_Lost_DISTRIBUTOR2__c != null && rep.ACP_Lost_DISTRIBUTOR2__c != ''){
                        distributor2_Lost = rep.ACP_Lost_DISTRIBUTOR2__c.replace(';',',');
                    }
                    partConfidence_Lost = rep.ACP_Lost_Part_Confidence__c;
                    if(partConfidence_Lost != null && partConfidence_Lost != '')
                        partConfidence_Lost = partConfidence_Lost.trim();
                    
                    date2_Lost = rep.ACP_Lost_Date2__c;
                    if(date2_Lost != null && date2_Lost != '')
                        date2_Lost = date2_Lost.trim();
                }
                //End of Lost
                
                //Start of Won                
                wonDate_Won = rep.ACP_Won_Won_Date__c;
                if(wonDate_Won != null && wonDate_Won != '')
                    wonDate_Won = wonDate_Won.trim();
                if(IND){
                    if(rep.ACP_Won_Opp_Group__c != null && rep.ACP_Won_Opp_Group__c != ''){
                        oppGrp_Won = rep.ACP_Won_Opp_Group__c.replace(';', ',');
                    }
                    if(rep.ACP_Won_Phase__c != null && rep.ACP_Won_Phase__c != ''){
                        phase_Won = rep.ACP_Won_Phase__c.replace(';', ',');
                    }
                }
                if(APL || ADM || DND){
                    if(rep.ACP_Won_Confidence__c != null && rep.ACP_Won_Confidence__c != ''){
                        conf_Won = rep.ACP_Won_Confidence__c.replace(';', ',');
                    }
                }
                if(APL || MED || ADM || DND || CHN){
                    date_Won = rep.ACP_Won_Date__c;
                    if(date_Won != null && date_Won != '')
                        date_Won = date_Won.trim();
                }
                if(APL){
                    if(rep.ACP_Won_Process_Status__c != null && rep.ACP_Won_Process_Status__c != ''){
                        processStatus_Won = rep.ACP_Won_Process_Status__c.replace(';',',');
                    }
                }if(MED){                   
                    medPortfolio_Won = rep.ACP_Won_MED_Portfolio__c;
                    if(medPortfolio_Won != null && medPortfolio_Won != '')
                        medPortfolio_Won = medPortfolio_Won.trim();
                    
                    lostDate_Won = rep.ACP_Won_Lost_Date__c;
                    if(lostDate_Won != null && lostDate_Won != '')
                        lostDate_Won = lostDate_Won.trim();
                }if(DND){                    
                    if(rep.ACP_Won_BU_Profit_Center__c != null && rep.ACP_Won_BU_Profit_Center__c != ''){
                        buProfitCenter_Won = rep.ACP_Won_BU_Profit_Center__c.replace(';',',');
                    }                    
                }if(ADM || DND || CHN){
                    if(rep.ACP_Won_Oppty_Rec_Type__c != null && rep.ACP_Won_Oppty_Rec_Type__c != ''){
                        oppRecordType_Won = rep.ACP_Won_Oppty_Rec_Type__c.replace(';',',');
                    }
                }if(CHN){
                    partConfidence_Won = rep.ACP_Won_Part_Confidence__c;
                    if(partConfidence_Won != null && partConfidence_Won != '')
                        partConfidence_Won = partConfidence_Won.trim();
                    if(rep.ACP_Won_Type__c != null && rep.ACP_Won_Type__c != ''){
                        type_Won = rep.ACP_Won_Type__c.replace(';',',');
                    }
                    if(rep.ACP_Won_DISTRIBUTOR__c != null && rep.ACP_Won_DISTRIBUTOR__c != ''){
                        distributor_Won = rep.ACP_Won_DISTRIBUTOR__c.replace(';',',');
                    }
                    if(rep.ACP_Won_DISTRIBUTOR2__c != null && rep.ACP_Won_DISTRIBUTOR2__c != ''){
                        distributor2_Won = rep.ACP_Won_DISTRIBUTOR2__c.replace(';',',');
                    }
                    date2_Won = rep.ACP_Won_Date2__c;
                    if(date2_Won != null && date2_Won != '')
                        date2_Won = date2_Won.trim();
                }
                //End of Won
                
                //Start of CYPL
                date_CY = rep.ACP_CYPL_Date__c;
                if(date_CY != null && date_CY != '')
                    date_CY = date_CY.trim();
                if(IND || CHN){
                    if(rep.ACP_CYPL_Type__c != null && rep.ACP_CYPL_Type__c != ''){
                        type_CY = rep.ACP_CYPL_Type__c.replace(';', ',');
                    }
                    if(rep.ACP_CYPL_Process_Status__c != null && rep.ACP_CYPL_Process_Status__c != ''){
                        processStatus_CY = rep.ACP_CYPL_Process_Status__c.replace(';', ',');
                    }
                }
                if(IND || MED || ADM || DND || CHN){
                    wonDate_CY = rep.ACP_CYPL_Won_Date__c;
                    if(wonDate_CY != null && wonDate_CY != '')
                        wonDate_CY = wonDate_CY.trim();
                }
                if(IND || ADM || DND || CHN){
                    if(rep.ACP_CYPL_Confidence__c != null && rep.ACP_CYPL_Confidence__c != ''){
                        conf_CY = rep.ACP_CYPL_Confidence__c.replace(';', ',');
                    }   
                }
                if(IND || DND){
                    conf2_CY = rep.ACP_CYPL_Confidence2__c;
                    if(conf2_CY != null && conf2_CY != '')
                        conf2_CY = conf2_CY.trim();
                }
                if(ADM || DND || CHN){
                    if(rep.ACP_CYPL_Oppty_Rec_Type__c != null && rep.ACP_CYPL_Oppty_Rec_Type__c != ''){
                        oppRecordType_CY = rep.ACP_CYPL_Oppty_Rec_Type__c.replace(';',',');
                    }
                }
                if(IND){                   
                    if(rep.ACP_CYPL_Days_since_last_user_update__c != null){
                        days_sincelastUpdate_CY = String.ValueOf(rep.ACP_CYPL_Days_since_last_user_update__c);
                    }
                    if(rep.ACP_CYPL_Opp_Group__c != null && rep.ACP_CYPL_Opp_Group__c != ''){
                        oppGrp_CY = rep.ACP_CYPL_Opp_Group__c.replace(';', ',');   
                    }
                }if(APL){
                    if(rep.ACP_CYPL_aplActivePL__c){
                        aplActive_CY = 'Yes';
                    }else
                        aplActive_CY = 'No';
                }if(MED){                   
                    if(rep.ACP_CYPL_MEDOppStatus__c != null && rep.ACP_CYPL_MEDOppStatus__c != ''){
                        medOppStatus_CY = rep.ACP_CYPL_MEDOppStatus__c.replace(';',',');
                    }                    
                    medPortfolio_CY = rep.ACP_CYPL_MED_Portfolio__c;
                    if(medPortfolio_CY != null && medPortfolio_CY != '')
                        medPortfolio_CY = medPortfolio_CY.trim();
                }if(ADM){
                    if(rep.ACP_CYPL_Phase__c != null && rep.ACP_CYPL_Phase__c != ''){
                        phase_CY = rep.ACP_CYPL_Phase__c.replace(';', ',');
                    }
                }if(DND){                    
                    if(rep.ACP_CYPL_BU_Profit_Center__c != null && rep.ACP_CYPL_BU_Profit_Center__c != ''){
                        buProfitCenter_CY = rep.ACP_CYPL_BU_Profit_Center__c.replace(';',',');
                    }
                }if(CHN){
                    if(rep.ACP_CYPL_DISTRIBUTOR__c != null && rep.ACP_CYPL_DISTRIBUTOR__c != ''){
                        distributor_CY = rep.ACP_CYPL_DISTRIBUTOR__c.replace(';',',');
                    }
                    if(rep.ACP_CYPL_DISTRIBUTOR2__c != null && rep.ACP_CYPL_DISTRIBUTOR2__c != ''){
                        distributor2_CY = rep.ACP_CYPL_DISTRIBUTOR2__c.replace(';',',');
                    }
                }
                //End of CYPL
                
                //Start of NYPL                
                date_NY = rep.ACP_NYPL_Date__c;
                if(date_NY != null)
                    date_NY = date_NY.trim();
                if(IND || CHN){
                    if(rep.ACP_NYPL_Type__c != null && rep.ACP_NYPL_Type__c != ''){
                        type_NY = rep.ACP_NYPL_Type__c.replace(';', ',');
                    }
                    if(rep.ACP_NYPL_Days_since_last_user_update__c != null){
                        days_sincelastUpdate_NY = String.ValueOf(rep.ACP_NYPL_Days_since_last_user_update__c);
                    }
                }
                if(ADM || DND || CHN){
                    if(rep.ACP_NYPL_Oppty_Rec_Type__c != null && rep.ACP_NYPL_Oppty_Rec_Type__c != ''){
                        oppRecordType_NY = rep.ACP_NYPL_Oppty_Rec_Type__c.replace(';',',');
                    }
                }if(IND || ADM || DND || CHN){
                    if(rep.ACP_NYPL_Confidence__c != null && rep.ACP_NYPL_Confidence__c != ''){
                        conf_NY = rep.ACP_NYPL_Confidence__c.replace(';', ',');
                    }
                }
                if(IND || DND || CHN){
                    conf2_NY = rep.ACP_NYPL_Confidence2__c;
                    if(conf2_NY != null && conf2_NY != '')
                        conf2_NY = conf2_NY.trim();
                }
                if(IND || MED || ADM || DND || CHN){
                    wonDate_NY = rep.ACP_NYPL_Won_Date__c;
                    if(wonDate_NY != null && wonDate_NY != '')
                        wonDate_NY = wonDate_NY.trim(); 
                }
                if(IND){
                    if(rep.ACP_NYPL_Process_Status__c != null && rep.ACP_NYPL_Process_Status__c != ''){
                        processStatus_NY = rep.ACP_NYPL_Process_Status__c.replace(';', ',');
                    }
                    if(rep.ACP_NYPL_Opp_Group__c != null && rep.ACP_NYPL_Opp_Group__c != ''){
                        oppGrp_NY = rep.ACP_NYPL_Opp_Group__c.replace(';', ',');
                    }
                }
                if(APL){
                    if(rep.ACP_NYPL_aplActivePL__c){
                        aplActive_NY = 'Yes';
                    }else
                        aplActive_NY = 'No';
                }
                if(MED){                    
                    medPortfolio_NY = rep.ACP_NYPL_MED_Portfolio__c;
                    if(medPortfolio_NY != null && medPortfolio_NY != '')
                        medPortfolio_NY = medPortfolio_NY.trim();
                }
                if(ADM){
                    if(rep.ACP_NYPL_Phase__c != null && rep.ACP_NYPL_Phase__c != ''){
                        phase_NY = rep.ACP_NYPL_Phase__c.replace(';', ',');
                    }
                }
                if(DND){
                    if(rep.ACP_NYPL_BU_Profit_Center__c != null && rep.ACP_NYPL_BU_Profit_Center__c != ''){
                        buProfitCenter_NY = rep.ACP_NYPL_BU_Profit_Center__c.replace(';',',');
                    }
                }
                if(CHN){
                    if(rep.ACP_NYPL_Opportunity_Record_Type2__c != null && rep.ACP_NYPL_Opportunity_Record_Type2__c != ''){
                        oppRecordType2_NY = rep.ACP_NYPL_Opportunity_Record_Type2__c.replace(';',',');
                    }
                    if(rep.ACP_NYPL_DISTRIBUTOR__c != null && rep.ACP_NYPL_DISTRIBUTOR__c != ''){
                        distributor_NY = rep.ACP_NYPL_DISTRIBUTOR__c.replace(';',',');
                    }
                    if(rep.ACP_NYPL_DISTRIBUTOR2__c != null && rep.ACP_NYPL_DISTRIBUTOR2__c != ''){
                        distributor2_NY = rep.ACP_NYPL_DISTRIBUTOR2__c.replace(';',',');
                    }
                    if(rep.ACP_NYPL_Days_since_last_user_update2__c != null){
                        days_sincelastUpdate2_NY = String.ValueOf(rep.ACP_NYPL_Days_since_last_user_update2__c);
                    }
                }
                //End of NYPL
                
                //Start of 5YPL
                date_5Y = rep.ACP_5YPL_Date__c;
                if(date_5Y != null && date_5Y != '')
                    date_5Y = date_5Y.trim();
                if(IND || CHN){
                    if(rep.ACP_5YPL_Type__c != null && rep.ACP_5YPL_Type__c != ''){
                        type_5Y = rep.ACP_5YPL_Type__c.replace(';', ',');
                    }
                    if(rep.ACP_5YPL_Days_since_last_user_update__c != null){
                        days_sincelastUpdate_5Y = String.ValueOf(rep.ACP_5YPL_Days_since_last_user_update__c);
                    }
                }
                if(IND || ADM || DND || CHN){
                    if(rep.ACP_5YPL_Confidence__c != null && rep.ACP_5YPL_Confidence__c != ''){
                        conf_5Y = rep.ACP_5YPL_Confidence__c.replace(';', ',');
                    }
                }
                if(IND || DND || CHN){
                    conf2_5Y = rep.ACP_5YPL_Confidence2__c;
                    if(conf2_5Y != null && conf2_5Y != '')
                        conf2_5Y = conf2_5Y.trim();
                }
                if(IND || MED || ADM || DND || CHN){
                    wonDate_5Y = rep.ACP_5YPL_Won_Date__c;
                    if(wonDate_5Y != null && wonDate_5Y != '')
                        wonDate_5Y = wonDate_5Y.trim();                    
                }
                if(ADM || DND || CHN){
                    if(rep.ACP_5YPL_Oppty_Rec_Type__c != null && rep.ACP_5YPL_Oppty_Rec_Type__c != ''){
                        oppRecordType_5Y = rep.ACP_5YPL_Oppty_Rec_Type__c.replace(';',',');
                    }
                }
                if(IND){
                    if(rep.ACP_5YPL_Process_Status__c != null && rep.ACP_5YPL_Process_Status__c != ''){
                        processStatus_5Y = rep.ACP_5YPL_Process_Status__c.replace(';', ',');
                    }
                    if(rep.ACP_5YPL_Opp_Group__c != null && rep.ACP_5YPL_Opp_Group__c != ''){
                        oppGrp_5Y = rep.ACP_5YPL_Opp_Group__c.replace(';', ',');
                    }
                }
                if(APL){
                    if(rep.ACP_5YPL_aplActivePL__c){
                        aplActive_5Y = 'Yes';
                    }else
                        aplActive_5Y = 'No';
                }
                if(MED){                    
                    medPortfolio_5Y = rep.ACP_5YPL_MED_Portfolio__c;
                    if(medPortfolio_5Y != null && medPortfolio_5Y != '')
                        medPortfolio_5Y = medPortfolio_5Y.trim();
                }
                if(ADM){
                    if(rep.ACP_5YPL_Phase__c != null && rep.ACP_5YPL_Phase__c != ''){
                        phase_5Y = rep.ACP_5YPL_Phase__c.replace(';', ',');
                    }                    
                }
                if(DND){
                    if(rep.ACP_5YPL_BU_Profit_Center__c != null && rep.ACP_5YPL_BU_Profit_Center__c != ''){
                        buProfitCenter_5Y = rep.ACP_5YPL_BU_Profit_Center__c.replace(';',',');
                    }
                }
                if(CHN){
                    if(rep.ACP_5YPL_Opportunity_Record_Type2__c != null && rep.ACP_5YPL_Opportunity_Record_Type2__c != ''){
                        oppRecordType2_5Y = rep.ACP_5YPL_Opportunity_Record_Type2__c.replace(';',',');
                    }
                    if(rep.ACP_5YPL_DISTRIBUTOR__c != null && rep.ACP_5YPL_DISTRIBUTOR__c != ''){
                        distributor_5Y = rep.ACP_5YPL_DISTRIBUTOR__c.replace(';',',');
                    }
                    if(rep.ACP_5YPL_DISTRIBUTOR2__c != null && rep.ACP_5YPL_DISTRIBUTOR2__c != ''){
                        distributor2_5Y = rep.ACP_5YPL_DISTRIBUTOR2__c.replace(';',',');
                    }
                    if(rep.ACP_5YPL_Days_since_last_user_update2__c != null){
                        days_sincelastUpdate2_5Y = String.ValueOf(rep.ACP_5YPL_Days_since_last_user_update2__c);
                    }
                }
                //End of 5YPL
            }
            oppTAMRevRecords = [select id, ACP_CBC__c, ACP_Conversion_current_YTD__c, ACP_L12M_Lost_1Yvalue__c, ACP_L12M_Won_1Y_Value__c, ACP_Pipeline_4Q_rolling__c, ACP_CY_Pipeline__c, ACP_NY_Pipeline__c, ACP_X5Y_Pipeline__c from ACP_Opportunity_TAM_Revenue__c where Id =: oppTamRevRecordId];
            System.Debug('oppTAMRevRecords size' + oppTAMRevRecords.size());
            if (oppTAMRevRecords.size() > 0) {
                for (ACP_Opportunity_TAM_Revenue__c rev: oppTAMRevRecords) {
                    oppTAMRevRec = new List < ACP_Opportunity_TAM_Revenue__c > ();
                    oppTAMRevRec.add(rev);
                    getReportIds(oppTAMRevRec);
                }
            }
        } catch (Exception e) {
            ErrorLogging.Log(e, 'ACP_Opportunity_Data_Automation_Ctrl', 'updateRecords', acpId);
            ApexPages.addMessages(e);
        }
        return null;
    }
    
    public Pagereference reloadThePage(){
        PageReference pageref = new PageReference('/apex/ACP_Performance_Analytics_Page?acpid=' + acpId + '#MrktCompDetail');
        pageref.setRedirect(true);
        return pageref;
    }
    
    //getReportIds(), this method is to query the "Opportunity TAM Report" object, and to get all the filter values alogn with Report Id's
    //Each report will get executed based on the values defined in the "Opportunity TAM Report" object.
    public void getReportIds(List < ACP_Opportunity_TAM_Revenue__c > oppTAMRec) {
        String product;
        List < String > productArry = new List < String > ();
        String CBCType;
        String CBCValue;
        
        String soql;
        String whereoption;
        String accountId;
        String code;
        
        List < ACP_Opportunity_TAM_Revenue__c > updateOppTamRec = new List < ACP_Opportunity_TAM_Revenue__c > ();
        try {
            for (ACP_Opportunity_TAM_Revenue__c rec: oppTAMRec) {
                product = rec.ACP_CBC__c; // get the product name
                productArry = product.split(' - ', 3); // split into 3 parts
                CBCType = productArry[0];
                CBCValue = productArry[1];
            }
            
            if(recordType != null){
                soql = 'select ACP_Conversion__c, ACP_L12_Lost__c, ACP_L12_Won__c, ACP_Pipeline__c, ACP_CY_Pipeline__c, ACP_NY_Pipeline__c, ACP_X5Y_Pipeline__c from ACP_Oppty_TAM_Report__c where recordtypeid=\''+recordType.id+'\' order by createdDate DESC limit 1';
            }
            
            System.Debug('soql :- '+soql);
            List < ACP_Oppty_TAM_Report__c > otReport = new List < ACP_Oppty_TAM_Report__c > ();
            
            if(soql != null){
                otReport = Database.query(soql);
                System.Debug('otReport : ' + otReport);
            }
            
            ID report1;
            ID report2;
            ID report3;
            ID report4;
            ID report5;
            ID report6;
            ID report7;
            
            //report Id's has been stored in respective varilables
            if (otReport.size() > 0) {
                report1 = otReport[0].ACP_Pipeline__c;
                report2 = otReport[0].ACP_Conversion__c;
                report3 = otReport[0].ACP_L12_Lost__c;
                report4 = otReport[0].ACP_L12_Won__c;                
                report5 = otReport[0].ACP_CY_Pipeline__c;
                report6 = otReport[0].ACP_NY_Pipeline__c;
                report7 = otReport[0].ACP_X5Y_Pipeline__c;
            }
            
            Reports.SummaryValue pipeline;
            Reports.SummaryValue conv;
            Reports.SummaryValue lost;
            Reports.SummaryValue won;            
            Reports.SummaryValue cyPipeline;
            Reports.SummaryValue nyPipeline;
            Reports.SummaryValue five5yPipeline; 
            
            if(report1 != null){
                PL4QReport = true;
                ConvReport = false;
                LostReport = false;
                WonReport = false; 
                CYReport = false;
                NYReport = false;
                Five5YReport = false;
                pipeline = runReport(CBCType, CBCValue, aPlan.Account_Plan_Type__c, aPlan.ACP_GAMCode__c,aPlan.ACP_KAMCode__c,aPlan.ACP_WWAcNo__c, aPlan.ACP_Account_Name__r.Id, report1);
            }
            if(report2 != null){
                ConvReport = true;
                PL4QReport = false;
                
                LostReport = false;
                WonReport = false; 
                CYReport = false;
                NYReport = false;
                Five5YReport = false;
                conv = runReport(CBCType, CBCValue, aPlan.Account_Plan_Type__c, aPlan.ACP_GAMCode__c,aPlan.ACP_KAMCode__c,aPlan.ACP_WWAcNo__c, aPlan.ACP_Account_Name__r.Id, report2);
            }
            if(report3 != null){
                LostReport = true;
                PL4QReport = false;
                ConvReport = false;
                
                WonReport = false; 
                CYReport = false;
                NYReport = false;
                Five5YReport = false;
                lost = runReport(CBCType, CBCValue, aPlan.Account_Plan_Type__c, aPlan.ACP_GAMCode__c,aPlan.ACP_KAMCode__c,aPlan.ACP_WWAcNo__c, aPlan.ACP_Account_Name__r.Id, report3);
            }
            if(report4 != null){
                PL4QReport = false;
                ConvReport = false;
                LostReport = false;
                WonReport = true; 
                CYReport = false;
                NYReport = false;
                Five5YReport = false;
                won = runReport(CBCType, CBCValue, aPlan.Account_Plan_Type__c, aPlan.ACP_GAMCode__c,aPlan.ACP_KAMCode__c,aPlan.ACP_WWAcNo__c, aPlan.ACP_Account_Name__r.Id, report4);
            }
            if(report5 != null){ 
                PL4QReport = false;
                ConvReport = false;
                LostReport = false;
                WonReport = false; 
                CYReport = true;
                NYReport = false;
                Five5YReport = false;
                cyPipeline = runReport(CBCType, CBCValue, aPlan.Account_Plan_Type__c, aPlan.ACP_GAMCode__c,aPlan.ACP_KAMCode__c,aPlan.ACP_WWAcNo__c, aPlan.ACP_Account_Name__r.Id, report5);
            }
            if(report6 != null){
                PL4QReport = false;
                ConvReport = false;
                LostReport = false;
                WonReport = false; 
                CYReport = false;
                NYReport = true;
                Five5YReport = false;
                nyPipeline = runReport(CBCType, CBCValue, aPlan.Account_Plan_Type__c, aPlan.ACP_GAMCode__c,aPlan.ACP_KAMCode__c,aPlan.ACP_WWAcNo__c, aPlan.ACP_Account_Name__r.Id, report6);
            }
            if(report7 != null){
                PL4QReport = false;
                ConvReport = false;
                LostReport = false;
                WonReport = false; 
                CYReport = false;
                NYReport = false;
                Five5YReport = true;
                five5yPipeline = runReport(CBCType, CBCValue, aPlan.Account_Plan_Type__c, aPlan.ACP_GAMCode__c,aPlan.ACP_KAMCode__c,aPlan.ACP_WWAcNo__c, aPlan.ACP_Account_Name__r.Id, report7);
            }  
            
            System.Debug('conv is :- ' + conv );
            System.Debug('lost is :- ' + lost );
            System.Debug('won is :- ' + won );
            System.Debug('pipeline is :- ' + pipeline);
            System.Debug('cyPipeline is :- ' + cyPipeline);
            System.Debug('nyPipeline is :- ' + nyPipeline);
            System.Debug('five5yPipeline is :- ' + five5yPipeline);
            
            
            /* String specialChars = ',';
            String speUSDChars = 'USD '; 
            
            for(integer i=0; i<specialChars.split('|').size(); i++){
                if(cyPipeline != null && cyPipeline != ''){
                    cyPipeline = cyPipeline.replace(specialChars.split('|')[i], '');
                }
                if(nyPipeline != null && nyPipeline != ''){
                    nyPipeline = nyPipeline.replace(specialChars.split('|')[i], '');
                }
                if(five5yPipeline!= null && five5yPipeline != ''){
                    five5yPipeline = five5yPipeline.replace(specialChars.split('|')[i], '');
                }
            }
            for(integer i=0; i<speUSDChars.split('|').size(); i++){
                if(cyPipeline != null && cyPipeline != ''){
                    cyPipeline = cyPipeline.replace(speUSDChars.split('|')[i],'');
                }
                if(nyPipeline != null && nyPipeline != ''){
                    nyPipeline = nyPipeline.replace(speUSDChars.split('|')[i],'');
                }
                if(five5yPipeline!= null && five5yPipeline != ''){
                    five5yPipeline = five5yPipeline.replace(speUSDChars.split('|')[i],'');
                }
            } */
            System.Debug('cyPipeline:- ' + cyPipeline);
            System.Debug('nyPipeline :- ' + nyPipeline);
            System.Debug('five5yPipeline :- ' + five5yPipeline);     
            
            //get the grand totals from the reports and update in "Opportunity TAM Revenue" object            
            for (ACP_Opportunity_TAM_Revenue__c rec: oppTAMRec) {
                if(conv != null && conv.getLabel() != ''){
                    rec.ACP_Conversion_current_YTD__c = conv.getLabel();
                }
                if(lost != null && lost.getLabel() != ''){
                    rec.ACP_L12M_Lost_1Yvalue__c = lost.getLabel();
                }
                if(won != null &&  won.getLabel() != ''){
                    rec.ACP_L12M_Won_1Y_Value__c = won.getLabel();
                }
                if(pipeline != null && pipeline.getLabel() != ''){
                    rec.ACP_Pipeline_4Q_rolling__c = pipeline.getLabel();
                }
                if(cyPipeline != null && cyPipeline.getLabel() != ''){
                    rec.ACP_CY_Pipeline__c = (Decimal)cyPipeline.getValue();
                }
                if(nyPipeline != null && nyPipeline.getLabel() != ''){
                    rec.ACP_NY_Pipeline__c = (Decimal)nyPipeline.getValue();
                }
                if(five5yPipeline != null && five5yPipeline.getLabel() != ''){
                    rec.ACP_X5Y_Pipeline__c = (Decimal)five5yPipeline.getValue();
                }
                
                updateOppTamRec.add(rec);
            }
            System.Debug('updateOppTamRec :- '+updateOppTamRec);
            update updateOppTamRec;
            
        } catch (Exception e) {
            ErrorLogging.Log(e, 'ACP_Opportunity_Data_Automation_Ctrl', 'getReportIds', acpId);
            ApexPages.addMessages(e);
        }
    }
    //below method to assign the values to respective filters, then to run the report, and then to get the Grand total
    public Reports.SummaryValue runReport(String cbctype, String cbcvalue, String actPType, String gamCode, String kamCode, String wwCode, Id accountId, ID reportId) {
        try {
            Report report = Database.query('SELECT Id, Developername, format FROM Report WHERE ID =: reportId');
            
            Reports.reportResults results;
            // Get the report metadata
            Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport((String) report.Id);
            Reports.ReportMetadata reportMd = describe.getReportMetadata();
            
            List < Reports.ReportFilter > filters = new List < Reports.ReportFilter > ();
            filters = reportMd.getReportFilters();
            
            System.Debug('filters.size() : ' +filters.size());
            
            Map <String, Reports.ReportFilter> filterMap = new Map <String, Reports.ReportFilter>();// to store unique filter names            
            Map <String, Reports.ReportFilter> repeatedFiltersMap = new Map <String, Reports.ReportFilter>();//to store repeated filter names
            
            filterMap.clear();
            repeatedFiltersMap.clear();
            //below code is to get the filters and to add them to "filterMap" uniquely, repeated filters will get added to "repeatedFiltersMap"
            for(Integer i=0; i<filters.size() ; i++)
            {
                String key = reportMd.getReportFilters()[i].getColumn();
                if(!filterMap.containsKey(key)){
                    filterMap.put(key, reportMd.getReportFilters()[i]);
                }
                else if(filterMap.containsKey(key)){
                    repeatedFiltersMap.put(key, reportMd.getReportFilters()[i]);          
                }
            }
            
            if(actPType == 'GAM Account' && gamCode != '' && gamCode != null) {
                filterMap.get('Account.GAMCD__c').setValue(gamCode);
            }else if(actPType == 'KAM Account' && kamCode != '' && kamCode != null) {
                filterMap.get('Account.IND_KAM_Code__c').setValue(kamCode);
            }else if(actPType == 'WW Account' && wwCode != '' && wwCode != null) {
                filterMap.get('Account.WWCORPACCT__c').setValue(wwCode);
            }else if(actPType == 'Sold-to Account'  && accountId != null) {
                String str = String.valueOf(accountId);
                accountId = str.substring(0, 15);// Report filter will accept only 15 charecters for ID fields.
                filterMap.get('Account.Id').setValue(accountId);
                System.Debug('4 Four');
            }
            if(cbctype == 'CBC1'){
                filterMap.get('Opportunity_Part__c.CBC_1_Code__c').setValue(cbcvalue); 
            }else if(cbctype == 'CBC2') {
                filterMap.get('Opportunity_Part__c.CBC2_Code__c').setValue(cbcvalue);
            }else if(cbctype == 'CBC3') {
                filterMap.get('Opportunity_Part__c.CBC_3_Code__c').setValue(cbcvalue);
            }            
            
            if(PL4QReport){
                System.Debug('PL4QReport : '+PL4QReport);
                System.Debug('filterMap PL4Q: '+filterMap.keySet());
                if(date_PL4Q != '' && date_PL4Q != null){
                    filterMap.get('Opportunity_Forecast__c.Date__c').setValue(date_PL4Q.trim());
                    //System.Debug('13');
                }
                if(CHN){
                    if(wonDate_PL4Q != '' && wonDate_PL4Q != null){
                        filterMap.get('Opportunity_Part__c.Won_Date__c').setValue(wonDate_PL4Q.trim());
                        System.Debug('11');
                    }
                }
                if(MED || ADM || DND || IND){
                    if(wonDate_PL4Q != '' && wonDate_PL4Q != null){
                        filterMap.get('Opportunity.Won_Date__c').setValue(wonDate_PL4Q.trim());
                    }
                }
                if(IND || ADM || DND || CHN){
                    if(conf_PL4Q != '' && conf_PL4Q != null){
                        filterMap.get('Opportunity_Part__c.Status__c').setValue(conf_PL4Q);
                        //System.Debug('12');
                    }
                }
                if(ADM || DND || CHN){
                    if(oppRecordType_PL4Q != '' && oppRecordType_PL4Q != null){
                        filterMap.get('Opportunity.RecordType').setValue(oppRecordType_PL4Q);
                    }
                }
                if(IND || CHN){
                    if(days_sincelastUpdate_PL4Q != null){
                        filterMap.get('Opportunity.Days_since_last_user_update__c').setValue(days_sincelastUpdate_PL4Q.trim());
                        System.Debug('10');
                    }
                                        if(type_PL4Q != '' && type_PL4Q != null){
                        filterMap.get('Opportunity.Type').setValue(type_PL4Q);
                        //System.Debug('9');
                    }
                }
                if(IND){
                    if(processStatus_PL4Q != '' && processStatus_PL4Q != null){
                        filterMap.get('Opportunity_Part__c.Process_Status__c').setValue(processStatus_PL4Q);
                        //System.Debug('8');
                    }
                    
                    if(oppGrp_PL4Q != '' && oppGrp_PL4Q != null){
                        filterMap.get('Opportunity.Opportunity_Group__c').setValue(oppGrp_PL4Q);
                        //System.Debug('14');
                    }
                }
                if(APL){
                    if(aplActive_PL4Q == 'Yes'){
                        filterMap.get('Opportunity_Part__c.APL_Active_Pipeline__c').setValue(aplActive_PL4Q);
                        //System.Debug('16');
                    }
                    filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(userBU);    
                    //System.Debug('17');
                }
                if(MED){
                    filterMap.get('Opportunity.Owner.GIBU__c').setValue(userBU);
                    if(medOppStatus_PL4Q != '' && medOppStatus_PL4Q != null){
                        filterMap.get('Opportunity.MED_Opp_Status__c').setValue(medOppStatus_PL4Q);
                    }
                    if(medPortfolio_PL4Q != '' && medPortfolio_PL4Q != null){
                        filterMap.get('Opportunity.MED_Product_Family__c').setValue(medPortfolio_PL4Q);
                    }
                }
                if(ADM){
                    if(phase_PL4Q != '' && phase_PL4Q != null){
                        filterMap.get('Opportunity.StageName').setValue(phase_PL4Q);
                    }
                }
                if(DND){
                    if(buProfitCenter_PL4Q != '' && buProfitCenter_PL4Q != null){
                        filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(buProfitCenter_PL4Q);
                    }
                }
                if(CHN){
                    if(distributor_PL4Q != '' && distributor_PL4Q != null){
                        filterMap.get('Opportunity.Distributor__c').setValue(distributor_PL4Q);
                    }
                }
                if(CHN && repeatedFiltersMap.keySet() != null){
                    if(conf2_PL4Q != '' && conf2_PL4Q != null){
                        reportMd.getReportFilters()[11].setValue(conf2_PL4Q.trim());
                    }
                    if(days_sincelastUpdate2_PL4Q != null){
                        reportMd.getReportFilters()[17].setValue(days_sincelastUpdate2_PL4Q.trim());
                    }
                    if(oppRecordType2_PL4Q != '' && oppRecordType2_PL4Q != null){
                        reportMd.getReportFilters()[14].setValue(oppRecordType2_PL4Q);
                    }
                    if(distributor2_PL4Q != '' && distributor2_PL4Q != null){
                        reportMd.getReportFilters()[16].setValue(distributor2_PL4Q);
                    }
                }
                if(DND && repeatedFiltersMap.keySet() != null){
                    if(conf2_PL4Q != '' && conf2_PL4Q != null){
                        reportMd.getReportFilters()[9].setValue(conf2_PL4Q.trim());
                    }
                    
                }
                if(IND && repeatedFiltersMap.keySet() != null){
                    if(conf2_PL4Q != '' && conf2_PL4Q != null){
                        reportMd.getReportFilters()[14].setValue(conf2_PL4Q.trim());
                    }
                }
            }
            else if(ConvReport){
                System.Debug('ConvReport : '+ConvReport);
                System.Debug('filterMap Conv: '+filterMap.keySet());
                if(CHN || APL){
                    if(wonDate_Conv != '' && wonDate_Conv != null){
                        filterMap.get('Opportunity_Part__c.Won_Date__c').setValue(wonDate_Conv.trim());
                    }
                }
                if(ADM || MED || DND || IND){
                    if(wonDate_Conv != '' && wonDate_Conv != null){
                        filterMap.get('Opportunity.Won_Date__c').setValue(wonDate_Conv.trim());
                    }
                }
                if(IND || APL || CHN){
                    if(processStatus_Conv != '' && processStatus_Conv != null){
                        filterMap.get('Opportunity_Part__c.Process_Status__c').setValue(processStatus_Conv);
                    }
                }
                if(IND || APL || ADM || DND || CHN){
                    if(conf_Conv != '' && conf_Conv != null){
                        filterMap.get('Opportunity_Part__c.Status__c').setValue(conf_Conv);
                    }
                }
                if(IND || CHN){
                    if(type_Conv != '' && type_Conv != null){
                        filterMap.get('Opportunity.Type').setValue(type_Conv);
                    }
                }
                if(IND){                                    
                    if(oppGrp_Conv != '' && oppGrp_Conv != null){
                        filterMap.get('Opportunity.Opportunity_Group__c').setValue(oppGrp_Conv);
                    } 
                }
                if(APL){
                    filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(userBU);
                }
                if(APL || ADM || MED || DND || CHN){
                    if(date_Conv != '' && date_Conv != null){
                        filterMap.get('Opportunity_Forecast__c.Date__c').setValue(date_Conv);
                    }
                }
                if(ADM || DND || CHN){
                    if(oppRecordType_Conv != '' && oppRecordType_Conv != null){
                        filterMap.get('Opportunity.RecordType').setValue(oppRecordType_Conv);
                    }
                }
                if(MED){       
                    filterMap.get('Opportunity.Owner.GIBU__c').setValue(userBU);
                    if(medOppStatus_Conv != '' && medOppStatus_Conv != null){
                        filterMap.get('Opportunity.MED_Opp_Status__c').setValue(medOppStatus_Conv);
                    }
                    if(medPortfolio_Conv != '' && medPortfolio_Conv != null){
                        filterMap.get('Opportunity.MED_Product_Family__c').setValue(medPortfolio_Conv);
                    }                   
                    if(lostDate_Conv != '' && lostDate_Conv != null){
                        filterMap.get('Opportunity_Part__c.Lost_Date__c').setValue(lostDate_Conv.trim());
                    }
                }
                if(ADM){                    
                    if(phase_Conv != '' && phase_Conv != null){
                        filterMap.get('Opportunity.StageName').setValue(phase_Conv);
                    }
                }
                if(DND){         
                    filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(buProfitCenter_Conv);
                }
                                if(CHN){
                    if(distributor_Conv != '' && distributor_Conv != null){
                        filterMap.get('Opportunity.Distributor__c').setValue(distributor_Conv);
                    }
                }
                if(CHN && repeatedFiltersMap.keySet() != null){
                    if(distributor2_Conv != '' && distributor2_Conv != null){
                        reportMd.getReportFilters()[14].setValue(distributor2_Conv);
                    }
                }              
            }
            else if(LostReport){
                System.Debug('LostReport : '+LostReport);
                System.Debug('filterMap Lost: '+filterMap.keySet());
                if((!DND) && lostDate_Lost != '' && lostDate_Lost != null){
                    filterMap.get('Opportunity_Part__c.Lost_Date__c').setValue(lostDate_Lost.trim());
                    System.Debug('10 Ten');
                } 
                if(IND){
                    if(oppGrp_Lost != '' && oppGrp_Lost != null){
                        filterMap.get('Opportunity.Opportunity_Group__c').setValue(oppGrp_Lost);
                        System.Debug('8 Eight');
                    }
                    if(phase_Lost != '' && phase_Lost != null){
                        filterMap.get('Opportunity.StageName').setValue(phase_Lost);
                        System.Debug('9 Nine');
                    }
                }
                if(APL || MED || ADM || DND || CHN){
                    if(date_Lost != '' && date_Lost != null){
                        filterMap.get('Opportunity_Forecast__c.Date__c').setValue(date_Lost.trim());
                    }
                }
                if(APL || ADM || DND){                    
                    if(conf_Lost != '' && conf_Lost != null){
                        filterMap.get('Opportunity_Part__c.Status__c').setValue(conf_Lost);
                    }
                }
                if(APL){
                    filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(userBU);
                }
                if(MED){
                    filterMap.get('Opportunity.Owner.GIBU__c').setValue(userBU);
                    if(wonDate_Lost != '' && wonDate_Lost != null){
                        filterMap.get('Opportunity.Won_Date__c').setValue(wonDate_Lost.trim());
                    }
                    if(medPortfolio_Lost != '' && medPortfolio_Lost != null){
                        filterMap.get('Opportunity.MED_Product_Family__c').setValue(medPortfolio_Lost);
                    }
                }
                if(ADM || DND || CHN){
                    if(oppRecordType_Lost != '' && oppRecordType_Lost != null){
                        filterMap.get('Opportunity.RecordType').setValue(oppRecordType_Lost);
                    }
                }
                if(DND){
                    if(lostDate_Lost != '' && lostDate_Lost != null){
                        filterMap.get('Opportunity.Lost_Date__c').setValue(lostDate_Lost.trim());
                        System.Debug('10 Ten');
                    }
                    if(buProfitCenter_Lost != '' && buProfitCenter_Lost != null){
                        filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(buProfitCenter_Lost);
                    }
                }
                if(CHN){
                                        if(type_Lost != '' && type_Lost != null){
                        filterMap.get('Opportunity.Type').setValue(type_Lost);
                    }
                                        if(distributor_Lost != '' && distributor_Lost != null){
                        filterMap.get('Opportunity.Distributor__c').setValue(distributor_Lost);
                    }
                    if(partConfidence_Lost != '' && partConfidence_Lost != null){
                        filterMap.get('Opportunity_Forecast__c.Part_Confidence__c').setValue(partConfidence_Lost);
                    }
                }
                if(CHN && repeatedFiltersMap.keySet() != null){
                    if(date2_Lost != '' && date2_Lost != null){
                        reportMd.getReportFilters()[14].setValue(date2_Lost);
                    }
                    if(distributor2_Lost != '' && distributor2_Lost != null){
                        reportMd.getReportFilters()[13].setValue(distributor2_Lost);
                    }
                }
            }
            else if(WonReport){
                System.Debug('WonReport : '+WonReport);
                if(CHN || APL){
                    if(wonDate_Won != '' && wonDate_Won != null){
                        filterMap.get('Opportunity_Part__c.Won_Date__c').setValue(wonDate_Won.trim());
                    }
                }
                if(IND){
                    if(oppGrp_Won != '' && oppGrp_Won != null){
                        filterMap.get('Opportunity.Opportunity_Group__c').setValue(oppGrp_Won);
                    }
                    if(phase_Won != '' && phase_Won != null){
                        filterMap.get('Opportunity.StageName').setValue(phase_Won);
                    }
                }
                if(APL || MED || ADM || DND || CHN){
                    if(date_Won != '' && date_Won != null){
                        filterMap.get('Opportunity_Forecast__c.Date__c').setValue(date_Won.trim());
                    }
                }
                if(APL){
                    filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(userBU);
                }
                if(APL || ADM || DND){
                    if(conf_Won != '' && conf_Won != null){
                        filterMap.get('Opportunity_Part__c.Status__c').setValue(conf_Won);
                    }
                }
                if(ADM || MED || DND || IND){
                    if(wonDate_Won != '' && wonDate_Won != null){
                        filterMap.get('Opportunity.Won_Date__c').setValue(wonDate_Won.trim());
                    }
                }
                if(APL){
                    if(processStatus_Won != '' && processStatus_Won != null){
                        filterMap.get('Opportunity_Part__c.Process_Status__c').setValue(processStatus_Won);
                    }
                }
                if(MED || ADM || DND || CHN){
                    if(date_Won != '' && date_Won != null){
                        filterMap.get('Opportunity_Forecast__c.Date__c').setValue(date_Won.trim());
                    }
                }
                if(MED){
                    filterMap.get('Opportunity.Owner.GIBU__c').setValue(userBU);
                    if(medPortfolio_Won != '' && medPortfolio_Won != null){
                        filterMap.get('Opportunity.MED_Product_Family__c').setValue(medPortfolio_Won);
                    }
                }
                if(ADM || DND || CHN){
                    if(oppRecordType_Won != '' && oppRecordType_Won != null){
                        filterMap.get('Opportunity.RecordType').setValue(oppRecordType_Won);
                    }
                }
                if(MED || ADM){                    
                    if(lostDate_Won != '' && lostDate_Won != null){
                        filterMap.get('Opportunity_Part__c.Lost_Date__c').setValue(lostDate_Won.trim());
                    }
                }
                if(DND){
                    if(buProfitCenter_Won != '' && buProfitCenter_Won != null){
                        filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(buProfitCenter_Won);
                    }
                }
                if(CHN){
                                        if(type_Won != '' && type_Won != null){
                        filterMap.get('Opportunity.Type').setValue(type_Won);
                    }
                                        if(distributor_Won != '' && distributor_Won != null){
                        filterMap.get('Opportunity.Distributor__c').setValue(distributor_Won);
                    }
                    if(partConfidence_Won != '' && partConfidence_Won != null){
                        filterMap.get('Opportunity_Forecast__c.Part_Confidence__c').setValue(partConfidence_Won);
                    }
                }
                if(CHN && repeatedFiltersMap.keySet() != null){
                    if(date2_Won != '' && date2_Won != null){
                        reportMd.getReportFilters()[14].setValue(date2_Won);
                    }
                    if(distributor2_Won != '' && distributor2_Won != null){
                        reportMd.getReportFilters()[13].setValue(distributor2_Won);
                    }
                }
                
            }
            else if(CYReport){
                System.Debug('CYReport : '+CYReport);
                if(date_CY != '' && date_CY != null){
                    filterMap.get('Opportunity_Forecast__c.Date__c').setValue(date_CY.trim());
                }
                if(CHN){
                    if(wonDate_CY != '' && wonDate_CY != null){
                        filterMap.get('Opportunity_Part__c.Won_Date__c').setValue(wonDate_CY.trim());
                    }
                                        if(processStatus_CY != '' && processStatus_CY != null){
                        filterMap.get('Opportunity_Part__c.Process_Status__c').setValue(processStatus_CY);
                    }
                    if(type_CY != '' && type_CY != null){
                        filterMap.get('Opportunity.Type').setValue(type_CY);
                    }
                }
                if(IND || ADM || DND || CHN){
                    if(conf_CY != '' && conf_CY != null){
                        filterMap.get('Opportunity_Part__c.Status__c').setValue(conf_CY);
                    } 
                }
                if(MED || ADM || DND || IND){
                    if(wonDate_CY != '' && wonDate_CY != null){
                        filterMap.get('Opportunity.Won_Date__c').setValue(wonDate_CY.trim());
                    }
                }
                if(IND){                    
                    if(days_sincelastUpdate_CY != null){
                        filterMap.get('Opportunity.Days_since_last_user_update__c').setValue(days_sincelastUpdate_CY.trim());
                    }                  
                    if(oppGrp_CY != '' && oppGrp_CY != null){
                        filterMap.get('Opportunity.Opportunity_Group__c').setValue(oppGrp_CY);
                    }
                }if(APL){
                    filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(userBU);
                }
                if(APL){
                    if(aplActive_CY == 'Yes'){
                        filterMap.get('Opportunity_Part__c.APL_Active_Pipeline__c').setValue(aplActive_CY);
                    }                    
                }
                if(MED){
                    filterMap.get('Opportunity.Owner.GIBU__c').setValue(userBU);
                    if(medOppStatus_CY != '' && medOppStatus_CY != null){
                        filterMap.get('Opportunity.MED_Opp_Status__c').setValue(medOppStatus_CY);
                    }
                    if(medPortfolio_CY != '' && medPortfolio_CY != null){
                        filterMap.get('Opportunity.MED_Product_Family__c').setValue(medPortfolio_CY);
                    }
                }
                if(ADM || DND || CHN){
                    if(oppRecordType_CY != '' && oppRecordType_CY != null){
                        filterMap.get('Opportunity.RecordType').setValue(oppRecordType_CY);
                    }
                }
                if(ADM){                    
                    if(phase_CY != '' && phase_CY != null){
                        filterMap.get('Opportunity.StageName').setValue(phase_CY);
                    }
                }else if(DND){               
                    if(buProfitCenter_CY != '' && buProfitCenter_CY != null){
                        filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(buProfitCenter_CY);
                    }
                }
                if(IND && repeatedFiltersMap.keySet() != null){
                    if(conf2_CY != '' && conf2_CY != null){
                        reportMd.getReportFilters()[14].setValue(conf2_CY.trim());
                    }
                }
                if(DND && repeatedFiltersMap.keySet() != null){
                    if(conf2_CY != '' && conf2_CY != null){
                        reportMd.getReportFilters()[9].setValue(conf2_CY.trim());
                    }
                }
                                if(CHN){
                                        if(distributor_CY != '' && distributor_CY != null){
                        filterMap.get('Opportunity.Distributor__c').setValue(distributor_CY);
                    }
                                }
                if(CHN && repeatedFiltersMap.keySet() != null){
                    if(distributor2_CY != '' && distributor2_CY != null){
                        reportMd.getReportFilters()[14].setValue(distributor2_CY);
                    }
                }
            }
            else if(NYReport){
                System.Debug('NYReport : '+NYReport);
                if(date_NY != '' && date_NY != null){
                    filterMap.get('Opportunity_Forecast__c.Date__c').setValue(date_NY.trim());
                }
                if(CHN){
                    if(wonDate_NY != '' && wonDate_NY != null){
                        filterMap.get('Opportunity_Part__c.Won_Date__c').setValue(wonDate_NY.trim());
                    }
                                        if(type_NY != '' && type_NY != null){
                        filterMap.get('Opportunity.Type').setValue(type_NY);
                    }
                    if(days_sincelastUpdate_NY != null){
                        filterMap.get('Opportunity.Days_since_last_user_update__c').setValue(days_sincelastUpdate_NY.trim());
                    }
                }
                if(MED || ADM || DND || IND){
                    if(wonDate_NY != '' && wonDate_NY != null){
                        filterMap.get('Opportunity.Won_Date__c').setValue(wonDate_NY.trim());
                    }
                }
                if(IND || ADM || DND || CHN){
                    if(conf_NY != '' && conf_NY != null){
                        filterMap.get('Opportunity_Part__c.Status__c').setValue(conf_NY);
                    }   
                }
                if(IND){
                    if(processStatus_NY != '' && processStatus_NY != null){
                        filterMap.get('Opportunity_Part__c.Process_Status__c').setValue(processStatus_NY);
                    }                    
                    if(oppGrp_NY != '' && oppGrp_NY != null){
                        filterMap.get('Opportunity.Opportunity_Group__c').setValue(oppGrp_NY);
                    }  
                }
                if(APL){
                    filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(userBU);
                }
                if(APL){
                    if(aplActive_NY == 'Yes'){
                        filterMap.get('Opportunity_Part__c.APL_Active_Pipeline__c').setValue(aplActive_NY);
                    }                    
                }
                if(MED){  
                    filterMap.get('Opportunity.Owner.GIBU__c').setValue(userBU);
                    if(medPortfolio_NY != '' && medPortfolio_NY != null){
                        filterMap.get('Opportunity.MED_Product_Family__c').setValue(medPortfolio_NY);
                    }
                }
                if(ADM || DND || CHN){
                    if(oppRecordType_NY != '' && oppRecordType_NY != null){
                        filterMap.get('Opportunity.RecordType').setValue(oppRecordType_NY);
                    }
                }
                if(ADM){                    
                    if(phase_NY != '' && phase_NY != null){
                        filterMap.get('Opportunity.StageName').setValue(phase_NY);
                    }
                }
                if(DND){
                    if(buProfitCenter_NY != '' && buProfitCenter_NY != null){
                        filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(buProfitCenter_NY);
                    }
                }
                if(IND && repeatedFiltersMap.keySet() != null){
                    if(conf2_NY != '' && conf2_NY != null){
                        reportMd.getReportFilters()[14].setValue(conf2_NY.trim());
                    }
                }
                if(DND && repeatedFiltersMap.keySet() != null){
                    if(conf2_NY != '' && conf2_NY != null){
                        reportMd.getReportFilters()[9].setValue(conf2_NY.trim());
                    }
                }
                                if(CHN){
                                        if(distributor_NY != '' && distributor_NY != null){
                        filterMap.get('Opportunity.Distributor__c').setValue(distributor_NY);
                    }
                                }
                if(CHN && repeatedFiltersMap.keySet() != null){
                    if(conf2_NY != '' && conf2_NY != null){
                        reportMd.getReportFilters()[11].setValue(conf2_NY.trim());
                    }
                    if(days_sincelastUpdate2_NY != null){
                        reportMd.getReportFilters()[17].setValue(days_sincelastUpdate2_NY.trim());
                    }
                    if(oppRecordType2_NY != '' && oppRecordType2_NY != null){
                        reportMd.getReportFilters()[14].setValue(oppRecordType2_NY);
                    }
                    if(distributor2_NY != '' && distributor2_NY != null){
                        reportMd.getReportFilters()[16].setValue(distributor2_NY);
                    }
                }
            }
            else if(Five5YReport){
                System.Debug('Five5YReport : '+Five5YReport);
                if(date_5Y != '' && date_5Y != null){
                    filterMap.get('Opportunity_Forecast__c.Date__c').setValue(date_5Y.trim());
                }
                if(IND || CHN){
                    if(type_5Y != '' && type_5Y != null){
                        filterMap.get('Opportunity.Type').setValue(type_5Y);
                    }
                                        if(days_sincelastUpdate_5Y != null){
                        filterMap.get('Opportunity.Days_since_last_user_update__c').setValue(days_sincelastUpdate_5Y);
                    } 
                    
                }
                
                if(CHN)
                {
                    if(wonDate_5Y != '' && wonDate_5Y != null){
                        filterMap.get('Opportunity_Part__c.Won_Date__c').setValue(wonDate_5Y);
                    }
                }
                
                if(MED || ADM || DND || IND){
                    if(wonDate_5Y != '' && wonDate_5Y != null){
                        filterMap.get('Opportunity.Won_Date__c').setValue(wonDate_5Y.trim());
                    }
                }
                if(IND || ADM || DND || CHN){
                    if(conf_5Y != '' && conf_5Y != null){
                        filterMap.get('Opportunity_Part__c.Status__c').setValue(conf_5Y);
                    }
                }
                if(IND){
                    if(processStatus_5Y != '' && processStatus_5Y != null){
                        filterMap.get('Opportunity_Part__c.Process_Status__c').setValue(processStatus_5Y);
                    }
                    if(oppGrp_5Y != '' && oppGrp_5Y != null){
                        filterMap.get('Opportunity.Opportunity_Group__c').setValue(oppGrp_5Y);
                    }
                }
                if(ADM || DND || CHN){
                    if(oppRecordType_5Y != '' && oppRecordType_5Y != null){
                        filterMap.get('Opportunity.RecordType').setValue(oppRecordType_5Y);
                    }
                }
                if(APL){
                    if(aplActive_5Y == 'Yes'){
                        filterMap.get('Opportunity_Part__c.APL_Active_Pipeline__c').setValue(aplActive_5Y);
                    }
                    filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(userBU);
                }
                if(MED){
                    filterMap.get('Opportunity.Owner.GIBU__c').setValue(userBU);
                    
                    if(medPortfolio_5Y != '' && medPortfolio_5Y != null){
                        filterMap.get('Opportunity.MED_Product_Family__c').setValue(medPortfolio_5Y);
                    }                    
                }
                if(ADM){                    
                    if(phase_5Y != '' && phase_5Y != null){
                        filterMap.get('Opportunity.StageName').setValue(phase_5Y);
                    }
                }
                if(DND){             
                    if(buProfitCenter_5Y != '' && buProfitCenter_5Y != null){                           
                        filterMap.get('Opportunity_Part__c.BU_profit_center__c').setValue(buProfitCenter_5Y);
                    }
                }
                if(IND && repeatedFiltersMap.keySet() != null){
                    if(conf2_5Y != '' && conf2_5Y != null){
                        reportMd.getReportFilters()[14].setValue(conf2_5Y.trim());
                    }
                }
                if(DND && repeatedFiltersMap.keySet() != null){
                    if(conf2_5Y != '' && conf2_5Y != null){
                        reportMd.getReportFilters()[9].setValue(conf2_5Y.trim());
                    }
                }
                                if(CHN){
                                        if(distributor_5Y != '' && distributor_5Y != null){
                        filterMap.get('Opportunity.Distributor__c').setValue(distributor_5Y);
                    }
                                }
                if(CHN && repeatedFiltersMap.keySet() != null){
                    if(conf2_5Y != '' && conf2_5Y != null){
                        reportMd.getReportFilters()[11].setValue(conf2_5Y.trim());
                    }
                    if(days_sincelastUpdate2_5Y != null){
                        reportMd.getReportFilters()[17].setValue(days_sincelastUpdate2_5Y.trim());
                    }
                    if(oppRecordType2_5Y != '' && oppRecordType2_5Y != null){
                        reportMd.getReportFilters()[14].setValue(oppRecordType2_5Y);
                    }
                    if(distributor2_5Y != '' && distributor2_5Y != null){
                        reportMd.getReportFilters()[16].setValue(distributor2_5Y);
                    }
                }
            }
            system.debug('results  ---- ' + results);
            results = Reports.ReportManager.runReport((String) report.Id, reportMd, true);
            
            System.Debug('Results : ' + results);
            //below code to verify the filter values in debug logs, whether proper values are assigned or not
            List < Reports.ReportFilter > filterstest = new List < Reports.ReportFilter > ();
            filterstest = results.getReportMetadata().getReportFilters();
            for(Integer i=0; i<filterstest.size() ; i++){
                String key = results.getReportMetadata().getReportFilters()[i].getColumn();
                String value = results.getReportMetadata().getReportFilters()[i].getValue();
                system.debug('===filter=>'+key+' ===Value=>'+value);              
            }
            
            // Get the fact map from the report results
            Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');
            return factDetails.getAggregates()[0];
        } catch (Exception e) {
            ErrorLogging.Log(e, 'ACP_Opportunity_Data_Automation_Ctrl', 'runReport', acpId);
            System.Debug('Line Number : '+ e.getLineNumber() + ' '+e.getMessage());
            ApexPages.addMessages(e);
            return null;
        }   
    }
    
    public pageReference updateMarkRecords() {
        try {
            markCompRecords = [select id, ACP_CBC__c, ACP_LY_Bill__c, ACP_CY_YTD__c, ACP_LY_YTD__c from ACP_Market_and_Competition__c where ACP_Account_Plan__c =: acpId and Id =: MarketId];
            if (markCompRecords != null) {
                getMarketReportIds(markCompRecords);
            }
        } catch (Exception e) {
            ErrorLogging.Log(e, 'ACP_Market_Competition_YBBB_Ctrl', 'updateRecords', acpId);
            ApexPages.addMessages(e);
            
        }
        PageReference pageref = new PageReference('/apex/ACP_Performance_Analytics_Page?acpid=' + acpId + '#MrktCompDetail');
        pageref.setRedirect(true);
        return pageref;
    }
    
    public void getMarketReportIds(ACP_Market_and_Competition__c markCompRec) {
        
        String product;
        List < String > productArry = new List < String > ();
        String CBCType;
        String CBCValue;
        String accountId;
        String code;
        
        try {
            product = markCompRec.ACP_CBC__c; // get the product name
            productArry = product.split(' - ', 3); // split into 3 parts
            CBCType = productArry[0];
            CBCValue = productArry[1];
            
            accountId = aPlan.ACP_Account_Name__c;
            //accountId = accountId.substring(0,15);
            
            if (aPlan.Account_Plan_Type__c == 'GAM Account') {
                code = aPlan.ACP_GAMCode__c;
            } else if (aPlan.Account_Plan_Type__c == 'KAM Account') {
                code = aPlan.ACP_KAMCode__c;
            } else if (aPlan.Account_Plan_Type__c == 'WW Account') {
                code = aPlan.ACP_WWAcNo__c;
            } else if (aPlan.Account_Plan_Type__c == 'Sold-to Account') {
                code = accountId;
            }
            /*    ID ybbreportId;

//  ybbreportId = System.Label.ACP_YBBB_ReportId;
ACP_BBB_Reports__c ybbreportCustSet = ACP_BBB_Reports__c.getValues('Yearly_BBB_Report');
if(ybbreportCustSet != null){
ybbreportId = ybbreportCustSet.ACP_Report_Id__c;
}*/
            String markReportName = 'ACP_Yearly_Billing_Report';
            Reports.ReportFactWithDetails factDetails;
            
            if (markReportName != null) {
            factDetails = marketRunReport(CBCType, CBCValue, aPlan.Account_Plan_Type__c, code, accountId, markReportName);
            }
            
            //get the grand totals from the reports and update in Opp Vs Tam rec            
            
             markCompRec.ACP_LY_Bill__c = (Decimal)factDetails.getAggregates()[0].getValue(); // Store the values in fields at the time of adding/Editing the records
        markCompRec.ACP_CY_YTD__c = (Decimal)factDetails.getAggregates()[1].getValue();
        markCompRec.ACP_LY_YTD__c = (Decimal)factDetails.getAggregates()[2].getValue();
            
            update markCompRec;
            
            
        } catch (Exception e) {
            ErrorLogging.Log(e, 'ACP_Opportunity_Data_Automation_Ctrl', 'getMarketReportIds', acpId);
            ApexPages.addMessages(e);
        }
    }
    
    
        public static Reports.ReportFactWithDetails marketRunReport(String cbctype, String cbcvalue, String actPType, String code, ID accountId, String markReportName) {
        try {
            
            Report report = Database.query('SELECT Id, Developername, format FROM Report WHERE Developername =: markReportName');
            Reports.reportResults results;
            
            // Get the report metadata
            Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport((String) report.Id);
            Reports.ReportMetadata reportMd = describe.getReportMetadata();
            // Add a filter.
            List < Reports.ReportFilter > filters = new List < Reports.ReportFilter > ();
            Reports.ReportFilter filter1 = reportMd.getReportFilters()[0];
            Reports.ReportFilter filter2 = reportMd.getReportFilters()[1];
            Reports.ReportFilter filter3 = reportMd.getReportFilters()[2];
            Reports.ReportFilter filter4 = reportMd.getReportFilters()[3];
            Reports.ReportFilter filter5 = reportMd.getReportFilters()[4];
            Reports.ReportFilter filter6 = reportMd.getReportFilters()[5];
            Reports.ReportFilter filter7 = reportMd.getReportFilters()[6];
            // Reports.ReportFilter filter8 = reportMd.getReportFilters()[7];
            
            if (cbctype == 'CBC1') {
                filter1.setValue(cbcvalue);
                
            } else if (cbctype == 'CBC2') {
                filter2.setValue(cbcvalue);
                
            } else if (cbctype == 'CBC3') {
                filter3.setValue(cbcvalue);
                
            }
            if (actPType == 'GAM Account') {
                filter4.setValue(code);
                
            } else if (actPType == 'KAM Account') {
                filter5.setValue(code);
                
            } else if (actPType == 'WW Account') {
                filter6.setValue(code);
                
            } else if (actPType == 'Sold-to Account') {
                filter7.setValue(accountId);
                
            }
            
            filters.add(filter1);
            filters.add(filter2);
            filters.add(filter3);
            filters.add(filter4);
            filters.add(filter5);
            filters.add(filter6);
            filters.add(filter7);
            
            reportMd.setReportFilters(filters);
            
            results = Reports.ReportManager.runReport((String) report.Id, reportMd, true);
            
            // Get the fact map from the report results
            Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');   
         
            return factDetails;
        } catch (Exception e) {
            ErrorLogging.Log(e, 'ACP_Market_Competition_YBBB_Ctrl', 'marketRunReport', 'acpId');
            ApexPages.addMessages(e);
            return null;
        }
    }
}