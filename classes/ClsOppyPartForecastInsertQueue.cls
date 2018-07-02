/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A queue class for handle Opportunity_Part_Forecast__c records in order to avoid DML limit.
			   The user story number is Opportunity Part Forecast.
Inputs:        list_OppyPartForecasts - the list of Opportunity_Part_Forecast__c records to handle
Test Class:    ClsOppyPartForecastInsertQueue_Test
History
2017-08-28 	Yiming Shen <yiming.shen@capgemini.com> Created
------------------------------------------------------------*/
public with sharing class ClsOppyPartForecastInsertQueue  implements Queueable {
    private List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Insert;
              
  	public ClsOppyPartForecastInsertQueue(List<Opportunity_Part_Forecast__c> list_OppyPartForecasts) {
        this.list_OppyPartForecasts2Insert = list_OppyPartForecasts;
  	}
              
   	public void execute(QueueableContext queCont) {
   		try{
   			if(list_OppyPartForecasts2Insert.size() > 0){
	   			insert list_OppyPartForecasts2Insert;
   			}
   		}catch(Exception e){
   			System.debug('---e:::' + e.getMessage());
   			String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
   			//ErrorLogging.Log(e);
   		}
   	}
}