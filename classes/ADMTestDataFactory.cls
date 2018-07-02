/**********************************************************************
Name:  ADMTestDataFactory
Copyright © 2017
======================================================
======================================================
Purpose: Test data factory
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               Description
0.1        Sreelekha A          8/29/2017         INITIAL DEVELOPMENT
***********************************************************************/
@isTest
public class ADMTestDataFactory {
    
    /***********************************************************************
Purpose : To set up the data for a single Sales_Hierarchy__c recoird     
***********************************************************************/
    Public static Sales_Hierarchy__c CreateSalesHierarchy(string Name, string extId, string level7TerritoryName, string userTEId){
        
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c(); 
        sh.Name = Name;
        sh.Level_7_Territory_Code__c = extId;
        sh.Level_6_Territory_Name__c = level7TerritoryName;
        sh.Level_6_Assigned_User_Network_Ids__c = userTEId;
        sh.Level_5_Territory_Name__c = level7TerritoryName;
        sh.Level_5_Assigned_User_Network_Ids__c = userTEId;
        sh.Level_4_Territory_Name__c = level7TerritoryName;
        sh.Level_4_Assigned_User_Network_Ids__c = userTEId;
        sh.Level_3_Territory_Name__c = level7TerritoryName;
        sh.Level_3_Assigned_User_Network_Ids__c = userTEId;
        sh.Level_2_Territory_Name__c = level7TerritoryName;
        sh.Level_2_Assigned_User_Network_Ids__c = userTEId;
        sh.Level_1_Territory_Name__c = level7TerritoryName;
        sh.Level_1_Assigned_User_Network_Ids__c = userTEId;
        //sh.Level_7_Assigned_Users__c = userId;
        sh.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
        sh.Level_1_Territory_Code__c = '101485';
        sh.Level_1_Territory_Name__c = 'Worldwide Aero, Def & Mari';
        insert sh;
        return sh;
    }
    
    public static Sales_Hierarchy__c createTestSalesHierarchy() {
        Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
        sh.Level_7_Territory_Code__c = 'A007341';
        sh.Hierarchy_Type__c = 'Account Manager Hierarchy (FE)';
        return sh;
    }
    
    /***********************************************************************
Purpose : To set u data for a List of Account recoirds and it will return List of accounts    
***********************************************************************/
    
    Public static List<Account> accountDetails(string Name, string accNumber, String City,string country, string type,
                                               string PostalCode ,string dd1Code){                                                                                      
                                                   
                                                   ADMTerritoryCode__c Territory = new ADMTerritoryCode__c();
                                                   Territory.Name = 'ADMTerritoryCode';
                                                   Territory.Territory_Code__c = '101485';
                                                   Territory.Level1TerritoryName__c = 'Worldwide Aero, Def & Mari';
                                                   Territory.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
                                                   insert Territory; 
                                                   
                                                   List<Account> accList = new List<Account>();                                    
                                                   Account acc = new Account();
                                                   //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];                                    
                                                   /**user u =  new User( ADM_User_Type__c= 'Distribution Manager',Alias = 'kttest', Email='st@gmail.com', 
UserName='anu@te.com',EmailEncodingKey='UTF-8', LastName='Tg', 
LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', 
Te_Network_Id__c = '12394');**/
                                                   //insert u;                                   
                                                   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
                                                   acc.Name = Name; //Modified by Harinath to get Unique AccountName for each Account.
                                                   acc.BillingCity = City;
                                                   acc.BillingCountry = country;
                                                   acc.Type = type;
                                                   acc.DD1_Industry_Business_Code__c = dd1Code ; 
                                                   acc.BillingPostalCode = PostalCode;
                                                   //acc.Account_Manager__c = manager;                                  
                                                   //acc.Sales_Hierarchy__c = sHierarchy;
                                                   acc.AccountNumber = accNumber;
                                                   acc.RecordTypeId = RecordTypeId; 
                                                   acc.Account_Manager__c = UserInfo.getUserId();                                   
                                                   accList.add(acc);
                                                   insert accList;                                      
                                                   return accList;                                   
                                                   //system.debug('acc=='+acc);                                     
                                                   
                                               }
    
    
    
    Public static List<Product_Hierarchy__c> productHierarchyDetails( string GPL, string CBC2, string CBC3, string CBC4,string GPLDec){
        Product_Hierarchy__c ProdHierchy = new Product_Hierarchy__c();
        List<Product_Hierarchy__c> productHierarchyDetailsList = new  List<Product_Hierarchy__c>();
        ProdHierchy.Name = GPL;
        ProdHierchy.CBC2__c = CBC2;
        ProdHierchy.CBC3__c = CBC3;
        ProdHierchy.CBC4__c = CBC4;
        ProdHierchy.GPL_Description__c = GPLDec;
        productHierarchyDetailsList.add(ProdHierchy);
        return productHierarchyDetailsList;
        
    }
    /***********************************************************************
Purpose : To set u data for a single Forecast__c recoirds     
***********************************************************************/
    Public static Void forecastObj(string name, string CBC2,String CBC3,String CBC4, string Comment, String district, 
                                   string frcstLevel, id GPL , String region,String soldToCust, String WWcust,String type){
                                       Forecast__c frCast = new Forecast__c();
                                       frCast.CBC2__c = CBC2;
                                       frCast.CBC3__c = CBC3;
                                       frCast.CBC4__c = CBC4;
                                       frCast.Comment__c = Comment;
                                       frCast.District__c = district;
                                       //frCast.External_ID__c = extId;
                                       frCast.Forecast_Level__c = frcstLevel;
                                       frCast.GPL__c = GPL;
                                       frCast.Region__c = region;
                                       frCast.Sold_To_Customer__c = soldToCust; // filter OEM 
                                       //frCast.Worldwide_Customer_Name__c = WWcust; // filter Distributor  
                                       insert frCast;                                      
                                       //frCast.Name =         
                                   }
    
    /***********************************************************************
Purpose : To set u data for a List of Forecast__c recoirds and it will return List of Forecast__c    
***********************************************************************/
    
    /* Public static List<Forecast__c> forecastObjList(string name, string CBC2,String CBC3,String CBC4, string Comment, 
string frcstLevel,  string soldToCust, string WWcust,String type,string profit){

List<Forecast__c> frCastList = new List<Forecast__c>();
Forecast__c frCast = new Forecast__c();
frCast.CBC2__c = CBC2;
frCast.CBC3__c = CBC3;
frCast.CBC4__c = CBC4;
frCast.Comment__c = Comment;
//frCast.District__c = district;
//frCast.External_ID__c = extId;
frCast.Forecast_Level__c = frcstLevel;
//frCast.GPL__c = ProdHierchy.id;
//frCast.Region__c = region;
frCast.Sold_To_Customer__c = soldToCust; // filter OEM 
frCast.Worldwide_Customer_Name__c = WWcust; // filter Distributor                                      
frCast.Profit_Center__c = profit;   
frCastList.add(frCast); 
return frCastList;                                      
}*/
    Public static  List<Forecast__c> forecastObjList(string extId, string CBC2,String CBC3,String CBC4, string Comment, String district, 
                                                     string frcstLevel, id GPL , String region,String type){
                                                         List<Forecast__c> frCastList = new List<Forecast__c>();
                                                         Forecast__c frCast = new Forecast__c();
                                                         frCast.CBC2__c = CBC2;
                                                         frCast.CBC3__c = CBC3;
                                                         frCast.CBC4__c = CBC4;
                                                         frCast.Comment__c = Comment;
                                                         frCast.District__c = district;
                                                         frCast.External_ID__c = extId;
                                                         frCast.Forecast_Level__c = frcstLevel;
                                                         frCast.GPL__c = GPL;
                                                         frCast.Region__c = region;
                                                         frCast.Type__c = type;
                                                         //frCast.Sold_To_Customer__c = soldToCust; // filter OEM 
                                                         //frCast.Worldwide_Customer_Name__c = WWcust; // filter Distributor  
                                                         frCastList.add(frCast);
                                                         //insert frCast;  
                                                         insert frCastList;                               
                                                         return frCastList;      
                                                     }
    
    
    /***********************************************************************
Purpose : To set u data for a List of Forecast_Detail__c recoirds and it will return List of Forecast_Detail__c    
***********************************************************************/
    
    Public static List<Forecast_Detail__c> forecastDetailObjList(string Comments, string period, string type){
        List<Forecast_Detail__c> frcDetailsList = new List<Forecast_Detail__c>(); 
        Forecast_Detail__c frcDetails = new Forecast_Detail__c();
        //frcdetails.External_ID__c =
        frcDetails.LatestComment__c = Comments;
        //frcdetails.M11__c = currency 
        //frcdetails.MTD_Actuals__c = 
        //frcdetails.MTD_Variance__c =
        //frcdetails.PPY_Actuals__c =
        //frcdetails.PY_Actuals__c =
        //frcdetails.YoYAmount__c =
        //frcdetails.YoYPercentage__c = 
        //frcdetails.Parent_Forecast__c = frCast.id;
        frcDetails.Period__c = period;
        frcDetails.Type__c = type;
        frcDetailsList.add(frcDetails);
        return frcDetailsList;     
        
    } 
    
    
    
    /***********************************************************************
Purpose : To create single Forecast__c record to use in Test Classes   
***********************************************************************/
    Public static Forecast__c createForecastObj(string extId, string CBC2,String CBC3,String CBC4, string Comment, String district, 
                                                string frcstLevel, id GPL , String region,String fctype){
                                                    Id ADMRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
                                                    system.debug('ADMRecordTypeId--> '+ADMRecordTypeId);
                                                    
                                                    Forecast__c frCast = new Forecast__c();                                            
                                                    frCast.CBC2__c = CBC2;
                                                    frCast.CBC3__c = CBC3;
                                                    frCast.CBC4__c = CBC4;
                                                    frCast.Comment__c = Comment;
                                                    frCast.District__c = district;
                                                    frCast.External_ID__c = extId;
                                                    frCast.Forecast_Level__c = frcstLevel;
                                                    frCast.GPL__c = GPL;
                                                    frCast.Region__c = region;
                                                    frCast.Type__c = fctype;
                                                    frCast.RecordTypeid = ADMRecordTypeId;
                                                    //frCast.Sold_To_Customer__c = soldToCust; // filter OEM 
                                                    //frCast.Worldwide_Customer_Name__c = WWcust; // filter Distributor  
                                                    insert frCast;                                      
                                                    return   frCast;      
                                                }
    
    
    
    /***********************************************************************
Purpose : To create single Forecast__c record to use in Test Classes   
***********************************************************************/
    Public static Forecast__c createForecastObj2(string extId, string CBC2,String CBC3,String CBC4, string Comment, String district, 
                                                 string frcstLevel, id GPL , String region,String fctype, Id AccountId){
                                                     
                                                     Id ADMRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
                                                     system.debug('ADMRecordTypeId--> '+ADMRecordTypeId);
                                                     
                                                     Forecast__c frCast = new Forecast__c();
                                                     frCast.AccountId__c = AccountId;                                      
                                                     frCast.CBC2__c = CBC2;
                                                     frCast.CBC3__c = CBC3;
                                                     frCast.CBC4__c = CBC4;
                                                     frCast.Comment__c = Comment;
                                                     frCast.District__c = district;
                                                     frCast.External_ID__c = extId;
                                                     frCast.Forecast_Level__c = frcstLevel;
                                                     frCast.GPL__c = GPL;
                                                     frCast.Region__c = region;
                                                     frCast.Type__c = fctype;
                                                     frCast.RecordTypeid = ADMRecordTypeId;                                      
                                                     //frCast.Sold_To_Customer__c = soldToCust; // filter OEM 
                                                     //frCast.Worldwide_Customer_Name__c = WWcust; // filter Distributor  
                                                     insert frCast;                                      
                                                     return   frCast;      
                                                 }
    
    
    
    public static List<Forecast_Detail__c> createForCastDetails(Id frcstId, String type){
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        String currentyr = currentfisobj.name;
        String nextyr= String.valueOf(Integer.ValueOf(currentyr)+1);
        String pastyr= String.valueOf(Integer.ValueOf(currentyr)-1);
        
        
        List<Forecast_Detail__c> frcDetailsList = new List<Forecast_Detail__c>();
        frcDetailsList .add(new Forecast_Detail__c(Parent_Forecast__c=frcstId, Period__c=pastyr, M1__c=2, M2__c=2,M3__c=2, M4__c=2, M5__c=2, M6__c=2,
                                                   M7__C=2, M8__c=2, M9__c=2, M10__c=2, M11__c=2, M12__c=2,Type__c= type));
        frcDetailsList .add(new Forecast_Detail__c(Parent_Forecast__c=frcstId, Period__c=currentyr, M1__c=2, M2__c=2,M3__c=2, M4__c=2, M5__c=2, M6__c=2,
                                                   M7__C=2, M8__c=2, M9__c=2, M10__c=2, M11__c=2, M12__c=2,Type__c= type));
        frcDetailsList .add(new Forecast_Detail__c(Parent_Forecast__c=frcstId, Period__c=nextyr, M1__c=2, M2__c=2,M3__c=2, M4__c=2, M5__c=2, M6__c=2,
                                                   M7__C=2, M8__c=2, M9__c=2, M10__c=2, M11__c=2, M12__c=2,Type__c= type));
        
        
        return insertRecord(frcDetailsList );
    }
    
    public static Forecast_Detail__c createForecastDetailsForHistorical(Id fId, String Priod, String type){
        
        Forecast_Detail__c frcDetail = new Forecast_Detail__c();
        
        frcDetail.Type__c = type;
        frcDetail.Parent_Forecast__c=fId; 
        frcDetail.Period__c = Priod;
        insert frcDetail;
        
        return frcDetail;
    }
    
    public static Account createTestAccounts() {
        Account acc = new Account();
        acc.Name = 't'+system.now().millisecond()+math.round(math.random()*10000);
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'CN';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '77777';
        acc.Sales_Hierarchy__c=ClsTestHelp.createTestSalesHierarchy().Id;
        acc.Industry_Code_Description__c='Industrial';
        acc.Business_Unit_Level_2__c='Rail';
        acc.AccountNumber = '';
        return acc;
    }   
    public static List<sObject> insertRecord(List<sObject> objectList){
        insert objectList;
        return objectList;
    }
    
    public static void getADM_CustomSetting(){
        
        List<ADM_Custom_Setting__c> ADMCSettings = new List<ADM_Custom_Setting__c>();
        ADM_Custom_Setting__c cbc3level = new ADM_Custom_Setting__c();
        cbc3level.Name = 'ADM_DISTYForecastLevel';
        cbc3level.Value__c = 'CBC3 Level';
        ADMCSettings.add(cbc3level);
          
        ADM_Custom_Setting__c GplLevel = new ADM_Custom_Setting__c();
        GplLevel.Name = 'ADM_OEMForecastLevel';
        GplLevel.Value__c = 'GPL Level';
        ADMCSettings.add(GplLevel);
        
        ADM_Custom_Setting__c slesEngnr = new ADM_Custom_Setting__c();
        slesEngnr.Name = 'ADMSalesEngineer';
        slesEngnr.Value__c = 'Sales Engineer';
        ADMCSettings.add(slesEngnr);
        
        ADM_Custom_Setting__c DityMgr = new ADM_Custom_Setting__c();
        DityMgr.Name = 'ADMDistributionManager';
        DityMgr.Value__c = 'Distribution Manager';
        ADMCSettings.add(DityMgr);
        
        ADM_Custom_Setting__c slesEngnrMgr = new ADM_Custom_Setting__c();
        slesEngnrMgr.Name = 'ADMSalesEngineerManager';
        slesEngnrMgr.Value__c = 'Sales Engineer Manager';
        ADMCSettings.add(slesEngnrMgr);
                
        ADM_Custom_Setting__c RgnalMgr = new ADM_Custom_Setting__c();
        RgnalMgr.Name = 'ADMRegionalManager';
        RgnalMgr.Value__c = 'Regional Manager';
        ADMCSettings.add(RgnalMgr);
        
        ADM_Custom_Setting__c DmandMgr = new ADM_Custom_Setting__c();
        DmandMgr.Name = 'ADMDemandManager';
        DmandMgr.Value__c = 'Demand Manager';
        ADMCSettings.add(DmandMgr);            
              
        Insert ADMCSettings;    
        
        ADMTerritoryCode__c Territory = new ADMTerritoryCode__c();
        Territory.Name = 'ADMTerritoryCode';
        Territory.Territory_Code__c = '101485';
        Territory.Level1TerritoryName__c = 'Worldwide Aero, Def & Mari';
        Territory.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
        insert Territory;            
    }
    public static void getADM_CustomSetting1(){
        
        Record_Rendering_Limit__c recRender = new Record_Rendering_Limit__c();
        recRender.Name = 'RecordRenderingLimit';
        recRender.Subordinates_Limit__c = 100;
        recRender.Managers_Limit__c = 400;
        insert recRender;
        
        ADM_ProfitCenter__c profit = new ADM_ProfitCenter__c();
        profit.Name = 'AER';
        profit.PC_Value__c  = 'AER';
        profit.PC_Label__c =  'AER - Aerospace, Defense & Marine'; 
        insert  profit; 
        
        ADM_Region__c region = new ADM_Region__c();
        region.Name = 'ANZ';
        region.Region_Label__c = 'EMEA';
        region.Region_Value__c = '0401';
        insert region; 
        
        ADM_District__c d= new ADM_District__c();
        d.name ='Australia';
        d.District_Value__c ='Australia';
        d.District_Label__c = 'Australia Area';  
        insert d; 
        
        ADM_CBC3__c cbc3 = new ADM_CBC3__c();
        cbc3.Name = '13010';
        cbc3.CBC3_Value__c = '13010';
        cbc3.CBC3_Label__c = '13010 - WIRE & CABLE';  
        insert cbc3;    
        
        List<ADM_User_Region__c> URList = new List<ADM_User_Region__c>();
        ADM_User_Region__c UserRegion =new ADM_User_Region__c();
        UserRegion.Name = 'EMEA';
        UserRegion.ADM_User_Region_Label__c = 'EMEA';
        UserRegion.ADM_User_Region_Value__c = '0401';
        URList.add(UserRegion);   
        
        ADM_User_Region__c UserRegion1 =new ADM_User_Region__c();
        UserRegion1.Name = 'ANZ';
        UserRegion1.ADM_User_Region_Label__c = 'ANZ';
        UserRegion1.ADM_User_Region_Value__c = '0934';
        URList.add(UserRegion1); 
        
        ADM_User_Region__c UserRegion2 =new ADM_User_Region__c();
        UserRegion2.Name = 'Asia Pacific';
        UserRegion2.ADM_User_Region_Label__c = 'Asia Pacific';
        UserRegion2.ADM_User_Region_Value__c = '0442';
        URList.add(UserRegion2); 
        
        ADM_User_Region__c UserRegion3 =new ADM_User_Region__c();
        UserRegion3.Name = 'China';
        UserRegion3.ADM_User_Region_Label__c = 'China';
        UserRegion3.ADM_User_Region_Value__c = '0442';
        URList.add(UserRegion3); 
        
        ADM_User_Region__c UserRegion4 =new ADM_User_Region__c();
        UserRegion4.Name = 'India';
        UserRegion4.ADM_User_Region_Label__c = 'India';
        UserRegion4.ADM_User_Region_Value__c = '0442';
        URList.add(UserRegion4); 
        
        ADM_User_Region__c UserRegion5 =new ADM_User_Region__c();
        UserRegion5.Name = 'Japan';
        UserRegion5.ADM_User_Region_Label__c = 'Japan';
        UserRegion5.ADM_User_Region_Value__c = '0442';
        URList.add(UserRegion5); 
        
        ADM_User_Region__c UserRegion6 =new ADM_User_Region__c();
        UserRegion6.Name = 'North America';
        UserRegion6.ADM_User_Region_Label__c = 'North America';
        UserRegion6.ADM_User_Region_Value__c = '0002';
        URList.add(UserRegion6); 
        
        ADM_User_Region__c UserRegion7 =new ADM_User_Region__c();
        UserRegion7.Name = 'South America';
        UserRegion7.ADM_User_Region_Label__c = 'South America';
        UserRegion7.ADM_User_Region_Value__c = '0933';
        URList.add(UserRegion7);            
        insert URList;                
    }
}