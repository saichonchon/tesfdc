/**
 * 
 *   This batch class is used to Identify Emails that are attached to closed cases which are aged more than 180 days, as described in the requirement.
 * Please refer to project in teamup: 'C2S Archive and Delete Cases'
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
global class BatchCls_DeleteSObjects implements Database.Batchable<sObject> {
    
    global list<String> RecTypes;
    global list<String> toAddresses;
    global String Query;
    global String EmailBody;
    global date closedDate;
    //global Id tempid = '500E000000N77WXIAZ'; -srinath added to test trigger
    global BatchCls_DeleteSObjects(){
        try{
            //create the query here from custom settings
            Batch_Delete_Inputs__c CS = Batch_Delete_Inputs__c.getInstance('JOB1');
            
            toAddresses = new list<string>();
            string emailids = CS.Email_For_Notifications__c;
            if(emailids.contains(','))  toAddresses = emailids.split(',');
            else    toAddresses.add(emailids);
            
            EmailBody = CS.Email_Body_of_Report__c;
            integer age = Integer.valueOf(CS.Age_in_Days__c);
            integer removedays = age;
            if(removedays == null || removedays==0){ removedays = 180;  }
               
            //if (age>=removedays){    removedays = age;  }
            //srinath 07-13-2016 : added missed statement, negating the days & reviewed by Prabhanjan
            removedays = -1*removedays; 
            //building the query to get the caseid
            closedDate = date.today().addDays(removedays);
            Query='SELECT ID,PARENTID FROM EMAILMESSAGE WHERE PARENT.isClosed = True';
            
            // Prabhanjan: Adding isRunningTest as test data can not be built for cases older than 180 days. 
            // So, avoiding closedate for tests.
            if(!TEST.isRunningTest()) {
                Query= Query+' AND Day_only(parent.closeddate) <=:closedDate';
            }
            
            // adding the record types.
            /* if(CS.Parent_Record_Types__c.contains(',')){
                RecTypes = new list<String>();
                for(String rt:CS.Parent_Record_Types__c.split(',')){
                    Case_Record_Type_Groups__c CaseRT = Case_Record_Type_Groups__c.getInstance(rt);
                    RecTypes.add(CaseRT.RecordTypeID__c);
                } 
                //Query = Query+' AND Parent.RecordTypeId IN :RecTypes';
            } */
            //  Query = Query+' limit 10';
            
            //Query='SELECT ID,PARENTID FROM EMAILMESSAGE WHERE PARENTID =: tempid'; -srinath added to test trigger
            
        }
        catch(exception e){  
            EmailBody = e.getMessage() +' at '+e.getStackTraceString();
            EmailSender_Utility.EmailSender('Something Went Wrong With Case Email Deletion Batch...!!!', toAddresses, EmailBody);
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<SObject> scope){ 
           
        try{
            //srinath: making static boolean value to false, to bypass the "bucketAccountupdate" trigger while this batch is running
            StaticBooleanValue.checkflag = false;
                        
            list<Id> recordIds = new list<Id>(); 
            set<Id> caseids = new set<Id>();
            list<Case> Cases = new list<Case>();
            list<sObject> deleteEmails = new list<sObject>();
            
            //working the result to cases that are closed.
            for(sObject s:scope){
                string CaseId = String.valueOf(s.get('ParentId')); 
                
                //Emails can be assoicated to other objects as well. so filtering out the Cases records.
                if(CaseId.startsWith('500')){
                    if(!caseids.contains(CaseId)){
                        caseids.add(CaseId);
                        Cases.add(new Case(Id=CaseId, Emails_Have_Been_Archived_Deleted__c = True));
                    }
                    deleteEmails.add(s);
                    recordIds.add(String.valueOf(s.get('Id')));
                }
            }
            
            // hard deleting the objects and updating inbetween.
            Database.DeleteResult[] DList = Database.delete(deleteEmails, true);
            Database.SaveResult[] srList = database.update(Cases, false);
            Database.EmptyRecycleBinResult[] RecycleIds = Database.emptyRecycleBin(recordIds);
        }
        
        catch(exception e){  
            EmailBody = e.getMessage() +' at '+e.getStackTraceString();
            EmailSender_Utility.EmailSender('Something Went Wrong With Case Email Deletion Batch...!!!', toAddresses, EmailBody);
        }
    }
    
    global void finish(Database.BatchableContext BC){ 
        //Send an email to the User after your batch completes    
        EmailSender_Utility.EmailSender('Case Emails Have Been Achived..!!!', toAddresses, EmailBody); 
    }
}