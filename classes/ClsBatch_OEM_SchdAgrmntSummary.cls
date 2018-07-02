global class ClsBatch_OEM_SchdAgrmntSummary implements Database.Batchable<SObject>,Database.Stateful{

    public String query;
 
    global map<Id, OEM_Mapping_Rule__c> InputOEMMappings = new map<Id, OEM_Mapping_Rule__c>();
    global Integer pFiscalMonth;
    global String pFiscalYear;
    global set<Id> OEMAccountIds = new set<Id>();
    
    global Map<Id, Double> SumOEMRulesMap = new Map<Id, Double>();    
    
    public ClsBatch_OEM_SchdAgrmntSummary(list<OEM_Mapping_Rule__c> ValidOEMMappings, String fiscalMonth, String fiscalYear){
        InputOEMMappings.putAll(ValidOEMMappings);
        pFiscalMonth = Integer.valueOf(fiscalMonth);
        pFiscalYear = fiscalYear;                   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    { 
        Set<String> SoldToAccountCodeSet = new Set<String>();
        Set<Id> PartNumberSet = new Set<Id>();
        Set<String> wwCusNumset = new Set<String>();
        
        for(OEM_Mapping_Rule__c oemmapobj:InputOEMMappings.values())                    
        {
        
            if(oemmapobj.Sold_To_Account_Code__c!= null)
            {
                SoldToAccountCodeSet.add(oemmapobj.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0'));
            }
            if(oemmapobj.Part_Number__c!= null)
            {
                PartNumberSet.add(oemmapobj.Part_Number__c);
            }
            if(oemmapobj.WWAC__c!= null)
            { 
                wwCusNumset.add(oemmapobj.WWAC__c.leftpad(8).replace(' ', '0'));
            }
            
            oemmapobj.Tech_Latest_SA__c = 0;
            SumOEMRulesMap.put(oemmapobj.id, 0);
            OEMAccountIds.add(oemmapobj.OEM__r.OEM__r.Id);
        }
        
        system.debug('***** JNV ' + soldtoaccountcodeset.size());
        system.debug('***** JNV ' + partnumberset.size());
        system.debug('***** JNV ' + wwcusnumset.size());
        
       if (query == null || query == '')
       {
            query =   'Select Id, Forecast_Amount_USD__c , ' +
                      ' Sold_To_Customer__c, Sold_To_Customer__r.WWCORPACCT__c , ' +
                      ' Sold_To_Customer__r.Tech_SoldToAccountCode__c, Part__c ' +
                      ' from Scheduled_Agreements__c ' +
                      ' where fiscal_month__c =: pFiscalMonth and fiscal_year__c =: pFiscalYear' +
                      ' and IsDeleted = false ' +
                      ' and (Sold_To_Customer__r.Tech_SoldToAccountCode__c in: soldtoaccountcodeset ' +
                      ' or Sold_To_Customer__r.WWCORPACCT__c in: wwCusNumset or ' +
                      ' part__c in: partnumberset) ';                                      
       }           
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, list<Scheduled_Agreements__c> SAList)
    {   
        //system.debug('***** - JNV Got here');
        if (SAList.size() > 0 && InputOEMMappings.values().size() > 0 && SumOEMRulesMap.values().size() > 0)
        { 
        	
	    	map<String, set<Id>> CustomerList = new map<String, set<Id>>();
	    	map<String, set<Id>> WWACList = new map<String, set<Id>>();
	    	map<Id, set<Id>> PartList = new map<Id, set<Id>>();
	    	map<Id, Scheduled_Agreements__c> SAMap = new map<Id, Scheduled_Agreements__c>(SAList);    	
	    	
	    	//nesting loop of SA's within loop of mappings was causing Code statement limit error
	    	//so first loop through all mappings to isolate wwac, customer, and part values
	    	for(Scheduled_Agreements__c s : SAMap.values())
	    	{
	    		if(CustomerList.containskey(s.sold_to_customer__r.Tech_SoldToAccountCode__c))
	    		{
	    			CustomerList.get(s.sold_to_customer__r.Tech_SoldToAccountCode__c).add(s.id);
	    		}
	    		else
	    		{
	    			CustomerList.put(s.sold_to_customer__r.Tech_SoldToAccountCode__c, new set<id>());
	    			CustomerList.get(s.sold_to_customer__r.Tech_SoldToAccountCode__c).add(s.id);
	    		}
	    		
	    		if(WWACList.containskey(s.sold_to_customer__r.WWCORPACCT__c))
	    		{
	    			WWACList.get(s.sold_to_customer__r.WWCORPACCT__c).add(s.id);
	    		}
	    		else
	    		{
	    			WWACList.put(s.sold_to_customer__r.WWCORPACCT__c, new set<id>());
	    			WWACList.get(s.sold_to_customer__r.WWCORPACCT__c).add(s.id);
	    		}
	    		
	    		if(PartList.containskey(s.part__c))
	    		{
	    			PartList.get(s.part__c).add(s.id);
	    		}
	    		else
	    		{
	    			PartList.put(s.part__c, new set<id>());
	    			PartList.get(s.part__c).add(s.id);
	    		}    		    		
	    	}        	

			for(OEM_Mapping_Rule__c OEMMap : InputOEMMappings.values())
	    	{
	    		set<Id> sumMaps = new set<Id>();

                Boolean isWWACheck = false;
                Boolean isSoldToAccCheck = false;
                Boolean isPartCheck = false;                    
                
                if(OEMMap.WWAC__c != null && WWACList.size() > 0)
                {                 	
                    if(WWACList.containskey(OEMMap.WWAC__c.leftpad(8).replace(' ', '0')))
                    {                   	
                    	sumMaps.addAll(WWACList.get(OEMMap.WWAC__c.leftpad(8).replace(' ', '0')));
                        isWWACheck =true;
                    }
                }
                else
                {
                    isWWACheck =true;
                }
                
                if(OEMMap.Sold_To_Account_Code__c != null && CustomerList.size() > 0 && isWWACheck == true)
                {
                    if(CustomerList.containskey(OEMMap.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0')))
                    {
                    	if(sumMaps.size() > 0)
                    	{
                        	sumMaps.retainAll(CustomerList.get(OEMMap.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0')));
                    	}
                    	else
                    	{
                    		sumMaps.addAll(CustomerList.get(OEMMap.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0')));
                    	}
                        isSoldToAccCheck = true;
                    }
                }
                else
                {
                    isSoldToAccCheck = true;
                }
                 
                if(OEMMap.Part_Number__c != null && PartList.size() > 0 && isWWACheck == true && isSoldToAccCheck == true)
                {                   
                    if(PartList.containskey(OEMMap.Part_Number__c))
                    {
                    	if(sumMaps.size() > 0)
                    	{
							sumMaps.retainAll(PartList.get(OEMMap.Part_Number__c));
                    	}
                    	else
                    	{
                    		sumMaps.addAll(PartList.get(OEMMap.Part_Number__c));
                    	}                     	
                        isPartCheck = true;
                    }
                }
                else
                {
                    isPartCheck = true;
                }                    
                             
                if(isWWACheck == true && isSoldToAccCheck == true && isPartCheck == true)
                {
                    Double Allocation = 0;
                    Allocation = InputOEMMappings.get(OEMMap.id).Allocation__c * .01;
                    if(sumMaps.size() > 0)
                    {             	
						for(Id i : sumMaps)
						{
							SumOEMRulesMap.put(OEMMap.id, (SumOEMRulesMap.get(OEMMap.id) + (SAMap.get(i).Forecast_Amount_USD__c * Allocation)));
						}
                    }
                }
            }        	
        	
            /*for(OEM_Mapping_Rule__c OEMMap : InputOEMMappings.values())
            {                
                for(Scheduled_Agreements__c SA : SAList)
                {   
                    Boolean isWWACheck = false;
                    Boolean isSoldToAccCheck = false;
                    Boolean isPartCheck = false;                    
                    
                    if(OEMMap.WWAC__c != null)
                    {
                        //system.debug('***** - JNV1 ' + OEMMap.WWAC__c + ' ' + SA.Sold_To_Customer__r.WWCORPACCT__c);
                        if(OEMMap.WWAC__c.leftpad(8).replace(' ', '0') == SA.Sold_To_Customer__r.WWCORPACCT__c)
                        {
                            isWWACheck =true;
                        }
                    }
                    else
                    {
                        isWWACheck =true;
                    }
                    
                    if(OEMMap.Sold_To_Account_Code__c != null && isWWACheck == true)
                    {
                        //system.debug('***** - JNV1 ' + OEMMap.Sold_To_Account_Code__c + ' ' + SA.Sold_To_Customer__r.Tech_SoldToAccountCode__c);                      
                        if(OEMMap.Sold_To_Account_Code__c.leftpad(8).replace(' ', '0') == SA.Sold_To_Customer__r.Tech_SoldToAccountCode__c)
                        {
                            isSoldToAccCheck = true;
                        }
                    }
                    else
                    {
                        isSoldToAccCheck = true;
                    }
                     
                    if(OEMMap.Part_Number__c != null && isWWACheck == true && isSoldToAccCheck == true)
                    {
                        //system.debug('***** - JNV1 ' + OEMMap.Part_Number__c + ' ' + SA.Part__c);                     
                        if(OEMMap.Part_Number__c == SA.Part__c)
                        {
                            isPartCheck = true;
                        }
                    }
                    else
                    {
                        isPartCheck = true;
                    }                    
                                 
                    if(isWWACheck == true && isSoldToAccCheck == true && isPartCheck == true)
                    {
                        Double Allocation = 0;
                        Allocation = InputOEMMappings.get(OEMMap.id).Allocation__c * .01;
                        SumOEMRulesMap.put(OEMMap.id, (SumOEMRulesMap.get(OEMMap.id) + (SA.Forecast_Amount_USD__c * Allocation)));                      
                        //system.debug('***** - JNV ' + OEMMap.id + ' ' + SA.Id + ' ' + SumOEMRulesMap.get(OEMMap.id));
                    }
                }
            }*/
        }
    }

    global void finish(Database.BatchableContext BC)
    {   
        if(InputOEMMappings.values().size() > 0)
        {
            //Set up map to contain summarized daily values by OEM Account      
            Map <Id, Double> OEMAccountTotals = new Map <Id, Double>();
            for(Id OEMId : OEMAccountIds)
            {
                OEMAccountTotals.put(OEMId, 0);
            }       
    
            Map<Id, Account> OEMAccounts = new Map<Id, Account>([Select Id, Latest_SA__c from Account where id in: OEMAccountIds]);
            
            //Iterate through Mappings Rules to set Totals, and to Sum Rule totals on account map
            for(OEM_Mapping_Rule__c UpdMap : InputOEMMappings.values())
            {
                UpdMap.Tech_Latest_SA__c += SumOEMRulesMap.get(UpdMap.id);
                
                OEMAccountTotals.put(UpdMap.OEM__r.OEM__r.Id, (OEMAccountTotals.get(UpdMap.OEM__r.OEM__r.Id) + SumOEMRulesMap.get(UpdMap.id)));
            }
            
            //Iterate through Account Totals to set Daily Values on OEM Account records themselves
            for(Account OA : OEMAccounts.values())
            {       
                OA.Latest_SA__c = OEMAccountTotals.get(OA.Id);
            } 
            
            //do we really need to store daily totals on OEM mapping records?
            update(InputOEMMappings.values());
            update(OEMAccounts.values());
        }
        
        //after updates, calculate current FM/FY based on today's date from fiscal periods and pass to Monthly SA Batch        
        if(ClsOEMUtil.CurrentFM == null || ClsOEMUtil.CurrentFY == null)
        {
			ClsOEMUtil.setCurrentFiscalDateValues();        	
        }
        
        pFiscalMonth = ClsOEMUtil.CurrentFM;
        pFiscalYear = ClsOEMUtil.CurrentFY;

        if(!test.IsRunningTest())
        { 
          //Loop over transaction records nested within loop of mappings
          //With roughly 3000 mapping records/month on average, must reduce 
          //batch size to stay under code statement limit.
	      //ClsBatch_OEM_MonthlyBBBSummary oemMBBB = new ClsBatch_OEM_MonthlyBBBSummary(string.valueOf(pFiscalMonth).leftpad(2).replace(' ', '0'), pFiscalYear); 
	      //Database.executeBatch(oemMBBB, 50);
        }        
    }

}