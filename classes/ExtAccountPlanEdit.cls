/**
 *  Extensions class for page ExtCustomerEdit_editCustomerDetail
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-15
 * @version 1.0
 * @since 23.0(ForceIDE Version)
 * 
 * 
 *   
 * @changelog
 * 2014-06-11 Lili Zhao <lili.zhao@itbconsult.com>
 * - Modified  due to change the requirement from SAP_Profit_Center_Short_Description__c to SAP_Profit_Center_Code__c,
 * - use the custom setting Account_Plan_Appliances_BU__c
 *
 * 2012-05-15 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 * 2014-03-05 Lili Zhao <lili.zhao@itbconsult.com>
 * - Modified  an Account is in both groupings(Grouped B and Global Account), add a new section in which on a Global Account Plan a link to the B-Account Plan and on a B-Account Plan a link to the Global Account Plan.
 *  
 * 2014-08-21 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified to fix query 50001 limit bug when GAM Code or KAM Code equals null or ''
 *  
 * 2015-06-16 Mrunal Parate  
 * - modified - Commented hard coded record type values and Used Custom setting 'Opportunity Record type Group' for the same and Added new record type
 * 'Channel_Sales_Opportunity' and 'Channel_Engineering_Opportunity' for MINI SPIN Project.
 *   
 */    

public class ExtAccountPlanEdit{   

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String mode{get;set;}
    public Account_Plan__c accPlan{get;set;}
    public set<string> set_salesRTs = new set<string>();// Added by Mrunal for MINI SPIN Project
    public set<string> set_engineerRTs = new set<string>();// Added by Mrunal for MINI SPIN Project
    public set<string> set_dndRTs = new set<string>();// Added by Padmaja for DND Project
    public set<string> set_salescsdRTs = new set<string>();// Added by Padmaja for CSD
    public set<string> set_engcsdRTs = new set<string>();// Added by Padmaja for CSD
    //public Account_Plan__c accPlan{get;set;}
    public String  aid{get;set;}
    public String  accId{get;set;}
    public String  displayError{get;set;}
    public Boolean displayVoice{get;set;}
    
    public String  voiceName{get;set;}
    public String  voiceId{get;set;}    
    public transient Blob    voiceBody{get;set;}
    
    public Integer voiceFileSize{get;set;}
    public string voiceFileErrorMsg{get;set;}
    
    public String displayVoiceFileError{get;set;}
    public String displayMUError{get;set;}
    public String voiceFileContentType{get;set;}
    
    public Integer planYear{get;set;}
    public Integer planYearMinus3{get;set;}
    public Integer planYearMinus2{get;set;}
    public Integer planYearMinus1{get;set;}
    public Integer planYearPlus1{get;set;}
    public Integer planYearPlus4{get;set;}
    //change start by Mrunal for R-1468
    
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
    //2012-05-08
    public list<keyOppyAndProgramm> list_keyOppyAndProgramm{get;set;}
    public list<winLossOppy> list_winOppy{get;set;}
    public list<winLossOppy> list_lossOppy{get;set;}
    
    //Use to store description for win/loss oppy
    public String winComment1{get;set;}
    public String winComment2{get;set;}
    public String winComment3{get;set;}
    public String winComment4{get;set;}
    public String lossComment1{get;set;}
    public String lossComment2{get;set;}
    public String lossComment3{get;set;}
    public String lossComment4{get;set;}
    public Opportunity opportunity{get;set;}
    
    //public String urlCBC{get;private set;}
    //public String urlRegion{get; private set;}
    public Boolean chooseCBC{get;set;}
    public Boolean chooseRegion{get;set;}
    
    /*
        START: 2012-05-24 added by Yuanyuan Zhang: try new charts
    */
    public String strCBCTopSave{get;set;}
    public String strCBCPercentSave{get;set;}
    public String strRegionTopSave{get;set;}
    public String strRegionPercentSave{get;set;}
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
    //public Decimal regionPercent6{get;set;}
    
    public Boolean showCBCPanel{get;set;}
    public Boolean showRegionPanel{get;set;}
    
    /*
        END: 2012-05-24 added by Yuanyuan Zhang: try new charts
    */
    public Boolean planYearIsChoosed{get;set;}//2012-05-24 added by Yuanyuan Zhang: for show plan year table
    
    //2012-06-15 added for BU
    public String buName{get;private set;}
    
    //START 2012-07-12 added by Yuanyuan Zhang
    
    public String strte_prior_revernue{get;private set;}
    public String strte_actual_revernue{get;private set;}
    //public String strte_cy_forecast{get;private set;}
    public String strbu_prior_revernue{get;private set;}
    public String strbu_actual_revernue{get;private set;}
    //public String strbu_cy_forecast{get;private set;}
    //END 2012-07-12 added by Yuanyuan Zhang
    
    //2012-10-24 added this param for customer type B and salesbreakdown 2 field
    public String customerType{get;private set;}
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
    private map<Id, Opportunity> map_oppyId_oppy;
    private map<Id, String> map_oppyId_oldAccountComment = new map<Id, String>();
    private Id customerId;
    
    private String retUrl;
    private final Integer millionDenominator = 1000000;
    private Integer j = 0; //2012-10-29 added by yuanyuan zhang for valid key/won/loss project start date 
    
    //START 2012-07-12 added by Yuanyuan Zhang
    private Decimal te_prior_revernue;
    private Decimal te_actual_revernue;
    //private Decimal te_cy_forecast;
    private Decimal bu_prior_revernue;
    private Decimal bu_actual_revernue;
    //private Decimal bu_cy_forecast;
    private String locale;
    //END 2012-07-12 added by Yuanyuan Zhang
    
    //START 2012-07-17 added by Yuanyuan Zhang
    private Boolean isGlobalAccount;
    private String GAMCD;
    //END 2012-07-17 added by Yuanyuan Zhang   
    
    //START 2012-07-18 Account Grouping
    private set<Id> set_accountGroupIds;
    private set<String> set_globalAccountRegion;
    //END 2012-07-18 by Yuanyuan Zhang
    private set<String> set_salesFigure;
    map<String, Decimal> map_period_amount = new map<String, Decimal>();//added by xia 2013-04-15
    private map<String, String> map_salesFigure_type = new map<String,String>{
        'Direct' => 'Direct',
        'Indirect - Distribution' => 'POS',
        'Indirect - Contract Mfr Alloc\'s'  => 'CMA'
    };
    
    //added by xia 2013-04-01 B account
    private boolean isBAccount;
    private String MKTMGRCDE;
    //START 2013-11-29 added by lili
    private String accGAMCD;
    public  boolean isAppliancesBU{get;set;}
    //private set<String> set_AppliancesBU = new set<String>{'Household Appliances', 'Relay Products - Appl'};
    // add lili zhao 2014-06-11 begin due to change the requirement 
    // from SAP_Profit_Center_Short_Description__c to SAP_Profit_Center_Code__c,use the custom setting
    /*
    private map<String, String> map_BU_Appliances = new Map<String, String>{
        'Household Appliances' => 'Appliances',
        'Relay Products - Appl' => 'Appliances'
    };
    */
    // end
    //END 2013-11-29 added by lili
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
     * the constructor
     */
    public ExtAccountPlanEdit(ApexPages.StandardController stdCtrl) {
        this.accGAMCD = '';
        //this.strLink = '';
        //this.isKAMLink = false;
        //this.isGAMLink = false;
        strCBCTopSave = '';
        strCBCPercentSave = '';
        strRegionTopSave = '';
        strRegionPercentSave = '';
        map_urlParams = ApexPages.currentPage().getParameters();
        if(map_urlParams.containsKey('id')){
            this.stdCtrl = stdCtrl;
            this.accPlan = (Account_Plan__c) this.stdCtrl.getRecord();
            aid = this.accPlan.id;
            if(aid != null){
                aid = aid.substring(0,aid.length()-3);
            }
            mode = 'edit';
        }   
        else{
            mode = 'new';
        }
        if(map_urlParams.containsKey('accId')){
            accId = map_urlParams.get('accId');
        }
        if(map_urlParams.containsKey('retURL')){
            retUrl = map_urlParams.get('retURL');
        }
        init();
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    /*
    * 2012-10-26 added for unlock the record, if the record is sending to approval process
    */
    public void Unlock(){
        this.accPlan.Approval_Status__c = 'Unlocked';
        update this.accPlan;
    }
    /*
    public String getCBCUrl(){
        String cbcUrl = '';
        if(showCBCPanel){
            Decimal tmp1 = cbcPercent1 == null? 0 : cbcPercent1/100;
            Decimal tmp2 = cbcPercent2 == null? 0 : cbcPercent2/100;
            Decimal tmp3 = cbcPercent3 == null? 0 : cbcPercent3/100;
            Decimal tmp4 = cbcPercent4 == null? 0 : cbcPercent4/100;
            Decimal tmp5 = cbcPercent5 == null? 0 : cbcPercent5/100;
            
            if(cbcTop5 != null && cbcTop4 != null && cbcTop3 != null && cbcTop2 != null && cbcTop1 != null){
                cbcUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + 
                tmp1 + ',' + 
                tmp2 + ',' + 
                tmp3 + ',' +
                tmp4 + ',' +
                tmp5 +
                '&chl=' + 
                EncodingUtil.urlEncode(cbcTop1, 'UTF-8') + ' (' + (tmp1*100).setScale(1)+ '%)|' + 
                EncodingUtil.urlEncode(cbcTop2, 'UTF-8') + ' (' + (tmp2*100).setScale(1) + '%)|'+
                EncodingUtil.urlEncode(cbcTop3, 'UTF-8') + ' (' + (tmp3*100).setScale(1) + '%)|'+ 
                EncodingUtil.urlEncode(cbcTop4, 'UTF-8') + ' (' + (tmp4*100).setScale(1) + '%)|'+
                EncodingUtil.urlEncode(cbcTop5, 'UTF-8') + ' (' + (tmp5*100).setScale(1) + '%)' + 
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD';
            }
            else if(cbcTop4 != null && cbcTop3 != null && cbcTop2 != null && cbcTop1 != null){
                cbcUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + 
                tmp1 + ',' + 
                tmp2 + ',' + 
                tmp3 + ',' +
                tmp4 +
                '&chl=' + 
                EncodingUtil.urlEncode(cbcTop1, 'UTF-8') + ' (' + (tmp1*100).setScale(1)+ '%)|' + 
                EncodingUtil.urlEncode(cbcTop2, 'UTF-8') + ' (' + (tmp2*100).setScale(1) + '%)|'+
                EncodingUtil.urlEncode(cbcTop3, 'UTF-8') + ' (' + (tmp3*100).setScale(1) + '%)|'+
                EncodingUtil.urlEncode(cbcTop4, 'UTF-8') + ' (' + (tmp4*100).setScale(1) + '%)' + 
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD';
            }
            else if(cbcTop3 != null && cbcTop2 != null && cbcTop1 != null){
                cbcUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + 
                tmp1 + ',' + 
                tmp2 + ',' + 
                tmp3 +
                '&chl=' + 
                EncodingUtil.urlEncode(cbcTop1, 'UTF-8') + ' (' + (tmp1*100).setScale(1)+ '%)|' + 
                EncodingUtil.urlEncode(cbcTop2, 'UTF-8') + ' (' + (tmp2*100).setScale(1) + '%)|'+
                EncodingUtil.urlEncode(cbcTop3, 'UTF-8') + ' (' + (tmp3*100).setScale(1) + '%)' + 
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD'; 
            }
            else if(cbcTop2 != null && cbcTop1 != null){
                cbcUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + tmp1 +
                 ',' + tmp2 +'&chl=' + EncodingUtil.urlEncode(cbcTop1, 'UTF-8') + ' (' +
                 (tmp1*100).setScale(1)+ '%)|' + EncodingUtil.urlEncode(cbcTop2, 'UTF-8') + ' (' + (tmp2*100).setScale(1)+ '%)' +
                 '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD'; 
            }
            else if(cbcTop1 != null){
                cbcUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + 
                tmp1 +
                '&chl=' + EncodingUtil.urlEncode(cbcTop1, 'UTF-8') + ' (' + (tmp1*100).setScale(1) + '%)' +
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD'; 
            }                                           
        }
        return cbcUrl;
    }
    
    public String getRegionUrl(){
        String regionUrl = '';
        if(showRegionPanel){
            Decimal tmp1 = regionPercent1 == null? 0 : regionPercent1/100;
            Decimal tmp2 = regionPercent2 == null? 0 : regionPercent2/100;
            Decimal tmp3 = regionPercent3 == null? 0 : regionPercent3/100;
            Decimal tmp4 = regionPercent4 == null? 0 : regionPercent4/100;
            Decimal tmp5 = regionPercent5 == null? 0 : regionPercent5/100;
            
            if(regionTop5 != null && regionTop4 != null && regionTop3 != null && regionTop2 != null && regionTop1 != null){ 
                regionUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + 
                tmp1 + ',' + 
                tmp2 + ',' + 
                tmp3 + ',' +
                tmp4 + ',' +
                tmp5 +
                '&chl=' +                
                EncodingUtil.urlEncode(regionTop1, 'UTF-8') + ' (' + (tmp1*100).setScale(1) + '%)|' + 
                EncodingUtil.urlEncode(regionTop2, 'UTF-8') + ' (' + (tmp2*100).setScale(1) + '%)|' +
                EncodingUtil.urlEncode(regionTop3, 'UTF-8') + ' (' + (tmp3*100).setScale(1) + '%)|' +
                EncodingUtil.urlEncode(regionTop4, 'UTF-8') + ' (' + (tmp4*100).setScale(1) + '%)|' +
                EncodingUtil.urlEncode(regionTop5, 'UTF-8') + ' (' + (tmp5*100).setScale(1) + '%)'  + 
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD';
            }
            else if(regionTop4 != null && regionTop3 != null && regionTop2 != null && regionTop1 != null){
                regionUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + 
                tmp1 + ',' + 
                tmp2 + ',' + 
                tmp3 + ',' +
                tmp4 +
                '&chl=' + 
                EncodingUtil.urlEncode(regionTop1, 'UTF-8') + ' (' + (tmp1*100).setScale(1)+ '%)|' + 
                EncodingUtil.urlEncode(regionTop2, 'UTF-8') + ' (' + (tmp2*100).setScale(1) + '%)|'+
                EncodingUtil.urlEncode(regionTop3, 'UTF-8') + ' (' + (tmp3*100).setScale(1) + '%)|'+
                EncodingUtil.urlEncode(regionTop4, 'UTF-8') + ' (' + (tmp4*100).setScale(1) + '%)' + 
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD';
            }
            else if(regionTop3 != null && regionTop2 != null && regionTop1 != null){
                regionUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + 
                tmp1 + ',' + 
                tmp2 + ',' + 
                tmp3 +
                '&chl=' + 
                EncodingUtil.urlEncode(regionTop1, 'UTF-8') + ' (' + (tmp1*100).setScale(1)+ '%)|' + 
                EncodingUtil.urlEncode(regionTop2, 'UTF-8') + ' (' + (tmp2*100).setScale(1) + '%)|'+
                EncodingUtil.urlEncode(regionTop3, 'UTF-8') + ' (' + (tmp3*100).setScale(1) + '%)' + 
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD'; 
            }
            else if(regionTop2 != null && regionTop1 != null){
                regionUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + tmp1 +
                ',' + tmp2 +'&chl=' + EncodingUtil.urlEncode(regionTop1, 'UTF-8') + ' (' +
                (tmp1*100).setScale(1)+ '%)|' + EncodingUtil.urlEncode(regionTop2, 'UTF-8') + ' (' + (tmp2*100).setScale(1)+ '%)' +
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD'; 
            }
            else if(regionTop1 != null){
                regionUrl='https://chart.googleapis.com/chart?chs=600x200&cht=p3&chf=bg,s,F8F8F8&chd=t:' + 
                tmp1 +
                '&chl=' + 
                EncodingUtil.urlEncode(regionTop1, 'UTF-8') + ' (' + (tmp1*100).setScale(1)+ '%)' +
                '&chco=2B2BD6|AA0033|00948C|FF7A0F|C2BDDD';
            }                       
        }
        return regionUrl;
    }    
    */
    
     
    public void getChartWithCBC3(){
        //START modify 2012-09-12 minghao.li@itbconsult.com
        if(this.set_accountGroupIds.isEmpty()){
            return;
        }
        map<String, Decimal> map_CBC3Description_amountNew = new map<String, Decimal>();

        if(this.accPlan.Plan_Year__c != null && !this.set_salesFigure.isEmpty()){ 
            for(AggregateResult ar : [SELECT Part__r.Product_Hierarchy__r.CBC3_Description__c des,
                                                            sum(Bill_Prior_Year_Amount_USD__c) total
                                                      FROM BBB_Year_Bill_Book_Cust_PN__c
                                                      WHERE CBC3_Description__c != null
                                                      AND Customer__c IN :this.set_accountGroupIds
                                                      //AND Year__c = :this.accPlan.Plan_Year__c
                                                      AND Bill_Type__c IN :set_salesFigure
                                                      AND Bill_Prior_Year_Amount_USD__c != null
                                                      AND Bill_Prior_Year_Amount_USD__c != 0
                                                      group by Part__r.Product_Hierarchy__r.CBC3_Description__c limit 50000]){
                                                        
                map_CBC3Description_amountNew.put((String) ar.get('des'), (Decimal) ar.get('total'));
            } 
        }       
        setAllParamNull('cbc'); 
        if(!map_CBC3Description_amountNew.isEmpty()){
            getPieChartsParams(map_CBC3Description_amountNew, true);
            map_CBC3Description_amountNew = null;  //modify 2012-09-12 minghao.li@itbconsult.com **do not isEmpty if the map
        }
    }
    
     
    public void getChartWithRegion(){

        if(this.set_accountGroupIds.isEmpty() && (!this.isGlobalAccount || this.isBAccount)){//modified by xia 2014-04-01 add B account
            return;
        }
        if(this.planYearMinus1 == null && this.set_salesFigure.isEmpty()){
            return;
        }
        map<String, Decimal> map_region_amountNew = new map<String, Decimal>();
        String lastYear = String.valueOf(this.planYearMinus1);
        for(AggregateResult byb : [SELECT sum(Bill_Amount_USD__c) amountSum, 
                                                      Region__c
                                                  FROM BBB_Month_Bill_Book_Cust__c
                                                  WHERE Customer__c IN :this.set_accountGroupIds
                                                  AND Fiscal_Year__c = :lastYear
                                                  AND Bill_Type__c IN :this.set_salesFigure
                                                  AND Region__c != null
                                                  group by Region__c
                                                  ORDER BY Region__c 
                                                  NULLS LAST
                                                  Limit 50000]){//Region__c IN :this.set_globalAccountRegion
            if(byb.get('amountSum') != null){
                map_region_amountNew.put((String)byb.get('Region__c'), (Decimal)byb.get('amountSum'));
            }
        }
        setAllParamNull('region');
        if(map_region_amountNew.isEmpty()){
            return;
        }   
        
        getPieChartsParams(map_region_amountNew, false);
        map_region_amountNew = null;
    }
    
    
    private void getPieChartsParams(map<String, Decimal> map_description_amount, Boolean isCBC){

        Decimal sum = 0;       

        map<Decimal, list<String>> map_amount_des = new map<Decimal, list<String>>();

        set<Decimal> set_amount = new set<Decimal>();
        for(Decimal amount :map_description_amount.values()){
            set_amount.add(amount);
        }

        list<Decimal> list_sort = new list<Decimal>();
        list_sort.addAll(set_amount);
        list_sort.sort();
        
        Integer listSize = list_sort.size();
        Integer loopNumber = listSize - 4;  
        if(listSize <= 4){
            loopNumber = 0;
        }
        
        for(String description : map_description_amount.keySet()){
            Decimal newKey = map_description_amount.get(description);
            list<String> list_temp = new list<String>();
            if(map_amount_des.containsKey(newKey)){
                list_temp = map_amount_des.get(newKey);
                
            }
            list_temp.add(description);
            map_amount_des.put(newKey, list_temp);
            list_temp = null;   
        }

        if(!map_description_amount.isEmpty()){
            map_description_amount = null;
        }

        if(isCBC){
            for(Integer i=listSize-1; i >= 0; i--){
                list<String> list_tempName = map_amount_des.get(list_sort[i]);
                for(String des : list_tempName){
                    if(cbcPart1 == null){
                        cbcPart1 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        cbcTop1 = des;
                        sum += list_sort[i];
                    }
                    else if(cbcPart2 == null){
                        cbcPart2 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        cbcTop2 = des;
                        sum += list_sort[i];
                    }
                    else if(cbcPart3 == null){
                        cbcPart3 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
                        cbcTop3 = des;
                        sum += list_sort[i];
                    }
                    else if(cbcPart4 == null){
                        cbcPart4 = list_sort[i].setScale(1, System.Roundingmode.HALF_UP);
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
                        sum += list_sort[i];
                    }
                }
                list_tempName = null;
            }
            
            if(cbcPart5 != null){
                cbcPart5 = cbcPart5.setScale(1, System.Roundingmode.HALF_UP);
            }
            if(cbcPart1 != null){
                cbcPercent1 = (Decimal)cbcPart1/sum;
                cbcPercent1 = cbcPercent1.setScale(3, System.Roundingmode.HALF_UP);
                showCBCPanel = true;
                if(cbcPercent1 != null){
                    cbcPercent1 = cbcPercent1*100;
                }
            }
            else{
                showCBCPanel = false;
            }
            if(cbcPart2 != null){
                cbcPercent2 = (Decimal)cbcPart2/sum;
                cbcPercent2 = cbcPercent2.setScale(3, System.Roundingmode.HALF_UP);
                if(cbcPercent2 != null){
                    cbcPercent2 = cbcPercent2*100;
                }
                if(cbcPart3 == null){
                    cbcPercent2 = 100-cbcPercent1;
                }

            }
            if(cbcPart3 != null){
                cbcPercent3 = (Decimal)cbcPart3/sum;
                cbcPercent3 = cbcPercent3.setScale(3, System.Roundingmode.HALF_UP);
                if(cbcPercent3 != null){
                    cbcPercent3 = cbcPercent3*100;
                }
                if(cbcPart4 == null){
                    cbcPercent3 = 100-cbcPercent1-cbcPercent2;
                }

            }
            if(cbcPart4 != null){
                cbcPercent4 = (Decimal)cbcPart4/sum;
                cbcPercent4 = cbcPercent4.setScale(3, System.Roundingmode.HALF_UP);
                if(cbcPercent4 != null){
                    cbcPercent4 = cbcPercent4*100;
                }
                if(cbcPart5 == null){
                    cbcPercent4 = 100-cbcPercent1-cbcPercent2-cbcPercent3;
                }
                
            }
            if(cbcPart5 != null){
                cbcPercent5 = 100-cbcPercent1-cbcPercent2-cbcPercent3-cbcPercent4;
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
            
            
            if(regionPart1 != null && (this.isGlobalAccount || this.isBAccount)){//modified by xia 2013-04-1 add b account
                regionPercent1 = regionPart1/sum;
                regionPercent1 = regionPercent1.setScale(3, System.Roundingmode.HALF_UP);
                showRegionPanel = true;
                if(regionPercent1 != null){
                    regionPercent1 = regionPercent1*100;
                }
            }
            else{
                showRegionPanel = false;
            }
            if(regionPart2 != null){
                regionPercent2 = regionPart2/sum;
                regionPercent2 = regionPercent2.setScale(3, System.Roundingmode.HALF_UP);
                if(regionPercent2 != null){
                    regionPercent2 = regionPercent2*100;
                }
                if(regionPart3 == null){
                    regionPercent2 = 100-regionPercent1;
                }
                
            }
            if(regionPart3 != null){
                regionPercent3 = regionPart3/sum;
                regionPercent3 = regionPercent3.setScale(3, System.Roundingmode.HALF_UP);
                if(regionPercent3 != null){
                    regionPercent3 = regionPercent3*100;
                }
                if(regionPart4 == null){
                    regionPercent3 = 100-regionPercent1-regionPercent2;
                }
                
            }
            if(regionPart4 != null){
                regionPercent4 = regionPart4/sum;
                regionPercent4 = regionPercent4.setScale(3, System.Roundingmode.HALF_UP);
                if(regionPercent4 != null){
                    regionPercent4 = regionPercent4*100;
                }
                if(regionPart5 == null){
                    regionPercent4 = 100-regionPercent1-regionPercent2-regionPercent3;
                }
                
            }
            if(regionPart5 != null){
                regionPercent5 = 100-regionPercent1-regionPercent2-regionPercent3-regionPercent4;
            }
           }
        
    }
    
    
    /*
    //added by xia 2013-04-12
    public void getChartWithSalesPeriod(){
        if(this.set_accountGroupIds.isEmpty() && (!this.isGlobalAccount || this.isBAccount)){//modified by xia 2014-04-01 add B account
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
    public pageReference cancel(){
        pageReference pr;
        if(mode == 'new'){
            if(retUrl != null){
                pr = new pageReference('/' + retUrl);
            }
            else if(accId != null){
                pr = new pageReference('/' + accId);
            }
            else{
                pr = new pageReference('/home/home.jsp');
            }
        }
        else{
            
            if(retUrl != null){
                pr = new pageReference('/' + retUrl);
            }
            else{
                pr = new pageReference('/apex/ExtAccountPlanView_showAccountPlanDetail?id=' + accPlan.Id);
            }
            
        }
        pr.setRedirect(true);
        return pr;
    }
    
    public pageReference Saveone(){
        getChartWithCBC3(); 
        if(this.isGlobalAccount || this.isBAccount){        
            getChartWithRegion(); 
         }

        try {
            setkeyProjectAndWinLossOppy();
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString()));
        }
        
         if(chooseCBC){

            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'cbcTop1 :::'+cbcTop1 +';;;cbcPercent1 :::'+cbcPercent1 +';;cbcPercent3 :;'+cbcPercent3 ));

            this.accPlan.Sales_Breakdown_1_Description__c = cbcTop1==null?'0':cbcTop1;
            this.accPlan.Sales_Breakdown_2_Description__c = cbcTop2==null?'0':cbcTop2;
            this.accPlan.Sales_Breakdown_3_Description__c = cbcTop3;
            this.accPlan.Sales_Breakdown_4_Description__c = cbcTop4;
            this.accPlan.Sales_Breakdown_5_Description__c = cbcTop5;  

            this.accPlan.Sales_Breakdown_1_Percent__c = cbcPercent1==null?0:cbcPercent1;
            this.accPlan.Sales_Breakdown_2_Percent__c = cbcPercent2==null?0:cbcPercent2;
            this.accPlan.Sales_Breakdown_3_Percent__c = cbcPercent3;
            this.accPlan.Sales_Breakdown_4_Percent__c = cbcPercent4;
            this.accPlan.Sales_Breakdown_5_Percent__c = cbcPercent5;
         }
         else{

            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'regionTop1 :::'+regionTop1 +';;;regionTop2:::'+regionTop2+';;regionPercent1:;'+regionPercent1));

            this.accPlan.Sales_Breakdown_1_Description__c = regionTop1==null?'0':regionTop1;
            this.accPlan.Sales_Breakdown_2_Description__c = regionTop2==null?'0':regionTop2;
            this.accPlan.Sales_Breakdown_3_Description__c = regionTop3;
            this.accPlan.Sales_Breakdown_4_Description__c = regionTop4;
            this.accPlan.Sales_Breakdown_5_Description__c = regionTop5;
            
            this.accPlan.Sales_Breakdown_1_Percent__c = regionPercent1==null?0:regionPercent1;
            this.accPlan.Sales_Breakdown_2_Percent__c = regionPercent2==null?0:regionPercent2;
            this.accPlan.Sales_Breakdown_3_Percent__c = regionPercent3;
            this.accPlan.Sales_Breakdown_4_Percent__c = regionPercent4;
            this.accPlan.Sales_Breakdown_5_Percent__c = regionPercent5;
         } 
         //added by bin yuan
        try {
            setCompetitors();
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString()));
        }
        this.displayMUError = 'false';
        //TempErrMsg = '';
        
        integer i = 0;
        if(this.accPlan.Strategic_Initiative_2__c != null){
            if(this.accPlan.Strategic_Initiative_2_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative));           
            }
            if(this.accPlan.Strategic_Initiative_2_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));                  
            }
        }        
        if(this.accPlan.Strategic_Initiative_3__c != null){
            if(this.accPlan.Strategic_Initiative_3_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_3_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative)); 
            }
        }
        if(this.accPlan.Strategic_Initiative_4__c != null){
            if(this.accPlan.Strategic_Initiative_4_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_4_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative)); 
            }
        }
        if(this.accPlan.Strategic_Initiative_5__c != null){
            if(this.accPlan.Strategic_Initiative_5_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative));
            }
            if(this.accPlan.Strategic_Initiative_5_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_6__c != null){
            if(this.accPlan.Strategic_Initiative_6_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative));
            }
            if(this.accPlan.Strategic_Initiative_6_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_7__c != null){
            if(this.accPlan.Strategic_Initiative_7_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative));
            }
            if(this.accPlan.Strategic_Initiative_7_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_8__c != null){
            if(this.accPlan.Strategic_Initiative_8_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative));
            }
            if(this.accPlan.Strategic_Initiative_8_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_9__c != null){
            if(this.accPlan.Strategic_Initiative_9_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative));
            }
            if(this.accPlan.Strategic_Initiative_9_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_10__c != null){
            if(this.accPlan.Strategic_Initiative_10_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_10_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        
        //added by weihang 2013-04-11
        if(this.accPlan.Strategic_Initiative_11__c != null){
            if(this.accPlan.Strategic_Initiative_11_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_11_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_12__c != null){
            if(this.accPlan.Strategic_Initiative_12_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_12_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_13__c != null){
            if(this.accPlan.Strategic_Initiative_13_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_13_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_14__c != null){
            if(this.accPlan.Strategic_Initiative_14_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_14_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_15__c != null){
            if(this.accPlan.Strategic_Initiative_15_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_15_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_16__c != null){
            if(this.accPlan.Strategic_Initiative_16_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_16_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_17__c != null){
            if(this.accPlan.Strategic_Initiative_17_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_17_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_18__c != null){
            if(this.accPlan.Strategic_Initiative_18_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_18_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_19__c != null){
            if(this.accPlan.Strategic_Initiative_19_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_19_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        if(this.accPlan.Strategic_Initiative_20__c != null){
            if(this.accPlan.Strategic_Initiative_20_Status__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative)); 
            }
            if(this.accPlan.Strategic_Initiative_20_Target__c == null){
                i++;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
            }
        }
        
        
        if(this.accPlan.Name == null){
            i++; 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_mush_input_account_plan_name));//changed by yinfeng.guo from You_must_enter_a_value to ..
        }
        
        if(this.accPlan.Plan_Year__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_Plan_Year));//changed by yinfeng.guo
        }
        if(this.accPlan.Sales_Figures_Makeup__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_at_least_one_value));
        }
        
        if(this.accPlan.Key_Product_Percent_Title__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_Key_Product_Percent_Title));//changed by yinfeng.guo
        }
        //They are required fields.added by dichen.
        if(this.accPlan.Key_Product_1_Outlook__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_Key_Product_1_Outlook));//changed by yinfeng.guo
        }
        if(this.accPlan.TE_Performance_Status__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_TE_Performance_Status));//changed by yinfeng.guo
        }
        //They are required fields.added by dichen

        if(this.accPlan.Revenue_TAM_SAM__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_Revenue_TAM_SAM));//changed by yinfeng.guo
        }//They are required fields.added by di chen

        if(this.accPlan.Executive_Relationship__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_Executive_Relationship));//modified by yinfeng.guo
        }
        if(this.accPlan.Purchasing_Relationship__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_Purchasing_Relationship));//modified by yinfeng.guo
        }
        if(this.accPlan.Engineering_Relationship__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_Engineering_Relationship));//modified by yinfeng.guo
        }
        //They are required fields.added by dichen.

        if(this.accPlan.Competitor_1_MS_Trend__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_Competitor_1_MS_Trend));//modified by yinfeng.guo
        }
        //They are required fields.added by dichen
        if(this.accPlan.Strategic_Initiative_1_Target__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Target_for_this_Initiative));
        }
        if(this.accPlan.Strategic_Initiative_1_Status__c == null){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_Status_for_this_Initiative));
        }
        
        decimal cone = 0.0; decimal ctwo = 0.0; decimal cthree = 0.0; decimal cfour = 0.0; decimal cfive = 0.0; decimal csix = 0.0;
        if(this.accPlan.Competitor_1_Market_Share__c != null){cone = this.accPlan.Competitor_1_Market_Share__c;}
        if(this.accPlan.Competitor_2_Market_Share__c != null){ctwo = this.accPlan.Competitor_2_Market_Share__c;}
        if(this.accPlan.Competitor_3_Market_Share__c != null){cthree = this.accPlan.Competitor_3_Market_Share__c;}
        if(this.accPlan.Competitor_4_Market_Share__c != null){cfour = this.accPlan.Competitor_4_Market_Share__c;}
        if(this.accPlan.Competitor_5_Market_Share__c != null){cfive = this.accPlan.Competitor_5_Market_Share__c;}
        if(this.accPlan.Competitor_6_Market_Share__c != null){csix = this.accPlan.Competitor_6_Market_Share__c;}
        if(cone + ctwo + cthree + cfour + cfive + csix > 100){
            i++;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.Sum_of_all_Competitors_Market_Share_Percentages_cannot_exceed_100));
        } 

        voiceFileErrorMsg = '';
        if (voiceFileSize > 3145728)
        {
            ApexPages.Message msg = 
                new ApexPages.Message(ApexPages.Severity.ERROR, 
                system.Label.file_size_cannot_be_greater_than_3_MB);
            ApexPages.addMessage(msg);
            displayVoiceFileError = 'true';
            i++;
            voiceBody = null;
            voiceFileSize = 0;
            voiceFileErrorMsg = system.Label.file_size_cannot_be_greater_than_3_MB;
                            
        }
        else
        {
            if(voiceBody != null && voiceName != null && !voiceFileContentType.contains('audio')){
            
                ApexPages.Message msg = 
                    new ApexPages.Message(ApexPages.Severity.ERROR, 
                    system.Label.Invalid_audio_file_type);
                ApexPages.addMessage(msg);
                displayVoiceFileError = 'true';
                i++;
                voiceBody = null;
                voiceFileSize = 0;
                voiceFileErrorMsg = system.Label.Invalid_audio_file_type; //' ===' + '-->' + voiceFileContentType;
                
            }
              
        }
        i += j;
        if(i>0){displayError = 'true'; return null;
        }                                     
        
         
        Attachment voAttachment; 
         
         if(aid != null){
             list<Attachment> list_attachments = new list<Attachment>();
             if(voiceBody != null && voiceName != null){
                 try
                 {
                  voAttachment = [Select name, body, id, ParentId from Attachment a where a.name = 'VoiceOverview.wav' and a.ParentId = :aid and a.Parent.Name = :this.accPlan.Name order by Attachment.CreatedDate ];
                 }
                 catch(Exception e)
                 {
                     voAttachment = new Attachment();
                     voAttachment.ParentId = aid;
                 }
                
                voAttachment.Body = voiceBody;
                voAttachment.Name = 'VoiceOverview.wav';            
                //Upsert voAttachment;
                list_attachments.add(voAttachment);              
             }
             
             if(list_attachments.size() != 0){
                upsert list_attachments;
             }
         }
         
         
         
         try{
            //update list_oppy2Update;
            //START : 2012-05-30 some oppy is in valid. Need it late       
            if(!list_lossOppy.isEmpty() || list_winOppy.size() > 0){
                list<Opportunity> list_oppyUpdate = new list<Opportunity>();
                
                for(winLossOppy wlo: list_lossOppy){
                	system.debug('comments: ' + wlo.comments);
                	system.debug('oppy4edit.Account_Plan_Comment__c: ' + wlo.oppy4edit.Account_Plan_Comment__c);
                    if(wlo.oppy4edit.Account_Plan_Comment__c != wlo.comments && !((wlo.oppy4edit.Account_Plan_Comment__c == null || wlo.oppy4edit.Account_Plan_Comment__c == '') && (wlo.comments == null || wlo.comments == ''))){
                        list_oppyUpdate.add(wlo.oppy4edit);
                    }
                }
                for(winLossOppy wlo: list_winOppy){
                	system.debug('comments: ' + wlo.comments);
                	system.debug('oppy4edit.Account_Plan_Comment__c: ' + wlo.oppy4edit.Account_Plan_Comment__c);                	
                    if(wlo.oppy4edit.Account_Plan_Comment__c != wlo.comments && !((wlo.oppy4edit.Account_Plan_Comment__c == null || wlo.oppy4edit.Account_Plan_Comment__c == '') && (wlo.comments == null || wlo.comments == ''))){
                        list_oppyUpdate.add(wlo.oppy4edit);
                    }
                }    
                system.debug('list_oppyUpdate: ' + list_oppyUpdate);
                if(list_oppyUpdate.size() >0 ) update list_oppyUpdate;
                
            }
            //END
            //2012-07-10 modified by Yuanyuan
            if(this.accPlan.Approval_Status__c == 'Approved' || this.accPlan.Approval_Status__c == 'Rejected'){
                this.accPlan.Approval_Status__c = 'Not Submitted';
                this.accPlan.Replicate_to_Central_Org__c = false;
            }
            this.accPlan.TE_Revenue_Prior_Yr_Actual_M__c = this.te_prior_revernue;
            this.accPlan.TE_Revenue_YTD_Actual_M__c = this.te_actual_revernue;
            //this.accPlan.TE_Revenue_CY_Forecast_M__c = this.te_cy_forecast;
            this.accPlan.BU_Revenue_Prior_Yr_Actual_M__c = this.bu_prior_revernue;
            this.accPlan.BU_Revenue_YTD_Actual_M__c = this.bu_actual_revernue;
            //this.accPlan.BU_Revenue_CY_Forecast_M__c = this.bu_cy_forecast;
            //START 2012-07-18 added by Yuanyuan Zhang if only one sales break down exist, then fill second with the same description but with value zero.
            if(this.customerType != null && this.customerType.trim().equalsIgnoreCase('b')){
                if(this.accPlan.Sales_Breakdown_1_Description__c == null){
                    this.accPlan.Sales_Breakdown_1_Description__c = 'No Break down';
                    this.accPlan.Sales_Breakdown_1_Percent__c = 100;
                }
                if(this.accPlan.Sales_Breakdown_2_Description__c == null){
                    this.accPlan.Sales_Breakdown_2_Description__c = 'No Break down';
                    this.accPlan.Sales_Breakdown_2_Percent__c = 100 - this.accPlan.Sales_Breakdown_1_Percent__c;
                }
            }
            
            //this.accPlan.Business_Unit__c  = this.buName;
            if(this.accPlan.Monthly_Update__c != null && this.accPlan.Monthly_Update__c.length() > 3000){
                this.displayMUError = 'true';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.label.Monthly_Update_Too_Large));
                return null;
            }
            upsert this.accPlan;           
         }
         catch(DMLException ex){
             displayError = 'true';
             //ApexPages.Message myMsg1 = new ApexPages.Message(ApexPages.Severity.INFO, ex.getMessage());
             ApexPages.addMessages(ex);
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getStackTraceString()));
             return null;
         }
         
         if(mode == 'new'){
            Attachment myAttachment;
            if(voiceBody != null && voiceName != null){
                 myAttachment = new Attachment();
                 myAttachment.ParentId = this.accPlan.id;
                 myAttachment.Body = voiceBody;
                 myAttachment.Name = 'VoiceOverview.wav';            
                 insert myAttachment;
             }  
         }
         
         return new PageReference('/' + this.accPlan.id);
    }   
    
    /***
    //Function to handle delete command of Voice file
    ***/
    public PageReference RemoveVoiceFile(){
        Attachment Voiceatt = null;
        try
        {
            Voiceatt = [select id From Attachment where Attachment.ParentId = :aid and Attachment.Name = 'VoiceOverview.wav' Limit 1];
        }
        catch(Exception e){
        }   
        try{
            if (Voiceatt != null)
            {
                delete Voiceatt;
                voiceBody = null;
                voiceFileSize = 0;
                displayVoice = false;
            }
        }  
        catch(DMLException ex){
             displayError = 'true';
             //
        }   
        return null;
    }        
    
    //refresh plan year table after plan year is selected
    public pageReference refreshOverviewTable(){
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, accPlan.Plan_Year__c));
        //setAllParamNull();
        if(this.accPlan.Plan_Year__c != null){
            planYear = Integer.valueOf(accPlan.Plan_Year__c);
            planYearMinus3 = planYear - 3;
            planYearMinus2 = planYear - 2;
            planYearMinus1 = planYear - 1;
            planYearPlus1 = planYear + 1;
            planYearPlus4 = planYear + 4;
            planYearIsChoosed = true;
        }
   
        if(this.accPlan.Plan_Year__c != null){
            
            getTECalculation();  
            if(this.isGlobalAccount || this.isBAccount){
                setIs();
            }
            //getOpportunities(set_keyProjectId,set_winOppies,set_LossOppies);
            //this.chartCBC3Sql = ''; //add lili 2014.1.6
            //getChartWithCBC3(); //add lili 2014.1.6
            //if(this.isGlobalAccount || this.isBAccount){ //add lili 2014.1.6
                //this.chartRegionSql = ''; //add lili 2014.1.6
               // getChartWithRegion(); //add lili 2014.1.6
           // } //add lili 2014.1.6
        }
       
        return null;
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //2012-05-30 set competitor name
    private void setCompetitors(){//Competitor_1__c
        //Begin : added by yinfeng.guo 2012-09-10
        map<Id, Integer> map_accId_number = new map<Id, Integer>();
        Integer i = 1;
        if(this.accPlan.Competitor1__c != null){
            map_accId_number.put(this.accPlan.Competitor1__c, 1);
        }
        if(this.accPlan.Competitor2__c != null){
            map_accId_number.put(this.accPlan.Competitor2__c, 2);
        }
        if(this.accPlan.Competitor3__c != null){
            map_accId_number.put(this.accPlan.Competitor3__c, 3);
        }
        if(this.accPlan.Competitor4__c != null){
            map_accId_number.put(this.accPlan.Competitor4__c, 4);
        }
        if(this.accPlan.Competitor5__c != null){
            map_accId_number.put(this.accPlan.Competitor5__c, 5);
        }
        if(this.accPlan.Competitor6__c != null){
            map_accId_number.put(this.accPlan.Competitor6__c, 6);
        }
        //Begin : added by yinfeng.guo 2012-09-10
        if(!map_accId_number.isEmpty()){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'map_accId_number :: ' + map_accId_number.keySet()));
            for(Account acc : [SELECT Id, Name FROM Account WHERE Id IN :map_accId_number.keySet()]){
                fillCompetitorName(acc, map_accId_number.get(acc.Id));
            }
        }
    }
    
    private void fillCompetitorName(Account acc, Integer identifier){
        if(identifier == 1){
            this.accPlan.Competitor_1__c = acc.Name;
        }
        else if(identifier == 2){
            this.accPlan.Competitor_2__c = acc.Name;
        }
        else if(identifier == 3){
            this.accPlan.Competitor_3__c = acc.Name;
        }
        else if(identifier == 4){
            this.accPlan.Competitor_4__c = acc.Name;
        }
        else if(identifier == 5){
            this.accPlan.Competitor_5__c = acc.Name;
        }
        else if(identifier == 6){
            this.accPlan.Competitor_6__c = acc.Name;
        }
    }
    
    public pageReference refreshPerformanceAndChart(){
        set_salesFigure.clear();
        //setAllParamNull();
        if(this.accPlan.Sales_Figures_Makeup__c != null){
            for(String key : this.accPlan.Sales_Figures_Makeup__c.split(';')){
                set_salesFigure.add(map_salesFigure_type.get(key));
            }
        }
        getTECalculation();
        if(this.isGlobalAccount || this.isBAccount){
            setIs();
        }
        //this.chartCBC3Sql = '';//add lili 2014.1.6
        //getChartWithCBC3();//add lili 2014.1.6
        //if(this.isGlobalAccount || this.isBAccount){ //add lili 2014.1.6
            //this.chartRegionSql = '';//add lili 2014.1.6
            //getChartWithRegion();//add lili 2014.1.6
        
        //} //add lili 2014.1.6 
        //this.chartPeriodSql = ''; //add lili 2014.1.6
        //getChartWithSalesPeriod();//added by xia 2013-04-15 //add lili 2014.1.6
        return null;
    }
    //END 2012-05-24 added for pie chart
    @RemoteAction
    public static map<String, Decimal>  loadLineChart(Account_Plan__c accPlan) {   
        
        set<Id> set_accGroupIds = new set<Id>();
        set<String> set_salFigure = new set<String>();
        set<String> set_year = new set<String>();
        set<String> set_quarter = new set<String>();
        map<Date, String> map_date_fiscalQuarter = new map<Date,String>();
        map<date, Decimal> map_date_amount = new map<date, Decimal>();
        map<String, Decimal> map_period_amount = new map<String, Decimal>();
        map<String, Decimal> map_period_amount_Str = new map<String, Decimal>();
        map<String, String> map_salFigure_type = new map<String,String>{
            'Direct' => 'Direct',
            'Indirect - Distribution' => 'POS',
            'Indirect - Contract Mfr Alloc\'s'  => 'CMA'
        };
        Boolean isGlobalAcc = false; 
        Boolean isBAcc = false;
        String  mapPeriodAmountStr = '';
        date startDate;
        date endDate;   
        integer i = 1;   
        
        if(accPlan.Id != null) {
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
            if(accPlan.Sales_Figures_Makeup__c != null){
                for(String key : accPlan.Sales_Figures_Makeup__c.split(';')){
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
        }else {
            set_accGroupIds.add(accPlan.Customer__c);
            Account account = new Account();
            account = (Account)[SELECT Customer_Industry__c, Industry_Code_Description__c, Id, GAMCD__c, RecordType.DeveloperName, Type, Customer_Classification__c, IND_KAM_Code__c, MKTMGRCDE__c FROM Account WHERE Id =: accPlan.Customer__c LIMIT 1];
            if(account != null){
                if(account.RecordType.DeveloperName == 'CIS_Global_Account'){
                    if(account.Type == 'Global Account'){                                                      
                        isGlobalAcc = true;
                    }else if(account.Type == 'Grouped B'){
                        isBAcc = true;
                        for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE IND_KAM_Code__c = :account.IND_KAM_Code__c LIMIT 10000]){ 
                            set_accGroupIds.add(acc.Id);
                        }
                    }
                }  
            }
            if(accPlan.Sales_Figures_Makeup__c != null){
                for(String key : accPlan.Sales_Figures_Makeup__c.split(';')){
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
        if(accPlan.Sales_Figures_Makeup__c != null){
            for(String key : accPlan.Sales_Figures_Makeup__c.split(';')){
                set_salFigure.add(map_salFigure_type.get(key));
            }
        }
        if(accPlan.Plan_Year__c != null && !set_accGroupIds.isEmpty() && !set_salFigure.isEmpty()){
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
        system.debug(accPlan.Sales_Figures_Makeup__c);
        system.debug(accPlan.Plan_Year__c);
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
        if(accPlan.Sales_Figures_Makeup__c != null){
            for(String key : accPlan.Sales_Figures_Makeup__c.split(';')){
                set_salFigure.add(map_salFigure_type.get(key));
            }   
        }
        if(isGlobalAcc || isBAcc){
            if(set_accGroupIds.isEmpty() && (!isGlobalAcc || isBAcc) && accPlan.Plan_Year__c == null && set_salFigure.isEmpty()){
                return map_region_amount;
            } 
            Integer planYear = Integer.Valueof(accPlan.Plan_Year__c);
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
    
    //********************************* -=END private methods=- ***********************************
    private void init(){
        list_keyOppyAndProgramm = new list<keyOppyAndProgramm>();//2012-05-08
        list_winOppy = new list<winLossOppy>();
        list_lossOppy = new list<winLossOppy>();  
        setLocale();
        set_accountGroupIds = new set<Id>();//2012-07-18 added by Yuanyuan Zhang
        set_salesFigure = new set<String>();
        
        this.isGlobalAccount = false;
        this.isBAccount = false;
        this.isAppliancesBU = false;
        Id UsId = UserInfo.getUserId();
        displayError = 'false';
        displayVoice = false;
        displayVoiceFileError = 'false';
        this.displayMUError = 'false';
        String Permission;
        Attachment Voiceatt;
        
        //init charts paramenters
        chooseRegion = false;
        chooseCBC = true;
        
        //Init description parameters
        winComment1 = '';
        winComment2 = '';
        winComment3 = '';
        winComment4 = '';
        lossComment1 = '';
        lossComment2 = '';
        lossComment3 = '';
        lossComment4 = '';
        opportunity = new Opportunity();
        String accPlanId = '';

        if(mode == 'new'){
            this.accPlan = new Account_Plan__c();
            this.accPlan.Customer__c = this.accId;
            this.customerId = this.accId;                
            this.accPlan.Active__c = true;
            planYearIsChoosed = false;//2012-05-24 added by Yuanyuan Zhang
            //2012-05-30
            this.accPlan.Revenue_TAM_SAM__c = 'TAM';
            this.accPlan.RecordTypeId = [SELECT IsActive, 
                                                Id, 
                                                DeveloperName, 
                                                SobjectType, 
                                                SystemModstamp 
                                         FROM RecordType
                                         WHERE SobjectType = 'Account_Plan__c'
                                         AND DeveloperName = 'Active' LIMIT 1].Id;
            //
            Account customer;
            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
            //for(Account acc :[SELECT Customer_Industry__c, Industry_Code_Description__c, Id, GAMCD__c, RecordType.DeveloperName, Type, Customer_Classification__c,MKTMGRCDE__c FROM Account WHERE Id = :this.accId LIMIT 1])
            for(Account acc :[SELECT Customer_Industry__c, Industry_Code_Description__c, Id, GAMCD__c, RecordType.DeveloperName, Type, Customer_Classification__c, IND_KAM_Code__c, MKTMGRCDE__c FROM Account WHERE Id = :this.accId LIMIT 1]){
            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                customer = acc;
            }
            if(customer != null){
                this.buName = customer.Customer_Industry__c;
                this.customerType = customer.Customer_Classification__c;
                this.GAMCD = customer.GAMCD__c;
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                //this.MKTMGRCDE = customer.MKTMGRCDE__c;//added by xia 2013-04-01
                this.MKTMGRCDE = customer.IND_KAM_Code__c;
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                if(customer.RecordType.DeveloperName == 'CIS_Global_Account' /*&& customer.Type == 'Global Account'*/){
                    if(customer.Type == 'Global Account'){
                        // add lili 2013.11.29 begin
                        /*
                        if(customer.Industry_Code_Description__c == 'Appliances' || customer.Customer_Industry__c == 'Appliances') {
                            isAppliancesBU = true;
                            this.buName = 'Appliances';
                        }else{
                            this.buName = customer.Industry_Code_Description__c;
                        } 
                        */   
                        // add lili 2013.11.29 end                  
                        this.buName = customer.Industry_Code_Description__c; // add lili 2013.11.29                       
                        isGlobalAccount = true;
                        // Added by Lili Zhao 2014-03-05 Begin due to get the related account plan as  IND_KAM_Code__c if the IND_KAM_Code__c of the account is not null 
                        /*
                        if(this.MKTMGRCDE != null && this.MKTMGRCDE != '') {
                            for(Account_Plan__c  accPlan : [SELECT Id, Name, Customer__r.IND_KAM_Code__c, Customer__r.GAMCD__c, Customer__c,Customer__r.Type 
                                                            from Account_Plan__c 
                                                            where  Customer__r.IND_KAM_Code__c =: this.MKTMGRCDE 
                                                            and Customer__r.Type = 'Grouped B' 
                                                            and Customer__r.RecordType.DeveloperName = 'CIS_Global_Account']) {
                                accPlanId = accPlan.Id;
                                this.accPlanName = accPlan.Name;
                            }
                            if(accPlanId != '') {
                                this.isKAMLink =true;
                                this.strLink = '/apex/ExtAccountPlanEdit_editAccountPlan?id=' + accPlanId;                  
                            }
                        }
                        */
                        //Added by Lili Zhao 2014-03-05 End
                    }else if(customer.Type == 'Grouped B'){//added by xia 2013-04-01
                        isBAccount = true;
                        // Added by Lili Zhao 2014-03-05 Begin due to get the related account plan as  GAMCD__c if the GAMCD__c of the account is not null 
                        /*
                        if(this.GAMCD != null && this.GAMCD != '') {
                            for(Account_Plan__c  accPlan : [SELECT Name, Id, Customer__r.IND_KAM_Code__c, Customer__r.GAMCD__c, Customer__c,Customer__r.Type 
                                                            from Account_Plan__c 
                                                            where  Customer__r.GAMCD__c =: this.GAMCD 
                                                            and Customer__r.Type = 'Global Account' 
                                                            and Customer__r.RecordType.DeveloperName = 'CIS_Global_Account']) {
                                accPlanId = accPlan.Id;
                                this.accPlanName = accPlan.Name;
                            }
                            if(accPlanId != '') {
                                //this.isLink = true;
                                this.strLink = '/apex/ExtAccountPlanEdit_editAccountPlan?id=' + accPlanId;
                                this.isGAMLink = true;
                            }
                        }
                        */
                        //Added by Lili Zhao 2014-03-05 End
                    }
                }
                // add lili 2013.11.29 begin
                if(customer.Industry_Code_Description__c == 'Appliances' || customer.Customer_Industry__c == 'Appliances') {
                    isAppliancesBU = true;
                    this.buName = 'Appliances';
                }
                // add lili 2013.11.29 end    
            }        
        }
        else{
            planYearIsChoosed = true;//2012-05-24 added by Yuanyuan Zhang
            this.accPlan = [SELECT Account_Definition__c, Replicate_to_Central_Org__c, Account_Objective_1__c, Account_Objective_2__c, Account_Objective_3__c, Account_Objective_4__c, Account_Objective_5__c, Name, 
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
                              Competitor_6_Comments__c, Competitor_6_MS_Trend__c, Competitor_6_Market_Share__c, Customer__c,
                              Customer__r.RecordType.DeveloperName, Customer__r.Type, BU_Revenue_CY_Manual_Forecast_M__c, 
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
                              Lost_Project_1__r.Name, Lost_Project_2__r.Name, Lost_Project_3__r.Name, Lost_Project_4__r.Name,
                              Lost_Project_1__r.Five_Year_Revenue__c, Lost_Project_2__r.Five_Year_Revenue__c, Lost_Project_3__r.Five_Year_Revenue__c, Lost_Project_4__r.Five_Year_Revenue__c,
                              Lost_Project_1__r.Lost_Rejected_Dead_On_Hold_Reason__c, Lost_Project_2__r.Lost_Rejected_Dead_On_Hold_Reason__c, 
                              Lost_Project_3__r.Lost_Rejected_Dead_On_Hold_Reason__c, Lost_Project_4__r.Lost_Rejected_Dead_On_Hold_Reason__c,
                              Sales_Breakdown_1_Description__c, Sales_Breakdown_1_Percent__c, 
                              Sales_Breakdown_2_Description__c, Sales_Breakdown_2_Percent__c, Sales_Breakdown_3_Description__c, 
                              Sales_Breakdown_3_Percent__c, Sales_Breakdown_4_Description__c, Sales_Breakdown_4_Percent__c, 
                              Sales_Breakdown_5_Description__c, Sales_Breakdown_5_Percent__c, Customer__r.Name,
                              Strategic_Initiative_1__c, Strategic_Initiative_1_Status__c, Strategic_Initiative_1_Target__c, 
                              Strategic_Initiative_10__c, Strategic_Initiative_10_Status__c, Strategic_Initiative_10_Target__c, 
                              Strategic_Initiative_2__c, Strategic_Initiative_2_Status__c, Strategic_Initiative_2_Target__c, Strategic_Initiative_3__c, 
                              Strategic_Initiative_3_Status__c, Strategic_Initiative_3_Target__c, Strategic_Initiative_4__c, Strategic_Initiative_4_Status__c, 
                              Strategic_Initiative_4_Target__c, Strategic_Initiative_5__c, Strategic_Initiative_5_Status__c, Strategic_Initiative_5_Target__c, 
                              Strategic_Initiative_6__c, Strategic_Initiative_6_Status__c, Strategic_Initiative_6_Target__c, Strategic_Initiative_7__c, 
                              Strategic_Initiative_7_Status__c, Strategic_Initiative_7_Target__c,Strategic_Initiative_8_Status__c,
                              Company_Logo_Id__c, Company_Logo__c, Customer__r.Customer_Industry__c, Customer__r.Plan_Group_Id__c,
                              Account_Manager_Id__c, Account_Manager__c, GAM_Code__c, Account_Manager_Approver__c,Customer__r.Industry_Code_Description__c,
                              Competitor1__c, Competitor2__c, Competitor3__c, Competitor4__c, Competitor5__c, Competitor6__c,Customer__r.MKTMGRCDE__c,
                              //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                              Customer__r.IND_KAM_Code__c,
                              Customer__r.GAMCD__c,
                              //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                              Account_Objective_Active_1__c,Account_Objective_Active_2__c,Account_Objective_Active_3__c,Account_Objective_Active_4__c,Account_Objective_Active_5__c,
                              Account_Objective_Active_6__c,Account_Objective_Active_7__c,Account_Objective_Active_8__c,Account_Objective_Active_9__c,Account_Objective_Active_10__c,
                              Account_Objective_Active_11__c,Account_Objective_Active_12__c,Account_Objective_Active_13__c,Account_Objective_Active_14__c,Account_Objective_Active_15__c,
                              Account_Objective_Active_16__c,Account_Objective_Active_17__c,Account_Objective_Active_18__c,Account_Objective_Active_19__c,Account_Objective_Active_20__c,
                              Account_Objective_6__c,Account_Objective_7__c,Account_Objective_8__c,Account_Objective_9__c,Account_Objective_10__c,Account_Objective_11__c,Account_Objective_12__c,Account_Objective_13__c,
                              Account_Objective_14__c,Account_Objective_15__c,Account_Objective_16__c,Account_Objective_17__c,Account_Objective_18__c,Account_Objective_19__c,Account_Objective_20__c,
                              Account_Objective_Location_1__c,Account_Objective_Location_2__c,Account_Objective_Location_3__c,Account_Objective_Location_4__c,Account_Objective_Location_5__c,
                              Account_Objective_Location_6__c,Account_Objective_Location_7__c,Account_Objective_Location_8__c,Account_Objective_Location_9__c,Account_Objective_Location_10__c,
                              Account_Objective_Location_11__c,Account_Objective_Location_12__c,Account_Objective_Location_13__c,Account_Objective_Location_14__c,Account_Objective_Location_15__c,
                              Account_Objective_Location_16__c,Account_Objective_Location_17__c,Account_Objective_Location_18__c,Account_Objective_Location_19__c,Account_Objective_Location_20__c,
                              Strategic_Initiative_Active_1__c,Strategic_Initiative_Active_2__c,Strategic_Initiative_Active_3__c,Strategic_Initiative_Active_4__c,Strategic_Initiative_Active_5__c,
                              Strategic_Initiative_Active_6__c,Strategic_Initiative_Active_7__c,Strategic_Initiative_Active_8__c,Strategic_Initiative_Active_9__c,Strategic_Initiative_Active_10__c,
                              Strategic_Initiative_Active_11__c,Strategic_Initiative_Active_12__c,Strategic_Initiative_Active_13__c,Strategic_Initiative_Active_14__c,Strategic_Initiative_Active_15__c,
                              Strategic_Initiative_Active_16__c,Strategic_Initiative_Active_17__c,Strategic_Initiative_Active_18__c,Strategic_Initiative_Active_19__c,Strategic_Initiative_Active_20__c,
                              Strategic_Initiative_11__c,Strategic_Initiative_12__c,Strategic_Initiative_13__c,Strategic_Initiative_14__c,Strategic_Initiative_15__c,
                              Strategic_Initiative_16__c,Strategic_Initiative_17__c,Strategic_Initiative_18__c,Strategic_Initiative_19__c,Strategic_Initiative_20__c,
                              Strategic_Initiative_11_Target__c,Strategic_Initiative_12_Target__c,Strategic_Initiative_13_Target__c,Strategic_Initiative_14_Target__c,Strategic_Initiative_15_Target__c,
                              Strategic_Initiative_16_Target__c,Strategic_Initiative_17_Target__c,Strategic_Initiative_18_Target__c,Strategic_Initiative_19_Target__c,Strategic_Initiative_20_Target__c,
                              Strategic_Initiative_11_Status__c,Strategic_Initiative_12_Status__c,Strategic_Initiative_13_Status__c,Strategic_Initiative_14_Status__c,Strategic_Initiative_15_Status__c,
                              Strategic_Initiative_16_Status__c,Strategic_Initiative_17_Status__c,Strategic_Initiative_18_Status__c,Strategic_Initiative_19_Status__c,Strategic_Initiative_20_Status__c,
                              Strategic_Initiative_1_Owner__c,Strategic_Initiative_2_Owner__c,Strategic_Initiative_3_Owner__c,Strategic_Initiative_4_Owner__c,Strategic_Initiative_5_Owner__c,
                              Strategic_Initiative_6_Owner__c,Strategic_Initiative_7_Owner__c,Strategic_Initiative_8_Owner__c,Strategic_Initiative_9_Owner__c,Strategic_Initiative_10_Owner__c,
                              Strategic_Initiative_11_Owner__c,Strategic_Initiative_12_Owner__c,Strategic_Initiative_13_Owner__c,Strategic_Initiative_14_Owner__c,Strategic_Initiative_15_Owner__c,
                              Strategic_Initiative_16_Owner__c,Strategic_Initiative_17_Owner__c,Strategic_Initiative_18_Owner__c,Strategic_Initiative_19_Owner__c,Strategic_Initiative_20_Owner__c,TE_Inside_Account_Plan__c // added TE_Inside_Account_Plan__c field by Mrunal for R-1468
                        FROM Account_Plan__c
                        Where Id = :aid];
            this.customerType = this.accPlan.Customer_Type__c;
            this.customerId = this.accPlan.Customer__c;                    
            this.buName = this.accPlan.Customer__r.Customer_Industry__c;
            this.GAMCD = this.accPlan.GAM_Code__c;
            this.accGAMCD = this.accPlan.Customer__r.GAMCD__c;
            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
            //this.MKTMGRCDE = this.accPlan.Customer__r.MKTMGRCDE__c;
            this.MKTMGRCDE = this.accPlan.Customer__r.IND_KAM_Code__c;
            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
            if(this.accPlan.Customer__r.RecordType.DeveloperName == 'CIS_Global_Account' /*&& this.accPlan.Customer__r.Type == 'Global Account'*/){
                if(this.accPlan.Customer__r.Type == 'Global Account'){
                    isGlobalAccount = true;                   
                    this.buName = this.accPlan.Customer__r.Industry_Code_Description__c;                     
                    // add lili 2013.11.29 begin
                    /*               
                    if(this.accPlan.Customer__r.Industry_Code_Description__c == 'Appliances' || this.accPlan.Customer__r.Customer_Industry__c == 'Appliances') {
                        isAppliancesBU = true;
                        this.buName = 'Appliances';
                    }else{
                        this.buName = this.accPlan.Customer__r.Industry_Code_Description__c;
                    } 
                    */                      
                    // add lili 2013.11.29 end
                    // Added by Lili Zhao 2014-03-05 Begin due to get the related account plan as  IND_KAM_Code__c if the IND_KAM_Code__c of the account is not null 
                    /*
                    if(this.MKTMGRCDE != null && this.MKTMGRCDE != '') {
                        for(Account_Plan__c  accPlan : [SELECT Id, Name, Customer__r.IND_KAM_Code__c, Customer__r.GAMCD__c, Customer__c,Customer__r.Type 
                                                        from Account_Plan__c 
                                                        where  Customer__r.IND_KAM_Code__c =: this.MKTMGRCDE 
                                                        and Customer__r.Type = 'Grouped B' 
                                                        and Customer__r.RecordType.DeveloperName = 'CIS_Global_Account']) {
                            accPlanId = accPlan.Id;
                            this.accPlanName = accPlan.Name;
                        }
                        if(accPlanId != '') {
                            this.isKAMLink =true;
                            this.strLink = '/apex/ExtAccountPlanEdit_editAccountPlan?id=' + accPlanId;                  
                        }
                    }
                    */
                    //Added by Lili Zhao 2014-03-05 End
                }else if(this.accPlan.Customer__r.Type == 'Grouped B'){//add by xia 2013-04-01
                    isBAccount = true;
                    // Added by Lili Zhao 2014-03-05 Begin due to get the related account plan as  GAMCD__c if the GAMCD__c of the account is not null 
                    /*
                    if(this.accGAMCD != null && this.accGAMCD != '') {
                        for(Account_Plan__c  accPlan : [SELECT Name, Id, Customer__r.IND_KAM_Code__c, Customer__r.GAMCD__c, Customer__c,Customer__r.Type 
                                                        From Account_Plan__c 
                                                        Where  Customer__r.GAMCD__c =: this.accGAMCD 
                                                        and Customer__r.Type = 'Global Account' 
                                                        and Customer__r.RecordType.DeveloperName = 'CIS_Global_Account']) {
                            accPlanId = accPlan.Id;
                            this.accPlanName = accPlan.Name;
                        }
                        if(accPlanId != '') {
                            //this.isLink = true;
                            this.strLink = '/apex/ExtAccountPlanEdit_editAccountPlan?id=' + accPlanId;
                            this.isGAMLink = true;
                        }
                    }
                    */
                    //Added by Lili Zhao 2014-03-05 End
                    
                }
            }
            // add lili 2013.11.29 begin
            if(this.accPlan.Customer__r.Industry_Code_Description__c == 'Appliances' || this.accPlan.Customer__r.Customer_Industry__c == 'Appliances') {
                isAppliancesBU = true;
                this.buName = 'Appliances';
            }
            // add lili 2013.11.29 end
            if(this.accPlan.Sales_Figures_Makeup__c != null){
                for(String key : this.accPlan.Sales_Figures_Makeup__c.split(';')){
                    set_salesFigure.add(map_salesFigure_type.get(key));
                }
            }
                        
            try{
                Voiceatt= [select id From Attachment where Attachment.ParentId = :aid and Attachment.Name = 'VoiceOverview.wav' Limit 1];
                VoiceID = Voiceatt.id;
                displayVoice = true;
            }
            catch(Exception e){
                displayVoice = false;
            }
            if(accPlan.Plan_Year__c != null){
                planYear = Integer.Valueof(accPlan.Plan_Year__c);
                planYearMinus3 = planYear-3;
                planYearMinus2 = planYear-2;
                planYearMinus1 = planYear-1;
                planYearPlus1 = planYear+1;
                planYearPlus4 = planYear+4;
            }
        }
        
        
        if(this.GAMCD != null && this.customerType != null && this.customerType.trim().equalsIgnoreCase('A')){
            this.accPlan.Account_Definition__c = 'GAM Code';
        }
        map<Id, String> map_keyProjectId_startDate = new map<Id, String>();
        map<Id, String> map_winOppies_Date = new map<Id, String>();
        map<Id, String> map_LossOppies_Date = new map<Id, String>();
        if(accPlan.Key_Project_1__c != null){
            //set_keyProjectId.add(accPlan.Key_Project_1__c);
            map_keyProjectId_startDate.put(accPlan.Key_Project_1__c, accPlan.Key_Project_1_Start_Date__c);
        }
        if(accPlan.Key_Project_2__c != null){
            //set_keyProjectId.add(accPlan.Key_Project_2__c);
            map_keyProjectId_startDate.put(accPlan.Key_Project_2__c, accPlan.Key_Project_2_Start_Date__c);
        }
        if(accPlan.Key_Project_3__c != null){
            //set_keyProjectId.add(accPlan.Key_Project_3__c);
            map_keyProjectId_startDate.put(accPlan.Key_Project_3__c, accPlan.Key_Project_3_Start_Date__c);
        }
        if(accPlan.Key_Project_4__c != null){
            //set_keyProjectId.add(accPlan.Key_Project_4__c);
            map_keyProjectId_startDate.put(accPlan.Key_Project_4__c, accPlan.Key_Project_4_Start_Date__c);
        }
        if(accPlan.Key_Project_5__c != null){
            //set_keyProjectId.add(accPlan.Key_Project_5__c);
            map_keyProjectId_startDate.put(accPlan.Key_Project_5__c, accPlan.Key_Project_5_Start_Date__c);
        }
        if(accPlan.Key_Project_6__c != null){
            //set_keyProjectId.add(accPlan.Key_Project_6__c);
            map_keyProjectId_startDate.put(accPlan.Key_Project_6__c, accPlan.Key_Project_6_Start_Date__c);
        }
        //Exist win oppies
        if(accPlan.Won_Project_1__c != null){
            //set_winOppies.add(accPlan.Won_Project_1__c);
            map_winOppies_Date.put(accPlan.Won_Project_1__c, accPlan.Recent_Big_Win_1_Date_Won__c);
        }
        if(accPlan.Won_Project_2__c != null){
            //set_winOppies.add(accPlan.Won_Project_2__c);
            map_winOppies_Date.put(accPlan.Won_Project_2__c, accPlan.Recent_Big_Win_2_Date_Won__c);
        }
        if(accPlan.Won_Project_3__c != null){
            //set_winOppies.add(accPlan.Won_Project_3__c);
            map_winOppies_Date.put(accPlan.Won_Project_3__c, accPlan.Recent_Big_Win_3_Date_Won__c);
        }
        if(accPlan.Won_Project_4__c != null){
            //set_winOppies.add(accPlan.Won_Project_4__c);
            map_winOppies_Date.put(accPlan.Won_Project_4__c, accPlan.Recent_Big_Win_4_Date_Won__c);
        }
        //Exist loss oppies
        if(accPlan.Lost_Project_1__c != null){
            //set_LossOppies.add(accPlan.Lost_Project_1__c);
            map_LossOppies_Date.put(accPlan.Lost_Project_1__c, accPlan.Recent_Loss_1_Date__c);
        }
        if(accPlan.Lost_Project_2__c != null){
            //set_LossOppies.add(accPlan.Lost_Project_2__c);
            map_LossOppies_Date.put(accPlan.Lost_Project_2__c, accPlan.Recent_Loss_2_Date__c);
        }
        if(accPlan.Lost_Project_3__c != null){
            //set_LossOppies.add(accPlan.Lost_Project_3__c);
            map_LossOppies_Date.put(accPlan.Lost_Project_3__c, accPlan.Recent_Loss_3_Date__c);
        }
        if(accPlan.Lost_Project_4__c != null){
            //set_LossOppies.add(accPlan.Lost_Project_4__c);
            map_LossOppies_Date.put(accPlan.Lost_Project_4__c, accPlan.Recent_Loss_4_Date__c);
        }
        
        initPerformanceValues();
        
        showRegionPanel = false;
        set_accountGroupIds.add(this.accPlan.Customer__c);
        if(this.isGlobalAccount){
            //FFA - 20.11.12: Commented out because it is no more needed
            //set_globalAccountRegion = new set<String>();
            showRegionPanel = true;
            
            map<String, String> map_region_kz = ClsAccountPlanUtility.map_region_kz;
            //Added by bin yuan due to fix query 50001 limit bug when GAM Code or KAM Code equals null or ''
            if(this.GAMCD != null && this.GAMCD.trim() != '') {
              for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE GAMCD__c = :this.GAMCD LIMIT 10000]){ //Customer_Region__c
                  set_accountGroupIds.add(acc.Id);
              }
            }
            //End
            
        }
        else if(this.isBAccount && this.MKTMGRCDE != null){//added by xia 2013-04-01
            showRegionPanel = true;
            
            map<String, String> map_region_kz = ClsAccountPlanUtility.map_region_kz;
            //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
            //for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE MKTMGRCDE__c = :this.MKTMGRCDE LIMIT 10000]) //Customer_Region__c
            //Added by bin yuan due to fix query 50001 limit bug when GAM Code or KAM Code equals null or ''
            if(this.MKTMGRCDE != null && this.MKTMGRCDE.trim() != '') {
              for(Account acc : [SELECT Id, Customer_Industry__c FROM Account WHERE IND_KAM_Code__c = :this.MKTMGRCDE LIMIT 10000]){
              //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                  set_accountGroupIds.add(acc.Id);
              }
            }
        }
        //2012-05-24 added by Yuanyuan Zhang
        getTECalculation();
        
        getOpportunities(map_keyProjectId_startDate,map_winOppies_Date,map_LossOppies_Date);
        if(this.isGlobalAccount || this.isBAccount){
            setIs();
        }
        //getChartWithCBC3(); //add lili 2014.1.6
        // if(this.isGlobalAccount || this.isBAccount){// modified by xia 2013-04-01 add B account //add lili 2014.1.6
            //getChartWithRegion(); //add lili 2014.1.6
        //} //add lili 2014.1.6
        // getChartWithSalesPeriod();//add lili 2014.1.6
    }
    // add lili 2014.1.6 begin
    private void setIs() {
        if(this.set_accountGroupIds.isEmpty() && (!this.isGlobalAccount || this.isBAccount)){
            return;
        }
        if(this.planYearMinus1 == null && this.set_salesFigure.isEmpty()){
            return;
        }
        if(this.isGlobalAccount || this.isBAccount) {
            if(chooseCBC){      
                chooseRegion = true;
                chooseCBC = false;
            }
        }
        
    }
    // add lili 2014.1.6 end
    private void getTECalculation(){        
        if(this.accPlan.Plan_Year__c == null){
            return;
        }
        String lastYear = String.valueOf(planYearMinus1);

        this.accPlan.TE_Revenue_Prior_Yr_Actual_M__c = 0;
        this.accPlan.TE_Revenue_YTD_Actual_M__c = 0;
        this.accPlan.BU_Revenue_Prior_Yr_Actual_M__c = 0;
        this.accPlan.BU_Revenue_YTD_Actual_M__c = 0;

        this.te_prior_revernue = 0;
        this.te_actual_revernue = 0;
        this.bu_prior_revernue = 0;
        this.bu_actual_revernue = 0;

        if(this.set_accountGroupIds.isEmpty()){
            return;
        }

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
                                                  AND (Fiscal_Year__c = :this.accPlan.Plan_Year__c 
                                                  OR   Fiscal_Year__c = :lastYear)]){                              
            if (lastYear.equals(bmbbc.Fiscal_Year__c)){
                this.te_prior_revernue += bmbbc.Bill_Amount_USD__c;
            }
            else if(bmbbc.Fiscal_Year__c == this.accPlan.Plan_Year__c){
                this.te_actual_revernue += bmbbc.Bill_Amount_USD__c;
            }
            //if(bmbbc.SAP_Profit_Center__c == this.buName)
            if(this.buName == 'DataComm'){
                if(bmbbc.Profit_Center__c == 'DTC'){
                    if (lastYear.equals(bmbbc.Fiscal_Year__c)){
                        bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                    }
                    else if(bmbbc.Fiscal_Year__c == this.accPlan.Plan_Year__c){
                        bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                    }
                }
            }
            else{
            // ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, bmbbc.SAP_Profit_Center__c+''));   
                
                //if(bmbbc.SAP_Profit_Center_Short_Description__c != null && this.buName != null && bmbbc.SAP_Profit_Center_Short_Description__c.contains(this.buName) ) //modify 2013-08-06 minghao.li@itbconsult.com
                
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
                if(bmbbc.SAP_Profit_Center_Short_Description__c != null && this.buName != null ){ // add lili 2013.11.29
                    if(isAppliancesBU) {  // add lili 2013.11.29
                        if(map_BU_Appliances.containsKey(bmbbc.SAP_Profit_Center_Short_Description__c)) {  // add lili 2013.11.29
                            // if(bmbbc.SAP_Profit_Center__c == this.buName)
                            if (lastYear.equals(bmbbc.Fiscal_Year__c)){
                                bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                            }
                            else if(bmbbc.Fiscal_Year__c == this.accPlan.Plan_Year__c){
                                bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                            }
                        }  // add lili 2013.11.29  
                        */
                if(!set_BU_Appliances.isEmpty() && bmbbc.SAP_Profit_Center_Short_Description__c != null && this.buName != null && bmbbc.SAP_Profit_Center_Code__c != null) { 
                    if(isAppliancesBU) {  
                        if(set_BU_Appliances.contains(bmbbc.SAP_Profit_Center_Code__c)) {  
                            if (lastYear.equals(bmbbc.Fiscal_Year__c)) {
                                bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                            }else if(bmbbc.Fiscal_Year__c == this.accPlan.Plan_Year__c) {
                                bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                            }
                        }                     
                    }else{  // add lili 2013.11.29
                        if(bmbbc.SAP_Profit_Center_Short_Description__c.contains(this.buName)) {  // add lili 2013.11.29
                            // if(bmbbc.SAP_Profit_Center__c == this.buName)
                            if (lastYear.equals(bmbbc.Fiscal_Year__c)){  
                                bu_prior_revernue += bmbbc.Bill_Amount_USD__c;
                            }
                            else if(bmbbc.Fiscal_Year__c == this.accPlan.Plan_Year__c){
                                bu_actual_revernue += bmbbc.Bill_Amount_USD__c;
                            }
                        }  // add lili 2013.11.29
                    }  // add lili 2013.11.29
                }
            }
        }
        this.te_prior_revernue = (this.te_prior_revernue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);//modified by yinfeng.guo Scale from 1 to 3 
        this.te_actual_revernue = (this.te_actual_revernue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);//modified by yinfeng.guo Scale from 1 to 3 
        this.bu_prior_revernue = (this.bu_prior_revernue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);//modified by yinfeng.guo Scale from 1 to 3 
        this.bu_actual_revernue = (this.bu_actual_revernue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);//modified by yinfeng.guo Scale from 1 to 3 
        
        Boolean needFractile = true;
        this.strte_prior_revernue = ClsAccountPlanUtility.setNumberFormat(locale, this.te_prior_revernue, needFractile);
        this.strte_actual_revernue = ClsAccountPlanUtility.setNumberFormat(locale, this.te_actual_revernue, needFractile);
        this.strbu_prior_revernue = ClsAccountPlanUtility.setNumberFormat(locale, this.bu_prior_revernue, needFractile);
        this.strbu_actual_revernue = ClsAccountPlanUtility.setNumberFormat(locale, this.bu_actual_revernue, needFractile);
        
    }
    
    private void getOpportunities(map<Id, String> map_keyProjectId_startDate, map<Id, String> map_winOppies_Date, map<Id, String> map_LossOppies_Date){
        map<String, Decimal> map_ISOCode_convertRate = new map<String, Decimal>();//Get ISO Code and convert rate to change all other kind of money to USD
        
        list<keyOppyAndProgramm> list_keyOppyAndProgrammNotSelected = new list<keyOppyAndProgramm>();
        list<winLossOppy> list_winOppyNotSelected = new list<winLossOppy>();
        list<winLossOppy> list_lossOppyNotSelected = new list<winLossOppy>();
        set<String> set_oppyStage2Loss = new set<String>{'Lost/Dead - closed', 'Lost', 'Dead', 'Rejected - Closed'};// New request value : 'Closed Lost','Lost' and 'Dead' on 2014-07-01. old value : 'Lost/Dead - closed' 
        set<String> set_oppyStage2Win = new set<String>{'Won - Closed', 'Won', 'Production' , 'Order Received  or Mass Production'};// New request value : 'Closed Won', 'Won', 'Production' on 2014-07-01. old value : 'Won - Closed'
        System.debug('****set_oppyStage2Win***'+set_oppyStage2Win);
        System.debug('****set_oppyStage2Loss***'+set_oppyStage2Loss);
        //Change start by Mrunal for MINI Spin project, Commented hard coded record type values and Used Custom setting 'Opportunity Record type Group' for the same.
        set<String> set_oppyRecordType = new set<String>();//{'Opportunity_Engineering_Project','Opportunity_Sales_Parts_Only'};//, 'Program'
        set<String> set_oppyRT = new set<String>();     

        for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
            if(rt.Active__c && rt.API_Name__c!= null){
                if(rt.Group__c == 'Account Plan Generate Win Loss Oppy')
                    set_oppyRecordType.add(rt.API_Name__c); 
                    
                else if(rt.Group__c == 'Account Plan Filter Opptys in Query')
                    set_oppyRT.add(rt.API_Name__c);
                    //Added by padmaja for DND and CSD
                else if(rt.Group__c == 'DND Account Plan Set Oppty type')
                     set_dndRTs.add(rt.API_Name__c);
                else if(rt.Group__c == 'CSD Account Plan Set Oppty type')
                    if (rt.Is_Sales_Only__c)
                                    set_salescsdRTs.add(rt.API_Name__c);
                            else
                                    set_engcsdRTs.add(rt.API_Name__c);
                         
                else if(rt.Group__c == 'Account Plan Set Oppty type'){
                    if (rt.Is_Sales_Only__c)
                                    set_salesRTs.add(rt.API_Name__c);
                            else
                                    set_engineerRTs.add(rt.API_Name__c);
                                   
                                    
                }
            }
        }
        system.debug('>>>set_oppyRecordType: '+set_oppyRecordType);
            system.debug('>>>set_oppyRT: '+set_oppyRT);
        system.debug('>>>set_salesRTs: '+set_salesRTs);
            system.debug('>>>set_engineerRTs: '+set_engineerRTs);
        system.debug('>>>set_dndRTs: '+set_dndRTs);         
    //Change End by MRUNAL for MINI SPIN
        
        // add lili zhao 2014-06-18 due to add the IND record type
        set<Id> set_PMVRecordTypeId = new set<Id>();  
        /*
        for(Opportunity_Record_Type_Groups__c setting : Opportunity_Record_Type_Groups__c.getAll().values()) {
            if(setting.Active__c == true && setting.RecordTypeID__c != null && setting.Group__c == 'SPIN') {
                set_PMVRecordTypeId.add((Id)setting.RecordTypeID__c);
            }
        }  
        */           
        set_PMVRecordTypeId = ClsPMV_Util.getAllPMVRecordtypes();
        // end
        Datetime currentDatum = datetime.now();
        map<Id, Opportunity> map_lossOppId_lossOpp = new map<Id, Opportunity>();
        map<Id, Opportunity> map_winOppId_winOpp = new map<Id, Opportunity>();
        
        map_ISOCode_convertRate = ClsAccountPlanUtility.getRateMap();
        
        for(Opportunity oppy : [SELECT Id,
                                       Name,
                                       StageName, 
                                       Five_Year_Revenue__c, 
                                       RecordTypeId,
                                       RecordType.DeveloperName, 
                                       Master_Opportunity__c,
                                       Program__c,
                                       Program__r.Name,
                                       Master_Opportunity__r.Name,
                                       AccountId,
                                       CloseDate,
                                       CreatedDate,
                                       Lost_Rejected_Dead_On_Hold_Reason__c,
                                       Account_Plan_Comment__c,
                                       CurrencyIsoCode,
                                       LastModifiedDate,
                                       Total_Opportunity_Value__c,
                                       Five_Year_Value__c  
                                FROM Opportunity
                                WHERE AccountId IN :set_accountGroupIds
                                AND StageName != 'EOL'
                                AND StageName != 'Rejected'
                                AND StageName != 'Duplicate'
                                AND //Change start by Mrunal for MINI Spin project.
                                /*(RecordType.DeveloperName = 'Opportunity_Engineering_Project'
                                OR RecordType.DeveloperName = 'Opportunity_Sales_Parts_Only'
                                OR RecordType.DeveloperName = 'Program'*/
                                (RecordType.DeveloperName IN :set_oppyRT
                                //change End by Mrunal for MINI SPIN. 
                                // add lili zhao 2014-06-18 due to add the IND record type
                                OR RecordTypeId IN :set_PMVRecordTypeId)
                                // end
                                ORDER BY Program__c]){
             System.debug('****oppy****'+oppy);                   
            keyOppyAndProgramm koap;
            winLossOppy wlo;
            Decimal fiveYearValue = 0.000;
            Decimal fiveYearValue_cust = 0.000;
            
            
            if(oppy.CurrencyIsoCode != 'USD'){
                if(oppy.Five_Year_Revenue__c != null && map_ISOCode_convertRate.containsKey(oppy.CurrencyIsoCode)){
                    fiveYearValue = oppy.Five_Year_Revenue__c / map_ISOCode_convertRate.get(oppy.CurrencyIsoCode);
                    fiveYearValue = (fiveYearValue/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                }
            }
            else if(oppy.Five_Year_Revenue__c != null){
                fiveYearValue = (oppy.Five_Year_Revenue__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
            }
            
            //Five Year Value Calculation Starts here Added By Ravi <ravikumar.vasimalla@zensar.in>
            if(oppy.CurrencyIsoCode != 'USD'){
                if(oppy.Five_Year_Value__c!= null && map_ISOCode_convertRate.containsKey(oppy.CurrencyIsoCode)){
                    fiveYearValue_cust = oppy.Five_Year_Value__c/ map_ISOCode_convertRate.get(oppy.CurrencyIsoCode);
                    fiveYearValue_cust  = (fiveYearValue_cust/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                }
            }
            else if(oppy.Five_Year_Value__c!= null){
                fiveYearValue_cust = (oppy.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
            }
            //Five Year Value Calculation Ends here By Ravi <ravikumar.vasimalla@zensar.in>
            
           if(!set_oppyStage2Loss.contains(oppy.StageName)){
                        System.debug('*****set_oppyStage2Loss****'+set_oppyStage2Loss);
                        System.debug('****oppy1****'+oppy); 
                        System.debug('****oppy.StageName****'+oppy.StageName); 
                if(set_oppyStage2Win.contains(oppy.StageName)){
                            System.debug('*****set_oppyStage2Win****'+set_oppyStage2Win);
                            System.debug('****oppy2****'+oppy);  

                    // add lili Zhao 2014-06-18 begin due to add the PMV record type
                    if((set_oppyRecordType.contains(oppy.RecordType.DeveloperName)) || (set_PMVRecordTypeId.contains(oppy.RecordTypeId))){
                    // end
                    System.debug('*****set_oppyRecordType****'+set_oppyRecordType);
                        map_winOppId_winOpp.put(oppy.Id, Oppy);
                        System.debug('*****map_winOppId_winOpp****'+map_winOppId_winOpp);
                    }
                }
                else{
                    if(map_keyProjectId_startDate.containsKey(oppy.Id)){
                        koap = new keyOppyAndProgramm(oppy, true, fiveYearValue, map_keyProjectId_startDate.get(oppy.Id),fiveYearValue_cust,set_salesRTs,set_engineerRTs,set_dndRTs,set_salescsdRTs,set_engcsdRTs);//Change 2 more parameter set_salesRTs,set_engineerRTs passed by Mrunal for MINI Spin project.
                        list_keyOppyAndProgramm.add(koap);
                    }
                    else{
                        koap = new keyOppyAndProgramm(oppy, false ,fiveYearValue, null,fiveYearValue_cust, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);//Change 2 more parameter set_salesRTs,set_engineerRTs passed by Mrunal for MINI Spin project.
                        list_keyOppyAndProgrammNotSelected.add(koap);
                    }
                } 
           }
            // add lili Zhao 2014-06-18 begin due to add the PMV record type
            else if(set_oppyRecordType.contains(oppy.RecordType.DeveloperName) || set_PMVRecordTypeId.contains(oppy.RecordTypeId)){
                map_lossOppId_lossOpp.put(Oppy.Id, Oppy);
            }
            // end
        }
        if(!map_winOppId_winOpp.isEmpty() || !map_lossOppId_lossOpp.isEmpty()){
            generateWinLossOppy(map_winOppId_winOpp, map_lossOppId_lossOpp, map_ISOCode_convertRate, map_winOppies_Date, map_LossOppies_Date);
        }
        list_keyOppyAndProgramm = getkeySortedList(list_keyOppyAndProgramm, list_keyOppyAndProgrammNotSelected);
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
    private list<keyOppyAndProgramm> getkeySortedList(list<keyOppyAndProgramm> list_selected, list<keyOppyAndProgramm> list_notSelected){
        list<keyOppyAndProgramm> list_return = new list<keyOppyAndProgramm>();        
        list<Decimal> list_sort = new list<Decimal>();
        set<Decimal> set_sort = new set<Decimal>();
        set<Decimal> set_sort_cust = new set<Decimal>();        
        
        map<Decimal, list<keyOppyAndProgramm>> map_fiveYearValue_keyPro = new map<Decimal, list<keyOppyAndProgramm>>();
        
        if(list_selected != null){
            for(keyOppyAndProgramm kop : list_selected){
                set_sort.add(kop.fiveYearReve);
                set_sort_Cust.add(kop.fiveYearReve_cust);
                
                list<keyOppyAndProgramm> list_temp = new list<keyOppyAndProgramm>();
                if(map_fiveYearValue_keyPro.containsKey(kop.fiveYearReve)){
                    list_temp = map_fiveYearValue_keyPro.get(kop.fiveYearReve);
                }
                list_temp.add(kop);
                map_fiveYearValue_keyPro.put(kop.fiveYearReve, list_temp);
            }
            list_sort.addAll(set_sort);
            list_sort.sort();
            for(Integer i = list_sort.size() -1 ; i >=0; i--){
                list_return.addAll(map_fiveYearValue_keyPro.get(list_sort[i]));
            }
        }
        
        if(list_notSelected != null){
            list_sort.clear();
            set_sort.clear();
            set_sort_Cust.clear();            
            map_fiveYearValue_keyPro.clear();
            for(keyOppyAndProgramm kop : list_notSelected){
                set_sort.add(kop.fiveYearReve);
                set_sort_Cust.add(kop.fiveYearReve_Cust);
                list<keyOppyAndProgramm> list_temp = new list<keyOppyAndProgramm>();
                if(map_fiveYearValue_keyPro.containsKey(kop.fiveYearReve)){
                    list_temp = map_fiveYearValue_keyPro.get(kop.fiveYearReve);
                }
                list_temp.add(kop);
                map_fiveYearValue_keyPro.put(kop.fiveYearReve, list_temp);
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
    private list<winLossOppy> getwinlossSortedList(list<winLossOppy> list_selected, list<winLossOppy> list_notSelected){
        list<winLossOppy> list_return = new list<winLossOppy>();
        list<Decimal> list_sort = new list<Decimal>();
        set<Decimal> set_sort = new set<Decimal>();
        map<Decimal, list<winLossOppy>> map_fiveYearValue_keyPro = new map<Decimal, list<winLossOppy>>();

        if(list_selected != null){
            for(winLossOppy kop : list_selected){
                set_sort.add(kop.fiveYearReve);
                list<winLossOppy> list_temp = new list<winLossOppy>();
                if(map_fiveYearValue_keyPro.containsKey(kop.fiveYearReve)){
                    list_temp = map_fiveYearValue_keyPro.get(kop.fiveYearReve);
                }
                list_temp.add(kop);
                map_fiveYearValue_keyPro.put(kop.fiveYearReve, list_temp);
            }
            list_sort.addAll(set_sort);
            list_sort.sort();
            for(Integer i = list_sort.size() -1 ; i >=0; i--){
                list_return.addAll(map_fiveYearValue_keyPro.get(list_sort[i]));
            }
        }
        
        if(list_notSelected != null){
            list_sort.clear();
            set_sort.clear();
            map_fiveYearValue_keyPro.clear();
            for(winLossOppy kop : list_notSelected){
                set_sort.add(kop.fiveYearReve);
                list<winLossOppy> list_temp = new list<winLossOppy>();
                if(map_fiveYearValue_keyPro.containsKey(kop.fiveYearReve)){
                    list_temp = map_fiveYearValue_keyPro.get(kop.fiveYearReve);
                }
                list_temp.add(kop);
                map_fiveYearValue_keyPro.put(kop.fiveYearReve, list_temp);
            }
            list_sort.addAll(set_sort);
            list_sort.sort();
            for(Integer i = list_sort.size() -1 ; i >=0; i--){
                list_return.addAll(map_fiveYearValue_keyPro.get(list_sort[i]));
            }
        }
        return list_return;
    }
    //Generate win/loss oppies with selected ids for last three quaters
    private void generateWinLossOppy(map<Id, Opportunity> map_winOppId_winOpp, map<Id, Opportunity> map_lossOppId_lossOpp, map<String, Decimal> map_ISOCode_convertRate, map<Id, String> map_winOppies_Date, map<Id, String> map_LossOppies_Date){
        if(!map_winOppId_winOpp.isEmpty() || !map_lossOppId_lossOpp.isEmpty()){
            list<winLossOppy> list_winOppyNotSelected = new list<winLossOppy>();
            list<winLossOppy> list_lossOppyNotSelected = new list<winLossOppy>();
            set<Id> set_winlossOppyId = new set<Id>();
            set_winlossOppyId.addAll(map_winOppId_winOpp.KeySet());
            set_winlossOppyId.addAll(map_lossOppId_lossOpp.KeySet());
            list<Period> list_per = new list<Period>();
            /*Date today = date.today();
            Date startDate;
            Date endDate;
            //get current fiscal year and quater
            Integer fiscalYear;
            Integer cQuater;
            Integer lastQuater;
            String lastFiscalYear;
            for(Period p : [SELECT Type, 
                                   EndDate, 
                                   FiscalYearSettingsId,
                                   FiscalYearSettings.Name, 
                                   IsForecastPeriod, 
                                   Number, 
                                   Id, 
                                   PeriodLabel, 
                                   QuarterLabel, 
                                   StartDate 
                            FROM Period 
                            Where Type = 'Quarter']){// AND IsForecastPeriod = true?
                if(today <= p.EndDate && today >= p.StartDate){
                    fiscalYear = Integer.valueOf(p.FiscalYearSettings.Name);
                    cQuater = p.Number;
                    endDate = p.EndDate;
                }
                list_per.add(p);
            }
            
            if(cQuater > 2){
                lastQuater = cQuater - 2;
                lastFiscalYear = String.valueOf(fiscalYear);
            }
            else{
                lastQuater = cQuater == 2?4:3;
                lastFiscalYear = String.valueOf(fiscalYear - 1);
            }
            
            for(Period p : list_per){
                if(lastQuater == p.Number && lastFiscalYear == p.FiscalYearSettings.Name){
                    startDate = p.StartDate;
                    break;
                }
            }
            //Get sum of amount from win/loss oppy for last 3 quater
            map<Id, Decimal> map_oppyId_sum = new map<Id, Decimal>();
            for(Opportunity_Forecast__c oft : [SELECT Amount__c, 
                                                      CurrencyIsoCode, 
                                                      IsDeleted ,
                                                      Opportunity__c,
                                                      Opportunity__r.CloseDate,
                                                      Opportunity__r.StageName, 
                                                      RecordType.DeveloperName, 
                                                      Part__c,
                                                      Part_Confidence__c 
                                               FROM Opportunity_Forecast__c
                                               WHERE Opportunity__c IN :set_winlossOppyId 
                                              // AND Opportunity__r.CloseDate <= :endDate 
                                               //AND Opportunity__r.CloseDate >= :startDate
                                               AND Part__c != null]){
                     
                if((oft.Opportunity__r.StageName == 'Won - Closed' && oft.Part_Confidence__c == 'Won') || (oft.Opportunity__r.StageName == 'Lost/Dead - closed')){// leijun
                   
                    Decimal temp = 0.000;
                    if(map_oppyId_sum.containsKey(oft.Opportunity__c)){
                        temp = map_oppyId_sum.get(oft.Opportunity__c);
                    }
                    Decimal fiveYearValue = oft.Amount__c;
                    if(oft.CurrencyIsoCode != 'USD'){
                        if(oft.Amount__c != null && oft.Amount__c != 0 && map_ISOCode_convertRate.containsKey(oft.CurrencyIsoCode)){
                            fiveYearValue = oft.Amount__c / map_ISOCode_convertRate.get(oft.CurrencyIsoCode);
                        }
                    }
                    temp += fiveYearValue;
                    
                    map_oppyId_sum.put(oft.Opportunity__c, temp);
                }
            }
            
            for(Id oppyId : map_winOppId_winOpp.KeySet()){
                 
                winLossOppy wlo;
                Decimal fiveYearValue = 0.000;
                if(map_oppyId_sum.containsKey(oppyId)){
                    fiveYearValue = (map_oppyId_sum.get(oppyId)/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                }
                if(map_winOppies_Date.containsKey(oppyId)){
                    wlo = new winLossOppy(map_winOppId_winOpp.get(oppyId), true, fiveYearValue, map_winOppies_Date.get(oppyId));
                    if(map_winOppId_winOpp.get(oppyId).Account_Plan_Comment__c != null) wlo.comments = map_winOppId_winOpp.get(oppyId).Account_Plan_Comment__c;
                    list_winOppy.add(wlo);
                }
                else{
                    wlo = new winLossOppy(map_winOppId_winOpp.get(oppyId), false, fiveYearValue,null);
                    if(map_winOppId_winOpp.get(oppyId).Account_Plan_Comment__c != null) wlo.comments = map_winOppId_winOpp.get(oppyId).Account_Plan_Comment__c;
                    list_winOppyNotSelected.add(wlo);
                }          
            }
            
            for(Id oppyId : map_lossOppId_lossOpp.KeySet()){
                winLossOppy wlo;
                Decimal fiveYearValue = 0.000;
                if(map_oppyId_sum.containsKey(oppyId)){
                    fiveYearValue = (map_oppyId_sum.get(oppyId)/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                    
                }
                if(map_LossOppies_Date.containsKey(oppyId)){
                    wlo = new winLossOppy(map_lossOppId_lossOpp.get(oppyId), true, fiveYearValue, map_LossOppies_Date.get(oppyId));
                    if(map_lossOppId_lossOpp.get(oppyId).Account_Plan_Comment__c != null) wlo.comments = map_lossOppId_lossOpp.get(oppyId).Account_Plan_Comment__c;
                    list_lossOppy.add(wlo);
                }
                else{
                    wlo = new winLossOppy(map_lossOppId_lossOpp.get(oppyId), false, fiveYearValue, null);
                    if(map_lossOppId_lossOpp.get(oppyId).Account_Plan_Comment__c != null) wlo.comments = map_lossOppId_lossOpp.get(oppyId).Account_Plan_Comment__c;
                    list_lossOppyNotSelected.add(wlo);
                }           
            }           */
            //Start:add by leijun 2013-04-25 used to dear with fiveYearReve
            for(Id oppyId : map_winOppId_winOpp.KeySet()){
                 
                winLossOppy wlo;
                Decimal fiveYearValue = 0.000;
                Decimal fiveYearValue_cust = 0.000;
                
                if(map_winOppies_Date.containsKey(oppyId)){
                    wlo = new winLossOppy(map_winOppId_winOpp.get(oppyId), true, fiveYearValue, map_winOppies_Date.get(oppyId), fiveYearValue_cust, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);//Change 2 more parameter set_salesRTs,set_engineerRTs passed by Mrunal for MINI Spin project.
                    if(map_winOppId_winOpp.get(oppyId).Account_Plan_Comment__c != null) wlo.comments = map_winOppId_winOpp.get(oppyId).Account_Plan_Comment__c;
                    
   // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
                    if(wlo.oppy.Five_Year_Revenue__c != null)
                    fiveYearValue = (wlo.oppy.Five_Year_Revenue__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                    else fiveYearValue = 0;
                    
                    if(wlo.oppy.Five_Year_Value__c!= null)
                    fiveYearValue_cust=(wlo.oppy.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                    else fiveYearValue_cust= 0;
                    if(wlo.oppy.CurrencyIsoCode != 'USD') fiveYearValue = (fiveYearValue / map_ISOCode_convertRate.get(wlo.oppy.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);
                    
                    wlo.fiveYearReve = fiveYearValue;
                    wlo.fiveYearReve_Cust = fiveYearValue_Cust;
                    
                    list_winOppy.add(wlo);
                    System.debug('******list_winOppy****'+list_winOppy);
                }
                else{
                    wlo = new winLossOppy(map_winOppId_winOpp.get(oppyId), false, fiveYearValue,null, fiveYearValue_cust, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);//Change 2 more parameter set_salesRTs,set_engineerRTs passed by Mrunal for MINI Spin project.
                    if(map_winOppId_winOpp.get(oppyId).Account_Plan_Comment__c != null) wlo.comments = map_winOppId_winOpp.get(oppyId).Account_Plan_Comment__c;
                    if(wlo.oppy.Five_Year_Revenue__c != null)
                     fiveYearValue = (wlo.oppy.Five_Year_Revenue__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                     else fiveYearValue = 0;
                     if(wlo.oppy.Five_Year_Value__c!= null)
                    fiveYearValue_Cust = (wlo.oppy.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);                    
                     else fiveYearValue_Cust= 0;
                     
                    if(wlo.oppy.CurrencyIsoCode != 'USD') 
                    {
                      fiveYearValue = (fiveYearValue / map_ISOCode_convertRate.get(wlo.oppy.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);
                      fiveYearValue_Cust = (fiveYearValue_Cust / map_ISOCode_convertRate.get(wlo.oppy.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);                    
                    }
                    
                    wlo.fiveYearReve = fiveYearValue;
                    wlo.fiveYearReve_Cust = fiveYearValue_Cust;                    
                    list_winOppyNotSelected.add(wlo);
                }          
            }
            for(Id oppyId : map_lossOppId_lossOpp.KeySet()){
                winLossOppy wlo;
                Decimal fiveYearValue = 0.000;
                Decimal fiveYearValue_cust=0.000;
                if(map_LossOppies_Date.containsKey(oppyId)){
                    wlo = new winLossOppy(map_lossOppId_lossOpp.get(oppyId), true, fiveYearValue, map_LossOppies_Date.get(oppyId),fiveYearValue_cust, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);//Change 2 more parameter set_salesRTs,set_engineerRTs passed by Mrunal for MINI Spin project.
                    if(map_lossOppId_lossOpp.get(oppyId).Account_Plan_Comment__c != null) wlo.comments = map_lossOppId_lossOpp.get(oppyId).Account_Plan_Comment__c;

        // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########    
                    if(wlo.oppy.Five_Year_Revenue__c != null)
                    fiveYearValue = (wlo.oppy.Five_Year_Revenue__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                     else fiveYearValue = 0;
                    if(wlo.oppy.Five_Year_Value__c!= null)
                    fiveYearValue_Cust = (wlo.oppy.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                     else fiveYearValue_cust = 0;
                    if(wlo.oppy.CurrencyIsoCode != 'USD') {
                      fiveYearValue = (fiveYearValue / map_ISOCode_convertRate.get(wlo.oppy.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);
                      fiveYearValue_Cust = (fiveYearValue_Cust / map_ISOCode_convertRate.get(wlo.oppy.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);                    
                    }
                    wlo.fiveYearReve = fiveYearValue;
                    wlo.fiveYearReve_Cust = fiveYearValue_Cust;                    
                    list_lossOppy.add(wlo);
                }
                else{
                    wlo = new winLossOppy(map_lossOppId_lossOpp.get(oppyId), false, fiveYearValue, null,fiveYearValue_cust, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);//Change 2 more parameter set_salesRTs,set_engineerRTs passed by Mrunal for MINI Spin project.
                    if(map_lossOppId_lossOpp.get(oppyId).Account_Plan_Comment__c != null) wlo.comments = map_lossOppId_lossOpp.get(oppyId).Account_Plan_Comment__c;
                    
    // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
                    if(wlo.oppy.Five_Year_Revenue__c != null)
                    fiveYearValue = (wlo.oppy.Five_Year_Revenue__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                     else fiveYearValue = 0;
                    if(wlo.oppy.Five_Year_Value__c != null) 
                    fiveYearValue_Cust = (wlo.oppy.Five_Year_Value__c/millionDenominator).setScale(3, System.Roundingmode.HALF_UP);
                    else fiveYearValue_Cust = 0;
                    if(wlo.oppy.CurrencyIsoCode != 'USD') {
                      fiveYearValue = (fiveYearValue / map_ISOCode_convertRate.get(wlo.oppy.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);
                      fiveYearValue_Cust = (fiveYearValue_Cust / map_ISOCode_convertRate.get(wlo.oppy.CurrencyIsoCode)).setScale(3, System.Roundingmode.HALF_UP);
                    }
                    wlo.fiveYearReve = fiveYearValue;
                    wlo.fiveYearReve_Cust = fiveYearValue_Cust;                    
                    list_lossOppyNotSelected.add(wlo); 
                }           
            }   
            //End
            list_winOppy = getwinlossSortedList(list_winOppy, list_winOppyNotSelected);
            System.debug('******list_winOppy********'+list_winOppy);
            list_lossOppy = getwinlossSortedList(list_lossOppy, list_lossOppyNotSelected);
            System.debug('******list_lossOppy********'+list_lossOppy);
            
        }
    }
    
    
    private void setkeyProjectAndWinLossOppy(){
         j = 0;
         //2012-05-30
         map_oppyId_oppy = new map<Id,Opportunity>();
         map_oppyId_oldAccountComment = new map<Id, String>();
         //Clear all Key Project 
         this.accPlan.Key_Project_1__c = null;
         this.accPlan.Key_Project_2__c = null;
         this.accPlan.Key_Project_3__c = null;
         this.accPlan.Key_Project_4__c = null;
         this.accPlan.Key_Project_5__c = null;
         this.accPlan.Key_Project_6__c = null;
         
         this.accPlan.Key_Project_1_Start_Date__c = null;
         this.accPlan.Key_Project_2_Start_Date__c = null;
         this.accPlan.Key_Project_3_Start_Date__c = null;
         this.accPlan.Key_Project_4_Start_Date__c = null;
         this.accPlan.Key_Project_5_Start_Date__c = null;
         this.accPlan.Key_Project_6_Start_Date__c = null;
         
         this.accPlan.Key_Project_1_Value_M__c = null;
         this.accPlan.Key_Project_2_Value_M__c = null;
         this.accPlan.Key_Project_3_Value_M__c = null;
         this.accPlan.Key_Project_4_Value_M__c = null;
         this.accPlan.Key_Project_5_Value_M__c = null;
         this.accPlan.Key_Project_6_Value_M__c = null;
         
         //2012-07-12 Store key project desc
         map<Decimal , list<keyOppyAndProgramm>> map_value_list_keyOpp = new map<Decimal, list<keyOppyAndProgramm>>();
         list<Decimal> list_sort = new list<Decimal>();
         set<Decimal> set_sort = new set<Decimal>();
         for(keyOppyAndProgramm koap : list_keyOppyAndProgramm){
            if(koap.isSelected){
                list<keyOppyAndProgramm> list_keyOppys = new list<keyOppyAndProgramm>();
                if(map_value_list_keyOpp.containsKey(koap.fiveYearReve)){
                    list_keyOppys = map_value_list_keyOpp.get(koap.fiveYearReve);
                }
                list_keyOppys.add(koap);
                map_value_list_keyOpp.put(koap.fiveYearReve, list_keyOppys);
                set_sort.add(koap.fiveYearReve);
            }
            else{
                koap.oppy4edit.Is_Strategic__c = false;
            }
            map_oppyId_oppy.put(koap.oppy4edit.Id, koap.oppy4edit);
            //map_oppyId_oldAccountComment.put(koap.oppy.Id, koap.oppy.Account_Plan_Comment__c);
         }
         
         list_sort.addAll(set_sort); 
         list_sort.sort();
         
         for(Integer i = list_sort.size() -1 ; i >= 0 ; i--){
            for(keyOppyAndProgramm koap : map_value_list_keyOpp.get(list_sort[i])){
                if(this.accPlan.Key_Project_1__c == null){
                    this.accPlan.Key_Project_1__c = koap.oppy4edit.Id;
                    this.accPlan.Key_Project_1_Start_Date__c = koap.ap.Key_Project_1_Start_Date__c;//2012-10-26 modified by yuanyuan zhang
                    if(this.accPlan.Key_Project_1_Start_Date__c == null){
                        j++;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' key project ' + koap.oppy4edit.Name));           
                    }
                    this.accPlan.Key_Project_1_Value_M__c = koap.fiveYearReve;
                }
                else if(this.accPlan.Key_Project_2__c == null){
                    this.accPlan.Key_Project_2__c = koap.oppy4edit.Id;
                    this.accPlan.Key_Project_2_Start_Date__c = koap.ap.Key_Project_1_Start_Date__c;//2012-10-26 modified by yuanyuan zhang
                    if(this.accPlan.Key_Project_2_Start_Date__c == null){
                        j++;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' key project ' + koap.oppy4edit.Name));           
                    } 
                    this.accPlan.Key_Project_2_Value_M__c = koap.fiveYearReve;
                }
                else if(this.accPlan.Key_Project_3__c == null){
                    this.accPlan.Key_Project_3__c = koap.oppy4edit.Id;
                    this.accPlan.Key_Project_3_Start_Date__c = koap.ap.Key_Project_1_Start_Date__c;//2012-10-26 modified by yuanyuan zhang
                    if(this.accPlan.Key_Project_3_Start_Date__c == null){
                        j++;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' key project ' + koap.oppy4edit.Name));           
                    } 
                    this.accPlan.Key_Project_3_Value_M__c = koap.fiveYearReve;
                }
                else if(this.accPlan.Key_Project_4__c == null){
                    this.accPlan.Key_Project_4__c = koap.oppy4edit.Id;
                    this.accPlan.Key_Project_4_Start_Date__c = koap.ap.Key_Project_1_Start_Date__c;//2012-10-26 modified by yuanyuan zhang
                    if(this.accPlan.Key_Project_4_Start_Date__c == null){
                        j++;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' key project ' + koap.oppy4edit.Name));           
                    } 
                    this.accPlan.Key_Project_4_Value_M__c = koap.fiveYearReve;
                }
                else if(this.accPlan.Key_Project_5__c == null){
                    this.accPlan.Key_Project_5__c = koap.oppy4edit.Id;
                    this.accPlan.Key_Project_5_Start_Date__c = koap.ap.Key_Project_1_Start_Date__c;//2012-10-26 modified by yuanyuan zhang
                    if(this.accPlan.Key_Project_5_Start_Date__c == null){
                        j++;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' key project ' + koap.oppy4edit.Name));           
                    } 
                    this.accPlan.Key_Project_5_Value_M__c = koap.fiveYearReve;
                }
                else if(this.accPlan.Key_Project_6__c == null){
                    this.accPlan.Key_Project_6__c = koap.oppy4edit.Id;
                    this.accPlan.Key_Project_6_Start_Date__c = koap.ap.Key_Project_1_Start_Date__c;//2012-10-26 modified by yuanyuan zhang
                    if(this.accPlan.Key_Project_6_Start_Date__c == null){
                        j++;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' key project ' + koap.oppy4edit.Name));           
                    } 
                    this.accPlan.Key_Project_6_Value_M__c = koap.fiveYearReve;
                }
            }
            
        }

         this.accPlan.Won_Project_1__c = null;
         this.accPlan.Won_Project_2__c = null;
         this.accPlan.Won_Project_3__c = null;
         this.accPlan.Won_Project_4__c = null;
         this.accPlan.Lost_Project_1__c = null;
         this.accPlan.Lost_Project_2__c = null;
         this.accPlan.Lost_Project_3__c = null;
         this.accPlan.Lost_Project_4__c = null;
         
         //added by xia 2012-12-20
         this.accPlan.Recent_Big_Win_1__c = null;
         this.accPlan.Recent_Big_Win_1_Comments__c = null;
         this.accPlan.Recent_Big_Win_1_Date_Won__c = null;
         this.accPlan.Recent_Big_Win_1_Value_M__c = null;
         this.accPlan.Recent_Big_Win_2__c = null;
         this.accPlan.Recent_Big_Win_2_Comments__c = null;
         this.accPlan.Recent_Big_Win_2_Date_Won__c = null;
         this.accPlan.Recent_Big_Win_2_Value_M__c = null;
         this.accPlan.Recent_Big_Win_3__c = null;
         this.accPlan.Recent_Big_Win_3_Comments__c = null;
         this.accPlan.Recent_Big_Win_3_Date_Won__c = null;
         this.accPlan.Recent_Big_Win_3_Value_M__c = null;
         this.accPlan.Recent_Big_Win_4__c = null;
         this.accPlan.Recent_Big_Win_4_Comments__c = null;
         this.accPlan.Recent_Big_Win_4_Date_Won__c = null;
         this.accPlan.Recent_Big_Win_4_Value_M__c = null;
         
         this.accPlan.Recent_Loss_1__c = null;
         this.accPlan.Recent_Loss_1_Comments__c = null;
         this.accPlan.Recent_Loss_1_Date__c = null;
         this.accPlan.Recent_Loss_1_Value_M__c = null;
         this.accPlan.Recent_Loss_2__c = null;
         this.accPlan.Recent_Loss_2_Comments__c = null;
         this.accPlan.Recent_Loss_2_Date__c = null;
         this.accPlan.Recent_Loss_2_Value_M__c = null;
         this.accPlan.Recent_Loss_3__c = null;
         this.accPlan.Recent_Loss_3_Comments__c = null;
         this.accPlan.Recent_Loss_3_Date__c = null;
         this.accPlan.Recent_Loss_3_Value_M__c = null;
         this.accPlan.Recent_Loss_4__c = null;
         this.accPlan.Recent_Loss_4_Comments__c = null;
         this.accPlan.Recent_Loss_4_Date__c = null;
         this.accPlan.Recent_Loss_4_Value_M__c = null;
         
         //2012-07-13 added by Yuanyuan Zhang sort win/lost oppy
         map<Decimal , list<winLossOppy>> map_value_list_winlostOpp = new map<Decimal, list<winLossOppy>>();
         list_sort.clear();
         set_sort.clear();
         //2012-07-16 added by Yuanyuan Zhang set_date to get Fiscal date format
         set<date> set_date2FiscalFormat = new set<date>();
         
         for(winLossOppy wlo : list_winOppy){
            if(wlo.isSelected){
                list<winLossOppy> list_winlostOppys = new list<winLossOppy>();
                if(map_value_list_winlostOpp.containsKey(wlo.fiveYearReve)){
                    list_winlostOppys = map_value_list_winlostOpp.get(wlo.fiveYearReve);
                }
                list_winlostOppys.add(wlo);
                map_value_list_winlostOpp.put(wlo.fiveYearReve, list_winlostOppys);
                set_sort.add(wlo.fiveYearReve);
                set_date2FiscalFormat.add(wlo.LastModifiedDate.date());
            }
            map_oppyId_oppy.put(wlo.oppy4edit.Id,wlo.oppy4edit);
         }
         
         for(winLossOppy wlo : list_lossOppy){
            if(wlo.isSelected){
                set_date2FiscalFormat.add(wlo.LastModifiedDate.date());
            }
         }
         //2012-10-26 comment out for date. use picklist, use seletes it self.
         //map<Date, String> map_date_fiscalQuarter = ClsAccountPlanUtility.getCorrespondingFiscalQuarter(set_date2FiscalFormat);
         
         list_sort.addAll(set_sort);
         list_sort.sort();
         if(!map_value_list_winlostOpp.isEmpty()){
            for(Integer i = list_sort.size() -1 ; i >= 0 ; i--){
                for(winLossOppy wlo : map_value_list_winlostOpp.get(list_sort[i])){
                     if(this.accPlan.Won_Project_1__c == null){
                         this.accPlan.Won_Project_1__c = wlo.oppy4edit.Id;
                         this.accPlan.Recent_Big_Win_1__c = wlo.oppy4edit.Name;
                         this.accPlan.Recent_Big_Win_1_Comments__c = wlo.oppy4edit.Account_Plan_Comment__c;
                         this.accPlan.Recent_Big_Win_1_Date_Won__c = wlo.ap.Recent_Big_Win_1_Date_Won__c;//2012-10-26 modified by yuanyuan zhang //map_date_fiscalQuarter.get(wlo.oppy.LastModifiedDate.date());
                         if(this.accPlan.Recent_Big_Win_1_Date_Won__c == null){
                            j++;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' won project ' + wlo.oppy4edit.Name));           
                         }
                         this.accPlan.Recent_Big_Win_1_Value_M__c = wlo.fiveYearReve;
                     }
                     else if(this.accPlan.Won_Project_2__c == null){
                         this.accPlan.Won_Project_2__c = wlo.oppy4edit.Id;
                         this.accPlan.Recent_Big_Win_2__c = wlo.oppy4edit.Name;
                         this.accPlan.Recent_Big_Win_2_Comments__c = wlo.oppy4edit.Account_Plan_Comment__c;
                         this.accPlan.Recent_Big_Win_2_Date_Won__c = wlo.ap.Recent_Big_Win_1_Date_Won__c;//2012-10-26 modified by yuanyuan zhang //map_date_fiscalQuarter.get(wlo.oppy.LastModifiedDate.date());
                         if(this.accPlan.Recent_Big_Win_2_Date_Won__c == null){
                            j++;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' won project ' + wlo.oppy4edit.Name));           
                         }
                         this.accPlan.Recent_Big_Win_2_Value_M__c = wlo.fiveYearReve;
                     }
                     else if(this.accPlan.Won_Project_3__c == null){
                         this.accPlan.Won_Project_3__c = wlo.oppy4edit.Id;
                         this.accPlan.Recent_Big_Win_3__c = wlo.oppy4edit.Name;
                         this.accPlan.Recent_Big_Win_3_Comments__c = wlo.oppy4edit.Account_Plan_Comment__c;
                         this.accPlan.Recent_Big_Win_3_Date_Won__c = wlo.ap.Recent_Big_Win_1_Date_Won__c;//2012-10-26 modified by yuanyuan zhang //map_date_fiscalQuarter.get(wlo.oppy.LastModifiedDate.date());
                         if(this.accPlan.Recent_Big_Win_3_Date_Won__c == null){
                            j++;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' won project ' + wlo.oppy4edit.Name));           
                         }
                         this.accPlan.Recent_Big_Win_3_Value_M__c = wlo.fiveYearReve;
                     }
                     else if(this.accPlan.Won_Project_4__c == null){
                         this.accPlan.Won_Project_4__c = wlo.oppy4edit.Id;
                         this.accPlan.Recent_Big_Win_4__c = wlo.oppy4edit.Name;
                         this.accPlan.Recent_Big_Win_4_Comments__c = wlo.oppy4edit.Account_Plan_Comment__c;
                         this.accPlan.Recent_Big_Win_4_Date_Won__c = wlo.ap.Recent_Big_Win_1_Date_Won__c;//2012-10-26 modified by yuanyuan zhang //map_date_fiscalQuarter.get(wlo.oppy.LastModifiedDate.date());
                         if(this.accPlan.Recent_Big_Win_4_Date_Won__c == null){
                            j++;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' won project ' + wlo.oppy4edit.Name));           
                         }
                         this.accPlan.Recent_Big_Win_4_Value_M__c = wlo.fiveYearReve;
                     }
                }
                
            }
         }
         
        
        list_sort.clear();
        set_sort.clear();
        map_value_list_winlostOpp = new map<Decimal, list<winLossOppy>>();
         
        for(winLossOppy wlo : list_lossOppy){
            if(wlo.isSelected){
                list<winLossOppy> list_winlostOppys = new list<winLossOppy>();
                if(map_value_list_winlostOpp.containsKey(wlo.fiveYearReve)){
                    list_winlostOppys = map_value_list_winlostOpp.get(wlo.fiveYearReve);
                }
                list_winlostOppys.add(wlo);
                map_value_list_winlostOpp.put(wlo.fiveYearReve, list_winlostOppys);
                set_sort.add(wlo.fiveYearReve);
            }
            map_oppyId_oppy.put(wlo.oppy4edit.Id,wlo.oppy4edit);
        }
        
        list_sort.addAll(set_sort);
         list_sort.sort();
         if(!map_value_list_winlostOpp.isEmpty()){//added by yinfeng.guo 2012-09-10
             for(Integer i = 0; i < list_sort.size() ; i++){
                for(winLossOppy wlo : map_value_list_winlostOpp.get(list_sort[i])){
                     if(this.accPlan.Lost_Project_1__c == null){
                         this.accPlan.Lost_Project_1__c = wlo.oppy4edit.Id;
                         this.accPlan.Recent_Loss_1__c = wlo.oppy4edit.Name;
                         this.accPlan.Recent_Loss_1_Comments__c = wlo.oppy4edit.Account_Plan_Comment__c;
                         this.accPlan.Recent_Loss_1_Date__c = wlo.ap.Recent_Loss_1_Date__c;//2012-10-26 modified by yuanyuan zhang //map_date_fiscalQuarter.get(wlo.oppy.LastModifiedDate.date());
                         if(this.accPlan.Recent_Loss_1_Date__c == null){
                            j++;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' loss project ' + wlo.oppy4edit.Name));           
                         }
                         this.accPlan.Recent_Loss_1_Value_M__c = wlo.fiveYearReve;
                     }
                     else if(this.accPlan.Lost_Project_2__c == null){
                         this.accPlan.Lost_Project_2__c = wlo.oppy4edit.Id;
                         this.accPlan.Recent_Loss_2__c = wlo.oppy4edit.Name;
                         this.accPlan.Recent_Loss_2_Comments__c = wlo.oppy4edit.Account_Plan_Comment__c;
                         this.accPlan.Recent_Loss_2_Date__c = wlo.ap.Recent_Loss_1_Date__c;//2012-10-26 modified by yuanyuan zhang //map_date_fiscalQuarter.get(wlo.oppy.LastModifiedDate.date());
                         if(this.accPlan.Recent_Loss_2_Date__c == null){
                            j++;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' loss project ' + wlo.oppy4edit.Name));           
                         }
                         this.accPlan.Recent_Loss_2_Value_M__c = wlo.fiveYearReve;
                     }
                     else if(this.accPlan.Lost_Project_3__c == null){
                         this.accPlan.Lost_Project_3__c = wlo.oppy4edit.Id;
                         this.accPlan.Recent_Loss_3__c = wlo.oppy4edit.Name;
                         this.accPlan.Recent_Loss_3_Comments__c = wlo.oppy.Account_Plan_Comment__c;
                         this.accPlan.Recent_Loss_3_Date__c = wlo.ap.Recent_Loss_1_Date__c;//2012-10-26 modified by yuanyuan zhang //map_date_fiscalQuarter.get(wlo.oppy.LastModifiedDate.date());
                         if(this.accPlan.Recent_Loss_3_Date__c == null){
                            j++;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' loss project ' + wlo.oppy4edit.Name));           
                         }
                         this.accPlan.Recent_Loss_3_Value_M__c = wlo.fiveYearReve;
                     }
                     else if(this.accPlan.Lost_Project_4__c == null){
                         this.accPlan.Lost_Project_4__c = wlo.oppy4edit.Id;
                         this.accPlan.Recent_Loss_4__c = wlo.oppy4edit.Name;
                         this.accPlan.Recent_Loss_4_Comments__c = wlo.oppy4edit.Account_Plan_Comment__c;
                         this.accPlan.Recent_Loss_4_Date__c = wlo.ap.Recent_Loss_1_Date__c;//2012-10-26 modified by yuanyuan zhang //map_date_fiscalQuarter.get(wlo.oppy.LastModifiedDate.date());
                         if(this.accPlan.Recent_Loss_4_Date__c == null){
                            j++;
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_must_select_a_date_for + ' loss project ' + wlo.oppy4edit.Name));           
                         }
                         this.accPlan.Recent_Loss_4_Value_M__c = wlo.fiveYearReve;
                     }
                }
                
            }   
         }
    }
    
    private void initPerformanceValues(){
        //START 2012-06-01 init all values as zero
        this.accPlan.TE_Revenue_Prior_Yr_Actual_M__c = 0;
        this.accPlan.TE_Revenue_YTD_Actual_M__c = 0;
        //this.accPlan.TE_Revenue_CY_Forecast_M__c = 0;
        this.accPlan.BU_Revenue_Prior_Yr_Actual_M__c = 0;
        this.accPlan.BU_Revenue_YTD_Actual_M__c = 0;
        //this.accPlan.BU_Revenue_CY_Forecast_M__c = 0;
        //END 2012-06-01 
    }
    
    private void setLocale(){
        this.locale = Userinfo.getLocale();
        if(this.locale == 'de_DE'){
            this.locale = 'de';
        }
    }
    
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
            return;     
        }       
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
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    public class keyOppyAndProgramm{
        public Boolean isSelected{get;set;}
        public String oppyType{get;set;}
        //public Opportunity oppy{get;set;}
        public Decimal fiveYearReve{get;set;}
        public Account_Plan__c ap{get;set;}//2012-10-26 added for start date
        public Decimal fiveYearReve_cust{get;set;}//2013-08-02 Added for Five year value
        
        //****************************************************************************************************
        // START: modified & added by Bin Yu on 2015-11-05 to reduce the view state
        //****************************************************************************************************        
        public transient Opportunity oppy{get;set;}
        public Opportunity oppy4edit{get;set;}
        public String programName {get;set;}
        public String oppyAccComment {get;set;}
        //****************************************************************************************************
        // END: modified & added by Bin Yu on 2015-11-05 to reduce the view state
        //****************************************************************************************************          
        
                
        public keyOppyAndProgramm(Opportunity opp, Boolean chose, Decimal money, String startDate, Decimal Money_cust, set<string> set_salesRTs, set<string> set_engineerRTs, set<string> set_dndRTs, set<string> set_salescsdRTs, set<string> set_engcsdRTs){//Change 2 more parameter set_salesRTs,set_engineerRTs added by Mrunal for MINI Spin project.
            isSelected = chose;
            ap = new Account_Plan__c();
            if(startDate != null) ap.Key_Project_1_Start_Date__c = startDate;
            oppy = opp;
                         
        	//****************************************************************************************************
        	// START: modified & added by Bin Yu on 2015-11-05 to reduce the view state
        	//****************************************************************************************************     
            oppy4edit = new Opportunity();           
            oppy4edit.put('Id', opp.Id);
            oppy4edit.put('Name', opp.Name);
            oppy4edit.put('Program__c', '');
            oppy4edit.put('Is_Strategic__c', chose);
            programName = oppy.Program__r.Name == null? '':oppy.Program__r.Name;
            if(opp.Program__c !=null) oppy4edit.put('Program__c', opp.Program__c);                         
        	//****************************************************************************************************
        	// END: modified & added by Bin Yu on 2015-11-05 to reduce the view state
        	//****************************************************************************************************                    
            
            if(money != null){
                fiveYearReve = money;//.setScale(3, System.Roundingmode.HALF_UP)
            }
            if(Money_cust!=null){
                fiveYearReve_cust=Money_cust;
            }
            setOppyType(oppy.RecordType.DeveloperName,set_salesRTs,set_engineerRTs,set_dndRTs,set_salescsdRTs,set_engcsdRTs);//Change 2 more parameter set_salesRTs,set_engineerRTs passed by Mrunal for MINI Spin project.
        }
        private void setOppyType(String opType, set<string> set_salesRTs, set<string> set_engineerRTs, set<string> set_dndRTs, set<string> set_salescsdRTs, set<string> set_engcsdRTs){//Change 2 more parameter set_salesRTs,set_engineerRTs added by Mrunal for MINI Spin project.
            // add lili zhao 2014-06-18 due to add the IND record type
            /*
            if(opType == 'Opportunity_Engineering_Project'){
                oppyType = 'Engineering';
            }
            else if(opType == 'Opportunity_Sales_Parts_Only'){
                oppyType = 'Sales';
            }       
            */
            //Change start by Mrunal for MINI Spin project, Commented hard coded record type values and Used Custom setting 'Opportunity Record type Group' for the same.
            /*if(opType == 'Opportunity_Engineering_Project' || opType == 'IND_Engineering_project') {
                oppyType = 'Engineering';
            }else if(opType == 'Opportunity_Sales_Parts_Only' || opType == 'IND_Sales_Project') {
                oppyType = 'Sales';
            }                 
            // end*/
            
            
            
            if(set_engineerRTs.contains(opType)){
                oppyType = 'Engineering';
            }else if(set_salesRTs.contains(opType)) {
                oppyType = 'Sales';
            //Change End by MRUNAL for MINI SPIN
            }else if(set_dndRTs.contains(opType)) {
                oppyType = 'DND';//Change End by Padmaja for DND
            }else if(set_salescsdRTs.contains(opType)) {
                oppyType = 'Sales CSD';
            }else if(set_engcsdRTs.contains(opType)) {
                oppyType = 'Engineering CSD';
            //Change End by Padmaja for CSD 

            }else{
                oppyType = 'Program';
               
            }     
        }
    }
    
    public class winLossOppy{
        public Boolean isSelected{get;set;}
        public String comments{get;set;}
        public String oppyType{get;set;}
        public Decimal fiveYearReve{get;set;} 
        public Account_Plan__c ap{get;set;}//2012-10-26 added for won/loss date
        public Decimal fiveYearReve_Cust{get;set;} 
        //****************************************************************************************************
        // START: modified & added by Bin Yu on 2015-11-05 to reduce the view state
        //****************************************************************************************************
        public transient Opportunity oppy{get;set;}
        public Opportunity oppy4edit{get;set;}
        public Datetime LastModifiedDate {get;set;}
        //****************************************************************************************************
        // END: modified & added by Bin Yu on 2015-11-05 to reduce the view state
        //****************************************************************************************************   
        
             
        public winLossOppy(Opportunity opp, Boolean chose, Decimal money, String startDate, Decimal money_cust, set<string> set_salesRTs,set<string> set_engineerRTs,set<string> set_dndRTs,set<string> set_salescsdRTs,set<string> set_engcsdRTs){//Change 2 more parameter set_salesRTs,set_engineerRTs added by Mrunal for MINI Spin project.
            isSelected = chose;
            ap = new Account_Plan__c();
            
            if(startDate != null){
                ap.Recent_Big_Win_1_Date_Won__c = startDate;
                ap.Recent_Loss_1_Date__c = startDate;
            } 
            
            oppy = opp;
                        
        	//****************************************************************************************************
        	// START: modified & added by Bin Yu on 2015-11-05 to reduce the view state
        	//****************************************************************************************************     
            oppy4edit = new Opportunity();           
            oppy4edit.put('Id', opp.Id);
            oppy4edit.put('Name', opp.Name);
            oppy4edit.put('Account_Plan_Comment__c', '');
            LastModifiedDate = opp.LastModifiedDate;
            if(opp.Account_Plan_Comment__c !=null) oppy4edit.put('Account_Plan_Comment__c', opp.Account_Plan_Comment__c);                        
        	//****************************************************************************************************
        	// END: modified & added by Bin Yu on 2015-11-05 to reduce the view state
        	//****************************************************************************************************                
            
            comments = '';
            if(money != null){
                fiveYearReve = money;//.setScale(3, System.Roundingmode.HALF_UP)
            }
            if(money_Cust != null){
                fiveYearReve_Cust = money;//.setScale(3, System.Roundingmode.HALF_UP)
            }
                    
            setOppyType(oppy.RecordType.DeveloperName, set_salesRTs, set_engineerRTs, set_dndRTs, set_salescsdRTs, set_engcsdRTs);//Change 2 more parameter set_salesRTs,set_engineerRTs passed by Mrunal for MINI Spin project.
        }
        private void setOppyType(String opType,set<string> set_salesRTs,set<string> set_engineerRTs,set<string> set_dndRTs,set<string> set_salescsdRTs,set<string> set_engcsdRTs){//Change 2 more parameter set_salesRTs,set_engineerRTs added by Mrunal for MINI Spin project.
            // add lili zhao 2014-06-18 due to add the IND record type
            /*
            if(opType == 'Opportunity_Engineering_Project'){
                oppyType = 'Engineering';
            }
            else if(opType == 'Opportunity_Sales_Parts_Only'){
                oppyType = 'Sales';
            }            
            */
            //Change start by Mrunal for MINI Spin project, Commented hard coded record type values and Used Custom setting 'Opportunity Record type Group' for the same.
            /*if(opType == 'Opportunity_Engineering_Project' || opType == 'IND_Engineering_project') {
                oppyType = 'Engineering';
            }else if(opType == 'Opportunity_Sales_Parts_Only' || opType == 'IND_Sales_Project') {
                oppyType = 'Sales';
            }
            // end*/

            if(set_engineerRTs.contains(opType)){
                oppyType = 'Engineering';
            }else if(set_salesRTs.contains(opType)) {
                oppyType = 'Sales';
            //Change End by MRUNAL for MINI SPIN
            }else if(set_dndRTs.contains(opType)) {
                oppyType = 'DND';
            //Change End by Padmaja for DND Project
            }else if(set_salescsdRTs.contains(opType)) {
                oppyType = 'Sales CSD';
            //Change End by Padmaja for CSD
            }else if(set_engcsdRTs.contains(opType)) {
                oppyType = 'Engineering CSD';
            //Change End by Padmaja for CSD
            }else{
                oppyType = 'Program';
            }
        }
    }
    
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}