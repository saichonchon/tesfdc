/**
 *  Util class for page CtrlPMVTeamView
 *
 @author    Bin Yuan
 @created   2014-03-11
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-09-18 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 * 2015-01-21 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified by bin yuan  2015-01-21 due to SPIN Selling Story#: D-441 to exclude lost and dead opportunities from the team view display
 */
public class ClsPMVTeamViewUtil {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static map<String, CustomSettingObj> map_oppyStageKey_customSetting4Projected = new map<String, CustomSettingObj>();
    public static map<String, CustomSettingObj> map_oppyStageKey_customSetting4Size = new map<String, CustomSettingObj>();
    
    public static map<String, Decimal> map_isoCode_exchangeRate; 
    public static map<String, Decimal> map_convertionRate = new Map<String, Decimal>();
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
   
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to generate date range list
    *
    @author Bin Yuan
    @created 2014-03-13
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void generateDateRange(list<DateRangeType> list_dateRangeType) {

        DateRangeType customYear = new DateRangeType();
        customYear.typeName = 'Custom';
        customYear.list_dateRange = new list<DateRange>();
        customYear.list_dateRange.add(new DateRange('Custom', 'Custom'));
        customYear.list_dateRange.add(new DateRange('All Time', 'AllTime'));
        list_dateRangeType.add(customYear);

        DateRangeType fiscalYear = new DateRangeType();
        fiscalYear.typeName = 'Fiscal Year';
        fiscalYear.list_dateRange = new list<DateRange>();
        fiscalYear.list_dateRange.add(new DateRange('THIS FISCAL YEAR', 'THIS_FISCAL_YEAR'));
        fiscalYear.list_dateRange.add(new DateRange('LAST FISCAL YEAR', 'LAST_FISCAL_YEAR'));
        fiscalYear.list_dateRange.add(new DateRange('NEXT FISCAL YEAR', 'NEXT_FISCAL_YEAR'));
        list_dateRangeType.add(fiscalYear);

        DateRangeType fiscalQuarter = new DateRangeType();
        fiscalQuarter.typeName = 'Fiscal Quarter';
        fiscalQuarter.list_dateRange = new list<DateRange>();
        fiscalQuarter.list_dateRange.add(new DateRange('THIS FISCAL QUARTER', 'THIS_FISCAL_QUARTER'));
        fiscalQuarter.list_dateRange.add(new DateRange('LAST FISCAL QUARTER', 'LAST_FISCAL_QUARTER'));
        fiscalQuarter.list_dateRange.add(new DateRange('NEXT FISCAL QUARTER', 'NEXT_FISCAL_QUARTER'));
        fiscalQuarter.list_dateRange.add(new DateRange('NEXT 4 FISCAL QUARTER', 'Next_N_Fiscal_Quarters:4'));
        list_dateRangeType.add(fiscalQuarter);

        DateRangeType calendarDay = new DateRangeType();
        calendarDay.typeName = 'Calendar Days';
        calendarDay.list_dateRange = new list<DateRange>();

        calendarDay.list_dateRange.add(new DateRange('LAST 90 DAYS', 'LAST_90_DAYS'));
        calendarDay.list_dateRange.add(new DateRange('NEXT 90 DAYS', 'NEXT_90_DAYS'));
        list_dateRangeType.add(calendarDay);

        DateRangeType calendarWeek = new DateRangeType();
        calendarWeek.typeName = 'Calendar Week';
        calendarWeek.list_dateRange = new list<DateRange>();
        calendarWeek.list_dateRange.add(new DateRange('LAST WEEK', 'LAST_WEEK'));
        calendarWeek.list_dateRange.add(new DateRange('THIS WEEK', 'THIS_WEEK'));
        calendarWeek.list_dateRange.add(new DateRange('NEXT WEEK', 'NEXT_WEEK'));
        list_dateRangeType.add(calendarWeek);

        DateRangeType calendarMonth = new DateRangeType();
        calendarMonth.typeName = 'Calendar Month';
        calendarMonth.list_dateRange = new list<DateRange>();
        calendarMonth.list_dateRange.add(new DateRange('LAST MONTH', 'LAST_MONTH'));
        calendarMonth.list_dateRange.add(new DateRange('THIS MONTH', 'THIS_MONTH'));
        calendarMonth.list_dateRange.add(new DateRange('NEXT MONTH', 'NEXT_MONTH'));
        list_dateRangeType.add(calendarMonth);


        DateRangeType calendarQuarter = new DateRangeType();
        calendarQuarter.typeName = 'Calendar Quarter';
        calendarQuarter.list_dateRange = new list<DateRange>();
        calendarQuarter.list_dateRange.add(new DateRange('THIS QUARTER', 'THIS_QUARTER'));
        calendarQuarter.list_dateRange.add(new DateRange('LAST QUARTER', 'LAST_QUARTER'));
        calendarQuarter.list_dateRange.add(new DateRange('NEXT QUARTER', 'NEXT_QUARTER'));
        list_dateRangeType.add(calendarQuarter);

        DateRangeType calendarYear = new DateRangeType();
        calendarYear.typeName = 'Calendar Year';
        calendarYear.list_dateRange = new list<DateRange>();
        calendarYear.list_dateRange.add(new DateRange('THIS YEAR', 'THIS_YEAR'));
        calendarYear.list_dateRange.add(new DateRange('LAST YEAR', 'LAST_YEAR'));
        calendarYear.list_dateRange.add(new DateRange('NEXT YEAR', 'NEXT_YEAR'));
        list_dateRangeType.add(calendarYear);

        
    }
   /**
    * This method is used to query string
    *
    @author Bin Yuan
    @created 2014-03-13
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getForecastRecords(set<String> set_membIds, CtrlPMVTeamView.DatePicker dateInfo) {
        try {
            list<AggregateResult> list_forecastResult = new list<AggregateResult>();
            if(set_membIds.isEmpty()) {
                return json.serialize(list_forecastResult);
            }
            set<String> set_rts = new set<String>();
            for(Id rtId : ClsPMV_Util.getAllPMVRecordtypes()) {
                set_rts.add(String.valueOf(rtId));
            }
            if((dateInfo.oppick == 'Custom' || dateInfo.oppick == null) && dateInfo.opstart == null && dateInfo.opend == null) {
                dateInfo.oppick = 'AllTime';
            }
            if((dateInfo.fcpick == 'Custom' || dateInfo.fcpick == null) && dateInfo.fcstart == null && dateInfo.fcend == null) {
                dateInfo.fcpick = 'Next_N_Fiscal_Quarters:4';
            }
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'dateInfo :: ' + dateInfo));

            String str_query = ' Select sum(Amount__c) Amount, Opportunity__r.OwnerId Owner, Opportunity__r.RecordType.BusinessProcessId salesProcessId, Opportunity__r.StageName Stage '
                             + ' From Opportunity_Forecast__c ';
            String str_where = ' Where ';
            String str_filter = ' Opportunity__r.OwnerId IN ( OWNERTEMP ) And Opportunity__r.RecordTypeId IN ( RTTEMP )';
            String str_idFilter = generateStringForSet(set_membIds);
            String str_oppyRTFilter = generateStringForSet(set_rts);
            String str_groupby = ' Group by Opportunity__r.OwnerId, Opportunity__r.RecordType.BusinessProcessId, Opportunity__r.StageName ';
            str_filter = str_filter.replace('OWNERTEMP', str_idFilter);
            if(str_oppyRTFilter == '' || str_oppyRTFilter == null){
            	str_oppyRTFilter = '\'\'';
            }
            str_filter = str_filter.replace('RTTEMP', str_oppyRTFilter);
            
            str_filter += multitpleEntries('Opportunity__r.GAM_Code__c', dateInfo.gamcode);
            str_filter += multitpleEntries('Opportunity__r.KAM_Code__c', dateInfo.kamcode);
            str_filter += multitpleEntries('Opportunity__r.AM_Code__c', dateInfo.amcode);

            str_filter += ((dateInfo.oppick != 'Custom' && dateInfo.oppick != 'AllTime') ? ' And Opportunity__r.Projected_Close_Date__c = ' + dateInfo.oppick : '');
            str_filter += (dateInfo.opstart != null ? ' And Opportunity__r.Projected_Close_Date__c >= ' + dateInfo.opstart : '');
            str_filter += (dateInfo.opend != null ? ' And Opportunity__r.Projected_Close_Date__c <= ' + dateInfo.opend : '');

            str_filter += ((dateInfo.fcpick != 'Custom' && dateInfo.fcpick != 'AllTime') ? ' And Date__c = ' + dateInfo.fcpick : '');
            str_filter += (dateInfo.fcstart != null ? ' And Date__c >= ' + dateInfo.fcstart : '');
            str_filter += (dateInfo.fcend != null ? ' And Date__c <= ' + dateInfo.fcend : '');
            str_filter += ' And RecordType.DeveloperName = \'Part\' and Opportunity__r.PMV_Type__c != null ';
            str_filter += ' And Part__r.Status__c != \'Lost\' And Part__r.Status__c != \'Dead\' ';
            str_filter += ' And Opportunity__r.StageName != \'Lost\' And Opportunity__r.StageName != \'Dead\' ';
            str_query += (str_where + str_filter + str_groupby);
            str_query = str_query.replaceAll('00:00:00', '');
            system.debug('**@@str_query = ' + str_query);
            for(AggregateResult result : database.query(str_query)) {
                list_forecastResult.add(result);
            }
            return json.serialize(list_forecastResult);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_queryKey_query :: ' + map_queryKey_query));
        }
        catch(Exception ex) {
            throw ex;
        }
    }
    
   /**
    * This method is used to query string
    *
    @author Bin Yuan
    @created 2014-03-13
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static String getForecastMixRecords(set<String> set_membIds, CtrlPMVTeamView.DatePicker dateInfo) {
        try {
            list<AggregateResult> list_forecastMixResult = new list<AggregateResult>();
            if(set_membIds.isEmpty()) {
                return json.serialize(list_forecastMixResult);
            }
            set<String> set_rts = new set<String>();
            for(Id rtId : ClsPMV_Util.getAllPMVRecordtypes()) {
                set_rts.add(String.valueOf(rtId)); 
            }
            if((dateInfo.oppick == 'Custom' || dateInfo.oppick == null) && dateInfo.opstart == null && dateInfo.opend == null) {
                dateInfo.oppick = 'AllTime';
            }
            if((dateInfo.fcpick == 'Custom' || dateInfo.fcpick == null) && dateInfo.fcstart == null && dateInfo.fcend == null) {
                dateInfo.fcpick = 'Next_N_Fiscal_Quarters:4';
            }
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'dateInfo :: ' + dateInfo));

            String str_mixQuery = ' Select sum(Amount__c) Amount, Opportunity__r.OwnerId Owner From Opportunity_Forecast__c ';
            String str_where = ' Where ';
            String str_filter = ' Opportunity__r.OwnerId IN ( OWNERTEMP ) And Opportunity__r.RecordTypeId IN ( RTTEMP )';
            String str_idFilter = generateStringForSet(set_membIds);
            String str_oppyRTFilter = generateStringForSet(set_rts);
            String str_mixGroupby = ' Group by Opportunity__c, Opportunity__r.OwnerId ';
            str_filter = str_filter.replace('OWNERTEMP', str_idFilter);
            if(str_oppyRTFilter == '' || str_oppyRTFilter == null){
            	str_oppyRTFilter = '\'\'';
            }
            str_filter = str_filter.replace('RTTEMP', str_oppyRTFilter);
            
            str_filter += multitpleEntries('Opportunity__r.GAM_Code__c', dateInfo.gamcode);
            str_filter += multitpleEntries('Opportunity__r.KAM_Code__c', dateInfo.kamcode);
            str_filter += multitpleEntries('Opportunity__r.AM_Code__c', dateInfo.amcode);

            str_filter += ((dateInfo.oppick != 'Custom' && dateInfo.oppick != 'AllTime') ? ' And Opportunity__r.Projected_Close_Date__c = ' + dateInfo.oppick : '');
            str_filter += (dateInfo.opstart != null ? ' And Opportunity__r.Projected_Close_Date__c >= ' + dateInfo.opstart : '');
            str_filter += (dateInfo.opend != null ? ' And Opportunity__r.Projected_Close_Date__c <= ' + dateInfo.opend : '');

            str_filter += ((dateInfo.fcpick != 'Custom' && dateInfo.fcpick != 'AllTime') ? ' And Date__c = ' + dateInfo.fcpick : '');
            str_filter += (dateInfo.fcstart != null ? ' And Date__c >= ' + dateInfo.fcstart : '');
            str_filter += (dateInfo.fcend != null ? ' And Date__c <= ' + dateInfo.fcend : '');
            str_filter += ' And RecordType.DeveloperName = \'Part\' and Opportunity__r.PMV_Type__c != null ';
            str_filter += ' And Part__r.Status__c != \'Lost\' And Part__r.Status__c != \'Dead\' ';
            str_filter += ' And Opportunity__r.StageName != \'Lost\' And Opportunity__r.StageName != \'Dead\' ';

            str_mixQuery += (str_where + str_filter + str_mixGroupby);
            str_mixQuery = str_mixQuery.replaceAll('00:00:00', '');
            
            for(AggregateResult result : database.query(str_mixQuery)) {
                list_forecastMixResult.add(result);
            }
            return json.serialize(list_forecastMixResult);
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_queryKey_query :: ' + map_queryKey_query));
        }
        catch(Exception ex) {
            throw ex;
        }
    }
    
   /**
    * This method is used to get opportunitys for selected member
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static string getOppysForMemb(set<String> set_membIds, CtrlPMVTeamView.DatePicker dateInfo) {

        try {
            list<Opportunity> list_oppysResult = new list<Opportunity>();
            if(set_membIds.isEmpty()) {
                return json.serialize(list_oppysResult);
            }
            set<String> set_rts = new set<String>();
            for(Id rtId : ClsPMV_Util.getAllPMVRecordtypes()) {
                set_rts.add(String.valueOf(rtId)); 
            }
            
            if((dateInfo.oppick == 'Custom' || dateInfo.oppick == null) && dateInfo.opstart == null && dateInfo.opend == null) {
             	dateInfo.oppick = 'AllTime';
            }
            map<Id, String> map_businessProcessId_name = new map<Id, String>();
            list<Opportunity> list_oppys = new list<Opportunity>();         
            
            String str_query = ' Select Id, StageName, RecordType.BusinessProcessId, '
	    					 + 'Amount, Five_Year_Revenue__c, Summary_Ability__c, Summary_Attractiveness__c '
                             + ' From Opportunity ';

	    	String str_where = ' Where ';
            String str_filter = ' OwnerId IN ( OWNERTEMP ) ';
            String str_idFilter = generateStringForSet(set_membIds);
            str_filter = str_filter.replace('OWNERTEMP', str_idFilter);

			str_filter += multitpleEntries('GAM_Code__c', dateInfo.gamcode);
            str_filter += multitpleEntries('KAM_Code__c', dateInfo.kamcode);
            str_filter += multitpleEntries('AM_Code__c', dateInfo.amcode);
            
            str_filter += ((dateInfo.oppick != 'Custom' && dateInfo.oppick != 'AllTime') ? ' And Projected_Close_Date__c = ' + dateInfo.oppick : '');
            str_filter += (dateInfo.opstart != null ? ' And Projected_Close_Date__c >= ' + dateInfo.opstart : '');
            str_filter += (dateInfo.opend != null ? ' And Projected_Close_Date__c <= ' + dateInfo.opend : '');

            str_filter += ' And RecordTypeId in : set_rts and PMV_Type__c != null ';
            //added by bin yuan  2015-01-21 due to SPIN Selling Story#: D-441 to exclude lost and dead opportunities from the team view display
			str_filter += ' And StageName != \'Lost\' And StageName != \'Dead\' ';
			//End
            str_filter += ' order by id asc ';
	    	str_query += (str_where + str_filter );
	    	str_query = str_query.replaceAll('00:00:00', '');
            for(Opportunity oppy : database.query(str_query)) {
                list_oppysResult.add(oppy);
            }
            return json.serialize(list_oppysResult);
        }
        catch(Exception ex) {
            throw ex;
        }

    }

   /**
    * This method is used to generate oppy view objects
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void generateOppyViewObjs(list<Opportunity> list_oppys, list<CtrlPMVTeamView.OppyViewObj> list_oppysForMemb, CtrlPMVTeamView.DatePicker dateInfo) {
        try {
            if(map_oppyStageKey_customSetting4Projected.isEmpty() || map_oppyStageKey_customSetting4Size.isEmpty()) {
                getSizeAndProjectedSetting();
            }
            
            set<string> set_oppyids = new set<string>();
            
            for(Opportunity oppy : list_oppys) {
            	set_oppyids.add(oppy.Id);
            }
            if(set_oppyids.isEmpty()) {
            	return;
            }
            set<String> set_rts = new set<String>();
            for(Id rtId : ClsPMV_Util.getAllPMVRecordtypes()) {
                set_rts.add(String.valueOf(rtId));
            }
            if((dateInfo.oppick == 'Custom' || dateInfo.oppick == null) && dateInfo.opstart == null && dateInfo.opend == null) {
                dateInfo.oppick = 'AllTime';
            }
            if((dateInfo.fcpick == 'Custom' || dateInfo.fcpick == null) && dateInfo.fcstart == null && dateInfo.fcend == null) {
                dateInfo.fcpick = 'Next_N_Fiscal_Quarters:4';
            }
            
            map<Id, decimal> map_oppyId_amount = new map<id, decimal>();
            
            String str_mixQuery = ' Select sum(Amount__c) Amount, Opportunity__c Opportunity From Opportunity_Forecast__c ';
            String str_where = ' Where ';
            String str_filter = ' Opportunity__c IN (' + generateStringForSet(set_oppyids) + ')';
            String str_oppyRTFilter = generateStringForSet(set_rts);
            String str_mixGroupby = ' Group by Opportunity__c ';

            str_filter += ((dateInfo.oppick != 'Custom' && dateInfo.oppick != 'AllTime') ? ' And Opportunity__r.Projected_Close_Date__c = ' + dateInfo.oppick : '');
            str_filter += (dateInfo.opstart != null ? ' And Opportunity__r.Projected_Close_Date__c >= ' + dateInfo.opstart : '');
            str_filter += (dateInfo.opend != null ? ' And Opportunity__r.Projected_Close_Date__c <= ' + dateInfo.opend : '');

            str_filter += ((dateInfo.fcpick != 'Custom' && dateInfo.fcpick != 'AllTime') ? ' And Date__c = ' + dateInfo.fcpick : '');
            str_filter += (dateInfo.fcstart != null ? ' And Date__c >= ' + dateInfo.fcstart : '');
            str_filter += (dateInfo.fcend != null ? ' And Date__c <= ' + dateInfo.fcend : '');
            str_filter += ' And RecordType.DeveloperName = \'Part\' and Opportunity__r.PMV_Type__c != null ';
            str_filter += ' And Part__r.Status__c != \'Lost\' And Part__r.Status__c != \'Dead\' ';
            str_filter += ' And Opportunity__r.StageName != \'Lost\' And Opportunity__r.StageName != \'Dead\' ';

            str_mixQuery += (str_where + str_filter + str_mixGroupby);
            str_mixQuery = str_mixQuery.replaceAll('00:00:00', '');
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'str_mixQuery :: ' + str_mixQuery));
            for(AggregateResult result : database.query(str_mixQuery)) {
            	map_oppyId_amount.put((Id)result.get('Opportunity'), (decimal)result.get('Amount'));
            }
            for(Opportunity oppy : list_oppys) {
                CtrlPMVTeamView.OppyViewObj obj = new CtrlPMVTeamView.OppyViewObj();
                obj.id = oppy.Id;
                obj.acctid = oppy.Account.Id;
                obj.acctname = oppy.Account.Name;
                obj.process = oppy.Sales_Processes_Name__c;
                obj.oppyname = oppy.Name;
                obj.stage = oppy.StageName;
                obj.progress = ((oppy.All_Stage_Color__c == '' || oppy.All_Stage_Color__c == null) ? 'cls_progress_empty' : oppy.All_Stage_Color__c);
                obj.enddate = oppy.Projected_Close_Date__c;
                obj.precntage = (oppy.Overall_Process__c == null ? '0' : oppy.Overall_Process__c + '');
                obj.amount = transformIsoCode(oppy.Five_Year_Revenue__c, oppy.CurrencyIsoCode, 'USD');
                obj.totalAmount = (!map_oppyId_amount.containsKey(oppy.id)) ? null : map_oppyId_amount.get(oppy.id);
                obj.health = (oppy.Overall_Health_Status__c == 'good' ? 'cls_health_3' : (oppy.Overall_Health_Status__c == 'medium' ? 'cls_health_2' : 'cls_health_1'));
                obj.healthComt = oppy.Overall_Health_Comment__c;
                obj.SumAtt = oppy.Summary_Attractiveness__c;
                obj.SumAbility = oppy.Summary_Ability__c;
                getSize(oppy, obj);
                getProjected(oppy, obj);
                list_oppysForMemb.add(obj);
            }
        }
        catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getStackTraceString()));
        }
        
    }

   /**
    * This method is used to get opportunitys for selected member
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getStageMapping(map<String, String> map_stage_teamViewColumn) {

        for(PMV_Sales_Stage_Setting__c setting : PMV_Sales_Stage_Setting__c.getAll().values()) {
            if(setting.Team_View_Column__c != null && setting.Team_View_Column__c != null) {
                if(!map_stage_teamViewColumn.containsKey(setting.Team_View_Column__c)) {
                    map_stage_teamViewColumn.put(setting.Team_View_Column__c, setting.Sales_Process_ID__c + ';' + setting.Sales_Stage__c);
                }
                else {
                    String stageName = map_stage_teamViewColumn.get(setting.Team_View_Column__c);
                    stageName = setting.Sales_Process_ID__c + ',' + stageName + ',' + setting.Sales_Stage__c;
                    map_stage_teamViewColumn.put(setting.Team_View_Column__c, stageName);
                }
            }
        }
        //system.debug('map_stage_teamViewColumn :: ' + map_stage_teamViewColumn);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_stage_teamViewColumn :: ' + map_stage_teamViewColumn));
    }

   /**
    * This method is used to get big opportunity amount & avg amount from custom setting
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getBigOppyAmountFromCustomsetting(CtrlPMVTeamView.PageConfig pageConf) {

        map<String, BigOppyAmountObj> map_roleId_bigOppyAmountObj = new map<String, BigOppyAmountObj>();
        map<String, set<String>> map_parentRoldId_setSubRoles = new map<String, set<String>>();
        for(PMV_Team_View__c setting : PMV_Team_View__c.getAll().values()) {
            if(setting.User_Role_Id__c != null && setting.AvgAmountOpportunityRelationship__c != null && setting.BigOpportunityAmountThreshold__c != null && setting.BigOpportunityCountThreshold__c != null) {
                BigOppyAmountObj obj = new BigOppyAmountObj();
                obj.userRoleId = setting.User_Role_Id__c.subString(0, 15);
                obj.avgAmount = setting.AvgAmountOpportunityRelationship__c;
                obj.bigOppyAmountThreshold = setting.BigOpportunityAmountThreshold__c / 100;
                obj.bigOppyCountThreshold = setting.BigOpportunityCountThreshold__c / 100;

                map_roleId_bigOppyAmountObj.put(obj.userRoleId, obj);
                map_parentRoldId_setSubRoles.put(obj.userRoleId, new set<String>());
                //get all sub roles
                set<String> set_subRoles = map_parentRoldId_setSubRoles.get(obj.userRoleId);
                set_subRoles = getAllSubRoleIds(new set<String> {obj.userRoleId});
                if(!set_subRoles.isEmpty()) {
                    for(String subRoleId : set_subRoles) {
                        if(subRoleId != obj.userRoleId) {
                            map_roleId_bigOppyAmountObj.put(subRoleId, obj);
                        }
                    }
                }
                
            }
        }





        pageConf.bigOppyDataJson = Json.serialize(map_roleId_bigOppyAmountObj);
        //system.debug('map_stage_teamViewColumn :: ' + map_stage_teamViewColumn);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_stage_teamViewColumn :: ' + map_stage_teamViewColumn));
    }
   /**
    * This method is used to get size and projected data from custom setting
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getSizeAndProjectedSetting() {
        if(map_oppyStageKey_customSetting4Projected == null) {
            map_oppyStageKey_customSetting4Projected = new map<String, CustomSettingObj>();
        }
        if(map_oppyStageKey_customSetting4Size == null) {
            map_oppyStageKey_customSetting4Size = new map<String, CustomSettingObj>();
        }
        for(PMV_Sales_Process_Settings__c setting : PMV_Sales_Process_Settings__c.getAll().values()) {
            String keyName = setting.Sales_Process_ID__c + setting.PMV_Type__c;
            if(setting.Deal_Size_Max__c != null && setting.Deal_Size_Min__c != null) {
                CustomSettingObj obj = new CustomSettingObj();
                obj.dealSizeMax = (double) setting.Deal_Size_Max__c;
                obj.dealSizeMin = (double) setting.Deal_Size_Min__c;
                map_oppyStageKey_customSetting4Size.put(keyName, obj);
            }

            if(setting.ProjectedToClose_Threshold__c != null) {
                CustomSettingObj obj = new CustomSettingObj();
                obj.projToCloseThreshold = setting.ProjectedToClose_Threshold__c;
                map_oppyStageKey_customSetting4Projected.put(keyName, obj);
            }
        }
        for(PMV_Sales_Stage_Setting__c setting : PMV_Sales_Stage_Setting__c.getAll().values()) {
            String keyName = setting.Sales_Process_ID__c + setting.PMV_Type__c;
            if((setting.Production_Stage__c || setting.Won_Stage__c || setting.On_Hold_Stage__c) && setting.Sales_Stage__c != null) {
                keyName = (keyName + setting.Sales_Stage__c);
                CustomSettingObj obj = new CustomSettingObj();
                obj.isProduction = setting.Production_Stage__c;
                obj.isWon = setting.Won_Stage__c;
                obj.isOnHold = setting.On_Hold_Stage__c;
                obj.stageName = setting.Sales_Stage__c;
                map_oppyStageKey_customSetting4Projected.put(keyName, obj);
            }
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_oppyStageKey_customSetting4Projected :: ' + map_oppyStageKey_customSetting4Projected));
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'map_oppyStageKey_customSetting4Size :: ' + map_oppyStageKey_customSetting4Size));
    }



   /**
    * This method is used to generate oppy view objects
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getSize(Opportunity oppy, CtrlPMVTeamView.OppyViewObj oppyForMemb) {
        String keyName = oppy.RecordType.BusinessProcessId + oppy.PMV_Type__c;
        if(map_oppyStageKey_customSetting4Size.containsKey(keyName)) {
            CustomSettingObj obj = map_oppyStageKey_customSetting4Size.get(keyName);
            if(oppyForMemb.originalAmount > obj.dealSizeMax) {
                oppyForMemb.size = 'cls_size_3';
            }
            else if(oppyForMemb.originalAmount <= obj.dealSizeMin) {
                oppyForMemb.size = 'cls_size_1';
            }
            else {
                oppyForMemb.size = 'cls_size_2';
            }
        }
        else {
            oppyForMemb.size = 'cls_size_empty';
        }
    }

   /**
    * This method is used to generate oppy view objects
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static void getProjected(Opportunity oppy, CtrlPMVTeamView.OppyViewObj oppyForMemb) {
        String keyName = oppy.RecordType.BusinessProcessId + oppy.PMV_Type__c;
        String keyNameWithStage = keyName + oppy.StageName;
        if(map_oppyStageKey_customSetting4Projected.containsKey(keyNameWithStage)) {
            CustomSettingObj obj = map_oppyStageKey_customSetting4Projected.get(keyNameWithStage);
            if(obj.isWon) {
                oppyForMemb.projected = 'cls_won';
            }
            else if(obj.isProduction) {
                oppyForMemb.projected = 'cls_production';
            }
            else if(obj.isOnHold) {
                oppyForMemb.projected = 'cls_onhold';
            }
        }
        else if(map_oppyStageKey_customSetting4Projected.containskey(keyName)) {
            CustomSettingObj obj = map_oppyStageKey_customSetting4Projected.get(keyName);
            if(oppy.Overall_Process__c >= obj.projToCloseThreshold) {
                oppyForMemb.projected = 'cls_project_2';
            }
            else {
                oppyForMemb.projected = 'cls_project_1';
            }
        }
        else {
            oppyForMemb.projected = 'cls_project_empty';
        }
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
   /**
    * This method is used to generate filter string for query
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    private static String generateStringForSet(set<String> set_str) {
        String sub_string = '';
        for(String parm : set_str) {
            sub_string += ' \'' + parm + '\', ';
        }
        if(sub_string != '') {
            sub_string = sub_string.removeEnd(', ');
        }
        return sub_string;
    }
    
    /**
    * This method is used to multitple entries for query
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    
    public static String multitpleEntries(string fieldName, string str_temp) {
    	string str_return = '';
    	if(str_temp != null && str_temp.trim() != '') {
    		str_return += ' AND (';
    		for(string str : str_temp.split(',')) {
    			str_return += fieldName + ' like \'%' + str.trim() + '%\' or ';
    		}
    	}
    	if(str_return != '') {
			str_return = str_return.removeEnd('or ');
			str_return +=')';
		}
		return str_return;
    }
    
    /**
    * This method is used to transform currency for different currency iso code while save forecast for non-USD currency
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static Decimal transformIsoCode(Decimal sourceValue, String fromIsoCode, String toIsoCode){
        Decimal result = 0;
    	if(sourceValue == null){	//check source value
    		return result;
    	}

        String k = fromIsoCode + toIsoCode;
        if(map_convertionRate.containsKey(k)){	//check convertion reate contains
            //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'from :: ' + fromIsoCode +' :: ' + sourceValue + ' :: TO :: ' + toIsoCode + ' :: ' + sourceValue * map_convertionRate.get(k)));
            return sourceValue * map_convertionRate.get(k);
        }
       
        Decimal fromRate = 1; 
        Decimal toRate = 1; 
        getExchangeRate();
        if(map_isoCode_exchangeRate.get(fromIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(fromIsoCode)) != '') fromRate =  map_isoCode_exchangeRate.get(fromIsoCode);
        else fromRate = 1;
        if(map_isoCode_exchangeRate.get(toIsoCode) != null && String.ValueOf(map_isoCode_exchangeRate.get(toIsoCode)) != '') toRate =  map_isoCode_exchangeRate.get(toIsoCode);
        else toRate = 1;
        
        result = sourceValue * ( toRate / fromRate );
        map_convertionRate.put(k, toRate / fromRate);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO, 'from :: ' + fromIsoCode +' :: ' + sourceValue + ' :: TO :: ' + toIsoCode + ' :: ' + result));
        return result;
    }

   /**
    * This method is used to build currency iso map 
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    private static void getExchangeRate(){
        if(map_isoCode_exchangeRate == null){
            map_isoCode_exchangeRate = new map<String, Decimal>();
            for(CurrencyType ct : [SELECT  IsActive, IsCorporate, CreatedById, CreatedDate, 
            					   			IsoCode, Id, DecimalPlaces, LastModifiedById, LastModifiedDate, 
            					   			SystemModstamp, ConversionRate  
            					   from CurrencyType]){
                map_isoCode_exchangeRate.put(ct.IsoCode, ct.ConversionRate);
            }
        }
    }
    
   /**
    * This method is used to generate filter string for query
    *
    @author Bin Yuan
    @created 2014-02-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-02-11 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    private static Set<String> getAllSubRoleIds(Set<String> roleIds) {

        set<String> currentRoleIds = new set<String>();
        //get all of the roles underneath the passed roles
        for(UserRole userRole :[select Id
                                from UserRole
                                where ParentRoleId IN :roleIds AND ParentRoleID != null]) {
            currentRoleIds.add(userRole.Id);
        }
        // go fetch some more rolls
        if(currentRoleIds.size() > 0) {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class DateRangeType {
        public String typeName {get; set;}
        public list<DateRange> list_dateRange {get; set;}
    }
    public class DateRange {
        public String rangeLabel {get; set;}
        public String rangeValue {get; set;}

        public DateRange(String label, String value) {
            this.rangeLabel = label;
            this.rangeValue = value;
        }
    }
    public class CustomSettingObj {
        public double dealSizeMax {get; set;}
        public double dealSizeMin {get; set;}
        public double projToCloseThreshold {get; set;}
        public boolean isWon {get; set;}
        public boolean isProduction {get; set;}
        public boolean isOnHold {get; set;}
        public String stageName {get; set;}

        public CustomSettingObj() {
            this.dealSizeMin = 0;
            this.dealSizeMax = 0;
            this.projToCloseThreshold = 0;
            this.isWon = false;
            this.isProduction = false;
            this.isOnHold = false;
            this.stageName = '';
        }
    }
    public class BigOppyAmountObj {
        public String userRoleId {get; set;}
        public double avgAmount {get; set;}
        public double bigOppyAmountThreshold {get; set;}
        public double bigOppyCountThreshold {get; set;}

        public BigOppyAmountObj() {
            this.userRoleId = '';
            this.avgAmount = 0;
            this.bigOppyAmountThreshold = 0;
            this.bigOppyCountThreshold = 0;
        }
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    //********************************* -=END public methods=- ************************************
    
    //********************************* -=BEGIN private methods=- *********************************
}