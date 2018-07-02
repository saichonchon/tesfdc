/**
 *  This class is CSD Regional Comparison View Service.
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
public without sharing class CSD_ClsRegionalComparisonViewService extends CSD_Interface.ACSDCtrlService {
	
	public override void setLevel1Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
		list<CSD_ClsEntityType.CSDColumn> list_t = new list<CSD_ClsEntityType.CSDColumn> {
			new CSD_ClsEntityType.CSDColumn('', '', '', '', false)
		};
		
		list_acctColumns.addAll(list_t);
	}
	
	public override void setLevel2Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
		list<CSD_ClsEntityType.CSDColumn> list_t = new list<CSD_ClsEntityType.CSDColumn> {
			new CSD_ClsEntityType.CSDColumn('', '', '', '', false)
		};
		
		list_acctColumns.addAll(list_t);
	}
	
	public override void setLevel3Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
		list<CSD_ClsEntityType.CSDColumn> list_t = new list<CSD_ClsEntityType.CSDColumn> {
			new CSD_ClsEntityType.CSDColumn('', '', '', '', false)
		};
		
		list_acctColumns.addAll(list_t);
	}
	
	public override void setLevel4Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
		list<CSD_ClsEntityType.CSDColumn> list_t = new list<CSD_ClsEntityType.CSDColumn> {
			new CSD_ClsEntityType.CSDColumn('', '', '', '', false)
		};
		
		list_acctColumns.addAll(list_t);
	}
	
	
	public override void setAllDateItems(CSD_ClsEntityType.PageConfig PageConf, list<CSD_ClsEntityType.DateItem> list_allDateItems) {
		CSD_ClsUtils.createDateItemForComparison(pageConf, list_allDateItems);
	}
	
	public override void setPageConf(CSD_ClsEntityType.PageConfig PageConf) {
		CSD_ClsUtils.setFiscalMonthForComparison(pageConf);
	}
	
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
        //system.debug('@#pageconf : '+pageconf);
        set<String> set_regions = new set<String>();
        for(CSD_Forecast_Management__c acc : [Select Id, Region__c from CSD_Forecast_Management__c where Role__c ='Regional Comparison' and Region__c != null And User__c = :UserInfo.getUserId() ]) {
        	//if(acc.Region__c != null) {
        		list<String> accregions = acc.Region__c.split(';');
        		for(String region : accregions) {
        			if(!set_regions.contains(region)) {
        				set_regions.add(region);
        			}
        		}
        	//}
		}
        
        if(set_regions.size() == 0) {
        	return;
        }
        
        list<String> list_sql = new list<String>();
        //string stringDate = pageconf.currentYear + '-' + String.valueOf(pageconf.currentMonth) + '-1';
        Date currentdate = Date.valueOf(pageconf.refStartDate);
        Date enddate = Date.valueOf(pageconf.refEndDate);
        
        list_sql.add(' Billing_Region__c region, ' 
        			+ ' Fiscal_Year__c year, Fiscal_Month__c month, '
               		+ ' sum(Forecast__c) sumFC, sum(DC_Forecast_Amount__c) sumDCFC ');
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
                    + ' And Billing_Region__c IN : set_regions ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' And Billing_Region__c != null '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Billing_Region__c ');
        
        map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC = new map<String, CSD_ClsEntityType.AccountObjForComparison>();
        //system.debug('@#list_sql : '+CSD_ClsUtils.getQueryString(list_sql));
        
        CSD_ClsUtils.getExistResultForComparison(pageconf.map_quarter_months, map_acctId_acctFC, set_regions, list_sql, currentdate, enddate, 'region', true, 'region', false);
        
        /*
        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
            //system.debug('@#result : '+result);
            String accId = (String)result.get('region'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                   
            CSD_ClsEntityType.AccountObjForComparison acctFC = new CSD_ClsEntityType.AccountObjForComparison();
            
            if(!map_acctId_acctFC.containsKey(accId)) {
        		CSD_ClsUtils.createAccountObjForComprison(acctFC, pageconf.map_quarter_months);
        		Blob aes = Crypto.generateAesKey(128);
                String hex = EncodingUtil.convertToHex(aes);
                acctFC.id = hex;
	            acctFC.name = accId;
	            map_acctId_acctFC.put(accId, acctFC);
			}else {
				acctFC = map_acctId_acctFC.get(accId);
			}
			
			for(String quarter : pageconf.map_quarter_months.keySet()) {
				
				set<String> set_months = new set<String>();
				set_months.addAll(pageconf.map_quarter_months.get(quarter).split(','));
				
				if(set_months.contains(dateKey)) {
					
					Decimal sumFC = (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0);
					Decimal totalFC = 0;
					if(acctFC.csFC.containsKey(quarter)) {
						totalFC = acctFC.csFC.get(quarter);
					}
					totalFC += sumFC;
					acctFC.csFC.put(quarter, totalFC);
					
					Decimal sumDCFC = (result.get('sumDCFC') != null ? (decimal)result.get('sumDCFC') : 0);
					Decimal totalDCFC = 0;
					if(acctFC.dcFC.containsKey(quarter)) {
						totalDCFC = acctFC.dcFC.get(quarter);
					}
					totalDCFC += sumDCFC;
					acctFC.dcFC.put(quarter, totalDCFC);
					
					acctFC.pmFC.put(quarter, (totalFC - totalDCFC));
				}
			}
			acctFC.json_csFC = JSON.serialize(acctFC.csFC);
			acctFC.json_dcFC = JSON.serialize(acctFC.dcFC);
			acctFC.json_pmFC = JSON.serialize(acctFC.pmFC);

            map_acctId_acctFC.put(accId, acctFC);    
        }
		*/
		

		setChannelForecastLevel1(pageconf, set_regions, currentdate, enddate, list_sql, map_acctId_acctFC);
        setFirstLevel(list_data, map_acctId_acctFC);
     //   for(Integer i = 0; i < list_accFc.size(); i++) {
     //       list_data.add(list_accFc.get(i));
     //   }

    }
    
    private void setFirstLevel(list<Object> list_data, map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC){
		
		CSD_ClsEntityType.AccountObjForComparison total=new CSD_ClsEntityType.AccountObjForComparison();
		total.id = CSD_ClsUtils.getHexUID();
		total.name = 'Total';
		total.type = 'total';
		/*CSD_ClsEntityType.AccountObjForComparison nonchannel=new CSD_ClsEntityType.AccountObjForComparison();
		nonchannel.id = CSD_ClsUtils.getHexUID();
		nonchannel.name = 'Non - Channel';
		nonchannel.type = 'nontotalchannel';
		
		CSD_ClsEntityType.AccountObjForComparison channel=new CSD_ClsEntityType.AccountObjForComparison();
		channel.id = CSD_ClsUtils.getHexUID();
		channel.name = 'Channel';
		channel.type = 'totalchannel';
		*/
		list_data.add(total);
		//list_data.add(nonchannel);
		
		list<CSD_ClsEntityType.AccountObjForComparison> list_oems = CSD_ClsUtils.compareListByDate(map_acctId_acctFC);
		
		for(Integer i = 0; i < list_oems.size(); i++) {
            list_data.add(list_oems.get(i));
        }
		//list_data.add(channel);
        list_oems.clear();
	}
	
	private void setChannelForecastLevel1(CSD_ClsEntityType.PageConfig pageconf, set<String> set_regions, 
									Date currentdate, Date enddate, list<String> list_sql, 
									map<String, CSD_ClsEntityType.AccountObjForComparison> map_oemid_comp){
		list_sql.clear();
		list_sql.add(' Billing_Region__c region, Fiscal_Year__c year, Fiscal_Month__c month, sum(Forecast__c) sumFC ');
        list_sql.add(' CSD_Channel_Forecast__c ');
        list_sql.add(' WHERE Billing_Region__c IN : set_regions ' 
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Billing_Region__c ');
		
		CSD_ClsUtils.getExistResultForComparison(pageconf.map_quarter_months, map_oemid_comp, set_regions, list_sql, currentdate, enddate, 'region', true, 'region', false);
		/*
    	for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
    		String accId = (String)result.get('region'), 
                   year = (String) result.get('year'),
                   month = (String) result.get('month'), 
                   dateKey = (year + '_' + month);
                   
            CSD_ClsEntityType.AccountObjForComparison acctFC = new CSD_ClsEntityType.AccountObjForComparison();
            
            if(!map_acctId_acctFC.containsKey(accId)) {
        		CSD_ClsUtils.createAccountObjForComprison(acctFC, pageconf.map_quarter_months);
        		Blob aes = Crypto.generateAesKey(128);
                String hex = EncodingUtil.convertToHex(aes);
                acctFC.id = hex;
	            acctFC.name = accId;
	            acctFC.type = 'channel';
	            map_acctId_acctFC.put(accId, acctFC);
			}else {
				acctFC = map_acctId_acctFC.get(accId);
			}
			
			for(String quarter : pageconf.map_quarter_months.keySet()) {
				
				set<String> set_months = new set<String>();
				set_months.addAll(pageconf.map_quarter_months.get(quarter).split(','));
				
				if(set_months.contains(dateKey)) {
					
					Decimal sumFC = (result.get('sumFC') != null ? (decimal)result.get('sumFC') : 0);
					Decimal totalFC = 0;
					if(acctFC.csFC.containsKey(quarter)) {
						totalFC = acctFC.csFC.get(quarter);
					}
					totalFC += sumFC;
					acctFC.csFC.put(quarter, totalFC);
					
					Decimal sumDCFC = 0, totalDCFC = 0;
					if(acctFC.dcFC.containsKey(quarter)) {
						totalDCFC = acctFC.dcFC.get(quarter);
					}
					totalDCFC += sumDCFC;
					acctFC.dcFC.put(quarter, totalDCFC);
					
					acctFC.pmFC.put(quarter, (totalFC - totalDCFC));
				}
			}
			acctFC.json_csFC = JSON.serialize(acctFC.csFC);
			acctFC.json_dcFC = JSON.serialize(acctFC.dcFC);
			acctFC.json_pmFC = JSON.serialize(acctFC.pmFC);

            map_acctId_acctFC.put(accId, acctFC);    
    	}
    	*/
	}
	
	
	public class SearchLevel2 extends CSD_Interface.ACSDRemoteService{
		
		
		public override String getExistResult(String sData){

			
			CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
			list<CSD_ClsEntityType.AccountObjForComparison> list_regions = new list<CSD_ClsEntityType.AccountObjForComparison>();
			
	        system.debug('@#searchOb : '+searchOb);

	        /*if(searchOb.type == 'channel'){
	        	list_regions = setChannelForecast(searchOb);
	        	//setChannelForecast(currentdate, enddate, searchOb, list_sql, list_tempoems, list_oems);	//added 2015-01-14 minghao.li@itbconsult.com 
				return JSON.serialize(list_regions);
	        }*/
	        
	        map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC = new  map<String, CSD_ClsEntityType.AccountObjForComparison>();
	        
	        Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
	        list<String> list_sql = new list<String>();
	        
	        
	        String typename = 'OEM';
	        list_sql.add(' OEM__c oem, OEM__r.Name accname, ' 
	        			+ ' Fiscal_Year__c year, Fiscal_Month__c month, '
	               		+ ' sum(Forecast__c) sumFC, sum(DC_Forecast_Amount__c) sumDCFC ');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c = \''+typename+'\' '
	                    + ' And Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' And Channel_Forecast__c = false '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');

			CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, null, list_sql, currentdate, enddate, 'oem', false, 'accname', false);
			
	        //list_tempoems = CSD_ClsUtils.getExistResultForComparison(searchOb, list_sql, currentdate, enddate, 'oem', false, 'accname');
	        /*
	        if(searchOb.region == 'TAIWAN') {

	        	list<String> list_taiwansql = new list<String>();
	        		
	    		list_taiwansql.add(' OEM__c oem, Sold_To_Number__c soldto ');
		        list_taiwansql.add(' CSD_Sales_Forecast__c ');
		        list_taiwansql.add(' WHERE Type__c = \'OEM\' '
		                    + ' And Billing_Region__c = \'TAIWAN\' ' 
		                    + ' And Fiscal_Date__c >= : currentdate '
		                    + ' And Fiscal_Date__c < : enddate '	                    
		                    + ' And Channel_Forecast__c = false '
		                    + ' Group by OEM__c, Sold_To_Number__c ');
		        set<String> set_taiwanoems = new set<String>();
		        set<String> set_taiwansoldtos = new set<String>();
		        String str_taiwansoldtos = '';
        		String str_taiwanoems = '';
		        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_taiwansql))) {
		        	set_taiwanoems.add((String)result.get('oem'));
		        	set_taiwansoldtos.add((String)result.get('soldto'));
		        	str_taiwansoldtos += '\''+(String)result.get('soldto')+'\',';
        			str_taiwanoems += '\''+(String)result.get('oem')+'\',';
		        }
	        	
	        	if(str_taiwansoldtos.length() > 0) {
					str_taiwansoldtos = str_taiwansoldtos.subString(0, str_taiwansoldtos.length()-1);
				}
				if(str_taiwanoems.length() > 0) {
					str_taiwanoems = str_taiwanoems.subString(0, str_taiwanoems.length()-1);
				}
	        	
	        	typename = 'Part';
	        	list_sql.add(2,' WHERE Type__c = \''+typename+'\' '
	                    + ' And Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
			        	+ (str_taiwansoldtos.length() > 0 ? ' And Sold_To_Number__c NOT IN ('+ str_taiwansoldtos +') ' : '')
                    	+ (str_taiwanoems.length() > 0 ? ' And OEM__c NOT IN (' + str_taiwanoems + ') ' : '')
	                    + ' And Channel_Forecast__c = false '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');
	            
	            CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, null, list_sql, currentdate, enddate, 'oem', false, 'accname', false);
	            
	        }
	        */
	        list_sql.clear();
	        list_sql.add(' OEM__c oem, OEM__r.Name accname, ' 
	        			+ ' Fiscal_Year__c year, Fiscal_Month__c month, '
	               		+ ' sum(Forecast__c) sumFC, sum(DC_Forecast_Amount__c) sumDCFC ');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c = \'Non-OEMs\' '
	                    + ' And Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' And Channel_Forecast__c = false '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');
	        
	        CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, null, list_sql, currentdate, enddate, 'oem', false, 'accname', false);
	        
	        getExistChannelForecast(searchOb, map_acctId_acctFC);
	        
	        
	        list_regions.addAll(CSD_ClsUtils.compareListByDate(map_acctId_acctFC));
			return JSON.serialize(list_regions);
		}
		
		private void getExistChannelForecast(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC){
			
			Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
						
			list<String> list_sql = new list<String>();
			list_sql.add( ' OEM__c oem, OEM__r.Name accname, '
						+ ' Fiscal_Year__c year, Fiscal_Month__c month, sum(Forecast__c) sumFC ');
	        list_sql.add(' CSD_Channel_Forecast__c ');
	        list_sql.add(' WHERE Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');
			
	    	CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, null, list_sql, currentdate, enddate, 'oem', false, 'accname', false);
	        
		}
		
		
		
		private list<CSD_ClsEntityType.AccountObjForComparison> setChannelForecast(CSD_ClsEntityType.SearchObj searchOb){
			
			map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC = new  map<String, CSD_ClsEntityType.AccountObjForComparison>();
			list<CSD_ClsEntityType.AccountObjForComparison> list_regions = new list<CSD_ClsEntityType.AccountObjForComparison>();
	        Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
	        list<String> list_sql = new list<String>();
			
			list_sql.add(' OEM__c oem, OEM__r.Name accname, Fiscal_Year__c year, Fiscal_Month__c month, sum(Forecast__c) sumFC ');
	        list_sql.add(' CSD_Channel_Forecast__c ');
	        list_sql.add(' WHERE Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');
			
			CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, null, list_sql, currentdate, enddate, 'oem', false, 'accname', true);
	        
			list_regions.addAll(CSD_ClsUtils.compareListByDate(map_acctId_acctFC));
			return list_regions;
	        
		}
		
		
	} 
	
	public class SearchLevel3 extends CSD_Interface.ACSDRemoteService{
		
		public override String getExistResult(String sData){
			
			CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
			Date currentdate = Date.valueOf(searchOb.startDate), enddate = Date.valueOf(searchOb.endDate);
			
			list<CSD_ClsEntityType.AccountObjForComparison> list_soldtos = new list<CSD_ClsEntityType.AccountObjForComparison>();
			map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC = new  map<String, CSD_ClsEntityType.AccountObjForComparison>();
	        system.debug('@#searchOb : '+searchOb);
	        
	        
	        if(searchOb.type == 'channel'){
				
				//total.name = 'Channel';
				//total.type = 'totalchannel';
				//map_acctId_acctFC.put('totalchannel', total);
	        	
            	getExistChannelForecast(searchOb, map_acctId_acctFC); //added 2015-01-14 minghao.li@itbconsult.com 
            	
	            list_soldtos.addAll(map_acctId_acctFC.values());
	            list_soldtos.sort();
	            system.debug('@#list_accFC :'+list_soldtos);
	            return Json.serialize(list_soldtos);
            } 
	        
	        list<String> list_sql = new list<String>();
	        list_sql.add(' Sold_To_Number__c soldto ');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
	                    + ' And Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And OEM__c = \'' + searchOb.oemId + '\' ' 
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
	        
	        for(Integer num : map_set_soldto.keySet()) {
	        	getExistResultForMore(searchOb, map_acctId_acctFC, currentdate, enddate, map_set_soldto.get(num));
	        }
	        
			list_soldtos.addAll(CSD_ClsUtils.compareListByDate(map_acctId_acctFC));
			return JSON.serialize(list_soldtos);
		}
		
		private void getExistResultForMore(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC, Date currentdate, Date enddate, set<String> set_key) {
			
			list<String> list_sql = new list<String>();
	        list_sql.add(' Sold_To_Number__c soldto, Sold_To_Name__c name, ' 
	        			+ ' Fiscal_Year__c year, Fiscal_Month__c month, '
	               		+ ' sum(Forecast__c) sumFC, sum(DC_Forecast_Amount__c) sumDCFC ');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c IN (\'OEM\',\'Non-OEMs\') '
	                    + ' And Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And OEM__c = \'' + searchOb.oemId + '\' ' 
	                    + ' And Sold_To_Number__c = :set_regions ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c, Sold_To_Name__c ');
			
			CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, set_key, list_sql, currentdate, enddate, 'soldto', true, 'name', false);

		}
		
		private void getExistChannelForecast(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC){
			
			Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
						
			list<String> list_sql = new list<String>();
			list_sql.add( ' OEM__c oem, OEM__r.Name accname, '
						+ ' Fiscal_Year__c year, Fiscal_Month__c month, sum(Forecast__c) sumFC ');
	        list_sql.add(' CSD_Channel_Forecast__c ');
	        list_sql.add(' WHERE Billing_Region__c = \'' + searchOb.region + '\' ' 
	        			+ ' And OEM__c = \''+ searchOb.oemId +'\' '
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, OEM__c, OEM__r.Name ');
			
	    	CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, null, list_sql, currentdate, enddate, 'oem', false, 'accname', true);
	        
		}
		
	}
	
	
	public class SearchLevel4 extends CSD_Interface.ACSDRemoteService{
		
		public override String getExistResult(String sData){
			list<CSD_ClsEntityType.AccountObjForComparison> list_parts = new list<CSD_ClsEntityType.AccountObjForComparison>();
			map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC = new  map<String, CSD_ClsEntityType.AccountObjForComparison>();
			
			CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
	        system.debug('@#searchOb : '+searchOb);
	        
	        Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
            
            list<String> list_sql = new list<String>();
	        list_sql.add(' Part__c part ');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c = \'Part\' '
	                    + ' And Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And OEM__c = \'' + searchOb.oemId + '\' ' 
	                    + ' And Sold_To_Number__c = \'' + searchOb.accnumber + '\' ' 
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
            
	        //list_parts = CSD_ClsUtils.getExistResultForComparison(searchOb, list_sql, currentdate, enddate, 'part', false, 'partname');
	        
	        if(searchOb.region == 'KOREA') {
	        	
		        list_parts.clear();
		        list_sql.clear();
		        list_sql.add(' Part__c part, Part__r.Name partname, Part__r.Description__c descr, ' 
	        			+ ' Fiscal_Year__c year, Fiscal_Month__c month, '
	               		+ ' sum(Forecast__c) sumFC, sum(DC_Forecast_Amount__c) sumDCFC ');
	        	list_sql.add(' CSD_Sales_Forecast__c ');
		        list_sql.add(' WHERE Type__c = \'Sold-To\' '
	                    + ' And Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And OEM__c = \'' + searchOb.oemId + '\' ' 
	                    + ' And Sold_To_Number__c = \'' + searchOb.accnumber + '\' ' 
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Part__r.Description__c, Part__c, Part__r.Name ');
		        
		        CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, null, list_sql, currentdate, enddate, 'part', false, 'partname', false);
        		
	        }
	        list_parts.addAll(CSD_ClsUtils.compareListByDate(map_acctId_acctFC));
			return JSON.serialize(list_parts);
		}
		
		private void getExistResultForMore(CSD_ClsEntityType.SearchObj searchOb, map<String, CSD_ClsEntityType.AccountObjForComparison> map_acctId_acctFC, Date currentdate, Date enddate, set<String> set_key) {
			
			list<String> list_sql = new list<String>();
	        list_sql.add(' Part__c part, Part__r.Name partname, Part__r.Description__c descr, ' 
	        			+ ' Fiscal_Year__c year, Fiscal_Month__c month, '
	               		+ ' sum(Forecast__c) sumFC, sum(DC_Forecast_Amount__c) sumDCFC ');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c = \'Part\' '
	                    + ' And Billing_Region__c = \'' + searchOb.region + '\' ' 
	                    + ' And OEM__c = \'' + searchOb.oemId + '\' ' 
	                    + ' And Sold_To_Number__c = \'' + searchOb.accnumber + '\' ' 
	                    + ' And Part__c = :set_regions '
	                    + ' And Fiscal_Date__c >= : currentdate '
	                    + ' And Fiscal_Date__c < : enddate '
	                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Part__c, Part__r.Name, Part__r.Description__c ');
			
			CSD_ClsUtils.getExistResultForComparison(searchOb.map_quarter_months, map_acctId_acctFC, set_key, list_sql, currentdate, enddate, 'part', false, 'partname', false);

		}
	}
}