/**
*  This test class used to test Trigger updateLiveChatTransaction.
*
@author Subramanian J
@created 2017-11-27
@version 1.0   
@since 41.0
*
@changelog
* coverage 96% 
* 
* 
* - Created
*/
@isTest(seeAllData = true) 
private class UpdateCaseOwner_Test {

    static testMethod void myUnitTest() {
        test.startTest();  
        LiveChatVisitor lcv= new LiveChatVisitor();        
        insert lcv;
        
        List<LiveChatTranscript> lctlst = new List<LiveChatTranscript>();
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.Email_Address__c = 'TestEmailAddress@TestEmailAddress.com';
        lct.First_Name__c = 'Test First Name';
        lct.Last_Name__c = 'Test Last Name';
        lct.Subject__c = 'Test Subject';
        lct.LiveChatVisitorId = lcv.id;
        lctlst.add(lct); 
        
        LiveChatTranscript lct1 = new LiveChatTranscript();
        lct1.Email_Address__c = 'TestEmailAddress@TestEmailAddress.com';
        lct1.First_Name__c = 'Test First Name';
        lct1.Last_Name__c = 'Test Last Name';
        lct1.Subject__c = 'Test Subject';
        lct1.LiveChatVisitorId = lcv.id;
        lctlst.add(lct1);
                
        insert lctlst;
        
        Profile p = [Select Id, Name From Profile where Name = 'PIC Agents' limit 1];
        
        User u = new User();
        u.FirstName ='First';
        u.LastName = 'Last';
        u.username = 'livechattranscript2017@testuser.com';
        u.Email = 'livechattranscript2017@testuser.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'lct2017';
        u.IsActive = true;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        
        insert u;
                        
        List<LiveChatTranscriptEvent> lctelst = new List<LiveChatTranscriptEvent>();
        LiveChatTranscriptEvent lcte = new LiveChatTranscriptEvent();
        lcte.AgentId = u.id;
        lcte.Type = 'OperatorLeftConference';        
        lcte.LiveChatTranscriptId = lctlst[0].id;
        lcte.Time = system.now();
        lctelst.add(lcte);
        
        LiveChatTranscriptEvent lcte2 = new LiveChatTranscriptEvent();
        lcte2.AgentId = u.id;
        lcte2.Type = 'LeaveVisitor';        
        lcte2.LiveChatTranscriptId = lctlst[0].id;
        lcte2.Time = system.now();
        lctelst.add(lcte2);
              
        insert lctelst;        
        
        test.stopTest();
        
        List<LiveChatTranscriptEvent> lctelst2 = new List<LiveChatTranscriptEvent>();
        LiveChatTranscriptEvent lcte3 = new LiveChatTranscriptEvent();
        lcte3.AgentId = u.id;
        lcte3.Type = 'LeaveVisitor';        
        lcte3.LiveChatTranscriptId = lctlst[1].id;
        lcte3.Time = system.now();
        lctelst2.add(lcte3);
        
        LiveChatTranscriptEvent lcte4 = new LiveChatTranscriptEvent();
        lcte4.AgentId = u.id;
        lcte4.Type = 'Transfer';        
        lcte4.LiveChatTranscriptId = lctlst[1].id;
        lcte4.Time = system.now();
        lctelst2.add(lcte4);
        
        insert lctelst2;            
    }
}