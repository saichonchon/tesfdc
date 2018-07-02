/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2014-10-10
@version 1.0   
@since 28.0
*
@changelog
* coverage 86% 
* 
* 
2014-10-10 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true) 
private class ClsCampaignMemberUtil_Test {

    static testMethod void myUnitTest() {
        
        set<String> set_compaignMembIds = new set<String>();    
        map<Id,String> map_conId_language= new map<Id,String>();
        map<Id,boolean> map_conId_optout= new map<Id,boolean>();
        map<Id,Id> map_conId_campaignId = new map<Id,Id>();           
        map<String, String> map_rtName_rtId = new map<String, String>();
        map<Id,String> map_camId_campaignName = new map<Id,String>();
        map<id,map<id,id>> map_campaignId_conId_memberId = new map<id,map<id,id>>();
        list<Contact> list_contacts = new list<Contact>();
        map<Id, Account> map_accId_Account = new map<Id, Account>();        
        
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'A&C';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0108';
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;
        
        Contact con = new Contact();
        for(Contact con1 : [select Campaign_Type__c, NPS_Result_Report__c, Id,AccountId,NPS_Language__c,Email,LastName,OwnerId,MailingCity,NPS_Score__c,MailingStreet,MailingCountry,MailingPostalCode ,Salutation ,Phone from Contact where  NPS_Score__c >= 0 and NPS_Score__c <= 6 and Campaign_Type__c = 'Industries' and email like '%te.com%' limit 1]){
            con = con1;
        }
        System.debug('****in test query con******'+con.id);
        if(con.Id == null){
            con.AccountId = acc.Id;
            con.NPS_Language__c = 'DE';
            con.Email = 'sdf@dsafj.com';
            con.LastName = 'Sand';
            con.OwnerId = UserInfo.getUserId();
            con.MailingCity = 'Musterstadt';
            con.MailingStreet = 'Teststr. 1';
            con.MailingCountry = 'Germany';
            con.MailingPostalCode = '77777';
            con.Salutation = 'Mr.';
            con.Phone = '12365478';  
            //con.Campaign_Type__c = 'Industries';           
            //con.NPS_Result_Report__c = 'test';
            insert con;
        }       
     
        //con.Campaign_Type__c = 'test';
        con.Campaign_Type__c = 'Industries'; 
        update con;
     
        Task task = new Task();
        task.Description = 'testwwww';
        task.WhoId = con.Id;
        task.OwnerId = UserInfo.getUserId();
        task.Subject = 'test';
        task.Detraction_Reason__c = 'Pricing;Quality';
        task.Status = 'In Progress';
        insert task;
        
        Task task1 = new Task();
        task1.Description = 'testwwww';
        task1.WhoId = con.Id;
        task1.OwnerId = UserInfo.getUserId();
        task1.Subject = 'test';
        task1.Detraction_Reason__c = 'Pricing;Quality';
        task1.Status = 'In Progress';
        insert task1;
     
        Survey__c survey = new Survey__c();
        survey.Name = 'henhao';
        insert survey;
        
        Campaign cam = new Campaign();
        cam.Name = 'nihao';
        cam.EndDate = date.today() + 5;
        cam.Survey__c = survey.Id;
        cam.Campaign_Type__c = 'TTI';
        cam.Survey_Date__c = date.today() - 15;
        cam.IsActive = true;
        insert cam;
        
        
        
        Campaign cam1 = new Campaign();
        cam1.Name = 'nihao';
        cam1.EndDate = date.today() + 5;
        cam1.Survey__c = survey.Id;
        cam1.Campaign_Type__c = 'Medical';
        cam1.IsActive = true;
        cam1.Survey_Date__c = date.today() - 15;
        insert cam1;
        
        Campaign cam2 = new Campaign();
        cam2.Name = 'nihao';
        cam2.EndDate = date.today() + 5;
        cam2.Survey__c = survey.Id;
        cam2.Campaign_Type__c = 'Industries';
        cam2.Survey_Date__c = date.today() - 15;
        cam2.IsActive = true;
        insert cam2;
        
        list<Answer__c> lstAnswer = new list<Answer__c> ();
        
        for(Question__c oQuestion :[select id, Name from Question__c where (name = '01. NPS Overall Score' or name =  '02. Engineering Responsiveness')and Survey__r.name = 'NPS Survey' ])
        {
            if(oQuestion.name == '01. NPS Overall Score')
                lstAnswer.add(new Answer__c(Campaign__c = cam2.id, Contact__c = con.id, Question__c = oQuestion.id, Current__c = true, Answer__c = '10'));
            if(oQuestion.name == '02. Engineering Responsiveness')            
                lstAnswer.add(new Answer__c(Campaign__c = cam2.id, Contact__c = con.id, Question__c = oQuestion.id, Current__c = true, Answer__c = '0'));
        }
            insert lstAnswer ;
        
        Campaign cam3 = new Campaign();
        cam3.Name = 'nihao';
        cam3.Campaign_Type__c = 'Appliance';
        cam3.EndDate = date.today() + 5;
        cam3.Survey__c = survey.Id;
        cam3.Survey_Date__c = date.today() - 15;
        insert cam3;
        
        CampaignMember cm = new CampaignMember();
        cm.ContactId = con.Id;
        cm.CampaignId = cam.Id;
        cm.Status = 'Sent';
        
        insert cm;
        
        CampaignMember cm1 = new CampaignMember();
        cm1.ContactId = con.Id;
        cm1.CampaignId = cam1.Id;
        cm1.Status = 'Sent';
        insert cm1;
        
        CampaignMember cm2 = new CampaignMember();
        cm2.ContactId = con.Id;
        cm2.CampaignId = cam2.Id;
        cm2.Status = 'Sent';
        insert cm2;
        
        CampaignMember cm3 = new CampaignMember();
        cm3.ContactId = con.Id;
        cm3.CampaignId = cam3.Id;
        cm3.Status = 'Sent';
        insert cm3;
        
        for(RecordType recordType : [Select Name, Id 
                                 From RecordType 
                                 where SobjectType = 'Task' 
                                 and (Name='NPS Task Appliances' or Name='NPS Task Industrial')]) {
            map_rtName_rtId.put(recordType.Name, recordType.Id);
        } 
        
        NPS_Settings__c nps2 = new NPS_Settings__c();
        
        for(NPS_Settings__c nps : [select Id, Value__c, Is_Active__c from NPS_Settings__c where Name = 'TTI Task Owner' limit 1]){
            nps2 = nps;
        }
        String NPSettingReason = 'testreason@test.com';     

        if(nps2.Id == null){
            nps2.Name = 'TTI Task Owner';
            nps2.Is_Active__c = true;
            nps2.Value__c = UserInfo.getUserId();
            insert nps2;
        }       
        
        set_compaignMembIds.add(cm.Id);
        set_compaignMembIds.add(cm1.Id);
        set_compaignMembIds.add(cm2.Id);
        set_compaignMembIds.add(cm3.Id);
        
        map_conId_language.put(cm.ContactId,cm.NPS_Language__c);
        map_conId_campaignId.put(cm.ContactId,cm.CampaignId);
        
        if(!map_campaignId_conId_memberId.containsKey(cm.CampaignId)){
            map_campaignId_conId_memberId.put(cm.CampaignId,new map<id,id>());
        }
        map_campaignId_conId_memberId.get(cm.CampaignId).put(cm.ContactId,cm.Id);
        
        ClsCampaignMemberUtil.TypeBase typeBase = new ClsCampaignMemberUtil.TypeBase();
        
        //added by <nooreen.i@zensar.in>
        map<String, Task> map_Id_task = new map<String, Task>();
        map_Id_task.put(task.Id, task);
        set<String> set_contactIds = new set<String>();
        set_contactIds.add(con.Id);       
        map<String, Contact> map_conId_Contact = new map<String, Contact>();
        map_conId_Contact.put(con.Id,con);
        map<String, set<String>> map_taskId_set_Emails = new map<String, set<String>>();
        map_taskId_set_Emails.put(task.Id, new set<string>{'test@test.com'});
        map<String, Contact> map_taskId_contact = new map<String, Contact>();              
        map_taskId_contact.put(task.Id,map_conId_Contact.get(task.whoId));             
                
        Test.startTest();
        ClsCampaignMemberUtil.setContactTask(map_conId_optout, map_conId_language, map_conId_campaignId, set_compaignMembIds, map_rtName_rtId );
        ClsCampaignMemberUtil.setMapType(set_compaignMembIds, typeBase);
        ClsCampaignMemberUtil.getStringTTITaskOwnerd();
        ClsCampaignMemberUtil.setMapCampaign(map_conId_campaignId, map_camId_campaignName);
        ClsCampaignMemberUtil.getListContact(map_rtName_rtId, map_conId_language, map_conId_optout, typeBase, map_conId_campaignId, map_camId_campaignName);
        
        map_accId_Account.put(acc.Id, acc); 
        map_camId_campaignName.put(cam.Id, cam.Name);
        ClsCampaignMemberUtil.NPSMedicalData NPSMedicalData = new ClsCampaignMemberUtil.NPSMedicalData(con.NPS_Result_Report__c, 'test', con.Id, UserInfo.getUserId(), map_conId_campaignId, map_camId_campaignName, map_rtName_rtId);  
        ClsCampaignMemberUtil.NPSMedicalData NPSMedicalData2 = new ClsCampaignMemberUtil.NPSMedicalData();  
        
        NPSMedicalData.owner = UserInfo.getUserId();
        ClsCampaignMemberUtil.createMedicalTask(NPSMedicalData);
        
        ClsCampaignMemberUtil.NPSMedicalData NPSMedicalData1 = new ClsCampaignMemberUtil.NPSMedicalData(con.NPS_Result_Report__c, 'test', con.Id, UserInfo.getUserId(), map_conId_campaignId, map_camId_campaignName, map_rtName_rtId); 
        NPSMedicalData1.owner = null;
        ClsCampaignMemberUtil.createMedicalTask(NPSMedicalData1);
        
        ClsCampaignMemberUtil.NPSApplINDData NPSApplINDData2 = new ClsCampaignMemberUtil.NPSApplINDData();  
        
        ClsCampaignMemberUtil.NPSApplINDData NPSApplINDData = new ClsCampaignMemberUtil.NPSApplINDData(con.NPS_Result_Report__c, 'test', con.Id, UserInfo.getUserId(), map_conId_campaignId, map_camId_campaignName, map_rtName_rtId);  
        NPSApplINDData.score = 4;
        NPSApplINDData.map_accId_Account = map_accId_Account;
        NPSApplINDData.accountId = con.accountId;
        ClsCampaignMemberUtil.createApplINDTask(NPSApplINDData, typeBase.set_TTIType);
   
        ClsCampaignMemberUtil.NPSTTIData NPSTTIData = new ClsCampaignMemberUtil.NPSTTIData(con.NPS_Result_Report__c, 'test', con.Id, UserInfo.getUserId(), map_conId_campaignId, map_camId_campaignName, map_rtName_rtId);        
        ClsCampaignMemberUtil.NPSTTIData NPSTTIData1 = new ClsCampaignMemberUtil.NPSTTIData();        
        
        ClsCampaignMemberUtil.TypeBase typeBase2 = new ClsCampaignMemberUtil.TypeBase(new set<String>(), new set<String>(), new set<String>(), new set<String>());
        
        ClsCampaignMemberUtil.updateContact(map_campaignId_conId_memberId);
        
        list_contacts.add(con);
        
        ClsCampaignMemberUtil.TypeBase typeBase1 = new ClsCampaignMemberUtil.TypeBase();
        typeBase1.set_medicalType.add(con.Id);
        ClsCampaignMemberUtil.createTask(typeBase1, map_rtName_rtId, map_accId_Account, list_contacts, map_conId_campaignId, map_camId_campaignName);       
        
        ClsCampaignMemberUtil.TypeBase typeBase3 = new ClsCampaignMemberUtil.TypeBase();
        typeBase3.set_industriesType.add(con.Id);
        ClsCampaignMemberUtil.createTask(typeBase3, map_rtName_rtId, map_accId_Account, list_contacts, map_conId_campaignId, map_camId_campaignName);             
         
        //changes by <nooreen.i@zensar.in> 
        ClsCampaignMemberUtil.NPSTTIData NPSTTIDataOne  = new ClsCampaignMemberUtil.NPSTTIData(con.NPS_Result_Report__c, 'test', con.Id, UserInfo.getUserId(), map_conId_campaignId, map_camId_campaignName, map_rtName_rtId); 
        ClsCampaignMemberUtil.createTTITask(NPSTTIDataOne);  
         
        ClsCampaignMemberUtil.TypeBase typeBase4 = new ClsCampaignMemberUtil.TypeBase();
        typeBase4.set_TTIType.add(con.Id);
        ClsCampaignMemberUtil.createTask(typeBase4, map_rtName_rtId, map_accId_Account, list_contacts, map_conId_campaignId, map_camId_campaignName);       
                
        ClsCampaignMemberUtil.sentDetractorEmail(map_Id_task, set_contactIds);
        ClsCampaignMemberUtil.getEmailAsReason(NPSettingReason);    
        ClsCampaignMemberUtil.setDetractionReasonEmail(map_Id_task,map_taskId_set_Emails,map_taskId_contact);
              
        ClsCampaignMemberUtil.NPSApplINDData NPSApplINDData1 = new ClsCampaignMemberUtil.NPSApplINDData(con.NPS_Result_Report__c, 'test', con.Id, UserInfo.getUserId(), map_conId_campaignId, map_camId_campaignName, map_rtName_rtId); 
        NPSApplINDData1.score = 5;
        con.accountId = acc.Id;
        NPSApplINDData1.map_accId_Account = map_accId_Account;
        NPSApplINDData1.accountId = con.accountId;
        ClsCampaignMemberUtil.createApplINDTask(NPSApplINDData1, typeBase.set_TTIType);
        // changes end
        
        Test.stopTest();
    }
}