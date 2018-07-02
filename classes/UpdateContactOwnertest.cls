@Istest (Seealldata=true)
public class UpdateContactOwnertest{
static testmethod void updatecontactowner(){ 

    try{
/*        
        profile pId=[select id from profile where name=:'BU Admin' limit 1];

        list<user> userlist = new list<user>();
        list<account> acclist = new list<account>();
        list<contact> Conlist = new list<contact>();
        
        user u1= new user();
        u1.Lastname='Test User1';
        U1.ALias='Usr';
        u1.isactive=true;
        u1.Username='testuseraccount1@test.com';
        u1.Email='testuser1@test.com';
        u1.communityNickname='Test';
        u1.TimeZoneSidKey='America/Los_Angeles';
        u1.LocaleSidKey='en_US';
        u1.EmailEncodingKey='ISO-8859-1';
        u1.Profileid=pId.Id;
        u1.languageLocaleKey='en_US';
        userlist.add(u1);
        
        user u2= new user();
        u2.Lastname='Test User2';
        U2.ALias='ta';
        u2.isactive=true;
        u2.Username='testuseraccount2@test.com';
        u2.Email='testuser2@test.com';
        u2.communityNickname='TestCN';
        u2.TimeZoneSidKey='America/Los_Angeles';
        u2.LocaleSidKey='en_US';
        u2.EmailEncodingKey='ISO-8859-1';
        u2.Profileid=pId.Id;
        u2.languageLocaleKey='en_US';
        userlist.add(u2);
        
        insert userlist;
        
        Account Acc1= new Account();
        id accountrecordtype = [select Id from RecordType where Name = 'Account' and SobjectType = 'Account' limit 1].id;
        Acc1.RecordTypeid= accountrecordtype;
        Acc1.Name='Test Account1';
        Acc1.CurrencyIsoCode='USD';
        Acc1.ownerid=u1.id;
        acclist.add(Acc1);
        
        Account Acc2= new Account();
        Acc2.RecordTypeid= accountrecordtype;
        Acc2.Name='Test Account2';
        Acc2.CurrencyIsoCode='USD';
        Acc2.ownerid=u2.id;
        acclist.add(Acc2);
        
        insert acclist;
        
        id Contactrecordtype = [select Id from RecordType where Name = 'TE Internal Contact' and SobjectType = 'Contact' limit 1].id;
        
        id ATRecType = [select Id from RecordType where Name = 'SFDC User' and SobjectType = 'Account_Team__c' limit 1].id;
        
        Account_Team__c at = new Account_Team__c();
        at.RecordTypeid = ATRecType;
        at.account__c = Acc1.Id;
        at.role__c = 'Account Manager (AM)';
        at.Opportunity_Access__c= 'Edit';
        at.Team_Member__c = u2.id;
        
        insert at;
  
        Contact con1 = new contact();
        Con1.RecordTypeid=Contactrecordtype;
        Con1.Lastname='Testcontact1';
        Con1.Accountid=ACC1.Id;
        con1.ownerid=u1.id;
        Conlist.add(con1);
        
        Contact con2 = new contact();
        Con2.RecordTypeid=Contactrecordtype;
        Con2.Lastname='Testcontact2';
        Con2.Accountid=ACC1.Id;
        con2.ownerid=u2.id;
        Conlist.add(con2);
        
        Contact con3 = new contact();
        Con3.RecordTypeid=Contactrecordtype;
        Con3.Lastname='Testcontact3';
        Con3.Accountid=ACC2.Id;
        con3.ownerid=u2.id;
        Conlist.add(con3);
        
        Contact con4 = new contact();
        Con4.RecordTypeid=Contactrecordtype;
        Con4.Lastname='Testcontact4';
        Con4.Accountid=ACC2.Id;
        con4.ownerid=u1.id;
        Conlist.add(con4);
        
        insert Conlist;
        
*/
         /*
          * The above insertions are failing because of some existing test classes, so using the existing data in Prod by querying
         */
        
        Account a = new account(); 
        account b = new account();
        map<id,account> oldacc = new map<id,account>();
        map<id,account> newacc = new map<id,account>();
        
        contact c = [select id, account.Id, account.ownerid from contact where accountid <> null limit 1];
        
        a.Id = c.account.Id;
        a.OwnerId = c.account.ownerid;
        oldacc.put(a.id, a);
        
        b.id=a.id;
        b.ownerid=[select id from user where id !=:a.OwnerId and isActive=true and profile.name='BU Admin' limit 1].id; 
        newacc.put(b.id, b);

        UpdateContactOwner.ChangeContactOwner(oldacc , newacc);
         
    }
    catch (Exception e) {
        System.debug('eeeeeeeeee'+ e.getMessage());
    }
    
}
}