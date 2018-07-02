/**
*   This class is a help class.
*
@author Di Chen
@created 2012-02-23
@vercreateTestRecordType23sion 1.0
@since 20.0
*
@changelog
* 2012-02-23 Di Chen <di.chen@itbconsult.com>
* - Created
*
*/
/*Added a new method for accounts and contacts to generate random unique number
            2014-09-18 Harinath Chittala <harinath.chittala@te.com>*/

@isTest
public class ClsTestHelp {
    public static map<string, Apex_Helper_Settings__c> map_ahs = new map<string, Apex_Helper_Settings__c>();
    public static map<string, Consumer_Device_Opportunity_Record_Types__c> map_DevOppRecTypes = new map<string, Consumer_Device_Opportunity_Record_Types__c>();
    public static map<string, Financial_Planning_Configuration__c> map_FinantialPlanConfig = new map<string, Financial_Planning_Configuration__c>();
    public static map<string, Opportunity_Approvers__c> map_OppApprovers = new map<string, Opportunity_Approvers__c>();
    public static map<string, PMV_Sales_Stage_Setting__c> map_PMVSalesSetting = new map<string, PMV_Sales_Stage_Setting__c>();
    public static map<string,PMV_Stage_Config__c> map_PMVStageConfig = new  map<string,PMV_Stage_Config__c>();
    
    public static void getPMV_Stage_Config(){map_PMVStageConfig = PMV_Stage_Config__c.getall();}    
    public static void getPMV_Sales_Stage_Settings(){map_PMVSalesSetting = PMV_Sales_Stage_Setting__c.getAll();}
    public static void getAllApex_Helper_Settings(){map_ahs = Apex_Helper_Settings__c.getAll();}
    public static void getDevOppRecTypes(){map_DevOppRecTypes = Consumer_Device_Opportunity_Record_Types__c.getAll();}
    public static void getFinantialPlanConfigs(){map_FinantialPlanConfig = Financial_Planning_Configuration__c.getAll();}
    public static void getOpportunityApprovers(){map_OppApprovers = Opportunity_Approvers__c.getAll();}
        
    public static void initAPLTestData() {
        
        //Apex_Helper_Settings__c name1 = ClsTestHelp.createTestName1();
        map<String, Profile> map_Profile = new map<String, Profile>();
        for(Profile pro : [ Select Id, Name From Profile where Name IN ('System Administrator','Partner Admin','Regional Admin','Service Account','BU Admin') ])
            map_Profile.put(pro.Name, pro);

        getAllApex_Helper_Settings();
        getDevOppRecTypes();
        
        list<Apex_Helper_Settings__c> list_ahs = new list<Apex_Helper_Settings__c>();
        
        if(!map_ahs.containsKey('System Admin Profile Id'))
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'System Admin Profile Id', Value__c = map_Profile.get('System Administrator').Id));
        
        if(!map_ahs.containsKey('Partner Admin Profile Id'))
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'Partner Admin Profile Id', Value__c = map_Profile.get('Partner Admin').Id));
            
        if(!map_ahs.containsKey('Regional Admin Profile Id'))
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'Regional Admin Profile Id', Value__c = map_Profile.get('Regional Admin').Id));
        
        if(!map_ahs.containsKey('Service Account Profile Id'))
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'Service Account Profile Id', Value__c = map_Profile.get('Service Account').Id));
        
        if(!map_ahs.containsKey('TEIS Admin User Id'))
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'TEIS Admin User Id', Value__c = map_Profile.get('System Administrator').Id));

        if(!map_ahs.containsKey('Account Record Type Id'))
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'Account Record Type Id', Value__c = map_Profile.get('System Administrator').Id));
        
        
        if(!map_ahs.containsKey('GAM Record Type Id')){
            RecordType rt14 = ClsTestHelp.createTestRecordType14();
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'GAM Record Type Id', Value__c = rt14.Id));
        }
        
        if(!map_ahs.containsKey('Forecast Snapshot Part RT Id')){
            RecordType rt18 = ClsTestHelp.createTestRecordType18();
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'Forecast Snapshot Part RT Id', Value__c = rt18.Id));
        }
        
        if(!map_ahs.containsKey('Forecast Snapshot Oppy RT Id')){
            RecordType rt19 = ClsTestHelp.createTestRecordType19();
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'Forecast Snapshot Oppy RT Id', Value__c = rt19.Id));
        }  
         
        
        if(!map_ahs.containsKey('Sales Parts RT Id')){
            RecordType rt20 = ClsTestHelp.createTestRecordType20();
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'Sales Parts RT Id', Value__c = rt20.Id));
        }
        
        if(!map_ahs.containsKey('BU Admin Profile Id'))
            list_ahs.add(new Apex_Helper_Settings__c(Name = 'BU Admin Profile Id', Value__c = map_Profile.get('BU Admin').Id));
        
        if(list_ahs.size() > 0)
            insert list_ahs;
        
        list<Consumer_Device_Opportunity_Record_Types__c> list_csd = new list<Consumer_Device_Opportunity_Record_Types__c>();
        RecordType csdRT1 = ClsTestHelp.createCSDTestRecordType1();  
        
        if(!map_DevOppRecTypes.containsKey('Engineering Opportunity-CSD')){
            Consumer_Device_Opportunity_Record_Types__c csd1 = new Consumer_Device_Opportunity_Record_Types__c();
            csd1.Name = 'Engineering Opportunity-CSD';
            csd1.Record_Type_Id__c = csdRT1.Id;
            list_csd.add(csd1);
        } 
        
        
        if(!map_DevOppRecTypes.containsKey('Engineering_Opportunity_CSD')){
            Consumer_Device_Opportunity_Record_Types__c csd2 = new Consumer_Device_Opportunity_Record_Types__c();
            csd2.Name = 'Engineering_Opportunity_CSD';
            csd2.Record_Type_Id__c = csdRT1.Id;
            list_csd.add(csd2);
        } 
        RecordType csdRT2 = ClsTestHelp.createCSDTestRecordType4(); 
        if(!map_DevOppRecTypes.containsKey('Sales Opportunity-CSD')){
            Consumer_Device_Opportunity_Record_Types__c csd3 = new Consumer_Device_Opportunity_Record_Types__c();        
            csd3.Name = 'Sales Opportunity-CSD';
            csd3.Record_Type_Id__c = csdRT2.Id;
            list_csd.add(csd3);
        } 
        
        if(!map_DevOppRecTypes.containsKey('Sales_Opportunity_CSD')){
            Consumer_Device_Opportunity_Record_Types__c csd4 = new Consumer_Device_Opportunity_Record_Types__c();
            csd4.Name = 'Sales_Opportunity_CSD';
            csd4.Record_Type_Id__c = csdRT2.Id;
            list_csd.add(csd4);
        } 

        if(!map_DevOppRecTypes.containsKey('New_Development')){
            RecordType csdRT5 = ClsTestHelp.createCSDTestRecordType5();  
            Consumer_Device_Opportunity_Record_Types__c csd5 = new Consumer_Device_Opportunity_Record_Types__c();
            csd5.Name = 'New_Development';
            csd5.Record_Type_Id__c = csdRT5.Id;
            list_csd.add(csd5);
        } 
        
        if(!map_DevOppRecTypes.containsKey('Sales_Parts')){        
            RecordType csdRT6 = ClsTestHelp.createCSDTestRecordType6();  
            Consumer_Device_Opportunity_Record_Types__c csd6 = new Consumer_Device_Opportunity_Record_Types__c();
            csd6.Name = 'Sales_Parts';
            csd6.Record_Type_Id__c = csdRT6.Id;
            list_csd.add(csd6);
        } 
        
        if(!map_DevOppRecTypes.containsKey('OEM')){
            RecordType csdRT7 = ClsTestHelp.createCSDTestRecordType7();  
            Consumer_Device_Opportunity_Record_Types__c csd7 = new Consumer_Device_Opportunity_Record_Types__c();
            csd7.Name = 'OEM';
            csd7.Record_Type_Id__c = csdRT7.Id;
            list_csd.add(csd7);
        } 
        
        if(list_csd.size() > 0) {
            insert list_csd;
        }
    }

    
    public static APL_ClsEntityType.SearchObj createSearchObj(){
    
        APL_ClsEntityType.SearchObj so = new APL_ClsEntityType.SearchObj();
        so.searchKey = 'Test';
        so.soldtoId = 'Test';
        so.accnumber = 'Test';
        so.oemId = 'Test';
        so.partId = 'Test';
        so.region = 'Test';
        so.gplfamily = 'Test';
        so.gplId = 'Test';
        so.rsmgrouping = 'Test';
        so.grouping = 'Test';
        so.cbc2Code = 'Test';
        so.relayCode = 'Test';
        so.territoryCode = 'Test';
        so.set_selectedId = null;
        so.map_year_monthsFuture = null;
        so.map_year_quartersFuture = null;
        so.startDate = '2015-05-01';
        so.endDate = '2015-05-01';
        so.isOtherMethod = true;
        so.set_fiscalMonth = null;
        so.isExpansionSoldto = true;
        so.hasGPLCode = true;
        so.viewMode = 'Test';
        so.userId = UserInfo.getUserId();
        so.managerId = UserInfo.getUserId();
        so.type = 'CBC2';
        so.currencyIso = 'USD';
        so.set_deletedId  = null;
        so.map_quarter_months = null;
        so.map_acctId_currencyIso = null;
        so.set_gamCodes = null;  
        return so;          
    }
    
    public static User createTestUsers() {
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.Alias = 'mtst';
        u.Email = 'mtester@ItbTestcompany.com';
        u.Username =getUserNamePrefix()+ u.Email;// Modified by Mrunal to get Unique UserName for each user.
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id 
                        from Profile
                        where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        return u;
    }
    // Change start by Mrunal to get Unique UserName for each user.
     public static String getUserNamePrefix(){

        return UserInfo.getOrganizationId() + System.now().millisecond();

    }
    // Change end by Mrunal to get Unique UserName for each user.
    public static Account createTestAccounts() {
        Account acc = new Account();
        acc.Name = 't'+system.now().millisecond()+math.round(math.random()*10000);//Modified by Harinath to get Unique AccountName for each Account.
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'CN';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '77777';
        acc.Sales_Hierarchy__c=ClsTestHelp.createTestSalesHierarchy().Id;       
        acc.Industry_Code_Description__c='Industrial';      
        acc.Business_Unit_Level_2__c='Rail';
        acc.AccountNumber = '';
        return acc;
    }
    public static Contact createTestContacts() {
        Contact contact = new Contact();
        contact.LastName = 'Sand';
        contact.Email= 't'+system.now().millisecond()+math.round(math.random()*10000)+'@gmail.com';//Modified by Harinath to get Unique EmailId for each Contact.
        contact.OwnerId = UserInfo.getUserId();
        contact.MailingCity = 'Musterstadt';
        contact.MailingStreet = 'Teststr. 1';
        contact.MailingCountry = 'Germany';
        contact.MailingPostalCode = '77777';
        contact.Salutation = 'Mr.';
        contact.Phone = '12365478';
        return contact;
    }
    
    public static Attachment createTestAttachments() {
        Attachment att= new Attachment();
        att.Name = 'Object1';
        att.Body = Blob.valueof('Test');
        return att;
    }
    //Added by Yiming Shen <yiming.shen@capgemini.com> at 2017-11-13
    public static Energy_Quote_Line_Item__c createTestEnergyQuoteLineItem() {
        Energy_Quote_Line_Item__c eqli = new Energy_Quote_Line_Item__c();
        return eqli;
    }
    public static Customer_Part_Number__c createTestCustomerPartNumber() {
        Customer_Part_Number__c cpn = new Customer_Part_Number__c();
        return cpn;
    }
    public static Energy_Quote__c createTestEnergyQuote() {
        Energy_Quote__c eq = new Energy_Quote__c();
        return eq;
    }
    public static Territory_Email_Template__c createTestTerritoryEmailTemplate() {
        Territory_Email_Template__c tet = new Territory_Email_Template__c();
        return tet;
    }
    public static ANZ_Clause_Master__c createTestANZClauseMaster() {
        ANZ_Clause_Master__c clauseMaster = new ANZ_Clause_Master__c();
        return clauseMaster;
    }
    public static ANZ_Clause__c createTestANZClause() {
        ANZ_Clause__c clause = new ANZ_Clause__c();
        return clause;
    }
    public static Product_Hierarchy__c createTestProductHierarchy() {
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        return ph;
    }
    public static Part__c createTestPart() {
        Part__c part = new Part__c();
        return part;
    }
    public static Price_Break__c createTestPriceBreak() {
        Price_Break__c price = new Price_Break__c();
        return price;
    }
    
    public static OpportunityForecastsReportId__c createOpportunityForecastsReportId(){
    	OpportunityForecastsReportId__c ofri = new OpportunityForecastsReportId__c();
    	return ofri;
    }
    public static BBB_Month_Bill_Book_Cust__c createTestBBBMonthBillBookCust() {
        BBB_Month_Bill_Book_Cust__c monthBillBookCust = new BBB_Month_Bill_Book_Cust__c();
        return monthBillBookCust;
    }
    public static Opportunity_Part_Forecast__c createTestOpportunityPartForecast() {
        Opportunity_Part_Forecast__c opf = new Opportunity_Part_Forecast__c();
        return opf;
    }
    public static MTO_High_Runner__c createTestMTOHighRunner() {
        MTO_High_Runner__c mtohr = new MTO_High_Runner__c();
        return mtohr;
    }
    public static MTO_High_Runner_File__c createTestMTOHighRunnerFile() {
        MTO_High_Runner_File__c mtohrf = new MTO_High_Runner_File__c();
        return mtohrf;
    }
    public static MTO_High_Runner_Field_Mapping__c createTestMTOHighRunnerFieldMapping() {
        MTO_High_Runner_Field_Mapping__c mtohrfm = new MTO_High_Runner_Field_Mapping__c();
        return mtohrfm;
    }
    public static Energy_Price_Book_Entry__c createTestEnergyPriceBookEntry() {
        Energy_Price_Book_Entry__c epbe = new Energy_Price_Book_Entry__c();
        return epbe;
    }
    public static Inventory__c createTestInventory() {
        Inventory__c inventory = new Inventory__c();
        return inventory;
    }
    public static OpportunityTeamMember createTestOpportunityTeamMember() {
        OpportunityTeamMember otm = new OpportunityTeamMember();
        return otm;
    }
    public static Month_forecast__c createTestMonthForecast() {
        Month_Forecast__c mf = new Month_Forecast__c();
        return mf;
    }
    public static CBC4_to_PM__c createTestCBC4toPM() {
        CBC4_to_PM__c cbc = new CBC4_to_PM__c();
        return cbc;
    }
    public static Events_Exhibitions__c createTestEventsExhibitions() {
        Events_Exhibitions__c ee = new Events_Exhibitions__c();
        return ee;
    }
    //End
    public static Group createTestGroups() {
        Group g = new Group();
        g.Name = 'Lucifer';
        return g;
    }
  
    public static Opportunity createTestOpportunity() {
        RecordType rt2 = ClsTestHelp.createTestRecordType16();
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'New';
        oppy.Name = 'SandKing';
        oppy.currency_confirm__c = true;
        oppy.CloseDate = date.today();
        oppy.RecordTypeId = rt2.Id; 
        //oppy.Tender__c = null;
        oppy.Sum_Part_Allocation__c = 100;
        oppy.Defined_GPLs__c = 'A39,K01,K03,176';
        oppy.Mass_prod_Status__c = true;
        return oppy;
    }
    
    public static Opportunity createTestADMOpportunity() {
        RecordType rt2 = ClsTestHelp.createTestRecordType31();
        Opportunity oppy = new Opportunity();
        oppy.StageName = 'Design';
        oppy.Name = 'SandKing';
        oppy.currency_confirm__c = true;
        oppy.CloseDate = date.today();
        oppy.RecordTypeId = rt2.Id; 
        //oppy.Tender__c = null;   
        return oppy;
    }
    public static Opportunity_Partner__c createTestOpportunityPartner() {
        Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
        oppyPartner.Allocation__c = 100;
        return oppyPartner;
    }
    public static Opportunity_Part__c createTestOpportunityPart() {
        Opportunity_Part__c oppypart = new Opportunity_Part__c();
        oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
        return oppypart;
    }
    public static Opportunity_Part__c createTestEnergyOpportunityPart() {
        Opportunity_Part__c oppypart = new Opportunity_Part__c();
        oppypart.RecordTypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Energy Parts').getRecordTypeId();
        oppypart.Cable_Assembly_Type__c = 'Fiber Optic';
        return oppypart;
    }
    public static Sales_Hierarchy__c createTestSalesHierarchy() {
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A007341';
        sh.Hierarchy_Type__c = 'Account Manager Hierarchy (FE)';
        return sh;
    }
    public static Sales_Hierarchy__c createTestSalesHierarchy1() {
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A007322';
        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
        return sh;
    }
    public static Opportunity_Forecast__c createTestOpportunityForecasts() {
        Opportunity_Forecast__c oppyForecast = new Opportunity_Forecast__c();
        oppyForecast.Date__c = date.today();
        oppyForecast.CurrencyIsoCode = 'EUR';
        return oppyForecast;
    }
    public static Opportunity_Forecast__c createTestENGOpportunityForecasts() {
        Opportunity_Forecast__c oppyForecast = new Opportunity_Forecast__c();
        oppyForecast.Date__c = date.today();
        oppyForecast.CurrencyIsoCode = 'EUR';
        oppyForecast.RecordTypeId = Schema.SObjectType.Opportunity_Forecast__c.getRecordTypeInfosByName().get('Part').getRecordTypeId();
        return oppyForecast;
    }
    public static Account_Plan__c createTestAccountPlan() {
        Account_Plan__c ap = new Account_Plan__c();
        ap.Account_Objective_1__c = 'Increase penetration into CAG and LSG groups/ currently 75% of our billings from from EMG.';
        ap.BU_Revenue_CY_Forecast_M__c = 11;
        ap.Account_Definition__c = 'GAM Code';
        ap.BU_Revenue_Fcst_Plan_Yr_1_M__c = 12;
        ap.BU_Revenue_Fcst_Plan_Yr_4_M__c = 12;
        ap.BU_Revenue_Fcst_Plan_Yr_M__c = 12;
        ap.BU_Revenue_Prior_Yr_Actual_M__c = 22;
        ap.BU_Revenue_YTD_Actual_M__c = 0.0;
        ap.Competitor_1_Market_Share__c = 8;
        ap.Competitor_1__c = 'Samtec';
        ap.Industry_Segment__c = 'Test and Measurement';
        ap.Key_Product_1_Pct__c = 40;
        ap.Key_Product_1__c = 'Probes';
        ap.Total_Revenue_M_Plan_Yr_2__c = 5444;
        ap.Total_Revenue_M_Plan_Yr_1__c = 6100;
        ap.TAM_Plan_Year_M__c = 125;
        ap.TAM_Plan_Yr_1_M__c = 130; 
        ap.TAM_Plan_Yr_4_M__c = 135; 
        ap.TAM_Prior_Yr_M__c = 125; 
        ap.TE_Revenue_CY_Forecast_M__c = 12;
        ap.TE_Revenue_Fcst_Plan_Yr_1_M__c = 12;
        ap.TE_Revenue_Fcst_Plan_Yr_4_M__c = 12; 
        ap.TE_Revenue_Fcst_Plan_Yr_M__c = 12; 
        ap.TE_Revenue_Prior_Yr_Actual_M__c = 12; 
        ap.TE_Revenue_YTD_Actual_M__c = 0.0; 
        ap.Sales_Breakdown_2_Description__c = 'Americas';
        ap.Sales_Breakdown_2_Percent__c = 48; 
        ap.Sales_Breakdown_1_Percent__c =52; 
        ap.Sales_Breakdown_1_Description__c = 'Asia';
        ap.Total_Revenue_M_Plan_Yr_3__c = 13;
        ap.Active__c = true;
        ap.Strategic_Initiative_1__c = 'Introduce the RF cable across the regions/ starting with';
        ap.Strategic_Initiative_2__c = 'xx';
        ap.Strategic_Initiative_3__c = 'xx';
        ap.Strategic_Initiative_4__c = 'xx';
        ap.Strategic_Initiative_5__c = 'xx';
        ap.Strategic_Initiative_6__c = 'xx';
        ap.Strategic_Initiative_7__c = 'xx';
        ap.Strategic_Initiative_8__c = 'xx';
        ap.Strategic_Initiative_9__c = 'xx';
        ap.Strategic_Initiative_10__c = 'xx';
        ap.Strategic_Initiative_11__c = 'xx';
        ap.Strategic_Initiative_12__c = 'xx';
        ap.Strategic_Initiative_13__c = 'xx';
        ap.Strategic_Initiative_14__c = 'xx';
        ap.Strategic_Initiative_15__c = 'xx';
        ap.Strategic_Initiative_16__c = 'xx';
        ap.Strategic_Initiative_17__c = 'xx';
        ap.Strategic_Initiative_18__c = 'xx';
        ap.Strategic_Initiative_19__c = 'xx';
        ap.Strategic_Initiative_20__c = 'xx';
        
        ap.Strategic_Initiative_1_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_2_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_3_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_4_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_5_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_6_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_7_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_8_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_9_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_10_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_11_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_12_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_13_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_14_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_15_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_16_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_17_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_18_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_19_Target__c = 'FY12Q1';
        ap.Strategic_Initiative_20_Target__c = 'FY12Q1';
        
        ap.Strategic_Initiative_10_Status__c = 'On target';
        ap.Strategic_Initiative_9_Status__c = 'On target';
        ap.Strategic_Initiative_8_Status__c = 'On target';
        ap.Strategic_Initiative_7_Status__c = 'On target';
        ap.Strategic_Initiative_6_Status__c = 'On target';
        ap.Strategic_Initiative_5_Status__c = 'On target';
        ap.Strategic_Initiative_4_Status__c = 'On target';
        ap.Strategic_Initiative_3_Status__c = 'On target';
        ap.Strategic_Initiative_2_Status__c = 'On target';
        ap.Strategic_Initiative_1_Status__c = 'On target';
        ap.Strategic_Initiative_11_Status__c = 'On target';
        ap.Strategic_Initiative_12_Status__c = 'On target';
        ap.Strategic_Initiative_13_Status__c = 'On target';
        ap.Strategic_Initiative_14_Status__c = 'On target';
        ap.Strategic_Initiative_15_Status__c = 'On target';
        ap.Strategic_Initiative_16_Status__c = 'On target';
        ap.Strategic_Initiative_17_Status__c = 'On target';
        ap.Strategic_Initiative_18_Status__c = 'On target';
        ap.Strategic_Initiative_19_Status__c = 'On target';
        ap.Strategic_Initiative_20_Status__c = 'On target';
        
        ap.Strategic_Initiative_1_Owner__c = '123';
        ap.Strategic_Initiative_10_Owner__c = '123';
        ap.Strategic_Initiative_11_Owner__c = '123';
        ap.Strategic_Initiative_12_Owner__c = '123';
        ap.Strategic_Initiative_13_Owner__c = '123';
        ap.Strategic_Initiative_14_Owner__c = '123';
        ap.Strategic_Initiative_15_Owner__c = '123';
        ap.Strategic_Initiative_16_Owner__c = '123';
        ap.Strategic_Initiative_17_Owner__c = '123';
        ap.Strategic_Initiative_18_Owner__c = '123';
        ap.Strategic_Initiative_19_Owner__c = '123';
        ap.Strategic_Initiative_20_Owner__c = '123';
        
        ap.Account_Objective_Active_1__c = true;
        ap.Account_Objective_Active_2__c = true;
        ap.Account_Objective_Active_3__c = true;
        ap.Account_Objective_Active_4__c = true;
        ap.Account_Objective_Active_5__c = true;
        
        ap.Strategic_Initiative_Active_1__c = true;
        ap.Strategic_Initiative_Active_2__c = true;
        ap.Strategic_Initiative_Active_3__c = true;
        ap.Strategic_Initiative_Active_4__c = true;
        ap.Strategic_Initiative_Active_5__c = true;
        
        ap.Account_Objective_6__c = '123';
        ap.Account_Objective_7__c = '123';
        ap.Account_Objective_8__c = '123';
        ap.Account_Objective_9__c = '123';
        ap.Account_Objective_10__c = '123';
        ap.Account_Objective_11__c = '123';
        ap.Account_Objective_12__c = '123';
        ap.Account_Objective_13__c = '123';
        ap.Account_Objective_14__c = '123';
        ap.Account_Objective_15__c = '123';
        ap.Account_Objective_16__c = '123';
        ap.Account_Objective_17__c = '123';
        ap.Account_Objective_18__c = '123';
        ap.Account_Objective_19__c = '123';
        ap.Account_Objective_20__c = '123';
        
        ap.Account_Objective_Location_1__c = '123';
        ap.Account_Objective_Location_2__c = '123';
        ap.Account_Objective_Location_3__c = '123';
        ap.Account_Objective_Location_4__c = '123';
        ap.Account_Objective_Location_5__c = '123';
        ap.Account_Objective_Location_6__c = '123';
        ap.Account_Objective_Location_7__c = '123';
        ap.Account_Objective_Location_8__c = '123';
        ap.Account_Objective_Location_9__c = '123';
        ap.Account_Objective_Location_10__c = '123';
        ap.Account_Objective_Location_11__c = '123';
        ap.Account_Objective_Location_12__c = '123';
        ap.Account_Objective_Location_13__c = '123';
        ap.Account_Objective_Location_14__c = '123';
        ap.Account_Objective_Location_15__c = '123';
        ap.Account_Objective_Location_16__c = '123';
        ap.Account_Objective_Location_17__c = '123';
        ap.Account_Objective_Location_18__c = '123';
        ap.Account_Objective_Location_19__c = '123';
        ap.Account_Objective_Location_20__c = '123';
        
        return ap;
    }
    public static Budget_Detail__c createTestBudgetDetail() {
        Budget_Detail__c bd = new Budget_Detail__c();
        bd.Forecast_CY__c = 11;
        bd.Obsoletion_EOL__c = 12;
        bd.Transfer_Out__c = 12;
        bd.Transfer_In__c = 11;
        bd.TAM_DTAM__c = 11;
        bd.Market_Growth__c = 12;
        bd.Price_Change__c = 12;
        bd.Price_Increase__c = 12;
        bd.Billings_LY__c = 11;
        bd.Billings_CYTD__c = 12;
        bd.Billings_CYRR__c = 12;
        bd.Backlog__c = 12;
        bd.Opportunities_Won__c = 12;
        bd.Opportunities_Commit__c = 12;
        bd.Opportunities_Likely__c = 12;
        bd.Opportunities50_50__c = 11;
        bd.Opportunities_Weak__c = 12;
        bd.Adjustment__c = 12;
        return bd;
    }
    public static RecordType createTestRecordType() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CIS_Global_Account',Name='Grouped Accounts',SobjectType = 'Account');
        else
        {
            RecordType rt = [select Id,Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Global_Account'];
            return rt;
        }
    }                                                                                               
    public static RecordType createTestRecordType2() {
        Id RecordTypeId = Schema.SObjectType.Account_Team__c.getRecordTypeInfosByName().get('SFDC User').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'SFDC_User',Name='SFDC User',SobjectType = 'Account_Team__c');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Account_Team__c' and DeveloperName = 'SFDC_User'];
            return rt;
        }
    }
    public static RecordType createTestRecordType3() {
        Id RecordTypeId = Schema.SObjectType.Product_Hierarchy__c.getRecordTypeInfosByName().get('GPL').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'GPL',Name='GPL',SobjectType = 'Product_Hierarchy__c');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Product_Hierarchy__c' and DeveloperName = 'GPL'];
            return rt;
        }
    }
    public static RecordType createTestRecordType4() {
        Id RecordTypeId = Schema.SObjectType.Product_Hierarchy__c.getRecordTypeInfosByName().get('CBC').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CBC',Name='CBC',SobjectType = 'Product_Hierarchy__c');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Product_Hierarchy__c' and DeveloperName = 'CBC'];
            return rt;
        }
    }
    public static RecordType createTestRecordType5() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('CIS Market Account').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CIS_Market_Account',Name='CIS Market Account',SobjectType = 'Account');
        else
        {
            RecordType rt = [select Id,Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Market_Account'];
            return rt;
        }
    }
    public static RecordType createTestRecordType6() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Other').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CIS_Other',Name='Other',SobjectType = 'Account');
        else
        {
            RecordType rt = [select Id, Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Other'];
            return rt;
        }
    }
    public static RecordType createTestRecordType7() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Program').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Program',Name='Program',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Id,Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Program'];
            return rt;
        }
    }
    public static RecordType createTestRecordType8() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CIS_Account',Name='Account',SobjectType = 'Account');
        else
        {
            RecordType rt = [select Id,Name from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Account'];
            return rt;
        }
    }     
    public static RecordType createTestRecordType9() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('TAM').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'TAM',Name='TAM',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'TAM'];
            return rt;
        }
    }  
    public static RecordType createTestRecordType10() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Engineering Project').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Opportunity_Engineering_Project',Name='Opportunity - Engineering Project',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'Opportunity_Engineering_Project'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType11() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Sales Project').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Opportunity_Sales_Parts_Only',Name='Opportunity - Sales Project',SobjectType = 'Opportunity');
        else
        {
        RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'Opportunity_Sales_Parts_Only'];
        return rt;
        }
    } 
    public static RecordType createTestRecordType12() {
        Id RecordTypeId = Schema.SObjectType.Account_Team__c.getRecordTypeInfosByName().get('SFDC User').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'SFDC_User',Name='SFDC User',SobjectType = 'Account_Team__c');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Account_Team__c' and DeveloperName = 'SFDC_User'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType13() {
        Id RecordTypeId = Schema.SObjectType.Account_Team__c.getRecordTypeInfosByName().get('Non SFDC User').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Non_SFDC_User',Name='Non SFDC User',SobjectType = 'Account_Team__c');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Account_Team__c' and DeveloperName = 'Non_SFDC_User'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType14() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CIS_Global_Account',Name='Grouped Accounts',SobjectType = 'Account');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Account' and DeveloperName = 'CIS_Global_Account'];
            return rt;
        }
    } 

    
    public static Id createTestRecordType15() {
        Id rt2Id;
        if(Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id') != null){ 
            rt2Id = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        }
        return rt2Id;
    }
    
    public static RecordType createTestRecordType16() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Program').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Program',Name='Program',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Id,Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Program'];
            return rt;
        }
    }
    public static RecordType createTestRecordType17() {
        Id RecordTypeId = Schema.SObjectType.Account_Team__c.getRecordTypeInfosByName().get('Non SFDC User').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Non_SFDC_User',Name='Non SFDC User',SobjectType = 'Account_Team__c');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Account_Team__c' and DeveloperName = 'Non_SFDC_User'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType18() {
        Id RecordTypeId = Schema.SObjectType.Forecast_Snapshot__c.getRecordTypeInfosByName().get('Part').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Part',Name='Part',SobjectType = 'Forecast_Snapshot__c');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Forecast_Snapshot__c' and DeveloperName = 'Part'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType19() {
        Id RecordTypeId = Schema.SObjectType.Forecast_Snapshot__c.getRecordTypeInfosByName().get('Opportunity').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Opportunity',Name='Opportunity',SobjectType = 'Forecast_Snapshot__c');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Forecast_Snapshot__c' and DeveloperName = 'Opportunity'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType20() {
        Id RecordTypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Sales Parts').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Sales_Parts',Name='Sales Parts',SobjectType = 'Opportunity_Part__c');
        else
        {
            RecordType rt = [SELECT Name, Id, DeveloperName, SobjectType FROM RecordType where SobjectType='Opportunity_Part__c' and DeveloperName = 'Sales_Parts'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType21() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Other').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CIS_Other',Name='Other',SobjectType = 'Account');
        else
        {
            RecordType rt = [select Id, Name from RecordType where DeveloperName = 'CIS_Other' and SobjectType = 'Account' and Name = 'Other'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType22() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Competitor',Name='Competitor',SobjectType = 'Account');
        else
        {
            RecordType rt = [select Id, Name from RecordType where DeveloperName = 'Competitor' and SobjectType = 'Account'];
            return rt;
        }
    }
    public static RecordType createTestRecordType23() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'NDR_Opportunity',Name='NDR Opportunity',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'NDR_Opportunity'];
            return rt;
        }
    }        
    public static RecordType createTestRecordType24() {
        Id RecordTypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('NDR Opportunity Parts').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'NDR_Opportunity_Parts',Name='NDR Opportunity Parts',SobjectType = 'Opportunity_Part__c');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Opportunity_Part__c' and DeveloperName = 'NDR_Opportunity_Parts'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType25() {
        Id RecordTypeId = Schema.SObjectType.APL_Forecast_Management__c.getRecordTypeInfosByName().get('AM').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'AM',Name='AM',SobjectType = 'APL_Forecast_Management__c');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'APL_Forecast_Management__c' and DeveloperName = 'AM'];
            return rt;
        }
    }
    public static RecordType createTestRecordType26() {
        Id RecordTypeId = Schema.SObjectType.APL_Forecast_Management__c.getRecordTypeInfosByName().get('Relay').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Relay',Name='Relay',SobjectType = 'APL_Forecast_Management__c');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'APL_Forecast_Management__c' and DeveloperName = 'Relay'];
            return rt;
        }
    } 
    
    public static RecordType createTestRecordType27() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Grouped Accounts').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CIS_Global_Account',Name='Grouped Accounts',SobjectType = 'Account');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Account' and DeveloperName = 'Grouped Accounts'];
            return rt;
        }
    }  
    
    public static RecordType createTestRecordType28() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Engineering Project').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Opportunity_Engineering_Project',Name='Opportunity - Engineering Project',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Opportunity_Engineering_Project'];
            return rt;
        }
    }
    public static RecordType createTestRecordType29() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Channel- Sales Opportunity').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Channel_Sales_Opportunity',Name='Channel- Sales Opportunity',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Channel_Sales_Opportunity'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType30() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Channel- Engineering Opportunity').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Channel_Engineering_Opportunity',Name='Channel- Engineering Opportunity',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Channel_Engineering_Opportunity'];
            return rt;
        }
    }     
    public static RecordType createTestRecordType31() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'ADM',Name='ADM',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Id, Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'ADM'];
            return rt;
        }
    } 
    public static RecordType createTestRecordType32() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Energy - Sales').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Energy_Sales',Name='Energy - Sales',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Id, Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Energy_Sales'];
            return rt;
        }
    }
            
    public static Apex_Helper_Settings__c createTestName1() {
        
        getAllApex_Helper_Settings();
        list<Apex_Helper_Settings__c> list_ahs = new list<Apex_Helper_Settings__c>();
        
        Apex_Helper_Settings__c ahs = map_ahs.get('System Admin Profile Id');
        
        if(ahs == null || ahs.Value__c == null){
            Profile p2 = [Select Id, Name From Profile where Name ='System Administrator' limit 1];
            ahs = new Apex_Helper_Settings__c();
            ahs.Name = 'System Admin Profile Id';
            ahs.Value__c = p2.Id;
            list_ahs.add(ahs);
        }
        
        Apex_Helper_Settings__c ahs1 = map_ahs.get('Partner Admin Profile Id');
        
        if(ahs1 == null || ahs1.Value__c == null){
            Profile p22 = [Select Id, Name From Profile where Name ='Partner Admin' limit 1];
            ahs1 = new Apex_Helper_Settings__c();
            ahs1.Name = 'Partner Admin Profile Id';
            ahs1.Value__c = p22.Id;
            list_ahs.add(ahs1);
        }
        
        Apex_Helper_Settings__c ahs3 = map_ahs.get('Regional Admin Profile Id');
        
        if(ahs3 == null || ahs3.Value__c == null){
            Profile p222 = [Select Id, Name From Profile where Name ='Regional Admin' limit 1];
            ahs3 = new Apex_Helper_Settings__c();
            ahs3.Name = 'Regional Admin Profile Id';
            ahs3.Value__c = p222.Id;
            list_ahs.add(ahs3);
        }
        
        Apex_Helper_Settings__c ahs4 = map_ahs.get('Service Account Profile Id');
        
        if(ahs4 == null || ahs4.Value__c == null){
            Profile p2222 = [Select Id, Name From Profile where Name ='Service Account' limit 1];
            ahs4 = new Apex_Helper_Settings__c();
            ahs4.Name = 'Service Account Profile Id';
            ahs4.Value__c = p2222.Id;
            list_ahs.add(ahs4);
        }
        if(list_ahs.size() > 0){
            insert list_ahs;
        }
        return ahs;
    }
    
    public static Apex_Helper_Settings__c createTestName() {        
        getAllApex_Helper_Settings();
        Apex_Helper_Settings__c ahs3 = map_ahs.get('System Admin Profile Id');
        
        if(ahs3 == null || ahs3.Value__c == null){
            Profile p3 = [Select Id, Name From Profile where Name ='Service Account' limit 1];
            ahs3 = new Apex_Helper_Settings__c();
            ahs3.Name = 'System Admin Profile Id';
            ahs3.Value__c = p3.Id;
            insert ahs3;
        }
        return ahs3;
    }
    
    public static Apex_Helper_Settings__c createTestName2() {
        getAllApex_Helper_Settings();
        Apex_Helper_Settings__c ahs3 = map_ahs.get('Service Account Profile Id');
        
        if(ahs3 == null || ahs3.Value__c == null){
            Profile p3 = [Select Id, Name From Profile where Name ='Service Account' limit 1];
            ahs3 = new Apex_Helper_Settings__c();
            ahs3.Name = 'Service Account Profile Id';
            ahs3.Value__c = p3.Id;
            insert ahs3;
        }
        return ahs3;
    }
    public static Apex_Helper_Settings__c createTestName3() {
        getAllApex_Helper_Settings();
        Apex_Helper_Settings__c ahs5 = map_ahs.get('TEIS Admin User Id');
        
        if(ahs5 == null || ahs5.Value__c == null){
            Profile p2 = [Select Id, Name From Profile where Name ='System Administrator' limit 1];
            ahs5 = new Apex_Helper_Settings__c();
            ahs5.Name = 'TEIS Admin User Id';
            ahs5.Value__c = p2.Id;
            insert ahs5;
        }
        return ahs5;
    }
    public static Apex_Helper_Settings__c createTestName4() {
        getAllApex_Helper_Settings();
        
        Apex_Helper_Settings__c ahs7 = map_ahs.get('Account Record Type Id');
        
        if(ahs7 == null || ahs7.Value__c == null){
            Profile p2 = [Select Id, Name From Profile where Name ='System Administrator' limit 1];
            ahs7 = new Apex_Helper_Settings__c();
            ahs7.Name = 'Account Record Type Id';
            ahs7.Value__c = p2.Id;
            insert ahs7;
        }   
        return ahs7;
    }
    public static Apex_Helper_Settings__c createTestName5() {
        getAllApex_Helper_Settings();
        Apex_Helper_Settings__c ahs9 = map_ahs.get('GAM Record Type Id');
        
        if(ahs9 == null || ahs9.Value__c == null){
            RecordType rt14 = ClsTestHelp.createTestRecordType14();
            ahs9 = new Apex_Helper_Settings__c();
            ahs9.Name = 'GAM Record Type Id';
            ahs9.Value__c = rt14.Id;
            insert ahs9;
        }   
        return ahs9;
    }
    public static Apex_Helper_Settings__c createTestName6() {
        getAllApex_Helper_Settings();
        Apex_Helper_Settings__c ahs9 = map_ahs.get('Forecast Snapshot Part RT Id');
        
        if(ahs9 == null || ahs9.Value__c == null){
            RecordType rt18 = ClsTestHelp.createTestRecordType18();
            ahs9 = new Apex_Helper_Settings__c();
            ahs9.Name = 'Forecast Snapshot Part RT Id';
            ahs9.Value__c = rt18.Id;
            insert ahs9;
        }   
        return ahs9;
    }
    public static Apex_Helper_Settings__c createTestName7() {
        getAllApex_Helper_Settings();
        Apex_Helper_Settings__c ahs9 = map_ahs.get('Forecast Snapshot Oppy RT Id');
        
        if(ahs9 == null || ahs9.Value__c == null){
            RecordType rt18 = ClsTestHelp.createTestRecordType19();
            ahs9 = new Apex_Helper_Settings__c();
            ahs9.Name = 'Forecast Snapshot Oppy RT Id';
            ahs9.Value__c = rt18.Id;
            insert ahs9;
        }   
        return ahs9;
    }
    public static Apex_Helper_Settings__c createTestName8() {
        getAllApex_Helper_Settings();
        Apex_Helper_Settings__c ahs9 = map_ahs.get('Sales Parts RT Id');
        
        if(ahs9 == null || ahs9.Value__c == null){
            RecordType rt18 = ClsTestHelp.createTestRecordType20();
            ahs9 = new Apex_Helper_Settings__c();
            ahs9.Name = 'Sales Parts RT Id';
            ahs9.Value__c = rt18.Id;
            insert ahs9;
        }   
        return ahs9;
    }
    public static Apex_Helper_Settings__c createTestName9() {
        getAllApex_Helper_Settings();
        Apex_Helper_Settings__c ahs10 = map_ahs.get('BU Admin Profile Id');
        
        if(ahs10 == null || ahs10.Value__c == null){
            Profile p2 = [Select Id, Name From Profile where Name ='BU Admin' limit 1];
            ahs10 = new Apex_Helper_Settings__c();
            ahs10.Name = 'BU Admin Profile Id';
            ahs10.Value__c = p2.Id;
            insert ahs10;
        }   
        return ahs10;
    }
    public static Apex_Helper_Settings__c createTestName10() {  
        getAllApex_Helper_Settings(); 
        Apex_Helper_Settings__c ahs11 = map_ahs.get('NDR Opportunity');
        
        if(ahs11 == null || ahs11.Value__c == null){
            RecordType rt23 = ClsTestHelp.createTestRecordType23();
            ahs11 = new Apex_Helper_Settings__c();
            ahs11.Name = 'NDR Opportunity';
            ahs11.Value__c = rt23.Id;
            insert ahs11;
        } 
        return ahs11;
    }
    public static Apex_Helper_Settings__c createTestName11() {  
        getAllApex_Helper_Settings();  
        Apex_Helper_Settings__c ahs12 = map_ahs.get('NDR Opportunity Parts');
        
        if(ahs12 == null || ahs12.Value__c == null){
            RecordType rt24 = ClsTestHelp.createTestRecordType24();
            ahs12 = new Apex_Helper_Settings__c();
            ahs12.Name = 'NDR Opportunity Parts';
            ahs12.Value__c = rt24.Id;
            insert ahs12;
        } 
        return ahs12;
    }
    public static Apex_Helper_Settings__c createTestName12(){
        getAllApex_Helper_Settings();                
        Apex_Helper_Settings__c ahs13 = map_ahs.get('Unidentified Account for NDR');
        
        if(ahs13 == null || ahs13.Value__c == null){
            RecordType rt24 = ClsTestHelp.createTestRecordType24(); 
            ahs13 = new Apex_Helper_Settings__c();
            ahs13.Name = 'Unidentified Account for NDR';
            ahs13.Value__c = rt24.Id;
            insert ahs13;
        } 
        return ahs13;
    }
    public static Apex_Helper_Settings__c createTestName13(){
        getAllApex_Helper_Settings();                
        Apex_Helper_Settings__c ahs14 = map_ahs.get('Appliance Opportunity Record Type Id');
        
        if(ahs14 == null || ahs14.Value__c == null){
            RecordType rt24 = ClsTestHelp.createTestRecordType24();
            ahs14 = new Apex_Helper_Settings__c();
            ahs14.Name = 'Appliance Opportunity Record Type Id';
            ahs14.Value__c = rt24.Id;
            insert ahs14;
        } 
        return ahs14;
    }
    //added by nelson zheng 2015-10-20 begin
    public static Apex_Helper_Settings__c createTestName14(){
        getAllApex_Helper_Settings();                
        Apex_Helper_Settings__c ahs14 = map_ahs.get('Currency Confirm Except Users');
        
        if(ahs14 == null || ahs14.Value__c == null){
            ahs14 = new Apex_Helper_Settings__c();
            ahs14.Name = 'Currency Confirm Except Users';
            ahs14.Value__c = '005E0000000XIav';
            insert ahs14;
        } 
        return ahs14;
    }
    
    public static Apex_Helper_Settings__c createTestName15(){
        getAllApex_Helper_Settings();                
        Apex_Helper_Settings__c ahs14 = map_ahs.get('Lost Business - Appliances');
        
        if(ahs14 == null || ahs14.Value__c == null){
            ahs14 = new Apex_Helper_Settings__c();
            ahs14.Name = 'Lost Business - Appliances';
            ahs14.Value__c = '012E0000000NFbV';
            insert ahs14;
        } 
        return ahs14;
    }
    
    public static Apex_Helper_Settings__c createTestName16(){
        getAllApex_Helper_Settings();                
        Apex_Helper_Settings__c ahs14 = map_ahs.get('APL_Email_Alert_Template');
        
        if(ahs14 == null || ahs14.Value__c == null){
            ahs14 = new Apex_Helper_Settings__c();
            ahs14.Name = 'APL_Email_Alert_Template';
            ahs14.Value__c = 'https://c2s--c.na9.content.force.com/servlet/servlet.ImageServer?;id=015E0000000P3MB;id=015E0000001hKDe;&oid=00DE0000000Hkve;https://c2s.my.salesforce.com/';
            insert ahs14;
        } 
        return ahs14;
    }
    
    public static CSD_Exception_Email__c createCSDExceptionEmail(){
        CSD_Exception_Email__c eu = new CSD_Exception_Email__c();
        eu.Name = 'Exception User';
        eu.user_Id__c = '005E0000006CX4x';
        insert eu;
        return eu;
    }
    //added by nelson zheng 2015-10-20 end
    public static Financial_Planning_Configuration__c createTestFinancial_Planning_Configuration1() {
        getFinantialPlanConfigs();
        Financial_Planning_Configuration__c ahs7 = map_FinantialPlanConfig.get('Set AM Frozen Date');
        
        if(ahs7 == null || ahs7.Name == null){
            ahs7 = new Financial_Planning_Configuration__c();
            ahs7.Class__c = 'ClsBatch_setLastASMFrozenDate';
            ahs7.Used4BatchManagement__c = true;
            ahs7.Name = 'Set AM Frozen Date';
            insert ahs7;
        }   
        return ahs7;
    }
    public static Financial_Planning_Configuration__c createTestFinancial_Planning_Configuration2() {
        getFinantialPlanConfigs();
        Financial_Planning_Configuration__c ahs7 = map_FinantialPlanConfig.get('Set RSM Frozen Date');
        
        if(ahs7 == null || ahs7.Name == null){
            ahs7 = new Financial_Planning_Configuration__c();
            ahs7.Class__c = 'ClsBatch_setLastRSMFrozenDate';
            ahs7.Used4BatchManagement__c = true;
            ahs7.Name = 'Set RSM Frozen Date';
            insert ahs7;
        }   
        return ahs7;
    }
    public static Financial_Planning_Configuration__c createTestFinancial_Planning_Configuration3() {
        getFinantialPlanConfigs();
        Financial_Planning_Configuration__c ahs7 = map_FinantialPlanConfig.get('Restatement');
        
        if(ahs7 == null || ahs7.Name == null){
            ahs7 = new Financial_Planning_Configuration__c();
            ahs7.Class__c = 'ClsBatch_FinancialplanningRestatement';
            ahs7.Used4BatchManagement__c = true;
            ahs7.Name = 'Restatement';
            insert ahs7;
        }   
        return ahs7;
    }
    public static Financial_Planning_Configuration__c createTestFinancial_Planning_Configuration4() {
        getFinantialPlanConfigs();
        Financial_Planning_Configuration__c ahs7 = map_FinantialPlanConfig.get('Update AM Previous Forecast');
        
        if(ahs7 == null || ahs7.Name == null){
            ahs7 = new Financial_Planning_Configuration__c();
            ahs7.Class__c = 'ClsBatch_recalculateAccountForecast';
            ahs7.Used4BatchManagement__c = true;
            ahs7.Name = 'Update AM Previous Forecast';
            insert ahs7;
        }   
        return ahs7;
    }   
    public static Financial_Planning_Configuration__c createTestFinancial_Planning_Configuration5() {
        getFinantialPlanConfigs();
        Financial_Planning_Configuration__c ahs7 = map_FinantialPlanConfig.get('Calculate Backlog & Currency');
        
        if(ahs7 == null || ahs7.Name == null){
            ahs7 = new Financial_Planning_Configuration__c();
            ahs7.Class__c = 'ClsBatch_calculateBBBMBacklog';
            ahs7.Used4BatchManagement__c = true;
            ahs7.Name = 'Calculate Backlog & Currency';
            insert ahs7;
        }   
        return ahs7;
    }   
    public static Financial_Planning_Configuration__c createTestFinancial_Planning_Configuration6() {
        getFinantialPlanConfigs();
        Financial_Planning_Configuration__c ahs7 = map_FinantialPlanConfig.get('Update RSM Previous Forecast');
        
        if(ahs7 == null || ahs7.Name == null){
            ahs7 = new Financial_Planning_Configuration__c();
            ahs7.Class__c = 'ClsBatch_recalculateRSMPreviousForecast';
            ahs7.Used4BatchManagement__c = true;
            ahs7.Name = 'Update RSM Previous Forecast';
            insert ahs7;
        }   
        return ahs7;
    }   
    public static TE_Connection__c createTestTEConnection() {
        TE_Connection__c tec = TE_Connection__c.getinstance('CentralOrg');
        
        if(tec == null || tec.Source_BU__c == null){
            tec = new TE_Connection__c();
            tec.Source_BU__c ='TE Connectivity: CIS QA';
            tec.Name = 'CentralOrg';
            insert tec;
        }   
        return tec;
    } 
    public static Opportunity_Approvers__c createTestOpportunityApprovers() {
        getOpportunityApprovers();
        Opportunity_Approvers__c oa = map_OppApprovers.get('A&C GPLs 01');
        
        if(oa == null || oa.Id == null){
            oa = new Opportunity_Approvers__c();
            oa.GPLs__c = 'A39,K01,K03,176';
            oa.Name = 'A&C GPLs 01';
            insert oa;
        }
        else{
            oa.GPLs__c = 'A39,K01,K03,176';
            update oa;
        }   
        return oa;
    }
    public static Opportunity_Approvers__c createTestOpportunityApprovers2() {
        getOpportunityApprovers();
        Opportunity_Approvers__c oa= map_OppApprovers.get('A&C GPLs 02');
        
        if(oa == null || oa.Id == null){
            oa = new Opportunity_Approvers__c();
            oa.GPLs__c = 'Z91';
            oa.Name = 'A&C GPLs 02';
            insert oa;
        }
        else{
            oa.GPLs__c = 'Z91';
            update oa;
        }   
        return oa;
    }
    public static Opportunity_Approvers__c createTestOpportunityApprovers3() {
        getOpportunityApprovers();
        Opportunity_Approvers__c oa= map_OppApprovers.get('IB GPLs');
        
        if(oa == null || oa.Id == null){
            oa = new Opportunity_Approvers__c();
            oa.GPLs__c = '375';
            oa.Name = 'IB GPLs';
            insert oa;
        }   
        else if(oa.GPLs__c == '' || oa.GPLs__c == null){
            oa.GPLs__c = '375';
            update oa;
        }
        return oa;
    }    
    public static Opportunity_Approvers__c createTestOpportunityApprovers4() {
        getOpportunityApprovers();
        Opportunity_Approvers__c oa= map_OppApprovers.get('Rail GPLs');
        
        if(oa == null || oa.Id == null){
            oa = new Opportunity_Approvers__c();
            oa.GPLs__c = '397';
            oa.Name = 'Rail GPLs';
            insert oa;
        }
        else{
            oa.GPLs__c = '397';
            update oa;
        }   
        return oa;
    }
    public static Profit_BU_Center_Mapping_Rule1__c createTestProfitBUCenterMapping1() {
        Profit_BU_Center_Mapping_Rule1__c oa = Profit_BU_Center_Mapping_Rule1__c.getinstance('30183');
        if(oa == null || oa.Id == null){
            oa = new Profit_BU_Center_Mapping_Rule1__c();
            oa.BU_Profit__c = 'A&C';
            oa.Name = '30183';
            insert oa;
        }   
        return oa;
    } 
    public static Profit_BU_Center_Mapping_Rule3__c createTestProfitBUCenterMapping3() {
        Profit_BU_Center_Mapping_Rule3__c oa= Profit_BU_Center_Mapping_Rule3__c.getinstance('241');
        if(oa == null || oa.Id == null){
            oa = new Profit_BU_Center_Mapping_Rule3__c();
            oa.BU_Profit__c = 'Rail';
            oa.Name = '241';
            insert oa;
        }   
        return oa;
    }         
    public static Profit_BU_Center_Mapping_Rule2__c createTestProfitBUCenterMapping2() {
        Profit_BU_Center_Mapping_Rule2__c oa= Profit_BU_Center_Mapping_Rule2__c.getinstance('Account_IBC_code__c');
        if(oa == null || oa.Id == null){
            oa = new Profit_BU_Center_Mapping_Rule2__c();
            oa.BU_Profit__c = '048,085,084,082,078,080,083,076,077,211,203';
            oa.Name = 'Account_IBC_code__c';
            insert oa;
        }   
        return oa;
    }   
    public static OrgWideSettings__c createTestOrgWideSettings1(){
        OrgWideSettings__c ows = OrgWideSettings__c.getinstance('Default');
        
        if(ows == null || ows.Id == null) {
            ows = new OrgWideSettings__c();
            ows.Name = 'Default';
            ows.Environment__c = 'PROD';
            ows.rtsUrl__c = 'http://requesttracking.us.tycoelectronics.com';
            ows.Datatable_Page_Size__c = 200;
            ows.Enable_Error_Logging__c = true;
            ows.Error_Email_Recipients__c = 'rob.dress@te.com; jasmine.ver@te.com';
            ows.rtsInterfaceObjectPrefix__c = 'a1K';
            ows.Search_Result_Limit__c = 200;
            ows.Send_Exception_Email__c = true;
            insert ows;
        }
        return ows;
    }
    
    public static OrgWideSettings__c createTestOrgWideSettings2(){
        OrgWideSettings__c ows = OrgWideSettings__c.getinstance('Manage Part');
        
        if(ows == null || ows.Id == null) {
            ows = new OrgWideSettings__c();
            ows.Name = 'Manage Part';
            ows.Datatable_Page_Size__c = 50;
            ows.Search_Result_Limit__c = 1000;
            insert ows;
        }
        return ows;
    }
    
    
    public static RecordType getSalesQuoteRecType(){
        Id RecordTypeId = Schema.SObjectType.Energy_Quote__c.getRecordTypeInfosByName().get('Sales Quote').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Sales Quote',Name='Sales Quote',SobjectType = 'Energy_Quote__c');
        else
        {
            RecordType rt = [select Id, Name from RecordType where DeveloperName = 'Sales Quote' and SobjectType = 'Energy_Quote__c'];
            return rt;
        }
    }
    
    
     //********************-=BEGIN:2013-09-03 added by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*****************
    //Consumer Device Custom Settings Methods Start
    public static RecordType createCSDTestRecordType1() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Engineering Opportunity-CSD').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Engineering_Opportunity_CSD',Name='Engineering Opportunity-CSD',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select id, Name, DeveloperName from RecordType where SobjectType = 'Opportunity' and Name = 'Engineering Opportunity-CSD'];
            return rt;
        }
    }  
    public static RecordType createCSDTestRecordType2() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Engineering Opportunity-CSD').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Engineering_Opportunity_CSD',Name='Engineering Opportunity-CSD',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select id, Name, DeveloperName from RecordType where SobjectType = 'Opportunity' and DeveloperName =  'Engineering_Opportunity_CSD'];
            return rt;
        }
    }
    public static RecordType createCSDTestRecordType3() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Opportunity-CSD').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Sales_Opportunity_CSD',Name='Sales Opportunity-CSD',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select id, Name, DeveloperName from RecordType where SobjectType = 'Opportunity' and Name = 'Sales Opportunity-CSD'];
            return rt;
        }
    }
    public static RecordType createCSDTestRecordType4() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Opportunity-CSD').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Sales_Opportunity_CSD',Name='Sales Opportunity-CSD',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select id, Name, DeveloperName from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Sales_Opportunity_CSD'];
            return rt;
        }
    }
    public static RecordType createCSDTestRecordType5() {
        Id RecordTypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('New Development').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'New_Development',Name='New Development',SobjectType = 'Opportunity_Part__c');
        else
        {
            RecordType rt = [select id,Name, DeveloperName from RecordType where SobjectType = 'Opportunity_Part__c' and DeveloperName = 'New_Development'];
            return rt;
        }
    } 
    public static RecordType createCSDTestRecordType6() {
        Id RecordTypeId = Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Sales Parts').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Sales_Parts',Name='Sales Parts',SobjectType = 'Opportunity_Part__c');
        else
        {
            RecordType rt = [select id,Name, DeveloperName from RecordType where SobjectType = 'Opportunity_Part__c' and DeveloperName = 'Sales_Parts'];
            return rt;
        }
    }
    public static RecordType createCSDTestRecordType7() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('OEM').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'OEM',Name='OEM',SobjectType = 'Account');
        else
        {
            RecordType rt = [select id,Name, DeveloperName from RecordType where SobjectType = 'Account' and DeveloperName = 'OEM'];
            return rt;
        }
    }   
    public static Consumer_Device_Opportunity_Record_Types__c createTestCSD1() {  
        getDevOppRecTypes();
        Consumer_Device_Opportunity_Record_Types__c csd = map_DevOppRecTypes.get('Engineering Opportunity-CSD');
        if(csd == null || csd.Record_Type_Id__c == null){
            csd = new Consumer_Device_Opportunity_Record_Types__c();
            RecordType csdRT = ClsTestHelp.createCSDTestRecordType1();  
            csd.Name = 'Engineering Opportunity-CSD';
            csd.Record_Type_Id__c = csdRT.Id;
            insert csd;
        } 
        return csd;
    }
    public static Consumer_Device_Opportunity_Record_Types__c createTestCSD2() {  
        getDevOppRecTypes();
        Consumer_Device_Opportunity_Record_Types__c csd = map_DevOppRecTypes.get('Engineering_Opportunity_CSD');
        if(csd == null || csd.Record_Type_Id__c == null){
            csd = new Consumer_Device_Opportunity_Record_Types__c();
            RecordType csdRT = ClsTestHelp.createCSDTestRecordType2();  
            csd.Name = 'Engineering_Opportunity_CSD';
            csd.Record_Type_Id__c = csdRT.Id;
            insert csd;
        } 
        return csd;
    }
    public static Consumer_Device_Opportunity_Record_Types__c createTestCSD3() {  
        getDevOppRecTypes();
        Consumer_Device_Opportunity_Record_Types__c csd = map_DevOppRecTypes.get('Sales Opportunity-CSD');
        if(csd == null || csd.Record_Type_Id__c == null){
            csd = new Consumer_Device_Opportunity_Record_Types__c();
            RecordType csdRT = ClsTestHelp.createCSDTestRecordType3(); 
            csd.Name = 'Sales Opportunity-CSD';
            csd.Record_Type_Id__c = csdRT.Id;
            insert csd;
        } 
        return csd;
    }
    public static Consumer_Device_Opportunity_Record_Types__c createTestCSD4() {  
        getDevOppRecTypes();
        Consumer_Device_Opportunity_Record_Types__c csd = map_DevOppRecTypes.get('Sales_Opportunity_CSD');
        if(csd == null || csd.Record_Type_Id__c == null){
            csd = new Consumer_Device_Opportunity_Record_Types__c();
            RecordType csdRT = ClsTestHelp.createCSDTestRecordType4();  
            csd.Name = 'Sales_Opportunity_CSD';
            csd.Record_Type_Id__c = csdRT.Id;
            insert csd;
        } 
        return csd;
    }
    public static Consumer_Device_Opportunity_Record_Types__c createTestCSD5() {
        getDevOppRecTypes();
        Consumer_Device_Opportunity_Record_Types__c csd = map_DevOppRecTypes.get('New_Development');
        if(csd == null || csd.Record_Type_Id__c == null){
            csd = new Consumer_Device_Opportunity_Record_Types__c();
            RecordType csdRT = ClsTestHelp.createCSDTestRecordType5(); 
            csd.Name = 'New_Development';
            csd.Record_Type_Id__c = csdRT.Id;
            insert csd;
        } 
        return csd;
    }
    public static Consumer_Device_Opportunity_Record_Types__c createTestCSD6() {  
        getDevOppRecTypes();
        Consumer_Device_Opportunity_Record_Types__c csd = map_DevOppRecTypes.get('Sales_Parts');
        if(csd == null || csd.Record_Type_Id__c == null){
            csd = new Consumer_Device_Opportunity_Record_Types__c();
            RecordType csdRT = ClsTestHelp.createCSDTestRecordType6();
            csd.Name = 'Sales_Parts';
            csd.Record_Type_Id__c = csdRT.Id;
            insert csd;
        } 
        return csd;
    }
    public static Consumer_Device_Opportunity_Record_Types__c createTestCSD7() {  
        getDevOppRecTypes();
        Consumer_Device_Opportunity_Record_Types__c csd = map_DevOppRecTypes.get('OEM');
        if(csd == null || csd.Record_Type_Id__c == null){
            csd = new Consumer_Device_Opportunity_Record_Types__c();
            RecordType csdRT = ClsTestHelp.createCSDTestRecordType7();  
            csd.Name = 'OEM';
            csd.Record_Type_Id__c = csdRT.Id;
            insert csd;
        } 
        return csd;
    }
    //create help method for PMV
    
    public static OpportunityStage createPMVTestOS1(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Contracting' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS2(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Developing & Differentiating' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS3(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Exploring Needs' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS4(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Initiating' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS5(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Production' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS6(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Refining & Resolving' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS7(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Won' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS8(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Lost' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS9(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'Dead' and IsActive = true];
        return os;
    }

    public static OpportunityStage createPMVTestOS10(){
        OpportunityStage os = [select id, MasterLabel, IsActive from OpportunityStage where MasterLabel = 'On Hold' and IsActive = true];
        return os;
    }

    public static RecordType createPMVTestRecordType1() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IND - Sales Project').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'IND_Sales_Project',Name='IND - Sales Project',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select id, Name, DeveloperName, BusinessProcessId from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'IND_Sales_Project'];
            return rt;
        }
    }
    public static RecordType createPMVTestRecordType2() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Sales Project').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Opportunity_Sales_Parts_Only',Name='Opportunity - Sales Project',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select id, Name, DeveloperName, BusinessProcessId from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Opportunity_Sales_Parts_Only'];
            return rt;
        }
    }
    public static RecordType createPMVTestRecordType3() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('IND - Engineering project').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'IND_Engineering_project',Name='IND - Engineering project',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select id, Name, DeveloperName, BusinessProcessId from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'IND_Engineering_project'];
            return rt;
        }
    }
    public static RecordType createPMVTestRecordType4() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Engineering Project').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Opportunity_Engineering_Project',Name='Opportunity - Engineering Project',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select id, Name, DeveloperName, BusinessProcessId from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Opportunity_Engineering_Project'];
            return rt;
        }
    }
    public static User createTestUsers4PMV() {
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.Alias = 'mtst';
        u.Email = 'mtester@ItbTestcompany.com';
        u.Username = u.Email;
        u.CommunityNickname = u.Alias;
        u.ProfileId = [select Id 
                        from Profile
                        where Name = 'System Administrator'][0].Id;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        return u;
    }
    public static Opportunity_Record_Type_Groups__c createTestOPTG1(){
        Opportunity_Record_Type_Groups__c optg4return = Opportunity_Record_Type_Groups__c.getinstance('IND_Sales_Project');
        if(optg4return == null || optg4return.RecordTypeID__c  == null){
            optg4return = new Opportunity_Record_Type_Groups__c();
            RecordType salesPMV = ClsTestHelp.createPMVTestRecordType1();
            RecordType sales = ClsTestHelp.createPMVTestRecordType2();
            optg4return.Name = 'IND_Sales_Project';
            optg4return.Active__c = true;
            optg4return.Default_Record_Type_Lead_Conversion__c = true;
            optg4return.Group__c = 'PMV';
            optg4return.Is_Sales_Only__c = true;
            optg4return.Migration_Record_Type__c = sales.Id;
            optg4return.RecordTypeID__c  = salesPMV.Id;
            insert optg4return;
        }
        return optg4return;
    }
    
    public static Opportunity_Record_Type_Groups__c createTestOPTG2(){        
        Opportunity_Record_Type_Groups__c optg4return = Opportunity_Record_Type_Groups__c.getinstance('IND_Engineering_project');
        if(optg4return == null || optg4return.RecordTypeID__c  == null){
            optg4return = new Opportunity_Record_Type_Groups__c();
            RecordType salesPMV = ClsTestHelp.createPMVTestRecordType3();
            RecordType sales = ClsTestHelp.createPMVTestRecordType4();
            optg4return.Name = 'IND_Engineering_project';
            optg4return.Active__c = true;
            optg4return.Default_Record_Type_Lead_Conversion__c = true;
            optg4return.Group__c = 'PMV';
            optg4return.Is_Sales_Only__c = false;
            optg4return.Migration_Record_Type__c = sales.Id;
            optg4return.RecordTypeID__c  = salesPMV.Id;
            insert optg4return;
        }
        return optg4return;
    }
    
    public static Opportunity_Record_Type_Groups__c createTestOPTG3(){
        
        Opportunity_Record_Type_Groups__c optg4return = Opportunity_Record_Type_Groups__c.getinstance('IND_Engineering_project');
        if(optg4return == null || optg4return.RecordTypeID__c  == null){
            optg4return = new Opportunity_Record_Type_Groups__c();
            RecordType salesPMV = ClsTestHelp.createPMVTestRecordType3();
            RecordType sales = ClsTestHelp.createPMVTestRecordType4();
            optg4return.Name = 'IND_Engineering_project';
            optg4return.Active__c = true;
            optg4return.Default_Record_Type_Lead_Conversion__c = true;
            optg4return.Group__c = 'PMV';
            optg4return.Is_Sales_Only__c = false;
            optg4return.Migration_Record_Type__c = sales.Id;
            optg4return.RecordTypeID__c  = salesPMV.Id;
            insert optg4return;
        }
        return optg4return;
    }
    
    public static Opportunity_Record_Type_Groups__c createTestOPTG4(){
        
        Opportunity_Record_Type_Groups__c optg4return = Opportunity_Record_Type_Groups__c.getinstance('DND Opportunity');
        if(optg4return == null || optg4return.RecordTypeID__c  == null){
            optg4return = new Opportunity_Record_Type_Groups__c();
            RecordType sales = ClsTestHelp.createTestRecordTypeDND();
            optg4return.Name = 'DND Opportunity';
            optg4return.Active__c = true;
            optg4return.Default_Record_Type_Lead_Conversion__c = false;
            optg4return.Group__c = 'Process Status Display';
            optg4return.Is_Sales_Only__c = false;
            optg4return.RecordTypeID__c  = sales.Id;
            insert optg4return;
        }
        return optg4return;
    }
    //Added by Archana 
      public static Opportunity_Record_Type_Groups__c createTestADM(){
        Opportunity_Record_Type_Groups__c optADMreturn = Opportunity_Record_Type_Groups__c.getinstance('ADDM');
        if(optADMreturn == null || optADMreturn.RecordTypeID__c  == null){
            optADMreturn = new Opportunity_Record_Type_Groups__c();
            RecordType salesPMV = ClsTestHelp.createPMVTestRecordType1();
            RecordType sales = ClsTestHelp.createPMVTestRecordType2();
            optADMreturn.Name = 'ADM';
            optADMreturn.Active__c = true;
            optADMreturn.Default_Record_Type_Lead_Conversion__c = true;
            optADMreturn.Group__c = 'Engineering Milestones Opportunities';
            optADMreturn.Migration_Record_Type__c = sales.Id;
            optADMreturn.RecordTypeID__c  = salesPMV.Id;
            insert optADMreturn;
        }
        return optADMreturn;
    }
    
    public static Opportunity_Record_Type_Groups__c createTestNDR(){
        Opportunity_Record_Type_Groups__c optNDRreturn = Opportunity_Record_Type_Groups__c.getinstance('NDR Opportunity');
        if(optNDRreturn == null || optNDRreturn.RecordTypeID__c == null){
            optNDRreturn = new Opportunity_Record_Type_Groups__c();
            optNDRreturn.Name = 'CCR Opportunity';
            optNDRreturn.Active__c = true;
            optNDRreturn.Default_Record_Type_Lead_Conversion__c = false;
            optNDRreturn.Group__c = 'RFQ 2.0 Quotes';
            optNDRreturn.RecordTypeID__c = createTestRecordType23().Id;
            insert optNDRreturn;
        }
        return optNDRreturn;
    }
    
    public static Opportunity_Record_Type_Groups__c createTestHLCNDR(){
        Opportunity_Record_Type_Groups__c optNDRreturn = Opportunity_Record_Type_Groups__c.getinstance('HLC- NDR Opportunity');
        if(optNDRreturn == null || optNDRreturn.RecordTypeID__c == null){
            optNDRreturn = new Opportunity_Record_Type_Groups__c();
            optNDRreturn.Name = 'HLC- NDR Opportunity';
            optNDRreturn.Active__c = true;
            optNDRreturn.Default_Record_Type_Lead_Conversion__c = false;
            optNDRreturn.Group__c = 'Change Channel Opportunities at header level';
            optNDRreturn.RecordTypeID__c = createTestRecordType23().Id;
            insert optNDRreturn;
        }
        return optNDRreturn;
    }
    
    public static PMV_Language_Config__c createTestSLC1(){
        PMV_Language_Config__c slcTemp = PMV_Language_Config__c.getinstance('de');
        if(slcTemp == null || slcTemp.Help_text_field__c == null){
            slcTemp = new PMV_Language_Config__c();
            slcTemp.Name = 'de';
            slcTemp.Active__c = true;
            slcTemp.Help_text_field__c = 'Help_Comment_German__c';
            slcTemp.Language__c = 'German';
            slcTemp.Question_text_field__c  = 'Question_German__c';
            insert slcTemp;
        }
        return slcTemp;
    }
    
    public static PMV_Language_Config__c createTestSLC2(){
        PMV_Language_Config__c slcTemp = PMV_Language_Config__c.getinstance('en_US');
        if(slcTemp == null || slcTemp.Help_text_field__c == null){
            slcTemp = new PMV_Language_Config__c();
            slcTemp.Name = 'en_US';
            slcTemp.Active__c = true;
            slcTemp.Help_text_field__c = 'Help_Comment_English__c';
            slcTemp.Language__c = 'English';
            slcTemp.Question_text_field__c  = 'Question_English__c';
            insert slcTemp;
        }
        return slcTemp;
    }
    
    public static PMV_Language_Config__c createTestSLC3(){
        PMV_Language_Config__c slcTemp = PMV_Language_Config__c.getinstance('zh_CN');
        if(slcTemp == null || slcTemp.Help_text_field__c == null){
            slcTemp = new PMV_Language_Config__c();
            slcTemp.Name = 'zh_CN';
            slcTemp.Active__c = true;
            slcTemp.Help_text_field__c = 'Help_Comment_Chinese__c';
            slcTemp.Language__c = 'Chinese (Simplified)';
            slcTemp.Question_text_field__c  = 'Question_Chinese__c';
            insert slcTemp;
        }
        return slcTemp;
    }
    
    public static PMV_Sales_Process_Settings__c createTestSSPS1(){
        PMV_Sales_Process_Settings__c sspsTemp = PMV_Sales_Process_Settings__c.getinstance('IND Standard Sales opp');
        if(sspsTemp == null || sspsTemp.Name == null){
            sspsTemp = new PMV_Sales_Process_Settings__c();
            sspsTemp.Name = 'IND Standard Sales opp';
            sspsTemp.Category__c = 'PMV Type';
            sspsTemp.Deal_Size_Max__c = 200000;
            sspsTemp.Deal_Size_Min__c = 50000;
            sspsTemp.ProjectedToClose_Threshold__c = 80; 
            sspsTemp.GIBU__c = 'Industrial';
            sspsTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            sspsTemp.PMV_Type__c = 'IND Standard Sales opp';
            sspsTemp.PMV_Type_Initialization__c = 'Standard';
            sspsTemp.Subvertical_BU__c = 'A&C,IB,Rail,Industrial';
            insert sspsTemp;
        }
        return sspsTemp;
    }
    
    public static PMV_Sales_Process_Settings__c createTestSSPS2(){
        PMV_Sales_Process_Settings__c sspsTemp = PMV_Sales_Process_Settings__c.getinstance('IND Standard ENG opp');
        if(sspsTemp == null || sspsTemp.Name == null){
            sspsTemp = new PMV_Sales_Process_Settings__c();
            sspsTemp.Name = 'IND Standard ENG opp';
            sspsTemp.Category__c = 'PMV Type';
            sspsTemp.Deal_Size_Max__c = 2000000;
            sspsTemp.Deal_Size_Min__c = 500000;
            sspsTemp.ProjectedToClose_Threshold__c = 80; 
            sspsTemp.GIBU__c = 'Industrial';
            sspsTemp.Sales_Process_ID__c = createPMVTestRecordType3().BusinessProcessId;
            sspsTemp.PMV_Type__c = 'IND Standard ENG opp';
            sspsTemp.PMV_Type_Initialization__c = 'Standard';
            sspsTemp.Subvertical_BU__c = 'A&C,IB,Rail,Industrial';
            insert sspsTemp;
        }
        return sspsTemp;
    }
        
    public static PMV_Sales_Stage_Setting__c createTestSSSS1(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_Contracting');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_Contracting';
            ssssTemp.Active__c = true;
            ssssTemp.Buyer_Cycle__c = null;
            ssssTemp.Average_Duration__c = 14;
            ssssTemp.Completion_Threshold__c = 100;
            ssssTemp.Dead_Lost_Stage__c = false;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = '50/50';
            ssssTemp.Opportunity_Parts_Process_Status__c = 'Quoted';
            ssssTemp.Production_Stage__c = false;
            ssssTemp.Priority_Stage__c = false;
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Contracting';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Team_View_Column__c = 'Pending';
            ssssTemp.Won_Stage__c = false;
            insert ssssTemp;
        }
        return ssssTemp;
    }
    
    public static PMV_Sales_Stage_Setting__c createTestSSSS2(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_Dead');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_Dead';
            ssssTemp.Active__c = true;
            ssssTemp.Dead_Lost_Stage__c = true;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = 'Dead';
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Dead';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Won_Stage__c = false;
            insert ssssTemp;
        }
        return ssssTemp;
    }
    
    public static PMV_Sales_Stage_Setting__c createTestSSSS3(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_Lost');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_Lost';
            ssssTemp.Active__c = true;
            ssssTemp.Dead_Lost_Stage__c = true;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = 'Lost';
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Dead';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Won_Stage__c = false;
            insert ssssTemp;
        }
        return ssssTemp;
    }
    
    public static PMV_Sales_Stage_Setting__c createTestSSSS4(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_Dev & Diff');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_Dev & Diff';
            ssssTemp.Active__c = true;
            ssssTemp.Buyer_Cycle__c = 'Evaluation of Options';
            ssssTemp.Average_Duration__c = 14;
            ssssTemp.Completion_Threshold__c = 70;
            ssssTemp.Dead_Lost_Stage__c = false;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = '50/50';
            ssssTemp.Opportunity_Parts_Process_Status__c = 'Demo';
            ssssTemp.Production_Stage__c = false;
            ssssTemp.Priority_Stage__c = false;
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Developing & Differentiating';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Team_View_Column__c = 'Pending';
            ssssTemp.Won_Stage__c = false;
            insert ssssTemp;
        }
        return ssssTemp;
    }
    
    public static PMV_Sales_Stage_Setting__c createTestSSSS5(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_Exploring Needs');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_Exploring Needs';
            ssssTemp.Active__c = true;
            ssssTemp.Buyer_Cycle__c = 'Recognition of Needs';
            ssssTemp.Average_Duration__c = 21;
            ssssTemp.Completion_Threshold__c = 85;
            ssssTemp.Dead_Lost_Stage__c = false;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = '50/50';
            ssssTemp.Opportunity_Parts_Process_Status__c = 'Concept';
            ssssTemp.Production_Stage__c = false;
            ssssTemp.Priority_Stage__c = false;
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Exploring Needs';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Team_View_Column__c = 'Pending';
            ssssTemp.Won_Stage__c = false;
            insert ssssTemp;
        }
        return ssssTemp;
    }

    public static PMV_Sales_Stage_Setting__c createTestSSSS6(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_Initiating');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_Initiating';
            ssssTemp.Active__c = true;
            ssssTemp.Buyer_Cycle__c = 'Changes Over Time';
            ssssTemp.Average_Duration__c = 7;
            ssssTemp.Completion_Threshold__c = 75;
            ssssTemp.Dead_Lost_Stage__c = false;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = '50/50';
            ssssTemp.Opportunity_Parts_Process_Status__c = 'Concept';
            ssssTemp.Production_Stage__c = false;
            ssssTemp.Priority_Stage__c = false;
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Initiating';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Team_View_Column__c = 'Pending';
            ssssTemp.Won_Stage__c = false;
            insert ssssTemp;
        }
        return ssssTemp;
    }

    public static PMV_Sales_Stage_Setting__c createTestSSSS7(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_On Hold');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_On Hold';
            ssssTemp.Active__c = true;
            ssssTemp.Dead_Lost_Stage__c = false;
            ssssTemp.On_Hold_Stage__c = true;
            ssssTemp.Opportunity_Parts_Confidence__c = 'On Hold';
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'On Hold';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Won_Stage__c = false;
            ssssTemp.Team_View_Column__c = 'On Hold';
            insert ssssTemp;
        }
        return ssssTemp;
    }

    public static PMV_Sales_Stage_Setting__c createTestSSSS8(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard ENG opp_Production');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard ENG opp_Production';
            ssssTemp.Active__c = true;
            ssssTemp.Buyer_Cycle__c = null;
            //ssssTemp.Average_Duration__c = 7;
            ssssTemp.Completion_Threshold__c = 100;
            ssssTemp.Dead_Lost_Stage__c = false;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = 'Won';
            ssssTemp.Opportunity_Parts_Process_Status__c = 'Production';
            ssssTemp.Production_Stage__c = true;
            ssssTemp.Priority_Stage__c = false;
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Production';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Team_View_Column__c = 'Converted';
            ssssTemp.Won_Stage__c = false;
            insert ssssTemp;
        }
        return ssssTemp;
    }

    public static PMV_Sales_Stage_Setting__c createTestSSSS9(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_Ref & Res');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_Ref & Res';
            ssssTemp.Active__c = true;
            ssssTemp.Buyer_Cycle__c = 'Resolution of Concerns';
            ssssTemp.Average_Duration__c = 14;
            ssssTemp.Completion_Threshold__c = 80;
            ssssTemp.Dead_Lost_Stage__c = false;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = '50/50';
            ssssTemp.Opportunity_Parts_Process_Status__c = 'Demo';
            ssssTemp.Production_Stage__c = false;
            ssssTemp.Priority_Stage__c = false;
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Refining & Resolving';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Team_View_Column__c = 'Pending';
            ssssTemp.Won_Stage__c = false;
            insert ssssTemp;
        }
        return ssssTemp;
    }

    public static PMV_Sales_Stage_Setting__c createTestSSSS10(){
        getPMV_Sales_Stage_Settings();
        PMV_Sales_Stage_Setting__c ssssTemp = map_PMVSalesSetting.get('IND Standard Sales opp_Won');
        
        if(ssssTemp == null || ssssTemp.Name == null){
            ssssTemp = new PMV_Sales_Stage_Setting__c();
            ssssTemp.Name = 'IND Standard Sales opp_Won';
            ssssTemp.Active__c = true;
            ssssTemp.Buyer_Cycle__c = 'Implementation';
            //ssssTemp.Average_Duration__c = 14;
            ssssTemp.Completion_Threshold__c = 65;
            ssssTemp.Dead_Lost_Stage__c = false;
            ssssTemp.On_Hold_Stage__c = false;
            ssssTemp.Opportunity_Parts_Confidence__c = 'Won';
            ssssTemp.Opportunity_Parts_Process_Status__c = 'Pre-Prod';
            ssssTemp.Production_Stage__c = false;
            ssssTemp.Priority_Stage__c = true;
            ssssTemp.Sales_Process_ID__c = createPMVTestRecordType1().BusinessProcessId;
            ssssTemp.Sales_Stage__c = 'Won';
            ssssTemp.PMV_Type__c = 'IND Standard Sales opp';
            ssssTemp.Team_View_Column__c = 'Won';
            ssssTemp.Won_Stage__c = true;
            insert ssssTemp;
        }
        return ssssTemp;
    }
   
    public static PMV_Stage_Config__c createTestSSC1(){
        getPMV_Stage_Config();
        PMV_Stage_Config__c sscTemp = map_PMVStageConfig.get('SP-Contracting');
        
        if(sscTemp == null || sscTemp.Name == null){
            sscTemp = new PMV_Stage_Config__c();
            sscTemp.Name = 'SP-Contracting';
            sscTemp.Business_ProcessID__c = createPMVTestRecordType1().BusinessProcessId;
            sscTemp.Stage_Name__c = createPMVTestOS1().MasterLabel;
            sscTemp.Stage_Id__c = createPMVTestOS1().Id;
            insert sscTemp;
        }
        return sscTemp;
    }
    public static PMV_Stage_Config__c createTestSSC2(){
        getPMV_Stage_Config();
        PMV_Stage_Config__c sscTemp = map_PMVStageConfig.get('SP-Developing & Differentiating');
        
        if(sscTemp == null || sscTemp.Name == null){
            sscTemp = new PMV_Stage_Config__c();
            sscTemp.Name = 'SP-Developing & Differentiating';
            sscTemp.Business_ProcessID__c = createPMVTestRecordType1().BusinessProcessId;
            sscTemp.Stage_Name__c = createPMVTestOS2().MasterLabel;
            sscTemp.Stage_Id__c = createPMVTestOS2().Id;
            insert sscTemp;
        }
        return sscTemp;
    }
    public static PMV_Stage_Config__c createTestSSC3(){
        getPMV_Stage_Config();
        PMV_Stage_Config__c sscTemp = map_PMVStageConfig.get('SP-Exploring Needs');
        
        if(sscTemp == null || sscTemp.Name == null){
            sscTemp = new PMV_Stage_Config__c();
            sscTemp.Name = 'SP-Exploring Needs';
            sscTemp.Business_ProcessID__c = createPMVTestRecordType1().BusinessProcessId;
            sscTemp.Stage_Name__c = createPMVTestOS3().MasterLabel;
            sscTemp.Stage_Id__c = createPMVTestOS3().Id;
            insert sscTemp;
        }
        return sscTemp;
    }
    public static PMV_Stage_Config__c createTestSSC4(){
        getPMV_Stage_Config();
        PMV_Stage_Config__c sscTemp = map_PMVStageConfig.get('SP-Initiating');
        
        if(sscTemp == null || sscTemp.Name == null){
            sscTemp = new PMV_Stage_Config__c();
            sscTemp.Name = 'SP-Initiating';
            sscTemp.Business_ProcessID__c = createPMVTestRecordType1().BusinessProcessId;
            sscTemp.Stage_Name__c = createPMVTestOS4().MasterLabel;
            sscTemp.Stage_Id__c = createPMVTestOS4().Id;
            insert sscTemp;
        }
        return sscTemp;
    }
    public static PMV_Stage_Config__c createTestSSC5(){
        getPMV_Stage_Config();
        PMV_Stage_Config__c sscTemp = map_PMVStageConfig.get('SP-Production');
        
        if(sscTemp == null || sscTemp.Name == null){
            sscTemp = new PMV_Stage_Config__c();
            sscTemp.Name = 'SP-Production';
            sscTemp.Business_ProcessID__c = createPMVTestRecordType1().BusinessProcessId;
            sscTemp.Stage_Name__c = createPMVTestOS5().MasterLabel;
            sscTemp.Stage_Id__c = createPMVTestOS5().Id;
            insert sscTemp;
        }
        return sscTemp;
    }
    public static PMV_Stage_Config__c createTestSSC6(){
        getPMV_Stage_Config();
        PMV_Stage_Config__c sscTemp = map_PMVStageConfig.get('SP-Refining & Resolving');
        
        if(sscTemp == null || sscTemp.Name == null){
            sscTemp = new PMV_Stage_Config__c();
            sscTemp.Name = 'SP-Refining & Resolving';
            sscTemp.Business_ProcessID__c = createPMVTestRecordType1().BusinessProcessId;
            sscTemp.Stage_Name__c = createPMVTestOS6().MasterLabel;
            sscTemp.Stage_Id__c = createPMVTestOS6().Id;
            insert sscTemp;
        }
        return sscTemp;
    }
    public static PMV_Stage_Config__c createTestSSC7(){
        getPMV_Stage_Config();
        PMV_Stage_Config__c sscTemp = map_PMVStageConfig.get('SP-Won');
        
        if(sscTemp == null || sscTemp.Name == null){
            sscTemp = new PMV_Stage_Config__c();
            sscTemp.Name = 'SP-Won';
            sscTemp.Business_ProcessID__c = createPMVTestRecordType1().BusinessProcessId;
            sscTemp.Stage_Name__c = createPMVTestOS7().MasterLabel;
            sscTemp.Stage_Id__c = createPMVTestOS7().Id;
            insert sscTemp;
        }
        return sscTemp;
    }
    
    public static APL_Forecast_Settings__c createAPLSetting1() {
        APL_Forecast_Settings__c aplSetting = APL_Forecast_Settings__c.getinstance('Price Decimal Places');
        if(aplSetting == null || aplSetting.Name == null ) {
            aplSetting = new APL_Forecast_Settings__c();
            aplSetting.Name = 'Price Decimal Places';
            aplSetting.Value__c = '4';
            insert aplSetting;
        }
        return aplSetting;
    }
    
    
    public static APL_Forecast_Settings__c createAPLSetting2() {
        APL_Forecast_Settings__c aplSetting = APL_Forecast_Settings__c.getinstance('Currency Rate Decimal Places');
        if(aplSetting == null || aplSetting.Name == null ) {
            aplSetting = new APL_Forecast_Settings__c();
            aplSetting.Name = 'Currency Rate Decimal Places';
            aplSetting.Value__c = '4';
            insert aplSetting;
        }
        return aplSetting;
    }
    //Consumer Device Custom Settings Methods End
    //********************-=End:2013-09-03 added by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*******************
    
    //*************** Archana Added **********************/
    
     public static RecordType createTestRecordTypeDND() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('DND Opportunity').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'DND_Opportunity',Name='DND Opportunity',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Id,Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'DND_Opportunity'];
            return rt;
        }
    }
    
     public static RecordType createTestRecordTypeEngCSD() {
        Id RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Engineering Opportunity-CSD').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'Engineering_Opportunity_CSD',Name='Engineering Opportunity-CSD',SobjectType = 'Opportunity');
        else
        {
            RecordType rt = [select Id,Name from RecordType where SobjectType = 'Opportunity' and DeveloperName = 'Engineering_Opportunity_CSD'];
            return rt;
        }
    }
    
   
      public static RecordType createProspectAccount() {
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
        if(RecordTypeId != null)
            return new RecordType(Id=RecordTypeId,DeveloperName = 'CIS_Prospect',Name='Prospect',SobjectType = 'Account');
        else
        {
            RecordType rt = [select id,Name, DeveloperName from RecordType where SobjectType = 'Account' and DeveloperName = 'CIS_Prospect'];
            return rt;
        }
    }  
    
    public static EmailTemplate createTestEmailTemplates() {
        EmailTemplate et= new EmailTemplate();
        return et;
    }
    
    public static Document createTestDocuments() {
        Document doc= new Document();
        return doc;
    }
}