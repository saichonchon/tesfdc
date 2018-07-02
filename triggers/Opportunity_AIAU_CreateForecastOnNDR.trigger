trigger Opportunity_AIAU_CreateForecastOnNDR on Opportunity ( after insert,after update,before insert, before update) {
    /** Create forecast records on NDR opportunity **/
    //Change start by Mrunal for CCR Project
    //Apex_Helper_Settings__c config = Apex_Helper_Settings__c.getInstance('NDR Opportunity');
    //Id ndrRecordType = config.Value__c;
    Set<Id> rt_id = new Set<Id>();
    for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
        if(rt.Active__c && rt.Group__c == 'RFQ 2.0 Quotes' && rt.RecordTypeID__c!= null)
            rt_id.add(rt.RecordTypeID__c);
    }

    // Change End by Mrunal for CCR Project
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        List<Opportunity> lstOppties = new List<Opportunity>();
        //Set<Id> setOpptyIds = new Set<Id>();
        for(Opportunity oppty : Trigger.new){
            if(OpptyNDRForecastUtil.isOpportunityComplete(oppty.NDR_Quote_Status_Description__c) 
               && oppty.Opportunity_Already_Exist__c != true 
               &&  (oppty.Current_NDR_quote_number__c == null || oppty.Current_NDR_quote_number__c == '') 
               && rt_id.contains(oppty.recordTypeId)){// Removed oppty.RecordTypeId == ndrRecordType condition and added rt_id.contains(oppty.recordTypeId) for CCR Project
                
                if(trigger.isInsert){
                    lstOppties.add(oppty); 
                    //setOpptyIds.add(oppty.Id);
                }
                if(Trigger.isUpdate && oppty.NDR_Quote_Status_Description__c != Trigger.oldMap.get(oppty.Id).NDR_Quote_Status_Description__c){
                    lstOppties.add(oppty);
                    //setOpptyIds.add(oppty.Id);    
                }
            }           
        }
        system.debug('lstOppties:::'+lstOppties);       
        if(lstOppties.size() > 0){
            OpptyNDRForecastUtil.addPartsToOpptyForecast(lstOppties);
        }
        
        /**
        if(setOpptyIds.size() > 0){
            OpptyNDRForecastUtil.addPartsToOpptyForecast(setOpptyIds);
        }**/                
    } 
    /** Create forecast records on NDR opportunity **/
    //Change start by Mrunal Parate for case 00726111 to update the phase of Oppty as per the status description field
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
        for(Opportunity oppty : Trigger.new){
            //if(oppty.RecordTypeId == ndrRecordType){// Comment for CCR Project
            if(rt_id.contains(oppty.recordTypeId)){// Added for CCR Project
                if(trigger.isInsert){
                    if(oppty.NDR_Quote_Status_Description__c != null && (oppty.NDR_Quote_Status_Description__c == 'Complete' || oppty.NDR_Quote_Status_Description__c == 'Partially Complete' || oppty.NDR_Quote_Status_Description__c == 'In Process') && oppty.Opportunity_Already_Exist__c != true &&  (oppty.Current_NDR_quote_number__c == null || oppty.Current_NDR_quote_number__c == ''))// Opportunity_Already_Exist__c and Current_NDR_quote_number__c check added by Mrunal for case 844983.
                        oppty.stagename = 'Approved/Active';
                }
                if(Trigger.isUpdate && oppty.NDR_Quote_Status_Description__c != Trigger.oldMap.get(oppty.Id).NDR_Quote_Status_Description__c){// Opportunity_Already_Exist__c and Current_NDR_quote_number__c check added by Mrunal for case 844983.//Pankaj Raijade: 3/31/2016 :00805857: removed "oppty.Opportunity_Already_Exist__c != true &&  (oppty.Current_NDR_quote_number__c == null || oppty.Current_NDR_quote_number__c == '')"
                    //7-4-2016 : Pankaj Raijade- Case 00805857 - start//
                    if(oppty.NDR_Quote_Status_Description__c == 'Rejected')
                        oppty.stagename = 'Dead - Closed';    
                    //7-4-2016 : Pankaj Raijade- Case 00805857 - start//
                    if(oppty.Opportunity_Already_Exist__c != true &&  (oppty.Current_NDR_quote_number__c == null || oppty.Current_NDR_quote_number__c == ''))
                    {
                        if(Trigger.oldMap.get(oppty.Id).NDR_Quote_Status_Description__c != 'Approved/Active' && (oppty.NDR_Quote_Status_Description__c == 'Complete' || oppty.NDR_Quote_Status_Description__c == 'Partially Complete' || oppty.NDR_Quote_Status_Description__c == 'In Process'))
                            oppty.stagename = 'Approved/Active';
                        else if (oppty.NDR_Quote_Status_Description__c == 'NDR Review' || oppty.NDR_Quote_Status_Description__c == 'In Review' || oppty.NDR_Quote_Status_Description__c == null) // Modified by Raghu Part of CCR - Changed NDR_Quote_Status_Description__c status from 'NDR review' to 'In Review'.
                            oppty.stagename = 'New';
                    }
                }
            }
        }  
    }
    //Change End by Mrunal Parate
    /** Oppty Part Update on Opportunity Stage Change for Channel Opportunities at header level Project**/
    //Change start by Mrunal Parate for Channel Opportunities at header level Project
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        set<string> set_oppyRecordType = new set<string>();
        for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
                    if(rt.Active__c && rt.Group__c == 'Change Channel Opportunities at header level' && rt.RecordTypeID__c!= null)
                        set_oppyRecordType .add(rt.RecordTypeID__c);      
        }
        //system.debug('>>>>set_oppyRecordType '+set_oppyRecordType);
        set<Id> set_oppyId = new set<Id>();
        for(Opportunity oppy : trigger.new) {
            if(set_oppyRecordType.contains(oppy.RecordTypeId)){
                //Update Oppy Part status for current oppy Stage
                if(trigger.isInsert && oppy.StageName != null){
                    set_oppyId.add(oppy.Id);
                }
                if(Trigger.isUpdate && oppy.StageName != trigger.oldMap.get(oppy.Id).StageName){
                    set_oppyId.add(oppy.Id);
                }
            }
        }
        //system.debug('>>>>set_oppyId'+set_oppyId);
        if(set_oppyId.size()>0){
            ClsOppyPartUtil.updateOppyPartForOppyStage(set_oppyId);
        }
    }
    
    //Change End by Mrunal Parate for Channel Opportunities at header level Project
}