/**
 *  This class is used to recalculate BBB_Month_Bill_Book_Cust__c.
 *  
 * @author Xiaona Liu
 * @created 2013-10-16
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2013-10-16 Xiaona Liu <xiaona.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_recalculateAccountForecast implements Database.Batchable<SObject>, Database.stateful{
    global String query;
    global String filter;
    global String str_where;
    global String currentYear;
    global String currentMonth;
    //global Integer index;
    //global String str_limit = '';
 	
    global Date startDate; 
    global Date endDate;
    global boolean isQuarterStart;
    global boolean isQuarterEnd;
    
    public static final Integer PREVIOUSMONTH = 18;
    
    public ClsBatch_recalculateAccountForecast(){
        //filter = '';
        //Map<Integer,set<Integer>> map_year_months = new Map<Integer,Set<Integer>>();
        ClsFinancialFCBatchUtil.PageConfig pageConf = new ClsFinancialFCBatchUtil.PageConfig();
        ClsFinancialFCBatchUtil.setCurrent(pageConf);
        if(currentYear == null || currentMonth == null) {
        	currentYear = pageConf.currentYear;
        	currentMonth = String.valueOf(pageConf.currentMonth);
        }
        //Added by Bin Yuan due to calc Forecast_Begin_of_Quarter_Document__c, Forecast_End_of_Prev_Quarter_Document__c
    	isQuarterStart = (math.mod(Integer.valueOf(currentMonth), 3) == 1 ? true : false);
    	isQuarterEnd = (math.mod(Integer.valueOf(currentMonth), 3) == 0 ? true : false);
        //End
        
        system.debug('isQuarterStart :: ' + isQuarterStart);
        system.debug('isQuarterEnd :: ' + isQuarterEnd);
        /**
        map<String, Set<Integer>> map_financialMonth = new Map<String,Set<Integer>>();        
        ClsFinancialFCBatchUtil.setfinancialMonths(map_financialMonth);     
        index = ClsFinancialFCBatchUtil.getCurrentMonthIndex(map_financialMonth,String.valueOf(currentYear),currentMonth);
        ClsFinancialFCBatchUtil.setYearMonth(index, currentYear, currentMonth, map_year_months);

        if(!map_year_months.isEmpty()){
            for(Integer year :map_year_months.keySet()){
                filter += ' (Fiscal_year__c = \''+year+'\' and Fiscal_Month__c in (';
                for(Integer month : map_year_months.get(year)){
                    filter += month+',';
                }
                filter = filter.substring(0,filter.length()-1);
                filter += ')) or';
            }     
                
            filter = filter.substring(0,filter.length()-2);    
        }
        **/
        
               
    } 
      
    global Database.QueryLocator start(Database.BatchableContext BC){
    	system.debug('currentYear=='+currentYear);
    	system.debug('currentMonth=='+currentMonth);
    	startDate = Date.newinstance(Integer.valueOf(currentYear), Integer.valueOf(currentMonth), 15);
        endDate = startDate.addMonths(PREVIOUSMONTH);
        
    	if(startDate != null && endDate != null) {
        	filter = 'Fiscal_date__c >= ' + startDate + ' And Fiscal_date__c <= ' + endDate;
        	filter = filter.replaceAll(' 00:00:00', '');
        } 
        if(query == null || query.trim() == ''){
            query = 'Select Id, Fiscal_date__c, Fiscal_year__c, Fiscal_Month__c, forecast__c, Previous_Month_Forecast_Document__c, Last_Frozen_Month_Date__c, Forecast_Begin_of_Quarter_Document__c, Forecast_End_of_Prev_Quarter_Document__c ';
        	for (Integer i = 2; i<= 6; i++) {
        		query += ', Forecast_' + i + '_Months_Document__c';
        		//Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Forecast_4_Months_Document__c,Forecast_5_Months_Document__c,Forecast_6_Months_Document__c,
        	}
        	query += ' From BBB_Month_Bill_Book_Cust__c';
        }
        if(filter != null && filter.trim() !=''){
            query += ' where ' + filter;
        }  
        query += ' and forecast__c != null ';
        query += ((str_where == null || str_where.trim() == '') ? '' : str_where);
        query += ' order by Fiscal_date__c asc ';
        //query += (str_limit == '' ? '' : str_limit);
        system.debug('query :: ' + query);
        system.debug('isQuarterStart 2:: ' + isQuarterStart);
        system.debug('isQuarterEnd 2:: ' + isQuarterEnd);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<BBB_Month_Bill_Book_Cust__c> list_BBMonths){
		//ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, index, currentYear, currentMonth);
        ClsFinancialFCBatchUtil.setBBBMonthBillBookCust(list_BBMonths, startDate, isQuarterStart, isQuarterEnd);
        update list_BBMonths;
    }
    
    global void finish(Database.BatchableContext BC){ 
        ClsBatch_recalculateRSMPreviousForecast rsmPrevForecast = new ClsBatch_recalculateRSMPreviousForecast();
		rsmPrevForecast.currentYear = currentYear;
		rsmPrevForecast.currentMonth = currentMonth;
        database.executeBatch(rsmPrevForecast);
    }
}