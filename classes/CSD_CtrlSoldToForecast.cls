/**
 *  Ctrl class for CSD_CtrlSoldToForecast
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
public without sharing class CSD_CtrlSoldToForecast extends CSD_CtrlForecastRemoteBase {
    
     //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public transient CSD_ClsEntityType.LocaleConfig lc {get;set;}

    public transient CSD_ClsEntityType.PageConfig pageConf {get; set;}
    
    public transient list<CSD_ClsEntityType.DateItem> list_allDateItems {get; set;}
    public transient list<CSD_ClsEntityType.CSDColumn> list_SoldToColumns {get;set;}
    public transient list<CSD_ClsEntityType.CSDColumn> list_OEMColumns {get;set;}
    public transient list<CSD_ClsEntityType.CSDColumn> list_PartColumns {get;set;}
    public transient list<CSD_ClsEntityType.CSDColumn> list_TotalColumns {get;set;}
    
    public transient list<Object> list_popupColumnsLevle1 {get;set;}
    public transient list<Object> list_popupColumnsLevle2 {get;set;}
    public transient list<Object> list_popupColumnsLevle3 {get;set;}
    public transient list<Object> list_soldToData {get;set;}
    public transient String RESTSOLDTOID {get;set;}
    public transient String NONOEMSID {get;set;}
    public transient String managername {get;set;}
    public transient String totalbacklogname {get;set;}
    public transient map<Integer, decimal> map_month_Percent {get;set;}
    public transient String jsonmonthspercent {get;set;}
    public transient String jsonAttention {get;set;}
    
    public CSD_Interface.ACSDCtrlService csdService {get;set;}
    

    {
        
        this.lc = new CSD_ClsEntityType.LocaleConfig();
        CSD_ClsUtils.setUserLocale(this.lc, userInfo.getLocale());  //set user locale
    }
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CSD_CtrlSoldToForecast(){
        
        this.csdService = new CSD_ClsSoldToService();   //init gam service interface
        initCSD();
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************

    public CSD_CtrlSoldToForecast getThis(){
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
            if(CSD_Configuration__c.getInstance('Non OEM Account') != null && CSD_Configuration__c.getInstance('Non OEM Account').Value__c != null) {
	        	this.NONOEMSID = CSD_Configuration__c.getInstance('Non OEM Account').Value__c;
			}
            this.totalbacklogname = CSD_ClsUtils.MAP_ROWLABEL_ROWNAME.get('Total Backlog');
            
            this.setPopupColumnsLevle1();
            this.setPopupColumnsLevle2();
            this.setPopupColumnsLevle3();
            this.managername = 	'';
            this.jsonAttention = '';
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
			
            this.csdService.setPageConf(this.pageConf);
            system.debug('@# pageConf : '+this.pageConf);
            this.list_TotalColumns = new list<CSD_ClsEntityType.CSDColumn>();
            //this.setTotalColumns();
            this.setSoldToColumns();
            this.setOEMColumns();
            this.setPartColumns();
            this.setList_allDateItems();
            
            this.setList_soldToData();
            
            this.map_month_Percent = new map<Integer, decimal>();
            CSD_ClsUtils.setStatisticalPercentMap(this.map_month_Percent);
            this.jsonmonthspercent = Json.serialize(this.map_month_Percent);
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
    
    
    /**
    * This method is used to get level 1 data
    *
    @author Lei Tang
    @created 2014-11-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-22 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public void setList_soldToData(){
        this.list_soldToData = new list<Object>();
        csdService.setLevel1Data(this.list_soldToData, this.pageConf);
    }
    
    
    /**
    * This method is used to generate level total columns
    *
    @author Lei Tang
    @created 2014-11-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-22 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public void setTotalColumns(){
        this.list_TotalColumns = new list<CSD_ClsEntityType.CSDColumn>();
        this.csdService.setTotalRow(this.list_TotalColumns);
    }
    
    /**
    * This method is used to generate level 1 columns
    *
    @author Lei Tang
    @created 2014-11-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-22 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public void setSoldToColumns(){
        this.list_SoldToColumns = new list<CSD_ClsEntityType.CSDColumn>();
        this.csdService.setLevel1Row(this.list_SoldToColumns);
    }
    
    /**
    * This method is used to generate level 2 columns
    *
    @author Lei Tang
    @created 2014-11-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-22 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
    public void setOEMColumns(){
        this.list_OEMColumns = new list<CSD_ClsEntityType.CSDColumn>();
        this.csdService.setLevel2Row(this.list_OEMColumns);
    }
    
    
    /**
    * This method is used to generate level 3 columns
    *
    @author Lei Tang
    @created 2014-11-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-22 Lei Tang <lei.tang@itbconsult.com>
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
    public static String saveSoldToEOL(String sData) {
        try {
            CSD_ClsEntityType.SearchObj searchobj = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
            
            list<Account> list_Accounts = new list<Account>();
            
            for(Account acc : [select Id, Name, CSD_EOL_Comment__c from Account where AccountNumber = :searchobj.accnumber limit 1] ) {
                
                acc.CSD_EOL_Comment__c = searchobj.searchKey;
                list_Accounts.add(acc);
            }       

            if(list_Accounts.size() > 0) {
                update list_Accounts;
            }

            return 'true'; 
        }catch(Exception ex) {
            throw ex;
        }
    }
    
    
    @RemoteAction
	public static String hasKeyPart(String sData) {
	    /*try {
	        CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
	        
	        Date fiscaldate = CSD_ClsUtils.getFiscalDate();
	        Date enddate = fiscaldate.addMonths(13);
	        
	        if(searchOb.set_selectedId == null){
	            searchOb.set_selectedId = new set<string>();
	        }
	        if(searchOb.set_deletedId == null){
	            searchOb.set_deletedId = new set<string>();
	        }
	        
	        list<String> list_sql = new list<String>();
	        list_sql.add(' Part__c part ');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c = \'Part\' '
	                + ' And Sold_To_Number__c = \''+searchOb.accnumber+'\' ' 
	                + ' AND OEM__c = \''+searchOb.oemId+'\' '
	                + ' And Fiscal_Date__c >= : fiscaldate '
	                + ' And Fiscal_Date__c < : enddate '
	                + ' Group by Part__c ');
	
	        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	            if(!searchOb.set_selectedId.contains((String)result.get('part')) && !searchOb.set_deletedId.contains((String)result.get('part'))){
	                searchOb.set_selectedId.add((String)result.get('part'));
	            }
	        }
	        
	        for(CSD_Key_Part_Management__c part : [select Id, Part__c, Part__r.Name, Part__r.Description__c from CSD_Key_Part_Management__c 
	                            where SoldTo_Number__c = :searchOb.accnumber And OEM__c = :searchOb.oemId 
	                                And Part__c not IN :searchOb.set_selectedId limit 1]) {
	            return 'true';
	        }
	        
	        return 'false';
	
	    }catch(Exception ex) {
	        throw ex;
	    }*/
	    return 'false';
	}


	@RemoteAction
	public static String searchKeyPart(String sData) {
	    try {
	        CSD_ClsEntityType.SearchObj searchOb = (CSD_ClsEntityType.SearchObj)JSON.deserialize(sData,CSD_ClsEntityType.SearchObj.class);
	        system.debug('@#searchOb:'+searchOb);
	        String searchDescOrNumber = '%'+searchOb.searchKey+'%';
	        
	        if(searchOb.set_selectedId == null){
	            searchOb.set_selectedId = new set<string>();
	        }
	        if(searchOb.set_deletedId == null){
	            searchOb.set_deletedId = new set<string>();
	        }
	        
	        Date fiscaldate = CSD_ClsUtils.getFiscalDate();
	        Date enddate = fiscaldate.addMonths(13);
	        
	        list<String> list_sql = new list<String>();
	        list_sql.add(' Part__c part ');
	        list_sql.add(' CSD_Sales_Forecast__c ');
	        list_sql.add(' WHERE Type__c = \'Part\' '
	                + ' And Sold_To_Number__c = \''+searchOb.accnumber+'\' ' 
	                + ' AND OEM__c = \''+searchOb.oemId+'\' '
	                + ' And Fiscal_Date__c >= : fiscaldate '
	                + ' And Fiscal_Date__c < : enddate '
	                + ' Group by Part__c ');
	
	        for(AggregateResult result : Database.query(CSD_ClsUtils.getQueryString(list_sql))) {
	            if(!searchOb.set_selectedId.contains((String)result.get('part')) && !searchOb.set_deletedId.contains((String)result.get('part'))){
	                searchOb.set_selectedId.add((String)result.get('part'));
	            }
	        }
	        
	        set<String> set_hascftpartid = new set<String>();
            map<String, CSD_Key_Part_Management__c> map_partid_part = new map<String, CSD_Key_Part_Management__c>();
	        
	        list<CSD_ClsEntityType.PartObj> list_parts = new list<CSD_ClsEntityType.PartObj>();
	        for(CSD_Key_Part_Management__c part : [select Id, Part__c, Part__r.Name, Part__r.Description__c  from CSD_Key_Part_Management__c 
	                            where (Part__r.Description__c like :searchDescOrNumber or Part__r.Name like :searchDescOrNumber )
	                            And (Type__c = 'Global' OR (Type__c = 'Key Part' And OwnerId = :UserInfo.getUserId()))
	                            And Part__c not IN :searchOb.set_selectedId
	                            order by Part__r.Name 
	                            limit 100]) {
	            
	            map_partid_part.put(String.valueOf(part.Part__c).substring(0,15), part);
	        }
	        
	        if(map_partid_part.size() > 0) {
            	CSD_ClsUtils.hasCFTForecast(searchOb.soldtoId, searchOb.oemId, map_partid_part.keySet(), fiscaldate, enddate, set_hascftpartid);
            	map<String, String> map_part_region = CSD_ClsUtils.getPartRegion(searchOb.accnumber, searchOb.oemId, map_partid_part.keySet());
            	system.debug('@#map_partid_part:'+map_partid_part);
            	for(CSD_Key_Part_Management__c part : map_partid_part.values()) {
	                CSD_ClsEntityType.PartObj partObj = new CSD_ClsEntityType.PartObj();
		            partObj.id = part.Part__c;
		            partObj.name = part.Part__r.Name;
		            partObj.snumber = part.Part__r.Description__c;
	                partObj.hasCFTFC = false;
	                partObj.region = map_part_region.containsKey(String.valueOf(part.Part__c).substring(0,15)) ? map_part_region.get(String.valueOf(part.Part__c).substring(0,15)) : '';
					if(set_hascftpartid.contains(part.Id)) {
						partObj.hasCFTFC = true;
					}
					list_parts.add(partObj);
            	}
            }
	        
	        return JSON.serialize(list_parts);
	        
	
	    }catch(Exception ex) {
	        throw ex;
	    }
	}
    
	@RemoteAction
	public static String autoCreateOEMForecast(String sData) {
		
		list<Object> list_data = new list<Object>();
		
		CSD_ClsUtils.autoCreateOEMForecastAndGetSoldtoData(list_data, sData);
		system.debug('@#list_data :'+JSON.serialize(list_data));
		return JSON.serialize(list_data);
		
	}



    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    

    
    
    
    
    
}