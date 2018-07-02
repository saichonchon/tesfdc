@isTest(seeAllData=false)
public class TestEventandExhibitionController {
	
	static testMethod void TestEventandExhibitionController () { 
    	profile profile = [select Id from Profile limit 1];
                             
        User user = new User(
	        Username = 'klmn@jktech.com',
	        Email = 'abc@jktech.com',
	        LastName = 'xyz@jktech.com',
	        Alias = 'test',
	        CommunityNickname='TestTrigger',
	        ProfileID = profile.id,
	        LocaleSidKey = 'en_US',
	        LanguageLocaleKey = 'en_US',
	        TimeZoneSidKey = 'America/Los_Angeles',
	        EmailEncodingKey='UTF-8'
        );              
        insert user;
        
		Events_Exhibitions__c Eve= new Events_Exhibitions__c();
		Eve.Literature__c=Eve.id;
		insert Eve;
			   
		EventModules__c evemod= new EventModules__c();
		evemod.Events_Exhibitions__c=Eve.id;
		evemod.Module_Name__c='General Information';
		insert evemod;
		
		Blob file=Blob.valueOf('Unit Test Attachment Body');

		attachment attrecords= new attachment();
        attrecords.ParentId=evemod.id;
        attrecords.name='test';
        attrecords.name = 'General Information';
        attrecords.ContentType = 'Attachment';
        attrecords.body = file;
        insert  attrecords; 
   
		Task t = new Task();
        t.subject='test123';        
        //t.WhatId=accObj.id;
        t.ActivityDate=Date.Today();
        t.Status='Not Started';
        t.Priority='Normal';
        t.ownerid=user.id;
        t.whatid=evemod.id;
        insert t; 
        
        ApexPages.currentPage().getParameters().put('id', Eve.Id);
        ApexPages.StandardController controller=new ApexPages.StandardController(Eve);
        EventandExhibitionController Event=new EventandExhibitionController(controller);
        Event.file = file;
        Event.getcontent();
        Event.getTaskGeneral();
        Event.getTaskGeneral1();
        Event.getTaskGeneral2();
        Event.getTaskGeneral3();
        Event.getTaskGeneral4();
        Event.getTaskGeneral5();
        Event.getTaskGeneral6();
        Event.getTaskGeneral7();
        Event.getAttachGeneral();
        Event.getProspects();
        Event.getBooth();
        Event.getSamples();
        Event.getLiterature();
        Event.getGiveaways();
        Event.getReport();
        Event.getOther();
        
        Event.go();  
        Event.go1(); 
        Event.go2(); 
        Event.go3(); 
        Event.go4(); 
        Event.go5(); 
        Event.go6();
        Event.go7();
        
        Event.edit();
        Event.edit1();
        Event.edit2();
        Event.edit3();
        Event.edit4();
        Event.edit5();
        Event.edit6();
        Event.edit7();
        
        Event.NewTask();
        Event.NewTask1(); 
        Event.NewTask2(); 
        Event.NewTask3(); 
        Event.NewTask4(); 
        Event.NewTask5(); 
        Event.NewTask6(); 
        Event.NewTask7();
	}
	
}