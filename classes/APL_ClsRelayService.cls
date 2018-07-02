public without sharing class APL_ClsRelayService  extends APL_Interface.AAPLCtrlService  {
	
	public class SearchLevel1 extends APL_Interface.AAPLRemoteService {

		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }
				
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
				
                if(list_beforedate.size() > 0) {
                	
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	//+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	                    	+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
				    		//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        	+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
	                System.debug('---------------APL_ClsRelayService.cls (13 matches) 1------------------');
                    APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
		                    //+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
		                    + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							//update by nelson zheng 2015-10-21 for case 00900375
							//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        	+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '\
                        	
		    				+ ' Group by Fiscal_Date__c  ' );
					 System.debug('---------------APL_ClsRelayService.cls (13 matches) 2------------------');
	                APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.grouping;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_billingrefdata.keySet()) {
                	refdata.map_billingrefdata.put(datekey, (refdata.map_billingrefdata.get(datekey) / currencyRate) );
                	refdata.map_bookingrefdata.put(datekey, (refdata.map_bookingrefdata.get(datekey) / currencyRate) );
                }
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
        
        
        /**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, sum(Backlog_Qty__c) qty, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE  Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
		                    //+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
							+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
		                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
							+ ' And Backlog_Amount_USD__c != 0 '
							//update by nelson zheng 2015-10-21 for case 00900375
							//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
                        	+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'41553\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
		    		System.debug('---------------APL_ClsRelayService.cls (13 matches) 3------------------');
	                APL_ClsUtils.setRegionMapRefData(searchOb.grouping, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.grouping;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_backlogrefdata.keySet()) {
                	refdata.map_backlogrefdata.put(datekey, (refdata.map_backlogrefdata.get(datekey) / currencyRate) );
                }

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
	}
	
	public class SearchLevel2 extends APL_Interface.AAPLRemoteService {
		
		public override void setCBC2Column(list<APL_ClsEntityType.Cbc2Object> list_cbc2column)  {
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 41553 ] CBC3 / Relays IND', '41553', 'CBC3 / Relays IND', '' ));
			//change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
			//list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 40309 ] CBC3 / Relays IB', '40309', 'CBC3 / Relays IB', '' ));
			//list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 40308 ] CBC3 / Relays A&C', '40308', 'CBC3 / Relays A&C', ''));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 30005 ] CBC2 / APPLIANCES GENERAL PURPOSE RELAYS', '30005', 'CBC2 / APPLIANCES GENERAL PURPOSE RELAYS', ''));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 13213 ] CBC2 / Automotive Relays', '13213',  'CBC2 / Automotive Relays', ''));
		}
		
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();

            list<String> list_sql = new list<String>();
        	 
        	list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, Relay_CBC2_Code__c cbc2Name, ' 
	        		+ ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, sum(Current_month_1_RSM_forecast__c) rsmFC ');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
	        	+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
		        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
		        + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Relay_CBC2_Code__c'); 
			
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            list<APL_ClsEntityType.Cbc2Object> list_cbc2column = new list<APL_ClsEntityType.Cbc2Object>();
	    	setCBC2Column(list_cbc2column);
	    	map<String, APL_ClsEntityType.Cbc2Object> map_cbcRowKey_cbcName = new map<String, APL_ClsEntityType.Cbc2Object>();
            for(APL_ClsEntityType.Cbc2Object cbc2 : list_cbc2column) {
	    		map_cbcRowKey_cbcName.put(cbc2.code, cbc2);
	    		APL_ClsEntityType.RSMAccountObj rsmcbc = new APL_ClsEntityType.RSMAccountObj();
	    		APL_ClsUtils.createRSMAccountObj(rsmcbc, searchOb.map_year_quartersFuture);
                rsmcbc.id = APL_ClsUtils.getHexUID();
	    		rsmcbc.name = cbc2.name;
	    		rsmcbc.accnumber = cbc2.code;
	    		map_acctId_acctFC.put(cbc2.code, rsmcbc);
	    	}
            
            list<String> set_tempqy = new list<String>();

			decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
            for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
	            String year = (String) result.get('year');
	            String cbcName = (String) result.get('cbc2Name');
	            String quarter = (String) result.get('quarter');
	            String dateKey = year + '_' + quarter;
	            
	            APL_ClsEntityType.RSMAccountObj rsmcbc = new APL_ClsEntityType.RSMAccountObj();
	            
	            if(!map_acctId_acctFC.containsKey(cbcName)) {
	        		APL_ClsUtils.createRSMAccountObj(rsmcbc, searchOb.map_year_quartersFuture);
	                rsmcbc.id = APL_ClsUtils.getHexUID();
		            rsmcbc.name = map_cbcRowKey_cbcName.get(cbcName).name;
					rsmcbc.accnumber = map_cbcRowKey_cbcName.get(cbcName).code;
		            map_acctId_acctFC.put(cbcName, rsmcbc);
				}else {
					rsmcbc = map_acctId_acctFC.get(cbcName);
				}
				
	            rsmcbc.map_type_FC.get('csFC').put(dateKey, (result.get('amFC') != null ? ((decimal)result.get('amFC') / currencyRate) : 0));
				rsmcbc.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmFC') != null ? ((decimal)result.get('rsmFC') / currencyRate) : 0));
				rsmcbc.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? ((decimal)result.get('prevFC') / currencyRate ) : 0));
	            map_acctId_acctFC.put(cbcName, rsmcbc);
	        }
            
            list_accFC.addAll(map_acctId_acctFC.values());
			system.debug('@#list_accFC : '+list_accFC);
            return Json.serialize(list_accFC);
		}
		
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }
				
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
				
                if(list_beforedate.size() > 0) {
                	
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	                    	+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
	                System.debug('---------------APL_ClsRelayService.cls (13 matches) 4------------------');
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
		                    + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
		    				+ ' Group by Fiscal_Date__c  ' );
					System.debug('---------------APL_ClsRelayService.cls (13 matches) 5------------------');
	                APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_billingrefdata.keySet()) {
                	refdata.map_billingrefdata.put(datekey, (refdata.map_billingrefdata.get(datekey) / currencyRate) );
                	refdata.map_bookingrefdata.put(datekey, (refdata.map_bookingrefdata.get(datekey) / currencyRate) );
                }
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount,sum(Backlog_Qty__c) qty,  Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE  Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
							+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
		                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
							+ ' And Backlog_Amount_USD__c != 0 '
							//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
		    		System.debug('---------------APL_ClsRelayService.cls (13 matches) 6------------------');
	                APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_backlogrefdata.keySet()) {
                	refdata.map_backlogrefdata.put(datekey, (refdata.map_backlogrefdata.get(datekey) / currencyRate) );
                }

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
		
	}
	
	public class SearchLevel3 extends APL_Interface.AAPLRemoteService {
		
		public override String saveSObjectData(String sData) { 
            try {
                APL_ClsEntityType.APLForecastValueObj valueobj = (APL_ClsEntityType.APLForecastValueObj)JSON.deserialize(sData,APL_ClsEntityType.APLForecastValueObj.class);
                system.debug('@#valueobj : '+valueobj);
				map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
        		map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();   
        		map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc 
            				= new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
                
				list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
		        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
		        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
                
                
                ClsAPLServiceRSMRelay.getProductCodePercentForSave(valueobj.grouping, valueobj.cbc2Code, valueobj.territoryCode, '',
                              map_acctId_avgPercent, map_partId_map_acctId_partPercent);
                APL_ClsUtils.getExistingProductCodeFC(valueobj.grouping, valueobj.cbc2Code, valueobj.territoryCode, '',
                            valueobj.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
                
                APL_ClsUtils.generateProductFC(valueobj, map_partId_map_acctId_partPercent, map_partId_map_acctId_map_dateKey_fc, map_acctId_avgPercent,APL_ClsUtils.RELAYPRODUCTCODEFCTYPE, APL_ClsUtils.AMFCTYPE,
                       list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);             
		        system.debug('Part list_acctFC2Insert :: ' + list_acctFC2Insert);
		        system.debug('list_acctFC2Update:::: '+list_acctFC2Update);
		        //INSERT, UPDATE, DELETE APL Forecasts
		        ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
				return 'true';
			}catch(Exception ex) {
                throw ex;
            }
        }
        
        
        public override String deleteAPLObject(String sData) { 
            APL_ClsEntityType.SearchObj valueobj = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#valueobj : '+valueobj);
            list<APL_Sales_Forecast__c> list_aplFC = new list<APL_Sales_Forecast__c>();
		    String query = ' Select Id From APL_Sales_Forecast__c WHERE Id != null ';
		    query += ClsGroupingRelayForecastUtil.getForecastParentFilter(valueobj.grouping, valueobj.territoryCode, false);
		    //query += ' And Part__c = \'' + valueobj.partId + '\'';
		    query += ' And (PRODUCT_CDE__c = \'' + valueobj.accnumber + '\' or Part__r.PRODUCT_CDE__c = \'' + valueobj.accnumber + '\') ';
		    query += ' And (Relay_CBC2_Code__c = \''+valueobj.cbc2Code+'\' ';
		    query += ' or ' + APL_ClsUtils.getRelayCBCFilter(valueobj.cbc2Code) +') ';
		    query += ' And Type__c IN (\'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\',\''+APL_ClsUtils.RELAYFCTYPE+'\') ';
		    query += ' And Customer__r.STATDESC__c = \'Active\' ';   
		    query += ClsAPLForecastUtil.getMonthFilter(valueobj.map_year_quartersFuture);
		    system.debug('@#query : '+query);
		    try {
		        for(APL_Sales_Forecast__c fc : database.query(query)) {
		            list_aplFC.add(fc);
		        }
		        if(!list_aplFC.isEmpty()) {
		            delete list_aplFC;
		        }
		        return 'true';
		    }
		    catch(Exception ex) {
		        return 'false';
		    }

               
        }
		
		
        public override String getSearchResult(String sData){
            
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            
            list<APL_ClsEntityType.RSMAccountObj> list_parts = new list<APL_ClsEntityType.RSMAccountObj>();

	        //only get current fc to check if this part has forecast
	        /*map<String, set<String>> map_year_quartersFuture = new map<String, set<String>>();
	        String currentYearQuart = ClsAPLForecastUtil.getCurrentYearQuart();
	        String year = currentYearQuart.substringBefore('_');
	        String quarter = currentYearQuart.substringAfter('_');
	        system.debug('currentYearQuart :: ' + currentYearQuart);
	        map_year_quartersFuture.put(year, new set<String>{quarter});
	        
	        system.debug('set_newAddedpartIds:::'+searchOb.set_selectedId);
	         */         
            set<String> set_existPartIds = new set<String>();
            //filter part ids for already added parts
            if(!searchOb.set_selectedId.isEmpty()) {
                set_existPartIds.addAll(searchOb.set_selectedId);
            }
            //String existPartIdQuery = APL_ClsUtils.getHasForecastProdectCodeQuery(searchOb.grouping, searchOb.cbc2Code, searchOb.territoryCode, map_year_quartersFuture, false);
    		
            //ClsGroupingRelayForecastUtil.setExistPartIds(set_existPartIds, existPartIdQuery);
            //system.debug('existPartIdQuery :: ' + existPartIdQuery);
            //set_existPartIds = new set<String>();
            String query = ' Select PRODUCT_CDE__c prodcode, PROD_NAME__c prodname ';
	        query += ' FROM Part__c ';
	        query += ' WHERE Id != null ';        
	        query += ClsGroupingRelayForecastUtil.getRelayPartSearchQueryFilter(searchOb.cbc2Code, false);
	        query += (searchOb.searchKey != null ? ' And (PRODUCT_CDE__c like \'%' + searchOb.searchKey + '%\' or PROD_NAME__c like \'%' + searchOb.searchKey + '%\' )' : '');
	        query += (set_existPartIds.isEmpty() ? '' : ' And PRODUCT_CDE__c NOT IN :set_existPartIds ');
	        query += ' And PRODUCT_CDE__c != null ';
	        query += ' group by PRODUCT_CDE__c, PROD_NAME__c limit 200';
            
            for(AggregateResult part : database.query(query)) {
	            APL_ClsEntityType.RSMAccountObj partObj = new APL_ClsEntityType.RSMAccountObj();
                APL_ClsUtils.createRSMRelayPartObj(partObj, searchOb.map_year_quartersFuture);
                partObj.id = APL_ClsUtils.getHexUID();
	            partObj.name = (String) part.get('prodname');
				partObj.accnumber = (String) part.get('prodcode');
	            partObj.price = 0;
	            list_parts.add(partObj);
	        }
			system.debug('@#list_parts:'+list_parts);
            return JSON.serialize(list_parts);
        }
		
		
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sql = new list<String>();
        	  
        	list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, PRODUCT_CDE__c procode, PROD_NAME__c proname, ' 
	        		+ ' sum(Quantity__c) quantity, sum(Current_month_1_quantity__c) preQuantity, sum(Current_month_1_RSM_quantity__c) rsmQuantity ');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
		        //+ ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.cbc2Code, true)
		        + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		        + ' And Relay_CBC2_Code__c = \''+searchOb.cbc2Code+'\''
		        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
		        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
		        + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, PRODUCT_CDE__c, PROD_NAME__c'); 
			
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            list<String> set_tempqy = new list<String>();
            
            String pricePlaces = APL_ClsUtils.getPricePlaces();
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.map_acctId_currencyIso.get(searchOb.grouping), 'USD');
			decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('procode'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
				if(set_tempqy.size() == 0) {
					set_tempqy.add(year);
					set_tempqy.add(quarter);
				}
				 
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMRelayPartObj(acctFC, searchOb.map_year_quartersFuture);
	        		acctFC.id = APL_ClsUtils.getHexUID();
		            acctFC.name = (String) result.get('proname');
					acctFC.accnumber = accId;
					acctFC.isHighLighted = false;
					acctFC.price = 0;
					
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
				
	            //acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? ((decimal)result.get('fc') / currencyRate) : 0));
				acctFC.map_type_FC.get('quantity').put(dateKey, (result.get('quantity') != null ? (decimal)result.get('quantity') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('preQuantity') != null ? (decimal)result.get('preQuantity') : 0));
				acctFC.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmQuantity') != null ? (decimal)result.get('rsmQuantity') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
            }
            system.debug('@#set_tempqy : '+set_tempqy);
			if(set_tempqy.size() > 1){

	            list_sql.clear();
	            list_sql.add(' PRODUCT_CDE__c , Price__c, CurrencyIsoCode');
		        list_sql.add(' APL_Sales_Forecast__c ');
		        list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
			        + ' And Relay_CBC2_Code__c = \''+searchOb.cbc2Code+'\''
			        + ' And Fiscal_Year__c = \''+set_tempqy.get(0)+'\' '
			        + ' And Fiscal_Quarter__c = \''+set_tempqy.get(1)+'\' '
			        + ' And PRODUCT_CDE__c != null '
			        + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
			        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' ' );
				system.debug('@#list_sql : '+APL_ClsUtils.getQueryString(list_sql));
				for(APL_Sales_Forecast__c result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
					String accId = result.PRODUCT_CDE__c;
					decimal currencyRatePrice = ClsAPLForecastUtil.transformIsoCode(1, result.CurrencyIsoCode, searchOb.currencyIso);
					if(map_acctId_acctFC.containsKey(accId)) {
						decimal price = (result.Price__c == null ? 0 : result.Price__c * currencyRatePrice);
						map_acctId_acctFC.get(accId).price = price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
					}
				}
			}
			
			APL_ClsUtils.setHighlight(searchOb, APL_ClsUtils.RELAYFCTYPE, APL_ClsUtils.AMFCTYPE, map_acctId_acctFC);
			
            list_accFC.addAll(map_acctId_acctFC.values());
			system.debug('@#list_accFC : '+list_accFC);
            return Json.serialize(list_accFC);
		}
		
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }
				
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
				
                if(list_beforedate.size() > 0) {
                	
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	                    	+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
	                System.debug('---------------APL_ClsRelayService.cls (13 matches) 7------------------');
                    APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
		                    + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
		    				+ ' Group by Fiscal_Date__c  ' );
					System.debug('---------------APL_ClsRelayService.cls (13 matches) 8------------------');
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                system.debug('@#refdata:'+refdata);
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_billingrefdata.keySet()) {
                	refdata.map_billingrefdata.put(datekey, (refdata.map_billingrefdata.get(datekey) / currencyRate) );
                	refdata.map_bookingrefdata.put(datekey, (refdata.map_bookingrefdata.get(datekey) / currencyRate) );
                }
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount,sum(Backlog_Qty__c) qty,  Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE  Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
							+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
		                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
							+ ' And Backlog_Amount_USD__c != 0 '
							//update by nelson zheng 2015-10-21 for case 00900375
                        	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
		    				System.debug('---------------APL_ClsRelayService.cls (13 matches) 9------------------');
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_backlogrefdata.keySet()) {
                	refdata.map_backlogrefdata.put(datekey, (refdata.map_backlogrefdata.get(datekey) / currencyRate) );
                }

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
		
	}
	
	public class SearchLevel4 extends APL_Interface.AAPLRemoteService {
		
		public override String saveSObjectData(String sData) { 
            try {
                APL_ClsEntityType.APLForecastValueObj valueobj = (APL_ClsEntityType.APLForecastValueObj)JSON.deserialize(sData,APL_ClsEntityType.APLForecastValueObj.class);
                system.debug('@#valueobj : '+valueobj);
				map<String, map<String, decimal>> map_partId_map_acctId_partPercent = new map<String, map<String, decimal>>();
        		map<String, decimal> map_acctId_avgPercent = new map<String, decimal>();   
        		map<String, map<String, map<String, APL_Sales_Forecast__c>>> map_partId_map_acctId_map_dateKey_fc 
            				= new map<String, map<String, map<String, APL_Sales_Forecast__c>>>();
                
				list<APL_Sales_Forecast__c> list_acctFC2Insert = new list<APL_Sales_Forecast__c>();
		        list<APL_Sales_Forecast__c> list_acctFC2Update = new list<APL_Sales_Forecast__c>();
		        list<APL_Sales_Forecast__c> list_acctFC2Delete = new list<APL_Sales_Forecast__c>();
                
                
                ClsAPLServiceRSMRelay.getPartPercentForSave(valueobj.grouping, valueobj.cbc2Code, valueobj.territoryCode, '',
                              map_acctId_avgPercent, map_partId_map_acctId_partPercent);
                              
                APL_ClsUtils.getExistingPartFC(valueobj.grouping, valueobj.cbc2Code, valueobj.territoryCode, '',
                            valueobj.map_year_quartersFuture, map_partId_map_acctId_map_dateKey_fc);
                
               	APL_ClsUtils.generateProductFC(valueobj, map_partId_map_acctId_partPercent, map_partId_map_acctId_map_dateKey_fc, map_acctId_avgPercent,APL_ClsUtils.RELAYFCTYPE, APL_ClsUtils.AMFCTYPE,
                       list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);             
		        system.debug('Part list_acctFC2Insert :: ' + list_acctFC2Insert);
		        system.debug('list_acctFC2Update:::: '+list_acctFC2Update);
		        //INSERT, UPDATE, DELETE APL Forecasts
		        ClsAPLForecastUtil.aplFCRecordsDML(list_acctFC2Insert, list_acctFC2Update, list_acctFC2Delete);
				return 'true';
			}catch(Exception ex) {
                throw ex;
            }
        }
		
		public override String deleteAPLObject(String sData) { 
            APL_ClsEntityType.SearchObj valueobj = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#valueobj : '+valueobj);
            list<APL_Sales_Forecast__c> list_aplFC = new list<APL_Sales_Forecast__c>();
		    String query = ' Select Id From APL_Sales_Forecast__c WHERE Id != null ';
		    query += ClsGroupingRelayForecastUtil.getForecastParentFilter(valueobj.grouping, valueobj.territoryCode, false);
		    query += ' And Part__c = \'' + valueobj.partId + '\'';
		    query += ' And ' + APL_ClsUtils.getRelayCBCFilter(valueobj.cbc2Code);
		    query += ' And Type__c = \''+APL_ClsUtils.RELAYFCTYPE+'\' ';
		    query += ' And Customer__r.STATDESC__c = \'Active\' ';   
		    query += ClsAPLForecastUtil.getMonthFilter(valueobj.map_year_quartersFuture);
		    system.debug('@#query : '+query);
		    try {
		        for(APL_Sales_Forecast__c fc : database.query(query)) {
		            list_aplFC.add(fc);
		        }
		        if(!list_aplFC.isEmpty()) {
		            delete list_aplFC;
		        }
		        return 'true';
		    }
		    catch(Exception ex) {
		        return 'false';
		    }

               
        }
		
		
		public override String getSearchResult(String sData){
            
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            if(searchOb.isOtherMethod != null && searchOb.isOtherMethod) {
                return getSearchResultForTop(searchOb);
            }
            
            list<APL_ClsEntityType.RSMAccountObj> list_parts = new list<APL_ClsEntityType.RSMAccountObj>();
   			
            set<String> set_existPartIds = new set<String>();
            //filter part ids for already added parts
            if(!searchOb.set_selectedId.isEmpty()) {
                set_existPartIds.addAll(searchOb.set_selectedId);
            }
            
            //String existPartIdQuery = APL_ClsUtils.getHasForecastProdectCodeQuery(searchOb.grouping, searchOb.cbc2Code, searchOb.territoryCode, map_year_quartersFuture, false);
    		
            //ClsGroupingRelayForecastUtil.setExistPartIds(set_existPartIds, existPartIdQuery);
            //system.debug('existPartIdQuery :: ' + existPartIdQuery);
            //set_existPartIds = new set<String>();

            String query = ' Select Id, Name, Description__c, Product_Hierarchy__c ';
	        query += ' FROM Part__c ';
	        query += ' WHERE Id != null ';        
	        query += ClsGroupingRelayForecastUtil.getRelayPartSearchQueryFilter(searchOb.cbc2Code, false);
	        query += (searchOb.searchKey != null ? ' And name like \'%' + searchOb.searchKey + '%\' ' : '');
	        query += ' And PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' ';
	        query += (set_existPartIds.isEmpty() ? '' : ' And Id not in: set_existPartIds ');
	        query += ' limit 200 ';

            for(Part__c part : database.query(query)) {
	            APL_ClsEntityType.RSMAccountObj partObj = new APL_ClsEntityType.RSMAccountObj();
                APL_ClsUtils.createRSMRelayPartObj(partObj, searchOb.map_year_quartersFuture);
                partObj.id = part.Id;
	            partObj.name = part.Name;
				partObj.accnumber = part.Product_Hierarchy__c;
				partObj.snumber = part.Description__c;
	            partObj.price = 0;
	            list_parts.add(partObj);
	        }

            return JSON.serialize(list_parts);
        }
		
		private String getSearchResultForTop(APL_ClsEntityType.SearchObj searchOb) {
			
			list<APL_ClsEntityType.RSMPartObj> list_parts = new list<APL_ClsEntityType.RSMPartObj>();
			set<String> set_existPartIds = new set<String>();
            //filter part ids for already added parts
            if(!searchOb.set_selectedId.isEmpty()) {
                set_existPartIds.addAll(searchOb.set_selectedId);
            }
			
			decimal allValue = 0;
			map<String, decimal> map_partId_billPercent = new map<String, decimal>();
	        map<String, decimal> map_partId_amount = new map<String, decimal>();
	        // get the query for Part level begin 
	        String query = ' select SUM(Bill_Amount_current_prior__c) amount, Part__c key, Part__r.Product_Hierarchy__c gplId '
	                     + ' From BBB_Year_Bill_Book_Cust_PN__c '
	                     + ' Where Id != null '
	                     + ' And Bill_Amount_current_prior__c != null And Bill_Amount_current_prior__c != 0 ' 
	                     //update by nelson zheng 2015-10-21 for case 00900375
                         //+' AND (BU_Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                         //+' And BU_Profit_Center__c = \'RPA\'  '
                         +' And BU_Profit_Center__c = \'APL\'  '
	                     + (!set_existPartIds.isEmpty() ? ' And Part__c not in : set_existPartIds ' : '');
	        query += ' And Customer__r.STATDESC__c = \'Active\' ';   
	        query += ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false);
	        query += ' And Part__r.Product_Hierarchy__r.' + ClsGroupingRelayForecastUtil.getRelayField(searchOb.cbc2Code) + ' = \'' + searchOb.cbc2Code + '\' ';
	        query += ' group by Part__c, Part__r.Product_Hierarchy__c ';
	        System.debug('---------------APL_ClsRelayService.cls (13 matches) 10------------------');
	        // end
	        //system.debug('query::: '+query);
	        // get the part to the amount begin
	        for(AggregateResult  result : database.query(query)) {
	            decimal amount = (decimal) (result.get('amount') == null ? 0 : result.get('amount'));
	            allValue += amount;                                     
	            map_partId_amount.put((String)result.get('key'), amount); 
	        }
	        //system.debug('map_partId_amount::: '+map_partId_amount);
	        //system.debug('allValue::: '+allValue);
	        // get the Percent for Part level begin
	        //setBillPercent(allValue, map_partId_amount, map_partId_billPercent);
	        for(String key : map_partId_amount.keySet()) {
	            Decimal rate = (allValue == 0 ? 0 : (map_partId_amount.get(key) / allValue));
	            rate = rate.setScale(4, System.Roundingmode.HALF_UP);
	            map_partId_billPercent.put(key, rate);
	        }
			
			set<String> set_isTopPartIds = new set<String>();
			set_isTopPartIds.addAll(map_partId_billPercent.keySet());
			
			String queryTop = ' Select Id, Name, Description__c, Product_Hierarchy__c ';
	        queryTop += ' FROM Part__c ';
	        queryTop += ' WHERE Id IN: set_isTopPartIds ';        
	        queryTop += ClsGroupingRelayForecastUtil.getRelayPartSearchQueryFilter(searchOb.cbc2Code, false);
	        queryTop += (searchOb.searchKey != null ? ' And name like \'%' + searchOb.searchKey + '%\' ' : '');
	        queryTop += ' And PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' ';
	        queryTop += (set_existPartIds.isEmpty() ? '' : ' And Id not in: set_existPartIds ');

            for(Part__c part : database.query(queryTop)) {
	            APL_ClsEntityType.RSMPartObj partObj = new APL_ClsEntityType.RSMPartObj();
                APL_ClsUtils.createSearchRSMRelayPartObj(partObj, searchOb.map_year_quartersFuture);
                partObj.id = part.Id;
	            partObj.name = part.Name;
				partObj.accnumber = part.Product_Hierarchy__c;
				partObj.snumber = part.Description__c;
	            partObj.price = 0;
	            partObj.precent = map_partId_billPercent.get(part.Id);
	            list_parts.add(partObj);
	        }
			list_parts.sort();
			list<APL_ClsEntityType.RSMPartObj> list_TopParts = new list<APL_ClsEntityType.RSMPartObj>();
			
			for(Integer m = 0; m < list_parts.size(); m++) {
	            list_TopParts.add(list_parts[m]);
	            if(m == 4) {
	            	break;
	            }
	        }
            return JSON.serialize(list_TopParts);
			
		}
		
		
		
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sql = new list<String>();

        	list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, Part__c partId, Part__r.Product_Hierarchy__c gplId, Part__r.Description__c partDesc, Part__r.Name partName, ' 
	        		+ ' sum(Quantity__c) quantity, sum(Forecast__c) fc, sum(Current_month_1_quantity__c) preQuantity, sum(Current_month_1_RSM_quantity__c) rsmQuantity ');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
		        + ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.cbc2Code, true)
		        + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
		        + ' And Type__c = \'' + ClsGroupingRelayForecastUtil.RELAYFCTYPE + '\' ' 
		        + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
		        + ' Group by Part__c, Fiscal_Year__c, Fiscal_Quarter__c, Part__r.Product_Hierarchy__c, Part__r.Description__c, Part__r.Name'); 
			system.debug('@#list_sql : '+APL_ClsUtils.getQueryString(list_sql));
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            list<String> set_tempqy = new list<String>();
            
            String pricePlaces = APL_ClsUtils.getPricePlaces();
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.map_acctId_currencyIso.get(searchOb.grouping), 'USD');
			decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('partId'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
				if(set_tempqy.size() == 0) {
					set_tempqy.add(year);
					set_tempqy.add(quarter);
				}
				 
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMRelayPartObj(acctFC, searchOb.map_year_quartersFuture);
	        		acctFC.id = accId;
		            acctFC.name = (String) result.get('partName');
					acctFC.accnumber = (String) result.get('gplId');
					acctFC.snumber = (String) result.get('partDesc');
					acctFC.price = 0;
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
				
	            //acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? ((decimal)result.get('fc') / currencyRate) : 0));
				acctFC.map_type_FC.get('quantity').put(dateKey, (result.get('quantity') != null ? (decimal)result.get('quantity') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('preQuantity') != null ? (decimal)result.get('preQuantity') : 0));
				acctFC.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmQuantity') != null ? (decimal)result.get('rsmQuantity') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
            }
            
			if(set_tempqy.size() > 1){

	            list_sql.clear();
	            list_sql.add(' Part__c , Price__c, CurrencyIsoCode');
		        list_sql.add(' APL_Sales_Forecast__c ');
			    list_sql.add(' WHERE Customer__r.STATDESC__c = \'Active\' '
			        + ClsAPLServiceRSMRelay.getRelayPartSearchQueryFilter(searchOb.cbc2Code, true)
			        + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
			        + ' And Type__c = \'' + ClsGroupingRelayForecastUtil.RELAYFCTYPE + '\' ' 
			        + ' And Part__r.PRODUCT_CDE__c = \'' + searchOb.accnumber + '\' '
			        + ' And Fiscal_Year__c = \''+set_tempqy.get(0)+'\' '
			        + ' And Fiscal_Quarter__c = \''+set_tempqy.get(1)+'\' ');
	
				for(APL_Sales_Forecast__c result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
					String accId = result.Part__c;
					decimal currencyRatePrice = ClsAPLForecastUtil.transformIsoCode(1, result.CurrencyIsoCode, searchOb.currencyIso);
					if(map_acctId_acctFC.containsKey(accId)) {
						decimal price = (result.Price__c == null ? 0 : result.Price__c * currencyRatePrice);
						map_acctId_acctFC.get(accId).price = price.setScale((pricePlaces == '' ? 3 : Integer.valueOf(pricePlaces)));
					}
				}
			}
			
            list_accFC.addAll(map_acctId_acctFC.values());

            return Json.serialize(list_accFC);
		}
		
		/**
         *  This function is used get all reference data list.
         *  
         * @author Juillet Yuan
         * @created 2014-10-29
         * @version 1.0
         * @since 31.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Juillet Yuan <Juillet.yuan@itbconsult.com>
         * - Created
         *
         */
        public override String getRefData(String sData) { 
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData,APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);

		            if(refdate < currentdate) {
						list_beforedate.add(refdate);
					}else if(refdate >= currentdate) {
						list_currentdate.add(refdate);
					}
		        }
				
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
				
                if(list_beforedate.size() > 0) {
                	
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Quantity__c) billQty, sum(Book_Quantity__c) bookQty, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
	                    	+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And Part__c = \'' + searchOb.partId + '\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	                    	+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		//update by nelson zheng 2015-10-21 for case 00900375
                         	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
	                        System.debug('---------------APL_ClsRelayService.cls (13 matches) 11------------------');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, sum(Bill_Qty__c) billQty, sum(Book_Qty__c) bookQty, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ ' And Part__c = \'' + searchOb.partId + '\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
		                    + ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							//update by nelson zheng 2015-10-21 for case 00900375
                         	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
		    				+ ' Group by Fiscal_Date__c  ' );
					System.debug('---------------APL_ClsRelayService.cls (13 matches) 12-----------------');
	                APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_billingrefdata.keySet()) {
                	refdata.map_billingrefdata.put(datekey, (refdata.map_billingrefdata.get(datekey) / currencyRate) );
                	refdata.map_bookingrefdata.put(datekey, (refdata.map_bookingrefdata.get(datekey) / currencyRate) );
                }
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
		/**
         *  This function is used get backlog reference data list.
         *  
         * @author Lei Tang
         * @created 2015-03-10
         * @version 1.0
         * @since 30.0 (Force.com ApiVersion)  
         * 
         *
         * @changelog
         * 2014-10-29 Lei Tang <lei.tang@itbconsult.com>
         * - Created
         *
         */
        public override String getBacklogRefData(String sData) {
            try {
                APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb:'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                for(String datekey : searchOb.set_fiscalMonth) {
		            String year = datekey.substring(0, datekey.indexOf('_'));
		            String month = datekey.substring(datekey.indexOf('_')+1, datekey.length());
		            Date refdate = Date.newInstance(Integer.valueOf(year), Integer.valueOf(month), 15);
	
					list_futruedate.add(refdate);
		        }

                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
                    //before
                    set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    APL_ClsUtils.setRefForecastDate(years, months, list_futruedate);

                    list<String> list_sql = new list<String>();
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount,sum(Backlog_Qty__c) qty,  Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE  Customer__r.APL_Relay_forecast_Plan_Account__c = \'' +  searchOb.grouping + '\' '
							+ ' And Customer__r.STATDESC__c = \'Active\' '
							+ ' And Part__c = \'' + searchOb.partId + '\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
							+ ClsGroupingRelayForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
		    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
		                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
							+ ' And Backlog_Amount_USD__c != 0 '
							//update by nelson zheng 2015-10-21 for case 00900375
                         	//+' AND (Profit_Center__c = \'APL\' and (Part__r.Product_Hierarchy__r.CBC3__c in (\'40308\',\'40309\') or Part__r.Product_Hierarchy__r.CBC2__c in (\'30005\',\'13213\'))) '
                        	//+ ' And Profit_Center__c = \'RPA\'  '
                        	+ ' And Profit_Center__c = \'APL\'  '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
		    			System.debug('---------------APL_ClsRelayService.cls (13 matches) 13-----------------');
	                APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRelayRefObj refdata = APL_ClsUtils.createRelayRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRelayRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                 
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_backlogrefdata.keySet()) {
                	refdata.map_backlogrefdata.put(datekey, (refdata.map_backlogrefdata.get(datekey) / currencyRate) );
                }

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
	}
}