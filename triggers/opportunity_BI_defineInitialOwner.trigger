/**
* 
*   This Before Insert Trigger sets the opportunity creator (Owner) as "Initial Owner".
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |08.03.2012  |Initial Draft
*
*/

trigger opportunity_BI_defineInitialOwner on Opportunity(before insert){
    
    for(Opportunity oppy : Trigger.new){
        oppy.Initial_Owner__c = oppy.OwnerId;
    }
}