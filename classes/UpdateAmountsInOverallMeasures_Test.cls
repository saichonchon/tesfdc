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
@isTest (SeeAllData=true)
private class UpdateAmountsInOverallMeasures_Test {

    static testMethod void TestMethod1() {
        String testGamCode = 'G444TEST';
        
         User me = [ select Id from User where Id = :UserInfo.getUserId() ];
    	User usr = C2ForecastTestHelp.createTestUsers();
    	Sales_Hierarchy__c sh = C2ForecastTestHelp.createTestSalesHierarchy();
    	   
		System.runAs ( me ) {
	    	usr.isActive = true;
	    	insert usr;
		

    	system.debug(' testGamCode ' +testGamCode);
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
    	
    	list<Overall_Measures__c> lst_ovmMesures = new list<Overall_Measures__c>();
   
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
    	
    	Overall_Measures__c ovMTotalOpportunities = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMTotalOpportunities.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMTotalOpportunities.Sales_Hierarchy__c = sh.Id;
    	ovMTotalOpportunities.Type__c ='Total Opportunities';
    	ovMTotalOpportunities.Overall_Forecast__c =ovF.Id;
    	insert ovMTotalOpportunities;

		set<String> set_gamCode = new set <String>();
		set_gamCode.add(sh.Level_7_Territory_Code__c);
        
        UpdateAmountsInOverallMeasures.getOvForecast(ovMTotalOpportunities);
        UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(Set_gamCode);
        UpdateAmountsInOverallMeasures.CaluclateTotalRunrate(Set_gamCode);
        }
	}
	 static testMethod void TestMethod2() {
        String testGamCode = 'G444TEST';
        
         User me = [ select Id from User where Id = :UserInfo.getUserId() ];
    	User usr = C2ForecastTestHelp.createTestUsers();
    	Sales_Hierarchy__c sh = C2ForecastTestHelp.createTestSalesHierarchy();
    	   
		System.runAs ( me ) {
	    	usr.isActive = true;
	    	insert usr;
		

    	system.debug(' testGamCode ' +testGamCode);
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
    	
    	list<Overall_Measures__c> lst_ovmMesures = new list<Overall_Measures__c>();
   
    	Overall_Measures__c ovMTotalRunRate = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMTotalRunRate.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMTotalRunRate.Sales_Hierarchy__c = sh.Id;
    	ovMTotalRunRate.Type__c ='Total Run Rate';
    	ovMTotalRunRate.Overall_Forecast__c =ovF.Id;
    	insert ovMTotalRunRate;
    	
    	Overall_Measures__c ovMTotalOpportunities = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMTotalOpportunities.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMTotalOpportunities.Sales_Hierarchy__c = sh.Id;
    	ovMTotalOpportunities.Type__c ='Total Opportunities';
    	ovMTotalOpportunities.Overall_Forecast__c =ovF.Id;
    	insert ovMTotalOpportunities;

		set<String> set_gamCode = new set <String>();
		set_gamCode.add(sh.Level_7_Territory_Code__c);
        
        UpdateAmountsInOverallMeasures.getOvForecast(ovMTotalOpportunities);
        UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(Set_gamCode);
        UpdateAmountsInOverallMeasures.CaluclateTotalRunrate(Set_gamCode);
        }
	}
	    static testMethod void TestMethod3() {
        String testGamCode = 'G444TEST';
        
         User me = [ select Id from User where Id = :UserInfo.getUserId() ];
    	User usr = C2ForecastTestHelp.createTestUsers();
    	Sales_Hierarchy__c sh = C2ForecastTestHelp.createTestSalesHierarchy();
    	   
		System.runAs ( me ) {
	    	usr.isActive = true;
	    	insert usr;
		

    	system.debug(' testGamCode ' +testGamCode);
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
    	
    	list<Overall_Measures__c> lst_ovmMesures = new list<Overall_Measures__c>();
   
    	
    	Overall_Measures__c ovMRemainingAccountsRunRate = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMRemainingAccountsRunRate.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMRemainingAccountsRunRate.Sales_Hierarchy__c = sh.Id;
    	ovMRemainingAccountsRunRate.Type__c ='Remaining Accounts Run Rate';
    	ovMRemainingAccountsRunRate.Overall_Forecast__c =ovF.Id;
    	insert ovMRemainingAccountsRunRate;
    	
    	Overall_Measures__c ovMTotalOpportunities = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMTotalOpportunities.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMTotalOpportunities.Sales_Hierarchy__c = sh.Id;
    	ovMTotalOpportunities.Type__c ='Total Opportunities';
    	ovMTotalOpportunities.Overall_Forecast__c =ovF.Id;
    	insert ovMTotalOpportunities;

		set<String> set_gamCode = new set <String>();
		set_gamCode.add(sh.Level_7_Territory_Code__c);
        
        UpdateAmountsInOverallMeasures.getOvForecast(ovMTotalOpportunities);
        UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(Set_gamCode);
        UpdateAmountsInOverallMeasures.CaluclateTotalRunrate(Set_gamCode);
        }
	}
	static testMethod void TestMethod4() {
        String testGamCode = 'G444TEST';
        
         User me = [ select Id from User where Id = :UserInfo.getUserId() ];
    	User usr = C2ForecastTestHelp.createTestUsers();
    	Sales_Hierarchy__c sh = C2ForecastTestHelp.createTestSalesHierarchy();
    	   
		System.runAs ( me ) {
	    	usr.isActive = true;
	    	insert usr;
		

    	system.debug(' testGamCode ' +testGamCode);
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
    	
    	list<Overall_Measures__c> lst_ovmMesures = new list<Overall_Measures__c>();
   
    	set<String> set_gamCode = new set <String>();
		set_gamCode.add(sh.Level_7_Territory_Code__c);
        
     //   UpdateAmountsInOverallMeasures.getOvForecast(ovMTotalOpportunities);
        UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(Set_gamCode);
        UpdateAmountsInOverallMeasures.CaluclateTotalRunrate(Set_gamCode);
        }
	}
	static testMethod void TestMethod5() {
        String testGamCode = 'G444TEST';
        
         User me = [ select Id from User where Id = :UserInfo.getUserId() ];
    	User usr = C2ForecastTestHelp.createTestUsers();
    	Sales_Hierarchy__c sh = C2ForecastTestHelp.createTestSalesHierarchy();
    	   
		System.runAs ( me ) {
	    	usr.isActive = true;
	    	insert usr;
		

    	system.debug(' testGamCode ' +testGamCode);
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
    	
    	list<Overall_Measures__c> lst_ovmMesures = new list<Overall_Measures__c>();
   
    	Overall_Measures__c ovMTotalRunRate = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMTotalRunRate.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMTotalRunRate.Sales_Hierarchy__c = sh.Id;
    	ovMTotalRunRate.Type__c ='Total Run Rate';
    	ovMTotalRunRate.Overall_Forecast__c =ovF.Id;
    	insert ovMTotalRunRate;
    	
    	

		set<String> set_gamCode = new set <String>();
		set_gamCode.add(sh.Level_7_Territory_Code__c);
        
        UpdateAmountsInOverallMeasures.getOvForecast(ovMTotalRunRate);
        UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(Set_gamCode);
        UpdateAmountsInOverallMeasures.CaluclateTotalRunrate(Set_gamCode);
        }
	}
	static testMethod void TestMethod6() {
        String testGamCode = 'G444TEST';
        
         User me = [ select Id from User where Id = :UserInfo.getUserId() ];
    	User usr = C2ForecastTestHelp.createTestUsers();
    	Sales_Hierarchy__c sh = C2ForecastTestHelp.createTestSalesHierarchy();
    	   
		System.runAs ( me ) {
	    	usr.isActive = true;
	    	insert usr;
		

    	system.debug(' testGamCode ' +testGamCode);
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
    	
    	list<Overall_Measures__c> lst_ovmMesures = new list<Overall_Measures__c>();
   
    	
    	
    	Overall_Measures__c ovMRemainingAccountsRunRate = C2ForecastTestHelp.CreateTestOverallMeasures();
    	ovMRemainingAccountsRunRate.Gam_Code__c = sh.Level_7_Territory_Code__c;
    	ovMRemainingAccountsRunRate.Sales_Hierarchy__c = sh.Id;
    	ovMRemainingAccountsRunRate.Type__c ='Remaining Accounts Run Rate';
    	ovMRemainingAccountsRunRate.Overall_Forecast__c =ovF.Id;
    	insert ovMRemainingAccountsRunRate;
    	
    	

		set<String> set_gamCode = new set <String>();
		set_gamCode.add(sh.Level_7_Territory_Code__c);
        
        UpdateAmountsInOverallMeasures.getOvForecast(ovMRemainingAccountsRunRate);
        UpdateAmountsInOverallMeasures.CaluclateRemainingRunrate(Set_gamCode);
        UpdateAmountsInOverallMeasures.CaluclateTotalRunrate(Set_gamCode);
        }
	}
	
}