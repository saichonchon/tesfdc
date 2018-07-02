/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A queue class for clone Opportunity_Part__c records in order to avoid DML limit.
Inputs:        originalOppyId - the original opportunity Id
			   newOppyId - the new clone opportunity Id
Test Class:    ClsOppyPartForecastInsertQueue_Test
History
2018-01-26 	Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
public with sharing class ClsCloneOppyPartQueue  implements Queueable {
    private Id oppyId;
    private Id oppyCloneId;
    public static boolean bool_isInCloneOppyPartQueue = false;
              
  	public ClsCloneOppyPartQueue(Id newOppyId, Id originalOppyId) {
        this.oppyCloneId = newOppyId;
        this.oppyId = originalOppyId;
        bool_isInCloneOppyPartQueue = true;
  	}
              
   	public void execute(QueueableContext queCont) {
   		try{
   			System.debug('---oppyPart limit:::' + limits.getQueries());
   			bool_isInCloneOppyPartQueue = true;
	    	String queryOppyPart = 'SELECT ';
	    	Schema.FieldSet oppyPartFieldSet = Schema.SObjectType.Opportunity_Part__c.fieldSets.Clone_Opportunity;
	        for(Schema.FieldSetMember f : oppyPartFieldSet.getFields()){
	            queryOppyPart += f.getFieldPath() + ', ';
	        }
	    	queryOppyPart += 'Id FROM Opportunity_Part__c WHERE Opportunity__c =: oppyId';
	    	List<Opportunity_Part__c> list_OppyParts2Clone = new List<Opportunity_Part__c>();
	        for(Opportunity_Part__c oppyPart : Database.query(queryOppyPart)){
	            list_OppyParts2Clone.add(oppyPart);
	        }
	        System.debug('---list_OppyParts2Clone:::' + list_OppyParts2Clone.size());
	        if(list_OppyParts2Clone.size() > 0){
	            List<Opportunity_Part__c> list_OppyParts2Insert = list_OppyParts2Clone.deepClone(false,false,false);
	            for(Opportunity_Part__c oppyPart : list_OppyParts2Insert){
	                oppyPart.Opportunity__c = oppyCloneId;
	                oppyPart.Status__c = 'Pending';
	                oppyPart.isCloned__c = true;
	                oppyPart.Approval_Status__c = 'Not Needed';
	                oppyPart.Offered_Price__c = 0;
	                oppyPart.Standard_Cost__c = 0;
	                oppyPart.Sales_Price__c = 0;
	                oppyPart.Error_Message__c = null; //Added by Buwen Guo 2018-03-28 requirement from email:Requests for Part Mgmt point 1
	                oppyPart.Info_Message__c = null; //Added by Buwen Guo 2018-03-28 requirement from email:Requests for Part Mgmt point 1
	            }
	            System.debug('---list_OppyParts2Insert:::' + list_OppyParts2Insert.size());
	            
	            //added by Tangyong Li 2018-02-13 ::: retrigger opportunity part trigger.
	            OpportunityPartTrgHandler.isMultipleBeforeInsert = false; 
			    OpportunityPartTrgHandler.isMultipleBeforeUpdate = false; 
			    OpportunityPartTrgHandler.isMultipleBeforeDelete = false; 
			    OpportunityPartTrgHandler.isMultipleAfterInsert = false; 
			    OpportunityPartTrgHandler.isMultipleAfterUpdate = false; 
			    OpportunityPartTrgHandler.isMultipleAfterDelete = false; 
			    //end
			    
	        	insert list_OppyParts2Insert;
	        }
	        System.debug('---oppyPart limit:::' + limits.getQueries());
   		}catch(Exception e){
   			System.debug('---e:::' + e.getMessage());
   			String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
   		}
   	}
}