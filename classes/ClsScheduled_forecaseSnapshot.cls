/** 
*    scheduler class for forecast snapshot
*
@author Xia Tong
@created 2013-01-09 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-01-09 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/
global class ClsScheduled_forecaseSnapshot implements Schedulable{
    global void execute(SchedulableContext sc) {
        
        if(Apex_Helper_Settings__c.getInstance('forecastSnapshotAtLastMonthDay') != null && Apex_Helper_Settings__c.getInstance('forecastSnapshotAtLastMonthDay').Active__c){
	        for(Period p: [SELECT EndDate, StartDate, Type FROM Period where Type='Month' and EndDate =: system.today() limit 1]){
	            ClsBatch_forecastSnapshot batch = new ClsBatch_forecastSnapshot(); 
	            database.executebatch(batch);
	        }
        }
        else{
        	ClsBatch_forecastSnapshot batch = new ClsBatch_forecastSnapshot(); 
        	database.executebatch(batch);     
        }        
    }
}