/**
 *  Send email alert
 *
 @  author Nelson Zheng
 @  created 2015-02-02
 @  version 1.0
 @  since 31.0 (Force.com ApiVersion)
 *
 @  changelog
 *  2015-02-02 Nelson Zheng
 *  - Created
 */
global class ClsSchedule_ConvertedOppPartEmailAlert implements Schedulable{
	
	global void execute(SchedulableContext sc) {
	  
		//a list to hold opportunity part for update
		List<Opportunity_part__c> oppPartList = new List<Opportunity_part__c>();
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
		EmailTemplate emailTemplate = [Select e.Id, e.HtmlValue, e.Body,e.Subject,e.BrandTemplateId From EmailTemplate e where e.name = 'APL-Converted Opportunity Part'];
		String initialemailTemplate = emailTemplate.HtmlValue;
		initialemailTemplate = initialemailTemplate.replace('<![CDATA[','');
		initialemailTemplate = initialemailTemplate.replace(']]>','');
		initialemailTemplate = letterHead+initialemailTemplate+letterBottom;
		//query the opportunity which record's Converted_Email_Alert_Date__c is yesterday
		List<Opportunity> opportunityList = [Select o.Owner.name,o.Won_Date__c,o.Owner.ManagerId,o.Owner.Manager.email, o.Opportunity_Number__c, o.Name, o.Id, 
											o.Account.Name,o.Account.Account_Manager_Name__c,o.Account.Owner.name,o.Account.Owner.Email,o.Account.Owner.ManagerId,o.Account.Owner.Manager.email,o.AccountId, 
												(Select Current_Year__c,Won_Date__c, Current_Year_add_1__c,Part_Number__c 
												From Parts__r where Won_Date__c = LAST_N_DAYS:2 and already_sent_convert_email__c = false)
											From Opportunity o where o.Converted_Email_Alert_Date__c =: System.today() -1];
		
		for(Opportunity o : opportunityList){
			
			if(o.Parts__r.size() > 0){
				
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String htmlBody = initialemailTemplate;//initialise
				
				String[] toAddresses = new String[]{};
				if(o.Owner.ManagerId != null){
					toAddresses.add(o.Owner.Manager.email);
				}
				
				if(o.Account.Owner.ManagerId != null && o.Owner.Manager.email != o.Account.Owner.Manager.email){
					toAddresses.add(o.Account.Owner.Manager.email);
				}
				htmlBody = htmlBody.replace('#won date#',(o.Parts__r[0].Won_Date__c+'').replace(' 00:00:00',''));
				htmlBody = htmlBody.replace('#Opportunity Owner#',o.Owner.name);
				htmlBody = htmlBody.replace('#Opportunity Number#',o.Opportunity_Number__c);
				htmlBody = htmlBody.replace('#Opportunity Name#',o.Name);
				htmlBody = htmlBody.replace('#Account Name#',o.Account.Name);
				if(o.Account.Account_Manager_Name__c == null || o.Account.Account_Manager_Name__c == 'TEIS Admin'){
					htmlBody = htmlBody.replace('#Account Manager Name#',o.Account.Owner.name);
				}else{
					htmlBody = htmlBody.replace('#Account Manager Name#',o.Account.Account_Manager_Name__c);
					toAddresses.add(o.Account.Owner.Email);
				}
				htmlBody = htmlBody.replace('https://#####',headAndFoot[4]+o.Id);
				htmlBody = htmlBody.replace('https://###AccountId###',headAndFoot[4]+o.AccountId);
				//input the opportunity part info
				String[] bodySplit = htmlBody.split('####Add opportunity part information#####');
				String oppPartInfo = '';
				for(Opportunity_part__c oppPart : o.Parts__r){
					String partInfoTemp = bodySplit[1];//initialize
					partInfoTemp = partInfoTemp.replace('#Opportunity Part#',oppPart.Part_Number__c);
					partInfoTemp = partInfoTemp.replace('#Current Year#',String.valueOf(oppPart.Current_Year__c.setScale(2)));
					partInfoTemp = partInfoTemp.replace('#Current Year+1#',String.valueOf(oppPart.Current_Year_add_1__c.setScale(2)));
					oppPartInfo += partInfoTemp + '<br/>';
					//change already_sent_convert_email__c to true to avoid to be sent again.
					oppPart.already_sent_convert_email__c = true;
					oppPartList.add(oppPart);
				}
				//remove the last <br/>
				oppPartInfo = oppPartInfo.substring(0,oppPartInfo.lastIndexOf('<br/>'));
				
				mail.setToAddresses(toAddresses);
				mail.setSubject(emailTemplate.Subject);
				mail.setHtmlBody(bodySplit[0]+oppPartInfo+bodySplit[2]);
				mail.setSenderDisplayName(o.Owner.name);
				singleEmailList.add(mail);
			}
		}
		//send email
		try{
			Messaging.sendEmail(singleEmailList);
			//update opportunity part
			update oppPartList;
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