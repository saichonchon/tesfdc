/**
*  This class is used to send next survet follow up reminder email

*
@author Pankaj Raijade
@created 1/2/2016
@Test Class : clsBatch_NextSurveyFollupCallRem_Test
@ coverage  95%
@changelog

*/
global class clsBatch_NextSurveyFollupCallReminder implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {         
        set<string> setTaskSubject = new set<string>{system.label.NPS_Detractor_GM_Follow_UP, system.label.NPS_Detractor_GM_Functional_Follow_UP, system.label.NPS_Detractor_AM_Follow_UP, system.label.NPS_Detractor_AM_Functional_Follow_UP, system.label.NPS_Passive_Follow_UP, system.label.NPS_Passive_Functional_Follow_UP, system.label.NPS_Promoter_Follow_UP, system.label.NPS_Promoter_Functional_Follow_UP};
        Date DateStart = system.Today().addMonths(-5);
        Integer nextWaveNumber = system.date.today().Month() + 1;
        if(nextWaveNumber == 13)
            nextWaveNumber = 1;
        return  Database.getQueryLocator([select id, ownerID,(select id from tasks where subject in :setTaskSubject AND ((ActivityDate >= :DateStart) OR ( Status = 'Completed' AND lastModifiedDate >= :DateStart))) from contact where NPS_Survey_Wave_Number__c = :nextWaveNumber AND NPS_OPT_OUT__c = :false]);
    }
    global void execute(Database.BatchableContext BC, List<contact> lstContact)
    {
        emailtemplate oET = [select id, name from emailtemplate where name = 'NPS - Next month Survey reminder' limit 1];
        if(oET != null)
        {
            list<Messaging.SingleEmailMessage> lstmail = new list<Messaging.SingleEmailMessage>();
            for(Contact oContact :lstContact)
            {
                if(oContact.Tasks != null && oContact.Tasks.size() > 0)
                {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.templateid = oET.id;
                    mail.setTargetObjectId(oContact.ownerID);
                    mail.orgWideEmailAddressId = '0D2E00000008RE1';
                    mail.setSaveAsActivity(false);
                    lstmail.add(mail);
                }
            }
            if(lstmail.size() > 0 )
                Messaging.sendEmail(lstmail);
        }
    }
    global void finish(Database.BatchableContext BC)
    {
    
    
    }
}