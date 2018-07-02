/***********************************************************************************************************************
Name: ClsBatch_deleteForecastSnapshot
Salesforce Instance : C2S
========================================================================================================================
Purpose: Delete the Forecast Snapshot Records(By Keeping the Forecast Snapshot records of last 3 Fiscal months
and last week of every Fiscal month into the system)                                                  
========================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            
------------------------------------------------------------------------------------------------------------------------
1.0    Mrunal            08/31/2015     Initial Development                             
***********************************************************************************************************************/
global class ClsBatch_deleteForecastSnapshot implements Database.Batchable<SObject>{
    /**
     * the email address to tell people the status of the batch class after run the batch class
     * before run the batch class, we can define the email manual
     * if not define email address, after the batch completed, will not send email
     */ 
    public String email;

    /**
     * the sql query statement that will select the data will be used in this batch class
     */     
    public String query;
    Id rtId;
    Date StartDate;
    Date todayDt;
    Date vFiscalStartDate;
    Date dateBeforeMonth;
    String vStrError = '';
    list<Forecast_Snapshot__c> delFSnapshotList = new list<Forecast_Snapshot__c>();
    Map<string, string> mapLastWeek = new Map <string, string>();
    public ClsBatch_deleteForecastSnapshot(){
        todayDt = System.Today();
        Time_frame_Setting__c vConfig = Time_frame_Setting__c.getValues('Exclude Del of Forecast Snapshot');
        if(vConfig != null && vConfig.Period_Type__c != null && vConfig.Period__c != null)
                {
                    if('YEAR'.equalsIgnoreCase(vConfig.Period_Type__c))
                        DateBeforeMonth = todayDt.addYears((Integer)(-1 * vConfig.Period__c));
                    if('MONTH'.equalsIgnoreCase(vConfig.Period_Type__c))
                        DateBeforeMonth = todayDt.addMonths((Integer)(-1 * vConfig.Period__c));
                    if('DAY'.equalsIgnoreCase(vConfig.Period_Type__c))
                        DateBeforeMonth = todayDt.addDays((Integer)(-1 * vConfig.Period__c));
                    
                    if(DateBeforeMonth != null) {  
                        Period vPeriod = [SELECT StartDate, EndDate FROM Period WHERE Type =: vConfig.Period_Type__c AND StartDate <=: DateBeforeMonth AND EndDate >=: DateBeforeMonth];
                        vFiscalStartDate = vPeriod.StartDate;
                    }
                    if(DateBeforeMonth != null) {
                        for(Period pd: [SELECT StartDate, EndDate FROM Period WHERE Type =: vConfig.Period_Type__c AND StartDate <=: DateBeforeMonth AND startDate>: date.newInstance(2014, 1, 1)]){
                        mapLastWeek.put(pd.EndDate.month()+'-'+pd.EndDate.year(), pd.EndDate.addDays(-6)+';'+pd.EndDate.addDays(1));
                        }
                    }
                }
         
         system.debug('>>>'+mapLastWeek);
         
         rtId= [select id, DeveloperName from RecordType where SobjectType ='Forecast_Snapshot__c' and DeveloperName= 'Part'].Id;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        if (query == '' || query == null){
            query = 'SELECT Id,CreatedDate FROM Forecast_Snapshot__c limit 0';
            if(vFiscalStartDate != null){
                query = 'SELECT Id,CreatedDate FROM Forecast_Snapshot__c WHERE Snapshot_Type__c = \'Monthly\' and CreatedDate <: vFiscalStartDate and recordtypeid =:rtId ';
            }
            
        }
        //query += ' and id =\'a0y0L00000EA9ck\'';  
        
        return Database.getQueryLocator(query);  
    }

    global void execute(Database.BatchableContext BC, list<Forecast_Snapshot__c> forecastSnapshotList ){
        if(forecastSnapshotList != null && !forecastSnapshotList.isEmpty()){
            for(Forecast_Snapshot__c fs : forecastSnapshotList){
                string key = fs.CreatedDate.month()+'-'+fs.CreatedDate.year();
                if(mapLastWeek.get(key)!= null){
                    if(!(fs.CreatedDate >= datetime.valueOf(mapLastWeek.get(key).split(';')[0]) && fs.CreatedDate <= datetime.valueOf(mapLastWeek.get(key).split(';')[1])))
                        delFSnapshotList.add(fs);
                }               
            }
        }
        if(delFSnapshotList != null && !delFSnapshotList.isEmpty()){
         system.debug('>>>>delFSnapshotList'+delFSnapshotList.size());
             try{
                 delete delFSnapshotList; 
                 DataBase.emptyRecycleBin(delFSnapshotList);
             }catch(Exception e){
                vStrError +='Error Type = '+e.getTypeName()+' Error Line = '+e.getLineNumber()+''+' Error Stack = '+e.getStackTraceString()+' Error Message = '+e.getMessage();
                SalesforceException.putError('ClsBatch_deleteForecastSnapshot Exception **', '',vStrError,SalesforceConstant.strSfdc,SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
             }
         }
    }

    global void finish(Database.BatchableContext BC){ 
        // Send an email to the Apex job's submitter notifying of job completion.
        if(email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] {email});
            mail.setReplyTo(Email);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Batch Processing ClsBatch_deleteForecastSnapshot Completed');
            mail.setPlainTextBody('Batch Processing ClsBatch_deleteForecastSnapshot has completed');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
        } 
    }  
        
}