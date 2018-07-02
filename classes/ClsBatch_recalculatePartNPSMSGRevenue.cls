/**
 *  A batch job to ReCalculate NPS/MSG Revenues on opportunity part. 
 *  
 * @author Michael Cui
 * @created 2014-07-11
 * @version 1.0
 * 
 *
 * @changelog
 * 2014-07-11 Michael Cui
 * - Created   
 * @changelog
 * updated by nelson 05/13/2015 for case 00832173
 *
 */
global class ClsBatch_recalculatePartNPSMSGRevenue implements Database.Batchable<SObject>,Database.Stateful {    
    public String query;
    public set<Id> applOpptyRTId;
    public set<Id> partIdSet;
    global List<Period> list_fiscalQuarter;
    //public set<Date> npsStartDate = new set<Date>();
    
    public static map<Date,map<String, Date>> getQuarterStartEndDate(set<Date> set_startDate, List<Period> list_fiscalQuarter)
    {    	
    	map<Date, map<String, Date>> returnMap = new map<Date,map<String, Date>>();
    	//List<Period> list_fiscalQuarter = [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter'];
        
        for(Date inputDate : set_startDate)
        {
            returnMap.put(inputDate, new Map<String, Date>());
            for(Period p: list_fiscalQuarter)
            {
                if(inputDate >= p.StartDate && inputDate <= p.EndDate)
                {                    
                    returnMap.get(inputDate).put('Start', p.StartDate);
                    returnMap.get(inputDate).put('End', p.EndDate);
                    break;
                }         
            }
        }
    	return returnMap;
    }
    
    public static map<String,map<String, Date>> getStartEndDateByQuarter(List<Period> list_fiscalQuarter)
    {    	
    	map<String, map<String, Date>> returnMap = new map<String, map<String, Date>>();
    	//List<Period> list_fiscalQuarter = [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter'];
               
        for(Period p: list_fiscalQuarter)
        {                   
            returnMap.put(String.valueOf(p.FiscalYearSettings.Name) + String.valueOf(p.Number), new Map<String, Date>());
            returnMap.get(String.valueOf(p.FiscalYearSettings.Name) + String.valueOf(p.Number)).put('Start', p.StartDate);
            returnMap.get(String.valueOf(p.FiscalYearSettings.Name) + String.valueOf(p.Number)).put('End', p.EndDate);
            //break;                 
        }        
    	return returnMap;
    }
    
    public static map<Date,map<String, String>> getQuarter(set<Date> set_startDate, List<Period> list_fiscalQuarter)
    {    	
    	map<Date, map<String, String>> returnMap = new map<Date, map<String, String>>();
    	//List<Period> list_fiscalQuarter = [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter'];
        
        for(Date inputDate : set_startDate)
        {
            returnMap.put(inputDate, new Map<String, String>());
            for(Period p: list_fiscalQuarter)
            {
                if(inputDate >= p.StartDate && inputDate <= p.EndDate)
                {                    
                    returnMap.get(inputDate).put('Year', p.FiscalYearSettings.Name);
                    returnMap.get(inputDate).put('Quarter', String.valueOf(p.Number));
                    //returnMap.get(inputDate).put('End', p.EndDate);
                    break;
                }         
            }
        }
    	return returnMap;
    }
     
    global Database.QueryLocator start(Database.BatchableContext BC){    	 
        applOpptyRTId = ClsOppyForecastUtil.applianceOpptyRecordTypeId();
        
        list_fiscalQuarter = [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter'];
        if (query == '' || query == null)
        {            
            //query = 'SELECT Id From Opportunity_Part__c where Opportunity__r.Name != null' ;
            //query = 'SELECT Id,Part__c From Opportunity_Part__c where need_recalculate_PartNPSMSGRevenue__c = true and Opportunity__r.RecordTypeId in: applOpptyRTId and opportunity__r.Industry_Code__c = \'Appliances\' and opportunity__r.Owner.GIBU__c = \'Appliances\' and APL_Forecast_Calculation_Start_Date__c>=2008-09-27 and Status__c != \'Dead\' and Status__c != \'Lost\'' ;
        	
        	//updated by nelson 05/13/2015 for case 00832173 change opportunity__r.Industry_Code__c = \'Appliances\' to BU_profit_center__c = \'Appliances\'
        	query = 'SELECT Id,Part__c From Opportunity_Part__c where need_recalculate_PartNPSMSGRevenue__c = true and Opportunity__r.RecordTypeId in: applOpptyRTId and BU_profit_center__c = \'Appliances\' and opportunity__r.Owner.GIBU__c = \'Appliances\' and APL_Forecast_Calculation_Start_Date__c>=2008-09-27 and Status__c != \'Dead\' and Status__c != \'Lost\'' ;
        }
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, list<Opportunity_Part__c> scope){
        Map<Id, List<Opportunity_Forecast__c>> map_partId_forecasts = new Map<Id, List<Opportunity_Forecast__c>>();
        List<Opportunity_Forecast__c> lst_fcst2Update = new List<Opportunity_Forecast__c>();
        map<Id,Opportunity_Part__c> map_partId_part = new map<Id,Opportunity_Part__c>();
        set<Date> npsStartDate = new set<Date>();
        CSD_Utils_Class.recalcuNPSMSG = true;
        
        for(Opportunity_Part__c part: scope){
        	part.need_recalculate_PartNPSMSGRevenue__c = false;// add by nelson zheng 01-22-2015 
            map_partId_part.put(part.Id,part); 
        }
                
        for(Opportunity_Forecast__c fc :[SELECT NPS1__c, NPS2__c, NPS3__c,  MSG1__c, MSG2__c, MSG3__c, Date__c, APL_NPS_Calculation_Start_Date__c, Amount__c, CurrencyIsoCode, Fiscal_Quarter__c, Fiscal_Year__c, Part__c FROM Opportunity_Forecast__c where Part__c in: map_partId_part.keySet()]){
            
            if(!map_partId_forecasts.containsKey(fc.Part__c)) {
                map_partId_forecasts.put(fc.Part__c, new List<Opportunity_Forecast__c>());
                map_partId_forecasts.get(fc.Part__c).add(fc);
            }
            else
            	map_partId_forecasts.get(fc.Part__c).add(fc);
            if(fc.APL_NPS_Calculation_Start_Date__c != null)
	        	npsStartDate.add(fc.APL_NPS_Calculation_Start_Date__c);
        }
        
        //CSD_Utils_Class.getAllFiscalQuarter();
        map<Date,map<String, Date>> npsQuarterStartEndDate = getQuarterStartEndDate(npsStartDate, list_fiscalQuarter);
        map<String,map<String, Date>> QuarterStartEndDate = getStartEndDateByQuarter(list_fiscalQuarter);
		map<Date,map<String, String>> StartQuarter = getQuarter(npsStartDate, list_fiscalQuarter);		        
        
        if(!map_partId_forecasts.isEmpty())
        {
        	for(Id pId :map_partId_forecasts.keySet())
        	{        		
		        if(map_partId_forecasts.get(pId) != null)
		        {
			        for(Opportunity_Forecast__c oppf :map_partId_forecasts.get(pId))
			        {
			        	if(map_partId_part.get(pId).Part__c == null)
			        	{
			        		if(oppf.APL_NPS_Calculation_Start_Date__c != null)
			    			{
			    				Decimal tmpAmount = oppf.CurrencyIsoCode != 'USD'? ClsOppyForecastUtil.transformIsoCode(oppf.Amount__c, oppf.CurrencyIsoCode, 'USD'):oppf.Amount__c;
			    				Date startDate = npsQuarterStartEndDate.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Start');
			    				Date endDate   = npsQuarterStartEndDate.get(oppf.APL_NPS_Calculation_Start_Date__c).get('End');
			    				Integer startYear = Integer.valueOf(StartQuarter.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Year'));
			    				String strStartQuarter = StartQuarter.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Quarter');		    				
			    				Decimal NPS1 = 0;
			    				Decimal NPS2 = 0;
			    				Decimal NPS3 = 0;
			    				
			    				//if(oppf.Date__c > endDate && oppf.Date__c < startDate.addYears(1))
			    				if(oppf.Date__c > endDate && oppf.Date__c < QuarterStartEndDate.get(String.valueOf(startYear + 1) + strStartQuarter).get('Start'))
			    					NPS1 =  tmpAmount;
			    				//if(oppf.Date__c > endDate && oppf.Date__c < startDate.addYears(2))
			    				if(oppf.Date__c > endDate && oppf.Date__c < QuarterStartEndDate.get(String.valueOf(startYear + 2) + strStartQuarter).get('Start'))
			    					NPS2 =  tmpAmount;
			    				//if(oppf.Date__c > endDate && oppf.Date__c < startDate.addYears(3))
			    				if(oppf.Date__c > endDate && oppf.Date__c < QuarterStartEndDate.get(String.valueOf(startYear + 3) + strStartQuarter).get('Start'))
			    					NPS3 =  tmpAmount;
			    				if(oppf.Date__c >= startDate && oppf.Date__c <= endDate)
			    				{
			    					NPS1 =  (tmpAmount * (oppf.APL_NPS_Calculation_Start_Date__c.daysBetween(endDate) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    					NPS2 =  (tmpAmount * (oppf.APL_NPS_Calculation_Start_Date__c.daysBetween(endDate) + 1)).divide((startDate.daysBetween(endDate) + 1),2);	    					
			    					NPS3 =  (tmpAmount * (oppf.APL_NPS_Calculation_Start_Date__c.daysBetween(endDate) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    					
			    				}
			    				//if(oppf.Date__c >= startDate.addYears(1) && oppf.Date__c <= endDate.addYears(1))
			    				if(oppf.Date__c >= QuarterStartEndDate.get(String.valueOf(startYear + 1) + strStartQuarter).get('Start') && oppf.Date__c <= QuarterStartEndDate.get(String.valueOf(startYear + 1) + strStartQuarter).get('End'))
			    				{		    					
			    					NPS1 = (tmpAmount * (startDate.daysBetween(oppf.APL_NPS_Calculation_Start_Date__c) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    				}
			    				//if(oppf.Date__c >= startDate.addYears(2) && oppf.Date__c <= endDate.addYears(2))
			    				if(oppf.Date__c >= QuarterStartEndDate.get(String.valueOf(startYear + 2) + strStartQuarter).get('Start') && oppf.Date__c <= QuarterStartEndDate.get(String.valueOf(startYear + 2) + strStartQuarter).get('End'))
			    				{		    					
			    					NPS2 = (tmpAmount * (startDate.daysBetween(oppf.APL_NPS_Calculation_Start_Date__c) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    				}
			    				//if(oppf.Date__c >= startDate.addYears(3) && oppf.Date__c <= endDate.addYears(3))
			    				if(oppf.Date__c >= QuarterStartEndDate.get(String.valueOf(startYear + 3) + strStartQuarter).get('Start') && oppf.Date__c <= QuarterStartEndDate.get(String.valueOf(startYear + 3) + strStartQuarter).get('End'))
			    				{		    					
			    					NPS3 = (tmpAmount * (startDate.daysBetween(oppf.APL_NPS_Calculation_Start_Date__c) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    				}
			    				oppf.NPS1__c = NPS1;
			    				oppf.NPS2__c = NPS2;
			    				oppf.NPS3__c = NPS3;
			    				oppf.MSG1__c = tmpAmount - NPS1;
			    				oppf.MSG2__c = tmpAmount - NPS2;
			    				oppf.MSG3__c = tmpAmount - NPS3;
			    			}
			    		}
			    		else
			    		{		    			
			    			if(oppf.APL_NPS_Calculation_Start_Date__c != null)
			    			{
			    				Decimal tmpAmount = oppf.CurrencyIsoCode != 'USD'? ClsOppyForecastUtil.transformIsoCode(oppf.Amount__c, oppf.CurrencyIsoCode, 'USD'):oppf.Amount__c;
			    				Date startDate = npsQuarterStartEndDate.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Start');
			    				Date endDate   = npsQuarterStartEndDate.get(oppf.APL_NPS_Calculation_Start_Date__c).get('End');
			    				Integer startYear = Integer.valueOf(StartQuarter.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Year'));
			    				String strStartQuarter = StartQuarter.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Quarter');		    				
			    				Decimal NPS1 = 0;
			    				Decimal NPS2 = 0;
			    				Decimal NPS3 = 0;
			    				
			    				//if(oppf.Date__c > endDate && oppf.Date__c < startDate.addYears(1))
			    				if(oppf.Date__c > endDate && oppf.Date__c < QuarterStartEndDate.get(String.valueOf(startYear + 1) + strStartQuarter).get('Start'))
			    					NPS1 =  tmpAmount;
			    				//if(oppf.Date__c > endDate && oppf.Date__c < startDate.addYears(2))
			    				if(oppf.Date__c > endDate && oppf.Date__c < QuarterStartEndDate.get(String.valueOf(startYear + 2) + strStartQuarter).get('Start'))
			    					NPS2 =  tmpAmount;
			    				//if(oppf.Date__c > endDate && oppf.Date__c < startDate.addYears(3))
			    				if(oppf.Date__c > endDate && oppf.Date__c < QuarterStartEndDate.get(String.valueOf(startYear + 3) + strStartQuarter).get('Start'))
			    					NPS3 =  tmpAmount;
			    				if(oppf.Date__c >= startDate && oppf.Date__c <= endDate)
			    				{
			    					NPS1 =  (tmpAmount * (oppf.APL_NPS_Calculation_Start_Date__c.daysBetween(endDate) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    					NPS2 =  (tmpAmount * (oppf.APL_NPS_Calculation_Start_Date__c.daysBetween(endDate) + 1)).divide((startDate.daysBetween(endDate) + 1),2);	    					
			    					NPS3 =  (tmpAmount * (oppf.APL_NPS_Calculation_Start_Date__c.daysBetween(endDate) + 1)).divide((startDate.daysBetween(endDate) + 1),2);		    					
			    				}
			    				//if(oppf.Date__c >= startDate.addYears(1) && oppf.Date__c <= endDate.addYears(1))
			    				if(oppf.Date__c >= QuarterStartEndDate.get(String.valueOf(startYear + 1) + strStartQuarter).get('Start') && oppf.Date__c <= QuarterStartEndDate.get(String.valueOf(startYear + 1) + strStartQuarter).get('End'))
			    				{		    					
			    					NPS1 = (tmpAmount * (startDate.daysBetween(oppf.APL_NPS_Calculation_Start_Date__c) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    				}
			    				//if(oppf.Date__c >= startDate.addYears(2) && oppf.Date__c <= endDate.addYears(2))
			    				if(oppf.Date__c >= QuarterStartEndDate.get(String.valueOf(startYear + 2) + strStartQuarter).get('Start') && oppf.Date__c <= QuarterStartEndDate.get(String.valueOf(startYear + 2) + strStartQuarter).get('End'))
			    				{		    					
			    					NPS2 = (tmpAmount * (startDate.daysBetween(oppf.APL_NPS_Calculation_Start_Date__c) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    				}
			    				//if(oppf.Date__c >= startDate.addYears(3) && oppf.Date__c <= endDate.addYears(3))
			    				if(oppf.Date__c >= QuarterStartEndDate.get(String.valueOf(startYear + 3) + strStartQuarter).get('Start') && oppf.Date__c <= QuarterStartEndDate.get(String.valueOf(startYear + 3) + strStartQuarter).get('End'))
			    				{		    					
			    					NPS3 = (tmpAmount * (startDate.daysBetween(oppf.APL_NPS_Calculation_Start_Date__c) + 1)).divide((startDate.daysBetween(endDate) + 1),2);
			    				}
			    				oppf.NPS1__c = NPS1;
			    				oppf.NPS2__c = NPS2;
			    				oppf.NPS3__c = NPS3;
			    				oppf.MSG1__c = tmpAmount - NPS1;
			    				oppf.MSG2__c = tmpAmount - NPS2;
			    				oppf.MSG3__c = tmpAmount - NPS3;
			    			}
			    		}
			    		lst_fcst2Update.add(oppf);
			        }
		        }
        	}
        } 
         
        if(lst_fcst2Update.size()>0) update lst_fcst2Update; 
        
        if(!map_partId_part.isEmpty())
    	{
    		//map<Id,Opportunity_Part__c> map_partId_part = getOpptyPart(opptyPartId);	    		
    		Date presentYear = Date.Today();
    		Period p = [Select Type, StartDate, Number,  Id, FiscalYearSettings.Name, FiscalYearSettingsId, EndDate From Period where type = 'Quarter' and FiscalYearSettings.IsStandardYear = false and StartDate <= :presentYear and EndDate >= :presentYear limit 1];
    		Integer sYear = Integer.valueOf(p.FiscalYearSettings.Name);
    		Integer sQuarter = Integer.valueOf(p.Number);
    		
			if(!map_partId_part.isEmpty())
			{
    			for(Id pId :map_partId_part.keySet())
    			{
    				Opportunity_Part__c part = map_partId_part.get(pId);
    				part.Current_Year_NPS3__c = 0;
					part.Current_Year_NPS2__c = 0;
					part.Current_Year_NPS1__c = 0;
					part.Current_Year_MSG3__c = 0;
					part.Current_Year_MSG2__c = 0;
					part.Current_Year_MSG1__c = 0;
					part.Current_Year_5_NPS3__c = 0;
					part.Current_Year_5_NPS2__c = 0;
					part.Current_Year_5_NPS1__c = 0;
					part.Current_Year_5_MSG3__c = 0;
					part.Current_Year_5_MSG2__c = 0;
					part.Current_Year_5_MSG1__c = 0;
					part.Current_Year_4_NPS3__c = 0;
					part.Current_Year_4_NPS2__c = 0;
					part.Current_Year_4_NPS1__c = 0;
					part.Current_Year_4_MSG3__c = 0;
					part.Current_Year_4_MSG2__c = 0;
					part.Current_Year_4_MSG1__c = 0;
					part.Current_Year_3_NPS3__c = 0;
					part.Current_Year_3_NPS2__c = 0;
					part.Current_Year_3_NPS1__c = 0;
					part.Current_Year_3_MSG3__c = 0;
					part.Current_Year_3_MSG2__c = 0;
					part.Current_Year_3_MSG1__c = 0;
					part.Current_Year_2_NPS3__c = 0;
					part.Current_Year_2_NPS2__c = 0;
					part.Current_Year_2_NPS1__c = 0;
					part.Current_Year_2_MSG3__c = 0;
					part.Current_Year_2_MSG2__c = 0;
					part.Current_Year_2_MSG1__c = 0;
					part.Current_Year_1_NPS3__c = 0;
					part.Current_Year_1_NPS2__c = 0;
					part.Current_Year_1_NPS1__c = 0;
					part.Current_Year_1_MSG3__c = 0;
					part.Current_Year_1_MSG2__c = 0;
					part.Current_Year_1_MSG1__c = 0;
    			
    				if(map_partId_forecasts.get(pId) != null)
    				{
	    				for(Opportunity_Forecast__c oppf: map_partId_forecasts.get(pId))
	    				{
	    					if(oppf.Fiscal_Year__c != null && oppf.NPS2__c != null && oppf.NPS3__c != null && oppf.MSG2__c != null && oppf.MSG3__c != null)
	    					{
		    					if(Integer.valueOf(oppf.Fiscal_Year__c) == sYear && Integer.valueof(oppf.Fiscal_Quarter__c) >= sQuarter)
		    					{
		    						part.Current_Year_NPS1__c += oppf.NPS1__c;
		    						part.Current_Year_NPS2__c += oppf.NPS2__c;
		    						part.Current_Year_NPS3__c += oppf.NPS3__c;
		    						part.Current_Year_MSG1__c += oppf.MSG1__c;
		    						part.Current_Year_MSG2__c += oppf.MSG2__c;
		    						part.Current_Year_MSG3__c += oppf.MSG3__c;
		    					}
		    					if(Integer.valueOf(oppf.Fiscal_Year__c) == (sYear+1))
		    					{
		    						part.Current_Year_1_NPS1__c += oppf.NPS1__c;
		    						part.Current_Year_1_NPS2__c += oppf.NPS2__c;
		    						part.Current_Year_1_NPS3__c += oppf.NPS3__c;
		    						part.Current_Year_1_MSG1__c += oppf.MSG1__c;
		    						part.Current_Year_1_MSG2__c += oppf.MSG2__c;
		    						part.Current_Year_1_MSG3__c += oppf.MSG3__c;
		    					}
		    					if(Integer.valueOf(oppf.Fiscal_Year__c) == (sYear+2))
		    					{
		    						part.Current_Year_2_NPS1__c += oppf.NPS1__c;
		    						part.Current_Year_2_NPS2__c += oppf.NPS2__c;
		    						part.Current_Year_2_NPS3__c += oppf.NPS3__c;
		    						part.Current_Year_2_MSG1__c += oppf.MSG1__c;
		    						part.Current_Year_2_MSG2__c += oppf.MSG2__c;
		    						part.Current_Year_2_MSG3__c += oppf.MSG3__c;
		    					}
		    					if(Integer.valueOf(oppf.Fiscal_Year__c) == (sYear+3))
		    					{
		    						part.Current_Year_3_NPS1__c += oppf.NPS1__c;
		    						part.Current_Year_3_NPS2__c += oppf.NPS2__c;
		    						part.Current_Year_3_NPS3__c += oppf.NPS3__c;
		    						part.Current_Year_3_MSG1__c += oppf.MSG1__c;
		    						part.Current_Year_3_MSG2__c += oppf.MSG2__c;
		    						part.Current_Year_3_MSG3__c += oppf.MSG3__c;
		    					}
		    					if(Integer.valueOf(oppf.Fiscal_Year__c) == (sYear+4))
		    					{
		    						part.Current_Year_4_NPS1__c += oppf.NPS1__c;
		    						part.Current_Year_4_NPS2__c += oppf.NPS2__c;
		    						part.Current_Year_4_NPS3__c += oppf.NPS3__c;
		    						part.Current_Year_4_MSG1__c += oppf.MSG1__c;
		    						part.Current_Year_4_MSG2__c += oppf.MSG2__c;
		    						part.Current_Year_4_MSG3__c += oppf.MSG3__c;
		    					}
		    					if(Integer.valueOf(oppf.Fiscal_Year__c) == (sYear+5))
		    					{
		    						part.Current_Year_5_NPS1__c += oppf.NPS1__c;
		    						part.Current_Year_5_NPS2__c += oppf.NPS2__c;
		    						part.Current_Year_5_NPS3__c += oppf.NPS3__c;
		    						part.Current_Year_5_MSG1__c += oppf.MSG1__c;
		    						part.Current_Year_5_MSG2__c += oppf.MSG2__c;
		    						part.Current_Year_5_MSG3__c += oppf.MSG3__c;
		    					}
	    					}
	    				}
    				}
    			}
			}
			if(!map_partId_part.isEmpty()) 
			{
				CSD_Utils_Class.canCallBatch = false;
				update map_partId_part.values();
			} 
    	}         
                       
    }

    global void finish(Database.BatchableContext BC){
    	CSD_Utils_Class.recalcuNPSMSG = false;              
    } 
}