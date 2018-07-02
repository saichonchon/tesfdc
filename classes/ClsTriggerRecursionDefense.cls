/**
 *  Used to prevent mutiple execution of triggers
 * 
 * @author Min Liu
 * @created 2012-09-26
 * @version 1.0
 * @since 23.0
 * 
 * @changelog
 * 2012-09-26 Min Liu <min.liu@itbconsult.com>
 * - Created   
 *
 */
public class ClsTriggerRecursionDefense {
    // To prevent the opportunity part updating the opportunity phase again when opportunity phase is set to Rejected - Closed
    public static Boolean partUpdateOpportunity = true;
    // To prevent the execute of the trigger opportunity_BIU_defineApprovers
    public static Boolean defineApproversInsert = true;
    public static Boolean defineApproversUpdate = true;
    public static Boolean bbbMonthlyUpdate = true;
    // Added by Mrunal to prevent the opportunity part updating the opportunity phase again for channel change opportunity at header level Project
    public static Boolean isFirstRun = true;
    
    public static boolean OpportunityAnzClauseTrigger = true;
    public static boolean isSkipCreateANZClause = false; //added by Tangyong Li 2018-03-16
    
    public static map<Id, Boolean> map_oppyId_isEnergy = new map<Id, Boolean>();
    public static set<Id> set_rtIds = new set<Id>();
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to skip Opportunity_Part__c triggers if parent Opportunity record type is Energy.
	Inputs:        set_oppyIds - a set of Opportunity Ids
	Returns:       true - skip triggers
				   false - no skip    
	History
	2017-10-20 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public static Boolean avoidMultipleRunningForTrigger(set<Id> set_oppyIds) {
    	Boolean isEnergyOppy = false;
    	set<Id> set_newOppyIds = new set<Id>();
    	if(set_rtIds.size() == 0) {
    		set_rtIds.add(Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Energy - Sales').getRecordTypeId());
    	}
    	for(Id oppyId : set_oppyIds){
    		if(map_oppyId_isEnergy.containsKey(oppyId)){
    			if(map_oppyId_isEnergy.get(oppyId)){
    				isEnergyOppy = true;
    				return isEnergyOppy;
    			}
    		}else{
    			set_newOppyIds.add(oppyId);
    		}
    	}
    	if(set_newOppyIds.size() > 0){
	    	for(Opportunity oppy : [SELECT RecordTypeId FROM Opportunity WHERE Id IN: set_newOppyIds]){
	    		if(set_rtIds.contains(oppy.RecordTypeId)){
	    			isEnergyOppy = true;
					map_oppyId_isEnergy.put(oppy.Id,true);
	    		}else{
	    			map_oppyId_isEnergy.put(oppy.Id,false);
	    		}
	    	}
    	}
    	return isEnergyOppy;
    }
    
    public static void doCatch(Exception e){
    	//ErrorLogging.Log(e);
        String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
        SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());   
    }
}