/** 
*  Batch class for Sending the mail to MytoDo App Users
*
@author Deepak Kumar (deepak.kumar89@te.com)
@created 3rd Aug 2016 
@version 1.0
@since 37.0 (Force.com ApiVersion)
*
 To execute the batch:--- Id batjobId = Database.executeBatch(new INDBatch_MytoDoEmailClassCall(),50);

For deleting the schedule job need to add code to developer console.
CronTrigger ct = [select id, NextFireTime from CronTrigger where Id = '08e22000000aTikAAE'];
 Delete the schedule job
System.abortJob(ct.id); 

select Id, NextFireTime,CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType from CronTrigger where CronJobDetail.JobType ='7'

*/
global class INDBatch_MytoDoEmailClassCall implements Database.Batchable<sObject>, Database.stateful{
  public String query;
 // Public Map<id,User> map_idfinal = new Map<id,User>();
  //public set<id> usrid= new set<id>();
 Public List<String> Emailbodyforadmin = new List<string>();
 

 Public String[] Toaddress= new String[]{}; 
 

 
// Quering for the Users

       global INDBatch_MytoDoEmailClassCall()
        {
          for(IND_MYTODO_App__c pq: IND_MYTODO_App__c.getall().values())
           {
             If(pq.Active__c==true)
              {
               Toaddress.add(pq.Email_Address__c);
              }
             
           }
         
         
        }

      
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
       
        if(query == null || query == ''){            
            query = 'select id,Email,LastName,Name,Firstname from user where IsActive=true AND Profile.Name IN (\'Industrial Engineering User w/Cost\',\'Industrial Standard User\',\'Industrial User w/ Cost\') ';
                
               // query +=' LIMIT 20 ';
        }
        // Added by Deepak for Test Class 'INDBatch_MytoDoEmailClassCall_Test'
       if(!Test.isRunningTest())
          
          query +=  'AND LastLoginDate <LAST_N_DAYS:14 ';  
       else
           query += 'AND Alias = \'SF\' limit 5';
            
            return Database.getQueryLocator(query);
      //AND LastLoginDate <NEXT_N_DAYS:14 LIMIT 10';
    }
    
    global void execute(Database.BatchableContext BC, list<User> list_User){ 
      
           IND_MyToDoReminderEmailClass emailcont = new IND_MyToDoReminderEmailClass();
           
           Emailbodyforadmin.add(emailcont.execute(list_User));
   
    
    }      
 //******************************************************************** End of code to Send email****************************************************************************          
  
    global void finish(Database.BatchableContext BC){
    
    //user admin = [ select id,email from user where id=:usercreatedId];
    
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

    string [] toaddres=Toaddress;
    
   

    //String[] ccAddresses=new String[]{'gundepogu.nancy@te.com'};

    email.setSubject(' Admin Summary of MyToDo App Notification');
    
    String topBody='Dear Admin,<br/><br/>Below are the MytoDo email fuctionality trigger summary for all user\'s pending Items:<br/><br/> ';
    
     for(string str:Emailbodyforadmin)
      {
        topBody+=Str+'<br/>';
        
      
      }

    email.setHtmlBody(topBody + '<br/> <br/>Sincerely,<br/>Industrial BU Admin<br/><br/>Date :'+string.valueof(system.today()));

    email.setToAddresses(toaddres);
   
    //email.setCcAddresses(ccAddresses);

    Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});
      
}
}