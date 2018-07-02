Global class APL_One_Time_Execution  {

    private static final Set<String> requiredOnce=new Set<String>{'opportunity_AU_RecalculateNPSMSG', 'CalcNPSAmount_on_Opportunity_Forecast_Before', 'CalcNPSAmount_on_Opportunity_Forecast_After', 'opportunityPart_AU_RecalculateNPSMSG'};//List of Apex codes that should run only once. Add any code to the list   
    private static Set<String>hasRun=new Set<String>();//List of Apex code that has already been run. Keep this list empty.
    public static Boolean batchRun = false; // this value is only used for other batchs such as ClsBatch_recalculatePartRevenue
    
    public static void removeFromRunOnce(String st)
    {
        if(Test.isRunningTest() && hasRun.contains(st))
        {
            hasRun.remove(st);
        }    
    }
    public static boolean canTrigger(String ApexName){//If no bypass
    
            Boolean toRun = false;
        if(requiredOnce.contains(ApexName)){//If it should run Once
            if(hasRun.contains(ApexName))
            {
                toRun = false;//Already run, should not run
            }
            else{
                
                toRun = true;
                hasRun.add(ApexName);//Never run, can run only if not bypassed
            
            }  
        }        
                
        return toRun;
        
    }
}