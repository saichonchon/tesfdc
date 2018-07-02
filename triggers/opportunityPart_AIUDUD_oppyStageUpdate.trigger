/**. STAGE
*  This trigger is used to updates the Opportunity Stage when the status of  Part Process Status is not “New”.
*
@  author Bin Yuan
@  created 2012-09-03
@  version 1.0
@  since 25.0 (Force.com ApiVersion)
*
@  changelog
* 2016-11-03   Prabhanjan N
* - Escaping ADM records to be involved in regular header changes process an
*  2014-06-04    Mrunal Parate<Mrunal.Parate@zensar.in>
*  -modified trigger login for NDR Opportunity for case 00726111.
*
*  2014-06-04    Lili Zhao <lili.zhao@itbconsult.com>
*  -modify that trigger is only fired for recordType in Opportunity Parts Managed Stages Group, and contians PMV RecordType for define GPL
*
*  2014-03-05    Jinbo Shan <jinbo.shan@itbconsult.com>
*  -modify that trigger is only fired for recordType in Opportunity Parts Managed Stages Group
*  2014-06-18    Jinbo Shan <jinbo.shan@itbconsult.com>
*  -added to update DGI Value for Opportunity
*
*   2012-09-03   Bin Yuan <bin.yuan@itbconsult.com>
*   - Created

* Prabhanjan: Observed that No exception handing was implemented, so I added the try catch blocks with proper message and stack tracing
*/

trigger opportunityPart_AIUDUD_oppyStageUpdate on Opportunity_Part__c (after delete, after insert, after undelete,   after update) {
    
    Admin_Profile_Exception__c CS = Admin_Profile_Exception__c.getInstance();
    if(CS.opportunityPart_AIUDUD_oppyStageUpdate__c){
         return;
    }
    
    String triggerName = 'Opportunity_Part__c';
    map<Id,Id> ADM_OppIdToRTId = new map<Id,Id>();
    set<Id> set_oppyId = new set<Id>();
    //Change start by Mrunal for Change Channel Opportunities at header level Project
    //set<Id> set_NDRoppyId = new set<Id>();// Added by Mrunal Parate for case 00726111
    set<Id> set_chnlOppyId = new set<Id>();
    //Change End by Mrunal for Change Channel Opportunities at header level Project
    //added by xia 2013-01-10 defined GPLs
    map<Id, set<String>> map_oppyId_gpls = new map<Id, set<String>>();
    map<Id,String> map_gplId_gplName = new map<Id,String>();
    map<Id, set<Id>> map_gplId_oppyIds = new map<Id, set<Id>>();
    set<Id> set_oppyId4DefinedGPLs = new set<Id>();
    
    set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
    set<Id> set_oppyIds = new set<Id>();
    
    boolean ADM_runStageUpdate = false;
    map<Id,string> partStatus = new map<id,string>();
    
    //Change Start by Mrunal for Change Channel Opportunities at header level Project
    //Apex_Helper_Settings__c config = Apex_Helper_Settings__c.getInstance('NDR Opportunity');// Added by Mrunal Parate for case 00726111
    //Id ndrRecordType = config.Value__c;// Added by Mrunal Parate for case 00726111*/
    public set<string> set_oppyRecordTypeId = new set<string>();
    for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
        if(rt.Active__c && rt.Group__c == 'Change Channel Opportunities at header level' && rt.RecordTypeID__c!= null)
            set_oppyRecordTypeId.add(rt.RecordTypeID__c);      
    }
    //Change End by Mrunal for Change Channel Opportunities at header level Project
    public Id energyOppyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Energy - Sales').getRecordTypeId();
    
    if(Trigger.isInsert || Trigger.isUnDelete) {
        try{
            for(Opportunity_Part__c oppyPart : [select Id,status__c, GPL__c, Opportunity__c, opportunity__r.StageName, Opportunity__r.RecordTypeId from Opportunity_Part__c where Id IN :trigger.newMap.keySet()]) {
                //system.debug('**@@oppyPart = ' + oppyPart);
                //Change start by Mrunal for Change Channel Opportunities at header level Project
                /*if(!set_rts.contains(oppyPart.Opportunity__r.RecordTypeId)) {
set_oppyId.add(oppyPart.Opportunity__c);
} else {*/
                
                //Checking for ADM
                if(oppyPart.Opportunity__r.RecordTypeId==Opportunity_Record_Type_Groups__c.getInstance('ADM').RecordTypeID__c ) {
                    //Prabhanjan - ADM Migration - Building the Map of Opp Id and RT 
                    ADM_OppIdToRTId.put(oppyPart.Opportunity__c, oppyPart.Opportunity__r.RecordTypeId);
                    ADM_runStageUpdate = true;
                    partStatus.put(oppyPart.Id, oppyPart.Status__c);
                }
                else { 
                    
                    if(!set_rts.contains(oppyPart.Opportunity__r.RecordTypeId) 
                    && !set_oppyRecordTypeId.contains(oppyPart.Opportunity__r.RecordTypeId)
                    //Added By Yiming Shen <yiming.shen@capgemini.com> at 2018/04/09
                    && oppyPart.Opportunity__r.RecordTypeId != energyOppyRecordTypeId
                    //Ended By Yiming Shen <yiming.shen@capgemini.com> at 2018/04/09
                     ) 
                    {  
                        set_oppyId.add(oppyPart.Opportunity__c); 
                    }
                    
                    
                    if(set_rts.contains(oppyPart.Opportunity__r.RecordTypeId)){
                        //Change End by Mrunal for Change Channel Opportunities at header level Project
                        //added by Jinbo Shan 2014-06-18
                        set_oppyIds.add(oppyPart.Opportunity__c); 
                    }
                    //added by xia 2013-01-10 defined GPLs
                    if(oppyPart.GPL__c != null){
                        set_oppyId4DefinedGPLs.add(oppyPart.Opportunity__c);
                    }
                    //Change Start by Mrunal for Change Channel Opportunities at header level Project
                    // Added by Mrunal Parate for case 00726111
                    /*if(oppyPart.Opportunity__r.RecordTypeId == ndrRecordType){
set_NDRoppyId.add(oppyPart.Opportunity__c);
}*/
                    if(set_oppyRecordTypeId.contains(oppyPart.Opportunity__r.RecordTypeId)){
                        set_chnlOppyId.add(oppyPart.Opportunity__c);
                    }
                    //Change End by Mrunal for Change Channel Opportunities at header level Project
                }
            }
        }
        catch(exception e){
            system.debug(e.getMessage()+' at '+ e.getStackTraceString());
        }
    }
    
    if(Trigger.isUpdate) {
        try{
            if(ClsTriggerRecursionDefense.partUpdateOpportunity){
                for(Opportunity_Part__c oppyPart : [select Id, Opportunity__c, GPL_Name__c, Status__c, Process_Status__c, Opportunity__r.RecordTypeId from Opportunity_Part__c where Id IN :trigger.newMap.keySet()]) {
                    
                    //Checking for ADM
                    if(oppyPart.Opportunity__r.RecordTypeId==Opportunity_Record_Type_Groups__c.getInstance('ADM').RecordTypeID__c ) {
                        //Prabhanjan - ADM Migration - Building the Map of Opp Id and RT 
                        ADM_OppIdToRTId.put(oppyPart.Opportunity__c, oppyPart.Opportunity__r.RecordTypeId);
                        ADM_runStageUpdate = true;
                        partStatus.put(oppyPart.Id, oppyPart.Status__c);
                    }
                    else { 
                        //system.debug('**@@oppyPart = ' + oppyPart);
                        if((trigger.oldMap.get(oppyPart.Id).Status__c != oppyPart.Status__c || trigger.oldMap.get(oppyPart.Id).Process_Status__c != oppyPart.Process_Status__c) 
                           && !set_rts .contains(oppyPart.Opportunity__r.RecordTypeId) && !set_oppyRecordTypeId.contains(oppyPart.Opportunity__r.RecordTypeId)
                            //Added By Yiming Shen <yiming.shen@capgemini.com> at 2018/04/09
                            && oppyPart.Opportunity__r.RecordTypeId != energyOppyRecordTypeId
                            //Ended By Yiming Shen <yiming.shen@capgemini.com> at 2018/04/09
                           ){// set_oppyRecordTypeId condition Added by Mrunal for Change Channel Opportunities at header level
                               set_oppyId.add(oppyPart.Opportunity__c);
                           }
                        //added by xia 2013-01-10 defined GPLs
                        if(oppyPart.GPL_Name__c != trigger.oldMap.get(oppyPart.Id).GPL_Name__c){
                            set_oppyId4DefinedGPLs.add(oppyPart.Opportunity__c);
                        }
                        //added by Jinbo Shan 2014-06-18
                        if(set_rts .contains(oppyPart.Opportunity__r.RecordTypeId)) {
                            set_oppyIds.add(oppyPart.Opportunity__c);
                        }
                        //Change start by Mrunal for Change Channel Opportunities at header level Project
                        // Added by Mrunal Parate for case 00726111
                        /*if((trigger.oldMap.get(oppyPart.Id).Status__c != oppyPart.Status__c || trigger.oldMap.get(oppyPart.Id).Process_Status__c != oppyPart.Process_Status__c) && oppyPart.Opportunity__r.RecordTypeId == ndrRecordType){
set_NDRoppyId.add(oppyPart.Opportunity__c);
}*/
                        if(trigger.oldMap.get(oppyPart.Id).Status__c != oppyPart.Status__c && set_oppyRecordTypeId.contains(oppyPart.Opportunity__r.RecordTypeId)){
                            set_chnlOppyId.add(oppyPart.Opportunity__c);
                        }
                        //Change End by Mrunal for Change Channel Opportunities at header level Project
                    }
                }
            }
        }
        catch(exception e){
            system.debug(e.getMessage()+' at '+ e.getStackTraceString());
        }
        
    }
    if(Trigger.isDelete) {
        try{
            set<Id> set_oppyIdsNotFilter = new set<Id>();
            
            for(Opportunity_Part__c oppyPart : trigger.old) {
                set_oppyIdsNotFilter.add(oppyPart.Opportunity__c);
                //added by xia 2013-01-10 defined GPLs
                if(oppyPart.GPL__c != null){
                    set_oppyId4DefinedGPLs.add(oppyPart.Opportunity__c);
                }  
            }
            
            for(Opportunity oppy : [SELECT Id, RecordTypeId FROM Opportunity WHERE Id IN : set_oppyIdsNotFilter]) {
                //Change Start by Mrunal for Change Channel Opportunities at header level Project
                /*if(!set_rts.contains(oppy.RecordTypeId)) {
set_oppyId.add(oppy.Id);

}else {*/
                
                //Checking for ADM
                if( oppy.RecordTypeId==Opportunity_Record_Type_Groups__c.getInstance('ADM').RecordTypeID__c ) {
                    //Prabhanjan - ADM Migration - Building the Map of Opp Id and RT 
                    ADM_OppIdToRTId.put(oppy.Id, oppy.RecordTypeId);
                    ADM_runStageUpdate = true;
                }
                else{
                    //exempting ADM records
                    if(!set_rts.contains(oppy.RecordTypeId) && !set_oppyRecordTypeId.contains(oppy.RecordTypeId)
                    //Added By Yiming Shen <yiming.shen@capgemini.com> at 2018/04/09
                    && oppy.RecordTypeId != energyOppyRecordTypeId
                    //Ended By Yiming Shen <yiming.shen@capgemini.com> at 2018/04/09
                    )  
                        set_oppyId.add(oppy.Id);
                    if (set_rts.contains(oppy.RecordTypeId)){
                        //Change End by Mrunal for Change Channel Opportunities at header level Project
                        //added by Jinbo Shan 2014-06-18
                        set_oppyIds.add(oppy.Id);
                    }
                }
            }
        }
        catch(exception e){
            system.debug(e.getMessage()+' at '+ e.getStackTraceString());
        }
    }
    system.debug('set_oppyId ---'+set_oppyId);
    system.debug('set_oppyIds ---'+set_oppyIds);
    if(set_oppyId.size()>0){
        ClsOppyPartUtil.updateOppyStage(set_oppyId);
    }
    
    if(!set_oppyId4DefinedGPLs.isEmpty()) ClsOppyPartUtil.updateOppyDefinedGPLs(set_oppyId4DefinedGPLs);   
    //added by Jinbo Shan 2014-06-18
    if(set_oppyIds.size() > 0) {
        ClsPMV_Util.calculateDGIIndicator(set_oppyIds);
    }
    //Change Start by Mrunal for Change Channel Opportunities at header level Project
    // Added by Mrunal Parate for case 00726111
    /*if(set_NDRoppyId.size()>0){
ClsOppyPartUtil.updateNDROppyStage(set_NDRoppyId);
}*/
    if(set_chnlOppyId.size()>0){
        ClsOppyPartUtil.updateOppyStageOnPartConfChange(set_chnlOppyId);
    } 
    //Change End by Mrunal for Change Channel Opportunities at header level Project
    
    //Prabhanjan - checking for ADM_runStageUpdate and running the stage update
    if(ADM_runStageUpdate){
        ClsOppyPartUtil.ADM_updateOppyStage(partStatus, ADM_OppIdToRTId);
    }
}