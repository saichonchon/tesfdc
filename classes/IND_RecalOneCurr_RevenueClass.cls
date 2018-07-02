/********************************************************...
/*********************************************************************************************************************** 
 Name: IND_RecalOneCurr_RevenueClass 
 Salesforce Instance : IND Sandbox,QA Sandbox
========================================================================================================================
 Purpose: This class will be called by the Opportunity Forecast trigger and claculate the one year revenue and current year revenue as well as update these fields.                                                   
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak Kumar      26 August 2016   Initial Development                                         1

*/
Public class IND_RecalOneCurr_RevenueClass {


 //Set<id> oppid = new Set<id>();
 public List<Period> list_fiscalYear; 
 public map<String, Map<String, Period>> map_fiscalyear_quarters;
 
 
 
//************************************************Constructor Method************************************************************************************************
  
      
 
//************************************************Constructor Method************************************************************************************************
  
 
 
//************************************************Trigger Method************************************************************************************************
 
 Public map<id,opportunity> onAfterinsertUpdate(map<id,Opportunity> mapNewOppForecast)
    {
    
           getAllFiscalYear();
           getAllFiscalQuarter();
    
     //Below Query on opportunity we can avoid but the map variable which am getting from the controller class does not contain the two new fields which i am trying to update because these are the new fields added by us now.
     
     // Map<ID,Opportunity> OpptoProc = new Map<ID,Opportunity>();  //[SELECT ID,Current_Year_Revenue__c,One_Year_Revenue__c,Manufacturing_Start_Date__c from Opportunity where id IN :mapNewOppForecast.keyset()]);  
     // OpptoProc.putall(mapNewOppForecast);
      
     
      Map<Id, List<Opportunity_Forecast__c>> map_oppyid_forecasts = new Map<Id, List<Opportunity_Forecast__c>>();
      //Map<Id, Date> map_oppyid_firstDate = new Map<Id, Date>();
       
       
       
        if(!mapNewOppForecast.isEmpty()){
            // get the forecasts according to opportunity id
            for(Opportunity_Forecast__c ofc: [select id, Name, Five_Year_Amount__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Sales_Price__c, Date__c,Fiscal_Year__c, Fiscal_Quarter__c from Opportunity_Forecast__c where Opportunity__c in :mapNewOppForecast.keyset() and Part__c = null and Date__c != null order by Opportunity__c, Date__c]){
                if(!map_oppyid_forecasts.containsKey(ofc.Opportunity__c)){
                    map_oppyid_forecasts.put(ofc.Opportunity__c, new List<Opportunity_Forecast__c>());
                }
                map_oppyid_forecasts.get(ofc.Opportunity__c).add(ofc);          
            }
             
 //********************************************************************Begning of Recalculate method***************************************************************** 
              
         String currentYear = String.valueOf(system.today().year());
            
         if(!map_oppyid_forecasts.isEmpty()){    
             
          for(Id oid: map_oppyid_forecasts.keySet()){
          
             Decimal OneYRevenue = 0;
             Decimal CurrYRevenue = 0; 
             Integer Starty=0;
             Integer StartQ=0;
             
 //*********************************************Current Year Revenue Update*************************************************************************************            
       
             for(period Cyr:list_fiscalYear)
              { 
                if(cyr.StartDate<=system.today() && cyr.EndDate>=system.today())
                  {
                    for(Opportunity_Forecast__c ofr:map_oppyid_forecasts.get(oid))
                     {
                       if(ofr.Fiscal_Year__c==cyr.FiscalYearSettings.Name)
                        {
                          CurrYRevenue+=ofr.Amount__c;
                        }
                     
                     } 
                  
                  
                  }  
 //**Integer.valueOf()*******************************************Current Year Revenue Update*************************************************************************************            
 
 
 //*********************************************One Year Revenue Update*************************************************************************************            
                 
                 if(cyr.StartDate<=mapNewOppForecast.get(oid).Manufacturing_Start_Date__c && cyr.EndDate>=mapNewOppForecast.get(oid).Manufacturing_Start_Date__c)
                   {
                     for(integer i=1;i<5;i++)
                      {
                       if(map_fiscalyear_quarters.get(cyr.FiscalYearSettings.Name).get(String.valueOf(i)).StartDate<=mapNewOppForecast.get(oid).Manufacturing_Start_Date__c && map_fiscalyear_quarters.get(cyr.FiscalYearSettings.Name).get(String.valueOf(i)).EndDate>=mapNewOppForecast.get(oid).Manufacturing_Start_Date__c)
                         {
                          Starty=Integer.valueOf(cyr.FiscalYearSettings.Name);
                          StartQ=i;
                         // System.debug('*****************************************'+Starty+'****'+StartQ);
                         // System.debug('************quater start date*****************************'+map_fiscalyear_quarters.get(cyr.FiscalYearSettings.Name).get(String.valueOf(i)).StartDate);
                         // System.debug('****************Manufacturing start date*************************'+OpptoProc.get(oid).Manufacturing_Start_Date__c);
                         }
                      
                      }
                   
                   
                   }
              }
              
           

            for(Opportunity_Forecast__c ofr:map_oppyid_forecasts.get(oid))
                     {
                     
                       if(StartQ==1 && (ofr.Fiscal_Quarter__c=='01' || ofr.Fiscal_Quarter__c=='02' || ofr.Fiscal_Quarter__c=='03' || ofr.Fiscal_Quarter__c=='04') && Integer.valueOf(ofr.Fiscal_Year__c)==Starty)
                        {
                          OneYRevenue +=ofr.Amount__c;
                        }
                        if(StartQ==2 && (((ofr.Fiscal_Quarter__c=='02' || ofr.Fiscal_Quarter__c=='03' || ofr.Fiscal_Quarter__c=='04') && Integer.valueOf(ofr.Fiscal_Year__c)==Starty) || (ofr.Fiscal_Quarter__c=='01' && Integer.valueOf(ofr.Fiscal_Year__c)==Starty+1)))
                        {
                          OneYRevenue +=ofr.Amount__c;
                        }
                        if(StartQ==3 && (((ofr.Fiscal_Quarter__c=='03' || ofr.Fiscal_Quarter__c=='04') && Integer.valueOf(ofr.Fiscal_Year__c)==Starty) || ((ofr.Fiscal_Quarter__c=='02' || ofr.Fiscal_Quarter__c=='01') && Integer.valueOf(ofr.Fiscal_Year__c)==Starty+1)))
                        {
                          OneYRevenue +=ofr.Amount__c;
                        }
                        if(StartQ==4 && ((ofr.Fiscal_Quarter__c=='04' && Integer.valueOf(ofr.Fiscal_Year__c)==Starty) || ((ofr.Fiscal_Quarter__c=='03' || ofr.Fiscal_Quarter__c=='02' || ofr.Fiscal_Quarter__c=='01') && Integer.valueOf(ofr.Fiscal_Year__c)==Starty+1 )))
                        {
                          OneYRevenue +=ofr.Amount__c;
                        }
                        
                        
                     } 
        

//*********************************************One Year Revenue Update*************************************************************************************            
              
             mapNewOppForecast.get(oid).Current_Year_Revenue__c=CurrYRevenue;
            
             mapNewOppForecast.get(oid).One_Year_Revenue__c=OneYRevenue;
            
           
     
             
            }
            }
 
           // Update OppToUpdate;
//********************************************************************End of Recalculate method***************************************************************** 
          
          }


      if(mapNewOppForecast.size()>0) 
      {return (mapNewOppForecast);}
      else {return(null);}
      

    }
//************************************************Trigger Method************************************************************************************************
     
     //********************************* -=BEGIN public methods=- **********************************
    public void getAllFiscalYear(){
        if(list_fiscalYear == null){
            list_fiscalYear = new List<Period>();
            for(Period p: [select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'Year' and FiscalYearSettings.IsStandardYear = false order by FiscalYearSettings.Name]){
                list_fiscalYear.add(p);
            }
        }
    }
    
    public void getAllFiscalQuarter(){
        if(map_fiscalyear_quarters == null){
          map_fiscalyear_quarters = new map<String, map<String, Period>>();
            for(Period p:  [select FiscalYearSettingsId, FiscalYearSettings.Name, Number, PeriodLabel, StartDate, EndDate from Period where type = 'Quarter']){
                
                 if(!map_fiscalyear_quarters.containsKey(p.FiscalYearSettings.Name)){
                    map_fiscalyear_quarters.put(p.FiscalYearSettings.Name, new Map<String, Period>());
                }
                map_fiscalyear_quarters.get(p.FiscalYearSettings.Name).put(String.valueOf(p.Number), p);
             }
            }
        }
     
    
  
 //********************************* -=END public methods=- **********************************    
    
}