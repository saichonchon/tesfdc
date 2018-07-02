/**
 *  Extensions class for page ExtAPSnapShotView_showAPSnapshot
 * 
 * @author Yuanyuan Zhang
 * @created 2012-06-25
 * @version 1.0
 * @since 23.0(ForceIDE Version)
 * 
 * 
 *
 * @changelog
 * 2012-06-25 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 * 2015-05-27 Mrunal Parate  
 * - modified - Changed logic by replacing hardcoded Record types with Custom setting containing same record type along with new record type 'Channel_Sales_Opportunity' and 'Channel_Engineering_Opportunity'
 *   for MINI SPIN Project 
 */

public with sharing class ExtAPShapShotView {

   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //public final Account_Plan__c accPlan{get;set;}
    
    public String mode{get;private set;}
    public Account_Plan__c accountPlan{get;set;}
    
    public Boolean readAccess{get;set;}
    public Boolean writeAccess{get;set;}
    
    public Boolean displayVoice{get;set;}
    public String  voiceId{get;set;}
        
    
    public Integer planYear{get;set;}
    public Integer planYearMinus3{get;set;}
    public Integer planYearMinus2{get;set;}
    public Integer planYearMinus1{get;set;}
    public Integer planYearPlus1{get;set;}
    public Integer planYearPlus4{get;set;}
    
    
    
    public list<competitor> list_competitor{get;set;}//2012-04-25 yuanyuan zhang
    public list<String> list_strategies{get;set;}
    public list<strategiesPlan> list_strategiesInitiativesPenetrationPlan{get;set;}
    public list<overview> list_overview{get;set;}
    public list<keyProduct> list_keyProduct{get;set;}
    public list<breakthroughProgram> list_breakthroughProgram{get;set;}
    public list<keyProjects> list_keyProjects{get;set;}
    public list<winsAndLosses> list_wins{get;set;}
    public list<winsAndLosses> list_losses{get;set;}
    public list<String> list_obstecles{get;set;}
    public list<tePerformance> list_tePerformance{get;set;}
    public list<winsLossProjects> list_lossProject{get;private set;}
    public list<winsLossProjects> list_winProject{get;private set;}
    
    public Id accountPlanId{get;private set;}
    public transient List<Account_Plan_Attachment__c> list_apaAttachment{get;set;}
    public Boolean isSnapshot{get;set;}
    /*
        START: 2012-05-23 added by Yuanyuan Zhang: try new charts
    */
    public Double cbcPart1{get;set;}
    public Double cbcPart2{get;set;}
    public Double cbcPart3{get;set;}
    public Double cbcPart4{get;set;}
    public Double cbcPart5{get;set;}
    
    public String cbcTop1{get;set;}
    public String cbcTop2{get;set;}
    public String cbcTop3{get;set;}
    public String cbcTop4{get;set;}
    public String cbcTop5{get;set;}
    
    /*
        END: 2012-05-23 added by Yuanyuan Zhang: try new charts
    */
    
    public Boolean hasCompanyLogo{get;set;}
    public Boolean hasManagerLogo{get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private ApexPages.standardController stdCtrl;
    private map<String, String> map_urlParams;
    private Id customerId;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
     * the constructor
     */
    public ExtAPShapShotView(ApexPages.StandardController stdCtrl) {
        this.mode = '';
        this.map_urlParams = ApexPages.currentPage().getParameters();
        this.stdCtrl = stdCtrl;
        //this.accPlan = (Account_Plan__c) this.stdCtrl.getRecord();
        accountPlanId = stdCtrl.getId();
        if(accountPlanId == null){
            mode = 'invalid';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, system.Label.Dont_allow_to_access)); 
        }
        else{
            mode = 'valid';
            init();
        }
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    private void init(){
        
        Id UsId = UserInfo.getUserId();
        System.debug('User Id ' + UsId);
        string US = [select Profile.Name from User where Id = :UserInfo.getUserId()].Profile.Name;
        //Id MGR = [select ManagerId From User Where Id = :this.accPlan.Ownerid].ManagerId;   
        
      
        readAccess = false;
        writeAccess = false;
        displayVoice = false;
        Attachment Voiceatt;
        
        //2012-04-25 yuanyuan zhang
        this.list_competitor = new list<competitor>();
        this.list_strategies = new list<String>();
        this.list_strategiesInitiativesPenetrationPlan = new list<strategiesPlan>();
        this.list_overview = new list<overview>();
        this.list_keyProduct = new list<keyProduct>();
        this.list_breakthroughProgram = new list<breakthroughProgram>();
        this.list_keyProjects = new list<keyProjects>();
        this.list_wins = new list<winsAndLosses>();
        this.list_losses = new list<winsAndLosses>();
        this.list_obstecles = new list<String>();
        this.list_tePerformance = new list<tePerformance>();
        this.list_winProject = new list<winsLossProjects>();
        this.list_lossProject = new list<winsLossProjects>();
        
        list_apaAttachment = new list<Account_Plan_Attachment__c>([Select Id, Name, Title__c,Author__c, LastModifiedDate, Type__c, CreatedBy.Name, 
                                CreatedById, Send_Attachment_to_Executive_Dashboard__c, AttachmentId__c 
                         From Account_Plan_Attachment__c 
                         Where Account_Plan__c = :this.accountPlanId 
                         and Name != 'VoiceOverview.wav' 
                         order by LastModifiedDate DESC]);
        
        this.accountPlan = new Account_Plan__c();
        this.accountPlan = [SELECT Account_Definition__c, Replicate_to_Central_Org__c,Account_Objective_1__c, Account_Objective_2__c, Account_Objective_3__c, Account_Objective_4__c, Account_Objective_5__c, Name, 
                              Active__c, Approval_Status__c, BU_Revenue_CY_Forecast_M__c, BU_Revenue_Fcst_Plan_Yr_M__c, BU_Revenue_Fcst_Plan_Yr_1_M__c, Revenue_TAM_SAM__c,
                              BU_Revenue_Fcst_Plan_Yr_4_M__c, BU_Revenue_Pct_Change_Plan_Yr_1__c, BU_Revenue_Pct_Change_Plan_Yr_4__c, BU_Revenue_Prior_Yr_Actual_M__c, 
                              BU_Revenue_YTD_Actual_M__c, BU_Revenue_Pct_Change_Plan_Yr__c, Breakthrough_Pgm_1_Comments__c, Breakthrough_Pgm_1_Status__c,Revenue_Section_Last_Updated_By__c, 
                              Breakthrough_Pgm_2_Comments__c, Breakthrough_Pgm_2_Status__c, Breakthrough_Pgm_3_Comments__c, Breakthrough_Pgm_3_Status__c, Revenue_Section_Last_Updated__c,
                              Breakthrough_Pgm_4_Comments__c, Breakthrough_Pgm_4_Status__c, Breakthrough_Program_1__c, Breakthrough_Program_2__c, Breakthrough_Program_3__c, 
                              Breakthrough_Program_4__c, Business_Unit__c, Category1_Rev_Pct_Chg_Plan_Yr_1__c, Category1_Rev_Pct_Chg_Plan_Yr_2__c, Category1_Revenue_M_Plan_Yr_1__c, 
                              Category1_Revenue_M_Plan_Yr_2__c, Category1_Revenue_M_Plan_Yr_3__c, Category2_Name__c, Category2_Rev_Pct_Chg_Plan_Yr_1__c, 
                              Category2_Rev_Pct_Chg_Plan_Yr_2__c, Category2_Revenue_M_Plan_Yr_1__c, Category2_Revenue_M_Plan_Yr_2__c, Category2_Revenue_M_Plan_Yr_3__c, 
                              Category3_Name__c, Category3_Rev_Pct_Chg_Plan_Yr_1__c, Category3_Rev_Pct_Chg_Plan_Yr_2__c, Category3_Revenue_M_Plan_Yr_1__c, 
                              Category3_Revenue_M_Plan_Yr_2__c, Category3_Revenue_M_Plan_Yr_3__c, Competitor_1__c, Competitor_1_Comments__c, Competitor_1_MS_Trend__c, 
                              Competitor_1_Market_Share__c, Competitor_2__c, Competitor_2_Comments__c, Competitor_2_MS_Trend__c, Competitor_2_Market_Share__c, Competitor_3__c, 
                              Competitor_3_Comments__c, Competitor_3_MS_Trend__c, Competitor_3_Market_Share__c, Competitor_4__c, Competitor_4_Comments__c, Competitor_4_MS_Trend__c, 
                              Competitor_4_Market_Share__c, Competitor_5__c, Competitor_5_Comments__c, Competitor_5_MS_Trend__c, Competitor_5_Market_Share__c, Competitor_6__c, 
                              Competitor_6_Comments__c, Competitor_6_MS_Trend__c, Competitor_6_Market_Share__c, CreatedById, CreatedDate, CurrencyIsoCode, Customer__c, Customer__r.Name,
                              Customer_Scorecard__c, Customer_Scorecard_Comments__c, Customer_Type__c, Definition__c, IsDeleted, Gross_Margin_Pct_Plan_Yr__c, 
                              Gross_Margin_Pct_Plan_Yr_1__c, Gross_Margin_Pct_Plan_Yr_4__c, Gross_Margin_Pct_Prior_Yr__c, Hidden_Do_Not_Use__c, Industry_Segment__c, 
                              Key_Product_1__c, Key_Product_1_Outlook__c, Key_Product_1_Pct__c, Key_Product_2__c, Key_Product_2_Outlook__c, Key_Product_2_Pct__c, Key_Product_3__c, 
                              Key_Product_3_Outlook__c, Key_Product_3_Pct__c, Key_Product_4__c, Key_Product_4_Outlook__c, Key_Product_4_Pct__c, Key_Product_5__c, 
                              Key_Product_5_Outlook__c, Key_Product_5_Pct__c, Key_Product_6__c, Key_Product_6_Outlook__c, Key_Product_6_Pct__c, Key_Product_Percent_Title__c, 
                              Key_Project_1__c, Key_Project_1__r.Name, Key_Project_1_Start_Date__c, Key_Project_1_Value_M__c, Key_Project_2__c, Key_Project_2__r.Name, Key_Project_2_Start_Date__c, Key_Project_2_Value_M__c, 
                              Key_Project_3__c, Key_Project_3__r.Name, Key_Project_3_Start_Date__c, Key_Project_3_Value_M__c, Key_Project_4__c, Key_Project_4__r.Name, Key_Project_4_Start_Date__c, Key_Project_4_Value_M__c, 
                              Key_Project_5__c, Key_Project_5__r.Name, Key_Project_5_Start_Date__c, Key_Project_5_Value_M__c, Key_Project_6__c, Key_Project_6__r.Name, Key_Project_6_Start_Date__c, Key_Project_6_Value_M__c, 
                              LastModifiedById, LastModifiedDate, Lost_Project_1__c, Lost_Project_2__c, Lost_Project_3__c, Lost_Project_4__c, Manager__c, Market_Share_Plan_Yr__c,
                              Market_Share_Plan_Yr_1__c, Market_Share_Plan_Yr_4__c, Market_Share_Prior_Yr__c, Monthly_Update__c, Monthly_Update_Last_Updated__c, Obstacle_1__c, 
                              Obstacle_2__c, Obstacle_3__c, Obstacle_4__c, Obstacle_5__c, Plan_Year__c, Purchasing_Relationship__c, Purchasing_Relationship_Comments__c, 
                              ConnectionReceivedId, Recent_Big_Win_1__c, Recent_Big_Win_1_Comments__c, Recent_Big_Win_1_Date_Won__c, Recent_Big_Win_1_Value_M__c,Monthly_Update_Last_Updated_By__c, 
                              Recent_Big_Win_2__c, Recent_Big_Win_2_Comments__c, Recent_Big_Win_2_Date_Won__c, Recent_Big_Win_2_Value_M__c, Recent_Big_Win_3__c, 
                              Recent_Big_Win_3_Comments__c, Recent_Big_Win_3_Date_Won__c, Recent_Big_Win_3_Value_M__c, Recent_Big_Win_4__c, Recent_Big_Win_4_Comments__c, 
                              Recent_Big_Win_4_Date_Won__c, Recent_Big_Win_4_Value_M__c, Recent_Loss_1__c, Recent_Loss_1_Comments__c, Recent_Loss_1_Date__c, Category1_Name__c ,
                              Recent_Loss_1_Value_M__c, Recent_Loss_2__c, Recent_Loss_2_Comments__c, Recent_Loss_2_Date__c, Recent_Loss_2_Value_M__c, Recent_Loss_3__c, 
                              Recent_Loss_3_Comments__c, Recent_Loss_3_Date__c, Recent_Loss_3_Value_M__c, Recent_Loss_4__c, Recent_Loss_4_Comments__c, Recent_Loss_4_Date__c, 
                              Recent_Loss_4_Value_M__c, Id, ConnectionSentId, Snapshot_Date__c, Status__c, Strategic_Initiative_8__c, Strategic_Initiative_8_Target__c, 
                              Strategic_Initiative_9__c, Strategic_Initiative_9_Status__c, Strategic_Initiative_9_Target__c, SystemModstamp, TAM_Pct_Change_Plan_Yr__c, 
                              TAM_Pct_Change_Plan_Yr_1__c, TAM_Pct_Change_Plan_Yr_4__c, TAM_Plan_Year_M__c, TAM_Plan_Yr_1_M__c, TAM_Plan_Yr_4_M__c, TAM_Prior_Yr_M__c, 
                              TE_Performance_Status__c, TE_Revenue_CY_Forecast_M__c, TE_Revenue_Fcst_Plan_Yr_M__c, TE_Revenue_Fcst_Plan_Yr_1_M__c, TE_Revenue_Fcst_Plan_Yr_4_M__c, 
                              TE_Revenue_Pct_Change_Plan_Yr__c, TE_Revenue_Pct_Change_Plan_Yr_1__c, TE_Revenue_Pct_Change_Plan_Yr_4__c, TE_Revenue_Prior_Yr_Actual_M__c, 
                              TE_Revenue_YTD_Actual_M__c, Sales_Figures_Makeup__c, Total_Rev_Pct_Chg_Plan_Yr_1__c, Total_Rev_Pct_Chg_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_1__c, 
                              Total_Revenue_M_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_3__c, Unique_A_Customer_Year__c, Won_Project_1__c, Won_Project_2__c, Won_Project_3__c, 
                              Won_Project_4__c, Executive_Relationship__c, Executive_Relationship_Comments__c, Engineering_Relationship__c, Engineering_Relationship_Comments__c,
                              Won_Project_1__r.Name, Won_Project_2__r.Name, Won_Project_3__r.Name, Won_Project_4__r.Name,
                              Won_Project_1__r.Five_Year_Revenue__c, Won_Project_2__r.Five_Year_Revenue__c, Won_Project_3__r.Five_Year_Revenue__c, Won_Project_4__r.Five_Year_Revenue__c,
                              Won_Project_1__r.Lost_Rejected_Dead_On_Hold_Reason__c, Won_Project_2__r.Lost_Rejected_Dead_On_Hold_Reason__c, Won_Project_3__r.Lost_Rejected_Dead_On_Hold_Reason__c, Won_Project_4__r.Lost_Rejected_Dead_On_Hold_Reason__c,
                              Won_Project_1__r.Account_Plan_Comment__c, Won_Project_2__r.Account_Plan_Comment__c, Won_Project_3__r.Account_Plan_Comment__c, Won_Project_4__r.Account_Plan_Comment__c,
                              Lost_Project_1__r.Name, Lost_Project_2__r.Name, Lost_Project_3__r.Name, Lost_Project_4__r.Name,
                              Lost_Project_1__r.Five_Year_Revenue__c, Lost_Project_2__r.Five_Year_Revenue__c, Lost_Project_3__r.Five_Year_Revenue__c, Lost_Project_4__r.Five_Year_Revenue__c,
                              Lost_Project_1__r.Lost_Rejected_Dead_On_Hold_Reason__c, Lost_Project_2__r.Lost_Rejected_Dead_On_Hold_Reason__c, 
                              Lost_Project_3__r.Lost_Rejected_Dead_On_Hold_Reason__c, Lost_Project_4__r.Lost_Rejected_Dead_On_Hold_Reason__c,
                              Lost_Project_1__r.Account_Plan_Comment__c, Lost_Project_2__r.Account_Plan_Comment__c, 
                              Lost_Project_3__r.Account_Plan_Comment__c, Lost_Project_4__r.Account_Plan_Comment__c,
                              Sales_Breakdown_1_Description__c, Sales_Breakdown_1_Percent__c, 
                              Sales_Breakdown_2_Description__c, Sales_Breakdown_2_Percent__c, Sales_Breakdown_3_Description__c, 
                              Sales_Breakdown_3_Percent__c, Sales_Breakdown_4_Description__c, Sales_Breakdown_4_Percent__c, 
                              Sales_Breakdown_5_Description__c, Sales_Breakdown_5_Percent__c,
                              Strategic_Initiative_1__c, Strategic_Initiative_1_Status__c, Strategic_Initiative_1_Target__c, 
                              Strategic_Initiative_10__c, Strategic_Initiative_10_Status__c, Strategic_Initiative_10_Target__c, 
                              Strategic_Initiative_2__c, Strategic_Initiative_2_Status__c, Strategic_Initiative_2_Target__c, Strategic_Initiative_3__c, 
                              Strategic_Initiative_3_Status__c, Strategic_Initiative_3_Target__c, Strategic_Initiative_4__c, Strategic_Initiative_4_Status__c, 
                              Strategic_Initiative_4_Target__c, Strategic_Initiative_5__c, Strategic_Initiative_5_Status__c, Strategic_Initiative_5_Target__c, 
                              Strategic_Initiative_6__c, Strategic_Initiative_6_Status__c, Strategic_Initiative_6_Target__c, Strategic_Initiative_7__c, 
                              Strategic_Initiative_7_Status__c, Strategic_Initiative_7_Target__c,Strategic_Initiative_8_Status__c,
                              Key_Project_1__r.RecordType.DeveloperName, Key_Project_1__r.Program__r.Name, Key_Project_1__r.Program__c,
                              Key_Project_2__r.RecordType.DeveloperName, Key_Project_2__r.Program__r.Name, Key_Project_2__r.Program__c,
                              Key_Project_3__r.RecordType.DeveloperName, Key_Project_3__r.Program__r.Name, Key_Project_3__r.Program__c,
                              Key_Project_4__r.RecordType.DeveloperName, Key_Project_4__r.Program__r.Name, Key_Project_4__r.Program__c,
                              Key_Project_5__r.RecordType.DeveloperName, Key_Project_5__r.Program__r.Name, Key_Project_5__r.Program__c,
                              Key_Project_6__r.RecordType.DeveloperName, Key_Project_6__r.Program__r.Name, Key_Project_6__r.Program__c,
                              Company_Logo__c, Company_Logo_Id__c,RecordTypeId, RecordType.Name, Account_Manager_Id__c, Account_Manager__c,GAM_Code__c,
                              Competitor1__c, Competitor2__c, Competitor3__c, Competitor4__c, Competitor5__c, Competitor6__c, Account_Manager_Approver__c
                        FROM Account_Plan__c
                        WHERE Id = :this.accountPlanId LIMIT 1];
        this.customerId = this.accountPlan.Customer__c;
        //2012-05-24 added by Yuanyuan Zhang : to show/hide delete button
        this.hasCompanyLogo = false;
        this.hasManagerLogo = false;
        
        //If a account plan has type 'snapshot', then it is not editbar!
        this.isSnapshot = false;
        if(this.accountPlan.RecordType.Name == 'Snapshot'){
            this.isSnapshot = true;
        }
        
        if(this.accountPlan.Company_Logo_Id__c != null){
            this.hasCompanyLogo = true;
        }
        if(this.accountPlan.Account_Manager_Id__c != null){
            this.hasManagerLogo = true;
        }
        
        
        

        try{
            Voiceatt= [select id From Attachment where Attachment.ParentId = :accountPlanId and Attachment.Name = 'VoiceOverview.wav' Limit 1];
            VoiceID = Voiceatt.id;
            displayVoice = true;
        }
        catch(Exception e){
            displayVoice = false;
        }
        if(this.accountPlan.Plan_Year__c != null){
            this.planYear = Integer.Valueof(this.accountPlan.Plan_Year__c);
            this.planYearMinus3 = this.planYear - 3;
            this.planYearMinus2 = this.planYear - 2;
            this.planYearMinus1 = this.planYear - 1;
            this.planYearPlus1 = this.planYear + 1;
            this.planYearPlus4 = this.planYear + 4;
        }
        
        //get competitors
        if(this.accountPlan.Competitor1__c != null){
            competitor comp = new competitor(this.accountPlan.Competitor1__c, this.accountPlan.Competitor_1__c, this.accountPlan.Competitor_1_Market_Share__c, this.accountPlan.Competitor_1_MS_Trend__c, this.accountPlan.Competitor_1_Comments__c);
            list_competitor.add(comp);
        }
        if(this.accountPlan.Competitor2__c != null){
            competitor comp = new competitor(this.accountPlan.Competitor2__c, this.accountPlan.Competitor_2__c, this.accountPlan.Competitor_2_Market_Share__c, this.accountPlan.Competitor_2_MS_Trend__c, this.accountPlan.Competitor_2_Comments__c);
            list_competitor.add(comp);
        }
        if(this.accountPlan.Competitor3__c != null){
            competitor comp = new competitor(this.accountPlan.Competitor3__c, this.accountPlan.Competitor_3__c, this.accountPlan.Competitor_3_Market_Share__c, this.accountPlan.Competitor_3_MS_Trend__c, this.accountPlan.Competitor_3_Comments__c);
            list_competitor.add(comp);
        }
        if(this.accountPlan.Competitor4__c != null){
            competitor comp = new competitor(this.accountPlan.Competitor4__c, this.accountPlan.Competitor_4__c, this.accountPlan.Competitor_4_Market_Share__c, this.accountPlan.Competitor_4_MS_Trend__c, this.accountPlan.Competitor_4_Comments__c);
            list_competitor.add(comp);
        }
        if(this.accountPlan.Competitor5__c != null){
            competitor comp = new competitor(this.accountPlan.Competitor5__c, this.accountPlan.Competitor_5__c, this.accountPlan.Competitor_5_Market_Share__c, this.accountPlan.Competitor_5_MS_Trend__c, this.accountPlan.Competitor_5_Comments__c);
            list_competitor.add(comp);
        }
        if(this.accountPlan.Competitor6__c != null){
            competitor comp = new competitor(this.accountPlan.Competitor6__c, this.accountPlan.Competitor_6__c, this.accountPlan.Competitor_6_Market_Share__c, this.accountPlan.Competitor_6_MS_Trend__c, this.accountPlan.Competitor_6_Comments__c);
            list_competitor.add(comp);
        }
        // get strategies list
        
        if(this.accountPlan.Account_Objective_1__c != null)
        {
            list_strategies.add(this.accountPlan.Account_Objective_1__c);
        }
        if(this.accountPlan.Account_Objective_2__c != null)
        {
            list_strategies.add(this.accountPlan.Account_Objective_2__c);
        }
        if(this.accountPlan.Account_Objective_3__c != null)
        {
            list_strategies.add(this.accountPlan.Account_Objective_3__c);
        }
        if(this.accountPlan.Account_Objective_4__c != null)
        {
            list_strategies.add(this.accountPlan.Account_Objective_4__c);
        }
        if(this.accountPlan.Account_Objective_5__c != null)
        {
            list_strategies.add(this.accountPlan.Account_Objective_5__c);
        }
        
        //get staregie initiatives penetration plans list
        if(this.accountPlan.Strategic_Initiative_1__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_1__c, this.accountPlan.Strategic_Initiative_1_Target__c, this.accountPlan.Strategic_Initiative_1_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_2__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_2__c, this.accountPlan.Strategic_Initiative_2_Target__c, this.accountPlan.Strategic_Initiative_2_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_3__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_3__c, this.accountPlan.Strategic_Initiative_3_Target__c, this.accountPlan.Strategic_Initiative_3_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_4__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_4__c, this.accountPlan.Strategic_Initiative_4_Target__c, this.accountPlan.Strategic_Initiative_4_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_5__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_5__c, this.accountPlan.Strategic_Initiative_5_Target__c, this.accountPlan.Strategic_Initiative_5_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_6__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_6__c, this.accountPlan.Strategic_Initiative_6_Target__c, this.accountPlan.Strategic_Initiative_6_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_7__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_7__c, this.accountPlan.Strategic_Initiative_7_Target__c, this.accountPlan.Strategic_Initiative_7_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_8__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_8__c, this.accountPlan.Strategic_Initiative_8_Target__c, this.accountPlan.Strategic_Initiative_8_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_9__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_9__c, this.accountPlan.Strategic_Initiative_9_Target__c, this.accountPlan.Strategic_Initiative_9_Status__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        
        //get overviews list
        overview ovTotal = new overview('Total', this.accountPlan.Total_Revenue_M_Plan_Yr_3__c, this.accountPlan.Total_Revenue_M_Plan_Yr_2__c, String.ValueOf(this.accountPlan.Total_Rev_Pct_Chg_Plan_Yr_2__c.setScale(0)), this.accountPlan.Total_Revenue_M_Plan_Yr_1__c, String.ValueOf(this.accountPlan.Total_Rev_Pct_Chg_Plan_Yr_1__c.setScale(0)));
        list_overview.add(ovTotal);
        if(this.accountPlan.Category1_Name__c != null){
            overview ov = new overview(this.accountPlan.Category1_Name__c, this.accountPlan.Category1_Revenue_M_Plan_Yr_3__c, this.accountPlan.Category1_Revenue_M_Plan_Yr_2__c, String.ValueOf(this.accountPlan.Category1_Rev_Pct_Chg_Plan_Yr_2__c.setScale(0)), this.accountPlan.Category1_Revenue_M_Plan_Yr_1__c, String.ValueOf(this.accountPlan.Category1_Rev_Pct_Chg_Plan_Yr_1__c.setScale(0)));
            list_overview.add(ov);
        }
        if(this.accountPlan.Category2_Name__c != null){
            overview ov = new overview(this.accountPlan.Category2_Name__c, this.accountPlan.Category2_Revenue_M_Plan_Yr_3__c, this.accountPlan.Category2_Revenue_M_Plan_Yr_2__c, String.ValueOf(this.accountPlan.Category2_Rev_Pct_Chg_Plan_Yr_2__c.setScale(0)), this.accountPlan.Category2_Revenue_M_Plan_Yr_1__c, String.ValueOf(this.accountPlan.Category1_Rev_Pct_Chg_Plan_Yr_1__c.setScale(0)));
            list_overview.add(ov);
        }
        if(this.accountPlan.Category3_Name__c != null){
            overview ov = new overview(this.accountPlan.Category3_Name__c, this.accountPlan.Category3_Revenue_M_Plan_Yr_3__c, this.accountPlan.Category3_Revenue_M_Plan_Yr_2__c, String.ValueOf(this.accountPlan.Category3_Rev_Pct_Chg_Plan_Yr_2__c.setScale(0)), this.accountPlan.Category3_Revenue_M_Plan_Yr_1__c, String.ValueOf(this.accountPlan.Category1_Rev_Pct_Chg_Plan_Yr_1__c.setScale(0)));
            list_overview.add(ov);
        }
        
        //Get key products list
        if(this.accountPlan.Key_Product_1__c != null){
            keyProduct kp = new keyProduct(this.accountPlan.Key_Product_1__c, this.accountPlan.Key_Product_1_Pct__c, this.accountPlan.Key_Product_1_Outlook__c);
            list_keyProduct.add(kp);
        }
        if(this.accountPlan.Key_Product_2__c != null){
            keyProduct kp = new keyProduct(this.accountPlan.Key_Product_2__c, this.accountPlan.Key_Product_2_Pct__c, this.accountPlan.Key_Product_2_Outlook__c);
            list_keyProduct.add(kp);
        }
        if(this.accountPlan.Key_Product_3__c != null){
            keyProduct kp = new keyProduct(this.accountPlan.Key_Product_3__c, this.accountPlan.Key_Product_3_Pct__c, this.accountPlan.Key_Product_3_Outlook__c);
            list_keyProduct.add(kp);
        }
        if(this.accountPlan.Key_Product_4__c != null){
            keyProduct kp = new keyProduct(this.accountPlan.Key_Product_4__c, this.accountPlan.Key_Product_4_Pct__c, this.accountPlan.Key_Product_4_Outlook__c);
            list_keyProduct.add(kp);
        }
        if(this.accountPlan.Key_Product_5__c != null){
            keyProduct kp = new keyProduct(this.accountPlan.Key_Product_5__c, this.accountPlan.Key_Product_5_Pct__c, this.accountPlan.Key_Product_5_Outlook__c);
            list_keyProduct.add(kp);
        }
        if(this.accountPlan.Key_Product_6__c != null){
            keyProduct kp = new keyProduct(this.accountPlan.Key_Product_6__c, this.accountPlan.Key_Product_6_Pct__c, this.accountPlan.Key_Product_6_Outlook__c);
            list_keyProduct.add(kp);
        }
        
        //  get break through programm 
        if(this.accountPlan.Breakthrough_Program_1__c != null){
            breakthroughProgram bp = new breakthroughProgram(this.accountPlan.Breakthrough_Program_1__c, this.accountPlan.Breakthrough_Pgm_1_Status__c, this.accountPlan.Breakthrough_Pgm_1_Comments__c);
            list_BreakthroughProgram.add(bp);
        }
        if(this.accountPlan.Breakthrough_Program_2__c != null){
            breakthroughProgram bp = new breakthroughProgram(this.accountPlan.Breakthrough_Program_2__c, this.accountPlan.Breakthrough_Pgm_2_Status__c, this.accountPlan.Breakthrough_Pgm_2_Comments__c);
            list_BreakthroughProgram.add(bp);
        }
        if(this.accountPlan.Breakthrough_Program_3__c != null){
            breakthroughProgram bp = new breakthroughProgram(this.accountPlan.Breakthrough_Program_3__c, this.accountPlan.Breakthrough_Pgm_3_Status__c, this.accountPlan.Breakthrough_Pgm_3_Comments__c);
            list_BreakthroughProgram.add(bp);
        }
        if(this.accountPlan.Breakthrough_Program_4__c != null){
            breakthroughProgram bp = new breakthroughProgram(this.accountPlan.Breakthrough_Program_1__c, this.accountPlan.Breakthrough_Pgm_4_Status__c, this.accountPlan.Breakthrough_Pgm_4_Comments__c);
            list_BreakthroughProgram.add(bp);
        }
        
        //Generate key project list
        if(this.accountPlan.Key_Project_1__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_1__r.Name, this.accountPlan.Key_Project_1_Value_M__c, this.accountPlan.Key_Project_1_Start_Date__c, this.accountPlan.Key_Project_1__c, this.accountPlan.Key_Project_1__r.RecordType.DeveloperName, this.accountPlan.Key_Project_1__r.Program__r.Name, this.accountPlan.Key_Project_1__r.Program__c);
            list_keyProjects.add(kp);
        }
        if(this.accountPlan.Key_Project_2__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_2__r.Name, this.accountPlan.Key_Project_2_Value_M__c, this.accountPlan.Key_Project_2_Start_Date__c, this.accountPlan.Key_Project_2__c, this.accountPlan.Key_Project_2__r.RecordType.DeveloperName, this.accountPlan.Key_Project_2__r.Program__r.Name, this.accountPlan.Key_Project_2__r.Program__c);
            list_keyProjects.add(kp);
        }
        if(this.accountPlan.Key_Project_3__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_3__r.Name, this.accountPlan.Key_Project_3_Value_M__c, this.accountPlan.Key_Project_3_Start_Date__c, this.accountPlan.Key_Project_3__c, this.accountPlan.Key_Project_3__r.RecordType.DeveloperName, this.accountPlan.Key_Project_3__r.Program__r.Name, this.accountPlan.Key_Project_3__r.Program__c);
            list_keyProjects.add(kp);
        }
        if(this.accountPlan.Key_Project_4__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_4__r.Name, this.accountPlan.Key_Project_4_Value_M__c, this.accountPlan.Key_Project_4_Start_Date__c, this.accountPlan.Key_Project_4__c, this.accountPlan.Key_Project_4__r.RecordType.DeveloperName, this.accountPlan.Key_Project_4__r.Program__r.Name, this.accountPlan.Key_Project_4__r.Program__c);
            list_keyProjects.add(kp);
        }
        if(this.accountPlan.Key_Project_5__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_5__r.Name, this.accountPlan.Key_Project_5_Value_M__c, this.accountPlan.Key_Project_5_Start_Date__c, this.accountPlan.Key_Project_5__c, this.accountPlan.Key_Project_5__r.RecordType.DeveloperName, this.accountPlan.Key_Project_5__r.Program__r.Name, this.accountPlan.Key_Project_5__r.Program__c);
            list_keyProjects.add(kp);
        }
        if(this.accountPlan.Key_Project_6__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_6__r.Name, this.accountPlan.Key_Project_6_Value_M__c, this.accountPlan.Key_Project_6_Start_Date__c, this.accountPlan.Key_Project_6__c, this.accountPlan.Key_Project_6__r.RecordType.DeveloperName, this.accountPlan.Key_Project_6__r.Program__r.Name, this.accountPlan.Key_Project_6__r.Program__c);
            list_keyProjects.add(kp);
        }
        
        //get recent big wins
        if(this.accountPlan.Recent_Big_Win_1__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Won_Project_1__c ,this.accountPlan.Recent_Big_Win_1__c, this.accountPlan.Recent_Big_Win_1_Value_M__c, this.accountPlan.Recent_Big_Win_1_Date_Won__c, this.accountPlan.Recent_Big_Win_1_Comments__c);
            list_wins.add(wl);
        }
        if(this.accountPlan.Recent_Big_Win_2__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Won_Project_2__c ,this.accountPlan.Recent_Big_Win_2__c, this.accountPlan.Recent_Big_Win_2_Value_M__c, this.accountPlan.Recent_Big_Win_2_Date_Won__c, this.accountPlan.Recent_Big_Win_2_Comments__c);
            list_wins.add(wl);
        }
        if(this.accountPlan.Recent_Big_Win_3__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Won_Project_3__c ,this.accountPlan.Recent_Big_Win_3__c, this.accountPlan.Recent_Big_Win_3_Value_M__c, this.accountPlan.Recent_Big_Win_3_Date_Won__c, this.accountPlan.Recent_Big_Win_3_Comments__c);
            list_wins.add(wl);
        }
        if(this.accountPlan.Recent_Big_Win_4__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Won_Project_4__c ,this.accountPlan.Recent_Big_Win_4__c, this.accountPlan.Recent_Big_Win_4_Value_M__c, this.accountPlan.Recent_Big_Win_4_Date_Won__c, this.accountPlan.Recent_Big_Win_4_Comments__c);
            list_wins.add(wl);
        }
        
        //get recent losses
        if(this.accountPlan.Recent_Loss_1__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Lost_Project_1__c ,this.accountPlan.Recent_Loss_1__c, this.accountPlan.Recent_Loss_1_Value_M__c, this.accountPlan.Recent_Loss_1_Date__c, this.accountPlan.Recent_Loss_1_Comments__c);
            list_losses.add(wl);
        }
        if(this.accountPlan.Recent_Loss_2__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Lost_Project_2__c ,this.accountPlan.Recent_Loss_2__c, this.accountPlan.Recent_Loss_2_Value_M__c, this.accountPlan.Recent_Loss_2_Date__c, this.accountPlan.Recent_Loss_2_Comments__c);
            list_losses.add(wl);
        }
        if(this.accountPlan.Recent_Loss_3__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Lost_Project_3__c ,this.accountPlan.Recent_Loss_3__c, this.accountPlan.Recent_Loss_3_Value_M__c, this.accountPlan.Recent_Loss_3_Date__c, this.accountPlan.Recent_Loss_3_Comments__c);
            list_losses.add(wl);
        }
        if(this.accountPlan.Recent_Loss_4__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Lost_Project_4__c ,this.accountPlan.Recent_Loss_4__c, this.accountPlan.Recent_Loss_4_Value_M__c, this.accountPlan.Recent_Loss_4_Date__c, this.accountPlan.Recent_Loss_4_Comments__c);
            list_losses.add(wl);
        }
        
        //get win/loss project name winsLossProjects
        if(this.accountPlan.Won_Project_1__c != null){
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Won_Project_1__r.Name,this.accountPlan.Won_Project_1__r.Five_Year_Revenue__c ,this.accountPlan.Won_Project_1__r.Account_Plan_Comment__c);
            list_winProject.add(wlp);
        }
        if(this.accountPlan.Won_Project_2__c != null){
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Won_Project_2__r.Name,this.accountPlan.Won_Project_2__r.Five_Year_Revenue__c ,this.accountPlan.Won_Project_2__r.Account_Plan_Comment__c);
            list_winProject.add(wlp);
        }
        if(this.accountPlan.Won_Project_3__c != null){
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Won_Project_3__r.Name,this.accountPlan.Won_Project_3__r.Five_Year_Revenue__c ,this.accountPlan.Won_Project_3__r.Account_Plan_Comment__c);
            list_winProject.add(wlp);
        }
        if(this.accountPlan.Won_Project_4__c != null){
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Won_Project_4__r.Name,this.accountPlan.Won_Project_4__r.Five_Year_Revenue__c ,this.accountPlan.Won_Project_4__r.Account_Plan_Comment__c);
            list_winProject.add(wlp);
        }
        
        if(this.accountPlan.Lost_Project_1__c != null){
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Lost_Project_1__r.Name,this.accountPlan.Lost_Project_1__r.Five_Year_Revenue__c ,this.accountPlan.Lost_Project_1__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp);
        }
        if(this.accountPlan.Lost_Project_2__c != null){
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Lost_Project_2__r.Name,this.accountPlan.Lost_Project_2__r.Five_Year_Revenue__c ,this.accountPlan.Lost_Project_2__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp);
        }
        if(this.accountPlan.Lost_Project_3__c != null){
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Lost_Project_3__r.Name,this.accountPlan.Lost_Project_3__r.Five_Year_Revenue__c ,this.accountPlan.Lost_Project_3__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp);
        }
        if(this.accountPlan.Lost_Project_4__c != null){
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Lost_Project_4__r.Name,this.accountPlan.Lost_Project_4__r.Five_Year_Revenue__c ,this.accountPlan.Lost_Project_4__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp);
        }
        
        //get obstacles
        if(this.accountPlan.Obstacle_1__c != null){
            list_obstecles.add(this.accountPlan.Obstacle_1__c);
        }
        if(this.accountPlan.Obstacle_2__c != null){
            list_obstecles.add(this.accountPlan.Obstacle_2__c);
        }
        if(this.accountPlan.Obstacle_3__c != null){
            list_obstecles.add(this.accountPlan.Obstacle_3__c);
        }
        if(this.accountPlan.Obstacle_4__c != null){
            list_obstecles.add(this.accountPlan.Obstacle_4__c);
        }
        if(this.accountPlan.Obstacle_5__c != null){
            list_obstecles.add(this.accountPlan.Obstacle_5__c);
        }
        
        //get TE performance
        tePerformance te = new tePerformance(system.Label.TE, this.accountPlan.TE_Revenue_Prior_Yr_Actual_M__c, this.accountPlan.TE_Revenue_YTD_Actual_M__c, 
                                              this.accountPlan.TE_Revenue_CY_Forecast_M__c, this.accountPlan.TE_Revenue_Fcst_Plan_Yr_M__c, this.accountPlan.TE_Revenue_Pct_Change_Plan_Yr__c,
                                              this.accountPlan.TE_Revenue_Fcst_Plan_Yr_1_M__c, this.accountPlan.TE_Revenue_Pct_Change_Plan_Yr_1__c,
                                              this.accountPlan.TE_Revenue_Fcst_Plan_Yr_4_M__c, this.accountPlan.TE_Revenue_Pct_Change_Plan_Yr_4__c);
        list_tePerformance.add(te);
        
        if(this.accountPlan.Business_Unit__c != null){
            tePerformance bu = new tePerformance(this.accountPlan.Business_Unit__c, this.accountPlan.BU_Revenue_Prior_Yr_Actual_M__c, this.accountPlan.BU_Revenue_YTD_Actual_M__c, 
                                              this.accountPlan.BU_Revenue_CY_Forecast_M__c, this.accountPlan.BU_Revenue_Fcst_Plan_Yr_M__c, this.accountPlan.BU_Revenue_Pct_Change_Plan_Yr__c,
                                              this.accountPlan.BU_Revenue_Fcst_Plan_Yr_1_M__c, this.accountPlan.BU_Revenue_Pct_Change_Plan_Yr_1__c,
                                              this.accountPlan.BU_Revenue_Fcst_Plan_Yr_4_M__c, this.accountPlan.BU_Revenue_Pct_Change_Plan_Yr_4__c);
            list_tePerformance.add(bu);
        }
        if(this.accountPlan.Revenue_TAM_SAM__c != null){
            tePerformance tam = new tePerformance(this.accountPlan.Revenue_TAM_SAM__c, this.accountPlan.TAM_Prior_Yr_M__c, null, 
                                              null, this.accountPlan.TAM_Plan_Year_M__c, this.accountPlan.TAM_Pct_Change_Plan_Yr__c,
                                              this.accountPlan.TAM_Plan_Yr_1_M__c, this.accountPlan.TAM_Pct_Change_Plan_Yr_1__c,
                                              this.accountPlan.TAM_Plan_Yr_4_M__c, this.accountPlan.TAM_Pct_Change_Plan_Yr_4__c);
            list_tePerformance.add(tam);
        }
        
        tePerformance ms = new tePerformance(system.Label.MS, this.accountPlan.Market_Share_Prior_Yr__c, null, 
                                              null, this.accountPlan.Market_Share_Plan_Yr__c, null,
                                              this.accountPlan.Market_Share_Plan_Yr_4__c, null,
                                              this.accountPlan.TAM_Plan_Yr_4_M__c, null);
        list_tePerformance.add(ms);
        
        
                              
        cbcPart1 = this.accountPlan.Sales_Breakdown_1_Percent__c;
        cbcPart2 = this.accountPlan.Sales_Breakdown_2_Percent__c;
        cbcPart3 = this.accountPlan.Sales_Breakdown_3_Percent__c;
        cbcPart4 = this.accountPlan.Sales_Breakdown_4_Percent__c;
        cbcPart5 = this.accountPlan.Sales_Breakdown_5_Percent__c;
        
        cbcTop1 = this.accountPlan.Sales_Breakdown_1_Description__c;
        cbcTop2 = this.accountPlan.Sales_Breakdown_2_Description__c;
        cbcTop3 = this.accountPlan.Sales_Breakdown_3_Description__c;
        cbcTop4 = this.accountPlan.Sales_Breakdown_4_Description__c;
        cbcTop5 = this.accountPlan.Sales_Breakdown_5_Description__c;
    }
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    
    
    /*
        Inner class for competitor
    */
    public class competitor{
        public Id compId{get;set;}
        public String name{get;set;}
        public Decimal marketShare{get;set;}
        public String tendend{get;set;}
        public String comment{get;set;}
        public competitor(Id accId, String comName, Decimal comMarket, String comTend, String comm){
            compId = accId;
            name = comName;
            marketShare = comMarket;
            tendend = comTend;
            comment = comm;
        }
    }
    
    /*
        Inner class for strategie initiatives/penetration plan 
    */
    public class strategiesPlan{
        public String plan{get;set;}
        public String target{get;set;}
        public String status{get;set;}
        public strategiesPlan(String straPlan, String straTarget, String straStatus){
            plan = straPlan;
            target = straTarget;
            status = straStatus;
        }
    }
    
    /*
        Inner class for overview
    */
    public class overview{
        public String name{get;set;}
        public Decimal sumYear3{get;set;}
        public Decimal sumYear2{get;set;}
        public String yoVariante2{get;set;}
        public Decimal sumYear1{get;set;}
        public String yoVariante1{get;set;}
        public overview(String ovName, Decimal year3, Decimal year2, String variYear2, Decimal year1, String variYear1){
            name = ovName;
            sumYear3 = year3;
            sumYear2 = year2;
            yoVariante2 = variYear2 + '%';
            sumYear1 = year1;
            yoVariante1 = variYear1 + '%';
        }
    }
    
    /*
        Inner class for key products
    */
    public class keyProduct{
        public String name{get;set;}
        public Decimal productPct{get;set;}
        public String productOutlook{get;set;}
        public keyProduct(String proName, Decimal proPct,String proOutlook){
            name = proName;
            productPct = proPct;
            productOutlook = proOutlook;
        }
    }
    
    /*
        Inner class for key products
    */
    public class breakthroughProgram{
        public String name{get;set;}
        public String status{get;set;}
        public String comments{get;set;}
        public breakthroughProgram(String bpname, String bpstatus,String bpcomments){
            name = bpname;
            status = bpstatus;
            comments = bpcomments;
        }
    }
    
    /*
        Inner class for key projects
    */
    public class keyProjects{
        public String name{get;private set;}
        public Decimal yearsValue{get;private set;}
        public String startDate{get;private set;}
        public String proTyp{get;private set;}
        public String masterProgramm{get;private set;}
        public Id keyProjectId{get;private set;}
        public Id masterProjectId{get;private set;}
        public keyProjects(String kpname, Decimal kpValue,String kpStart, Id kpId, String pType, String masterP, Id masId){
            name = kpname;
            yearsValue = kpValue;
            startDate = kpStart;
            //proTyp = pType;
            masterProgramm = masterP;
            keyProjectId = kpId;
            masterProjectId = masId;
            setOppyType(pType);
        }
        Public set<string> set_salesRTs = new set<string>();// Added my Mrunal for MINI SPIN Project
        Public set<string> set_engineerRTs = new set<string>();// Added my Mrunal for MINI SPIN Project
        private void setOppyType(String opType){
            system.debug('§§§§: ' + opType);
            //Change start by Mrunal for MINI Spin project, Commented hard coded record type values and Used Custom setting 'Opportunity Record type Group' for the same.
            /*if(opType == 'Opportunity_Engineering_Project'){
                proTyp = 'Engineering';
            }
            else if(opType == 'Opportunity_Sales_Parts_Only'){
                proTyp = 'Sales';
            }*/
            List<Opportunity_Record_Type_Groups__c> cusSet = Opportunity_Record_Type_Groups__c.getall().values();
            for (Opportunity_Record_Type_Groups__c rt : cusSet){
                if(rt.Active__c && rt.Group__c == 'Account Plan Snap Shot View Set Oppty type' && rt.API_Name__c!= null){
                    if (rt.Is_Sales_Only__c)
                        set_salesRTs.add(rt.API_Name__c);
                    else
                        set_engineerRTs.add(rt.API_Name__c);
                }      
            }
            system.debug('>>>set_salesRTs: '+set_salesRTs);
            system.debug('>>>set_engineerRTs: '+set_engineerRTs);
            if(set_engineerRTs.contains(opType)){
                proTyp = 'Engineering';
            }else if(set_salesRTs.contains(opType)) {
                proTyp = 'Sales';
            //Change End by MRUNAL for MINI SPIN
            }else{
                proTyp = 'Program';
            } 
        }
    }
    
    /*
        Inner class for big wins/losses
    */
    public class winsAndLosses{
        public Id oppId{get;set;}
        public String name{get;set;}
        public Decimal yearsValue{get;set;}
        public String dateValue{get;set;}
        public String comments{get;set;}
        public winsAndLosses(Id oId, String wlname, Decimal wlValue,String wlDate, String wlComment){
            oppId = oId;
            name = wlname;
            yearsValue = wlValue;
            dateValue = wlDate;
            comments = wlComment;
        }
        
        
    }
    
    /*
        Inner class for key projects
    */
    public class winsLossProjects{
        public String name{get;set;}
        public Decimal yearsValue{get;set;}
        //public String dateValue{get;set;}
        public String comments{get;set;}
        public winsLossProjects(String wlname, Decimal wlValue,String wlComment){
            name = wlname;
            yearsValue = wlValue;
            //dateValue = wlDate;
            comments = wlComment;
        }
    }
    
    /*
        Inner class for TE performance
    */
    public class tePerformance{
        public String name{get;set;}
        public String actualValue{get;set;}
        public String ytdActualValue{get;set;}
        public String forecastValue{get;set;}
        public String apValue1{get;set;}
        public String yoyValue1{get;set;}
        public String apValue2{get;set;}
        public String yoyValue2{get;set;}
        public String apValue3{get;set;}
        public String yoyValue3{get;set;}
        public tePerformance(String wlname, Decimal value1, Decimal value2, Decimal value3, Decimal value4, Decimal value5, Decimal value6, Decimal value7, Decimal value8, Decimal value9){
            name = wlname;
            actualValue = String.valueOf(value1);
            ytdActualValue = String.valueOf(value2);
            forecastValue = String.valueOf(value3);
            apValue1 = String.valueOf(value4);
            yoyValue1 = value5==null?'':String.valueOf(value5) + '%';
            apValue2 = String.valueOf(value6);
            yoyValue2 = value7==null?'':String.valueOf(value7) + '%';
            apValue3 = String.valueOf(value8);
            yoyValue3 = value9==null?'':String.valueOf(value9) + '%';
        }
        
    }
    
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}