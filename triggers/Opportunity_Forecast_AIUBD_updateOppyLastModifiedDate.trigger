/**
* 
*   This After Insert/Update, Before Delete Trigger updates the custom opportunity "Last Modified Date" field.
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Pankaj Raijade      |pankaj.raijade@zensar.in           |15.12.2015  |Initial Draft

*/

trigger Opportunity_Forecast_AIUBD_updateOppyLastModifiedDate on Opportunity_Forecast__c (after insert, after update, before delete) {
    set<Id> setOppyID = new set<Id>();
    if(checkRecursive.runOnce()|| test.isRunningTest()){
    if(Last_Modified_Field_Update_Permission__c.getInstance() != null && Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c)
    {
        if(Trigger.isDelete)
        {
            for(Opportunity_Forecast__c oOppyForecast : Trigger.old)
                if(oOppyForecast.Opportunity__c != null)
                    setOppyID.add(oOppyForecast.Opportunity__c);
        }
        else{
            for(Opportunity_Forecast__c oOppyForecast : Trigger.new)
                if(oOppyForecast.Opportunity__c != null)
                    setOppyID.add(oOppyForecast.Opportunity__c);
        }
        if(!setOppyID.isEmpty())
                update [Select Id, Last_Modified_Date__c, Last_Modified_By_Custom__c From Opportunity Where Id in :setOppyID];
    }
    }
}