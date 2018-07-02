/**
*  This used as controller for Ind_NPSFollowUpTaskView VF page.
*
@author Pankaj Raijade
@created 1/2/2016
@Test Class : Ind_NPSFollowUpTaskView_Test
@ coverage  100%
@changelog

*/
public class Ind_NPSFollowUpTaskView
{
    public list<task> lstTask{get;set;}
    public Ind_NPSFollowUpTaskView(ApexPages.StandardController stdController)
    {
        Schema.RecordTypeInfo NPSFunctionalFollowUpTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Industrial Functional Follow Up Task');
        id NPSFunctionalFollowUpTaskRecordtypeid = NPSFunctionalFollowUpTaskRecordtype.getRecordTypeId();
        id TaskID = stdController.getId();
        Map<String, Schema.SObjectField> FsMap = Task.sObjectType.getDescribe().fields.getMap();

        string strFields = ' ';
        
        for(string strField :FsMap.keySet())
            strFields += ' ' + strField + ' ,';
        
        strFields = strFields.substring(1, strFields.lastIndexOf(','));
        lstTask = database.query('select ' + strFields + ' from task where detractor_task__c = :TaskID AND recordtypeid = :NPSFunctionalFollowUpTaskRecordtypeid ');
        //lstTask = database.query('select id, Subject, Whoid from task where detractor_task__c = :TaskID');
    }
}