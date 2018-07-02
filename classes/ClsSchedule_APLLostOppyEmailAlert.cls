/**
 *  Send email alert for lost business-Appliances
 *
 @  author Nelson Zheng
 @  created 2015-08-11
 @  version 1.0
 @  since 31.0 (Force.com ApiVersion)
 *
 @  changelog
 *  2015-08-11 Nelson Zheng
 *  - Created
 */
global class ClsSchedule_APLLostOppyEmailAlert implements Schedulable{
	global void execute(SchedulableContext sc) {
		
		List<Opportunity> opportunityList = [Select o.Owner.name,o.Won_Date__c,o.Owner.ManagerId,o.Owner.Manager.email, o.Opportunity_Number__c, o.Name, o.Id, o.APL_Billing_Receive_Region__c,
												o.Account.Name,o.Account.Account_Manager_Name__c,o.Account.Owner.name,o.Account.Owner.Email,o.Account.Owner.ManagerId,o.Account.Owner.Manager.email,o.AccountId, 
												o.first_fiscal_year_lost__c,o.second_fiscal_year_lost__c	
												From Opportunity o where o.APL_Billing_Receive_Region__c != null and RecordTypeId =: Apex_Helper_Settings__c.getInstance('Lost Business - Appliances').Value__c
												and Need_Send_Lost_Mail__c = true and Existing_Business_Lost_Reason__c = 'Migration - sales moved to other region'];//
	
    	//a list to hold the final email
		List<Messaging.SingleEmailMessage> singleEmailList = new List<Messaging.SingleEmailMessage>();
    	//get the header and footer pic
		Apex_Helper_Settings__c helperSettings = Apex_Helper_Settings__c.getInstance('APL_Email_Alert_Template');
		String[] headAndFoot = helperSettings.value__c.split(';');
		String letterHead = '<table id="topTable" height="450" width="500" cellpadding="0" cellspacing="0" ><tr valign="top" ><td  style=" vertical-align:middle; height:80; text-align:left; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;"><img id="r1sp1" bLabel="headerImage" border="0" bEditID="r1sp1" src="#head#" ></img></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF9900; bLabel:accent1; bEditID:r2st1;"></td></tr></table>';
		letterHead = letterHead.replace('#head#',headAndFoot[0]+headAndFoot[1]+headAndFoot[3]);
		String letterBottom = '<table><tr valign="top" ><td  style=" height:5; background-color:#FF9900; bLabel:accent2; bEditID:r4st1;"></td></tr><tr valign="top" ><td  style=" vertical-align:top; height:30; text-align:left; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;"><img id="r5sp1" bLabel="footerImage" border="0" bEditID="r5sp1" src="#foot#" ></img></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF9900; bLabel:accent3; bEditID:r6st1;"></td></tr></table>';
		letterBottom = letterBottom.replace('#foot#',headAndFoot[0]+headAndFoot[2]+headAndFoot[3]);
		//query the email template
		EmailTemplate emailTemplate = [Select e.Id, e.HtmlValue, e.Body,e.Subject,e.BrandTemplateId From EmailTemplate e where e.name = 'APL-Lost Opportunity'];
		String initialemailTemplate = emailTemplate.HtmlValue;
		initialemailTemplate = initialemailTemplate.replace('<![CDATA[','');
		initialemailTemplate = initialemailTemplate.replace(']]>','');
		initialemailTemplate = letterHead+initialemailTemplate+letterBottom;
		
		List<User> aplRegionSalesManagerList = [select Id,Email,APL_Sales_manager_Region__c from User where APL_Sales_manager_Region__c != null];
		Map<String,Set<Id>> aplRegionSalesManagerMap = new Map<String,Set<Id>>();
		for(User u : aplRegionSalesManagerList){
			Set<Id> emailSet = aplRegionSalesManagerMap.get(u.APL_Sales_manager_Region__c);
			if(emailSet == null){
				emailSet = new Set<Id>();
			}
			emailSet.add(u.Id);
			aplRegionSalesManagerMap.put(u.APL_Sales_manager_Region__c,emailSet);
		}
		for(Opportunity o : opportunityList){
			
			
			String htmlBody = initialemailTemplate;//initialise
				
			//String[] toAddresses = new String[]{};
			String[] receiveRegionList = o.APL_Billing_Receive_Region__c.split(';');
			Set<Id> emailTargetIdSet = new Set<Id>();
			for(String receiveRegion : receiveRegionList){
				Set<Id> emailSet = aplRegionSalesManagerMap.get(receiveRegion);
				if(emailSet != null){
					for(Id targerId : emailSet){
						emailTargetIdSet.add(targerId);
					}
				}
			}
				
			htmlBody = htmlBody.replace('#Opportunity Owner#',o.Owner.name);
			htmlBody = htmlBody.replace('#Opportunity Number#',o.Opportunity_Number__c);
			htmlBody = htmlBody.replace('#Opportunity Name#',o.Name);
			htmlBody = htmlBody.replace('#Account Name#',o.Account.Name);
			if(o.Account.Account_Manager_Name__c == null || o.Account.Account_Manager_Name__c == 'TEIS Admin'){
				htmlBody = htmlBody.replace('#Account Manager Name#',o.Account.Owner.name);
			}else{
				htmlBody = htmlBody.replace('#Account Manager Name#',o.Account.Account_Manager_Name__c);
			}
			htmlBody = htmlBody.replace('https://#####',headAndFoot[4]+o.Id);
			htmlBody = htmlBody.replace('https://###AccountId###',headAndFoot[4]+o.AccountId);
			htmlBody = htmlBody.replace('#first year#',o.first_fiscal_year_lost__c+'');
			htmlBody = htmlBody.replace('#second year#',o.second_fiscal_year_lost__c+'');
				
			for(Id target : emailTargetIdSet){
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				mail.setTargetObjectId(target);
				mail.setSubject(emailTemplate.Subject);
				mail.setHtmlBody(htmlBody);
				mail.setSenderDisplayName(o.Owner.name);
				mail.saveAsActivity = false;
				singleEmailList.add(mail);
			}
			o.Need_Send_Lost_Mail__c = false;
		}
		try{
			//send email
			Messaging.sendEmail(singleEmailList);
		
			update opportunityList;
		}catch(Exception e){
			
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setSubject('Converted Part Email send failed.');
			mail.setPlainTextBody('Exception: '+e);
			mail.setTargetObjectId(CSD_Exception_Email__c.getInstance('Exception User').User_Id__c);
			mail.saveAsActivity = false;
			Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
		}
	}
}