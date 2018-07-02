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
private class ClsBatch_UpdtFcstValuestoLastMonth_Test {

    static testMethod void testUpdtFcstValueLastMonth() {	
	list<Overall_Forecast__c> oFcstList = new list<Overall_Forecast__c>();
	list<Account_Forecast__c> aFcstList = new list<Account_Forecast__c>();
	
	Id OverallFcstId;
	Id AccountFcstId;
	
	Overall_Forecast__c oFcst = new Overall_Forecast__c();	
	Account_Forecast__c aFcst = new Account_Forecast__c();
	
		oFcst.GAM_Code__c = 'G000';
	 	oFcst.Previous_Month_6__c			= -6;
	 	oFcst.Previous_Month_5__c 			= -5;
	 	oFcst.Previous_Month_4__c 			= -4;
	 	oFcst.Previous_Month_3__c 			= -3;
	 	oFcst.Previous_Month_2__c 			= -2;
	 	oFcst.Previous_Month_1__c 			= -1;
	 	oFcst.Month_0__c 					= 0;
		oFcst.Month_1__c 					= 1;
	 	oFcst.Month_2__c 					= 2;
	 	oFcst.Month_3__c 					= 3;
	 	oFcst.Month_4__c 					= 4;
	 	oFcst.Month_5__c 					= 5;
	 	oFcst.Month_6__c 					= 6;
	 	oFcst.Month_7__c 					= 7;
	 	oFcst.Month_8__c 					= 8;
	 	oFcst.Month_9__c 					= 9;
	 	oFcst.Month_10__c 					= 10;
	 	oFcst.Month_11__c 					= 11;
	 	oFcst.Month_12__c 					= 12;
	 	oFcst.Month_13__c 					= 13;
	 	oFcst.Month_14__c 					= 14;
	 	oFcst.Month_15__c 					= 15;
	 	oFcst.Month_16__c 					= 16;
	 	oFcst.Month_17__c 					= 17;
	 	oFcst.Bookings_Previous_Month_6__c 	= -6;
	 	oFcst.Bookings_Previous_Month_5__c 	= -5;
	 	oFcst.Bookings_Previous_Month_4__c 	= -4;
	 	oFcst.Bookings_Previous_Month_3__c 	= -3;
	 	oFcst.Bookings_Previous_Month_2__c 	= -2;
	 	oFcst.Bookings_Previous_Month_1__c 	= -1;
	 	oFcst.Bookings_Month_0__c 			= 0;
	 	oFcst.Bookings_Month_1__c 			= 1;
	 	oFcst.Bookings_Month_2__c 			= 2;
	 	oFcst.Bookings_Month_3__c 			= 3;
	 	oFcst.Bookings_Month_4__c 			= 4;
	 	oFcst.Bookings_Month_5__c 			= 5;
	 	oFcst.Bookings_Month_6__c 			= 6;
	 	oFcst.Bookings_Month_7__c 			= 7;
	 	oFcst.Bookings_Month_8__c 			= 8;
	 	oFcst.Bookings_Month_9__c 			= 9;
	 	oFcst.Bookings_Month_10__c 			= 10;
	 	oFcst.Bookings_Month_11__c 			= 11;
	 	oFcst.Bookings_Month_12__c 			= 12;
	 	oFcst.Bookings_Month_13__c 			= 13;
	 	oFcst.Bookings_Month_14__c 			= 14;
	 	oFcst.Bookings_Month_15__c 			= 15;
	 	oFcst.Bookings_Month_16__c		 	= 16;
	 	oFcst.Bookings_Month_17__c 			= 17; 

	oFcstList.add(oFcst); 
	
	 	aFcst.Previous_Month_6__c			= -6;
	 	aFcst.Previous_Month_5__c 			= -5;
	 	aFcst.Previous_Month_4__c 			= -4;
	 	aFcst.Previous_Month_3__c 			= -3;
	 	aFcst.Previous_Month_2__c 			= -2;
	 	aFcst.Previous_Month_1__c 			= -1;
	 	aFcst.Month_0__c 					= 0;
		aFcst.Month_1__c 					= 1;
	 	aFcst.Month_2__c 					= 2;
	 	aFcst.Month_3__c 					= 3;
	 	aFcst.Month_4__c 					= 4;
	 	aFcst.Month_5__c 					= 5;
	 	aFcst.Month_6__c 					= 6;
	 	aFcst.Month_7__c 					= 7;
	 	aFcst.Month_8__c 					= 8;
	 	aFcst.Month_9__c 					= 9;
	 	aFcst.Month_10__c 					= 10;
	 	aFcst.Month_11__c 					= 11;
	 	aFcst.Month_12__c 					= 12;
	 	aFcst.Month_13__c 					= 13;
	 	aFcst.Month_14__c 					= 14;
	 	aFcst.Month_15__c 					= 15;
	 	aFcst.Month_16__c 					= 16;
	 	aFcst.Month_17__c 					= 17;		 	
	
	Account a = C2ForecastTestHelp.createTestAccounts();
	a.GAMCD__c = 'G000';
	insert a;	
	aFcst.Account__c = a.Id;
	
	Database.SaveResult[] OverallResult = Database.Insert(oFcstList);
	OverallFcstId = OverallResult[0].getId();
	aFcst.Overall_Forecast__c = OverallFcstId;
	aFcstList.add(aFcst); 
	Database.SaveResult[] AccountResult = Database.Insert(aFcstList);	 	
	AccountFcstId = AccountResult[0].getId();
		
		list<Overall_Forecast__c> oUpdt = [select id , Month_0__c, Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c,Month_13__c,Month_14__c,Month_15__c,Month_16__c,Month_17__c,Previous_Month_1__c,Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c,Previous_Month_6__c,Bookings_Month_0__c, Bookings_Month_1__c,Bookings_Month_2__c,Bookings_Month_3__c,Bookings_Month_4__c,Bookings_Month_5__c,Bookings_Month_6__c,Bookings_Month_7__c,Bookings_Month_8__c,Bookings_Month_9__c,Bookings_Month_10__c,Bookings_Month_11__c,Bookings_Month_12__c,Bookings_Month_13__c,Bookings_Month_14__c,Bookings_Month_15__c,Bookings_Month_16__c,Bookings_Month_17__c,Bookings_Previous_Month_1__c,Bookings_Previous_Month_2__c,Bookings_Previous_Month_3__c,Bookings_Previous_Month_4__c,Bookings_Previous_Month_5__c,Bookings_Previous_Month_6__c  from Overall_Forecast__c where Id =: OverallFcstId];
        ClsBatch_UpdateForecastValuestoLastMonth clsBatch = new ClsBatch_UpdateForecastValuestoLastMonth();
        Database.BatchableContext BC1;
        clsBatch.query = 'select id from Overall_Forecast__c where id = \'' + OverallFcstId + '\' limit 1';
        //clsBatch.email = 'sfdc@sfdc.com';
        clsBatch.ObjectName = 'Overall_Forecast__c';
    	clsBatch.start(BC1);
		clsBatch.execute(BC1, oUpdt);
		clsBatch.finish(BC1);
		
		oUpdt = [Select Month_12__c, Bookings_Previous_Month_1__c from Overall_Forecast__c where Id =: OverallFcstId];	
		system.assert(oUpdt[0].Month_12__c == 13, 'Overall Fcst value does not match expected output');
		system.assert(oUpdt[0].Bookings_Previous_Month_1__c == 0, 'Overall Fcst value does not match expected output');
		
		list<Account_Forecast__c> aUpdt = [select id , Month_0__c, Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c,Month_13__c,Month_14__c,Month_15__c,Month_16__c,Month_17__c,Previous_Month_1__c,Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c,Previous_Month_6__c from Account_Forecast__c where Id =: AccountFcstId];		
        ClsBatch_UpdateForecastValuestoLastMonth clsBatch2 = new ClsBatch_UpdateForecastValuestoLastMonth();
        Database.BatchableContext BC2;
        clsBatch2.query = 'select id from Account_Forecast__c where Id = \'' + AccountFcstId + '\' limit 1';
        //clsBatch2.email = 'sfdc@sfdc.com';        
        clsBatch2.ObjectName = 'Account_Forecast__c';        
    	clsBatch2.start(BC2);
		clsBatch2.execute(BC2, aFcstList);
		clsBatch2.finish(BC2);			

		aUpdt = [Select Month_17__c from Account_Forecast__c where Id =: AccountFcstId];	
		system.assert(aUpdt[0].Month_17__c == 0, 'Acct Fcst value does not match expected output');
	
    }
	
}