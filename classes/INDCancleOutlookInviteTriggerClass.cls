public class INDCancleOutlookInviteTriggerClass{

/*********************************************************************************************************************** 
 Name: INDCancleOutlookInviteTriggerClass
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is called by trigger to send the outlook cancle mail to all the attendies of the training .                                                   
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/


//********************************************************Method to create the Cancle Outlook invitaion************************************************************

   private static Blob doIcsAttachment(DateTime startDate, DateTime endDate, String location, String body, 
                                                                        String subject, String fromAddress, String displayName, String toAddress, String outlookuid) {
       
       // yyyyMMddThhmmssZ
      //string exstartdate= String.valueof(startDate.year())+String.valueof(startDate.month())+String.valueof(startDate.day())+'T'+String.valueof(startDate.hour())+String.valueof(startDate.minute())+String.valueof(startDate.second())+'Z';
       string exenddate = createdatetime(endDate);
       string exstartdate = createdatetime(startDate);
       string exlocation = String.valueof(location);
       string exbody = String.valueof(body);
       string exsubject = String.valueof(subject);
       string exfromAddress = String.valueof(fromAddress);
       string extoAddress = String.valueof(toAddress);
       string exdisplayName = String.valueof(displayName);
       string extempdate = createdatetime(DateTime.Now());
       string exoutlookuid = String.valueof(outlookuid);  
                
                String txtInvite = '';
     
    txtInvite += 'BEGIN:VCALENDAR\n';
    txtInvite += 'PRODID:-//Microsoft Corporation//Outlook 15.0 MIMEDIR//EN\n';
    txtInvite += 'VERSION:2.0\n';
    txtInvite += 'METHOD:Cancel\n'; // REQUEST\n';
    txtInvite += 'X-MS-OLK-FORCEINSPECTOROPEN:TRUE\n';
    txtInvite += 'BEGIN:VEVENT\n';                                                              
    // txtInvite += 'ATTENDEE;CN="'+exdisplayName+'";RSVP=TRUE:mailto:'+exfromAddress+ '\n';           
    txtInvite += 'CLASS:PUBLIC\n';
    txtInvite += 'CREATED:'+extempdate+'\n';
     txtInvite += 'DESCRIPTION:'+exbody+'\n';
    txtInvite += 'DTEND:'+exenddate+'\n';                           
    txtInvite += 'DTSTAMP:'+extempdate+'\n';
    txtInvite += 'DTSTART:'+exstartdate+'\n';                              //yyyyMMddThhmmssZ''+String.valueOf(Crypto.getRandomLong())+'\n'; //
    txtInvite += 'LAST-MODIFIED:'+extempdate+'\n';
    txtInvite += 'LOCATION:'+exlocation+'\n';
    //txtInvite += 'ORGANIZER;SENT-BY="MAILTO:'+fromAddress+'":mailto:'+toAddress+'\n';
   // txtInvite += 'ORGANIZER;CN="'+exdisplayName+'":'+exfromAddress+'\n'; 
    txtInvite += 'STATUS:CANCELLED\n';
    txtInvite += 'PRIORITY:5\n';// CANCELLED 
    txtInvite += 'SEQUENCE:0\n';
    txtInvite += 'SUMMARY:'+exsubject+'\n';
    txtInvite += 'LANGUAGE=en-us:Meeting\n';
    txtInvite += 'TRANSP:OPAQUE\n';
    txtInvite += 'UID:'+exoutlookuid+'\n';           // String.valueOf(Crypto.getRandomLong())+'\n'; //4036587160834EA4AE7848CBD028D1D200000000000000000000000000000000\n';
    txtInvite += 'X-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN"><HTML><HEAD><META NAME="Generator" CONTENT="MS Exchange Server version rmj.rmm.rup.rpr"><TITLE></TITLE></HEAD><BODY><!-- Converted from text/plain format --></BODY></HTML>\n';
                  //X-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">\n<HTML>\n<HEAD>\n<META NAME="Generator" CONTENT="MS Exchange Server ve rmj.rmm.rup.rpr 08.00.0681.000
    
    txtInvite += 'X-MICROSOFT-CDO-BUSYSTATUS:BUSY\n';
    txtInvite += 'X-MICROSOFT-CDO-IMPORTANCE:1\n';
    txtInvite += 'X-MICROSOFT-DISALLOW-COUNTER:FALSE\n';
    txtInvite += 'X-MS-OLK-APPTSEQTIME:'+extempdate+'\n';
    txtInvite += 'X-MS-OLK-AUTOFILLLOCATION:FALSE\n';
    txtInvite += 'X-MS-OLK-CONFTYPE:0\n';
   txtInvite +='BEGIN:VALARM\n';
   txtInvite +='TRIGGER:-PT15M\n';
   txtInvite +='ACTION:DISPLAY\n';
   txtInvite +='DESCRIPTION:Reminder\n';
   txtInvite +='END:VALARM\n';
    txtInvite += 'END:VEVENT\n';
    txtInvite += 'END:VCALENDAR';                                                                
                                                                                
       // String attachment = String.join(icsTemplate, '\n');
        return Blob.valueof(txtInvite ); 
    }
 //********************************************************Method to create the Cancle Outlook invitaion************************************************************
 
 
//********************************************************Method to convert the date and time format************************************************************
 
    public static string createdatetime(DateTime d)
     {
     
      String finalstring;
      finalstring=String.valueof(d.year());
      
      if(d.month()>=0 && d.month()<=9)
      {
       finalstring +='0'+ String.valueof(d.month());
      }
      else
      {
       finalstring +=String.valueof(d.month());
      }
      
      if(d.day()>=0 && d.day()<=9)
      {
       finalstring +='0'+ String.valueof(d.day())+'T';
      }
      else
      {
       finalstring +=String.valueof(d.day())+'T';
      }
     
      if(d.hour()>=0 && d.hour()<=9)
      {
       finalstring +='0'+ String.valueof(d.hour());
      }
      else
      {
       finalstring +=String.valueof(d.hour());
      }
      
      if(d.minute()>=0 && d.minute()<=9)
      {
       finalstring +='0'+ String.valueof(d.minute());
      }
      else
      {
       finalstring +=String.valueof(d.minute());
      }
      if(d.second()>=0)
      {
       finalstring +='00Z';
      }
      
     return(finalstring);
       
         
     }
 
 //********************************************************Method to convert the date and time format************************************************************

 
 
//****************************************************** Cancle Email Invite******************************************************************************************************************************************
 

 
 
 Public static void initMethod(ID trids) 
    {
     List<Learning_Response_Result__c> listLrr = [select id,Name_of_Participant__c,Email_of_Participant__c,Date_Time_Selected_by_User_Slot1__c,Date_Time_Selected_by_User_Slot2__c,Date_Time_Selected_by_User_Slot3__c,Date_Time_Selected_by_User_Slot4__c,Date_Time_Selected_by_User_Slot5__c,Date_Time_Selected_by_User_Slot6__c
                                            from Learning_Response_Result__c where Training__c = :trids];
      
    Training__c trr =[select id,name,Training_Date_and_Time1__c,EndTraining_Date_and_Time1__c,Slot_1_Outlook_UID__c,Training_Date_and_Time2__c,EndTraining_Date_and_Time2__c,Slot_2_Outlook_UID__c,Training_Date_and_Time3__c,EndTraining_Date_and_Time3__c,Slot_3_Outlook_UID__c,Training_Date_and_Time4__c,EndTraining_Date_and_Time4__c,Slot_4_Outlook_UID__c,Training_Date_and_Time5__c,EndTraining_Date_and_Time5__c,Slot_5_Outlook_UID__c,Training_Date_and_Time6__c,EndTraining_Date_and_Time6__c,Slot_6_Outlook_UID__c,Location_of_Training__c,Email_of_Trainner__c,Cancel_Slot_1__c,Cancel_Slot_2__c,Cancel_Slot_3__c,Cancel_Slot_4__c,Cancel_Slot_5__c,Cancel_Slot_6__c from Training__c where id =:trids Limit 1];
   Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
  If(trr!=null)
  {
 
  for(Learning_Response_Result__c llr:listLrr)
  {
  string fromAddress=String.valueof(trr.Email_of_Trainner__c);
  string displayName=String.valueof(llr.Name_of_Participant__c);
  string toAddress=String.valueof(llr.Email_of_Participant__c);
  string subject= String.valueof(trr.name);
  string body='The Training is canceled for some reason, For more information please contact Trainner:'+ trr.Email_of_Trainner__c;//  String.valueof(trr.Body_of_Outlook_Invite_Mail__c);
  string location=String.valueof(trr.Location_of_Training__c);
 
 
  String attachmentName = 'TrainingInvite.ics';
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        
        //Now we have to set the value to Mail message properties
 
        //Note Please change it to correct mail-id to use this in your application
        msg.setReplyTo(fromAddress);
        msg.setSenderDisplayName(displayName);
        msg.setToAddresses(new String[] {toAddress});
        
        //msg.setCcAddresses(new String[] {'user@acme.com'});// it is optional, only if required
        msg.setSubject(subject);
        msg.setPlainTextBody(body);
      
        
       
        
        // Create the attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.ContentType = 'text/calendar;';
        efa.inline = true;
      
        efa.setFileName(attachmentName );
        //Blob b;
        if(llr.Date_Time_Selected_by_User_Slot1__c!=null && trr.Cancel_Slot_1__c==true)
        {
        Blob b = doIcsAttachment(trr.Training_Date_and_Time1__c, trr.EndTraining_Date_and_Time1__c, location, body, subject, fromAddress, displayName, toAddress, trr.Slot_1_Outlook_UID__c);
         efa.setBody(b);
         msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
         messages.add(msg);
        // Send the email you have created.
       // Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        }
        if(llr.Date_Time_Selected_by_User_Slot2__c!=null && trr.Cancel_Slot_2__c==true)
        {
        Blob b = doIcsAttachment(trr.Training_Date_and_Time2__c, trr.EndTraining_Date_and_Time2__c, location, body, subject, fromAddress, displayName, toAddress, trr.Slot_2_Outlook_UID__c);
          efa.setBody(b);
         msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
          messages.add(msg);
        // Send the email you have created.
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        }
        if(llr.Date_Time_Selected_by_User_Slot3__c!=null && trr.Cancel_Slot_3__c==true)
        {
        Blob b = doIcsAttachment(trr.Training_Date_and_Time3__c, trr.EndTraining_Date_and_Time3__c, location, body, subject, fromAddress, displayName, toAddress, trr.Slot_3_Outlook_UID__c);
         efa.setBody(b);
         msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
          messages.add(msg);
        // Send the email you have created.
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        }
        if(llr.Date_Time_Selected_by_User_Slot4__c!=null && trr.Cancel_Slot_4__c==true)
        {
        Blob b = doIcsAttachment(trr.Training_Date_and_Time4__c, trr.EndTraining_Date_and_Time4__c, location, body, subject, fromAddress, displayName, toAddress, trr.Slot_4_Outlook_UID__c);
         efa.setBody(b);
         msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
         messages.add(msg);
        // Send the email you have created.
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        }
        if(llr.Date_Time_Selected_by_User_Slot5__c!=null && trr.Cancel_Slot_5__c==true)
        {
        Blob b = doIcsAttachment(trr.Training_Date_and_Time5__c, trr.EndTraining_Date_and_Time5__c, location, body, subject, fromAddress, displayName, toAddress, trr.Slot_5_Outlook_UID__c);
         efa.setBody(b);
         msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
          messages.add(msg);
        // Send the email you have created.
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        }
        if(llr.Date_Time_Selected_by_User_Slot6__c!=null && trr.Cancel_Slot_6__c==true)
        {
        Blob b = doIcsAttachment(trr.Training_Date_and_Time6__c, trr.EndTraining_Date_and_Time6__c, location, body, subject, fromAddress, displayName, toAddress, trr.Slot_6_Outlook_UID__c);
         efa.setBody(b);
         msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
          messages.add(msg);
        // Send the email you have created.
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
        }
       // efa.setBody(b);
      //  msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        // Send the email you have created.
        //Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { messages});
      
      }
      }
       Messaging.sendEmail(messages);
 //********************************************************Method to convert the date and time format************************************************************
     

//****************************************************** Cancle Email Invite******************************************************************************************************************************************
 



 }


}