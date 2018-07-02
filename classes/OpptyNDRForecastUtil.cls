/**
Class provides utility methods for NDR forecasting functionality
**/
//public with sharing class OpptyNDRForecastUtil {
global class OpptyNDRForecastUtil{
    
    @future
    public static void addPartsToOpptyForecast(Set<Id> setOpptyIds){
        if(setOpptyIds == null || setOpptyIds.size() <= 0){
            return;
        }
        List<Opportunity> lstOppties = new List<Opportunity>();
        lstOppties = [Select Id, Name, Manufacturing_Start_Date__c, Level__c, CurrencyIsoCode, NDR_Quote_Status_Description__c, Life_of_Program_in_Years__c // add lili zhao due to add the field of 'Life_of_Program_in_Years__c' 
                      from Opportunity 
                      where Id in : setOpptyIds 
                      and NDR_Quote_Status_Description__c = 'Complete'
                      and Opportunity_Already_Exist__c != true 
                      and (Current_NDR_quote_number__c = null OR Current_NDR_quote_number__c = '')];
        
        if(lstOppties != null && lstOppties.size() > 0){
            addPartsToOpptyForecast(lstOppties);
        }       
    }
    
    /**     
    Creates forecast records on completed opportunities with approved NDR parts 
    **/
    public static void addPartsToOpptyForecast(List<Opportunity> lstOppties){
        /**
        1. Iterate on the list of opportunities        
           - create a Map where key is opportunity Id and value is opportunity record           
           - Calculate the forecast start year for every opportunity and create a map where key is opportunity id and value is fiscal year 
        2. Query out record type id for opportunity forecast record   
        3. Query out opportunity parts based on these opportunity ids
        4. Loop on all parts and create forecast records for these parts.
        5. Insert forecast records.
        6. Update parts.  
        **/
        
        if(lstOppties == null || lstOppties.size() <= 0){
            return;
        }
        
        //key = opportunity id, value = opportunity record
        Map<Id, Opportunity> mapOpportunityIds = new Map<Id, Opportunity>();
        
        //key = opportunity id, value = forecast start fiscal year
        Map<Id, Integer> mapOpptyIdForecastYear = new Map<Id, Integer>(); 
        map<String, Date> mapYearStartDate = new map<String, Date>(); // add lili 2014.1.24
        
        //List of opportunity forecast records to insert
        List<Opportunity_Forecast__c> lstOpptyForecastToInsert = new List<Opportunity_Forecast__c>();
        
        //List of opportunity parts
        List<Opportunity_Part__c> lstOpptyParts = new List<Opportunity_Part__c>();
        
        //List of opportunity parts to update
        List<Opportunity_Part__c> lstOpptyPartsToUpdate = new List<Opportunity_Part__c>();
        
        //List of Periods for holding fiscal years
        List<Period> lstPeriods = new List<Period>();
        
        
        try{            
            // query out all Periods            
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'Year' and FiscalYearSettings.IsStandardYear = false order by FiscalYearSettings.Name]){
                lstPeriods.add(p);
            }
                                         
            //Fetch NDR opportunity part record type 
            Apex_Helper_Settings__c config = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');
            Id ndrRecordType = config.Value__c;
            
            //Query out Opportunity Forecast record type
            config = Apex_Helper_Settings__c.getInstance('NDR Opportunity Forecast Part');
            Id opptyForecastRecordTypeId = config.Value__c;
            
            //***************************************************
            //START: get recordtype Id for opportunity's forecast
            //***************************************************
            String oppyFCRTId;
            config = Apex_Helper_Settings__c.getInstance('NDR Opportunity Forecast Opp');
            oppyFCRTId = config.Value__c;
            //***************************************************
            //END: get recordtype Id for opportunity's forecast
            //***************************************************            
            
            //loop on all opportunities
            for(Opportunity oppty : lstOppties){
                Date dtManufStartDate;                
                
                if(oppty.Manufacturing_Start_Date__c == null){
                    dtManufStartDate = Date.today();
                }
                else{
                    dtManufStartDate = oppty.Manufacturing_Start_Date__c;
                }
                mapOpportunityIds.put(oppty.Id, oppty);
                
                String strForecastYear = '';
                for(Period p: lstPeriods){   
                    if(dtManufStartDate >= p.StartDate && dtManufStartDate <= p.EndDate){
                        strForecastYear = p.FiscalYearSettings.Name; 
                        break;
                    }
                }                
                /**
                check if manufacturing start date is not within rannge then set it as today's date
                else use manufacturing start date as it is
                **/
                if(strForecastYear == ''){
                    dtManufStartDate = Date.today();                    
                    mapOpptyIdForecastYear.put(oppty.Id, Date.today().year());
                    mapYearStartDate.put(oppty.Id, dtManufStartDate); // add lili 2014.1.24
                }
                else{
                    mapOpptyIdForecastYear.put(oppty.Id, Integer.valueOf(strForecastYear));
                    mapYearStartDate.put(oppty.Id, dtManufStartDate); // add lili 2014.1.24
                }                
            }

            //Query out opportunity parts
            // Prabhanjan : [08-Apr-2015] adding forecast records of the respective parts and 
            // removing 'NDRForecastCreated__c!= true' filter to get all the forecasts.
             
            //Prabhanjan : [08-Apr-2015] adding map variable 
            // Added NDR_Alternate_Part__c != true filter by Mrunal for NDR Phase 2 So that forecast should not be created for alternate part.
            map<Id, Opportunity_Part__c> mapOpptyParts = new map<Id, Opportunity_Part__c>([Select Id, 
                             Name, Opportunity__c, Status__c, CurrencyISOCode, Quantity__c, 
                             NDR_Ship_and_Debit_Price__c, NDR_Ship_and_Debit_Price_Per__c,
                             NDR_GPMS_Approval_Price__c, NDR_Range__c,NDRForecastCreated__c,
                             NDR_Item_Unit_Price_Quoted_Price__c, NDR_Item_Price_Per__c,
                             NDR_Price_at_time_of_Request_Per__c, NDR_Customer_Requested_Price_Per__c,
                             Opportunity__r.CurrencyISOCode , NDR_Alternate_Part__c ,
                             (select id,Opportunity__c,part__c, date__c, quantity__c, amount__c from Forecast__r)
                             from Opportunity_Part__c 
                             where
                             NDR_Item_Status_Desc__c = 'Complete' and  
                             RecordTypeId = :ndrRecordType and
                             Opportunity__c in :mapOpportunityIds.keySet() and 
                             Opportunity__r.Opportunity_Already_Exist__c != true and
                             NDR_Alternate_Part__c != true and
                             (Opportunity__r.Current_NDR_quote_number__c = null OR Opportunity__r.Current_NDR_quote_number__c = '')
                             ]);
                                 
            /*
             * 
            lstOpptyParts = [Select Id, Name, Opportunity__c, Status__c, CurrencyISOCode, Quantity__c, 
                             NDR_Ship_and_Debit_Price__c, NDR_Ship_and_Debit_Price_Per__c,
                             NDR_GPMS_Approval_Price__c, NDR_Range__c,NDRForecastCreated__c,
                             NDR_Item_Unit_Price_Quoted_Price__c, NDR_Item_Price_Per__c,
                             NDR_Price_at_time_of_Request_Per__c, NDR_Customer_Requested_Price_Per__c,
                             Opportunity__r.CurrencyISOCode ,
                             (select id,Opportunity__c,part__c, date__c, quantity__c, amount__c from Forecast__r)
                             from Opportunity_Part__c 
                             where
                             NDR_Item_Status_Desc__c = 'Complete' and  
                             RecordTypeId = :ndrRecordType and
                             Opportunity__c in :mapOpportunityIds.keySet() and 
                             Opportunity__r.Opportunity_Already_Exist__c != true and
                             (Opportunity__r.Current_NDR_quote_number__c = null OR Opportunity__r.Current_NDR_quote_number__c = '')
                             ];
             */
            
            if(mapOpptyParts.size() <= 0){
                return;
            } 
           
           
            /*
            ** START: Prabhanjan : [08-Apr-2015] removing the parts that has forecast already created and
            ** building the forecasts with related opportunity-parts.
            ** 
            */
            
            map<string,list<Opportunity_Forecast__c>>  mapExstFC = new map<string,list<Opportunity_Forecast__c>>();
            
            List<Id> lstPartsIdsToRemove = new List<Id>();
           
            for(opportunity_part__c oPart:mapOpptyParts.values()){ 
                if(oPart.NDRForecastCreated__c){
                    string mapExstFCKey = string.valueOf(oPart.Opportunity__c)+string.valueOf(oPart.Id);
                    if(!mapExstFC.containsKey(mapExstFCKey)){
                        mapExstFC.put(mapExstFCKey,new list<Opportunity_Forecast__c>());
                    }
                    mapExstFC.put(mapExstFCKey,oPart.Forecast__r);
                    lstPartsIdsToRemove.add(oPart.Id);  
                }
                 
            }
            
            lstOpptyParts.clear();
            boolean removed = mapOpptyParts.keySet().removeAll(lstPartsIdsToRemove);
            lstOpptyParts.addAll(mapOpptyParts.values());
           
            /*
            ** END : Prabhanjan : [08-Apr-2015] removing the parts that has forecast already created and
            ** building the forecasts with related opportunity-parts.
            */
            
            Map<Id, Id> mapPartIdOpptyId = new Map<Id, Id>();
            Map<Id, String> mapPartIdISOCode = new Map<Id, String>();
            for(Opportunity_Part__c part : lstOpptyParts){
                //adjust string fields to avert any exceptions
                part.NDR_Ship_and_Debit_Price_Per__c = adjustFieldLength(part.NDR_Ship_and_Debit_Price_Per__c);
                part.NDR_Item_Price_Per__c = adjustFieldLength(part.NDR_Item_Price_Per__c);
                part.NDR_Price_at_time_of_Request_Per__c = adjustFieldLength(part.NDR_Price_at_time_of_Request_Per__c);
                part.NDR_Customer_Requested_Price_Per__c = adjustFieldLength(part.NDR_Customer_Requested_Price_Per__c);
                                
                mapPartIdOpptyId.put(part.Id, part.Opportunity__c);
                mapPartIdISOCode.put(part.Id, part.CurrencyISOCode);
                
                //commented this piece and uncommented the above as per changes done in forecast currency conversion logic
                //put same currency on the forecast as that is on opportunity
                //mapPartIdISOCode.put(part.Id, part.Opportunity__r.CurrencyISOCode);
                
                if(part.Quantity__c == null){
                    part.Quantity__c = 0;
                }               
                
                if(getValue(part.NDR_Ship_and_Debit_Price__c) == 0){
                    part.NDR_Ship_and_Debit_Price__c = '0';
                }
                if(part.NDR_GPMS_Approval_Price__c == null || part.NDR_GPMS_Approval_Price__c <= 0){
                    part.NDR_GPMS_Approval_Price__c = 0;
                }
                if(getValue(part.NDR_Item_Unit_Price_Quoted_Price__c) == 0){
                    part.NDR_Item_Unit_Price_Quoted_Price__c = '0';
                }
            }
            
            Map<Integer, Decimal> mapDateAmount = new Map<Integer, Decimal>();
            Map<Integer, Decimal> mapDateAmountCust = new Map<Integer, Decimal>();
            Decimal finalPrice = 0;
            Decimal salesPrice = 0;
            //system.debug('lstOpptyParts:::'+lstOpptyParts);

            for(Opportunity_Part__c part : lstOpptyParts){
                //decide on item price to forecast on
                finalPrice = 0;
                salesPrice = 0;
                if(part.NDR_Ship_and_Debit_Price__c != '0'){                    
                    finalPrice = getPricePerPiece(Decimal.valueOf(part.NDR_Ship_and_Debit_Price__c), part.NDR_Ship_and_Debit_Price_Per__c);
                }   
                else if(part.NDR_GPMS_Approval_Price__c != 0){                  
                    finalPrice = getPricePerPiece(part.NDR_GPMS_Approval_Price__c, part.NDR_Range__c.toPlainString());
                } 
                else if(part.NDR_Item_Unit_Price_Quoted_Price__c != '0'){                   
                    finalPrice = getPricePerPiece(Decimal.valueOf(part.NDR_Item_Unit_Price_Quoted_Price__c), part.NDR_Item_Price_Per__c);
                }
                         
                List<Decimal> quantities = new List<Decimal>(); 
                Integer intforecastStartYear = mapOpptyIdForecastYear.get(part.Opportunity__c); 
                Integer months = 0;
                
                //***********************************************************
                // START: calculate the quantities based on oppy's level
                // Notice: No real yearly forecasts exisits, yearly should 
                // be splited as quarterly
                //***********************************************************                
                Opportunity oppty = mapOpportunityIds.get(part.Opportunity__c);
                if(oppty.Level__c == ClsOppyForecastUtil.MONTHLY){
                    months = 12;
                }
                else{
                    months = 4;
                }
                //***********************************************************
                // END: calculate the quantities based on oppy's level
                // Notice: No real yearly forecasts exisits, yearly should 
                // be splited as quarterly
                //***********************************************************     
                                 
                //******************************************************************
                // START:Added by Mrunal for NDR Project to calculate the quantities for years as per the life_of_program_in_years field value
                // based on manufacturing start date, e.g. 100 pieces for 2014-02-01 and life_of_program_in_years as '3'
                // we will create 25 for each of 2014-Q2, 2014-Q3, 2014-Q4, 2015-Q1, 2015-Q2, 2015-Q3, 2015-Q4, 2016-Q1, 2016-Q2, 2016-Q3, 2016-Q4, 2017-Q1
                // The result should be like: 2014[0,25,25,25], 2015[25,25,25,25], 2016[25,25,25,25], 2017[25,0,0,0]
                //******************************************************************
                map<String, list<Decimal>> map_quantities = calculateQantityForeCurrentNextYear(part.Quantity__c, months, mapYearStartDate.get(part.Opportunity__c),oppty.Life_of_Program_in_Years__c);
                //******************************************************************
                // END:calculate the quantities for years as per the life_of_program_in_years field value
                // based on manufacturing start date, e.g. 100 pieces for 2014-02-01 and life_of_program_in_years as '3'
                // we will create 25 for each of 2014-Q2, 2014-Q3, 2014-Q4, 2015-Q1, 2015-Q2, 2015-Q3, 2015-Q4, 2016-Q1, 2016-Q2, 2016-Q3, 2016-Q4, 2017-Q1
                // The result should be like: 2014[0,25,25,25], 2015[25,25,25,25], 2016[25,25,25,25], 2017[25,0,0,0]
                //******************************************************************    
                
                // Change start by Mrunal for NDR project to calculate quantity and salesprice for yrs mentioned in field life_of_program_in_years
                Integer startMonth = 1;
                startMonth = getStartMonthOrQuarter(mapYearStartDate.get(part.Opportunity__c), months);
                Integer intForecastEndYear;
                if(oppty.Life_of_Program_in_Years__c != null ) {
                    intForecastEndYear = intForecastStartYear + Integer.valueOf(oppty.Life_of_Program_in_Years__c);
                }
                if(startMonth != 1) {
                    intForecastEndYear = intForecastEndYear + 1;
                }    
                /*system.debug('intForecastStartYear::: '+intForecastStartYear);      
                system.debug('intForecastEndYear::: ' + intForecastEndYear);
                add lili zhao 2014-09-02  begin         
                for(Integer iter = intForecastStartYear; iter < intForecastStartYear + 5; iter++){
                for(Integer iter = intForecastStartYear; iter < intForecastEndYear; iter++){
                add lili zhao 2014-09-02  end */
                
                
                Integer LifeOfProgram;
                if(oppty.Life_of_Program_in_Years__c != null)
                    LifeOfProgram = Integer.valueOf(oppty.Life_of_Program_in_Years__c);
                else
                    LifeOfProgram = 1;
                    
                for (Integer i = 0; i < LifeOfProgram+1 ; i++){
                    quantities = map_quantities.get('Year'+i);
                    salesPrice = finalPrice;
                    Integer iter = intForecastStartYear+i;
                    // Commented by Mrunal
                    /*if(iter == intForecastStartYear){
                        quantities = map_quantities.get('currYear');
                        salesPrice = finalPrice;
                    }
                    else if(iter == intForecastStartYear + 1){
                        quantities = map_quantities.get('nextYear');
                        salesPrice = finalPrice;                    
                    }
                    else{
                        quantities = calculateQantity(0, months);
                        salesPrice = 0;
                    }  */
                    // Change end by Mrunal for NDR project
                    
                    lstOpptyForecastToInsert.addAll(ClsOppyForecastUtil.createForcastsNew(oppty, opptyForecastRecordTypeId, quantities, salesPrice, part, String.valueOf(iter), mapPartIdISOCode, mapPartIdOpptyId, mapDateAmount, mapDateAmountCust, null));

                    part.Status__c = 'Likely';
                    part.Process_Status__c = 'Quoted';//changed value from Designed to Quoted by Mrunal for Change Channel Opportunities at header level Project
                    part.NDRForecastCreated__c = true;                    
                }
                lstOpptyPartsToUpdate.add(part);
            }       
            if(lstOpptyForecastToInsert.size() > 0){
                list<Opportunity_Forecast__c> list_tmp = new list<Opportunity_Forecast__c>();
                list_tmp.addAll(lstOpptyForecastToInsert);
                //***************************************************
                //START: create opportunity forecast
                //***************************************************
                map<Date, map<String, Opportunity_Forecast__c>> map_oppys = new map<Date, map<String,Opportunity_Forecast__c>>();
                
                for(Opportunity_Forecast__c fc :lstOpptyForecastToInsert){
                    system.debug('fc: ' + fc);
                    if(!map_oppys.containsKey(fc.Date__c)){
                        map_oppys.put(fc.Date__c, new map<String, Opportunity_Forecast__c>());
                    }
                    if(!map_oppys.get(fc.Date__c).containsKey(fc.Opportunity__c)){
                        Opportunity_Forecast__c oppyFC = fc.clone(false);
                        oppyFC.RecordTypeId = oppyFCRTId; 
                        oppyFC.Sales_Price__c = 0;
                        oppyFC.Part__c = null;           
                        map_oppys.get(fc.Date__c).put(fc.Opportunity__c, oppyFC);
                        system.debug('oppyFC: ' + oppyFC);
                        list_tmp.add(oppyFC);
                    }
                    else{
                        map_oppys.get(fc.Date__c).get(fc.Opportunity__c).Quantity__c += fc.Quantity__c;
                        map_oppys.get(fc.Date__c).get(fc.Opportunity__c).Amount__c += fc.Amount__c!=null?fc.Amount__c:0;
                        map_oppys.get(fc.Date__c).get(fc.Opportunity__c).Five_Year_Amount__c += fc.Five_Year_Amount__c!=null?fc.Five_Year_Amount__c:0;// Added by Mrunal for NDR Phase II Enhancement project for revenue Calculation requirement.
                    }
                    
                }           
                /***************************************************
                ** END: create opportunity forecast
                ** START: Prabhanjan [08-Apr-2015] changing 'insert list_tmp;' statement to upsert to avoid duplicates with the help of Uniquekey_For_The_Forecast__c .
                ** and calculating the forecast of existing parts.
                ***************************************************/
                map<string,Opportunity_Forecast__c> finalFCMap = new map<string,Opportunity_Forecast__c>();
                map<string,Decimal> mapFCofExtPartsQty = new map<string,Decimal>();
                map<string,Decimal> mapFCofExtPartsAmt = new map<string,Decimal>();
                map<string,Decimal> mapFCofExtPartsFYAmt = new map<string,Decimal>();// Added by Mrunal for NDR Phase II Enhancement project for revenue Calculation requirement.
                //Getting the values from mapExstFC and building map for adding to the new forecast records.
                //As it returns list<list<>>, needed for inside for.
                for(list<Opportunity_Forecast__c> fclist : mapExstFC.values()){
                                                               
                    for(Opportunity_Forecast__c partFC : fclist){
                    
                        string mapFCofExtPartsKey = string.valueOf(partFC.Opportunity__c)+'null'+string.valueOf(partFC.Date__c);
                        if(!mapFCofExtPartsQty.containsKey(mapFCofExtPartsKey)){
                            mapFCofExtPartsQty.put(mapFCofExtPartsKey, partFC.Quantity__c);
                            mapFCofExtPartsAmt.put(mapFCofExtPartsKey, partFC.amount__c);
                            mapFCofExtPartsFYAmt.put(mapFCofExtPartsKey, partFC.Five_Year_Amount__c);// Added by Mrunal for NDR Phase II Enhancement project for revenue Calculation requirement.
                        }
                        else{
                            mapFCofExtPartsQty.put(mapFCofExtPartsKey,mapFCofExtPartsQty.get(mapFCofExtPartsKey)+partFC.Quantity__c);
                            mapFCofExtPartsAmt.put(mapFCofExtPartsKey,mapFCofExtPartsAmt.get(mapFCofExtPartsKey)+partFC.amount__c);
                            mapFCofExtPartsFYAmt.put(mapFCofExtPartsKey,mapFCofExtPartsFYAmt.get(mapFCofExtPartsKey)+partFC.Five_Year_Amount__c);// Added by Mrunal for NDR Phase II Enhancement project for revenue Calculation requirement.
                        }
                         
                    }
                }
            mapExstFC.clear();                
                for(Opportunity_Forecast__c fcc :list_tmp){
                    fcc.Uniquekey_For_The_Forecast__c = string.valueOf(fcc.Opportunity__c)+string.valueOf(fcc.Part__c)+string.valueOf(fcc.Date__c);
                    if(!finalFCMap.containsKey(fcc.Uniquekey_For_The_Forecast__c)){ 
                        
                        //Adding the prevoius forecast figures to the new ones.
                        if(mapFCofExtPartsQty.containsKey(fcc.Uniquekey_For_The_Forecast__c)) {
                            fcc.Quantity__c +=  mapFCofExtPartsQty.get(fcc.Uniquekey_For_The_Forecast__c);
                            fcc.Amount__c +=  mapFCofExtPartsAmt.get(fcc.Uniquekey_For_The_Forecast__c); 
                            fcc.Five_Year_Amount__c+=  mapFCofExtPartsFYAmt.get(fcc.Uniquekey_For_The_Forecast__c);// Added by Mrunal for NDR Phase II Enhancement project for revenue Calculation requirement.
                        }
                            finalFCMap.put(fcc.Uniquekey_For_The_Forecast__c, fcc);
                            
                    }
         
                }
                
                //insert list_tmp; 
                Database.UpsertResult[] results = 
                        Database.upsert(finalFCMap.values(), Schema.Opportunity_Forecast__c.Uniquekey_For_The_Forecast__c, false);
                for (Database.UpsertResult res : results) {
                    if (res.isSuccess()) {
                         System.debug('Record ID ' + res.getId() + ' is successfully upserted.'); 
                    }
                    else {
                        if (res.getErrors().size() > 0) {
                            System.debug('Record ID ' + res.getId() + ' Got this error:' + res.getErrors()[0].getMessage());
                        }
                    }
                }
                
                /***************************************************
                ** END: Prabhanjan [08-Apr-2015] changing 'insert list_tmp;' statement to upsert to avoid duplicates with the help of Uniquekey_For_The_Forecast__c .
                ** and calculating the forecast of existing parts.
                ***************************************************/
                
                
                //update lstOpptyParts;
                update lstOpptyPartsToUpdate;
            }                                   
        }   
        catch(Exception ex){
            System.debug('**** Exception ' + ex.getMessage());
            System.debug('**** Exception Line Number ' + ex.getLineNumber());
            System.debug('**** Exception Stack Trace ' + ex.getStackTraceString());
            System.debug('**** Exception Type Name ' + ex.getTypeName());
        }
    }
    
    private static String adjustFieldLength(String field){
        /**
        1. Check for null or blank and put 1 in these cases
        2. Get iteger value, convert to string and check for length. 
        3. if length is more than 5 then truncate the value
        **/     
        String value = '1';
        if(field == null || field == ''){
            return value;
        }
        if(getValue(field) > 0){
            value = String.valueOf(getValue(field).intValue());
            if(value.length() > 5){
                value = value.left(5);
            }           
        }       
        return value;
    }
    
    /** Returns decimal value against string field and checks for any exceptions **/
    private static Decimal getValue(String field){
        Decimal value = 0;
        try{
            if(field == null || field == '' || Decimal.valueOf(field) <= 0){
                value = 0;
            }
            else{
                value = Decimal.valueOf(field);
            }
            return value;
        }
        catch(Exception ex){
            value = 0;
            return value;
        }
        finally{
            return value;
        }
    }
    
    /** Returns decimal price per piece value and checks for any exceptions **/
    public static Decimal getPricePerPiece(Decimal price, String qty){
        Decimal pricePerPiece = price;      
        try{
            if(price == null || price <= 0){
                return 0;
            }
            if(qty == null || qty == ''){
                return pricePerPiece;
            }
            Decimal quantity = Decimal.valueOf(qty);
            if(quantity <= 0){
                return pricePerPiece;
            }
            if(quantity > 0){
                system.debug('price:::'+price+':::quantity::::'+quantity);
                pricePerPiece = price / quantity;
            }
            return pricePerPiece;
        }
        catch(Exception ex){
            return pricePerPiece;
        }
        finally{
            return pricePerPiece;
        }
    }
    
    /** returns List of quantity values divided based on number of months **/
    private static List<Decimal> calculateQantity(Decimal quantity, Integer months){        
        List<Decimal> quantityValues = new List<Decimal>();
        
        if(quantity == null || quantity == 0){
            for(Integer iter = 0; iter < months; iter++){
                quantityValues.add(0);
            }
            return quantityValues;
        }
        if(months == 1){
            quantityValues.add(quantity);
            return quantityValues;
        }   
        
        Integer yearlyQuantity = quantity.intValue();  
        Integer dividedQuantity = yearlyQuantity / months;
        Integer remainderQuantity = Math.mod(yearlyQuantity, months);        
        
        for(Integer iter = 1; iter <= months; iter++){
            //add the remainder to last month / quarter 
            if(iter == months){
                quantityValues.add(dividedQuantity + remainderQuantity);
            }
            else{
                quantityValues.add(dividedQuantity);
            }           
        }
        return quantityValues;
    }

    private static Integer getStartMonthOrQuarter(Date startDate, Integer months){
        for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate, type from Period where (type = 'Month' or type = 'Quarter') and StartDate <=: startDate and EndDate >=:startDate ]){
            if(months == 12 && p.Type == 'Month'){ 
                return ClsOppyForecastUtil.MAP_MONTHLABELNUMBER.get(p.PeriodLabel);
            }
            else if(months != 12 && p.Type == 'Quarter'){
                return p.Number;
            }
        }   
        return 1;   
    }
     /**     
    Changed this Method's complete logic, earlier this was calculating quantity of forecast for current and next year but now this will calculate quantity of forecast for Years mentioned in Life_of_Program_in_Years__c field.  
    **/

        
    public static map<String, List<Decimal>> calculateQantityForeCurrentNextYear(Decimal quantity, Integer months, Date startDate, String lifeOfProg){ 
        /**
        1. Check Life_of_Program_in_Years__c field, if not null take its value and if it is null take value as 1.        
        2. Divide Quantity of a part in Forecast.   
        3. Create a map of quantityValues for years as per the life_of_program_in_years field.
        4. If Quantity of any part is null return map with 0 values for yrs as per life_of_program_in_years field. So for 3 yrs, map key will have year0,year1,year2 values
        5. if Life_of_Program_in_Years__c has '3' value and Oppty part Quantity is 130 then for 
            -first condition if startmonth is 1 the map will be Year0{32,32,32,34} , Year1{32,32,32,34}, Year2{32,32,32,34}, Year3{0,0,0,0}
            -Second condition if startmonth is 3 the map will be Year0{0,0,32,32} , Year1{32,34,32,32}, Year2{32,34,32,32}, Year3{32,34,0,0}  
        **/
        map<String, List<Decimal>> quantityValues = new map<String, List<Decimal>>();
        Integer startMonth = 1;
        //1. Check Life_of_Program_in_Years__c field, if not null take its value and if it is null take value as 1. 
        Integer lop;
        if(lifeOfProg != null || lifeOfProg != '')
            lop = Integer.valueof(lifeOfProg);
        else
            lop = 1;
            
        startMonth = getStartMonthOrQuarter(startDate, months);
        System.debug('startMonth: ' + startMonth);
        // Commented and created map for yrs as per the life_of_program_in_years field.
        /*if(quantity == null || quantity == 0){
            for(Integer iter = 0; iter < months; iter++){
                if(!quantityValues.containsKey('currYear')){
                    quantityValues.put('currYear', new list<Decimal>());
                    quantityValues.put('nextYear', new list<Decimal>());
                }
                quantityValues.get('currYear').add(0);
                quantityValues.get('nextYear').add(0);
            }
            return quantityValues;
        }*/

        // 2. Divide Quantity of a part in Forecast.
        Integer yearlyQuantity = quantity.intValue();  
        Integer dividedQuantity = yearlyQuantity / months;
        Integer remainderQuantity = Math.mod(yearlyQuantity, months);        
        //3. Create a map of quantityValues for years as per the life_of_program_in_years field.
        for(Integer i = 0; i <= LOP; i++){
        if(!quantityValues.containsKey('Year'+i)){
                quantityValues.put('Year'+i, new list<Decimal>());
            } 
        }
        //4. If Quantity of any part is null return map with 0 values for yrs as per life_of_program_in_years field. So for 3 yrs, map key will have year0,year1,year2 values
        if(quantity == null || quantity == 0){
            for(Integer iter = 1; iter <= months*(LOP+1); iter++){
                quantityValues.get('Year'+((iter-1)/months)).add(0);
            }
            return quantityValues;
        }
        //5. if Life_of_Program_in_Years__c has '3' value and Oppty part Quantity is 130 then for 
            
        for(Integer iter = 1; iter <= months*(LOP+1); iter++){
            Integer div = iter/(months+1);
            //  -first condition if startmonth is 1 the map will be Year0{32,32,32,34} , Year1{32,32,32,34}, Year2{32,32,32,34}, Year3{0,0,0,0}
            if(startMonth == 1){
                if(iter < months*(LOP+1)-1 && Math.mod(iter, months) == 0 ){        
                    //add the remainder to last month / quarter     
                    quantityValues.get('Year'+((iter-1)/months)).add(dividedQuantity + remainderQuantity);
                }    
                else if(iter >= startMonth && iter<months){              
                    quantityValues.get('Year'+((iter-1)/months)).add(dividedQuantity);
                }  
                else if(iter > months && iter <= months* LOP){
                    quantityValues.get('Year'+((iter-1)/months)).add(dividedQuantity);
                }
                else {
                    quantityValues.get('Year'+((iter-1)/months)).add(0);
                }                                                           
            }
            //  -Second condition if startmonth is 3 the map will be Year0{0,0,32,32} , Year1{32,34,32,32}, Year2{32,34,32,32}, Year3{32,34,0,0}
            else{
                if(iter>startMonth && Math.mod(iter-(startMonth-1), months) == 0){        
                    //add the remainder to last month / quarter     
                    quantityValues.get('Year'+((iter-1)/months)).add(dividedQuantity + remainderQuantity);
                }        
                else if(iter >= startMonth && iter<=months){             
                    quantityValues.get('Year'+((iter-1)/months)).add(dividedQuantity);
                }  
                else if(iter > months && iter<months + startMonth-1){
                    quantityValues.get('Year'+((iter-1)/months)).add(dividedQuantity);
                }
                else if(iter > months + startMonth-1 && iter <= (months*LOP) + startMonth-1){
                    quantityValues.get('Year'+((iter-1)/months)).add(dividedQuantity);
                }
                else if(iter >=1 && iter<startMonth){
                    quantityValues.get('Year'+((iter-1)/months)).add(0);
                }                                      
                else{
                    quantityValues.get('Year'+((iter-1)/months)).add(0);
                }                       
            }
        }
        return quantityValues;
    }    

    /**
    Check status description value against various combinations and return true if its complete and false otherwise
    **/
    public static Boolean isOpportunityComplete(string statusDescription){              
        Boolean result = false;
        if(statusDescription == null || statusDescription == ''){
            result = false;
        }
        else if(statusDescription.containsIgnoreCase('complete') && statusDescription.toUpperCase().indexOf('COMPLETE') == 0){
            result = true;
        }
        return result;          
    }
}