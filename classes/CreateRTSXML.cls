/**************************************************************************************************************************************************
 Name:  CreateRTSXML 
 Copyright © 2013 TE Connectivity 
 ==================================================================================================================================================
 Purpose: This creates XML string for RTS Interface.
 --------------------------------------------------------------------------------------------------------------------------------------------------
 History:                                                        
 --------------------------------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR              DATE        DETAIL                          Mercury Request #
 --------------------------------------------------------------------------------------------------------------------------------------------------
     1.0 Subba Reddy         02/25/2013  Initial Development 
     1.1 Shantinath Patil    01/22/2014  Updated code for forecast 
                                         alignment with Parts  
     1.2 Toshi Darode        09/10/2014  Updtaed code for Sample request for Datacomm                                                     
**************************************************************************************************************************************************/
public class CreateRTSXML {
   /*-- D1. Collection variable declaration ----------------------------------------------------------------------------*/
    static List<RTSMapping__c> vLstRTSMapping = new List<RTSMapping__c>();
    static Map<String,Double> vConversionRateMap = new Map<String,Double>();
    static Map<Id,List<Opportunity_Forecast__c>> vOppForcastListByPartMap = new Map<Id,List<Opportunity_Forecast__c>>();
    static Map<Id,List<Opportunity_Forecast__c>> vOppForcastListByPartMap1 = new Map<Id,List<Opportunity_Forecast__c>>();
    static Map<Id,List<Opportunity_Forecast__c>> vOppForcastListByPartMap2 = new Map<Id,List<Opportunity_Forecast__c>>();
    static Map<String, Double> vSalesPriceByFiscalYearMap = new Map<String, Double>();
    
   /*-- D2. Primitive variable declaration --------------------------------------*/
    static String vOppForecastLevel;    
    static Final Integer NUMBER_OF_FORECAST_YEARS = 5;
           
    /*____________________________________________________________________________________________________________________
     | Purpose : Creates a Map of Currency IsoCodes and respective Conversion Rates.                                      |
     |____________________________________________________________________________________________________________________|
     | Input Parameter  : None                                                                                            |
     |____________________________________________________________________________________________________________________|
     | Output Parameter : None                                                                                            |
     |___________________________________________________________________________________________________________________*/    
    private static void getExchangeRate() {
        for(CurrencyType vCurrencyType : [SELECT IsoCode,ConversionRate FROM CurrencyType]){          
            vConversionRateMap.put(vCurrencyType.IsoCode , vCurrencyType.ConversionRate);
        }
        System.Debug('Map of ISO Codes and their respective Conversion Rates---------> \n' + vConversionRateMap); 
    }
    
     /*____________________________________________________________________________________________________________________
     | Purpose : Creates a Map of OpportunityPartId and related OpportunityForecast List.                                  |
     |_____________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                  |   
     | ____________________________________________________________________________________________________________________|     
     |  I1. Name        : pOppFcstLst                                                                                      | 
     |      Data Type   : List<Opportunity_Forecast__c>                                                                    | 
     |      Description : Opportunity Forecast List of all Opportunity parts.                                              | 
     |_____________________________________________________________________________________________________________________|                                                                                        |
     | Output Parameter : None                                                                                             |
     |____________________________________________________________________________________________________________________*/ 
    private static void createOppForecastMap(List<Opportunity_Forecast__c> pOppFcstLst, List<Opportunity_part__c> pOppPartsLst){
       /*-- D1. Primitive variable declaration --------------------------------------*/
       
       createOppForecastMap1(pOppFcstLst);
       system.debug('pOppPartsLst --------->'+pOppPartsLst);
       
       for(Opportunity_part__c vOppPart: pOppPartsLst){
            String vForecastYear;
            Integer vForecastYearCounter = 0 ;
            List<Opportunity_Forecast__c> vOppFcstLstByPart = new List<Opportunity_Forecast__c>();           
            
            if(vOppForcastListByPartMap1.containsKey(vOppPart.id)){
                vOppFcstLstByPart = vOppForcastListByPartMap1.get(vOppPart.id);
            }
            
            system.debug('vOppFcstLstByPart in Qrtly Map:'+vOppFcstLstByPart);
            
            for(Opportunity_Forecast__c vOppFcstRec : vOppFcstLstByPart){
                system.debug('vOppFcstRec ----------------->'+vOppFcstRec);
                if(vForecastYear != vOppFcstRec.Fiscal_Year__c){
                    vForecastYearCounter +=1;
                    if(vForecastYearCounter > NUMBER_OF_FORECAST_YEARS){
                        break;
                    }
                    vForecastYear = vOppFcstRec.Fiscal_Year__c;                 
                }
                List<Opportunity_Forecast__c> vOppFcstLst = new List<Opportunity_Forecast__c>();           
            
                if(vOppForcastListByPartMap.containsKey(vOppPart.id)){
                    vOppFcstLst = vOppForcastListByPartMap.get(vOppPart.id);
                }
            
                vOppFcstLst.add(vOppFcstRec);
                vOppForcastListByPartMap.put(vOppPart.id , vOppFcstLst);
                system.debug('vOppForcastListByPartMap ------>'+vOppForcastListByPartMap);
            }
        
       }
        
    } 
    
     /*____________________________________________________________________________________________________________________
     | Purpose : Creates a Map of OpportunityPartId and related OpportunityForecast List.                                  |
     |_____________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                  |   
     | ____________________________________________________________________________________________________________________|     
     |  I1. Name        : pOppFcstLst                                                                                      | 
     |      Data Type   : List<Opportunity_Forecast__c>                                                                    | 
     |      Description : Opportunity Forecast List of all Opportunity parts.                                              | 
     |_____________________________________________________________________________________________________________________|                                                                                        |
     | Output Parameter : None                                                                                             |
     |____________________________________________________________________________________________________________________*/ 
    private static void createOppForecastMap1(List<Opportunity_Forecast__c> pOppFcstLst){
       /*-- D1. Primitive variable declaration --------------------------------------*/         
        
        for(Opportunity_Forecast__c vForecastYearRec: pOppFcstLst){           
                                           
            List<Opportunity_Forecast__c> vOppFcstLstByPart = new List<Opportunity_Forecast__c>();           
            
            if(vOppForcastListByPartMap1.containsKey(vForecastYearRec.Part__c)){
                vOppFcstLstByPart = vOppForcastListByPartMap1.get(vForecastYearRec.Part__c);
            }
            
            vOppFcstLstByPart.add(vForecastYearRec);
            vOppForcastListByPartMap1.put(vForecastYearRec.Part__c, vOppFcstLstByPart);
        }
    }       
    
    /*_____________________________________________________________________________________________________________________
     | Purpose : Creates a Map of FiscalyYear and related SalesPrice                                                       |
     |_____________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                  |
     | ____________________________________________________________________________________________________________________|     
     |  I1. Name        : pOppFcstLst                                                                                      | 
     |      Data Type   : List<Opportunity_Forecast__c>                                                                    | 
     |      Description : Opportunity Forecast List of all Opportunity parts.                                              | 
     |_____________________________________________________________________________________________________________________|                                                                                        |
     | Output Parameter : None                                                                                             |
     |____________________________________________________________________________________________________________________*/ 
    private static void CreateFYSalesPriceMap(List<Opportunity_part__c> pOppPartsLst){
      /*-- D1. Primitive variable declaration --------------------------------------*/
        
                     
        for(Opportunity_part__c vOppPartRec : pOppPartsLst){ 
            String vForecastYear;
            Integer vForecastYearCounter = 0 ;
            List<Opportunity_Forecast__c> vFcstLst = new List<Opportunity_Forecast__c>();
            
            if(vOppForcastListByPartMap1.containsKey(vOppPartRec.id)){
                vFcstLst =  vOppForcastListByPartMap1.get(vOppPartRec.id);
            }
            for(Opportunity_Forecast__c  vOppFcstRec: vFcstLst){
                if(vForecastYear != vOppFcstRec.Part__c+vOppFcstRec.Fiscal_Year__c){
                    vForecastYearCounter += 1;
                    if(vForecastYearCounter > NUMBER_OF_FORECAST_YEARS)
                        break;
                    vSalesPriceByFiscalYearMap.put(vOppFcstRec.part__c + vOppFcstRec.Fiscal_Year__c, vOppFcstRec.Sales_Price__c);
                    vForecastYear = vOppFcstRec.Part__c+vOppFcstRec.Fiscal_Year__c;             
                }   
            }    
                       
        }
    }
    
    /*_____________________________________________________________________________________________________________________
     | Purpose : Creates a Map of OpportunityPartId and related OpportunityForecast List                                   |
     |           by aggregating monthly Forecast Records to Quarterly .                                                    |
     |_____________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                  |
     |_____________________________________________________________________________________________________________________|     
     |  I1. Name        : pOppFcstLst                                                                                      | 
     |      Data Type   : List<Opportunity_Forecast__c>                                                                    | 
     |      Description : Opportunity Forecast List of all Opportunity parts.                                              | 
     |_____________________________________________________________________________________________________________________|                                                                                        |
     | I21. Name        : pOppPartsLst                                                                                     | 
     |      Data Type   : List<Opportunity_part__c>                                                                        | 
     |      Description : OpportunityParts List .                                                                          |
     |_____________________________________________________________________________________________________________________|
     | Output Parameter : None                                                                                             |
     |___________________________________________________________________________________________________________________*/ 
    private static void createQrtlyFcstMap(List<Opportunity_Forecast__c> pOppFcstLst, List<Opportunity_part__c> pOppPartsLst){      
       /*-- D1. Collection variable declaration --------------------------------------*/
        Set<Id> vPartsIdSet = new Set<Id>();
       /*-- D2. Primitive variable declaration --------------------------------------*/
        //String vForecastYear;
        //Integer vForecastYearCounter = 0 ;
        
        createOppForecastMap1(pOppFcstLst);
        
        system.debug('vOppForcastListByPartMap1 ******'+vOppForcastListByPartMap1);
        
        system.debug('pOppFcstLst *******:'+pOppFcstLst);
        CreateFYSalesPriceMap(pOppPartsLst);   
        system.debug('vSalesPriceByFiscalYearMap *********'+vSalesPriceByFiscalYearMap);  
        
        for(Opportunity_part__c part: pOppPartsLst){
            vPartsIdSet.add(part.id);
        }    
        
        // If a query includes a GROUP BY or HAVING clause, any currency data returned by using an aggregate function, such as SUM() or MAX(), 
        // is in the organization's default currency.
        // You cannot convert the result of an aggregate function into the user's currency by calling the convertCurrency() function.   
        AggregateResult[] vQrtlyGrpedFcstResult = [Select  CurrencyIsoCode, Part__c, Fiscal_Year__c, Fiscal_Quarter__c,
                                                    Sum( Amount__c) QrtlyAmt, Sum(Quantity__c) QrtlyQtty 
                                                    FROM Opportunity_Forecast__c  
                                                    Group By Fiscal_Year__c,Fiscal_Quarter__c,Part__c,CurrencyIsoCode 
                                                    having part__c in : vPartsIdSet
                                                    Order by Fiscal_Year__c 
                                                  ];  
        system.debug('vQrtlyGrpedFcstResult ********\n'+vQrtlyGrpedFcstResult);
        
        // Adding to forecast map 
        for(AggregateResult vQrtlyAR : vQrtlyGrpedFcstResult){                                  
            List<Opportunity_Forecast__c> vOppFcstLstByPart = new List<Opportunity_Forecast__c>();
            String vOppPartId = String.valueOf(vQrtlyAR.get('Part__c'));
            String vFiscalYear = String.valueOf(vQrtlyAR.get('Fiscal_Year__c'));
            String vPartFiscalYear =vOppPartId + vFiscalYear;                        
                      
            if(vOppForcastListByPartMap2.containsKey(vOppPartId)){
                vOppFcstLstByPart = vOppForcastListByPartMap2.get(vOppPartId);
            }
            Opportunity_Forecast__c vQrtFcstRec = new Opportunity_Forecast__c();            
            vQrtFcstRec.Part__c = vOppPartId;
            vQrtFcstRec.Fiscal_Year__c = vFiscalYear;
            vQrtFcstRec.Fiscal_Quarter__c = String.valueOf(vQrtlyAR.get('Fiscal_Quarter__c'));
            vQrtFcstRec.Amount__c = Double.valueOf(vQrtlyAR.get('QrtlyAmt'));
            vQrtFcstRec.Quantity__c = Integer.valueOf(String.valueOf((vQrtlyAR.get('QrtlyQtty'))));
            if(vSalesPriceByFiscalYearMap.containsKey(vOppPartId + vFiscalYear))
                vQrtFcstRec.Sales_Price__c = vSalesPriceByFiscalYearMap.get(vOppPartId + vFiscalYear);
            vQrtFcstRec.CurrencyIsoCode = String.valueOf(vQrtlyAR.get('CurrencyIsoCode'));
            
            vOppFcstLstByPart.add(vQrtFcstRec);             
            vOppForcastListByPartMap2.put(vOppPartId,vOppFcstLstByPart);
            System.Debug('vOppForcastListByPartMap------->\n' +vOppForcastListByPartMap);
            system.debug('vOppForcastListByPartMap2 ----->:'+vOppForcastListByPartMap2);           
         }            
         
        for(Opportunity_part__c vOppPartRec : pOppPartsLst){ 
                                             
            String vForecastYear;
            Integer vForecastYearCounter = 0 ;
            List<Opportunity_Forecast__c> vFcstLst = new List<Opportunity_Forecast__c>();
            
            if(vOppForcastListByPartMap2.containsKey(vOppPartRec.id)){
                vFcstLst =  vOppForcastListByPartMap2.get(vOppPartRec.id);
            }
            for(Opportunity_Forecast__c  vOppFcstRec: vFcstLst){
                if(vForecastYear != vOppFcstRec.Part__c+vOppFcstRec.Fiscal_Year__c){
                    vForecastYearCounter += 1;
                    if(vForecastYearCounter > NUMBER_OF_FORECAST_YEARS)
                        break;       
                    vForecastYear = vOppFcstRec.Part__c+vOppFcstRec.Fiscal_Year__c;             
                }
                
                List<Opportunity_Forecast__c> vOppFcstLst = new List<Opportunity_Forecast__c>();          
            
                if(vOppForcastListByPartMap.containsKey(vOppPartRec.id)){
                    vOppFcstLst = vOppForcastListByPartMap.get(vOppPartRec.id);
                }
        
                vOppFcstLst.add(vOppFcstRec);
                
                vOppForcastListByPartMap.put(vOppPartRec.id, vOppFcstLst);  
                system.debug('vOppForcastListByPartMap ^^^^^^^^^^^^^^^^^:'+vOppForcastListByPartMap);
            }          
         }      
    }
     /*____________________________________________________________________________________________________________________
     | Purpose : Get the List of fields from Custom seeting for the sObject type that is being passed as a parameter.      |
     |_____________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                  |
     |_____________________________________________________________________________________________________________________|
     |  I1. Name        : pObjectType                                                                                      |
     |      Data Type   : Schema.SObjectType                                                                               | 
     |      Description : Object Type of the sObject being passed.                                                         | 
     |_____________________________________________________________________________________________________________________| 
     | Output Parameter :                                                                                                  |
     |_____________________________________________________________________________________________________________________|
     |  O1. Name        : vObjectFieldLst                                                                                  |
     |      Data Type   : List<String>                                                                                     |
     |      Description : List of fields in the form of list of string. It may contain duplicate fields.                   |
     |____________________________________________________________________________________________________________________*/    
    public static List<String> getFieldList(Schema.SObjectType pObjectType) {
        /*-- D1. Collection variable declaration --------------------------------------*/
        List<String> vObjectFieldLst = new List<String>{};
        
        vLstRTSMapping = RTSMapping__c.getall().values();
        System.Debug('RTS Mapping Custom Setting values ------------>\n ' + vLstRTSMapping);
        if(vLstRTSMapping != null) {
            if(vLstRTSMapping.size() > 0) {
                for (RTSMapping__c rtsMapping : vLstRTSMapping) {
                    if(rtsMapping.Object_Name__c == pObjectType.getDescribe().getName()){
                        vObjectFieldLst.add(rtsMapping.API_Name__c);
                    }
                }   
            }
        }
        return vObjectFieldLst;
    }
     /*____________________________________________________________________________________________________________________
     | Purpose : Returns the List of sObject with field and their values.                                                  |
     |_____________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                  |
     |_____________________________________________________________________________________________________________________|
     |  I1. Name        : pObjectLst                                                                                       | 
     |      Data Type   : List<sObject>                                                                                    | 
     |      Description : List of sObject                                                                                  | 
     |  I2. Name        : pObjectType                                                                                      | 
     |      Data Type   : Schema.SObjectType                                                                               | 
     |      Description : Object Type of the sObject being passed.                                                         | 
     |_____________________________________________________________________________________________________________________| 
     | Output Parameter :                                                                                                  |
     |_____________________________________________________________________________________________________________________|
     |  O1. Name        : vObjectLst                                                                                       |
     |      Data Type   : List<sObject>                                                                                    |
     |      Description : List of sObject with fields and their respective values.                                         |
     |____________________________________________________________________________________________________________________*/
    public static List<sObject> getFieldValues(List<sObject> pObjectLst,Schema.SObjectType pObjectType){    
        /*-- D1. Collection variable declaration --------------------------------------*/
        Set<String> vObjectFieldSet = new Set<String>();
        List<Id> vObjectIdLst = new List<Id>{};
        List<String> vObjectFieldLst = new List<String>{};
        List<sObject> vObjectLst = new List<sObject>{};
        List<String> vObjUniqueFieldLst = new List<String>();
        
        vObjectFieldLst = getFieldList(pObjectType);
        //Converting List<String> to Set<String> so that all duplicate fields are removed.
        vObjectFieldSet.addAll(vObjectFieldLst); 
        //This List will contain all the unique field for the pObjectType that needs to be queried.
        vObjUniqueFieldLst.addAll(vObjectFieldSet);
        if (pObjectLst != null){
            if(pObjectLst.size() > 0) {     
                for (sObject vObjInst: pObjectLst){
                    vObjectIdLst.add(vObjInst.Id);
                }  
                if(vObjUniqueFieldLst != null){
                    if(vObjUniqueFieldLst.size() > 0) { 
                        String vQuery = 'SELECT CurrencyIsoCode, ' + vObjUniqueFieldLst.get(0);   
                        for (Integer i=1 ; i < vObjUniqueFieldLst.size() ; i++){
                                vQuery += ', ' + vObjUniqueFieldLst.get(i);
                        }  
                        vQuery += ' FROM ' + pObjectType.getDescribe().getName() + ' WHERE ID IN (\''
                                          + vObjectIdLst.get(0) + '\'';
                        for (Integer i=1 ; i < vObjectIdLst.size() ; i++){
                            vQuery += ', \'' + vObjectIdLst.get(i) + '\'';
                        }    
                        vQuery += ')';
                        System.Debug('vQuery---------> \n' + vQuery);    
                        try{             
                            for (SObject sObjectFromDatabase: Database.query(vQuery)){
                                vObjectLst.add(sObjectFromDatabase);     
                            } 
                        } 
                        catch (exception vException){ System.debug('Exception in getFieldValues : ' + vException.getMessage()); vObjectLst = null;}
                    }
                }
            }
        }         
        return vObjectLst;
    }
     /*_________________________________________________________________________________________________________________________________
     | Purpose : Generates the XML string for RTS record whose Id is being passed and Opportunity Parts realted to parent Opportunity.  |
     |__________________________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  I1. Name        : pRTSReqId                                                                                                     | 
     |      Data Type   : Id                                                                                                            | 
     |      Description : Id of RTS Request object for which XML needs to be generated.                                                 |
     |__________________________________________________________________________________________________________________________________|
     | Output Parameter :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  O1. Name        : vStrXml                                                                                                       |
     |      Data Type   : String                                                                                                        |
     |      Description : XML String generated.                                                                                         |
     |_________________________________________________________________________________________________________________________________*/
    public static string generateXML(Id pRTSReqId){
         /*-- D1. Collection variable declaration --------------------------------------*/
        Set<Id> vOpprntyIdSet = new Set<Id>();
        Map<Id,RTS_Request__c> vOppReqstTypeMap = new Map<Id,RTS_Request__c>();  
        List<sObject>           vSObjects;
        List<sObject>           vRTSFieldValues;
       
        /*-- D2. Object variable declaration -------------------------------------------*/
        RTS_Request__c          vRequest;
        sObject                 vSObject;
        /*-- D3. Primitive variable declaration ----------------------------------------*/ 
        String                  vStrXml = '';
        String                  vStrContactName = '';
        String                  vStrTitleName = '';
        
        
        vRTSFieldValues = new List<sObject>();
        if(pRTSReqId != null) {
            try{
                vRequest = [SELECT Id, CurrencyIsoCode, Request_Type__c, DTC_Customer_Contact_Name__c, DTC_Customer_Contact_Title__c, OpportunityName__c, OpportunityName__r.Owner.GIBU__c FROM  RTS_Request__c WHERE Id = :pRTSReqId];
                vOppReqstTypeMap.put(vRequest.OpportunityName__c, vRequest);
                
                if(vRequest != null) {
                    System.Debug('RTS Request Id ---------> \n' + vRequest.Id);
                    if(vRequest.OpportunityName__c != null) {
                        System.Debug('Opportunity Id ---------> \n' + vRequest.OpportunityName__c);
                        vOpprntyIdSet.add(vRequest.OpportunityName__c);
                    }
                    vSObject = (sObject) vRequest;
                    vSObjects = new List<sObject>{vSObject};
                    vRTSFieldValues = getFieldValues(vSObjects, vSObject.getSobjectType());
                    System.Debug('RTS Request Instance with field and values ---------> \n ' + vRTSFieldValues);
                    getExchangeRate();
                    vStrXml = createRtsPackage(vRTSFieldValues) + createItemsPackage(vOpprntyIdSet, vOppReqstTypeMap);
                } 
            } catch (exception vException){ System.debug('Exception  : ' + vException.getMessage()); system.debug(' Line Number ******:'+vException.getLineNumber()); system.debug('getStackTraceString ******:'+vException.getStackTraceString());}
        
            //*****Changes by Zensar Team: Toshi on 09/10/2014 for ESR form **************
            if(vRequest.Request_Type__c == 'Engineering Sample Request'){
                String vStrTemp = '';
                vStrTemp = vStrXml.substring(vStrXml.indexOf('<FormType>'),vStrXml.indexOf('</FormType>') + 11);
                vStrXml = vStrXml.replace(vStrTemp,'<FormType></FormType>');
                vStrTemp = vStrXml.substring(vStrXml.indexOf('<BusinessUnit>'),vStrXml.indexOf('</BusinessUnit>') + 15);
                vStrXml = vStrXml.replace(vStrTemp,'<BusinessUnit></BusinessUnit>');
            }
          
        System.Debug('XML output \n' + vStrXml);
       
        }
         return vStrXml;
        
    }
     /*_________________________________________________________________________________________________________________________________
     | Purpose : Generates the XML string for RTS record.                                                                               |
     |__________________________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  I1. Name        : pRTSFieldValues                                                                                               | 
     |      Data Type   : List<sObject>                                                                                                 | 
     |      Description : List of RTS Records with field and their rescpective values.                                                  |
     |__________________________________________________________________________________________________________________________________|
     | Output Parameter :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  O1. Name        : vRTSstrXml                                                                                                    |
     |      Data Type   : String                                                                                                        |
     |      Description : XML String generated for RTS Record.                                                                          |
     |_________________________________________________________________________________________________________________________________*/   
    private static string createRtsPackage(List<sObject> pRTSFieldValues){
        /*-- D1. Object variable declaration ------------------------------------------*/
        XmlStreamWriter vXsw;
        /*-- D2. Primitive variable declaration ---------------------------------------*/
        string          vRTSstrXml = '';
        
        vXsw = new XmlStreamWriter();
        vXsw.writeStartDocument('UTF-8', '1.0');
            vXsw.writeStartElement(null, 'RTS_PACKAGE', null);          // Start Element RTS_PACKAGE
                vXsw.writeStartElement(null, 'RTS_Request', null);          // Start Element RTS_Request
                outputNode(vXsw, 'Function', 'Create Request');
                buildXmlRequest(vXsw, pRTSFieldValues);
                outputRtsAttribNode(vXsw, 'SFDCORGID', UserInfo.getOrganizationId());
                vXsw.writeEndElement();                                     // End Element RTS_Request
            vXsw.writeEndElement();                                     // END Element RTS_PACKAGE
        vXsw.writeEndDocument();
        vRTSstrXml = vXsw.getXmlString();
        System.Debug('XML output of RTS Record \n' + vRTSstrXml);
        vXsw.close();
        return vRTSstrXml;
    }
     /*____________________________________________________________________________________________________________________
     | Purpose : Generates the XML string for List of Opportunity parts.                                                   |
     |_____________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                  |
     |_____________________________________________________________________________________________________________________|
     |  I1. Name        : pOpprntyIdSet                                                                                    | 
     |      Data Type   : Set<Id>                                                                                          | 
     |      Description : Set of Opportunity Id related to child RTS Request.                                              |
     |_____________________________________________________________________________________________________________________|
     | Output Parameter :                                                                                                  |
     |_____________________________________________________________________________________________________________________|
     |  O1. Name        : vItemStrXml                                                                                      |
     |      Data Type   : String                                                                                           |
     |      Description : XML String generated for Opportunity parts.                                                      |
     |____________________________________________________________________________________________________________________*/
    private static string createItemsPackage(Set<Id> pOpprntyIdSet, map<id,RTS_Request__c> vOpprntyReqstTypeMap){
        /*-- D1. Collection variable declaration --------------------------------------*/
        List<Opportunity> vOppWithPartsLst;
        List<sObject> vSObjects;
        List<sObject> vOppFieldValueLst;
        List<sObject> vPartSObjects;
        List<sObject> vOppPartFieldValueLst;
        List<sObject> vOppPartFieldValue;
        
        List<Opportunity_Forecast__c> vOppFcstLst = new List<Opportunity_Forecast__c>(); 
        /*-- D2. Object variable declaration ------------------------------------------*/
        XmlStreamWriter vXsw;
        sObject vPartSObject;
        /*-- D3. Primitive variable declaration ---------------------------------------*/
        string vItemStrXml = '';
        
        vOppWithPartsLst = new List<Opportunity>();
        vSObjects = new List<sObject>();
        vOppFieldValueLst = new List<sObject>();
        vPartSObjects = new List<sObject>();
        vOppPartFieldValueLst = new List<sObject>();
        vOppPartFieldValue = new List<sObject>();
        vXsw = new XmlStreamWriter();
         
        //Forecast variable declaration
        List<Opportunity_Forecast__c> vOppFcstLstByPart;
        vOppFcstLstByPart = new List<Opportunity_Forecast__c>();
        
        
        // DATACOMM Query+ Collection Variable..
        String vStartQueryString = ''; 
        String vEndQueryString = '';
        String vQueryString = '';
        List<Opportunity> vListOppOwner;
        Map<Id,String> vOppQueryMap = new Map<Id, String>();
        String vSendRTSTrue = 'Yes';
        String vSampleOnly= 'Sample Only';
        String vQuoteOnly = 'Quote Only';
        String vSampleNQuote = 'Sample & Quote';
        
       //****Basic Query Formation ******************* Changes made by Toshi from Zensar
        
        vStartQueryString = 'SELECT Id, CurrencyIsoCode, Level__c,(Select Name, CurrencyIsoCode, Opportunity__c, Amount__c, Fiscal_Quarter__c, Fiscal_Year_Quarter__c, Fiscal_Year__c, Forecasting_Start_Date__c, Part__c, Part__r.Send_to_RTS__c, Quantity__c, Sales_Price__c FROM Forecast__r WHERE Part__r.Send_to_RTS__c =: vSendRTSTrue Order By Part__c,Fiscal_Year__c, Fiscal_Year_Quarter__c),(SELECT Id, Send_to_RTS__c , CurrencyIsoCode FROM  Parts__r WHERE Send_to_RTS__c =: vSendRTSTrue ';
        vEndQueryString = 'ORDER BY Id) FROM  Opportunity WHERE Id in :pOpprntyIdSet';
        
        //****Split for bussiness ******************* Changes made by Toshi from Zensar
       
        vListOppOwner = [Select Id, Opportunity.Owner.GIBU__c From Opportunity where Id IN: pOpprntyIdSet];
        for(Opportunity oppinst: vListOppOwner){
            vQueryString = '';
            if((oppinst.Owner.GIBU__c == 'Data & Devices') || (oppinst.Owner.GIBU__c == 'Channel')){
                String vRequestType = vOpprntyReqstTypeMap.get(oppinst.id).Request_Type__c;
                if(vRequestType =='Engineering Quote Request')
                    vQueryString = vStartQueryString +'AND (DataCom_Request_Type__c =:vQuoteOnly OR DataCom_Request_Type__c =:vSampleNQuote) '+ vEndQueryString;
                
                if(vRequestType =='Engineering Sample Request')
                    vQueryString = vStartQueryString +'AND (DataCom_Request_Type__c =:vSampleOnly OR DataCom_Request_Type__c =:vSampleNQuote) '+ vEndQueryString;
            }
            else{
                
                vQueryString = vStartQueryString + vEndQueryString;
            }
            
        }
        
        
        if(pOpprntyIdSet != null && pOpprntyIdSet.size() > 0) {
        
            vOppWithPartsLst = Database.query(vQueryString);  
                       
            System.Debug('Opportunity with Opportunity Parts ------->' + vOppWithPartsLst); 
            if(vOppWithPartsLst != null) {
                if(vOppWithPartsLst.size() > 0 ){
                    sObject vSObject = (sObject) vOppWithPartsLst[0];
                    vSObjects = vOppWithPartsLst;
                    vOppFieldValueLst = getFieldValues(vSObjects,vSObject.getsObjectType());
                    System.Debug('Opportunity with fields and values ---------> \n' + vOppFieldValueLst);
                    vXsw.writeStartDocument('UTF-8', '1.0');
                    vXsw.writeStartElement(null, 'Items', null);                                // START Element of Items
                    for(Opportunity vOppInst: vOppWithPartsLst){
                        
                        //Added for Forecast List
                        vOppForecastLevel = vOppInst.Level__c;
                        vOppFcstLst = vOppInst.Forecast__r;
                        
                        if(vOppFcstLst != null){
                            if(vOppFcstLst.size()>0){
                                if(vOppForecastLevel != 'Monthly'){                             
                                    createOppForecastMap(vOppFcstLst,vOppInst.Parts__r);
                                }
                                else if(vOppForecastLevel == 'Monthly'){
                                    if(vOppInst.Parts__r != null){
                                        if(vOppInst.Parts__r.size() > 0){
                                            createQrtlyFcstMap(vOppFcstLst, vOppInst.Parts__r);
                                        }
                                    }
                                } 
                            } 
                        }                                        
                        
                        if(vOppInst.Parts__r != null) {                            
                            if(vOppInst.Parts__r.size() > 0) {                                
                                vPartSObject = (sObject) vOppInst.Parts__r[0];                                
                                vPartSObjects = vOppInst.Parts__r;                                
                                vOppPartFieldValueLst = getFieldValues(vPartSObjects,vPartSObject.getsObjectType());
                                
                                System.Debug('Opportunity Parts with fields and values ---------> \n' + vOppPartFieldValueLst);
                                
                                for(Integer i =0 ; i < vOppInst.Parts__r.size() ; i++) { 
                                    //Opportunity Forecast Logic    
                                    system.debug('vOppInst.Parts__r[i].id *******'+vOppInst.Parts__r[i].id);
                                    System.Debug('vOppForcastListByPartMap------->\n' +vOppForcastListByPartMap);
                                    system.debug('vOppForcastListByPartMap.get(vOppInst.Parts__r[i].id) *******'+vOppForcastListByPartMap.get(vOppInst.Parts__r[i].id));
                                    vOppFcstLstByPart = new List<Opportunity_Forecast__c>();                                
                                    if(vOppForcastListByPartMap != null){
                                        if(vOppForcastListByPartMap.size() > 0){
                                            if(vOppForcastListByPartMap.containsKey(vOppInst.Parts__r[i].id)){
                                                vOppFcstLstByPart = vOppForcastListByPartMap.get(vOppInst.Parts__r[i].id);
                                                system.debug('vOppFcstLstByPart Size *******'+vOppFcstLstByPart.size()+'vOppFcstLstByPart ffffffffff:'+vOppFcstLstByPart + 'vOppForcastListByPartMap MMMMMMMMMM:'+vOppForcastListByPartMap);
                                            }
                                        }
                                    }
                                    
                                    vOppPartFieldValue = new List<sObject>{vOppPartFieldValueLst[i]};
                                    vXsw.writeStartElement(null, 'Item', null);                         // START Element of Item
                                        outputNode(vXsw, 'Item_Id', vOppInst.Parts__r[i].Id);
                                        outputNode(vXsw, 'ParentSFDCOpportunity', vOppInst.Id);
                                        vXsw.writeStartElement(null, 'ItemAttributes', null);               // START Element of ItemAttributes
                                            buildXmlRequest(vXsw, vOppFieldValueLst);
                                            buildXmlRequest(vXsw, vOppPartFieldValue);
                                            // Forecat XML
                                            if(vOppFcstLstByPart != Null){
                                                if(vOppFcstLstByPart.size() > 0){
                                                    buildForecastXmlRequest(vXsw, vOppFcstLstByPart);
                                                }
                                            }                                            
                                        vXsw.writeEndElement();                                             // END Element of ItemAttributes
                                    vXsw.writeEndElement();                                             // END Element of Item
                                } 
                            }  
                        }                       
                    }
                }
            }
            vXsw.writeEndElement();                                                             // END Element of Items
            vXsw.writeEndDocument();
            vItemStrXml = vXsw.getXmlString();
        }    
        System.Debug('XML output of Item Record \n' + vItemStrXml);
        vXsw.close();
        return vItemStrXml;
    }
    
     /*_________________________________________________________________________________________________________________________________
     | Purpose : Builds the XML for List<sObject> which is passed as parameter.                                                         |
     |__________________________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  I1. Name        : pXsw                                                                                                          | 
     |      Data Type   : XmlStreamWriter                                                                                               | 
     |      Description : XmlStreamWriter.                                                                                              |
     |  I2. Name        : pObjectLst                                                                                                    | 
     |      Data Type   : List<sObject>                                                                                                 | 
     |      Description : List of sObjects with field and values                                                                        | 
     |__________________________________________________________________________________________________________________________________| 
     | Output Parameter : None.                                                                                                         |
     |_________________________________________________________________________________________________________________________________*/
    private static void buildXmlRequest(XmlStreamWriter pXsw, List<sObject> pObjectLst){
        /*-- D1. Collection variable declaration --------------------------------------*/
        List<String> vObjectFieldLst;
        Map<String, Schema.SObjectField> fieldMap;
        Map<String, String> resultMap;
        //Map<String,Double> vConversionRateMap;
        Set<String> vIsoCodes;
        
        /*-- D2. Primitive variable declaration ---------------------------------------*/
        string values;
        string fieldName;
        string myDtString;
        Double vConversionRate;
        Double vConversionRateUSD;
        
        vIsoCodes = new Set<String>();
        fieldMap = new Map<String, Schema.SObjectField>();
        resultMap = new Map<String, String>();
        //vConversionRateMap = new Map<String,Double>();
        
        vLstRTSMapping = RTSMapping__c.getall().values();
        System.Debug('RTS Mapping Custom Setting values ------------>\n ' + vLstRTSMapping);
        System.Debug('Object List with Field and Values ---------> \n ' + pObjectLst); 
        
        vObjectFieldLst = new List<String>{};
        
        if(pObjectLst != null) {
            System.Debug('Size of Object List with Field and Values ---------> \n ' + pObjectLst.size()); 
            if(pObjectLst.size() > 0) {
                Schema.SObjectType vObjectType = pObjectLst[0].getsObjectType();
                System.Debug('Type of Object ---------> \n ' + vObjectType);
                vObjectFieldLst = getFieldList(vObjectType);
                if(vObjectFieldLst != null) {
                    if(vObjectFieldLst.size() > 0) {
                        System.Debug('List of Fields in ' + vObjectType + ' ---------> \n ' + vObjectFieldLst);
                        fieldMap = pObjectLst[0].getSObjectType().getDescribe().fields.getMap();
                        
                        for(sobject sinst : pObjectLst){
                            System.Debug('Object Instance ---------> \n' + sinst);
                            for(String field : vObjectFieldLst ){
                                fieldName = field;
                                System.Debug('Name of Field ---------> \n ' + fieldName);
                                Schema.DisplayType vFieldDataType = fieldMap.get(field).getDescribe().getType();
                                System.Debug('Data Type of '+ fieldName + ' ---------> \n ' + vFieldDataType);
                                
                                if(vFieldDataType == Schema.DisplayType.DOUBLE){
                                    system.debug('Double value :'+ fieldName + sinst.get(field));
                                    if(sinst.get(field)!=null){
                                        Decimal d = Double.valueOf(sinst.get(field));
                                        Integer vDecimalPlaces = fieldMap.get(field).getDescribe().getScale();
                                        system.debug('Scale ********'+vDecimalPlaces);
                                        system.debug('Field Name:'+fieldName + 'getScale ****'+fieldMap.get(field).getDescribe().getScale());                               
                                        if(vDecimalPlaces > 0){                                   
                                            values = String.valueOf(d.setScale(vDecimalPlaces));
                                        }
                                        else values = String.valueOf(sinst.get(field));
                                    }
                                    else values = null;
                                }
                                else if(vFieldDataType == Schema.DisplayType.DATETIME || vFieldDataType == Schema.DisplayType.DATE){
                                    if(sinst.get(field) !=null){
                                        Datetime myDate = DateTime.valueOf(String.valueOf(sinst.get(field)));
                                        // This will format date or date/time field into Date format MM/dd/yyyy
                                        myDtString = myDate.format('MM/dd/yyyy');
                                        values = myDtString;
                                        System.Debug('Date value---------> \n ' + values);
                                    }
                                    // check if date is null 
                                    else{
                                        values = null;
                                    }
                                }
                                else if(vFieldDataType == Schema.DisplayType.Boolean) {
                                    if(String.valueOf(sinst.get(field)) == 'true')
                                        values = String.valueOf(1);
                                    else
                                        values = String.valueOf(0);
                                }
                                
                                else if(vFieldDataType == Schema.DisplayType.CURRENCY) {
                                    if(sinst.get(field) !=null){
                                        System.debug('Current iso code currency ----> \n' + sinst.get('CurrencyIsoCode'));
                                        if(String.valueOf(sinst.get('CurrencyIsoCode')) <> 'USD') {
                                            System.Debug('Map of ISO Codes and their respective Conversion Rates---------> \n' + vConversionRateMap);
                                            //Convert incoming Amount into USD
                                            vConversionRate = vConversionRateMap.get(String.valueOf(sinst.get('CurrencyIsoCode')));
                                            vConversionRateUSD = vConversionRateMap.get('USD');
                                                                                        
                                            Decimal d = (Double.valueOf(sinst.get(field)) * vConversionRateUSD) / vConversionRate ;
                                            Integer vDecimalPlaces = fieldMap.get(field).getDescribe().getScale();
                                            values = String.valueOf(d.setScale(vDecimalPlaces));
                                            system.debug('Currency Decimal plcaces ****'+'Field Name:'+fieldName + sinst.get(field));
                                                                                        
                                            System.Debug('Value of CURRENCY field In ' + sinst.get('CurrencyIsoCode') + ' is ---------> \n' + String.valueOf(sinst.get(field)));
                                            System.Debug('Value of CURRENCY field In USD is ---------> \n' + values);
                                        }
                                        else{
                                            values = String.valueOf(sinst.get(field));
                                        }
                                    }
                                    else
                                        values = String.valueOf(sinst.get(field));
                                }
                                else{
                                    system.debug('Value before converting String '+fieldName +sinst.get(field));
                                    values = String.valueOf(sinst.get(field));
                                    System.Debug('Value of' + fieldName + ' is ---------> \n' + values);
                                }
                                resultMap.put(fieldName, values);
                            }
                            System.Debug('Map of Fields and their respective Values---------> \n' + resultMap);
                            if(vLstRTSMapping != null) {
                                if(vLstRTSMapping.size() > 0) {
                                    for (RTSMapping__c rtsMapping : vLstRTSMapping) {
                                        //if(resultMap != null && resultMap.containsKey(rtsMapping.API_Name__c) && rtsMapping.Object_Name__c == vObjectType.getDescribe().getName()){
                                        if(resultMap != null && resultMap.containsKey(rtsMapping.API_Name__c) && rtsMapping.Object_Name__c == 'RTS_Request__c'){
                                            if     (!rtsMapping.isProgramAttribute__c && !rtsMapping.isItemAttribute__c ){
                                                    outputNode(pXsw, rtsMapping.Code__c, resultMap.get(rtsMapping.API_Name__c));
                                            }
                                        }
                                    }
                                    for (RTSMapping__c rtsMapping : vLstRTSMapping) {
                                        if(resultMap != null && resultMap.containsKey(rtsMapping.API_Name__c) && rtsMapping.Object_Name__c == vObjectType.getDescribe().getName()){
                                            if(rtsMapping.isProgramAttribute__c && !rtsMapping.isItemAttribute__c  ){
                                                    outputRtsAttribNode(pXsw, rtsMapping.Code__c, resultMap.get(rtsMapping.API_Name__c));
                                            }
                                            else if(!rtsMapping.isProgramAttribute__c && rtsMapping.isItemAttribute__c  ){
                                                    outputItemsAttribNode(pXsw, rtsMapping.Code__c, resultMap.get(rtsMapping.API_Name__c));
                                            }
                                        }
                                    }   
                                } 
                            }
                        } 
                    }
                }
            }
        }
    } // end of buildXmlRequest
    
    /*_________________________________________________________________________________________________________________________________
     | Purpose : Builds the Forecast XML for List<Opportunity_Forecast__c> which is passed as parameter.                                |
     |__________________________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  I1. Name        : pXsw                                                                                                          | 
     |      Data Type   : XmlStreamWriter                                                                                               | 
     |      Description : XmlStreamWriter.                                                                                              |
     |  I2. Name        : pOppFcstLst                                                                                                   | 
     |      Data Type   : List<Opportunity_Forecast__c>                                                                                 | 
     |      Description : List of Opportunity Forecast Records                                                                          | 
     |__________________________________________________________________________________________________________________________________| 
     | Output Parameter : None.                                                                                                         |
     |_________________________________________________________________________________________________________________________________*/
    
    public static void buildForecastXmlRequest(XMLStreamWriter pXsw, List<Opportunity_Forecast__c> pOppFcstLst){        
       /*-- D1. Primitive variable declaration ---------------------------------------*/
        String  vForecastYearCode = 'FORECASTYEAR';
        String  vFCFY = 'FC_FY';    
        String  vPriceCode = 'PRICE';
        String  vAmt = 'AMT';
        String  vQty = 'QTY';
        String  vFiscalYear;
        String  vFYQrt;
        Integer vFYCounter = 0; 
        
        Double vLocalCurConversionRate; 
        Double vUSDConversionRate;          
        
        for(Integer i = 0; i < pOppFcstLst.size(); i++){
            String vSalesPrice;
            String vAmount;
            String vCurIsoCode = String.valueOf(pOppFcstLst[i].get('CurrencyISOCode'));
            system.debug('vCurIsoCode *******:'+vCurIsoCode);                   
            
            if(vCurIsoCode != 'USD' && vCurIsoCode != Null){
                vLocalCurConversionRate = vConversionRateMap.get(vCurIsoCode);
                vUSDConversionRate      = vConversionRateMap.get('USD');             
            
                Decimal vDecimalValue  = (Double.valueOf(pOppFcstLst[i].Sales_Price__c) * vUSDConversionRate) / vLocalCurConversionRate ;
                Integer vDecimalPlaces = Opportunity_Forecast__c.Sales_Price__c.getDescribe().getScale();
                vSalesPrice            = String.valueOf(vDecimalValue.setScale(vDecimalPlaces));
                
                if(vOppForecastLevel == 'Monthly'){
                    vAmount     = String.valueOf(pOppFcstLst[i].Amount__c);
                }
                else {                  
                    vDecimalValue  = (Double.valueOf(pOppFcstLst[i].Amount__c) * vUSDConversionRate)/ vLocalCurConversionRate;
                    vDecimalPlaces = Opportunity_Forecast__c.Amount__c.getDescribe().getScale();
                    vAmount        = String.valueOf(vDecimalValue.setScale(vDecimalPlaces));
                }
            }
            else {
                vSalesPrice = String.valueOf(pOppFcstLst[i].Sales_Price__c);
                vAmount     = String.valueOf(pOppFcstLst[i].Amount__c);
            }               
            
            system.debug('Forecast Record ************'+i+pOppFcstLst[i]);
            if(vFiscalYear != pOppFcstLst[i].Fiscal_Year__c){
                vFiscalYear = pOppFcstLst[i].Fiscal_Year__c;
                vFYCounter += 1;
                outputItemsAttribNode(pXsw, vForecastYearCode + vFYCounter, pOppFcstLst[i].Fiscal_Year__c);
                outputItemsAttribNode(pXsw, vFCFY + vFYCounter+ '_' +vPriceCode, vSalesPrice);
            }
            system.debug('Fiscal year Quarter *******:'+pOppFcstLst[i].Fiscal_Quarter__c);
            if(pOppFcstLst[i].Fiscal_Quarter__c == '01'){
                vFYQrt = 'Q1';
            }
            else if(pOppFcstLst[i].Fiscal_Quarter__c == '02'){
                vFYQrt = 'Q2';
            }
            else if(pOppFcstLst[i].Fiscal_Quarter__c == '03'){
                vFYQrt = 'Q3';
            }
            else if(pOppFcstLst[i].Fiscal_Quarter__c == '04'){
                vFYQrt = 'Q4';
            }
            outputItemsAttribNode(pXsw, vFCFY + vFYCounter + '_'+vFYQrt + '_'+vAmt, vAmount);
            outputItemsAttribNode(pXsw, vFCFY + vFYCounter + '_'+vFYQrt + '_'+vQty, String.valueOf(pOppFcstLst[i].Quantity__c));
            
        }
    }// end of buildForecastXmlRequest()
    
    
     /*_________________________________________________________________________________________________________________________________
     | Purpose : Build XML Node element.                                                                                                |
     |__________________________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  I1. Name        : pXsWriter                                                                                                     | 
     |      Data Type   : XmlStreamWriter                                                                                               | 
     |      Description : XmlStreamWriter instance.                                                                                     |
     |  I2. Name        : pStrNodeName                                                                                                  | 
     |      Data Type   : String                                                                                                        | 
     |      Description : Node name                                                                                                     | 
     |  I3. Name        : pStrNodeValue                                                                                                 | 
     |      Data Type   : String                                                                                                        | 
     |      Description : Node Value                                                                                                    | 
     |__________________________________________________________________________________________________________________________________| 
     | Output Parameter : None.                                                                                                         |
     |_________________________________________________________________________________________________________________________________*/
    public static void outputNode(XmlStreamWriter pXsWriter, string pStrNodeName, string pStrNodeValue){
        pXsWriter.writeStartElement(null, pStrNodeName, null);
        if (pStrNodeValue != null && pStrNodeValue.length() > 0)
            pXsWriter.writeCharacters(pStrNodeValue);
        pXsWriter.writeEndElement();   
    }
     /*_________________________________________________________________________________________________________________________________
     | Purpose : Build XML ProgramAttribute element.                                                                                    |
     |__________________________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  I1. Name        : pXsWriter                                                                                                     | 
     |      Data Type   : XmlStreamWriter                                                                                               | 
     |      Description : XmlStreamWriter instance.                                                                                     |
     |  I2. Name        : pAttribCode                                                                                                   | 
     |      Data Type   : String                                                                                                        | 
     |      Description : Attribute name                                                                                                | 
     |  I3. Name        : pStrAttribValue                                                                                               | 
     |      Data Type   : String                                                                                                        | 
     |      Description : Attribute Value                                                                                               | 
     |__________________________________________________________________________________________________________________________________| 
     | Output Parameter : None.                                                                                                         |
     |_________________________________________________________________________________________________________________________________*/
    private static void outputRtsAttribNode(XmlStreamWriter pXsWriter, string pAttribCode, string pStrAttribValue){
        pXsWriter.writeStartElement(null, 'ProgramAttribute', null); // Start Element of ProgramAttribute
        
            pXsWriter.writeStartElement(null, 'Code', null);            // Start Element of Code
            pXsWriter.writeCharacters(pAttribCode);
            pXsWriter.writeEndElement();                                // End   Element of Code
            
            pXsWriter.writeStartElement(null, 'Value', null);           // Start Element of Value
            if (pStrAttribValue != null && pStrAttribValue.length() > 0)
                pXsWriter.writeCharacters(pStrAttribValue);
            pXsWriter.writeEndElement();                                // End   Element of Value
            
        pXsWriter.writeEndElement();                                 // End   Element of ProgramAttribute
    }
     /*_________________________________________________________________________________________________________________________________
     | Purpose : Build XML ItemAttribute element.                                                                                       |
     |__________________________________________________________________________________________________________________________________|
     | Input Parameter  :                                                                                                               |
     |__________________________________________________________________________________________________________________________________|
     |  I1. Name        : pXsWriter                                                                                                     | 
     |      Data Type   : XmlStreamWriter                                                                                               | 
     |      Description : XmlStreamWriter instance.                                                                                     |
     |  I2. Name        : pAttribName                                                                                                   | 
     |      Data Type   : String                                                                                                        | 
     |      Description : Attribute Name                                                                                                | 
     |  I3. Name        : pStrAttribValue                                                                                               | 
     |      Data Type   : String                                                                                                        | 
     |      Description : Attribute Value                                                                                               | 
     |__________________________________________________________________________________________________________________________________| 
     | Output Parameter : None.                                                                                                         |
     |_________________________________________________________________________________________________________________________________*/
    private static void outputItemsAttribNode(XmlStreamWriter pXsWriter, string pAttribName, string pStrAttribValue){
        pXsWriter.writeStartElement(null, 'ItemAttribute', null);    // Start Element of ItemAttribute
        
            pXsWriter.writeStartElement(null, 'Code', null);            // Start Element of Code
            pXsWriter.writeCharacters(pAttribName);
            pXsWriter.writeEndElement();                                // End   Element of Code
            
            pXsWriter.writeStartElement(null, 'Value', null);           // Start Element of Value 
            if (pStrAttribValue != null && pStrAttribValue.length() > 0)
                pXsWriter.writeCharacters(pStrAttribValue);
            pXsWriter.writeEndElement();                                // End   Element of Value 
            
        pXsWriter.writeEndElement();                                 // End   Element of ItemAttribute
    }
}