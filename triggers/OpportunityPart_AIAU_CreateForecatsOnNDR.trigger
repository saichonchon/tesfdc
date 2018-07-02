trigger OpportunityPart_AIAU_CreateForecatsOnNDR on Opportunity_Part__c (after insert, after update) {
    
    /** Create forecast records on NDR opportunity **/
    /**
    1. Check for the trigger event, it should only be after insert and after update
    2. Loop on all parts and check for records type - it should be ndr part. Also check for status - it should be changed to Complete
    3. Create a set of all opportunity ids.
    4. pass the set of opportunity ids to the future method     
    **/
    //1. Check for the trigger event, it should only be after insert and after update
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        //get record type of NDR parts
        Apex_Helper_Settings__c config = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');
        Id ndrRecordType = config.Value__c;
        Set<Id> setOpportunityIds = new Set<Id>();
        
        //2. Loop on all parts and check for records type - it should be ndr part. Also check for status - it should be changed to Complete
        for(Opportunity_Part__c part : Trigger.new){
            if(part.RecordTypeId == ndrRecordType && part.NDRForecastCreated__c != true && part.NDR_Item_Status_Desc__c == 'Complete' && part.NDR_Alternate_Part__c != true){// NDR_Alternate_Part__c check added by Mrunal for NDR Phase II Enhancement project.
                if(Trigger.isInsert){
                    setOpportunityIds.add(part.Opportunity__c); 
                }
                else if(Trigger.isUpdate && Trigger.OldMap.get(part.Id).NDR_Item_Status_Desc__c != 'Complete'){
                    setOpportunityIds.add(part.Opportunity__c);
                }
            }           
        }
        System.debug('*** Set of Opportunity ids: ' + setOpportunityIds);
        //4. pass the set of opportunity ids to the future method  
        if(setOpportunityIds != null && setOpportunityIds.size() > 0){
            System.debug('*** Set of Opportunity ids: ' + setOpportunityIds);
            OpptyNDRForecastUtil.addPartsToOpptyForecast(setOpportunityIds);
        }
    }    
    /** Create forecast records on NDR opportunity **/
    
    /** modified trigger to call revenue calculation method for NDR when Forecast are raise automatically for NDR Phase II Enhancement project.**/
 
    if(Trigger.isAfter && Trigger.isUpdate){
        Apex_Helper_Settings__c config = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');// Added by Mrunal Parate for NDR Phase II Enhancement project
        Id ndrRecordType = config.Value__c;
        set<Id> set_NDRoppyId = new set<Id>();
        for(Opportunity_Part__c oppyPart : Trigger.new){
            if((trigger.oldMap.get(oppyPart.Id).Status__c != oppyPart.Status__c || trigger.oldMap.get(oppyPart.Id).Process_Status__c != oppyPart.Process_Status__c) && oppyPart.RecordTypeId == ndrRecordType){
                    set_NDRoppyId.add(oppyPart.Opportunity__c);
            }
        }
        System.debug('>>>>> Set of Oppty ids: ' + set_NDRoppyId);
        if(set_NDRoppyId.size()>0){
        ClsOppyForecastUtil.calculateRevenueforNDR(set_NDRoppyId);
        }
    }
    /** Changes End for NDR Phase II Enhancement project **/
}