public class Catchblocktest_Handler{

   public static void sendemail(String test){
   
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                //String[] toAddresses = new String[] {Userinfo.getuseremail()};
                //mail.setToAddresses(toAddresses);
                mail.setSaveAsActivity(false);
                mail.setTargetObjectId(Userinfo.getuserId());
                mail.setSubject('Accounts Update with sales hierarchies batch is failed due to ' + test);
                mail.setPlainTextBody(test);
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
   
   
   }

}