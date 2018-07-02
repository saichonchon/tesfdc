trigger CutoffDateUpdate on OEM_Details__c (After insert , After update) {

 if(Utils_SDF_Methodology.canTrigger('CutoffDateUpdate')){
        Set<String> yearSet = new Set<String>();
         Set<String> MonthSet = new Set<String>();
         set<id> oemidset = new Set<id>();
        for(OEM_Details__c  obj: Trigger.new){
            if(obj.Fiscal_Year__c!=null)
            yearSet.add(obj.Fiscal_Year__c);
            if(obj.Fiscal_Month__c!=null)
            MonthSet.add(obj.Fiscal_Month__c);
            oemidset.add(obj.id);
            
        }
        List<OEM_Details__c> oemdetailList =[select id,Fiscal_Year__c ,Fiscal_Month__c,Cutoff_Date__c from OEM_Details__c  where Fiscal_Year__c in :yearSet  and Fiscal_Month__c in: MonthSet  and id Not in :oemidset    ];
       if(oemdetailList != null && oemdetailList.size()>0)
       {
            for(OEM_Details__c  obj: Trigger.new){
                for(OEM_Details__c  toupdate: oemdetailList ){
                    if(obj.Fiscal_Year__c == toupdate.Fiscal_Year__c && obj.Fiscal_Month__c == toupdate.Fiscal_Month__c && obj.Cutoff_Date__c  != null  ){
                       toupdate.Cutoff_Date__c  = obj.Cutoff_Date__c ; 
                    }
                }
            }
            update oemdetailList ;
        }
    }

}