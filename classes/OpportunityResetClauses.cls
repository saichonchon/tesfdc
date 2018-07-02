/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   Custom button 'Reset Clauses' on Opportunity detail page
Inputs:        
Test Class:    OpportunityResetClauses_Test
History
2017-11-30 	   Yiming Shen <yiming.shen@capgemini.com>	Created
------------------------------------------------------------*/
global with sharing class OpportunityResetClauses {
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to delete the existing clauses on the Opportunity and 
				   create new ANZ Clause records (from the ANZ Clause Master records) on the same opportunity
	Inputs:        currentOppyId - current opportunity Id which needs to reset clauses
	Returns:       String - the json string of result
	History
	2017-11-30 	   Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    webservice static String resetClauses(Id currentOppyId,String currentOppyQuoteType){
	   Id oppyId = currentOppyId;
	   String oppyType = currentOppyQuoteType;
       System.debug('---oppyType:::' + oppyType);
	   ExecuteResult executeResult = new ExecuteResult();
	   String result;
	   List<ANZ_Clause__c> list_Clauses2Delete = new List<ANZ_Clause__c>();
	   List<ANZ_Clause__c> list_Clauses2Insert = new List<ANZ_Clause__c>();
	   for(ANZ_Clause__c clause : [SELECT Id FROM ANZ_Clause__c WHERE Opportunity__c =: oppyId]){
	   		list_Clauses2Delete.add(clause);
	   }
	   try{
	   	   System.debug('---list_Clauses2Delete:::' + list_Clauses2Delete);
		   if(list_Clauses2Delete.size() > 0){
		   		delete list_Clauses2Delete;
		   }
		   for(ANZ_Clause_Master__c clauseMaster : [SELECT Id, Name, Insurance__c, Opportynity_Type__c, Sequence_No__c 
		   											FROM ANZ_Clause_Master__c
		   											WHERE Opportynity_Type__c = 'Quote'
                                                    OR Opportynity_Type__c = 'Tender'
		   											order by Sequence_No__c]){
                System.debug('---clauseMaster:::' + clauseMaster);               
                if((oppyType == 'Standard' && clauseMaster.Opportynity_Type__c == 'Quote')
                ||(oppyType == 'Blanket/Tender' && clauseMaster.Opportynity_Type__c == 'Tender')){                                     
                    ANZ_Clause__c newClause = new ANZ_Clause__c();
                    newClause.Name = clauseMaster.Name;
                    newClause.ANZ_Clause_Master__c = clauseMaster.Id;
                    newClause.Opportunity__c = oppyId;
                    newClause.Insurance__c = clauseMaster.Insurance__c;
                    newClause.Opportynity_Type__c = clauseMaster.Opportynity_Type__c;
                    newClause.Sequence_No__c = clauseMaster.Sequence_No__c;
                    list_Clauses2Insert.add(newClause);
                }
		   }
		   System.debug('---list_Clauses2Insert:::' + list_Clauses2Insert);
		   if(list_Clauses2Insert.size() > 0){
		   		insert list_Clauses2Insert;
		   }
		   executeResult.isSuccessful = true;
	   }catch(Exception e){
	   	   System.debug('---e:::' + e.getMessage());
	   	   executeResult.isSuccessful = false;
		   executeResult.resultMessage = e.getMessage();
	   }
	   System.debug('---executeResult:::' + executeResult);
	   result = JSON.serialize(executeResult);
	   return result;
    }
    
    public class ExecuteResult{
    	public Boolean isSuccessful;
    	public String resultMessage;
    }
}