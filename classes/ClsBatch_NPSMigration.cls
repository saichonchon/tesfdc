/** 
*    batch class to migrate NPS answers
*
@author Xia Tong
@created 2013-01-14 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-01-14 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/

global class ClsBatch_NPSMigration implements Database.Batchable<SObject>{
	private static final String query = 'SELECT Answer_01__c, Answer_02__c, Answer_03__c, Answer_04__c, Answer_05__c,' 
									  + 'Answer_06__c, Answer_07__c, Answer_08__c, Answer_09__c, Answer_10__c, Answer_11__c,' 
									  + 'Answer_12__c, Answer_13__c, Answer_14__c, Campaign__c, Contact__c, Current__c, Appliance__c, Not_Applicable_02__c,' 
									  + 'Not_Applicable_03__c, Not_Applicable_04__c, Not_Applicable_06__c, Not_Applicable_07__c, '
									  + 'Not_Applicable_08__c, Not_Applicable_10__c, Not_Applicable_11__c, Not_Applicable_12__c, '
									  + 'Question_01__c, Question_02__c, Question_03__c, Question_04__c, Question_05__c, Question_06__c,' 
									  + 'Question_07__c, Question_08__c, Question_09__c, Question_10__c, Question_11__c, Question_12__c, '
									  + 'Question_13__c, Question_14__c,  Id FROM NPS_Migration__c ';
	
	global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext BC, list<NPS_Migration__c> scope){
    	list<Answer__c> list_answer2Insert = new list<Answer__c>();
    	for(NPS_Migration__c nm: scope){
    		Sobject so = (Sobject)nm;
    		for(Integer i=1; i<=14; i++){
    			Answer__c a = new Answer__c();
    			String numStr;
    			if(i < 10) numStr = '0' + i;
    			else numStr = String.valueOf(i);
    			String qField = 'Question_' + numStr + '__c';
    			String aField = 'Answer_' + numStr + '__c';
    			String nField = 'Not_Applicable_' + numStr + '__c';
    			
    			a.Campaign__c = (Id)so.get('Campaign__c');
    			a.Contact__c = 	(Id)so.get('Contact__c');
    			a.Current__c = (boolean)so.get('Current__c');
    			a.Appliance__c = (boolean)so.get('Appliance__c');
    			a.Question__c = (Id)so.get(qField);
    			if((i >= 1 && i <= 4) || (i >= 6 && i <= 8) || (i >= 10 && i <= 12)){
    				if(so.get(aField) != null){
    					a.Answer__c = String.valueOf((decimal)so.get(aField));
    				}else{
    					a.Not_Applicable__c = true;
    				}
    			}else{
    				a.Answer_txt__c = (String)so.get(aField);
    			}
    			list_answer2Insert.add(a);
    		}
    	
    	} 
    	
    	if(!list_answer2Insert.isEmpty()) insert list_answer2Insert;	   
    }
    global void finish(Database.BatchableContext BC){ 
    
    }
}