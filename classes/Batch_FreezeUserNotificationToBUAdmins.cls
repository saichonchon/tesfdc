/***********************************************************************************************************************
      Name : Batch_FreezeUserNotificationToBUAdmins
       Org : C2S
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
   Summary : A batch class which will Freeze the users who are leaving TE and their TE Internal Contact  is InActive
             It will send an email notification with Freeze User details to respective BU Admins based on user GIBU picklist value
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR             DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Subba Vanipenta   09/18/2015 Initial Development                        
***********************************************************************************************************************/

global  class Batch_FreezeUserNotificationToBUAdmins implements Database.Batchable<SObject>, Database.Stateful { 
    
    global map<Id, User> vStandardUsersMapToFreeze = new map<Id, User>();
    global map<string, set<User>> vBUUsersMap = new map<string, set<User>>();
    global string query;
    global Database.QueryLocator start(Database.BatchableContext BC){
    	Integer lastNdays = integer.valueOf(OrgWideSettings__c.getInstance('Default').Last_Login_N_Days_To_Freeze_Users__c);
    	if(lastNdays == Null){
    		lastNdays = 10;
    	}
    	system.debug('******* lastNdays:'+lastNdays);
        if (query == '' || query == null){
        	query = 'Select u.Username, FederationIdentifier, u.Salesforce_ID__c, u.Region__c, u.Name, u.LastName, u.LastLoginDate, u.IsActive, u.Id, u.GIBU__c, u.FirstName, u.Email, u.UserType From User u '
                        + 'where UserType=\''+ 'Standard'+  '\''  
                        + 'and IsActive=True  and u.LastLoginDate < LAST_N_DAYS:'+lastNdays;
            //query += ' Limit 150';
        }
        system.debug('**** query:'+query);        
        return Database.getQueryLocator(query);     
    }
    
   global void execute(Database.BatchableContext BC, list<User> vUserList){
    	map<String,User> vStandardActiveUsersMap = new map<String,User>(); 
    	set<User> vUserSet;   	
    	for(USer vUser: vUserList){
    		if(!vStandardActiveUsersMap.containsKey(vUser.FederationIdentifier)){    			
    				vStandardActiveUsersMap.put(vUser.FederationIdentifier, vUser);
    		}
    	}
    	system.debug('*********** vStandardActiveUsersMap :'+vStandardActiveUsersMap);
    	list<Contact> vInactiveInternalContactList = [Select id, email, recordtype.name, name from contact 
    												 where Inactive__c = true and 
    												 recordtype.name ='TE Internal Contact' and 
    												 email in:vStandardActiveUsersMap.keyset()
    												 ];
    	system.debug('*********** vInactiveInternalContactList :'+vInactiveInternalContactList);
    	for(Contact vInactiveContact : vInactiveInternalContactList){  
    		if(vStandardActiveUsersMap.containsKey(vInactiveContact.email) )  {  
    			vStandardUsersMapToFreeze.put(vStandardActiveUsersMap.get(vInactiveContact.email).id, vStandardActiveUsersMap.get(vInactiveContact.email) );
    			if(vBUUsersMap.containsKey(vStandardActiveUsersMap.get(vInactiveContact.email).GIBU__c)){
    				vBUUsersMap.get(vStandardActiveUsersMap.get(vInactiveContact.email).GIBU__c).add(vStandardActiveUsersMap.get(vInactiveContact.email));
	    		}else {
	    			vBUUsersMap.put(vStandardActiveUsersMap.get(vInactiveContact.email).GIBU__c, new set<User>{vStandardActiveUsersMap.get(vInactiveContact.email)});	
	    		}
    		}
    	}
    	//system.debug('****** vFreezeUsersCustomSettings: '+vFreezeUsersCustomSettings);
    	system.debug('********** vStandardUsersMapToFreeze :'+vStandardUsersMapToFreeze);
    	list<UserLogin> vStandardUsersLoginToFreeze = [SELECT Id, UserId, IsFrozen FROM UserLogin
												 WHERE IsFrozen = false and
												 UserId in : vStandardUsersMapToFreeze.keyset()
												];
		system.debug('*********** vStandardUsersLoginToFreeze :'+vStandardUsersLoginToFreeze);
		
	    for (UserLogin vUserlogin :vStandardUsersLoginToFreeze){
	    	vUserlogin.isFrozen = true;
	    }
	    system.debug('*********** vStandardUsersLoginToFreeze update :'+vStandardUsersLoginToFreeze);
	    database.update(vStandardUsersLoginToFreeze);
    }   
  
    global void finish(Database.BatchableContext info) {
        map<string, FreezeUserNotificationToBUAdmins__c> vFreezeUsersCustomSettings = FreezeUserNotificationToBUAdmins__c.getAll();
        map<string,User> vBUUserEmailMap = new map<string,User>();
        set<string> vSetOfEmails = new set<String>();
        for(FreezeUserNotificationToBUAdmins__c vCustomSetting: vFreezeUsersCustomSettings.values()){
            vSetOfEmails.add(vCustomSetting.BU_Admin_User_Emails__c);
        }
        For(User vUser: [Select Id, name, Email from user where email in : vSetOfEmails]){
            vBUUserEmailMap.put(vUser.email,vUser);
        }
    	list<User> vUserList;
    	string BUAdminUserEmails;
    	string[] vToAddresses;
        list<Id> vUserIdList;
        Messaging.SingleEmailMessage[] arraymails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage vSingleEmail;
    	system.debug('****** vBUUsersMap.keyset():'+vBUUsersMap.keyset());
    	system.debug(' ****** vFreezeUsersCustomSettings.keyset(): '+vFreezeUsersCustomSettings.keyset());
    	for(string vBusinessUnit : vBUUsersMap.keyset()){
    		Messaging.reserveSingleEmailCapacity(1);               
            if(vFreezeUsersCustomSettings.containskey(vBusinessUnit)){
            	BUAdminUserEmails = vFreezeUsersCustomSettings.get(vBusinessUnit).BU_Admin_User_Emails__c;
            }else{
            	BUAdminUserEmails = vFreezeUsersCustomSettings.get('Other BU Admins').BU_Admin_User_Emails__c;
            }
            vToAddresses = BUAdminUserEmails.split(',');
            vUserIdList = new list<Id>();
            for(String vEmail :vToAddresses){                
				vSingleEmail = new Messaging.SingleEmailMessage();
                system.debug('*******  vBUUserEmailMap.get(vEmail) :'+vBUUserEmailMap.get(vEmail));
                if(vBUUserEmailMap.get(vEmail) !=Null){
                    system.debug('****** email id:'+vBUUserEmailMap.get(vEmail).id );
                    vSingleEmail.setTargetObjectId(vBUUserEmailMap.get(vEmail).id);
                    vSingleEmail.setSaveAsActivity(false);
                    vSingleEmail.setSubject('C2S Org '+vBusinessUnit + ' Business Unit Frozen Users' );
                    vUserList = new list<User>(vBUUsersMap.get(vBusinessUnit));
                    if(vUserList != Null && vUserList.size()>0){
                        vSingleEmail.setHtmlBody(getTableEmailBody(vUserList,vBusinessUnit, vBUUserEmailMap.get(vEmail).Name));
                    }
                    else{continue;} // When there are no users to freeze, it will not send an email notification to BU Admins
                    if(vSingleEmail !=Null){
                        arraymails.add(vSingleEmail);    
                    }
                }
			}
        }
    	
           // Query the AsyncApexJob object to retrieve the current job's information. 
            if(!Test.isRunningTest()){
               AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =: info.getJobId()];
               // Send an email to the Apex job's submitter notifying of job completion. 
               vSingleEmail = new Messaging.SingleEmailMessage();               
               vSingleEmail.setToAddresses(new string[]{'crmsupport@te.com'});               
               vSingleEmail.setSubject('FreezeUserNotification Batch Job' + a.Status);
               vSingleEmail.setPlainTextBody('FreezeUser who leaving Te Batch Job Status:  Total ' + a.TotalJobItems + '  batches with '+ a.NumberOfErrors + ' failures.');
               arraymails.add(vSingleEmail);
           }
        if(arraymails != Null && arraymails.size()>0){
           Messaging.sendEmail(arraymails); 
        }
    } 
    
    global string getTableEmailBody(list<User> pUserLst, string pBusinessUnit, string pBusinessUnitAdmin){
		String htmlBody = '';
		//open table..
	    htmlBody = '<p>' +
	    				'Dear '+pBusinessUnitAdmin+',' +'<br/><br/>' +
	    				'The The following  '+pBusinessUnit+' Users seems to have left TE. The users account were frozen for security purposes. ' +
						'Please re-assign any opportunities, contacts etc. that may still be associated to these users account and deactivate at your earliest convenience. '+ '<br/>' +'<br/>' +
						'Thank you! ' +						
	               '</p>'+ '<br/>'+'<br/>'+
	    
	         		'<table border="1" width ="800" style="border-collapse: collapse">'+   			
	    				'<tr>'+
	    					'<th>Name</th>'+
	    					'<th>Email</th>'+
	    					'<th>Region   </th>'+
	                		'<th>Last Login Date   </th>'+
	                	'</tr>';
	
	    //iterate over list and output columns/data into table rows...
	    for(User vUser : pUserLst){
			htmlBody += '<tr>'+
	        				'<td>' + vUser.Name +'</td>'+
	        				'<td>' + vUser.email +'</td>'+
	        				'<td   >'+ vUser.Region__c +' </td>'+
	        				'<td   >'+ vUser.LastLoginDate +'</td>'+
	        			'</tr>';
	
	    }
	
	    //close table...
	    htmlBody += '</table>';
		system.debug('Email Body: ' + htmlBody);   
	  return htmlBody;
	}
}