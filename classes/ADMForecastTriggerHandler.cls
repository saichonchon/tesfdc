/**********************************************************************
Name: ADMForecastTriggerHandler
Copyright © 2017
======================================================
======================================================
Purpose: ADMForecastTriggerHandler is used for deleting Forecast Detail records of Forecast and YoY Variance Type
for current fiscal year and next fiscal year
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL Description
0.1          Kartik  G           10/04/2017         INITIAL DEVELOPMENT
0.2			 Kartik  G  		 11/21/2017 		INITIAL DEVELOPMENT
***********************************************************************/


public class ADMForecastTriggerHandler extends ClsTriggerVirtual{
    
     public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        if (trgCtx.isBefore) return;
        Boolean isRun;
       
        Trigger_Configuration__c tc = Trigger_Configuration__c.getInstance('DeleteForecastdetailrec'); //Enable/Disable trigger based on Custom Setting
        
        if (tc != null)isRun = tc.isRun__c;
        else{isRun=false;}
        if (isRun) {
            if (trgCtx.isUpdate) {
                this.onAfterUpdate((List<Forecast__c>)trgCtx.oldList,(List<Forecast__c>)trgCtx.newList,(Map<Id,Forecast__c>)trgCtx.oldMap,(Map<Id,Forecast__c>)trgCtx.newMap);
            }
            
        }
    }
    
    
    public void onAfterUpdate(list<Forecast__c> lstFcOld,list<Forecast__c> lstFcNew,Map<Id,Forecast__c> mapfcOld,Map<Id,Forecast__c> mapfcNew)
    {
        try{
            //Get current year
            Date todaydate = System.Today();
            FiscalYearSettings currentfisobj = [select id,name,EndDate from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
            String currentyr = currentfisobj.name;
            String nextyr= String.valueOf(Integer.ValueOf(currentyr)+1);
            List<String> listyrs = new list<String>{currentyr, nextyr};
            Set<Id> fcid = new  Set<Id>();
            
            //Get Forecast record type id of Name-ADM
            Id ForecastRecordTypeId = Schema.SObjectType.Forecast__c.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
            
            Map<Id,Forecast__c> porttoNonportMap = new  Map<Id,Forecast__c>();
            Map<Id,Forecast__c> NonporttoportMap = new  Map<Id,Forecast__c>();
            
            //Fetch Forecast records whose type is changed either from Portfolio to Non-Portfolio OR Vice-versa
            for(Forecast__c fc: lstFcOld ){
                if(fc.RecordTypeId==ForecastRecordTypeId){
                    if(fc.Type__c=='Portfolio' &&  mapfcNew.get(fc.id).Type__c == 'Non-Portfolio'){
                        porttoNonportMap.put(fc.Id, mapfcNew.get(fc.id));
                        fcid.add(fc.Id);
                    }
                    else if (fc.Type__c=='Non-Portfolio' &&  mapfcNew.get(fc.id).Type__c == 'Portfolio'){
                        NonporttoportMap.put(fc.Id, mapfcNew.get(fc.id));
                        fcid.add(fc.Id);
                    }
                }
            }  
            list<Forecast_Detail__c> fdTodelete = new list<Forecast_Detail__c>(); 
            
            //To query forecast detail record for type Forecast , Auto-Forecast and YOY Variance
            list<Forecast_Detail__c> fdlist= [Select id, Parent_Forecast__c,Type__c,Period__c from Forecast_Detail__c WHERE Parent_Forecast__c IN : fcid AND Period__c IN :listyrs AND (Type__c='Forecast' OR Type__c='YoY Variance'OR Type__c='Auto-Forecast') ];
            system.debug('fdlist...'+fdlist);
            
            if(fdlist.size()>0)
            {
                
                //Checking which type of Forecast Details records needs to be deleted based on Parent Forecast Type
                for(Forecast_Detail__c fd : fdlist){
                    system.debug('fd...'+fd);
                    //Fetch Forecast and YoY Variance if Forecast record Type changed from Portfolio to Non-Portfolio
                    //Add it in list
                    if (porttoNonportMap.get(fd.Parent_Forecast__c)!=null && (fd.Type__c=='Forecast'|| fd.Type__c=='YoY Variance')){
                        fdTodelete.add(fd) ;
                    }  
                    //Fetch Forecast and YoY Variance if Forecast record Type changed from Portfolio to Non-Portfolio
                    //Add it in list
                    if (NonporttoportMap.get(fd.Parent_Forecast__c)!=null && (fd.Type__c=='Auto-Forecast'|| fd.Type__c=='YoY Variance')){
                        fdTodelete.add(fd) ;
                    }             
                } 
                //Deleting the list
                delete fdTodelete;
            }   
            
        }catch(Exception e){
            System.debug('errMessage' + ': ' + e.getMessage());
            ErrorLogging.Log(e, 'ADMForecastTriggerHandler', 'onAfterUpdate','');
            
        }
        
        
    }
}