/**
*   apex class: ClsBatch_OEM_DailyBBBSummary
*
@author Michael Cui
@version 1.0
*
@changelog
* 2014-09-04 Michael Cui
* update this for case 00733781 to get the OEM As To date.
*/
global class ClsBatch_OEM_DailyBBBSummary implements Database.Batchable<SObject>,Database.Stateful{

    public ClsBatch_OEM_DailyBBBSummary(){
                   
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    { 
        String query = 'select Backlog_Amount_After_Allocation__c,Billing_Amount_After_Allocation__c,'+
                        'Book_Amount_After_Allocation__c,CSD_OEM_Mapping__c,Transaction_Date__c,'+
                        'CSD_OEM_Mapping__r.OEM__r.OEM__c from CSD_OEM_Mapping_Daily_BBB__c '+
                        'where need_summary__c = true order by CSD_OEM_Mapping__r.OEM__r.OEM__c';
        return Database.getQueryLocator(query); 
    }

    global void execute(Database.BatchableContext BC, list<CSD_OEM_Mapping_Daily_BBB__c> dBBBList)
    {   
        //hold account ids
        Set<Id> accountIdSet = new Set<Id>();
        //CSD_OEM_Mapping_Daily_BBB__c for update
        List<CSD_OEM_Mapping_Daily_BBB__c> dBBBFinalList = new List<CSD_OEM_Mapping_Daily_BBB__c>();
        
        for(CSD_OEM_Mapping_Daily_BBB__c dBBB : dBBBList){
            accountIdSet.add(dBBB.CSD_OEM_Mapping__r.OEM__r.OEM__c);
        }
        
        //query the account
        Map<Id,Account> accMap = new Map<Id,Account>([select Id,MTD_Billing__c,Latest_Booking__c,Latest_Backlog__c,OEM_As_To__c from Account where Id in: accountIdSet]);
        
        //initial MTD_Billing__c/Latest_Booking__c/Latest_Backlog__c to 0
        for(String key : accMap.keySet()){
            Account acc = accMap.get(key);
            acc.MTD_Billing__c = 0;
            acc.Latest_Booking__c = 0;
            acc.Latest_Backlog__c = 0;
            
            accMap.put(key,acc);
        }
        
        for(CSD_OEM_Mapping_Daily_BBB__c dBBB : dBBBList){
            Account acc = accMap.get(dBBB.CSD_OEM_Mapping__r.OEM__r.OEM__c);
            acc.MTD_Billing__c += dBBB.Billing_Amount_After_Allocation__c;
            acc.Latest_Booking__c += dBBB.Book_Amount_After_Allocation__c;
            acc.Latest_Backlog__c += dBBB.Backlog_Amount_After_Allocation__c;
            if(acc.OEM_As_To__c == null || acc.OEM_As_To__c < dBBB.Transaction_Date__c){
                acc.OEM_As_To__c = dBBB.Transaction_Date__c;
            }
            dBBB.need_summary__c = false;
            accMap.put(acc.Id,acc);
            dBBBFinalList.add(dBBB);
        }
        
        update accMap.values();
        update dBBBList;
    }

    global void finish(Database.BatchableContext BC)
    {
        /*
            //Iterate through Account Totals to set Daily Values on OEM Account records themselves
            for(Account OA : OEMAccounts.values())
            {   
                //System.debug('***** JNV Update Accounts - ' + OA.Id + ' ' + OA.MTD_Billing__c + ' ' + OEMAccountTotals.get(OA.Id).Billings);
                OA.MTD_Billing__c = OEMAccountTotals.get(OA.Id).Billings;
                OA.Latest_Booking__c = OEMAccountTotals.get(OA.Id).Bookings;
                OA.Latest_Backlog__c = OEMAccountTotals.get(OA.Id).Backlog;
                if(OEMAccountTotals.get(OA.Id).transactionDate > date.newinstance(1900, 1, 1))
                    OA.OEM_As_To__c = OEMAccountTotals.get(OA.Id).transactionDate;                    
            }
            
            ClsBatch_OEM_MonthlyBBBSummary oemMBBB = new ClsBatch_OEM_MonthlyBBBSummary(string.valueOf(pFiscalMonth).leftpad(2).replace(' ', '0'), pFiscalYear); 
            Database.executeBatch(oemMBBB);                  
            */  
     }

           
            
        
}