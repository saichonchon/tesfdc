public class INDSendOutlookInviteTriggerClass{

   
/*********************************************************************************************************************** 
 Name: INDSendOutlookInviteTriggerClass
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is used to filter whom to send the invite based on the trigger call on the training record.                                            
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/ 

  Public static void initMethod(Set<ID> lrid,List<Learning_Response_Result__c> oldllrlist) 
    {
       Set<ID> ids = new Set<ID>(lrid); 
       List<Learning_Response_Result__c> listLrr = [select id,Result_Summary__c,Name_of_Participant__c,Training__r.Email_of_Trainner__c,Training__r.Body_of_Outlook_Invite_Mail__c,Training__r.ownerid,Email_of_Participant__c,Date_Time_Selected_by_User_Slot1__c,Status_of_Participant__c,Training__r.Name_of_the_Trainer__c,End_Date_Time_for_Slot1__c,Training__r.Location_of_Training__c,Training__r.Name,Active_Response_Result_Record__c,TE_Network_ID__c,Training__c, 
                                             Date_Time_Selected_by_User_Slot2__c,End_Date_Time_for_Slot2__c,Date_Time_Selected_by_User_Slot3__c,End_Date_Time_for_Slot3__c,Date_Time_Selected_by_User_Slot4__c,End_Date_Time_for_Slot4__c,Date_Time_Selected_by_User_Slot5__c,End_Date_Time_for_Slot5__c,Date_Time_Selected_by_User_Slot6__c,End_Date_Time_for_Slot6__c,Start_Date_Time_for_Slot1__c,
                                             Start_Date_Time_for_Slot2__c,Start_Date_Time_for_Slot3__c,Start_Date_Time_for_Slot4__c,Start_Date_Time_for_Slot5__c,Start_Date_Time_for_Slot6__c,Training__r.Slot_1_Outlook_UID__c,Training__r.Slot_2_Outlook_UID__c,Training__r.Slot_3_Outlook_UID__c,Training__r.Slot_4_Outlook_UID__c,Training__r.Slot_5_Outlook_UID__c,Training__r.Slot_6_Outlook_UID__c
                                            from Learning_Response_Result__c where id in :ids ];
        Boolean Slot1;
        Boolean Slot2;
        Boolean Slot3;
        Boolean Slot4;
        Boolean Slot5;
        Boolean Slot6;
        
        user ownerdata=[select id,TimeZoneSidKey from user where id=:listLrr[0].Training__r.ownerid];
  for(Learning_Response_Result__c oldllr:oldllrlist)
  {
   if(oldllr.Date_Time_Selected_by_User_Slot1__c!=null)
    {
     Slot1=true;
    }
    if(oldllr.Date_Time_Selected_by_User_Slot2__c!=null)
    {
     Slot2=true;
    }
    if(oldllr.Date_Time_Selected_by_User_Slot3__c!=null)
    {
     Slot3=true;
    }
    if(oldllr.Date_Time_Selected_by_User_Slot4__c!=null)
    {
     Slot4=true;
    }
    if(oldllr.Date_Time_Selected_by_User_Slot5__c!=null)
    {
     Slot5=true;
    }
    if(oldllr.Date_Time_Selected_by_User_Slot6__c!=null)
    {
     Slot6=true;
    }
  }
  List<Messaging.SingleEmailMessage> Listmassemail = New List<Messaging.SingleEmailMessage>();
  
   for(Learning_Response_Result__c llr:listLrr)
  {
   if(llr.Date_Time_Selected_by_User_Slot1__c!=null && Slot1!=true )
    {    
       string fromaddress= llr.Training__r.Email_of_Trainner__c;
       string toaddress=llr.Email_of_Participant__c;
       string body= String.valueof(llr.Training__r.Body_of_Outlook_Invite_Mail__c);
       //string location= 'locationtest';
    //sendinvitecontroller.Sendmail_With_IcsAttachment(DateTime startDate, DateTime endDate, String location, String body, String subject, 
                                                                                           // String fromAddress, String displayName, String toAddress)
      
     Listmassemail.add(INDSendEmailwithICSAttachment.Sendmail_With_IcsAttachment(llr.Start_Date_Time_for_Slot1__c, llr.End_Date_Time_for_Slot1__c,llr.Training__r.Location_of_Training__c, body ,llr.Training__r.Name, fromaddress, llr.Name_of_Participant__c, toaddress,llr.Training__r.Slot_1_Outlook_UID__c,ownerdata.TimeZoneSidKey));
      
    }
      if(llr.Date_Time_Selected_by_User_Slot2__c!=null && Slot2!=true )
    {    
       string fromaddress=llr.Training__r.Email_of_Trainner__c;
       string toaddress=llr.Email_of_Participant__c;
       string body= String.valueof(llr.Training__r.Body_of_Outlook_Invite_Mail__c);
       //string location= 'locationtest';
    //sendinvitecontroller.Sendmail_With_IcsAttachment(DateTime startDate, DateTime endDate, String location, String body, String subject, 
                                                                                           // String fromAddress, String displayName, String toAddress)
      
     Listmassemail.add(INDSendEmailwithICSAttachment.Sendmail_With_IcsAttachment(llr.Start_Date_Time_for_Slot2__c, llr.End_Date_Time_for_Slot2__c,llr.Training__r.Location_of_Training__c, body ,llr.Training__r.Name, fromaddress, llr.Name_of_Participant__c, toaddress,llr.Training__r.Slot_2_Outlook_UID__c,ownerdata.TimeZoneSidKey));
      
    }
   if(llr.Date_Time_Selected_by_User_Slot3__c!=null && Slot3!=true)
    {    
       string fromaddress= llr.Training__r.Email_of_Trainner__c;
       string toaddress=llr.Email_of_Participant__c;
       string body= String.valueof(llr.Training__r.Body_of_Outlook_Invite_Mail__c);
       //string location= 'locationtest';
     
      
     Listmassemail.add(INDSendEmailwithICSAttachment.Sendmail_With_IcsAttachment(llr.Start_Date_Time_for_Slot3__c, llr.End_Date_Time_for_Slot3__c,llr.Training__r.Location_of_Training__c, body ,llr.Training__r.Name, fromaddress, llr.Name_of_Participant__c, toaddress,llr.Training__r.Slot_3_Outlook_UID__c,ownerdata.TimeZoneSidKey));
      
    }
    if(llr.Date_Time_Selected_by_User_Slot4__c!=null && Slot4!=true)
    {    
       string fromaddress= llr.Training__r.Email_of_Trainner__c;
       string toaddress=llr.Email_of_Participant__c;
       string body= String.valueof(llr.Training__r.Body_of_Outlook_Invite_Mail__c);
       //string location= 'locationtest';
    
      
     Listmassemail.add(INDSendEmailwithICSAttachment.Sendmail_With_IcsAttachment(llr.Start_Date_Time_for_Slot4__c, llr.End_Date_Time_for_Slot4__c,llr.Training__r.Location_of_Training__c, body ,llr.Training__r.Name, fromaddress, llr.Name_of_Participant__c, toaddress,llr.Training__r.Slot_4_Outlook_UID__c,ownerdata.TimeZoneSidKey));
      
    }
    if(llr.Date_Time_Selected_by_User_Slot5__c!=null && Slot5!=true)
    {    
       string fromaddress= llr.Training__r.Email_of_Trainner__c;
       string toaddress=llr.Email_of_Participant__c;
       string body= String.valueof(llr.Training__r.Body_of_Outlook_Invite_Mail__c);
       //string location= 'locationtest';
      
      
     Listmassemail.add(INDSendEmailwithICSAttachment.Sendmail_With_IcsAttachment(llr.Start_Date_Time_for_Slot5__c, llr.End_Date_Time_for_Slot5__c,llr.Training__r.Location_of_Training__c, body ,llr.Training__r.Name, fromaddress, llr.Name_of_Participant__c, toaddress,llr.Training__r.Slot_5_Outlook_UID__c,ownerdata.TimeZoneSidKey));
      
    }
    if(llr.Date_Time_Selected_by_User_Slot6__c!=null && Slot6!=true)
    {    
       string fromaddress= llr.Training__r.Email_of_Trainner__c;
       string toaddress=llr.Email_of_Participant__c;
       string body= String.valueof(llr.Training__r.Body_of_Outlook_Invite_Mail__c);
       //string location= 'locationtest';
     
      
     Listmassemail.add(INDSendEmailwithICSAttachment.Sendmail_With_IcsAttachment(llr.Start_Date_Time_for_Slot6__c, llr.End_Date_Time_for_Slot6__c,llr.Training__r.Location_of_Training__c, body ,llr.Training__r.Name, fromaddress, llr.Name_of_Participant__c, toaddress,llr.Training__r.Slot_6_Outlook_UID__c,ownerdata.TimeZoneSidKey));
      
    }
  
  
  }
  Messaging.sendEmail(Listmassemail);
 
/*for(Learning_Response_Result__c oldllr:Trigger.new)
{
 trid.add(oldllr.Training__c);
 RSid.add(oldllr.Result_Summary__c);
}

List<Training__c> Listtr =[select id,Number_of_Points_for_Exam_Participation__c,Number_of_Points_for_Exam_Passed__c,Number_of_Points_for_giving_Feedback__c,Number_of_Points_If_user_Attended__c from Training__c where id IN :trid];
List<L_R_Result_Summary__c> ListRS =[select id,Total_Points_for_Training_Attended__c,Total_Feedback_Given_Point__c,Total_Exam_Passed_Points__c,Total_Exam_Participation_Point__c from L_R_Result_Summary__c where id IN :RSid];

 if(trigger.isinsert)
  {
    for(Learning_Response_Result__c llr:listLrr)
     {
       for(Training__c tr:Listtr )
        {
           for(L_R_Result_Summary__c Rs:ListRS)
           {
              if(llr.Training__c == tr.id && llr.Result_Summary__c==Rs.id)
               {
                 Rs.Total_Exam_Participation_Point__c+=tr.Number_of_Points_for_Exam_Participation__c;
                 Rs.Total_Exam_Passed_Points__c+=tr.Number_of_Points_for_Exam_Passed__c;
                 Rs.Total_Feedback_Given_Point__c+=tr.Number_of_Points_for_giving_Feedback__c;
                 Rs.Total_Points_for_Training_Attended__c+=tr.Number_of_Points_If_user_Attended__c;
               
               }
           }    
        }
     }
     Update ListRS;
  }
   */ 
  
  
  
  
  
 
    }





}