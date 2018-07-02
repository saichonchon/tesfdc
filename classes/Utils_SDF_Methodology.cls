public with sharing class Utils_SDF_Methodology {

    private static final Set<String> requiredOnce=new Set<String>{'CutoffDateUpdate','OEMMappingAfterInsert'};//List of Apex codes that should run only once. Add any code to the list   
    private static Set<String>hasRun=new Set<String>();//List of Apex code that has already been run. Keep this list empty.
    
    
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
    
    public Static Boolean StageValidation;
    public Static Set<String> ApexNameList=new Set<String>();
    public Static Boolean restrictquery(String apxname){
        if(ApexNameList.Contains(apxname)){
            StageValidation=True;   
        }
        else{
            StageValidation=false;
            ApexNameList.add(apxname);
        }                       
        return StageValidation;
    }
}