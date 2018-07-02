/**********************************************************************
Name:  ADMOpportunityHelper
Copyright © 2017
======================================================
======================================================
Purpose:  ADMOpportunityHelper Class - validates Relevant for SOP Check based on mulitple conditions.
-------                                      
======================================================
======================================================
History                                                                                                                        
VERSION      AUTHOR                DATE             DETAIL Description
0.1          Vaibhav Magdum        10/07/2017       INITIAL DEVELOPMENT
0.2			 Vaibhav Magdum 	   09/11/2017       INITIAL DEVELOPMENT
***********************************************************************/
public class ADMOpportunityHelper{
    
   
    public static void oppyTrigger(Set<Id> associatedAccId, List<Opportunity>list_ADMOppys,ClsWrappers.TriggerContext trgCtx ){
        try{
            
            //Get Account record type id of Name-Account
            Id accountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
            
            //Get opportunity record type id of Name-ADM
            Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
  
            
            //Get current year
            Date todaydate = System.Today();
            FiscalYearSettings currentfisobj = [select id,name from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
            String currentYear = currentfisobj.name;
            String nextYear = String.valueOf(Integer.ValueOf(currentfisobj.name)+1);
            List <String> yearlist = new List<string>{currentYear,nextYear};
            
            //Get account record type of respective opportunity  
                if(associatedAccId.size() > 0){
                    Map <id, account> mapOfAccounts = new Map <id, account>([SELECT Id, RecordTypeId FROM account WHERE Id in: associatedAccId]);
                    
                    Map <String, List<Opportunity_Forecast__c>> Opportunityfdlist=new Map <String, List<Opportunity_Forecast__c>>();
                    if(trgCtx.IsUpdate)
                    {     
                        //Opportunityfdlist = new Map<ID, sObject>([SELECT id, (SELECT Id,Name FROM Forecast__r where Fiscal_Year__c in : yearlist AND RecordType.Name = 'Part') from Opportunity where id in: trigger.newMap.keySet()]);         
                        List<Opportunity_Forecast__c> ofdclist=[SELECT Id,Name,Opportunity__c FROM Opportunity_Forecast__c where Fiscal_Year__c in : yearlist AND RecordType.Name = 'Part' AND Opportunity__c in :list_ADMOppys];
                        if(ofdclist.size()>0){
                            for(Opportunity_Forecast__c ofdc:ofdclist)
                            {
                                if(ofdc!= null)
                                {
                                    if(Opportunityfdlist.containsKey(String.valueof(ofdc.Opportunity__c))){              
                                        Opportunityfdlist.get(String.valueof(ofdc.Opportunity__c)).add(ofdc);}      
                                    else{
                                        Opportunityfdlist.put(String.valueof(ofdc.Opportunity__c),new list<Opportunity_Forecast__c>{ofdc});
                                    }
                                }
                            } 
                        }         
                        System.debug('Opportunityfdlist --'+Opportunityfdlist);
                    }
                    
                    
                    
                    for (Opportunity opp: (List<Opportunity>)list_ADMOppys){     
                        
                        String daccRecordTypeId='';
                        if(mapOfAccounts.get(opp.AccountId) != null)
                            daccRecordTypeId=mapOfAccounts.get(opp.AccountId).RecordTypeId;      
                        
                        if(daccRecordTypeId == accountRecordTypeId && opp.Relevant_for_S_OP__c  == True && opp.RecordTypeId == oppRecordTypeId)
                        {         
                            if(trgCtx.IsUpdate)
                            { 
                                List<Opportunity_Forecast__c> frcstlst = new List<Opportunity_Forecast__c>();
                                frcstlst.clear();
                                if(Opportunityfdlist.containsKey(String.valueof(opp.Id)))              
                                    frcstlst =Opportunityfdlist.get(String.valueof(opp.Id));
                                
                                
                                if(opp.Relevant_for_S_OP__c  != ((Opportunity)trgctx.oldmap.get(opp.id)).Relevant_for_S_OP__c)
                                {
                                    if(opp.Level__c != 'Monthly' || opp.Method__c != 'Manual' || frcstlst.size() < 1){
                                        opp.addError(System.Label.ADMCustErrorSop);
                                    }
                                }
                                else  if((opp.Level__c != 'Monthly') || (opp.Method__c != 'Manual')){
                                    opp.addError(System.Label.ADMCustErrorSop2);
                                }                
                            }
                            else if(trgCtx.IsInsert)
                            {              
                                //if(opp.Level__c != 'Monthly' || opp.Method__c != 'Manual' || frcstlst.size() < 1){
                                opp.addError(System.Label.ADMCustErrorSop);
                                //    }
                            }                    
                        }
                        else if(daccRecordTypeId != accountRecordTypeId && opp.Relevant_for_S_OP__c  == True && opp.RecordTypeId == oppRecordTypeId)
                        {
                            opp.addError(System.Label.ADMCustErrorSop);
                        }
                        
                    }
                }
           
        }
        catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMOpportunityHelper', '','');
            //return null;    
        }
        
    }
    
    
    
}