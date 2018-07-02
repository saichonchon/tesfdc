/**************************************************************************************************************************************************
Name:  CSD_Utils_Class
Copyright © 2013 TE Connectivity
===================================================================================================================================================
Purpose: This utility class contains CSD Opportunity Record Types and User CSD Region Static Values. 
---------------------------------------------------------------------------------------------------------------------------------------------------       
APEX Classes utilize this class : CSD_Opportunity_Alert_Controller
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version     Developer                   Date             Detail                                               Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
  1.0    Ramakrishna Singara     11/26/2013       Initial Development                                             Req-0172 
  2.0    Michael Cui             07/10/2014       Add some function for Applicance NPS MSG calculation          Case 00689465
  3.0    Nelson Zheng            01/21/2015       Fixed the issue for call batch in trigger
**************************************************************************************************************************************************/
Global class CSD_Utils_Class  {

    public static final String strOppRecordTypeEngg = 'Engineering Opportunity-CSD';
    public static final String strOppRecordTypeSales = 'Sales Opportunity-CSD';
    public static final String strRegionTaiwan = 'Taiwan';
    public static final String strRegionKorea = 'Korea';
    public static Boolean plmTemplateFlag = false;
    public static Boolean plmCreateFlag = false;
    public static Boolean recalcuNPSMSG = false;
    public static Boolean canCallBatch = true;
    public static List<Period> list_fiscalQuarter;    

    //Global CSD_Utils_Class(){}
    
    public static void getAllFiscalQuarter(){
        if(list_fiscalQuarter == null){
            list_fiscalQuarter = new List<Period>();
            for(Period p:  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter']){
                list_fiscalQuarter.add(p);
            }
        }
    } 
    
    public static map<Date,map<String, Date>> getQuarterStartEndDate(set<Date> set_startDate)
    {       
        map<Date, map<String, Date>> returnMap = new map<Date,map<String, Date>>();
        //List<Period> list_fiscalQuarter = [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'quarter'];
        
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
    
    public static map<String,map<String, Date>> getStartEndDateByQuarter()
    {       
        map<String, map<String, Date>> returnMap = new map<String, map<String, Date>>();
        //List<Period> list_fiscalQuarter = [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'quarter'];
                
        for(Period p: list_fiscalQuarter)
        {                   
            returnMap.put(String.valueOf(p.FiscalYearSettings.Name) + String.valueOf(p.Number), new Map<String, Date>());
            returnMap.get(String.valueOf(p.FiscalYearSettings.Name) + String.valueOf(p.Number)).put('Start', p.StartDate);
            returnMap.get(String.valueOf(p.FiscalYearSettings.Name) + String.valueOf(p.Number)).put('End', p.EndDate);
            //break;                 
        }
        
        return returnMap;
    }
    
    public static map<Date,map<String, String>> getQuarter(set<Date> set_startDate)
    {       
        map<Date, map<String, String>> returnMap = new map<Date, map<String, String>>();
        //List<Period> list_fiscalQuarter = [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'quarter'];
        
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
    
    public static map<Id, Opportunity_Part__c> getOpptyPart(set<Id> inputOpptyPartId)
    {
        map<Id, Opportunity_Part__c> returnMap = new map<Id, Opportunity_Part__c>();
        for(Opportunity_Part__c oppPart: [select Part__c, Id, Current_Year_NPS3__c, Current_Year_NPS2__c, Current_Year_MSG3__c, Current_Year_MSG2__c, Current_Year_5_NPS3__c, Current_Year_5_NPS2__c, Current_Year_5_MSG3__c, Current_Year_5_MSG2__c, Current_Year_4_NPS3__c, Current_Year_4_NPS2__c, Current_Year_4_MSG3__c, Current_Year_4_MSG2__c, Current_Year_3_NPS3__c, Current_Year_3_NPS2__c, Current_Year_3_MSG3__c, Current_Year_3_MSG2__c, Current_Year_2_NPS3__c, Current_Year_2_NPS2__c, Current_Year_2_MSG3__c, Current_Year_2_MSG2__c, Current_Year_1_NPS3__c, Current_Year_1_NPS2__c, Current_Year_1_MSG3__c, Current_Year_1_MSG2__c from Opportunity_Part__c where Id in: inputOpptyPartId])
            returnMap.put(oppPart.Id, oppPart);
        return returnMap;
    }
    
    public static void updateNPSMSG(List<Opportunity_Forecast__c> newOpptyFCST)
    {
        try{
        set<Id> opptyId = new set<Id>();
        set<Id> aplOpptyId = new set<Id>();
        set<Id> opptyPartId = new set<Id>();        
        set<Date> npsStartDate = new set<Date>();
        List<Opportunity_Forecast__c> calcuForecast = new List<Opportunity_Forecast__c>();
        Date dueDate = Date.newInstance(2008,9,27);
        for(Opportunity_Forecast__c oppf: newOpptyFCST)
        {
            opptyId.add(oppf.Opportunity__c);
        }
        if(opptyId.size()>0)
        {
            for(Opportunity o: [select Id,Name,RecordTypeId,Industry_Code__c,Owner.GIBU__c from Opportunity where Id in: opptyId])
            {
                if(o.Industry_Code__c == 'Appliances' && o.Owner.GIBU__c == 'Appliances' && ClsOppyForecastUtil.applianceOpptyRecordTypeId().contains(o.RecordTypeId)) 
                    aplOpptyId.add(o.Id);
            }
        }  
        for(Opportunity_Forecast__c oppf: newOpptyFCST)
        {
            if(aplOpptyId.contains(oppf.Opportunity__c) && oppf.Part__c != null && oppf.RecordTypeId == '012E0000000Xqo1IAC' && oppf.APL_NPS_Calculation_Start_Date__c != null)
            {
                calcuForecast.add(oppf);                
                opptyPartId.add(oppf.Part__c);
                if(oppf.APL_NPS_Calculation_Start_Date__c != null)
                    npsStartDate.add(oppf.APL_NPS_Calculation_Start_Date__c);
            }
        }
        
        if(opptyPartId.size()>0)
        {
            String query = 'SELECT Id,Part__c From Opportunity_Part__c where Id in: opptyPartId';                        
            ClsBatch_recalculatePartNPSMSGRevenue ClsBatch = new ClsBatch_recalculatePartNPSMSGRevenue();
            //ClsBatch.partIdSet = partIdSet;
            ClsBatch.query = query;
            Database.executeBatch(ClsBatch,1);
        }
        
        /*if(Trigger.isBefore && Trigger.isInsert)
        {
            if(calcuForecast.size()>0)
            {
                getAllFiscalQuarter();
                map<Date,map<String, Date>> npsQuarterStartEndDate = getQuarterStartEndDate(npsStartDate);
                map<String,map<String, Date>> QuarterStartEndDate = getStartEndDateByQuarter();
                map<Date,map<String, String>> StartQuarter = getQuarter(npsStartDate);
                map<Id, Opportunity_Part__c> mapOpptyPart = getOpptyPart(opptyPartId);
                system.debug('mapOpptyPart ===>' + mapOpptyPart);
                
                for(Opportunity_Forecast__c oppf:calcuForecast)
                {
                    if(mapOpptyPart.get(oppf.Part__c).Part__c == null)                  
                    {
                        if(oppf.APL_NPS_Calculation_Start_Date__c != null && oppf.APL_NPS_Calculation_Start_Date__c >= dueDate)
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
                        if(oppf.APL_NPS_Calculation_Start_Date__c != null && oppf.APL_NPS_Calculation_Start_Date__c >= dueDate)
                        {
                            Decimal tmpAmount = oppf.CurrencyIsoCode != 'USD'? ClsOppyForecastUtil.transformIsoCode(oppf.Amount__c, oppf.CurrencyIsoCode, 'USD'):oppf.Amount__c;
                            Date startDate = npsQuarterStartEndDate.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Start');
                            Date endDate   = npsQuarterStartEndDate.get(oppf.APL_NPS_Calculation_Start_Date__c).get('End');
                            Integer startYear = Integer.valueOf(StartQuarter.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Year'));
                            String strStartQuarter = StartQuarter.get(oppf.APL_NPS_Calculation_Start_Date__c).get('Quarter');
                            Decimal NPS1 = 0;
                            Decimal NPS2 = 0;
                            Decimal NPS3 = 0;
                            //system.debug('startYear ===>' + startYear);
                            //system.debug('strStartQuarter ===>' + strStartQuarter);
                            //system.debug('strStartQuarter111 ===>' + String.valueOf(startYear + 1) + strStartQuarter);
                            //system.debug('QuarterStartEndDate ===>' + QuarterStartEndDate);
                            //system.debug('startYear555 ===>' + QuarterStartEndDate.get(String.valueOf(startYear + 1) + strStartQuarter).get('Start'));
                            system.debug('tmpAmount ===>' + tmpAmount);
                            system.debug('Sales_Price__c ===>' + oppf.Sales_Price__c);
                            system.debug('Quantity__c ===>' + oppf.Quantity__c);
                            system.debug('Date__c ===>' + oppf.Date__c); 
                             system.debug('Amount__c ===>' + oppf.Amount__c);
                            
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
                } 
            }       
        }
        //if(calcuForecast.size()>0) update calcuForecast;
        
        if(Trigger.isAfter && Trigger.isInsert)
        {
            if(opptyPartId.size()>0)
            {
                map<Id,Opportunity_Part__c> map_partId_part = getOpptyPart(opptyPartId);
                system.debug('map_partId_part ===>' + map_partId_part);                
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
                    
                        for(Opportunity_Forecast__c oppf: calcuForecast)
                        {
                            //system.debug('AfterAmount__c ===>' + oppf.Amount__c);
                            if(oppf.Fiscal_Year__c != null && oppf.NPS1__c != null && oppf.NPS2__c != null && oppf.NPS3__c != null && oppf.MSG1__c != null && oppf.MSG2__c != null && oppf.MSG3__c != null)
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
                if(!map_partId_part.isEmpty()) update map_partId_part.values();             
            }
        }*/
    }
    catch(exception ex)
    {
    	throw(ex);
    }
    }
    public static void updateNPSMSG(List<Opportunity> oldOppty, List<Opportunity> newOppty)
    {
        set<Id> opptyId = new set<Id>();
        set<Id> aplOpptyId = new set<Id>();
        set<Id> opptyPartId = new set<Id>();        
        set<Date> npsStartDate = new set<Date>();
        Date dueDate = Date.newInstance(2008,9,27);
        List<Opportunity_Forecast__c> calcuForecast = new List<Opportunity_Forecast__c>();
        for(Integer i=0; i<newOppty.Size(); i++)
        {
            if(newOppty[i].Manufacturing_Start_Date__c != oldOppty[i].Manufacturing_Start_Date__c && newOppty[i].Industry_Code__c == 'Appliances' && ClsOppyForecastUtil.applianceOpptyRecordTypeId().contains(newOppty[i].RecordTypeId))
                opptyId.add(newOppty[i].Id);            
        }
        if(opptyId.size()>0)
        {
            for(Opportunity o: [select Id,Name,RecordTypeId,Industry_Code__c,Owner.GIBU__c from Opportunity where Id in: opptyId])
            {               
                if(o.Owner.GIBU__c == 'Appliances') 
                    aplOpptyId.add(o.Id);
            }
            for(Opportunity_Forecast__c oppf: [SELECT NPS2__c, NPS3__c, MSG2__c, MSG3__c, Date__c, APL_NPS_Calculation_Start_Date__c, Amount__c, CurrencyIsoCode, Fiscal_Quarter__c, Fiscal_Year__c, Part__c, Opportunity__c FROM Opportunity_Forecast__c where Opportunity__c in: aplOpptyId and Part__c != null and Part_Number__c = null])
            {               
                calcuForecast.add(oppf);                
                opptyPartId.add(oppf.Part__c);
                if(oppf.APL_NPS_Calculation_Start_Date__c != null)
                    npsStartDate.add(oppf.APL_NPS_Calculation_Start_Date__c);               
            }
        }
        
        if(Trigger.isAfter)
        {
            if(calcuForecast.size()>0)
            {
                getAllFiscalQuarter();
                map<Date,map<String, Date>> npsQuarterStartEndDate = getQuarterStartEndDate(npsStartDate);
                map<String,map<String, Date>> QuarterStartEndDate = getStartEndDateByQuarter();
                map<Date,map<String, String>> StartQuarter = getQuarter(npsStartDate);
                map<Id, Opportunity_Part__c> mapOpptyPart = getOpptyPart(opptyPartId);
                
                for(Opportunity_Forecast__c oppf:calcuForecast)
                {
                    if(mapOpptyPart.get(oppf.Part__c).Part__c == null)                  
                    {
                        if(oppf.APL_NPS_Calculation_Start_Date__c != null && oppf.APL_NPS_Calculation_Start_Date__c >= dueDate)
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
                } 
            }       
        }
        if(calcuForecast.size()>0) update calcuForecast;        
    }
    
    public static void updateNPSMSGonPart(List<Opportunity_Part__c> oldOpptyPart, List<Opportunity_Part__c> newOpptyPart)
    {
        map<Id,Opportunity_Part__c> map_partId_part = new map<Id,Opportunity_Part__c>();
        Map<Id, List<Opportunity_Forecast__c>> map_partId_forecasts = new Map<Id, List<Opportunity_Forecast__c>>();
        List<Opportunity_Forecast__c> lst_fcst2Update = new List<Opportunity_Forecast__c>();
        set<Id> applOpptyRTId = ClsOppyForecastUtil.applianceOpptyRecordTypeId();
        set<Date> npsStartDate = new set<Date>();
        Date dueDate = Date.newInstance(2008,9,27);
        for(Integer i=0; i<newOpptyPart.Size(); i++)
        {           
            if(newOpptyPart[i].Initial_Order_Date__c != oldOpptyPart[i].Initial_Order_Date__c && oldOpptyPart[i].Initial_Order_Date__c != null && newOpptyPart[i].Part__c != null)
            {
                map_partId_part.put(newOpptyPart[i].Id,newOpptyPart[i]);
            }
        }
        if(!map_partId_part.isEmpty())
        {
            for(Opportunity_Forecast__c fc :[SELECT NPS2__c, NPS3__c, MSG2__c, MSG3__c, Date__c, APL_NPS_Calculation_Start_Date__c, Amount__c, CurrencyIsoCode, Fiscal_Quarter__c, Fiscal_Year__c, Part__c FROM Opportunity_Forecast__c where Part__c in: map_partId_part.keySet() and part__r.part__r.Market_Date__c = null and opportunity__r.Industry_Code__c = 'Appliances' and opportunity__r.Owner.GIBU__c = 'Appliances' and opportunity__r.RecordTypeId in:applOpptyRTId])
            {            
                if(!map_partId_forecasts.containsKey(fc.Part__c)) {
                    map_partId_forecasts.put(fc.Part__c, new List<Opportunity_Forecast__c>());
                    map_partId_forecasts.get(fc.Part__c).add(fc);
                }
                else
                    map_partId_forecasts.get(fc.Part__c).add(fc);
                if(fc.APL_NPS_Calculation_Start_Date__c != null)
                    npsStartDate.add(fc.APL_NPS_Calculation_Start_Date__c);
            }
        }
        if(!map_partId_forecasts.isEmpty())
        {
            getAllFiscalQuarter();
            map<Date,map<String, Date>> npsQuarterStartEndDate = getQuarterStartEndDate(npsStartDate);
            map<String,map<String, Date>> QuarterStartEndDate = getStartEndDateByQuarter();
            map<Date,map<String, String>> StartQuarter = getQuarter(npsStartDate);
            for(Id pId :map_partId_forecasts.keySet())
            {               
                for(Opportunity_Forecast__c oppf :map_partId_forecasts.get(pId))
                {                                   
                    if(oppf.APL_NPS_Calculation_Start_Date__c != null && oppf.APL_NPS_Calculation_Start_Date__c >= dueDate)
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
                    lst_fcst2Update.add(oppf);
                }
            }
        }
        if(lst_fcst2Update.size()>0) update lst_fcst2Update;
    }
    
    public static void recalcuNPSMSGonPart(List<Part__c> oldPart, List<Part__c> newPart)
    {
        set<Id> partIdSet = new set<Id>();
        for(Integer i = 0; i< newPart.size(); i++)
        {
            if(newPart[i].Market_Date__c != oldPart[i].Market_Date__c)
                partIdSet.add(newPart[i].Id);
        }
        //changed by nelson zheng 01-21-2015
        set<Id> applOpptyRTId = ClsOppyForecastUtil.applianceOpptyRecordTypeId();
        List<Opportunity_Part__c> oppPartList = [SELECT Id,Part__c,need_recalculate_PartNPSMSGRevenue__c From Opportunity_Part__c where Part__c in: partIdSet and Opportunity__r.RecordTypeId in: applOpptyRTId and opportunity__r.Industry_Code__c = 'Appliances' and opportunity__r.Owner.GIBU__c = 'Appliances' and APL_Forecast_Calculation_Start_Date__c>=2008-09-27 and Status__c != 'Dead' and Status__c != 'Lost'];
        System.debug('-----------oppPartList------------'+oppPartList);
        for(Opportunity_Part__c oppPart : oppPartList){
        	oppPart.need_recalculate_PartNPSMSGRevenue__c = true;
        }
        update oppPartList;
        /*commented by nelson zheng 01-21-2015
        if(partIdSet.size()>0 && canCallBatch)
        {
            String query = 'SELECT Id,Part__c From Opportunity_Part__c where Part__c in: partIdSet and Opportunity__r.RecordTypeId in: applOpptyRTId and opportunity__r.Industry_Code__c = \'Appliances\' and opportunity__r.Owner.GIBU__c = \'Appliances\' and APL_Forecast_Calculation_Start_Date__c>=2008-09-27 and Status__c != \'Dead\' and Status__c != \'Lost\'';                        
            ClsBatch_recalculatePartNPSMSGRevenue ClsBatch = new ClsBatch_recalculatePartNPSMSGRevenue();
            ClsBatch.partIdSet = partIdSet;
            ClsBatch.query = query;
            Database.executeBatch(ClsBatch,1);
        }
        */
    }
    public static void recalcuNPSMSGonOppyPart(List<Opportunity_Part__c> newPart)
    {
        set<Id> partIdSet = new set<Id>();
        set<Id> usedPartIdSet = new set<Id>();
        for(Integer i = 0; i< newPart.size(); i++)
        {
            //if(newPart[i].Market_Date__c != oldPart[i].Market_Date__c)
                partIdSet.add(newPart[i].Id);
        }
        if(canCallBatch)
        {
	        set<Id> applOpptyRTId = ClsOppyForecastUtil.applianceOpptyRecordTypeId();
	        for(Opportunity_Part__c opp: [SELECT Id,Part__c From Opportunity_Part__c where Id in: partIdSet and Opportunity__r.RecordTypeId in: applOpptyRTId and opportunity__r.Industry_Code__c = 'Appliances' and opportunity__r.Owner.GIBU__c = 'Appliances' and APL_Forecast_Calculation_Start_Date__c>=2008-09-27 and Status__c != 'Dead' and Status__c != 'Lost'])
	        	usedPartIdSet.add(opp.Id);
	        
	        if(usedPartIdSet.size()>0 && canCallBatch)
	        {
	            String query = 'SELECT Id,Part__c From Opportunity_Part__c where Id in: partIdSet and Opportunity__r.RecordTypeId in: applOpptyRTId and opportunity__r.Industry_Code__c = \'Appliances\' and opportunity__r.Owner.GIBU__c = \'Appliances\' and APL_Forecast_Calculation_Start_Date__c>=2008-09-27 and Status__c != \'Dead\' and Status__c != \'Lost\'';                        
	            ClsBatch_recalculatePartNPSMSGRevenue ClsBatch = new ClsBatch_recalculatePartNPSMSGRevenue();
	            ClsBatch.partIdSet = usedPartIdSet;
	            ClsBatch.query = query;
	            Database.executeBatch(ClsBatch,1);
	        }
        }
    }
}