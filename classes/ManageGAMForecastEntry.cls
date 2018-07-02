/******************************************************************************
*   extension for Opportunity forecast
*
@author Praveen
@created 01-03-2013 
@version 1.0
*
@changelog
* 01-03-2013 Praveen bondalapati <Praveen.bondalapati@te.com>
* - Created
********************************************************************************/
global without sharing class ManageGAMForecastEntry 
{
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    
    public Boolean editMode = false;
    public Boolean hasParts {get; set;}
    public List<SelectOption> list_GAMcode;
    public List<String> list_years;
    //  public list<AccountWrapper> accountData {get; set; }
    
    public String selectedGamCode {get; set;}
    public String gamCode {get; set;}
    public Id gamCodeUser {get; set;}
    public Sales_Hierarchy__c Shierarchy {get; set;}
//    public Overall_Forecast__c ovforecast{get; set;}
    public Overall_Forecast__c ovForecast = new Overall_Forecast__c();
    public Overall_Measures__c ovmTotalRunrate{get; set;}
    public Overall_Measures__c ovmRemainingAccountsRunrate{get; set;}
    public Overall_Measures__c ovmTotalOpportunities{get; set;}
    public Overall_Measures__c ovmBilling{get; set;}
    public Overall_Measures__c ovmConsensus{get; set;}
    public Overall_Measures__c ovmStatistical{get; set;}
    public Overall_Measures__c ovmBacklog{get; set;}
    public Overall_Measures__c ovmScheduleAgreement{get; set;}
    public Overall_Measures__c ovmBooking{get; set;}
    public Overall_Measures__c ovmDemand{get; set;}
    public Overall_Measures__c ovm;
    public Account_Forecast__c af;
    public Boolean ShowManageAccountsButton = false;
    
          
        
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private final ApexPages.standardController stdCtrl;
    private Id currentUserId; 
    public list<Account> lst_AccountsforGam = new list<Account>();
    public list<Account_Measures__c> lstAm = new list<Account_Measures__c>();
    public list<Account_Forecast__c> lstAf = new list<Account_Forecast__c>();
    public set<Id> set_Accountid        = new Set<Id>(); 
    public map<String, list<Account_Measures__c>> map_AccountMeasures=new map <String, list<Account_Measures__c>>();
    public map<String, Account_Forecast__c> map_AccountForecast = new map<String, Account_Forecast__c>();
    public list<Overall_Forecast__c> lst_ovForecast =new list <Overall_Forecast__c>();
    public list<Sales_Hierarchy__c> lst_SalesHierarchies = new list <Sales_Hierarchy__c>();
    public list<Overall_Measures__c> lst_ovMeasures = new list <Overall_Measures__c>();
    public list<Overall_Measures__c> lst_UpdateovMeasures = new list <Overall_Measures__c>();
    public set <Overall_Measures__c> set_ovMeasures = new set <Overall_Measures__c>();
    public set <String> set_GamCode= new set<String>();
    public set <String> Set_AccountNumbers = new set <String>();
    public list<selectOption> Options = new list <selectOption>();
    public list<String> defaultGamCode = new list <String>();
    
  
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   /////////////////////////////////// -=BEGIN CONSTRUCTOR=- ///////////////////////////////////// 
    public ManageGAMForecastEntry() {
         system.debug('--------------------- inside getGameCodesforUser');
         list<Id> sh_Id= new list <Id>();
        lst_SalesHierarchies = [select id , Level_7_Territory_Code__c, Level_7_Default_Owner__c, Hierarchy_Type__c 
                                from Sales_Hierarchy__c 
                                where Level_7_Default_Owner__r.ID=: UserInfo.getUserId() 
                                and  Hierarchy_Type__c = 'Global Account Manager Hierarchy (GAM)'];
         for(Sales_Hierarchy__c SH:lst_SalesHierarchies  ){
            if(SH != null) {
                system.debug('----- SH'+SH);
                defaultGamCode.add(SH.Level_7_Territory_Code__c);
                system.debug ('@@@defaultGamCode'+defaultGamCode);
                sh_Id.add(SH.Id);
            }
        }
        if(!defaultGamCode.isEmpty()){
        gamCode = defaultGamCode.get(0);
        selectedGamCode  = String.valueof(sh_Id.get(0));
        go();
    }
  }
 /******************************************************************************
The method is used to show the Delete and Manage Buttons
****************************************************************************/       
    public boolean getShowManageAccountsButton(){
        return ShowManageAccountsButton;
    }
/******************************************************************************
The method is used to get the edit mode
****************************************************************************/    
    public Boolean getEditMode() {
        return Editmode;
    }
/******************************************************************************
The method is used to show & update the Overall Forecast values
****************************************************************************/       
     public overall_Forecast__c getOvForecast() {
        return ovForecast;
    }

/******************************************************************************
The method is used to get GAM Codes assigned to the currenct user. 
****************************************************************************/        
    public list<SelectOption> getGamCodesForUser(){
        
        system.debug('--------------------- inside getGameCodesforUser');
        lst_SalesHierarchies = [select id , Level_7_Territory_Code__c, Level_7_Default_Owner__c, Hierarchy_Type__c 
                                from Sales_Hierarchy__c 
                                where Level_7_Default_Owner__r.ID=: UserInfo.getUserId() 
                                and  Hierarchy_Type__c = 'Global Account Manager Hierarchy (GAM)'];
        system.debug('@@@@lst_SalesHierarchies is '+lst_SalesHierarchies);
     //   options.add(new selectOption('' , 'None'));
        for(Sales_Hierarchy__c SH:lst_SalesHierarchies  ){
            if(SH != null) {
                system.debug('----- SH'+SH);
                options.add(new selectOption(SH.id , SH.Level_7_Territory_Code__c));
                defaultGamCode.add(SH.Level_7_Territory_Code__c);
                system.debug ('@@@defaultGamCode'+defaultGamCode);
            }
        }
        system.debug('@@@@Options'+Options);
        return Options;
    }
/******************************************************************************
The method is used to get the data to show user
****************************************************************************/
    public void go() {
        if (selectedGamCode!=null ){
            system.debug ('@@@@selectedGamCode'+selectedGamCode);
            for (Sales_Hierarchy__c SH : [select id , Level_7_Territory_Code__c , Level_7_Default_Owner__c from Sales_Hierarchy__c where Id =:selectedGamCode limit 1 ] ){
                Shierarchy = sh;
                gamCode = sh.Level_7_Territory_Code__c;
                set_GamCode.add(gamCode);
                System.debug('gamCode'+gamCode);
                gamCodeUser = sh.Level_7_Default_Owner__c;
                system.debug ('@@@@Shierarchy'+Shierarchy);
           }
           lst_ovForecast = [Select Id, Bookings_Month_0__c,Bookings_Month_1__c,Bookings_Month_2__c,Bookings_Month_3__c,Bookings_Month_4__c,Bookings_Month_5__c,Bookings_Month_6__c,Bookings_Month_7__c,Bookings_Month_8__c,Bookings_Month_9__c,Bookings_Month_10__c,Bookings_Month_11__c,Bookings_Month_12__c , Bookings_Month_13__c, Bookings_Month_14__c, Bookings_Month_15__c, Bookings_Month_16__c, Bookings_Month_17__c , Bookings_Previous_Month_1__c, Bookings_Previous_Month_2__c,Bookings_Previous_Month_3__c,Bookings_Previous_Month_4__c,Bookings_Previous_Month_5__c, Bookings_Previous_Month_6__c,
           Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, GAM_Code__c , Sales_Hierarchy__c , Sum_of_Bookings__c, Sum_of_Total_Demand__c, Name , CurrencyIsoCode from Overall_Forecast__c where  Sales_Hierarchy__c = :selectedGamCode limit 1  ];
           System.Debug('@@@@lst_ovForecast'+lst_ovForecast);
           if (lst_ovForecast.size()!= 0)
           {
                ovForecast = lst_ovForecast.get(0);
                System.Debug('@@@@ovForecast'+ovForecast);
                ShowManageAccountsButton = true;
           }
           
           if (lst_ovForecast.isEmpty())
           {
                ovForecast.GAM_CODE__c = gamCode;
                ovForecast.Sales_Hierarchy__c = SelectedGamCode;
                ovForecast.CurrencyIsoCode = 'USD';
                ovForecast.Ownerid= gamCodeUser;
           }
           for (Overall_Measures__c ov : [Select Id, Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, Sales_Hierarchy__c , Sum_of_Total_Months__c, Name , type__c, CurrencyIsoCode, Overall_Forecast__c  from Overall_Measures__c where Sales_Hierarchy__c = :selectedGamCode]){
                lst_ovMeasures.add(ov);
                if (ov.Type__c == 'Total Run Rate'){
                    ovmTotalRunrate = ov;
                    system.debug ('@@@@ovmTotalRunrate'+ovmTotalRunrate);
                }else if (ov.Type__c == 'Remaining Accounts Run Rate'){
                    ovmRemainingAccountsRunrate = ov;
                    system.debug ('@@@@ovmRemainingAccountsRunrate'+ovmRemainingAccountsRunrate);
                }else if (ov.Type__c == 'Backlog'){
                    ovmBacklog = ov;
                    system.debug ('@@@@ovmBacklog'+ovmBacklog);
                }else if (ov.Type__c == 'Statistical'){
                    ovmStatistical = ov;
                    system.debug ('@@@@ovmStatistical'+ovmStatistical);
                }else if (ov.Type__c == 'Consensus'){
                    ovmConsensus = ov;
                    system.debug ('@@@@ovmConsensus'+ovmConsensus);
                }else if (ov.Type__c == 'Billing (historic)'){
                    ovmBilling = ov;
                    system.debug ('@@@@ovmBilling'+ovmBilling);
                }else if (ov.Type__c == 'Schedule Agreement'){
                    ovmScheduleAgreement = ov;
                    system.debug ('@@@@ovmScheduleAgreement'+ovmScheduleAgreement);
                }else if (ov.Type__c == 'Booking (historic)'){
                    ovmBooking = ov;
                    system.debug ('@@@@ovmBooking'+ovmBooking);
                }else if (ov.Type__c == 'Total Opportunities'){
                    ovmTotalOpportunities = ov;
                    system.debug ('@@@@ovmTotalOpportunities'+ovmTotalOpportunities);
                }else if (ov.Type__c == 'Demand'){
                    ovmDemand = ov;
                    system.debug ('@@@@ovmDemand'+ovmDemand);
                }
            }
         }
         
        editMode = false;
        pageReference pageRef = new PageReference('/' + ApexPages.currentPage().getParameters().get('id') );
    
    }
/******************************************************************************
The method is used to take users to the Manage My Accounts screen.
****************************************************************************/
    public PageReference manageAccounts() {
    
        string Url = '/apex/ManageAccountsforGAMEntry?GamCode='+gamCode;
        PageReference Pageref = new PageReference(Url);
        System.Debug('@@@Url'+url);
        pageref.setRedirect(true);
        return pageref;
    }
    
/******************************************************************************
The method is used for cancel button 
****************************************************************************/
        public PageReference cancel() {
        string Url = '/apex/ManageGAMForecastEntry?GamCode='+GamCode;
        PageReference Pageref = new PageReference(Url);
        System.Debug('@@@Url'+url);
        pageref.setRedirect(true);
        return pageref;
    }
/******************************************************************************
The method is used for Save all  button 
****************************************************************************/
        public PageReference save() {
                system.debug('Testing EditMode Save' +editmode);
                
                quickSave();
                editmode = false;
                
        string Url = '/apex/ManageGAMForecastEntry?GamCode='+GamCode;
        PageReference Pageref = new PageReference(Url);
        System.Debug('@@@Url'+url);
        pageref.setRedirect(true);
        return pageref;
    }    
     
/******************************************************************************
The method is used for Quick Save 
****************************************************************************/
        public void quickSave() {
           try{
              upsert (ovForecast);
                if (!lst_ovMeasures.isEmpty()){
                    for (Overall_Measures__c ovm:lst_ovMeasures ){
                        ovm.Overall_Forecast__c = ovForecast.Id;
                       }
                    for (Overall_Measures__c ovms: lst_ovMeasures){
                    	set_ovMeasures.add(ovms);
                    }   
                    for (Overall_Measures__c ovms: set_ovMeasures){
                    	lst_UpdateovMeasures.add(ovms);
                    }
                    update lst_UpdateovMeasures;
                    }
                    system.debug('Step11111');
                UpdateAmountsInOverallMeasures.CaluclateTotalRunrate(set_GamCode);
                list<Account_Forecast__c> lstAFSave = new list<Account_Forecast__c>();
                System.debug('map_AccountForecast'+map_AccountForecast);
                for (String accNumber : map_AccountForecast.Keyset()){
                    Account_Forecast__c afNew = map_AccountForecast.get(accNumber);
                 if (afNew.Id == null){
                        afNew.Overall_Forecast__c = ovForecast.Id;
                    }
                    lstAFSave.add(afNew);
                }
                if (!lstAFSave.isEmpty()){
                   
                    upsert lstAFSave;
                    UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(set_GamCode);      
                   
               
                }
               //	UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(set_GamCode);
                }
                catch (System.DMLException e) {
            //        ApexPages.addMessages(e);
                }
             //   go ();
                editMode = true;
                ShowManageAccountsButton = false;
                lst_ovMeasures.clear();
                system.debug('step Quic save ending');
             //   getWrapperData();
              //  return null;
           
    }
/******************************************************************************
The method is used for Delete the Overall Forecast
****************************************************************************/
        public PageReference deleteOvForecast() {
            if (ovForecast.Id != null){
            try{
                if(ovForecast != null){
                delete (ovForecast);
                }
                if (OvmTotalRunRate!= null){
                delete (ovmTotalRunrate);
                }
                if(ovmRemainingAccountsRunrate != null){
                delete (ovmRemainingAccountsRunrate);
                }
            }
            catch (System.DMLException e) {
                ApexPages.addMessages(e);
                }
            }
        string Url = '/apex/ManageGAMForecastEntry?GamCode='+GamCode;
        PageReference Pageref = new PageReference(Url);
        System.Debug('@@@Url'+url);
        pageref.setRedirect(true);
        return pageref;
    }
/******************************************************************************
The method is used for Edit Mode
****************************************************************************/
                
        public PageReference setEditMode() {
                system.debug('Testing' +editmode);
                editmode = true;
                ShowManageAccountsButton = false;
        return null;
    }
/******************************************************************************
The method is used to change the state.
****************************************************************************/       
            public list<AccountWrapper> getWrapperData(){
            list <AccountWrapper> lstWrapperAccounts = new list <AccountWrapper>();
            System.debug('@@@@OverallForecast'+OvForecast.Id); 
            if(gamCode!=null){
            lstAf= [Select id, Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, GAM_Code__c , Sum_of_Total_Months__c, Name , CurrencyIsoCode, Account__c  ,Account__r.AccountNumber, Overall_Forecast__c, Account_Number__c from Account_Forecast__c where Overall_Forecast__c = : OvForecast.Id];
            }
            system.debug('@@@lstaf'+lstaf);
            if(!lstAf.isEmpty()){
                for (Account_Forecast__c af: lstAf){
                    set_AccountId.add(af.Account__c);
                    Set_AccountNumbers.add(af.Account_Number__c); 
                    system.debug('@@@set_AccountNumbers'+set_accountNumbers);
                    system.debug('@@@set_AccountId'+set_accountId);
                }
            }
            if (!set_Accountid.isEmpty())
            {
                 lst_AccountsforGam = [select id ,name, Gamcd__c, AccountNumber, Account_Combined_Data__c from Account where id In:Set_AccountId];
                 lstAm= [Select id, Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, Sum_of_Total_Months__c, Name , type__c, CurrencyIsoCode,Account_Number__c ,Account_Forecast__r.Account_Number__c,Account_Forecast__r.Account__c from Account_Measures__c where Account_Number__c IN: Set_AccountNumbers];
          
                 system.Debug('@@@@lstAM'+lstAm);
                 system.Debug('@@@@lstAf'+lstAf);                           
            } 
            
            if (!lstAm.isEmpty()){
                for(Account_Measures__c am: lstAm){
                  if (map_AccountMeasures.ContainsKey(am.Account_Number__c)){
                        list<Account_Measures__c> lstAccountMeasuresShow= map_AccountMeasures.get(am.Account_Number__c);
                        lstAccountMeasuresShow.add(am);
                        map_AccountMeasures.put(am.Account_Number__c ,lstAccountMeasuresShow );
                    }else if (!map_AccountMeasures.ContainsKey(am.Account_Number__c)){
                        list<Account_Measures__c> lstAccountMeasuresShow2= new list<Account_Measures__c>();
                        lstAccountMeasuresShow2.add(am);
                        map_AccountMeasures.put(am.Account_Number__c ,lstAccountMeasuresShow2 );
                        system.debug('List1' +lst_AccountsforGam);
                        system.debug('MAP1' +map_AccountForecast);
                        system.debug('Map2' +map_AccountMeasures);
                    }
                }
            }
            if (!lstAf.isEmpty()){
                
                for (Account_Forecast__c af:lstaf){
            Account_Forecast__c afe = new Account_Forecast__c ();
                    
            if (!map_AccountForecast.ContainsKey(af.Account_Number__c)){
                        map_AccountForecast.put(af.Account_Number__c, af);
                    }
                }
            }
            system.debug('@@@map_AccountMeasures' +map_AccountMeasures);
                system.debug('@@@map_AccountForecast' +map_AccountForecast);
                    if(!lst_AccountsforGam.isEmpty()){
                for (Account ac:lst_AccountsforGam){
                    system.debug('map_AccountForecast.Containskey(ac.AccountNumber)' +map_AccountForecast.Containskey(ac.AccountNumber));
                        system.debug('map_AccountMeasures.containskey(ac.AccountNumber)' +map_AccountMeasures.containskey(ac.AccountNumber));
                  if(map_AccountForecast.Containskey(ac.AccountNumber) && !map_AccountMeasures.containskey(ac.AccountNumber)){
                  	Account_Measures__c aMeasures = new Account_Measures__c();
                  //	aMeasures.Account_Forecast__c = map_AccountForecast.get(ac.AccountNumber);
                  	list <Account_Measures__c> lst_aMeasures = new list<Account_Measures__c>();
                  	lst_aMeasures.add(aMeasures);
                    AccountWrapper aWrapper = new AccountWrapper (ac, map_AccountForecast.get(ac.AccountNumber), lst_aMeasures);
                    system.Debug('@@@aWrapper'+aWrapper);
                    lstWrapperAccounts.add(aWrapper);
                  }
                  else if(map_AccountForecast.Containskey(ac.AccountNumber) && map_AccountMeasures.containskey(ac.AccountNumber)){
                  	system.debug('@@@@map_AccountMeasures.get(ac.AccountNumber)'+map_AccountMeasures.get(ac.AccountNumber));
                    AccountWrapper aWrapper = new AccountWrapper (ac, map_AccountForecast.get(ac.AccountNumber), map_AccountMeasures.get(ac.AccountNumber));
                    system.Debug('@@@aWrapper'+aWrapper);
                    lstWrapperAccounts.add(aWrapper);
                  }
                }
            }   
        return lstWrapperAccounts;
        }   
             
/******************************************************************************
The wrapper class to call account forecast and account measures 
****************************************************************************/ 
    //placeholder added by tony to get just one account number. will this be in another class?
    public String getAccountNumber() {
        return '';
    }
/******************************************************************************
The wrapper class to call account forecast and account measures 
****************************************************************************/ 
   public class AccountWrapper{
        public Account SelectedAccount {get; set ; }
        public Account_Forecast__c SelectedAccountForecast {get; set ; }
        public Account_Measures__c SelectedAccountMeasureBacklog {get; set ; }
        public Account_Measures__c SelectedAccountMeasureStatistical {get; set ; }
        public Account_Measures__c SelectedAccountMeasureConsensus {get; set ; }
        public Account_Measures__c SelectedAccountMeasureBilling {get; set ; }
        public Account_Measures__c SelectedAccountMeasureScheduleAgreement {get; set ; }
        public Account_Measures__c SelectedAccountMeasureBooking {get; set ; }
        public Account_Measures__c SelectedAccountMeasureDemand {get; set ; }
        
        public  AccountWrapper (Account a, Account_Forecast__c af, list<Account_Measures__c> lstAMWrapper ){
            SelectedAccount                         = a; 
            SelectedAccountForecast                 = af; 
            if(!lstAMWrapper.isEmpty()){
            for(Account_Measures__c om: lstAMWrapper){
                if (om.Type__c == 'Backlog'){
                    SelectedAccountMeasureBacklog = om;
                    system.debug('@@@@SelectedAccountMeasureBacklog'+SelectedAccountMeasureBacklog);
                }else if (om.Type__c == 'Statistical'){
                    SelectedAccountMeasureStatistical = om;
                    system.debug('@@@@SelectedAccountMeasureStatistical'+SelectedAccountMeasureStatistical);
                    
                }else if (om.Type__c == 'Consensus'){
                    SelectedAccountMeasureConsensus = om;
                     system.debug('@@@@SelectedAccountMeasureConsensus'+SelectedAccountMeasureConsensus);
                    
                }else if (om.Type__c == 'Billing (historic)'){
                    SelectedAccountMeasureBilling = om;
                   system.debug('@@@@SelectedAccountMeasureBilling'+ SelectedAccountMeasureBilling); 
                    
                }else if (om.Type__c == 'Schedule Agreement'){
                    SelectedAccountMeasureScheduleAgreement = om;
                    system.debug('@@@@SelectedAccountMeasureScheduleAgreement'+ SelectedAccountMeasureScheduleAgreement);
                    
                }else if (om.Type__c == 'Booking (historic)'){
                    SelectedAccountMeasureBooking = om;
                    system.debug('@@@@SelectedAccountMeasureBooking'+ SelectedAccountMeasureBooking);
                }else if (om.Type__c == 'Demand'){
                    SelectedAccountMeasureDemand = om;
                    system.debug('@@@@SelectedAccountMeasureDemand'+ SelectedAccountMeasureDemand);
                    }
                }
            }
        }
    }
}