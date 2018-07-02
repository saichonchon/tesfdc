/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A queue class for handle Opportunity_Part_Forecast__c records in order to avoid DML limit.
			   The user story number is Opportunity Part Forecast.
Inputs:        list_OppyPartForecasts2Del - the list of Opportunity_Part_Forecast__c records to delete
			   list_OppyPartForecasts2In  - the list of Opportunity_Part_Forecast__c records to insert
Test Class:    ClsOppyPartForecastDeleteQueue_Test
History
2017-08-28 	Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
public with sharing class ClsOppyPartForecastDeleteQueue  implements Queueable {
    private List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Delete;
  	private List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Insert;
  	
  	public ClsOppyPartForecastDeleteQueue(List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Del, List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2In) {
        this.list_OppyPartForecasts2Delete = list_OppyPartForecasts2Del;
        this.list_OppyPartForecasts2Insert = list_OppyPartForecasts2In;
  	}
              
   	public void execute(QueueableContext queCont) {
   		try{
   			if(list_OppyPartForecasts2Delete.size() > 0){
	   			delete list_OppyPartForecasts2Delete;
   			}
   			if(list_OppyPartForecasts2Insert.size() > 0){
		     	System.enqueueJob(new ClsOppyPartForecastInsertQueue(list_OppyPartForecasts2Insert));
   			}
   		}catch(Exception e){
   			System.debug('---e:::' + e.getMessage());
   			String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
   			//ErrorLogging.Log(e);
   		}
   	} 
}