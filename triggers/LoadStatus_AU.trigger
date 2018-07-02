/**
 *  This after update trigger is used to update related sips.
 *
 @  author Bin Yuan
 @  created 2014-01-08
 @  version 1.0
 @  since 29.0 (Force.com ApiVersion)
 *
 @  changelog
 *
 * 2015-07-08 Jasmine Ver <jasmine.ver@te.com>
 * - comment out execution of Cls_BatchCalculateMonthlyAmount(), these fields will be loaded
 *   directly by integration
 *
 * 2015-04-30 Bin Yu <bin.yu@itbconsult.com>
 * - excluded records "FCB Engineering & FCB Regular"
 *
 *  2014-06-04 Lili Zhao <lili.zhao@itbconsult.com>
 *  due to run the ClsBatch_calculateBBBMCurrency batch once the load status changed
 *
 *  2014-11-18 Jinbo Shan <jinbo.shan@itbconsult.com>
 *  due to run the Cls_BatchCalculateMonthlyAmount batch once the current date changed
 *
 *  2014-01-08 Bin Yuan <bin.yuan@itbconsult.com>
 *  - Created
 */
trigger LoadStatus_AU on Load_Status__c (After update) {
    String triggerName = 'Load_Status__c';
    set<Id> set_loadStatusIds = new set<Id>(); 
    // add lili 2014-06-09 begin 
    set<Id> set_loadStatusChangeIds = new set<Id>();
    // end
    set<ID> set_currentDateChangedIds = new set<Id>();
    //************************* BEGIN After Trigger ***********************************************
    if(Trigger.isAfter) {        
        for(Load_Status__c ls : trigger.new) {   
            //added by BYU on 2015-04-30
            if(ls.Name != 'FCB Engineering' && ls.Name != 'FCB Regular'){                   
                if(ls.Name == 'BBB_Month_Bill_Book_Cust__c Direct' || ls.Name == 'BBB_Month_Bill_Book_Cust__c Indirect') {
                    set_loadStatusIds.add(ls.Id);
                }
    
                if(trigger.oldMap.get(ls.Id).Backlog_Updated_Date__c != ls.Backlog_Updated_Date__c && trigger.oldMap.get(ls.Id).Demand_Updated_Date__c != ls.Demand_Updated_Date__c) {
                    set_loadStatusChangeIds.add(ls.Id);
                }
                /* comment out 7/8 by Jasmine Ver    
                //Start: added by Jinbo Shan
                if(ls.Name == 'BBB_Year_Bill_Book_Cust_PN__c Indirect' && trigger.oldMap.get(ls.Id).Current_Date__c != ls.Current_Date__c) {
                    set_currentDateChangedIds.add(ls.Id);
                }     
                //End   
                */
            }
        }

    }
    if(!set_loadStatusIds.isEmpty()) {
        /*
        ClsBatch_populateSIPDate batchJob = new ClsBatch_populateSIPDate();
        batchJob.set_loadStatus = set_loadStatusIds;
        Database.executeBatch(batchJob,1);
        
        ClsBatch_populateSIPRunningNumbers batchJob = new ClsBatch_populateSIPRunningNumbers();
        batchJob.set_loadStatus = set_loadStatusIds;
        Database.executeBatch(batchJob);
        */
    }
    // add lili zhao 2014-06-04 due to run the batch once the load status changed
    if(!set_loadStatusChangeIds.isEmpty()) {
        ClsBatch_calculateBBBMCurrency clsBatch = new ClsBatch_calculateBBBMCurrency();
        Database.executeBatch(clsBatch);
    }
    // end
    
    /* comment out 7/8 by Jasmine Ver
    //Start: Added by Jinbo Shan to run the batch once the current date changed
    if(set_currentDateChangedIds.size() > 0) {
        Cls_BatchCalculateMonthlyAmount cls = new Cls_BatchCalculateMonthlyAmount();
        database.executeBatch(cls);
    }
    //END
    */
    //************************* END After Trigger *************************************************

}