/**
*   apex class: ClsBatch_OEM_MonthlyBBBSummary
*
@author Nelson Zheng
@version 1.0
*
* 2015-05-16 Nelson Zheng
* rewrite the logic to fix the bug of billing amount of OEM Details.
*/
global class ClsBatch_OEM_MonthlyBBBSummary implements Database.Batchable<SObject>,Database.Stateful{

    //03-19-2014 Michael Cui: update the execute method because the 4 static maps were changed in DetectOverlappingOEMMapRules method in ClsOEMUtil class.
    public String query;
          
    public String CurrentPeriodFMonth;
    public String CurrentPeriodFYear;
    public String PriorPeriodFMonth;
    public String PriorPeriodFYear;
    
    public ClsBatch_OEM_MonthlyBBBSummary(String fiscalMonth, String fiscalYear){        
        CurrentPeriodFMonth = fiscalMonth;
        CurrentPeriodFYear = fiscalYear;
        
        if(CurrentPeriodFMonth == '01')
        {
            PriorPeriodFMonth = '12';
            PriorPeriodFYear = String.valueOf(Integer.valueOf(CurrentPeriodFYear) - 1);
        }
        else
        {
            PriorPeriodFMonth = String.valueOf(Integer.valueOf(CurrentPeriodFMonth) - 1).leftpad(2).replace(' ', '0');
            PriorPeriodFYear = CurrentPeriodFYear;
        }
                 
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
       
       if (query == null || query == ''){
        Integer BBBMonth = Integer.valueOf(CurrentPeriodFMonth);
            query =   'Select Id, Billing__c,OEM__c ' +
                      ' from OEM_Details__c ' +
                      ' where fiscal_month__c =: CurrentPeriodFMonth and fiscal_year__c =: CurrentPeriodFYear' +
                      ' and IsDeleted = false' ;
       }      
        return Database.getQueryLocator(query);         
    }

    global void execute(Database.BatchableContext BC, list<OEM_Details__c> oemDetailsList){
        if (oemDetailsList.size() > 0){
            Set<Id> oemDetailIdSet = new Set<Id>();
            Map<Id,OEM_Details__c> forUpdateOEMDetailsMap = new Map<Id,OEM_Details__c>();
            List<OEM_Mapping_Rule__c> forUpdateOEMMappingList = new List<OEM_Mapping_Rule__c>();
            
            for(OEM_Details__c oemD : oemDetailsList){
                //oemDetailIdSet.add(oemD.Id);
                
                oemD.billing__c = 0;
                
            }
            forUpdateOEMDetailsMap.putAll(oemDetailsList);
            
            Map<Id,OEM_Mapping_Rule__c> OEMMappingRulelist = New Map<Id,OEM_Mapping_Rule__c>([select id,Tech_Billing__c from OEM_Mapping_Rule__c where OEM__c in: forUpdateOEMDetailsMap.keySet()]);
            
            List<AggregateResult> oemMappingAggreList = [select OEM_Mapping__r.OEM__c oem,OEM_Mapping__c,sum(Billing_Amount_After_Allocation__c)billing from CSD_OEM_Mapping_Monthly_BBB__c where OEM_Mapping__r.OEM__c in: forUpdateOEMDetailsMap.keySet() group by OEM_Mapping__r.OEM__c,OEM_Mapping__c];
            
            for(AggregateResult oemMappingAggre : oemMappingAggreList){
                
                OEM_Mapping_Rule__c oemM = OEMMappingRulelist.get((Id)oemMappingAggre.get('OEM_Mapping__c'));
                if(oemM != null){
                    oemM.Tech_Billing__c = (Decimal)oemMappingAggre.get('billing');
                    forUpdateOEMMappingList.add(oemM);
                }
                forUpdateOEMDetailsMap.get((Id)oemMappingAggre.get('oem')).billing__c += (Decimal)oemMappingAggre.get('billing');
            }
            
            update forUpdateOEMDetailsMap.values();
            update forUpdateOEMMappingList;
        }
      
    }
    
    global void finish(Database.BatchableContext BC){           
           
    }      
}