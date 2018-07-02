/**********************************************************************
Name:  ADMEntryScreen_Controller
Copyright Â© 2017
======================================================
======================================================
Purpose: Controller for ADMEntryScreen VisualForce Page
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL Description
1.0          Suresh A            08/08/2017         INITIAL DEVELOPMENT
***********************************************************************/
public class ADMEntryScreen_Controller {
Public Boolean OEM{get;set;}
public string ProfitCenter{get;set;}
public Forecast__c Forecast{get;set;}
public String Available{get;set;}
public String CBC3Val{get;set;}
public String SoldToCustomerNumber{get;set;}
Public String WWC_Num{get;set;}
Public String DISTYCode{get;set;}
Public String District{get;set;}
Public String Region{get;set;}
Public String UserNWKid{get;set;}
public User CurrentUser{get;set;}
public String UserType;
public String Loggedinuserid;
public String SalesEngineer;
public String DistributionManager;
public String SalesEngineerManager;
public String RegionalManager;
public String DemandManager;
public integer CountofPortfolioRecords; 
public integer CountofNonPortfolioRecords;    
public integer LimitQuery = 2000;
public integer Offset = 0;
public string NonPortfolio='Non-Portfolio';
public string Portfolio = 'Portfolio';
public String PaginationRecords{get;set;}
transient List<Forecast__c> ForecastNonPortList = new List<Forecast__c>();
transient List<Forecast__c> ForecastPortfoliolist = new List<Forecast__c>();

   //Checking current user type and displaying different users to different Entry screens.
   public ADMEntryScreen_Controller() {
       forecast = new Forecast__c();
       countofPortfolioRecords = 0;
       countofNonPortfolioRecords = 0;
       PaginationRecords = '30';
       usertype ='';
       Loggedinuserid ='';
       currentuser =new User();
       currentuser = [SELECT Id,Region__c,ADM_User_Type__c FROM User WHERE Id = : UserInfo.getUserId()];
       Loggedinuserid = currentuser.id;
       usertype = currentuser.ADM_User_Type__c;
       
       SalesEngineer ='';
       DistributionManager ='';
       SalesEngineerManager ='';
       RegionalManager ='';
       DemandManager ='';
       ADM_Custom_Setting__c SEngineer = ADM_Custom_Setting__c.getInstance('ADMSalesEngineer');
       SalesEngineer = SEngineer.Value__c;
       
       ADM_Custom_Setting__c DistyManager = ADM_Custom_Setting__c.getInstance('ADMDistributionManager');
       DistributionManager = DistyManager.Value__c;
       
       ADM_Custom_Setting__c SEngineerMgnr = ADM_Custom_Setting__c.getInstance('ADMSalesEngineerManager');
       SalesEngineerManager = SEngineerMgnr.Value__c;
       
       ADM_Custom_Setting__c RegionalMgnr = ADM_Custom_Setting__c.getInstance('ADMRegionalManager');
       RegionalManager = RegionalMgnr.Value__c;
       
       ADM_Custom_Setting__c DemandMgnr = ADM_Custom_Setting__c.getInstance('ADMDemandManager');
       DemandManager = DemandMgnr.Value__c;
         
       if(usertype==DistributionManager)
           Available = 'Distributor';
       else
           Available = 'OEM';                  
   }   
   // Based on OEM/DISTY Selection fields visible in vf page.
   public pageReference toggleEnabled()  {
       try {
           forecast.Sold_To_Customer__c=null;
           forecast.Worldwide_Customer_Name__c=null;
           forecast.Worldwide_Account_Name__c=null;
           SoldToCustomerNumber = '';
           WWC_Num = '';
           if(Available=='OEM') {
               OEM=true;
           } else
               OEM=false; 
      }
      catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMEntryScreen_Controller', 'toggleEnabled','');
            return null;  
       }          
      return null;
   }    
   //Users when click on the submitbutton in entryscreen this metod will call and fetch the required forecas records
   Public pagereference Searchvalues(){
       
       System.Debug('PaginationRecords :'+PaginationRecords);
       System.debug('CBC3Val :'+CBC3Val);
       System.debug('ProfitCenter :'+ProfitCenter);
       String SoldToCustomer = forecast.Sold_To_Customer__c;
       String WWCustmName;
       System.debug('SoldToCustomerval :'+SoldToCustomer);
           WWCustmName = forecast.Worldwide_Account_Name__c; 
       System.debug('SoldToCustomer :'+SoldToCustomer);
       System.debug('WWCustmName :'+WWCustmName);
       try {
           ForecastNonPortList = ADMEntryScreenHelper.getforecastrec(Available,SoldToCustomer,WWCustmName,WWC_Num,Region,District,ProfitCenter,UserNWKid,usertype,Loggedinuserid,SoldToCustomerNumber,CBC3Val,limitQuery,offset,nonPortfolio);
           system.debug('entForecastList --'+ForecastNonPortList.size());                 
            
            countofNonPortfolioRecords = ForecastNonPortList.size();
           
           ForecastPortfoliolist = ADMEntryScreenHelper.getforecastrec(Available,SoldToCustomer,WWCustmName,WWC_Num,Region,District,ProfitCenter,UserNWKid,usertype,Loggedinuserid,SoldToCustomerNumber,CBC3Val,limitQuery,offset,portfolio);
           countofPortfolioRecords = ForecastPortfoliolist.size();
       
           system.debug('countofPortfolioRecords --> '+countofPortfolioRecords+' countofNonPortfolioRecords--> '+countofNonPortfolioRecords);        
                 
           if(usertype != null && (ForecastNonPortList.Size() == 0 && ForecastPortfoliolist.size() == 0)) {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.ADM_No_Records_Message+ ' ' +ForecastNonPortList.Size()));
           return null;
           } else if(usertype == null) {
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, System.Label.ADM_User_Type_Message));
               return null;
           }           
           else{        
                String totalPortfolio = String.valueOf(countofPortfolioRecords);
                String totalNonPortfolio = String.valueOf(countofNonPortfolioRecords);
                PageReference ParegRef = new PageReference('/apex/ADMForecastingPage');
                ParegRef.getParameters().put('selectedOptions',Available);
                ParegRef.getParameters().put('ProfitCentre',ProfitCenter);
                ParegRef.getParameters().put('SoldToCust',SoldToCustomer);
                ParegRef.getParameters().put('SoldToCustNum',SoldToCustomerNumber);
                ParegRef.getParameters().put('WWCNum',WWC_Num);
                ParegRef.getParameters().put('WWCustmN',WWCustmName);
                ParegRef.getParameters().put('Dstr',District);
                ParegRef.getParameters().put('Reg',Region);
                ParegRef.getParameters().put('cbc3',CBC3Val);
                ParegRef.getParameters().put('Userid',UserNWKid);
                ParegRef.getParameters().put('UsrType',UserType);
                ParegRef.getParameters().put('Loginuserid',Loggedinuserid);
                ParegRef.getParameters().put('portfolioCount',totalPortfolio);
                ParegRef.getParameters().put('nonPortfolioCount',totalNonPortfolio);
                ParegRef.getParameters().put('PaginationRecords',PaginationRecords);
                ParegRef.setRedirect(true);
                return ParegRef; 
           }
       }
       catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMEntryScreen_Controller', 'Searchvalues','');
            return null;  
       }
    }    
/******************************************************************
To get ADM_ProfitCenter__c values from custom setting
******************************************************************/   
  public List<SelectOption> getProfitCenterValues() {
      try {
         List<ADM_ProfitCenter__c> profitOptionsList = ADM_ProfitCenter__c.getAll().Values();
         List<SelectOption> options=new List<SelectOption>();
       
        for(ADM_ProfitCenter__c pc: profitOptionsList){
             options.add(new SelectOption(pc.PC_Value__c,pc.PC_Label__c));
             options.Sort();
        }
            return options;
        }
        catch(Exception e){
             System.debug('errMessage' + ': ' + e.getMessage());
             ErrorLogging.Log(e, 'ADMEntryScreen_Controller', 'getProfitCenterValues','');
             return null;  
        }
  }    
/******************************************************************
To get ADM_CBC3__c values from custom setting
******************************************************************/    
public List<SelectOption>getCBC3Values() {
    try {
        List<ADM_CBC3__c> CBC3OptionsList = ADM_CBC3__c.getAll().Values();
        List<SelectOption> options = new List<SelectOption>();
       
        for(ADM_CBC3__c  cbc3: CBC3OptionsList){
             options.add(new SelectOption(cbc3.CBC3_Value__c,cbc3.CBC3_Label__c));
             options.Sort();
        }   
            return options;
     }
     catch(Exception e){
           System.debug('errMessage' + ': ' + e.getMessage());
           ErrorLogging.Log(e, 'ADMEntryScreen_Controller', 'getCBC3Values','');
           return null;  
      }
    }    
 /******************************************************************
To get ADM_Region__c values from custom setting
******************************************************************/
public List<SelectOption> getRegionValues() {  
    try {  
        List<ADM_Region__c> regionOptionsList = ADM_Region__c.getAll().Values();
        List<SelectOption> options = new List<SelectOption>();
        
        for(ADM_Region__c rg : regionOptionsList ){
            options.add(new SelectOption(rg.Region_Value__c,rg.Region_Label__c));            
            options.Sort();
        }
        if(usertype == DistributionManager) {            
            ADM_User_Region__c URSettingIN = ADM_User_Region__c.getInstance('India');
            ADM_User_Region__c URSettingCH = ADM_User_Region__c.getInstance('China');
            ADM_User_Region__c URSettingJP = ADM_User_Region__c.getInstance('Japan');
            ADM_User_Region__c URSettingAP = ADM_User_Region__c.getInstance('Asia Pacific');
            ADM_User_Region__c URSettingEA = ADM_User_Region__c.getInstance('EMEA');
            ADM_User_Region__c URSettingNA = ADM_User_Region__c.getInstance('North America');
            ADM_User_Region__c URSettingSA = ADM_User_Region__c.getInstance('South America');
            ADM_User_Region__c URSettingANZ = ADM_User_Region__c.getInstance('ANZ');
            if(currentuser.Region__c == URSettingIN.ADM_User_Region_Label__c || currentuser.Region__c == URSettingCH.ADM_User_Region_Label__c || currentuser.Region__c == URSettingJP.ADM_User_Region_Label__c || currentuser.Region__c == URSettingAP.ADM_User_Region_Label__c) {
                Region = URSettingAP.ADM_User_Region_Value__c;
            }
            else if(currentuser.Region__c == URSettingEA.ADM_User_Region_Label__c) {
                Region = URSettingEA.ADM_User_Region_Value__c;
            }
            else if(currentuser.Region__c == URSettingNA.ADM_User_Region_Label__c) {
                Region = URSettingNA.ADM_User_Region_Value__c;
            }
            else if(currentuser.Region__c == URSettingSA.ADM_User_Region_Label__c) {
                Region = URSettingSA.ADM_User_Region_Value__c;
            }
            else if(currentuser.Region__c == URSettingANZ.ADM_User_Region_Label__c) {
                Region = URSettingANZ.ADM_User_Region_Value__c;
            }
        }
        return options;
    }
    catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMEntryScreen_Controller', 'getRegionValues','');
            return null;  
    }
}    
 /******************************************************************
To get ADM_District__c values from custom setting
******************************************************************/
    public List<SelectOption> getDistrictValues() {
        try {
             List<ADM_District__c> districtOptionsList = ADM_District__c.getAll().Values();
             List<SelectOption> options = new List<SelectOption>();
           
             for(ADM_District__c dt: districtOptionsList ){
                 options.add(new SelectOption(dt.District_Value__c,dt.District_Label__c));                 
                 options.Sort();
             }
                 return options;
         }
         catch(Exception e){
                System.debug('errMessage' + ': ' + e.getMessage());
                ErrorLogging.Log(e, 'ADMEntryScreen_Controller', 'getDistrictValues','');
                return null;  
         }
    }
 /******************************************************************
Adding Pagination Select list values.
******************************************************************/
     public List<SelectOption> getPaginationDropDown() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('5','5'));
        options.add(new SelectOption('10','10'));
        options.add(new SelectOption('15','15'));
        options.add(new SelectOption('20','20'));
        options.add(new SelectOption('25','25'));
        options.add(new SelectOption('30','30'));
        return options;
    } 
}