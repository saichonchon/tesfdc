global class ClsScheduled_OEMMonthlyBBBtoMapping implements Schedulable{

    global void execute(SchedulableContext sc) {
                
        if(ClsOEMUtil.CurrentFM == null || ClsOEMUtil.CurrentFY == null)
        {
            ClsOEMUtil.setCurrentFiscalDateValues();            
        }
        
        Integer pFiscalMonth = ClsOEMUtil.CurrentFM;
        String pFiscalYear = ClsOEMUtil.CurrentFY;
        
        ClsOEMUtil.checkForActive = false;  
        ClsBatch_OEM_MonthlyBBBtoMapping oem = new ClsBatch_OEM_MonthlyBBBtoMapping(string.valueOf(pFiscalMonth).leftpad(2).replace(' ', '0'), pFiscalYear);
        ID batchprocessid = Database.executeBatch(oem);
    }

}