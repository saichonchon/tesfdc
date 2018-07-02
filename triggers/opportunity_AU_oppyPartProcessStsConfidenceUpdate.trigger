/**
 *  This trigger is used to update the confidence of all related Opportunity Parts to â€œLostâ€, process status stays on concept if an Opportunity is set to Stage "Rejected - Closed" by Approval Process.
 *
 @  author Bin Yuan
 @  created 2012-08-29
 @  version 1.0
 @  since 25.0 (Force.com ApiVersion)
 *
 @  changelog
 * 2013-03-04 Jinbo Shan <jinbo.shan@itbconsult.com>
 * modify for SPIN record type.     
 * 
 *  2012-08-28  Bin Yuan <bin.yuan@itbconsult.com> 
 *  - Created
 */
trigger opportunity_AU_oppyPartProcessStsConfidenceUpdate on Opportunity (before update, after update) {
    //get all SPIN RecordTypes.
    //set<Id> set_rts = ClsSPIN_Util.getAllSpinRecordtypes();
    //************************* BEGIN Pre-Processing **********************************************
    //System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
    
    //************************* END Pre-Processing ************************************************
    //System.debug('************************* ' + triggerName + ': END Pre-Processing **********');
    
    //************************* BEGIN Before Trigger **********************************************
    if(Trigger.isBefore) {
        for(Opportunity oppy : trigger.new) {
            if(trigger.oldMap.get(oppy.Id).StageName != oppy.StageName && oppy.StageName == 'Rejected - Closed'){//modify by Jinbo Shan 2014-03-04 not work on SPIN  && !set_rts.contains(oppy.RecordTypeId)              
                oppy.Amount = 0;
                oppy.Five_Year_Revenue__c = 0;              
            }
        }
    }
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************
    
    if(Trigger.isAfter) {
        set<Id> set_oppyId = new set<Id>();
        map<Id, String> map_oppyId_oppyMethod = new map<Id, String>();        
        map<Id, Decimal> map_oppyId_oppyTotalRevenue = new map<Id, Decimal>();
        map<Id, Decimal> map_oppyId_oppy5YearRevenue = new map<Id, Decimal>();
        map<Id, map<Id, String>> map_programId_oppyId_currency = new map<Id, map<Id, String>>();
        set<Id> set_programId = new set<Id>();
        //set<Id> set_oppyId4won = new set<Id>();
        //set<Id> set_oppyId4production = new set<Id>();
    
        list<Opportunity> list_program2Update = new list<Opportunity>();
        list<Opportunity_Part__c> list_oppyPart2Update = new list<Opportunity_Part__c>();
        list<Opportunity_Forecast__c> list_oppyForecast2Update = new list<Opportunity_Forecast__c>();

        for(Opportunity oppy : trigger.new) {
            Opportunity oldOppy = trigger.oldMap.get(oppy.Id);
            if(oldOppy.StageName != oppy.StageName && oppy.StageName == 'Rejected - Closed'){ //modify by Jinbo Shan 2014-03-04 not work on SPIN  && !set_rts.contains(oppy.RecordTypeId)         
                set_oppyId.add(oppy.Id);
                map_oppyId_oppyMethod.put(oppy.id, oppy.Method__c);
                if(oldOppy.Amount != null && oldOppy.Amount != 0) map_oppyId_oppyTotalRevenue.put(oppy.id, oldOppy.Amount);
                if(oldOppy.Five_Year_Revenue__c != null && oldOppy.Five_Year_Revenue__c != 0) map_oppyId_oppy5YearRevenue.put(oppy.id, oldOppy.Five_Year_Revenue__c);
                // program
                if(oldOppy.Program__c == oppy.Program__c && oppy.Program__c != null) {
                    set_programId.add(oppy.Program__c);
                    if(!map_programId_oppyId_currency.containsKey(oppy.Program__c)){
                        map_programId_oppyId_currency.put(oppy.Program__c, new map<Id, String>());
                    }
                    map_programId_oppyId_currency.get(oppy.Program__c).put(oppy.id, oppy.CurrencyIsoCode);
                }
            }
        }
        
        if(!set_oppyId.isEmpty()) {
            for(Opportunity_Part__c oppyPart : [Select Id, Status__c, Process_Status__c From Opportunity_Part__c Where Opportunity__c in :set_oppyId ]) {
                oppyPart.Status__c = 'Lost';
                oppyPart.Process_Status__c = 'Concept';
                oppyPart.Lost_Reason__c = 'Other';
                list_oppyPart2Update.add(oppyPart);
            }
            for(Opportunity_Forecast__c ofc : [Select Id, Amount__c, Quantity__c, Opportunity__c From Opportunity_Forecast__c Where Opportunity__c in :set_oppyId and Part__c = null]) {
                String method = 'BOM';
                if(map_oppyId_oppyMethod.containsKey(ofc.Opportunity__c)) method = map_oppyId_oppyMethod.get(ofc.Opportunity__c);
                if(method == 'BOM') ofc.Amount__c = 0;
                else{
                    ofc.Quantity__c = 0;
                    ofc.Amount__c = 0;              
                }
                list_oppyForecast2Update.add(ofc);
            }          
            for(Opportunity program :[Select id, Amount, Five_Year_Revenue__c, CurrencyIsoCode from Opportunity where id IN :set_programId]){
                if(map_programId_oppyId_currency.containsKey(program.id)){
                    for(Id oppyId :map_programId_oppyId_currency.get(program.id).keySet()){
                        if(program.Amount == null) program.Amount = 0;
                        if(program.Five_Year_Revenue__c == null) program.Five_Year_Revenue__c = 0;                      
                        // currency is NOT same
                        String oppyCurr = map_programId_oppyId_currency.get(program.id).get(oppyId);
                        if(program.CurrencyIsoCode != oppyCurr){
                            // total revenue of program
                            if(map_oppyId_oppyTotalRevenue.containsKey(oppyId)) program.Amount -= ClsOppyUtil.transformIsoCode(map_oppyId_oppyTotalRevenue.get(oppyId), oppyCurr, program.CurrencyIsoCode);
                            // 5 year revenue of program
                            if(map_oppyId_oppy5YearRevenue.containsKey(oppyId)) program.Five_Year_Revenue__c -= ClsOppyUtil.transformIsoCode(map_oppyId_oppy5YearRevenue.get(oppyId), oppyCurr, program.CurrencyIsoCode);
                        }
                        // currency is same
                        else{
                            if(map_oppyId_oppyTotalRevenue.containsKey(oppyId)) program.Amount -= map_oppyId_oppyTotalRevenue.get(oppyId);
                            if(map_oppyId_oppy5YearRevenue.containsKey(oppyId)) program.Five_Year_Revenue__c -= map_oppyId_oppy5YearRevenue.get(oppyId);
                        }
                    }
                    list_program2Update.add(program);
                }               
            }
        }
        
        if(!list_oppyPart2Update.isEmpty()) {
            ClsTriggerRecursionDefense.partUpdateOpportunity = false;
            update list_oppyPart2Update;
            ClsTriggerRecursionDefense.partUpdateOpportunity = true;
        }
        if(!list_oppyForecast2Update.isEmpty()) update list_oppyForecast2Update;
        if(!list_program2Update.isEmpty()) update list_program2Update;
        
    }
    //************************* END After Trigger *************************************************
}