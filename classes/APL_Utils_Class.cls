/**************************************************************************************************************************************************
Name:  APL_Utils_Class
Copyright © 2013 TE Connectivity
===================================================================================================================================================
Purpose: This utility class contains APL functions. 
---------------------------------------------------------------------------------------------------------------------------------------------------       
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version     Developer                   Date             Detail                                               Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
  1.0    Nelson Zheng                 06/15/2015        Created
  1.1    Nelson Zheng                 07/22/2015        Updated
**************************************************************************************************************************************************/
public class APL_Utils_Class {
    
    public static Boolean plmTemplateFlag = false;
    public static Boolean plmCreateFlag = false;
    public static Boolean recalcuNPSMSG = false;
    public static Boolean canCallBatch = true;
    public static List<Period> list_fiscalQuarter; 
    
    //Added by Nelson Zheng 07/22/2015
    public static Boolean calAllocation = true;//identify whether to calculate partner allocation by trigger or not  
    public static Boolean createPartner = true; 
    
    public static void getAllFiscalQuarter(){
        //System.debug('--------Limits.getCpuTime0--------'+Limits.getCpuTime());
        if(list_fiscalQuarter == null){
            list_fiscalQuarter = [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter'];
            //for(Period p:  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter']){
            //    list_fiscalQuarter.add(p);
            //}
        }
        
        //System.debug('--------Limits.getCpuTime1--------'+Limits.getCpuTime());
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
        //System.debug('--------Limits.getCpuTime2--------'+Limits.getCpuTime());
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
       //System.debug('--------Limits.getCpuTime3--------'+Limits.getCpuTime());
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
        //System.debug('--------Limits.getCpuTime4--------'+Limits.getCpuTime());
        return returnMap;
    }
    
    //addded by nelson 7/7/2015
    public static map<String,Object> getQuarterAndQuarterStartEndDate(set<Date> set_startDate){
        map<Date, map<String, Date>> dateMap = new map<Date,map<String, Date>>();
        map<Date, map<String, String>> stringMap = new map<Date, map<String, String>>();
        map<String,Object> returnMap = new map<String,Object>();
        
        for(Date inputDate : set_startDate)
        {
            stringMap.put(inputDate, new Map<String, String>());
            dateMap.put(inputDate, new Map<String, Date>());
            for(Period p: list_fiscalQuarter)
            {
                if(inputDate >= p.StartDate && inputDate <= p.EndDate)
                {                    
                    stringMap.get(inputDate).put('Year', p.FiscalYearSettings.Name);
                    stringMap.get(inputDate).put('Quarter', String.valueOf(p.Number));
                    
                    dateMap.get(inputDate).put('Start', p.StartDate);
                    dateMap.get(inputDate).put('End', p.EndDate);
                    break;
                }         
            }
        }
        
        returnMap.put('stringMap',stringMap);
        returnMap.put('dateMap',dateMap);
        
        return returnMap;
    }
    
    public static map<Id, Opportunity_Part__c> getOpptyPart(set<Id> inputOpptyPartId)
    {
        map<Id, Opportunity_Part__c> returnMap = new map<Id, Opportunity_Part__c>([select Part__c, Id, Current_Year_NPS3__c, Current_Year_NPS2__c, Current_Year_MSG3__c, Current_Year_MSG2__c, Current_Year_5_NPS3__c, Current_Year_5_NPS2__c, Current_Year_5_MSG3__c, Current_Year_5_MSG2__c, Current_Year_4_NPS3__c, Current_Year_4_NPS2__c, Current_Year_4_MSG3__c, Current_Year_4_MSG2__c, Current_Year_3_NPS3__c, Current_Year_3_NPS2__c, Current_Year_3_MSG3__c, Current_Year_3_MSG2__c, Current_Year_2_NPS3__c, Current_Year_2_NPS2__c, Current_Year_2_MSG3__c, Current_Year_2_MSG2__c, Current_Year_1_NPS3__c, Current_Year_1_NPS2__c, Current_Year_1_MSG3__c, Current_Year_1_MSG2__c from Opportunity_Part__c where Id in: inputOpptyPartId]);
        //System.debug('--------Limits.getCpuTime5--------'+Limits.getCpuTime());
        //for(Opportunity_Part__c oppPart: )
            //returnMap.put(oppPart.Id, oppPart);
        return returnMap;
    }
    
    public static void updateNPSMSG(List<Opportunity> oldOppty, List<Opportunity> newOppty){
        set<Id> opptyId = new set<Id>();
        set<Id> aplOpptyId = new set<Id>();
        set<Id> opptyPartId = new set<Id>();        
        set<Date> npsStartDate = new set<Date>();
        Date dueDate = Date.newInstance(2008,9,27);
        List<Opportunity_Forecast__c> calcuForecast = new List<Opportunity_Forecast__c>();
        for(Integer i=0; i<newOppty.Size(); i++)
        {
            //if(ClsOppyForecastUtil.applianceOpptyRecordTypeId().contains(newOppty[i].RecordTypeId))
                //newOppty[i].Industry_Code__c == 'Appliances' && newOppty[i].Manufacturing_Start_Date__c != oldOppty[i].Manufacturing_Start_Date__c && 
                opptyId.add(newOppty[i].Id);            
        }
        //System.debug('-------------opptyId opp-----------'+opptyId);
        if(opptyId.size()>0)
        {
            
            for(Opportunity_Forecast__c oppf: [SELECT NPS2__c, NPS3__c, MSG2__c, MSG3__c, Date__c, APL_NPS_Calculation_Start_Date__c, Amount__c, CurrencyIsoCode, Fiscal_Quarter__c, Fiscal_Year__c, Part__c, Opportunity__c FROM Opportunity_Forecast__c where Opportunity__c in: aplOpptyId and Part__r.BU_profit_center__c like 'Appliance%'])
            {       
                //and Opportunity__r.Owner.GIBU__c = 'Appliances'         
                calcuForecast.add(oppf);                
                opptyPartId.add(oppf.Part__c);
                if(oppf.APL_NPS_Calculation_Start_Date__c != null)
                    npsStartDate.add(oppf.APL_NPS_Calculation_Start_Date__c);               
            }
        }
        
        if(calcuForecast.size()>0){
                getAllFiscalQuarter();
                map<Date,map<String, Date>> npsQuarterStartEndDate = getQuarterStartEndDate(npsStartDate);
                map<String,map<String, Date>> QuarterStartEndDate = getStartEndDateByQuarter();
                map<Date,map<String, String>> StartQuarter = getQuarter(npsStartDate);
                map<Id, Opportunity_Part__c> mapOpptyPart = getOpptyPart(opptyPartId);
                
                for(Opportunity_Forecast__c oppf:calcuForecast)
                {
                    //if(mapOpptyPart.get(oppf.Part__c).Part__c == null)                  
                    //{
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
                    //}                                   
                } 
        }       
        //System.debug('------------calcuForecast opp---------------'+calcuForecast);
        if(calcuForecast.size()>0) 
            update calcuForecast;        
    }
    
    //added by nelson 06/15/2015
    public static void updateNPSMSGonPartNew(Set<Id> oppIdSet)
    {
        System.debug('--------Limits.getCpuTime1--------'+Limits.getCpuTime());
        set<Id> opptyId = new set<Id>();
        set<Id> aplOpptyId = new set<Id>();
        set<Id> opptyPartId = new set<Id>();        
        set<Date> npsStartDate = new set<Date>();
        Date dueDate = Date.newInstance(2008,9,27);
        List<Opportunity_Forecast__c> calcuForecast = new List<Opportunity_Forecast__c>();
        System.debug('--------Limits.getCpuTime2--------'+Limits.getCpuTime());
        if(oppIdSet.size()>0)
        {
            
            
            for(Opportunity_Forecast__c oppf: [SELECT NPS2__c, NPS3__c, MSG2__c, MSG3__c, Date__c, APL_NPS_Calculation_Start_Date__c, Amount__c, CurrencyIsoCode, Fiscal_Quarter__c, Fiscal_Year__c, Part__c, Opportunity__c FROM Opportunity_Forecast__c where Opportunity__c in: oppIdSet and Part__r.BU_profit_center__c like 'Appliance%'])
            {  
                //and Opportunity__r.Owner.GIBU__c = 'Appliances' and opportunity__r.RecordTypeId in: ClsOppyForecastUtil.applianceOpptyRecordTypeId()         
                calcuForecast.add(oppf);                
                opptyPartId.add(oppf.Part__c);
                if(oppf.APL_NPS_Calculation_Start_Date__c != null)
                    npsStartDate.add(oppf.APL_NPS_Calculation_Start_Date__c);               
            }
        }
        System.debug('--------Limits.getCpuTime3--------'+Limits.getCpuTime());
        
            if(calcuForecast.size()>0)
            {
                getAllFiscalQuarter();
                map<String,Object> quarterAndQuarterStartEndDate = getQuarterAndQuarterStartEndDate(npsStartDate);
                map<Date,map<String, Date>> npsQuarterStartEndDate = (map<Date,map<String, Date>>)quarterAndQuarterStartEndDate.get('dateMap');
                map<Date,map<String, String>> StartQuarter = (map<Date,map<String, String>>)quarterAndQuarterStartEndDate.get('stringMap');
                //map<Date,map<String, Date>> npsQuarterStartEndDate = getQuarterStartEndDate(npsStartDate);
                
                map<String,map<String, Date>> QuarterStartEndDate = getStartEndDateByQuarter();
                //map<Date,map<String, String>> StartQuarter = getQuarter(npsStartDate);
                
                map<Id, Opportunity_Part__c> mapOpptyPart = getOpptyPart(opptyPartId);
                //System.debug('---------------mapOpptyPart----------------'+mapOpptyPart);
                System.debug('--------Limits.getCpuTime4--------'+Limits.getCpuTime());
                for(Opportunity_Forecast__c oppf:calcuForecast)
                {
                    
                        //System.debug('----------------------enter-------------------');
                        if(oppf.APL_NPS_Calculation_Start_Date__c != null && oppf.APL_NPS_Calculation_Start_Date__c >= dueDate)
                        {
                            //System.debug('----------------------enter1-------------------');
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
                System.debug('--------Limits.getCpuTime5--------'+Limits.getCpuTime());
            }       
        
        //System.debug('------------calcuForecast---------------'+calcuForecast);
        if(calcuForecast.size()>0) 
            update calcuForecast;
        
        System.debug('--------Limits.getCpuTime6--------'+Limits.getCpuTime());
    }
    
    public static void recalcuNPSMSGonPart(List<Part__c> oldPart, List<Part__c> newPart)
    {
        set<Id> partIdSet = new set<Id>();
        for(Integer i = 0; i< newPart.size(); i++)
        {
            if(newPart[i].Market_Date__c != oldPart[i].Market_Date__c)
                partIdSet.add(newPart[i].Id);
        }
        
        set<Id> applOpptyRTId = ClsOppyForecastUtil.applianceOpptyRecordTypeId();
        List<Opportunity_Part__c> oppPartList = [SELECT Id,Part__c,need_recalculate_PartNPSMSGRevenue__c From Opportunity_Part__c where Part__c in: partIdSet and Opportunity__r.RecordTypeId in: applOpptyRTId and bu_profit_center__c = 'Appliances' and opportunity__r.Owner.GIBU__c = 'Appliances' and APL_Forecast_Calculation_Start_Date__c>=2008-09-27 and Status__c != 'Dead' and Status__c != 'Lost'];
        System.debug('-----------oppPartList------------'+oppPartList);
        for(Opportunity_Part__c oppPart : oppPartList){
            oppPart.need_recalculate_PartNPSMSGRevenue__c = true;
        }
        update oppPartList;
        
    }
}