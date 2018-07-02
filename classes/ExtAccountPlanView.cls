/**
 *  Extensions class for page ExtCustomerDetail_ShowCustomerDetail
 * 
 * @author Yuanyuan Zhang
 * @created 2012-04-24
 * @version 1.0
 * @since 23.0(ForceIDE Version) 
 * 
 *
 * @changelog
 * 2014-06-11 Lili Zhao <lili.zhao@itbconsult.com>
 * - Modified  due to change the requirement from SAP_Profit_Center_Short_Description__c to SAP_Profit_Center_Code__c,
 * - use the custom setting Account_Plan_Appliances_BU__c
 *
 * 2012-04-24 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created  
 * 2014-03-05 Lili Zhao <lili.zhao@itbconsult.com>
 * - Modified  an Account is in both groupings(Grouped B and Global Account), add a new section in which on a Global Account Plan a link to the B-Account Plan and on a B-Account Plan a link to the Global Account Plan.
 *
 * 2015-06-10 Mrunal Parate  
 * - modified - Changed logic by replacing hardcoded Record types with Custom setting containing same record type along with new record type 'Channel_Sales_Opportunity' and 'Channel_Engineering_Opportunity'
 *   for MINI SPIN Project 
 *
 * 2016-05-11 Sanghita Das
 * - Changed DTC to DND in getTECalculation() method -Case 00900947
 */ 



public class ExtAccountPlanView{
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //public final Account_Plan__c accPlan{get;set;}
    
    public String mode{get;private set;}
    public Account_Plan__c accountPlan{get;set;}
    
    public Boolean readAccess{get;set;}
    public Boolean writeAccess{get;set;}
    public Boolean unlockbtn{get;set;}
    public Boolean approvalLock{get;set;}  
    public String  changeOwner{get;set;}
    public String  displayError{get;set;}
    
    public Boolean displayVoice{get;set;}
    public String  voiceId{get;set;}
        
    
    public Integer planYear{get;set;}
    public Integer planYearMinus3{get;set;}
    public Integer planYearMinus2{get;set;}
    public Integer planYearMinus1{get;set;}
    public Integer planYearPlus1{get;set;}
    public Integer planYearPlus4{get;set;}
    public String buName{get;private set;}
    
    public String strte_prior_revernue{get;private set;}
    public String strte_actual_revernue{get;private set;}
    public String strbu_prior_revernue{get;private set;}
    public String strbu_actual_revernue{get;private set;}
    
    public list<competitor> list_competitor{get;set;}//2012-04-25 yuanyuan zhang
    public list<strategies> list_strategies{get;set;}
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
    public Boolean canApproval{get;set;}//For Approval process 
    public Boolean isSnapshot{get;set;}
    
    public transient String checkSnapshot_url{get;set;} //2014-01-30 added minghao.li@itbconsult.com
    // change start by Mrunal for R-1468
    Profile_Ids_for_access__c profIds = Profile_Ids_for_access__c.getInstance('Profiles');
    public string ids = profIds.Ids__c;
    
    public boolean chkLoggedInUser{
        get {
            if(ids.contains(Userinfo.getProfileId().substring(0,15)))
            return true;
            else
            return false;
        }
    }
    //change end by Mrunal for R-1468
    
    /*
        START: 2012-05-23 added by Yuanyuan Zhang: try new charts
    */
    /*
    public Decimal cbcPart1{get;set;}
    public Decimal cbcPart2{get;set;}
    public Decimal cbcPart3{get;set;}
    public Decimal cbcPart4{get;set;}
    public Decimal cbcPart5{get;set;}
    //public Decimal cbcPart6{get;set;}
    
    public String cbcTop1{get;set;}
    public String cbcTop2{get;set;}
    public String cbcTop3{get;set;}
    public String cbcTop4{get;set;}
    public String cbcTop5{get;set;}
    //public String cbcTop6{get;set;}
    
    public Decimal regionPart1{get;set;}
    public Decimal regionPart2{get;set;}
    public Decimal regionPart3{get;set;}
    public Decimal regionPart4{get;set;}
    public Decimal regionPart5{get;set;}
    //public Decimal regionPart6{get;set;}
    
    public String regionTop1{get;set;}
    public String regionTop2{get;set;}
    public String regionTop3{get;set;}
    public String regionTop4{get;set;}
    public String regionTop5{get;set;}
    //public String regionTop6{get;set;}
    public Decimal cbcPercent1{get;set;}
    public Decimal cbcPercent2{get;set;}
    public Decimal cbcPercent3{get;set;}
    public Decimal cbcPercent4{get;set;}
    public Decimal cbcPercent5{get;set;}
    //public Decimal cbcPercent6{get;set;}
    
    public Decimal regionPercent1{get;set;}
    public Decimal regionPercent2{get;set;}
    public Decimal regionPercent3{get;set;}
    public Decimal regionPercent4{get;set;}
    public Decimal regionPercent5{get;set;}
    */
    /*
        END: 2012-05-23 added by Yuanyuan Zhang: try new charts
    */
    
    public Boolean hasCompanyLogo{get;set;}
    public Boolean hasManagerLogo{get;set;}
    
    public Boolean showCBCPanel{get;set;}
    public Boolean showRegionPanel{get;set;}
    
    public Boolean hasSnapshot{get;set;}
    //public String snapShotId{get;set;}
    public list<snapshot> list_snapshot{get;set;}
    map<String, Decimal> map_period_amount = new map<String, Decimal>();//added by leijun 2013-04-22
    
    public String chartPeriodSql{get;set;}
    public String chartCBC3Sql{get;set;}
    public String chartRegionSql{get;set;}
    public string listPerStr{get;set;}
    //Added by Lili Zhao 2014-03-05 begin due to control related account plan
    /*
    public String strLink {get; set;}
    public boolean isGAMLink {get; set;}
    public boolean isKAMLink {get; set;}
    public String accPlanName {get; set;}
    */
    //Added by Lili Zhao 2014-03-05 end
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private ApexPages.standardController stdCtrl;
    private map<String, String> map_urlParams;
    private Id customerId;
    private final Integer millionDenominator = 1000000;
    private map<String, Decimal> map_ISOCode_convertRate;
    private String locale;
    
    //START 2012-07-17 added by Yuanyuan Zhang
    private Boolean isGlobalAccount;
    private String GAMCD;
    //END 2012-07-17 added by Yuanyuan Zhang
    
    //START 2012-07-18 Account Grouping
    private set<Id> set_accountGroupIds;
    private set<String> set_globalAccountRegion;
    //END 2012-07-18 by Yuanyuan Zhang
    private set<String> set_salesFigure;
    
    private map<String, String> map_salesFigure_type = new map<String,String>{
        'Direct' => 'Direct',
        'Indirect - Distribution' => 'POS',
        'Indirect - Contract Mfr Alloc\'s'  => 'CMA'
    };
    //add by leijun 2013-04-23
    private boolean isBAccount;
    private String MKTMGRCDE;
    //START 2013-12-02 added by lili
    private String accGAMCD;    
    public  boolean isAppliancesBU{get;set;}
    // added by lili 2014-06-12 begin due to add the BU of Industrial
    public  boolean isINDBU{get;set;}
    private Map<String, String> map_BU_IND = new Map<String, String>{
        'Rail' => 'IND',
        'A&C' => 'IND',
        'IB' => 'IND',
        'Solar' => 'IND'
    };
    // end
    // add lili zhao 2014-06-11 begin due to change the requirement 
  // from SAP_Profit_Center_Short_Description__c to SAP_Profit_Center_Code__c,use the custom setting
  /*
    private map<String, String> map_BU_Appliances = new Map<String, String>{
        'Household Appliances' => 'Appliances',
        'Relay Products - Appl' => 'Appliances'
    };
     */
    // end
    //END 2013-12-02 added by lili
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
     * the constructor
     */
    public ExtAccountPlanView(ApexPages.StandardController stdCtrl) {
        this.accGAMCD = '';
        //this.strLink = '';
        this.chartPeriodSql = ' ';
        this.chartCBC3Sql = '';
        this.chartRegionSql = '';
        this.listPerStr = '';
        //this.isKAMLink = false;
        //this.isGAMLink = false;
        this.MKTMGRCDE = '';
        this.isAppliancesBU = false; //add lili 2013.12.02
        this.isINDBU = false;
        this.mode = '';   
        this.map_urlParams = ApexPages.currentPage().getParameters();
        this.stdCtrl = stdCtrl;
        this.accountPlan = (Account_Plan__c) this.stdCtrl.getRecord();
        accountPlanId = stdCtrl.getId();
        if(accountPlanId == null){
            mode = 'invalid';
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, system.Label.Dont_allow_to_access)); 
        }
        else{
            mode = 'valid';
            try {
                init();
                
            }
            catch(Exception ex) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ex.getStackTraceString()));
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error, ex.getMessage()));
            }
        }
        
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    //Edit method
    public pageReference edit(){
        pageReference pr = new pageReference('/apex/ExtAccountPlanEdit_editAccountPlan?id=' + this.accountPlan.Id);
        pr.setRedirect(true);
        return pr;
    } 
    
    public pageReference Pdf(){
        pageReference pr = new pageReference('/apex/ExtAccountPlanView_controlPDF?id=' + this.accountPlan.Id);
        pr.setRedirect(true);
        return pr;
    }   
    
    public pageReference submitAndApproval(){
        approvalLock = true;
        unlockBtn = true;  
        
        if(!this.accountPlan.Active__c){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, system.Label.Account_Plan_Inactive));
            return null; 
        }                        
        if(this.accountPlan.Account_Manager_Approver__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, system.Label.Define_Approver));
            return null; 
        }
        else{
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(this.accountPlan.Id);
            req1.setNextApproverIds(new Id[] {this.accountPlan.Account_Manager_Approver__c});//set approver.            
            Approval.ProcessResult result = Approval.process(req1);  
            pageReference pr = new pageReference('/apex/ExtAccountPlanView_showAccountPlanDetail?id=' + this.accountPlan.Id);
            pr.setRedirect(true);
            return pr;
        }                     
    }
    /*
    public void getChartWithCBC3(){
        
        //map<String, Decimal> map_CBC3Description_amount = new map<String, Decimal>();        
        if(!this.set_accountGroupIds.isEmpty()){
            if(this.accountPlan.Plan_Year__c != null && !this.set_salesFigure.isEmpty()){
                this.chartCBC3Sql = 'select sum(Bill_Prior_Year_Amount_USD__c) total, Part__r.Product_Hierarchy__r.CBC3_Description__c cust FROM BBB_Year_Bill_Book_Cust_PN__c WHERE  Customer__c IN (';                
                list<Id> list_accountGroupIds = new list<Id>();
                list_accountGroupIds.addAll(set_accountGroupIds);                   
                for(Id accGrId : list_accountGroupIds){             
                    this.chartCBC3Sql += ' \'' + accGrId + '\', ';                               
                }     
                this.chartCBC3Sql = this.chartCBC3Sql.substring(0,this.chartCBC3Sql.length()-2);
                this.chartCBC3Sql += ') And Bill_Type__c IN (';   
                list<String> list_salesFigure = new list<String>();
                list_salesFigure.addAll(set_salesFigure);
                for(String salesFigure : list_salesFigure) {
                    this.chartCBC3Sql += ' \''+ salesFigure + '\', '; 
                }
                this.chartCBC3Sql = this.chartCBC3Sql.substring(0,this.chartCBC3Sql.length()-2);
                this.chartCBC3Sql += ') group by Part__r.Product_Hierarchy__r.CBC3_Description__c ';                 
            }
        }
        
    }
    
    
    public void getChartWithRegion(){
        
        //map<String, Decimal> map_region_amount = new map<String, Decimal>();
        if(!this.set_accountGroupIds.isEmpty()){ //&& this.isGlobalAccount){ alert by leijun 2013-04-24
            if(this.planYearMinus1 != null && !this.set_salesFigure.isEmpty()){
                String lastYear = String.valueOf(this.planYearMinus1);
                this.chartRegionSql = 'SELECT sum(Bill_Amount_USD__c) amountSum, Region__c region FROM BBB_Month_Bill_Book_Cust__c WHERE Customer__c IN (';
                list<Id> list_accountGroupIds = new list<Id>();
                list_accountGroupIds.addAll(set_accountGroupIds);                   
                for(Id accGrId : list_accountGroupIds){             
                    this.chartRegionSql += ' \'' + accGrId + '\', ';                               
                }     
                this.chartRegionSql = this.chartRegionSql.substring(0,this.chartRegionSql.length()-2);
                this.chartRegionSql += ') And Fiscal_Year__c = \'' + lastYear + '\' And Bill_Type__c IN (';   
                list<String> list_salesFigure = new list<String>();
                list_salesFigure.addAll(set_salesFigure);
                for(String salesFigure : list_salesFigure) {
                    this.chartRegionSql += ' \''+ salesFigure + '\', '; 
                }
                this.chartRegionSql = this.chartRegionSql.substring(0,this.chartRegionSql.length()-2);
                this.chartRegionSql += ') group by Region__c  ORDER BY Region__c NULLS LAST '; 
               //list<BBB_Year_Bill_Book_Cust_PN__c> list_byb = new list<BBB_Year_Bill_Book_Cust_PN__c>();
               
            }
        }
    }
    */
    public pageReference unLock(){
        this.approvalLock = false;
        this.unlockBtn = false;
        this.accountPlan.Approval_Status__c = 'Unlocked';
        update this.accountPlan;
        pageReference pr = new pageReference('/apex/ExtAccountPlanView_showAccountPlanDetail?id=' + this.accountPlan.Id);
        pr.setRedirect(true);
        return pr;
        
    }
    
    public list<snapshot> getSnapShot(){
        list<snapshot> list_return = new list<snapshot>();
        
        for(Account_Plan__c ap : [SELECT Id, CreatedDate FROM Account_Plan__c WHERE Customer__c = :this.accountPlan.Customer__c AND RecordType.DeveloperName = 'Snapshot' ORDER BY CreatedDate DESC]){
            list_return.add(new snapshot(String.ValueOf(ap.Id),ap.CreatedDate.Date().Format()));
        }
        if(list_return.size() != 0){
            hasSnapshot = true;
        }
        return list_return;
    }
    /*
    // added lili 2013.12.12 begin
    public void getChartWithSalesPeriodLili(){
        if(this.set_accountGroupIds.isEmpty() && (!this.isGlobalAccount || this.isBAccount)){//modified by leijun 2013-04-22 add B account
            return;
        }
        if(this.set_salesFigure.isEmpty()){
            return;
        }
        date startDate;
        date endDate;
        integer i = 1;
        for(Period p: [select Id, FiscalYearSettings.name, Type, StartDate, EndDate, SystemModstamp, IsForecastPeriod, QuarterLabel, PeriodLabel, Number from Period where Type= 'quarter' and EndDate<: system.today() order by startdate desc limit 8]){
            if(i == 1){
                endDate = p.EndDate;
            }   
            if(i == 8){
                startDate = p.StartDate;
            }
            i++;
        }
        map<date, Decimal> map_date_amount = new map<date, Decimal>();//(l,l)
        String filter = '';
        String str_filter = '';

        this.chartPeriodSql = 'select sum(Bill_Amount_USD__c) amountSum,Sales_Period__c salesPer FROM BBB_Month_Bill_Book_Cust__c ';
        if(!set_accountGroupIds.isEmpty()){
            list<Id> list_accountGroupIds = new list<Id>();
            list_accountGroupIds.addAll(set_accountGroupIds);
            filter += '  Customer__c In ( ';
            for(Id accGrId : list_accountGroupIds){             
                filter += ' \''+accGrId +'\', ';                               
            }     
            filter = filter.substring(0,filter.length()-2);
            filter += ')';      
        }
        if(!set_salesFigure.isEmpty()) {
            list<String> list_salesFigure = new list<String>();
            list_salesFigure.addAll(set_salesFigure);
            str_filter += ' Bill_Type__c In ( ';
            for(String salesFigure : list_salesFigure) {
                str_filter += ' \''+ salesFigure + '\', '; 
            }
            str_filter = str_filter.substring(0,str_filter.length()-2);
            str_filter += ')';  
        }
        if(str_filter != '' || filter != '' || startDate != null || endDate != null ) {
            this.chartPeriodSql += ' Where';
            if(filter != '') {
                this.chartPeriodSql += filter + ' And ';
            }
            if(str_filter != '') {
                this.chartPeriodSql += str_filter + ' And ';
            }
            if(startDate != null) {                 
                this.chartPeriodSql += ' Sales_Period__c >= ' + startDate + ' And ';
            }
            if(endDate != null) {
                this.chartPeriodSql += ' Sales_Period__c <= ' + endDate + ' And ';
            }
            this.chartPeriodSql = this.chartPeriodSql.substring(0,this.chartPeriodSql.length()-4);
        }
        this.chartPeriodSql += ' group by Sales_Period__c order by Sales_Period__c ';
        this.chartPeriodSql = this.chartPeriodSql.replaceAll(' 00:00:00', '');

        
        list<Period> list_per = new list<Period>();
        for(Period p : [SELECT Type,  EndDate, FiscalYearSettingsId, FiscalYearSettings.Name, IsForecastPeriod, Number, Id, PeriodLabel, QuarterLabel, StartDate FROM Period  Where (Type = 'Year' OR Type = 'Quarter')]){// AND IsForecastPeriod = true?
            list_per.add(p);
        }
        listPerStr = JSON.serialize(list_per);
    }
    */
    // add lili 2013.12.12 end
    
    @RemoteAction
    public static map<String, Decimal>  loadLineChart(Account_Plan__c accPlan) {    
        set<Id> set_accGroupIds = new set<Id>();
        set<String> set_salFigure = new set<String>();
        map<Date, String> map_date_fiscalQuarter = new map<Date,String>();
        map<date, Decimal> map_date_amount = new map<date, Decimal>();
        map<String, Decimal> map_period_amount = new map<String, Decimal>();
        map<String, String> map_salFigure_type = new map<String,String>{
            'Direct' => 'Direct',
            'Indirect - Distribution' => 'POS',
            'Indirect - Contract Mfr Alloc\'s'  => 'CMA'
        };
        Boolean isGlobalAcc = false; 
        Boolean isBAcc = false;
        date startDate;
        date endDate;   
        integer i = 1;  
        Account_Plan__c accountPlan = ClsAccountPlanUtility.getAccountPlanById(accPlan.Id);
        set_accGroupIds.add(accountPlan.Customer__c);           
        if(accountPlan.Customer__r.RecordType.DeveloperName == 'CIS_Global_Account' && accountPlan.Customer__r.Type == 'Global Account'){
            isGlobalAcc = true;
            for(Account acc : [SELECT Id FROM Account WHERE GAMCD__c = :accountPlan.GAM_Code__c LIMIT 10000]){ 
                set_accGroupIds.add(acc.Id);
            } 
        }else if(accountPlan.Customer__r.Type == 'Grouped B' && accountPlan.Customer__r.IND_KAM_Code__c != null){
            isBAcc = true;
            for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE IND_KAM_Code__c = :accountPlan.Customer__r.IND_KAM_Code__c LIMIT 10000]){ 
                set_accGroupIds.add(acc.Id);
            }                      
        }
        if(accountPlan.Sales_Figures_Makeup__c != null){
            for(String key : accountPlan.Sales_Figures_Makeup__c.split(';')){
                set_salFigure.add(map_salFigure_type.get(key));
            }
        }
        if(set_accGroupIds.isEmpty() && (!isGlobalAcc || isBAcc) && set_salFigure.isEmpty()){
            return map_period_amount;
        }
        for(Period p: [select Id, FiscalYearSettings.name, Type, StartDate, EndDate, SystemModstamp, IsForecastPeriod, QuarterLabel, PeriodLabel, Number from Period where Type= 'quarter' and EndDate<: system.today() order by startdate desc limit 8]){
            if(i == 1){
                endDate = p.EndDate;
            }   
            if(i == 8){
                startDate = p.StartDate;
            }
            i++;
        }
        
        for(AggregateResult byb : [select sum(Bill_Amount_USD__c) amountSum,Sales_Period__c 
                                    FROM BBB_Month_Bill_Book_Cust__c 
                                    WHERE Customer__c IN :set_accGroupIds
                                    AND Bill_Type__c IN :set_salFigure
                                    AND Sales_Period__c >=:startDate 
                                    And Sales_Period__c <=:endDate
                                    group by Sales_Period__c
                                    order by Sales_Period__c limit 50000]){
            map_date_amount.put((Date)byb.get('Sales_Period__c'),(Decimal)byb.get('amountSum'));            
        }           
        
        map_date_fiscalQuarter = ClsAccountPlanUtility.getCorrespondingFiscalQuarter(map_date_amount.keyset());
        
        for(Date d: map_date_amount.keySet()){
            if(map_date_fiscalQuarter.containsKey(d)){
                String fiscalQuarter = map_date_fiscalQuarter.get(d);
                if(map_period_amount.containsKey(fiscalQuarter)){
                    decimal amount = map_period_amount.get(fiscalQuarter);
                    amount = amount == null ? 0 : amount;
                    if(map_date_amount.get(d) != null){
                        amount += map_date_amount.get(d);
                    }
                    map_period_amount.put(fiscalQuarter,amount);    
                }else{
                    map_period_amount.put(fiscalQuarter,map_date_amount.get(d));
                }
            }
        }      
        return map_period_amount;
    }
    @RemoteAction
    public static map<String, Decimal>  loadPieCBCChart(Account_Plan__c accPlan) {  
        set<Id> set_accGroupIds = new set<Id>();
        set<String> set_salFigure = new set<String>();
        map<String, Decimal> map_CBC3Description_amount = new map<String, Decimal>();
        map<String, String> map_salFigure_type = new map<String,String>{
            'Direct' => 'Direct',
            'Indirect - Distribution' => 'POS',
            'Indirect - Contract Mfr Alloc\'s'  => 'CMA'
        };
        Boolean isGlobalAcc = false; 
        Boolean isBAcc = false;  

        Account_Plan__c accountPlan = ClsAccountPlanUtility.getAccountPlanById(accPlan.Id);
        set_accGroupIds.add(accountPlan.Customer__c);           
        if(accountPlan.Customer__r.RecordType.DeveloperName == 'CIS_Global_Account' && accountPlan.Customer__r.Type == 'Global Account'){
            //isGlobalAcc = true;
            for(Account acc : [SELECT Id FROM Account WHERE GAMCD__c = :accountPlan.GAM_Code__c LIMIT 10000]){ //Customer_Region__c
                set_accGroupIds.add(acc.Id);
            } 
        }else if(accountPlan.Customer__r.Type == 'Grouped B' && accountPlan.Customer__r.IND_KAM_Code__c != null){
            //isBAcc = true;
            for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE IND_KAM_Code__c = :accountPlan.Customer__r.IND_KAM_Code__c LIMIT 10000]){ 
                set_accGroupIds.add(acc.Id);
            }                      
        }
        if(accountPlan.Sales_Figures_Makeup__c != null){
            for(String key : accountPlan.Sales_Figures_Makeup__c.split(';')){
                set_salFigure.add(map_salFigure_type.get(key));
            }
        }
        if(accountPlan.Plan_Year__c != null && !set_accGroupIds.isEmpty() && !set_salFigure.isEmpty()){
             for(AggregateResult byb : [SELECT Part__r.Product_Hierarchy__r.CBC3_Description__c cust,Sum(Bill_Prior_Year_Amount_USD__c) total
                                                          FROM BBB_Year_Bill_Book_Cust_PN__c
                                                          WHERE  Customer__c IN :set_accGroupIds
                                                          AND Bill_Type__c IN :set_salFigure
                                                          group by Part__r.Product_Hierarchy__r.CBC3_Description__c ]){//alter limit by leijun
                map_CBC3Description_amount.put((String) byb.get('cust'), (Decimal) byb.get('total'));
            }
        }
        return map_CBC3Description_amount;
    }
    @RemoteAction
    public static map<String, Decimal>  loadPieRegionChart(Account_Plan__c accPlan) {  
        set<Id> set_accGroupIds = new set<Id>();
        set<String> set_salFigure = new set<String>();
        map<String, Decimal> map_region_amount = new map<String, Decimal>();
        map<String, String> map_salFigure_type = new map<String,String>{
            'Direct' => 'Direct',
            'Indirect - Distribution' => 'POS',
            'Indirect - Contract Mfr Alloc\'s'  => 'CMA'
        };
        Boolean isGlobalAcc = false; 
        Boolean isBAcc = false;
          
        Account_Plan__c accountPlan = ClsAccountPlanUtility.getAccountPlanById(accPlan.Id);
        set_accGroupIds.add(accountPlan.Customer__c);           
        if(accountPlan.Customer__r.RecordType.DeveloperName == 'CIS_Global_Account' && accountPlan.Customer__r.Type == 'Global Account'){
            isGlobalAcc = true;
            for(Account acc : [SELECT Id FROM Account WHERE GAMCD__c = :accountPlan.GAM_Code__c LIMIT 10000]){ //Customer_Region__c
                set_accGroupIds.add(acc.Id);
            } 
        }else if(accountPlan.Customer__r.Type == 'Grouped B' && accountPlan.Customer__r.IND_KAM_Code__c != null){
            isBAcc = true;
            for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE IND_KAM_Code__c = :accountPlan.Customer__r.IND_KAM_Code__c LIMIT 10000]){ 
                set_accGroupIds.add(acc.Id);
            }                      
        }
        if(accountPlan.Sales_Figures_Makeup__c != null){
            for(String key : accountPlan.Sales_Figures_Makeup__c.split(';')){
                set_salFigure.add(map_salFigure_type.get(key));
            }
        }
        if(accountPlan.Plan_Year__c != null && (isGlobalAcc || isBAcc)&& !set_accGroupIds.isEmpty() && !set_salFigure.isEmpty()){
            Integer planYear = Integer.Valueof(accountPlan.Plan_Year__c);
            Integer planYearMinus1 = planYear - 1;
            String lastYear = String.valueOf(planYearMinus1);
            for(Sobject byb : [SELECT sum(Bill_Amount_USD__c) amountSum, Region__c region
                               FROM BBB_Month_Bill_Book_Cust__c
                               WHERE Customer__c IN :set_accGroupIds
                               AND Fiscal_Year__c = :lastYear
                               AND Bill_Type__c IN :set_salFigure
                               group by Region__c
                               ORDER BY Region__c 
                               NULLS LAST 
                               limit 50000]){//Region__c IN :this.set_globalAccountRegion
                if(byb.get('amountSum') != null){
                    map_region_amount.put((String)byb.get('region'), (Decimal)byb.get('amountSum'));
                }
            }
        }
        return map_region_amount;
    }
    
    //added by leijun 2013-04-22
    /*
    public void getChartWithSalesPeriod(){
        if(this.set_accountGroupIds.isEmpty() && (!this.isGlobalAccount || this.isBAccount)){//modified by leijun 2013-04-22 add B account
            return;
        }
        if(this.set_salesFigure.isEmpty()){
            return;
        }
        set<String> set_year = new set<String>();
        set<String> set_quarter = new set<String>();
        map<String, set<String>> map_year_quarters = new map<String, set<String>>();
       
        date startDate;
        date endDate;
        integer i = 1;
        for(Period p: [select Id, FiscalYearSettings.name, Type, StartDate, EndDate, SystemModstamp, IsForecastPeriod, QuarterLabel, PeriodLabel, Number from Period where Type= 'quarter' and EndDate<: system.today() order by startdate desc limit 8]){
            if(i == 1){
                endDate = p.EndDate;
            }   
            if(i == 8){
                startDate = p.StartDate;
            }
            i++;
        }
        map<date, Decimal> map_date_amount = new map<date, Decimal>();
        for(AggregateResult byb : [select sum(Bill_Amount_USD__c) amountSum,Sales_Period__c 
                                    FROM BBB_Month_Bill_Book_Cust__c 
                                    WHERE Customer__c IN :this.set_accountGroupIds
                                    AND Bill_Type__c IN :this.set_salesFigure
                                    AND Sales_Period__c >=:startDate 
                                    And Sales_Period__c <=:endDate
                                    group by Sales_Period__c
                                    order by Sales_Period__c limit 50000]){
            map_date_amount.put((Date)byb.get('Sales_Period__c'),(Decimal)byb.get('amountSum'));
        
        }
        
        map<Date, String> map_date_fiscalQuarter = new map<Date,String>();
        map_date_fiscalQuarter = ClsAccountPlanUtility.getCorrespondingFiscalQuarter(map_date_amount.keyset());
        
        for(Date d: map_date_amount.keySet()){
            if(map_date_fiscalQuarter.containsKey(d)){
                String fiscalQuarter = map_date_fiscalQuarter.get(d);
                if(map_period_amount.containsKey(fiscalQuarter)){
                    decimal amount = map_period_amount.get(fiscalQuarter);
                    amount = amount == null ? 0 : amount;
                    if(map_date_amount.get(d) != null){
                        amount += map_date_amount.get(d);
                    }
                    map_period_amount.put(fiscalQuarter,amount);    
                }else{
                    map_period_amount.put(fiscalQuarter,map_date_amount.get(d));
                }
            }
        }
    }
    */
    //added by leijun 2013-04-22
    /*
    public list<Decimal> getAmount(){
        list<String> list_tmp = new list<String>();
        list<Decimal> result = new list<Decimal>();
        list_tmp.addAll(map_period_amount.keyset());
        list_tmp.sort();
        for(String d : list_tmp){
            result.add(map_period_amount.get(d));
        }       
        return result;
    }
    //added by leijun 2013-04-22
    public list<String> getFiscalQuarters(){
        list<String> list_tmp = new list<String>();
        list_tmp.addAll(map_period_amount.keyset());
        list_tmp.sort();
        //system.debug('@@@@@map_period_amount values'+map_period_amount.values());
        //return map_period_amount.values();
        return list_tmp;        
    }
    */
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //START 2012-06-18 added for pie chart
    /*
    private void getPieChartsParams(map<String, Decimal> map_description_amount, Boolean isCBC){
        Decimal sum = 0;
        //sort with amount of cbc/region
        list<Decimal> list_sort = map_description_amount.values();
        //Map use to get des parameters
        map<Decimal, list<String>> map_amount_des = new map<Decimal, list<String>>();
        
        list_sort.sort();
        Integer listSize = list_sort.size();
        //If there are less than 5 different CBC3 descrition,set loop number 0, else list size minus 5.
        Integer loopNumber;
        if(listSize <= 4){
            loopNumber = 0;
        }
        else{
            loopNumber = listSize - 4;
        }
        for(String description : map_description_amount.keySet()){
            Decimal newKey = map_description_amount.get(description);
            list<String> list_temp = new list<String>();
            if(map_amount_des.containsKey(newKey)){
                list_temp = map_amount_des.get(newKey);
                
            }
            list_temp.add(description);
            map_amount_des.put(newKey, list_temp);
        }
        //calculate with usd amonut of cbc/region
        if(isCBC){                        
            for(Integer i=listSize-1; i >= 0; i--){
                list<String> list_tempName = map_amount_des.get(list_sort[i]);
                for(String des : list_tempName){
                    if(cbcPart1 == null){
                        cbcPart1 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        //cbcPart1 = Decimal.valueOf(ClsAccountPlanUtility.setNumberFormat(locale, cbcPart1, true));//added by yinfeng.guo
                        cbcTop1 = des;
                        sum += list_sort[i];
                    }
                    else if(cbcPart2 == null){
                        cbcPart2 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        //cbcPart2 = Decimal.valueOf(ClsAccountPlanUtility.setNumberFormat(locale, cbcPart2, true));//added by yinfeng.guo
                        cbcTop2 = des;
                        sum += list_sort[i];
                    }
                    else if(cbcPart3 == null){
                        cbcPart3 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        //cbcPart3 = Decimal.valueOf(ClsAccountPlanUtility.setNumberFormat(locale, cbcPart3, true));//added by yinfeng.guo
                        cbcTop3 = des;
                        sum += list_sort[i];
                    }
                    else if(cbcPart4 == null){
                        cbcPart4 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        //cbcPart4 = Decimal.valueOf(ClsAccountPlanUtility.setNumberFormat(locale, cbcPart4, true));//added by yinfeng.guo
                        cbcTop4 = des;
                        sum += list_sort[i];
                    }
                    else{
                        cbcTop5 = 'All Others';
                        if(cbcPart5 == null){
                            cbcPart5 = list_sort[i];
                        }
                        else{
                            cbcPart5 += list_sort[i];
                        }
                        //cbcPart5 = Decimal.valueOf(ClsAccountPlanUtility.setNumberFormat(locale, cbcPart5, true));//added by yinfeng.guo
                        sum += list_sort[i];
                    }
                }
            }
            
            if(cbcPart5 != null){
                cbcPart5 = cbcPart5.setScale(1, System.Roundingmode.HALF_UP);
            }
            if(cbcPart1 != null){
                cbcPercent1 = (Decimal)cbcPart1/sum;
                cbcPercent1 = cbcPercent1.setScale(3, System.Roundingmode.HALF_UP);
                showCBCPanel = true;
            }
            else{
                showCBCPanel = false;
            }
            if(cbcPart2 != null){
                cbcPercent2 = (Decimal)cbcPart2/sum;
                cbcPercent2 = cbcPercent2.setScale(3, System.Roundingmode.HALF_UP);
            }
            if(cbcPart3 != null){
                cbcPercent3 = (Decimal)cbcPart3/sum;
                cbcPercent3 = cbcPercent3.setScale(3, System.Roundingmode.HALF_UP);
            }
            if(cbcPart4 != null){
                cbcPercent4 = (Decimal)cbcPart4/sum;
                cbcPercent4 = cbcPercent4.setScale(3, System.Roundingmode.HALF_UP);
            }
            if(cbcPart5 != null){
                cbcPercent5 = (Decimal)cbcPart5/sum;
                cbcPercent5 = cbcPercent5.setScale(3, System.Roundingmode.HALF_UP);
            }
        }
        else{                 
            for(Integer i=listSize-1; i >= 0; i--){
                list<String> list_tempName = map_amount_des.get(list_sort[i]);
                for(String des : list_tempName){
                    if(regionPart1 == null){
                        regionPart1 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        regionTop1 = des;
                        sum += list_sort[i];
                    }
                    else if(regionPart2 == null){
                        regionPart2 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        regionTop2 = des;
                        sum += list_sort[i];
                    }
                    else if(regionPart3 == null){
                        regionPart3 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        regionTop3 = des;
                        sum += list_sort[i];
                    }
                    else if(regionPart4 == null){
                        regionPart4 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        regionTop4 = des;
                        sum += list_sort[i];
                    }
                    else{
                        regionTop5 = 'All Others';
                        if(regionPart5 == null){
                            regionPart5 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        }
                        else{
                            regionPart5 += list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        }
                        sum += list_sort[i];
                    }
                }
            }
            if(regionPart5 != null){
                regionPart5 = regionPart5.setScale(1, System.Roundingmode.HALF_UP);
            }               
            
            if(regionPart1 != null && (this.isGlobalAccount || this.isBAccount)){
                regionPercent1 = regionPart1/sum;
                regionPercent1 = regionPercent1.setScale(3, System.Roundingmode.HALF_UP);
                showRegionPanel = true;
                if(regionPercent1 != null){//add by leijun
                    regionPercent1 = regionPercent1*100;
                }
            }
            else{
                showRegionPanel = false;
            }
            if(regionPart2 != null){
                regionPercent2 = regionPart2/sum;
                regionPercent2 = regionPercent2.setScale(3, System.Roundingmode.HALF_UP);
            }
            if(regionPart3 != null){
                regionPercent3 = regionPart3/sum;
                regionPercent3 = regionPercent3.setScale(3, System.Roundingmode.HALF_UP);
            }
            if(regionPart4 != null){
                regionPercent4 = regionPart4/sum;
                regionPercent4 = regionPercent4.setScale(3, System.Roundingmode.HALF_UP);
            }
            if(regionPart5 != null){
                regionPercent5 = regionPart5/sum;
                regionPercent5 = regionPercent5.setScale(3, System.Roundingmode.HALF_UP);
            }
        }
    }
    */
    //END 2012-05-24 added for pie chart
        /*
    public pageReference checkSnapshot(){
        this.mode = '';
        this.map_urlParams = ApexPages.currentPage().getParameters();
        if(map_urlParams.containsKey('id')){
            this.accountPlanId =  map_urlParams.get('id');
            String rtname = [SELECT RecordType.Name From Account_Plan__c WHERE Id = :accountPlanId].RecordType.Name;
            if(rtname == 'Snapshot'){
                pageReference pr = new pageReference('/apex/ExtAPSnapShotView_showAPSnapshot?id=' + this.accountPlan.Id);
                pr.setRedirect(true);
                return pr;
            }
        }
        return null;
    }
    */
    /**
     * This method check snapshot
     *
     @author Minghao Li
     @created 2014-01-30
     @version 1.0
     @since 23.0
     *                      the account list that insert or update
     *
     @return         void   
    */
    public String getCheckSnapshot(){
        this.mode = '';
        this.checkSnapshot_url = '';
        this.map_urlParams = ApexPages.currentPage().getParameters();
        if(map_urlParams.containsKey('id')){
            this.accountPlanId =  map_urlParams.get('id');
            String rtname = [SELECT RecordType.Name From Account_Plan__c WHERE Id = :accountPlanId].RecordType.Name;
            if(rtname == 'Snapshot'){
                this.checkSnapshot_url = ('/apex/ExtAPSnapShotView_showAPSnapshot?id=' + this.accountPlan.Id);
            }
        }
        return this.checkSnapshot_url;
    }
    
    private void init(){

        this.isBAccount = false;//add by leijun 2013-04-23 // add lili 2014.1.6
        Id UsId = UserInfo.getUserId();
        string US = [select Profile.Name from User where Id = :UserInfo.getUserId()].Profile.Name;
        //Id MGR = [select ManagerId From User Where Id = :this.accPlan.Ownerid].ManagerId;   
        this.map_ISOCode_convertRate = ClsAccountPlanUtility.getRateMap();
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'map_ISOCode_convertRate :: ' + this.map_ISOCode_convertRate));

        //this.locale = setLocale();
        this.hasSnapshot = false;
        //this.snapShotId = '';
        this.list_snapshot = new list<snapshot>();
        
        set_accountGroupIds = new set<Id>();//2012-07-18 added by Yuanyuan Zhang
        set_salesFigure = new set<String>();
        
        this.isGlobalAccount = false;       
        readAccess = false;
        writeAccess = false;
        unlockbtn = false;
        approvalLock = false;
        displayError = 'false';
        displayVoice = false;
        String Permission;
        Attachment Voiceatt;
        
        //2012-04-25 yuanyuan zhang
        this.canApproval = false;
        this.list_competitor = new list<competitor>();
        this.list_strategies = new list<strategies>();
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
        
        this.accountPlan = ClsAccountPlanUtility.getAccountPlanById(this.accountPlanId);
        this.customerId = this.accountPlan.Customer__c;
        this.set_accountGroupIds.add(this.customerId);
        //2012-05-24 added by Yuanyuan Zhang : to show/hide delete button
        this.hasCompanyLogo = false;
        this.hasManagerLogo = false;  
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        //if(this.accountPlan.Customer__r.MKTMGRCDE__c != null) this.MKTMGRCDE = this.accountPlan.Customer__r.MKTMGRCDE__c;//add by leijun 2013-04-23
        if(this.accountPlan.Customer__r.IND_KAM_Code__c != null) this.MKTMGRCDE = this.accountPlan.Customer__r.IND_KAM_Code__c;
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//        
        this.buName = this.accountPlan.Customer__r.Customer_Industry__c;
        if(this.accountPlan.Customer__r.RecordType.DeveloperName == 'CIS_Global_Account' && this.accountPlan.Customer__r.Type == 'Global Account'){
            this.buName = this.accountPlan.Customer__r.Industry_Code_Description__c;
            isGlobalAccount=true;
        }else if(this.accountPlan.Customer__r.Type == 'Grouped B'){//added by leijun 2013-04-23
            isBAccount = true;
         }
        // add lili 2013.12.02 begin
        if(this.accountPlan.Customer__r.Industry_Code_Description__c == 'Appliances' || this.accountPlan.Customer__r.Customer_Industry__c == 'Appliances') {
            isAppliancesBU = true;
            this.buName = 'Appliances';
        }
        // add lili 2013.12.02 end
        
        // add Lili Zhao 2014-06-02 begin due to add the BU of Industrial
        String industryCodeDescription = ClsAccountPlanUtility.checkBU(this.accountPlan.Customer__r.Industry_Code_Description__c);
        String customerIndustry = ClsAccountPlanUtility.checkBU(this.accountPlan.Customer__r.Customer_Industry__c);
        if(industryCodeDescription == 'IND'|| customerIndustry == 'IND') {
            this.isINDBU = true;
        }
        // end
          
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
        
        if(this.accountPlan.Approval_Status__c == 'Pending' || this.accountPlan.Approval_Status__c == 'Approved'){
            this.approvalLock = true;
            this.unlockBtn = true;
        }        
        if(US == 'System Administrator' || US == 'Developer'){
            readAccess = true;
            writeAccess = true;
            if(approvalLock == true){
                unlockBtn = true;
            }
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
        changeOwner = '/' + this.accountPlanId + '/a?retURL=' + this.accountPlanId;
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
            strategies st = new strategies(this.accountPlan.Account_Objective_1__c, this.accountPlan.Account_Objective_Location_1__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_2__c != null)
        {
            strategies st = new strategies(this.accountPlan.Account_Objective_2__c, this.accountPlan.Account_Objective_Location_2__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_3__c != null)
        {
            strategies st = new strategies(this.accountPlan.Account_Objective_3__c, this.accountPlan.Account_Objective_Location_3__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_4__c != null)
        {
            strategies st = new strategies(this.accountPlan.Account_Objective_4__c, this.accountPlan.Account_Objective_Location_4__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_5__c != null)
        {
            strategies st = new strategies(this.accountPlan.Account_Objective_5__c, this.accountPlan.Account_Objective_Location_5__c);
            list_strategies.add(st);
        }
        //added by weihang 2013-04-11 
        if(this.accountPlan.Account_Objective_6__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_6__c, this.accountPlan.Account_Objective_Location_6__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_7__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_7__c, this.accountPlan.Account_Objective_Location_7__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_8__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_8__c, this.accountPlan.Account_Objective_Location_8__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_9__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_9__c, this.accountPlan.Account_Objective_Location_9__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_10__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_10__c, this.accountPlan.Account_Objective_Location_10__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_11__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_11__c, this.accountPlan.Account_Objective_Location_11__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_12__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_12__c, this.accountPlan.Account_Objective_Location_12__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_13__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_13__c, this.accountPlan.Account_Objective_Location_13__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_14__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_14__c, this.accountPlan.Account_Objective_Location_14__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_15__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_15__c, this.accountPlan.Account_Objective_Location_15__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_16__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_16__c, this.accountPlan.Account_Objective_Location_16__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_17__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_17__c, this.accountPlan.Account_Objective_Location_17__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_18__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_18__c, this.accountPlan.Account_Objective_Location_18__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_19__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_19__c, this.accountPlan.Account_Objective_Location_19__c);
            list_strategies.add(st);
        }
        if(this.accountPlan.Account_Objective_20__c != null){
            strategies st = new strategies(this.accountPlan.Account_Objective_20__c, this.accountPlan.Account_Objective_Location_20__c);
            list_strategies.add(st);
        }
         
        //get staregie initiatives penetration plans list
        if(this.accountPlan.Strategic_Initiative_1__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_1__c, this.accountPlan.Strategic_Initiative_1_Target__c, this.accountPlan.Strategic_Initiative_1_Status__c, this.accountPlan.Strategic_Initiative_1_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_2__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_2__c, this.accountPlan.Strategic_Initiative_2_Target__c, this.accountPlan.Strategic_Initiative_2_Status__c, this.accountPlan.Strategic_Initiative_2_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_3__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_3__c, this.accountPlan.Strategic_Initiative_3_Target__c, this.accountPlan.Strategic_Initiative_3_Status__c, this.accountPlan.Strategic_Initiative_3_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_4__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_4__c, this.accountPlan.Strategic_Initiative_4_Target__c, this.accountPlan.Strategic_Initiative_4_Status__c, this.accountPlan.Strategic_Initiative_4_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_5__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_5__c, this.accountPlan.Strategic_Initiative_5_Target__c, this.accountPlan.Strategic_Initiative_5_Status__c, this.accountPlan.Strategic_Initiative_5_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_6__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_6__c, this.accountPlan.Strategic_Initiative_6_Target__c, this.accountPlan.Strategic_Initiative_6_Status__c, this.accountPlan.Strategic_Initiative_6_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_7__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_7__c, this.accountPlan.Strategic_Initiative_7_Target__c, this.accountPlan.Strategic_Initiative_7_Status__c, this.accountPlan.Strategic_Initiative_7_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_8__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_8__c, this.accountPlan.Strategic_Initiative_8_Target__c, this.accountPlan.Strategic_Initiative_8_Status__c, this.accountPlan.Strategic_Initiative_8_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_9__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_9__c, this.accountPlan.Strategic_Initiative_9_Target__c, this.accountPlan.Strategic_Initiative_9_Status__c, this.accountPlan.Strategic_Initiative_9_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        
        //added by weihang 2013-04-11
        if(this.accountPlan.Strategic_Initiative_10__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_10__c, this.accountPlan.Strategic_Initiative_10_Target__c, this.accountPlan.Strategic_Initiative_10_Status__c, this.accountPlan.Strategic_Initiative_10_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_11__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_11__c, this.accountPlan.Strategic_Initiative_11_Target__c, this.accountPlan.Strategic_Initiative_11_Status__c, this.accountPlan.Strategic_Initiative_11_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_12__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_12__c, this.accountPlan.Strategic_Initiative_12_Target__c, this.accountPlan.Strategic_Initiative_12_Status__c, this.accountPlan.Strategic_Initiative_12_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_13__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_13__c, this.accountPlan.Strategic_Initiative_13_Target__c, this.accountPlan.Strategic_Initiative_13_Status__c, this.accountPlan.Strategic_Initiative_13_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_14__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_14__c, this.accountPlan.Strategic_Initiative_14_Target__c, this.accountPlan.Strategic_Initiative_14_Status__c, this.accountPlan.Strategic_Initiative_14_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_15__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_15__c, this.accountPlan.Strategic_Initiative_15_Target__c, this.accountPlan.Strategic_Initiative_15_Status__c, this.accountPlan.Strategic_Initiative_15_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_16__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_16__c, this.accountPlan.Strategic_Initiative_16_Target__c, this.accountPlan.Strategic_Initiative_16_Status__c, this.accountPlan.Strategic_Initiative_16_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_17__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_17__c, this.accountPlan.Strategic_Initiative_17_Target__c, this.accountPlan.Strategic_Initiative_17_Status__c, this.accountPlan.Strategic_Initiative_17_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_18__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_18__c, this.accountPlan.Strategic_Initiative_18_Target__c, this.accountPlan.Strategic_Initiative_18_Status__c, this.accountPlan.Strategic_Initiative_18_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_19__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_19__c, this.accountPlan.Strategic_Initiative_19_Target__c, this.accountPlan.Strategic_Initiative_19_Status__c, this.accountPlan.Strategic_Initiative_19_Owner__c);
            list_strategiesInitiativesPenetrationPlan.add(sp);
        }
        if(this.accountPlan.Strategic_Initiative_20__c != null){
            strategiesPlan sp = new strategiesPlan(this.accountPlan.Strategic_Initiative_20__c, this.accountPlan.Strategic_Initiative_20_Target__c, this.accountPlan.Strategic_Initiative_20_Status__c, this.accountPlan.Strategic_Initiative_20_Owner__c);
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
            overview ov = new overview(this.accountPlan.Category2_Name__c, this.accountPlan.Category2_Revenue_M_Plan_Yr_3__c, this.accountPlan.Category2_Revenue_M_Plan_Yr_2__c, String.ValueOf(this.accountPlan.Category2_Rev_Pct_Chg_Plan_Yr_2__c.setScale(0)), this.accountPlan.Category2_Revenue_M_Plan_Yr_1__c, String.ValueOf(this.accountPlan.Category2_Rev_Pct_Chg_Plan_Yr_1__c.setScale(0)));
            list_overview.add(ov);
        }
        if(this.accountPlan.Category3_Name__c != null){
            overview ov = new overview(this.accountPlan.Category3_Name__c, this.accountPlan.Category3_Revenue_M_Plan_Yr_3__c, this.accountPlan.Category3_Revenue_M_Plan_Yr_2__c, String.ValueOf(this.accountPlan.Category3_Rev_Pct_Chg_Plan_Yr_2__c.setScale(0)), this.accountPlan.Category3_Revenue_M_Plan_Yr_1__c, String.ValueOf(this.accountPlan.Category3_Rev_Pct_Chg_Plan_Yr_1__c.setScale(0)));
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
            breakthroughProgram bp = new breakthroughProgram(this.accountPlan.Breakthrough_Program_4__c, this.accountPlan.Breakthrough_Pgm_4_Status__c, this.accountPlan.Breakthrough_Pgm_4_Comments__c);
            list_BreakthroughProgram.add(bp);
        }
            
        //Generate key project list
        //system.debug('tongxia list_keyProjects0:' + list_keyProjects);
        if(this.accountPlan.Key_Project_1__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_1__r.Name, this.accountPlan.Key_Project_1_Value_M__c, this.accountPlan.Key_Project_1_Start_Date__c, this.accountPlan.Key_Project_1__c, this.accountPlan.Key_Project_1__r.RecordType.DeveloperName, this.accountPlan.Key_Project_1__r.Program__r.Name, this.accountPlan.Key_Project_1__r.Program__c);
            list_keyProjects.add(kp);
        }
        //system.debug('tongxia list_keyProjects1:' + list_keyProjects);
        if(this.accountPlan.Key_Project_2__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_2__r.Name, this.accountPlan.Key_Project_2_Value_M__c, this.accountPlan.Key_Project_2_Start_Date__c, this.accountPlan.Key_Project_2__c, this.accountPlan.Key_Project_2__r.RecordType.DeveloperName, this.accountPlan.Key_Project_2__r.Program__r.Name, this.accountPlan.Key_Project_2__r.Program__c);
            list_keyProjects.add(kp);
        }
        //system.debug('tongxia list_keyProjects2:' + list_keyProjects);
        if(this.accountPlan.Key_Project_3__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_3__r.Name, this.accountPlan.Key_Project_3_Value_M__c, this.accountPlan.Key_Project_3_Start_Date__c, this.accountPlan.Key_Project_3__c, this.accountPlan.Key_Project_3__r.RecordType.DeveloperName, this.accountPlan.Key_Project_3__r.Program__r.Name, this.accountPlan.Key_Project_3__r.Program__c);
            list_keyProjects.add(kp);
        }
        //system.debug('tongxia list_keyProjects3:' + list_keyProjects);
        if(this.accountPlan.Key_Project_4__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_4__r.Name, this.accountPlan.Key_Project_4_Value_M__c, this.accountPlan.Key_Project_4_Start_Date__c, this.accountPlan.Key_Project_4__c, this.accountPlan.Key_Project_4__r.RecordType.DeveloperName, this.accountPlan.Key_Project_4__r.Program__r.Name, this.accountPlan.Key_Project_4__r.Program__c);
            list_keyProjects.add(kp);
        }
        //system.debug('tongxia list_keyProjects4:' + list_keyProjects);
        if(this.accountPlan.Key_Project_5__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_5__r.Name, this.accountPlan.Key_Project_5_Value_M__c, this.accountPlan.Key_Project_5_Start_Date__c, this.accountPlan.Key_Project_5__c, this.accountPlan.Key_Project_5__r.RecordType.DeveloperName, this.accountPlan.Key_Project_5__r.Program__r.Name, this.accountPlan.Key_Project_5__r.Program__c);
            list_keyProjects.add(kp);
        }
        //system.debug('tongxia list_keyProjects5:' + list_keyProjects);
        if(this.accountPlan.Key_Project_6__c != null){
            keyProjects kp = new keyProjects(this.accountPlan.Key_Project_6__r.Name, this.accountPlan.Key_Project_6_Value_M__c, this.accountPlan.Key_Project_6_Start_Date__c, this.accountPlan.Key_Project_6__c, this.accountPlan.Key_Project_6__r.RecordType.DeveloperName, this.accountPlan.Key_Project_6__r.Program__r.Name, this.accountPlan.Key_Project_6__r.Program__c);
            list_keyProjects.add(kp);
        }
        //system.debug('tongxia list_keyProjects6:' + list_keyProjects);
        list_keyProjects = getkeySortedList(list_keyProjects);
        //system.debug('tongxia list_keyProjects sort:' + list_keyProjects);
        //get recent big wins
        if(this.accountPlan.Won_Project_1__c != null){//added by xia 2012-12-20
        //if(this.accountPlan.Recent_Big_Win_1__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Won_Project_1__c ,this.accountPlan.Recent_Big_Win_1__c, this.accountPlan.Recent_Big_Win_1_Value_M__c, this.accountPlan.Recent_Big_Win_1_Date_Won__c, this.accountPlan.Recent_Big_Win_1_Comments__c);
            list_wins.add(wl);
        }
        if(this.accountPlan.Won_Project_2__c != null){//added by xia 2012-12-20
        //if(this.accountPlan.Recent_Big_Win_2__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Won_Project_2__c ,this.accountPlan.Recent_Big_Win_2__c, this.accountPlan.Recent_Big_Win_2_Value_M__c, this.accountPlan.Recent_Big_Win_2_Date_Won__c, this.accountPlan.Recent_Big_Win_2_Comments__c);
            list_wins.add(wl);
        }
        if(this.accountPlan.Won_Project_3__c != null){//added by xia 2012-12-20
        //if(this.accountPlan.Recent_Big_Win_3__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Won_Project_3__c ,this.accountPlan.Recent_Big_Win_3__c, this.accountPlan.Recent_Big_Win_3_Value_M__c, this.accountPlan.Recent_Big_Win_3_Date_Won__c, this.accountPlan.Recent_Big_Win_3_Comments__c);
            list_wins.add(wl);
        }
        if(this.accountPlan.Won_Project_4__c != null){//added by xia 2012-12-20
        //if(this.accountPlan.Recent_Big_Win_4__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Won_Project_4__c ,this.accountPlan.Recent_Big_Win_4__c, this.accountPlan.Recent_Big_Win_4_Value_M__c, this.accountPlan.Recent_Big_Win_4_Date_Won__c, this.accountPlan.Recent_Big_Win_4_Comments__c);
            list_wins.add(wl);
        }
        list_wins = getwinlossSortedList(list_wins);
        //get recent losses
        
        //add by Lei Tang <lei.tang@oinio.com>
        map<String, Decimal> map_oppyid_FiveYearValue = new map<String, Decimal>();
        for(Account_Plan__c ap : [select Lost_Project_1__c, Lost_Project_1__r.Five_Year_Value__c, Lost_Project_1__r.CurrencyIsoCode,
                                                                        Lost_Project_2__c, Lost_Project_2__r.Five_Year_Value__c, Lost_Project_2__r.CurrencyIsoCode,
                                                                        Lost_Project_3__c, Lost_Project_3__r.Five_Year_Value__c, Lost_Project_3__r.CurrencyIsoCode,
                                                                        Lost_Project_4__c, Lost_Project_4__r.Five_Year_Value__c, Lost_Project_4__r.CurrencyIsoCode
                                                                from Account_Plan__c  
                                                                where Id = : this.accountPlan.Id]) {
                Integer millionDenominator = 1000000;
                Decimal fiveYearValue = 0;
                if(ap.Lost_Project_1__c != null) {
                        fiveYearValue = (ap.Lost_Project_1__r.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                        if(ap.Lost_Project_1__r.CurrencyIsoCode != 'USD') 
                {
                                        fiveYearValue = (fiveYearValue / map_ISOCode_convertRate.get(ap.Lost_Project_1__r.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);                    
                }
                        map_oppyid_FiveYearValue.put(ap.Lost_Project_1__c, fiveYearValue);
                }
                if(ap.Lost_Project_2__c != null) {
                        fiveYearValue = (ap.Lost_Project_2__r.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                        if(ap.Lost_Project_2__r.CurrencyIsoCode != 'USD') 
                {
                                        fiveYearValue = (fiveYearValue / map_ISOCode_convertRate.get(ap.Lost_Project_2__r.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);                    
                }
                        map_oppyid_FiveYearValue.put(ap.Lost_Project_2__c, fiveYearValue);
                }
                if(ap.Lost_Project_3__c != null) {
                        fiveYearValue = (ap.Lost_Project_3__r.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                        if(ap.Lost_Project_3__r.CurrencyIsoCode != 'USD') 
                {
                                        fiveYearValue = (fiveYearValue / map_ISOCode_convertRate.get(ap.Lost_Project_3__r.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);                    
                }
                        map_oppyid_FiveYearValue.put(ap.Lost_Project_3__c, fiveYearValue);
                }
                if(ap.Lost_Project_4__c != null) {
                        fiveYearValue = (ap.Lost_Project_4__r.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                        if(ap.Lost_Project_4__r.CurrencyIsoCode != 'USD') 
                {
                                        fiveYearValue = (fiveYearValue / map_ISOCode_convertRate.get(ap.Lost_Project_4__r.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);                    
                }
                        map_oppyid_FiveYearValue.put(ap.Lost_Project_4__c, fiveYearValue);
                }
        }
        
        
        
        if(this.accountPlan.Lost_Project_1__c != null){//added by xia 2012-12-20
        //if(this.accountPlan.Recent_Loss_1__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Lost_Project_1__c ,this.accountPlan.Recent_Loss_1__c, map_oppyid_FiveYearValue.get(this.accountPlan.Lost_Project_1__c), this.accountPlan.Recent_Loss_1_Date__c, this.accountPlan.Recent_Loss_1_Comments__c);
            list_losses.add(wl);
        }
        if(this.accountPlan.Lost_Project_2__c != null){//added by xia 2012-12-20
        //if(this.accountPlan.Recent_Loss_2__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Lost_Project_2__c ,this.accountPlan.Recent_Loss_2__c, map_oppyid_FiveYearValue.get(this.accountPlan.Lost_Project_2__c), this.accountPlan.Recent_Loss_2_Date__c, this.accountPlan.Recent_Loss_2_Comments__c);
            list_losses.add(wl);
        }
        if(this.accountPlan.Lost_Project_3__c != null){//added by xia 2012-12-20
        //if(this.accountPlan.Recent_Loss_3__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Lost_Project_3__c ,this.accountPlan.Recent_Loss_3__c, map_oppyid_FiveYearValue.get(this.accountPlan.Lost_Project_3__c), this.accountPlan.Recent_Loss_3_Date__c, this.accountPlan.Recent_Loss_3_Comments__c);
            list_losses.add(wl);
        }
        if(this.accountPlan.Lost_Project_4__c != null){//added by xia 2012-12-20
        //if(this.accountPlan.Recent_Loss_4__c != null){
            winsAndLosses wl = new winsAndLosses(this.accountPlan.Lost_Project_4__c ,this.accountPlan.Recent_Loss_4__c, map_oppyid_FiveYearValue.get(this.accountPlan.Lost_Project_4__c), this.accountPlan.Recent_Loss_4_Date__c, this.accountPlan.Recent_Loss_4_Comments__c);
            list_losses.add(wl);
        }
         
        list_losses = getwinlossSortedList(list_losses);
        //get win/loss project name winsLossProjects
        if(this.accountPlan.Won_Project_1__c != null){              
            String showValue = setShowValue(this.accountPlan.Won_Project_1__r.Five_Year_Revenue__c, this.accountPlan.Won_Project_1__r.CurrencyIsoCode);
       // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'Five_Year_Value__c ::' + this.accountPlan.Won_Project_1__r.Five_Year_Value__c)); 
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'this.accountPlan.Won_Project_1__r.CurrencyIsoCode' + this.accountPlan.Won_Project_1__r.CurrencyIsoCode)); 
            String showValue_Cust = setShowValue(this.accountPlan.Won_Project_1__r.Five_Year_Value__c, this.accountPlan.Won_Project_1__r.CurrencyIsoCode);

            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Won_Project_1__r.Name,showValue ,this.accountPlan.Won_Project_1__r.Account_Plan_Comment__c);
            winsLossProjects wlp_Cust = new winsLossProjects(this.accountPlan.Won_Project_1__r.Name,showValue_Cust ,this.accountPlan.Won_Project_1__r.Account_Plan_Comment__c);

            list_winProject.add(wlp);
            list_winProject.add(wlp_Cust);

        }
        if(this.accountPlan.Won_Project_2__c != null){
            String showValue = setShowValue(this.accountPlan.Won_Project_2__r.Five_Year_Revenue__c, this.accountPlan.Won_Project_2__r.CurrencyIsoCode);
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Won_Project_2__r.Name,showValue ,this.accountPlan.Won_Project_2__r.Account_Plan_Comment__c);
        
        // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
           
            String showValue_Cust = setShowValue(this.accountPlan.Won_Project_2__r.Five_Year_Value__c, this.accountPlan.Won_Project_2__r.CurrencyIsoCode);
            winsLossProjects wlp_Cust = new winsLossProjects(this.accountPlan.Won_Project_2__r.Name,showValue_Cust ,this.accountPlan.Won_Project_2__r.Account_Plan_Comment__c);

            list_winProject.add(wlp);
            list_winProject.add(wlp_Cust);
        }
        if(this.accountPlan.Won_Project_3__c != null){
            String showValue = setShowValue(this.accountPlan.Won_Project_3__r.Five_Year_Revenue__c, this.accountPlan.Won_Project_3__r.CurrencyIsoCode);
           
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Won_Project_3__r.Name,showValue ,this.accountPlan.Won_Project_3__r.Account_Plan_Comment__c);
        // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
            
            String showValue_Cust = setShowValue(this.accountPlan.Won_Project_3__r.Five_Year_Value__c, this.accountPlan.Won_Project_3__r.CurrencyIsoCode);
            winsLossProjects wlp_Cust = new winsLossProjects(this.accountPlan.Won_Project_3__r.Name,showValue_Cust ,this.accountPlan.Won_Project_3__r.Account_Plan_Comment__c);

            list_winProject.add(wlp);
            list_winProject.add(wlp_Cust);
        }
        if(this.accountPlan.Won_Project_4__c != null){
            String showValue = setShowValue(this.accountPlan.Won_Project_4__r.Five_Year_Revenue__c, this.accountPlan.Won_Project_4__r.CurrencyIsoCode);
           
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Won_Project_4__r.Name,showValue ,this.accountPlan.Won_Project_4__r.Account_Plan_Comment__c);
  
  // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
  
            String showValue_Cust = setShowValue(this.accountPlan.Won_Project_4__r.Five_Year_Value__c, this.accountPlan.Won_Project_4__r.CurrencyIsoCode);
            winsLossProjects wlp_Cust = new winsLossProjects(this.accountPlan.Won_Project_4__r.Name,showValue_Cust ,this.accountPlan.Won_Project_4__r.Account_Plan_Comment__c);

            list_winProject.add(wlp);
            list_winProject.add(wlp_Cust);
        }
        
        if(this.accountPlan.Lost_Project_1__c != null){
            String showValue = setShowValue(this.accountPlan.Lost_Project_1__r.Five_Year_Revenue__c, this.accountPlan.Lost_Project_1__r.CurrencyIsoCode);
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Lost_Project_1__r.Name,showValue ,this.accountPlan.Lost_Project_1__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp);
            
  // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
  
            String showValue_Cust = setShowValue(this.accountPlan.Lost_Project_1__r.Five_Year_Value__c, this.accountPlan.Lost_Project_1__r.CurrencyIsoCode);
            winsLossProjects wlp_Cust = new winsLossProjects(this.accountPlan.Lost_Project_1__r.Name,showValue_Cust ,this.accountPlan.Lost_Project_1__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp_Cust);
        }
        if(this.accountPlan.Lost_Project_2__c != null){
            String showValue = setShowValue(this.accountPlan.Lost_Project_2__r.Five_Year_Revenue__c, this.accountPlan.Lost_Project_2__r.CurrencyIsoCode);
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Lost_Project_2__r.Name,showValue ,this.accountPlan.Lost_Project_2__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp);
            
  // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
  
            String showValue_Cust = setShowValue(this.accountPlan.Lost_Project_2__r.Five_Year_Value__c, this.accountPlan.Lost_Project_2__r.CurrencyIsoCode);
            winsLossProjects wlp_Cust = new winsLossProjects(this.accountPlan.Lost_Project_2__r.Name,showValue_Cust ,this.accountPlan.Lost_Project_2__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp_Cust);

        }
        if(this.accountPlan.Lost_Project_3__c != null){
            String showValue = setShowValue(this.accountPlan.Lost_Project_3__r.Five_Year_Revenue__c, this.accountPlan.Lost_Project_3__r.CurrencyIsoCode);
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Lost_Project_3__r.Name,showValue ,this.accountPlan.Lost_Project_3__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp);
    // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
           
            String showValue_Cust = setShowValue(this.accountPlan.Lost_Project_3__r.Five_Year_Value__c, this.accountPlan.Lost_Project_3__r.CurrencyIsoCode);
            winsLossProjects wlp_Cust = new winsLossProjects(this.accountPlan.Lost_Project_3__r.Name,showValue_Cust ,this.accountPlan.Lost_Project_3__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp_Cust);
        }
        if(this.accountPlan.Lost_Project_4__c != null){
            String showValue = setShowValue(this.accountPlan.Lost_Project_4__r.Five_Year_Revenue__c, this.accountPlan.Lost_Project_4__r.CurrencyIsoCode);
            winsLossProjects wlp = new winsLossProjects(this.accountPlan.Lost_Project_4__r.Name,showValue ,this.accountPlan.Lost_Project_4__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp);
    // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
          
            String showValue_Cust = setShowValue(this.accountPlan.Lost_Project_4__r.Five_Year_Value__c, this.accountPlan.Lost_Project_4__r.CurrencyIsoCode);
            winsLossProjects wlp_Cust = new winsLossProjects(this.accountPlan.Lost_Project_4__r.Name,showValue_Cust ,this.accountPlan.Lost_Project_4__r.Account_Plan_Comment__c);
            list_lossProject.add(wlp_Cust);
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
        String BRCMFValueTemp='';
        if(accountPlanId != null && this.accountPlan.BU_Revenue_CY_Manual_Forecast_M__c != null){
            BRCMFValueTemp = String.valueOf(this.accountPlan.BU_Revenue_CY_Manual_Forecast_M__c);
        }else{
            if(this.accountPlan.BU_Revenue_CY_Forecast_M__c != null ){
                BRCMFValueTemp = String.valueOf(this.accountPlan.BU_Revenue_CY_Forecast_M__c);
            }else{
                BRCMFValueTemp='';
            }
        }
             
       //Get Charts
        if(this.accountPlan.Active__c && this.accountPlan.RecordType.Name == 'Active' && (this.accountPlan.Customer_Type__c == 'A' || this.accountPlan.Customer_Type__c == 'B')){
            this.canApproval = true;
        }
        this.GAMCD = this.accountPlan.GAM_Code__c;
        this.accGAMCD = this.accountPlan.Customer__r.GAMCD__c; // add lili 2014.3.4
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        /*
        if(this.accountPlan.Customer__r.MKTMGRCDE__c != null)
        this.MKTMGRCDE = this.accountPlan.Customer__r.MKTMGRCDE__c;//add by leijun 2013-04-23
        */
        if(this.accountPlan.Customer__r.IND_KAM_Code__c != null)
        this.MKTMGRCDE = this.accountPlan.Customer__r.IND_KAM_Code__c;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'MKTMGRCDE :: ' + this.MKTMGRCDE));
        //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
        if(this.accountPlan.Customer__r.RecordType.DeveloperName == 'CIS_Global_Account'){// && this.accountPlan.Customer__r.Type == 'Global Account'){ alter by leijun 2013-04-24
            String accPlanId = '';
            if(this.accountPlan.Customer__r.Type == 'Global Account'){            
                this.buName =this.accountPlan.Customer__r.Industry_Code_Description__c;
                isGlobalAccount = true;
                //Added by Lili Zhao 2014-03-05 Begin due to get the related account plan as  IND_KAM_Code__c if the IND_KAM_Code__c of the account is not null 
                /*
                if(this.MKTMGRCDE != null && this.MKTMGRCDE != '') {
                    
                    for(Account_Plan__c  accPlan : [SELECT Id, Name, Customer__r.IND_KAM_Code__c, Customer__r.GAMCD__c, Customer__c,Customer__r.Type from Account_Plan__c where  Customer__r.IND_KAM_Code__c =: this.MKTMGRCDE and Customer__r.Type = 'Grouped B' and Customer__r.RecordType.DeveloperName = 'CIS_Global_Account']) {
                        accPlanId = accPlan.Id;
                        this.accPlanName = accPlan.Name;
                    }
                    if(accPlanId != '') {
                        this.isKAMLink = true;
                        this.strLink = '/apex/ExtAccountPlanView_showAccountPlanDetail?id=' + accPlanId;                  
                    }
                }
                */
                //Added by Lili Zhao 2014-03-05 End
            }else {
                //Added by Lili Zhao 2014-03-05 Begin due to get the related account plan as  GAMCD__c if the GAMCD__c of the account is not null
                /*
                if(this.accGAMCD != null && this.accGAMCD != '') {
                    for(Account_Plan__c  accPlan : [SELECT Name, Id, Customer__r.IND_KAM_Code__c, Customer__r.GAMCD__c, Customer__c,Customer__r.Type from Account_Plan__c where  Customer__r.GAMCD__c =: this.accGAMCD and Customer__r.Type = 'Global Account' and Customer__r.RecordType.DeveloperName = 'CIS_Global_Account']) {
                        accPlanId = accPlan.Id;
                        this.accPlanName = accPlan.Name;
                    }
                    if(accPlanId != '') {
                        //this.isLink = true;
                        this.strLink = '/apex/ExtAccountPlanView_showAccountPlanDetail?id=' + accPlanId;
                        this.isGAMLink = true;
                    }
                }
                */
                //Added by Lili Zhao 2014-03-05 End
            }
        }
        else if(this.accountPlan.Customer__r.Type == 'Grouped B'){//added by xia 2013-04-01
            isBAccount = true;
            }
        //showRegionPanel = false; //add lili 2014.1.6
        //showCBCPanel = false; //add lili 2014.1.6   
        if(this.isGlobalAccount && this.GAMCD != null && this.GAMCD != ''){ // added lili zhao added the code of this.GAMCD != null && this.GAMCD != ''
            //FFA - 20.11.12: Commented out because it is no more needed
            //set_globalAccountRegion = new set<String>();
            //showRegionPanel = true; //add lili 2014.1.6
            map<String, String> map_region_kz = ClsAccountPlanUtility.map_region_kz;
            for(Account acc : [SELECT Id FROM Account WHERE GAMCD__c = :this.GAMCD LIMIT 10000]){ //Customer_Region__c
                set_accountGroupIds.add(acc.Id);
            }            
        }
        else if(this.isBAccount && this.MKTMGRCDE != null && this.MKTMGRCDE != ''){//added by leijun 2013-04-23// added lili zhao 2014-07-16 due to add the code of this.MKTMGRCDE != ''
            showRegionPanel = true;           
            map<String, String> map_region_kz = ClsAccountPlanUtility.map_region_kz;
            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
            //for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE MKTMGRCDE__c = :this.MKTMGRCDE LIMIT 10000]){ //Customer_Region__c
            for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE IND_KAM_Code__c = :this.MKTMGRCDE LIMIT 10000]){ 
            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                set_accountGroupIds.add(acc.Id);
            }
        }
        if(this.accountPlan.Sales_Figures_Makeup__c != null){
            for(String key : this.accountPlan.Sales_Figures_Makeup__c.split(';')){
                set_salesFigure.add(map_salesFigure_type.get(key));
            }
        }
        
        //getChartWithSalesPeriodLili(); //add lili 2014.1.6
        
        //getChartWithSalesPeriod();//added by leijun  // add lili 2013.12.12
               
        //get TE performance
        getTECalculation(); 
        // TE
        tePerformance te = new tePerformance(system.Label.TE, strte_prior_revernue, strte_actual_revernue,
                                              this.accountPlan.TE_Revenue_CY_Forecast_M__c, this.accountPlan.TE_Revenue_Fcst_Plan_Yr_M__c, this.accountPlan.TE_Revenue_Pct_Change_Plan_Yr__c,
                                              this.accountPlan.TE_Revenue_Fcst_Plan_Yr_1_M__c, this.accountPlan.TE_Revenue_Pct_Change_Plan_Yr_1__c,
                                              this.accountPlan.TE_Revenue_Fcst_Plan_Yr_4_M__c, this.accountPlan.TE_Revenue_Pct_Change_Plan_Yr_4__c,'');
        list_tePerformance.add(te);
                   
        // BU
        if(this.accountPlan.Business_Unit__c != null){
            tePerformance bu = new tePerformance(this.accountPlan.Business_Unit__c, strbu_prior_revernue, strbu_actual_revernue, 
                                              this.accountPlan.BU_Revenue_CY_Forecast_M__c, this.accountPlan.BU_Revenue_Fcst_Plan_Yr_M__c, this.accountPlan.BU_Revenue_Pct_Change_Plan_Yr__c,
                                              this.accountPlan.BU_Revenue_Fcst_Plan_Yr_1_M__c, this.accountPlan.BU_Revenue_Pct_Change_Plan_Yr_1__c,
                                              this.accountPlan.BU_Revenue_Fcst_Plan_Yr_4_M__c, this.accountPlan.BU_Revenue_Pct_Change_Plan_Yr_4__c,BRCMFValueTemp);
            list_tePerformance.add(bu);
        }
        
        // TAM
        if(this.accountPlan.Revenue_TAM_SAM__c != null){
            String tmp = '';
            if(this.accountPlan.TAM_Prior_Yr_M__c != null) tmp = String.valueOf(this.accountPlan.TAM_Prior_Yr_M__c); 
            tePerformance tam = new tePerformance(this.accountPlan.Revenue_TAM_SAM__c, tmp, null, 
                                              null, this.accountPlan.TAM_Plan_Year_M__c, this.accountPlan.TAM_Pct_Change_Plan_Yr__c,
                                              this.accountPlan.TAM_Plan_Yr_1_M__c, this.accountPlan.TAM_Pct_Change_Plan_Yr_1__c,
                                              this.accountPlan.TAM_Plan_Yr_4_M__c, this.accountPlan.TAM_Pct_Change_Plan_Yr_4__c,'');
            list_tePerformance.add(tam);
        }
        
        // MS
        tePerformance ms = new tePerformance(system.Label.MS, 
                                             this.accountPlan.Market_Share_Prior_Yr__c, 
                                             this.accountPlan.Market_Share_Plan_Yr__c,
                                             this.accountPlan.Market_Share_Plan_Yr_1__c, 
                                             this.accountPlan.Market_Share_Plan_Yr_4__c);
        list_tePerformance.add(ms);
            
        //getChartWithCBC3(); //add lili 2014.1.6
         
        // if(this.isGlobalAccount || this.isBAccount){ // //add lili 2014.1.6
        // getChartWithRegion(); // //add lili 2014.1.6
        // } //add lili 2014.1.6
        
        list_snapshot = getSnapShot();
        
    }        
      
    private void getTECalculation(){
        if(this.accountPlan.Plan_Year__c == null){
            return;
        }
        if(this.set_accountGroupIds.isEmpty()){
            return;
        }
        
        String lastYear = String.valueOf(planYearMinus1);
        
        this.accountPlan.TE_Revenue_Prior_Yr_Actual_M__c = 0;
        this.accountPlan.TE_Revenue_YTD_Actual_M__c = 0;
        this.accountPlan.BU_Revenue_Prior_Yr_Actual_M__c = 0;
        this.accountPlan.BU_Revenue_YTD_Actual_M__c = 0;
        
        Decimal te_prior_revernue = 0;
        Decimal te_actual_revernue = 0;
        Decimal bu_prior_revernue = 0;
        Decimal bu_actual_revernue = 0;

        for(BBB_Month_Bill_Book_Cust__c bmbbc : [SELECT Bill_Amount_USD__c, 
                                                        Fiscal_Year__c, 
                                                        Id,
                                                        SAP_Profit_Center_Code__c, // added Lili Zhao 2014-06-11 
                                                        SAP_Profit_Center_Short_Description__c,
                                                        Profit_Center__c,
                                                        Bill_Type__c
                                                  FROM BBB_Month_Bill_Book_Cust__c
                                                  WHERE Customer__c IN : this.set_accountGroupIds
                                                  AND Bill_Amount_USD__c != null
                                                  AND Bill_Type__c in :set_salesFigure 
                                                  AND (Fiscal_Year__c = :this.accountPlan.Plan_Year__c 
                                                  OR   Fiscal_Year__c = :lastYear) limit 50000]){
            if (lastYear.equals(bmbbc.Fiscal_Year__c)){
                te_prior_revernue += bmbbc.Bill_Amount_USD__c;
            }else if(bmbbc.Fiscal_Year__c == this.accountPlan.Plan_Year__c){
                te_actual_revernue += bmbbc.Bill_Amount_USD__c;
            }
            //if(bmbbc.SAP_Profit_Center__c == this.buName){
           // if(this.buName == 'DataComm'){
                if(bmbbc.Profit_Center__c == 'DND'){  //Changed DTC to DND -Case 00900947 - Sanghita Das
                    if (lastYear.equals(bmbbc.Fiscal_Year__c)){
                        bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                    }
                    else if(bmbbc.Fiscal_Year__c == this.accountPlan.Plan_Year__c){
                        bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                    }
                }
            //}
            else{
                //system.debug('**@@bmbbc.SAP_Profit_Center__c = ' + bmbbc.SAP_Profit_Center__c);
                //system.debug('**@@this.buName = ' + this.buName);
                // add lili 2013.12.02 begin 
                /*
                if(bmbbc.SAP_Profit_Center_Short_Description__c != null && this.buName != null && bmbbc.SAP_Profit_Center_Short_Description__c.contains(this.buName) ){//modify 2013-08-06 minghao.li@itbconsult.com
                    // if(bmbbc.SAP_Profit_Center__c == this.buName)
                    if (lastYear.equals(bmbbc.Fiscal_Year__c)){
                        bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                    }
                    else if(bmbbc.Fiscal_Year__c == this.accountPlan.Plan_Year__c){
                        bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                    }
                }
                */
                // add lili zhao 2014-05-27 begin
                // due to change the requirement from SAP_Profit_Center_Short_Description__c to SAP_Profit_Center_Code__c
                set<String> set_BU_Appliances = new set<String>();
                if(Account_Plan_Appliances_BU__c.getInstance('Household Appliances') != null && Account_Plan_Appliances_BU__c.getInstance('Household Appliances').Value__c != null ) {
                set_BU_Appliances.add((String) Account_Plan_Appliances_BU__c.getInstance('Household Appliances').Value__c);
            }
            if(Account_Plan_Appliances_BU__c.getInstance('Relay Products - Appl') != null && Account_Plan_Appliances_BU__c.getInstance('Relay Products - Appl').Value__c != null ) {
                set_BU_Appliances.add((String) Account_Plan_Appliances_BU__c.getInstance('Relay Products - Appl').Value__c);
            }
                /*
                if(bmbbc.SAP_Profit_Center_Short_Description__c != null && this.buName != null ) { 
                    if(isAppliancesBU) {  
                        if(map_BU_Appliances.containsKey(bmbbc.SAP_Profit_Center_Short_Description__c)) {  
                            if (lastYear.equals(bmbbc.Fiscal_Year__c)) {
                                bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                            }else if(bmbbc.Fiscal_Year__c == this.accountPlan.Plan_Year__c) {
                                bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                            }
                        }
          */
        if(!set_BU_Appliances.isEmpty() && bmbbc.SAP_Profit_Center_Short_Description__c != null && this.buName != null && bmbbc.SAP_Profit_Center_Code__c != null) { 
                    if(isAppliancesBU) {  
                        if(set_BU_Appliances.contains(bmbbc.SAP_Profit_Center_Code__c)) {  
                            if (lastYear.equals(bmbbc.Fiscal_Year__c)) {
                                bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                            }else if(bmbbc.Fiscal_Year__c == this.accountPlan.Plan_Year__c) {
                                bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                            }
                        }                        
                    }else{  
                        if(bmbbc.SAP_Profit_Center_Short_Description__c.contains(this.buName)) {  
                            if (lastYear.equals(bmbbc.Fiscal_Year__c)) {  
                                bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                            }else if(bmbbc.Fiscal_Year__c == this.accountPlan.Plan_Year__c) {
                                bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                            }
                        }  
                    }  
                }
                // add lili 2013.12.02 end
            }                       
        }
        
        te_prior_revernue = (te_prior_revernue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
        te_actual_revernue = (te_actual_revernue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
        bu_prior_revernue = (bu_prior_revernue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
        bu_actual_revernue = (bu_actual_revernue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
        
        this.strte_prior_revernue = ClsAccountPlanUtility.setNumberFormat(locale, te_prior_revernue, true);
        this.strte_actual_revernue = ClsAccountPlanUtility.setNumberFormat(locale, te_actual_revernue, true);
        this.strbu_prior_revernue = ClsAccountPlanUtility.setNumberFormat(locale, bu_prior_revernue, true);
        this.strbu_actual_revernue = ClsAccountPlanUtility.setNumberFormat(locale, bu_actual_revernue, true);           
    }
    
    /** 
     *  Sort oppy list with 5 year
     * 
     * @author Yuanyuan Zhang
     * @created 2012-10-26
     * 
     *
     * @changelog
     * 2012-10-26 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
     * - Created   
     *
     */
    private list<keyProjects> getkeySortedList(list<keyProjects> list_selected){
        list<keyProjects> list_return = new list<keyProjects>();
        list<Decimal> list_sort = new list<Decimal>();
        set<Decimal> set_sort = new set<Decimal>();
        map<Decimal, list<keyProjects>> map_fiveYearValue_keyPro = new map<Decimal, list<keyProjects>>();
        if(list_selected != null){
            for(keyProjects kop : list_selected){
                set_sort.add(kop.yearsValue);
                list<keyProjects> list_temp = new list<keyProjects>();
                if(map_fiveYearValue_keyPro.containsKey(kop.yearsValue)){
                    list_temp = map_fiveYearValue_keyPro.get(kop.yearsValue);
                }
                list_temp.add(kop);
                map_fiveYearValue_keyPro.put(kop.yearsValue, list_temp);
            }
            list_sort.addAll(set_sort);
            list_sort.sort();
            for(Integer i = list_sort.size() -1 ; i >=0; i--){
                list_return.addAll(map_fiveYearValue_keyPro.get(list_sort[i]));
            }
        }
        
        
        return list_return;
    }
    /** 
     *  Sort oppy list with 5 year
     * 
     * @author Yuanyuan Zhang
     * @created 2012-10-26
     * 
     *
     * @changelog
     * 2012-10-26 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
     * - Created   
     *
     */
    private list<winsAndLosses> getwinlossSortedList(list<winsAndLosses> list_selected){
        list<winsAndLosses> list_return = new list<winsAndLosses>();
        list<Decimal> list_sort = new list<Decimal>();
        set<Decimal> set_sort = new set<Decimal>();
        map<Decimal, list<winsAndLosses>> map_fiveYearValue_keyPro = new map<Decimal, list<winsAndLosses>>();
        if(list_selected != null){
            for(winsAndLosses kop : list_selected){
                set_sort.add(kop.yearsValue);
                list<winsAndLosses> list_temp = new list<winsAndLosses>();
                if(map_fiveYearValue_keyPro.containsKey(kop.yearsValue)){
                    list_temp = map_fiveYearValue_keyPro.get(kop.yearsValue);
                }
                list_temp.add(kop);
                map_fiveYearValue_keyPro.put(kop.yearsValue, list_temp);
            }
            list_sort.addAll(set_sort);
            list_sort.sort();
            for(Integer i = list_sort.size() -1 ; i >=0; i--){
                list_return.addAll(map_fiveYearValue_keyPro.get(list_sort[i]));
            }
        }
        
        return list_return;
    }
    
    private void setLocale(){
        this.locale = Userinfo.getLocale();
        if(this.locale == 'de_DE'){
            this.locale = 'de';
        }
    }
    
    private String setShowValue(Decimal wlValue, String isoCode){
        String showValue;
        if(wlValue!=null && isoCode!=null){
            if(map_ISOCode_convertRate.containsKey(isoCode)) wlValue = wlValue / map_ISOCode_convertRate.get(isoCode);
            wlValue = wlValue/this.millionDenominator;
            wlValue = wlValue.setScale(1, System.Roundingmode.HALF_UP);
            showValue = ClsAccountPlanUtility.setNumberFormat(this.locale,  wlValue, true);
        }
        return showValue;
    }
    /*
    private void setAllParamNull(String param){
        if(param == 'cbc'){
            cbcPart1 = null;
            cbcPart2 = null;
            cbcPart3 = null;
            cbcPart4 = null;
            cbcPart5 = null;
            cbcTop1 = null;
            cbcTop2 = null;
            cbcTop3 = null;
            cbcTop4 = null;
            cbcTop5 = null;
        }
        else{  
            regionPart1 = null;
            regionPart2 = null;
            regionPart3 = null;
            regionPart4 = null;
            regionPart5 = null;
            regionTop1 = null;
            regionTop2 = null;
            regionTop3 = null;
            regionTop4 = null;
            regionTop5 = null;
        }
    }
    */
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
        public String owner{get;set;}
        public strategiesPlan(String straPlan, String straTarget, String straStatus, string straOwner){
            plan = straPlan;
            target = straTarget;
            status = straStatus;
            owner = straOwner;
        }
    }
    public class strategies{
        public String objective{get;set;}
        public String location{get;set;}
        public strategies(String straObjective, String straLocation){
            objective = straObjective;
            location = straLocation;
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
        public set<string> set_dndRTs = new set<string>();// Added by Padmaja for DND Project
        public set<string> set_salescsdRTs = new set<string>();// Added by Padmaja for CSD
        public set<string> set_engcsdRTs = new set<string>();// Added by Padmaja for CSD
        private void setOppyType(String opType){
            // add lili zhao 2014-06-18 due to add the IND record type
            /*
            if(opType == 'Opportunity_Engineering_Project'){
                proTyp = 'Engineering';
            }
            else if(opType == 'Opportunity_Sales_Parts_Only'){
                proTyp = 'Sales';
            }            
            */
            //Change start by Mrunal for MINI Spin project, Commented hard coded record type values and Used Custom setting 'Opportunity Record type Group' for the same.
            /*if(opType == 'Opportunity_Engineering_Project' || opType == 'IND_Engineering_project') {
              proTyp = 'Engineering';
            }else if(opType == 'Opportunity_Sales_Parts_Only' || opType == 'IND_Sales_Project') {
              proTyp = 'Sales';
            }
            // end*/
     
            List<Opportunity_Record_Type_Groups__c> cusSet = Opportunity_Record_Type_Groups__c.getall().values();
            for (Opportunity_Record_Type_Groups__c rt : cusSet){
                if(rt.Group__c == 'DND Account Plan Set Oppty type')
                     set_dndRTs.add(rt.API_Name__c);
                if(rt.Active__c && rt.Group__c == 'CSD Account Plan Set Oppty type' && rt.API_Name__c!= null){
                     if (rt.Is_Sales_Only__c)
                     set_salescsdRTs.add(rt.API_Name__c); 
                   else
                        set_engcsdRTs.add(rt.API_Name__c);
                   }       
                if(rt.Active__c && rt.Group__c == 'Account Plan Set Oppty type' && rt.API_Name__c!= null){
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
            }else if(set_dndRTs.contains(opType)) {
                proTyp = 'DND';
            //Change End by Padmaja for DND Merge 
            }else if(set_salescsdRTs.contains(opType)) {
                proTyp = 'Sales CSD';
            //Change End by Padmaja for CSD
            }else if(set_engcsdRTs.contains(opType)) {
                proTyp = 'Engineering CSD';
            //Change End by Padmaja for CSD
            }else{//Change End by MRUNAL for MINI SPIN
                proTyp = 'Program';
            }
            system.debug('>>>proTyp '+proTyp);
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
        public String yearsValue{get;set;}
        //public String dateValue{get;set;}
        public String comments{get;set;}
        public winsLossProjects(String wlname, String wlValue,String wlComment){
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
        public String BRCMFValue{get;set;}
        public tePerformance(String wlname, String value1, String value2, Decimal value3, Decimal value4, Decimal value5, Decimal value6, Decimal value7, Decimal value8, Decimal value9,String BRCMFValueTemp){
            name = wlname;
            try{
                actualValue = String.valueOf(Decimal.valueOf(value1).setScale(3));
            }catch(Exception e){
                actualValue = value1;
            }
            try{
                ytdActualValue = String.valueOf(Decimal.valueOf(value2).setScale(3));
            }catch(Exception e){
                ytdActualValue = value2;
            }
            forecastValue = String.valueOf(value3 != null ? value3.setScale(3) : value3);
            apValue1 = String.valueOf(value4 != null ? value4.setScale(3) : value4);
            yoyValue1 = value5==null?'':String.valueOf(value5) + '%';
            apValue2 = String.valueOf(value6 != null ? value6.setScale(3) : value6);
            yoyValue2 = value7==null?'':String.valueOf(value7) + '%';
            
            apValue3 = String.valueOf(value8 != null ? value8.setScale(3) : value8);
            yoyValue3 = value9==null?'':String.valueOf(value9) + '%';
            BRCMFValue = BRCMFValueTemp;
        }
        
        public tePerformance(String wlname, Decimal value1, Decimal value2, Decimal value3, Decimal value4){
            name = wlname;
            forecastValue = String.valueOf(value1) + '%';
            yoyValue1 = String.valueOf(value2) + '%';
            yoyValue2 = String.valueOf(value3) + '%';
            yoyValue3 = String.valueOf(value4) + '%';
        }
        
    }
    
    public class snapshot{
        public String id{get;set;}
        public String dateString{get;set;}
        public snapshot(String apid, String dateStr){
            id = apid;
            dateString = dateStr;
        }
    }
     
    ///*<<<InnerClass*/
    
    //********************************* -=END inner classes=- *************************************
}