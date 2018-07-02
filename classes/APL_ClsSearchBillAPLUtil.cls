/**
 * Controller class for page APL_ClsSearchBillAPLUtil
 *
 @author    Chen Chen
 @created   2015-01-29
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-03-30 Chen Chen <Shawn.liu.china@itbconsult.com>
 * - Created
 */
 
 
public class APL_ClsSearchBillAPLUtil {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public static Set<String> set_oppyIdsForFilter = new Set<String>();
	public static String queryBill;//
	public static String queryFore;//
	public static String queryOppy;// 
	public static String queryOppyPart;//
	public static String queryOppyPartner;
	public static Set<String> set_oppyPartIds = new Set<String>();//to save oppyPartIds
	public static list<APL_CtrlSearchForecastBilling.paramlFilter> list_paramlFilter{get; set;}//to save the data of filter to be always
	public static list<Opportunity> list_oppy = new list<Opportunity>();//to save data about oppy
	public static list<Opportunity_Forecast__c> list_forecast = new list<Opportunity_Forecast__c>();//to save data about oppyPart
	public static list<Opportunity_Part__c> list_oppPart = new list<Opportunity_Part__c>();//to save data about oppyPart
	public static list<AggregateResult> list_bill = new list<AggregateResult>();//to save data about oppyPartner
	public static list<response> list_transmitRes = new list<response>();//to transmiting response
	public static map<String,APL_Billing__c> customSettingValue = APL_Billing__c.getAll();
	public static APL_Billing__c customSetting_Oppy = customSettingValue.get('Oppy');
	public static APL_Billing__c customSetting_OppyPart = customSettingValue.get('OppyPart');
	public static APL_Billing__c customSetting_OppyPartner = customSettingValue.get('OppyPartner');
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	//
	public APL_ClsSearchBillAPLUtil() {
		
		
		 set_oppyIdsForFilter = getOppyId();
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
	
	//get Id of Opportunity IN isaplOpp__c is true and stageName has Won
	public static set<String> getOppyId(){
		//added by Lei Tang 2016-05-20 add filte Won_Fiscal_Year__c, Status__c ,Process_Status__c
		String fiscalYear = String.valueOf(getFiscalYear());
		String fiscalbefYear = String.valueOf(getFiscalYear()-1);
		set<String> set_oppyIds = new set<String>();
		for(Opportunity_Part__c op : [select Opportunity__c from Opportunity_Part__c 
										where (Won_Fiscal_Year__c =:fiscalYear or Won_Fiscal_Year__c =:fiscalbefYear) 
											and Status__c = 'Won' and Process_Status__c = 'Production' 
											and Opportunity__r.isAPLOpp__c = true and Opportunity__r.StageName like : '%Won%' ]) {
			if(!set_oppyIds.contains(op.Opportunity__c)) {
				set_oppyIds.add(op.Opportunity__c);
			}
		}

		return set_oppyIds;
	}
	
	// to get data for filter
	public String getMultipleType() {
		map<String,String> map_oppyNumber = new map<String,String>();
		map<String,String> map_oppyRegion = new map<String,String>();
		map<String,String> map_oppyEngineer = new map<String,String>();
		
		for(Opportunity oppy : [select Opportunity_Number__c,Customer_Region__c,Field_Engineer_Name__c FROM Opportunity Where Id IN :set_oppyIdsForFilter]){
			if (oppy.Opportunity_Number__c != null) {
				map_oppyNumber.put(oppy.Opportunity_Number__c, oppy.Opportunity_Number__c);
			}
			 if (oppy.Customer_Region__c != null) {
				map_oppyRegion.put(oppy.Customer_Region__c, oppy.Customer_Region__c);
			}
			if (oppy.Field_Engineer_Name__c != null) {
				map_oppyEngineer.put(oppy.Field_Engineer_Name__c, oppy.Field_Engineer_Name__c);
			}
		}

		WrapFiltersSub wrapFiltersSub = new WrapFiltersSub();
		wrapFiltersSub.account_Manager = getAccountManager();
		//wrapFiltersSub.field_Engineer = getOppyListData('FieldEngineer');
		wrapFiltersSub.field_Engineer = map_oppyEngineer;
		wrapFiltersSub.opportunity_Owner = getOppyMapData();
		//wrapFiltersSub.opportunity_Number = getOppyListData('OpportunityNumber');
		wrapFiltersSub.opportunity_Number = map_oppyNumber;
		//wrapFiltersSub.customer_Region = getOppyListData('CustomerRegion');
		wrapFiltersSub.customer_Region = map_oppyRegion;
		return JSON.serialize(wrapFiltersSub);
	}
	//getMultipleType about Account Manager
	public map<String,String> getAccountManager(){
		list<String> list_acctOwner = new list<String>();
		map<String,String> map_accountOwner = new map<String,String>();
		Set<String> set_acctId = new Set<String>();
		for(Opportunity oppy : [select accountId From Opportunity Where Id IN : set_oppyIdsForFilter]) {
			set_acctId.add(oppy.accountId);
		}
		for(Account acct : [select Account_Manager__c,Account_Manager_Name__c,ownerId FROM Account Where Id IN : set_acctId]){
			if (acct.Account_Manager_Name__c != null)
			map_accountOwner.put(acct.Account_Manager__c,acct.Account_Manager_Name__c);
		}
		return map_accountOwner;
	}
	///getMultipleType about Opportunity Owner
	public map<String,String> getOppyMapData(){
		list<String> set_oppyData = new list<String>();
		map<String,String> map_oppyData = new map<String,String>();
		for(Opportunity oppy : [select ownerId FROM Opportunity Where Id IN : set_oppyIdsForFilter]){
			set_oppyData.add(oppy.ownerId);
		}
		for(User users : [select id,name from user where Id IN : set_oppyData]){
			if(users.Id != null)
			map_oppyData.put(users.Id,users.Name);
		}
		return map_oppyData;
	}
	
	////////////////////////to get oppyid which is need/////////////////////////////////
	//to find OppyId which is eligible and return set_oppyIds
	public static set<String> findSet_oppyId(list<APL_CtrlSearchForecastBilling.paramlFilter> list_searchQuery) {
		Set<String> set_oppIds = new Set<String>();//to Init and return
		boolean paraValue = false;//to make sure If I enter the iterator
		list_paramlFilter = list_searchQuery;//save the data from filter
		queryOppy = 'Select Id From Opportunity';
		set_oppIds = APL_ClsSearchBillAPLUtil.getOppyId();//get oppyIds which isAPLOpp__c = true and StageName like '%Won%'
		//set_oppIds = set_oppyIdsForFilter;
		//if it have limit about oppy,get a query about it
		for(APL_CtrlSearchForecastBilling.paramlFilter para : list_paramlFilter) {
			if(para.objectName == 'Opportunity') {
				if(!String.isEmpty(para.queryString)) {
					queryOppy = queryOppy + ' Where Id IN: set_oppIds And ' + para.queryString;
					paraValue = true;
				}
			}
		}
		system.debug('queryOppy:chen' + queryOppy);
		//system.debug('dataqueryOppy:chen' + Database.query(queryOppy));
		//get oppyId accroding to filter else return oppyIds which isAPLOpp__c = true and StageName like '%Won%'
		if(paraValue == true) {
			Set<String> set_transmitOppyId  = new Set<String>();
			for(Opportunity oppy : Database.query(queryOppy)){
				set_transmitOppyId.add(oppy.Id);      //save oppyId we need
			}
			set_oppIds = set_transmitOppyId;
		}
		system.debug('chen::oppy set_oppIds.size()' + set_oppIds.size());
		return set_oppIds;
	}
	//to find OppyId IN oppyPart which is eligible and return set_oppyIds
	public static set<String> findOppyIdInOppPart(Set<String> set_oppyIds, list<APL_CtrlSearchForecastBilling.paramlFilter> list_searchQuery){
		system.debug('Chen::StartINfindOppyIdInOppPart' + set_oppyIds);
		boolean paraValue = false;//to make sure If I enter the iterator
		queryOppyPart = 'Select Opportunity__c From Opportunity_Part__c Where Opportunity__c IN: set_oppyIds And ';
		list_paramlFilter = list_searchQuery;//save the data from filter
		//if it have limit about oppyPart,get a query about it
		for(APL_CtrlSearchForecastBilling.paramlFilter para : list_paramlFilter) {
			if(para.objectName == 'Opportunity_Part__c'){
			   // updata  is Mingxing 	Qiu  time  2016/4/27
				if(para.queryString != NULL && para.queryString != '') {
					queryOppyPart =  queryOppyPart  + para.queryString;
					paraValue = true;
				} 
				//updata to 2016/7/5 by Mingxing Qiu because of delete custom data 
				/*if(para.valueMap != null && !(para.valueMap.isEmpty())) {
					queryOppyPart = queryOppyPart + getParsingTime(paraValue, para.valueMap);
					para.queryString += getParsingTime(paraValue, para.valueMap);
					system.debug('qmx_para.queryString ::'+para.queryString);
					paraValue = true;	
				}*/

			}
		}
		system.debug('chen::queryOppyPart' + queryOppyPart);
		//system.debug('chen::dataqueryOppyPart' + Database.query(queryOppyPart));
		//get oppyId accroding to filter else return oppyIds which i get
		if(paraValue == true) {
			Set<String> set_transmitOppyId  = new Set<String>();
			for(Opportunity_Part__c oppyPart : Database.query(queryOppyPart)){
				set_transmitOppyId.add(oppyPart.opportunity__c);
			}
			set_oppyIds = set_transmitOppyId;
		}
		system.debug('chen::retrun_set_oppyIds' + set_oppyIds);
		return set_oppyIds;
	}
	//updata to 2016/7/5 by Mingxing Qiu because of delete custom data
	//get the limit of time
	/*public static String getParsingTime(Boolean isQueryString, map<String,String> map_api_time) {
		//Integer i = 0;
		String queryTime;
		if(isQueryString == true) { //true means has other limit before time limit and false means no
			queryTime = ' AND ';
		}else {
			queryTime = '';
		}
		for(String apiName  : map_api_time.keySet()) {
			list<String> list_timeFromTo = map_api_time.get(apiName).split(';');
			String startDate = splitDate(list_timeFromTo[1]);
			String endtDate = splitDate(list_timeFromTo[2]);
			if(list_timeFromTo[0] == 'Custom Date') {
				//if(i == 0) {//first in and not add and 
					queryTime += ' (' + apiName + ' >=' + startDate + ' And ' + apiName + ' <= ' + endtDate + ')';
					//queryTime = queryTime + query;
					//i = i + 1;
				//}else if(i == 1) {//after first in and add and
				//	String query = ' AND (' + apiName + ' >= ' +startDate + ' And ' + apiName + ' <= ' + startDate + ')';
				//	queryTime = queryTime + query;
				//}
			}
		}
		return queryTime;
	}
	//  Format custom string to time layout
	public static String splitDate(String str) {
		String str_ruturn;
		list <String> list_strData = str.split('/');
		list_strData[1] = list_strData[1].length() == 1 ? '0'+list_strData[1] : list_strData[1];
		list_strData[0] = list_strData[0].length() == 1 ? '0'+list_strData[0] : list_strData[0];
		str_ruturn = list_strData[2]+'-'+list_strData[0]+'-'+list_strData[1];
		return str_ruturn;
	}*/
	
	// get Direct Billing Month
	/*public static integer getDirBillMonth() {
		//calculate Forecast Achieve Ratio
		Load_Status__c load_status = [Select Current_Fiscal_Month__c From Load_Status__c Where Data_Source_Description__c = 'Bookings/Billings direct PN detail monthly' limit 1]; 
		if(load_status != null) {
			return Integer.valueOf(load_status.Current_Fiscal_Month__c);
		}else {
			return 0;
		}

	}
	
	// get  POS/CMA Billing Month
	public static integer getPosBillMonth() {
		//calculate Forecast Achieve Ratio
		Load_Status__c load_status = [Select Current_Fiscal_Month__c From Load_Status__c Where Data_Source_Description__c = 'Bookings/Billings POS/CMA PN detail Monthly' limit 1]; 
		if(load_status != null) {
			return Integer.valueOf(load_status.Current_Fiscal_Month__c);
		}else {
			return 0;
		}

	}*/
	// get  POS/CMA Billing Month and Direct Billing Month
	public static String getDirBillPosBill() {
		//calculate Forecast Achieve Ratio
		String str_dirMonth = '0';
		String str_posMonth = '0';
		Boolean isDirMonth = true;
		Boolean isPosMonth = true;
		for(Load_Status__c load_status : [Select Current_Fiscal_Month__c,Data_Source_Description__c From Load_Status__c Where Data_Source_Description__c IN ('Bookings/Billings direct PN detail monthly', 'Bookings/Billings POS/CMA PN detail Monthly')]) { 
			if(load_status.Data_Source_Description__c == 'Bookings/Billings direct PN detail monthly' && isDirMonth) {
				str_dirMonth = String.valueOf(load_status.Current_Fiscal_Month__c);
				isDirMonth = false;
			}
			if(load_status.Data_Source_Description__c == 'Bookings/Billings POS/CMA PN detail Monthly' && isPosMonth) {
				str_posMonth = String.valueOf(load_status.Current_Fiscal_Month__c);
				isPosMonth = false;
			}
			
		}
		return str_dirMonth+','+str_posMonth;
	}
	
	//format data  round data
	public static String formatData(decimal deci_data) {
		Long long_data = deci_data.round(System.RoundingMode.HALF_UP);
		//String str_data = long_data.format();
		return String.valueOf(long_data);
	}
	
	//get A one thousand - bit separator
	public static String getThouSymbol() {
		Decimal value = 1000;
        String formattedValue = value.format();
        String thousandSep = formattedValue.substring(1,2);
   		return thousandSep;
	}
	
	//to find OppyId whichi is eligible and return set_oppyIds
	public static set<String> findOppyIdInOppPartner(Set<String> set_oppyIds){
		system.debug('Chen::StartINfindOppyIdInOppPartner' + set_oppyIds);
		//Set<String> set_oppIds = new Set<String>();//to return
		boolean paraValue = false;//to make sure If I enter the iterator
		queryOppyPartner = 'Select Opportunity__c From Opportunity_Partner__c';
		//if it have limit about oppy,get a query about it
		for(APL_CtrlSearchForecastBilling.paramlFilter para : list_paramlFilter) {
			if(para.objectName == 'Opportunity_Partner__c'){
				if(!String.isEmpty(para.queryString)){
					queryOppyPartner = queryOppyPartner + ' Where '+ ' Opportunity__c IN: set_oppyIds AND ' + para.queryString ;
					paraValue = true;
				}
			}
		}
		system.debug('queryqueryOppyPartner:chen' + queryOppyPartner);
		//system.debug('dataqueryOppyPartner:chen' + Database.query(queryOppyPartner));
		//get oppyId accroding to filter else return oppyIds which i get
		if(paraValue == true) {
			Set<String> set_transmitOppyId  = new Set<String>();
			for(Opportunity_Partner__c oppyPartner : Database.query(queryOppyPartner)){
				set_transmitOppyId.add(oppyPartner.opportunity__c);
			}
			set_oppyIds = set_transmitOppyId;
		}
		system.debug('chen::Partner::set_oppyIds::' + set_oppyIds);
		return set_oppyIds;
	}
	//to find OppyId whichi is eligible and return set_oppyIds
	public static set<String> findOppyIdInBill(Set<String> set_oppyIds){
		system.debug('chenchen::findOppyIdInBill::' + set_oppyIds);
		boolean paraValue = false;//to make sure If I enter the iterator
		queryBill = 'Select Opportunity__c From APL_Billing_Result_of_Covnerted_Opp__c';
		//if it have limit about oppy,get a query about it
		for(APL_CtrlSearchForecastBilling.paramlFilter para : list_paramlFilter) {
			if(para.objectName == 'APL_Billing_Result_of_Covnerted_Opp__c'){
				if(!String.isEmpty(para.queryString)){
					queryBill = queryBill + ' Where '+ ' Opportunity__c IN: set_oppyIds AND ' + para.queryString ;
					paraValue = true;
				}
			}
		}
		system.debug('queryBill:chen' + queryBill);
		//system.debug('dataqueryBill:chen' + Database.query(queryBill));
		//get oppyId accroding to filter else return oppyIds which i get
		if(paraValue == true) {
			Set<String> set_transmitOppyId  = new Set<String>();
			for(APL_Billing_Result_of_Covnerted_Opp__c apl : Database.query(queryBill)){
				set_transmitOppyId.add(apl.opportunity__c);
			}
			set_oppyIds = set_transmitOppyId;
		}
		system.debug('chen:::set_oppyIds' + set_oppyIds);
		return set_oppyIds;
	}
	//to get oppy data
	public static list<response> getOppy(set<String> set_oppIds){
	
		list<response> list_responseOppy = new list<response>();
		list<Opportunity> list_oppys = new list<Opportunity>();
		list<String> list_object_filed = new list<String>();
		//get all oppy accroding to filter
		list_oppys = database.query('Select Id, AccountId, ' + customSetting_Oppy.Column_API_Names__c
									+' From Opportunity Where Id IN: set_oppIds order by Id');
		system.debug('chenchen::list_oppys::' + list_oppys);
		for(Opportunity oppy : list_oppys) {
			response res = new response();
			res.oppyId = oppy.Id;//It is used to sure the record is which Opportunity
			//system.debug('acctId ::' + oppy.AccountId);
			//res.acctId = oppy.AccountId;
			//iterator oppyId to put api name and  corresponding values
			for(String apiName : customSetting_Oppy.Column_API_Names__c.split(',')) {//Account_Combined_Data__c
				res.map_record.put('acctId',oppy.AccountId);
				list_object_filed = apiName.split('\\.');//if list.size() == 2,it is Across the field
				
				if(list_object_filed.size() == 1) {//the apiName is Opportunity
					//to sure the data is null to set it ''
					if(String.valueOf(oppy.get(apiName)) == null) {
						res.map_record.put(apiName, '-');
					}else {	
						res.map_record.put(apiName, String.valueOf(oppy.get(apiName)));
					}
				}
				if(list_object_filed.size() == 2){
					sObject acct = (sObject)oppy.getSObject(list_object_filed[0]);
					//to sure the data is null to set it ''
					if(acct == null || (acct.get(list_object_filed[1])) == null) {
						res.map_record.put(apiName, '-');
					}else {
						res.map_record.put(apiName, String.valueOf(acct.get(list_object_filed[1])));
					}
				}
			}
			list_responseOppy.add(res);
		}
		system.debug('qmx::list_responseOppy::' + list_responseOppy);
		return list_responseOppy;
	}
	
	//to get Forecast data according to oppyIds
	public static list<response> getFore(list<APL_CtrlSearchForecastBilling.paramlFilter> list_paramlFilte, set<String> set_oppIds, Integer fiscalYear, boolean befYear, boolean fisYear, boolean nextYear){  
		system.debug('start to getFore' + set_oppIds);
        list<response> list_responseOppyFore = new list<response>();
        list<AggregateResult> list_oppForeCast = new list<AggregateResult>();
        list<AggregateResult> list_oppOppyPart = new list<AggregateResult>();
        String str_queryPart;
        //get all oppyFore accroding to filter
        system.debug('chen::fiscalYear::' + fiscalYear);
        queryFore = 'Select sum(Amount__c) Amount__c,Opportunity__c, Fiscal_Year__c, Fiscal_Quarter__c '
                    + 'From Opportunity_Forecast__c where Opportunity__c In: set_oppIds  And part__r.Status__c =  \'Won\' and part__r.Process_Status__c = \'Production\' And Part__c != null And '
                    + '(Fiscal_Year__c >= \'' +  (fiscalYear-1) + '\' AND Fiscal_Year__c <= \'' + (fiscalYear + 1)
                    + ' \') And part__c in ';  
        queryOppyPart = 'Select sum(Initial_12_months__c) Initial_12_months__c, Opportunity__c '
                        + ' From Opportunity_Part__c where Opportunity__c In: set_oppIds '
                        + ' And Status__c =  \'Won\' and Process_Status__c = \'Production\' ';            

        str_queryPart ='(Select Id From Opportunity_Part__c Where Status__c =  \'Won\' And Process_Status__c = \'Production\' ';     

        for(APL_CtrlSearchForecastBilling.paramlFilter para : list_paramlFilte) {
            if(para.objectName == 'Opportunity_Part__c'){
                if(!String.isEmpty(para.queryString)){
                    str_queryPart = str_queryPart +' And '+ para.queryString ;
                    queryOppyPart += ' And ' + para.queryString ;        
                }
            }
        }
        str_queryPart +=')';
        queryFore += str_queryPart + ' Group By Opportunity__c, Fiscal_Year__c, Fiscal_Quarter__c '    ; //
        queryOppyPart += ' Group By Opportunity__c';
        system.debug('chen::queryOppyPart::' + queryOppyPart);
        system.debug('chen::queryFore::' + queryFore);

        list_oppForeCast = database.query(queryFore);
        list_oppOppyPart = database.query(queryOppyPart);

        system.debug('chenchen::list_oppForeCast::' + list_oppForeCast);

        system.debug('chenchen::list_oppOppyPart::' + list_oppOppyPart);
        //to get data from Opportunity_Part__c for forecast
        for(AggregateResult oppPart : list_oppOppyPart) {
            response res = new response();
            res.oppyId = String.valueOf(oppPart.get('Opportunity__c'));//It is used to sure the record is which Opportunity
            //to sure the data is null to set it ''
            if(oppPart.get('Initial_12_months__c') == null) {
                res.map_record.put(String.valueOf('Initial_12_months__c'), '-');
            }else {
                res.map_record.put(String.valueOf('Initial_12_months__c'), formatData((decimal)(oppPart.get('Initial_12_months__c'))));
            }
            list_responseOppyFore.add(res);
        }
        //to get data from Opportunity_Forecasr
        for(String apiName : set_oppIds) { 
            nextYear = false;
            befYear = false;
            fisYear = false;
            response res = new response();
            res.oppyId = apiName;//It is used to sure the record is which Opportunity 
            for(AggregateResult oppFore : list_oppForeCast) {


                //to sure the record is one Opportunity 
                if (apiName == String.valueOf(oppFore.get('Opportunity__c'))){
                    //iterator oppyId to put api name and  corresponding values
                    if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear + 1)) {
                        if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
                            if(!res.map_record.containsKey(String.valueOf('FY' + (fiscalYear + 1)))) {
                                nextYear = true;
                                res.map_record.put(String.valueOf('FY' + (fiscalYear + 1)), formatData((decimal)oppFore.get('Amount__c')));
                            }else {
                                decimal quantity = (decimal)(oppFore.get('Amount__c'));
                                quantity += decimal.valueOf(res.map_record.get(String.valueOf('FY' + (fiscalYear + 1))));
                                res.map_record.put(String.valueOf('FY' + (fiscalYear + 1)), formatData(Quantity));
                            }
                        }
                    }
                    if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear - 1)) {
                        if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
                            if(!res.map_record.containsKey(String.valueOf('FY' + (fiscalYear - 1)))) {
                                befYear = true;
                                res.map_record.put(String.valueOf('FY' + (fiscalYear - 1)), formatData((decimal)oppFore.get('Amount__c')));
                            }else {
                                decimal quantity = (decimal)(oppFore.get('Amount__c'));
                                quantity += decimal.valueOf(res.map_record.get(String.valueOf('FY' + (fiscalYear - 1))));
                                res.map_record.put(String.valueOf('FY' + (fiscalYear - 1)), formatData(Quantity));
                            }
                        }
                    }
                    if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear)) {
                        if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
                            if(!res.map_record.containsKey(String.valueOf('FY' + fiscalYear))) {
                                fisYear = true;    
                                res.map_record.put(String.valueOf('FY' + fiscalYear), formatData((decimal)oppFore.get('Amount__c')));
                            }else {
                                decimal quantity = (decimal)(oppFore.get('Amount__c'));
                                quantity += decimal.valueOf(res.map_record.get(String.valueOf('FY' + (fiscalYear))));
                                res.map_record.put(String.valueOf('FY' + fiscalYear), formatData(Quantity));
                            }
                        }
                    }
                    if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear) && 
                                      String.valueOf(oppFore.get('Fiscal_Quarter__c')) == '01') {
                        //to sure the data is null to set it ''
                        if(oppFore.get('Amount__c') == null) {
                            res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q1'), '-');
                        }else {
                            res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q1'), formatData((decimal)oppFore.get('Amount__c')));
                        }
                    }
                    if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear) && 
                                      String.valueOf(oppFore.get('Fiscal_Quarter__c')) == '02') {
                        //to sure the data is null to set it ''
                        if(oppFore.get('Amount__c') == null) {
                            res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q2'), '-');
                        }else {
                            res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q2'), formatData((decimal)oppFore.get('Amount__c')));
                        }
                    }
                    if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear) && 
                                      String.valueOf(oppFore.get('Fiscal_Quarter__c')) == '03') {
                        //to sure the data is null to set it ''
                        if(oppFore.get('Amount__c') == null) {
                            res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q3'), '-');
                        }else {
                            res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q3'), formatData((decimal)oppFore.get('Amount__c')));
                        }
                    }
                    if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear) && 
                                      String.valueOf(oppFore.get('Fiscal_Quarter__c')) == '04') {
                        //to sure the data is null to set it ''
                        if(oppFore.get('Amount__c') == null) {
                            res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q4'), '-');
                        }else {
                            res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q4'), formatData((decimal)oppFore.get('Amount__c')));
                        }
                    }
                }
            }
            if(nextYear == false) {
                res.map_record.put(String.valueOf('FY' + (fiscalYear + 1)), '-');
            }
            if(befYear == false) {
                res.map_record.put(String.valueOf('FY' + (fiscalYear - 1)), '-');
            }
            if(fisYear == false) {
                res.map_record.put(String.valueOf('FY' + fiscalYear), '-');
            }        
            list_responseOppyFore.add(res);
        }
        system.debug('chenchen::list_responseOppyFore::' + list_responseOppyFore);
        return list_responseOppyFore;
    }

	
	//to sure the year is IN which fiscal year
	public static Integer getFiscalYear(){
		Integer year;
		for(Period per : [SELECT EndDate FROM Period
						 Where StartDate = THIS_FISCAL_YEAR and Type = 'Year']){
			year = per.EndDate.Year();
		}
		system.debug('chen::year' + year);
		return year;
	}
	
	//to get Billing data
	public static list<response> getBill(set<String> set_oppIds, map<String, String> map_billFileds){
		list<response> list_responseBill = new list<response>();
		set<String> set_partIds = new set<String>();
		//map<String,AggregateResult> map_oppyId_list_bill = new map<String,AggregateResult>();
		map<String,aplBill> map_oppyId_aplbill = new map<String,aplBill>();
        map<string,set<string>> map_oppyId_partIds = new map<String,set<String>>();
		queryBill ='Select sum(Bill_Prior_Year_1_Amount_Document__c)Bill_Prior_Year_1_Amount_Document__c, ';
		queryBill +='sum(Bill_Prior_Year_1_to_Date_Amount_Do__c)Bill_Prior_Year_1_to_Date_Amount_Do__c, ';
		queryBill +='sum(Bill_Prior_Year_Amount_USD__c)Bill_Prior_Year_Amount_USD__c, ';
		queryBill +='sum(Bill_Prior_Year_to_Date_Amount_USD__c)Bill_Prior_Year_to_Date_Amount_USD__c, ';
		queryBill +='sum(Bill_Year_to_Date_Amount_USD__c)Bill_Year_to_Date_Amount_USD__c, ';
		queryBill +='sum(Book_Prior_Year_Amount_USD__c)Book_Prior_Year_Amount_USD__c, ';
		queryBill +='sum(Book_Prior_Year_To_Date_Amount_USD__c)Book_Prior_Year_To_Date_Amount_USD__c, ';
		queryBill +='sum(Book_Year_to_Date_Amount_USD__c)Book_Year_to_Date_Amount_USD__c, ';
		queryBill +='Opportunity__c,part__c From APL_Billing_Result_of_Covnerted_Opp__c ';
		queryBill +='Where Opportunity__c IN: set_oppIds And part__c In: set_partIds ';
		
		//query Oppy part string
		String queryOppyPartString = 'Select Id,Part__c,opportunity__c ' 
									  +' From Opportunity_Part__c Where opportunity__c In: set_oppIds  And Status__c =  \'Won\' and Process_Status__c = \'Production\' ';
		
		//get filter from page 
		for(APL_CtrlSearchForecastBilling.paramlFilter para : list_paramlFilter) {
			if(para.objectName == 'APL_Billing_Result_of_Covnerted_Opp__c'){
				if(!String.isEmpty(para.queryString)){
					queryBill = queryBill + ' And ' + para.queryString ;
				}
			}
			if(para.objectName == 'Opportunity_Part__c'){
				if(!String.isEmpty(para.queryString)){
					queryOppyPartString = queryOppyPartString + ' And ' + para.queryString ;
				}
			}
		}
		queryBill += ' group by Opportunity__c, part__c '; 

        system.debug('qmx_queryoppypart:'+queryOppyPartString);
		for(Opportunity_Part__c oppyPart : database.query(queryOppyPartString)){
            set_partIds.add(oppyPart.part__c);
            if(!map_oppyId_partIds.containsKey(oppyPart.opportunity__c)){
                map_oppyId_partIds.put(oppyPart.opportunity__c,new set<String>());
            }
            map_oppyId_partIds.get(oppyPart.opportunity__c).add(oppyPart.part__c);
		}
		
		list_bill = database.query(queryBill);
		system.debug('chen::queryBill::' + queryBill);
		system.debug('qmx::queryOppyPartString::' + queryOppyPartString);
		//iterator list_bills put in map with apiName and corresponding data
		for(AggregateResult Bill : list_bill) {
			String oppyId = String.valueOf(Bill.get('opportunity__c'));
			String partId = String.valueOf(Bill.get('part__c'));
			decimal Bill_Prior_Year_1_Amount_Document = (Decimal)(Bill.get('Bill_Prior_Year_1_Amount_Document__c'));
			decimal Bill_Prior_Year_1_to_Date_Amount_Do = (Decimal)(Bill.get('Bill_Prior_Year_1_to_Date_Amount_Do__c'));
			decimal Bill_Prior_Year_Amount_USD = (Decimal)(Bill.get('Bill_Prior_Year_Amount_USD__c'));
			decimal Bill_Prior_Year_to_Date_Amount_USD = (Decimal)(Bill.get('Bill_Prior_Year_to_Date_Amount_USD__c'));
			decimal Bill_Year_to_Date_Amount_USD = (Decimal)(Bill.get('Bill_Year_to_Date_Amount_USD__c'));
			decimal Book_Prior_Year_Amount_USD = (Decimal)(Bill.get('Book_Prior_Year_Amount_USD__c'));
			decimal Book_Prior_Year_To_Date_Amount_USD = (Decimal)(Bill.get('Book_Prior_Year_To_Date_Amount_USD__c'));
			decimal Book_Year_to_Date_Amount_USD = (Decimal)(Bill.get('Book_Year_to_Date_Amount_USD__c'));
			if(map_oppyId_partIds.get(oppyId).contains(partId)){
				if(!map_oppyId_aplbill.containsKey(oppyId)) {
                    //system.debug('qmx_oppyId::'+oppyId);
					map_oppyId_aplbill.put(oppyId,new aplBill());
					map_oppyId_aplbill.get(oppyId).Bill_Prior_Year_1_Amount_Document = Bill_Prior_Year_1_Amount_Document == null ? 0 : Bill_Prior_Year_1_Amount_Document;
					map_oppyId_aplbill.get(oppyId).Bill_Prior_Year_1_to_Date_Amount_Do = Bill_Prior_Year_1_to_Date_Amount_Do == null ? 0 : Bill_Prior_Year_1_to_Date_Amount_Do;
					map_oppyId_aplbill.get(oppyId).Bill_Prior_Year_Amount_USD = Bill_Prior_Year_Amount_USD == null ? 0 : Bill_Prior_Year_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Bill_Prior_Year_to_Date_Amount_USD = Bill_Prior_Year_to_Date_Amount_USD == null ? 0 : Bill_Prior_Year_to_Date_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Bill_Year_to_Date_Amount_USD = Bill_Year_to_Date_Amount_USD == null ? 0 : Bill_Year_to_Date_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Book_Prior_Year_Amount_USD = Book_Prior_Year_Amount_USD == null ? 0 : Book_Prior_Year_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Book_Prior_Year_To_Date_Amount_USD = Book_Prior_Year_To_Date_Amount_USD == null ? 0 : Book_Prior_Year_To_Date_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Book_Year_to_Date_Amount_USD = Book_Year_to_Date_Amount_USD == null ? 0 : Book_Year_to_Date_Amount_USD;
				
				}else{
                    //system.debug('qmx_oppyId2::'+oppyId);
					map_oppyId_aplbill.get(oppyId).Bill_Prior_Year_1_Amount_Document += Bill_Prior_Year_1_Amount_Document == null ? 0 : Bill_Prior_Year_1_Amount_Document;
					map_oppyId_aplbill.get(oppyId).Bill_Prior_Year_1_to_Date_Amount_Do += Bill_Prior_Year_1_to_Date_Amount_Do == null ? 0 : Bill_Prior_Year_1_to_Date_Amount_Do;
					map_oppyId_aplbill.get(oppyId).Bill_Prior_Year_Amount_USD += Bill_Prior_Year_Amount_USD == null ? 0 : Bill_Prior_Year_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Bill_Prior_Year_to_Date_Amount_USD += Bill_Prior_Year_to_Date_Amount_USD == null ? 0 : Bill_Prior_Year_to_Date_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Bill_Year_to_Date_Amount_USD += Bill_Year_to_Date_Amount_USD == null ? 0 : Bill_Year_to_Date_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Book_Prior_Year_Amount_USD+= Book_Prior_Year_Amount_USD == null ? 0 : Book_Prior_Year_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Book_Prior_Year_To_Date_Amount_USD += Book_Prior_Year_To_Date_Amount_USD  == null ? 0 : Book_Prior_Year_To_Date_Amount_USD;
					map_oppyId_aplbill.get(oppyId).Book_Year_to_Date_Amount_USD += Book_Year_to_Date_Amount_USD == null ? 0 : Book_Year_to_Date_Amount_USD;
				}
			}	
			system.debug('qmx_map_oppyId_aplbill::'+map_oppyId_aplbill);
		}
		for(String oppyId : set_oppIds){
			response res = new response();
		    res.oppyId = oppyId;
			if(map_oppyId_aplbill.containsKey(oppyId)) {  // if have record 
			  aplbill aplBill ;
			  aplBill = map_oppyId_aplbill.get(oppyId);
		      double BillDiff;
		      double BookDiff;
		      //change to map<apiName, value>
		      for(String apiName : map_billFileds.keySet()) { 
		      	system.debug('have data apiName :'+ apiName);
		        if(apiName != 'Booking_Diff_Vs_Pre_FY' && apiName != 'Billing_Diff_Vs_Pre_FY' && apiName !='Bill_Forecast_Achieve_Ratio'){
		          //to sure the data is null to set it ''
		          if(aplBill.getVal(apiName) == 0) {	            
		            res.map_record.put(apiName, '-');		           
		          }else {
		            res.map_record.put(apiName, formatData(aplBill.getVal(apiName)));
		          }
		        }else {
		          //when one of them all of them is null,to get a difference between them
		          if(aplBill.Book_Year_to_Date_Amount_USD == 0 && 
		             aplBill.Book_Prior_Year_To_Date_Amount_USD == 0) {
		            res.map_record.put('Booking_Diff_Vs_Pre_FY', '-');
		          } else if(aplBill.Book_Year_to_Date_Amount_USD != 0 && 
		             aplBill.Book_Prior_Year_To_Date_Amount_USD == 0) {
		              res.map_record.put('Booking_Diff_Vs_Pre_FY', formatData((decimal)aplBill.Book_Year_to_Date_Amount_USD));
		          }else if(aplBill.Book_Year_to_Date_Amount_USD == 0 && 
		              aplBill.Book_Prior_Year_To_Date_Amount_USD != 0) {
		            BookDiff = 0 - double.valueOf(aplBill.Book_Prior_Year_To_Date_Amount_USD);
		            res.map_record.put('Booking_Diff_Vs_Pre_FY', formatData(decimal.valueOf(bookDiff)));
		          }else {
		            bookDiff = double.valueOf(aplBill.Book_Year_to_Date_Amount_USD) - double.valueOf(aplBill.Book_Prior_Year_To_Date_Amount_USD);
		            
		            res.map_record.put('Booking_Diff_Vs_Pre_FY', formatData(decimal.valueOf(bookDiff)));
		          }
		          if(aplBill.Bill_Year_to_Date_Amount_USD == 0 && 
		             aplBill.Bill_Prior_Year_To_Date_Amount_USD == 0) {
		            res.map_record.put('Billing_Diff_Vs_Pre_FY', '-');
		          } else if(aplBill.Bill_Year_to_Date_Amount_USD != 0 && 
		             aplBill.Bill_Prior_Year_To_Date_Amount_USD == 0) {
		              res.map_record.put('Billing_Diff_Vs_Pre_FY', formatData((decimal)aplBill.Bill_Year_to_Date_Amount_USD));
		          }else if(aplBill.Bill_Year_to_Date_Amount_USD == 0 && 
		              aplBill.Bill_Prior_Year_To_Date_Amount_USD != 0) {
		            BillDiff = 0 - aplBill.Bill_Prior_Year_To_Date_Amount_USD;
		            res.map_record.put('Billing_Diff_Vs_Pre_FY',formatData(decimal.valueOf(BillDiff)));
		          }else {
		            BillDiff = double.valueOf(aplBill.Bill_Year_to_Date_Amount_USD) - double.valueOf(aplBill.Bill_Prior_Year_To_Date_Amount_USD);
		            res.map_record.put('Billing_Diff_Vs_Pre_FY', formatData(decimal.valueOf(BillDiff)));
		          }         
		        }
		      }
		      
	
			}else{   // if no record   APL_Billing_Result_of_Covnerted_Opp__c   
				for(String apiName : map_billFileds.keySet()) {
					system.debug('no data apiName::' + apiName);
					res.map_record.put(apiName, '-');
				}
			}
			list_responseBill.add(res);	
		}
		system.debug('chen::list_responseBill::' + list_responseBill);
		return list_responseBill;
	}
	//mergeMap make the data map_record belong to a oppyId
	public static list<response> mergeMap(set<String> set_oppyIds, list<response> list_responseGet){
		system.debug('chenchen::list_responseGet::' + list_responseGet);
		list<response> list_response2transmit = new list<response>();
		for(String apiName : set_oppyIds){
			response res = new response();
			res.oppyId = apiName;
			for(response respo : list_responseGet){
				if(respo.oppyId == apiName){
					res.map_record.putAll(respo.map_record);
					//res.acctId = respo.acctId;
				}
			}
			list_response2transmit.add(res);
		}
		system.debug('chenchen::list_response2transmit::' + list_response2transmit);
		return list_response2transmit;
	}
	
	//calculate oppy Forecast achieve Ratio (Kevin Shen)
	public static list<response> calForecastAchieveRatio(Integer fiscalYear,Integer current_fiscal_month,list<response> list_response){
		list<response> list_response2transmit = new list<response>();
		system.debug('current_month::'+current_fiscal_month);	
		for(response res : list_response) {
			decimal billing_diff_vs_pre = String.ValueOf(res.map_record.get('Billing_Diff_Vs_Pre_FY'))=='-'?0:decimal.ValueOf(res.map_record.get('Billing_Diff_Vs_Pre_FY'));
			decimal fiscal_forcast=0;
			if(current_fiscal_month != 0){
				
				decimal fiscal_Q1 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q1'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q1')));
				decimal fiscal_Q2 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q2'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q2')));
				decimal fiscal_Q3 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q3'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q3')));
				decimal fiscal_Q4 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q4'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q4')));
			
				if(current_fiscal_month>=1 && current_fiscal_month <=3){
					fiscal_forcast = (fiscal_Q1*current_fiscal_month/3).setscale(2); 
				}
				if(current_fiscal_month>=4 && current_fiscal_month <= 6){
					fiscal_forcast = fiscal_Q1 + (fiscal_Q2*(current_fiscal_month-3)/3).setscale(2);
				}
				if(current_fiscal_month>=7 && current_fiscal_month <= 9){
					fiscal_forcast = fiscal_Q1 + fiscal_Q2 + (fiscal_Q3*(current_fiscal_month-6)/3).setscale(2);
				}
				if(current_fiscal_month>=10 && current_fiscal_month <= 12){
					fiscal_forcast = fiscal_Q1 + fiscal_Q2 + fiscal_Q3 + (fiscal_Q4*(current_fiscal_month-9)/3).setscale(2);
				}		
		}		
		if(fiscal_forcast == 0){
			res.map_record.put('Bill_Forecast_Achieve_Ratio', 'N/A');
		}else{
			decimal forcast_achieve_ration = ((billing_diff_vs_pre/fiscal_forcast)*100).setscale(1);
			res.map_record.put('Bill_Forecast_Achieve_Ratio',String.valueOf(forcast_achieve_ration)+'%');
		}
		
		system.debug('fiscal_forcast::'+fiscal_forcast+'billing_diff_vs_pre::'+billing_diff_vs_pre);
		list_response2transmit.add(res);
		
		}
		
	return list_response2transmit;

}	
	
	
	//to get oppyPart data
	public static list<response> getOppyPart(String oppId){ 
		list<String> list_object_filed = new list<String>();
		list<response> list_responseOppyPart = new list<response>();
		list<Opportunity_Part__c> list_oppyPart = new list<Opportunity_Part__c>();
		set_oppyPartIds = new set<String>();
		//get all oppyPart accroding to oppId
		list_oppyPart = database.query('Select Id, opportunity__c, opportunity__r.Name,opportunity__r.Opportunity_Number__c, ' + customSetting_OppyPart.Column_API_Names__c
									  +' From Opportunity_Part__c Where opportunity__c =: oppId order by Id');
									  
		for(Opportunity_Part__c oppyPart : list_oppyPart) {
			response res = new response();
			res.objectName = 'Opportunity_Part__c';//It is used to sure the record is which Opportunity
			res.objectId = oppyPart.id;
			res.oppyId = oppyPart.opportunity__c;
			res.oppyName = oppyPart.opportunity__r.Name;
			res.oppyNumber = oppyPart.opportunity__r.Opportunity_Number__c;
			set_oppyPartIds.add(oppyPart.Id);
			//iterator oppyId to put api name and  corresponding values
			for(String apiName : customSetting_OppyPart.Column_API_Names__c.split(',')) {
				list_object_filed = apiName.split('\\.');//to sure the apiName whether across the fields
				if(list_object_filed.size() == 1) {//if the object is Opportunity Part
					//to sure the data is null to set it ''
					if(OppyPart.get(apiName) == null) {
						res.map_record.put(apiName, '');
					}else {	
						res.map_record.put(apiName, String.valueOf(OppyPart.get(apiName)));
					}
				}
				if(list_object_filed.size() == 2){//if the object is not Opportunity Part
					sObject sob = (sObject)oppyPart.getSObject(list_object_filed[0]);
					//to sure the data is null to set it ''
					if(sob.get(list_object_filed[1]) == null) {
						res.map_record.put(apiName, '');
					}else {	
						res.map_record.put(apiName, String.valueOf(sob.get(list_object_filed[1])));
					}
				}
			}
		
			
			list_responseOppyPart.add(res);
		}
		system.debug('chenchen::list_responseOppyPart::' + list_responseOppyPart);
		return list_responseOppyPart;
	}
		

	
	//to get oppyPart data and Oppy Forecase and Billing (kevin shen)
	public static list<response> getOppyPartFcBilling(list<APL_CtrlSearchForecastBilling.paramlFilter> list_searchQuery,set<String> set_oppIds,Integer fiscalYear,Integer current_fiscal_month){
		
		
		list<Opportunity_Part__c> list_oppyPart = new list<Opportunity_Part__c>();
		list<String> list_object_filed = new list<String>();
		list<response> list_responseOppyPart = new list<response>();
		map<String,decimal> map_oppyPartId_intial = new map<String,decimal>();
		
		//set for oppypart Ids
		set<String> set_oppypartsIds = new set<String>();
		//set for part ids
		set<String> set_part_Ids = new set<String>();
		//set for billing key 
		set<String> set_billingKey=new set<String>{
			'Book_Year_to_Date_Amount_USD__c',
			'Book_Prior_Year_To_Date_Amount_USD__c',
			'Book_Prior_Year_Amount_USD__c',
			'Bill_Year_to_Date_Amount_USD__c',
			'Bill_Prior_Year_to_Date_Amount_USD__c',
			'Bill_Prior_Year_Amount_USD__c',
			'Bill_Prior_Year_1_to_Date_Amount_Do__c',
			'Bill_Prior_Year_1_Amount_Document__c'
		};
		
		//query billing string 
		String queryBilling='SELECT Part__c,Opportunity__c,Sum(Bill_Prior_Year_1_Amount_Document__c) Bill_Prior_Year_1_Amount_Document__c,Sum(Bill_Prior_Year_1_to_Date_Amount_Do__c) Bill_Prior_Year_1_to_Date_Amount_Do__c,'
		+'Sum(Bill_Prior_Year_Amount_USD__c) Bill_Prior_Year_Amount_USD__c,Sum(Bill_Prior_Year_to_Date_Amount_USD__c) Bill_Prior_Year_to_Date_Amount_USD__c,Sum(Bill_Year_to_Date_Amount_USD__c) Bill_Year_to_Date_Amount_USD__c,Sum(Book_Prior_Year_Amount_USD__c) Book_Prior_Year_Amount_USD__c,'
		+'Sum(Book_Prior_Year_To_Date_Amount_USD__c) Book_Prior_Year_To_Date_Amount_USD__c,Sum(Book_Year_to_Date_Amount_USD__c) Book_Year_to_Date_Amount_USD__c FROM APL_Billing_Result_of_Covnerted_Opp__c Where Part__c In: set_part_Ids And Opportunity__c In: set_oppIds ';
		
		//query Oppy part string
		String queryOppyPartString = 'Select Id, opportunity__c, opportunity__r.Name,opportunity__r.Opportunity_Number__c, Initial_12_months__c, Part__c,' + customSetting_OppyPart.Column_API_Names__c
									  +' From Opportunity_Part__c Where opportunity__c In: set_oppIds  And Status__c =  \'Won\' and Process_Status__c = \'Production\' ';
		
		String str_queryInitialNum = 'Select Id,sum(Initial_12_months__c)  Initial_12_months__c From Opportunity_Part__c Where opportunity__c In: set_oppIds  And Status__c =  \'Won\' and Process_Status__c = \'Production\' ';
		for(APL_CtrlSearchForecastBilling.paramlFilter para : list_searchQuery) {
			if(para.objectName == 'Opportunity_Part__c'){
				if(!String.isEmpty(para.queryString)){
					queryOppyPartString = queryOppyPartString +' And '+ para.queryString ;	
					str_queryInitialNum = str_queryInitialNum +' And '+ para.queryString ;		
				}
			}
			
			if(para.objectName == 'APL_Billing_Result_of_Covnerted_Opp__c'){
				if(!String.isEmpty(para.queryString)){
					queryBilling = queryBilling +' And '+para.queryString ;			
				}
			}
		}
		
				
		queryBilling = queryBilling + ' group by Part__c, Opportunity__c';
		str_queryInitialNum = str_queryInitialNum + ' group by id ';
        
		//get all oppyPart accroding to oppId
		list_oppyPart = database.query(queryOppyPartString);
		
		//get  Part Ids according to OppyId		
		for(Opportunity_Part__c part : list_oppyPart){	    	
	      set_part_Ids.add(part.Part__c);
	      set_oppypartIds.add(part.Id);	  
	    }
	    //system.debug('qmx_set_partIds:'+set_part_Ids);
		//get all the forcecast for oppy part
		queryFore = 'Select Opportunity__c, Part__c, Fiscal_Year__c, Fiscal_Quarter__c ,sum(Amount__c) Amount__c '
					+ 'From Opportunity_Forecast__c where Part__c In: set_oppypartIds AND Opportunity__c In: set_oppIds  And '
					+ '(Fiscal_Year__c >= \'' +  (fiscalYear-1) + '\' AND Fiscal_Year__c <= \'' + (fiscalYear + 1)
					+ ' \') Group By Opportunity__c, part__c, Fiscal_Year__c, Fiscal_Quarter__c ';
				
		list<AggregateResult> list_oppypart_forecast = database.query(queryFore);	
		//get all the billing for oppy part
		list<AggregateResult> list_oppypart_billing = database.query(queryBilling);
		list<AggregateResult> list_oppypart_intialNum = database.query(str_queryInitialNum);				

		system.debug('list_oppyPart Size--'+list_oppyPart.size()+'list_oppyPartBilling Size--'+list_oppypart_billing.size());
		for(AggregateResult oppyPart : list_oppypart_intialNum){
			map_oppyPartId_intial.put(String.valueOf(oppyPart.get('id')),(decimal)oppyPart.get('Initial_12_months__c'));
		}
		
						  
		for(Opportunity_Part__c oppyPart : list_oppyPart) {					
	   		//check if it contain null value,set default value 
	   		boolean initial12Months = false;
			boolean nextYear = false;
			boolean befYear = false;
			boolean fisYear = false;
			boolean fisYearQ1 = false;
			boolean fisYearQ2 = false;
			boolean fisYearQ3 = false;
			boolean fisYearQ4 = false;
			boolean oppyPartBilling =false;
			
			response res = new response();
			res.objectName = 'Opportunity_Part__c';//It is used to sure the record is which Opportunity
			res.objectId = oppyPart.id;
			res.oppyId = oppyPart.opportunity__c;
			res.oppyName = oppyPart.opportunity__r.Name;
			res.oppyNumber = oppyPart.opportunity__r.Opportunity_Number__c;
			
			//iterator oppyId to put api name and  corresponding values
			for(String apiName :customSetting_OppyPart.Column_API_Names__c.split(',')) {
				list_object_filed = apiName.split('\\.');//to sure the apiName whether across the fields
				if(list_object_filed.size() == 1) {//if the object is Opportunity Part
					//to sure the data is null to set it ''
					if(OppyPart.get(apiName) == null) {
						res.map_record.put(apiName, '-');
					}else {	
											
					//format won date 
					if(apiName == 'Won_Date__c'){
						Datetime wonDate = Datetime.valueOf(String.valueOf(OppyPart.get(apiName)));
						String formatDateString=wonDate.format('yyyy-MM-dd');
						res.map_record.put(apiName,formatDateString);
					}else{
						res.map_record.put(apiName, String.valueOf(OppyPart.get(apiName)));
						}
					}
				}
				if(list_object_filed.size() == 2){//if the object is not Opportunity Part
					sObject sob = (sObject)oppyPart.getSObject(list_object_filed[0]);
					//to sure the data is null to set it ''
					if(sob.get(list_object_filed[1]) == null) {
						res.map_record.put(apiName, '-');
					}else {	
						res.map_record.put(apiName, String.valueOf(sob.get(list_object_filed[1])));
					}
				}
			}
			
			//set initial12Months
			if(map_oppyPartId_intial.get(oppyPart.id) != null) {
				if(!res.map_record.containsKey('Initial_12_months__c')) {
					initial12Months = true;
					res.map_record.put('Initial_12_months__c', formatData(map_oppyPartId_intial.get(oppyPart.id)));
				}else {
					decimal initial12MonthsValue = (decimal)(map_oppyPartId_intial.get(oppyPart.id));
					initial12MonthsValue += decimal.valueOf((res.map_record.get('Initial_12_months__c')));
					res.map_record.put('Initial_12_months__c', formatData(initial12MonthsValue));
				}
			}
			
			system.debug('queryBillingchen::' + queryBilling);
			//iterate forecast to put api name and  corresponding values
		 	for(AggregateResult oppFore : list_oppypart_forecast) {
		 		if(oppyPart.Id == oppFore.get('Part__c') && oppyPart.opportunity__c == oppFore.get('opportunity__c')){
		 			//Sum Next Year's Total Quantity
		 			if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear + 1)) {
						if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
							nextYear=true;
							if(!res.map_record.containsKey(String.valueOf('FY' + (fiscalYear + 1)))) {
								res.map_record.put(String.valueOf('FY' + (fiscalYear + 1)), formatData((decimal)oppFore.get('Amount__c')));
							}else {
								decimal quantity = (decimal)(oppFore.get('Amount__c'));
								quantity += decimal.valueOf(res.map_record.get(String.valueOf('FY' + (fiscalYear + 1))));
								res.map_record.put(String.valueOf('FY' + (fiscalYear + 1)), formatData(quantity));
							}
						}
					}
					
					//Sum Last Year's Total Quantity
					if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear - 1)) {
						if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
							befYear=true;
							if(!res.map_record.containsKey(String.valueOf('FY' + (fiscalYear - 1)))) {
								res.map_record.put(String.valueOf('FY' + (fiscalYear - 1)), formatData((decimal)oppFore.get('Amount__c')));
							}else {
								decimal quantity = (decimal)(oppFore.get('Amount__c'));
								quantity += decimal.valueOf(res.map_record.get(String.valueOf('FY' + (fiscalYear - 1))));
								res.map_record.put(String.valueOf('FY' + (fiscalYear - 1)),formatData(quantity));
							}
						}
					}
					
					//Sum Current Year					
					if(String.valueOf(oppFore.get('Fiscal_Year__c')) == String.valueOf(fiscalYear)){
						
						//Sum Curretn Year TTL
						if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
							fisYear=true;
							if(!res.map_record.containsKey(String.valueOf('FY' +fiscalYear))) {
								res.map_record.put(String.valueOf('FY' +fiscalYear), formatData((decimal)oppFore.get('Amount__c')));
							}else {
								decimal quantity = (decimal)(oppFore.get('Amount__c'));
								quantity += decimal.valueOf(res.map_record.get(String.valueOf('FY' +fiscalYear)));
								res.map_record.put(String.valueOf('FY' +fiscalYear), formatData(quantity));
							}
						}
						
									
						//get Fiscal_Quarter 01 Quantity__c
						if(String.valueOf(oppFore.get('Fiscal_Quarter__c')) == '01') {
							if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
								if(!res.map_record.containsKey(String.valueOf('FY' + fiscalYear + '_Q1'))) {
									fisYearQ1=true;
									res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q1'), formatData((decimal)oppFore.get('Amount__c')));
								}
							}else{	
							    res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q1'),'');
							}
						}
						
						//get Fiscal_Quarter 02 Quantity__c
						if(String.valueOf(oppFore.get('Fiscal_Quarter__c')) == '02') {
							if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
								if(!res.map_record.containsKey(String.valueOf('FY' + fiscalYear + '_Q2'))) {
									fisYearQ2=true;
									res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q2'), formatData((decimal)oppFore.get('Amount__c')));
								}
							}else{	
							    res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q2'),'');
							}
						}
						//get Fiscal_Quarter 03 Quantity__c
						if(String.valueOf(oppFore.get('Fiscal_Quarter__c')) == '03') {
							if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
								if(!res.map_record.containsKey(String.valueOf('FY' + fiscalYear + '_Q3'))) {
									fisYearQ3=true;
									res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q3'), formatData((decimal)oppFore.get('Amount__c')));
								}
							}else{	
							    res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q3'),'');
							}
						}
						
						//get Fiscal_Quarter 04 Quantity__c
						if(String.valueOf(oppFore.get('Fiscal_Quarter__c')) == '04') {
							if(oppFore.get('Amount__c') != null) {//to sure the data is null to make it can work
								if(!res.map_record.containsKey(String.valueOf('FY' + fiscalYear + '_Q4'))) {
									fisYearQ4=true;
									res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q4'), formatData((decimal)oppFore.get('Amount__c')));
								}
							}else{	
							    res.map_record.put(String.valueOf('FY' + fiscalYear + '_Q4'),'');
							}
						}
										
					
				 }
			}
					
		}
		
		//iterate billing to put api name and  corresponding values		
		for(AggregateResult oppyBilling : list_oppypart_billing) {
			if(oppyPart.Part__c == String.valueOf(oppyBilling.get('Part__c')) && oppyPart.Opportunity__c == String.valueOf(oppyBilling.get('Opportunity__c'))) {
					oppyPartBilling=true;
                	system.debug('qmx_oppyPart.Part__c:'+ oppyPart.Part__c);
					for(String apiName : set_billingKey){
						if(oppyBilling.get(apiName) == null) {
							res.map_record.put(apiName, '-');
						}else {	
							res.map_record.put(apiName, formatData((decimal)oppyBilling.get(apiName)));
							}
					}
										
					//calculate Billing_Diff_Vs_Pre_FY 
					decimal bill_year_to_date_amount_usd = String.valueOf(res.map_record.get('Bill_Year_to_Date_Amount_USD__c'))==''? 0 : decimal.valueOf(res.map_record.get('Bill_Year_to_Date_Amount_USD__c'));
					decimal bill_prior_year_to_date_amount_usd = String.valueOf(res.map_record.get('Bill_Prior_Year_to_Date_Amount_USD__c'))==''?0 : decimal.valueOf(res.map_record.get('Bill_Prior_Year_to_Date_Amount_USD__c'));
					
					decimal billing_diff_vs_pre_fy = bill_year_to_date_amount_usd - bill_prior_year_to_date_amount_usd;
					
					if(billing_diff_vs_pre_fy == 0){
						res.map_record.put('Billing_Diff_Vs_Pre_FY', '-');
					}else {
						res.map_record.put('Billing_Diff_Vs_Pre_FY',formatData(billing_diff_vs_pre_fy));
					}
					
					//calculate Booking_Diff_Vs_Pre_FY value
					decimal book_year_to_date_amount_usd = String.valueOf(res.map_record.get('Book_Year_to_Date_Amount_USD__c'))==''? 0 : decimal.valueOf(res.map_record.get('Book_Year_to_Date_Amount_USD__c'));
					decimal book_Prior_year_to_date_amount = String.valueOf(res.map_record.get('Book_Prior_Year_To_Date_Amount_USD__c'))==''? 0 : decimal.valueOf(res.map_record.get('Book_Prior_Year_To_Date_Amount_USD__c'));
					
					decimal Booking_diff_vs_pre_fy = book_year_to_date_amount_usd - book_Prior_year_to_date_amount;
					
					if(Booking_diff_vs_pre_fy == 0){
						res.map_record.put('Booking_Diff_Vs_Pre_FY', '-');
					}else {
						res.map_record.put('Booking_Diff_Vs_Pre_FY',formatData(Booking_diff_vs_pre_fy));
					}
			}
		}
			
		   //set default value  for forcast column when no data
			if(nextYear == false) {
				res.map_record.put(String.valueOf('FY' + (fiscalYear + 1)), '-');
			}
			if(befYear == false) {
				res.map_record.put(String.valueOf('FY' + (fiscalYear - 1)), '-');
			}
			if(fisYear == false) {
				res.map_record.put(String.valueOf('FY' + fiscalYear), '-');
			}
			if(initial12Months == false){
				res.map_record.put('Initial_12_months__c', '-');
			}
			if(fisYearQ1 == false) {
				res.map_record.put('FY' + fiscalYear + '_Q1', '-');
			}
			if(fisYearQ2 == false) {
				res.map_record.put('FY' + fiscalYear + '_Q2', '-');
			}
			if(fisYearQ3 == false) {
				res.map_record.put('FY' + fiscalYear + '_Q3', '-');
			}
			if(fisYearQ4 == false) {
				res.map_record.put('FY' + fiscalYear + '_Q4', '-');
			}
			
			//set default value  for billing column when no data
			if(oppyPartBilling == false){
				for(String apiName : set_billingKey){
					res.map_record.put(apiName, '-');
				}
				res.map_record.put('Booking_Diff_Vs_Pre_FY', '-');
				res.map_record.put('Billing_Diff_Vs_Pre_FY', '-');
			}
			
			
		//calculate Forecast Achieve Ratio
		
		decimal billing_diff_vs_pre = String.ValueOf(res.map_record.get('Billing_Diff_Vs_Pre_FY'))=='-'?0:decimal.ValueOf(res.map_record.get('Billing_Diff_Vs_Pre_FY'));
		
		decimal fiscal_forcast=0;
		
		if(current_fiscal_month != 0){
			decimal fiscal_Q1 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q1'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q1')));
			decimal fiscal_Q2 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q2'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q2')));
			decimal fiscal_Q3 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q3'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q3')));
			decimal fiscal_Q4 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q4'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q4')));
			
			if(current_fiscal_month>=1 && current_fiscal_month <=3){
				fiscal_forcast = (fiscal_Q1*current_fiscal_month/3).setscale(2); 
			}
			if(current_fiscal_month>=4 && current_fiscal_month <= 6){
				fiscal_forcast = fiscal_Q1 + (fiscal_Q2*(current_fiscal_month-3)/3).setscale(2);
			}
			if(current_fiscal_month>=7 && current_fiscal_month <= 9){
				fiscal_forcast = fiscal_Q1 + fiscal_Q2 + (fiscal_Q3*(current_fiscal_month-6)/3).setscale(2);
			}
			if(current_fiscal_month>=10 && current_fiscal_month <= 12){
				fiscal_forcast = fiscal_Q1 + fiscal_Q2 + fiscal_Q3 + (fiscal_Q4*(current_fiscal_month-9)/3).setscale(2);
			}		
			 
		}
		
		if(fiscal_forcast == 0){
			res.map_record.put('Bill_Forecast_Achieve_Ratio', 'N/A');
		}else{
			decimal forcast_achieve_ration = ((billing_diff_vs_pre/fiscal_forcast)*100).setscale(1);
			res.map_record.put('Bill_Forecast_Achieve_Ratio',String.valueOf(forcast_achieve_ration)+'%');
		}
				 
			list_responseOppyPart.add(res);
		}
		system.debug('chenchen::list_responseOppyPart::' + list_responseOppyPart);
		return list_responseOppyPart;
	}
	
	//to get oppyPartner data
	public static list<response> getoppyPartner(String oppId){
		list<String> list_object_filed = new list<String>();
		
		list<response> list_responseOppyPartner = new list<response>();
		list<Opportunity_Partner__c> list_oppyPartner = new list<Opportunity_Partner__c>();
		//get all oppyPartner accroding to oppId
		list_oppyPartner = database.query('Select Id, opportunity__c, opportunity__r.Name, opportunity__r.Opportunity_Number__c, ' + customSetting_OppyPartner.Column_API_Names__c
										 +' From Opportunity_Partner__c Where opportunity__c =: oppId order by Id');
		for(Opportunity_Partner__c oppyPartner : list_oppyPartner) {
			response res = new response();
			res.objectName = 'Opportunity_Partner__c';//It is used to sure the record is which Opportunity 
			res.objectId = oppyPartner.id;
			res.oppyName = oppyPartner.opportunity__r.Name;
			res.oppyNumber = oppyPartner.opportunity__r.Opportunity_Number__c;
			res.oppyId = oppyPartner.opportunity__c;
			//iterator oppyId to put api name and  corresponding values
			for(String apiName : customSetting_OppyPartner.Column_API_Names__c.split(',')) {
				//system.debug('chen::apiName::' + apiName);
				list_object_filed = apiName.split('\\.');//to sure the apiName whether across the fields
				if(list_object_filed.size() == 1) {//if the object is Opportunity Part
					//to sure the data is null to set it ''
					if(oppyPartner.get(apiName) == null) {
						res.map_record.put(apiName, '');
					}else {	
						res.map_record.put(apiName, String.valueOf(oppyPartner.get(apiName)));
					}
				}
				if(list_object_filed.size() == 2){//if the object is not Opportunity Part
					sObject sob = (sObject)oppyPartner.getSObject(list_object_filed[0]);
					res.map_record.put(apiName, String.valueOf(sob.get(list_object_filed[1])));
				}
			}
			list_responseOppyPartner.add(res);
		}
		system.debug('chenchen::list_responseOppyPartner::' + list_responseOppyPartner);
		return list_responseOppyPartner;
	}

	//to get oppyPartner Data and oppyPartnerForcecast and Billing Data (Kevin Shen)
	public static list<response> getoppyPartnerFcBilling(list<APL_CtrlSearchForecastBilling.paramlFilter> list_searchQuery,set<String> set_oppIds,Integer fiscalYear,Integer current_fiscal_month){
			
		//Set<String> set_oppyIds = new Set<String>{
		  // oppId
		//};
		set<String> set_partIds = new set<String>();
		
		set<String> set_billingKey=new set<String>{
			'Book_Year_to_Date_Amount_USD__c',
			'Book_Prior_Year_To_Date_Amount_USD__c',
			'Book_Prior_Year_Amount_USD__c',
			'Bill_Year_to_Date_Amount_USD__c',
			'Bill_Prior_Year_to_Date_Amount_USD__c',
			'Bill_Prior_Year_Amount_USD__c',
			'Bill_Prior_Year_1_to_Date_Amount_Do__c',
			'Bill_Prior_Year_1_Amount_Document__c'
		};
		
		//get all the oppy partner Id for one oppyId
		Set<String> set_partnerIds =new Set<String>();
		
		//get all the accountIds for oppy partner
		Set<String> set_accountIds =new Set<String>(); 
        map<String,set<String>> map_oppyId_partIds = new map<String,set<String>>();
	
		//get oppy forcast data 
		list<response> list_responseOppy =getFore(list_searchQuery,set_oppIds,fiscalYear,false,false,false);
		
		
		String oppyPartnerQuery = 'Select Id, opportunity__c,Account__c,opportunity__r.Name,opportunity__r.Opportunity_Number__c, ' + customSetting_OppyPartner.Column_API_Names__c
										 +' From Opportunity_Partner__c Where opportunity__c In: set_oppIds ';
		//query Oppy part string
		String queryOppyPartString = 'Select Id,Part__c,opportunity__c '
									  +' From Opportunity_Part__c Where opportunity__c In: set_oppIds  And Status__c =  \'Won\' and Process_Status__c = \'Production\' ';
		
		//build the query string for billing 			
		String queryBilling='SELECT Opportunity_Partner__c,Opportunity__c,part__c,Sum(Bill_Prior_Year_1_Amount_Document__c) Bill_Prior_Year_1_Amount_Document__c,Sum(Bill_Prior_Year_1_to_Date_Amount_Do__c) Bill_Prior_Year_1_to_Date_Amount_Do__c,'
		+'Sum(Bill_Prior_Year_Amount_USD__c) Bill_Prior_Year_Amount_USD__c,Sum(Bill_Prior_Year_to_Date_Amount_USD__c) Bill_Prior_Year_to_Date_Amount_USD__c,Sum(Bill_Year_to_Date_Amount_USD__c) Bill_Year_to_Date_Amount_USD__c,Sum(Book_Prior_Year_Amount_USD__c) Book_Prior_Year_Amount_USD__c,'
		+'Sum(Book_Prior_Year_To_Date_Amount_USD__c) Book_Prior_Year_To_Date_Amount_USD__c,Sum(Book_Year_to_Date_Amount_USD__c) Book_Year_to_Date_Amount_USD__c FROM APL_Billing_Result_of_Covnerted_Opp__c Where Opportunity_Partner__c In: set_accountIds And Opportunity__c In: set_oppIds and part__c In: set_partIdS ';
	
		
		//filter oppy partner								 
		for(APL_CtrlSearchForecastBilling.paramlFilter para : list_searchQuery) {
			if(para.objectName == 'Opportunity_Part__c'){
				if(!String.isEmpty(para.queryString)){
					queryOppyPartString = queryOppyPartString + ' And ' + para.queryString;			
				}
			}
			//updata to 2016/7/5 by Mingxing Qiu because of GAM code do't filter partner
			/*if(para.objectName == 'Opportunity_Partner__c'){
				if(!String.isEmpty(para.queryString)){
					oppyPartnerQuery = oppyPartnerQuery +' And '+ para.queryString ;
					//queryOppyPartString = queryOppyPartString + ' And ' + para.queryString;			
				}
			}*/
			
			if(para.objectName == 'APL_Billing_Result_of_Covnerted_Opp__c'){
				if(!String.isEmpty(para.queryString)){
					queryBilling = queryBilling +' And '+para.queryString ;			
				}
			}
		}
		
		queryBilling = queryBilling +' group by Opportunity_Partner__c, Opportunity__c,part__c ';	 						 
		
		
		
		
		list<String> list_object_filed = new list<String>();
		list<response> list_responseOppyPartner = new list<response>();
		list<Opportunity_Partner__c> list_oppyPartner = new list<Opportunity_Partner__c>();
        map<String,list<map<String,aplBill>>> map_oppyId_aplbill = new map<String,list<map<String,aplBill>>>();
		//get all oppyPartner accroding to oppId
		
		list_oppyPartner = database.query(oppyPartnerQuery);
		
		//get all the oppy partner Id and accountId
		for(Opportunity_Partner__c oppyPartner : list_oppyPartner){
			set_partnerIds.add(oppyPartner.Id);
			set_accountIds.add(oppyPartner.Account__c);
		}
		for(Opportunity_Part__c oppyPart : database.query(queryOppyPartString)) {
			set_partIds.add(oppyPart.Part__c);
             if(!map_oppyId_partIds.containsKey(oppyPart.opportunity__c)){
                map_oppyId_partIds.put(oppyPart.opportunity__c,new set<String>());
            }
            map_oppyId_partIds.get(oppyPart.opportunity__c).add(oppyPart.part__c);
		}
		
		//system.debug('qmx:oppyPartnerQuery::' + queryBilling);
		//system.debug('qmx:queryOppyPartString::' + queryOppyPartString);
	   //get all the billing for oppy partner
		list<AggregateResult> list_oppypartner_billing = database.query(queryBilling);
		//system.debug('qmx: list_oppypartner_billing :'+ list_oppypartner_billing);
		//system.debug('list_oppyPartner size--'+list_oppyPartner.size()+'list_oppypartner_billing size--'+list_oppypartner_billing.size());
		//system.debug('qmx_map_oppyId_partIds :' + map_oppyId_partIds);
        
        //modifiy Mingxing Qiu  by 2016-8-9
        //get sum APL_Billing_Result_of_Covnerted_Opp__c by opportunity and part and  orroutunity !
        for(AggregateResult Bill : list_oppypartner_billing) {
			String oppyId = String.valueOf(Bill.get('opportunity__c'));
			String partId = String.valueOf(Bill.get('part__c'));
            String partnerId = String.valueOf(Bill.get('Opportunity_Partner__c'));
			decimal Bill_Prior_Year_1_Amount_Document = (Decimal)(Bill.get('Bill_Prior_Year_1_Amount_Document__c'));
			decimal Bill_Prior_Year_1_to_Date_Amount_Do = (Decimal)(Bill.get('Bill_Prior_Year_1_to_Date_Amount_Do__c'));
			decimal Bill_Prior_Year_Amount_USD = (Decimal)(Bill.get('Bill_Prior_Year_Amount_USD__c'));
			decimal Bill_Prior_Year_to_Date_Amount_USD = (Decimal)(Bill.get('Bill_Prior_Year_to_Date_Amount_USD__c'));
			decimal Bill_Year_to_Date_Amount_USD = (Decimal)(Bill.get('Bill_Year_to_Date_Amount_USD__c'));
			decimal Book_Prior_Year_Amount_USD = (Decimal)(Bill.get('Book_Prior_Year_Amount_USD__c'));
			decimal Book_Prior_Year_To_Date_Amount_USD = (Decimal)(Bill.get('Book_Prior_Year_To_Date_Amount_USD__c'));
			decimal Book_Year_to_Date_Amount_USD = (Decimal)(Bill.get('Book_Year_to_Date_Amount_USD__c'));
			if(map_oppyId_partIds.get(oppyId).contains(partId)){      //find oppy relative should be part
				if(!map_oppyId_aplbill.containsKey(oppyId)) {
                    system.debug('qmx_oppyId::'+oppyId);
					map_oppyId_aplbill.put(oppyId,new list<map<String,aplBill>>());
                    map<String,aplBill> map_partner_aplBill = new map<String,aplBill>();
                    if(!map_partner_aplBill.containsKey(partnerId)){
                        map_partner_aplBill.put(partnerId,new aplBill());
                    }
					map_partner_aplBill.get(partnerId).Bill_Prior_Year_1_Amount_Document = Bill_Prior_Year_1_Amount_Document == null ? 0 : Bill_Prior_Year_1_Amount_Document;
					map_partner_aplBill.get(partnerId).Bill_Prior_Year_1_to_Date_Amount_Do = Bill_Prior_Year_1_to_Date_Amount_Do == null ? 0 : Bill_Prior_Year_1_to_Date_Amount_Do;
					map_partner_aplBill.get(partnerId).Bill_Prior_Year_Amount_USD = Bill_Prior_Year_Amount_USD == null ? 0 : Bill_Prior_Year_Amount_USD;
					map_partner_aplBill.get(partnerId).Bill_Prior_Year_to_Date_Amount_USD = Bill_Prior_Year_to_Date_Amount_USD == null ? 0 : Bill_Prior_Year_to_Date_Amount_USD;
					map_partner_aplBill.get(partnerId).Bill_Year_to_Date_Amount_USD = Bill_Year_to_Date_Amount_USD == null ? 0 : Bill_Year_to_Date_Amount_USD;
					map_partner_aplBill.get(partnerId).Book_Prior_Year_Amount_USD = Book_Prior_Year_Amount_USD == null ? 0 : Book_Prior_Year_Amount_USD;
					map_partner_aplBill.get(partnerId).Book_Prior_Year_To_Date_Amount_USD = Book_Prior_Year_To_Date_Amount_USD == null ? 0 : Book_Prior_Year_To_Date_Amount_USD;
					map_partner_aplBill.get(partnerId).Book_Year_to_Date_Amount_USD = Book_Year_to_Date_Amount_USD == null ? 0 : Book_Year_to_Date_Amount_USD;
					map_oppyId_aplbill.get(oppyId).add(map_partner_aplBill);
				}else{
                    system.debug('qmx_oppyId2::'+oppyId);
                    boolean isPartnerId = false;
                    for(map<String,aplBill> map_partner_aplBill : map_oppyId_aplbill.get(oppyId)) {
                        if(map_partner_aplBill.containsKey(partnerId)){
                            isPartnerId = true ;
                        }
                    }
                    if(!isPartnerId){
                         map<String,aplBill> map_partner_aplBill_new = new map<String,aplBill>();
                         map_partner_aplBill_new.put(partnerId,new aplBill());
                         map_partner_aplBill_new.get(partnerId).Bill_Prior_Year_1_Amount_Document = Bill_Prior_Year_1_Amount_Document == null ? 0 : Bill_Prior_Year_1_Amount_Document;
                         map_partner_aplBill_new.get(partnerId).Bill_Prior_Year_1_to_Date_Amount_Do = Bill_Prior_Year_1_to_Date_Amount_Do == null ? 0 : Bill_Prior_Year_1_to_Date_Amount_Do;
                         map_partner_aplBill_new.get(partnerId).Bill_Prior_Year_Amount_USD = Bill_Prior_Year_Amount_USD == null ? 0 : Bill_Prior_Year_Amount_USD;
                         map_partner_aplBill_new.get(partnerId).Bill_Prior_Year_to_Date_Amount_USD = Bill_Prior_Year_to_Date_Amount_USD == null ? 0 : Bill_Prior_Year_to_Date_Amount_USD;
                         map_partner_aplBill_new.get(partnerId).Bill_Year_to_Date_Amount_USD = Bill_Year_to_Date_Amount_USD == null ? 0 : Bill_Year_to_Date_Amount_USD;
                         map_partner_aplBill_new.get(partnerId).Book_Prior_Year_Amount_USD = Book_Prior_Year_Amount_USD == null ? 0 : Book_Prior_Year_Amount_USD;
                         map_partner_aplBill_new.get(partnerId).Book_Prior_Year_To_Date_Amount_USD = Book_Prior_Year_To_Date_Amount_USD == null ? 0 : Book_Prior_Year_To_Date_Amount_USD;
                         map_partner_aplBill_new.get(partnerId).Book_Year_to_Date_Amount_USD = Book_Year_to_Date_Amount_USD == null ? 0 : Book_Year_to_Date_Amount_USD;
                         map_oppyId_aplbill.get(oppyId).add(map_partner_aplBill_new);
                    }else{
                        system.debug('qmx_isPartnerId');
                        for(map<String,aplBill> map_partner_aplBill : map_oppyId_aplbill.get(oppyId)) {
                        	if(map_partner_aplBill.containsKey(partnerId)){
                                map_partner_aplBill.get(partnerId).Bill_Prior_Year_1_Amount_Document += Bill_Prior_Year_1_Amount_Document == null ? 0 : Bill_Prior_Year_1_Amount_Document;
                                map_partner_aplBill.get(partnerId).Bill_Prior_Year_1_to_Date_Amount_Do += Bill_Prior_Year_1_to_Date_Amount_Do == null ? 0 : Bill_Prior_Year_1_to_Date_Amount_Do;
                                map_partner_aplBill.get(partnerId).Bill_Prior_Year_Amount_USD += Bill_Prior_Year_Amount_USD == null ? 0 : Bill_Prior_Year_Amount_USD;
                                map_partner_aplBill.get(partnerId).Bill_Prior_Year_to_Date_Amount_USD += Bill_Prior_Year_to_Date_Amount_USD == null ? 0 : Bill_Prior_Year_to_Date_Amount_USD;
                                map_partner_aplBill.get(partnerId).Bill_Year_to_Date_Amount_USD += Bill_Year_to_Date_Amount_USD == null ? 0 : Bill_Year_to_Date_Amount_USD;
                                map_partner_aplBill.get(partnerId).Book_Prior_Year_Amount_USD+= Book_Prior_Year_Amount_USD == null ? 0 : Book_Prior_Year_Amount_USD;
                                map_partner_aplBill.get(partnerId).Book_Prior_Year_To_Date_Amount_USD += Book_Prior_Year_To_Date_Amount_USD  == null ? 0 : Book_Prior_Year_To_Date_Amount_USD;
                                map_partner_aplBill.get(partnerId).Book_Year_to_Date_Amount_USD += Book_Year_to_Date_Amount_USD == null ? 0 : Book_Year_to_Date_Amount_USD;
                        	}  
                    	}
					}
                }
            }
			system.debug('qmx_map_oppyId_aplbill::'+map_oppyId_aplbill);
		}
        
        //iterate oppy partner and set oppy forcecast and billing for it
		for(Opportunity_Partner__c oppyPartner : list_oppyPartner) {
			
			boolean oppyPartnerBilling= false;
			
			response res = new response();
			res.objectName = 'Opportunity_Partner__c';//It is used to sure the record is which Opportunity 
			res.objectId = oppyPartner.id;
			res.oppyId = oppyPartner.opportunity__c;
			res.oppyName = oppyPartner.opportunity__r.Name;
			res.oppyNumber = oppyPartner.opportunity__r.Opportunity_Number__c;
			//iterator oppyId to put api name and  corresponding values
			for(String apiName : customSetting_OppyPartner.Column_API_Names__c.split(',')) {
				system.debug('chen::apiName::' + apiName);
				list_object_filed = apiName.split('\\.');//to sure the apiName whether across the fields
				if(list_object_filed.size() == 1) {//if the object is Opportunity Part
					//to sure the data is null to set it ''
					if(oppyPartner.get(apiName) == null) {
						res.map_record.put(apiName, '-');
					}else {	
						res.map_record.put(apiName, String.valueOf(oppyPartner.get(apiName)));
					}
				}
				if(list_object_filed.size() == 2){ //if the object is not Opportunity Part
					sObject sob = (sObject)oppyPartner.getSObject(list_object_filed[0]);
					res.map_record.put(apiName, String.valueOf(sob.get(list_object_filed[1])));
				}
			}
			
			// oppy partner forcecast percentage
			decimal allocation = String.valueOf(res.map_record.get('Allocation__c'))== '-'?0:decimal.valueOf(String.valueOf(res.map_record.get('Allocation__c')));
		     
						
			//get forecast value from Oppy and assign it to oppypartner
			for(response oppy_response : list_responseOppy) {
				//get the oppy for current oppypartner
				if(oppy_response.oppyId == res.oppyId) {
					//calculate oppy partner forecast
					if(!oppy_response.map_record.containsKey('Initial_12_months__c')){
						//calcuate oppy partner last year  forcecast
						if(String.valueOf(oppy_response.map_record.get('FY' + (fiscalYear - 1)))!='-' && String.valueOf(oppy_response.map_record.get('FY' + (fiscalYear - 1))) != null){
						//calculate oppy partner forcecast based on the allocation 
						system.debug('qmx get( (fiscalYear - 1)::' + String.valueOf(oppy_response.map_record.get('FY' + (fiscalYear - 1))));
						decimal oppypartner_bef_fc =((decimal.valueOf(oppy_response.map_record.get('FY' + (fiscalYear - 1)))*allocation)/100).setscale(2);			
					    res.map_record.put('FY'+(fiscalYear - 1),formatData(oppypartner_bef_fc));
						}else {
						 res.map_record.put('FY'+(fiscalYear - 1),'-');
						}
					
			       		//calculate oppy partner next year  forcecast
						if(String.valueOf(oppy_response.map_record.get('FY' + (fiscalYear + 1)))!='-'){
							//calcuate oppy partner forcecast based on the allocation 
							decimal oppypartner_after_fc =((decimal.valueOf(oppy_response.map_record.get('FY' + (fiscalYear + 1)))*allocation)/100).setscale(2);			
					    	res.map_record.put('FY'+(fiscalYear + 1),formatData(oppypartner_after_fc));
						}else {
						 res.map_record.put('FY'+(fiscalYear + 1),'-');
						}
					
					
						//calculate opp partner current year				
						if(String.valueOf(oppy_response.map_record.get('FY' + fiscalYear))!='-'){
							//calcuate oppy partner forcecast based on the allocation 
							decimal oppypartner_cur_fc =((decimal.valueOf(oppy_response.map_record.get('FY' + fiscalYear))*allocation)/100).setscale(2);			
					    	res.map_record.put('FY' + fiscalYear,formatData(oppypartner_cur_fc));
						}else {
						 res.map_record.put('FY' + fiscalYear,'-');
						}
					
						// calculate opp partner  quarter Q1~4 forecast 										
						for(Integer i=1;i<=4;i++){
							if(String.valueOf(oppy_response.map_record.get('FY' + fiscalYear + '_Q'+i)) != '-') {
								decimal oppypartner_fc_quart =((decimal.valueOf(oppy_response.map_record.get('FY' + fiscalYear + '_Q'+i))*allocation)/100).setscale(2);			
					    		res.map_record.put('FY' + fiscalYear + '_Q'+i,formatData(oppypartner_fc_quart));
							}else{
								 res.map_record.put('FY' + fiscalYear + '_Q'+i,'-');
							}					
						}
						}else {
						  //calculate oppy partner initial month
						  	if(String.valueOf(oppy_response.map_record.get('Initial_12_months__c'))!='-'){
								//calcuate oppy partner forcecast based on the allocation 
								decimal oppypartner_intial_month =((decimal.valueOf(oppy_response.map_record.get('Initial_12_months__c'))*allocation)/100).setscale(2);			
					    		res.map_record.put('Initial_12_months__c',formatData(oppypartner_intial_month));
							}else {
							 	res.map_record.put('Initial_12_months__c','-');
							}
						}									
				}
				
			}
				 //modifiy Mingxing Qiu  by 2016-8-9
				//iterate billing to put api name and  corresponding values		
			/*for(AggregateResult oppyBilling : list_oppypartner_billing) {
			if(oppyPartner.Account__c == String.valueOf(oppyBilling.get('Opportunity_Partner__c')) && oppyPartner.Opportunity__c == String.valueOf(oppyBilling.get('Opportunity__c'))) {
					oppyPartnerBilling=true;
					for(String apiName : set_billingKey){
						if(oppyBilling.get(apiName) == null) {
							res.map_record.put(apiName, '-');
						}else {	
							res.map_record.put(apiName, formatData((decimal)oppyBilling.get(apiName)));
							}
					}
										
					//calculate Billing_Diff_Vs_Pre_FY 
					decimal bill_year_to_date_amount_usd = String.valueOf(res.map_record.get('Bill_Year_to_Date_Amount_USD__c'))=='-'? 0 : decimal.valueOf(res.map_record.get('Bill_Year_to_Date_Amount_USD__c'));
					decimal bill_prior_year_to_date_amount_usd = String.valueOf(res.map_record.get('Bill_Prior_Year_to_Date_Amount_USD__c'))=='-'?0 : decimal.valueOf(res.map_record.get('Bill_Prior_Year_to_Date_Amount_USD__c'));
					
					decimal billing_diff_vs_pre_fy = bill_year_to_date_amount_usd - bill_prior_year_to_date_amount_usd;
					
					if(billing_diff_vs_pre_fy == 0){
						res.map_record.put('Billing_Diff_Vs_Pre_FY', '-');
					}else {
						res.map_record.put('Billing_Diff_Vs_Pre_FY',formatData(billing_diff_vs_pre_fy));
					}
					
					//calculate Booking_Diff_Vs_Pre_FY value
					decimal book_year_to_date_amount_usd = String.valueOf(res.map_record.get('Book_Year_to_Date_Amount_USD__c'))=='-'? 0 : decimal.valueOf(res.map_record.get('Book_Year_to_Date_Amount_USD__c'));
					decimal book_Prior_year_to_date_amount = String.valueOf(res.map_record.get('Book_Prior_Year_To_Date_Amount_USD__c'))=='-'? 0 : decimal.valueOf(res.map_record.get('Book_Prior_Year_To_Date_Amount_USD__c'));
					
					decimal Booking_diff_vs_pre_fy = book_year_to_date_amount_usd - book_Prior_year_to_date_amount;
					
					if(Booking_diff_vs_pre_fy == 0){
						res.map_record.put('Booking_Diff_Vs_Pre_FY', '-');
					}else {
						res.map_record.put('Booking_Diff_Vs_Pre_FY',formatData(Booking_diff_vs_pre_fy));
					}
			}
		}
		*/	
			//iterate billing to put api name and  corresponding values		
            if(map_oppyId_aplbill.get(oppyPartner.Opportunity__c)!=null) {
                for(map<String,aplBill> map_partnerId_oppyBilling : map_oppyId_aplbill.get(oppyPartner.Opportunity__c)) {
                    if(map_partnerId_oppyBilling.containsKey(oppyPartner.Account__c)) {
                    //if(oppyPartner.Account__c == String.valueOf(oppyBilling.Opportunity_Partner)) {
                        oppyPartnerBilling=true;
                        for(String apiName : set_billingKey){
                            if(map_partnerId_oppyBilling.get(oppyPartner.Account__c).getVal(apiName) == null) {
                                res.map_record.put(apiName, '-');
                            }else {	
                                res.map_record.put(apiName, formatData((decimal)map_partnerId_oppyBilling.get(oppyPartner.Account__c).getVal(apiName)));
                                }
                        }
                                            
                        //calculate Billing_Diff_Vs_Pre_FY 
                        decimal bill_year_to_date_amount_usd2 = String.valueOf(res.map_record.get('Bill_Year_to_Date_Amount_USD__c'))=='-'? 0 : decimal.valueOf(res.map_record.get('Bill_Year_to_Date_Amount_USD__c'));
                        decimal bill_prior_year_to_date_amount_usd2 = String.valueOf(res.map_record.get('Bill_Prior_Year_to_Date_Amount_USD__c'))=='-'?0 : decimal.valueOf(res.map_record.get('Bill_Prior_Year_to_Date_Amount_USD__c'));
                        
                        decimal billing_diff_vs_pre_fy = bill_year_to_date_amount_usd2 - bill_prior_year_to_date_amount_usd2;
                        
                        if(billing_diff_vs_pre_fy == 0){
                            res.map_record.put('Billing_Diff_Vs_Pre_FY', '-');
                        }else {
                            res.map_record.put('Billing_Diff_Vs_Pre_FY',formatData(billing_diff_vs_pre_fy));
                        }
                        
                        //calculate Booking_Diff_Vs_Pre_FY value
                        decimal book_year_to_date_amount_usd2 = String.valueOf(res.map_record.get('Book_Year_to_Date_Amount_USD__c'))=='-'? 0 : decimal.valueOf(res.map_record.get('Book_Year_to_Date_Amount_USD__c'));
                        decimal book_Prior_year_to_date_amount2 = String.valueOf(res.map_record.get('Book_Prior_Year_To_Date_Amount_USD__c'))=='-'? 0 : decimal.valueOf(res.map_record.get('Book_Prior_Year_To_Date_Amount_USD__c'));
                        
                        decimal Booking_diff_vs_pre_fy = book_year_to_date_amount_usd2 - book_Prior_year_to_date_amount2;
                        
                        if(Booking_diff_vs_pre_fy == 0){
                            res.map_record.put('Booking_Diff_Vs_Pre_FY', '-');
                        }else {
                            res.map_record.put('Booking_Diff_Vs_Pre_FY',formatData(Booking_diff_vs_pre_fy));
                        }
                }
            }
         }
		//set default value for billing column when no data
		
		if(oppyPartnerBilling == false){
				for(String apiName : set_billingKey){
					res.map_record.put(apiName, '-');
				}
				res.map_record.put('Booking_Diff_Vs_Pre_FY', '-');
				res.map_record.put('Billing_Diff_Vs_Pre_FY', '-');
			}
			
		//calculate Forecast Achieve Ratio
		
		decimal billing_diff_vs_pre = String.ValueOf(res.map_record.get('Billing_Diff_Vs_Pre_FY'))=='-'?0:decimal.ValueOf(res.map_record.get('Billing_Diff_Vs_Pre_FY'));
		
		decimal fiscal_forcast=0;
		
		if(current_fiscal_month != 0){
			decimal fiscal_Q1 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q1'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q1')));
			decimal fiscal_Q2 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q2'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q2')));
			decimal fiscal_Q3 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q3'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q3')));
			decimal fiscal_Q4 = String.ValueOf(res.map_record.get('FY' + fiscalYear + '_Q4'))=='-'?0:decimal.ValueOf((res.map_record.get('FY' + fiscalYear + '_Q4')));
			
			if(current_fiscal_month>=1 && current_fiscal_month <=3){
				fiscal_forcast = (fiscal_Q1*current_fiscal_month/3).setscale(2); 
			}
			if(current_fiscal_month>=4 && current_fiscal_month <= 6){
				fiscal_forcast = fiscal_Q1 + (fiscal_Q2*(current_fiscal_month-3)/3).setscale(2);
			}
			if(current_fiscal_month>=7 && current_fiscal_month <= 9){
				fiscal_forcast = fiscal_Q1 + fiscal_Q2 + (fiscal_Q3*(current_fiscal_month-6)/3).setscale(2);
			}
			if(current_fiscal_month>=10 && current_fiscal_month <= 12){
				fiscal_forcast = fiscal_Q1 + fiscal_Q2 + fiscal_Q3 + (fiscal_Q4*(current_fiscal_month-9)/3).setscale(2);
			}		
			 
		}
		
		if(fiscal_forcast == 0){
			res.map_record.put('Bill_Forecast_Achieve_Ratio', 'N/A');
		}else{
			decimal forcast_achieve_ration = ((billing_diff_vs_pre/fiscal_forcast)*100).setscale(1);
			res.map_record.put('Bill_Forecast_Achieve_Ratio',String.valueOf(forcast_achieve_ration)+'%');
		}			
			
			
			list_responseOppyPartner.add(res);
		}
		system.debug('chenchen::list_responseOppyPartner::' + list_responseOppyPartner);
		return list_responseOppyPartner;
	}		
	
	//get OppyPart Ids according to OppyId
	public static set<String> getOppyPartIds(String oppyId) {
		set<String> set_oppy_partIds = new set<String>();		
	    list<Opportunity_Part__c> list_partIds=[Select Id From Opportunity_Part__c Where opportunity__c =: oppyId];
	    for(Opportunity_Part__c part : list_partIds){
	      set_oppy_partIds.add(part.Id);
	    }		
		return set_oppy_partIds;
	}
	
	////////////////////////to get data accroding to oppyIds/////////////////////////////////
	//********************************* -=BEGIN inner classes=- ***********************************
	///*>>>WrapperClass*/
	/**
	 * Inner class for  
	 *
	 @author Qiang Liu
	 @created 2016-04-05
	 @version 1.0
	 @since 30.0 (Force.com ApiVersion)
	 *
	 *
	 @changelog
	 * 2016-04-05 Qiang Liu <qiang.liu@itbconsult.com>
	 * - Created
	*/
	
	public class WrapFiltersSub {
		public map<String, String> opportunity_Number {get; set;}
		public map<String, String> customer_Region {get; set;}
		public map<String, String> opportunity_Owner {get; set;}
		public map<String, String> account_Manager {get; set;}
		public map<String, String> field_Engineer {get; set;}
		
		public WrapFiltersSub() {
			this.opportunity_Number = new map<String, String>();
			this.customer_Region = new map<String, String>();
			this.opportunity_Owner = new map<String, String>();
			this.account_Manager = new map<String, String>();
			this.field_Engineer = new map<String, String>();
		}
	}
	///*<<<WrapperClass*/
	//to return data to js to show
	public class response {
		public map<String, String> map_record {get; set;}
		public set<String> set_oppyId2Js {get;set;}//to transmit set of oppyId when it is more than 100;
		public String message {get; set;}//when record is null to return it.
		public String oppyId {get; set;}//to sure forecast and billing is IN right Opportunity 
		public String objectName {get; set;}//to sure it is Opportunity Part or Partner
		public String objectId {get; set;}
		public String oppyNumber {get; set;}
		public String oppyName {get; set;}
		
		public response() {
			this.set_oppyId2Js = new set<String>();
			this.map_record = new map<String, String>();
			this.message = '';
			this.oppyId = '';
			this.objectName = '';
			this.objectId = '';
			this.oppyNumber = '';
			this.oppyName = '';
		}
	}
    
    //To save apl Billing result of covnerted opp data
    public class aplBill {
		public decimal Bill_Prior_Year_1_Amount_Document {get; set;}//when record is null to return it.
		public decimal Bill_Prior_Year_1_to_Date_Amount_Do {get; set;}//to sure forecast and billing is IN right Opportunity 
		public decimal Bill_Prior_Year_Amount_USD {get; set;}//to sure it is Opportunity Part or Partner
		public decimal Bill_Prior_Year_to_Date_Amount_USD {get; set;}
		public decimal Bill_Year_to_Date_Amount_USD {get; set;}
		public decimal Book_Prior_Year_Amount_USD {get; set;}
		public decimal Book_Prior_Year_To_Date_Amount_USD {get; set;}
		public decimal Book_Year_to_Date_Amount_USD {get; set;}
        public String Opportunity_Partner {get; set;}
     
		public aplBill() {
			this.Bill_Prior_Year_1_Amount_Document = 0;
			this.Bill_Prior_Year_1_to_Date_Amount_Do = 0;
			this.Bill_Prior_Year_Amount_USD= 0;
			this.Bill_Prior_Year_to_Date_Amount_USD = 0;
			this.Bill_Year_to_Date_Amount_USD = 0;
			this.Book_Prior_Year_Amount_USD = 0;
			this.Book_Prior_Year_To_Date_Amount_USD = 0;
			this.Book_Prior_Year_To_Date_Amount_USD = 0;
            this.Opportunity_Partner = '';
          
		}
        public decimal getVal(String apiName) {
            if(apiName == 'Bill_Prior_Year_1_Amount_Document__c') {
                return this.Bill_Prior_Year_1_Amount_Document;
            }else if(apiName == 'Bill_Prior_Year_1_to_Date_Amount_Do__c') {
                return this.Bill_Prior_Year_1_to_Date_Amount_Do;
            } else if(apiName == 'Bill_Prior_Year_Amount_USD__c') {
                return this.Bill_Prior_Year_Amount_USD;
            }else if(apiName == 'Bill_Prior_Year_to_Date_Amount_USD__c') {
                return this.Bill_Prior_Year_to_Date_Amount_USD;
            }else if(apiName == 'Book_Prior_Year_Amount_USD__c') {
                return this.Book_Prior_Year_Amount_USD;
            }else if(apiName == 'Book_Prior_Year_To_Date_Amount_USD__c') {
                return this.Book_Prior_Year_To_Date_Amount_USD;
            }else if(apiName == 'Book_Year_to_Date_Amount_USD__c') {
                return this.Book_Year_to_Date_Amount_USD;
            }else if(apiName == 'Bill_Year_to_Date_Amount_USD__c') {
                return this.Bill_Year_to_Date_Amount_USD;
            }else {
                return 0;
            }
        }
	}
	//********************************* -=END inner classes=- *************************************
}