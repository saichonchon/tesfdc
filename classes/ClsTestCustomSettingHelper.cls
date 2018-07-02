@isTest 
public class ClsTestCustomSettingHelper
{
    public static void getNDRRedflagreason()
    {
        List<NDR_red_flag_reason__c> lstNDRredflagreason = new List<NDR_red_flag_reason__c>();
        lstNDRredflagreason.add(new NDR_red_flag_reason__c(name = '1',Red_flag_reason__c='Special price setup for the part for the sold to customer in past 36 months'));
        lstNDRredflagreason.add(new NDR_red_flag_reason__c(name = '2',Red_flag_reason__c='Sales exists on this part for the POS or END customer in the past 12 months'));
        insert lstNDRredflagreason;
    }
    
    public static void getTriggerConfigurationSettings() 
    {
        List<Trigger_Configuration__c> lstTrgConfig = new List<Trigger_Configuration__c>();
        lstTrgConfig.add(new Trigger_Configuration__c(Name='Populate Opportunity Partner' ,isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='DND Lead Conversion Initialization' ,isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='Avoid Duplicate PLM Id' ,isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='Identify Fiscal Year' ,isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='updateAccountBusinessUnit', isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='MarketCompetitionDelete', isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='PlatformContentUpdate', isRun__c = true));
        insert lstTrgConfig ;
    }
    
    public static void getCCPTriggerSettings() 
    {
        insert (new CCP_Trigger__c(Name='Skip_Validation' ,Skip_Validation__c = true));
    }
    
    public static void getProfitBUCenterMapping() 
    {
        insert new Profit_BU_Center_Mapping_Rule1__c(Name = '30183', BU_Profit__c = 'A&C');
        list<Profit_BU_Center_Mapping_Rule2__c> lstProfit_BU_Center_Mapping_Rule2 = new list<Profit_BU_Center_Mapping_Rule2__c>();
        
        lstProfit_BU_Center_Mapping_Rule2.add(new Profit_BU_Center_Mapping_Rule2__c(Name = 'Account_IBC_code__c', BU_Profit__c = '038,048,085,084,082,078,080,081,083,076,077,211,203'));
        lstProfit_BU_Center_Mapping_Rule2.add(new Profit_BU_Center_Mapping_Rule2__c(Name = '10600', BU_Profit__c = 'Enterprise Networks'));
        insert lstProfit_BU_Center_Mapping_Rule2;
        insert new Profit_BU_Center_Mapping_Rule3__c(Name = '241', BU_Profit__c = 'Rail');
    }
    
    public static void getForecast_Snapshot_Setup() 
    {
        List<Forecast_Snapshot_Setup__c> lstForecast_Snapshot_Setup = new List<Forecast_Snapshot_Setup__c>();
        lstForecast_Snapshot_Setup.add(new Forecast_Snapshot_Setup__c(name = 'Approval Stage',Value__c='G0 Approved'));
        lstForecast_Snapshot_Setup.add(new Forecast_Snapshot_Setup__c(name = 'Opportunity Stage',Value__c='Won',Final_Stage__c='Production'));
        lstForecast_Snapshot_Setup.add(new Forecast_Snapshot_Setup__c(Name='Channel_Engineering_Opportunity',Value__c='Commit',Final_Stage__c='Production',Opportunity_RecordTypeId__c='012E0000000NImT'));
        lstForecast_Snapshot_Setup.add(new Forecast_Snapshot_Setup__c(Name='Opportunity_Product_Platform',Value__c='Won - Open',Final_Stage__c='Won - Closed',Opportunity_RecordTypeId__c='012E0000000dYse'));
        lstForecast_Snapshot_Setup.add(new Forecast_Snapshot_Setup__c(Name='Channel_Sales_Opportunity',Value__c='Commit',Final_Stage__c='Production',Opportunity_RecordTypeId__c='012E0000000NImU'));
        insert lstForecast_Snapshot_Setup;
    }
    
    public static void getApex_Helper_Settings() 
    {
        List<Apex_Helper_Settings__c> lstApex_Helper_Settings = new List<Apex_Helper_Settings__c>();
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'System Admin Profile Id', Value__c = '00eE0000000VFvYIAW'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Engineering Opportunity CSD Id', Value__c = '00eE0000000VFvYIAW'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Sales Opportunity CSD', Value__c = '00eE0000000VFvYIAW'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'TEIS Admin User Id', Value__c = '005E0000000XIavIAG'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'BU Admin Profile Id', Value__c = '00eE0000000lsks'));  
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Partner Admin Profile Id', Value__c = '00eE0000000mMnLIAU'));  
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Regional Admin Profile Id', Value__c = '00eE0000000lsks'));  
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Service Account Profile Id', Value__c = '00eE00000010myEIAQ'));  
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Unidentified Account for NDR', Value__c = '001E000000hnpVCIAY'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Currency Confirm Except Users', Value__c = '005E0000000XIavIAG'));  
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'APL Oppty Part Process Status Value', Active__c = true,Value__c = 'Concept;Designed;Pre-prod;Production;Ramp-down;EOL'));  
        //lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'System Administrator', Value__c = Userinfo.getUserid(), Active__c = true));  //Archana:commented
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'System Administrator', Value__c ='00eE0000000VFvYIAW', Active__c = true));  //Archana:added
        
        
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'GAM Record Type Id', Value__c = '012E0000000J6k0IAC')); //account
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Account Record Type Id', Value__c = '012E0000000I9EGIA0')); //account
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Forecast Snapshot Part RT Id', Value__c = '012E0000000XrPBIA0')); //part
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Forecast Snapshot Oppy RT Id', Value__c = '012E0000000XrPAIA0')); //Forecast Snapshot
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Appliance Opportunity Record Type Id', Value__c = '012E0000000dYseIAE', Active__c = true)); //opp
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'NDR Opportunity', Value__c = '012E0000000egdDIAQ')); //opp
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'NDR Opportunity Parts', Value__c = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('NDR Opportunity Parts').getRecordTypeId())); //Opportunity Part
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Sales Parts RT Id', Value__c = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Sales Parts').getRecordTypeId())); //Opportunity Part
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'AccountPlan_Snapshot', Value__c = '012E0000000YlLKIA0')); //Account Plan
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Lost Business - Appliances', Value__c = '012E0000000XrBgIAK'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Customer Care Cloud', Value__c = '012E0000000f8tj'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Tender Opportunity Record Type Id', Value__c = '012E0000000XrBb'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'GIBU of Applience', Value__c = 'Appliances'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Sales Opportunity Channel', Value__c = '012E0000000NImU'));
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'DataComm - Customer Care', Value__c = '012E0000000egdDIAQ'));
        
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'DND Oppty Part Process Status Value', Active__c = true, Value__c = 'Concept;Quoted;Designed;On Customer AVL;Prototyped/Sampled;Pre-prod;Production;Ramp-down;EOL'));
        
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Quarterly-4 Month', Value__c = '11')); 
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Quarterly-3 Month', Value__c = '8'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Quarterly-2 Month', Value__c = '5'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Quarterly-1 Month', Value__c = '2'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Quarterly-4 Date', Value__c = '15'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Quarterly-3 Date', Value__c = '15'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Quarterly-2 Date', Value__c = '15'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Quarterly-1 Date', Value__c = '15'));
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'APAC Channel Team', Value__c = '00GE0000001uVZ5'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'APAC Arrow Team', Value__c = '00GE0000002BfxP'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'APAC Avnet Team', Value__c = '00GE0000002BfxU'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'APAC Channel Korea Team', Value__c = '00GE0000002BfxZ'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'APAC Serial Team', Value__c = '00GE0000002Bfxe'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'APAC TTI Team', Value__c = '00GE0000002Bfxj'));
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = '24 Hour Response TIme', value__c = '557E00000004HKRIA2'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = '4 Hour Response Time',Active__c = true,Description__c = 'This value caontains the id of a 4 Hour Response Time milestone type', value__c = '557E00000004HKMIA2'));
        
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'MigrateOppyForecastCurrConvert', Value__c = '15',Active__c = true));
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Customer Care Cloud -Case Close', Value__c = '012E0000000f8ioIAA')); 
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'PIC Service Cloud', Value__c = '012E0000000oPg7')); 
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'PIC Universal Customer Account', Value__c = '001E000001HL83N')); 
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Internal Account', Value__c = '001E000000zdo0s'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'PIC Project Profile List', Value__c = 'Global Admin,Inside Sales,PIC Agents,PIC Germany (Temp solution),PIC RL/Directors,PIC Supervisors Managers')); 
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Customer profile list', Value__c = 'CC Business Analyst,CC Leaders & Directors,CC Global Admin,CC CCP Germany,CC CCP,Customer Care Service Cloud-EMEA,Customer Care Service Cloud,Customer Care Service Account,Customer Care Service Cloud-Germany,CC Supervisor and Managers')); 
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'forecastSnapshotYears', Value__c = '2016;2017', Active__c = true)); 
        Id devRecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Customer Care Task').getRecordTypeId();
        
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Customer Care Task', Value__c = devRecordTypeId));
        
        //added by nelson zheng 2015-10-20
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'APL_Email_Alert_Template',value__c = 'https://c2s.my.salesfroce.come/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Appliance Show Mass Update',value__c = 'TRUE', Active__c = true));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Lead Response RT Id', Value__c = '015E0000000P3MB',Active__c=true));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Lead Event Lead RT Id', Value__c = '015E0000000P3MB',Active__c=true));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Lead Central RT Id', Value__c = '015E0000000P3MB',Active__c=true));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Exclude Oppy Revenue Phase', Value__c ='Dead,Dead - Closed,Lost,Lost - Closed', Active__c = true));  //Anushka:added
        insert lstApex_Helper_Settings;
    } 
    
    public static void getCSDExceptionEmail(){
        CSD_Exception_Email__c eu = new CSD_Exception_Email__c();
        eu.Name = 'Exception User';
        eu.user_Id__c = '005E0000006CX4x';
        insert eu;
    }
    
    public static void getCaseFinalVariables(){
        List<CaseFinalVariables__c> lstCaseFV = new List<CaseFinalVariables__c>();
        lstCaseFV.add(new CaseFinalVariables__c (name='Default', CASE_STATUS_CLOSED_SPAM_STRING__c ='Closed (SPAM)', CASE_STATUS_NEW_STRING__c='New',TE_PIC_STANDART_CASE_RECORD_TYPE_STRING__c='TE_PIC_Standard_Case_Record_Type',CASE_PRIORITY_HIGHT_STRING__c='High',CASE_STATUS_IN_PROGRESS_CUSTOMER_STRING__c='Waiting for Response',TE_PIC_CONTACT_RECORD_TYPE_STRING__c='PIC_Contact') ) ;
        insert lstCaseFV;
    }
    
    
    public static void getWebToCaseStrings(){
        List<WebToCaseStrings__c> lstweb = new List<WebToCaseStrings__c>();
        lstweb.add(new WebToCaseStrings__c(name='Default',welcomeBack__c='Welcome back! Please fill out the rest of this form to submit your message',fillInContact__c='Please fill in additional contact to submit an incident' ));
        insert lstweb;
    }
    
    public static void getConsumer_Device_Opportunity_Record_Types()
    {
        list<Consumer_Device_Opportunity_Record_Types__c> lstCDORT = new list<Consumer_Device_Opportunity_Record_Types__c>();
        lstCDORT.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'OEM', Record_Type_Id__c = '012E0000000eQgJIAU'));
        lstCDORT.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Opportunity_Engineering_Project', Record_Type_Id__c = '012E0000000XrBX'));
        lstCDORT.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Engineering Opportunity-CSD', Record_Type_Id__c = '012E0000000eR0cIAE'));
        lstCDORT.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Sales Opportunity-CSD', Record_Type_Id__c = '012E0000000eR0dIAE'));
        lstCDORT.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Sales_Parts', Record_Type_Id__c = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Sales Parts').getRecordTypeId()));
        lstCDORT.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'New_Development', Record_Type_Id__c = '012E0000000eR0cIAE'));
        lstCDORT.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Engineering_Opportunity_CSD', Record_Type_Id__c = '012E0000000eR0cIAE'));
        lstCDORT.add(new Consumer_Device_Opportunity_Record_Types__c(name = 'Sales_Opportunity_CSD', Record_Type_Id__c = '012E0000000eR0cIAE'));
        insert lstCDORT;
    }
    public static void getOpportunity_Record_Type_Groups()
    {    
        list<Opportunity_Record_Type_Groups__c> lstORTG = new list<Opportunity_Record_Type_Groups__c>();
        //lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity', RecordTypeID__c = '012c00000004tlA'));  //commented by archana
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Opportunity_Engineering_Project', Migration_Record_Type__c = '012E0000000XrBX',RecordTypeID__c = '012E0000000XrBX',Active__c = true,Group__c = 'PMV'));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND_Sales_Project', Migration_Record_Type__c = '012E0000000XrBYIA0',RecordTypeID__c = '012E0000000fCzmIAE',Active__c = true,Group__c = 'PMV'));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND_Engineering_project', Migration_Record_Type__c = '012E0000000XrBXIA0',RecordTypeID__c = '012E0000000fCzrIAE',Active__c = true,Group__c = 'PMV'));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'FS- Engineering Opportunity CSD', Group__c = 'Forecast Snapshot Creation', active__c = true, API_Name__c = 'Engineering_Opportunity_CSD'));
        //lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND_Engineering_project', Group__c = 'PMV', active__c = true, RecordTypeID__c = '012E0000000fCzrIAE', Migration_Record_Type__c = '012E0000000XrBXIA0'));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'PMV', Group__c = 'PMV', active__c = true, RecordTypeID__c = '012E0000000XrBZ'));
        //lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND_Sales_Project', Group__c = 'PMV', active__c = true, RecordTypeID__c = '012E0000000fCzmIAE', Migration_Record_Type__c = '012E0000000XrBYIA0'));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Channel- Engineering Opportunity_EM',RecordTypeID__c = '012E0000000NImT', Group__c = 'Engineering Milestones Opportunities', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Opportunity - Product Platform_EM',RecordTypeID__c = '012E0000000dYse', Group__c = 'Engineering Milestones Opportunities', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'TAM_EM',RecordTypeID__c = '012E0000000XrBb', Group__c = 'Engineering Milestones Opportunities', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Opportunity - Engineering Project_EM',RecordTypeID__c = '012E0000000XrBX', Group__c = 'Engineering Milestones Opportunities', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Engineering Opportunity-CSD_EM',RecordTypeID__c = '012E0000000eR0c', Group__c = 'Engineering Milestones Opportunities', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true)); //Archana : Added
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND-Engineering project Opportunity_EM',RecordTypeID__c = '012E0000000fCzr', Group__c = 'Engineering Milestones Opportunities', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity_EM',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Engineering Milestones Opportunities', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'NDR Opportunity',RecordTypeID__c = '012E0000000egdDIAQ', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'CCR Opportunity',RecordTypeID__c = '0123C000000065gQAA', active__c = true));
        //lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Part Std Price Display on Forecast',RecordTypeID__c = '012E0000000NImT', Group__c = 'Part Std Price Display on Forecast', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Part Std Price Display on Forecast',RecordTypeID__c = '012E0000000XrBY', Group__c = 'Part Std Price Display on Forecast', active__c = true)); //ram
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Change Channel Oppy header level',RecordTypeID__c = '012E0000000eR0c', Group__c = 'Change Channel Opportunities at header level', active__c = true));
        //lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Change Channel Oppy header level',RecordTypeID__c = '012E0000000XrBY', Group__c = 'Change Channel Opportunities at header level', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Engineering Opportunity CSD',RecordTypeID__c = '012E0000000eR0cIAE', Group__c = 'Process Status Display', active__c = true));
        
        //ADM Record type
        RecordType rt2 = ClsTestHelp.createTestRecordType31();
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'ADM',RecordTypeID__c = rt2.Id, Group__c = 'Engineering Milestones Opportunities', active__c = true));         
        insert (new Opportunity_Record_Type_Groups__c(name = 'ADM sales',RecordTypeID__c = rt2.Id, Group__c = 'ADM Group', active__c = true));
        //lstORTG.add(new Opportunity_Record_Type_Groups__c(name = '',RecordTypeID__c = '', Group__c = 'Engineering Milestones Opportunities', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND - Engineering project - UPI', Group__c = 'Enforce Unique Project Id', active__c = true, RecordTypeID__c = '012E0000000fCzrIAE'));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND - Sales Project - UPI', Group__c = 'Enforce Unique Project Id', active__c = true, RecordTypeID__c = '012E0000000fCzmIAE'));
        insert lstORTG;
    }
    
    public static void getOpportunity_Approvers()
    {
        list<Opportunity_Approvers__c> lstOA = new list<Opportunity_Approvers__c>();
        lstOA.add(new Opportunity_Approvers__c(name = 'A&C GPLs 01'));
        lstOA.add(new Opportunity_Approvers__c(name = 'A&C GPLs 02'));
        lstOA.add(new Opportunity_Approvers__c(name = 'IB GPLs'));
        lstOA.add(new Opportunity_Approvers__c(name = 'Rail GPLs'));
        lstOA.add(new Opportunity_Approvers__c(name = 'FilterCenter',Approver_Id__c='005E0000002Hakf'));
        insert lstOA;
    }
    
    public static void getProfit_BU_Center_Mapping_Rule2()
    {
        insert new Profit_BU_Center_Mapping_Rule2__c(name = 'Account_IBC_code__c', BU_Profit__c = '038,048,085,084,082,078,080,083,076,077,211,203');
    }
    
    public static void getRTSMapping()
    {   
        RTSMapping__c oRTSMapping = new RTSMapping__c(name = 'Build Quantity', API_Name__c = 'Build_Quantity__c', Code__c = 'BUILDQTY', isItemAttribute__c = true,  isProgramAttribute__c = false, Object_Name__c = 'Opportunity_Part__c');
        insert oRTSMapping;
    }
    
    public static void getOrgWideSettings()
    {    
        OrgWideSettings__c oOrgWideSettings = new OrgWideSettings__c(name = 'Default', Datatable_Page_Size__c = 200, Enable_Error_Logging__c = true,  Environment__c = 'PROD', Error_Email_Recipients__c = 'rob.dress@te.com; jasmine.ver@te.com', rtsUrl__c = 'http://requesttracking.us.tycoelectronics.com', rtsInterfaceObjectPrefix__c = 'a1K', Search_Result_Limit__c = 200, Send_Exception_Email__c = true);
        insert oOrgWideSettings;
    }
    public static void getParts_Activation_Settings()
    {
        list<Parts_Activation_Settings__c> lstPAS = new list<Parts_Activation_Settings__c>();
        
        lstPAS.add(new Parts_Activation_Settings__c(name = '1', Conditional_Query__c = 'LastModifiedDate = LAST_N_DAYS:180', Object_API_Name__c = 'Opportunity_Part__c', Object_Field_API_Name__c = 'Part__c'));
        lstPAS.add(new Parts_Activation_Settings__c(name = '2', Conditional_Query__c = 'LastModifiedDate = LAST_N_DAYS:180', Object_API_Name__c = 'Opportunity_Part__c', Object_Field_API_Name__c = 'Part__c'));
        lstPAS.add(new Parts_Activation_Settings__c(name = '7', Conditional_Query__c = 'LastModifiedDate = LAST_N_DAYS:180', Object_API_Name__c = 'Opportunity_Part__c', Object_Field_API_Name__c = 'Part__c'));
        insert lstPAS;
    }
    public static void getAllSettings()
    {
        getApex_Helper_Settings();
        getConsumer_Device_Opportunity_Record_Types();
        getOpportunity_Record_Type_Groups();
        getOpportunity_Approvers();
        getProfit_BU_Center_Mapping_Rule2();
        getRTSMapping();
        getOrgWideSettings();
        getParts_Activation_Settings();
        getMonthly_Data_delete();
        getConfiguration();
        getCaseFinalVariables();
        getWebToCaseStrings();
        getCustomer_Care_SharedEmailBox();
        getDD1_Definition();
        getDD2_Definition();
        
    	getAccount_Business_Unit_L2();
         getADM_Territory_Code();
    }
    public static void getCustomer_Care_SharedEmailBox()
    {
        insert new Customer_Care_SharedEmailBox__c( Name = 'ABB@te.com', Business_Hours__c = '01mE0000000Xr5c', Case_Group__c = 'Email-ABB', GIBU__c = 'Industrial', Region__c = 'EMEA', SFDC_Routing_Address__c = 'abb@1nqbq7qvkw538lo9twysbht1uhy4gzfi7l7bqkddeqgb2tqy21.e-hkvemac.na9.case.salesforce.com');
        
    }
    public static void getAllSettings(set<string> SetRequiredSetting)
    {
        if(SetRequiredSetting.contains('Apex_Helper_Settings__c'))
            getApex_Helper_Settings();
        if(SetRequiredSetting.contains('Consumer_Device_Opportunity_Record_Types__c'))
            getConsumer_Device_Opportunity_Record_Types();
        if(SetRequiredSetting.contains('Opportunity_Record_Type_Groups__c'))
            getOpportunity_Record_Type_Groups();
        if(SetRequiredSetting.contains('Opportunity_Approvers__c'))
            getOpportunity_Approvers();
        if(SetRequiredSetting.contains('Profit_BU_Center_Mapping_Rule2__c'))
            getProfit_BU_Center_Mapping_Rule2();
        if(SetRequiredSetting.contains('RTSMapping__c'))
            getRTSMapping();
        if(SetRequiredSetting.contains('OrgWideSettings__c'))
            getOrgWideSettings();
        if(SetRequiredSetting.contains('Parts_Activation_Settings__c'))
            getParts_Activation_Settings();
        if(SetRequiredSetting.contains('Monthly_Data_delete__c'))
            getMonthly_Data_delete();
        if(SetRequiredSetting.contains('INFRA_JDA_Settings__c'))
            getINFRA_JDA_Settings();
    }
    public static void getMonthly_Data_delete()
    {
        Monthly_Data_delete__c o = new Monthly_Data_delete__c(name = 'No of years', No_of_years_to_keep_data__c = 2);
        insert o;
    }
    public static void getINFRA_JDA_Connector_Config()
    {
        insert new INFRA__JDA_Connector_Config__c(Name = 'APL', INFRA__Default_Period_Indicator__c = '402', INFRA__Site__c = 'OTHER', INFRA__Site_Indicator__c = '103');
        insert new INFRA__JDA_Connector_Config__c(Name = 'DND', INFRA__Default_Period_Indicator__c = '401', INFRA__Site__c = 'OTHER', INFRA__Site_Indicator__c = '103');
    }
    public static void getINFRA_JDA_Settings()
    {
        list<INFRA_JDA_Settings__c> lstINFRA_JDA_Settings = new list<INFRA_JDA_Settings__c>();
        lstINFRA_JDA_Settings.add(new INFRA_JDA_Settings__c(name = 'Default', N_th_Day_of_Fiscal_Month__c = 22, Engineering_Opportunity_Record_Types__c = '012E0000000eR0c', Sales_Opportunity_Record_Types__c = '012E0000000eR0d'));
        lstINFRA_JDA_Settings.add(new INFRA_JDA_Settings__c(name = 'APL', N_th_Day_of_Fiscal_Month__c = 15, CountingBack__c = -6, CountingForward__c = 15));
        lstINFRA_JDA_Settings.add(new INFRA_JDA_Settings__c(name = 'DND', N_th_Day_of_Fiscal_Month__c = 15, CountingBack__c = -6, CountingForward__c = 15));
        insert lstINFRA_JDA_Settings;
        
    }
    public static void getTE_Connection()
    {
        insert new TE_Connection__c(name = 'CentralOrg', Id_value__c = '04PE00000005lQQ', Source_BU__c = 'TE Connectivity: CIS');
    }
    public static void getSIP_Sharing_Setting()
    {
        list<SIP_Sharing_Setting__c> lstSIP_Sharing_Setting = new list<SIP_Sharing_Setting__c>();
        lstSIP_Sharing_Setting.add(new SIP_Sharing_Setting__c(name = 'Callout limit', Is_Active__c = true, Value__c = '95'));
        lstSIP_Sharing_Setting.add(new SIP_Sharing_Setting__c(name = 'SIP Run Report Query Limit', Is_Active__c = true, Value__c = '1'));
        lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'SIP batch refresh token', Value__c = 'test'));
        lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'SIP batch customer Id', Value__c = 'test'));
        lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'SIP batch secret Id', Value__c = 'test'));
        lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'FE SIP Oppy RecordTypeId', Value__c = 'a,b',Is_Active__c = true));
        lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'Approver', Value__c = 'Read'));
        lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'Participant', Value__c = 'Read'));
        lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'Participant Manager', Value__c = 'Read'));
        //lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'Fetch Job Start Time', Value__c = '',Job_Start_Time__c = datetime.now().adddays(-2)));
        //lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = 'Max Run Hours', Value__c = '0'));
        //lstSIP_Sharing_Setting.add(New SIP_Sharing_Setting__c(Name = '', Value__c = ''));
        insert lstSIP_Sharing_Setting;
    }
    
    public static void getBacklogSnapshotConfig()
    {
        list<Backlog_Snapshot_Config__c> lstBacklog_Snapshot_Config = new list<Backlog_Snapshot_Config__c>();
        lstBacklog_Snapshot_Config.add(new Backlog_Snapshot_Config__c(name = 'Transaction Date 1',Date__c = date.today() ));
        lstBacklog_Snapshot_Config.add(new Backlog_Snapshot_Config__c(name = 'Transaction Date 2',Date__c = date.today() ));
        lstBacklog_Snapshot_Config.add(new Backlog_Snapshot_Config__c(name = 'Snapshot Date',Date__c = date.today() ));
        
        insert lstBacklog_Snapshot_Config;
    }
    
    public static void getType_Priority()
    {
        List<Type_Priority__c> lstTYP = new List<Type_Priority__c>();
        lstTYP.add(new Type_Priority__c(Name='Customer',priority__c = 'Custo'));
        lstTYP.add(new Type_Priority__c(Name='PN',priority__c = 'CusPN'));
        lstTYP.add(new Type_Priority__c(Name='Customer+PN',priority__c = 'Custp'));
        lstTYP.add(new Type_Priority__c(Name='WWAC+PN',priority__c = 'wwacp'));
        lstTYP.add(new Type_Priority__c(Name='WWAC',priority__c = 'wwacc'));
        insert lstTYP;
    }
    public static void getBatchEmailmessageUsers()
    {
        List<Batch_Email_message_Users__c> lstBatch_Email_message_Users = new List<Batch_Email_message_Users__c>();
        lstBatch_Email_message_Users.add(new Batch_Email_message_Users__c(name = 'Error_clsBatch_CalculateSurveyScore', email_ID__c = 'test@test.test'));
        lstBatch_Email_message_Users.add(new Batch_Email_message_Users__c(name = 'Test Batch', email_ID__c = 'test@test.test'));
        lstBatch_Email_message_Users.add(new Batch_Email_message_Users__c(name = 'Error_ClsBatch_forecastSnapshot', email_ID__c = 'test@test.test'));
        insert lstBatch_Email_message_Users;
    }
    
    public static void getTimeframeSetting()
    {
        List<Time_frame_Setting__c> lstoTFS = new List<Time_frame_Setting__c>();
        lstoTFS.add(new Time_frame_Setting__c(Name = 'ACCOUNT_SURVEY', Period__c = 6, Period_Type__c = 'MONTH'));
        lstoTFS.add(new Time_frame_Setting__c(Name = 'Exclude Del of Forecast Snapshot', Period__c = 3, Period_Type__c = 'Month'));
        insert lstoTFS;
    }
    
    public static void getFinancialPlanningConfiguration()
    {
        List<Financial_Planning_Configuration__c> lstFinancialPlanningConfig = new List<Financial_Planning_Configuration__c>();
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Name = 'Chatter Group', Is_Active__c = true, Parameter__c= userinfo.getUserId()));
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Name = 'AM Frozen Date', Is_Active__c = true, Date_Parameter__c= '2'));
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Name = 'RSM Frozen Date', Is_Active__c = true, Date_Parameter__c= '2'));
        
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Parameter__c='a;b',Date_Parameter__c='a;b',Name = 'Set AM Frozen Date',  Class__c= 'ClsBatch_setLastASMFrozenDate',Is_Active__c = true,Used4BatchManagement__c=true));
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Parameter__c='ab',Date_Parameter__c='ab',Name = 'Set RSM Frozen Date',  Class__c= 'ClsBatch_setLastRSMFrozenDate',Is_Active__c = true,Used4BatchManagement__c=true));
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Parameter__c='a;b',Date_Parameter__c='a;b',Name = 'Restatement', Class__c= 'ClsBatch_FinancialplanningRestatement',Is_Active__c = true,Used4BatchManagement__c=true));
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Parameter__c='ab',Date_Parameter__c='ab',Name = 'Update AM Previous Forecast',  Class__c= 'ClsBatch_recalculateAccountForecast',Is_Active__c = true,Used4BatchManagement__c=true));
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Parameter__c='a;b',Date_Parameter__c='a;b',Name = 'Calculate Backlog & Currency',  Class__c= 'ClsBatch_calculateBBBMBacklog',Is_Active__c = true,Used4BatchManagement__c=true));
        lstFinancialPlanningConfig.add(new Financial_Planning_Configuration__c(Parameter__c='a;b',Date_Parameter__c='a;b',Name = 'Update RSM Previous Forecast',  Class__c= 'ClsBatch_recalculateRSMPreviousForecast',Is_Active__c = true,Used4BatchManagement__c=true));
        insert lstFinancialPlanningConfig;
    }
    
    public static void getSIPRecordTypes() 
    {
        List<Apex_Helper_Settings__c> lstApex_Helper_Settings = new List<Apex_Helper_Settings__c>();
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'AM_Plan', Value__c = '012E0000000ejM6'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'AM_Plan_FY15', Value__c = '012E0000000NDQT'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'FE_Plan', Value__c = '012E0000000ejM7'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'FE_Plan_FY15', Value__c = '012E0000000NDQY'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'GAM_Plan', Value__c = '012E0000000ejM8'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'GAM_Plan_FY15', Value__c = '012E0000000NDQd'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'PM_CCAO_FY15', Value__c = '012E0000000NE47'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'PM_Plan_FY15', Value__c = '012E0000000NDQn'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'SM_Plan_FY15', Value__c = '012E0000000NDQi'));
        lstApex_Helper_Settings.add(new Apex_Helper_Settings__c (name = 'Sales_Manager_Plan', Value__c = '012E0000000ejMA'));
        
        insert lstApex_Helper_Settings;
    }
    
    public static void getConfiguration()
    {
        insert new Configuration__c(name = 'Default', Environment__c = 'PROD' , Error_Recipients__c = 'jasmine.ver@te.com,sweta.khalasi@te.com,cornelia.jager@te.com');
    }
    public static void getCaseRecordTypes() 
    {
        List<DTC_Request_page_access__c> lstDTC_Request_page_access = new List<DTC_Request_page_access__c>();
        lstDTC_Request_page_access.add(new DTC_Request_page_access__c (Name__c='RecordType',name = 'RecordType', Id__c = '012E0000000f8is'));//DataComm - Customer Care
        lstDTC_Request_page_access.add(new DTC_Request_page_access__c (Name__c='Profiles List',name = 'Profiles List', Id__c = userinfo.getProfileId()));
        insert lstDTC_Request_page_access;
    }
    
    public static void getAplRoutingProcess() 
    {
        List<AplRoutingProcess__c> lstAplRoutingProcess = new List<AplRoutingProcess__c>();
        
        lstAplRoutingProcess.add(new AplRoutingProcess__c (name = 'Opportunity - Engineering Project', Record_type_Id__c = '012E0000000XrBX'));
        lstAplRoutingProcess.add(new AplRoutingProcess__c (name = 'Opportunity - Product Platform', Record_type_Id__c = '012E0000000dYse'));
        insert lstAplRoutingProcess;
    }
    public static void getPMV_Language_Config()
    {
        list<PMV_Language_Config__c> lstPMV_Language_Config = new list<PMV_Language_Config__c>();
        lstPMV_Language_Config.add(new PMV_Language_Config__c(Name = 'de', Active__c = true, Help_text_field__c = 'Help_Comment_German__c', Language__c = 'German', Question_text_field__c  = 'Question_German__c'));
        lstPMV_Language_Config.add(new PMV_Language_Config__c(Name = 'en_US', Active__c = true, Help_text_field__c = 'Help_Comment_English__c', Language__c = 'English', Question_text_field__c  = 'Question_English__c'));
        lstPMV_Language_Config.add(new PMV_Language_Config__c(Name = 'zh_CN', Active__c = true, Help_text_field__c = 'Help_Comment_Chinese__c', Language__c = 'Chinese (Simplified)', Question_text_field__c  = 'Question_Chinese__c'));
        insert lstPMV_Language_Config;
    }
    public static void getPMV_Sales_Stage_Setting()
    {
        RecordType rt = new RecordType();
          for(RecordType  temp: [select id, Name, DeveloperName, BusinessProcessId from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'IND_Sales_Project'])
          rt=temp;
          
        list<PMV_Sales_Stage_Setting__c> lstPMV_Sales_Stage_Setting = new list<PMV_Sales_Stage_Setting__c>();
        
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_Contracting', Active__c = true, Buyer_Cycle__c = null, Average_Duration__c = 14, Completion_Threshold__c = 100, Dead_Lost_Stage__c = false, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = '50/50', Opportunity_Parts_Process_Status__c = 'Quoted', Production_Stage__c = false, Priority_Stage__c = false, Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Contracting', PMV_Type__c = 'IND Standard Sales opp', Team_View_Column__c = 'Pending', Won_Stage__c = false));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_Dead', Active__c = true, Dead_Lost_Stage__c = true, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = 'Dead', Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Dead', PMV_Type__c = 'IND Standard Sales opp', Won_Stage__c = false));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_Lost', Active__c = true, Dead_Lost_Stage__c = true, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = 'Lost', Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Dead', PMV_Type__c = 'IND Standard Sales opp', Won_Stage__c = false));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_Dev & Diff', Active__c = true, Buyer_Cycle__c = 'Evaluation of Options', Average_Duration__c = 14, Completion_Threshold__c = 70, Dead_Lost_Stage__c = false, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = '50/50', Opportunity_Parts_Process_Status__c = 'Demo', Production_Stage__c = false, Priority_Stage__c = false, Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Developing & Differentiating', PMV_Type__c = 'IND Standard Sales opp', Team_View_Column__c = 'Pending', Won_Stage__c = false));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_Exploring Needs', Active__c = true, Buyer_Cycle__c = 'Recognition of Needs', Average_Duration__c = 21, Completion_Threshold__c = 85, Dead_Lost_Stage__c = false, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = '50/50', Opportunity_Parts_Process_Status__c = 'Concept', Production_Stage__c = false, Priority_Stage__c = false, Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Exploring Needs', PMV_Type__c = 'IND Standard Sales opp', Team_View_Column__c = 'Pending', Won_Stage__c = false));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_Initiating', Active__c = true, Buyer_Cycle__c = 'Changes Over Time', Average_Duration__c = 7, Completion_Threshold__c = 75, Dead_Lost_Stage__c = false, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = '50/50', Opportunity_Parts_Process_Status__c = 'Concept', Production_Stage__c = false, Priority_Stage__c = false, Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Initiating', PMV_Type__c = 'IND Standard Sales opp', Team_View_Column__c = 'Pending', Won_Stage__c = false));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_On Hold', Active__c = true, Dead_Lost_Stage__c = false, On_Hold_Stage__c = true, Opportunity_Parts_Confidence__c = 'On Hold', Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'On Hold', PMV_Type__c = 'IND Standard Sales opp', Won_Stage__c = false, Team_View_Column__c = 'On Hold'));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard ENG opp_Production', Active__c = true, Buyer_Cycle__c = null, Average_Duration__c = 7, Completion_Threshold__c = 100, Dead_Lost_Stage__c = false, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = 'Won', Opportunity_Parts_Process_Status__c = 'Production', Production_Stage__c = true, Priority_Stage__c = false, Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Production', PMV_Type__c = 'IND Standard Sales opp', Team_View_Column__c = 'Converted', Won_Stage__c = false));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_Ref & Res', Active__c = true, Buyer_Cycle__c = 'Resolution of Concerns', Average_Duration__c = 14, Completion_Threshold__c = 80, Dead_Lost_Stage__c = false, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = '50/50', Opportunity_Parts_Process_Status__c = 'Demo', Production_Stage__c = false, Priority_Stage__c = false, Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Refining & Resolving', PMV_Type__c = 'IND Standard Sales opp', Team_View_Column__c = 'Pending', Won_Stage__c = false));
        lstPMV_Sales_Stage_Setting.add(new PMV_Sales_Stage_Setting__c(Name = 'IND Standard Sales opp_Won', Active__c = true, Buyer_Cycle__c = 'Implementation', Completion_Threshold__c = 65, Dead_Lost_Stage__c = false, On_Hold_Stage__c = false, Opportunity_Parts_Confidence__c = 'Won', Opportunity_Parts_Process_Status__c = 'Pre-Prod', Production_Stage__c = false, Priority_Stage__c = true, Sales_Process_ID__c = rt.BusinessProcessId, Sales_Stage__c = 'Won', PMV_Type__c = 'IND Standard Sales opp', Team_View_Column__c = 'Won', Won_Stage__c = true));
        
        insert lstPMV_Sales_Stage_Setting;
    }
    public static void getPMV_Stage_Config()
    {
     RecordType rt =new RecordType ();
          for(RecordType  temp : [select id, Name, DeveloperName, BusinessProcessId from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'IND_Sales_Project'])
          rt=temp;
          
        set<string> setStr = new set<string>{'Contracting', 'Developing & Differentiating', 'Exploring Needs', 'Initiating', 'Production', 'Refining & Resolving', 'Won', 'Lost', 'Dead', 'On Hold'};
            map<string, OpportunityStage> mapOpportunityStage = new map<string, OpportunityStage>();
        list<PMV_Stage_Config__c> lstPMV_Stage_Config = new list<PMV_Stage_Config__c>();
        for(OpportunityStage oOS :[select id, MasterLabel, IsActive from OpportunityStage where MasterLabel in :setStr and IsActive = true])
            lstPMV_Stage_Config.add(new PMV_Stage_Config__c(Name = 'SP-' + oOS.MasterLabel, Business_ProcessID__c = rt.BusinessProcessId, Stage_Name__c = oOS.MasterLabel, Stage_Id__c = oOS.Id));
        
        if(lstPMV_Stage_Config.size() > 0)
            insert lstPMV_Stage_Config;
        
    }
    public static void getPMV_Sales_Process_Settings()
    {
     RecordType rt = new RecordType ();
          for(RecordType  temp: [select id, Name, DeveloperName, BusinessProcessId from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'IND_Sales_Project'])
          rt=temp;
        
        List<PMV_Sales_Process_Settings__c> lstPMV_Sales_Process_Settings = new list<PMV_Sales_Process_Settings__c>();
        lstPMV_Sales_Process_Settings.add(new PMV_Sales_Process_Settings__c(Name = 'IND Standard Sales opp', Category__c = 'PMV Type', Deal_Size_Max__c = 200000, Deal_Size_Min__c = 50000, ProjectedToClose_Threshold__c = 80, GIBU__c = 'Industrial', Sales_Process_ID__c = rt.BusinessProcessId, PMV_Type__c = 'IND Standard Sales opp', PMV_Type_Initialization__c = 'Standard', Subvertical_BU__c = 'A&C,IB,Rail,Industrial'));
        string strSPID = '019E0000000GwqT';
        Id SPID = (Id) strSPID;
        lstPMV_Sales_Process_Settings.add(new PMV_Sales_Process_Settings__c(Name = 'IND Standard Sales opp1', Category__c = 'PMV Type', Deal_Size_Max__c = 200000, Deal_Size_Min__c = 50000, ProjectedToClose_Threshold__c = 80, GIBU__c = 'Industrial', Sales_Process_ID__c = SPID, PMV_Type__c = 'IND Standard Sales opp', PMV_Type_Initialization__c = 'Standard', Subvertical_BU__c = 'A&C,IB,Rail,Industrial'));
        
        insert lstPMV_Sales_Process_Settings;
    }
    public static void getBatch_Email_message_Users(map<string, string> mapError)
    {
        list<Batch_Email_message_Users__c> lstBatch_Email_message_Users = new list<Batch_Email_message_Users__c>();
        for(string str :mapError.Keyset())
            lstBatch_Email_message_Users.add(new Batch_Email_message_Users__c(name = str, Email_ID__c = mapError.get(str)));
        if(lstBatch_Email_message_Users.size() > 0)
            insert lstBatch_Email_message_Users;
    }
    public static void getBatch_size_setting()
    {
        list<Batch_size_setting__c> lstBatchsize = new list<Batch_size_setting__c>();
        lstBatchsize.add(new Batch_size_setting__c(name = 'ClsBatch_DeleteDay_DirectBBBCust_PN', Batch_size__c = 1));
        
        insert lstBatchsize;
    }
    public static void getObject_field_mapping()
    {
        list<Object_field_mapping__c> lstObject_field_mapping = new list<Object_field_mapping__c>();
        lstObject_field_mapping.add(new Object_field_mapping__c(Name = 'Bill_Prior_Year_Amount_Document__c', Field_Mapping_Purpose__c = 'UPDATE_PRIOR_YEAR_1_FIELDS', Source_Object__c = 'BBB_Year_Bill_Book_Cust_PN__c', Source_Object_Field__c = 'Bill_Prior_Year_Amount_Document__c', Target_Object__c = 'BBB_Year_Bill_Book_Cust_PN__c', Target_Object_Field__c = 'Bill_Prior_Year_1_Amount_Document__c'));
        
        insert lstObject_field_mapping;
    }
    public static void getBatch_Email_message_Users()
    {
        list<Batch_Email_message_Users__c> lstBatch_Email_message_Users = new list<Batch_Email_message_Users__c>();
        lstBatch_Email_message_Users.add(new Batch_Email_message_Users__c(name = 'clsBatch_CopyPriorYear_1_fields', Email_ID__c = 'test@test.test'));
        insert lstBatch_Email_message_Users;
    }
    public static void getrealtime_Callout_Settings()
    {
        list<realtime_Callout_Settings__c> lstrealtime_Callout_Settings = new list<realtime_Callout_Settings__c>();
        lstrealtime_Callout_Settings.add(new realtime_Callout_Settings__c(Active__c = true, Name = 'Prod NDR Quote Link', Certificate_name__c = 'TE_RT_Cert3', Traffic_Cop_Org_Name__c = 'C2S', endpoint_url__c = 'https://sfdcgateway.te.com/ProcessHandler.asmx'));
        lstrealtime_Callout_Settings.add(new realtime_Callout_Settings__c(Active__c = true, Name = 'QA C2S_NDRRetryGPMSInitialReview', Certificate_name__c = 'TE_RT_Cert3', Traffic_Cop_Org_Name__c = 'C2S', endpoint_url__c = 'https://sfdcgateway.te.com/ProcessHandler.asmx'));
        lstrealtime_Callout_Settings.add(new realtime_Callout_Settings__c(Active__c = true, Name = 'Prod C2S_NDRRetryGPMSInitialReview', Certificate_name__c = 'TE_RT_Cert3', Traffic_Cop_Org_Name__c = 'C2S', endpoint_url__c = 'https://sfdcgateway.te.com/ProcessHandler.asmx'));
        insert lstrealtime_Callout_Settings;
    }
    public static void getOpportunity_Team_Default_Permission()
    {
        Opportunity_Team_Default_Permission__c oOpportunity_Team_Default_Permission = new Opportunity_Team_Default_Permission__c(name = 'ProfileNotSendEmail', Permission__c = 'Channel Distributor Portal User;Channel Standard User;Channel User w/ Cost - DO NOT ASSIGN');
        insert oOpportunity_Team_Default_Permission;
    }
    public static void getLast_Modified_Field_Update_Permission()
    {
        insert new Last_Modified_Field_Update_Permission__c(SetupOwnerId = UserInfo.getUserId(), Allow_Update__c = true);
    }
    public static void getLast_Modified_Field_Update_Permission(string UserId, boolean isallow)
    {
        insert new Last_Modified_Field_Update_Permission__c(SetupOwnerId = UserId, Allow_Update__c = isallow);
    }
    public static void getSpecialist_Field()
    {
        insert new Specialist_Field__c(name = 'Idento', API_Name__c = 'Account_Team_Partner_Function__c', Role__c = 'Idento Labels Specialist');
    }
    public static void getTrigger_Configuration(){
        
        List<Trigger_Configuration__c> lstTrgConfig = new List<Trigger_Configuration__c>();
        lstTrgConfig.add(new Trigger_Configuration__c(Name='Populate Opportunity Partner' ,isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='DND Lead Conversion Initialization' ,isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='Avoid Duplicate PLM Id' ,isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='Identify Fiscal Year' ,isRun__c = true));
        lstTrgConfig.add(new Trigger_Configuration__c(Name='updateAccountBusinessUnit', isRun__c = true));
        insert lstTrgConfig ;
    }
    public static void getChannel_Oppty_Header_Level_Change()
    {
        list<Channel_Oppty_Header_Level_Change__c> lst = new list<Channel_Oppty_Header_Level_Change__c>();
        lst.add(new Channel_Oppty_Header_Level_Change__c(name = 'Commit', Confidence__c = 'Commit', Process_Status__c = 'Pre-prod', Active__c = true, Stage__c = 'Commit'));
        lst.add(new Channel_Oppty_Header_Level_Change__c(name = 'Concept', Confidence__c = 'Weak', Process_Status__c = 'Concept', Active__c = true, Stage__c = 'Concept'));
        lst.add(new Channel_Oppty_Header_Level_Change__c(name = 'Dead - Closed', Confidence__c = 'Dead - Closed', Process_Status__c = 'Dead - Closed', Active__c = true, Stage__c = 'Dead - Closed'));
        lst.add(new Channel_Oppty_Header_Level_Change__c(name = 'Lost - Closed', Confidence__c = 'Lost', Process_Status__c = 'Lost', Active__c = true, Stage__c = 'Lost - Closed'));
        lst.add(new Channel_Oppty_Header_Level_Change__c(name = 'Production', Confidence__c = 'Won', Process_Status__c = 'Production', Active__c = true, Stage__c = 'Production'));
        lst.add(new Channel_Oppty_Header_Level_Change__c(name = 'Quotation', Confidence__c = 'Likely', Process_Status__c = 'Quoted', Active__c = true, Stage__c = 'Quotation'));
        lst.add(new Channel_Oppty_Header_Level_Change__c(name = 'Sampling', Confidence__c = '50/50', Process_Status__c = 'Prototyped/Sampled', Active__c = true, Stage__c = 'Sampling'));
        insert lst;
    }  
    public static void getDD1_Definition()
    {
        list<DD1_Definition__c> DD1List = new List<DD1_Definition__c>();
        DD1List.add(new DD1_Definition__c(Name = '001', DD1_Code__c='001', DD1_Business_Unit__c='Automotive'));
        DD1List.add(new DD1_Definition__c(Name = '104', DD1_Code__c='104', DD1_Business_Unit__c='Industrial'));
        insert DD1List;
    }
    
    public static void getQuoteValiditySetting() {
        Quote_Validity_Expiration_Notification__c qve = new Quote_Validity_Expiration_Notification__c();
        qve.Name = 'Notification of 15Days';
        qve.Notification_Text__c = 'Quote <SAP_QUOTE_ID__c> will expire in 15 days. Link to Quote: <QuoteLink>';
        insert qve;
    }
    
    public static void getQuoteExpirationSetting() {
        Quote_expiration_email_template__c qee = new Quote_expiration_email_template__c();
        qee.Name = 'Email Template';
        qee.Email_Template_Name__c = 'Quote_validity_expiration_Template';
        insert qee;
    }
    
    /* --- Code Added for ADM Custom Setting----------- Onkar Kumar*/
    public static void getADMTerritoryCode()
    {
        
        list<ADMTerritoryCode__c> ADMList = new List<ADMTerritoryCode__c>();
        ADMList.add(new ADMTerritoryCode__c(Name = 'ADMTerritoryCode', Territory_Code__c='101485'));

        insert ADMList ;
    }
    /* --- END Code for ADM Custom Setting-----------*/
    
    public static void getTriggerDisableUserIdSetting() {
        Trigger_Disable_User_Id__c tdu = new Trigger_Disable_User_Id__c();
        tdu.Name = String.valueOf(UserInfo.getUserId());
        insert tdu;
    }
    
    public static void getBestPriceWebspeedSetting() {
        BestPriceWebspeed__c bestPriceMfg = new BestPriceWebspeed__c();
        bestPriceMfg.Name = 'QAD-MFGProUrl';
        bestPriceMfg.URL__c = 'https://webspeed-qa.te.com/energy.wsc/zxprcsfwsrq.p';
        insert bestPriceMfg;  
    }
    
    public static void getSAPBestPriceWebspeedSetting() {
        BestPriceWebspeed__c bestPriceMfg = new BestPriceWebspeed__c();
        bestPriceMfg.Name = 'SAP Create Quote';
        bestPriceMfg.URL__c = 'https://www.soccernet.com';
        insert bestPriceMfg;  
    }
    
    public static void getSAPInstanceSetting() {
        SAP_Instance__c SAPInstance = new SAP_Instance__c();
        SAPInstance.Name = 'SAP Create Quote';
        insert SAPInstance;  
    }
    
    public static void getEnergyControlSetting() {
        Energy_Control__c energyControl = new Energy_Control__c();
        energyControl.Name = 'Energy Control';
        energyControl.Disable_Integrations__c = false;
        energyControl.Callout_Start_Date__c = system.today().addYears(-2);
        insert energyControl;  
    }
    
    public static void getCrossBUCheck() {
        Cross_BU_Check__c cbc = new Cross_BU_Check__c();
        cbc.Name = 'Appliances BU 01';
        cbc.Customer_GIBU__c = 'Appliances';
        cbc.Product_Owning_GIBU__c = 'A&C';
        cbc.Result__c = 'AP';
        insert cbc;  
    }
    public static void getAllowToSetForecastUSDCurrency() {
        Allow_To_Set_Forecast_USD_Currency__c allowSetting = new Allow_To_Set_Forecast_USD_Currency__c();
        allowSetting.Name = 'Current User';
        allowSetting.UserId__c = UserInfo.getUserId();
        insert allowSetting;  
    }
    
    public static void getDD2_Definition()
    {
        list<DD2_Definition__c> DD2List = new List<DD2_Definition__c>();
        DD2List.add(new DD2_Definition__c(Name = '113', DD2_Code__c='113', DD2_Business_Unit__c='Rail'));
        DD2List.add(new DD2_Definition__c(Name = '105', DD2_Code__c='105', DD2_Business_Unit__c='IB'));
        insert DD2List;
    }
 
     public static void getADM_Territory_Code()
        {
           List<ADMTerritoryCode__c> ADMTerr = new List<ADMTerritoryCode__c>();
            ADMTerr.add(new ADMTerritoryCode__c(Name = 'ADMTerritoryCode', Territory_Code__c='101485'));
            insert ADMTerr;
       }   
    public static void getAccount_Business_Unit_L2()
    {
        list<Account_Business_Unit_L2__c> AccBUList = new List<Account_Business_Unit_L2__c>();
        AccBUList.add(new Account_Business_Unit_L2__c(Name = 'Null'));
        AccBUList.add(new Account_Business_Unit_L2__c(Name = '205', IBC__c='205', Business_Unit__c='Automotive'));
        AccBUList.add(new Account_Business_Unit_L2__c(Name = '116', IBC__c='116', Business_Unit__c='Industrial', Business_Unit_Level_2__c='A&C'));
        AccBUList.add(new Account_Business_Unit_L2__c(Name = '211', IBC__c='211', Business_Unit__c='Subcontractor'));
        insert AccBUList;
    }   
    
    /* Added by Subramanian for Select Growth Long term project - Start */    
    public static void getZSD_DMM_SAP(){
        List<ZSD_DMM_SAP__c> ZDSList = new List<ZSD_DMM_SAP__c>();
        ZDSList.add(new ZSD_DMM_SAP__c (Region__c='EU', Country_Key__c='EU', CJMUser_Network_Id__c = 'TE654321', District_Marketing_Manager__c ='TE654321'));
        ZDSList.add(new ZSD_DMM_SAP__c (Region__c='CA', Country_Key__c='US', CJMUser_Network_Id__c = 'TE123456', District_Marketing_Manager__c ='TE123456'));
        ZDSList.add(new ZSD_DMM_SAP__c (Region__c='CA', Country_Key__c='US', CJMUser_Network_Id__c = 'TE123456', District_Marketing_Manager__c ='TE123456'));

        insert ZDSList;
    }
    
    public static void getLiveAgentCountry(){
        List<Live_Agent_Country_List__c> liveAgentCountryList = new List<Live_Agent_Country_List__c>();
         liveAgentCountryList.add(new Live_Agent_Country_List__c (Name='test1234', Country_Code_2_Digit__c='US', English__c='United States', region_code__c = '2'));       
         liveAgentCountryList.add(new Live_Agent_Country_List__c (Name='test1235', Country_Code_2_Digit__c='IN', English__c='India', region_code__c = '0442'));       
         liveAgentCountryList.add(new Live_Agent_Country_List__c (Name='test1236', Country_Code_2_Digit__c='EU', English__c='Germany', region_code__c = '0441'));       
         liveAgentCountryList.add(new Live_Agent_Country_List__c (Name='test1237', Country_Code_2_Digit__c='EM', English__c='Italy', region_code__c = '0441')); 
         insert liveAgentCountryList;
    }
    
    public static void getMQLConstantVariables(){
        List<MQLs_Constant_Variables__c> MRMList = new List<MQLs_Constant_Variables__c>();   
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'cjm-network-id', Constants__c = 'EB123444'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'non-country-state', Constants__c = '0442'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'assign-cjm-user-territory', Constants__c = 'TE123456,TE654321'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'search-by-state', Constants__c = 'United States,US,USA,Canada,CA'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'selectcustomer', Constants__c = 'S'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'targetcustomer', Constants__c = 'X04'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'defaultleadassignment', Constants__c = '005E0000000VsJBIA0'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'cjm-americas-queue', Constants__c = 'Filter_Agent_Sales_Dev_America_s'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'cjm-apac-queue', Constants__c = 'Filter_Agent_Sales_Dev_PIC_AP'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'cjm-emea-queue', Constants__c = 'Filter_Agent_Sales_Dev_PIC_EMEA'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'cjm-appliance-queue', Constants__c = 'Appliances_Inside_Sales_Americas'));
         MRMList.add(new MQLs_Constant_Variables__c (Name = 'cjm-queues', Constants__c = 'Filter_Agent_Sales_Dev_America_s,Filter_Agent_Sales_Dev_PIC_AP,Appliances_Inside_Sales_Americas,Filter_Agent_Sales_Dev_PIC_EMEA'));
         
         insert MRMList;
    }
    /* Added by Subramanian for Select Growth Long term project - End */
    public static void getProfilesAllowToEditPastForecasts(){
        List<Profiles_Allow_To_Edit_Past_Forecast__c> list_ProfileSettings = new List<Profiles_Allow_To_Edit_Past_Forecast__c>();
        list_ProfileSettings.add(new Profiles_Allow_To_Edit_Past_Forecast__c(Name = 'Test', Profile_Id__c = UserInfo.getProfileId()));
        insert list_ProfileSettings;
    }
    
}