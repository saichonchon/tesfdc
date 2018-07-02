public Class checkRecursive{
    //updated for test class..
    @TestVisible private static boolean run = true;  
    public static boolean runOnce(){
    if(run){          
     run=false;
     return true;
    }else{
        return run;
    }
    }
}