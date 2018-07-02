/**********************************************************************
Name:  ADMEntryScreenHelper
Copyright © 2017
======================================================
======================================================
Purpose: 
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL Description
1.0          Suresh Aepoor         08/08/2017       INITIAL DEVELOPMENT
***********************************************************************/
public class ADMEntryScreenHelper  {     
    //This method reused in ADMentryscreen and ADMForecasting page fetching forecast records based on user fileter selection
    public static List<Forecast__c> getforecastrec(String Available, String SoldToCustomer, String WWCustmName, String WWC_Num, String Region, String district, String sbuval, String userid, String usertype, String CurrentUserid, String SoldToCustomerNum,String CBC3Values, integer limitQuery, integer offset, String forecastType) {
        try {
            Set<Id> ManagersSHSet = new  Set<Id>();   
            //Retrieving level 1 territory details from custom setting
            ADMTerritoryCode__c Level1Territory = ADMTerritoryCode__c.getInstance('ADMTerritoryCode');
            String Level1TCode = Level1Territory.Territory_Code__c;
            //String Level1TName = Level1Territory.Level1TerritoryName__c;
            String HierarchyType = Level1Territory.Hierarchy_Type__c; 
            System.Debug('HierarchyType :'+HierarchyType +'******'+Level1TCode);
            //quering sales hirarchy records checking loggedin user availble in different levels or not if available adding that record ito set
            List<Sales_Hierarchy__c> SalesHRecordsList = new List<Sales_Hierarchy__c>();
            SalesHRecordsList = [SELECT id,Name,Level_7_Territory_Code__c,Level_7_Assigned_User_Network_Ids__c,Level_7_Assigned_Users__c,Level_6_Assigned_User_Network_Ids__c,Level_6_Assigned_Users__c,Level_5_Assigned_User_Network_Ids__c,Level_5_Assigned_Users__c,Level_4_Assigned_User_Network_Ids__c,Level_4_Assigned_Users__c,Level_3_Assigned_User_Network_Ids__c,Level_3_Assigned_Users__c,Level_2_Assigned_User_Network_Ids__c,Level_2_Assigned_Users__c,Level_1_Assigned_User_Network_Ids__c,Level_1_Assigned_Users__c FROM Sales_Hierarchy__c
                                 WHERE Hierarchy_Type__c =: HierarchyType AND Level_1_Territory_Code__c =: Level1TCode];
            System.Debug('SalesHRecordsList :'+SalesHRecordsList);
            System.Debug('SalesHRecordsListSize :'+SalesHRecordsList.Size());
            if(SalesHRecordsList.Size() > 0) {
                for(Sales_Hierarchy__c sh: SalesHRecordsList) {
                    if(!String.IsBlank(sh.Level_6_Assigned_Users__c) /*&& sh.Level_6_Assigned_Users__c.Contains(';')*/) {
                        //for(String Level6AssignedUsers: sh.Level_6_Assigned_Users__c.Split(';'))  {
                            if(sh.Level_6_Assigned_Users__c.Contains(CurrentUserid)) {
                                ManagersSHSet.add(sh.id);  
                                //break;                     
                            }
                        //} 
                    }
                    if(!String.IsBlank(sh.Level_5_Assigned_Users__c) /*&& sh.Level_5_Assigned_Users__c.Contains(';')*/) {
                        //for(String Level5AssignedUsers: sh.Level_5_Assigned_Users__c.Split(';'))  {
                            if(sh.Level_5_Assigned_Users__c.Contains(CurrentUserid)) {
                                ManagersSHSet.add(sh.id);    
                                //break;                   
                            }
                        //} 
                    }
                    if(!String.IsBlank(sh.Level_4_Assigned_Users__c) /*&& sh.Level_4_Assigned_Users__c.Contains(';')*/) {
                        //for(String Level4AssignedUsers: sh.Level_4_Assigned_Users__c.Split(';'))  {
                            if(sh.Level_4_Assigned_Users__c.Contains(CurrentUserid)) {
                                ManagersSHSet.add(sh.id);  
                                //break;                      
                            }
                        //} 
                    }
                    if(!String.IsBlank(sh.Level_3_Assigned_Users__c) /*&& sh.Level_3_Assigned_Users__c.Contains(';')*/) {
                        //for(String Level3AssignedUsers: sh.Level_3_Assigned_Users__c.Split(';'))  {
                            if(sh.Level_3_Assigned_Users__c.Contains(CurrentUserid)) {
                                ManagersSHSet.add(sh.id);  
                                //break;                     
                            }
                        //} 
                    }
                    if(!String.IsBlank(sh.Level_2_Assigned_Users__c) /*&& sh.Level_2_Assigned_Users__c.Contains(';')*/) {
                        //for(String Level2AssignedUsers: sh.Level_2_Assigned_Users__c.Split(';'))  {
                            if(sh.Level_2_Assigned_Users__c.Contains(CurrentUserid)) {
                                ManagersSHSet.add(sh.id);   
                                //break;                     
                            }
                        //} 
                    }
                    if(!String.IsBlank(sh.Level_1_Assigned_Users__c) /*&& sh.Level_1_Assigned_Users__c.Contains(';')*/) {
                        //for(String Level1AssignedUsers: sh.Level_1_Assigned_Users__c.Split(';'))  {
                            if(sh.Level_1_Assigned_Users__c.Contains(CurrentUserid)) {
                                ManagersSHSet.add(sh.id);  
                                //break;                      
                            }
                        //} 
                    }            
                }
            }
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMEntryScreenHelper', 'getforecastrec','');
            return null;  
        }           
        List<Account> AmHierarchylist =new List<Account>();
        List<Forecast__c> ForecastList = new List<Forecast__c>();
        List<Forecast_Detail__c> forecastDetailList = new List<Forecast_Detail__c>();
        try {
            //Forecast object dynamic soql query based on user filter criteria
            String query = ' SELECT Id,Name,Profit_Center__c,CBC2_Description__c,CBC3_Description__c,GPL__r.CBC2_Description__c,GPL__r.CBC3_Description__c,GPL__r.CBC4_Description__c,External_ID__c,Forecast_Level__c,GPL__c,GPL__r.name,GPL__r.GPL_Description__c,Type__c, (SELECT Id,Parent_Forecast__r.Name,Parent_Forecast__r.GPL__c,Parent_Forecast__r.GPL__r.GPL_Description__c,Parent_Forecast__r.Sold_To_Customer__c, Parent_Forecast__r.Type__c,Parent_Forecast__r.Accountid__r.Worldwide_Customer__c,Total__c,Type__c ,Period__c,M1__c,M2__c,M3__c,M4__c, '+
                ' M5__c ,M6__c ,M7__c ,M8__c ,M9__c ,M10__c ,M11__c ,M12__c,Q1__c,Q2__c,Q3__c,Q4__c,LastModifiedDate, LastModifiedBy.Name FROM Forecast_Details__r), Accountid__r.AccountNumber, Accountid__r.BillingCountry,Accountid__r.BillingState,Accountid__r.BillingCity,Accountid__r.Name, Accountid__r.Account_Type__c,Accountid__r.WWCORPACCTNM__c, Accountid__r.WWCORPACCT__c,Accountid__r.LAYER2_ORGANIZATION_ID__c,Accountid__r.LAYER2_ORGANIZATION_LONG_NM__c, Accountid__r.LAYER3_ORGANIZATION_ID__c,Accountid__r.LAYER3_ORGANIZATION_LONG_NM__c,'+
                ' Accountid__r.Sales_Hierarchy__r.Level_7_Territory_Name__c,Region__c,Region_Description__c ,District_Description__c, AccountId__r.Account_Manager__r.Te_Network_Id__c ,AccountId__r.Sales_Hierarchy__r.Level_2_Assigned_User_Names__c ,AccountId__r.Sales_Hierarchy__r.Level_3_Assigned_User_Names__c,Worldwide_Account_Name__c,Worldwide_Account_Number__c FROM Forecast__c ';
            
            Id ADMRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
            //append 'where' condition to query if any one or more of search parameters has/have value/s
            query += 'WHERE RecordTypeId =: ADMRecordTypeId ';
            
            if(forecastType !='' && forecastType != null){
                
                query += 'AND Type__c =\'' + forecastType + '\' '; 
            }
            
            //apend below parameters to query when user selects OEM radio button
            if(Available !='' && Available !=null) {
                if(Available =='OEM')    {
                
                    ADM_Custom_Setting__c OEMForecastLevel = ADM_Custom_Setting__c.getInstance('ADM_OEMForecastLevel');
                    String ADMOEMForecastLevel = OEMForecastLevel.Value__c;
                    
                    ADM_Custom_Setting__c SEngineer = ADM_Custom_Setting__c.getInstance('ADMSalesEngineer');
                    String SalesEngineer = SEngineer.Value__c;
              
                    ADM_Custom_Setting__c SEngineerMgnr = ADM_Custom_Setting__c.getInstance('ADMSalesEngineerManager');
                    String SalesEngineerManager = SEngineerMgnr.Value__c;
       
                    ADM_Custom_Setting__c RegionalMgnr = ADM_Custom_Setting__c.getInstance('ADMRegionalManager');
                    String RegionalManager = RegionalMgnr.Value__c;       
       
                    query += 'AND Forecast_Level__c =\'' + ADMOEMForecastLevel + '\' '; 
                    if(sbuval !='' && sbuval !=null && sbuval.length() > 2)
                    {
                        sbuval = sbuval.replaceAll(', ', '\',\'');
                        sbuval = sbuval.remove('[');
                        sbuval = sbuval.remove(']');
                        query += 'AND Profit_Center__c IN (\'' + sbuval + '\') ';    
                    }
                    if(CBC3Values !='' && CBC3Values !=null && CBC3Values.length() > 2)
                    {
                        CBC3Values = CBC3Values.replaceAll(', ', '\',\'');
                        CBC3Values = CBC3Values.remove('[');
                        CBC3Values = CBC3Values.remove(']');
                        query += 'AND GPL__r.CBC3__c IN (\'' + CBC3Values + '\') ';    
                    }          
                    if(SoldToCustomer !='' && SoldToCustomer !=null)
                    {
                        query += 'AND Accountid__r.Id =\'' + SoldToCustomer + '\' ';   
                    }
                    if(SoldToCustomerNum !='' && SoldToCustomerNum !=null)
                    {
                        String SoldToCustNum ='\'%' + SoldToCustomerNum + '%\'';   
                        query += 'AND Accountid__r.AccountNumber LIKE '+ SoldToCustNum ;    
                    }
                    if(WWCustmName !='' && WWCustmName !=null)
                    {
                        //Account acc = [SELECT Id,Name,WWCORPACCTNM__c FROM Account WHERE Id =: WWCustmName LIMIT 1];                    
                        //String WWCustomerName = acc.WWCORPACCTNM__c;
                        String WWCustomerName ='\'%' + WWCustmName + '%\''; 
                        query += 'AND Accountid__r.WWCORPACCTNM__c LIKE '+ WWCustomerName ;   
                    }
                    if(WWC_Num !='' && WWC_Num !=null)
                    {
                        query += 'AND Accountid__r.WWCORPACCT__c =\'' + WWC_Num + '\' ';   
                    }         
                    if(Region !='' && Region !=null && Region.length() > 2)
                    {
                        Region = Region.replaceAll(', ', '\',\'');
                        Region = Region.remove('[');
                        Region = Region.remove(']');                
                        query += 'AND Accountid__r.LAYER2_ORGANIZATION_ID__c IN (\'' + Region + '\')';
                    }
                    System.debug('didtrict'+ district);
                    if(district !='' && district !=null && district.length() > 2)
                    {
                        district = district.replaceAll(', ', '\',\'');
                        district = district.remove('[');
                        district = district.remove(']');                 
                        query += 'AND Accountid__r.LAYER3_ORGANIZATION_ID__c IN (\'' + District + '\') ';
                    }
                    if(userid  !='' && userid !=null)
                    {
                        query += ' AND AccountId__r.Account_Manager__r.Te_Network_Id__c =\'' + userid + '\' ';   
                    }                                                          
                    if((usertype !='' && usertype !=null) && (CurrentUserid !='' && CurrentUserid !=null) && (usertype == SalesEngineer)) 
                    {
                        query += 'AND Accountid__r.Account_Manager__c =\'' + CurrentUserid + '\' ';     
                        System.Debug('querySaleshirarchy : '+query);
                    }
                    if((usertype !='' && usertype !=null) && (usertype == SalesEngineerManager || usertype == RegionalManager))
                    {
                        query += 'AND Accountid__r.Sales_Hierarchy__c IN : ManagersSHSet ';    
                    }                                                         
                }        
                //apend below parameters to query when user selects 'Distributor' radio button
                else if(Available =='Distributor')  {
                
                    ADM_Custom_Setting__c DISTYForecastLevel = ADM_Custom_Setting__c.getInstance('ADM_DISTYForecastLevel');
                    String ADMDISTYForecastLevel = DISTYForecastLevel.Value__c;

                    query += 'AND Forecast_Level__c =\'' + ADMDISTYForecastLevel + '\' '; 
                    if(sbuval !='' && sbuval !=null && sbuval.length() > 2) {
                        sbuval = sbuval.replaceAll(', ', '\',\'');
                        sbuval = sbuval.remove('[');
                        sbuval = sbuval.remove(']');
                        query += 'AND Profit_Center__c IN (\'' + sbuval + '\') ';   
                    }
                    if(CBC3Values !='' && CBC3Values !=null && CBC3Values.length() > 2)
                    {
                        CBC3Values = CBC3Values.replaceAll(', ', '\',\'');
                        CBC3Values = CBC3Values.remove('[');
                        CBC3Values = CBC3Values.remove(']');
                        query += 'AND CBC3__c IN (\'' + CBC3Values + '\') ';    
                    }
                    /*if(SoldToCustomer !='' && SoldToCustomer !=null)
                    {
                        query += 'AND Accountid__r.Id =\'' + SoldToCustomer + '\' ';   
                    }
                    if(SoldToCustomerNum !='' && SoldToCustomerNum !=null)
                    {
                        query += 'AND Accountid__r.AccountNumber =\'' + SoldToCustomerNum + '\' ';   
                    }*/
                    if(WWCustmName !='' && WWCustmName !=null)
                    {
                        //Account acc = [SELECT Id,Name FROM Account WHERE Id =: WWCustmName LIMIT 1];
                        //String WWCustomerName = acc.Name;
                        String WWCustomerName ='\'%' + WWCustmName + '%\'';
                        query += 'AND Worldwide_Account_Name__c LIKE '+ WWCustomerName ;   
                    }
                    if(WWC_Num !='' && WWC_Num !=null)
                    {
                        query += 'AND Worldwide_Account_Number__c =\'' + WWC_Num + '\' ';   
                    }
                    if(Region !='' && Region !=null && Region.length() > 2)
                    {
                        Region = Region.replaceAll(', ', '\',\'');
                        Region = Region.remove('[');
                        Region = Region.remove(']');
                        query += 'AND Region__c IN (\'' + Region + '\') ';             
                    }
                    if(district !='' && district !=null && district.length() > 2)
                    {
                        district = district.replaceAll(', ', '\',\'');
                        district = district.remove('[');
                        district = district.remove(']');
                        query += 'AND District__c IN (\'' + district + '\') ';  
                    }                         
                    if(userid  !='' && userid !=null)
                    {
                        query += 'AND AccountId__r.Account_Manager__r.Te_Network_Id__c =\'' + userid + '\' ';   
                    }                                                                 
                }   
        }    
            ForecastList = Database.query(query + ' LIMIT  '+ limitQuery + ' offset '+ offset); 
            System.Debug('query:'+query);
            System.Debug('ForecastList ::'+ForecastList);
            return ForecastList;       
        }
        catch(ExternalObjectException e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMEntryScreenHelper', 'getforecastrec','');
            return null;  
        }      
    }
    //Get Monthly actuals from external object// 
   @TestVisible private static List<MonthlyActualSales__x> mockedRequests = new List<MonthlyActualSales__x>();
    public static List<MonthlyActualSales__x> getExMonthlyActualSales(Set<String> forecastexids){
        List<MonthlyActualSales__x> ExtMonthlyActuals= new List<MonthlyActualSales__x>();   
        try{                                   
            ExtMonthlyActuals = [SELECT FISCAL_YEAR_ID__c,M1_AMOUNT__c,M2_AMOUNT__c,M3_AMOUNT__c,M4_AMOUNT__c,M5_AMOUNT__c,M6_AMOUNT__c,M7_AMOUNT__c,M8_AMOUNT__c,M9_AMOUNT__c,M10_AMOUNT__c,M11_AMOUNT__c,M12_AMOUNT__c,SFDC_EXTERNAL_ID__c,YEARLYTOT_AMOUNT__c FROM MonthlyActualSales__x WHERE SFDC_EXTERNAL_ID__c IN : forecastexids];
            system.debug('ExtMonthlyActuals--'+ExtMonthlyActuals);            

                 if(Test.isRunningTest()){                      
                    List<MonthlyActualSales__x> MonthlyActualsQuery = (!mockedRequests.isEmpty()) ? mockedRequests : [SELECT FISCAL_YEAR_ID__c,M1_AMOUNT__c,M2_AMOUNT__c,M3_AMOUNT__c,M4_AMOUNT__c,M5_AMOUNT__c,M6_AMOUNT__c,M7_AMOUNT__c,M8_AMOUNT__c,M9_AMOUNT__c,M10_AMOUNT__c,M11_AMOUNT__c,M12_AMOUNT__c,SFDC_EXTERNAL_ID__c,YEARLYTOT_AMOUNT__c FROM MonthlyActualSales__x WHERE SFDC_EXTERNAL_ID__c IN :forecastexids];
                        
                        for(MonthlyActualSales__x singleMonthlyActualSales : MonthlyActualsQuery)
                    {
                        ExtMonthlyActuals.add(singleMonthlyActualSales);
                    }
                }
            return ExtMonthlyActuals;
        }
        catch(ExternalObjectException e){
            System.debug('errMessage' + ': ' + e.getMessage());
            //ErrorLogging.Log(e,'ADMEntryScreenHelper','getExMonthlyActualSales','');
            return null;  
        }            
    }    
    //Get daily actuals from external object//
     @TestVisible private static List<DailyActualSales__x> mockedRequests2 = new List<DailyActualSales__x>();
    public static List<DailyActualSales__x> getExForecastDailyActual(Set<String> forecastexids){
    system.debug('hdailyforecastexids--'+forecastexids.size()); 
        List<DailyActualSales__x> ForecastactList = new List<DailyActualSales__x>();
        try{ 
             
            ForecastactList = [SELECT MONTH_ID__c,YEAR_ID__c,SFDC_EXTERNAL_ID__c,MTD_AMOUNT__c FROM DailyActualSales__x WHERE SFDC_EXTERNAL_ID__c IN: forecastexids];
            system.debug('ForecastactList--'+ForecastactList);
             
            
            if(Test.isRunningTest()){
                List<DailyActualSales__x> dailyActualsQuery = (!mockedRequests2.isEmpty()) ? mockedRequests2 : [SELECT MONTH_ID__c,YEAR_ID__c,SFDC_EXTERNAL_ID__c,MTD_AMOUNT__c FROM DailyActualSales__x WHERE SFDC_EXTERNAL_ID__c IN: forecastexids];
                    
                    for(DailyActualSales__x singleDailyActualSales : dailyActualsQuery)
                {
                    ForecastactList.add(singleDailyActualSales);
                }
            }
            
            return ForecastactList;
        }
        catch(ExternalObjectException e){
            System.debug('errMessage' + ': ' + e.getMessage());
            //ErrorLogging.Log(e, 'ADMEntryScreenHelper', 'getExForecastDailyActual','');
            return null;  
        }            
    }
}