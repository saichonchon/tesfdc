/**
 * Created by alanbrown on 10/8/17.
 */
/***********************************************************************************************************************
      Name : Cls_BatchJDAPartForecast2_ENG
       Org : C2S
 Copyright : © 2017 TE Connectivity
========================================================================================================================
   Summary : A batch class to create records in INFRA Part Forecast object
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL                               User Story #
________________________________________________________________________________________________________________________
     1.0 alan         08/24/2017 Initial Development

***********************************************************************************************************************/
global class Cls_BatchJDAAccountPartForecast3_ENG implements   Database.Batchable<AggregateResult>,
        Iterable<AggregateResult>,
        Iterator<AggregateResult>,
        Database.Stateful {
    /* _______________________________________ GLOBAL VARIABLE DECLARATION ___________________________________________*/
    global String vQuery;
    //global Map<String, Decimal> currencyConversionMap = new Map<String, Decimal>();

    Integer index;
    List<AggregateResult> accountParts;
    Integer todayYearAndMonth;


    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
            'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
            'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };


    public void execute(SchedulableContext context) {
        Database.executeBatch(this);
    }
    public Iterator<AggregateResult> iterator() {
        return this;
    }
    public Boolean hasNext() {
        return index < accountParts.size();
    }
    public AggregateResult next() {
        return accountParts[index++];
    }



    global Cls_BatchJDAAccountPartForecast3_ENG() {

        Period currPeriod = [
                select Id, FiscalYearSettings.Name, PeriodLabel
                from Period
                where StartDate <= :System.today() and EndDate >= :System.today() and Type = 'Month'
                limit 1
        ];

        Integer currentYear = 3000;  //these are just arbitrarily large numbers so we don't pull any data if the fiscal year isn't set
        Integer currentMonth = 13;
        try {

            if (currPeriod.FiscalYearSettings.Name != null) { //set current year
                currentYear = Integer.valueOf (currPeriod.FiscalYearSettings.Name);
            }
            if (currPeriod.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(currPeriod.PeriodLabel)) { //set current month
                currentMonth = Integer.valueOf(MAP_MONTHLABELNUMBER.get(currPeriod.PeriodLabel));
            }
        } catch (Exception e) {
            System.debug('could not parse the fiscalyear or fiscalmonth of the current date');
        }

        todayYearAndMonth = currentYear * 100 + currentMonth;
        Integer eighteenMonthsFromNow = getYearMonthAsIntegerFor18MonthsInFuture(todayYearAndMonth);


        index = 0;

		accountParts = [
                select count(id),
                        opportunity_part__r.opportunity__r.accountid acctId,
                        opportunity_part__r.part__r.product_hierarchy__r.id gplId
                from opportunity_part_forecast__c
                where year_and_month__c <= :eighteenMonthsFromNow
                and forecast_value2__c  != null
                and year_and_month__c >= :todayYearAndMonth
                and opportunity_part__r.part__r.product_hierarchy__c != null
                and opportunity_part__r.opportunity__r.account.Account_Number_JDA_bridge_format__c != null
                and Opportunity_forecast__r.Opportunity__r.account.LAYER2_ORGANIZATION_SHORT_NM__c != null
                and opportunity_part__r.opportunity__r.accountid != null
                group by opportunity_part__r.opportunity__r.accountid,
                         opportunity_part__r.part__r.product_hierarchy__r.id
        ];

        //FINISH: Modified by Yiming Shen <yiming.shen@capgemini.com> at 2017/10/12 due to Invalid field opportunity_part__r.opportunity__r.accountid for AggregateResult
    }

    //STANDARD QueryLocator METHOD TO EXECUTE THE QUERY IN CONSTRUCTOR
    public Iterable<AggregateResult> start(Database.BatchableContext context) {
        return this;
    }



    private List<Opportunity_Part_Forecast__c> getOPFs(Set<String> accGPLs, integer yearAndMonthToday, Integer yearAndMonthEighteenMonths) {
        return [
                select id,
                        opportunity_part__r.part__r.product_hierarchy__r.name,
                        opportunity_part__r.opportunity__r.accountid,
                        Opportunity_part__r.opportunity__r.account.name,
                        year_and_month__c,
                        Forecast_Value2__c,
                        year__c,
                        month__c,
                        opportunity_part__r.part__r.name,
                        Opportunity_Forecast__r.confidence_level__c,
                        Opportunity_forecast__r.Opportunity__r.Is_Base_Business__c,
                        //START: Added by Yiming Shen <yiming.shen@capgemini.com> at 2017/20/12 due to 
                        Opportunity_Part__r.Opportunity__r.account.LAYER2_ORGANIZATION_SHORT_NM__c,
                        Opportunity_Part__r.Opportunity__r.account.Account_Number_JDA_bridge_format__c,
                        //FINISH: Added by Yiming Shen <yiming.shen@capgemini.com> at 2017/20/12 due to 
                        Opportunity_forecast__r.Opportunity__r.account.LAYER2_ORGANIZATION_SHORT_NM__c,
                        Opportunity_forecast__r.Opportunity__r.account.Account_Number_JDA_bridge_format__c
                from opportunity_part_forecast__c
                where  AccountIdGPLid__c in :accGPLs
                and opportunity_forecast__r.Confidence_level__c != '0'
                and forecast_value2__c != null and forecast_value2__c > 0
                and year_and_month__c <= :yearAndMonthEighteenMonths
                and year_and_month__c >= :yearAndMonthToday
                and Opportunity_forecast__r.Opportunity__r.account.LAYER2_ORGANIZATION_SHORT_NM__c != null
        ];
    }


    private INFRA.ForecastData.PartData getINFRAForecastPart(INFRA.ForecastUtil.DataStream dataStream) {
        INFRA.ForecastData.PartData result = new INFRA.ForecastData.PartData();

        result.customerIndicator = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
        result.productHierarchyIndicator = INFRA.ForecastUtil.ProductHierarchyIndicator.GPL;
        //currForecastHeader.businessUnitForecastSourceId = accToAccParts.get(id)[0].Opportunity__c;
        result.site = 'OTHERS';
        result.datastream = datastream; //508=New, 509=Existing
        result.siteIndicator = INFRA.ForecastUtil.SiteIndicator.OTHERS;
        result.customerIndicator = INFRA.ForecastUtil.CustomerIndicator.SoldTo;

        return result;
    }

    private void printOPFinfo (Map<AccountAndGPL, List<Opportunity_Part_Forecast__c>> accAndGPLToOppPartForecasts) {
        for (AccountAndGPL accAndGpl: accAndGPLToOppPartForecasts.keySet()) {
            System.debug('%%% Account/GPL is ' + accAndGpl.accountId + ' / ' + accAndGpl.gpl);
            List<Opportunity_Part_Forecast__c> opfs = accAndGPLToOppPartForecasts.get(accAndGpl);
            for (Opportunity_Part_Forecast__c opf : opfs) {
                System.debug('%%% --- OPF.Account ' + opf.Opportunity_part__r.opportunity__r.account.name);
                System.debug('%%% --- OPF.AccountId ' + opf.Opportunity_part__r.opportunity__r.accountId);
                System.debug('%%% --- OPF.part ' + opf.opportunity_part__r.part__r.name);
                System.debug('%%% --- OPF.GPL ' + opf.Opportunity_part__r.part__r.product_hierarchy__r.name);
                System.debug('%%% --- OPF.year_and_month ' + opf.year_and_month__c);
                System.debug('%%% --- OPF.forecast_value2__c ' + opf.Forecast_Value2__c);
            }
        }
    }

    private static Integer getYearMonthAsIntegerFor2MonthsInFuture(Integer todayAsInteger) {
        Integer months = math.mod(todayAsInteger, 100);
        Integer years = todayAsInteger / 100;
        months += 2;
        if (months > 12) {
            years += 1;
            months -= 12;
        }
        return years * 100 + months;
    }

    private static Integer getYearMonthAsIntegerFor18MonthsInFuture(Integer todayAsInteger) {
        Integer months = math.mod(todayAsInteger, 100);
        Integer years = todayAsInteger / 100;
        months += 6;
        years += 1;
        if (months > 12) {
            years += 1;
            months -= 12;
        }
        return years * 100 + months;
    }





    //ACTUAL LOGIC TO CREATE FORECAST RECORDS
    global void execute(Database.BatchableContext BC, List<AggregateResult> aggregateAccountParts) {

        Integer twoFiscalMonthsFromNow = getYearMonthAsIntegerFor2MonthsInFuture(todayYearAndMonth);

        //List<Account_part__c> accPartList = [select id from Account_part__c where id in :accountIds];

        //Set<AccountAndGPL> accAndGPLs = new Set<AccountAndGPL>();
        Set<String> accGPLStrings = new Set<String>();

        for (AggregateResult ar : aggregateAccountParts) {
        	String accId =  String.valueOf(ar.get('acctId'));
            String gpl = String.valueOf(ar.get('gplId'));
            if (accId.length() == 0 || gpl.length() == 0)
                continue; //we don't have one or both of these key values for this opf record
            System.debug('%%% AccountId/GPLid is ' + accId + gpl);
            //accAndGPLs.add(new AccountAndGPL(accId, gpl));
            accGPLStrings.add(accId + gpl);
        }


        List<Opportunity_Part_Forecast__c> OppPartForecasts = getOPFs(accGPLStrings,
                                                                      todayYearAndMonth,
                                                                      getYearMonthAsIntegerFor18MonthsInFuture(todayYearAndMonth));

        Map<AccountAndGPL, List<Opportunity_Part_Forecast__c>> accAndGPLToOppPartForecasts =
                new  Map<AccountAndGPL, List<Opportunity_Part_Forecast__c>>();

        String gplName = '';


        //Make a a map of Acc/GPL -> List of their OPFs)
        for (Opportunity_Part_Forecast__c opf : oppPartForecasts) {
            gplName = opf.opportunity_part__r.part__r.product_hierarchy__r.name;

            AccountAndGPL accAndGPL = new AccountAndGPL(opf.opportunity_part__r.opportunity__r.accountid,
                                              opf.opportunity_part__r.part__r.product_hierarchy__c,
                                              opf.opportunity_part__r.part__r.product_hierarchy__r.name);

            String accGPLString = '' + opf.opportunity_part__r.opportunity__r.accountid + opf.opportunity_part__r.part__r.product_hierarchy__c;
            if (!accGPLStrings.contains(accGPLString)) {
                System.debug('%%% We have an UNEXPECTED OPF with AccId / gpl '+ opf.opportunity_part__r.opportunity__r.accountid
                            + opf.opportunity_part__r.part__r.product_hierarchy__c);
                continue;
            } else
                System.debug('%%% FOUND A GOOD AccId/GPL combo for acc/GPL ' + opf.opportunity_part__r.opportunity__r.accountid +  ' / ' + opf.opportunity_part__r.part__r.product_hierarchy__r.name);



            if (accAndGPLToOppPartForecasts.get(accAndGPL) == null) {
                accAndGPLToOppPartForecasts.put(accAndGPL, new List<Opportunity_Part_Forecast__c>());
                System.debug('%%% Created a new Acc/GPL header in the map for acc/gpl ' + accAndGPL.toString());
            }
            accAndGPLToOppPartForecasts.get(accAndGPL).add(opf);
        }

        printOPFinfo(accAndGPLToOppPartForecasts);

        //now we have all the OppPartForecasts for all the Account/GPLs for the Accounts in the batch

        //FORECAST RECORDS CREATION
        System.debug('accAndGPL size is ' + accAndGPLToOppPartForecasts.keyset().size());
        for (AccountAndGPL accAndGPL : accAndGPLToOppPartForecasts.keyset()) {
            //Header is Account and GPL (the top level keyset)
            //Details are in the OppPartForecast records

            List<INFRA.ForecastData.PartData> forecastList = new List<INFRA.ForecastData.PartData>();


            INFRA.ForecastData.PartData currForecastHeaderNewBiz
                    = getINFRAForecastPart(INFRA.ForecastUtil.DataStream.SalesBookingForecast);
            List<INFRA.ForecastDetail.PartDetail> currForecastDetailListNewBiz
                    = new List<INFRA.ForecastDetail.PartDetail>();

            INFRA.ForecastData.PartData currForecastHeaderExistingBiz
                    = getINFRAForecastPart(INFRA.ForecastUtil.DataStream.SalesDemandForecast);
            List<INFRA.ForecastDetail.PartDetail> currForecastDetailListExistingBiz
                    = new List<INFRA.ForecastDetail.PartDetail>();

            //These only get added if we have newBiz and we have existing biz records
            currForecastHeaderNewBiz.forecastDetail = currForecastDetailListNewBiz;
            currForecastHeaderExistingBiz.forecastDetail = currForecastDetailListExistingBiz;

            boolean isFirstRecord = true;

            Map <String, INFRA.ForecastDetail.PartDetail> monthAndYearToForecastDetailNewBiz =
                    new Map <String, INFRA.ForecastDetail.PartDetail>();

            Map <String, INFRA.ForecastDetail.PartDetail> monthAndYearToForecastDetailExistingBiz =
                    new Map <String, INFRA.ForecastDetail.PartDetail>();

            System.debug('%%% we will creating new and existing records for ' +accAndGPLToOppPartForecasts.size() + ' accGPL combos');

            System.debug('%%% Creating forecast records for accId/GPL: ' + accAndGPL.accountId + ', ' + accAndGPL.gplName);

            for (Opportunity_Part_Forecast__c opf : accAndGPLToOppPartForecasts.get(accAndGPL)) {

                if (isFirstRecord) {
                    //FOR PARENT FORECAST DATA
                    currForecastHeaderNewBiz.region = opf.opportunity_part__r.opportunity__r.account.LAYER2_ORGANIZATION_SHORT_NM__c;
                    currForecastHeaderNewBiz.customer = opf.opportunity_part__r.opportunity__r.account.Account_Number_JDA_bridge_format__c;
                    currForecastHeaderNewBiz.businessUnitForecastSourceId = opf.opportunity_part__r.opportunity__r.accountid;
                    currForecastHeaderNewBiz.productCode = accAndGPL.gplName;


                    currForecastHeaderExistingBiz.region = opf.opportunity_part__r.opportunity__r.account.LAYER2_ORGANIZATION_SHORT_NM__c;
                    currForecastHeaderExistingBiz.customer = opf.opportunity_part__r.opportunity__r.account.Account_Number_JDA_bridge_format__c;
                    currForecastHeaderExistingBiz.businessUnitForecastSourceId = opf.opportunity_part__r.opportunity__r.accountid;
                    currForecastHeaderExistingBiz.productCode = accAndGPL.gplName;

                }

                isFirstRecord = false;

                Integer opfConfidenceLevel = 0;
                if (opf.Opportunity_Forecast__r.confidence_level__c != '0') {

                    try {
                        opfConfidenceLevel = Integer.valueOf(opf.Opportunity_Forecast__r.confidence_level__c);

                    } catch (Exception e) {
                        String vStrError = 'Error Type = ' + e.getTypeName() +
                                ' Error Line = ' + e.getLineNumber() + '' +
                                ' Error Stack = ' + e.getStackTraceString() +
                                ' Error Message = ' + e.getMessage();
                        SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,
                                SalesforceConstant.strError, '', '', '', '5', '', '', 'Exception', e.getLineNumber() + '', e.getStackTraceString());
                    }
                }
                //We only consider OPFs >= 80% confidence level in the next 2 months
                Date threeMonthsFromNow = System.today().addMonths(3);

                System.debug('%%% confidenceLevel and yearAndMonth (and 2 months from now) are ' + opfConfidenceLevel + ', '
                        + opf.year_and_month__c + '(' + getYearMonthAsIntegerFor18MonthsInFuture(todayYearAndMonth) + ')');

                boolean isIncludedInJDA = opfConfidenceLevel >= 80 ||
                                          opf.year_and_month__c > twoFiscalMonthsFromNow;
                boolean isExistingBusiness = opf.Opportunity_forecast__r.Opportunity__r.Is_Base_Business__c;

                String yearAndMonth = String.valueOf(opf.year_and_month__c);

                System.debug('%%% isIncludedInJDA is ' + isIncludedInJDA);
                if (isIncludedInJDA) {
                    if (isExistingBusiness) {

                        if (monthAndYearToForecastDetailExistingBiz.get(yearAndMonth) == null) {
                            INFRA.ForecastDetail.PartDetail currForecastDetail = new INFRA.ForecastDetail.PartDetail();
                            currForecastDetail.period = yearAndMonth;
                            currForecastDetail.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;
                            currForecastDetail.amount = 0;
                            //currForecastDetailListExistingBiz.add(currForecastDetail);
                            monthAndYearToForecastDetailExistingBiz.put(yearAndMonth, currForecastDetail);
                        }
                        INFRA.ForecastDetail.PartDetail currForecastDetail = monthAndYearToForecastDetailExistingBiz.get(yearAndMonth);
                        System.debug('%%% EXISTINGBIZ amount is ' + currForecastDetail.amount);
                        System.debug('%%% EXISTINGBIZ forecastValue2 is ' + opf.Forecast_Value2__c);
                        if (opf.Forecast_Value2__c != null)
                            currForecastDetail.amount = currForecastDetail.amount + opf.Forecast_Value2__c;
                    } else {
                        if (monthAndYearToForecastDetailNewBiz.get(yearAndMonth) == null) {
                            INFRA.ForecastDetail.PartDetail currForecastDetail = new INFRA.ForecastDetail.PartDetail();
                            currForecastDetail.period = yearAndMonth;
                            currForecastDetail.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;
                            currForecastDetail.amount = 0;
                            //currForecastDetailListExistingBiz.add(currForecastDetail);
                            monthAndYearToForecastDetailNewBiz.put(yearAndMonth, currForecastDetail);
                        }
                        INFRA.ForecastDetail.PartDetail currForecastDetail = monthAndYearToForecastDetailNewBiz.get(yearAndMonth);
                        //System.debug('currForecastDetail is ' + currForecastDetail + ', and opf is ' + opf);
                        System.debug('%%% NEWBIZ amount is ' + currForecastDetail.amount);
                        System.debug('%%% NEWBIZ forecastValue2 is ' + opf.Forecast_Value2__c);
                        if (opf.Forecast_Value2__c != null)
                            currForecastDetail.amount = currForecastDetail.amount + opf.Forecast_Value2__c;

                    }
                }


            }
            if (monthAndYearToForecastDetailNewBiz.size() > 0) {
                currForecastDetailListNewBiz.addAll(monthAndYearToForecastDetailNewBiz.values());
                forecastList.Add(currForecastHeaderNewBiz);
            }
            if (monthAndYearToForecastDetailExistingBiz.size() > 0) {
                currForecastDetailListExistingBiz.addAll(monthAndYearToForecastDetailExistingBiz.values());
                forecastList.Add(currForecastHeaderExistingBiz);
            }

            System.debug('%%% NEWBIZ size is ' + currForecastDetailListNewBiz.size());
            System.debug('%%% EXISTINGBIZ size is ' + currForecastDetailListExistingBiz.size());
            //THIS IS THE PUBLISHER CLASS INITIALIZATION WITH CUSTOM SETTING NAME - 'IND'
            INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('ENG');
            //invoke the Part publish function and pass the forecast list
            System.debug('%%% FORECAST LIST size is ' + forecastList.size() );
            clsObj.publishPartForecast(forecastList);
        }

    }

    global void finish(Database.BatchableContext BC) {

    }

    private class AccountAndGPL {

        Id accountId;
        String gpl;
        String gplName;
		//START: Modified by Yiming Shen <yiming.shen@capgemini.com> at 2017/10/12 due to unexpected token error
        /*public Cls_BatchJDAAccountPartForecast3_ENG.AccountAndGPL (id theAccount, String theGPL) {*/
        public AccountAndGPL (id theAccount, String theGPL, String gplName) {
    	//FINISH: Modified by Yiming Shen <yiming.shen@capgemini.com> at 2017/10/12 due to unexpected token error
            accountId = theAccount;
            gpl = theGPL;
            this.gplName = gplName;
        }

        override public String toString() {
            return '' + accountId + gpl;
        }

        public Integer hashCode() {
            return toString().hashCode();
        }
        public Boolean equals(Object obj) {
            if (obj instanceof AccountAndGPL) {
                AccountAndGPL p = (AccountAndGPL)obj;
                return p.toString() == toString();
            }
            return false;
        }
    }

}