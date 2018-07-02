/**
 * 
 * @purpose  REST API calls from C2S to Qualtrics to create reminders in Qualtrics.
 * @author      Vigneshwar Kotha
 * @created     2017-05-04   
 * @version     1.0 
 * @Deployment numbers :1934,1955                                                               
 *   
 */ 
@isTest
Public class TestQualtricsEmailDistribution {
    Public static testMethod void testCallout() {
        Contact con=new contact();
        con.LastName='vignesh';
        insert con;
        List<Qualtrics_Project__c> qplist=new List<Qualtrics_Project__c>(); 
        for(integer k=0;k<10;k++){
        Qualtrics_Project__c qp=new Qualtrics_Project__c();
        qp.From_Email__c = 'vigensh@test.com';
        qp.From_Name__c = 'vignesh';
        qp.Library_ID__c='hi123';
        qp.Message_Id__c='hi123';
        qp.Qualtrics_User_Id__c='vigensh@test.com';
        qp.Subject__c='test';
        qp.Survey_ID__c='hii123';
        qp.Token__c='hii123';
        qplist.add(qp);
           }
         insert qplist;
        List<Campaign> camplst=new List<Campaign>();
        for(integer j=0;j<10;j++){
        Campaign c=new Campaign();
        c.Name='test';
        c.Qualtrics_Schedule_Date__c=datetime.now();
        c.Qualtrics_Schedule_Reminder1__c=datetime.now();
        c.Qualtrics_Schedule_Reminder2__c=datetime.now();
        c.Qualtrics_Project__c = qplist[0].id;
        camplst.add(c);
        }
        insert camplst;
        list<id> idslst = new list<id>();
        for(Campaign cag:camplst){
        idslst.add(cag.Id);
        }
        Qualtrics_Endpoint__c qep = Qualtrics_Endpoint__c.getValues('endpoint');
        if(qep == null) {
        qep = new Qualtrics_Endpoint__c(name='endpoint');
        qep.url__c='https://survey.qualtrics.com//WRAPI/ControlPanel/api.php?API_SELECT=ControlPanel&Version=2.5';
        insert qep;
        }
        Test.setMock(HttpCalloutMock.class, new FakeResponse());  
       QualtricsEmailDistribution.getCampaignid(idslst);
       //String reqBody =QualtricsEmailDistribution.MakeRestCalloutEmail(idslst);
      
      /*  for(Integer i=0;i<=qplist.size();i++){
             QualtricsEmailSchedule qes = new QualtricsEmailSchedule();
            qes.MakeRestCallout('a1',String.valueOf(camplst[i].Qualtrics_Schedule_Reminder1__c),qplist[i].From_Email__c,qplist[i].From_Name__c,qplist[i].Library_ID__c,qplist[i].Message_Id__c,qplist[i].Qualtrics_User_Id__c,qplist[i].Subject__c,qplist[i].Survey_ID__c,qplist[i].Token__c); 
        
        }*/
       
     }
}