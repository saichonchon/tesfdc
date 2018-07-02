global class ClsBatch_APLForecastAccuracy implements Database.Batchable<SObject>, Database.stateful{
	
	private String querySQL,fiscalYear,fiscalQuarter;
	private static String aplCBC2 = '30012;30014;30015;30016;30017;30042';
	//private static String aplRelayCBC2 = '30005;13213';
	//private static String aplRelayCBC3 = '40308;40309';
	//private static Decimal threeMonthWeight = 0.5,twoMonthWeight= 0.5,oneMonthWeight = 0.5;
	//added by Lei Tang<lei.tang@capgemini.com> 2017-1-20
	private set<String> outsideCBC2;
	private set<String> outsideGPLCode;
	
	public ClsBatch_APLForecastAccuracy(String queryStr,String fiscalYear,String fiscalQuarter){
		
		this.fiscalYear = fiscalYear;
		this.fiscalQuarter = '0'+fiscalQuarter;
		
        //added by Lei Tang<lei.tang@capgemini.com> 2017-1-20
        String outside = '';
		this.outsideCBC2 = new set<String>();
		this.outsideGPLCode = new set<String>();
		for(APL_Forecast_Settings__c setting : [select Id, Value__c from APL_Forecast_Settings__c where Name = 'Forecast accuracy exception']) {
        	if(setting.Value__c != null) {
    			outside = setting.Value__c;
        	}
        }
        if(String.isNotEmpty(outside)) {
        	list<String> outsideCBC2_code = outside.split(';');
        	for(String CBC2_code : outsideCBC2_code) {
        		if(String.isNotEmpty(CBC2_code)) {
        			list<String> set_CBC2_code = CBC2_code.split(':');
        			if(set_CBC2_code.size() == 2) {
        				this.outsideCBC2.add(set_CBC2_code.get(0));
        				this.outsideGPLCode.add(set_CBC2_code.get(1));
        			}
        		}
        	}
        }
        
		System.debug('-------fiscalYear----------'+fiscalYear);
		System.debug('-------fiscalQuarter----------'+fiscalQuarter);
		
		
		if(queryStr != null){
			querySQL = queryStr;
		}else{
			//querySQL = 'select RecordType.DeveloperName, Relay_Specialist__c, A6_Code__c from APL_Forecast_Management__c where RecordType.DeveloperName in (\'AM\',\'Relay\') and id = \'a3RE00000008dPM\'';
			querySQL = 'select RecordType.DeveloperName, Relay_Specialist__c, A6_Code__c from APL_Forecast_Management__c where RecordType.DeveloperName in (\'AM\',\'Relay\')';
		}
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return database.getQueryLocator(querySQL);
	}
	
	global void execute(Database.BatchableContext BC, list<APL_Forecast_Management__c> aplAMList){
		
		Set<String> territotyCodeSet = new Set<String>();
		Set<String> relaySpecialistCodeSet = new Set<String>();
		//Map<String,AggregateResult> CBC2ForecastMap = new Map<String,AggregateResult>();//key is Territory code + CBC2 Code
		Map<String,CustomForecast> CBC2ForecastMap = new Map<String,CustomForecast>();//new Data //key is Territory code + CBC2 Code
		//Map<String,AggregateResult> CBC2RelayForecastMap = new Map<String,AggregateResult>();//key is Territory code + 'Relay'
		Map<String,Decimal> totalBillingMap = new Map<String,Decimal>();//key is Territory Code
		Map<String,Decimal> totalQuantityMap = new Map<String,Decimal>();//key is Territory Code, use for Relay
		Map<String,Decimal> CBC2billingMap = new Map<String,Double>();//key is Territory code + CBC2 Code
		Map<String,Decimal> CBC2QuantityMap = new Map<String,Double>();//key is Territory code + CBC2 Code. use for Relay
		//Boolean hasRelayForecast = false;//check whether am inputed relay forecast or not
		
		for(APL_Forecast_Management__c am : aplAMList){
			if(am.RecordType.DeveloperName == 'AM'){
				territotyCodeSet.add(am.A6_Code__c);
			}else if(am.RecordType.DeveloperName == 'Relay'){
				relaySpecialistCodeSet.add(am.A6_Code__c);
			}
		}
		
		//*********** for AM begin ********************//
		System.debug('-------fiscalYear----------'+fiscalYear);
		System.debug('-------fiscalQuarter----------'+fiscalQuarter);
		System.debug('-------territotyCodeSet----------'+territotyCodeSet);
		if(fiscalQuarter.indexOf('0') == -1){
			fiscalQuarter = '0'+fiscalQuarter;
		}
		
		System.debug('-------fiscalQuarter----------'+fiscalQuarter);
		//query the forecast of non-relay
		List<AggregateResult> forecastList = [select Customer__r.SALES_TERRITORY_CDE__c territoryCode,GPL__r.CBC2__c CBC2,
			sum(Current_month_2_RSM_forecast__c) lastForecast,sum(Current_month_3_RSM_forecast__c) lastForecast_1,sum(Current_month_4_RSM_forecast__c) lastForecast_2
			from apl_sales_forecast__c where Fiscal_Year__c =: fiscalYear and Fiscal_Quarter__c =: fiscalQuarter and Customer__r.SALES_TERRITORY_CDE__c in: territotyCodeSet
			and type__c in ('GPL','Other CBC2') 
			//added by Lei Tang<lei.tang@capgemini.com> 2017-1-20
			and GPL__r.GPL_Description__c not IN :outsideGPLCode
			group by Customer__r.SALES_TERRITORY_CDE__c, GPL__r.CBC2__c];

		//change to map
		for(AggregateResult forecast : forecastList){
			CustomForecast cforecast = new CustomForecast(forecast, false);
			if(forecast.get('CBC2') != null){
				CBC2ForecastMap.put((String)forecast.get('territoryCode')+';'+(String)forecast.get('CBC2'),cforecast);
			}else{
				CBC2ForecastMap.put((String)forecast.get('territoryCode')+';Other BU products',cforecast);
			}
            if((String)forecast.get('territoryCode') == 'A008869') {
                system.debug('forecastList  ::'+cforecast);
            }
		}
		
		// BEGIN added by Lei Tang<lei.tang@capgemini.com> 2017-1-20 BEGIN
		List<AggregateResult> exceptionforecastList = [select Customer__r.SALES_TERRITORY_CDE__c territoryCode,GPL__r.CBC2__c CBC2,
			sum(Current_month_2_RSM_forecast__c) lastForecast,sum(Current_month_3_RSM_forecast__c) lastForecast_1,sum(Current_month_4_RSM_forecast__c) lastForecast_2
			from apl_sales_forecast__c where Fiscal_Year__c =: fiscalYear and Fiscal_Quarter__c =: fiscalQuarter and Customer__r.SALES_TERRITORY_CDE__c in: territotyCodeSet
			and type__c in ('GPL','Other CBC2') 
			//added by Lei Tang<lei.tang@capgemini.com> 2017-1-20
			and (GPL__r.CBC2__c IN :this.outsideCBC2 and GPL__r.GPL_Description__c IN :outsideGPLCode)
			group by Customer__r.SALES_TERRITORY_CDE__c, GPL__r.CBC2__c];
		
		for(AggregateResult forecast : exceptionforecastList){
			CustomForecast cforecast = new CustomForecast(forecast, false);
			if(forecast.get('CBC2') != null){
				CustomForecast oldforecast = CBC2ForecastMap.get((String)forecast.get('territoryCode')+';Other BU products');
				if(oldforecast != null) {
					if(forecast.get('lastForecast') != null ){
						oldforecast.lastForecast = cforecast.lastForecast + oldforecast.lastForecast;
					}
					if(forecast.get('lastForecast_1') != null){
						oldforecast.lastForecast_1 = cforecast.lastForecast_1 + oldforecast.lastForecast_1;
					}
					if(forecast.get('lastForecast_2') != null){
						oldforecast.lastForecast_2 = cforecast.lastForecast_2 + oldforecast.lastForecast_2;
					}
					CBC2ForecastMap.put((String)forecast.get('territoryCode')+';Other BU products',oldforecast);
				}else {
					CBC2ForecastMap.put((String)forecast.get('territoryCode')+';Other BU products',cforecast);
				}
			}
		}
		// END added by Lei Tang<lei.tang@capgemini.com> 2017-1-20
		
		//query the forecast of relay
		List<AggregateResult> relayForecastList = [select Customer__r.SALES_TERRITORY_CDE__c territoryCode,
			sum(Current_month_2_RSM_forecast__c) lastForecast,sum(Current_month_3_RSM_forecast__c) lastForecast_1,sum(Current_month_4_RSM_forecast__c) lastForecast_2
			from apl_sales_forecast__c where Fiscal_Year__c =: fiscalYear and Fiscal_Quarter__c =: fiscalQuarter and Customer__r.SALES_TERRITORY_CDE__c in: territotyCodeSet and type__c <> 'Part'
			and type__c ='Relay Product Code' 
			//and type__c ='Relay' 
			group by Customer__r.SALES_TERRITORY_CDE__c];
		
		//change to map
		for(AggregateResult forecast : relayForecastList){
			CustomForecast cforecast = new CustomForecast(forecast, true);
			CBC2ForecastMap.put((String)forecast.get('territoryCode')+';Relay',cforecast);
		}
		
		//query the billing of non-relay
		fiscalQuarter = fiscalQuarter.replace('0','');
		List<AggregateResult> billingList = [select Customer__r.SALES_TERRITORY_CDE__c territoryCode,Part__r.Product_Hierarchy__r.CBC2__c CBC2,
				sum(Bill_Amount_USD__c) billing ,sum(Bill_Quantity__c) quantity
				from BBB_Month_Bill_Book_Cust_PN__c where Fiscal_Year__c =: fiscalYear 
				and Fiscal_Quarter__c =: fiscalQuarter and Customer__r.SALES_TERRITORY_CDE__c in: territotyCodeSet
				and Part__r.Product_Hierarchy__r.CBC2__c not in ('30005','13213')
				and Part__r.Product_Hierarchy__r.CBC3__c not in ('41553')
				//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
				//and Part__r.Product_Hierarchy__r.CBC3__c not in ('40308','40309')
				and profit_center__c = 'APL'
				//added by Lei Tang<lei.tang@capgemini.com> 2017-1-20
				//and (Part__r.Product_Hierarchy__r.CBC2__c not IN :this.outsideCBC2 and Part__r.Product_Hierarchy__r.GPL_Description__c not IN :outsideGPLCode)
				group by Customer__r.SALES_TERRITORY_CDE__c,Part__r.Product_Hierarchy__r.CBC2__c];
		
		//query the billing of relay
		List<AggregateResult> relayBillingList = [select Customer__r.SALES_TERRITORY_CDE__c territoryCode
				//Part__r.Product_Hierarchy__r.CBC2__c CBC2,Part__r.Product_Hierarchy__r.CBC3__c CBC3
				,sum(Bill_Amount_USD__c) billing ,sum(Bill_Quantity__c) quantity
				from BBB_Month_Bill_Book_Cust_PN__c where Fiscal_Year__c =: fiscalYear 
				and Fiscal_Quarter__c =: fiscalQuarter and Customer__r.SALES_TERRITORY_CDE__c in: territotyCodeSet//.Sales_Hierarchy__r.Name
				//and (Part__r.Product_Hierarchy__r.CBC2__c in ('30005','13213')
				//or Part__r.Product_Hierarchy__r.CBC3__c in ('40308','40309'))
				//update by nelson zheng 2015-10-21 for case 00900375
				//and profit_center__c = 'RPA'
				//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
				and (profit_center__c = 'APL' and (Part__r.Product_Hierarchy__r.CBC3__c in ('41553') 
					or Part__r.Product_Hierarchy__r.CBC2__c in ('30005','13213')))
				group by Customer__r.SALES_TERRITORY_CDE__c];
				
		//sum the total billing by Territory code and the CBC2 level billing
		for(AggregateResult billingResult : billingList){
			
			String territoryCode = (String)billingResult.get('territoryCode');
			String CBC2Code = (String)billingResult.get('CBC2');
			
			//total billing
			Decimal totalBilling = totalBillingMap.get(territoryCode);
			if(totalBilling == null){
				totalBilling = 0;
			}
			totalBilling += (Decimal)billingResult.get('billing');
			
			totalBillingMap.put(territoryCode,totalBilling);
			
			//total Quantity
			Decimal totalQuantity = totalQuantityMap.get(territoryCode);
			if(totalQuantity == null){
				totalQuantity = 0;
			}
			totalQuantity += (Decimal)billingResult.get('quantity');
			
			totalQuantityMap.put(territoryCode,totalQuantity);
			
			//Other CBC2
			if(aplCBC2.indexof(CBC2Code) == -1){
				CBC2Code = 'Other BU products';
			}
			
			//CBC2 billing
			Decimal cbc2Billing = CBC2billingMap.get(territoryCode+';'+CBC2Code);
			if(cbc2Billing == null){
				cbc2Billing = 0;
			}
			
			cbc2Billing += (Decimal)billingResult.get('billing');
			CBC2billingMap.put(territoryCode+';'+CBC2Code,cbc2Billing);
			
			//CBC2 Quantity
			Decimal cbc2Quantity = CBC2QuantityMap.get(territoryCode+';'+CBC2Code);
			if(cbc2Quantity == null){
				cbc2Quantity = 0;
			}
			
			cbc2Quantity += (Decimal)billingResult.get('quantity');
			CBC2QuantityMap.put(territoryCode+';'+CBC2Code,cbc2Quantity);
		}
		
		/*// BEGIN added by Lei Tang<lei.tang@capgemini.com> 2017-1-20
		List<AggregateResult> exceptionbillingList = [select Customer__r.SALES_TERRITORY_CDE__c territoryCode,Part__r.Product_Hierarchy__r.CBC2__c CBC2,
				sum(Bill_Amount_USD__c) billing ,sum(Bill_Quantity__c) quantity
				from BBB_Month_Bill_Book_Cust_PN__c where Fiscal_Year__c =: fiscalYear 
				and Fiscal_Quarter__c =: fiscalQuarter and Customer__r.SALES_TERRITORY_CDE__c in: territotyCodeSet
				and Part__r.Product_Hierarchy__r.CBC2__c not in ('30005','13213')
				and Part__r.Product_Hierarchy__r.CBC3__c not in ('40308','40309')
				and profit_center__c = 'APL'
				and (Part__r.Product_Hierarchy__r.CBC2__c IN :this.outsideCBC2 and Part__r.Product_Hierarchy__r.GPL_Description__c IN :outsideGPLCode)
				group by Customer__r.SALES_TERRITORY_CDE__c,Part__r.Product_Hierarchy__r.CBC2__c];
		for(AggregateResult billingResult : exceptionbillingList){
			
			String territoryCode = (String)billingResult.get('territoryCode');
			String CBC2Code = (String)billingResult.get('CBC2');
			
			//total billing
			Decimal totalBilling = totalBillingMap.get(territoryCode);
			if(totalBilling == null){
				totalBilling = 0;
			}
			totalBilling += (Decimal)billingResult.get('billing');
			
			totalBillingMap.put(territoryCode,totalBilling);
			
			//total Quantity
			Decimal totalQuantity = totalQuantityMap.get(territoryCode);
			if(totalQuantity == null){
				totalQuantity = 0;
			}
			totalQuantity += (Decimal)billingResult.get('quantity');
			
			totalQuantityMap.put(territoryCode,totalQuantity);
			
			//Other CBC2
			CBC2Code = 'Other BU products';

			//CBC2 billing
			Decimal cbc2Billing = CBC2billingMap.get(territoryCode+';'+CBC2Code);
			if(cbc2Billing == null){
				cbc2Billing = 0;
			}
			
			cbc2Billing += (Decimal)billingResult.get('billing');
			CBC2billingMap.put(territoryCode+';'+CBC2Code,cbc2Billing);
			
			//CBC2 Quantity
			Decimal cbc2Quantity = CBC2QuantityMap.get(territoryCode+';'+CBC2Code);
			if(cbc2Quantity == null){
				cbc2Quantity = 0;
			}
			
			cbc2Quantity += (Decimal)billingResult.get('quantity');
			CBC2QuantityMap.put(territoryCode+';'+CBC2Code,cbc2Quantity);
		}
		// END added by Lei Tang<lei.tang@capgemini.com> 2017-1-20*/
		
		
		//add relay billing and quantity
		for(AggregateResult relayBilling : relayBillingList){
			if(relayBilling.get('billing') != null && (Decimal)relayBilling.get('billing') > 0){
				String territoryCode = (String)relayBilling.get('territoryCode');
				//add to total billing and quantity
				Decimal totalBilling = totalBillingMap.get(territoryCode);
				if(totalBilling == null){
					totalBilling = 0;
				}
				totalBilling += (Decimal)relayBilling.get('billing');
					
				totalBillingMap.put(territoryCode,totalBilling);
				//total Quantity
				Decimal totalQuantity = totalQuantityMap.get(territoryCode);
				if(totalQuantity == null){
					totalQuantity = 0;
				}
				totalQuantity += (Decimal)relayBilling.get('quantity');
				totalQuantityMap.put(territoryCode,totalQuantity);
				//CBC2 level
				CBC2QuantityMap.put(territoryCode+';Relay',(Decimal)relayBilling.get('quantity'));
				CBC2billingMap.put(territoryCode+';Relay',(Decimal)relayBilling.get('billing'));
			}
		}
		
		//figure out the accuracy
		//List<CBC2Accuracy> CBC2AccuracyList = new List<CBC2Accuracy>();
		List<APL_AM_Forecast_Accuracy__c> amAccuracyList = new List<APL_AM_Forecast_Accuracy__c>();
		for(String key : CBC2billingMap.keySet()){
			String[] keyList = key.split(';');
			
			CustomForecast forecast = CBC2ForecastMap.get(key);
			if(keyList[0] == 'A008869') {
                system.debug('forecast::'+forecast);
            }
			APL_AM_Forecast_Accuracy__c amAccuracy = new APL_AM_Forecast_Accuracy__c();
			amAccuracy.Fiscal_Quarter__c = fiscalQuarter;
			amAccuracy.Fiscal_Year__c = fiscalYear;
			amAccuracy.Territory_Code__c = keyList[0];
			amAccuracy.Product_family__c = keyList[1];
			amAccuracy.Billing__c = CBC2billingMap.get(key);
			if(amAccuracy.Billing__c == null){
				amAccuracy.Billing__c = 0;
			}
			amAccuracy.Quantity__c = CBC2QuantityMap.get(key);
			if(amAccuracy.Quantity__c == null){
				amAccuracy.Quantity__c = 0;
			}
            if(keyList[0] == 'A008869') {
                system.debug(amAccuracy.Billing__c+'forecast::'+amAccuracy.Quantity__c);
            }
			if(keyList[1] <> 'Relay'){
				amAccuracy.type__c = 'Non-Relay';
				//amAccuracy.billingOrQuantity__c = CBC2billingMap.get(key);
			}else{
				amAccuracy.type__c = 'Relay';
				//amAccuracy.billingOrQuantity__c = CBC2QuantityMap.get(key);
			}
			if(forecast != null){
				if(forecast.lastForecast != null){
					amAccuracy.one_month_forecast__c = forecast.lastForecast;
				}else{
					amAccuracy.one_month_forecast__c = 0;
				}
				if(forecast.lastForecast_1 != null){
					amAccuracy.two_month_forecast__c = forecast.lastForecast_1;
				}else{
					amAccuracy.two_month_forecast__c = 0;
				}
				if(forecast.lastForecast_2 != null){
					amAccuracy.three_month_forecast__c = forecast.lastForecast_2;
				}else{
					amAccuracy.three_month_forecast__c = 0;
				}
				
				/*
				if(amAccuracy.billingOrQuantity__c == null){
					amAccuracy.billingOrQuantity__c = 0;
				}
				*/
				
				//3 month accuracy
				if(amAccuracy.three_month_forecast__c > 0 && amAccuracy.Billing__c > 0){
					amAccuracy.three_month__c = (1-(Math.abs(amAccuracy.three_month_forecast__c - amAccuracy.Billing__c)/amAccuracy.Billing__c))*100;
				}else{
					amAccuracy.three_month__c = 0;
				}
				//2 month accuracy
				if(amAccuracy.two_month_forecast__c > 0 && amAccuracy.Billing__c > 0){
					amAccuracy.two_month__c = (1-(Math.abs(amAccuracy.two_month_forecast__c - amAccuracy.Billing__c)/amAccuracy.Billing__c))*100;
				}else{
					amAccuracy.two_month__c = 0;
				}
				//1 month accuracy
				if(amAccuracy.one_month_forecast__c > 0 && amAccuracy.Billing__c > 0){
					amAccuracy.one_month__c = (1-(Math.abs(amAccuracy.one_month_forecast__c - amAccuracy.Billing__c)/amAccuracy.Billing__c))*100;
				}else{
					amAccuracy.one_month__c = 0;
				}
			}else{
				amAccuracy.one_month_forecast__c = 0;
				amAccuracy.two_month_forecast__c = 0;
				amAccuracy.three_month_forecast__c = 0;
				amAccuracy.three_month__c = 0;
				amAccuracy.two_month__c = 0;
				amAccuracy.one_month__c = 0;
			}
			amAccuracyList.add(amAccuracy);
			
		}
		//figure out the cbc2 percentage
		for(APL_AM_Forecast_Accuracy__c amAccuracy : amAccuracyList){
			if(totalBillingMap.get(amAccuracy.Territory_Code__c) > 0){
				amAccuracy.CBC2_Percentage__c = (amAccuracy.Billing__c / totalBillingMap.get(amAccuracy.Territory_Code__c)) * 100;
			}else{
				amAccuracy.CBC2_Percentage__c = 0;
			}
		}
		
		//*********** for AM end ********************//
		
		//*********** for Relay begin ********************//
		
		//query the forecast of relay
		
		Map<String,AggregateResult> CBC2RelayForecast1Map = new Map<String,AggregateResult>();//key is Territory code + 'Relay'
		
		//query the forecast of relay
		List<AggregateResult> relayForecast1List = [select Customer__r.Relay_Specialist_Territory_Code__c territoryCode,
			sum(Current_month_2_RSM_forecast__c) lastForecast,sum(Current_month_3_RSM_forecast__c) lastForecast_1,sum(Current_month_4_RSM_forecast__c) lastForecast_2
			from apl_sales_forecast__c where Fiscal_Year__c =: fiscalYear and Fiscal_Quarter__c =: '0'+fiscalQuarter and Customer__r.Relay_Specialist_Territory_Code__c in: relaySpecialistCodeSet and type__c <> 'Part'
			and type__c ='Relay Product Code' 
			group by Customer__r.Relay_Specialist_Territory_Code__c];
			
		//change to map
		for(AggregateResult forecast : relayForecast1List){
			CBC2RelayForecast1Map.put((String)forecast.get('territoryCode')+';Relay',forecast);
		}
		
		//query the billing of relay
		System.debug('----------relaySpecialistCodeSet----------'+relaySpecialistCodeSet);
		List<AggregateResult> relayBilling1List = [select Customer__r.Relay_Specialist_Territory_Code__c territoryCode
				//Part__r.Product_Hierarchy__r.CBC2__c CBC2,Part__r.Product_Hierarchy__r.CBC3__c CBC3
				,sum(Bill_Amount_USD__c) billing ,sum(Bill_Quantity__c) quantity
				from BBB_Month_Bill_Book_Cust_PN__c where Fiscal_Year__c =: fiscalYear 
				and Fiscal_Quarter__c =: fiscalQuarter and Customer__r.Relay_Specialist_Territory_Code__c in: relaySpecialistCodeSet//.Sales_Hierarchy__r.Name
				//update by nelson zheng 2015-10-21 for case 00900375
				//and profit_center__c = 'RPA'
				//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
				and (profit_center__c = 'APL' and (Part__r.Product_Hierarchy__r.CBC3__c in ('41553') or Part__r.Product_Hierarchy__r.CBC2__c in ('30005','13213')))
				group by Customer__r.Relay_Specialist_Territory_Code__c];
				
		//figure out the accuracy
		for(AggregateResult billing : relayBilling1List){
			APL_AM_Forecast_Accuracy__c amAccuracy = new APL_AM_Forecast_Accuracy__c(); 
			String key = (String)billing.get('territoryCode')+';Relay';
			AggregateResult forecast = CBC2RelayForecast1Map.get(key);
			amAccuracy.Product_family__c = 'Relay';
			amAccuracy.Fiscal_Quarter__c = fiscalQuarter;
			amAccuracy.Fiscal_Year__c = fiscalYear;
			amAccuracy.Territory_Code__c = (String)billing.get('territoryCode');
			System.debug('------------Territory_Code__c0-------------'+billing.get('territoryCode'));
			System.debug('------------Territory_Code__c-------------'+amAccuracy.Territory_Code__c);
			amAccuracy.CBC2_Percentage__c = 100;
			amAccuracy.type__c = 'Relay Specilist';
			amAccuracy.Billing__c = (Decimal)billing.get('billing');
			if(amAccuracy.Billing__c == null){
				amAccuracy.Billing__c = 0;
			}
			amAccuracy.Quantity__c = (Decimal)billing.get('quantity');
			if(forecast != null){
				
				if(forecast.get('lastForecast') != null){
					amAccuracy.one_month_forecast__c = (Decimal)forecast.get('lastForecast');
				}else{
					amAccuracy.one_month_forecast__c = 0;
				}
				if(forecast.get('lastForecast_1') != null){
					amAccuracy.two_month_forecast__c = (Decimal)forecast.get('lastForecast_1');
				}else{
					amAccuracy.two_month_forecast__c = 0;
				}
				if(forecast.get('lastForecast_2') != null){
					amAccuracy.three_month_forecast__c = (Decimal)forecast.get('lastForecast_2');
				}else{
					amAccuracy.three_month_forecast__c = 0;
				}
				
				//3 month accuracy
				if(amAccuracy.three_month_forecast__c > 0 && amAccuracy.Billing__c > 0){
					amAccuracy.three_month__c = (1-(Math.abs(amAccuracy.three_month_forecast__c - amAccuracy.Billing__c)/amAccuracy.Billing__c))*100;
				}else{
					amAccuracy.three_month__c = 0;
				}
				//2 month accuracy
				if(amAccuracy.two_month_forecast__c > 0 && amAccuracy.Billing__c > 0){
					amAccuracy.two_month__c = (1-(Math.abs(amAccuracy.two_month_forecast__c - amAccuracy.Billing__c)/amAccuracy.Billing__c))*100;
				}else{
					amAccuracy.two_month__c = 0;
				}
				//1 month accuracy
				if(amAccuracy.one_month_forecast__c > 0 && amAccuracy.Billing__c > 0){
					amAccuracy.one_month__c = (1-(Math.abs(amAccuracy.one_month_forecast__c - amAccuracy.Billing__c)/amAccuracy.Billing__c))*100;
				}else{
					amAccuracy.one_month__c = 0;
				}
				
			}else{
				amAccuracy.one_month_forecast__c = 0;
				amAccuracy.two_month_forecast__c = 0;
				amAccuracy.three_month_forecast__c = 0;
				amAccuracy.one_month__c = 0;
				amAccuracy.two_month__c = 0;
				amAccuracy.three_month__c = 0;
			}
			System.debug('------------Territory_Code__c1-------------'+amAccuracy.Territory_Code__c);
			amAccuracyList.add(amAccuracy);
				
		}
		
		//*********** for Relay end ********************//
		
		for(APL_AM_Forecast_Accuracy__c amAccuracy : amAccuracyList){
			for(APL_Forecast_Management__c am : aplAMList){
				if(am.Relay_Specialist__c == amAccuracy.Territory_Code__c || am.A6_Code__c == amAccuracy.Territory_Code__c ){
					amAccuracy.AM__c = am.Id;
					continue;
				}
			}
		}
		
		if(amAccuracyList.size() > 0){
			insert amAccuracyList;
		}
	}
	global void finish(Database.BatchableContext BC){ 
        
    }
    
    
    
    public class CustomForecast {
    	public String territoryCode {get;set;}
    	public String CBC2 {get;set;}
    	public Decimal lastForecast {get;set;}
    	public Decimal lastForecast_1 {get;set;}
    	public Decimal lastForecast_2 {get;set;}
		
		public CustomForecast(AggregateResult forecast, Boolean isRelay) {
			this.territoryCode = (String)forecast.get('territoryCode');
			this.CBC2 = '';
			if(!isRelay) {
				this.CBC2 = forecast.get('CBC2') != null ? (String)forecast.get('CBC2') : null;
			}
			this.lastForecast = (Decimal)forecast.get('lastForecast');
			this.lastForecast_1 = (Decimal)forecast.get('lastForecast_1');
			this.lastForecast_2 = (Decimal)forecast.get('lastForecast_2');
		}
    }
}