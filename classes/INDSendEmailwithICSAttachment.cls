public class INDSendEmailwithICSAttachment {

   
/*********************************************************************************************************************** 
 Name: INDSendEmailwithICSAttachment 
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is creating Outlook invite for participant.                                            
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/ 
    public static Messaging.SingleEmailMessage Sendmail_With_IcsAttachment(DateTime startDate, DateTime endDate, String location, String body, String subject, 
                                                                                            String fromAddress, String displayName, String toAddress, String outlookuid,string Teownertimezoneid) {
        
        
       
        
        String attachmentName = 'TrainingInvite.ics';
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        //Now we have to set the value to Mail message properties
        //subject= subject + PrticipantGMThour +'/'+ TrOwnerGMThour;
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
        Blob b = doIcsAttachment(startDate, endDate, location, body, subject, fromAddress, displayName, toAddress, outlookuid);
        efa.setBody(b);
        msg.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        // Send the email you have created.
        //Messaging.sendEmail(new Messaging.SingleEmailMessage[] { msg });
      return(msg);
    }
    
    private static Blob doIcsAttachment(DateTime startDate, DateTime endDate, String location, String body, 
                                                                        String subject, String fromAddress, String displayName, String toAddress, String outlookuid) {
       
       // yyyyMMddThhmmssZ
      //string exstartdate= String.valueof(startDate.year())+String.valueof(startDate.month())+String.valueof(startDate.day())+'T'+String.valueof(startDate.hour())+String.valueof(startDate.minute())+String.valueof(startDate.second())+'Z';
      // startDate = startDate.format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getID()); 
      // endDate = endDate.format('yyyy-MM-dd HH:mm:ss', UserInfo.getTimeZone().getID()); 
       
       string exenddate = createdatetime(endDate);
       string exstartdate = createdatetime(startDate);
      
       string exlocation = String.valueof(location);
       string exbody = String.valueof(body);
       string exsubject = String.valueof(subject);
       string exfromAddress = String.valueof(fromAddress);
       string exdisplayName = String.valueof(displayName);
       string extempdate = createdatetime(DateTime.Now());
       string exoutlookuid = String.valueof(outlookuid);  
                
                String txtInvite = '';
     
    txtInvite += 'BEGIN:VCALENDAR\n';
    txtInvite += 'PRODID:-//Microsoft Corporation//Outlook 15.0 MIMEDIR//EN\n';
    txtInvite += 'VERSION:2.0\n';
    txtInvite += 'METHOD:REQUEST\n';
    txtInvite += 'X-MS-OLK-FORCEINSPECTOROPEN:TRUE\n';
    
   /* txtInvite += 'BEGIN:VTIMEZONE\n';
    txtInvite += 'TZID:America/Los_Angeles\n';
    txtInvite += 'BEGIN:STANDARD\n';
    txtInvite += 'DTSTART:'+exstartdate+'\n';
    txtInvite += 'TZOFFSETFROM:-0800\n';
    txtInvite += 'TZOFFSETTO:-0700\n';
    txtInvite += 'END:STANDARD\n';
   txtInvite += 'END:VTIMEZONE\n';*/
    txtInvite += 'BEGIN:VEVENT\n';                                                              
                 
    txtInvite += 'CLASS:PUBLIC\n';
    txtInvite += 'CREATED:'+extempdate+'\n';
     txtInvite += 'DESCRIPTION:'+exbody+'\n';
    txtInvite += 'DTEND:'+exenddate+'\n';                           
    txtInvite += 'DTSTAMP:'+extempdate+'\n';
    txtInvite += 'DTSTART:'+exstartdate+'\n';                              //yyyyMMddThhmmssZ''+String.valueOf(Crypto.getRandomLong())+'\n'; //
    txtInvite += 'LAST-MODIFIED:'+extempdate+'\n';
    txtInvite += 'LOCATION:'+exlocation+'\n';
    //txtInvite += 'ORGANIZER;SENT-BY="MAILTO:'+fromAddress+'":mailto:'+toAddress+'\n';
    //ORGANIZER;CN="Anja Schneider":mailto:aschneider@te.com
    txtInvite += 'PRIORITY:5\n';
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
    //txtInvite += 'X-MS-OLK-APPTSEQTIME:20141128T085902Z\n';
   // txtInvite += 'X-MS-OLK-AUTOFILLLOCATION:FALSE\n';
   // txtInvite += 'X-MS-OLK-CONFTYPE:0\n';
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
    
    public static string createdatetime(DateTime d)
     {
      // small change in code made by deepak basically what ever date am sending to outlook is going in GMT timezone so if we schedule the training 2AM then
      // when sending the request to outlook it go as 2AM GMT which is wroung so am subtracting or adding the hours based on time zone to over come this problem  
     
      
      TimeZone tz = UserInfo.getTimeZone();
     // datetime dts = datetime.newinstance(finalstring);
     Decimal actualoffset = tz.getOffset(d); // Code updated by Salesforce support for deployment deploy-1832
     Decimal hoursConversion = 1000*60*60;  // Code updated by Salesforce support for deployment deploy-1832
     Decimal doffset = actualoffset/hoursConversion;  // Code updated by Salesforce support for deployment deploy-1832
         
      d= d - (doffset)/24; // Code updated by Salesforce support for deployment deploy-1832
      String finalstring;  // Code updated by Salesforce support for deployment deploy-1832
      finalstring=String.valueof(d.year());   // Code updated by Salesforce support for deployment deploy-1832
      
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
     
   
}