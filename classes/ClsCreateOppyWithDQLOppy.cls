/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A class for CreateOpportunity custom button on Data_Qualified_Lead__c object.
Inputs:        
Test Class:    ClsCreateOppyWithDQLOppy_Test.cls
History
2017-09-21 Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
global with sharing class ClsCreateOppyWithDQLOppy {
	/*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to create Opportunity record from Data_Qualified_Lead__c record.
	Inputs:        dataQualifiedLeadID - the Id of Data_Qualified_Lead__c record
	Returns:       String - the string of execute result
	History
	2017-09-21 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    webservice static String createOpportunity(String dataQualifiedLeadID){
        ExecuteResult executeResult = new ExecuteResult();
        try{
	        Data_Qualified_Lead__c dataQualifiedLead = [SELECT Id, OwnerId, Name, Prospect_Company__c, TE_Potential_Value__c,
	                                                    Next_Step__c, Opportunity_Source__c  
	                                                    FROM Data_Qualified_Lead__c 
	                                                    WHERE Id =: dataQualifiedLeadID 
	                                                    limit 1];   
	        Opportunity oppy2Insert = new Opportunity();
	        oppy2Insert.OwnerId = dataQualifiedLead.OwnerId;
	        oppy2Insert.Name = dataQualifiedLead.Name;
	        oppy2Insert.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Energy - Sales').getRecordTypeId();
	        oppy2Insert.AccountId = dataQualifiedLead.Prospect_Company__c;
	        oppy2Insert.Opportunity_Source__c = dataQualifiedLead.Opportunity_Source__c;
	        oppy2Insert.Amount = dataQualifiedLead.TE_Potential_Value__c;
	        oppy2Insert.NextStep = dataQualifiedLead.Next_Step__c;
	        oppy2Insert.Currency_Confirm__c = true;
	        oppy2Insert.StageName = 'Initiation';
	        oppy2Insert.Probability__c = '10';
	        oppy2Insert.CloseDate = Date.today();
            insert oppy2Insert;
            DQL_Opportunity__c dqlOppy2Insert = new DQL_Opportunity__c();
            dqlOppy2Insert.Data_Qualified_Lead__c = dataQualifiedLead.Id;
            dqlOppy2Insert.Opportunity__c = oppy2Insert.Id;
            insert dqlOppy2Insert;
            executeResult.isSuccessful = true;
            executeResult.resultMessage = 'Created Successfully!';
            executeResult.oppyId = oppy2Insert.Id;
        }catch(Exception e){
            executeResult.isSuccessful = false;
            executeResult.resultMessage = 'Error:' + e.getMessage();
            System.debug('---e.getMessage():::' + e.getMessage());
            String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
            //ErrorLogging.Log(e);
        }
        return JSON.serialize(executeResult);
    }
    
    public class ExecuteResult{
        public String resultMessage;
        public Boolean isSuccessful;
        public Id oppyId;
    }
}