/**
 *  This class used to csv file upload
 *
 @author Minghao Li
 @created 2014-11-20
 @version 1.0
 @since 30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
 * - Created
 */
public without sharing class CSD_CtrlImportKeyPart {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public transient String jsonMapping {get;set;}
    public transient String jsonCSVHead {get;set;}
    public Integer batchNum {get;set;}
    public Boolean isStop {get;set;}
    public Boolean isError {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CSD_CtrlImportKeyPart(){
    	this.isStop = false;
    	this.isError = false;
        this.batchNum = 200;

        /*map<String, String> map_mapping = new map<String, String>{
        	'Soldto Number' => 'soldtonumber', 
        	'OEM Name' => 'oemname', 
        	'Part Number' => 'partnumber'
        };
		list<String> list_head = new list<String>{ 'Soldto Number', 'OEM Name', 'Part Number' };*/
		map<String, String> map_mapping = new map<String, String>{
        	'Part Number' => 'partnumber'
        };
		list<String> list_head = new list<String>{ 'Part Number' };
        this.jsonCSVHead = String.join(list_head, ',');
        this.jsonMapping = Json.serialize(map_mapping);
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    

    
    //********************************* -=BEGIN public methods=- **********************************
	/**
    * This method is used to delete key part managements records 
    *
    @author Minghao Li
    @created 2014-11-21
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    public void deleteObject(){
    	this.isError = false;
    	try{
    		list<Sobject> list_kpm = new list<Sobject>();
    		for(CSD_Key_Part_Management__c kpm : [Select Id From CSD_Key_Part_Management__c where Type__c = 'Global' limit 10000]){
    			list_kpm.add(kpm);
    		}
    		
    		this.isStop = (list_kpm.size() < 10000 ? true : false);
    		
    		if(!list_kpm.isEmpty()){
    			delete list_kpm;
    		}
    		
    	}catch(Exception e){
    		this.isStop = true;
    		this.isError = true;
    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
    	}
    }
	/**
    * This method is used to upsert SamSung Mapping 
    *
    @author Minghao Li
    @created 2014-11-21
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String upsertListObject(String o){
    	list<CustomKeyPart> list_fc = (list<CustomKeyPart>)JSON.deserialize(o, list<CustomKeyPart>.class);
    	
    	list<ExceptionObj> list_exception = new list<ExceptionObj>();
    	list<CSD_Key_Part_Management__c> list_upsert = new list<CSD_Key_Part_Management__c>();
    	map<String, list<CustomKeyPart>> map_mapping = new map<String, list<CustomKeyPart>>();

    	matchMapSoldTo_part(list_fc, list_exception, map_mapping);
    	matchListForecast(map_mapping, list_upsert, list_exception);
    	
    	if(!list_upsert.isEmpty()) {
		//	upsert list_upsert External_Id__c;
			Database.UpsertResult[] list_result = database.upsert(list_upsert, false);
			system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@');
			system.debug(list_result);
			system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@');
		}
    	
    	return Json.serialize(list_exception);
    }

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
    * This method is used to match account and part id.
    *
    @author Minghao Li
    @created 2014-11-21
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private static void matchMapSoldTo_part(list<CustomKeyPart> list_fc, list<ExceptionObj> list_exception,
    											map<String, list<CustomKeyPart>> map_mapping){
		

		/*map<String, String> map_oem = new map<String, String>();
		
		for(CustomKeyPart fc : list_fc){
			if(!map_mapping.containsKey(fc.soldtonumber)){
				map_mapping.put(fc.soldtonumber, new list<CustomKeyPart>());
			}
			map_mapping.get(fc.soldtonumber).add(fc);
			map_oem.put(fc.oemname.toLowerCase(), '');
		}
		
		for(Account a : [Select Id, AccountNumber, Account_Type__c, Profit_ctr_code__c, Name From Account Where 
							( STATDESC__c = 'Active' AND AccountNumber IN : map_mapping.keySet() )
        				  		or (OEM_Lower_Name__c IN: map_oem.keySet() and RecordType.Name = 'OEM' 
        				  		//and Profit_ctr_code__c = 'CSD' 
        				  		and Active__c=true)
					//		AND (AccountNumber =: map_mapping.keySet() 
					//				or (Name IN: map_oem.keySet() and Account_Type__c = 'OEM'))
							order by AccountNumber asc]){
			if(map_mapping.containsKey(a.AccountNumber) && a.AccountNumber != ''){ 
				for(CustomKeyPart cs : map_mapping.get(a.AccountNumber)){
					cs.accountId = a.Id;
				}
			}
			if(//a.Profit_ctr_code__c == 'CSD' && 
				a.Account_Type__c == 'OEM' && map_oem.containsKey(a.Name.toLowerCase())) {
				map_oem.put(a.Name.toLowerCase(), a.Id);
			}

    	}
		list_fc.clear();
		for(String oemKey : map_oem.keySet()){
			for(String key : map_mapping.keySet()){
	    		for(CustomKeyPart fc : map_mapping.get(key)){
					if(fc.oemname == oemKey){
						fc.oemId = map_oem.get(oemKey);
					}
				}
	    	}
    	}
    	
    	for(String key : map_mapping.keySet()){
			list_fc.addAll(map_mapping.get(key));
    	}
		map_oem.clear();
		map_mapping.clear();*/
		for(CustomKeyPart fc : list_fc){
			if(!map_mapping.containsKey(fc.partnumber)){
				map_mapping.put(fc.partnumber, new list<CustomKeyPart>());
			}
			map_mapping.get(fc.partnumber).add(fc);
		}
		
		for(Part__c p : [Select Id, Name From Part__c Where Name =: map_mapping.keySet()]){
			if(!map_mapping.containsKey(p.Name)){ continue; }
			for(CustomKeyPart cs : map_mapping.get(p.Name)){
				cs.partId = p.Id;
			}
    	}
    	
    	list_fc.clear();
	}
	
    /**
    * This method is used to match csd mapping samsung forecast
    *
    @author Minghao Li
    @created 2014-11-21
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private static void matchListForecast(map<String, list<CustomKeyPart>> map_mapping,
    										list<CSD_Key_Part_Management__c> list_upsert, list<ExceptionObj> list_exception){
		
		for(String key : map_mapping.keySet()){
	    	for(CustomKeyPart fc : map_mapping.get(key)){
	    		//String externalId = fc.soldtonumber + '-' + fc.oemname + '-' + fc.partnumber;
	    		//String externalId = fc.partnumber + '-Global-' + UserInfo.getUserId();
	    		list<String> list_str = new list<String>();
	    		
	    		/*if(String.isBlank(fc.accountId)){
					list_str.add('Soldto Number');
				}
	
				if(String.isBlank(fc.oemId)){
					list_str.add('OEM Name');
				}*/
				if(String.isBlank(fc.partId)){
					list_str.add('Part Number');
				}
				
				if(!list_str.isEmpty()){
					String t = (CSD_ClsUtils.getFormatString(list_str) + ' does not match!');
		    		list_exception.add(new ExceptionObj(t, fc.index));
					continue;
				}
	    		
				/*CSD_Key_Part_Management__c kpm = new CSD_Key_Part_Management__c(
											SoldTo_Number__c=fc.soldtonumber, OEM_Name__c=fc.oemname, Part_Number__c=fc.partnumber,
											OEM__c=fc.oemId, Part__c=fc.partId, 
											External_Id__c = externalId
											);*/
				CSD_Key_Part_Management__c kpm = new CSD_Key_Part_Management__c(
											Part_Number__c=fc.partnumber, Part__c=fc.partId, Type__c = 'Global'
											);
				list_upsert.add(kpm);
	    	}
		}
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    
    public class CustomException extends Exception{ }
    
    public class ExceptionObj {
    	public String errorMsg {get; set;}
    	public Integer index {get; set;}
    	
    	public ExceptionObj(String errorMsg, Integer index){
    		this.errorMsg = errorMsg;
    		this.index = index;
    	}
    	
    }

    public class CustomKeyPart{
		public String soldtonumber {get;set;}
		public String oemname {get;set;}
		public String partnumber {get;set;}
		public String accountId {get;set;}
		public String oemId {get;set;}
		public String partId {get;set;}
		public Integer index {get;set;}
    }
    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************

}