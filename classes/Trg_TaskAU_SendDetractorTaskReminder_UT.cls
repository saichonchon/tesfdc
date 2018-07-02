@istest(seeAlldata=true)
public class Trg_TaskAU_SendDetractorTaskReminder_UT
{
    static testmethod void Trg_TaskAU_SendDetractorTaskReminder_TM()
    {
         Schema.RecordTypeInfo TaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('EC Survey');
         Schema.RecordTypeInfo TaskRecordtypeNPS = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Task Industrial');

         list<task> lstTask = new list<task>();
         lstTask.add(new Task(RecordtypeID = TaskRecordtype.getRecordTypeId(), subject = 'Detractor Assignment', Next_reminder_date__c = datetime.now().addDays(-1)));
         lstTask.add(new Task(RecordtypeID = TaskRecordtypeNPS.getRecordTypeId(), subject = system.label.NPS_Detractor_GM_Follow_UP, Next_reminder_date__c = datetime.now().addDays(-1)));
         lstTask.add(new Task(RecordtypeID = TaskRecordtypeNPS.getRecordTypeId(), subject = system.label.NPS_Passive_Follow_UP, Next_reminder_date__c = datetime.now().addDays(-1)));
         lstTask.add(new Task(RecordtypeID = TaskRecordtypeNPS.getRecordTypeId(), subject = system.label.NPS_Promoter_Follow_UP, Next_reminder_date__c = datetime.now().addDays(-1)));
         
         insert lstTask;
         
         for(task oTask :lstTask)
             oTask.Next_reminder_date__c = datetime.now();
         update lstTask;         
    }
}