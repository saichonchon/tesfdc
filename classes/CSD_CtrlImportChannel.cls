/**
 *  This class used to csv file upload
 *
 @author Minghao Li
 @created 2014-11-20
 @version 1.0
 @since 30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
 * - Created
 * - 02/09/2016 Rajendra <Shahane rajendra.shahane@zensar.com>
* - Modified for project DND Forecast Tool Enhancement 2
* - Test Class : CSD_CtrlImportChannel_Test
 */
public without sharing class CSD_CtrlImportChannel {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public transient String jsonMapping {get;set;}
    public transient String jsonCSVHead {get;set;}
    public transient String currentFiscalDate {get;set;}
    public Integer batchNum {get;set;}
    public Boolean isStop {get;set;}
    public Boolean isError {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CSD_CtrlImportChannel(){
        this.isStop = false;
        this.isError = false;
        this.batchNum = 1000;
        
        Date d = CSD_ClsUtils.getFiscalDate();
        this.currentFiscalDate = (d.year() + '-' + d.month() +'-'+ d.day());
        
        /*
        OEM Name - OEM                              public String oemname {get;set;}
        Soldto Number - Sold To Number              public String soldtonumber {get;set;}
        Fiscal Year - Fiscal Year                   public String year {get;set;}
        Fiscal Month - Fiscal Month                 public String month {get;set;}
        Channel Forecast - Channel Forecast         public String forecast {get;set;}
        Billing Region - Billing Region             public String billingregion {get;set;}
        */
        map<String, String> map_mapping = new map<String, String>{
            'Billing Region' => 'billingregion',
            'OEM Name' => 'oemname', 
            'CM+1' => 'm1', 'CM+2' => 'm2', 'CM+3' => 'm3', 'CM+4' => 'm4', 'CM+5' => 'm5', 'CM+6' => 'm6', 
            'CM+7' => 'm7', 'CM+8' => 'm8', 'CM+9' => 'm9', 'CM+10' => 'm10', 'CM+11' => 'm11', 'CM+12' => 'm12'
            ,'CM+13' => 'm13','CM+14' => 'm14','CM+15' => 'm15','CM+16' => 'm16','CM+17' => 'm17','CM+18' => 'm18'
        };
        list<String> list_head = new list<String>{ 
            'Billing Region', 'OEM Name', 'CM+1', 'CM+2', 'CM+3', 'CM+4', 'CM+5', 'CM+6', 'CM+7', 'CM+8', 'CM+9', 'CM+10', 'CM+11', 'CM+12', 'CM+13', 'CM+14', 'CM+15', 'CM+16', 'CM+17', 'CM+18'
        };
        this.jsonCSVHead = String.join(list_head, ',');
        this.jsonMapping = Json.serialize(map_mapping);
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    

    
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * This method is used to delete key part managements records 
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
            for(CSD_Channel_Forecast__c kpm : [Select Id From CSD_Channel_Forecast__c limit 10000]){
                list_kpm.add(kpm);
            }
            
            this.isStop = (list_kpm.size() < 10000 ? true : false);
            
            if(!list_kpm.isEmpty()){
                delete list_kpm;
            }
            
        }catch(Exception e){
            this.isStop = this.isError = true;
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
        }
    }
    /**
    * This method is used to upsert SamSung Mapping 
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
    @RemoteAction
    public static String upsertListObject(String o){
        list<CustomChannel> list_fc = (list<CustomChannel>)JSON.deserialize(o, list<CustomChannel>.class);
        
        list<ExceptionObj> list_exception = new list<ExceptionObj>();
        list<CSD_Channel_Forecast__c> list_upsert = new list<CSD_Channel_Forecast__c>();
        
        matchMapSoldTo_OEM(list_fc, list_exception);
        matchListForecast(list_fc, list_upsert, list_exception);
        
        if(!list_upsert.isEmpty()) {
        //  upsert list_upsert External_Id__c;
            Database.UpsertResult[] list_result = database.upsert(list_upsert, CSD_Channel_Forecast__c.External_Id__c.getDescribe().getSObjectField(), false);
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@');
            system.debug(list_result);
            system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@');
        }
        
        return Json.serialize(list_exception);
    }

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
    * This method is used to match account and part id.
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
    private static void matchMapSoldTo_OEM(list<CustomChannel> list_fc, list<ExceptionObj> list_exception){
        
        map<String, String> map_oem = new map<String, String>();
        
        for(CustomChannel fc : list_fc){
            map_oem.put(fc.oemname, '');
        }
        for(Account a : [Select Id, Name From Account Where Name IN: map_oem.keySet() and Account_Type__c = 'OEM' and Active__c = true order by AccountNumber asc]){
            if(map_oem.containsKey(a.Name))
                map_oem.put(a.Name, a.Id);
        }
        for(CustomChannel fc : list_fc){
            if(map_oem.containsKey(fc.oemname)){
                fc.oemId = map_oem.get(fc.oemname);
            }
        }
    }
    
    /**
    * This method is used to match csd mapping samsung forecast
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
    private static void matchListForecast(list<CustomChannel> list_channel, list<CSD_Channel_Forecast__c> list_upsert, list<ExceptionObj> list_exception){
        
        for(CustomChannel channel : list_channel){
            
            list<String> list_str = new list<String>();
            
            if(String.isBlank(channel.billingregion)){
                list_str.add('Billing Region');
            }

            if(String.isBlank(channel.oemname) || String.isblank(channel.oemId)){
                list_str.add('OEM Name');
            }
            
            if(!list_str.isEmpty()){
                String t = (CSD_ClsUtils.getFormatString(list_str) + ' does not match!');
                list_exception.add(new ExceptionObj(t, channel.index));
                continue;
            }
            
            for(CustomChannel fc : channel.list_fc){
                list_upsert.add(
                    new CSD_Channel_Forecast__c( CurrencyIsoCode='USD', 
                        Forecast__c=fc.forecast, Fiscal_Year__c=fc.fYear, Fiscal_Month__c=fc.fMonth, 
                        OEM__c=(String.isBlank(channel.oemId) ? null : channel.oemId), Billing_Region__c=channel.billingregion, 
                        External_Id__c = (fc.fYear+'-'+fc.fMonth+'-'+channel.billingregion+'-'+channel.oemId)
                    )
                );
            }
        }
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    
    public class CustomException extends Exception{ }
    
    public class ExceptionObj {
        public String errorMsg {get; set;}
        public Integer index {get; set;}
        
        public ExceptionObj(String errorMsg, Integer index){
            this.errorMsg = errorMsg;
            this.index = index;
        }
        
    }

    public class CustomChannel{
        public String oemname {get;set;}
        public String oemId {get;set;}
        public String fYear {get;set;}
        public String fMonth {get;set;}
        public Double forecast {get;set;}
        public String billingregion {get;set;}
        public Integer index {get;set;}
        
        public list<CustomChannel> list_fc {get;set;}
        
    }
    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************

}