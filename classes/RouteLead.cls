Public class RouteLead  {
//constructor
Public RouteLead() {
 
}


public static void Leadrouter(List <string> LeadIds){
     
    // var to store reason the queue was chosen
    String Queue_Message='';
    // get the list to test for matches
    List <Lead> leads = [SELECT email, Type_of_company__c,  industry, id, Queue_Reason__c, STATUS_REASON_CODE__c, STATUS_REASON__c  FROM Lead WHERE id in :LeadIds];
    //What is the default user  id  for "TEIS Admin"
    User teaU = [SELECT Id FROM User WHERE Name ='TEIS Admin' limit 1];   
    String TEISadmin = teaU.ID;
            
    
    String QueueID=''; 
        // Loop through all the leads passed in 
    for(Lead LeadList:leads) {
        if(LeadList.Type_of_company__c == Null ) {
           LeadList.Type_of_company__c = '';    
        }
        if(! LeadList.Type_of_company__c.contains('Distributor')){
        
            QueueID = doqueue(LeadList);
            // is there match(s) for email in contacts that have accounts linked 
            if(QueueID !='REJECT'){        
                List <Contact>  ContactList = [SELECT ID,AccountID FROM Contact WHERE  Email=:LeadList.email AND AccountID != Null AND account.OwnerID != :TEISadmin AND email!= Null AND email!='' ];
                Integer contactcount = ContactList.size();
                System.debug(Logginglevel.INFO,  '******* contacts count ******'+contactcount); 
                System.debug(Logginglevel.INFO,  '******* Queue id ******'+QueueID); 
                System.debug(Logginglevel.INFO,  '******* TEISadmin ******'+TEISadmin); 
                System.debug(Logginglevel.INFO,  '******* Email ******'+LeadList.email);
                System.debug(Logginglevel.INFO,  '******* contacts ******'+ContactList);
                System.debug(Logginglevel.INFO, 'SELECT AccountID,email,account.OwnerID FROM Contact WHERE  account.OwnerID !=\''+teaU.ID+'\'');
                
                if(contactcount == 0 ) {
                    LeadList.Queue_Reason__c='No Contacts Were found with a matching Email Address in the Lead';
                    LeadList.OwnerId=QueueID; 
                }            
                if(contactcount > 1){
                    LeadList.Queue_Reason__c='More than One Contact was found with the Email Address in the Lead';
                    LeadList.OwnerId=QueueID; 
                } 
                if(contactcount == 1) {
                    // the account must not be owned by the teis admin and the contact email must match the lead  and the account must be the right recordtype(s)
                    LeadList.Queue_Reason__c='Contact email and account match';
                    Contact C =[SELECT account.OwnerID FROM Contact WHERE AccountID != null AND email=:LeadList.email AND account.OwnerID != :TEISadmin AND email!= Null AND email!='' limit 1];
                    Integer  AccCnt = [SELECT Count() FROM Account A where A.Id=:C.AccountID AND A.RecordType.DeveloperName IN('CIS_Account','CIS_Prospect')];
                    if(AccCnt== 1){ 
                        user Usr = [SELECT name,email,Te_Network_Id__c FROM User WHERE ID = :C.account.OwnerID];
                        LeadList.ASSIGNEE_NETWORK_ID__c=Usr.Te_Network_Id__c;
                        LeadList.ASSIGNEE_EMAIL__c=Usr.email;
                        LeadList.ASSIGNEE_Name__c=Usr.name;
                        LeadList.OwnerId=C.account.OwnerID;
                        LeadList.Status='Assigned';
                    }
                  } 
            }else {
                LeadList.Status='Rejected';
                LeadList.STATUS_REASON_CODE__c='This Lead does not belong to my business unit.';
                LeadList.STATUS_REASON__c='This Lead does not belong to my business unit.';


            }
        } else {
                LeadList.Status='Rejected';
                LeadList.STATUS_REASON_CODE__c='This Lead does not belong to my business unit.';
                LeadList.STATUS_REASON__c='This Lead should belong to Channel business unit.';

        }
    }     
   
    // update the leads to route
    update leads;
}

public static string doqueue(Lead LeadList) {
string Qid='REJECT';




//get the Queue Ids for Queue assignments
List <Group> groups  = [SELECT name, Id FROM group WHERE type ='Queue']; 
 List <Lead_Routing_key__c> Settings = [SELECT Keyword__c, Queue_Name__c FROM Lead_Routing_key__c WHERE Active__c = True];
         
    // set the Queue Id for the lead based on industry filters
    // Note theese loops are sensitive to Queue name changes
    // loop through the filters
    for (Lead_Routing_key__c LeadRoutingKey : Settings ) {
        // loop through the queue records
        for(group Q :groups) {      
           if(LeadList.industry != Null) { 
           //do lowercase compaire on keywords
                   string Indval = LeadList.industry.toLowerCase();
                   string LrKey = LeadRoutingKey.Keyword__c.toLowerCase();
                   //if keyword is contained in the Industry string set the Qid to the Queue user Id
                   if(Indval.contains(LrKey)){
                   if(Q.name == LeadRoutingKey.Queue_Name__c ){
                       Qid = Q.Id;
                   }
               }
           }
       }
    }  
Return Qid;
}
// Test Methods
@IsTest(SeeAllData=true)
Static void RouteLeadTest1() {

Account testaccount;
Contact testcontact;
Lead testlead;        

List <Lead_Routing_key__c> Settings1 = [SELECT Keyword__c, Queue_Name__c FROM Lead_Routing_key__c WHERE Active__c = True];
    test.starttest();

    testaccount = ClsTestHelp.createTestAccounts();
    testaccount.Name = 'Test TE Account';
    testaccount.AnnualRevenue = 123456.01;
    testaccount.Legally_Restricted__c = false;
    testaccount.BillingCity = 'Middletown';
    testaccount.BillingCountry = 'USA';
    testaccount.BillingState = 'PA';
    testaccount.BillingStreet = '2800 Fulling Mill Road';
    testaccount.BillingPostalCode = '17057';

    insert testaccount;

    testcontact = ClsTestHelp.createTestContacts();
    testcontact.AccountId = testaccount.Id;
    testcontact.FirstName = 'Jasmine';
    testcontact.LastName = 'Ver';
    testcontact.Legally_Restricted__c = false;
    testcontact.Email = 'jasmine.ver@test.com';
    
    insert testcontact;

    for (Lead_Routing_key__c setting : Settings1) {
        testlead = new lead();
        testlead.lastname='Tester';
        testlead.firstName='Unit';
        testlead.company ='TEIS';
        testlead.Status = 'Assigned Unaccepted';  
        testlead.Rating = 'Hot'; 
        
        testlead.country='United States';
        testlead.email= testcontact.Email; //use created contact email instead of 'les.balamut@mouser.com';
        testlead.description='unit test ignore';
        testlead.Type_of_company__c='testrecord';
        testlead.CUSTOMER_CONTACTED__C=False;
        //testlead.DATE_QUALIFIED__C='2012-05-01';
        testlead.Industry=setting.Keyword__c ;
        testlead.LEADSOURCE='LDAP';
        testlead.phone='+1 1231231234';
        testlead.STATE='PA';
        //insert the test lead to fire the trigger
       
   // insert testlead;
   
        //call constructor
        RouteLead cls = new RouteLead() ;

        }

        test.stoptest();
       
}

@IsTest(SeeAllData=true)
Static void RouteLeadTest3() {
Lead testlead = new lead();
testlead.lastname='Tester3';
testlead.firstName='Unit';
testlead.company ='TEIS3';
testlead.Status = 'Assigned Unaccepted';  
testlead.Rating = 'Hot'; 

testlead.country='United States';
testlead.email='bad@em.com';
testlead.description='unit test ignore';
testlead.CUSTOMER_CONTACTED__C=False;
testlead.Industry='noind';
testlead.LEADSOURCE='LDAP';
testlead.phone='+1 1231231234';
testlead.STATE='PA';
testlead.Type_of_company__c='OEM';
test.starttest();

// insert a set of leads

   // insert testlead;

test.stoptest();
}




@IsTest(SeeAllData=true)
Static void RouteLeadTest4() {
Lead testlead = new lead();
testlead.lastname='Tester4';
testlead.firstName='Unit';
testlead.company ='TEIS4';
testlead.Status = 'Assigned Unaccepted';  
testlead.Rating = 'Hot'; 

testlead.country='United States';
testlead.email='bad@em.com';
testlead.description='unit test ignore';
testlead.CUSTOMER_CONTACTED__C=False;
testlead.Industry='Industrial';
testlead.LEADSOURCE='LDAP';
testlead.phone='+1 1231231234';
testlead.STATE='PA';
testlead.Type_of_company__c='OEM';
test.starttest();

// insert a set of leads

   // insert testlead;

// call the local static method with the  lead id you inserted
//Leadrouter(List <string> LeadIds){
test.stoptest();
}

@IsTest(SeeAllData=true)
Static void RouteLeadTest5() {
Lead testlead = new lead();
testlead.lastname='Tester5';
testlead.firstName='Unit';
testlead.company ='TEIS5';
testlead.Status = 'Assigned Unaccepted';  
testlead.Rating = 'Hot'; 

testlead.country='United States';
testlead.email='tester@test5.com';
testlead.description='unit test ignore';
testlead.CUSTOMER_CONTACTED__C=False;
testlead.Industry='Industrial';
testlead.LEADSOURCE='LDAP';
testlead.phone='+1 1231231234';
testlead.STATE='PA';
testlead.Type_of_company__c='Distributor';
test.starttest();

// insert a set of leads

    //insert testlead;

// call the local static method with the  lead id you inserted
//Leadrouter(List <string> LeadIds){
test.stoptest();
}



@IsTest(SeeAllData=true)
Static void RouteLeadTest6() {
Lead testlead = new lead();
testlead.lastname='Tester6';
testlead.firstName='Unit';
testlead.company ='TEIS6';
testlead.Status = 'Assigned Unaccepted';  
testlead.Rating = 'Hot'; 

testlead.country='United States';
testlead.email='tester@test6.com';
testlead.description='unit test ignore';
testlead.CUSTOMER_CONTACTED__C=False;
testlead.Industry='Industrial';
testlead.LEADSOURCE='LDAP';
testlead.phone='+1 1231231234';
testlead.STATE='PA';
test.starttest();

// insert a set of leads
    //insert testlead;


// call the local static method with the  lead id you inserted
//Leadrouter(List <string> LeadIds){
test.stoptest();
}
}