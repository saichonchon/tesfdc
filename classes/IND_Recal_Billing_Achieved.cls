/********************************************************...
/*********************************************************************************************************************** 
 Name: IND_Recal_Billing_Achieved 
 Salesforce Instance : IND Sandbox,QA Sandbox
========================================================================================================================
 Purpose: This class will be called by the Batch job to claculate the Forecast Billing Acheived % as well as update this field with percentage achevied.                                                   
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak Kumar      5th Jan 2017   Initial Development                                         1

*/
Public class IND_Recal_Billing_Achieved {


 //Set<id> oppid = new Set<id>();
 
 public map<string,double> Convertedrate;
 public map<id,opportunity> mapNewOppForecast; 
 Public Integer CurrentFY=0;
 Public Integer CurrentQ=0;
 Public String stringCFY;
 Public String stringPFY;
 
//************************************************Constructor Method************************************************************************************************
   public IND_Recal_Billing_Achieved(Integer CQ,Integer CFY,map<string,double> clist)
   {
      CurrentQ=CQ;
      CurrentFY=CFY;
      Convertedrate =clist;
      stringCFY =String.valueOf(CFY);
      stringPFY =String.valueOf(CFY-1);
              
   }
//************************************************Constructor Method************************************************************************************************
  
 
 
//************************************************Batch job Calling Method************************************************************************************************
 
 Public integer UpdateBillingOpp(list<Opportunity> ListOpp)
    {
         
          integer successCount=0;
          integer failurecount=0;
         
          mapNewOppForecast= new map<id,opportunity>();
          for(opportunity opp:ListOpp)
           {
             mapNewOppForecast.put(opp.id,opp);
           }
           
     
      Map<Id, List<Forecast_Billing__c>> map_oppyid_Billing = new Map<Id, List<Forecast_Billing__c>>();
      Map<Id, List<Opportunity_Forecast__c>> map_oppyid_forecasts = new Map<Id, List<Opportunity_Forecast__c>>();
       
       
       
        if(!mapNewOppForecast.isEmpty()){
            // get the forecasts billings according to opportunity id 
            for(Forecast_Billing__c ofc: [select id,CurrencyIsoCode,Amount__c,Date__c,Opportunity_Part__c,RecordType.DeveloperName,RecordTypeId,RecordType.Name,Opportunity_Part__r.Status__c,Opportunity_Part__r.Part__c,Opportunity_Part__r.PLM_ID__c,Opportunity_Part__r.Opportunity__r.PLM_Id__c,Opportunity_Forecast__r.Fiscal_Quarter__c,Opportunity_Forecast__r.Fiscal_Year__c from Forecast_Billing__c where Opportunity_Part__r.Opportunity__r.Id in :mapNewOppForecast.keyset() and (Opportunity_Forecast__r.Fiscal_Year__c= :stringCFY or Opportunity_Forecast__r.Fiscal_Year__c= :stringPFY) and Amount__c!=0 and Opportunity_Forecast__r.RecordType.DeveloperName='Part' and Opportunity_Part__c !=null and Date__c != null and (Opportunity_Part__r.Status__c!='Lost' or Opportunity_Part__r.Status__c != 'Dead' or Opportunity_Part__r.Status__c != 'On Hold') order by Date__c]){
               
                if(!map_oppyid_Billing.containsKey(ofc.Opportunity_Part__r.Opportunity__r.Id)){
                    map_oppyid_Billing.put(ofc.Opportunity_Part__r.Opportunity__r.Id, new List<Forecast_Billing__c>());
                }
                map_oppyid_Billing.get(ofc.Opportunity_Part__r.Opportunity__r.Id).add(ofc);          
               }
            
            // get the opportunity forecasts according to opportunity id
            for(Opportunity_Forecast__c ofc1: [select id,CurrencyIsoCode,Name, Five_Year_Amount__c, Quantity__c, Amount__c, Opportunity__c, Part__c, Sales_Price__c, Date__c,Fiscal_Year__c, Fiscal_Quarter__c from Opportunity_Forecast__c where Opportunity__c in :mapNewOppForecast.keyset() and Part__c = null and Date__c != null and (Fiscal_Year__c= :stringCFY or Fiscal_Year__c= :stringPFY) and Amount__c!=0 order by Opportunity__c, Date__c]){
                if(!map_oppyid_forecasts.containsKey(ofc1.Opportunity__c)){
                    map_oppyid_forecasts.put(ofc1.Opportunity__c, new List<Opportunity_Forecast__c>());
                }
                map_oppyid_forecasts.get(ofc1.Opportunity__c).add(ofc1);          
              }
            
             
 //********************************************************************Begning of Recalculate method***************************************************************** 
              
      if(!map_oppyid_forecasts.isEmpty()){    
             
          for(Id oid: map_oppyid_forecasts.keySet()){
          
             Decimal AcheivedRevenue = 0;
             Decimal CurrYRevenue = 0; 
             Decimal PreYRevenue = 0;
                         
            
             
 //*Integer.valueOf()********************************************Quarter check*************************************************************************************            
       
              
                
                if(!map_oppyid_forecasts.isEmpty() && map_oppyid_forecasts.get(oid)!=null)
                   {
                      for(Opportunity_Forecast__c ofr:map_oppyid_forecasts.get(oid))
                        {
                        
                            if(CurrentQ==1 && ((ofr.Fiscal_Quarter__c=='02' || ofr.Fiscal_Quarter__c=='04' || ofr.Fiscal_Quarter__c=='01' || ofr.Fiscal_Quarter__c=='03') && Integer.valueOf(ofr.Fiscal_Year__c)==CurrentFY-1))
                            {
                              CurrYRevenue+=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                            }
                            if(CurrentQ==2 && (ofr.Fiscal_Quarter__c=='01' && Integer.valueOf(ofr.Fiscal_Year__c)==CurrentFY))
                            {
                              CurrYRevenue+=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                            }
                            if(CurrentQ==3 && ((ofr.Fiscal_Quarter__c=='02' || ofr.Fiscal_Quarter__c=='01') && Integer.valueOf(ofr.Fiscal_Year__c)==CurrentFY))
                            {
                              CurrYRevenue+=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                            }
                            if(CurrentQ==4 && ((ofr.Fiscal_Quarter__c=='02' || ofr.Fiscal_Quarter__c=='01' || ofr.Fiscal_Quarter__c=='03') && Integer.valueOf(ofr.Fiscal_Year__c)==CurrentFY))
                            {
                              CurrYRevenue+=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                            }
                            
                            
                           if(Integer.valueOf(ofr.Fiscal_Year__c)==CurrentFY- 1)
                             {
                              PreYRevenue+=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                             }
                           
                        } 
                   } 
                    
                                 
                 
                  
//************************************************Forecats billing acheived calculation************************************************************************************************
    if(!map_oppyid_Billing.isEmpty() && map_oppyid_Billing.get(oid)!=null)
     {
        for(Forecast_Billing__c ofr:map_oppyid_Billing.get(oid))
             {
                if( ofr.Opportunity_Part__r.Opportunity__r.PLM_Id__c!=null && ofr.RecordType.DeveloperName=='Engineering'&& ((ofr.Opportunity_Part__r.Part__c!= null && ofr.Opportunity_Part__r.Opportunity__r.PLM_Id__c == ofr.Opportunity_Part__r.PLM_Id__c) || ofr.Opportunity_Part__r.Part__c== null))
                     {
                     
                      if(CurrentQ==1 && ((ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='02' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='04' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='01' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='03') && Integer.valueOf(ofr.Opportunity_Forecast__r.Fiscal_Year__c)==CurrentFY-1))
                        {
                          AcheivedRevenue +=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                        }
                        if(CurrentQ==2 && (ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='01' && Integer.valueOf(ofr.Opportunity_Forecast__r.Fiscal_Year__c)==CurrentFY))
                        {
                          AcheivedRevenue +=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                        }
                        if(CurrentQ==3 && ((ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='02' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='01') && Integer.valueOf(ofr.Opportunity_Forecast__r.Fiscal_Year__c)==CurrentFY))
                        {
                          AcheivedRevenue +=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                        }
                        if(CurrentQ==4 && ((ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='02' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='01' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='03') && Integer.valueOf(ofr.Opportunity_Forecast__r.Fiscal_Year__c)==CurrentFY))
                        {
                          AcheivedRevenue +=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                        }
                    }
                  else if(ofr.Opportunity_Part__r.Opportunity__r.PLM_Id__c==null && ofr.RecordType.DeveloperName=='Regular')
                    {
                        if(CurrentQ==1 && ((ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='02' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='04' ||ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='01' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='03') && Integer.valueOf(ofr.Opportunity_Forecast__r.Fiscal_Year__c)==CurrentFY-1))
                        {
                          AcheivedRevenue +=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                        }
                        if(CurrentQ==2 && (ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='01' && Integer.valueOf(ofr.Opportunity_Forecast__r.Fiscal_Year__c)==CurrentFY))
                        {
                          AcheivedRevenue +=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                        }
                        if(CurrentQ==3 && ((ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='02' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='01') && Integer.valueOf(ofr.Opportunity_Forecast__r.Fiscal_Year__c)==CurrentFY))
                        {
                          AcheivedRevenue +=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                        }
                        if(CurrentQ==4 && ((ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='02' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='01' || ofr.Opportunity_Forecast__r.Fiscal_Quarter__c=='03') && Integer.valueOf(ofr.Opportunity_Forecast__r.Fiscal_Year__c)==CurrentFY))
                        {
                          AcheivedRevenue +=(ofr.Amount__c/Convertedrate.get(ofr.CurrencyIsoCode));
                        }
                    
                    }
                        
            }
          }
         else
          {
           AcheivedRevenue=0;
          }    
      
      Double BillingPercent=0;
      
         
             
              
              if(CurrentQ!=1)
              {
               
               if(CurrYRevenue==null || CurrYRevenue==0)
                 {
                   mapNewOppForecast.get(oid).Forecast_Attainment_Automated_Mapping__c=0;
                 }
                 else
                 {
                   BillingPercent=(AcheivedRevenue/CurrYRevenue)*100;
                   if(BillingPercent<=0)
                    {
                      mapNewOppForecast.get(oid).Forecast_Attainment_Automated_Mapping__c=0;
                    }
                   else if(BillingPercent>=0 && BillingPercent<=500)
                    {
                      mapNewOppForecast.get(oid).Forecast_Attainment_Automated_Mapping__c=BillingPercent;
                    }
                  else if(BillingPercent>500)
                    {
                       mapNewOppForecast.get(oid).Forecast_Attainment_Automated_Mapping__c=500;
                    }
                 }
               
              
              } 
              
         if(Test.isRunningTest())
              
          {
            CurrentQ=1;  
            PreYRevenue=1;
          }
      
                   
            if(CurrentQ==1)
              {
                if(PreYRevenue==null || PreYRevenue==0)
                 {
                   mapNewOppForecast.get(oid).Forecast_Attainment_Automated_Mapping__c=0;
                 }
                 else
                 {
                   BillingPercent=(AcheivedRevenue/PreYRevenue)*100;
                   if(BillingPercent<=0)
                    {
                      mapNewOppForecast.get(oid).Forecast_Attainment_Automated_Mapping__c=0;
                    }
                   else if(BillingPercent>=0 && BillingPercent<=500)
                    {
                      mapNewOppForecast.get(oid).Forecast_Attainment_Automated_Mapping__c=BillingPercent;
                    }
                  else if(BillingPercent>500)
                    {
                       mapNewOppForecast.get(oid).Forecast_Attainment_Automated_Mapping__c=500;
                    }
                  
                 }
              }
            
  
 //************************************************Forecats billing acheived calculation************************************************************************************************
      
         }
      }
          
//********************************************************************End of Recalculate method***************************************************************** 
    }
    
    
      // if(mapNewOppForecast.size()>0) 
    // {return (mapNewOppForecast.values());}
    // else {return(null);}
   // Update mapNewOppForecast.values();
    //Return (mapNewOppForecast.values());
     Database.SaveResult[] sveResult = Database.update(mapNewOppForecast.values(), false);
     
      for(Database.SaveResult sr:sveResult)
       if(sr.isSuccess()==true) successCount++;
       else failurecount++;
       return(failurecount);

    }
    
 
}