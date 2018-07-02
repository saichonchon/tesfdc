/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class ManageGAMForecastEntry_Test {

    static testMethod void TestMethod1() {
         Test.startTest();
         ManageGAMForecastEntry Ctrl = new ManageGAMForecastEntry();
         
         Ctrl.cancel();
         Ctrl.deleteOvForecast();
         Ctrl.getAccountNumber();
         Ctrl.getEditMode();
         Ctrl.getGamCodesForUser();
         Ctrl.getOvForecast();
         Ctrl.getShowManageAccountsButton();
         Ctrl.getWrapperData();
         Ctrl.go();
         Ctrl.manageAccounts();
         Ctrl.quickSave();
         Ctrl.setEditMode();
         Ctrl.save();
            
        system.assert(true);
        Test.stopTest();
    }
    
    static testMethod void TestMethod2() {
    String testGamCode = 'G444TEST';

		User me = [ select Id from User where Id = :UserInfo.getUserId() ];
    	User usr = C2ForecastTestHelp.createTestUsers();
    	Sales_Hierarchy__c sh = C2ForecastTestHelp.createTestSalesHierarchy();
    	   
		System.runAs ( me ) {
	    	usr.isActive = true;
	    	insert usr;
		

    	system.debug('--------------------------- testGamCode ' +testGamCode);
    	sh.Name = 'nameOfTestRecord'+testGamCode;
    	sh.Level_7_Territory_Name__c = 'nameOfTestRecord'+testGamCode;
    	sh.Level_7_Territory_Code__c = testGamCode;
    	sh.Level_7_Assigned_User_Network_Ids__c = usr.EmployeeNumber;
    	//sh.Level_7_Assigned_Users__c = usr.id;
    	sh.Level_7_Default_Owner__c = usr.id;
	    insert sh;

		Account acc = C2ForecastTestHelp.createTestAccounts();
    	acc.recordType = C2ForecastTestHelp.createTestRecordType();
		acc.GAMCD__c = testGamCode;
		acc.accountNumber = '4455:44445555';
		insert acc;

    	Overall_Forecast__c ovF = C2ForecastTestHelp.CreateTestOverallForecast();
    	ovF.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovF.Sales_Hierarchy__c = sh.Id;
    	insert ovF;
    	
    	list<Overall_Forecast__c> lst_ovForecast = new list<Overall_Forecast__c>();
  		Overall_Forecast__c ovForecast;
    	lst_ovForecast = [Select Id, Bookings_Month_0__c,Bookings_Month_1__c,Bookings_Month_2__c,Bookings_Month_3__c,Bookings_Month_4__c,Bookings_Month_5__c,Bookings_Month_6__c,Bookings_Month_7__c,Bookings_Month_8__c,Bookings_Month_9__c,Bookings_Month_10__c,Bookings_Month_11__c,Bookings_Month_12__c , Bookings_Month_13__c, Bookings_Month_14__c, Bookings_Month_15__c, Bookings_Month_16__c, Bookings_Month_17__c , Bookings_Previous_Month_1__c, Bookings_Previous_Month_2__c,Bookings_Previous_Month_3__c,Bookings_Previous_Month_4__c,Bookings_Previous_Month_5__c, Bookings_Previous_Month_6__c,
 	             Month_0__c,Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c , Month_13__c, Month_14__c, Month_15__c, Month_16__c, Month_17__c , Previous_Month_1__c, Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c, Previous_Month_6__c, GAM_Code__c , Sales_Hierarchy__c , Sum_of_Bookings__c, Sum_of_Total_Demand__c, Name , CurrencyIsoCode from Overall_Forecast__c where  Sales_Hierarchy__c = :SH.Id limit 1  ];
 	             System.Debug('@@@@lst_ovForecast'+lst_ovForecast);
 	             if (lst_ovForecast.size()!= 0)
 	             {
 	                  ovForecast = lst_ovForecast.get(0);
 	                  System.Debug('@@@@ovForecast'+ovForecast);
 //	                  ShowManageAccountsButton = true;
 	             }
    	
    	Overall_Measures__c ovMTotalRunRate = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMTotalRunRate.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMTotalRunRate.Sales_Hierarchy__c = sh.Id;
    	ovMTotalRunRate.Type__c ='Total Run Rate';
    	ovMTotalRunRate.Overall_Forecast__c =ovF.Id;
    	insert ovMTotalRunRate;
    	
    	Overall_Measures__c ovMRemainingAccountsRunRate = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMRemainingAccountsRunRate.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMRemainingAccountsRunRate.Sales_Hierarchy__c = sh.Id;
    	ovMRemainingAccountsRunRate.Type__c ='Remaining Accounts Run Rate';
    	ovMRemainingAccountsRunRate.Overall_Forecast__c =ovF.Id;
    	insert ovMRemainingAccountsRunRate;
    	
    	Overall_Measures__c ovMBacklog = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMBacklog.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMBacklog.Sales_Hierarchy__c = sh.Id;
    	ovMBacklog.Type__c ='Backlog';
    	ovMBacklog.Overall_Forecast__c =ovF.Id;
    	insert ovMBacklog;
    	
    	Overall_Measures__c ovMStatistical = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMStatistical.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMStatistical.Sales_Hierarchy__c = sh.Id;
    	ovMStatistical.Type__c ='Statistical';
    	ovMStatistical.Overall_Forecast__c =ovF.Id;
    	insert ovMStatistical;
    	
    	Overall_Measures__c ovMConsensus = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMConsensus.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMConsensus.Sales_Hierarchy__c = sh.Id;
    	ovMConsensus.Type__c ='Consensus';
    	ovMConsensus.Overall_Forecast__c =ovF.Id;
    	insert ovMConsensus;
    	
    	Overall_Measures__c ovMBilling = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMBilling.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMBilling.Sales_Hierarchy__c = sh.Id;
    	ovMBilling.Type__c ='Billing (historic)';
    	ovMBilling.Overall_Forecast__c =ovF.Id;
    	insert ovMBilling;
    	
    	Overall_Measures__c ovMScheduleAgreement = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMScheduleAgreement.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMScheduleAgreement.Sales_Hierarchy__c = sh.Id;
    	ovMScheduleAgreement.Type__c ='Schedule Agreement';
    	ovMScheduleAgreement.Overall_Forecast__c =ovF.Id;
    	insert ovMScheduleAgreement;
    	
    	Overall_Measures__c ovMDemand = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMDemand.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMDemand.Sales_Hierarchy__c = sh.Id;
    	ovMDemand.Type__c = 'Demand';
    	ovMDemand.Overall_Forecast__c =ovF.Id;
    	insert ovMDemand;
    	
    	Overall_Measures__c ovMBooking = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMBooking.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMBooking.Sales_Hierarchy__c = sh.Id;
    	ovMBooking.Type__c ='Booking (historic)';
    	ovMBooking.Overall_Forecast__c =ovF.Id;
    	insert ovMBooking;
    	
    	Overall_Measures__c ovMTotalOpportunities = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMTotalOpportunities.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMTotalOpportunities.Sales_Hierarchy__c = sh.Id;
    	ovMTotalOpportunities.Type__c ='Total Opportunities';
    	ovMTotalOpportunities.Overall_Forecast__c =ovF.Id;
    	insert ovMTotalOpportunities;
    	
    	list<Overall_Measures__c> lst_ovMeasures = new list <Overall_Measures__c>();
    	lst_ovMeasures.add(ovMTotalRunRate);
    	lst_ovMeasures.add(ovMRemainingAccountsRunRate);
    	lst_ovMeasures.add(ovMBacklog);
    	lst_ovMeasures.add(ovMStatistical);
    	lst_ovMeasures.add(ovMConsensus);
    	lst_ovMeasures.add(ovMBilling);
    	lst_ovMeasures.add(ovMScheduleAgreement);
    	lst_ovMeasures.add(ovMDemand);
    	lst_ovMeasures.add(ovMBooking);
    	lst_ovMeasures.add(ovMTotalOpportunities);
    	

    	Account_Forecast__c accountForecast = C2ForecastTestHelp.CreateTestAccountForecast();
        accountForecast.Account__c = acc.id;
        accountForecast.Account_Number__c = acc.AccountNumber;
        accountForecast.Overall_Forecast__c = ovF.Id;
        insert accountForecast;
        
        Account_Measures__c amBacklog = C2ForecastTestHelp.CreateTestAccountMeasures();
        amBacklog.Account_Forecast__c = accountForecast.Id;
        amBacklog.Account_Number__c = accountForecast.Account_Number__c;
        amBacklog.Type__c ='Backlog';
        insert amBacklog;
        
        Account_Measures__c amStatistical = C2ForecastTestHelp.CreateTestAccountMeasures();
        amStatistical.Account_Forecast__c = accountForecast.Id;
        amStatistical.Account_Number__c = accountForecast.Account_Number__c;
        amStatistical.Type__c ='Statistical';
        insert amStatistical;
        
        Account_Measures__c amConsensus = C2ForecastTestHelp.CreateTestAccountMeasures();
        amConsensus.Account_Forecast__c = accountForecast.Id;
        amConsensus.Account_Number__c = accountForecast.Account_Number__c;
        amConsensus.Type__c ='Consensus';
        insert amConsensus;
        
        Account_Measures__c amBilling = C2ForecastTestHelp.CreateTestAccountMeasures();
        amBilling.Account_Forecast__c = accountForecast.Id;
        amBilling.Account_Number__c = accountForecast.Account_Number__c;
        amBilling.Type__c ='Billing (historic)';
        insert amBilling;
        
        Account_Measures__c amScheduleAgreement = C2ForecastTestHelp.CreateTestAccountMeasures();
        amScheduleAgreement.Account_Forecast__c = accountForecast.Id;
        amScheduleAgreement.Account_Number__c = accountForecast.Account_Number__c;
        amScheduleAgreement.Type__c ='Schedule Agreement';
        insert amScheduleAgreement;
        
        Account_Measures__c amBooking = C2ForecastTestHelp.CreateTestAccountMeasures();
        amBooking.Account_Forecast__c = accountForecast.Id;
        amBooking.Account_Number__c = accountForecast.Account_Number__c;
        amBooking.Type__c ='Booking (historic)';
        insert amBooking;
        
        Account_Measures__c amDemand = C2ForecastTestHelp.CreateTestAccountMeasures();
        amBooking.Account_Forecast__c = accountForecast.Id;
        amBooking.Account_Number__c = accountForecast.Account_Number__c;
        amBooking.Type__c ='Demand';
        insert amDemand;
        
        list<Account_Measures__c> lst_am = new list <Account_Measures__c>();
        lst_am.add(amBacklog);
        lst_am.add(amStatistical);
        lst_am.add(amConsensus);
        lst_am.add(amBilling);
        lst_am.add(amScheduleAgreement);
        lst_am.add(amBooking);
        lst_am.add(amDemand);
        
        
    	list<ManageGAMForecastEntry.AccountWrapper> lst_AccountData = new list <ManageGAMForecastEntry.AccountWrapper>();
    	ManageGAMForecastEntry.AccountWrapper accountsData = new ManageGAMForecastEntry.AccountWrapper(acc ,  accountforecast ,lst_am);
    	accountsData.SelectedAccount = acc;
    	accountsData.SelectedAccountForecast = accountforecast;
    	accountsData.SelectedAccountMeasureBacklog = amBacklog;
    	accountsData.SelectedAccountMeasureStatistical = amStatistical;
    	accountsData.SelectedAccountMeasureConsensus = amConsensus;
    	accountsData.SelectedAccountMeasureBilling = amBilling; 
    	accountsData.SelectedAccountMeasureScheduleAgreement = amScheduleAgreement;
    	accountsData.SelectedAccountMeasureBooking = amBooking;
    	
    	map<String, list<Account_Measures__c>> map_AccountMeasures=new map <String, list<Account_Measures__c>>();
    	map_AccountMeasures.put(acc.AccountNumber , lst_am);
    	map<String, Account_Forecast__c> map_AccountForecast = new map<String, Account_Forecast__c>();
     	map_AccountForecast.put(acc.AccountNumber, accountforecast);
     	
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
    }
}