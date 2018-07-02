global class ClsBatch_recalculateOppyProgram implements Database.Batchable<SObject>,Database.Stateful{
	global string SUCCESS;
    global string ERROR;
    global integer errorNum;
	public String query;
	public list<string> list_emails;
	
	global ClsBatch_recalculateOppyProgram(){
		errorNum = 0;
		if(list_emails == null){
			list_emails = new list<string>();
			for(Batch_Result_To_Emails__c brte : Batch_Result_To_Emails__c.getAll().values()){
				list_emails.add(brte.Name);
			}
		}
		
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		query = 'select id, Amount, Five_Year_Value__c, Total_Opportunity_Value__c, '
						+'Five_Year_Revenue__c, CurrencyIsoCode from Opportunity '
						+'where RecordType.Developername=\'Program\'';
		return Database.getQueryLocator(query);
	}
	global void execute(Database.BatchableContext BC, list<Opportunity> list_oppy){   
		List<Opportunity> list_program2Update = new List<Opportunity>();
        Map<Id, Set<Opportunity>> map_programId_oppys = new Map<Id, Set<Opportunity>>();
        Map<Id, Opportunity> map_programId_program = new Map<Id, Opportunity>();
        for(Opportunity oppy : list_oppy){
        	map_programId_program.put(oppy.Id, oppy);
        }
        for(Opportunity oppy : [select id, Program__c, Amount, Five_Year_Value__c, Total_Opportunity_Value__c, Five_Year_Revenue__c, CurrencyIsoCode from Opportunity where Program__c != null and Program__c IN :map_programId_program.keySet()]){
        	if(!map_programId_oppys.containsKey(oppy.Program__c)) map_programId_oppys.put(oppy.Program__c, new Set<Opportunity>());
            map_programId_oppys.get(oppy.Program__c).add(oppy);
        }
        for(Opportunity program :list_oppy){
            if(map_programId_oppys.containsKey(program.id) && map_programId_oppys.get(program.id).size() > 0) {
                ClsOppyUtil.updateProgramTotalFiveYearsAmount(program, map_programId_oppys.get(program.id));
                list_program2Update.add(program);
            }
        }            
        // update program
        if(list_program2Update.size() > 0) {
        	Database.SaveResult[] srList = Database.update(list_program2Update, false);

			for (integer i = 0; i < srList.size(); i++) {
			    if (srList.get(i).isSuccess()) {
			        // Operation was successful, so get the ID of the record that was processed
			        if(SUCCESS == null) {
	                    SUCCESS = 'Successfully Calculated Programs. Opportunity ID: <br/>';
	                }
	                SUCCESS += srList.get(i).getId() + '<br/>';
			    }
			    else {
			        // Operation failed, so get all errors     
			        if(ERROR == null) {
	                    ERROR = 'The following Programs has calculated failing: <br/>';
	                }      
	                errorNum ++;
	                ERROR += list_program2Update.get(i).Id + ': ';     
			        for(Database.Error err : srList.get(i).getErrors()) {    
			             ERROR += err.getStatusCode() + ': ' + err.getMessage() + '<br/>';
			        }
			    }
			}         
        }
        
	}
	global void finish(Database.BatchableContext BC){   
		if(UserInfo.getUserId() != null && (ERROR != null || SUCCESS != null) ){
        	if(ERROR == null) {
                ERROR = '';   
            }
            if(SUCCESS == null) {
                SUCCESS = '';
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());
            if(list_emails.size() > 0){
            	mail.setToAddresses(list_emails);
            }
            mail.setSubject('Recalculating all Programs are completed.');
            system.debug('**@@ ERROR = ' + ERROR);
            string htmlContent = SUCCESS + '<br/><br/> We got the error is ' + errorNum + ':<br/>' + ERROR;
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            if(htmlContent != null){
			    attach.setContentType('application/pdf');
			    attach.setFileName('RecalculateOpportunitiesRevenueResult.pdf');
			    attach.setInline(false);
			    attach.Body = Blob.toPDF(htmlContent);
			    htmlContent = 'Please find in attachment the recalculate result:';
            }
	            	            
            string htmlBody = htmlContent;
            mail.setHtmlBody(htmlBody);
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC           
            if(attach.Body != null){
            	mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            }
            if(!test.isRunningTest()){
            	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            /*
            string htmlBody = SUCCESS + '<br/><br/> We got the error is ' + errorNum + ':<br/>' + ERROR;
            EmailTemplate p;
            for(EmailTemplate temp : [select BrandTemplateId, Name, Id, IsActive, Body, TemplateType, FolderId, TemplateStyle, HtmlValue, DeveloperName from EmailTemplate where DeveloperName = 'Recalculate_Opportunity_Revenue']) {
            	p=temp;
            }
            if(p == null) {
            	p = new EmailTemplate();
            	p.Name = 'Recalculate Opportunity Revenue';
	            p.TemplateType='html';
	            p.FolderId = '00lE0000000u2yEIAQ';
	            p.TemplateStyle = 'freeForm';
	            p.DeveloperName = 'Recalculate_Opportunity_Revenue';
	            p.BrandTemplateId = '016E0000000Y1UcIAK';
	            p.IsActive = true;
	            p.Subject = 'Recalculate Opportunity Revenue';
	            insert p;
            }
            p.Body = htmlBody;
            update p;
            
            list<Id> list_userIds = new list<Id>();
            list_userIds.add(UserInfo.getUserId());
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(list_userIds);
            //mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com'});
            //mail.setSubject('Recalculating all opportunities revenue are completed.');
            system.debug('**@@ ERROR = ' + ERROR);
            
            mail.setTemplateId(p.Id);
            mail.setDescription('Recalculating all opportunities revenue are completed.');
            //mail.setHtmlBody(htmlBody);
            
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC           
            if(!test.isRunningTest()){
            	Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
            }*/
        }
	}
}