/**
*   extension for Opportunity forecast
*
@author bin yu
@created 2012-03-03
@version 1.0
@since 23.0.
*
@changelog
* 2012-03-03 bin yu <bin.yu@itbconsult.cofm>
* - Created

@changelog
* 2014-09-01 Padmaja D <padmaja.dadi@te.com>
* - Modified
* 2018-01-03 RaviPrakash Soda 
* - Modified: line 83  - added one more profile name Appliance Inside Sales Playbook User. (|| profileName == 'Appliance Inside Sales Playbook User')
*/

public without sharing class ExtProgramOppyForecastAPL {
   
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    public Opportunity opportunity {get; set;}      
    public List<Opportunity> list_oppys {get; set;}
    public List<Opportunity_Part__c> list_parts;
    public List<OppyForecastStructure> list_forecastStructures{get; set;}   
    public String format {get; set;}
    public String isSaved {get; set;}
    public Boolean isProgramLevelForecasting {get; set;}
    //public Boolean validMassProd {get; set;}
    public Boolean validOpportunities {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private final ApexPages.standardController stdCtrl;
    private Map<String, List<Opportunity_Forecast__c>> map_year_oppyForecast;
    private Map<String, Map<Id, List<Opportunity_Forecast__c>>> map_year_map_oppyId_oppyForecast;
    private Set<Id> set_partIds;
    private Map<Id, Opportunity> map_id_opportunity;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- ///////////////////////////////////// 
    public ExtProgramOppyForecastAPL(ApexPages.standardController stdCtrl) {
        this.stdCtrl = stdCtrl;     
        if(UserInfo.getLocale().indexOf('de') != -1){
            format = 'de';
        }
        else{
            format = 'other';
        }
        isSaved = '';
        //validMassProd = true;
        validOpportunities = true;
        opportunity = (Opportunity) stdCtrl.getRecord();
        opportunity = [select Id, Program_level_Forecasting__c, CurrencyIsoCode  from Opportunity where id = :opportunity.Id];
        isProgramLevelForecasting = opportunity.Program_level_Forecasting__c;       
        map_year_map_oppyId_oppyForecast = new Map<String, Map<Id, List<Opportunity_Forecast__c>>>();
        list_forecastStructures = new List<OppyForecastStructure>();
        map_id_opportunity = new Map<Id, Opportunity>();
        map_id_opportunity = ClsOppyForecastUtilAPL.getOpportunitysByProgramId(opportunity.Id);
        if(!map_id_opportunity.isEmpty()){
            if(isProgramLevelForecasting){
                for(Id oppyId: map_id_opportunity.keySet()){
                    // one of the opportunities of the program is in approval, edit is not allowed.
                    if(map_id_opportunity.get(oppyId).stageName == 'In Approval'){
                        validOpportunities = false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Program_Valid_Oppy_Check));
                        break;
                    }
                    // one of the opportunities of the program is rejected - closed, edit is not allowed.
                    else if(map_id_opportunity.get(oppyId).stageName == 'Rejected - Closed'){
                        validOpportunities = false;
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Program_Valid_Oppy_Check));
                        break;
                    }
                    else{
                        // when user is an appliance user and one of the opportunities of the program has no assigned competitor
                        String profileName;
                        for(Profile p :[select name from Profile where id = :UserInfo.getProfileId()]){
                            profileName = p.name;
                        }
                        if(map_id_opportunity.get(oppyId).Competitor_Count__c == 0 && (profileName == 'Appliance Engineering User w/Cost' || profileName == 'Appliance Standard User' || profileName == 'Appliance Inside Sales Playbook User'|| profileName == 'Appliance User w/ Cost')){
                            validOpportunities = false;
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.Program_Appliance_Oppy_Check));
                            break;
                        }
                    }              
                }
            }   
            map_year_map_oppyId_oppyForecast = ClsOppyForecastUtilAPL.getOppyForeCastMap(map_id_opportunity.keySet());
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,system.label.No_Opportunites));
        }       
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * The method is used to determine if the page will be redirected
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return        the fiscal years
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public void deterRedirect(){
        if(ApexPages.CurrentPage().getParameters().containsKey('isSaved')){
            isSaved = 'true';
        }
    }
    
    
     /**
    * The method is used to get the fiscal years
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return        the fiscal years
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public List<String> getYears(){
        List<String> list_year = new List<String>();        
        for(String year: map_year_map_oppyId_oppyForecast.keySet()){
            list_year.add(year);
        }
        list_year.sort();
        return list_year;
    }
    
     /**
    * The method is used to calculate the total revenues of every years
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return        the total revenues of every years
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public List<Opportunity_Forecast__c> getTotalRevenues(){
        List<Opportunity_Forecast__c> list_totalRevenue = new List<Opportunity_Forecast__c>();
        if(!map_year_map_oppyId_oppyForecast.isEmpty()){
            List<String> list_year = new List<String>();            
            for(String year: map_year_map_oppyId_oppyForecast.keySet()){
                list_year.add(year);
            }
            list_year.sort();
            for(String year: list_year){
                Opportunity_Forecast__c revenue = new Opportunity_Forecast__c();
                revenue.Amount__c = 0;
                for(Id oid : map_id_opportunity.keySet()){
                    if(map_year_map_oppyId_oppyForecast.get(year).containsKey(oid)){
                        for(Opportunity_Forecast__c ofc: map_year_map_oppyId_oppyForecast.get(year).get(oid)){
                            if(map_id_opportunity.get(oid).CurrencyIsoCode != opportunity.CurrencyIsoCode){
                                revenue.Amount__c += ClsOppyForecastUtilAPL.transformIsoCode( ofc.Amount__c, map_id_opportunity.get(oid).CurrencyIsoCode, opportunity.CurrencyIsoCode);
                            }
                            else {
                                revenue.Amount__c += ofc.Amount__c;
                            }
                        }
                    }
                }
                list_totalRevenue.add(revenue);
            }
        }
        return list_totalRevenue;
    }
    
     /**
    * The method is used to get opportunity forecast structures
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return        opportunity forecast structures
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public List<OppyForecastStructure> getOppyForecastStructures(){
        Map<Id, OppyForecastStructure> map_id_structures = new Map<Id, OppyForecastStructure>();
        if(!map_year_map_oppyId_oppyForecast.isEmpty()){
            List<String> list_year = new List<String>();            
            for(String year: map_year_map_oppyId_oppyForecast.keySet()){
                list_year.add(year);
            }
            list_year.sort();
            for(String year: list_year){
                for(Id oid : map_id_opportunity.keySet()){
                    if(!map_id_structures.containsKey(oid)){                        
                        OppyForecastStructure ofcs = new OppyForecastStructure(map_id_opportunity.get(oid));
                        map_id_structures.put(oid, ofcs);
                    }
                    
                    OppyForecastStructureItem item;
                    if(map_year_map_oppyId_oppyForecast.get(year).containsKey(oid)){
                        item = new OppyForecastStructureItem(oid, opportunity.CurrencyIsoCode, map_id_opportunity, year, map_year_map_oppyId_oppyForecast.get(year).get(oid));
                    }
                    else{
                        item = new OppyForecastStructureItem(oid, opportunity.CurrencyIsoCode, map_id_opportunity, year, new List<Opportunity_Forecast__c>{});
                    }
                    map_id_structures.get(oid).items.add(item);
                }
            }
        }
        else{
            List<String> list_year = ClsOppyForecastUtilAPL.getYearList(new set<String>{}, true, 5);
            for(String year: list_year){
                if(!map_year_map_oppyId_oppyForecast.containsKey(year)){
                    map_year_map_oppyId_oppyForecast.put(year, new Map<Id, List<Opportunity_Forecast__c>>{});
                }
            }
            for(String year: list_year){
                for(Id oid : map_id_opportunity.keySet()){
                    if(!map_id_structures.containsKey(oid)){
                        OppyForecastStructure ofcs = new OppyForecastStructure(map_id_opportunity.get(oid));
                        map_id_structures.put(oid, ofcs);
                    }
                    
                    OppyForecastStructureItem item;
                    if(map_year_map_oppyId_oppyForecast.get(year).containsKey(oid)){
                        item = new OppyForecastStructureItem(oid, opportunity.CurrencyIsoCode, map_id_opportunity, year, map_year_map_oppyId_oppyForecast.get(year).get(oid));
                    }
                    else{
                        item = new OppyForecastStructureItem(oid, opportunity.CurrencyIsoCode, map_id_opportunity, year, new List<Opportunity_Forecast__c>{});
                    }
                    map_id_structures.get(oid).items.add(item);
                }               
            }
        } 
        return map_id_structures.values();      
    }
    
     /**
    * The method is the edit method
    *
    @author Bin yu
    @created 2012-03-03
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param    
    *
    @return            
    *
    @changelog
    * 2012-03-03 Bin yu <bin.yu@itbconsult.com>
    * - Created
    */
    public PageReference editProgram(){
        PageReference pageRef = new PageReference('/apex/ExtProgramOppyForecastEntryAPL?id=' + opportunity.Id+'&mode=edit');            
        pageRef.setRedirect(true);
        return pageRef;    
    }   
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************         
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- *********************************** 
    public class OppyForecastStructure{
        public Opportunity oppy {get; set;}
        public List<OppyForecastStructureItem> items {get; set;}
        public OppyForecastStructure(Opportunity o){
            oppy = o;
            items = new List<OppyForecastStructureItem>();
        }       
    }                 
    ///*>>>WrapperClass*/  
    public class OppyForecastStructureItem{
        public String year {get; set;}
        public Opportunity_Forecast__c totalRevenue {get; set;}
        public Opportunity_Forecast__c Q1{get; set;}
        public Opportunity_Forecast__c Q2{get; set;}
        public Opportunity_Forecast__c Q3{get; set;}
        public Opportunity_Forecast__c Q4{get; set;}
        public List<Opportunity_Forecast__c> fcs  = new List<Opportunity_Forecast__c>();
        public OppyForecastStructureItem(Id oid, String opportunityIsoCode, Map<Id, Opportunity> map_id_opportunity, String year, List<Opportunity_Forecast__c> forecasts){
            this.year = year;
            totalRevenue = new Opportunity_Forecast__c();
            totalRevenue.Amount__c = 0;
            ClsOppyForecastUtilAPL.getAllFiscalQuarter(); 
            Q1 = new Opportunity_Forecast__c();
            Q2 = new Opportunity_Forecast__c();
            Q3 = new Opportunity_Forecast__c();
            Q4 = new Opportunity_Forecast__c();
            Q1.Amount__c = 0;
            Q2.Amount__c = 0;
            Q3.Amount__c = 0;
            Q4.Amount__c = 0;
            fcs.add(Q1);
            fcs.add(Q2);
            fcs.add(Q3);
            fcs.add(Q4);
            ClsOppyForecastUtilAPL.getAllFiscalQuarter();
            for(Opportunity_Forecast__c fc :forecasts){
                //String theMonth = '';
                if(fc.Amount__c!=null){
                    if(fc.CurrencyIsoCode != opportunityIsoCode){
                        totalRevenue.Amount__c += ClsOppyForecastUtilAPL.transformIsoCode(fc.Amount__c, fc.CurrencyIsoCode, opportunityIsoCode);
                    }  
                    else{
                        totalRevenue.Amount__c += fc.Amount__c ;
                    }
                } 
                String q = '';
                q = ClsOppyForecastUtilAPL.getForecastQuarter(fc.Date__c);
                Decimal a = fc.Amount__c;
                if(fc.CurrencyIsoCode != opportunityIsoCode){
                    a = ClsOppyForecastUtilAPL.transformIsoCode(fc.Amount__c, fc.CurrencyIsoCode, opportunityIsoCode);
                }
                fcs.get(Integer.valueOf(q)-1).Amount__c +=  a;
                fcs.get(Integer.valueOf(q)-1).CurrencyIsoCode = opportunityIsoCode;
            }
        }
    }     
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}