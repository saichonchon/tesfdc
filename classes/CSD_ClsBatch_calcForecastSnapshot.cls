/**
 *  This class is used to recalculate CSD Forecast Snapshot.
 *  
 * @author Bin Yuan
 * @created 2014-12-04
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-12-04 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created   
 *
 */
global class CSD_ClsBatch_calcForecastSnapshot implements Database.Batchable<SObject>, Database.stateful{
    global String query;
    global String filter;
    global Date currentFiscalDate;
    global Boolean isFail{get;set;}
    
    public CSD_ClsBatch_calcForecastSnapshot(){
    	isFail = false;
    	if(currentFiscalDate == null) {
    		currentFiscalDate = CSD_ClsUtils.getCurrentFiscalDate().addMonths(-1);
    	}
    	
    } 
      
    global Database.QueryLocator start(Database.BatchableContext BC) { 
    	
    	if(query == null || query.trim() == '') {
    		query = ' Select Id, Forecast__c, Quantity__c, Batch_Running_Date__c, Previous_Month_Quantity__c, Previous_Month_Forecast__c';
    		
	    	for(Integer i = 1; i <= 11; i ++) {
	    		String fcFieldAPI = 'Previous_' + i + '_Month_Forecast__c';
	    		String quantityFieldAPI = 'Previous_' + i + '_Month_Quantity__c';
	    		query += ', ' + fcFieldAPI + ', ' + quantityFieldAPI;
	    	}
	        query += ' From CSD_Sales_Forecast__c '
	        	  +  ' Where Fiscal_Date__c >= ' + currentFiscalDate + ' And (Batch_Running_Date__c < ' + currentFiscalDate + ' or Batch_Running_Date__c = null)';
        	query = query.replaceAll(' 00:00:00', ' ');
    	}
        if(filter != null && filter.trim() != ''){
            query += filter;
        }  
        system.debug('query :: ' + query);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<CSD_Sales_Forecast__c> list_csdFCs){
    	
    	for(CSD_Sales_Forecast__c csdFC : list_csdFCs) {
    		//Sobject sobj = (Sobject) csdFC;
    		csdFC.put('Batch_Running_Date__c', currentFiscalDate);
    		for(Integer i = 10; i >= 1; i--) {
	    		String fcFieldAPI = 'Previous_' + i + '_Month_Forecast__c';
	    		String quantityFieldAPI = 'Previous_' + i + '_Month_Quantity__c';
	    		String prevFCFieldAPI = 'Previous_' + (i + 1) + '_Month_Forecast__c';
	    		String prevQuantityFieldAPI = 'Previous_' + (i + 1) + '_Month_Quantity__c';
	    		
	    		csdFC.put(prevFCFieldAPI, (csdFC.get(fcFieldAPI) == null ? 0 : (decimal) csdFC.get(fcFieldAPI) ));
	    		csdFC.put(prevQuantityFieldAPI, (csdFC.get(quantityFieldAPI) == null ? 0 : (decimal) csdFC.get(quantityFieldAPI)));
    		}
    		csdFC.put('Previous_1_Month_Forecast__c', (csdFC.get('Previous_Month_Forecast__c') == null ? 0 : (decimal) csdFC.get('Previous_Month_Forecast__c')));
    		csdFC.put('Previous_1_Month_Quantity__c', (csdFC.get('Previous_Month_Quantity__c') == null ? 0 : (decimal) csdFC.get('Previous_Month_Quantity__c')));
    		csdFC.put('Previous_Month_Forecast__c', (csdFC.get('Forecast__c') == null ? 0 : (decimal) csdFC.get('Forecast__c')));
    		csdFC.put('Previous_Month_Quantity__c', (csdFC.get('Quantity__c') == null ? 0 : (decimal) csdFC.get('Quantity__c')));
    		
    		//csdFC = (CSD_Sales_Forecast__c) sobj;
    		
    	}
    	if(list_csdFCs.size() > 0) {
    		try {
        		update list_csdFCs;
    		}catch(Exception ex) {
        		isFail = true;
        		throw ex;	
        	}
    	}
        
    }
    
    global void finish(Database.BatchableContext BC){ 
    	if(isFail) {
    		CSD_Configuration__c mcs = CSD_Configuration__c.getInstance('BatchEmailTemplate');
	  		EmailTemplate et = null;
	  		if(mcs != null && mcs.Value__c != null && mcs.Value__c != '') {
		  		for(EmailTemplate temp : [SELECT Id FROM EmailTemplate WHERE id = :mcs.Value__c]) {
		  			et = temp;	
		  		}
	  		}
	  		if(et != null) {
	  			//Id userId = UserInfo.getUserId();
  				//User user = [select Email from User where id = :userId];
	  			
	  			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	  			mail.setTemplateID(et.Id);
				//String[] toAddresses = new String[] {user.email};
  				//mail.setToAddresses(toAddresses); 
  				mail.setTargetObjectid(UserInfo.getUserId());
				mail.setSaveAsActivity(false);
	  			
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
	  		}
    	}
    }
}