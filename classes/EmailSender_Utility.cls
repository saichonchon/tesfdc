/**
 * 
 *   This is a common utility for sending the emails. 
 *
 * @author      Prabhanjan Nandyala
 * @created     2016-03-07
 * @since      36.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2016-03-07 Prabhanjan Nandyala <prabhanjan.nandyala@te.com>
 * - Created
 *    
 */
public class EmailSender_Utility {
    public static void EmailSender(string subject, list<string> toAddresses, string body ){ 
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
        mail.setToAddresses(toAddresses);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}