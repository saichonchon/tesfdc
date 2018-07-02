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
public without sharing class CSD_CtrlImportSamSungMapping {
	
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
    public CSD_CtrlImportSamSungMapping(){
    	this.isStop = false;
    	this.isError = false;
        this.batchNum = 1000;
        //the map values must be CSD_CtrlImportSamSungMapping.CustomSamSungMappping class field match.
        map<String, String> map_mapping = new map<String, String>{
        	'Category' => 'category', 
        	'PN' => 'pn', 
        	'Assigned DSE Email' => 'assigneddesemail',
        	'PN indicator' => 'pnindicator'
        	/*
        	'Assigned DSE' => 'assigneddes',
        	'PN Des.' => 'pnDes',
        	'Sold to Name' => 'soldtoname',
        	'Sold to ID' => 'soldtonumber',
        	'Org. ID' => 'orgid',
        	'DD7 Territory Name' => 'territoryname',
        	*/
        };
		list<String> list_head = new list<String>{
			'Category', 'PN', 'Assigned DSE Email', 'PN indicator'
			 /*'PN Des.', 'Sold to Name', 'Sold to ID', 'Org. ID', 'Assigned Dse', 'DD7 Territory Name', */
        };
        this.jsonCSVHead = String.join(list_head, ',');
        this.jsonMapping = Json.serialize(map_mapping);
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    

    
    //********************************* -=BEGIN public methods=- **********************************
	/**
    * This method is used to delete SamSung Mapping records
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
    		for(CSD_Samsung_Mapping__c kpm : [Select Id From CSD_Samsung_Mapping__c limit 10000]){
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
    	list<CustomSamSungMappping> list_fc = (list<CustomSamSungMappping>)JSON.deserialize(o, list<CustomSamSungMappping>.class);
    	
    	list<ExceptionObj> list_exception = new list<ExceptionObj>();
    	list<CSD_Samsung_Mapping__c> list_upsert = new list<CSD_Samsung_Mapping__c>();
    	map<String, list<CustomSamSungMappping>> map_mapping = new map<String, list<CustomSamSungMappping>>();

    	matchUploadData(list_fc, map_mapping);
    	matchListForecast(map_mapping, list_upsert, list_exception);
    	
    	if(!list_upsert.isEmpty()) {
		//	upsert list_upsert External_Id__c;
			Database.UpsertResult[] list_result = database.upsert(list_upsert, CSD_Samsung_Mapping__c.External_Id__c.getDescribe().getSObjectField(), false);
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
    private static void matchUploadData(list<CustomSamSungMappping> list_fc,
    											map<String, list<CustomSamSungMappping>> map_mapping){
		
		checkSoldTo(list_fc, map_mapping);
    	checkUserEmail(list_fc);
    	checkPart(list_fc, map_mapping);
	}
	
	private static void checkSoldTo(list<CustomSamSungMappping> list_fc, map<String, list<CustomSamSungMappping>> map_mapping){
		for(CustomSamSungMappping fc : list_fc){
			if(!map_mapping.containsKey(fc.category)){
				map_mapping.put(fc.category, new list<CustomSamSungMappping>());
			}
			map_mapping.get(fc.category).add(fc);
		}
		
		for(Account a : [Select Id, Name, AccountNumber From Account 
							Where STATDESC__c = 'Active' 
							AND (AccountNumber =: map_mapping.keySet()) 
							order by AccountNumber asc]){
			if(!map_mapping.containsKey(a.AccountNumber)){ continue; }
			for(CustomSamSungMappping cs : map_mapping.get(a.AccountNumber)){
				cs.accountId = a.Id;
				cs.soldtoname = a.Name;
			}
    	}
		list_fc.clear();
		
		
    	for(String key : map_mapping.keySet()){
			list_fc.addAll(map_mapping.get(key));
    	}
		map_mapping.clear();
	}
	
	private static void checkPart(list<CustomSamSungMappping> list_fc, map<String, list<CustomSamSungMappping>> map_mapping){
		for(CustomSamSungMappping fc : list_fc){
			if(!map_mapping.containsKey(fc.pn)){
				map_mapping.put(fc.pn, new list<CustomSamSungMappping>());
			}
			map_mapping.get(fc.pn).add(fc);
		}
		
		for(Part__c p : [Select Id, GPL_txt__c, Product_Hierarchy__r.CBC2_Description__c, Name From Part__c Where Name =: map_mapping.keySet()]){
			if(!map_mapping.containsKey(p.Name)){ continue; }
			for(CustomSamSungMappping cs : map_mapping.get(p.Name)){
				cs.partId = p.Id;
				cs.gplCode = p.GPL_txt__c;
				cs.gplfamily = p.Product_Hierarchy__r.CBC2_Description__c;
			}
    	}
    	
    	list_fc.clear();
	}
	
	private static void checkUserEmail(list<CustomSamSungMappping> list_fc){
		map<String, User> map_user = new map<String, User>();
    	for(User u : [Select Id, Email From User Where IsActive = true]){
    		map_user.put(u.Email, u);
    		
    	}
		for(CustomSamSungMappping cs : list_fc){
			cs.userEmail = (map_user.containsKey(cs.assigneddesemail) ? cs.assigneddesemail : null);
		}
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
    private static void matchListForecast(map<String, list<CustomSamSungMappping>> map_mapping,
    										list<CSD_Samsung_Mapping__c> list_upsert, list<ExceptionObj> list_exception){

		for(String key : map_mapping.keySet()){
	    	for(CustomSamSungMappping fc : map_mapping.get(key)){
				list<String> list_str = new list<String>();
	    		String externalId = fc.category + '-' + fc.pn + '-' + fc.assigneddesemail;
				Boolean isError=false, isIndicator= ('yes'.equalsIgnoreCase(fc.pnindicator) ? true : false);
				
				if(String.isBlank(fc.accountId)){
					list_str.add('Category');
				}
				
				if(String.isBlank(fc.partId)){
					list_str.add('PN');
				}
				
				if(String.isBlank(fc.userEmail)){
					list_str.add('Assigned DSE Email');
				}

				if(list_str.isEmpty()){
					CSD_Samsung_Mapping__c sm = new CSD_Samsung_Mapping__c(
												Category__c = fc.category, GPL_Code__c = fc.gplCode, Sales_Email__c = fc.assigneddesemail,
												GPL_Family__c = fc.gplfamily, Sold_to_Name__c = fc.soldtoname,
												Part_Name__c = fc.pn, PN_indicator__c = isIndicator, 
												External_Id__c = externalId, Part__c = fc.partId
												//Sold_to_ID__c = fc.soldtonumber, Org_ID__c = fc.orgid, PN_Description__c = fc.pnDes,
												);
					list_upsert.add(sm);
				}else{
					String t = (CSD_ClsUtils.getFormatString(list_str) + ' does not match!');
					list_exception.add( new ExceptionObj(t, fc.index) );
				}
	    	}
		}
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    
    public class CustomException extends Exception{
    	public Integer index {get; set;}
    }
    
    public class ExceptionObj {
    	public String errorMsg {get; set;}
    	public Integer index {get; set;}
    	
    	public ExceptionObj(String errorMsg, Integer index){
    		this.errorMsg = errorMsg;
    		this.index = index;
    	}
    	
    }
    
    public class SuccessResponse {
    	public String status {get; set;}
    	public Integer index {get; set;}
    }
    
    public class CustomSamSungMappping{
		public String category {get;set;}
		public String accountId {get;set;}
		public String partId {get;set;}
    	public String gplfamily {get;set;}
    	public String gplCode {get;set;}
    	public String pn {get;set;}
    	public String pnDes {get;set;}
    	public String soldtoname {get;set;}
    	public String soldtonumber {get;set;}
    	public String orgid {get;set;}
    	public String assigneddes {get;set;}
    	public String assigneddesemail {get;set;}
    	public String userEmail {get;set;}
    	public String territoryname {get;set;}
    	public String pnindicator {get;set;}
    	public Integer index {get; set;}
    }
    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}