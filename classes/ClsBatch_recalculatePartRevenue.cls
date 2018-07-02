/**
 *  A batch job to ReCalculate Revenues on opportunity part. 
 *  
 * @author Min Liu
 * @created 2012-11-26
 * @version 1.0
 * @since 26.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2012-11-26 Min Liu <min.liu@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_recalculatePartRevenue implements Database.Batchable<SObject>,Database.Stateful {
    /**
     * the email address to tell people the status of the batch class after run the batch class
     * before run the batch class, we can define the email manual
     * if not define email address, after the batch completed, will not send email
     */
    public String email;
    /**
     * the sql query statement that will select the data will be used in this batch class
     */     
    public String query; 
     
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if (query == '' || query == null){
            //query = 'SELECT Quantity__c, Sales_Price__c, CurrencyIsoCode, Fiscal_Quarter__c, Fiscal_Year__c, Opportunity__r.closeDate, Part__c FROM Opportunity_Forecast__c where Part__c != null';// and Opportunity__c=\'006L0000002GBsb\' ';
        	query = 'SELECT Id From Opportunity_Part__c where Opportunity__r.Name != null' ;
        }
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, list<Opportunity_Part__c> scope){
        Map<Id, List<Opportunity_Forecast__c>> map_partId_forecasts = new Map<Id, List<Opportunity_Forecast__c>>();
        Map<Id, Map<String, String>> map_partId_fiscalYear_order = new Map<Id, Map<String, String>>();
        //List<Opportunity_Part__c> list_part2Update = new List<Opportunity_Part__c>();
        map<Id,Opportunity_Part__c> map_partId_part = new map<Id,Opportunity_Part__c>();
        ClsOppyForecastUtil.generateRevenueMap();
        for(Opportunity_Part__c part: scope){
        	map_partId_part.put(part.Id,part);	
        }
        
        
        for(Opportunity_Forecast__c fc :[SELECT Quantity__c, Sales_Price__c, CurrencyIsoCode, Fiscal_Quarter__c, Fiscal_Year__c, Opportunity__r.closeDate,Opportunity__r.Manufacturing_Start_Date__c, Part__c, Part__r.CurrencyIsoCode FROM Opportunity_Forecast__c where Part__c in: map_partId_part.keySet()]){
			// get close date
			if(!map_partId_forecasts.containsKey(fc.Part__c)) {
				map_partId_forecasts.put(fc.Part__c, new List<Opportunity_Forecast__c>());
			}
			String oppyYear = ClsOppyUtil.getForecastYear(fc.Opportunity__r.Manufacturing_Start_Date__c);
			if(oppyYear != '') {
				map_partId_forecasts.get(fc.Part__c).add(fc);
				if(!map_partId_fiscalYear_order.containsKey(fc.Part__c)) {
					map_partId_fiscalYear_order.put(fc.Part__c, new Map<String, String>());
					for(Integer i = 0; i < 10; i++){
			            String y = String.valueOf(Integer.valueOf(oppyYear) + i);
			            map_partId_fiscalYear_order.get(fc.Part__c).put(y , String.valueOf(i + 1));
			        }
				}				
			}
        }
        
        if(!map_partId_forecasts.isEmpty()){
        	for(Id pId :map_partId_part.keySet()){
	        	// clear revenues
	        	Opportunity_Part__c part = map_partId_part.get(pId);
	        	for(Integer i = 1; i <= 10; i++){                
	                part.put('FCSTYR'+ i +'QTY__c', 0);
	                part.put('FCSTYR'+ i +'AMT__c', 0);
	                part.put('FC_FY'+ i +'_PRICE__c', 0);
	                part.put('YRLYFCSTYR'+ i +'__c', null);
	                integer y = i - 3;
	                if(y < 0){
						part.put('Current_Year_minus_' + y*(-1) + '__c',0);
						part.put('Current_Year_minus_' + y*(-1) + '_QTY__c',0);
                    	part.put('Current_Year_minus_' + y*(-1) + '_PRICE__c',0);
					}else if(y > 0){
						part.put('Current_Year_add_' + y + '__c',0);
						part.put('Current_Year_add_' + y + '_QTY__c',0);
						part.put('Current_Year_add_' + y + '_PRICE__c',0);
					}else{
						part.put('Current_Year__c', 0);
						part.put('Current_Year_QTY__c', 0);
						part.put('Current_Year_PRICE__c', 0);
					}
	                
	            }
	            
	            // calculate revenues
	            if(map_partId_forecasts.containsKey(pId)){
		            for(Opportunity_Forecast__c fc :map_partId_forecasts.get(pId)){
		            	if(fc.Fiscal_Year__c != null){
		            		if(map_partId_fiscalYear_order.containsKey(pId) && map_partId_fiscalYear_order.get(pId).containsKey(fc.Fiscal_Year__c)){
		            			String tmpOrder = map_partId_fiscalYear_order.get(pId).get(fc.Fiscal_Year__c);
								part.put('YRLYFCSTYR' + tmpOrder + '__c', fc.Fiscal_Year__c);						
								if(fc.Quantity__c != null && fc.Quantity__c > 0){
				                    Decimal qty = (Decimal) part.get('FCSTYR' + tmpOrder + 'QTY__c');
				                    qty += fc.Quantity__c;
				                    part.put('FCSTYR' + tmpOrder + 'QTY__c', qty);
				                    if(fc.Sales_Price__c != null) {
				                        Decimal p = fc.Part__r.CurrencyIsoCode != 'USD'? ClsOppyForecastUtil.transformIsoCode(fc.Sales_Price__c, fc.Part__r.CurrencyIsoCode, 'USD'):fc.Sales_Price__c;
				                        part.put('FC_FY' + tmpOrder + '_PRICE__c', p);
				                        Decimal amount = (Decimal) part.get('FCSTYR' + tmpOrder + 'AMT__c');
				                        amount += fc.Quantity__c * p;
				                        part.put('FCSTYR' + tmpOrder + 'AMT__c', amount);		                    	
				                    }
				                }
		            		}
		            		// Revenue FY
		            		if(fc.Quantity__c != null && fc.Quantity__c > 0 && fc.Sales_Price__c != null){
		                    	if(ClsOppyForecastUtil.map_year_revApi.containsKey(fc.Fiscal_Year__c)){
		                    		Decimal quantity = (Decimal)part.get(ClsOppyForecastUtil.map_year_QTYApi.get(fc.Fiscal_Year__c));
	                                quantity += fc.Quantity__c;
	                                part.put(ClsOppyForecastUtil.map_year_QTYApi.get(fc.Fiscal_Year__c), quantity);
	                                
	                                if(fc.Sales_Price__c != 0){
		                                Decimal salesprice = ClsOppyForecastUtil.transformIsoCode(fc.Sales_Price__c, fc.Part__r.CurrencyIsoCode, 'USD');
		                                part.put(ClsOppyForecastUtil.map_year_PRICEApi.get(fc.Fiscal_Year__c), salesprice);
	                                }
	                                
		                    		Decimal revenue = (Decimal) part.get(ClsOppyForecastUtil.map_year_revApi.get(fc.Fiscal_Year__c));
			                    	revenue += fc.Quantity__c * ClsOppyUtil.transformIsoCode(fc.Sales_Price__c, fc.Part__r.CurrencyIsoCode, 'USD');
			                    	part.put(ClsOppyForecastUtil.map_year_revApi.get(fc.Fiscal_Year__c), revenue);
		                    	}		                    	
			                }   
		            	}	            		            	
		            }
	            }
	            //list_part2Update.add(part);
	            
        	}
        	APL_One_Time_Execution.batchRun = true;
        	if(!map_partId_part.isEmpty()) update map_partId_part.values();			
        }                
    }

    global void finish(Database.BatchableContext BC){       
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(email != null) {           
            mail.setToAddresses(new String[] {email});           
        } 
        else{
            User currentUser = [Select email from User where id = :UserInfo.getUserId() limit 1];
            mail.setToAddresses(new String[] {currentUser.email});            
        }
        mail.setReplyTo(Email);
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Batch Processing ClsBatch_recalculatePartRevenue Completed');
        mail.setPlainTextBody('Batch Processing ClsBatch_recalculatePartRevenue has completed');
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        // calculate oppy revenue
        //ClsBatch_recalculateOppyRevenue cls = new ClsBatch_recalculateOppyRevenue();
        //DataBase.ExecuteBatch(cls);
        //added by weihang 2013-05-28 begin 
        ClsBatch_recalculateOppyRevenue OppyBatch = new ClsBatch_recalculateOppyRevenue();
        Database.executeBatch(OppyBatch) ;
        //added by weihang 2013-05-28 end 
    } 
}