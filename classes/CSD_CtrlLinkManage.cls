/**
 *  This class is CSD link manager
 *  
 * @author Lei Tang
 * @created 2015-03-03
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-03-03 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 *
 */
public without sharing class CSD_CtrlLinkManage {
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //public transient String jsonlinkmap {get; set;}
    public transient map<String, list<PageLink>> map_section_link {get;set;}
    public transient map<String, PageLink> pagelinkentry {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CSD_CtrlLinkManage(){
        initLink();
        
        initPage();
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    public void initPage() {
        set<String> set_roles = new set<String>();
        set<String> set_improts = new set<String>();
        Boolean isGAMManager = false;
        Boolean isSamsung = false;
        for(CSD_Forecast_Management__c manager : [select Id, Role__c, User__c, Master_Data_Import__c from CSD_Forecast_Management__c where User__c = :UserInfo.getUserId()]) {
            if(!set_roles.contains(manager.Role__c)) {
                set_roles.add(manager.Role__c);
                
            }
            if(manager.Role__c == 'Sales Leader') {
                isGAMManager = true;
            }
            if(manager.Role__c == 'Regional Admin' && manager.Master_Data_Import__c != null) {
                list<String> improts = manager.Master_Data_Import__c.split(';');
                for(String perm : improts) {
                    if(!set_improts.contains(perm)) {
                        set_improts.add(perm);
                    }
                }
            }
        }
        String useremail= '';
        for(User user : [select Email from User where Id = :UserInfo.getUserId()]) {
            useremail = '%' + user.Email + '%';
        }

        for(CSD_Samsung_Mapping__c sm : [select GPL_Family__c, GPL_Code__c, Category__c, Part__c 
                                        from CSD_Samsung_Mapping__c 
                                        where Sales_Email__c like :useremail limit 1]) {
            isSamsung = true;
        }
        
        if(!isGAMManager) {
            for(Account acc:  [select Id, Name 
                               from Account 
                               where RecordType.Name = 'OEM' 
                                    and Account_Manager__c = :UserInfo.getUserId()
                                    and Active__c = true
                                    //and Profit_ctr_code__c = 'CSD' 
                                    limit 1
                                    ]) {
                isGAMManager = true;
            }
        }
        
        this.map_section_link = new map<String, list<PageLink>>();
        list<PageLink> list_Forecast = new list<PageLink>();
        list_Forecast.add(pagelinkentry.get('DND SoldTo Forecast'));
        if(isSamsung) {
            list_Forecast.add(pagelinkentry.get('DND Samsung Forecast'));
        }
        map_section_link.put('edit',list_Forecast);
        
        list<PageLink> list_Views = new list<PageLink>();
        if(set_roles.contains('Samsung GAM')) {
            list_Views.add(pagelinkentry.get('DND Samsung View'));
        }
        if(set_roles.contains('RSM')) {
            list_Views.add(pagelinkentry.get('DND Regional Leader View'));
        }
        if(isGAMManager) {
            list_Views.add(pagelinkentry.get('DND GAM View'));
        }
        if(set_roles.contains('ODM')) {
            list_Views.add(pagelinkentry.get('DND ODM View'));
        }  
        if(set_roles.contains('Sales Leader')) {
            list_Views.add(pagelinkentry.get('DND Global Leader View'));
        }  
        list_Views.add(pagelinkentry.get('DND Sales Person View'));
        if(isGAMManager) {
            list_Views.add(pagelinkentry.get('DND GAM Comparison View'));
        }
        if(set_roles.contains('Regional Comparison')) {
            list_Views.add(pagelinkentry.get('DND Regional Comparison View'));
        }
        map_section_link.put('view',list_Views);
        
        list<PageLink> list_Import = new list<PageLink>();
        if(set_roles.contains('Regional Admin')) {
            for(String imports : set_improts) {
                list_Import.add(pagelinkentry.get(imports));
            }
        }
        map_section_link.put('import',list_Import);
        //ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, JSON.serialize(map_section_link)));
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    private void initLink() {
        this.pagelinkentry = new map<String, PageLink>();
        PageLink soldTolink = new PageLink('DND SoldTo Forecast','DND SoldTo Forecast','DND Sales Forecast Entry Page for Sales Except from Korean Samsung.','CSD_CtrlSoldToForecast');
        this.pagelinkentry.put('DND SoldTo Forecast', soldTolink);
        
        PageLink samsunglink = new PageLink('DND Samsung Forecast','DND Samsung Forecast','DND Sales Forecast Entry Page for Korean Samsung Sales.','CSD_CtrlSamSungForecast');
        this.pagelinkentry.put('DND Samsung Forecast', samsunglink);
        
        PageLink samsungviewlink = new PageLink('DND Samsung View','DND Samsung View','Used by Samsung GAMs to Review Forecasts Entered by Samsung Sales.','CSD_CtrlSamsungViewForecast');
        this.pagelinkentry.put('DND Samsung View', samsungviewlink);
        
        PageLink salesleaderlink = new PageLink('DND Global Leader View','DND Global Leader View','Used by Sales Leaders to Review Forecasts by Billing Region and Design-in Region.','CSD_CtrlSalesLeaderViewForecast');
        this.pagelinkentry.put('DND Global Leader View', salesleaderlink);
        
        PageLink salespersonlink = new PageLink('DND Sales Person View','DND Sales Person View','Used by Top Managers to Review forecasts by Sales Person They Are Responsible to.','CSD_CtrlSalesPersonViewForecast');
        this.pagelinkentry.put('DND Sales Person View', salespersonlink);

        PageLink odmviewlink = new PageLink('DND ODM View','DND ODM View','Used by ODM Managers to Review Forecasts by World Wide Account.','CSD_CtrlODMViewForecast');
        this.pagelinkentry.put('DND ODM View',odmviewlink);

        PageLink rsmviewlink = new PageLink('DND Regional Leader View','DND Regional Leader View','Used by RSMs to Review Forecasts by Billing Region and Design-in Region They are Responsible to.','CSD_CtrlRSMViewForecast');
        this.pagelinkentry.put('DND Regional Leader View',rsmviewlink);

        
        PageLink gamviewlink = new PageLink('DND GAM View','DND GAM View','Used by GAMs to Review Forecasts by OEMs They are Responsible to.','CSD_CtrlGAMViewForecast');
        this.pagelinkentry.put('DND GAM View',gamviewlink);

        PageLink regionalcomparisonlink = new PageLink('DND Regional Comparison View','DND Regional Comparison View','Used by RSMs to Inspect Comparisons between Latest Sales Forecast and Last Cycle DC Forecast Quarterly.','CSD_CtrlRegionalComparisonView');
        this.pagelinkentry.put('DND Regional Comparison View',regionalcomparisonlink);

        PageLink gamcomparisonlink = new PageLink('DND GAM Comparison View','DND GAM Comparison View','Used by GAMs to Inspect Comparisons between Latest Sales Forecast and Last Cycle DC Forecast Quarterly.','CSD_CtrlGlobalGAMComparisonView');
        this.pagelinkentry.put('DND GAM Comparison View',gamcomparisonlink);

        PageLink cftimportlink = new PageLink('DND CFT Forecast Import','DND CFT Forecast Import','Used by CFT Team to upload CFT Forecasts.','CtrlCSDImportCFTForecast');
        this.pagelinkentry.put('CFT Forecast Import',cftimportlink);

        PageLink samsungimportlink = new PageLink('DND Samsung Mapping File Import','DND Samsung Mapping File Import','Used by Samsung Team to Upload Samsung Mapping File.','CSD_CtrlImportSamSungMapping');
        this.pagelinkentry.put('Samsung Mapping File Import',samsungimportlink);

        PageLink keypartimportlink = new PageLink('DND Key Part Management Import','DND Key Part Management Import','Used by Regional Admin to Upload Key Part Management Records.','CSD_CtrlImportKeyPart');
        this.pagelinkentry.put('Key Part Management Import',keypartimportlink);

        PageLink channelimportlink = new PageLink('DND Channel Forecast Import','DND Channel Forecast Import','Used by Admin to Upload Channel Forecasts.','CSD_CtrlImportChannel');
        this.pagelinkentry.put('Channel Forecast Import',channelimportlink);
        
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    public class PageLink {
        public String label {get;set;}
        public String title {get;set;}
        public String url {get;set;}
        public String description {get;set;}
        
        public PageLink(String label, String title, String description, String url) {
            this.label = label;
            this.title = title;
            this.description = description;
            this.url = '/apex/' + url;
        }
    }
}