/**
 *  This class is used to copy contact role to custom Opportunity Contact role..
 *  
 * @author Jinbo Shan
 * @created 2014-06-24
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-06-24 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_copyStandardContactRoleToCustom implements Database.Batchable<SObject>,Database.Stateful {
	
	
	global string filter = '';
	global String ERROR4CustomConRole;
	global String ERROR4KeyPlayer;
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		string query = 'SELECT ContactId, Id, OpportunityId, IsPrimary, Role ' 
						+ 'FROM OpportunityContactRole ' 
						+ 'where ContactId != null and Role != null';
		if(filter != '') {
			query = query + filter;
		}
		return Database.getQueryLocator(query); 
	}
	
	global void execute(Database.BatchableContext BC, list<OpportunityContactRole> scope) {
		
		list<Key_Player__c> list_kps = new list<Key_Player__c>();
		list<Custom_Opportunity_Contact_Role__c> list_cconRoles = new list<Custom_Opportunity_Contact_Role__c>();
		map<Id, OpportunityContactRole> map_conRoleId_conRole = new map<Id, OpportunityContactRole>();
		map<Id, set<Key_Player__c>> map_conRoleId_set_kps = new map<Id, set<Key_Player__c>>();
		
		for(OpportunityContactRole conRole : scope) {
			map_conRoleId_conRole.put(conRole.Id, conRole);
		}
		
		for(Key_Player__c kp : [SELECT Id, Contact_Role_Id__c, 	Custom_Opportunity_Contact_Role__c FROM Key_Player__c WHERE Contact_Role_Id__c IN : map_conRoleId_conRole.keySet()]) {
			if(!map_conRoleId_set_kps.containsKey(kp.Contact_Role_Id__c)) {
				map_conRoleId_set_kps.put(kp.Contact_Role_Id__c, new set<Key_Player__c>());
			}
			map_conRoleId_set_kps.get(kp.Contact_Role_Id__c).add(kp);
		}
		
		for(Id conRoleId : map_conRoleId_conRole.keySet()) {
			if(map_conRoleId_set_kps.containsKey(conRoleId)) {
				Custom_Opportunity_Contact_Role__c cconRole = new Custom_Opportunity_Contact_Role__c();
				cconRole.Contact__c = map_conRoleId_conRole.get(conRoleId).ContactId;
				cconRole.Opportunity__c = map_conRoleId_conRole.get(conRoleId).OpportunityId;
				cconRole.Primary__c = map_conRoleId_conRole.get(conRoleId).IsPrimary;
				cconRole.Role__c = map_conRoleId_conRole.get(conRoleId).Role;
				cconRole.Focus_Point__c = 'Focus of Dissatisfaction (FOD);Focus of Power (FOP)';
				list_cconRoles.add(cconRole);
				for(Key_Player__c kp : map_conRoleId_set_kps.get(conRoleId)) {
					kp.Custom_Opportunity_Contact_Role__c = cconRole.Id;
					list_kps.add(kp);
				}
			} else {
				Custom_Opportunity_Contact_Role__c cconRole = new Custom_Opportunity_Contact_Role__c();
				cconRole.Contact__c = map_conRoleId_conRole.get(conRoleId).ContactId;
				cconRole.Opportunity__c = map_conRoleId_conRole.get(conRoleId).OpportunityId;
				cconRole.Primary__c = map_conRoleId_conRole.get(conRoleId).IsPrimary;
				cconRole.Role__c = map_conRoleId_conRole.get(conRoleId).Role;
				list_cconRoles.add(cconRole);
			}
		}
		if(list_cconRoles.size() > 0) {
			List<Database.SaveResult> srList = database.insert(list_cconRoles, false);
			for (integer i = 0; i < srList.size(); i++) {
				if (!srList.get(i).isSuccess()) {
					if(ERROR4CustomConRole == null) {
			    		ERROR4CustomConRole = 'The following errors have occured when insert custom opportunity contact role: </br>';
			    	}
			    	ERROR4CustomConRole += 'Opportunity Id is: ' + list_cconRoles.get(i).Opportunity__c + ': ';
			    	for(Database.Error err : srList.get(i).getErrors()) {                  
			            ERROR4CustomConRole += err.getStatusCode() + ': ' + err.getMessage() + '</br>';
			            //System.debug('Account fields that affected this error: ' + err.getFields());
			        }
				}
			}
		}
		
		if(list_kps.size() > 0) {
			List<Database.SaveResult> srList = database.update(list_kps, false);
			for (integer i = 0; i < srList.size(); i++) {
				if (!srList.get(i).isSuccess()) {
					if(ERROR4KeyPlayer == null) {
			    		ERROR4KeyPlayer = 'The following errors have occured when update key player: </br>';
			    	}
			    	ERROR4KeyPlayer += list_kps.get(i).Id + ': ';
			    	for(Database.Error err : srList.get(i).getErrors()) {                  
			            ERROR4KeyPlayer += err.getStatusCode() + ': ' + err.getMessage() + '</br>';
			            //System.debug('Account fields that affected this error: ' + err.getFields());
			        }
				}
			}
		}
		
	}
	
	global void finish(Database.BatchableContext BC) { 
		if(!test.isRunningTest()) {
			if(UserInfo.getUserId() != null && (ERROR4KeyPlayer != null || ERROR4CustomConRole != null)){
				if(ERROR4KeyPlayer == null) {
					ERROR4KeyPlayer = '';
				}
				if(ERROR4CustomConRole == null) {
					ERROR4CustomConRole = '';
				}
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	            mail.setTargetObjectId(UserInfo.getUserId());
	            mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com', 'bin.yu@itbconsult.com'});
	            mail.setSubject('Copy OpportunityContactRole to custom opportunity contact role that is completed.');
				
	            string htmlBody = ERROR4KeyPlayer + '</br></br>' + ERROR4CustomConRole;
	            mail.setHtmlBody(htmlBody);
	            
	            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
	            mail.setUseSignature(false); //Sender Signature from SFDC           
	            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			}
		}
	}
}