/**
*   Controller for CtrlBatchManagementPage page
*
@author Fuqi Tan
@created 2013-12-03
@version 1.0
@since 28.0 (Force.com ApiVersion)
*
@changelog
* 2013-12-03 Fuqi Tan fuqi.tan@itbconsult.com>
* - Created  
*/

public without sharing class CtrlBatchManagementPage {
  
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public list<jobInfo> listJobInfo{get;set;}
    public string modelDateStr{get;set;}
    public string jobModel{get;set;}
    public jobInfo jobData{get;set;}
    public jobParameter jobParDateInfo{get;set;}
    public list<jobParameter> list_jobParDateInfo{get;set;}
	public String jobClassName{get;set;}
	public String jobLableName{get;set;}
	public string jobPar{get;set;}
	public string jobParDate{get;set;}
    public map<String, Financial_Planning_Configuration__c> map_config = new map<String, Financial_Planning_Configuration__c>();
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<string,AsyncApexJob> map_Name_Job;
    // add lili 2013.12.04 begin
    //*******************  change the final Strings to custom setting：Forecast History Config  **************************
    private  map<string,String> map_Name_Class = new map<String, String>(); 
    private  map<string,string> map_BatchName_Label = new map<string,string>();
    private  set<string> set_BatchName = new set<string>();
    private  list<string> jobNames = new list<string>();
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CtrlBatchManagementPage(){
        listJobInfo = new list<jobInfo>();
        jobClassName = '';
       
        for(Financial_Planning_Configuration__c c : Financial_Planning_Configuration__c.getAll().values()){
        	if(c.Class__c != null && c.Used4BatchManagement__c == true)  map_config.put(c.Class__c, c);
        }
        // add lili 2013.12.04 end
        findApexJobs();
        initListJob();
        initJobModel();
        initDateModel();
    }
    
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    /**
    * This method is get Manager Forecast
    *
    @author Fuqi Tan
    @created 2013-12-03
    @version 1.0
    @since 28.0
    *
    @return       void
    *
    @changelog
    * 2013-12-03 Fuqi Tan fuqi.tan@itbconsult.com>
    * - Created
    */
    public void findApexJobs(){
		set_BatchName = map_config.keySet();
        String jobSql = 'Select ApexClass.Name, Status, ParentJobId, NumberOfErrors, MethodName, '+
                'LastProcessedOffset, LastProcessed, JobType, JobItemsProcessed, Id, ExtendedStatus, '+
                'CreatedDate, CreatedById, CompletedDate, ApexClassId '+
                  ' From AsyncApexJob '+
                  ' Where ApexClass.Name IN :   set_BatchName  ' +
                  ' And (Status != \'Completed\' and Status != \'Failed\' and Status != \'Aborted\' )';        
        try{
            map_Name_Job = new map<string,AsyncApexJob>();           
            string jobLabel;
            for(AsyncApexJob job : database.query(jobSql)){
                map_Name_Job.put(job.ApexClass.Name,job);          
            }           
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e+'')); 
        }
    }
    public void initListJob(){
        jobInfo jif;
        String status = '';
        AsyncApexJob asJob;
        list<jobInfo> list_Infos = new list<jobInfo>();
        for(string jobName : map_config.keySet()){
            if(map_Name_Job.containsKey(jobName)){
                asJob = map_Name_Job.get(jobName);   
                status = asJob.Status;                                  
            }
            jif = new jobInfo(jobName,map_config.get(jobName).Name,status, map_config.get(jobName).Parameter__c, map_config.get(jobName).Date_Parameter__c);// add jobName  add lili 2013.12.05
            list_Infos.add(jif);           
        }
        
        list<String> list_lableName = new list<String>();
        for(jobInfo ji:list_Infos) {
        	list_lableName.add(ji.jobName);
        }
        list_lableName.sort();
        for(String str : list_lableName) {
        	for(jobInfo ji:list_Infos) {
        		if(str == ji.jobName ) {
        			listJobInfo.add(ji);
        		}
        	}        	
        }
    }
    public void initJobModel(){
        jobParameter jobPar = new jobParameter('','','',Date.newInstance(2013,12,16));
        list<jobParameter> list_parDate = new list<jobParameter>();
        list_parDate.add(jobPar);
        jobParDate = JSON.serialize(list_parDate);
    }
    
    public void initDateModel(){
        Date modelDate = Date.newInstance(2013,12,16);
        modelDateStr = modelDate.format();
    }
    
    public void runBatch(){   	
    	system.debug('jobParDate=='+jobParDate); 
    	system.debug('jobModel=='+jobModel); 
    	system.debug('jobPar=='+jobPar);  
    	list<jobParameter> list_par = (list<jobParameter>)JSON.deserialize(jobPar,list<jobParameter>.class);
    	list<jobParameter> list_parDate = (list<jobParameter>)JSON.deserialize(jobParDate,list<jobParameter>.class);
        jobInfo batchJob = (jobInfo)JSON.deserialize(jobModel,jobInfo.class);
        string jname = batchJob.jobName;    
        //start added by Jinbo Shan at 2013-12-06\
        system.debug('batchJob.jobClass=='+batchJob.jobClass);  
        system.debug('list_parDate=='+list_parDate);  
        //Added by Bin Yuan 2014-03-11 due to change requirment to no need calc backlog any more
        if(batchJob.jobClass == 'ClsBatch_calculateBBBMCurrency'){
            
            //ClsBatch_calculateBBBMBacklog cls = new ClsBatch_calculateBBBMBacklog();
        	ClsBatch_calculateBBBMCurrency cls = new ClsBatch_calculateBBBMCurrency();
            //End
        	for(jobParameter jobParam : list_par){        		
        		if(jobParam.pName == 'currentYear' && jobParam.Value!=null && jobParam.Value != ''){
        			cls.currentYear = Integer.valueOf(jobParam.Value);
        		}
				if(jobParam.pName=='currentMonth' && jobParam.Value!=null && jobParam.Value != ''){
        			cls.currentMonth = Integer.valueOf(jobParam.Value);
        		}
        	}
        	database.executeBatch(cls);
        }else if(batchJob.jobClass == 'ClsBatch_setLastRSMFrozenDate'){
        	 
        	ClsBatch_setLastRSMFrozenDate cls = new ClsBatch_setLastRSMFrozenDate();
        	for(jobParameter jobParam : list_parDate){
        		if(jobParam.pName=='frozenDate' && jobParam.dateValue!=null){
        			cls.frozenDate=jobParam.dateValue;
        		}
        	}
        	database.executeBatch(cls);
        }else if(batchJob.jobClass == 'ClsBatch_setLastASMFrozenDate'){
        	ClsBatch_setLastASMFrozenDate cls = new ClsBatch_setLastASMFrozenDate();
        	for(jobParameter jobParam : list_parDate){
        		if(jobParam.pName=='frozenDate' && jobParam.dateValue!=null){
        			system.debug('jobParam.dateValue=='+jobParam.dateValue);
        			cls.frozenDate=jobParam.dateValue;
        			system.debug('cls.frozenDate=='+cls.frozenDate);
        		}
        	}
        	database.executeBatch(cls);
        }else if(batchJob.jobClass == 'ClsBatch_recalculateRSMPreviousForecast'){
        	ClsBatch_recalculateRSMPreviousForecast cls = new ClsBatch_recalculateRSMPreviousForecast();
        	for(jobParameter jobParam : list_par){
        		if(jobParam.pName=='currentYear' && jobParam.Value!=null && jobParam.Value != ''){
        			cls.currentYear=jobParam.Value;
        		}
        		if(jobParam.pName=='currentMonth' && jobParam.Value != null && jobParam.Value != ''){
        			cls.currentMonth=jobParam.Value;
        		}
        	}
        	database.executeBatch(cls);
        }else if(batchJob.jobClass == 'ClsBatch_FinancialplanningRestatement'){
        	ClsBatch_FinancialplanningRestatement cls = new ClsBatch_FinancialplanningRestatement();
        	database.executeBatch(cls);
        }else if(batchJob.jobClass == 'ClsBatch_recalculateAccountForecast'){
        	ClsBatch_recalculateAccountForecast cls = new ClsBatch_recalculateAccountForecast();
        	for(jobParameter jobParam : list_par){
        		if(jobParam.pName=='currentYear' && jobParam.Value!=null && jobParam.Value != ''){
        			cls.currentYear=jobParam.Value;
        		}
        		if(jobParam.pName=='currentMonth' && jobParam.Value!=null && jobParam.Value != ''){
        			cls.currentMonth=jobParam.Value;
        		}
        	}
        	database.executeBatch(cls);
        }   
        //*******************  change the final Strings to custom setting：Forecast History Config  ************************** 
       
    }
    public void setClassName() {
    	
    }
    /**
    * This method is get Manager Forecast
    *
    @author Fuqi Tan
    @created 2013-12-03
    @version 1.0
    @since 28.0
    *
    @return       void
    *
    @changelog
    * 2013-12-03 Fuqi Tan fuqi.tan@itbconsult.com>
    * - Created
    */
    public void getManagerForecast(){
    }
    /**
    * This method is updata Manager Forecast
    *
    @author Fuqi Tan
    @created 2013-12-03
    @version 1.0
    @since 28.0
    *
    @return       void
    *
    @changelog
    *2013-12-03 Fuqi Tan fuqi.tan@itbconsult.com>
    * - Created
    */
    public void updataManagerForecast(){
    }
   
    public list<jobParameter> getListParameters() {
    	//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'lili77+' + jobClassName)); 
    	list<jobParameter> list_Parameters = new list<jobParameter>();
    	
    	for(jobInfo job :listJobInfo) {
    		if(job.jobClass == this.jobClassName) {
    			list_Parameters = job.parameters;
    		}
    	}
    	return list_Parameters;
    }
    
    public list<jobParameter> getListDateParameters() { 
    	list<jobParameter> list_DateParameters = new list<jobParameter>();   	
    	for(jobInfo job :listJobInfo) {
    		if(job.jobClass == this.jobClassName) {
    			list_DateParameters = job.dateParameters;
    		}
    	}
    	return list_DateParameters;
    }
    
    //********************************* -=END public methods=- ************************************
    
    //********************************* -=BEGIN private methods=- **********************************   
    /**
    * This method is used to Splice sql query
    *
    @author Fuqi Tan
    @created 2013-12-03
    @version 1.0
    @since 28.0
    *
    @return       void
    *
    @changelog
    *2013-12-03 Fuqi Tan fuqi.tan@itbconsult.com>
    * - Created
    */
    private void setFindbbbSql(){
    
    }
    /**
    * This method is used to Splice sql query
    *
    @author Fuqi Tan
    @created 2013-12-03
    @version 1.0
    @since 28.0
    *
    @return       void
    *
    @changelog
    *2013-12-03 Fuqi Tan fuqi.tan@itbconsult.com>
    * - Created
    */
    //********************************* -=END private methods=- ************************************
        
        
        
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class jobInfo{
        public String jobName{set;get;}        	
        public String jobStatus{set;get;}
        public String jobClass{set;get;}
        public list<jobParameter> parameters {get; set;}
        public list<jobParameter> dateParameters {get; set;}
        
        public jobInfo(String className, String name,String status, String par, String datePar){ // add ClssName  add lili 2013.12.05
            parameters = new list<jobParameter>();
            dateParameters = new list<jobParameter>();
            this.jobName = name;           
            this.jobClass = className; // add lili 2013.12.05
            this.jobStatus = status;
            if(par != null){
            	if(par.contains(';')) {
	            	for(String s: par.split(';')){
	                    jobParameter jp = new jobParameter();
	                    jp.pName = s;
	                    jp.lableNam = name;
	                    parameters.add(jp);
	                }
            	}else {
            		jobParameter jp = new jobParameter();
                    jp.pName = par;
                    jp.lableNam = name;
                    parameters.add(jp);
            	}
                
            }
            
            if(datePar != null) {
            	if(datePar.contains(';')) {
            		for(String s : datePar.split(';')) {
	            		jobParameter jp = new jobParameter();
	                    jp.pName = s;
	                    jp.lableNam = name;
	                    dateParameters.add(jp);
	            	}
            	}else {
            		jobParameter jp = new jobParameter();
                    jp.pName = datePar;
                    jp.lableNam = name;
                    dateParameters.add(jp);
            	}
            	
            }
           
        }        
    }
      
    public class jobParameter{
        public String pName {get; set;}
        public String lableNam{get;set;}
        public String Value {get; set;}
        public Date dateValue {get; set;}
        public jobParameter() {}
        public jobParameter(String name,String laNam,String val,Date endDate){
            this.pName = name;
            this.lableNam = laNam;
            this.Value = val;
            this.dateValue = endDate;
        }
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
}