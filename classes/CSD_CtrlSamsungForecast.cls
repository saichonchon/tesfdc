/**
 *  Ctrl class for CSD_CtrlSamsungForecast
 *
 @author    Lei Tang
 @created   2014-10-16
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-10-16 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 */
 public with sharing class CSD_CtrlSamsungForecast extends CSD_CtrlForecastRemoteBase {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public transient CSD_ClsEntityType.LocaleConfig lc {get;set;}

	public transient CSD_ClsEntityType.PageConfig pageConf {get; set;}
	
	public transient list<CSD_ClsEntityType.DateItem> list_allDateItems {get; set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_SoldToColumns {get;set;}
	//public transient list<CSD_ClsEntityType.CSDColumn> list_OEMColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_PartColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_TotalColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_GPLFamilyColumns {get;set;}
	public transient list<CSD_ClsEntityType.CSDColumn> list_GPLCodeColumns {get;set;}
	
	public transient list<Object> list_popupColumnsLevle1 {get;set;}
	public transient list<Object> list_popupColumnsLevle2 {get;set;}
	public transient list<Object> list_popupColumnsLevle3 {get;set;}
	//public transient list<Object> list_soldToData {get;set;}
	public transient list<Object> list_GPLFamilyData {get;set;}
	
	public transient String RESTSOLDTOID {get;set;}
	public transient String RESTPARTID {get;set;}
	public transient String managername {get;set;}
	public transient String jsonmonthspercent {get;set;}
	public transient String jsonAttention {get;set;}
	
	public CSD_Interface.ACSDCtrlService csdService {get;set;}

	{
		
		this.lc = new CSD_ClsEntityType.LocaleConfig();
		CSD_ClsUtils.setUserLocale(this.lc, userInfo.getLocale());	//set user locale
	}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public CSD_CtrlSamsungForecast(){
		this.csdService = new CSD_ClsOEMService();
		initCSD();
		
	}
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************

	public CSD_CtrlSamsungForecast getThis(){
		return this;
	}
    
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */ 
	public void initCSD(){
		try {
			this.RESTSOLDTOID = CSD_ClsUtils.RESTSOLDTOID;
			this.RESTPARTID = CSD_ClsUtils.RESTPARTID;
			this.managername = '';
			this.pageConf = new CSD_ClsEntityType.PageConfig();
			system.debug('@#Parameters: '+Apexpages.currentPage().getParameters());
			if(Apexpages.currentPage().getParameters().containsKey('mid')) {
            	this.pageConf.managerId = CSD_ClsUtils.decryptionFormInput(Apexpages.currentPage().getParameters().get('mid'));
            	Boolean isNotPermissions = true;
            	for(User user : [select Id, Name from User 
            					 where Id = :this.pageConf.managerId and CSD_Forecast_Delegation__c = :UserInfo.getUserId()]) {
            		this.managername = 'Edit as [ ' + user.Name + ' ]';	 	 
					isNotPermissions = false;
				}
            	if(isNotPermissions) {
            		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, 'You do not have permission to access this page.'));
            		return;
            	}
            }else {
            	this.pageConf.managerId = UserInfo.getUserId();
            }
			
			if(CSD_Configuration__c.getInstance('Samsung OEM Account') != null || CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != null) {
				this.pageConf.samsungId = CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c;
			}
			this.csdService.setPageConf(this.pageConf);
			 system.debug('@#this.pageConf.managerId: '+this.pageConf.managerId);
			this.setPopupColumnsLevle1();
			this.setPopupColumnsLevle2();
			this.setPopupColumnsLevle3();
			
			//this.setTotalColumns();
			//this.setOEMColumns();
			this.list_TotalColumns = new list<CSD_ClsEntityType.CSDColumn>();
			this.setGPLFamilyColumns();
			this.setGPLCodeColumns();
			this.setPartColumns();
			this.setSoldToColumns();
			this.setList_allDateItems();
			
			this.setList_GPLData();
			
			map<Integer, decimal> map_month_Percent = new map<Integer, decimal>();
            CSD_ClsUtils.setStatisticalPercentMap(map_month_Percent);
            this.jsonmonthspercent = Json.serialize(map_month_Percent);
			
			if(list_GPLFamilyData.size() < 1) {
				this.list_allDateItems.clear();
				this.pageConf.str_tableHead = 'null';
			}
			
			this.jsonAttention = CSD_ClsUtils.getAttentionString();
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
		}
		
		//this.csdService.getAcctInfo(this.pageConf);
	}
	

   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setList_allDateItems(){
		this.list_allDateItems = new list<CSD_ClsEntityType.DateItem>();
		this.csdService.setAllDateItems(this.pageConf, this.list_allDateItems);
	}
	
	
	
	public void setList_GPLData(){
		this.list_GPLFamilyData = new list<Object>();
		csdService.setLevel1Data(this.list_GPLFamilyData, this.pageConf);
	}
	
	
	/**
    * This method is used to generate GPL Family columns
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setGPLFamilyColumns(){
		this.list_GPLFamilyColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel1Row(this.list_GPLFamilyColumns);
	}
	
	
	/**
    * This method is used to generate GPL Code columns
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setGPLCodeColumns(){
		this.list_GPLCodeColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel2Row(this.list_GPLCodeColumns);
	}
	
	
	/**
    * This method is used to generate Total Columns
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setTotalColumns(){
		this.list_TotalColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setTotalRow(this.list_TotalColumns);
	}
	
	
   /**
    * This method is used to generate SoldTo Columns
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setSoldToColumns(){
		this.list_SoldToColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel4Row(this.list_SoldToColumns);
	}

	
	
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void setPartColumns(){
		this.list_PartColumns = new list<CSD_ClsEntityType.CSDColumn>();
		this.csdService.setLevel3Row(this.list_PartColumns);
	}

	public void setPopupColumnsLevle1(){
		this.list_popupColumnsLevle1 = new list<Object>();
		this.csdService.setPopUPBoxColumnLevel1(this.list_popupColumnsLevle1);
	}
	
	public void setPopupColumnsLevle2(){
		this.list_popupColumnsLevle2 = new list<Object>();
		this.csdService.setPopUPBoxColumnLevel2(this.list_popupColumnsLevle2);
	}
	
	public void setPopupColumnsLevle3(){
		this.list_popupColumnsLevle3 = new list<Object>();
		this.csdService.setPopUPBoxColumnLevel3(this.list_popupColumnsLevle3);
	}
	
	@RemoteAction
	public static String checkSoldTo(String sData) {
		
		CSD_ClsEntityType.SearchObjExpand searchOb = (CSD_ClsEntityType.SearchObjExpand)JSON.deserialize(sData, CSD_ClsEntityType.SearchObjExpand.class);
		system.debug('@#searchOb:'+searchOb);
		map<String, set<String>> map_Soldto_part = new map<String, set<String>>();
        set<String> set_allparts = new set<String>();
        String useremail = '%null%';
		for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(searchOb.managerId)]) {
			useremail = '%' + user.Email + '%';
		}
		
		for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c
										from CSD_Samsung_Mapping__c 
										where Sales_Email__c like :useremail 
											AND GPL_Family__c = :searchOb.gplfamily  ]) {
			if(map_Soldto_part.containsKey(sm.Category__c)) {
				map_Soldto_part.get(sm.Category__c).add(sm.Part__c);
				
			}else {
				set<String> set_parts = new set<String>();
				set_parts.add(sm.Part__c);
				map_Soldto_part.put(sm.Category__c, set_parts);
			}
			if(!set_allparts.contains(sm.Part__c)) {
				set_allparts.add(sm.Part__c);
			}
		}
		
		system.debug('@#map_Soldto_part:'+map_Soldto_part);
		
		list<String> list_sql = new list<String>();
        set<String> set_selectedCode = new set<String>();
        
        if(searchOb.set_selectedId == null) {
            searchOb.set_selectedId = new set<string>();
        }
        if(searchOb.set_deletedId == null){
        	searchOb.set_deletedId = new set<string>();
        }
        if(searchOb.set_deletedgplcodes == null) {
            searchOb.set_deletedgplcodes = new set<string>();
        }
        if(searchOb.set_selectdsoldtonumbers == null) {
        	searchOb.set_selectdsoldtonumbers = new set<string>();
        }
		set<String> set_syssoldtos = new set<String>();
		set<String> deletedpart = searchOb.set_deletedId;
		set<String> deletedgplcode = searchOb.set_deletedgplcodes;
		
		list_sql.add(' Part__c part, GPL_Code__c gplcode, Sold_To_Number__c soldto, Samsung_Type__c samtype ');
        list_sql.add(' CSD_Sales_Forecast__c ');
        list_sql.add(' WHERE Type__c = \'Sold-To\' '
                //+ ' And (Samsung_Type__c = null or Samsung_Type__c = \'Non SoldTo\' or Samsung_Type__c = \'Non Part\') '
                + ' And OEM__c = \'' + searchOb.oemId + '\' '
                + ' And GPL_Family__c = \'' + searchOb.gplfamily + '\' '
                //+ ' And Sold_To_Number__c IN :map_Soldto_part.keySet() '
                //+ ' And Part__c IN :set_allparts '
               	+ (deletedpart.size() > 0 ? ' And Part__c not IN :deletedpart ' : '')
                + (deletedgplcode.size() > 0 ? ' And GPL_Code__c not IN :deletedgplcode ' : '' )
                + ' Group by Part__c, GPL_Code__c, Sold_To_Number__c, Samsung_Type__c');
		system.debug('@#list_sql:'+CSD_ClsUtils.getQueryString(list_sql));
		for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
			if(result.get('samtype') == null || (String)result.get('samtype') == 'Non SoldTo') {
				if(!searchOb.set_selectedId.contains((String)result.get('part')) ) {
					searchOb.set_selectedId.add((String)result.get('part'));
				}
			}else {
				if(!set_syssoldtos.contains((String)result.get('soldto')) ) {
					set_syssoldtos.add((String)result.get('soldto'));
				}
			}
        }
		
		system.debug('@#searchOb.set_selectedId:'+searchOb.set_selectedId);
		
		set<String> nopartsoldto = new set<String>();
		for(String soldto : map_Soldto_part.keySet()) {
			Boolean hasotherpart = false;
			
			if(!searchOb.set_selectdsoldtonumbers.contains(soldto)) {
				continue;
			}
			
			for(String part : map_Soldto_part.get(soldto)) {
				if(!searchOb.set_selectedId.contains(part)) {
					hasotherpart = true;
				}
			}
			
			if(!hasotherpart){
				nopartsoldto.add(soldto);
			}
			
		}
		system.debug('@#nopartsoldto:'+nopartsoldto);
		return JSON.serialize(nopartsoldto);
	}
	
	
	
	@RemoteAction
	public static String saveSamsungOEMLevel(String sData) {
			
		try {
         	CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
            system.debug('@#searchOb'+searchOb);
            
            String oemId = '';
            if(CSD_Configuration__c.getInstance('Samsung OEM Account') != null || CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c != null) {
				oemId = CSD_Configuration__c.getInstance('Samsung OEM Account').Value__c;
			}else {
				return 'false';
			}
            
            Date currentdate = Date.valueOf(searchOb.startDate);
            Date enddate = Date.valueOf(searchOb.endDate);
			set<String> set_accids = new set<String>();
			list<CSD_Sales_Forecast__c> list_delcsd = new list<CSD_Sales_Forecast__c>();
            map<String, map<String, CSD_Sales_Forecast__c>> map_accnumber_datakey_forecast = new map<String, map<String, CSD_Sales_Forecast__c>>();
            for(CSD_Sales_Forecast__c csd : [select Id, Sold_To_Number__c, OEM__c, Forecast__c, Fiscal_Year__c, 
            										Fiscal_Month__c, DC_Forecast_Amount__c, Previous_Month_Forecast__c
            									from CSD_Sales_Forecast__c
            									where OEM__c = :oemId And Type__c = 'OEM' And Sold_To_Number__c != null 
            										And Fiscal_Date__c >= : currentdate And Fiscal_Date__c < : enddate ]) {
            	set_accids.add(csd.Sold_To_Number__c);
            	list_delcsd.add(csd);
            	/*String accId = csd.Sold_To_Number__c, 
                        year = (String)csd.Fiscal_Year__c,
                        month = (String)csd.Fiscal_Month__c, 
                        dateKey = (year + '_' + month);
                if(!map_accnumber_datakey_forecast.containsKey(accId)) {
                    map_accnumber_datakey_forecast.put(accId, new map<String, CSD_Sales_Forecast__c>());
                }
                if(!map_accnumber_datakey_forecast.get(accId).containsKey(dateKey)) {
                    map_accnumber_datakey_forecast.get(accId).put(dateKey, csd);
                }*/
            }
            if(list_delcsd.size() > 0) {
            	delete list_delcsd;
            }
            list<String> list_sql = new list<String>();
            
            list_sql.add(' Sold_To_Number__c soldto, Fiscal_Year__c year, Fiscal_Month__c month, '
                        + ' sum(Forecast__c) sumFC, '
                        + ' sum(DC_Forecast_Amount__c) sumDCFC, sum(Previous_Month_Forecast__c) sumPMFC ');
            list_sql.add(' CSD_Sales_Forecast__c ');
            list_sql.add(' WHERE OEM__c = \'' + oemId + '\' ' 
                   	+ ' And Sold_To_Number__c != null '
                    + ' And Type__c = \'Sold-To\' '
                    + ' And Fiscal_Date__c >= : currentdate '
                    + ' And Fiscal_Date__c < : enddate '
                    + ' Group by Fiscal_Year__c, Fiscal_Month__c, Sold_To_Number__c  ');
            
            map<String, String> map_accnumber_name = new map<String, String>();
            for(Account acc : [select Id, Name, AccountNumber from Account 
            						//where AccountNumber IN :map_accnumber_datakey_forecast.keySet()
            						where AccountNumber IN :set_accids
                                 	and RecordType.Name = 'Account' and STATDESC__c = 'Active']) {
           		if(!map_accnumber_name.containsKey(acc.AccountNumber)) {
           			map_accnumber_name.put(acc.AccountNumber, acc.Name);
           		}	
            }
            
            list<CSD_Sales_Forecast__c> list_forecast = new list<CSD_Sales_Forecast__c>();
            for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
                
                String accId = (String)result.get('soldto'), 
                       year = (String)result.get('year'),
                       month = (String)result.get('month'), 
                       dateKey = (year + '_' + month);
                       
                CSD_Sales_Forecast__c forecast = new CSD_Sales_Forecast__c();
                forecast.Price__c = 0;
                forecast.Quantity__c = 0;
                forecast.Forecast__c = (decimal)result.get('sumFC');
                forecast.Rest_Parts_Forecast__c = 0;
                forecast.Previous_Month_Forecast__c = (decimal)result.get('sumPMFC');
                forecast.DC_Forecast_Amount__c = (decimal)result.get('sumDCFC');
                forecast.Fiscal_Year__c = year;
                forecast.Fiscal_Month__c = month;
                forecast.Sold_To_Number__c = accId;
                forecast.OEM__c = oemId;
                forecast.Sold_To_Name__c = map_accnumber_name.containsKey(accId) ? map_accnumber_name.get(accId) : '';  //(String)result.get('accname');
                forecast.Type__c = 'OEM';
                /*if(map_accnumber_datakey_forecast.containsKey(accId) && map_accnumber_datakey_forecast.get(accId).containsKey(dateKey)) {
                    forecast.Id = map_accnumber_datakey_forecast.get(accId).get(dateKey).Id;
                }*/
                
                //modified by chenchen on 2017-02-10
                //forecast.Billing_Region__c = 'KOREA';
                forecast.Billing_Region__c = 'Asia';
                //end
                
                forecast.CurrencyIsoCode = 'USD';
                list_forecast.add(forecast);

            }
            
            if(list_forecast.size() > 0) {
                upsert list_forecast;
            }
            
			return 'true';
        }catch(Exception ex) {
            throw ex;
        }
        
        return 'true';
		
	} 
	
	@RemoteAction
	public static String checkParthasSoldto(String sData) {
		
		CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData, CSD_ClsEntityType.SearchObj.class);
        system.debug('@#searchOb'+searchOb);
		String useremail = '%%';
		for(User user : [select Email from User where Id = :CSD_ClsUtils.getManageUserId(searchOb.managerId)]) {
			useremail = '%' + user.Email + '%';
		}
		
		for(AggregateResult fc : [select  Sold_To_Number__c soldto
                                                From CSD_Sales_Forecast__c 
                                                where OEM__c = :searchOb.oemId 
                                                	And GPL_Family__c = :searchOb.gplfamily
                                                    And Part__c = :searchOb.partId 
                                                    And Type__c = 'Sold-To'
                                                    And Samsung_Type__c = null
                                                group by Sold_To_Number__c ] ) {
             if(!searchOb.set_selectedId.contains((String)fc.get('soldto'))) {
             	searchOb.set_selectedId.add((String)fc.get('soldto'));
             }
        }
		
		system.debug('@#searchOb.set_selectedId:'+searchOb.set_selectedId);
		
		for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
										from CSD_Samsung_Mapping__c 
										where Sales_Email__c like :useremail 
											AND GPL_Family__c = :searchOb.gplfamily
											AND Part__c = :searchOb.partId]) {
			if(!searchOb.set_selectedId.contains(sm.Category__c)) {
				system.debug('@#true');
				return 'true';
			}
		}
		system.debug('@#false');
		return 'false';
		
	}
	
	
	
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	//********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
	
}