/**
 *  This class is used to recalculate Manager_Forecast__c.
 *  
 * @author Xiaona Liu
 * @created 2013-10-21
 * @version 1.0
 * @since 28.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2013-10-21 Xiaona Liu <xiaona.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_recalculateRSMPreviousForecast implements Database.Batchable<SObject>, Database.stateful{
    global String query;
    global String filter;
    global String currentYear;
    global String currentMonth;
    //public Integer index;
    //public String str_limit = '';  
    
    global Date startDate; 
    global Date endDate;
    
    global boolean isQuarterStart;
    global boolean isQuarterEnd;
    
    public static final Integer PREVIOUSMONTH = 18;
    
    public ClsBatch_recalculateRSMPreviousForecast(){
        /* add lili 2013.11.19 begin
        CtrlAccountForecast.PageConfig pageConf = new CtrlAccountForecast.PageConfig();
        CtrlAccountForecastUtil.setCurrent(pageConf);
        */
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
        
        //Set<Date> set_date = new Set<Date>();
        
        //map<String, Set<Integer>> map_financialMonth = new Map<String,Set<Integer>>();
        // add lili begin
        //CtrlAccountForecastUtil.setfinancialMonths(map_financialMonth);
        //ClsFinancialFCBatchUtil.setfinancialMonths(map_financialMonth);
        //index = CtrlAccountForecastUtil.getCurrentMonthIndex(map_financialMonth,String.valueOf(currentYear),currentMonth);
        //index = ClsFinancialFCBatchUtil.getCurrentMonthIndex(map_financialMonth,String.valueOf(currentYear),currentMonth);
        
        /*
        if(index-6 == 1){
            //set_date.add(currentYear+','+currentMonth);
            set_date.add(date.newinstance(currentYear, currentMonth, 15));
        }else if(index-6 == 2){
            if(currentMonth == 1){
                //set_date.add((currentYear-1)+','+'12');
                //set_date.add(currentYear+','+currentMonth);
                set_date.add(date.newinstance(currentYear-1, 12, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }else{
                //set_date.add(currentYear+','+(currentMonth-1));
                //set_date.add(currentYear+','+currentMonth);
                set_date.add(date.newinstance(currentYear, currentMonth-1, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }
        }else if(index-6 == 3){
            if(currentMonth == 2){
                //set_date.add((currentYear-1)+','+'12');
                //set_date.add(currentYear+','+(currentMonth-1));
                //set_date.add(currentYear+','+currentMonth);
                set_date.add(date.newinstance(currentYear-1, 12, 15));
                set_date.add(date.newinstance(currentYear, currentMonth-1, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }else if(currentMonth == 1){
                //set_date.add((currentYear-1)+','+'12');
                //set_date.add((currentYear-1)+','+'11');
                //set_date.add(currentYear+','+currentMonth);
                set_date.add(date.newinstance(currentYear-1, 12, 15));
                set_date.add(date.newinstance(currentYear-1, 11, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }else{
                //set_date.add(currentYear+','+(currentYear-2));
                //set_date.add(currentYear+','+(currentYear-1));
                //set_date.add(currentYear+','+currentMonth);
                set_date.add(date.newinstance(currentYear, currentMonth-2, 15));
                set_date.add(date.newinstance(currentYear, currentMonth-1, 15));
                set_date.add(date.newinstance(currentYear, currentMonth, 15));
            }
        }
        
        String DateStr = '';
        if(currentMonth <= 6){
            for(Integer i=currentMonth+1;i<=currentMonth+6;i++){
                //set_date.add(currentYear+','+i);
                set_date.add(date.newinstance(currentYear, i, 15));
            }
        }else if(currentMonth > 6 && currentMonth != 12){
            for(Integer i=currentMonth+1;i<=12;i++){
                //set_date.add(currentYear+','+i);
                set_date.add(date.newinstance(currentYear, i, 15));
            }
            
            for(Integer i=1;i<=6-(12-currentMonth);i++){
                //set_date.add(currentYear+1+','+i);
                set_date.add(date.newinstance(currentYear+1, i, 15));
            }
        }else if(currentMonth == 12){
            for(Integer i=1;i<=6-(12-currentMonth);i++){
                //set_date.add(currentYear+1+','+i);
                set_date.add(date.newinstance(currentYear+1, i, 15));
            }
        }
        */
        // add lili end 
        //ClsFinancialFCBatchUtil.setDate(index,currentYear,currentMonth,set_date);
        //system.debug('set_date==='+ set_date);
        //String filterStr = '';
        // add lili 2013.11.19 begin
        //if(set_date.size() > 0) {
            //for(Date fisDate :set_date){
                //String sDate = String.valueOf(fisDate);
                //filterStr += (sDate + ',');
            //}
        //}
        /*
        for(Date fisDate :set_date){
            filterStr += fisDate+',';   
        }    
        */
        //if(filterStr != ''){                        
            //filterStr = filterStr.substring(0,filterStr.length()-1);
            //filter = ' where Fiscal_Date__c IN (' + filterStr + ') ';
            // filter = ' where id = \'a2hL000000007IzIAI\' and Fiscal_Date__c IN (' + filterStr + ') ';           
        //}
        
        
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
    	startDate = Date.newinstance(Integer.valueOf(currentYear), Integer.valueOf(currentMonth), 15);
        endDate = startDate.addMonths(PREVIOUSMONTH);
        
        if(startDate != null && endDate != null) {
        	filter = 'Fiscal_Date__c >= ' + startDate + ' And Fiscal_Date__c <= ' + endDate;
        	filter = filter.replaceAll(' 00:00:00', '');
        }
        if(query == null || query.trim() == ''){
            query = 'Select Id,Fiscal_Date__c,Forecast_USD__c, Previous_Month_Forecast_Document__c, Last_Frozen_Month_Date__c,Forecast_Begin_of_Quarter_Document__c,Fiscal_Year__c,Fiscal_Month__c, Forecast_End_of_Previous_Quarter_Documen__c';
        	for (Integer i = 2; i<= 6; i++) {
        		query += ', Forecast_' + i + '_Months_Document__c';
        		//Forecast_2_Months_Document__c,Forecast_3_Months_Document__c,Forecast_4_Months_Document__c,Forecast_5_Months_Document__c,Forecast_6_Months_Document__c,
        	}
        	query += ' From Manager_Forecast__c';
        }
        if(filter != null && filter.trim() != ''){
            query += ' where ' + filter;
        }
        query += ' And Forecast_USD__c != null ';
        query += ' order by Fiscal_Date__c asc';
        /**if(str_limit != '') {
            query += str_limit;
        }**/
        system.debug('query:' +query );      
        return Database.getQueryLocator(query);

    }
    
    global void execute(Database.BatchableContext BC, List<Manager_Forecast__c> list_mgForecasts){
        // add lili 2013.11.19 begin
        /*
        Date quarterLastDate = list_mgForecasts[0].Last_Frozen_Month_Date__c;

        for(Manager_Forecast__c mgForecast : list_mgForecasts){
            Integer year = Integer.valueOf(mgForecast.Fiscal_Year__c);
            Integer month = Integer.valueOf(mgForecast.Fiscal_Month__c);
            
            if((currentYear -year == 1)){
                if(index-6 == 3 && (currentMonth == 2 || currentMonth == 1)){
                    if(quarterLastDate < Date.today()){
                        mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                    }
                }else if(index - 6 == 2){
                    if(quarterLastDate < Date.today()){
                        mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                    }
                }
                
            }else if(currentYear == year){
                if((month - currentMonth == -2 || month - currentMonth == -1 || month == currentMonth)  && index-6 == 3){
                    if(quarterLastDate < Date.today()){
                        mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                    }
                }
                if((month - currentMonth == -1 || month == currentMonth)  && index-6 == 2){
                    if(quarterLastDate < Date.today()){
                        mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                    }
                }
                
                
                if(month - currentMonth == 1){
                    if(index-6 == 2 || index-6 == 1){
                        if(quarterLastDate < Date.today()){
                            mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                        }
                    }
                    
                    mgForecast.Previous_Month_Forecast_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 2){
                    if(index-6 == 1){
                        if(quarterLastDate < Date.today()){
                            mgForecast.Forecast_Begin_of_Quarter_Document__c = mgForecast.Forecast_USD__c;
                        }
                    }
                    
                    mgForecast.Forecast_2_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 3){
                    mgForecast.Forecast_3_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 4){
                    mgForecast.Forecast_4_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 5){
                    mgForecast.Forecast_5_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(month - currentMonth == 6){
                    mgForecast.Forecast_6_Months_Document__c = mgForecast.Forecast_USD__c;
                }
            }else if(year - currentYear == 1){
                if(currentMonth - month == 11){
                    mgForecast.Previous_Month_Forecast_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 10){
                    mgForecast.Forecast_2_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 9){
                    mgForecast.Forecast_3_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 8){
                    mgForecast.Forecast_4_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 7){
                    mgForecast.Forecast_5_Months_Document__c = mgForecast.Forecast_USD__c;
                }else if(currentMonth - month == 6){
                    mgForecast.Forecast_6_Months_Document__c = mgForecast.Forecast_USD__c;
                }
            }
        }
        */
        // add lili 2013.11.19 end
        //ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, index, currentYear, currentMonth);
        ClsFinancialFCBatchUtil.setManagerForecast(list_mgForecasts, startDate, isQuarterStart, isQuarterEnd);
        if(!list_mgForecasts.isEmpty()) {
	        update list_mgForecasts;
        }
    }
    
    global void finish(Database.BatchableContext BC){ 
        
    }
}