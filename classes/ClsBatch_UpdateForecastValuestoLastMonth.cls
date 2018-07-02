global class ClsBatch_UpdateForecastValuestoLastMonth implements Database.Batchable<sObject> {

public String query;
//public String email;
public string ObjectName;

global Database.querylocator start(Database.BatchableContext BC){
            return Database.getQueryLocator(query);}


global void execute(Database.BatchableContext BC, List<sObject> scope){
	list<Overall_Forecast__c> ovf = new list<Overall_Forecast__c>();
	list<Account_Forecast__c> af = new list <Account_Forecast__c>();
	 for(sObject s : scope){
	 	
	 	if (ObjectName == 'Overall_Forecast__c'){
	 		Overall_Forecast__c a 			= (Overall_Forecast__c)s;
	 	
	 	a.Previous_Month_6__c 			= a.Previous_Month_5__c;
	 	a.Previous_Month_5__c 			= a.Previous_Month_4__c;
	 	a.Previous_Month_4__c 			= a.Previous_Month_3__c;
	 	a.Previous_Month_3__c 			= a.Previous_Month_2__c;
	 	a.Previous_Month_2__c 			= a.Previous_Month_1__c;
	 	a.Previous_Month_1__c 			= a.Month_0__c;
	 	a.Month_0__c 					= a.Month_1__c;
		a.Month_1__c 					= a.Month_2__c;
	 	a.Month_2__c 					= a.Month_3__c;
	 	a.Month_3__c 					= a.Month_4__c;
	 	a.Month_4__c 					= a.Month_5__c;
	 	a.Month_5__c 					= a.Month_6__c;
	 	a.Month_6__c 					= a.Month_7__c;
	 	a.Month_7__c 					= a.Month_8__c;
	 	a.Month_8__c 					= a.Month_9__c;
	 	a.Month_9__c 					= a.Month_10__c;
	 	a.Month_10__c 					= a.Month_11__c;
	 	a.Month_11__c 					= a.Month_12__c;
	 	a.Month_12__c 					= a.Month_13__c;
	 	a.Month_13__c 					= a.Month_14__c;
	 	a.Month_14__c 					= a.Month_15__c;
	 	a.Month_15__c 					= a.Month_16__c;
	 	a.Month_16__c 					= a.Month_17__c;
	 	a.Month_17__c 					= 0;
	 	a.Bookings_Previous_Month_6__c 	= a.Bookings_Previous_Month_5__c;
	 	a.Bookings_Previous_Month_5__c 	= a.Bookings_Previous_Month_4__c;
	 	a.Bookings_Previous_Month_4__c 	= a.Bookings_Previous_Month_3__c;
	 	a.Bookings_Previous_Month_3__c 	= a.Bookings_Previous_Month_2__c;
	 	a.Bookings_Previous_Month_2__c 	= a.Bookings_Previous_Month_1__c;
	 	a.Bookings_Previous_Month_1__c 	= a.Bookings_Month_0__c;
	 	a.Bookings_Month_0__c 			= a.Bookings_Month_1__c;
	 	a.Bookings_Month_1__c 			= a.Bookings_Month_2__c;
	 	a.Bookings_Month_2__c 			= a.Bookings_Month_3__c;
	 	a.Bookings_Month_3__c 			= a.Bookings_Month_4__c;
	 	a.Bookings_Month_4__c 			= a.Bookings_Month_5__c;
	 	a.Bookings_Month_5__c 			= a.Bookings_Month_6__c;
	 	a.Bookings_Month_6__c 			= a.Bookings_Month_7__c;
	 	a.Bookings_Month_7__c 			= a.Bookings_Month_8__c;
	 	a.Bookings_Month_8__c 			= a.Bookings_Month_9__c;
	 	a.Bookings_Month_9__c 			= a.Bookings_Month_10__c;
	 	a.Bookings_Month_10__c 			= a.Bookings_Month_11__c;
	 	a.Bookings_Month_11__c 			= a.Bookings_Month_12__c;
	 	a.Bookings_Month_12__c 			= a.Bookings_Month_13__c;
	 	a.Bookings_Month_13__c 			= a.Bookings_Month_14__c;
	 	a.Bookings_Month_14__c 			= a.Bookings_Month_15__c;
	 	a.Bookings_Month_15__c 			= a.Bookings_Month_16__c;
	 	a.Bookings_Month_16__c		 	= a.Bookings_Month_17__c;
	 	a.Bookings_Month_17__c 			= 0; 
	 	ovf.add(a);
	 	}
	 	if (Objectname == 'Account_Forecast__c'){
	 	
	 		Account_Forecast__c a 			= (Account_Forecast__c)s;
	 	
	 	a.Previous_Month_6__c 			= a.Previous_Month_5__c;
	 	a.Previous_Month_5__c 			= a.Previous_Month_4__c;
	 	a.Previous_Month_4__c 			= a.Previous_Month_3__c;
	 	a.Previous_Month_3__c 			= a.Previous_Month_2__c;
	 	a.Previous_Month_2__c 			= a.Previous_Month_1__c;
	 	a.Previous_Month_1__c 			= a.Month_0__c;
	 	a.Month_0__c 					= a.Month_1__c;
		a.Month_1__c 					= a.Month_2__c;
	 	a.Month_2__c 					= a.Month_3__c;
	 	a.Month_3__c 					= a.Month_4__c;
	 	a.Month_4__c 					= a.Month_5__c;
	 	a.Month_5__c 					= a.Month_6__c;
	 	a.Month_6__c 					= a.Month_7__c;
	 	a.Month_7__c 					= a.Month_8__c;
	 	a.Month_8__c 					= a.Month_9__c;
	 	a.Month_9__c 					= a.Month_10__c;
	 	a.Month_10__c 					= a.Month_11__c;
	 	a.Month_11__c 					= a.Month_12__c;
	 	a.Month_12__c 					= a.Month_13__c;
	 	a.Month_13__c 					= a.Month_14__c;
	 	a.Month_14__c 					= a.Month_15__c;
	 	a.Month_15__c 					= a.Month_16__c;
	 	a.Month_16__c 					= a.Month_17__c;
	 	a.Month_17__c 					= 0;
	 	af.add(a);
	 	}
	 }
	 if (!af.isEmpty()){
		update af;
	 }
	 if (!ovf.isEmpty()){
	 	update ovf;
	 }
}

global void finish(Database.BatchableContext BC){
/*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

mail.setToAddresses(new String[] {email});
mail.setReplyTo('TESalesSystems@te.com');
mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed');
mail.setPlainTextBody('Batch Process has completed');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */
}            

}