/**
*  This batch class to create capture result when a opportunity part is converted.
*
@author Yimin Zheng
@created 2016-01-21
*
@changelog
coverage

2016-01-21 Yimin Zheng<yimin.zheng@te.com>
* - Created


 * @changelog
 * 2016-04-18 Mingxing Qiu  <mingxing.qiu@oinio.com>
 * - Created 
*/
global class ClsBatch_captureBillingWhenPartConverted implements Database.Batchable<SObject>{
  
	String queryStr;

	global ClsBatch_captureBillingWhenPartConverted(){
    	queryStr = 'select id,Opportunity__c,Part__c,APL_need_to_capture_billing__c,APL_need_to_delete_captured_billing__c,Initial_12_months__c,Won_Date__c,Opportunity__r.Level__c from Opportunity_Part__c where Opportunity__r.isAPLOpp__c =true And (APL_need_to_capture_billing__c = true or APL_need_to_delete_captured_billing__c = true) ';
  	}
  
  	global Database.QueryLocator start(Database.BatchableContext BC){
    	return database.getQueryLocator(queryStr);
  	}
  
  	global void execute(Database.BatchableContext BC, list<Opportunity_Part__c> oppPartList){
    
	    Set<Id> createOppIdSet = new Set<Id>();
	    Set<Id> createPartIdSet = new Set<Id>();
	    Set<Id> deleteOppIdSet = new Set<Id>();
	    Set<Id> deletePartIdSet = new Set<Id>();
	    list<Period>  list_period = new list<Period>();
	    list<Opportunity_Part__c> list_updateOppyPart =new list<Opportunity_Part__c>();
	 	list<Opportunity_Part__c> list_updateOppyPart2 =new list<Opportunity_Part__c>();
	    list<Opportunity_Forecast__c> list_forecast = new list<Opportunity_Forecast__c>();
	   	map<Opportunity_Part__c,Date> map_oppypart_date = new map<Opportunity_Part__c,Date>();
	    map<Id,String> map_oppypartId_level = new map<Id,String>();  
	    //the key is accountid;partid, the value is the list of opp id
	    Map<String,Set<Id>> oppIdMap = new Map<String,Set<Id>>();
	    //the key is opportunity id, use these two maps to define a relationship between part and partner
	    Map<Id,List<Opportunity_Part__c>> oppPartMap = new Map<Id,List<Opportunity_Part__c>>();
	    Map<Id,List<Opportunity_Partner__c>> oppPartnerMap = new Map<Id,List<Opportunity_Partner__c>>();
	    
	    List<Opportunity_Part__c> finalUpdateList = new List<Opportunity_Part__c>();
    
    	for(Opportunity_Part__c oppPart : oppPartList){
    		//capture_billing  is true 
    	
    		system.debug('allOppPart:::'+oppPart.Id);
      		if(oppPart.APL_need_to_capture_billing__c == true){
		      	oppPart.APL_need_to_capture_billing__c = false;
		      	list_updateOppyPart2.add(oppPart);
		        createOppIdSet.add(oppPart.Opportunity__c);
		        createPartIdSet.add(oppPart.Part__c);
	        
	        
	        	if(oppPartMap.get(oppPart.Opportunity__c) == null){
		          	List<Opportunity_Part__c> tmpList = new List<Opportunity_Part__c>();
		          	tmpList.add(oppPart);
		          	oppPartMap.put(oppPart.Opportunity__c,tmpList);
	        	}else{
	          		oppPartMap.get(oppPart.Opportunity__c).add(oppPart);
	        	}
		       	// delete captured billing is true
			}else if(oppPart.APL_need_to_delete_captured_billing__c == true){
	       		oppPart.APL_need_to_delete_captured_billing__c = false;
	       		list_updateOppyPart2.add(oppPart);
	       		deleteOppIdSet.add(oppPart.Opportunity__c);
	       		deletePartIdSet.add(oppPart.Part__c);
	      	} 
       		//Calculate the total 12 months forecast 
	      	if(oppPart.Initial_12_months__c == null) {
	          	map_oppypart_date.put(oppPart,oppPart.Won_Date__c);
	          	map_oppypartId_level.put(oppPart.Id, oppPart.Opportunity__r.Level__c);
	      	}
	      	finalUpdateList.add(oppPart);
	    }
    
	    //deal with the APL_need_to_capture_billing__c records
	    if(createOppIdSet.size() > 0){
	      	//set to hold the partner Account Id
	      	Set<Id> accIdSet = new Set<Id>();
	      	List<APL_Billing_Result_of_Covnerted_Opp__c> insertConvertedList = new List<APL_Billing_Result_of_Covnerted_Opp__c>();
	      	//query the opportunity partners
	      	List<Opportunity_Partner__c> partnerList = [select id,Account__c,Opportunity__c from Opportunity_Partner__c where Opportunity__c in: createOppIdSet And isAPLOpp__c = true];
	    				
	      	for(Opportunity_Partner__c partner : partnerList){
        		accIdSet.add(partner.Account__c);
        
		        if(oppPartnerMap.get(partner.Opportunity__c) == null){
					List<Opportunity_Partner__c> tmpList = new List<Opportunity_Partner__c>();
		          	tmpList.add(partner);
		          	oppPartnerMap.put(partner.Opportunity__c,tmpList);
		        }else{
		          	oppPartnerMap.get(partner.Opportunity__c).add(partner);
		        }
      		}
      
      		//merge oppPartnerMap and oppPartMap to oppIdMap
      		for(Id oppId : createOppIdSet){
        		List<Opportunity_Partner__c> partnerTmpList = oppPartnerMap.get(oppId);
        		List<Opportunity_Part__c> partTmpList = oppPartMap.get(oppId);
        
        		for(Opportunity_Partner__c partner : partnerTmpList){
          			for(Opportunity_Part__c part : partTmpList){
            			if(oppIdMap.get(partner.Account__c+';'+part.Part__c) == null){
			              	Set<Id> tmpSet = new Set<Id>();
			              	tmpSet.add(oppId);
			              	oppIdMap.put(partner.Account__c+';'+part.Part__c,tmpSet);
            			}else{
              				oppIdMap.get(partner.Account__c+';'+part.Part__c).add(oppId);
            			}
          			}
        		}
      		}
       
      		//get the billing records by AccountId and PartId
      		//old Comment out by Lei Tang 2016-04-26
      		//List<BBB_Year_Bill_Book_Cust_PN__c> yearlyList = [select Id, Customer__c, Part__c from BBB_Year_Bill_Book_Cust_PN__c where Customer__c in: accIdSet and Part__c in: createPartIdSet]; 
      		//create the converted result
      		map<String, list<BBB_Year_Bill_Book_Cust_PN__c>> yearlymap = new map<String, list<BBB_Year_Bill_Book_Cust_PN__c>>();
      		for(BBB_Year_Bill_Book_Cust_PN__c yearlybb : [select Id, Customer__c, Part__c from BBB_Year_Bill_Book_Cust_PN__c 
      														where Customer__c in: accIdSet and Part__c in: createPartIdSet
      														and APL_need_to_capture_billing__c = false]) {
      			if(!yearlymap.containsKey(yearlybb.Customer__c+';'+yearlybb.Part__c)) {
      				yearlymap.put(yearlybb.Customer__c+';'+yearlybb.Part__c, new list<BBB_Year_Bill_Book_Cust_PN__c>());
      			} 
      			yearlymap.get(yearlybb.Customer__c+';'+yearlybb.Part__c).add(yearlybb);
      		} 
			system.debug('!@# oppIdMap :'+oppIdMap);
			system.debug('!@# yearlymap :'+yearlymap.keySet());
			set<String> set_hasAddedPP = new set<String>();
      		for(String key : oppIdMap.keySet()) {
  				Set<Id> oppIdSet = oppIdMap.get(key);
  				for(Id oppId : oppIdSet){
  					
	      			if(yearlymap.containsKey(key)) {
      					for(BBB_Year_Bill_Book_Cust_PN__c bb : yearlymap.get(key)) {
		          			APL_Billing_Result_of_Covnerted_Opp__c convert = new APL_Billing_Result_of_Covnerted_Opp__c();
		          			convert.opportunity__c = oppId;
		          			convert.part__c = bb.Part__c;
		          			convert.Opportunity_Partner__c = bb.Customer__c;
		          			convert.Yearly_Booking_Billings_By_Part__c = bb.Id;
		          			insertConvertedList.add(convert);
	    				}
      				}else {
      					List<Opportunity_Partner__c> list_oppyPartner = oppPartnerMap.get(oppId);
					    List<Opportunity_Part__c> list_oppyPart = oppPartMap.get(oppId);
						
					    for(Opportunity_Partner__c partner : list_oppyPartner){
					     	for(Opportunity_Part__c part : list_oppyPart){
					     		if(!yearlymap.containsKey(partner.Account__c+';'+part.Part__c) && !set_hasAddedPP.contains(partner.Account__c+';'+part.Part__c)) {
					     			APL_Billing_Result_of_Covnerted_Opp__c APL_billing = new APL_Billing_Result_of_Covnerted_Opp__c();
						     		APL_billing.opportunity__c = oppId;
							 		APL_billing.part__c = part.Part__c;
							 		APL_billing.Opportunity_Partner__c = partner.Account__c;
							 		 
							 		insertConvertedList.add(APL_billing);
							 		set_hasAddedPP.add(partner.Account__c+';'+part.Part__c);
					     		}
		      					
					     	}
					    }
      				}
      			}
      		}
      		
      		
      		/*
      		if(yearlyList.size() > 0){
      			System.debug('yearlyList :: ' + yearlyList  );
  				for(BBB_Year_Bill_Book_Cust_PN__c bb : yearlyList){
	        		Set<Id> oppIdSet = oppIdMap.get(bb.Customer__c+';'+bb.Part__c);
	        		for(Id oppId : oppIdSet){
	          			APL_Billing_Result_of_Covnerted_Opp__c convert = new APL_Billing_Result_of_Covnerted_Opp__c();
	          			convert.opportunity__c = oppId;
	          			convert.part__c = bb.Part__c;
	          			convert.Opportunity_Partner__c = bb.Customer__c;
	          			convert.Yearly_Booking_Billings_By_Part__c = bb.Id;
	          			insertConvertedList.add(convert);
    				}
  				} 
      		}else {  //Update by Mingxing Qiu time is 2016-04-11
      			//Create the APL billing when Not found year bill book 
				for(Id oppId : createOppIdSet){
					List<Opportunity_Partner__c> list_oppyPartner = oppPartnerMap.get(oppId);
				    List<Opportunity_Part__c> list_oppyPart = oppPartMap.get(oppId);
		
				    for(Opportunity_Partner__c partner : list_oppyPartner){
				     	for(Opportunity_Part__c part : list_oppyPart){
				     		APL_Billing_Result_of_Covnerted_Opp__c APL_billing = new APL_Billing_Result_of_Covnerted_Opp__c();
				     		APL_billing.opportunity__c = oppId;
					 		APL_billing.part__c = part.Part__c;
					 		APL_billing.Opportunity_Partner__c = partner.Account__c;
					 		
					 		insertConvertedList.add(APL_billing);
				      	} 
					}
				}
			}
	      	*/
	      	if(insertConvertedList.size() > 0){
	      		insert insertConvertedList;
			}    
       
	    }
	    
	    //deal with the APL_need_to_delete_captured_billing__c records
		if(deleteOppIdSet.size() > 0){
			//get the converted records by opportunityId and PartId
	    	set<Opportunity_Part__c> set_updatOppyPart = new set<Opportunity_Part__c>();
	    	List<APL_Billing_Result_of_Covnerted_Opp__c> convertedList = [select Id, opportunity__c, Part__c from APL_Billing_Result_of_Covnerted_Opp__c where opportunity__c in: deleteOppIdSet and Part__c in: deletePartIdSet];
	    	for(APL_Billing_Result_of_Covnerted_Opp__c APL_billing : convertedList) {
	      		String str_oppyIdPartId = APL_billing.opportunity__c +':'+ APL_billing.Part__c;
	      		for(Opportunity_Part__c oppPart : oppPartList) {
	      			String str_oppyIdPartId2 = oppPart.opportunity__c+':'+ oppPart.Part__c;
	      			if(str_oppyIdPartId == str_oppyIdPartId2) {
	      				system.debug('Opportunity_Part__c.opportunity__c ::' + oppPart.opportunity__c);
	      				system.debug('Opportunity_Part__c.Part__c ::' + oppPart.Part__c);
	      				oppPart.Initial_12_months__c = null;
	      				system.debug('oppPartId ::' + oppPart.Id);
	      				set_updatOppyPart.add(oppPart);
	      			}
				}	
	      	}
			if(convertedList.size() > 0){
				delete convertedList;
			}
	      	if(set_updatOppyPart.size() > 0){
	      		list<Opportunity_Part__c> list_updatOppyPart = new list<Opportunity_Part__c>(set_updatOppyPart); 
	      		update list_updatOppyPart;
			}
		}
    
     	//Calculate the total 12 months forecast
		if(map_oppypart_date.size() > 0){
   			date minDate = null;
    		integer flagDate = 1; 

	        //Find a minimum of time to find Period and find oppyFore
	        for( Opportunity_Part__c oppyPart : map_oppypart_date.keySet()) {
	            if(flagDate == 1){
	                minDate = oppyPart.Won_Date__c;
	                flagDate++;
	            }
	            if(oppyPart.Won_Date__c <= minDate ){
	               minDate =  oppyPart.Won_Date__c ;
	            }
	        }
        
	        //find  all Opportunity Forecast group by date 
	        for(Opportunity_Forecast__c oppyFore : [Select Id,Fiscal_Year__c ,Fiscal_Quarter__c,Fiscal_Month__c,Quantity__c,part__c,Date__c, Amount__c From Opportunity_Forecast__c where part__c in: map_oppypartId_level.keySet() and Date__c > = : minDate order by Date__c]){
	              list_forecast.add(oppyFore);    
	        }
	        
	        //find Period
	        for(Period  per : [Select Number, Id, StartDate, Type From Period Where type = 'Quarter' And StartDate > = : minDate order by StartDate]){
	            list_period.add(per);
	        }
	        //Looking for the next four quarters forecast
	        for(Opportunity_Part__c oppyPart : map_oppypart_date.keySet()) { 
	            //When opprotuntiy forecasting Level  is Quarterly or Yearly
	           if(map_oppypartId_level.get(oppyPart.Id) == 'Quarterly' || map_oppypartId_level.get(oppyPart.Id) == 'Yearly') {
	               Decimal totalQuantity = 0.0; 
	               Integer flag = 0;
	               for(Opportunity_Forecast__c oppyForecast : list_forecast) {
	                    if(flag==4) break;
	                    if(oppyForecast.part__c == oppyPart.Id && oppyForecast.Date__c > oppyPart.Won_Date__c) {
	                        totalQuantity += oppyForecast.Amount__c;
	                        System.debug('totalQuantity :: '+ totalQuantity);
	                       	flag++;
	                    }                           
	               }
	               oppyPart.Initial_12_months__c = totalQuantity;
	               list_updateOppyPart.add(oppyPart); 
	            }  
	            //When opprotuntiy forecasting Level  is Monthly         
				else if(map_oppypartId_level.get(oppyPart.Id) == 'Monthly') {
	               Decimal totalQuantity = 0.0;
	               Integer flag = 0;
	               Integer flagper = 0;
	               date start = null;
	               for(Opportunity_Forecast__c oppyForecast : list_forecast) {
	                   for(Period peri : list_period){
	                       if(peri.StartDate >= oppyPart.Won_Date__c && flagper == 0){
	                           start = peri.StartDate;
	                           flagper++;
	                       }                    
	                    }
	                    if(flag==12) break;
	                        if(oppyForecast.part__c == oppyPart.Id && oppyForecast.Date__c > start) {
	                            totalQuantity += oppyForecast.Amount__c;
	                            flag++;
	                    }      
	                } 
	               oppyPart.Initial_12_months__c = totalQuantity;
	               list_updateOppyPart.add(oppyPart); 
	           }             
	        }
	    }
	    // update opportunity part initial 12 months filed
	    if(list_updateOppyPart.size() > 0){
            update list_updateOppyPart;
    	}
    
    	// update opportunity part flag 
		if(list_updateOppyPart2.size() > 0){
            update list_updateOppyPart2;
    	}
    
	}

  
	global void finish(Database.BatchableContext BC){ 
        
    }
    
}