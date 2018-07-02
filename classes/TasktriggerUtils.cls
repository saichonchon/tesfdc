/**
*  This class is used to create functional follow up task and send functional follow up task complete reminder
*
@author Pankaj Raijade
@created 1/2/2016
@Test Class : taskTrigger_Test
@ coverage  90%
@changelog
*****
@ Changes By Mrunal for Case 900966 --> Changed ownership of task for industrial based on territory code i.e  first
check matched level 3 code then level 4 and if not found then assign to default user of custom setting

@Changes By DeepAk Kumar for Case 00901079 for Product Quality on 19th Aug 2016--> Changed ownership of task for industrial based on territory code i.e  first
check matched level 3 code then level 4 and if not found then assign to default user of custom setting
*
* Author: Rahulkumar Chakalasiya
* Modified Date: 04/16/2018
* Reason: case 00901528, added updateActivityOnMQLRecord method to update first activity date on MQLRecord.
* Author: Rahulkumar Chakalasiya
* Modified Date: 06/06/2018
* Reason: case 00901789, consider only lead(00Q) and contact(003) records in whoID from task record
*  
*/

Public class TasktriggerUtils
{
    public static boolean TaskRecursionDefence = true;
    public static void CreateFunctionalFollowUpTask(Map<Id,Task> mapTaskold, Map<Id,Task> mapTasknew)
    {
         if(TasktriggerUtils.TaskRecursionDefence)
         {
             TasktriggerUtils.TaskRecursionDefence = false;
             Schema.RecordTypeInfo NPSTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Task Industrial');
             Schema.RecordTypeInfo NPSFunctionalFollowUpTaskRecordtype = schema.Task.SobjectType.getDescribe().getRecordTypeInfosByName().get('NPS Industrial Functional Follow Up Task');
             list<task> lstTaskInsert = new list<task>();
             map<string, NPS_Settings__c> mapNPSSetting = NPS_Settings__c.getAll();
             set<ID> setBUFTTask = new set<id>();
             list<task> lstSendmailTask = new list<task>();
             for(Task oTaskNew :mapTaskNew.values())
             {
                 Task oTaskOld = mapTaskold.get(oTaskNew.id);
                 if(oTaskNew.recordTypeID == NPSTaskRecordtype.getRecordTypeId() && oTaskNew.status == 'Functional Follow Up Created' && oTaskNew.status != oTaskOld.status)
                 {
                     if(oTaskNew.Q05_Business_Understanding__c || oTaskNew.Q06_Field_Tech_Support__c || oTaskNew.Q09_Delivery_Performance__c || oTaskNew.Q10_Product_Quality__c)//Added oTaskNew.Q09_Delivery_Performance__c By Mrunal for Case 900966
                         setBUFTTask.add(oTaskNew.WhoID);                                                                                                                        //Added oTaskNew.Q10_Product_Quality__c By Deepak for Case 00901079
                                                                                                                                                     
                 }
                 if(oTaskNew.recordTypeID == NPSFunctionalFollowUpTaskRecordtype.getRecordTypeId() && oTaskNew.status == 'Completed' && oTaskNew.status != oTaskOld.status)
                     lstSendmailTask.add(oTaskNew);
             }
             map<id, contact> mapContact = new map<id, contact>();
             if(setBUFTTask.size() > 0)
                 mapContact.putAll([select id, account.Sales_Hierarchy__r.Level_7_Assigned_Users__c,account.Sales_Hierarchy__r.Level_3_Territory_Code__c,account.Sales_Hierarchy__r.Level_4_Territory_Code__c, account.FE_Hierarchy__r.Level_7_Assigned_Users__c from contact where id in :setBUFTTask]);// Level_3_Territory_Code__c and Level_4_Territory_Code__c added By Mrunal for Case 900966
            
             for(Task oTaskNew :mapTaskNew.values())
             {
                 Task oTaskOld = mapTaskold.get(oTaskNew.id);
                 if(oTaskNew.recordTypeID == NPSTaskRecordtype.getRecordTypeId() && oTaskNew.status == 'Functional Follow Up Created' && oTaskNew.status != oTaskOld.status)
                 {
                     if(oTaskNew.Q02_Engineering_Responsiveness__c)
                     {
                         NPS_Settings__c oNPS_Settings = mapNPSSetting.get('02. Engineering Responsiveness');
                         if(oNPS_Settings != null && oNPS_Settings.value__c != null)
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, oNPS_Settings.value__c, '02. Engineering Responsiveness',  oTaskNew.Q02_Engineering_Responsiveness_Comments__c));
                     }
                     if(oTaskNew.Q03_Technology_needs_met__c)
                     {
                         NPS_Settings__c oNPS_Settings = mapNPSSetting.get('03. Technology needs met');
                         if(oNPS_Settings != null && oNPS_Settings.value__c != null)
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, oNPS_Settings.value__c, '03. Technology needs met', oTaskNew.Q03_Technology_needs_met_Comments__c));
                     }
                     if(oTaskNew.Q04_Product_Innovation__c)
                     {
                         NPS_Settings__c oNPS_Settings = mapNPSSetting.get('04. Product Innovation');
                         if(oNPS_Settings != null && oNPS_Settings.value__c != null)
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, oNPS_Settings.value__c, '04. Product Innovation', oTaskNew.Q04_Product_Innovation_Comments__c));
                     }
                     if(oTaskNew.Q05_Business_Understanding__c)
                     {                         
                         if(mapContact.containsKey(oTaskNew.WhoID))
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_7_Assigned_Users__c, '05 Business Understanding', oTaskNew.Q05_Business_Understanding_Comments__c));
                     }
                     if(oTaskNew.Q06_Field_Tech_Support__c)
                     {
                        if(mapContact.containsKey(oTaskNew.WhoID))
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, mapContact.get(oTaskNew.WhoID).account.FE_Hierarchy__r.Level_7_Assigned_Users__c, '06 Field Tech Support', oTaskNew.Q06_Field_Tech_Support_Comments__c));
                     }
                     if(oTaskNew.Q07_Customer_Care_Support__c)
                     {
                         NPS_Settings__c oNPS_Settings = mapNPSSetting.get('07. Customer Care Support');
                         if(oNPS_Settings != null && oNPS_Settings.value__c != null)
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, oNPS_Settings.value__c, '07. Customer Care Support', oTaskNew.Q07_Customer_Care_Support_Comments__c));
                     }
                     if(oTaskNew.Q08_Competitive_Price__c)
                     {
                         NPS_Settings__c oNPS_Settings = mapNPSSetting.get('08. Competitive Price');
                         if(oNPS_Settings != null && oNPS_Settings.value__c != null)
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, oNPS_Settings.value__c, '08. Competitive Price', oTaskNew.Q08_Competitive_Price_Comments__c));
                     }
                     if(oTaskNew.Q09_Delivery_Performance__c)
                     {
                     //Changes start By Mrunal for Case 900966
                        Id owner;
                        if(mapContact.containsKey(oTaskNew.WhoID) && mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_3_Territory_Code__c!= null && mapNPSSetting.containsKey('09. Delivery Performance - ' +mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_3_Territory_Code__c)){
                            NPS_Settings__c oNPS_Settings = mapNPSSetting.get('09. Delivery Performance - '+mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_3_Territory_Code__c);
                            
                            if(oNPS_Settings != null && oNPS_Settings.value__c != null) owner = oNPS_Settings.Value__c;
                            
                                                   
                        }else if(mapContact.containsKey(oTaskNew.WhoID) && mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_4_Territory_Code__c!= null && mapNPSSetting.containsKey('09. Delivery Performance - '+mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_4_Territory_Code__c)){
                            NPS_Settings__c oNPS_Settings = mapNPSSetting.get('09. Delivery Performance - '+mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_4_Territory_Code__c);
                            if(oNPS_Settings != null && oNPS_Settings.value__c != null) owner = oNPS_Settings.Value__c;
                                                
                        }else{
                            NPS_Settings__c oNPS_Settings = mapNPSSetting.get('09. Delivery Performance - Default');
                            if(oNPS_Settings != null && oNPS_Settings.value__c != null) owner = oNPS_Settings.Value__c;
                         
                           
                        }
                         
                         if(owner != null)
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, owner, '09. Delivery Performance', oTaskNew.Q09_Delivery_Performance_Comments__c));
                     //Changes End By Mrunal for Case 900966
                     }
                     if(oTaskNew.Q10_Product_Quality__c)
                     {
                      /*   NPS_Settings__c oNPS_Settings = mapNPSSetting.get('10. Product Quality');
                          if(oNPS_Settings != null && oNPS_Settings.value__c != null)
                            lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, oNPS_Settings.value__c, '10. Product Quality', oTaskNew.Q10_Product_Quality_Comments__c));
                     */
                      
                    //Changes start By Deepak Kumar on 19th Aug 2016 for Case 00901079
                    
                        Id owner;
                        if(mapContact.containsKey(oTaskNew.WhoID) && mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_3_Territory_Code__c!= null && mapNPSSetting.containsKey('10. ProductQuality- '+mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_3_Territory_Code__c)){
                            NPS_Settings__c oNPS_Settings = mapNPSSetting.get('10. ProductQuality- '+mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_3_Territory_Code__c);
                            
                            if(oNPS_Settings != null && oNPS_Settings.value__c != null) owner = oNPS_Settings.Value__c;
                            
                                                   
                        }else if(mapContact.containsKey(oTaskNew.WhoID) && mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_4_Territory_Code__c!= null && mapNPSSetting.containsKey('10. ProductQuality- '+mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_4_Territory_Code__c)){
                            NPS_Settings__c oNPS_Settings = mapNPSSetting.get('10. ProductQuality- '+mapContact.get(oTaskNew.WhoID).account.Sales_Hierarchy__r.Level_4_Territory_Code__c);
                            if(oNPS_Settings != null && oNPS_Settings.value__c != null) owner = oNPS_Settings.Value__c;
                                                
                        }else{
                            NPS_Settings__c oNPS_Settings = mapNPSSetting.get('10. ProductQuality- Default');
                            if(oNPS_Settings != null && oNPS_Settings.value__c != null) owner = oNPS_Settings.Value__c;
                         
                           
                        }
                         
                         if(owner != null)
                             lstTaskInsert.add(getFunctionaltask(oTaskNew, NPSFunctionalFollowUpTaskRecordtype, owner, '10. Product Quality', oTaskNew.Q09_Delivery_Performance_Comments__c));
                     
                      
                       //Changes start By Deepak Kumar on 19th Aug 2016 for Case 00901079
                         
                     }
                 }
             }
             if(lstTaskInsert.size() > 0)
                 insert lstTaskInsert;
             if(lstSendmailTask.size() > 0)
             {
                 map<string, id> mapEmailTemplate = new map<string, id>();
                 set<string> setemailTemplateName = new set<string>{'NPS - Function follow up completed'};
                 for(emailtemplate oET:[select id, name from emailtemplate where name IN :setemailTemplateName ])
                     mapEmailTemplate.put(oET.Name, oET.Id);
                 list<Messaging.SingleEmailMessage> lstmail = new list<Messaging.SingleEmailMessage>();
                 for(task oTaskNew :lstSendmailTask)
                 {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.templateid = mapEmailTemplate.get('NPS - Function follow up completed');
                    mail.setTargetObjectId(oTaskNew.Follow_Up_Received_from__c);
                    mail.setwhatid(oTaskNew.id);
                    mail.setSaveAsActivity(false);
 
                    lstmail.add(mail);
                 }
                 if(lstmail.size() > 0 )
                    Messaging.sendEmail(lstmail);
             }
        }
    }
    public static string getFollowupSubject(string strTaskSubject)
    {
         if(strTaskSubject == system.label.NPS_Detractor_GM_Follow_UP)
             return system.label.NPS_Detractor_GM_Functional_Follow_UP;
         if(strTaskSubject == system.label.NPS_Detractor_AM_Follow_UP)
             return system.label.NPS_Detractor_AM_Functional_Follow_UP;
         if(strTaskSubject == system.label.NPS_Passive_Follow_UP)
             return system.label.NPS_Passive_Functional_Follow_UP;
         if(strTaskSubject == system.label.NPS_Promoter_Follow_UP)
             return system.label.NPS_Promoter_Functional_Follow_UP;
         return '';
    }
    public static task getFunctionaltask(task oTask, Schema.RecordTypeInfo NPSFunctionalFollowUpTaskRecordtype, id taskownerid, string strFeedbackQuestion, string strFeedbackComment)
    {
        Task oTaskFunc = oTask.clone(false, true);
        oTaskFunc.status = 'Not Started';
        oTaskFunc.Follow_Up_Received_from__c = oTask.ownerID;
        oTaskFunc.Subject = getFollowupSubject(oTaskFunc.Subject);
        oTaskFunc.recordtypeid = NPSFunctionalFollowUpTaskRecordtype.getRecordTypeId();
        oTaskFunc.OwnerID = taskownerid;
        oTaskFunc.Detractor_Task__c = oTask.id;
        oTaskFunc.Feed_back_Question__c = strFeedbackQuestion;
        oTaskFunc.Feed_back__c = strFeedbackComment;
        oTaskFunc.Q02_Engineering_Responsiveness__c = false;
        oTaskFunc.Q03_Technology_needs_met__c = false;
        oTaskFunc.Q04_Product_Innovation__c = false;
        oTaskFunc.Q05_Business_Understanding__c = false;
        oTaskFunc.Q06_Field_Tech_Support__c = false;
        oTaskFunc.Q07_Customer_Care_Support__c = false;
        oTaskFunc.Q08_Competitive_Price__c = false;
        oTaskFunc.Q09_Delivery_Performance__c = false;
        oTaskFunc.Q10_Product_Quality__c = false;
        oTaskFunc.Q02_Engineering_Responsiveness_Comments__c = '';
        oTaskFunc.Q03_Technology_needs_met_Comments__c = '';
        oTaskFunc.Q04_Product_Innovation_Comments__c = '';
        oTaskFunc.Q05_Business_Understanding_Comments__c = '';
        oTaskFunc.Q06_Field_Tech_Support_Comments__c = '';
        oTaskFunc.Q07_Customer_Care_Support_Comments__c = '';
        oTaskFunc.Q08_Competitive_Price_Comments__c = '';
        oTaskFunc.Q09_Delivery_Performance_Comments__c = '';
        oTaskFunc.Q10_Product_Quality_Comments__c = '';
        oTaskFunc.Description = '';
        oTaskFunc.Next_reminder_date__c = system.now();
        return oTaskFunc;
    }

    //--Added by Rahul(16 Apr 2018)--Case 901528--Start--//
    /*
    * Author: Rahulkumar Chakalasiya
    * Method name : updateActivityOnMQLRecord
    * Parameter(s):
    * - taskNewMap: Parameter contains list of Task object records.
    * ReturnType: void
    * This method is update first activity(task or event) date on MQL record for associated lead or contact, for those activity those are created after mql creation.
    * 
    * Change History:
    * Author: Rahulkumar
    * Reason: to fox P1 ticket INC0626903, consider only lead(00Q) and contact(003) records in whoID from task record
    */

    public static void updateActivityOnMQLRecord(List<Task> taskNewMap){
        List<TEMarketing__MQLRecord__c> updateMqlList = new List<TEMarketing__MQLRecord__c>();        
        Map<Id,Date> activityMap = new Map<Id,Date>();

        //--populate map for whoid and its least created date from task or event records--//
        if(taskNewMap != null && taskNewMap.size() > 0){
            for(Task oTaskNew :taskNewMap){
                if((oTaskNew.WhoId != null && (oTaskNew.WhoId.getSObjectType() == Contact.sObjectType || oTaskNew.WhoId.getSObjectType() == Lead.sObjectType)) && 
                    (oTaskNew.TaskSubType == 'Call' || oTaskNew.TaskSubType == 'Email') && 
                    ((!activityMap.containsKey(oTaskNew.WhoId)) || 
                    (activityMap.containsKey(oTaskNew.WhoId) && oTaskNew.CreatedDate.date() < activityMap.get(oTaskNew.WhoId)))){
                    activityMap.put(oTaskNew.WhoId, oTaskNew.CreatedDate.date());
                }
            }
        }

        if(activityMap != null && activityMap.size() > 0){ 
            for(TEMarketing__MQLRecord__c mql: [Select Id,Original_MQL_Type__c,Related_to__c,TEMarketing__Lead__c,TEMarketing__Contact__c, 
                    First_Contact_Date__c,CreatedDate From TEMarketing__MQLRecord__c 
                    Where (TEMarketing__Lead__c in: activityMap.keySet() OR TEMarketing__Contact__c in: activityMap.keySet()) 
                    And First_Contact_Date__c = null Order by CreatedDate DESC LIMIT 50000]){       
                if(activityMap.containsKey(mql.TEMarketing__Lead__c)){
                    mql.First_Contact_Date__c = activityMap.get(mql.TEMarketing__Lead__c); 
                }
                if(mql.First_Contact_Date__c == null || (activityMap.containsKey(mql.TEMarketing__Contact__c) && activityMap.get(mql.TEMarketing__Contact__c) < mql.First_Contact_Date__c)){ 
                    mql.First_Contact_Date__c = activityMap.get(mql.TEMarketing__Contact__c);
                }
                if(mql.First_Contact_Date__c != null){
                    updateMqlList.add(mql); 
                }
            } 
        }

        if(updateMqlList != null && updateMqlList.size() > 0 ){
            update updateMqlList;
        }         
    }
    //--Added by Rahul(16 Apr 2018)--Case 901528--End--//
}