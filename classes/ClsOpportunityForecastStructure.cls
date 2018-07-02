/**
*	structure class
*
@author Bin Yu
@created 2012-03-01
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2012-03-01 Bin Yu <bin.yu@itbconsult.com>
* - Created
*/

public class ClsOpportunityForecastStructure { 
   
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	public Id oppyId {get; set;}
	public String year {get; set;}
	public String yearLabel {get; set;}
	public String level {get; set;}
	public List<ForecastStructure> partForecasts {get; set;}  
	public ForecastStructure forecastStructure {get; set;}
	public Id forecastOppyRecordTypeId {get; set;}	
	public Id forecastPartRecordTypeId {get; set;}
	public Boolean isDeleted {get; set;}
	
	public String opportunityIsoCode; //added 2012/3/26	
	public map<Id, String> map_oppyPartId_isoCode ; //added 2012/3/26		
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	
    public ClsOpportunityForecastStructure(map<Id, String> map_oppyPartId_isoCode, String opportunityIsocode, List<Opportunity_Forecast__c> oppyForecasts, Map<Id, List<Opportunity_Forecast__c>> partFCs, String year, Id oppyId, Map<Id, Id> map_partId_oppyId, Id forecastOppyRecordTypeId, Id forecastPartRecordTypeId, String level, List<Id> list_partIds) {  	
    	this.opportunityIsoCode = opportunityIsocode;
    	this.map_oppyPartId_isoCode = map_oppyPartId_isoCode;   	
    	this.year = year;
    	this.yearLabel = 'FY '+year;
    	this.oppyId = oppyId;
    	this.level = level;
    	this.forecastOppyRecordTypeId = forecastOppyRecordTypeId;
    	this.forecastPartRecordTypeId = forecastPartRecordTypeId;
    	this.partForecasts = new List<ForecastStructure>(); 
    	isDeleted = false;
  	    forecastStructure = new ForecastStructure(null, opportunityIsocode, oppyForecasts, oppyId, null, year, forecastOppyRecordTypeId, level); 
  	    for(Id partId :list_partIds){
  	    	if(partFCs.containsKey(partId)){
	  	    	List<Opportunity_Forecast__c> list_tmp = partFCs.get(partId);
	  	    	ForecastStructure fc = new ForecastStructure(map_oppyPartId_isoCode.get(partId), opportunityIsoCode, list_tmp, map_partId_oppyId.get(partId), partId, year, forecastPartRecordTypeId, level);
	  	    	partForecasts.add(fc);
  	    	}  	    	
  	    }		    	
    } 
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************	
	public class ForecastStructure{
		public Id oppyId {get; set;}
		public Id partId {get; set;}
		public Id recordTypeId {get; set;}
		public String year {get; set;}
		public String type {get; set;}
		public String level {get; set;}
		public Opportunity_Forecast__c salesPriceOF;
		public List<ForecastItemStructure> list_editForecasts;
		
		public String partCurrencyIsoCode;
		public String opportunityIsoCode;
		
		public ForecastStructure(String partCurrencyIsoCode, String opportunityIsoCode, List<Opportunity_Forecast__c> oppyForecasts, Id oppyId, Id partId, String year, Id recordTypeId, String level){
			this.partCurrencyIsoCode = partCurrencyIsoCode;
			if(partCurrencyIsoCode == null){
				this.partCurrencyIsoCode = opportunityIsoCode;
			}
			ClsOppyUtil.getAllFiscalQuarter();
			//system.debug('Limits.getScriptStatements() :' + Limits.getScriptStatements() ); 
			this.opportunityIsoCode = opportunityIsoCode;
			this.oppyId = oppyId;
			this.partId = partId;
			this.year = year;
			this.recordTypeId = recordTypeId;
			this.level = level;
			list_editForecasts = new List<ForecastItemStructure>();
			salesPriceOF = new Opportunity_Forecast__c();
	    	map<String, Opportunity_Forecast__c> map_ofcs = new map<String, Opportunity_Forecast__c>();
	    	for(Opportunity_Forecast__c ofc : oppyForecasts){ 
	    		String key;
	    		if(level == ClsOppyUtil.MONTHLY){
	    			key = ClsOppyUtil.getForecastMonth(ofc.Date__c);
	    		}
	    		else{
	    			key = ClsOppyUtil.getForecastQuarter(ofc.Date__c);
	    		}
	    		map_ofcs.put(key, ofc);
				salesPriceOF.Sales_Price__c = ofc.Sales_Price__c;
				if(partCurrencyIsoCode != opportunityIsoCode){
					salesPriceOF.Sales_Price__c = ClsOppyUtil.transformIsoCode(ofc.Sales_Price__c, partCurrencyIsoCode, opportunityIsoCode);
				}
				if(salesPriceOF.Sales_Price__c != null) salesPriceOF.Sales_Price__c = salesPriceOF.Sales_Price__c.setScale(2);	    				
	    	} 		    	
	    	buildFCStructure(oppyForecasts, map_ofcs, level);	
		} 	
    	//******************************************************************
    	// START: get the forecast to edit
    	//******************************************************************
    	public List<ForecastItemStructure> getEditForecasts(){ 		
    		return list_editForecasts;
    	}
    	//******************************************************************
    	// END: get the forecast to edit
    	//******************************************************************  
    	
    	public Opportunity_Forecast__c getSalesPriceOF(){   		
			salesPriceOF.Amount__c = 0;
			salesPriceOF.Quantity__c = 0;    		
			for(ForecastItemStructure fcs :list_editForecasts){
				if(fcs.forecast.Quantity__c != null) salesPriceOF.Quantity__c += fcs.forecast.Quantity__c;
				if(fcs.forecast.Amount__c != null) salesPriceOF.Amount__c += fcs.forecast.Amount__c;
				if(salesPriceOF.CurrencyIsoCode == null) salesPriceOF.CurrencyIsoCode = partCurrencyIsoCode;
			}  
			return salesPriceOF;  	
    	}
    	//******************************************************************
    	// START: build the list of month
    	//******************************************************************		
		public void buildFCStructure(List<Opportunity_Forecast__c> oppyForecasts, map<String, Opportunity_Forecast__c> map_ofcs, String level){
			//system.debug('Limits.getScriptStatements() :' + Limits.getScriptStatements() ); 
			if(level == ClsOppyUtil.MONTHLY){
				buildMonthStructure(oppyForecasts, map_ofcs, list_editForecasts);				
			}
			else if(level == ClsOppyUtil.QUARTERLY){
				buildQuarterStructure(oppyForecasts, map_ofcs, list_editForecasts);				
			}	
			else{
				buildYearStructure(oppyForecasts, list_editForecasts);				
			}	
			//system.debug('Limits.getScriptStatements() :' + Limits.getScriptStatements() ); 	
		}
    	//******************************************************************
    	// END: build the list of month
    	//******************************************************************  	
    	    	
    	//******************************************************************
    	// START: build the list of month
    	//******************************************************************		
		public void buildMonthStructure(List<Opportunity_Forecast__c> oppyForecasts, map<String, Opportunity_Forecast__c> map_ofcs, List<ForecastItemStructure> list_fcs){
			for(Integer i = 1; i<=12; i++){
				String monthVal = ClsOppyUtil.MAP_MONTH.get(i);	
				ForecastItemStructure fcs = new ForecastItemStructure(ClsOppyUtil.MONTHLY, partId, oppyId, recordTypeId);
				fcs.label = ClsOppyUtil.MAP_MONTHLABEL.get(monthVal);
				//put the forecast into the structure
				if(map_ofcs.containsKey(fcs.label)){
					fcs.forecast = map_ofcs.get(fcs.label);
					if(partCurrencyIsoCode != opportunityIsoCode){
						fcs.forecast.Amount__c = ClsOppyUtil.transformIsoCode(fcs.forecast.Amount__c, partCurrencyIsoCode, opportunityIsoCode);
                    }
				}
				else{
					fcs.forecast.Opportunity__c = oppyId;
				}	
				fcs.forecast.Date__c = ClsOppyUtil.getFiscalMonthStartDate(year, monthVal);
				fcs.forecast.CurrencyIsoCode = partCurrencyIsoCode;								
				list_fcs.add(fcs);		
			}	
		}
    	//******************************************************************
    	// END: build the list of month
    	//******************************************************************  	

    	//******************************************************************
    	// START: build the list of quarter
    	//******************************************************************
    	public void buildQuarterStructure(List<Opportunity_Forecast__c> oppyForecasts, map<String, Opportunity_Forecast__c> map_ofcs, List<ForecastItemStructure> list_fcs){
			for(Integer i = 1; i<=4; i++){	
				ForecastItemStructure fcs = new ForecastItemStructure(ClsOppyUtil.QUARTERLY, partId, oppyId, recordTypeId);
				fcs.label = ClsOppyUtil.MAP_QUARTERLABEL.get(i);
				//put the forecast into the structure
				if(map_ofcs.containsKey(String.valueOf(i))){
					fcs.forecast = map_ofcs.get(String.valueOf(i));
					if(partCurrencyIsoCode != opportunityIsoCode){
						fcs.forecast.Amount__c = ClsOppyUtil.transformIsoCode( fcs.forecast.Amount__c, partCurrencyIsoCode, opportunityIsoCode);
                    }
				}
				else{
					fcs.forecast.Opportunity__c = oppyId;
				}	
				fcs.forecast.Date__c = ClsOppyUtil.getFiscalQuarterStartDate(year, String.valueOf(i));
				fcs.forecast.CurrencyIsoCode = partCurrencyIsoCode;								
				list_fcs.add(fcs);		
			}	
    	}
    	//******************************************************************
    	// END: build the list of quarter
    	//******************************************************************   
    	    	    	
    	//******************************************************************
    	// START: build the forecast of year by month/quarter
    	//******************************************************************
    	public void buildYearStructure(List<Opportunity_Forecast__c> oppyForecasts, List<ForecastItemStructure> list_fcs){  	
    		list_fcs.clear();	
			ForecastItemStructure fcs = new ForecastItemStructure(ClsOppyUtil.YEARLY, partId, oppyId, recordTypeId);
			fcs.label = 'year';    		
			for(Opportunity_Forecast__c fc : oppyForecasts){
				fcs.forecast.CurrencyIsoCode = partCurrencyIsoCode;	
				if(fc.Quantity__c != null){
					if(fcs.forecast.Quantity__c == null){
						fcs.forecast.Quantity__c = fc.Quantity__c;
					}
					else{
						fcs.forecast.Quantity__c += fc.Quantity__c;
					}
					if(fcs.forecast.Amount__c == null){
						fcs.forecast.Amount__c = fc.Amount__c;
					}
					else{
						if(partCurrencyIsoCode != opportunityIsoCode){
							fcs.forecast.Amount__c += ClsOppyUtil.transformIsoCode( fc.Amount__c, partCurrencyIsoCode, opportunityIsoCode);
	                    }
	                    else {
	                    	fcs.forecast.Amount__c += fc.Amount__c;
	                    }						
					}					
				}	
			}	
			list_fcs.add(fcs);		
    	}
    	//******************************************************************
    	// END: build the forecast of year by month/quarter
    	//******************************************************************    
    	
    	//******************************************************************
    	// START: build the list of month by quarter
    	//****************************************************************** 	 
	    public List<ForecastItemStructure> calMonthForecastByQurater(List<ForecastItemStructure> qfcs){ 
	    	List<ForecastItemStructure> mfcs = new List<ForecastItemStructure>();
	    	buildMonthStructure(new List<Opportunity_Forecast__c>{}, new map<String, Opportunity_Forecast__c>{}, mfcs);
	        Integer qCounter = 0;
	        for(ForecastItemStructure fis: qfcs){
	            // if quantity is not an integer then get its integer part.
	            Decimal totalRevenue = fis.forecast.Amount__c == null?0:fis.forecast.Amount__c;
	            Decimal q = fis.forecast.Quantity__c==null?0:fis.forecast.Quantity__c;          
	            Integer quantityVal = Integer.valueOf(q);
	            Integer quanVal = Math.round(q*4/13);
	            mfcs.get(qCounter * 3).forecast.Quantity__c = quanVal;
	            mfcs.get(qCounter * 3 + 2).forecast.Quantity__c = quanVal;
	            mfcs.get(qCounter * 3 + 1).forecast.Quantity__c = quantityVal - 2 * quanVal;  
	            if(q != 0){
	                mfcs.get(qCounter * 3).forecast.Amount__c = (totalRevenue * quanVal) /q ; 
	                mfcs.get(qCounter * 3 + 2).forecast.Amount__c = (totalRevenue * quanVal) /q ;     
	                mfcs.get(qCounter * 3 + 1).forecast.Amount__c = (totalRevenue * (quantityVal - 2 * quanVal)) /q ;                             
	            }                                                               
	            else{
	                mfcs.get(qCounter * 3).forecast.Amount__c = 0;    
	                mfcs.get(qCounter * 3 + 2).forecast.Amount__c = 0;        
	                mfcs.get(qCounter * 3 + 1).forecast.Amount__c = 0;            
	            }
	            qCounter++;
	        }
	        return mfcs;
	    }  
    	//******************************************************************
    	// END: build the list of month by quarter
    	//******************************************************************    	
    	    	    	
    	//******************************************************************
    	// START: build the forecast of year by month/quarter
    	//******************************************************************
    	public List<ForecastItemStructure> calYearStructure(List<ForecastItemStructure> mfcs){  	
	    	List<ForecastItemStructure> list_tmp = new List<ForecastItemStructure>();   		
			ForecastItemStructure fcs = new ForecastItemStructure(ClsOppyUtil.YEARLY, partId, oppyId, recordTypeId);
			fcs.label = 'year';    		
			for(Integer i = 0; i< mfcs.size(); i++){	
				if(mfcs.get(i).forecast != null && mfcs.get(i).forecast.Quantity__c != null){
					if(fcs.forecast.Quantity__c == null){
						fcs.forecast.Quantity__c = mfcs.get(i).forecast.Quantity__c;
					}
					else{
						fcs.forecast.Quantity__c += mfcs.get(i).forecast.Quantity__c;
					}
					if(fcs.forecast.Amount__c == null){
						fcs.forecast.Amount__c = mfcs.get(i).forecast.Amount__c;
					}
					else{
						fcs.forecast.Amount__c += mfcs.get(i).forecast.Amount__c;
					}					
				}	
			}
			list_tmp.add(fcs);
			return list_tmp;
    	}
    	//******************************************************************
    	// END: build the forecast of year by month/quarter
    	//****************************************************************** 
    	    	    	    	     	
    	//******************************************************************
    	// START: build the list of quarter by month
    	//******************************************************************  	  
	    public List<ForecastItemStructure> calQuarterForecastByMonth(List<ForecastItemStructure> mfcs){
	    	List<ForecastItemStructure> qfcs = new List<ForecastItemStructure>();
	    	//buildQuarterStructure(new List<Opportunity_Forecast__c>{}, new map<String, Opportunity_Forecast__c>{}, qfcs);
    		if(mfcs.size() > 0){
    			Integer qCounter = 0;
				for(Integer i = 0; i< mfcs.size(); i++){
					if(math.mod(i, 3) == 0){						
						ForecastItemStructure fcs = new ForecastItemStructure(ClsOppyUtil.QUARTERLY, partId, oppyId, recordTypeId);	
						qCounter++;
						fcs.label = ClsOppyUtil.MAP_QUARTERLABEL.get(qCounter);
						qfcs.add(fcs);
					}
					if(mfcs.get(i).forecast != null && mfcs.get(i).forecast.Quantity__c != null){
						if(qfcs.get(qCounter-1).forecast.Quantity__c == null){
							qfcs.get(qCounter-1).forecast.Quantity__c = mfcs.get(i).forecast.Quantity__c;
						}
						else{
							qfcs.get(qCounter-1).forecast.Quantity__c += mfcs.get(i).forecast.Quantity__c;
						}
						if(qfcs.get(qCounter-1).forecast.Amount__c == null){
							qfcs.get(qCounter-1).forecast.Amount__c = mfcs.get(i).forecast.Amount__c;
						}
						else{
							qfcs.get(qCounter-1).forecast.Amount__c += mfcs.get(i).forecast.Amount__c;
						}										
					}			
				}
    		}
    		return qfcs;
	    }   
    	//******************************************************************
    	// END: build the list of quarter by month
    	//******************************************************************  

    	//******************************************************************
    	// START: build the list of quarter by year
    	//******************************************************************
	    public List<ForecastItemStructure> calQuarterForecastByYear(ForecastItemStructure yfcs){	 
	    	List<ForecastItemStructure> qfcs = new List<ForecastItemStructure>();
	    	buildQuarterStructure(new List<Opportunity_Forecast__c>{}, new map<String, Opportunity_Forecast__c>{}, qfcs);   	
	        Decimal totalQuantity = yfcs.forecast.Quantity__c==null?0:yfcs.forecast.Quantity__c;
	        Decimal totalRevenue = yfcs.forecast.Amount__c==null?0:yfcs.forecast.Amount__c;
	        Integer quantityVal_q = (Integer) math.floor(totalQuantity);
	        Integer qCounter = 0;
	        
	        if(math.mod(quantityVal_q, 4) == 0){
	            for(ForecastItemStructure fcs: qfcs){
	            	fcs.forecast.Quantity__c = quantityVal_q / 4;            	
	            }       
	        }   
	        else{
	            // firstly transfer year quantity to quarter quantity
	            Integer quanVal_q = (Integer) math.floor(quantityVal_q / 4);
	            Integer counter = math.mod(quantityVal_q, 4);
	            
	            List<Integer> list_quanVal_q = new List<Integer>();
	            for(ForecastItemStructure fcs: qfcs){
	            	fcs.forecast.Quantity__c = quanVal_q;
	            } 	            

                for(Integer i = 0; i < counter; i++){
                    qfcs[i].forecast.Quantity__c += 1;
                }
	        }
	         
            for(ForecastItemStructure fcs: qfcs){
                if(totalQuantity != 0){
                    fcs.forecast.Amount__c = (totalRevenue * fcs.forecast.Quantity__c) /totalQuantity ;                                                
                }                                                               
                else{
                    fcs.forecast.Amount__c = 0;             
                }	            	
            }  	        
	        return qfcs; 
	    }
    	//******************************************************************
    	// END: build the list of month by year
    	//******************************************************************

    	//******************************************************************
    	// START: build the list of month by year
    	//******************************************************************
	    public List<ForecastItemStructure> calMonthForecastByYear(ForecastItemStructure yfcs){
	    	List<ForecastItemStructure> list_tmp = calQuarterForecastByYear(yfcs);
			return calMonthForecastByQurater(list_tmp);
	    }
    	//******************************************************************
    	// END: build the list of month by year
    	//******************************************************************    	   	  	  		
	}		
		  
    ///*>>>WrapperClass*/
	public class ForecastItemStructure{
		public String level {get; set;}
		public String type {get; set;}
		public Opportunity_Forecast__c forecast {get; set;}
		public String label {get; set;}
		public ForecastItemStructure(String l, Id partId, Id oppyId, Id recordTypeId){
			level = l;
			forecast = new Opportunity_Forecast__c();			
			if(partId != null){
				forecast.Part__c = partId;
				type = 'Part';
			}
			else{
				type = 'Opportunity';
			}
			forecast.Opportunity__c = oppyId;
			forecast.RecordTypeId = recordTypeId;
			forecast.Quantity__c = 0;
		}
	}    
	///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}