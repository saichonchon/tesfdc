global class ClsBatch_buildOpportunityMeasures implements Database.Batchable<SObject>,Database.Stateful{

    public String query;
    global Id ForecastRTOppy = [SELECT Id FROM RecordType WHERE DeveloperName = 'Opportunity' and SObjectType = 'Opportunity_Forecast__c' Limit 1].Id;
    global list<Period> StartEndDates = new list<Period>(); 
    global Period StartQuarter = new Period();
    global Period EndQuarter = new Period();
    global Period StartMonth = new Period();
    global Period EndMonth = new Period();
    global map<String, Double> ConversionMap = new map<String, Double>();
    //JNV - use global measure map, since batches will sum amounts rather than update on each pass
    global map<String, Overall_Measures__c> measureMap = new map<String, Overall_Measures__c>();
    global map<String, Id> overallFcstMap = new map<String, Id>();    
    global map<String, Date> startDateMap = new map<String, Date>();
    global integer StartMonthNumber = 1;
    global integer EndMonthNumber = 3;

    global Database.QueryLocator start(Database.BatchableContext BC)
    { 
    	//JNV - Get conversion rates in order to convert all amounts to USD
        list<CurrencyType> ConversionRates = [SELECT ConversionRate, IsoCode FROM CurrencyType where IsActive = true];
        
        for(CurrencyType c : ConversionRates)
        {
        	ConversionMap.put(c.ISOCode, c.ConversionRate);
        }
	
    	list<Overall_Measures__c> measureList = [SELECT Id, Name, CurrencyIsoCode, GAM_Code__c, Overall_Forecast__c,
    												Previous_Month_1__c, Previous_Month_2__c, Previous_Month_3__c, 
    												Previous_Month_4__c, Previous_Month_5__c, Previous_Month_6__c,  
    												Month_0__c, Month_1__c, Month_2__c, Month_3__c, Month_4__c,
    												Month_5__c, Month_6__c, Month_7__c, Month_8__c, Month_9__c,
    												Month_10__c, Month_11__c, Month_12__c, Month_13__c, Month_14__c,
    												Month_15__c, Month_16__c, Month_17__c from Overall_Measures__c 
    												where Type__c = 'Total Opportunities'];
    												
    	list<Overall_Forecast__c> overallFcstList = [Select Id, GAM_code__c from Overall_Forecast__c];
    	
    	for(Overall_Forecast__c fcst : overallFcstList)
    	{
    		overallFcstMap.put(fcst.GAM_code__c, fcst.Id);
    	}
    	
    	//JNV - clear out opportunity measures to start											
    	for(Overall_Measures__c measure : measureList)
    	{
    		measure.Previous_Month_1__c = 0;
    		measure.Previous_Month_2__c = 0;
    		measure.Previous_Month_3__c = 0;
    		measure.Previous_Month_4__c = 0;
    		measure.Previous_Month_5__c = 0;
    		measure.Previous_Month_6__c = 0;
    		measure.Month_0__c = 0;
    		measure.Month_1__c = 0;
    		measure.Month_2__c = 0;
    		measure.Month_3__c = 0;
    		measure.Month_4__c = 0;
    		measure.Month_5__c = 0;
    		measure.Month_6__c = 0;
    		measure.Month_7__c = 0;
    		measure.Month_8__c = 0;
    		measure.Month_9__c = 0;
    		measure.Month_10__c = 0;
    		measure.Month_11__c = 0;
    		measure.Month_12__c = 0;
    		measure.Month_13__c = 0;
    		measure.Month_14__c = 0;
    		measure.Month_15__c = 0;
    		measure.Month_16__c = 0;
    		measure.Month_17__c = 0;
    		measure.Overall_Forecast__c = overallFcstMap.get(measure.GAM_Code__c);

  		    measureMap.put(measure.GAM_Code__c, measure);		
    	}
    	
    	Period CurrentMonth = [SELECT EndDate, Number, Id, PeriodLabel, QuarterLabel, StartDate, Type FROM Period where StartDate <= Today and EndDate >= Today and Type = 'Month'];
        String DaysForward = '518';
        
        //JNV - if current date is more than 28 days from start date, and it's still the current month, then it's a 35 day month
        // offset final week of month back by 7 days to continue falling in the right month.
        If(System.today() > CurrentMonth.StartDate.addDays(27))
        {
        	DaysForward = '511';
        }
        
        //JNV - Get all valid time periods for forecasts
        String periodQuery = 'SELECT EndDate, Number, Id, PeriodLabel, QuarterLabel, StartDate, Type FROM Period ' +
        					 ' WHERE ((StartDate < LAST_N_DAYS:182 and EndDate >= LAST_N_DAYS:182) ' +
        					 ' OR (StartDate <= NEXT_N_DAYS:' + DaysForward + ' and EndDate > NEXT_N_DAYS:' + DaysForward + ') ' +
        					 ' OR (StartDate = LAST_N_DAYS:182 OR EndDate = NEXT_N_DAYS:' + DaysForward + ')) ' +
        					 ' and Type in (\'Month\',\'Quarter\') order by Type desc, StartDate';
        					         
        StartEndDates = Database.query(periodQuery); 	
    	
     	StartQuarter = StartEndDates[0];
     	//system.debug('***** JNV array size - ' + CurrentMonth.StartDate.addDays(27) + ' ' + System.today());
     	if(StartEndDates.size() == 32)
     	{
	    	EndQuarter = StartEndDates[7];
    		StartMonth = StartEndDates[8];
	    	EndMonth = StartEndDates[31];
     	}
     	else
     	{
	    	EndQuarter = StartEndDates[8];
    		StartMonth = StartEndDates[9];
	    	EndMonth = StartEndDates[32];     		
     	}
    	    	
    	//JNV - figure out which monthly bucket a forecast date will be associated with
    	Integer QCount = 1;
    	Integer MCount = 1;    	
    	for(Period p : StartEndDates)
    	{
    		if(p.Type == 'Quarter')
    		{
    			startDateMap.put('Q' + QCount, p.StartDate);
    			QCount++;
    		}
    		else
    		{
    			startDateMap.put('M' + MCount, p.StartDate);
    			MCount++;    			
    		}
    	}    	
    	
    	if(StartQuarter.EndDate == StartMonth.EndDate)
    	{
    		StartMonthNumber = 3;
    		EndMonthNumber = 2;
    	}
    	else if(StartQuarter.StartDate != StartMonth.StartDate)
    	{
    		StartMonthNumber = 2;
    		EndMonthNumber = 1;    		
    	}
    	
    	//JNV - get opportunity partners on opportunities fulfilling run rate relevancy criteria
        if (query == null || query == '')
        {
            query =   'SELECT Allocation__c, Opportunity__c, Primary__c, Account__c, Account__r.GAMCD__c ' 
						+ ' FROM Opportunity_Partner__c '
						+ ' where Primary__c = true '
						+ ' and Account__r.GAMCD__c != null '
						+ ' and Account__r.ACCT_GROUP_CDE__c = \'0001\' '
						+ ' and Opportunity__r.Mass_Prod_Status__c = true ' 
						+ ' and Allocation__c > 0 '
						+ ' and Opportunity__r.StageName in (\'Won - Closed\', \'Won - Open\') ';                                      
        }
        
        upsert(measureList);        
        
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, list<Opportunity_Partner__c> oppyPartnerBatch)
    {
    	set<Id> gamOppyIds = new set<Id>();
    	set<Id> quarterlyFcstOppIds = new set<Id>();
    	set<Id> monthlyFcstOppIds = new set<Id>();
    	set<String> gamCdeSet = new set<String>(); //add measures for GAM Codes not already in existing set of measures
    	map<Id, Double> allocationMap = new map<Id, Double>();
    	map<Id, String> partnerGAMCdeMap = new map<Id, String>();    	
    	Opportunity TempOpp = new Opportunity();
    	
    	list<Opportunity_Forecast__c> qtrlyFcsts = new list<Opportunity_Forecast__c>();
    	list<Opportunity_Forecast__c> monthlyFcsts = new list<Opportunity_Forecast__c>();

		//system.debug('***** JNV - I got into the execute!');
    	for(Opportunity_Partner__c oppyPart : oppyPartnerBatch)
    	{
    		gamOppyIds.add(oppyPart.opportunity__c);
    		gamCdeSet.add(oppyPart.account__r.gamcd__c);   //JNV this actually works outside of test class...		
    		allocationMap.put(oppyPart.opportunity__c, oppyPart.allocation__c);
    		partnerGAMCdeMap.put(oppyPart.opportunity__c, oppyPart.account__r.gamcd__c);    		
    	}
    	
    	//JNV - add measures to map if they don't exist
    	for(string gamCde : gamCdeSet)
    	{
    		if(!measureMap.keyset().contains(gamCde))
    		{
    			Overall_Measures__c addMeasure = new Overall_Measures__c();
    			addMeasure.CurrencyISOCode = 'USD';
    			addMeasure.Type__c = 'Total Opportunities';
    			addMeasure.GAM_Code__c = gamCde;
	    		addMeasure.Previous_Month_1__c = 0;
	    		addMeasure.Previous_Month_2__c = 0;
	    		addMeasure.Previous_Month_3__c = 0;
	    		addMeasure.Previous_Month_4__c = 0;
	    		addMeasure.Previous_Month_5__c = 0;
	    		addMeasure.Previous_Month_6__c = 0;
	    		addMeasure.Month_0__c = 0;
	    		addMeasure.Month_1__c = 0;
	    		addMeasure.Month_2__c = 0;
	    		addMeasure.Month_3__c = 0;
	    		addMeasure.Month_4__c = 0;
	    		addMeasure.Month_5__c = 0;
	    		addMeasure.Month_6__c = 0;
	    		addMeasure.Month_7__c = 0;
	    		addMeasure.Month_8__c = 0;
	    		addMeasure.Month_9__c = 0;
	    		addMeasure.Month_10__c = 0;
	    		addMeasure.Month_11__c = 0;
	    		addMeasure.Month_12__c = 0;
	    		addMeasure.Month_13__c = 0;
	    		addMeasure.Month_14__c = 0;
	    		addMeasure.Month_15__c = 0;
	    		addMeasure.Month_16__c = 0;
	    		addMeasure.Month_17__c = 0;
	    		
	    		if(overallFcstMap.containsKey(gamCde))
	    		{
	    			addMeasure.Overall_Forecast__c = overallFcstMap.get(gamCde);
	    		}
	
	  		    measureMap.put(gamCde, addMeasure);    			
    		}
    	}

		//system.debug('***** JNV - I\'m about to do some queries! ' + StartQuarter.StartDate + ' ' + EndQuarter.EndDate + ' ' + StartMonth.StartDate + ' ' + EndMonth.EndDate);
		//system.debug('***** JNV - I\'m about to do some queries! ' + gamOppyIds);
		    	    	
		//JNV - scan for opportunity forecasts in all possible periods, get opportunities fcsting quarterly vs. monthly    	    	
    	aggregateResult[] aggregateQtrly = [SELECT count(id), Fiscal_Quarter__c, Fiscal_Year__c, Opportunity__c 
    													FROM Opportunity_Forecast__c 
    													where date__c >=: StartQuarter.StartDate
    													and date__c <: EndQuarter.EndDate
    													and RecordTypeId =: ForecastRTOppy 
    													and part__c = null 
    													and opportunity__c in: gamOppyIds
														group by opportunity__c,  
														Fiscal_Quarter__c, Fiscal_Year__c 
														having count(id) = 1 
														order by opportunity__c, fiscal_year__c, 
														fiscal_quarter__c];
    	aggregateResult[] aggregateMonthly = [SELECT count(id), Fiscal_Quarter__c, Fiscal_Year__c, Opportunity__c
    													FROM Opportunity_Forecast__c 
    													where date__c >=: StartMonth.StartDate 
    													and date__c <: EndMonth.EndDate 
    													and RecordTypeId =: ForecastRTOppy 
    													and part__c = null 
    													and opportunity__c in: gamOppyIds
														group by opportunity__c, 
														Fiscal_Quarter__c, Fiscal_Year__c 
														having count(id) = 3 
														order by opportunity__c, fiscal_year__c, 
														fiscal_quarter__c];    	
    	   	
    	for(aggregateResult qtrs : aggregateQtrly)
    	{
    		quarterlyFcstOppIds.add((Id)qtrs.get('opportunity__c'));    		
    	}
    	for(aggregateResult months : aggregateMonthly)
    	{
    		monthlyFcstOppIds.add((Id)months.get('opportunity__c'));
    	}    	    
    	
    	//JNV - Get Quarterly Forecast records
    	qtrlyFcsts = [SELECT Amount__c, CurrencyIsoCode, Date__c, Fiscal_Quarter__c, Fiscal_Year__c, Fiscal_Year_Quarter__c, Opportunity__c 
    				  FROM Opportunity_Forecast__c
    				  WHERE date__c >=: StartQuarter.StartDate 
    				  and date__c <=: EndQuarter.EndDate //End date, or start date here?
    				  and RecordTypeId =: ForecastRTOppy 
    				  and part__c = null 
    				  and opportunity__c in: quarterlyFcstOppIds];
    	
    	double TempAmount = 0;
    				  
    	system.debug('***** JNV - Now I want to update my map');			  
    	for(Opportunity_Forecast__c qFcst : qtrlyFcsts)
    	{
    		//JNV - Divide total for qtr by 3
	    	TempAmount = ((qFcst.Amount__c*(allocationMap.get(qFcst.opportunity__c)/100))/ConversionMap.get(qFcst.CurrencyISOCode))/3;
    		//system.debug('***** JNV - ' + qFcst.opportunity__r.account.gamcd__c + ' ' + qFcst.opportunity__c + ' ' + qFcst.Amount__c + ' ' + allocationMap.get(qFcst.opportunity__c) + ' ' + TempAmount);	    	
    		
    		//JNV - If startmonth in quarter is not 1, only set values for months in that quarter, and offset which months to update
    		if(qFcst.Date__c == startDateMap.get('Q1') && StartMonthNumber != 1)
    		{
    			if(StartMonthNumber == 2)
    			{
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_6__c += TempAmount;
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_5__c += TempAmount;    				
    			}
    			else
    			{
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_6__c += TempAmount;
    			}
    		}
    		//JNV - Q9 will only exist if start month was not first month in quarter
    		else if(qFcst.Date__c == startDateMap.get('Q9'))
    		{
    			if(EndMonthNumber == 2)
    			{
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_16__c += TempAmount;
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_17__c += TempAmount;    				
    			}
    			else
    			{
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_17__c += TempAmount;
    			}    			
    		}
    		else
    		{

    			if(qFcst.Date__c == startDateMap.get('Q1'))
    			{
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_6__c += TempAmount;
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_5__c += TempAmount;
    				measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_4__c += TempAmount;
    			}	    					    				    			
    			else if(qFcst.Date__c == startDateMap.get('Q2'))
    			{
    				if(StartMonthNumber == 1)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_3__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_2__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_1__c += TempAmount;    					    				
    				}    				
    				else if(StartMonthNumber == 2)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_4__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_3__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_2__c += TempAmount;    					    				
    				}
    				else
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_5__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_4__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_3__c += TempAmount;
    				}
    			}
    			else if(qFcst.Date__c == startDateMap.get('Q3'))
    			{
    				if(StartMonthNumber == 1)
    				{	
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_0__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_1__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_2__c += TempAmount;
    					//system.debug('***** JNV - Q3, startmonth 1');    					    				
    				}    				
    				else if(StartMonthNumber == 2)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_1__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_0__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_1__c += TempAmount;
    					//system.debug('***** JNV - Q3, startmonth 2');    					    				    					    					    				
    				}
    				else
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_2__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Previous_Month_1__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_0__c += TempAmount;
    					//system.debug('***** JNV - Q3, startmonth 3');    					    				    					
    				}
    			}
    			else if(qFcst.Date__c == startDateMap.get('Q4'))
    			{
    				if(StartMonthNumber == 1)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_3__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_4__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_5__c += TempAmount;    					    				
    				}    				
    				else if(StartMonthNumber == 2)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_2__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_3__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_4__c += TempAmount;    					    				
    				}
    				else
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_1__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_2__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_3__c += TempAmount;
    				}
    			}
    			else if(qFcst.Date__c == startDateMap.get('Q5'))
    			{
    				if(StartMonthNumber == 1)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_6__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_7__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_8__c += TempAmount;    					    				
    				}    				
    				else if(StartMonthNumber == 2)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_5__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_6__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_7__c += TempAmount;    					    				
    				}
    				else
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_4__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_5__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_6__c += TempAmount;
    				}
    			}
    			else if(qFcst.Date__c == startDateMap.get('Q6'))
    			{
    				if(StartMonthNumber == 1)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_9__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_10__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_11__c += TempAmount;    					    				
    				}    				
    				else if(StartMonthNumber == 2)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_8__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_9__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_10__c += TempAmount;    					    				
    				}
    				else
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_7__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_8__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_9__c += TempAmount;
    				}
    			}    			    			    			
    			else if(qFcst.Date__c == startDateMap.get('Q7'))
    			{
    				if(StartMonthNumber == 1)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_12__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_13__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_14__c += TempAmount;    					    				
    				}    				
    				else if(StartMonthNumber == 2)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_11__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_12__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_13__c += TempAmount;    					    				
    				}
    				else
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_10__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_11__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_12__c += TempAmount;
    				}
    			}
    			else if(qFcst.Date__c == startDateMap.get('Q8'))
    			{
    				if(StartMonthNumber == 1)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_15__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_16__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_17__c += TempAmount;    					    				
    				}    				
    				else if(StartMonthNumber == 2)
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_14__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_15__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_16__c += TempAmount;    					    				
    				}
    				else
    				{
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_13__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_14__c += TempAmount;
    					measureMap.get(partnerGAMCdeMap.get(qFcst.opportunity__c)).Month_15__c += TempAmount;
    				}
    			}    			    			    			    			    			
    		}
    		TempAmount = 0;    		
    	}

		//JNV - Get Monthly Forecast records
    	monthlyFcsts = [SELECT Amount__c, CurrencyIsoCode, Date__c, Fiscal_Quarter__c, Fiscal_Year__c, Fiscal_Year_Quarter__c, Opportunity__c 
    				  FROM Opportunity_Forecast__c
    				  WHERE date__c >=: StartMonth.StartDate 
    				  and date__c <=: EndMonth.StartDate 
    				  and RecordTypeId =: ForecastRTOppy 
    				  and part__c = null 
    				  and opportunity__c in: monthlyFcstOppIds];
    	
    	TempAmount = 0;
    	
    	//JNV - months can go directly in appropriate month bucket of measure record			  
    	for(Opportunity_Forecast__c mFcst : monthlyFcsts)
    	{    		
    		TempAmount = (mFcst.Amount__c*(allocationMap.get(mFcst.opportunity__c)/100))/ConversionMap.get(mFcst.CurrencyISOCode);
    		if(mFcst.Date__c == startDateMap.get('M1'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Previous_Month_6__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M2'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Previous_Month_5__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M3'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Previous_Month_4__c += TempAmount;
    		}    		
    		else if(mFcst.Date__c == startDateMap.get('M4'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Previous_Month_3__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M5'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Previous_Month_2__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M6'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Previous_Month_1__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M7'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_0__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M8'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_1__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M9'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_2__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M10'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_3__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M11'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_4__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M12'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_5__c += TempAmount;
    		} 
    		else if(mFcst.Date__c == startDateMap.get('M13'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_6__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M14'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_7__c += TempAmount;
    		}    		    		   		    		    		    
    		else if(mFcst.Date__c == startDateMap.get('M15'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_8__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M16'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_9__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M17'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_10__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M18'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_11__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M19'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_12__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M20'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_13__c += TempAmount;
    		} 
    		else if(mFcst.Date__c == startDateMap.get('M21'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_14__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M22'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_15__c += TempAmount;
    		} 
    		else if(mFcst.Date__c == startDateMap.get('M23'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_16__c += TempAmount;
    		}
    		else if(mFcst.Date__c == startDateMap.get('M24'))
    		{
    			measureMap.get(partnerGAMCdeMap.get(mFcst.opportunity__c)).Month_17__c += TempAmount;
    		}
    		TempAmount = 0;    		    		   		    		   		    		    		    		    		    				    		    		    		    		    		    		    		
    	}    	    		
                
        /*upsert oppyMeasures;    */   
    }
    
    global void finish(Database.BatchableContext BC)
    {
    	list<String> missingGAMHierarchies = new list<String>();
    	list<Sales_Hierarchy__c> addHierarchies = new list<Sales_Hierarchy__c>();
    	map<String, Id> hierarchyMap = new map<String, Id>();

		//JNV - find and set missing sales hierarchies on measures to create
    	for(Overall_Measures__c om1 : measureMap.values())
    	{
    		if(om1.Sales_Hierarchy__c == null)
    		{
    			missingGAMHierarchies.add(om1.Gam_Code__c);
    		}
    		
    		//JNV - round total amounts to 2 decimal places
			om1.Previous_Month_1__c = om1.Previous_Month_1__c.setScale(2);
			om1.Previous_Month_2__c = om1.Previous_Month_2__c.setScale(2);
			om1.Previous_Month_3__c = om1.Previous_Month_3__c.setScale(2);
			om1.Previous_Month_4__c = om1.Previous_Month_4__c.setScale(2);
			om1.Previous_Month_5__c = om1.Previous_Month_5__c.setScale(2);
			om1.Previous_Month_6__c = om1.Previous_Month_6__c.setScale(2);
			om1.Month_0__c = om1.Month_0__c.setScale(2);
			om1.Month_1__c = om1.Month_1__c.setScale(2);
			om1.Month_2__c = om1.Month_2__c.setScale(2);
			om1.Month_3__c = om1.Month_3__c.setScale(2);
			om1.Month_4__c = om1.Month_4__c.setScale(2);
			om1.Month_5__c = om1.Month_5__c.setScale(2);
			om1.Month_6__c = om1.Month_6__c.setScale(2);
			om1.Month_7__c = om1.Month_7__c.setScale(2);
			om1.Month_8__c = om1.Month_8__c.setScale(2);
			om1.Month_9__c = om1.Month_9__c.setScale(2);
			om1.Month_10__c = om1.Month_10__c.setScale(2);
			om1.Month_11__c = om1.Month_11__c.setScale(2);
			om1.Month_12__c = om1.Month_12__c.setScale(2);
			om1.Month_13__c = om1.Month_13__c.setScale(2);
			om1.Month_14__c = om1.Month_14__c.setScale(2);
			om1.Month_15__c = om1.Month_15__c.setScale(2);
			om1.Month_16__c = om1.Month_16__c.setScale(2);
			om1.Month_17__c = om1.Month_17__c.setScale(2);   		
    	}

		//system.debug('***** - JNV ' + missingGAMHierarchies);		
		if(missingGAMHierarchies.size() > 0)
		{
	    	addHierarchies = [SELECT Id, Level_7_Territory_Code__c from Sales_Hierarchy__c where Hierarchy_Type__c = 'Global Account Manager Hierarchy (GAM)' and Level_7_Territory_Code__c in: missingGAMHierarchies];
	
			for(Sales_Hierarchy__c sh : addHierarchies)
			{
				hierarchyMap.put(sh.Level_7_Territory_Code__c, sh.Id );
			}
						
	    	for(Overall_Measures__c om2 : measureMap.values())
	    	{
	    		if(om2.Sales_Hierarchy__c == null)
	    		{
	    			om2.Sales_Hierarchy__c = hierarchyMap.get(om2.Gam_Code__c);
	    		}
	    	}
		}

    	system.debug('***** JNV - Updating...');
        upsert(measureMap.values());
    }    
    
}