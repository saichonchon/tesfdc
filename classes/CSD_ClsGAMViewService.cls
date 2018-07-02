/**
 *  This class is CSD GAM View Service.
 *  
 * @author Jinbo Shan
 * @created 2014-10-23
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-10-23 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created
 *
 */
public without sharing class CSD_ClsGAMViewService extends CSD_Interface.ACSDCtrlService {
 

	/**
	 *  This class is get Soldto level data.
	 *  
	 * @author Lei Tang
	 * @created 2014-10-28
	 * @version 1.0
	 * @since 30.0 (Force.com ApiVersion)  
	 * 
	 *
	 * @changelog
	 * 2014-10-28 Lei Tang <lei.tang@itbconsult.com>
	 * - Created
	 *
	*/
	public override void setLevel1Data(list<Object> list_data, Object config) {
		
		CSD_ClsEntityType.PageConfig pageconf = (CSD_ClsEntityType.PageConfig)config;
		
		set<String> set_oemIds = new set<String>();
		CSD_ClsUtils.setGAMOEMCompetence('Sales Leader', set_oemIds);
		//string stringDate = pageconf.currentYear + '-' + String.valueOf(pageconf.currentMonth) + '-1';
		Date currentdate = Date.valueOf(pageconf.refStartDate);
        Date enddate = Date.valueOf(pageconf.refEndDate);
        system.debug('current date = ' + currentdate + '; enddate = ' + enddate);
        list<String> list_sql = new list<String>();
        list_sql.add('OEM__c oem, OEM__r.Name accname, Fiscal_Year__c year, Fiscal_Month__c month, '
        		+ 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC, sum(Rest_Parts_Forecast__c) restPNFC');
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
        			+ ' And OEM__c in :set_oemIds ' 
        			+ ' And Fiscal_Date__c >= :currentdate '
                    + ' And Fiscal_Date__c < :enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');
		 
        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
		
		CSD_ClsUtils.setGAMViewAccountObjMap(map_acctId_acctFC, pageconf, list_sql, set_oemIds, currentdate, enddate);
        
        
        list<String> list_taiwansql = new list<String>();
	        		
		list_taiwansql.add(' OEM__c oem, Sold_To_Number__c soldto ');
        list_taiwansql.add(' CSD_Sales_Forecast__c ');
        list_taiwansql.add(' WHERE Type__c = \'OEM\' '
        			+ ' And OEM__c in :set_oemIds  '
                    + ' And Billing_Region__c = \'TAIWAN\' ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '	                    
                    + ' Group by OEM__c, Sold_To_Number__c ');
        set<String> set_taiwanoems = new set<String>();
        set<String> set_taiwansoldtos = new set<String>();
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_taiwansql))) {
        	set_taiwanoems.add((String)result.get('oem'));
        	set_taiwansoldtos.add((String)result.get('soldto'));
        }
         
        list_sql.add(2, ' WHERE Type__c = \'Part\' And Billing_Region__c = \'TAIWAN\'  '
        			+ ' And OEM__c in :set_oemIds ' 
        			+ ' And Fiscal_Date__c >= :currentdate '
                    + ' And Fiscal_Date__c < :enddate '
                    + ' And Sold_To_Number__c NOT IN :set_taiwansoldtos '
                    + ' And OEM__c NOT IN :set_taiwanoems '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');

		for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
        	//system.debug('@#result : '+result);
            String accId = (String)result.get('oem'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
        	if(!map_acctId_acctFC.containsKey(accId)) {
        		CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
        		CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
        		
	            acctFC.id = accId;
	            acctFC.name = (String)result.get('accname');
				
				acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
				acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
	            //acctFC.restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') : 0));
	            map_acctId_acctFC.put(accId, acctFC);     

			}else {
				map_acctId_acctFC.get(accId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') + map_acctId_acctFC.get(accId).csFC.get(dateKey) : map_acctId_acctFC.get(accId).csFC.get(dateKey)));
				map_acctId_acctFC.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') + map_acctId_acctFC.get(accId).dcFC.get(dateKey) : map_acctId_acctFC.get(accId).dcFC.get(dateKey)));
				map_acctId_acctFC.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') + map_acctId_acctFC.get(accId).pmFC.get(dateKey) : map_acctId_acctFC.get(accId).pmFC.get(dateKey)));
	            //map_acctId_acctFC.get(accId).restPNFC.put(dateKey, (result.get('restPNFC') != null ? (decimal)result.get('restPNFC') + map_acctId_acctFC.get(accId).restPNFC.get(dateKey) : map_acctId_acctFC.get(accId).restPNFC.get(dateKey)));
			}        
        }
		
		setChannelForecastLevel1(pageconf,  map_acctId_acctFC);
		
		system.debug('@#map_acctId_acctFC:'+map_acctId_acctFC.get('OEM01'));
        list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
        if(map_acctId_acctFC.size() > 0) {
	        list_accFc.addAll(map_acctId_acctFC.values());
	        list_accFc.sort();
	        for(Integer i = 0; i < list_accFc.size(); i++) {
	        	list_data.add(list_accFc.get(i));
	        }
        }
	}
	
	public override String setChannelForecast(Object config){
		CSD_ClsEntityType.PageConfig pageconf = (CSD_ClsEntityType.PageConfig)config;
		
		map<String, Object> map_oems = new map<String, Object>();
		
		CSD_ClsEntityType.AccountObj total=new CSD_ClsEntityType.AccountObj();
		total.id = CSD_ClsUtils.getHexUID();
		total.name = 'Total';
		total.type = 'total';
		
		/*CSD_ClsEntityType.AccountObj nonchannel=new CSD_ClsEntityType.AccountObj();
		nonchannel.id = CSD_ClsUtils.getHexUID();
		nonchannel.name = 'Non - Channel';
		nonchannel.type = 'nontotalchannel';
		
		CSD_ClsEntityType.AccountObj channel=new CSD_ClsEntityType.AccountObj();
		channel.id = CSD_ClsUtils.getHexUID();
		channel.name = 'Channel';
		channel.type = 'totalchannel';
		*/
		map_oems.put('total', total);
		//map_oems.put('nontotalchannel', nonchannel);
		//map_oems.put('totalchannel', channel);
		
		map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
		
		//setChannelForecastLevel1(pageconf, map_acctId_acctFC);
	    map_oems.put('channel', map_acctId_acctFC.values());
        
        return Json.serialize(map_oems);
	}
    
    private void setChannelForecastLevel1(CSD_ClsEntityType.PageConfig pageconf, 
										map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC){
		set<String> set_oemIds = new set<String>();
		CSD_ClsUtils.setGAMOEMCompetence('Sales Leader', set_oemIds);
		
		Date currentdate = Date.valueOf(pageconf.refStartDate);
        Date enddate = Date.valueOf(pageconf.refEndDate);
											
		list<String> list_sql = new list<String>();
		list_sql.add(' OEM__c oem, OEM__r.Name accname, ' 
	        			+ ' Fiscal_Year__c year, Fiscal_Month__c month, '
	               		+ ' sum(Forecast__c) sumFC  ');
        list_sql.add(' CSD_Channel_Forecast__c ');
        list_sql.add(' WHERE OEM__c IN :set_oemIds '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');
		for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('oem'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                   
            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
    
            if(!map_acctId_acctFC.containsKey(accId)) {
                CSD_ClsUtils.createAccountObj(acctFC, pageconf.map_financialMonth);
                
                acctFC.id = accId;
                acctFC.name = (String)result.get('accname');
				acctFC.type = 'channel';
        		
                map_acctId_acctFC.put(accId, acctFC);
            }else {
                acctFC = map_acctId_acctFC.get(accId);
            }

			acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') + acctFC.csFC.get(dateKey) : acctFC.csFC.get(dateKey)));
            //acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
            //acctFC.dcFC.put(dateKey, 0);
            //acctFC.pmFC.put(dateKey, 0);
            //acctFC.restPNFC.put(dateKey, 0);
            map_acctId_acctFC.put(accId, acctFC);            
        }
		
	}
	
	
	public class SearchLevel1 extends CSD_Interface.ACSDRemoteService{
	
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
				CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
				
				list<Date> list_beforedate = new list<Date>();
		    	list<Date> list_futruedate = new list<Date>();
		    	
		    	CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
		    	
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
			        		new map<String, map<String, AggregateResult>>();
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
		        		new map<String, map<String, AggregateResult>>();

		        if(list_beforedate.size() > 0) {
		        	//before   
		        	set<String> years = new set<String>();
		        	set<Integer> months = new set<Integer>();
		        	
		        	CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
		        	 	
		        	set<String> set_monthIds = new set<String>();
		    		for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
		    														from CSD_OEM_Mapping_Monthly_BBB__c 
		    														where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
		    															and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
		    															and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
		    			set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
		    		}
		        	
		        	
			        list<String> list_beforesql = new list<String>();
					list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
			     	list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
			     	list_beforesql.add(' WHERE Id IN :set_monthids '
			                + ' Group by Fiscal_Date__c ');
			        CSD_ClsUtils.setGAMOEMMapRefData(searchOb.oemId, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
			        
		        }
		        
		        CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
		        refdata.id = searchOb.oemId;
		        
		        CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
                
               	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
                            new map<String, map<String, AggregateResult>>();
                map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
                        new map<String, map<String, AggregateResult>>();
                
                if(list_futruedate.size() > 0) {
		    		//futrue
		    		set<String> years = new set<String>();
		        	set<Integer> months = new set<Integer>();
		        	
		        	CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
		    		
		    		set<String> set_dailyIds = new set<String>();
		    		for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
		    														from CSD_OEM_Mapping_Daily_BBB__c 
		    														where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
		    															and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
		    			set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
		    		}

		    		list<String> list_futruesql = new list<String>();
					list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
			     	list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c	 ');
			     	list_futruesql.add(' WHERE Id IN :set_monthids '
			            + ' Group by Fiscal_Date__c ');		
			        CSD_ClsUtils.setGAMOEMMapRefData(searchOb.oemId, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
		    	}

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.oemId;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
	} 
	
	
	
	public class SearchLevel2 extends CSD_Interface.ACSDRemoteService {

		
		public override String getExistResult(String sData) {
			CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
			system.debug('@#searchOb'+searchOb);	
			
			Date currentdate = Date.valueOf(searchOb.startDate);
	        Date enddate = Date.valueOf(searchOb.endDate);
			
			list<String> list_sql = new list<String>();
			list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
			if(searchOb.type == 'channel'){
	        	setChannelForecast(currentdate, enddate, searchOb, list_sql, list_accFc);
				return JSON.serialize(list_accFc);
	        }
			
			String typename = 'OEM';
			list_sql.add(' Billing_Region__c region, Fiscal_Year__c year, Fiscal_Month__c month, '
					+ ' sum(Forecast__c) sumFC,'
					+ ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
                    
        	list_sql.add(' CSD_Sales_Forecast__c ');
        	list_sql.add(' WHERE OEM__c = \''+ searchOb.oemId +'\' '
        			+ ' And Type__c IN (\'OEM\',\'Non-OEMs\') '
        			+ ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    
                    + ' Group by Billing_Region__c, Fiscal_Year__c, Fiscal_Month__c  ');
			
			map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
	        
	        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	        	//system.debug('@#result : '+result);
	            String accId = ((String)result.get('region')).toUpperCase(), 
	                   year = (String)result.get('year'),
	                   month = (String)result.get('month'), 
	                   dateKey = (year + '_' + month);
	            
	            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
	
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
		            Blob aes = Crypto.generateAesKey(128);
	                String hex = EncodingUtil.convertToHex(aes);
	                acctFC.id = hex;
		            acctFC.name = accId;
	
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
				acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
	            map_acctId_acctFC.put(accId, acctFC);       
   
	            
	        }
	        
	        list<String> list_taiwansql = new list<String>();
	        		
    		list_taiwansql.add(' OEM__c oem, Sold_To_Number__c soldto ');
	        list_taiwansql.add(' CSD_Sales_Forecast__c ');
	        list_taiwansql.add(' WHERE Type__c = \'OEM\' '
	        			+ ' And OEM__c = \''+ searchOb.oemId +'\' '
	                    + ' And Billing_Region__c = \'TAIWAN\' ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '	                    
	                    + ' Group by OEM__c, Sold_To_Number__c ');
	        //set<String> set_taiwanoems = new set<String>();
	        set<String> set_taiwansoldtos = new set<String>();
	        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_taiwansql))) {
	        	//set_taiwanoems.add((String)result.get('oem'));
	        	set_taiwansoldtos.add((String)result.get('soldto'));
	        }
	        
	        
	        typename = 'Part';
	        list_sql.add(2, ' WHERE OEM__c = \''+ searchOb.oemId +'\' '
        			+ ' And Type__c = \''+typename+'\' '
        			+ ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' And Billing_Region__c = \'TAIWAN\' '
                    + ' And Sold_To_Number__c NOT IN :set_taiwansoldtos '
                    + ' Group by Billing_Region__c, Fiscal_Year__c, Fiscal_Month__c  ');
	        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	        	//system.debug('@#result : '+result);
	            String accId = ((String)result.get('region')).toUpperCase(), 
	                   year = (String)result.get('year'),
	                   month = (String)result.get('month'), 
	                   dateKey = (year + '_' + month);
	                   
	            if(!map_acctId_acctFC.containsKey(accId)) {
	            	CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
	            	CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
	        		Blob aes = Crypto.generateAesKey(128);
		            String hex = EncodingUtil.convertToHex(aes);
		            acctFC.id = hex;
		            acctFC.name = accId;
		            map_acctId_acctFC.put(accId, acctFC);       
		            if(!map_acctId_acctFC.get(accId).csFC.containsKey(dateKey)) {
						continue;
					}
		            acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
					acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
					acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
					
	            }else {
	            	if(!map_acctId_acctFC.get(accId).csFC.containsKey(dateKey)) {
						continue;
					}
	            	map_acctId_acctFC.get(accId).csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') + map_acctId_acctFC.get(accId).csFC.get(dateKey) : map_acctId_acctFC.get(accId).csFC.get(dateKey)));
					map_acctId_acctFC.get(accId).dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') + map_acctId_acctFC.get(accId).dcFC.get(dateKey) : map_acctId_acctFC.get(accId).dcFC.get(dateKey)));
					map_acctId_acctFC.get(accId).pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') + map_acctId_acctFC.get(accId).csFC.get(dateKey) : map_acctId_acctFC.get(accId).csFC.get(dateKey)));
	            	
	            }
	        }
	        
	        list_accFc.addAll(map_acctId_acctFC.values());
	        list_accFc.sort();
			return Json.serialize(list_accFC);
		}
		
		private void setChannelForecast(Date currentdate, Date enddate, CSD_ClsEntityType.SearchObj searchOb, 
						list<String> list_sql, list<CSD_ClsEntityType.AccountObj> list_accFc){
			list_sql.clear();			
			list_sql.add(' Billing_Region__c region, Fiscal_Year__c year, Fiscal_Month__c month, sum(Forecast__c) sumFC ');
	        list_sql.add(' CSD_Channel_Forecast__c ');
	        list_sql.add(' WHERE OEM__c = \'' + searchOb.oemId + '\' ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Billing_Region__c ');
			map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
			
			for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	        	//system.debug('@#result : '+result);
	            String accId = ((String)result.get('region')).toUpperCase(), 
	                   year = (String)result.get('year'),
	                   month = (String)result.get('month'), 
	                   dateKey = (year + '_' + month);
	            
	            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
	
	            if(!map_acctId_acctFC.containsKey(accId)) {
	        		CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
		            Blob aes = Crypto.generateAesKey(128);
	                String hex = EncodingUtil.convertToHex(aes);
	                acctFC.id = hex;
		            acctFC.name = accId;
					acctFC.type = 'channel';
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
	
	            acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
				acctFC.dcFC.put(dateKey, 0);
				acctFC.pmFC.put(dateKey, 0);
	            map_acctId_acctFC.put(accId, acctFC);       

	        }
	        
	        list_accFc.addAll(map_acctId_acctFC.values());
			list_accFc.sort();
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
				CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
				system.debug('@#searchOb:'+searchOb);
				list<Date> list_beforedate = new list<Date>();
		    	list<Date> list_futruedate = new list<Date>();

		    	CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
		    	
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
			        		new map<String, map<String, AggregateResult>>();
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
		        		new map<String, map<String, AggregateResult>>();
		        		
		    	set<String> set_oemIds = new set<String>();
				CSD_ClsUtils.setGAMOEMCompetence('Sales Leader', set_oemIds);
		    	
		    	list<String> list_sql = new list<String>();
				list_sql.add(' Sold_To_Number__c soldto ');
		        list_sql.add(' CSD_Sales_Forecast__c ');
		        list_sql.add(' WHERE Type__c = \'OEM\' '
		        			+ ' And OEM__c in : set_oemIds ' 
		        			+ ' And Billing_Region__c = \''+searchOb.region+'\' '
		                    + ' Group by Sold_To_Number__c ');
		    	
		    	set<String> set_soldtoId = new set<String>();
		    	for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
		    		set_soldtoId.add((String)result.get('soldto'));
		    	}

				if(list_beforedate.size() > 0) {
		        	//before
		        	set<String> years = new set<String>();
		        	set<Integer> months = new set<Integer>();
		        	
		        	CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
		        	
			        set<String> set_monthIds = new set<String>();
		    		for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
		    														from CSD_OEM_Mapping_Monthly_BBB__c 
		    														where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
		    															and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
		    															and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
                                                                        and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = :set_soldtoId 
		    															and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
		    			set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
		    		}

			        list<String> list_beforesql = new list<String>();
					list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
			     	list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
			     	list_beforesql.add(' WHERE Id IN :set_monthids '
			                + ' Group by Fiscal_Date__c ');
			        CSD_ClsUtils.setGAMOEMMapRefData(searchOb.region, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
		        }
		    	
		        CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
		        refdata.id = searchOb.region;
		        
		        CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
		    	
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
			        		new map<String, map<String, AggregateResult>>();
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
		        		new map<String, map<String, AggregateResult>>();
		        
		    	set<String> set_oemIds = new set<String>();
				CSD_ClsUtils.setGAMOEMCompetence('Sales Leader', set_oemIds);
		    	
		    	list<String> list_sql = new list<String>();
				list_sql.add(' Sold_To_Number__c soldto ');
		        list_sql.add(' CSD_Sales_Forecast__c ');
		        list_sql.add(' WHERE Type__c = \'OEM\' '
		        			+ ' And OEM__c in : set_oemIds ' 
		        			+ ' And Billing_Region__c = \''+searchOb.region+'\' '
		                    + ' Group by Sold_To_Number__c ');
		    	
		    	set<String> set_soldtoId = new set<String>();
		    	for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
		    		set_soldtoId.add((String)result.get('soldto'));
		    	}
		    	
		    	if(list_futruedate.size() > 0) {
		    		//futrue
		    		set<String> years = new set<String>();
		        	set<Integer> months = new set<Integer>();
		        	
		        	CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
		    		
		    		set<String> set_dailyIds = new set<String>();
		    		for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
		    														from CSD_OEM_Mapping_Daily_BBB__c 
		    														where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c = :years 
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber IN :set_soldtoId 
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
		    															and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
		    			set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
		    		}

			    	list<String> list_futruesql = new list<String>();
					list_futruesql.add(' sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
			     	list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c	 ');
			     	list_futruesql.add(' WHERE Id IN :set_monthids '
			            + ' Group by Fiscal_Date__c ');		
			        CSD_ClsUtils.setGAMOEMMapRefData(searchOb.region, set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
		    	}

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.region;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
	}
	
	
	public class SearchLevel3 extends CSD_Interface.ACSDRemoteService{
		
		
		
		/**
		 *  This function is get value of OEM level by SoldTO level
		 *  
		 * @author Lei Tang
		 * @created 2014-10-28
		 * @version 1.0
		 * @since 30.0 (Force.com ApiVersion)  
		 * 
		 *
		 * @changelog
		 * 2014-10-28 Lei Tang <lei.tang@itbconsult.com>
		 * - Created
		 *
		*/
		public override String getExistResult(String sData){
			
			CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
			system.debug('@#searchOb'+searchOb);
			Date currentdate = Date.valueOf(searchOb.startDate);
	        Date enddate = Date.valueOf(searchOb.endDate);
	        
	        list<String> list_sql = new list<String>();
	        list_sql.add(' Sold_To_Number__c soldto');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
	        			+ ' And OEM__c = \'' + searchOb.oemId + '\' ' 
	        			+ ' AND Billing_Region__c = \'' + searchOb.region + '\''
	        			+ ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Sold_To_Number__c ');
	        map<Integer, set<String>> map_set_soldto = new map<Integer, set<String>>();
	        Integer i = 0;
	        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	        	Integer num = i/150;
	        	if(map_set_soldto.containsKey(num)) {
	        		map_set_soldto.get(num).add((String)result.get('soldto'));
	        	}else {
	        		set<String> set_soldto = new set<String>();
	        		set_soldto.add((String)result.get('soldto'));
	        		map_set_soldto.put(num, set_soldto);
	        	}
	        	i++;
	        }

	        map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObj>();
	        
	        for(Integer num : map_set_soldto.keySet()) {
	        	getExistResultForMore(searchOb, map_acctId_acctFC, currentdate, enddate, map_set_soldto.get(num));
	        }
	        /*
	        list_sql.clean();
	        list_sql.add(' Sold_To_Number__c soldto, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
	        		+ 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
	                    
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
	        			+ ' And OEM__c = \'' + searchOb.oemId + '\' ' 
	        			+ ' AND Billing_Region__c = \'' + searchOb.region + '\''
	        			+ ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');
	        //Generate forecast view object
	        */
	        list<CSD_ClsEntityType.AccountObj> list_accFc = new list<CSD_ClsEntityType.AccountObj>();
	        list_accFc.addAll(map_acctId_acctFC.values());
	        list_accFc.sort();
			
			return Json.serialize(list_accFC);
		}
		
		private void getExistResultForMore(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.AccountObj> map_acctId_acctFC, Date currentdate, Date enddate, set<String> set_key) {
			
			list<String> list_sql = new list<String>();
            list_sql.add(' Sold_To_Number__c soldto, Sold_To_Name__c name, Fiscal_Year__c year, Fiscal_Month__c month, '
	        		+ 'sum(DC_Forecast_Amount__c) sumDCFC, sum(Forecast__c) sumFC, sum(Previous_Month_Forecast__c) sumPMFC');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
	        			+ ' And Sold_To_Number__c = :set_key ' 
	        			+ ' And OEM__c = \'' + searchOb.oemId + '\' ' 
	        			+ ' AND Billing_Region__c = \'' + searchOb.region + '\''
	        			+ ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');

			for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	        	//system.debug('@#result : '+result);
	            String accId = (String)result.get('soldto'), 
	                   year = (String) result.get('year'),
	                   month = (String) result.get('month'), 
	                   dateKey = (year + '_' + month);
	            
	            CSD_ClsEntityType.AccountObj acctFC = new CSD_ClsEntityType.AccountObj();
	
	        	if(!map_acctId_acctFC.containsKey(accId)) {
	        		CSD_ClsUtils.createAccountObj(acctFC, searchOb.map_year_monthsFuture);
	        		Blob aes = Crypto.generateAesKey(128);
		            String hex = EncodingUtil.convertToHex(aes);
		            acctFC.id = hex;
		            acctFC.accnumber = accId;
		            acctFC.name = (String)result.get('name');
	
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}

	            acctFC.csFC.put(dateKey, (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0));
				acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
	            
	            map_acctId_acctFC.put(accId, acctFC);
     
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
		public override String getRefData(String sData) { 
			try {
				CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
				system.debug('@#searchOb'+searchOb);
				list<Date> list_beforedate = new list<Date>();
		    	list<Date> list_futruedate = new list<Date>();
		    	
		    	CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
		    	
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
			        		new map<String, map<String, AggregateResult>>();
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
		        		new map<String, map<String, AggregateResult>>();

		        if(list_beforedate.size() > 0) {
		        	//before
		        	set<String> years = new set<String>();
		        	set<Integer> months = new set<Integer>();
		        	
		        	CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
		        	
		        	set<String> set_monthIds = new set<String>();
		    		for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
		    														from CSD_OEM_Mapping_Monthly_BBB__c 
		    														where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
		    															and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
		    															and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
		    															and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
		    															and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
		    			set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
		    		}
		        	
		        	
			        list<String> list_beforesql = new list<String>();
					list_beforesql.add(' Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
			     	list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
			     	list_beforesql.add(' WHERE Id IN :set_monthids '
			                + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');
			        CSD_ClsUtils.setOEMPartMapRefData(set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
		        	
		        }
		        
		        CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
		        refdata.id = searchOb.accnumber;
		        
		        CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                system.debug('@#searchOb'+searchOb);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
		    	
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
			        		new map<String, map<String, AggregateResult>>();
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
		        		new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
		    		//futrue
		    		set<String> years = new set<String>();
		        	set<Integer> months = new set<Integer>();
		        	
		        	CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
		        	
		        	set<String> set_dailyIds = new set<String>();
		    		for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
		    														from CSD_OEM_Mapping_Daily_BBB__c 
		    														where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c = :years 
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
		    															and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
		    			set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
		    		}

		    		list<String> list_futruesql = new list<String>();
					list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
			     	list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c	 ');
			     	list_futruesql.add(' WHERE Id IN :set_monthids '
			            + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');		
			        CSD_ClsUtils.setOEMPartMapRefData(set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);

		    	}

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
		
	}
	
	
	
	public class SearchLevel4 extends CSD_Interface.ACSDRemoteService{
		
		public override String getExistResult(String sData){
			CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
			system.debug('@#searchOb'+searchOb);
			
			Date currentdate = Date.valueOf(searchOb.startDate);
	        Date enddate = Date.valueOf(searchOb.endDate);
			map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC = new map<String, CSD_ClsEntityType.PartObj>();
			
			list<String> list_sql = new list<String>();
            list_sql.add(' Part__c part ');
        	list_sql.add(' CSD_Sales_Forecast__c ');
        	list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
        			+ ' And OEM__c = \''+ searchOb.oemId +'\' '
        			+ ' And Billing_Region__c = \''+ searchOb.region +'\' '
        			+ ' And Type__c = \'Part\' '
        			+ ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c ');

			map<Integer, set<String>> map_set_soldto = new map<Integer, set<String>>();
	        Integer i = 0;
	        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	        	Integer num = i/150;
	        	if(map_set_soldto.containsKey(num)) {
	        		map_set_soldto.get(num).add((String)result.get('part'));
	        	}else {
	        		set<String> set_soldto = new set<String>();
	        		set_soldto.add((String)result.get('part'));
	        		map_set_soldto.put(num, set_soldto);
	        	}
	        	i++;
	        }
	        
	        for(Integer num : map_set_soldto.keySet()) {
	        	getExistResultForMore(searchOb, map_acctId_acctFC, currentdate, enddate, map_set_soldto.get(num));
	        }

	        if(searchOb.region == 'KOREA') {
	        	system.debug('@searchOb.region'+searchOb.region);
	        	list_sql.clear();
	        	list_sql.add('Part__c part, Part__r.Name partname, Fiscal_Year__c year, Fiscal_Month__c month, '
					+ ' sum(Quantity__c) quantity, sum(Forecast__c) forecast, sum(Price__c) price,'
					+ ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                    
        		list_sql.add(' CSD_Sales_Forecast__c ');
	        	list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
	        			+ ' And OEM__c = \''+ searchOb.oemId +'\' '
	        			+ ' And Billing_Region__c = \''+ searchOb.region +'\' '
	        			+ ' And Type__c = \'Sold-To\' '
	        			//+ ' And (Samsung_Type__c = \'Non SoldTo\' or Samsung_Type__c = null) '
	        			+ ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Part__c, Part__r.Name, Fiscal_Year__c, Fiscal_Month__c  ');

	        	for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	        		system.debug('@#result : '+result);
		            String accId = (String)result.get('part'), 
		                   year = (String)result.get('year'),
		                   month = (String)result.get('month'), 
		                   dateKey = (year + '_' + month);
		            
		            
		            CSD_ClsEntityType.PartObj acctFC = new CSD_ClsEntityType.PartObj();
		
		        	if(!map_acctId_acctFC.containsKey(accId)) {
		        		CSD_ClsUtils.createPartObj(acctFC, searchOb.map_year_monthsFuture);
		        		
			            acctFC.id = accId;
			            acctFC.name = (String)result.get('partname');
		
			            map_acctId_acctFC.put(accId, acctFC);
					}else {
						if(!map_acctId_acctFC.get(accId).csFC.containsKey(dateKey)) {
							continue;
						}
						acctFC = map_acctId_acctFC.get(accId);
					}
					
					CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
					
					valueobj.forecast = result.get('forecast') != null ? (decimal)result.get('forecast') : 0;
	            	valueobj.price = result.get('price') != null ? (decimal)result.get('price') : 0;
	            	valueobj.quantity = result.get('quantity') != null ? (decimal)result.get('quantity') : 0;
					
		            acctFC.csFC.put(dateKey, valueobj);
					acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
					acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
		            
		            map_acctId_acctFC.put(accId, acctFC);  
	        	}
	        }
	        
	        

			list<CSD_ClsEntityType.PartObj> list_accFC = new list<CSD_ClsEntityType.PartObj>();
			list_accFC.addAll(map_acctId_acctFC.values());
			list_accFC.sort();
			return Json.serialize(list_accFC);

		}
		
		
		private void getExistResultForMore(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.PartObj> map_acctId_acctFC, Date currentdate, Date enddate, set<String> set_key) {
			
			list<String> list_sql = new list<String>();
            list_sql.add(' Part__c part, Part__r.Name partname, Part__r.Description__c descr, Fiscal_Year__c year, Fiscal_Month__c month, '
					+ ' sum(Quantity__c) quantity, sum(Forecast__c) forecast, sum(Price__c) price,'
					+ ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC');
                    
        	list_sql.add(' CSD_Sales_Forecast__c ');
        	list_sql.add(' WHERE Sold_To_Number__c = \''+ searchOb.accnumber +'\' ' 
        			+ ' And OEM__c = \''+ searchOb.oemId +'\' '
        			+ ' And Billing_Region__c = \''+ searchOb.region +'\' '
        			+ ' And Part__c = :set_key ' 
        			+ ' And Type__c = \'Part\' '
        			+ ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Part__c, Part__r.Name, Part__r.Description__c, Fiscal_Year__c, Fiscal_Month__c ');

			
			for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	        	system.debug('@#result : '+result);
	            String accId = (String)result.get('part'), 
	                   year = (String)result.get('year'),
	                   month = (String)result.get('month'), 
	                   dateKey = (year + '_' + month);
	            CSD_ClsEntityType.PartObj acctFC = new CSD_ClsEntityType.PartObj();
	
	        	if(!map_acctId_acctFC.containsKey(accId)) {
	        		CSD_ClsUtils.createPartObj(acctFC, searchOb.map_year_monthsFuture);
	        		
		            acctFC.id = accId;
		            acctFC.name = (String)result.get('partname') + (result.get('descr') == null ? '' : ' - '+(String)result.get('descr'));
					acctFC.snumber = (result.get('descr') == null ? '' : (String)result.get('descr'));
		            map_acctId_acctFC.put(accId, acctFC);
				}else {
					acctFC = map_acctId_acctFC.get(accId);
				}
				
				CSD_ClsEntityType.AccountValueobj valueobj = new CSD_ClsEntityType.AccountValueobj();
				
				valueobj.forecast = result.get('forecast') != null ? (decimal)result.get('forecast') : 0;
            	valueobj.price = result.get('price') != null ? (decimal)result.get('price') : 0;
            	valueobj.quantity = result.get('quantity') != null ? (decimal)result.get('quantity') : 0;
				
	            acctFC.csFC.put(dateKey, valueobj);
				acctFC.dcFC.put(dateKey, (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0));
				acctFC.pmFC.put(dateKey, (result.get('sumPMFC') != null ? (decimal)result.get('sumPMFC') : 0));
	            
	            map_acctId_acctFC.put(accId, acctFC);  

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
		public override String getRefData(String sData) { 
			try {
				CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
				system.debug('@#searchOb'+searchOb);
				list<Date> list_beforedate = new list<Date>();
		    	list<Date> list_futruedate = new list<Date>();
		    	
		    	CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
		    	
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
			        		new map<String, map<String, AggregateResult>>();
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
		        		new map<String, map<String, AggregateResult>>();
		        		
		        if(list_beforedate.size() > 0) {
		        	//before   
		        	set<String> years = new set<String>();
		        	set<Integer> months = new set<Integer>();
		        	
		        	CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);
		        	 	
		        	set<String> set_monthIds = new set<String>();
		    		for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
		    														from CSD_OEM_Mapping_Monthly_BBB__c 
		    														where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
		    															and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
		    															and Monthly_Billings_Bookings_by_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
		    															and Monthly_Billings_Bookings_by_Part__r.Customer__r.STATDESC__c = 'Active'
		    															and Monthly_Billings_Bookings_by_Part__r.Part__c = :searchOb.partId 
		    															and OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId]) {
		    			set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
		    		}
		        	
		        	
			        list<String> list_beforesql = new list<String>();
					list_beforesql.add(' Customer__r.AccountNumber refId, sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
			     	list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
			     	list_beforesql.add(' WHERE Id IN :set_monthids '
			                + ' Group by Customer__r.AccountNumber,  Fiscal_Date__c ');
			        CSD_ClsUtils.setOEMPartMapRefData(set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
			        
		        }
		        
		        CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
		        refdata.id = searchOb.accnumber;
		        
		        CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata, 
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
                CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
                list<Date> list_beforedate = new list<Date>();
                list<Date> list_futruedate = new list<Date>();
                system.debug('@#searchOb'+searchOb);
                CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
		    	
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
			        		new map<String, map<String, AggregateResult>>();
		    	map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
		        		new map<String, map<String, AggregateResult>>();

                if(list_futruedate.size() > 0) {
		    		//futrue
		    		set<String> years = new set<String>();
		        	set<Integer> months = new set<Integer>();
		        	
		        	CSD_ClsUtils.setRefForecastDate(years, months, list_futruedate);
		    		
		    		set<String> set_dailyIds = new set<String>();
		    		for(CSD_OEM_Mapping_Daily_BBB__c csdmap : [select Daily_Booking_Billing_Backlog_By_Part__c 
		    														from CSD_OEM_Mapping_Daily_BBB__c 
		    														where Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Year__c IN :years
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Fiscal_Month__c IN :months
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.AccountNumber = :searchOb.accnumber 
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Customer__r.STATDESC__c = 'Active'
		    															and Daily_Booking_Billing_Backlog_By_Part__r.Part__c = :searchOb.partId 
		    															and CSD_OEM_Mapping__r.OEM__r.OEM__c = :searchOb.oemId ]) {
		    			set_dailyIds.add(csdmap.Daily_Booking_Billing_Backlog_By_Part__c);
		    		}

		    		list<String> list_futruesql = new list<String>();
					list_futruesql.add(' Customer__r.AccountNumber refId, sum(Backlog_Amount_USD__c) amount, Fiscal_Date__c refdate');
			     	list_futruesql.add(' BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c	 ');
			     	list_futruesql.add(' WHERE Id IN :set_monthids '
			            + ' Group by Customer__r.AccountNumber, Fiscal_Date__c ');		
			        CSD_ClsUtils.setOEMPartMapRefData(set_dailyIds, list_futruesql, map_acctId_map_dateKey_result_futrue);
		    	}

                CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
                refdata.id = searchOb.accnumber;
                
                CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
                            map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
                
                return Json.serialize(refdata);
            }catch(Exception ex) {
                throw ex;
            }
        }
	}
	
	
	public class SearchTotal extends CSD_Interface.ACSDRemoteService{
     	
     	public override String getTotalBillingData(String sData) {
		
			try {
	            CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
	                
	            list<Date> list_beforedate = new list<Date>();
	            list<Date> list_futruedate = new list<Date>();
	
	            CSD_ClsUtils.setRefDatelist(list_beforedate, list_futruedate, searchOb.set_fiscalMonth);
	
	            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_futrue =
	                        new map<String, map<String, AggregateResult>>();
	            map<String, map<String, AggregateResult>> map_acctId_map_dateKey_result_before =
	                    new map<String, map<String, AggregateResult>>();
	            
	            set<String> set_oemIds = new set<String>();
				CSD_ClsUtils.setGAMOEMCompetence('Sales Leader', set_oemIds);
                
	            if(list_beforedate.size() > 0) {
	            	
	            	set<String> years = new set<String>();
                    set<Integer> months = new set<Integer>();
                    
                    CSD_ClsUtils.setRefForecastDate(years, months, list_beforedate);

                    list<String> list_beforesql = new list<String>();
	            	
	            	set<String> set_monthIds = new set<String>();
		    		for(CSD_OEM_Mapping_Monthly_BBB__c csdmap : [select Monthly_Billings_Bookings_by_Part__c 
		    														from CSD_OEM_Mapping_Monthly_BBB__c 
		    														where Monthly_Billings_Bookings_by_Part__r.Fiscal_Year__c IN :years
		    															and Monthly_Billings_Bookings_by_Part__r.Fiscal_Month__c IN :months
		    															and OEM_Mapping__r.OEM__r.OEM__c IN :set_oemIds]) {
		    			set_monthIds.add(csdmap.Monthly_Billings_Bookings_by_Part__c);
		    		}

					list_beforesql.add(' sum(Bill_Amount_USD__c) billamount, sum(Book_Amount_USD__c) bookamount, Fiscal_Date__c refdate');
			     	list_beforesql.add(' BBB_Month_Bill_Book_Cust_PN__c ');
			     	list_beforesql.add(' WHERE Id IN :set_perm '
			                + ' Group by Fiscal_Date__c ');
	                CSD_ClsUtils.setTotelBillingData(years, months, set_monthIds, list_beforesql, map_acctId_map_dateKey_result_before);
	            }
	                
	            CSD_ClsEntityType.CSDRefObj refdata = CSD_ClsUtils.createRefDataObj();
	            refdata.id = 'Total';
	                
	            CSD_ClsUtils.setRefDateObject(list_beforedate, list_futruedate, refdata,
	                        map_acctId_map_dateKey_result_before, map_acctId_map_dateKey_result_futrue);
	            
	            return Json.serialize(refdata);
	        }catch(Exception ex) {
	            throw ex;
	        }
			
		}
    }

}