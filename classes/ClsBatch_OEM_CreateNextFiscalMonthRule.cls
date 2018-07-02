global class ClsBatch_OEM_CreateNextFiscalMonthRule implements Database.Batchable<SObject>{
	
	public String query;
          
    public String CurrentPeriodFMonth;
    public String CurrentPeriodFYear;
    public String nextPeriodFMonth;
    public String nextPeriodFYear;
	
	public ClsBatch_OEM_CreateNextFiscalMonthRule(String fiscalMonth, String fiscalYear){ 
		CurrentPeriodFMonth = fiscalMonth;
        CurrentPeriodFYear = fiscalYear;
        Integer year = Integer.valueOf(fiscalYear);
        Integer month = Integer.valueOf(fiscalMonth);
        if(CurrentPeriodFMonth == '12'){
        	nextPeriodFMonth = '01';
        	year += 1;
        }else{
        	month += 1;
        }
        
        nextPeriodFMonth = String.valueOf(month);
        nextPeriodFMonth = nextPeriodFMonth.leftPad(2,'0');
        nextPeriodFYear = String.valueOf(year);
        
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
    	if (query == null || query == '')
       {
        	//query OEM_detail__c and OEM_mapping_rule__c together
            query =   'Select o.Tech_CutoffDate__c, o.SystemModstamp, o.OEM__c, o.Name, o.IsDeleted, o.Id, o.Fiscal_Year__c,'+
					  'o.Fiscal_Month__c, o.Effective_Date__c, o.Cutoff_Date__c, o.CurrencyIsoCode, '+
					  'o.ConnectionSentId, o.ConnectionReceivedId, o.Billing__c '+
					  'From OEM_Details__c o' +
                      ' where fiscal_month__c =: CurrentPeriodFMonth and fiscal_year__c =: CurrentPeriodFYear' +
                      ' and IsDeleted = false' ;
       }      
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext BC, list<OEM_Details__c> oemDetailsList){
    	
    	System.debug('----------nextPeriodFMonth---------------'+nextPeriodFMonth);
    	//define a set to hold id of OEM_details__c
    	Set<Id> OEMDetailsId = new Set<Id>();
    	//define a list to hold the new OEM_details__c
    	List<OEM_Details__c> newOemDetailsList = new List<OEM_Details__c>();
    	//define a list to hold the new OEM_Mapping_Rule__c
    	List<OEM_Mapping_Rule__c> newOemMappingRuleList = new List<OEM_Mapping_Rule__c>();
    	
    	for(OEM_Details__c oemDetails : oemDetailsList){
    		
    		OEM_Details__c newOemDetails = oemDetails.clone();
    		OEMDetailsId.add(oemDetails.Id);
    		newOemDetailsList.add(newOemDetails);
    	}
    	
    	List<OEM_Mapping_Rule__c> OEMmappingRuleOldList = [Select Id, IsDeleted, Name, CurrencyIsoCode, RecordTypeId, OEM__c, Active__c, Allocation__c, Fiscal_Month__c,
					  Fiscal_Year__c, OEM_Account__c, Part_Number__c, Sold_To_Account_Code__c, Sold_To_Account_Name__c, Tech_Backlog__c,
					  Tech_Billing__c, Tech_Booking__c, Tech_Cutoff_Date__c, Tech_Latest_SA__c, Tech_MTD_Billing__c, Type__c, WWAC__c,
					  Worldwide_Account_Name__c, Tech_Isvalid__c, Tech_Part_Number__c,OEM__r.OEM__r.Id From OEM_Mapping_Rule__c where OEM__c in: OEMDetailsId];
    	
    	newOemMappingRuleList = OEMmappingRuleOldList.clone();
    	ClsOEMUtil.cloneOEMDetailsAndMaps(nextPeriodFMonth, nextPeriodFYear, newOemDetailsList, newOemMappingRuleList);                                    
    }
    
    global void finish(Database.BatchableContext BC){           
           
    }  
}