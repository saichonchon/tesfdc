public without sharing class APL_ClsGAMService  extends APL_Interface.AAPLCtrlService  {
	
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__r.Territory_L2_code__c = \''+ searchOb.region +'\' '
                    		+ ' And Customer__r.RecordType.DeveloperName != \'Grouped Accounts\' '
                    		+ ' And Customer__r.GAMCD__c IN :set_soldtoIds '
                    		+ ' And Customer__r.STATDESC__c = \'Active\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.region, years, months, searchOb.set_gamCodes, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__r.Territory_L2_code__c = \''+ searchOb.region +'\' '
                    		+ ' And Customer__r.RecordType.DeveloperName != \'Grouped Accounts\' '
                    		+ ' And Customer__r.GAMCD__c IN :set_soldtoIds '
                    		+ ' And Customer__r.STATDESC__c = \'Active\' '
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.region, years, months, searchOb.set_gamCodes, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.region;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                
                
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__r.Territory_L2_code__c = \''+ searchOb.region +'\' '
							+ ' And Customer__r.RecordType.DeveloperName != \'Grouped Accounts\' '
                    		+ ' And Customer__r.GAMCD__c IN :set_soldtoIds '
                    		+ ' And Customer__r.STATDESC__c = \'Active\' '
		    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
		                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
							+ ' And Backlog_Amount_USD__c != 0 '
							+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.region, years, months, searchOb.set_gamCodes, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.region;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
	}
	
	public class SearchLevel2 extends APL_Interface.AAPLRemoteService {

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
				
				//set<String> set_acctIds = new set<String>();
				//ClsAPLForecastUtil.setAccountIds(true, searchOb.grouping, searchOb.territoryCode, set_acctIds);
				
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
	                    	+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		                    + ' Group by Fiscal_Date__c ' );
                    APL_ClsUtils.setRegionMapRefData(searchOb.soldtoId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
		                    + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.soldtoId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.soldtoId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);

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
				
				//set<String> set_acctIds = new set<String>();
				//ClsAPLForecastUtil.setAccountIds(true, searchOb.grouping, searchOb.territoryCode, set_acctIds);
				
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
    				list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
		                    + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                        + ' And Customer_Request_Date_Fiscal_Month__c IN : months '
		                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		                    + ' And Backlog_Amount_USD__c != 0 '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.soldtoId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.soldtoId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
		
	}
	
	public class SearchLevel3 extends APL_Interface.AAPLRemoteService {

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
				
				//set<String> set_acctIds = new set<String>();
				//ClsAPLForecastUtil.setAccountIds(true, searchOb.grouping, searchOb.territoryCode, set_acctIds);
				
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
		                    + ((searchOb.cbc2Code != APL_ClsUtils.CBCOTHER && searchOb.cbc2Code != APL_ClsUtils.CBCRELAY) 
	                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
	                    	+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And Profit_Center__c = \'APL\' ' : ' And Profit_Center__c IN (\'APL\', \'RPA\') ')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' ' : '')
		                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		                    + ' Group by Fiscal_Date__c ' );
                    APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
		                    + ((searchOb.cbc2Code != APL_ClsUtils.CBCOTHER && searchOb.cbc2Code != APL_ClsUtils.CBCRELAY) 
		                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
		                    + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And Profit_Center__c = \'APL\' ' : ' And Profit_Center__c IN (\'APL\', \'RPA\') ')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' ' : '')
		                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);

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
				
				//set<String> set_acctIds = new set<String>();
				//ClsAPLForecastUtil.setAccountIds(true, searchOb.grouping, searchOb.territoryCode, set_acctIds);
				
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
    				list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
		                    + ((searchOb.cbc2Code != APL_ClsUtils.CBCOTHER && searchOb.cbc2Code != APL_ClsUtils.CBCRELAY) 
		                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
		                    + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                        + ' And Customer_Request_Date_Fiscal_Month__c IN : months '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And Profit_Center__c = \'APL\' ' : ' And Profit_Center__c IN (\'APL\', \'RPA\') ')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' ' : '')
		                    + ' And Backlog_Amount_USD__c != 0 '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.cbc2Code, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.cbc2Code;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
		
	}
	
	//Relay Level4
	public class SearchLevel4 extends APL_Interface.AAPLRemoteService {
		
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            //if(searchOb.cbc2Code == 'Relay') {
        	getRelayExistResult(searchOb, list_accFC);
        	return Json.serialize(list_accFC);
            //}
			
			/*
            list<String> list_sql = new list<String>();
			
	    	map<String, String> map_prodHichyId_gplCode = new map<String, String>();
	    	map<String, String> map_gplId_gplName = new map<String, String>();
			map<String, ClsAPLEntityTypes.GPLFCValueObj> map_gplId_gplFC 
				= new map<String, ClsAPLEntityTypes.GPLFCValueObj>();
			//set gpl code & gpl name map
	        ClsAPLForecastUtil.setGPLCode(map_prodHichyId_gplCode, searchOb.cbc2Code, map_gplId_gplName);
        	system.debug('@#map_prodHichyId_gplCode:'+map_prodHichyId_gplCode);
        	list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
        	
	        //get query string for gpl forecast
	    	list_sql.add(' Fiscal_Year__c year, GPL__c gplId, sum(Current_month_1_RSM_forecast__c) rsmFC, ' 
					+ ' sum(Forecast__c) amFC, sum(Current_month_1_forecast__c) prevFC, Fiscal_Quarter__c quarter ');
			list_sql.add(' APL_Sales_Forecast__c ');
			list_sql.add(' WHERE Customer__r.APL_AM_forecast_Plan_Account__c = ' 
					+ (searchOb.grouping == APL_ClsUtils.OTHERACCTID ? ' null ' : '\'' +  searchOb.grouping + '\' ') 
					//+ ' And Customer__r.APL_RSM_Display_Name__c = ' + (searchOb.rsmgrouping == APL_ClsUtils.OTHER ? ' null ' : '\'' +  searchOb.rsmgrouping + '\' ')
					+ ' And Type__c = \'' + ClsAPLForecastUtil.GPLFCTYPE + '\' '
					+ ClsGroupingAMForecastUtil.getForecastParentFilter(searchOb.grouping, searchOb.territoryCode, false)
					+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
					+ (searchOb.cbc2Code == ClsAPLForecastUtil.CBCRELAY ? ClsAPLForecastUtil.getRelayGPLQuery(false) : ' And GPL__r.CBC2__c =\'' + searchOb.cbc2Code + '\' ')
					+ ' And Customer__r.STATDESC__c = \'Active\' '
					//+ ' And Customer__r.SALES_TERRITORY_CDE__c IN :set_rsmAMTerritoryCodes '
					+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c, GPL__c ');
            
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            for(String gplId : map_gplId_gplName.keySet()) {
        		APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
        		acctFC.id = gplId;
        		acctFC.accnumber = map_prodHichyId_gplCode.get(gplId);
                acctFC.name = '[ ' + acctFC.accnumber + ' ] - ' + map_gplId_gplName.get(gplId);
                map_acctId_acctFC.put(gplId, acctFC);
                
        	}
            
            decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
            
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('gplId'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
					   
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = accId;
		            acctFC.accnumber = map_prodHichyId_gplCode.get(accId);
                	acctFC.name = '[ ' + acctFC.accnumber + ' ] - ' + map_gplId_gplName.get(accId);
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('amFC') != null ? ((decimal)result.get('amFC') / currencyRate) : 0));
				acctFC.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmFC') != null ? ((decimal)result.get('rsmFC') / currencyRate) : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? ((decimal)result.get('prevFC') / currencyRate) : 0));
	            map_acctId_acctFC.put(accId, acctFC);
					   
            }
            
            list_accFC.addAll(map_acctId_acctFC.values());
            
            return Json.serialize(list_accFC);
            */
		}
		
		
		private void getRelayExistResult(APL_ClsEntityType.SearchObj searchOb, list<APL_ClsEntityType.RSMAccountObj> list_accFC) {
			//list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
			
			list<String> list_sortedRelayCBC = ClsAPLForecastUtil.getSortedRelayCBCKey();
	        list<String> list_sql = new list<String>();
			system.debug('@#list_sortedRelayCBC:'+list_sortedRelayCBC);
	        //get query string for gpl forecast
	    	list_sql.add(' Fiscal_Year__c year,Fiscal_Quarter__c quarter,  ' 
						+ ' sum(GAM_Forecast__c) fc, sum(Current_month_1_GAM_forecast__c) prefc, sum(Current_month_1_RSM_forecast__c) rsmfc, '
						+ ' Relay_CBC2_Code__c cbc2Name');
			list_sql.add(' APL_Sales_Forecast__c ');
			list_sql.add(' WHERE Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '
						+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
						+ APL_ClsUtils.getRelayCBC2CodeQuery() 
						+ ' And Customer__c = \'' + searchOb.soldtoId + '\' '
						+ ' Group by Fiscal_Year__c, Fiscal_Quarter__c, Relay_CBC2_Code__c ');
						
			map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
			
			for(String cbcKey : list_sortedRelayCBC) {
        		APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
        		acctFC.id = APL_ClsUtils.getHexUID();
        		acctFC.name = ' [ '+cbcKey+' ] - ' + ClsAPLForecastUtil.map_RELAY_CBCCode_CBCDESC.get(cbcKey);
            	acctFC.accnumber = cbcKey;
            	
                map_acctId_acctFC.put(cbcKey, acctFC);
                
        	}
        	system.debug('@#list_sql : '+ClsAPLForecastUtil.getQueryString(list_sql));
        	//decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
        	for(AggregateResult  result : Database.query(ClsAPLForecastUtil.getQueryString(list_sql))) {
	            String year = (String) result.get('year');
	            String cbcKeyName = (String) result.get('cbc2Name');
	            String quarter = (String) result.get('quarter');
	            String dateKey = year + '_' + quarter;
	            
	            APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(cbcKeyName)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = cbcKeyName;
		            acctFC.name = ' [ '+cbcKeyName+' ] - ' + ClsAPLForecastUtil.map_RELAY_CBCCode_CBCDESC.get(cbcKeyName);
					acctFC.accnumber = cbcKeyName;
		            map_acctId_acctFC.put(cbcKeyName, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(cbcKeyName);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prefc') != null ? (decimal)result.get('prefc') : 0));
				acctFC.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmfc') != null ? (decimal)result.get('rsmfc') : 0));
				
	            map_acctId_acctFC.put(cbcKeyName, acctFC);
	        }
        	system.debug('@#map_acctId_acctFC:'+map_acctId_acctFC);
			list_accFC.addAll(map_acctId_acctFC.values());		
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
                if(searchOb.cbc2Code != 'Relay') {
                	return getGPLRefData(sData);
                }
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.accnumber)
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c = \'RPA\'  '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
							+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.accnumber)
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							+ ' And Profit_Center__c = \'RPA\'  '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
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
        private String getGPLRefData(String sData) { 
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
				
				//set<String> set_acctIds = new set<String>();
				//ClsAPLForecastUtil.setAccountIds(true, searchOb.grouping, searchOb.territoryCode, set_acctIds);
				
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
		                    + ((searchOb.cbc2Code != APL_ClsUtils.CBCOTHER && searchOb.cbc2Code != APL_ClsUtils.CBCRELAY) 
	                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
	                        + ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\''
	                    	+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		                    + ' Group by Fiscal_Date__c ' );
                    APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
		                    + ((searchOb.cbc2Code != APL_ClsUtils.CBCOTHER && searchOb.cbc2Code != APL_ClsUtils.CBCRELAY) 
		                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
		                    //+ ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\''                
		                    + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
		                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.gplId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                /*
                decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                for(String datekey : refdata.map_billingrefdata.keySet()) {
                	refdata.map_billingrefdata.put(datekey, (refdata.map_billingrefdata.get(datekey) / currencyRate) );
                	refdata.map_bookingrefdata.put(datekey, (refdata.map_bookingrefdata.get(datekey) / currencyRate) );
                }*/
                
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
                if(searchOb.cbc2Code != 'Relay') {
                	return getGPLBacklogRefData(sData);
                }
                
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
							+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.accnumber)
		    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
		                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
							+ ' And Backlog_Amount_USD__c != 0 '
							+ ' And Profit_Center__c = \'RPA\'  '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);

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
        private String getGPLBacklogRefData(String sData) {
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
				
				//set<String> set_acctIds = new set<String>();
				//ClsAPLForecastUtil.setAccountIds(true, searchOb.grouping, searchOb.territoryCode, set_acctIds);
				
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
    				list_sql.add(' WHERE Customer__c = \''+ searchOb.soldtoId +'\' '
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCOTHER ? ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '') : '')
		                    + (searchOb.cbc2Code == APL_ClsUtils.CBCRELAY ? ClsAPLForecastUtil.getRelayPartQuery() : '')
		                    + ((searchOb.cbc2Code != APL_ClsUtils.CBCOTHER && searchOb.cbc2Code != APL_ClsUtils.CBCRELAY) 
		                                    ? 'And Part__r.Product_Hierarchy__r.CBC2__c = \'' + searchOb.cbc2Code +'\'' : '')
		                    + ' And Part__r.Product_Hierarchy__c = \'' + searchOb.gplId + '\''
		                    + ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                        + ' And Customer_Request_Date_Fiscal_Month__c IN : months '
		                    + ' And Profit_Center__c IN (\'APL\', \'RPA\') '
		                    + ' And Backlog_Amount_USD__c != 0 '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.gplId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.gplId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
	}
	
	public class SearchLevel5 extends APL_Interface.AAPLRemoteService {
		
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
            
            list<String> list_sql = new list<String>();
        	
        	list_sql.add(' Fiscal_Year__c year, Fiscal_Quarter__c quarter, PRODUCT_CDE__c procode, PROD_NAME__c proname, ' 
	        		+ ' sum(GAM_Forecast__c) fc, sum(Current_month_1_GAM_forecast__c) prefc, sum(Current_month_1_RSM_forecast__c) rsmfc ');
	        list_sql.add(' APL_Sales_Forecast__c ');
	        list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
		        + ' And Relay_CBC2_Code__c = \''+searchOb.cbc2Code+'\''
		        + ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
		        + ' And Type__c = \'' + APL_ClsUtils.RELAYPRODUCTCODEFCTYPE + '\' '  
		        + ' Group by Fiscal_Year__c, Fiscal_Quarter__c, PRODUCT_CDE__c, PROD_NAME__c'); 
			
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            list<String> set_tempqy = new list<String>();
            
            String pricePlaces = APL_ClsUtils.getPricePlaces();
            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.map_acctId_currencyIso.get(searchOb.grouping), 'USD');
			//decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
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
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	        		acctFC.id = APL_ClsUtils.getHexUID();
		            acctFC.name = (String) result.get('proname');
					acctFC.accnumber = accId;
					acctFC.price = 0;
					acctFC.isHighLighted = false;
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
				
	            //acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? ((decimal)result.get('fc') / currencyRate) : 0));
				acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc'): 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prefc') != null ? (decimal)result.get('prefc') : 0));
				acctFC.map_type_FC.get('rsmFC').put(dateKey, (result.get('rsmfc') != null ? (decimal)result.get('rsmfc') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
            }
			
			/*
			APL_ClsEntityType.RSMAccountObj acctFC1 = new APL_ClsEntityType.RSMAccountObj();
            APL_ClsUtils.createRSMAccountObj(acctFC1, searchOb.map_year_quartersFuture);
    		acctFC1.id = APL_ClsUtils.getHexUID();
            acctFC1.name = '[ 302 ] - Other:Other acc';
			acctFC1.accnumber = '302';
			acctFC1.price = 0;
			acctFC1.isHighLighted = false;
            map_acctId_acctFC.put('302', acctFC1);
            
            APL_ClsEntityType.RSMAccountObj acctFC2 = new APL_ClsEntityType.RSMAccountObj();
            APL_ClsUtils.createRSMAccountObj(acctFC2, searchOb.map_year_quartersFuture);
    		acctFC2.id = APL_ClsUtils.getHexUID();
            acctFC2.name = '[ 452 ] - Kevin Test';
			acctFC2.accnumber = '452';
			acctFC2.price = 0;
			acctFC2.isHighLighted = true;
            map_acctId_acctFC.put('452', acctFC2);
			*/
			APL_ClsUtils.setHighlight(searchOb, APL_ClsUtils.RELAYFCTYPE, APL_ClsUtils.GAMFCTYPE, map_acctId_acctFC);
			
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
	                    	+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
	                    	+ ' And Part__r.PRODUCT_CDE__c = \''+searchOb.accnumber+'\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');

                    APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	            	list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
		                    + ' And Part__r.PRODUCT_CDE__c = \''+searchOb.accnumber+'\' '
		    				+ ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
							+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
							+ ' And Profit_Center__c = \'RPA\'  '
		    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                //for(String datekey : refdata.map_billingrefdata.keySet()) {
                //	refdata.map_billingrefdata.put(datekey, (refdata.map_billingrefdata.get(datekey) / currencyRate) );
                //	refdata.map_bookingrefdata.put(datekey, (refdata.map_bookingrefdata.get(datekey) / currencyRate) );
                //}
                
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE  Customer__c = \'' + searchOb.soldtoId + '\' '
		                    + ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
		                    + ' And Part__r.PRODUCT_CDE__c = \''+searchOb.accnumber+'\' '
		    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
		                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
							+ ' And Backlog_Amount_USD__c != 0 '
							+ ' And Profit_Center__c = \'RPA\'  '
		    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, searchOb.currencyIso, 'USD');
                
                //for(String datekey : refdata.map_billingrefdata.keySet()) {
                //	refdata.map_backlogrefdata.put(datekey, (refdata.map_backlogrefdata.get(datekey) / currencyRate) );
                //}

                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
	}
	
	public class SearchLevel6 extends APL_Interface.AAPLRemoteService {
		
		public override String getExistResult(String sData){
			APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();

            list<String> list_sql = new list<String>();
        
	        //get query string for gpl forecast
	    	list_sql.add(' Fiscal_Year__c year, sum(RSM_Forecast__c) fc, Part__c partId, Part__r.Description__c partDesc, ' 		//, sum(POS_Forecast__c) posFC, sum(CMA_Forecast__c) cmaFC
					+ 'Part__r.Name partName, sum(GAM_Forecast__c) amFC, sum(Current_month_1_GAM_forecast__c) prevFC, Fiscal_Quarter__c quarter');
						
			list_sql.add(' APL_Sales_Forecast__c ');
			list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
					+ ' And Part__c != null '
					+ ' And Type__c = \'' + APL_ClsUtils.RELAYFCTYPE + '\' '  
					+ ClsAPLForecastUtil.getMonthFilter(searchOb.map_year_quartersFuture)
					+ ClsAPLForecastUtil.getRelayCBCFilter(searchOb.cbc2Code)
					+ ' And Part__r.PRODUCT_CDE__c = \''+searchOb.accnumber+'\' '
					+ ' Group by Part__c, Part__r.Name, Part__r.Description__c, Fiscal_Year__c, Fiscal_Quarter__c ');
	        
            map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
            
            for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('partId'),
	    			   year = (String) result.get('year'),
					   quarter = (String) result.get('quarter'), 
					   dateKey = (year + '_' + quarter);
					   
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            //decimal currencyRate = ClsAPLForecastUtil.transformIsoCode(1, (String) result.get('currency'), 'USD');
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMAccountObj(acctFC, searchOb.map_year_quartersFuture);
	                acctFC.id = accId;
		            acctFC.name = (String) result.get('partName');
					acctFC.accnumber = (String) result.get('partDesc');
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.map_type_FC.get('csFC').put(dateKey, (result.get('fc') != null ? (decimal)result.get('fc') : 0));
				//acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.map_type_FC.get('pmFC').put(dateKey, (result.get('prevFC') != null ? (decimal)result.get('prevFC') : 0));
	            map_acctId_acctFC.put(accId, acctFC);
					   
            }
            /*
            APL_ClsEntityType.RSMAccountObj acctFC1 = new APL_ClsEntityType.RSMAccountObj();
            APL_ClsUtils.createRSMAccountObj(acctFC1, searchOb.map_year_quartersFuture);
    		acctFC1.id = 'a0Hc0000006NdG7';
            acctFC1.name = '170004-1';
			acctFC1.accnumber = 'a0Fc00000021KNe';
			acctFC1.snumber = 'SPLICE';
			acctFC1.price = 12;
            map_acctId_acctFC.put(acctFC1.id, acctFC1);
            
            APL_ClsEntityType.RSMAccountObj acctFC2 = new APL_ClsEntityType.RSMAccountObj();
            APL_ClsUtils.createRSMAccountObj(acctFC2, searchOb.map_year_quartersFuture);
    		acctFC2.id = 'a0Hc0000006NdG8';
            acctFC2.name = '141080-1';
			acctFC2.accnumber = 'a0Fc00000021KTR';
			acctFC2.snumber = 'Z-PACK Stripline 100';
			acctFC2.price = 14;
            map_acctId_acctFC.put(acctFC2.id, acctFC2);
            */
            
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
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
	                    	+ ' And Part__c = \'' + searchOb.partId + '\' '
	                    	+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0) '
				    		+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	                        + ' And Fiscal_Year__c IN : years '
	                        + ' And Fiscal_Month__c IN : months '
	                        + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	                list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
						+ ' And Part__c = \'' + searchOb.partId + '\' '
	    				+ ' And Fiscal_Year__c IN : years '
	                    + ' And Fiscal_Month__c  IN : months '
						+ ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0)  '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Fiscal_Date__c  ' );
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' WHERE Customer__c = \'' + searchOb.soldtoId + '\' '
	    				+ ' And Part__c = \'' + searchOb.partId + '\' '
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c IN (\'APL\', \'RPA\') '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.partId, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.partId;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }
		
	}
	
	public class SearchLevelOther extends APL_Interface.AAPLRemoteService {
		
		
		public override String getExistResult(String sData){
            APL_ClsEntityType.SearchObj searchOb = (APL_ClsEntityType.SearchObj)JSON.deserialize(sData, APL_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb:'+searchOb);
            integer maxmonths = 1;
            for(APL_Forecast_Settings__c setting : [select Id, Value__c from APL_Forecast_Settings__c where Name = 'Search Other BU Billing Months']) {
            	if(setting.Value__c != null) {
            		try{
            			maxmonths = Integer.valueOf(setting.Value__c);
            		}catch(Exception ex) { }
            	}
            }
            maxmonths = 0 - maxmonths;
            
			list<Date> list_beforedate = new list<Date>();
            Date currentDate = APL_ClsUtils.getCurrentFiscalDate().addMonths(-1);
            for(integer i = 0; i > maxmonths; i--) {
            	Date tempdate = currentDate.addMonths(i);
            	list_beforedate.add(tempdate);
            }
            
            set<String> years = new set<String>();
            set<Integer> months = new set<Integer>();
            
            APL_ClsUtils.setRefForecastDate(years, months, list_beforedate);

            /*set<String> set_acctIds = new set<String>();
            ClsAPLForecastUtil.setAccountIds(true, searchOb.grouping, searchOb.territoryCode, set_acctIds);
            */                                  
	        list<String> list_sql = new list<String>();
	        
	        list_sql.add(' Part__r.Product_Hierarchy__r.CBC1__c cbc1Code, Part__r.Product_Hierarchy__r.CBC1_Description__c cbc1disc  ');
	        list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
	        list_sql.add(' Where Customer__c = \'' + searchOb.soldtoId + '\' '
	                    + ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '')
	                    + ' And Fiscal_Year__c IN : years '
	                    + ' And Fiscal_Month__c IN : months '
	                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
	                    + ' And Profit_Center__c = \'APL\' '
	                    + ' And Part__r.Product_Hierarchy__r.CBC1__c != \'30007\' '
	                    + ' Group by Part__r.Product_Hierarchy__r.CBC1__c, Part__r.Product_Hierarchy__r.CBC1_Description__c  ' );
	        
            
			map<String, APL_ClsEntityType.RSMAccountObj> map_acctId_acctFC = new map<String, APL_ClsEntityType.RSMAccountObj>();
			for(AggregateResult result : Database.query(APL_ClsUtils.getQueryString(list_sql))) {
	    		String accId = (String) result.get('cbc1Code');
	    		String cbc1 = (String) result.get('cbc1disc');
				if(cbc1.contains('Appliance') || cbc1.contains('APL')) {
					continue;
				}
				APL_ClsEntityType.RSMAccountObj acctFC = new APL_ClsEntityType.RSMAccountObj();
	            
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		APL_ClsUtils.createRSMRelayAccountObj(acctFC, searchOb.map_year_quartersFuture);
	        		acctFC.id = APL_ClsUtils.getHexUID();
		            acctFC.name = '[ '+accId  + ' ] - ' + (String) result.get('cbc1disc');
					acctFC.accnumber = accId;
					acctFC.price = 0;
		            map_acctId_acctFC.put(accId, acctFC);
	            }
            }
            /*
            APL_ClsEntityType.RSMAccountObj acctFC1 = new APL_ClsEntityType.RSMAccountObj();
            APL_ClsUtils.createRSMRelayAccountObj(acctFC1, searchOb.map_year_quartersFuture);
    		acctFC1.id = 'a0Hc0000006NdG7';
            acctFC1.name = '[ 10011 ] - Application Tooling';
			acctFC1.accnumber = '10011';
			acctFC1.price = 0;
            map_acctId_acctFC.put('10011', acctFC1);
            
            APL_ClsEntityType.RSMAccountObj acctFC2 = new APL_ClsEntityType.RSMAccountObj();
            APL_ClsUtils.createRSMRelayAccountObj(acctFC2, searchOb.map_year_quartersFuture);
    		acctFC2.id = 'a0Hc0000006NdG8';
            acctFC2.name = '[ 13003 ] - Telecom LTE';
			acctFC2.accnumber = '13003';
			acctFC2.price = 0;
            map_acctId_acctFC.put('13003', acctFC2);
            */
			list<APL_ClsEntityType.RSMAccountObj> list_accFC = new list<APL_ClsEntityType.RSMAccountObj>();
			list_accFC.addAll(map_acctId_acctFC.values());
	    	system.debug('@#list_accFC:'+list_accFC);
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
                Date currentdate = APL_ClsUtils.getCurrentFiscalDate();
                
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_currentdate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
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
                    
                    list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
                    list_sql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
                    list_sql.add(' Where Customer__c = \'' + searchOb.soldtoId + '\' '
	                    + ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '')
	                    + ' And Part__r.Product_Hierarchy__r.CBC1__c = \'' + searchOb.accnumber + '\' '
	                    + ' And Fiscal_Year__c IN : years '
	                    + ' And Fiscal_Month__c IN : months '
	                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
	                    + ' And Profit_Center__c = \'APL\' '
	                    + ' Group by Fiscal_Date__c ');
                    APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
                }
                
                if(list_currentdate.size() > 0) {
	                //current
	                set<String> years = new set<String>();
	                set<Integer> months = new set<Integer>();
	                    
	                APL_ClsUtils.setRefForecastDate(years, months, list_currentdate);
	
	                list<String> list_sql = new list<String>();
	                    
	                list_sql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
	                list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
	               	list_sql.add(' Where Customer__c = \'' + searchOb.soldtoId + '\' '
	                    + ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '')
	                    + ' And Part__r.Product_Hierarchy__r.CBC1__c = \'' + searchOb.accnumber + '\' '
	                    + ' And Fiscal_Year__c IN : years '
	                    + ' And Fiscal_Month__c IN : months '
	                    + ' And (Bill_Amount_USD__c != 0 OR Book_Amount_USD__c != 0 ) '
	                    + ' And Profit_Center__c = \'APL\' '
	                    + ' Group by Fiscal_Date__c ');
	
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_before);
	            }
                list_beforedate.addALl(list_currentdate);
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
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
                    
                    list_sql.add(' sum(Backlog_Amount_USD__c) amount, Customer_Request_Date_Fiscal_Date__c refdate ');
    				list_sql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c ');
					list_sql.add(' Where Customer__c = \'' + searchOb.soldtoId + '\' '
	                    + ' And ' + ClsAPLForecastUtil.getOtherPartQuery().replace('And  Type__c = \'Part\'', '')
						+ ' And Part__r.Product_Hierarchy__r.CBC1__c = \'' + searchOb.accnumber + '\' '
	    				+ ' And Customer_Request_Date_Fiscal_Year__c IN : years '
	                    + ' And Customer_Request_Date_Fiscal_Month__c  IN : months '
						+ ' And Backlog_Amount_USD__c != 0 '
						+ ' And Profit_Center__c = \'APL\' '
	    				+ ' Group by Customer_Request_Date_Fiscal_Date__c  ' );
	                APL_ClsUtils.setRegionMapRefData(searchOb.accnumber, years, months, null, list_sql, map_acctId_map_dateKey_result_futrue);
                }
                
                APL_ClsEntityType.APLRefObj refdata = APL_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                APL_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
            
        }

	}
	
}