/**
 *  This class is used to migrate the opportunity forecasts from TOPS system
 *  
 * @author 
 * @created 2012-08-29
 * @version 1.0
 * @since 23.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-08-29 Min Liu<min.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_MigrateOpportunityForecasts implements Database.Batchable<SObject>, Database.Stateful {
  	/**
     * the email address to tell people the status of the batch class after run the batch class
     * before run the batch class, we can define the email manual
     * if not define email address, after the batch completed, will not send email
    */ 
    public String email;
  
	// current year
	public String currentYear;
	// map of external id and sf id
	global Map<String, Opportunity> map_topsId_oppy = new Map<String, Opportunity>();
	global Map<String, Opportunity> map_Id_oppy = new Map<String, Opportunity>();
	global Map<String, Decimal> map_Id_partQty = new Map<String, Decimal>();
	global Map<String, Opportunity_Part__c> map_topsId_part = new Map<String, Opportunity_Part__c>();
	// map of id and currencyIsoCode
	global Map<Id, String> map_oppyId_oppyCurrencyIsoCode = new Map<Id, String>();  
	// ids of lost and dead parts
	global Set<Id> set_DLPartIds = new Set<Id>();
  	// map of record type
  	global Map<String, Id> map_recordTypeName_recordTypeId = new Map<String, Id>();
  	public boolean isCon;
    /** 
    * The contsructor
    *
    @author Min Liu
    @created 2012-08-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-08-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public ClsBatch_MigrateOpportunityForecasts(){
    	//added by weihang 2013-05-28 begin
    	isCon = ClsOppyUtil.getIsConvertVal();
    	//added by weihang 2013-05-28 end
        currentYear = ClsOppyUtil.getForecastYear(system.today());    
        for(RecordType rt :[select Id, DeveloperName from RecordType where SobjectType='opportunity_forecast__c' and (DeveloperName = 'Opportunity' or DeveloperName = 'Part')]){
        	map_recordTypeName_recordTypeId.put(rt.DeveloperName, rt.Id);
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        String query;   
        query = 'SELECT CY_Estimated_Market_Price__c, CY_Q1_Forecast_Amt__c, CY_Q1_Forecast_Qty__c, CY_Q2_Forecast_Amt__c, CY_Q2_Forecast_Qty__c, CY_Q3_Forecast_Amt__c, CY_Q3_Forecast_Qty__c, CY_Q4_Forecast_Amt__c, CY_Q4_Forecast_Qty__c, Initial_Order_Date__c, NY2_Estimated_Market_Price__c, NY2_Q1_Forecast_Amt__c, NY2_Q1_Forecast_Qty__c, NY2_Q2_Forecast_Amt__c, NY2_Q2_Forecast_Qty__c, NY2_Q3_Forecast_Amt__c, NY2_Q3_Forecast_Qty__c, NY2_Q4_Forecast_Amt__c, NY2_Q4_Forecast_Qty__c, NY3_Estimated_Market_Price__c, NY3_Q1_Forecast_Amt__c, NY3_Q1_Forecast_Qty__c, NY3_Q2_Forecast_Amt__c, NY3_Q2_Forecast_Qty__c, NY3_Q3_Forecast_Amt__c, NY3_Q3_Forecast_Qty__c, NY3_Q4_Forecast_Amt__c, NY3_Q4_Forecast_Qty__c, NY4_Estimated_Market_Price__c, NY4_Q1_Forecast_Amt__c, NY4_Q1_Forecast_Qty__c, NY4_Q2_Forecast_Amt__c, NY4_Q2_Forecast_Qty__c, NY4_Q3_Forecast_Amt__c, NY4_Q3_Forecast_Qty__c, NY4_Q4_Forecast_Amt__c, NY4_Q4_Forecast_Qty__c, NY5_Estimated_Market_Price__c, NY5_Q1_Forecast_Amt__c, NY5_Q1_Forecast_Qty__c, NY5_Q2_Forecast_Amt__c, NY5_Q2_Forecast_Qty__c, NY5_Q3_Forecast_Amt__c, NY5_Q3_Forecast_Qty__c, NY5_Q4_Forecast_Amt__c, NY5_Q4_Forecast_Qty__c, NY6_Estimated_Market_Price__c, NY6_Q1_Forecast_Amt__c, NY6_Q1_Forecast_Qty__c, NY6_Q2_Forecast_Amt__c, NY6_Q2_Forecast_Qty__c, NY6_Q3_Forecast_Amt__c, NY6_Q3_Forecast_Qty__c, NY6_Q4_Forecast_Amt__c, NY6_Q4_Forecast_Qty__c, NY7_Estimated_Market_Price__c, NY7_Q1_Forecast_Amt__c, NY7_Q1_Forecast_Qty__c, NY7_Q2_Forecast_Amt__c, NY7_Q2_Forecast_Qty__c, NY7_Q3_Forecast_Amt__c, NY7_Q3_Forecast_Qty__c, NY7_Q4_Forecast_Amt__c, NY7_Q4_Forecast_Qty__c, NY_Estimated_Market_Price__c, NY_Q1_Forecast_Amt__c, NY_Q1_Forecast_Qty__c, NY_Q2_Forecast_Amt__c, NY_Q2_Forecast_Qty__c, NY_Q3_Forecast_Amt__c, NY_Q3_Forecast_Qty__c, NY_Q4_Forecast_Amt__c, NY_Q4_Forecast_Qty__c, OwnerId, PY_Estimated_Market_Price__c, PY_Q1_Forecast_Qty__c, PY_Q2_Forecast_Qty__c, PY_Q3_Forecast_Qty__c, PY_Q4_Forecast_Qty__c, PY2_Estimated_Market_Price__c, PY2_Q1_Forecast_Qty__c, PY2_Q2_Forecast_Qty__c, PY2_Q3_Forecast_Qty__c, PY2_Q4_Forecast_Qty__c, PY2_Q1_Forecast_Amt__c, PY2_Q2_Forecast_Amt__c, PY2_Q3_Forecast_Amt__c, PY2_Q4_Forecast_Amt__c, PY_Q1_Forecast_Amt__c, PY_Q2_Forecast_Amt__c, PY_Q3_Forecast_Amt__c, PY_Q4_Forecast_Amt__c, Id, TOPS_Oppy_ID__c, TOPS_Part_ID__c, Opportunity_Currency__c, CurrencyIsoCode FROM TOPS_Forecast__c';
        return Database.getQueryLocator(query);  
    }

    global void execute(Database.BatchableContext BC, List<TOPS_Forecast__c> list_topsForecast){
	    // map of saved opportunity forecast
	    Map<Id, Map<String, Opportunity_Forecast__c>> map_oppyId_yearQuarter_oppyForecast = new Map<Id, Map<String, Opportunity_Forecast__c>>();
	    Map<Id, Map<String, List<Opportunity_Forecast__c>>> map_oppyId_yearQuarter_partForecasts = new Map<Id, Map<String, List<Opportunity_Forecast__c>>>();     
	  	List<Opportunity_Forecast__c> list_opportunityForecast2Upsert = new List<Opportunity_Forecast__c>();     
	  	// get the names of fields of tops forecast
	    //Set<String> set_field = Schema.SObjectType.TOPS_Forecast__c .fields.getMap().keySet();
	    Set<String> set_oppyTopIds = new set<String>();
	    Set<String> set_partTopIds = new set<String>();
	    // define the number of PY and NY
	    Integer numPY = 2;
	    Integer numNY = 7;
    
	    for(TOPS_Forecast__c tfc : list_topsForecast){
			if(!map_topsId_oppy.containsKey(tfc.TOPS_Oppy_ID__c)){
				set_oppyTopIds.add(tfc.TOPS_Oppy_ID__c);
			}          
			if(!map_topsId_part.containsKey(tfc.TOPS_Part_ID__c)){
				set_partTopIds.add(tfc.TOPS_Part_ID__c);
			}          
	    }
	    if(set_oppyTopIds.size() > 0){
		    for(Opportunity oppy: [select TOPS_ID__c, id, CurrencyIsoCode, Method__c from Opportunity where TOPS_ID__c in :set_oppyTopIds]){
		    	map_topsId_oppy.put(oppy.TOPS_ID__c, oppy);
		    	map_Id_oppy.put(oppy.Id, oppy);
		    }
	    }
  
	  	if(set_partTopIds.size() > 0){
		    for(Opportunity_Part__c part: [select TOPS_ID__c, id, Status__c, Quantity__c from Opportunity_Part__c where TOPS_ID__c in :set_partTopIds and Opportunity__c in :map_Id_oppy.keySet() and isDeleted = false]){
			    map_topsId_part.put(part.TOPS_ID__c, part);
			    map_Id_partQty.put(part.id, part.Quantity__c);
			    if(part.Status__c == 'Dead' || part.Status__c == 'Lost') set_DLPartIds.add(part.id);
		    }
	    }
              
      	for(SObject tf :list_topsForecast){
          	Id oppyId;
          	Id partId;         	
          	String curr = 'USD';
          	
          	if(map_topsId_oppy.containsKey(String.valueOf(tf.get('TOPS_Oppy_ID__c')))){
              	oppyId = map_topsId_oppy.get(String.valueOf(tf.get('TOPS_Oppy_ID__c'))).Id;
              	curr = map_topsId_oppy.get(String.valueOf(tf.get('TOPS_Oppy_ID__c'))).CurrencyIsoCode;
          	}
          	if(map_topsId_part.containsKey(String.valueOf(tf.get('TOPS_Part_ID__c')))){
              	partId = map_topsId_part.get(String.valueOf(tf.get('TOPS_Part_ID__c'))).Id;
          	}          
   
          	if(oppyId != null && !map_oppyId_yearQuarter_partForecasts.containsKey(oppyId)){
              	map_oppyId_yearQuarter_partForecasts.put(oppyId, new Map<String, List<Opportunity_Forecast__c>>());
          	}       	
        	 
          	if(oppyId != null && partId != null){
          		Id recordTypeId;
          		if(map_recordTypeName_recordTypeId.containsKey('Part')) recordTypeId = map_recordTypeName_recordTypeId.get('Part');
          		
              	// CY                  
              	ClsOppyUtil.generateForecasts(tf, oppyId, partId, currentYear, 'cy', '', map_oppyId_yearQuarter_partForecasts.get(oppyId), curr, recordTypeId);                  
              	// PY
	          	for(Integer i = 1; i <= numPY; i++){            
	              	String pn = '';
	          	  	if(i != 1) pn = String.valueOf(i);
	          	  	// get the pyear
	          	  	String pYear = '';
	          	  	if(currentYear != ''){
	            	  	pYear = String.valueOf(Integer.valueOf(currentYear) - i);
	          	  	}
	          	  	ClsOppyUtil.generateForecasts(tf, oppyId, partId, pYear, 'py', pn, map_oppyId_yearQuarter_partForecasts.get(oppyId), curr, recordTypeId);
	          	}         
              	// NY         
        	  	for(Integer i = 1; i <= numNY; i++){            
          	  	  	String nn = '';
          	      	if(i != 1) nn = String.valueOf(i);
          	      	// get the pyear
          		  	String nYear = '';
          	      	if(currentYear != ''){
            	  	  	nYear = String.valueOf(Integer.valueOf(currentYear) + i);
          		  	}
          		  	ClsOppyUtil.generateForecasts(tf, oppyId, partId, nYear, 'ny', nn, map_oppyId_yearQuarter_partForecasts.get(oppyId), curr, recordTypeId);
        	  	}
          	}
      	}
      	// get the existing opportunity forecasts
      	for(Opportunity_Forecast__c oppyForecast : [select Date__c, Amount__c, Quantity__c, Fiscal_Quarter__c, Fiscal_Year__c, Opportunity__c from Opportunity_Forecast__c where Opportunity__c IN :map_oppyId_yearQuarter_partForecasts.keySet() and Part__c = null]){
          	if(!map_oppyId_yearQuarter_oppyForecast.containsKey(oppyForecast.Opportunity__c)){
              	map_oppyId_yearQuarter_oppyForecast.put(oppyForecast.Opportunity__c, new Map<String, Opportunity_Forecast__c>());
          	}
          	if(!map_oppyId_yearQuarter_oppyForecast.get(oppyForecast.Opportunity__c).containsKey(oppyForecast.Fiscal_Year__c + oppyForecast.Fiscal_Quarter__c)){
              	map_oppyId_yearQuarter_oppyForecast.get(oppyForecast.Opportunity__c).put(oppyForecast.Fiscal_Year__c + oppyForecast.Fiscal_Quarter__c, oppyForecast);
      	  	}
      	}
      
      	// calculate the quantity and amount on opportunity forecast
      	for(Id oppyId :map_oppyId_yearQuarter_partForecasts.keySet()){
          	String method = 'BOM';
          	String curr = 'USD';
          	if(map_Id_oppy.containsKey(oppyId)){
          		if(map_Id_oppy.get(oppyId).Method__c != null) method = map_Id_oppy.get(oppyId).Method__c;
          		if(map_Id_oppy.get(oppyId).CurrencyIsoCode != null) curr = map_Id_oppy.get(oppyId).CurrencyIsoCode;
          	}
          	for(String yearQuarter :map_oppyId_yearQuarter_partForecasts.get(oppyId).keySet()){
              	// opportunity forecast  
              	Opportunity_Forecast__c forecast4Oppy = new Opportunity_Forecast__c();
        	  	if(map_oppyId_yearQuarter_oppyForecast.containsKey(oppyId)){
            	  	if(map_oppyId_yearQuarter_oppyForecast.get(oppyId).containsKey(yearQuarter)) forecast4Oppy = map_oppyId_yearQuarter_oppyForecast.get(oppyId).get(yearQuarter);
              	}
        
        	  	if(forecast4Oppy.id == null){
          		  	forecast4Oppy.Opportunity__c = oppyId;
          		  	forecast4Oppy.Part__c = null;
          		  	forecast4Oppy.CurrencyIsoCode = curr;
          		  	if(map_recordTypeName_recordTypeId.containsKey('Opportunity')) forecast4Oppy.RecordTypeId = map_recordTypeName_recordTypeId.get('Opportunity'); 
        	  	}
                
              	for(Opportunity_Forecast__c ofc :map_oppyId_yearQuarter_partForecasts.get(oppyId).get(yearQuarter)){          
	              	// Method:BOM
	          	  	if(method == 'BOM'){
	            	  	if(forecast4Oppy.Quantity__c == null){
		              	  	if(map_Id_partQty.containsKey(ofc.Part__c) && map_Id_partQty.get(ofc.Part__c) != null && map_Id_partQty.get(ofc.Part__c) != 0){
		                	  	forecast4Oppy.Quantity__c = ofc.Quantity__c / map_Id_partQty.get(ofc.Part__c);
		              	  	}
	            	  	}                            
	          	  	}
	          	  	else{
	            	  	if(forecast4Oppy.Quantity__c == null) forecast4Oppy.Quantity__c = 0;
	            	  	if(ofc.Quantity__c != null) forecast4Oppy.Quantity__c += ofc.Quantity__c;
	          	  	}   
	              	if(forecast4Oppy.Date__c == null) forecast4Oppy.Date__c = ofc.Date__c;
	              	if(forecast4Oppy.Fiscal_Year__c == null) forecast4Oppy.Fiscal_Year__c = ofc.Fiscal_Year__c;
	              	if(forecast4Oppy.Fiscal_Quarter__c == null) forecast4Oppy.Fiscal_Quarter__c = ofc.Fiscal_Quarter__c;
	              	// amount
	              	if(forecast4Oppy.Amount__c == null) forecast4Oppy.Amount__c = 0;
	              	// no need to calculate if confidence of part is dead or lost
	              	if(ofc.Amount__c != null && ofc.Part__c != null && !set_DLPartIds.contains(ofc.Part__c)) {	     
	              		//update by weihang 2013-05-28          	  	           
			            if(curr != ofc.CurrencyIsoCode && isCon) forecast4Oppy.Amount__c += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.CurrencyIsoCode, curr);
			            //if(isCon) forecast4Oppy.Amount__c += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.CurrencyIsoCode, curr);
			            else forecast4Oppy.Amount__c += ofc.Amount__c;                       
	              	}           
	          	  	list_opportunityForecast2Upsert.add(ofc);
              	}
              	list_opportunityForecast2Upsert.add(forecast4Oppy);
          	}
      	}
      	// upsert forecasts
      	try{
      	  	if(!list_opportunityForecast2Upsert.isEmpty()) upsert list_opportunityForecast2Upsert;
          	// delete TOPS
          	if(!list_topsForecast.isEmpty()) delete list_topsForecast;
      	}
      	catch(Exception ex){
        
      	}
    }
	
    global void finish(Database.BatchableContext BC){ 
        if(email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_MigrateOpportunityForecasts Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_MigrateOpportunityForecasts has completed');
            //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        } 
        else{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            User currentUser = [Select email from User where id = :UserInfo.getUserId() limit 1];
            mail.setToAddresses(new String[] {currentUser.email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_MigrateOpportunityForecasts Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_MigrateOpportunityForecasts has completed');
           // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        }
        //added by weihang 2013-05-28 begin 
        if(!test.isRunningTest()){
	        ClsBatch_recalculatePartRevenue partBatch = new ClsBatch_recalculatePartRevenue();
	        Database.executeBatch(partBatch);
        }
        //added by weihang 2013-05-28 end
  }
}