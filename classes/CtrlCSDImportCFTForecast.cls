/**
 *  This class used to csv file upload
 *
 @author Minghao Li
 @created 2014-09-23
 @version 1.0
 @since 30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-09-23 Minghao Li <minghao.li@itbconsult.com>
 * - Created
 * - 02/09/2016 Rajendra <Shahane rajendra.shahane@zensar.com>
* - Modified for project DND Forecast Tool Enhancement 2
* - Test Class : CtrlCSDImportCFTForecast_Test
 */
public without sharing class CtrlCSDImportCFTForecast {
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public transient String jsonMapping {get;set;}
    public transient String jsonNewHead {get;set;}
    public transient String jsonCSVHead {get;set;}
    public transient String currentFiscalDate {get;set;}
    public transient String strCurrentDate {get;set;}

    public transient list<String> list_head {get;set;}
    public transient map<String, String> map_mapping {get;set;}
    public transient list<CustomCFTFilter> list_field_filter {get;set;}
    public transient map<String, list<CustomCFTFilter>> map_sql_filter {get;set;}
    public transient LocaleConfig lc {get;set;}
    
    public Integer batchNumber {get; set;}
    public Boolean isStop {get;set;}
    public Boolean isError {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    {
        this.lc = new LocaleConfig();
        setUserLocale(lc, userInfo.getLocale());
    }
    
    public CtrlCSDImportCFTForecast(){
        
        batchNumber = 80;   //set batch update number
        this.isStop = false;
        this.isError = false;

        initFilter();
        
        Date d = CSD_ClsUtils.getFiscalDate();
        this.strCurrentDate = d.format();   //'MM/dd/yyyy'
        this.currentFiscalDate = (d.year() + '-' + (d.month()+1) +'-'+ d.day());
        
        this.map_mapping = new map<String, String>{
            'SoldTo account number' => 'soldToName', 
            'OEM account name' => 'oemName', 
            'Part name' => 'partName',
            'Billing region' => 'billingRegion',
            'LastModifiedDate' => 'LastModifiedDate',
            'CM+1' => 'm1', 'CM+2' => 'm2', 'CM+3' => 'm3', 'CM+4' => 'm4', 'CM+4' => 'm4', 'CM+5' => 'm5', 
            'CM+6' => 'm6', 'CM+7' => 'm7', 'CM+8' => 'm8', 'CM+9' => 'm9', 'CM+10' => 'm10', 'CM+11' => 'm11',
            'CM+12' => 'm12','CM+13' => 'm13','CM+14' => 'm14','CM+15' => 'm15','CM+16' => 'm16','CM+17' => 'm17','CM+18' => 'm18'
        };
        this.list_head = new list<String>{
            'SoldTo account number', 'OEM account name', 'Part name', 'Billing region', 'LastModifiedDate',
            'CM+1', 'CM+2', 'CM+3', 'CM+4', 'CM+5', 'CM+6', 'CM+7', 'CM+8', 'CM+9', 'CM+10', 'CM+11', 'CM+12', 'CM+13', 'CM+14', 'CM+15', 'CM+16', 'CM+17', 'CM+18'
        };
        this.jsonCSVHead = String.join(list_head, ',');
        this.jsonNewHead = String.join(new list<String>{
            'SoldTo account number', 'OEM account name', 'Part name', 'Billing region',
            'CM+1', 'CM+2', 'CM+3', 'CM+4', 'CM+5', 'CM+6', 'CM+7', 'CM+8', 'CM+9', 'CM+10', 'CM+11', 'CM+12','CM+13','CM+14','CM+15','CM+16','CM+17','CM+18'
        }, ',');
        this.jsonMapping = Json.serialize(map_mapping);
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    

    
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * This method is used to delete CFT forecast records 
    *
    @author Minghao Li
    @created 2014-11-21
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    public void deleteObject(){
        this.isError = false;
        try{
            list<Sobject> list_kpm = new list<Sobject>();
            for(CSD_CFT_Forecast__c kpm : [Select Id From CSD_CFT_Forecast__c limit 10000]){
                list_kpm.add(kpm);
            }
            
            this.isStop = (list_kpm.size() < 10000 ? true : false);
            
            if(!list_kpm.isEmpty()){
                delete list_kpm;
            }
            
        }catch(Exception e){
            this.isStop = true;
            this.isError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
        }
    }
    /**
    * This method is used to upsert CFT forecast 
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    @RemoteAction
    public static String upsertListCFTForecast(String o){
        system.debug('errdbg1'+o);
        list<CustomCFTForecast> list_fc = (list<CustomCFTForecast>)JSON.deserialize(o, list<CustomCFTForecast>.class);
        
        list<CSD_CFT_Forecast__c> list_cftFC2Upsert = new list<CSD_CFT_Forecast__c>();
        list<ExceptionObj> list_exception = new list<ExceptionObj>();
        map<String, list<CustomCFTForecast>> map_mapping = new map<String, list<CustomCFTForecast>>();
        
        matchUploadData(list_fc, map_mapping);
        matchListForecast(list_cftFC2Upsert, list_exception, map_mapping);
        if(!list_cftFC2Upsert.isEmpty()) 
        {
            for(CSD_CFT_Forecast__c oCSD_CFT_Forecast :list_cftFC2Upsert)
                system.debug('errdbg12' +oCSD_CFT_Forecast.External_Id__c + '=' + oCSD_CFT_Forecast);
        
            //system.debug('asdf2'+database.upsert(list_cftFC2Upsert, CSD_CFT_Forecast__c.External_Id__c.getDescribe().getSObjectField(), false));
            
            list<Database.UpsertResult> lstSaveResult = database.upsert(list_cftFC2Upsert, CSD_CFT_Forecast__c.External_Id__c.getDescribe().getSObjectField(), false);
            for (Database.UpsertResult sr : lstSaveResult)
                system.debug('errdbg13'+ sr.getErrors());

        }

        return Json.serialize(list_exception);
    }


    /**
    * This method is used to search CFT forecast 
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */

    @RemoteAction
    public static String runReportData(String q){
        list<CustomReport> list_report = new list<CustomReport>();
        list<CustomCFTForecast> list_cft = new  list<CustomCFTForecast>();
        map<String, list<CustomCFTForecast>> map_list_cft = new map<String, list<CustomCFTForecast>>();
        
        matchReport(q, list_cft);

        for(CustomCFTForecast c : list_cft){
            String key = (c.billingRegion + '-'+c.soldToName+ '-'+c.oemName+'-'+c.partName);
            
            if(!map_list_cft.containsKey(key)){
                map_list_cft.put(key, new list<CustomCFTForecast>());
            }
            map_list_cft.get(key).add(c);
        }
        list_cft.clear();
        for(String key : map_list_cft.keySet()){
            list_report.add( new CustomReport(key, map_list_cft.get(key)) );
        }
        map_list_cft.clear();

        return JSON.serialize(list_report);
    }

    
    /**
    * This method is used to search all CFT forecast 
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */

    @RemoteAction
    public static String runAllReportData(String q){
        CustomAllReport allReport= new CustomAllReport();
        list<CustomCFTForecast> list_cft = new  list<CustomCFTForecast>();
        map<String, list<CustomCFTForecast>> map_list_cft = new map<String, list<CustomCFTForecast>>();
        
        matchReport(q, list_cft);
        allReport.lastId = (list_cft.size() == 10000 ? list_cft.get(list_cft.size()-1).id : '');

        allReport.list_reports.addAll( list_cft );
        /*
        for(CustomCFTForecast c : list_cft){
            String key = (c.billingRegion + '-'+c.soldToName+ '-'+c.oemName+'-'+c.partName);
            if(!map_list_cft.containsKey(key)){
                map_list_cft.put(key, new list<CustomCFTForecast>());
            }
            map_list_cft.get(key).add(c);
        }
        
        list_cft.clear();
        
        for(String key : map_list_cft.keySet()){
            allReport.list_report.add( new CustomReport(key, map_list_cft.get(key)) );
        }
        map_list_cft.clear();
        */
        return JSON.serialize(allReport);
    }
    
    
    /**
    * This method is used to search all CFT forecast 
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */

    @RemoteAction
    public static String runFilterReportData(String q){
        CustomAllReport allReport= new CustomAllReport();
        list<CustomCFTForecast> list_cft = new  list<CustomCFTForecast>();
        map<String, list<CustomCFTForecast>> map_list_cft = new map<String, list<CustomCFTForecast>>();
        
        matchReport(q, list_cft);
        allReport.lastId = (list_cft.size() == 10000 ? list_cft.get(list_cft.size()-1).id : '');

        allReport.list_reports.addAll( list_cft );

        return JSON.serialize(allReport);
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    private static void matchReport(String q, list<CustomCFTForecast> list_cft){
        for(CSD_CFT_Forecast__c cft : Database.query(q)){
            CustomCFTForecast c = new CustomCFTForecast();
            c.id = cft.Id;
            c.soldToName = (cft.Sold_To_Number__c == null ? '' : cft.Sold_To_Number__c);
            c.accName = (cft.Sold_To_Name__c == null ? '' : cft.Sold_To_Name__c);
            c.billingRegion = (cft.Billing_Region__c == null ? '' : cft.Billing_Region__c);
            c.fMonth = cft.Fiscal_Month__c;
            c.fYear = cft.Fiscal_Year__c;
            c.oemId = cft.OEM__c;
            c.oemName = cft.OEM__r.Name;
            c.partId = cft.Part__c;
            c.partName = cft.Part__r.Name;
            c.qty = (Integer)cft.Quantity__c;
            DateTime Dt = cft.LastModifiedDate;
            c.LastModifiedDate = Date.newInstance(Dt.year(),Dt.Month(),Dt.day());
            c.externalKey = (c.soldToName+ '-'+c.oemName+'-'+c.partName);
            list_cft.add(c);
        }
    }
    /**
    * This method is used to upsert CFT forecast 
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private static void matchListForecast(list<CSD_CFT_Forecast__c> list_cftFC2Upsert, list<ExceptionObj> list_exception,
                            map<String, list<CustomCFTForecast>> map_mapping){
        
        
        for(String key : map_mapping.keySet()){
            for(CustomCFTForecast fc : map_mapping.get(key)) {
                
                list<String> list_str = new list<String>();
                if(String.isBlank(fc.soldId)){
                    list_str.add('SoldTo account number');
                }
                    
                if(String.isBlank(fc.oemId)){
                    list_str.add('OEM account name');
                }
                if(String.isBlank(fc.partId)){
                    list_str.add('Part name');
                }
                
                if(fc.list_qty.isEmpty()){
                    list_str.add('Fiscal date');
                }
                
                if(!list_str.isEmpty()){
                    String t = (CSD_ClsUtils.getFormatString(list_str) + ' does not match!');
                    list_exception.add(new ExceptionObj(t, fc.index));
                    continue;
                }
                
                for(CustomCFTForecast qtyFc : fc.list_qty){
                    list_cftFC2Upsert.add(
                        new CSD_CFT_Forecast__c(Part__c=fc.partId, OEM__c=fc.oemId, Quantity__c=qtyFc.qty, Sold_To_Number__c=fc.soldToName,
                        Sold_To_Name__c = fc.accName,
                        Billing_Region__c=fc.billingRegion, Fiscal_Year__c=qtyFc.fYear, Fiscal_Month__c=qtyFc.fMonth, 
                        External_Id__c=(fc.soldToName+'-'+fc.oemId+'-'+fc.partId+'-'+qtyFc.fYear+'-'+qtyFc.fMonth))
                    );
                }
            }
            
        }
        
        
        
    }
    
    /**
    * This method is call soldto, oem, part function.
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private static void matchUploadData(list<CustomCFTForecast> list_fc, map<String, list<CustomCFTForecast>> map_mapping){
        matchSoldTo_OEM(list_fc, map_mapping);
        matchPart(list_fc, map_mapping);
    }
    
    /**
    * This method is used to match soldto and oem
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private static void matchSoldTo_OEM(list<CustomCFTForecast> list_fc, map<String, list<CustomCFTForecast>> map_mapping){
        
        map<String, String> map_oem = new map<String, String>();
        
        for(CustomCFTForecast fc : list_fc) {
            if(!map_mapping.containsKey(fc.soldToName)){
                map_mapping.put(fc.soldToName, new list<CustomCFTForecast>());
            }
            map_mapping.get(fc.soldToName).add(fc);
            map_oem.put(fc.oemName.toLowerCase(), '');
        }
        
        for(Account a : [Select Id, AccountNumber, Name, Profit_ctr_code__c, RecordType.Name From Account 
                        Where ( STATDESC__c = 'Active' AND AccountNumber IN : map_mapping.keySet() )
                                or (OEM_Lower_Name__c IN: map_oem.keySet() and RecordType.Name = 'OEM' 
                                //and Profit_ctr_code__c = 'CSD' 
                                and Active__c=true)
                          order by AccountNumber asc]){
            //a.Profit_ctr_code__c == 'CSD' && 
            if(a.RecordType.Name == 'OEM' && map_oem.containsKey(a.Name.toLowerCase())) {
                map_oem.put(a.Name.toLowerCase(), a.Id);
            }
            if(map_mapping.containsKey(a.AccountNumber) && a.AccountNumber != '') {
                for(CustomCFTForecast cs : map_mapping.get(a.AccountNumber)){
                    cs.soldId = a.Id;
                    cs.accName = a.Name;
                }
            }
        }
        
        list_fc.clear();
        
        for(String key : map_mapping.keySet()){
            list_fc.addAll(map_mapping.get(key));
        }
        
        for(CustomCFTForecast fc : list_fc){
            if(map_oem.containsKey(fc.oemName.toLowerCase())){
                fc.oemId = map_oem.get(fc.oemName.toLowerCase());
            }
        }
        map_mapping.clear();
    }
    
    /**
    * This method is used to match part
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private static void matchPart(list<CustomCFTForecast> list_fc, map<String, list<CustomCFTForecast>> map_mapping){
        for(CustomCFTForecast fc : list_fc){
            String lowName = fc.partName.toLowerCase();
            if(!map_mapping.containsKey(lowName)){
                map_mapping.put(lowName, new list<CustomCFTForecast>());
            }
            map_mapping.get(lowName).add(fc);
        }
        
        for(Part__c p : [Select Id, Name From Part__c Where Part_Lower_Name__c IN: map_mapping.keySet()]){
            if(!map_mapping.containsKey(p.Name.toLowerCase())){ continue; }
            for(CustomCFTForecast cs : map_mapping.get(p.Name.toLowerCase())){
                cs.partId = p.Id;
            }
        }
        list_fc.clear();
    }
    
    /**
    * This method is init sql filter.
    *
    @author Minghao Li
    @created 2014-09-24
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
    * - Created
    */
    private void initFilter(){
        
        this.map_sql_filter = new map<String, list<CustomCFTFilter>>{
            'string' => new list<CustomCFTFilter>{
                            new CustomCFTFilter('equals', '', '='), new CustomCFTFilter('not equal to', '', '!='),
                            /*
                            new CustomCFTFilter('less than', '', '<'), new CustomCFTFilter('greater than', '', '>'),
                            new CustomCFTFilter('less or equal', '', '<='), new CustomCFTFilter('greater or equal', '', '>='),
                            */
                            new CustomCFTFilter('contains', '', 'in'), new CustomCFTFilter('does not contain', '', 'not in'),
                            new CustomCFTFilter('starts with', '', 'like')
                        }
        };
        
        /*
        Part__c=fc.partId, OEM__c=fc.oemId, Quantity__c=qtyFc.qty, Sold_To_Number__c=fc.soldToName,
                        Sold_To_Name__c = fc.accName,
                        Billing_Region__c=fc.billingRegion, Fiscal_Year__c=qtyFc.fYear, Fiscal_Month__c=qtyFc.fMonth
        */
        this.list_field_filter = new list<CustomCFTFilter>{
            new CustomCFTFilter('Billing region', 'Billing_Region__c', 'string'),
            new CustomCFTFilter('SoldTo account number', 'Sold_To_Number__c', 'string'),
            new CustomCFTFilter('SoldTo name', 'Sold_To_Name__c', 'string'),
            new CustomCFTFilter('OEM account name', 'OEM__r.Name', 'string'),
            new CustomCFTFilter('Part name', 'Part__r.Name', 'string')
        };

    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    public static void setUserLocale(LocaleConfig localeConfig, String userLocale){
        try{
            localeConfig.locale= userLocale;
            list<String> list_s = localeConfig.locale.split('_');
            localeConfig.locale = list_s[0]+'-'+list_s[1];
        }catch(Exception e){
            localeConfig.locale = 'de-DE';
        }   
        localeConfig.jsPath = '/glob-cultures/cultures/globalize.culture.'+localeConfig.locale+'.js';
    }
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    
    public class LocaleConfig{
        public String locale {get;set;}
        public String jsPath {get;set;}
    }
    
    public class CustomException extends Exception{ }
    
    public class ExceptionObj {
        public String errorMsg {get; set;}
        public Integer index {get; set;}
        
        public ExceptionObj(String errorMsg, Integer index){
            this.errorMsg = errorMsg;
            this.index = index;
        }
        
    }
    
    public class CustomAllReport{
        public String lastId {get;set;}
        public list<CustomReport> list_report {get;set;}
        public list<CustomCFTForecast> list_reports {get;set;}

        public CustomAllReport(){
            this.lastId = '';
            this.list_report = new list<CustomReport>();
            this.list_reports = new list<CustomCFTForecast>();
        }
    }
    
    public class CustomReport{
        public String key {get;set;}
        public list<CustomCFTForecast> list_cft {get;set;}
        
        public CustomReport(String key, list<CustomCFTForecast> list_cft){
            this.key = key;
            this.list_cft = list_cft;
        }
    }
    
    public class CustomCFTFilter{
        public String filter {get;set;}
        public String field {get;set;}
        public String type {get;set;}

        public CustomCFTFilter(){ }
        
        public  CustomCFTFilter(String filter, String field, String type){
            this.filter = filter;
            this.field = field;
            this.type = type;
        }

    }
    
    public class CustomCFTForecast{
        
        public String soldToName {get;set;}
        public String oemName {get;set;}
        public String partName {get;set;}
        
        public String soldId {get;set;}
        public String oemId {get;set;}
        public String partId {get;set;}
        public String accName {get;set;}
        public Date LastModifiedDate {get;set;}
        public String externalKey {get;set;}
        
        public String billingRegion {get;set;}
        public String fYear {get;set;}
        public String fMonth {get;set;}
        public Integer qty {get;set;}
        public Integer index {get; set;}
        public String id {get;set;}
        public list<CustomCFTForecast> list_qty {get;set;}

    }
    
    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}