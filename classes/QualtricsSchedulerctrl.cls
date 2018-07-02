/**
 * 
 * @purpose  Update Campaign and Campaign member Objects with Qualtrics Schedule Date,Qualtrics Schedule Reminder1,Qualtrics Schedule Reminder2 values given in "QualtricsScheduler" Visualforce page.
 * @author      Vigneshwar Kotha
 * @created     2017-03-16   
 * @version     1.0                                                                
 *   
 */ 

public class QualtricsSchedulerctrl {

    public campaign camp {get;set;}
    public list<Contact> ConList;
    public list<campaignMember> campMemberList;
    public boolean showAlert {get;set;}

    public QualtricsSchedulerctrl() {
        camp = new campaign ();
        /* passing id from vf page to camp */
        camp.Id = apexpages.currentpage().getparameters().get('campaignid');
        campMemberList = new list<campaignMember>();
        ConList= new list<Contact>();
         
    }
    /* Schedule method calls when click on Schedule button */
    public void schedule(){
    system.debug('in schedule function');
        for(campaignMember CM:[select id, Contactid, Contact.NPS_Language__C, Qualtrics_Schedule_Date__c,Qualtrics_Schedule_Reminder1__c,Qualtrics_Schedule_Reminder2__c,Qualtrics_Survey_Sent__c  
                                               from campaignMember 
                                               where campaignid = :camp.Id 
                                               and status='Sent'
                                              ]){
            system.debug('campagin mebers'+CM);
            CM.Qualtrics_Survey_Sent__c = true;
            CM.Qualtrics_Schedule_Date__c = camp.Qualtrics_Schedule_Date__c.addMinutes(1);
            CM.Qualtrics_Schedule_Reminder1__c=camp.Qualtrics_Schedule_Reminder1__c;
            CM.Qualtrics_Schedule_Reminder2__c=camp.Qualtrics_Schedule_Reminder2__c;
             CM.NPS_Language__c = CM.contact.NPS_Language__C;                     
            /* Adding field data into campMemberList */
            campMemberList.add(CM);
            
            //Adding Contacts to get them ready for survey
            ConList.add(new Contact(Id=CM.contactId, IND_Qualtrics_Survey_Taken__c=false));
        }
        try{
        /* Updating Campaign and Campaignmember values*/
            if(!campMemberList.isEmpty()){update camp; update campMemberList; showAlert=true; update ConList; }
        }Catch(Exception e){
        /*Catch the Exceptions*/
            Apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'Record Not Updated');
            Apexpages.addMessage(msg);
        }
         }
   
}