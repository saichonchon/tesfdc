/**
 *  The controller for vf page ManageAccountsforGAMEntry
 *
 @author Anthony Tersine
 @created 2012-01-18
 @version 1.0
 @since 25.0 (Force.com ApiVersion)
 */
public without sharing class ManageAccountsforGAMEntry {

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //public Account_Forecast__c acctForecast { set; get; }
    public list<AccountForecastInnerClass> list_accountForecasts{get;set;} 
    //public String subtitle { set; get; } 
    
    public Integer addAmount{get;set;}
    public Integer deleteParterIndex{get;set;}
    public Integer selectedIndex{get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private final ApexPages.standardController stdCtrl;
    public Id overallForecastId { get; set; }
    public String gamCode { get; set; }
    private map<Id, Account_Forecast__c> mapOfAccountForecastsToDelete ;
    private Boolean saveCompleted;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
    * The contsructor
    *
    @author Anthony Tersine
    @created 2012-01-18
    @version 1.0
    @since 25.0 (Force.com ApiVersion)
    */
    public ManageAccountsforGAMEntry(ApexPages.standardController stdCtrl) {

        this.stdCtrl = stdCtrl;
        
        String theGamCode = ApexPages.currentPage().getParameters().get('GamCode');
    	gamCode = theGamCode;
    	//gamCode = 'G999';
        
        system.debug('--------------------------------------- gamCode '+gamCode);
    	
        for(Overall_Forecast__c overallForecast : [SELECT Id
        											FROM Overall_Forecast__c 
        											WHERE GAM_Code__c = :gamCode]){
            overallForecastId = overallForecast.id;
            system.debug('--------------------------------------- overallForecastId '+overallForecastId);
        }
    
        list_accountForecasts = new list<AccountForecastInnerClass>();
        mapOfAccountForecastsToDelete = new map<Id, Account_Forecast__c>();
        
        saveCompleted = false;
        GetAll();
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    /**
     * This method is used to quick save, that's to say save but not back to the opportunity page
     *
     @author Anthony Tersine
     @created 2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            null
     */     
    public PageReference QuickSave(){
    	ApexPages.getMessages().clear();   	
        list<Account_Forecast__c> list_accountForecast2Update = new list<Account_Forecast__c>();
        list<Account_Forecast__c> list_accountForecast2Insert = new list<Account_Forecast__c>();
        set<Id> set_accIds2Save = new set<Id>();
        //ClsOppyPartUtil.needCheckAlloc = true;  
        Savepoint sp = Database.setSavepoint();
        
        //lookup the Account Number of the newly added Accounts
        List<Account> misfits = new List<Account>();
        Set<Id> misfitAccountIds = new Set<Id>();
        for(AccountForecastInnerClass afic: list_accountForecasts) {
        	if((afic.accountName == null || afic.accountName.equals('')) && afic.afc != null && afic.afc.Account__c != null && !((String)afic.afc.Account__c).trim().equals('')) {
        		system.debug('----------------------------- the other stuff is ' +afic);
        		misfitAccountIds.add(afic.afc.Account__c);
        	}
        }		
		List<Account> misfitAccounts =  [SELECT Id, AccountNumber, GAMCD__c 
						FROM Account
						WHERE Id in :misfitAccountIds];
		system.debug('----------------------------- misfitAccounts'+misfitAccounts);
		for(Account misfit: misfitAccounts) {
			for(AccountForecastInnerClass afic : list_accountForecasts) {
				if(afic.afc != null && afic.afc.Account__c != null && misfit.Id != null && ((String)afic.afc.Account__c).trim().equals(((String)misfit.Id).trim())  ) {
					system.debug('---------------------- afic.afc.Account__c ' +afic.afc.Account__c);
					system.debug('---------------------- misfit.Id '+misfit.Id);
					system.debug('-------------------- afic.accountNumber ' +afic.accountNumber);
					system.debug('-------------------- misfit.AccountNumber ' +misfit.AccountNumber);
					afic.accountNumber = misfit.AccountNumber;
					system.debug('------------------------------ added the account number to the newly selected account. The account number is: '+afic.accountNumber);
				}
			}
		}
		
		//set the Account Number for the Account_Forecast__c record
		for(AccountForecastInnerClass afic : list_accountForecasts){
			if(afic.afc.Account_Number__c == null || !afic.afc.Account_Number__c.trim().equals('') ) {
				if(afic.AccountNumber != null && !afic.AccountNumber.trim().equals('')) {
					afic.afc.Account_Number__c = afic.AccountNumber;
					system.debug('---------------------------------- set the account number properly to the account number of the Account_Forecast__c with a value of '+afic.afc.Account_Number__c);
				}
			}
		}
		

        for(AccountForecastInnerClass afic : list_accountForecasts){
        	system.debug('----------------------------- the ultimate debug of list_accountForecasts '+list_accountForecasts);
            if(afic.afc.Account__c != null && String.valueOf(afic.afc.Account__c) != ''){
                /*if(afic.afc.Partner_Role__c == null || afic.afc.Partner_Role__c ==''){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Partner Role: You must enter a value')); 
                    ResetList();     
                    return null;
                }*/
                if(!set_accIds2Save.contains(afic.afc.Account__c)){
                    if(afic.afc.Id != null){
                        set_accIds2Save.add(afic.afc.Account__c);
                        list_accountForecast2Update.add(afic.afc);
                        system.debug('------------------------------------------- list_accountForecast2Update ' +list_accountForecast2Update);
                        mapOfAccountForecastsToDelete.remove(afic.afc.Id);    
                    }
                    else{
                        set_accIds2Save.add(afic.afc.Account__c);
                        list_accountForecast2Insert.add(afic.afc);
                        system.debug('------------------------------------------- list_accountForecast2Insert '+list_accountForecast2Insert);
                    }   
                }
            }
        }
        //Could do but concensus was not to: only create account forecasts if account gam code and overall foreacast gam code are the same (cant this be resolved by passing GAM code too)
        
        //the ultimate debug of list_accountForecasts (
        //AccountForecastInnerClass:[accountName=Marvel, accountNumber=1082:12345678, afc=Account_Forecast__c:{Account__c=001c0000007wKLsAAM, RecordTypeId=012c00000004LxvAAE, CurrencyIsoCode=USD, GAM_Code__c=G999, Id=a0Kc0000001yO9WEAU}, index=0], 
        //AccountForecastInnerClass:[accountName=iRobot, accountNumber=2222:88888888, afc=Account_Forecast__c:{Account__c=001c0000007wKdEAAU, RecordTypeId=012c00000004LxvAAE, CurrencyIsoCode=USD, GAM_Code__c=G999, Id=a0Kc0000001yO9bEAE}, index=1], 
        //AccountForecastInnerClass:[accountName=, accountNumber=, afc=Account_Forecast__c:{Account__c=001c0000007OrkvAAC, Overall_Forecast__c=a1Lc0000000D6o9EAC}, index=2])
        
        //check that we are not adding/updating a duplicate account number. Display error message if a duplicate.
		Set<String> accountNumbersUnique = new Set<String>();
        if(!list_accountForecast2Update.isEmpty() || !list_accountForecast2Insert.isEmpty())  {
			system.debug('------------------------------ look at GAM code in list_accountForecast2Update '+list_accountForecast2Update);
			system.debug('------------------------------ look at GAM code in list_accountForecast2Insert '+list_accountForecast2Insert);
			for(Account_Forecast__c afUpdate : list_accountForecast2Update) {
				if(accountNumbersUnique.size() != 0 && afUpdate.Account_Number__c != null && !afUpdate.Account_Number__c.trim().equals('') && accountNumbersUnique.contains(afUpdate.Account_Number__c.trim()) ){
					system.debug('------------------------------ the trimmed account number is ' +afUpdate.Account_Number__c.trim());
				    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.Duplicate_Accounts)); 
				    ResetList();     
				    return null;
				} else {
					system.debug('--------------------------------------------------- afUpdate '+afUpdate);
					//if(afUpdate.Account_Number__c != null && !afUpdate.Account_Number__c.equals('') ) {
					accountNumbersUnique.add(afUpdate.Account_Number__c.trim());
					//}
				}
        	}
        	for(Account_Forecast__c afInsert : list_accountForecast2Insert) {
        		//do the same stuff as above
				if(accountNumbersUnique.size() != 0 && afInsert.Account_Number__c != null && !afInsert.Account_Number__c.trim().equals('') && accountNumbersUnique.contains(afInsert.Account_Number__c.trim()) ){
				    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, system.Label.Duplicate_Accounts)); 
				    ResetList();     
				    return null;
				} else {
					system.debug('-------------------------------------------------- afInsert '+afInsert);
					//if(afInsert.Account_Number__c != null && !afInsert.Account_Number__c.equals('') ) {
					accountNumbersUnique.add(afInsert.Account_Number__c.trim());
					//}
				}
        	}
        }
        
        //insert, update or delete the appropriate Account Forecasts
        if(!list_accountForecast2Update.isEmpty() || !list_accountForecast2Insert.isEmpty() || !mapOfAccountForecastsToDelete.isEmpty()) {
            try {
            	// delete account forecast				
                if(!mapOfAccountForecastsToDelete.isEmpty()) {
                	delete mapOfAccountForecastsToDelete.values();
                	
					//update the remaining rute rate when an account is deleted
	                Set<String> gamCodeSet = new Set<String>();
	                gamCodeSet.add(gamCode.trim());
	                UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(gamCodeSet); 
                }
                // update account forecast
                if(!list_accountForecast2Update.isEmpty()) {
                	update list_accountForecast2Update;
                }
                // insert account forecast
                if(!list_accountForecast2Insert.isEmpty()) {
                	insert list_accountForecast2Insert;
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, system.Label.Save_Completed));  
                saveCompleted = true;
            } catch (DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getDmlMessage(i)));
                    Database.rollback(sp);
                    ResetList();    
                    return null;
                }
            }
        }
        
        Savepoint sp2 = Database.setSavepoint();
        
        //in account measures there is a look up field called account forecast that neeeds to be updated when an Account forecast is created
        //Todo: should this be done upon update too?
        List<Account_Measures__c> accountMeasuresToUpdate = new List<Account_Measures__c>();
		system.debug('------------------------------------ accountNumbersUnique '+accountNumbersUnique);
        if(!list_accountForecast2Insert.isEmpty()) {
        	for(Account_Measures__c am: [SELECT id, Account_Number__c
        								FROM Account_Measures__c
        								WHERE Account_Number__c in :accountNumbersUnique]) {
        		system.debug('---------------------------------- am '+am);
        		system.debug('---------------------------------- list_accountForecast2Insert '+list_accountForecast2Insert);
        		for(Account_Forecast__c af: list_accountForecast2Insert) {
	        		if(am.Account_Number__c != null && af.Account_Number__c != null && am.Account_Number__c.trim().equals(af.Account_Number__c.trim())) {
	        			system.debug('---------------------------------- af.Id '+af.Id);
	        			am.Account_Forecast__c = af.Id;
		        		accountMeasuresToUpdate.add(am);
	        			system.debug('------------------------------ we are updating the Account Measures with '+am);
	        		}
        		}
        	}
        }
        if(!list_accountForecast2Insert.isEmpty() ) {
            try {
                //update account measures for the inserted account forecasts
                if(!list_accountForecast2Insert.isEmpty() ) {
                	update accountMeasuresToUpdate;
                }
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, system.Label.Save_Completed));  
                //saveCompleted = true;
            } catch (DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getDmlMessage(i)));
                    Database.rollback(sp2);
                    ResetList();    
                    return null;
                }
            }
        }
        
        ResetList();
        return null;
    }
    
    /**
     * This method is used to save and back to the opportunity page
     *
     @author Anthony Tersine
     @created 2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            null or the opportunity page
     */     
    public PageReference SaveAndReturn(){
        saveCompleted = false;
        QuickSave();
        if(saveCompleted == true) {
        	return new pageReference('/apex/ManageGAMForecastEntry?GamCode='+gamCode);
        }
        return null;
    }
    
    /**
     * This method is used to delete opportunity partner
     *
     @author Anthony Tersine
     @created 2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            the return Amounts option list
     */     
    public void DeleteOpportunityPartner(){
        if(deleteParterIndex != null){
            list_accountForecasts.remove(deleteParterIndex);
        }
        list<AccountForecastInnerClass> list_opNew = new list<AccountForecastInnerClass>();
        for(AccountForecastInnerClass p : list_accountForecasts){
            AccountForecastInnerClass afic = new AccountForecastInnerClass();
            afic.afc = p.afc;
            afic.index = list_opNew.size();
            afic.accountName = p.accountName;
            afic.accountNumber = p.accountNumber;
            list_opNew.add(afic);
        }
        list_accountForecasts = new list<AccountForecastInnerClass>();
        list_accountForecasts = list_opNew;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Delete_After_Save_Account));
        ResetList();
    }
    /**
     * This method is used to add partners
     *
     @author Anthony Tersine
     @created  2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            the return Amounts option list
     */     
    public void AddPartners(){
        for(Integer i = 0; i < addAmount; i++){
            AccountForecastInnerClass afic = new AccountForecastInnerClass();
            Account_Forecast__c af = new Account_Forecast__c();
            af.Overall_Forecast__c = overallForecastId;
            af.CurrencyIsoCode = 'USD';
            //af.Account_Number__c = what
            afic.afc = af;
            afic.accountName = '';
            afic.accountNumber = '';
            afic.index = list_accountForecasts.size();
            list_accountForecasts.add(afic);
            system.debug('---------------------------------------addPartners: afic '+afic);
            system.debug('---------------------------------------addPartners: list_accountForecasts '+list_accountForecasts);
        }
        ResetList();
        system.debug('---------------------------------------addPartners: list_accountForecasts '+list_accountForecasts);
        
    }
    /**
     * This method is used to reset opportunity partner list
     *
     @author Anthony Tersine
     @created  2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            the return Amounts option list
     */     
    private void ResetList(){
    	system.debug('------------------ within ResetList');
        mapOfAccountForecastsToDelete = new map<Id, Account_Forecast__c>();
        for(Account_Forecast__c af : [SELECT Id, GAM_Code__c, Account__c, Account_Number__c, Account__r.Name , Account__r.SALES_TERRITORY_NM__c, Account__r.BillingCity, Account__r.BillingState , Account__r.BillingCountry
        								FROM Account_Forecast__c 
        								WHERE Overall_Forecast__c = :overallForecastId]){
            mapOfAccountForecastsToDelete.put(af.Id, af);
        }
        
        set<Id> set_partnerIds = new set<Id>();
        map<Id, String> map_accId_accName = new map<Id, String>();
        map<Id, String> map_accId_accNumber = new map<Id, String>();
        for(AccountForecastInnerClass afic : list_accountForecasts){
            if(afic.afc.Account__c != null && String.valueOf(afic.afc.Account__c) != '') 
            	set_partnerIds.add(afic.afc.Account__c);
        }
        for(Account a : [select Id, Name, AccountNumber, GAMCD__c from Account where Id in: set_partnerIds]){
            map_accId_accName.put(a.Id, a.Name);
            map_accId_accNumber.put(a.Id, a.AccountNumber); 
            system.debug('---------------------- a is '+a);           
        }
        set<Id> set_accIds = new set<Id>();
        list<AccountForecastInnerClass> list_opNew = new list<AccountForecastInnerClass>();
        for(AccountForecastInnerClass afic : list_accountForecasts){
            if(afic.afc.Account__c != null && String.valueOf(afic.afc.Account__c) != '') {
                afic.accountName = map_accId_accName.get(afic.afc.Account__c);
                system.debug('----------------------------------------------- afic.accountName '+ afic.accountName);
                afic.accountNumber = map_accId_accNumber.get(afic.afc.Account__c);
                system.debug('----------------------------------------------- afic.accountNumber +' +afic.accountNumber);
                if(saveCompleted == true && !set_accIds.contains(afic.afc.Account__c)){
                    set_accIds.add(afic.afc.Account__c);
                    
                    AccountForecastInnerClass picNew = new AccountForecastInnerClass();
                    picNew.afc = afic.afc;
                    picNew.index = list_opNew.size();
                    picNew.accountName = afic.accountName;
                    picNew.accountNumber = afic.accountNumber;
                    //picNew.accountName = afic.accountName;
                    list_opNew.add(picNew);
                } 
            }
            else if(saveCompleted == true){
                AccountForecastInnerClass picNew = new AccountForecastInnerClass();
                picNew.afc = afic.afc;
                picNew.index = list_opNew.size();
                //picNew.accountName = afic.accountName;
                list_opNew.add(picNew);
            }
        }
        if(saveCompleted == true){
            list_accountForecasts = new list<AccountForecastInnerClass>();
            list_accountForecasts = list_opNew;
        }
    }
    
    /**
     * This method is used to get select list for the amount the user want to add partner
     *
     @author Anthony Tersine
     @created 2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            the return Amounts option list
     */ 
    public List<SelectOption> getAmounts() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', '1'));
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('6', '6'));
        options.add(new SelectOption('7', '7'));
        options.add(new SelectOption('8', '8'));
        options.add(new SelectOption('9', '9'));
        options.add(new SelectOption('10', '10'));
        return options;
    }
    
    /**
     * This method is used to check the duplicate partner
     *
     @author Anthony Tersine
     @created  2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            the return Amounts option list
     */ 
    public void checkDuplicatePartner() {
    	Set<String> set_accountId = new Set<String>();
    	for(AccountForecastInnerClass afic : list_accountForecasts){
    		if(afic.index != selectedIndex && afic.afc.Account__c != null && String.valueOf(afic.afc.Account__c) != '') 
    			set_accountId.add(afic.afc.Account__c);
    	}
        for(AccountForecastInnerClass afic : list_accountForecasts){
        	if(selectedIndex != null && afic.index == selectedIndex){
        		if(afic.afc.Account__c != null && set_accountId.contains(afic.afc.Account__c) && String.valueOf(afic.afc.Account__c) != '') {
        			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Account_Exists));
        			afic.afc.Account__c = null;
        			afic.accountName = '';
        			afic.accountNumber = '';
        		}       		
        		break;
        	}
        }
        ResetList();
    }
    
    
    /**
     * This method is used to cancel create new Account_Forecast__c
     *
     @author Anthony Tersine
     @created 2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            new pageReference('/'+overallForecastId);
     */
    public PageReference cancel() {
        //return new pageReference('/'+overallForecastId);
        return new pageReference('/apex/ManageGAMForecastEntry?GamCode='+gamCode);
    }

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
     * This method is used to get all opportunity partners according to the Opportunity Id
     *
     @author Anthony Tersine
     @created 2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            void
     */ 
    private void GetAll(){
        for(Account_Forecast__c af : [SELECT Id, GAM_Code__c, Account__c, Account_Number__c, Account__r.Name, Account__r.SALES_TERRITORY_NM__c, Account__r.BillingCity, Account__r.BillingState , Account__r.BillingCountry
        								FROM Account_Forecast__c 
        								WHERE Overall_Forecast__c = :overallForecastId]){
        									
        								/*SELECT Id, GAM_Code__c, Account__c, Account_Number__c, Account__r.Name 
        								FROM Account_Forecast__c 
        								WHERE Overall_Forecast__c = :overallForecastId]){*/
            mapOfAccountForecastsToDelete.put(af.Id, af);
            AccountForecastInnerClass afic = new AccountForecastInnerClass();
            afic.afc = af;
            afic.accountName = af.Account__r.Name;
            afic.accountNumber = af.Account_Number__c;
            afic.index = list_accountForecasts.size();
            list_accountForecasts.add(afic);
        }
    }    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    /**
     * Inner class contains Opportunity Partner
     *
     @author Anthony Tersine
     @created 2012-01-18
     @version 1.0
     @since 25.0
     *
     @return            void
     */     
    public class AccountForecastInnerClass{
        public Account_Forecast__c afc { get; set; }
        public Integer index { get; set; }
        public String accountName { get; set; }
        public String accountNumber { get; set; }
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}