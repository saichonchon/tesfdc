/**
* 
*   This After Insert/Update, Before Delete Trigger updates the custom opportunity "Last Modified Date" field.
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Pankaj Raijade      |pankaj.raijade@zensar.in           |15.12.2015  |Initial Draft

*/

trigger Opportunity_Competitor_AIUBD_updateOppyLastModifiedDate on Opportunity_Competitor__c (after insert, after update, before delete) {
    set<Id> setOppyID = new set<Id>();
    if(Last_Modified_Field_Update_Permission__c.getInstance() != null && Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c)
    {
        if(Trigger.isDelete)
        {
            for(Opportunity_Competitor__c oOppyCompetitor : Trigger.old)
                if(oOppyCompetitor.Opportunity__c != null)
                    setOppyID.add(oOppyCompetitor.Opportunity__c);
        }
        else{
            for(Opportunity_Competitor__c oOppyCompetitor: Trigger.new)
                if(oOppyCompetitor.Opportunity__c != null)
                    setOppyID.add(oOppyCompetitor.Opportunity__c);
        }
        if(!setOppyID.isEmpty())
                update [Select Id, Last_Modified_Date__c, Last_Modified_By_Custom__c From Opportunity Where Id in :setOppyID];
    }
}