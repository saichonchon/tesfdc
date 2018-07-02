/***********************************************************************************************************************
      Name : Cls_BatchJDAPartForecast
       Org : C2S
 Copyright : © 2014 TE Connectivity 
========================================================================================================================
   Summary : A batch class to create records in INFRA Part Forecast object
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL                               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   04/01/2014 Initial Development                  42  
     1.1 Mrunal       06/05/2014 Change to display region             42
                                 names in short instead of code.  
     1.2 Mrunal       26/01/2014 Changes to send Quarterly and        42
                                 Yearly Value to JDA                    
***********************************************************************************************************************/
global class Cls_BatchJDAPartForecast implements Database.Batchable<sObject>, Database.Stateful{
    /* _______________________________________ GLOBAL VARIABLE DECLARATION ___________________________________________*/    
    global String vQuery;
    global Set<Id> vRTSetToAdd = new Set<Id>();
    global Set<Id> vEngOppRTSet = new Set<Id>();
    global Set<Id> vSalesOppRTSet = new Set<Id>();
    global Map<String, Decimal> vConversionMap = new Map<String, Decimal>();
    global Map<String, Decimal> vAmountMap = new Map<String, Decimal>();
    global Map<String, List<Decimal>> vMapAccountToAmt = new Map<String, List<Decimal>>();
    
    global Cls_BatchJDAPartForecast(Map<String, Decimal> pConversionMap){
        vConversionMap = pConversionMap.clone();
        INFRA_JDA_Settings__c vConfig = INFRA_JDA_Settings__c.getValues('Default');
        if(vConfig.Engineering_Opportunity_Record_Types__c != NULL && vConfig.Sales_Opportunity_Record_Types__c != NULL){
            List<String> vListString = vConfig.Engineering_Opportunity_Record_Types__c.split(',',0);
            if(!vListString.isEmpty()){
                for(String vTempString : vListString){
                   vEngOppRTSet.add((Id)vTempString); 
                }
            }
            vListString.clear();
            vListString = vConfig.Sales_Opportunity_Record_Types__c.split(',',0);
            if(!vListString.isEmpty()){
                for(String vTempString : vListString){
                   vSalesOppRTSet.add((Id)vTempString); 
                }
            }
        }else{
            vSalesOppRTSet.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Sales Project').getRecordTypeId());
            vEngOppRTSet.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Engineering Project').getRecordTypeId());
        }
        vRTSetToAdd.add(Schema.SObjectType.Opportunity_Part__c.getRecordTypeInfosByName().get('Sales Parts').getRecordTypeId());
        //QUERY ON OPPORTUNITY PART TO AVOID PROBLEM OF INCONSISTENT PART RECORDS IN EXECUTE METHOD
        if(!vRTSetToAdd.isEmpty()){
            vQuery = 'SELECT Id, Part_Number__c, Opportunity__c, Opportunity__r.AccountId, '+
                    +'Opportunity__r.Account.Account_Number_JDA_bridge_format__c FROM Opportunity_Part__c WHERE '+
                    +'Opportunity__r.Account.Territory_L2_Code__c = \'102202\' AND Part_Number__c <> NULL AND '+
                    +'(Opportunity__r.RecordTypeId in: vSalesOppRTSet OR Opportunity__r.RecordTypeId in: vEngOppRTSet) AND '+
                    +'Opportunity__r.Relevant_for_S_OP__c = TRUE AND '+
                    +'Status__c <> \'On Hold\' AND Status__c <> \'Dead\' AND Status__c <> \'Lost\'';              
            if(Test.isRunningTest())
                vQuery += ' LIMIT 10';
        }
    }
    
    //STANDARD QueryLocator METHOD TO EXECUTE THE QUERY IN CONSTRUCTOR
    global Database.QueryLocator start(Database.BatchableContext BC){
        if(vQuery != null){
            return Database.getQueryLocator(vQuery);
        }
        return null;          
    }

    //ACTUAL LOGIC TO CREATE FORECAST RECORDS
    global void execute(Database.BatchableContext BC, List<Opportunity_Part__c> pOppPartList){
        if(!pOppPartList.isEmpty()){
            Set<String> vSetPartNumber = new Set<String>();
            Set<Id> vSetOppId = new Set<Id>();
            Set<String> vSetKeyString = new Set<String>();
            Map<String, String> vMapKeyProductMap = new Map<String, String>();
            Map<String, Id> vMapProductOppMap = new Map<String, Id>();
            Set<String> vSetINFRA = new Set<String>();
                        
            if(!pOppPartList.isEmpty()){
                for(Opportunity_Part__c vTempOppPart : pOppPartList){
                    String vKeyString = vTempOppPart.Part_Number__c+'_'+vTempOppPart.Opportunity__c;
                    vSetPartNumber.add(vTempOppPart.Part_Number__c);
                    vSetOppId.add(vTempOppPart.Opportunity__c);
                    vSetKeyString.add(vKeyString);
                    vMapKeyProductMap.put(vKeyString, vTempOppPart.Part_Number__c); 
                    vMapProductOppMap.put(vKeyString, vTempOppPart.Opportunity__c);
                }
                List<INFRA__Part_Forecast__c> vListINFRAForecast = [SELECT Id,
                                                                     INFRA__Customer__c,
                                                                     INFRA__Product_Code__c,
                                                                     INFRA__BU_Forecast_Source_Id__c
                                                                FROM INFRA__Part_Forecast__c
                                                               WHERE INFRA__Product_Code__c in: vSetPartNumber                                                                
                                                                 AND INFRA__BU_Forecast_Source_Id__c in: vSetOppId
                                                                 AND LastModifiedDate > LAST_N_DAYS:2];
                if(!vListINFRAForecast.isEmpty()){
                    for(INFRA__Part_Forecast__c vTempINFRA : vListINFRAForecast){
                        String vKeyString2 = vTempINFRA.INFRA__Product_Code__c+'_'+vTempINFRA.INFRA__BU_Forecast_Source_Id__c;
                        vSetINFRA.add(vKeyString2);
                    }
                }
                if(!vSetINFRA.isEmpty()){
                    //EXCLUDE THE PARTS FOR WHICH INFRA ALREADY CREATED
                    vSetPartNumber.clear();
                    vSetOppId.clear();
                    for(Opportunity_Part__c vTempOppPart : pOppPartList){
                        String vKeyString = vTempOppPart.Part_Number__c+'_'+vTempOppPart.Opportunity__c;
                        if(!vSetINFRA.contains(vKeyString)){
                            vSetPartNumber.add(vTempOppPart.Part_Number__c);
                            vSetOppId.add(vTempOppPart.Opportunity__c);
                        }
                    }  
                }
                //QUERY AGAIN ON OPPFORECASTS AND THEN A FOR LOOP
                if(!vSetPartNumber.isEmpty()){
                    //QUERY ON OPPORTUNITY FORECAST
                    // Added Fiscal_Year__c,Fiscal_Month__c,Opportunity__r.Level__c fields in query to send Quarterly and Yearly Value to JDA By Mrunal
                    List<Opportunity_Forecast__c> vListForecast = [SELECT Id, 
                                                                          Date__c, 
                                                                          Amount__c, 
                                                                          Quantity__c,
                                                                          Part_Number__c,
                                                                          Opportunity__c,
                                                                          CurrencyIsoCode,
                                                                          Fiscal_Year_Month_short__c,
                                                                          Fiscal_Year__c, 
                                                                          Fiscal_Month__c , 
                                                                          Opportunity__r.Level__c, 
                                                                          Opportunity__r.StageName,
                                                                          Opportunity__r.PLM_Id__c,
                                                                          Opportunity__r.RecordTypeId,
                                                                          Opportunity__r.Opportunity_Number__c,
                                                                          Opportunity__r.Account.LAYER2_ORGANIZATION_SHORT_NM__c, // Added By Mrunal from 'LAYER2_ORGANIZATION_ID__c' to show Short Name instead of code
                                                                          Opportunity__r.Account.Account_Number_JDA_bridge_format__c 
                                                                     FROM Opportunity_Forecast__c 
                                                                    WHERE Part_Number__c in: vSetPartNumber
                                                                      AND Opportunity__c in: vSetOppId
                                                                      AND Date__c >= TODAY
                                                                      AND Date__c <= NEXT_N_MONTHS:18
                                                                      AND Amount__c > 0];
                    //ACTUAL FORECAST RECORDS CREATION
                    if(!vListForecast.isEmpty()){
                        Map<String, List<Opportunity_Forecast__c>> vMapPartToForecast = new Map<String, List<Opportunity_Forecast__c>>();
                        for(Opportunity_Forecast__c vForecast : vListForecast){
                            String vKeyString3 = vForecast.Part_Number__c+'_'+vForecast.Opportunity__c;
                            List<Opportunity_Forecast__c> vTempList = new List<Opportunity_Forecast__c>();
                            if(!vMapPartToForecast.keySet().contains(vKeyString3)){
                                vTempList.add(vForecast);
                                vMapPartToForecast.put(vKeyString3, vTempList);
                            }else{
                                vTempList = vMapPartToForecast.get(vKeyString3);
                                vTempList.add(vForecast);
                                vMapPartToForecast.put(vKeyString3, vTempList);
                            }
                        }
                        //FOR FORECAST
                        List<INFRA.ForecastData.PartData> forecastList = new List<INFRA.ForecastData.PartData>();
                        for(String ids : vMapPartToForecast.keySet()){
                            //FOR PARENT FORECAST DATA
                            INFRA.ForecastData.PartData forecastHeader1  = new INFRA.ForecastData.PartData();
                            forecastHeader1.region                       = vMapPartToForecast.get(ids)[0].Opportunity__r.Account.LAYER2_ORGANIZATION_SHORT_NM__c;// Changed By Mrunal from 'LAYER2_ORGANIZATION_ID__c' to show Short Name instead of code
                            forecastHeader1.customer                     = vMapPartToForecast.get(ids)[0].Opportunity__r.Account.Account_Number_JDA_bridge_format__c;
                            forecastHeader1.customerIndicator            = INFRA.ForecastUtil.CustomerIndicator.SoldTo;
                            forecastHeader1.productHierarchyIndicator    = INFRA.ForecastUtil.ProductHierarchyIndicator.Part;
                            forecastHeader1.productCode                  = vMapPartToForecast.get(ids)[0].Part_Number__c;
                            forecastHeader1.businessUnitForecastSourceId = vMapPartToForecast.get(ids)[0].Opportunity__c;
                            forecastHeader1.site                         = 'OTHERS';
                            forecastHeader1.siteIndicator                = INFRA.ForecastUtil.SiteIndicator.Building;
                            if(vSalesOppRTSet.contains(vMapPartToForecast.get(ids)[0].Opportunity__r.RecordTypeId)){
                                forecastHeader1.dataStream = INFRA.ForecastUtil.DataStream.SalesOpportunity;
                            }
                            if(vEngOppRTSet.contains(vMapPartToForecast.get(ids)[0].Opportunity__r.RecordTypeId)){
                                forecastHeader1.dataStream = INFRA.ForecastUtil.DataStream.EngineeringOpportunity;
                            }

                            //FOR DETAIL CALCULATION
                            List<INFRA.ForecastDetail.PartDetail> forecastDetailList1 = new List<INFRA.ForecastDetail.PartDetail>();
                            for(Opportunity_Forecast__c vTempForecast : vMapPartToForecast.get(ids)){
                                INFRA.ForecastDetail.PartDetail forecastDetail1 = new INFRA.ForecastDetail.PartDetail();
                                if(vTempForecast.CurrencyIsoCode == 'USD'){
                                    forecastDetail1.amount = vTempForecast.Amount__c;
                                }else{
                                    forecastDetail1.amount = vTempForecast.Amount__c / vConversionMap.get(vTempForecast.CurrencyIsoCode);
                                }
                                //forecast period (period month format YYYYMM, quater format YYYYQ#, year format YYYY)
                                //forecastDetail1.period = vTempForecast.Fiscal_Year_Month_short__c; // Commented by Mrunal to send yearly and Quarterly value
                                String vSubtractionKey = forecastHeader1.customer+'_'+forecastDetail1.period;
                                if(vMapAccountToAmt.get(vSubtractionKey) == NULL){
                                    List<Decimal> vAmt = new Decimal[2];
                                    vAmt[0] = 0;
                                    vAmt[1] = 0;
                                    vMapAccountToAmt.put(vSubtractionKey, vAmt);
                                }
                                //forecastDetail1.useDefaultPeriodIndicator = false;
                                //forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly; //mrunal
                                //Change start by Mrunal to send Quarterly and Yearly Value to JDA 
                                String yearAndQuarter;
                                if(vTempForecast.Opportunity__r.Level__c == 'Monthly'){
                                    forecastDetail1.period = vTempForecast.Fiscal_Year_Month_short__c;
                                    forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Monthly;
                                }else if(vTempForecast.Opportunity__r.Level__c == 'Quarterly'){
                                    if(vTempForecast.Fiscal_Month__c == '01'){
                                        yearAndQuarter = vTempForecast.Fiscal_Year__c+'Q1';
                                    }else if(vTempForecast.Fiscal_Month__c == '04'){
                                        yearAndQuarter = vTempForecast.Fiscal_Year__c+'Q2';
                                    }else if(vTempForecast.Fiscal_Month__c == '07'){
                                        yearAndQuarter = vTempForecast.Fiscal_Year__c+'Q3';
                                    }else if(vTempForecast.Fiscal_Month__c == '10'){
                                        yearAndQuarter = vTempForecast.Fiscal_Year__c+'Q4';
                                    }
                                    forecastDetail1.period = yearAndQuarter;
                                    forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.Quaterly;
                                } else if(vTempForecast.Opportunity__r.Level__c == 'Yearly'){
                                    forecastDetail1.period = vTempForecast.Fiscal_Year__c;
                                    forecastDetail1.periodIndicator = INFRA.ForecastUtil.ForecastPeriodIndicator.yearly;
                                }
                                //Change end by Mrunal to send Quarterly and Yearly Value to JDA
                                forecastDetail1.quantity = Integer.valueOf(vTempForecast.Quantity__c);
                                if(vEngOppRTSet.contains(vTempForecast.Opportunity__r.RecordTypeId)){
                                    forecastDetail1.ATTRIB_NM_1 = vTempForecast.Opportunity__r.PLM_Id__c;
                                        //SUBTRACTION LOGIC FOR ENG OPP
                                        if(vMapAccountToAmt.get(vSubtractionKey)[0] == 0){                                           
                                            vMapAccountToAmt.get(vSubtractionKey)[0] = forecastDetail1.amount;
                                            vMapAccountToAmt.put(vSubtractionKey, vMapAccountToAmt.get(vSubtractionKey));
                                        }else{
                                            Decimal vTemp = vMapAccountToAmt.get(vSubtractionKey)[0];
                                            vTemp += forecastDetail1.amount;
                                            vMapAccountToAmt.get(vSubtractionKey)[0] = vTemp;
                                            vMapAccountToAmt.put(vSubtractionKey, vMapAccountToAmt.get(vSubtractionKey));
                                        }
                                 }else{
                                    forecastDetail1.ATTRIB_NM_1 = '';
                                        //SUBTRACTION LOGIC FOR SALES OPP
                                        if(vMapAccountToAmt.get(vSubtractionKey)[1] == 0){                                           
                                            vMapAccountToAmt.get(vSubtractionKey)[1] = forecastDetail1.amount;
                                            vMapAccountToAmt.put(vSubtractionKey, vMapAccountToAmt.get(vSubtractionKey));
                                        }else{
                                            Decimal vTemp = vMapAccountToAmt.get(vSubtractionKey)[1];
                                            vTemp += forecastDetail1.amount;
                                            vMapAccountToAmt.get(vSubtractionKey)[1] = vTemp;
                                            vMapAccountToAmt.put(vSubtractionKey, vMapAccountToAmt.get(vSubtractionKey));
                                        }
                                }
                                forecastDetail1.ATTRIB_NM_2 = vTempForecast.Opportunity__r.StageName;
                                forecastDetail1.ATTRIB_NM_3 = vTempForecast.Opportunity__r.Opportunity_Number__c;
                                forecastDetailList1.add(forecastDetail1);
                            }
                            forecastHeader1.forecastDetail = forecastDetailList1;
                            forecastList.Add(forecastHeader1);
                        }
                        //THIS IS THE PUBLISHER CLASS INITIALIZATION WITH CUSTOM SETTING NAME - 'IND'
                        INFRA.ForecastPublishManagerClass clsObj = new INFRA.ForecastPublishManagerClass('IND');
                        //invoke the Part publish function and pass the forecast list
                        clsObj.publishPartForecast(forecastList);                                  
                    }
                }
            }
        }
    }

    global void finish(Database.BatchableContext BC) {
        for(String vTempString : vMapAccountToAmt.keySet()){
            vAmountMap.put(vTempString, vMapAccountToAmt.get(vTempString)[0]+vMapAccountToAmt.get(vTempString)[1]);
        }
        if(!vAmountMap.keySet().isEmpty()){
            Cls_BatchJDAAccountForecast vBatch = new Cls_BatchJDAAccountForecast(vConversionMap, vAmountMap);
            Id batchInstanceId;
            if(!Test.isRunningTest()) 
                batchInstanceId = Database.executeBatch(vBatch, 20); 
            else 
                batchInstanceId = Database.executeBatch(vBatch, 200); 
        }
    }
}