/**
 *  This Before Insert/Update  the custom Load_Status__c for Working Days.
 * 
 * @author Minghao Li
 * @created 2012-06-12
 * @version 1.0
 * @since 24.0
 * 
 * return
 *
 * @changelog
 * 2015-04-30 Bin Yu <bin.yu@itbconsult.com>
 * - excluded records "FCB Engineering & FCB Regular"
 * 2012-06-12 Minghao Li <minghao.li@itbconsult.com>
 * - Created   
 *
 */
trigger LoadStatus_BIU_fiscalWorking on Load_Status__c (before insert, before update) {
    
    private Map<Integer, String> map_PeriodType = new Map<Integer, String>{
        1 => 'Year',
        2 => 'Month',
        3 => 'Week',
        4 => 'Quarter' 
    };
    String querySql = 'Select p.Type, p.StartDate, p.QuarterLabel, p.PeriodLabel, p.Number, p.IsForecastPeriod,' + //
                             'p.Id, p.FiscalYearSettingsId, p.EndDate ' +   // 
                      'From Period p ' +
                      'Where p.Type = \'' + map_PeriodType.get(2) + '\'';

    List<Period> list_period = Database.query(querySql);
    
    Map<ID, Load_Status__c> map_oldId = Trigger.oldMap;
    
    for(Load_Status__c ls : Trigger.new){
        //added by BYU on 2015-04-30
        if(ls.Name != 'FCB Engineering' && ls.Name != 'FCB Regular'){ 
            if(ls.Current_Date__c == null){
                ls.Total_Fiscal_Working_Days__c = null;
                ls.Fiscal_Working_Days_until_today__c = null;
                ls.Fiscal_Days_until_today__c = null;
                ls.Total_Fiscal_Days__c = null;
                break;
            }
            if(Trigger.isUpdate){
                /*
                START : 2012-06-15 modified by Yuanyuan Zhang
                */
                if(ls.Current_Date__c != map_oldId.get(ls.Id).Current_Date__c){
                /*
                END : 2012-06-15 modified by Yuanyuan Zhang
                */
                    for(Period p : list_period){
                        if(p.StartDate <= ls.Current_Date__c && p.EndDate >= ls.Current_Date__c){
            
                            Integer betweenDays = (p.StartDate.daysBetween(p.EndDate) + 1);
                            ls.Total_Fiscal_Days__c = betweenDays;
                            Date dayOfWeekstart = p.StartDate.toStartOfWeek();
                            
                            Integer weekCount = betweenDays(dayOfWeekstart, p.EndDate);
            
                            ls.Total_Fiscal_Working_Days__c = sumOfBetweenDays(dayOfWeekstart, p.StartDate, betweenDays, weekCount);    
                            if(dayOfWeekstart != p.EndDate){
                                ls.Total_Fiscal_Working_Days__c = (ls.Total_Fiscal_Working_Days__c + 1);                    
                            }
            
                            //dayOfWeekstart = p.StartDate.toStartOfWeek(); 2012-06-15 comment out from yuanyuan zhang
                            weekCount = betweenDays(dayOfWeekstart, ls.Current_Date__c);
            
                            betweenDays = 0;
                            if(ls.Current_Date__c != p.StartDate){
                                betweenDays = (p.StartDate.daysBetween(ls.Current_Date__c) +1);              
                            }                
                            ls.Fiscal_Days_until_today__c = (p.StartDate.daysBetween(ls.Current_Date__c) + 1);              
                            ls.Fiscal_Working_Days_until_today__c = sumOfBetweenDays(dayOfWeekstart, ls.Current_Date__c, betweenDays, weekCount);
            
                            if(dayOfWeekstart != ls.Current_Date__c){
                                ls.Fiscal_Working_Days_until_today__c = (ls.Fiscal_Working_Days_until_today__c + 1);                    
                            }
                            break;
                        }
                    }   
                }
            }
            
        }
        
        
    }
    /* The method is Record count*/
    private Integer betweenDays(Date startWeek, Date endDate){
        Integer weekCount = 0;
        while(startWeek <= endDate){
            startWeek += 7;
            weekCount++;
        }
        return weekCount;
    }
    /*The method is sum of betweendDays*/
    private Integer sumOfBetweenDays(Date startWeek, Date startDate,Integer betweenDays, Integer weekCount){
        Integer sum = 0;
        if(startWeek == startDate){
            sum = (betweenDays - weekCount*2);
            return sum;
        }
        sum = (betweenDays - weekCount*2+1);
        return sum;
    }
    
}