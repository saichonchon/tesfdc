/**
*  This trigger send detractor task reminder. This is fired every 7 day using time based workflow rule "Update Next reminder date"
* 
@author Pankaj Raijade
@created 6/24/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  83%
* 
* 
6/24/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
02/01/2016 Pankaj Raijade pankaj.raijade@zensar.in
* - Updated
*/
trigger TaskAU_SendDetractorTaskReminder on Task (after update) 
{
    list<task> lstTaskToUpdate = new list<task>();
    map<id, user> mapUsers = new map<id, user>();
    map<id, contact> mapcontact = new map<id, contact>();
    
    list<string> lstUserID = new list<string>();
    list<string> lstContact = new list<string>();
    
    for(task oTaskNew :trigger.new)
    {
        lstUserID.add(oTaskNew.ownerID);
        lstContact.add(oTaskNew.Whoid);
    }
    if(lstUserID.size() > 0)
        mapUsers = new map<id, user>([select id, email from user where id IN :lstUserID]);
        
    if(lstContact.size() > 0)
        mapcontact = new map<id, Contact>([select name, NPS_Survey_Wave_Number__c, account.Name from contact where id IN :lstContact]);

    list<Messaging.SingleEmailMessage> lstmail = new list<Messaging.SingleEmailMessage>();
    Schema.RecordTypeInfo TaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('EC Survey');
    Schema.RecordTypeInfo TaskRecordtypeNPS = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Task Industrial');
    Schema.RecordTypeInfo TaskRecordtypeNPSFunc = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Industrial Functional Follow Up Task');
    map<string, id> mapEmailTemplate = new map<string, id>();
    set<string> setemailTemplateName = new set<string>{'NPS - Detractor follow up overdue reminder', 'NPS - Passive follow up overdue reminder', 'NPS - Promoter follow up overdue reminder', 'NPS - Detractor follow up overdue reminder HP', 'NPS - Passive follow up overdue reminder HP', 'NPS - Promoter follow up overdue reminder HP', 'NPS - Detractor functional follow up overdue reminder', 'NPS - Passive functional follow up overdue reminder', 'NPS - Promoter functional follow up overdue reminder'};
    for(emailtemplate oET:[select id, name from emailtemplate where name IN :setemailTemplateName ])
        mapEmailTemplate.put(oET.Name, oET.Id);

    Time_frame_Setting__c HighPriotyTimeFrame = Time_frame_Setting__c.getValues('NPS_IND_Followup_HighPriority_Days');
    date dateSurveyStart;
    if(HighPriotyTimeFrame != null && HighPriotyTimeFrame.Period_Type__c != null && HighPriotyTimeFrame.Period__c != null)
    {
        if('YEAR'.equalsIgnoreCase(HighPriotyTimeFrame.Period_Type__c))
            dateSurveyStart = System.today().addYears((Integer)(-1 * HighPriotyTimeFrame.Period__c));
        if('MONTH'.equalsIgnoreCase(HighPriotyTimeFrame.Period_Type__c))
            dateSurveyStart = System.today().addMonths((Integer)(-1 * HighPriotyTimeFrame.Period__c));
        if('DAY'.equalsIgnoreCase(HighPriotyTimeFrame.Period_Type__c))
            dateSurveyStart = System.today().addDays((Integer)(-1 * HighPriotyTimeFrame.Period__c));
    }

    for(task oTaskNew :trigger.new)
    {
        Task oTaskOld = trigger.OldMap.get(oTaskNew.id);
        if( oTasknew.RecordtypeID == TaskRecordtype.getRecordTypeId() && oTasknew.subject == 'Detractor Assignment' && oTasknew.Next_reminder_date__c != oTaskOld.Next_reminder_date__c)// && oTasknew.ReminderDateTime.date() == date.today())
        {
            if(mapUsers.containsKey(oTaskNew.ownerID))
            {
                task oTaskNewToUpdate = oTasknew.clone(true, false);
                oTaskNewToUpdate.ReminderDateTime = datetime.now().addDays(1);
                lstTaskToUpdate.add(oTaskNewToUpdate);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                string strContactName = '';
                
                if(mapcontact.containsKey(oTaskNew.whoID))
                    strContactName = mapcontact.get(oTaskNew.whoID).Name + ', ' + mapcontact.get(oTaskNew.whoID).account.Name;
                mail.setTargetObjectId(mapUsers.get(oTaskNew.ownerID).Id);
                mail.orgWideEmailAddressId = '0D2E00000008RE1';
                mail.setSaveAsActivity(false);
                mail.setSubject('REMINDER – Detractor Task from EC Survey is Overdue for Completion');
                string strbody = 'This email is intended to alert you that you have a detractor task which is overdue for completion.';
                strbody += '\n\nThe task relates to a survey taken by ' + strContactName + ' which resulted in a detractor task being created.';
                strbody += '\n\nAccess to the survey response and task can be found in the SFDC link below.';
                strbody += '\n' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + oTasknew.Id;
                strbody += '\n\nPlease endeavour to make contact with the customer, summarize your discussions in the task comments and move to complete status as soon as possible.';
                strbody += '\n\nThank you,';
                strbody += '\nChannel Surveys Team';
                mail.setPlainTextBody(strbody);   
                lstmail.add(mail);
            }
        }
//Pankaj Raijade-1/2/2016-Detractor Follow Ups - Future State in SFDC-Start//
        if((oTasknew.RecordtypeID == TaskRecordtypeNPS.getRecordTypeId() || oTasknew.RecordtypeID == TaskRecordtypeNPSfunc.getRecordTypeId()) && oTasknew.Next_reminder_date__c != oTaskOld.Next_reminder_date__c)// && oTasknew.ReminderDateTime.date() == date.today())
        {
            if(mapUsers.containsKey(oTaskNew.ownerID))
            {
                boolean isHighPriority = false;
                if(mapcontact.containsKey(oTaskNew.Whoid))
                {
                    Decimal SurveyWaveNO = mapcontact.get(oTaskNew.Whoid).NPS_Survey_Wave_Number__c;
                    if(SurveyWaveNO != null)
                    {
                        Date dateNextsurveyDate = System.Date.newInstance(system.today().year(), (integer)SurveyWaveNO, 15);
                        if(dateNextsurveyDate < system.today())
                           dateNextsurveyDate.addYears(1);
                        if(dateNextsurveyDate > dateSurveyStart)
                            isHighPriority = true;
                    }
                }
                task oTaskNewToUpdate = oTasknew.clone(true, false);
                oTaskNewToUpdate.ReminderDateTime = datetime.now().addDays(1);
                lstTaskToUpdate.add(oTaskNewToUpdate);
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if(oTaskNew.subject == system.label.NPS_Detractor_GM_Follow_UP || oTaskNew.subject == system.label.NPS_Detractor_AM_Follow_UP)
                {
                    if(isHighPriority)
                        mail.templateid = mapEmailTemplate.get('NPS - Detractor follow up overdue reminder HP');
                    else
                        mail.templateid = mapEmailTemplate.get('NPS - Detractor follow up overdue reminder'); 
                }
                else if(oTaskNew.subject == system.label.NPS_Passive_Follow_UP)
                {
                    if(isHighPriority)
                        mail.templateid = mapEmailTemplate.get('NPS - Passive follow up overdue reminder HP');
                    else
                        mail.templateid = mapEmailTemplate.get('NPS - Passive follow up overdue reminder');
                }
                else if(oTaskNew.subject == system.label.NPS_Promoter_Follow_UP)
                {
                    if(isHighPriority)
                        mail.templateid = mapEmailTemplate.get('NPS - Promoter follow up overdue reminder HP');
                    else
                        mail.templateid = mapEmailTemplate.get('NPS - Promoter follow up overdue reminder');
                }
                
                if(oTaskNew.subject == system.label.NPS_Detractor_GM_Functional_Follow_UP || oTaskNew.subject == system.label.NPS_Detractor_AM_Functional_Follow_UP)
                    mail.templateid = mapEmailTemplate.get('NPS - Detractor functional follow up overdue reminder');
                else if(oTaskNew.subject == system.label.NPS_Passive_Functional_Follow_UP)
                    mail.templateid = mapEmailTemplate.get('NPS - Passive functional follow up overdue reminder');
                else if(oTaskNew.subject == system.label.NPS_Promoter_Functional_Follow_UP)
                    mail.templateid = mapEmailTemplate.get('NPS - Promoter functional follow up overdue reminder');
                   
                mail.setTargetObjectId(oTaskNew.ownerID);
                mail.orgWideEmailAddressId = '0D2E00000008RE1';
                mail.setwhatID(oTaskNew.id);
                mail.setSaveAsActivity(false);
                lstmail.add(mail);
            }
        }
    }
//Pankaj Raijade-1/2/2016-Detractor Follow Ups - Future State in SFDC-End//
    if(lstmail.size() > 0 )
        Messaging.sendEmail(lstmail);
    if(lstTaskToUpdate.size() > 0 )
        update lstTaskToUpdate;
}