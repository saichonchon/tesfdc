/**
*   Contains a set of static methods used in Campaign Member
*
@author Lili Zhao
@created 2014-09-28
@version 1.0
@since 29.0 (Force.com ApiVersion)
*
@changelog
* 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
* - Created  
*/ 
public class ClsCampaignMemberUtil {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final String APPLIANCES = 'Appliances';
    public static final map<String, String> map_industry_setting = new Map<String, String>{
        'Rail' => 'Rail Business Leader',
        'Solar' => 'Solar Business Leader',
        'A&C' => 'A&C Business Leader',
        'IB' => 'IB Business Leader',
        'Medical' => 'Medical Business Leader'
    };
    
    public static final map<decimal, String> MAP_SCORE_SCORESETTING = new map<decimal, String>{
        0 => 'Score_0__c', 1 => 'Score_1_4__c', 2 => 'Score_1_4__c', 3 => 'Score_1_4__c', 
        4 => 'Score_1_4__c', 5 => 'Score_5_6__c', 6 => 'Score_5_6__c'
    };
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- ********************************
    
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setContactTask(map<Id,boolean> map_conId_optout, map<Id,String> map_conId_language, map<Id,Id> map_conId_campaignId, set<String> set_compaignMembIds, map<String, String> map_rtName_rtId) {
        set<String> set_TTIType = new set<String>();
        set<String> set_industriesType = new set<String>();
        set<String> set_applianceType = new set<String>();
        set<String> set_medicalType = new set<String>(); 
        
        TypeBase typeBase = new TypeBase();
        
        map<Id,String> map_camId_campaignName = new map<Id,String>();
    
        if(!map_conId_campaignId.isEmpty()){
            
            // set the map map_camId_campaignName as the contact Id
            ClsCampaignMemberUtil.setMapCampaign(map_conId_campaignId, map_camId_campaignName);
        }
        
        //query to get compain name and survey name
        if(!set_compaignMembIds.isEmpty()) {
            // set the map of set_TTIType, set_industriesType, set_applianceType, set_medicalType as Campaign_Type__c
            ClsCampaignMemberUtil.setMapType(set_compaignMembIds, typeBase);
        }
        if(!map_conId_language.isEmpty() || !map_conId_optout.isEmpty()){
            ClsCampaignMemberUtil.getListContact(map_rtName_rtId, map_conId_language, map_conId_optout, typeBase, map_conId_campaignId, map_camId_campaignName);                
        }
    }
    
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setMapType(set<String> set_compaignMembIds, TypeBase typeBase) {
        for(CampaignMember cm : [Select Id, CampaignId, Campaign.Campaign_Type__c, ContactId  
                                 From CampaignMember
                                 Where Id in : set_compaignMembIds]) {
           if(cm.Campaign.Campaign_Type__c == 'TTI') {
                typeBase.set_TTIType.add(cm.ContactId);
            }else if(cm.Campaign.Campaign_Type__c == 'Medical') {
                typeBase.set_medicalType.add(cm.ContactId);
            }else if(cm.Campaign.Campaign_Type__c == 'Industries') {
                typeBase.set_industriesType.add(cm.ContactId);
            }else if(cm.Campaign.Campaign_Type__c == 'Appliance') {
                typeBase.set_applianceType.add(cm.ContactId);
            }                  
        }        
                   
    }
    
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getStringTTITaskOwnerd() {
        String str_TTITaskOwnerd = '';
        if(NPS_Settings__c.getInstance('TTI Task Owner') != null && NPS_Settings__c.getInstance('TTI Task Owner').Is_Active__c != false && NPS_Settings__c.getInstance('TTI Task Owner').Value__c != null && NPS_Settings__c.getInstance('TTI Task Owner').Value__c != '') {
            str_TTITaskOwnerd = NPS_Settings__c.getInstance('TTI Task Owner').Value__c;
        }
        return str_TTITaskOwnerd;
    }
    
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void setMapCampaign(map<Id,Id> map_conId_campaignId, map<Id,String> map_camId_campaignName) {
        for(Campaign c: [select id,name from Campaign where id in: map_conId_campaignId.values()]){
            map_camId_campaignName.put(c.Id,c.name);
        }
    }
    
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getListContact(map<String, String> map_rtName_rtId, map<Id,String> map_conId_language, map<Id,boolean> map_conId_optout, TypeBase typeBase, map<Id,Id> map_conId_campaignId, map<Id,String> map_camId_campaignName) {
        
        list<Contact> list_contacts = new list<Contact>();
        list<Contact> list_updateContacts = new list<Contact>();
        list<Contact> list_passContacts = new list<Contact>();
        map<Id, Account> map_accId_Account = new map<Id, Account>();
        for(Contact con: [SELECT id,NPS_OPT_OUT__c,NPS_Contact__c, Survey_Attended_Date__c, NPS_Language__c,Salutation, NPS_Score__c, accountId, NPS_Result_Report__c 
                          FROM Contact where id in: map_conId_language.keySet() or id in: map_conId_optout.keyset()]){       
            con.NPS_Contact__c = true;
            if(map_conId_optout.containskey(con.Id)){
                con.NPS_OPT_OUT__c = map_conId_optout.get(con.Id);
            }
            if(con.Salutation == null) con.Salutation = 'Mr.';
            
            if(map_conId_language.containsKey(con.Id)){
                con.Survey_Attended_Date__c = system.today();
                con.NPS_Language__c = map_conId_language.get(con.Id);
                if((con.NPS_Score__c >= 0 && con.NPS_Score__c <= 6)  ||  typeBase.set_industriesType.contains(con.Id)){
                    list_contacts.add(con);
                    if(con.accountId != null && !map_accId_Account.containsKey(con.accountId)) map_accId_Account.put(con.accountId, new Account());
                }
                             
            }            
            list_updateContacts.add(con);
        }
        if(!list_updateContacts.isEmpty()) update list_updateContacts;
        if(!map_accId_Account.isEmpty() && (!typeBase.set_TTIType.isEmpty() || !typeBase.set_medicalType.isEmpty() || !typeBase.set_industriesType.isEmpty() || !typeBase.set_applianceType.isEmpty())){
            createTask(typeBase, map_rtName_rtId, map_accId_Account, list_contacts, map_conId_campaignId, map_camId_campaignName);        
        }
    }
    
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
     public static void createTask(TypeBase typeBase, map<String, String> map_rtName_rtId, map<Id, Account> map_accId_Account, list<Contact> list_contacts,
                                   map<Id,Id> map_conId_campaignId, map<Id,String> map_camId_campaignName) {
        
        list<Task> list_task2Insert = new list<Task>();
        
        if(map_accId_Account.size() > 0) {
            getMapAccount(map_accId_Account);
        }
        
        String sfBaseURL = (list_contacts.size() > 0) ?  getStringSfBaseURL() : '';
        if(list_contacts.isEmpty()) return; 
        map<id, contact> mapContactInd = new map<id, contact>();
        for(Contact con :list_contacts){        
            String industry = ((map_accId_Account.containsKey(con.accountId) && map_accId_Account.get(con.accountId).Customer_Industry__c != null) ?  map_accId_Account.get(con.accountId).Customer_Industry__c : '');
            //String industry = map_accId_Account.get(con.accountId).Customer_Industry__c;
            String setting = ''; 
            String leaderId = '';
            String region = ((map_accId_Account.containsKey(con.accountId) && map_accId_Account.get(con.accountId).Customer_Region__c != null) ? map_accId_Account.get(con.accountId).Customer_Region__c : '');

            setting = ((industry == APPLIANCES) ? region : '');                       
            leaderId = getLeadId(industry, setting, con.NPS_Score__c, region, typeBase, con.Id);

            if(typeBase.set_TTIType.contains(con.Id) && con.NPS_Score__c >= 0 && con.NPS_Score__c <= 6 && leaderId != '') {
                //create TTIType Task
                NPSTTIData NPSTTIData = new NPSTTIData(con.NPS_Result_Report__c, sfBaseURL, con.Id, leaderId, map_conId_campaignId, map_camId_campaignName, map_rtName_rtId);         
                list_task2Insert.addAll(createTTITask(NPSTTIData));
                                                    
            }else if(typeBase.set_medicalType.contains(con.Id) && con.NPS_Score__c >= 0 && con.NPS_Score__c <= 6 ) {
                //create medical  type Task
            
            
                String ownerId1 = (map_accId_Account.containsKey(con.AccountId) ? map_accId_Account.get(con.AccountId).Sales_Hierarchy__r.Level_1_Assigned_Users__c : leaderId);
                String ownerId2 = (map_accId_Account.containsKey(con.AccountId) ? map_accId_Account.get(con.AccountId).Sales_Hierarchy__r.Level_2_Assigned_Users__c : leaderId);
                String ownerId3 = (map_accId_Account.containsKey(con.AccountId) ? map_accId_Account.get(con.AccountId).Sales_Hierarchy__r.Level_4_Assigned_Users__c : leaderId);
                NPSMedicalData NPSMedicalData = new NPSMedicalData(con.NPS_Result_Report__c, sfBaseURL, con.Id, leaderId, map_conId_campaignId, map_camId_campaignName, map_rtName_rtId);   

                if(con.NPS_Score__c == 0 ){
                    NPSMedicalData.owner = ownerId1;
                }else if(con.NPS_Score__c >= 1 && con.NPS_Score__c <= 4) {
                    NPSMedicalData.owner = ownerId2;
                }else if(con.NPS_Score__c >= 5 && con.NPS_Score__c <= 6){
                    NPSMedicalData.owner = ownerId3;                
                }   
                system.debug('NPSMedicalData::::: '+NPSMedicalData);
                list_task2Insert.addAll(createMedicalTask(NPSMedicalData));             
            }else if(typeBase.set_applianceType.contains(con.Id) && con.NPS_Score__c >= 0 && con.NPS_Score__c <= 6 && map_accId_Account.containsKey(con.accountId)){
                NPSApplINDData NPSApplINDData = new NPSApplINDData(con.NPS_Result_Report__c, sfBaseURL, con.Id, leaderId, map_conId_campaignId, map_camId_campaignName, map_rtName_rtId);   
                NPSApplINDData.score = con.NPS_Score__c;
                NPSApplINDData.map_accId_Account = map_accId_Account;
                NPSApplINDData.accountId = con.accountId;
                system.debug('NPSApplINDData::::: '+NPSApplINDData);
                list_task2Insert.addAll(createApplINDTask(NPSApplINDData, typeBase.set_applianceType)); 
//Pankaj Raijade-1/2/2016-Detractor Follow Ups - Future State in SFDC-Start//
            }else if(typeBase.set_industriesType.contains(con.Id))
                mapContactInd.put(con.id, con);
        }
        map<id, id> mapContactLevel3User = new map<id, id>();
        map<id, id> mapContactLevel4User = new map<id, id>();
        map<id, id> mapContactAccountManager = new map<id, id>();
        if(mapContactInd.size() > 0)
        {
            list<contact> lstContactAnswer = [select id, NPS_Result_Report__c, account.Territor_L3_Code__c, account.Sales_Hierarchy_GAM__c, account.Sales_Hierarchy_GAM__r.Level_7_Assigned_Users__c, account.Sales_Hierarchy__r.Level_3_Assigned_Users__c, account.Sales_Hierarchy__r.Level_4_Assigned_Users__c, account.Account_Manager__c,ownerId, (select id, Answer_Value__c, Question__r.name from Answers__r where Question__r.Survey__r.name = 'NPS Survey' AND  Question__r.Question_Type__c = :'0...10' AND Current__c = true)from contact where id in :mapContactInd.Keyset()];
            for(contact oContact :lstContactAnswer)
            {
                id TaskOwnerID;
                mapContactLevel3User.put(oContact.Id, oContact.account.Sales_Hierarchy__r.Level_3_Assigned_Users__c);
                mapContactLevel4User.put(oContact.Id, oContact.account.Sales_Hierarchy__r.Level_4_Assigned_Users__c);
                mapContactAccountManager.put(oContact.Id, oContact.account.Account_Manager__c);
                map<string, decimal> mapQuestionAnswervalue = new map<string, decimal>();
                boolean isCreateFollowupTask = false;
                for(Answer__c oAnswer :oContact.Answers__r )
                    mapQuestionAnswervalue.put(oAnswer.Question__r.name, oAnswer.Answer_Value__c);
                decimal dOverallscore;
                string strFollowupType = '';
                if(mapQuestionAnswervalue.containsKey('01. NPS Overall Score'))
                {
                    dOverallscore = mapQuestionAnswervalue.get('01. NPS Overall Score');
                 system.debug('asdf0'+ dOverallscore);
                    if(dOverallscore == 0)
                    {
                        NPS_Settings__c oNPS_Settings = NPS_Settings__c.getInstance(oContact.account.Territor_L3_Code__c);
                        if(oNPS_Settings != null && oNPS_Settings.Value__c != null)
                        {
                            TaskOwnerID = oNPS_Settings.Value__c;
                            strFollowupType = 'GM';
                            isCreateFollowupTask = true;
                        }
                    }
                    else if(dOverallscore < 5)
                    {
                        if(mapContactLevel3User.containsKey(oContact.Id))
                        {
                            TaskOwnerID = mapContactLevel3User.get(oContact.Id);
                            strFollowupType = 'Level3';
                            isCreateFollowupTask = true;
                        }
                    }
                    else if(dOverallscore < 7)
                    {
                        if(oContact.account.Sales_Hierarchy_GAM__c != null)
                        {
                            TaskOwnerID = oContact.account.Sales_Hierarchy_GAM__r.Level_7_Assigned_Users__c;
                            strFollowupType = 'Level4';
                            isCreateFollowupTask = true;
                        }
                        else if(mapContactLevel4User.containsKey(oContact.Id))
                        {
                            TaskOwnerID = mapContactLevel4User.get(oContact.Id);
                            strFollowupType = 'Level4';
                            isCreateFollowupTask = true;
                        }

                    }
                    else 
                    {
                        system.debug('asdfmapQuestionAnswervalue'+ mapQuestionAnswervalue);
                        mapQuestionAnswervalue.remove('01. NPS Overall Score');
                        for(decimal dOtherscore :mapQuestionAnswervalue.values())
                        {
                            system.debug('asdf'+ dOtherscore);
                            if(dOtherscore < 7)
                            {
                                isCreateFollowupTask = true;
                                if(dOverallscore < 9)
                                {
                                    TaskOwnerID = mapContactAccountManager.get(oContact.Id);
                                    strFollowupType = 'AccountManager';
                                }
                                else
                                {
                                    TaskOwnerID = oContact.OwnerId;
                                    strFollowupType = 'Owner';
                                }
                                break;
                            }
                        }
                    }
                }
                
                if(isCreateFollowupTask && TaskOwnerId != null)
                {
                    Task oTask = createIndTask(TaskOwnerId, oContact.Id, oContact.NPS_Result_Report__c, map_rtName_rtId, map_conId_campaignId, map_camId_campaignName, sfBaseURL);
                    if(oTask != null)
                    {
                        if(strFollowupType == 'GM')
                            oTask.subject = system.label.NPS_Detractor_GM_Follow_UP;
                        else if(strFollowupType == 'Level3' || strFollowupType == 'Level4')
                            oTask.subject = system.label.NPS_Detractor_AM_Follow_UP;
                        else if(strFollowupType == 'AccountManager')
                            oTask.subject = system.label.NPS_Passive_Follow_UP;
                        else if(strFollowupType == 'Owner')
                            oTask.subject = system.label.NPS_Promoter_Follow_UP;
                        list_task2Insert.add(oTask ); 
                    }
                }
            }
        }
//Pankaj Raijade-1/2/2016-Detractor Follow Ups - Future State in SFDC-End//
        if(list_task2Insert.size() > 0) {
            insert list_task2Insert;
        }
     }
    /**
    * This method is used to create NPS Task Industrial record type Task
    *
    @created 2016-02-01 - Pankaj Raijade
    @version 1.0
    *
    @changelog  
    */
    public static Task createIndTask(id TaskOwnerId, id contId, string NPS_Result_Report, map<String, String> map_rtName_rtId, map<Id,Id> map_conId_campaignId, map<Id,String> map_camId_campaignName, string sfBaseURL)
    {
        Task oTask = new Task();
        oTask.ActivityDate = system.today().addDays(2);
        oTask.IsReminderSet = true;
        oTask.WhoId = contId;
        oTask.RecordTypeId = map_rtName_rtId.get('NPS Task Industrial');
        oTask.Subject = system.label.NPS_Detractor_Management_Follow_UP;
        if(map_conId_campaignId.containsKey(contId) && map_camId_campaignName.containsKey(map_conId_campaignId.get(contId))) {
            oTask.Campaign_Name__c = map_camId_campaignName.get(map_conId_campaignId.get(contId));
        }
        oTask.ReminderDateTime = system.now().addHours(48);
        oTask.NPS_Survey_Result__c =  sfBaseURL + NPS_Result_Report;
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        oTask.setOptions(dmo);
        oTask.OwnerId = TaskOwnerId;
        return oTask;
    }
    /**
    * This method is used to create TTI type Task
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static list<Task> createTTITask(NPSDatabase NPSTTIData) {
        
        list<Task> list_TTITask = new list<Task>();
        
        String str_TTITaskOwnerd = ClsCampaignMemberUtil.getStringTTITaskOwnerd();          
        
        if(str_TTITaskOwnerd == '' && NPSTTIData.leaderId != '' && NPSTTIData.leaderId != null){
            Task tk = new Task();                           
            tk = setTaskField(NPSTTIData.NPSReport, NPSTTIData.sfBaseURL, NPSTTIData.contId, NPSTTIData.map_conId_campaignId, NPSTTIData.map_camId_campaignName, NPSTTIData.map_rtName_rtId); 
            tk.OwnerId = NPSTTIData.leaderId ;  
            list_TTITask.add(tk);                                               
        }else if(str_TTITaskOwnerd != '') {
            Task tk = new Task();                           
            tk = setTaskField(NPSTTIData.NPSReport, NPSTTIData.sfBaseURL, NPSTTIData.contId, NPSTTIData.map_conId_campaignId, NPSTTIData.map_camId_campaignName, NPSTTIData.map_rtName_rtId); 
            tk.OwnerId = str_TTITaskOwnerd;  
            list_TTITask.add(tk);                                       
        }       
        return list_TTITask;
    }
    
    /**
    * This method is used to create Medical type Task
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static list<Task> createMedicalTask(NPSMedicalData NPSMedicalData) {
        
        list<Task> list_medicalTask = new list<Task>();
        if(NPSMedicalData.owner != null) {
            Task tk = new Task(); 
            tk = setTaskField(NPSMedicalData.NPSReport, NPSMedicalData.sfBaseURL, NPSMedicalData.contId, NPSMedicalData.map_conId_campaignId, NPSMedicalData.map_camId_campaignName, NPSMedicalData.map_rtName_rtId); 
            tk.OwnerId = NPSMedicalData.owner; 
            list_medicalTask.add(tk);   
        }else if(NPSMedicalData.leaderId != '' && NPSMedicalData.leaderId != null){
            Task tk = new Task();                           
            tk = setTaskField(NPSMedicalData.NPSReport, NPSMedicalData.sfBaseURL, NPSMedicalData.contId, NPSMedicalData.map_conId_campaignId, NPSMedicalData.map_camId_campaignName, NPSMedicalData.map_rtName_rtId); 
            tk.OwnerId = NPSMedicalData.leaderId;  
            list_medicalTask.add(tk);                                          
        }           
        
        return list_medicalTask;
    }
    
    /**
    * This method is used to create Medical type Task
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static list<Task> createApplINDTask(NPSApplINDData NPSApplINDData, set<String> set_applianceType) {
        list<Task> list_Task = new list<Task>();
        //NPS Score:0-4 
        if(NPSApplINDData.leaderId != '' && NPSApplINDData.leaderId != null && NPSApplINDData.Score >= 0 && NPSApplINDData.Score <= 4){
            Task tk = new Task(); 
            tk = setTaskField(NPSApplINDData.NPSReport, NPSApplINDData.sfBaseURL, NPSApplINDData.contId, NPSApplINDData.map_conId_campaignId, NPSApplINDData.map_camId_campaignName, NPSApplINDData.map_rtName_rtId); 
            if(set_applianceType.contains(NPSApplINDData.contId)) {
                tk.RecordTypeId = NPSApplINDData.map_rtName_rtId.get('NPS Task Appliances');
            }
            tk.OwnerId = NPSApplINDData.leaderId;
            list_Task.add(tk);
        //NPS Score:5 or 6  
        }else if(NPSApplINDData.Score >= 5 && NPSApplINDData.Score <= 6){
            String leaderId = NPSApplINDData.leaderId;
            system.debug('leaderId::::: '+leaderId);      
            if(set_applianceType.contains(NPSApplINDData.contId)) {
                leaderId = NPSApplINDData.map_accId_Account.get(NPSApplINDData.accountId).Account_Manager__c;
            } 
            system.debug('leaderId::::: '+leaderId);   
            //added check for leaderId != '' for case 00774606 on 20-03-15 by <nooreen.i@zensar.in>
            if(leaderId != null && leaderId != ''){
                Task tk = new Task();               
                tk = setTaskField(NPSApplINDData.NPSReport, NPSApplINDData.sfBaseURL, NPSApplINDData.contId, NPSApplINDData.map_conId_campaignId, NPSApplINDData.map_camId_campaignName, NPSApplINDData.map_rtName_rtId); 
                tk.OwnerId = leaderId;
                tk.Subject = system.label.NPS_Detractor_AM_Follow_UP;
                if(set_applianceType.contains(NPSApplINDData.contId)) {
                    tk.RecordTypeId = NPSApplINDData.map_rtName_rtId.get('NPS Task Appliances');
                }   
                list_Task.add(tk);                    
            }
        }  
        system.debug('list_Task::::: '+list_Task);
        return list_Task;
    }
    
     
     
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void getMapAccount(map<Id, Account> map_accId_Account) {
        
        for(Account acc :[select id, Customer_Industry__c, Account_Manager__c, Customer_Region__c, Sales_Hierarchy__r.Level_1_Assigned_Users__c, 
                                  Sales_Hierarchy__r.Level_2_Assigned_Users__c, Sales_Hierarchy__r.Level_4_Assigned_Users__c 
                          from Account where id IN  :map_accId_Account.keySet()]){
                            
            map_accId_Account.put(acc.id, acc);
        }
    }
     
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
     public static String getLeadId(String industry, String setting, decimal score, String region, TypeBase typeBase, String contId) {
        String leaderId = '';
       
        if(typeBase.set_industriesType.contains(contId)) {
            String strScore = '';
            strScore = MAP_SCORE_SCORESETTING.get(score);
            String BU = '';
            if(region ==  'North America' || region == 'South America') {
                region = 'North America,South America';
            }
            if(strScore != '' && NPS_Settings__c.getInstance(industry) != null && NPS_Settings__c.getInstance(industry).Is_Active__c){                                  
                if(strScore == 'Score_0__c' && NPS_Settings__c.getInstance(industry).Score_0__c != null) {
                    leaderId = (String)NPS_Settings__c.getInstance(industry).Score_0__c;
                }else if(strScore == 'Score_1_4__c' && NPS_Settings__c.getInstance(industry).Score_1_4__c != null) {
                    leaderId = (String)NPS_Settings__c.getInstance(industry).Score_1_4__c;
                }else if(strScore == 'Score_5_6__c' && NPS_Settings__c.getInstance(industry).Score_5_6__c != null) {
                    BU = (String)NPS_Settings__c.getInstance(industry).Score_5_6__c;
                }               
            }
            if(BU != '' && region != '' && NPS_Settings__c.getInstance(region) != null && NPS_Settings__c.getInstance(region).Is_Active__c){
                if(BU == 'A_C__c') {
                    leaderId = (String)NPS_Settings__c.getInstance(region).A_C__c;
                }else if(BU == 'IB__c') {
                    leaderId = (String)NPS_Settings__c.getInstance(region).IB__c;
                }else if(BU == 'RAIL__c') {
                    leaderId = (String)NPS_Settings__c.getInstance(region).RAIL__c;
                }else if(BU == 'SOLAR__c') {
                    leaderId = (String)NPS_Settings__c.getInstance(region).SOLAR__c;
                }
            }
        }else if(typeBase.set_TTIType.contains(contId) || typeBase.set_medicalType.contains(contId) || typeBase.set_applianceType.contains(contId)){
            String cusSetting = ((industry == APPLIANCES) ? setting : ( (map_industry_setting.containsKey(industry)) ? map_industry_setting.get(industry) : '') );
            if(cusSetting != '' && Apex_Helper_Settings__c.getInstance(cusSetting) != null && Apex_Helper_Settings__c.getInstance(cusSetting).Active__c && Apex_Helper_Settings__c.getInstance(cusSetting).value__c != null){
                leaderId = (String)Apex_Helper_Settings__c.getInstance(cusSetting).value__c;
            }
        }
        system.debug('leaderId:::: '+leaderId);
        return leaderId;
     }
     
     
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
     public static Task setTaskField(String NPSResultReport, String sfBaseURL, Id contId, map<Id,Id> map_conId_campaignId, map<Id,String> map_camId_campaignName, map<String, String> map_rtName_rtId) {
        
        Task tk = new Task();
        tk.ActivityDate = system.today().addDays(2);
        tk.IsReminderSet = true;
        tk.WhoId = contId;
        tk.RecordTypeId = map_rtName_rtId.get('NPS Task Standard');
        tk.Subject = system.label.NPS_Detractor_Management_Follow_UP;
        if(map_conId_campaignId.containsKey(contId) && map_camId_campaignName.containsKey(map_conId_campaignId.get(contId))) {
            tk.Campaign_Name__c = map_camId_campaignName.get(map_conId_campaignId.get(contId));
        }
        tk.ReminderDateTime = system.now().addHours(48);
        tk.NPS_Survey_Result__c =  sfBaseURL + NPSResultReport;
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        tk.setOptions(dmo);
        return tk;
     }
     
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static String getStringSfBaseURL() {
        
        String sfBaseURL = '';
        if(NPS_Settings__c.getInstance('SF Base URL') != null && NPS_Settings__c.getInstance('SF Base URL').Is_Active__c != false && NPS_Settings__c.getInstance('SF Base URL').Value__c != null) {
            sfBaseURL = (String) NPS_Settings__c.getInstance('SF Base URL').Value__c;
        }
        return sfBaseURL;
    }
    
    /**
    * This method is used to 
    *
    @created 2014-09-28
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2014-09-28 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void updateContact(map<id,map<id,id>> map_campaignId_conId_memberId) {
        
        map<Id,Id> map_conId_memberId= new map<Id,Id>();  
        map<Id, String> map_conId_campaignType = new map<Id, String>();
        
        for(Campaign cam:[select id, Campaign_Type__c from Campaign 
                          where (id in: map_campaignId_conId_memberId.keyset() )and IsActive=true]){
            for(Id conId: map_campaignId_conId_memberId.get(cam.Id).keySet()){
                map_conId_memberId.put(conId,map_campaignId_conId_memberId.get(cam.Id).get(conId));
                map_conId_campaignType.put(conId, cam.Campaign_Type__c);
            }
        }
        
        if(!map_conId_memberId.isEmpty()){
            list<contact> list_con = new list<Contact>();
            for(Contact con: [SELECT Campaign_Type__c, id, Campaign_Member_ID__c FROM Contact 
                              where (id in: map_conId_memberId.keySet())]){
                if(map_conId_memberId.containsKey(con.Id) || map_conId_campaignType.containsKey(con.Id)) {
                    if(map_conId_memberId.containsKey(con.Id)){
                        con.Campaign_Member_ID__c = map_conId_memberId.get(con.Id); 
                    } 
                    if(map_conId_campaignType.containsKey(con.Id)){
                        con.Campaign_Type__c = map_conId_campaignType.get(con.Id);   
                    }
                    list_con.add(con);          
                }                                                               
            }
            
            if(!list_con.isEmpty()) update list_con;
        }
    }
    
    /**
    * This method is used to sent Detractor Email
    *
    @author     Lili Zhao
    @created    2014-10-09  
    @version    1.0
    @since      28.0 (Force.com ApiVersion)
    *
    @param      contactIds
    *
    @return             
    *
    @changelog
    * 2014-10-09 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static void sentDetractorEmail(map<String, Task> map_Id_task, set<String> set_contactIds){
        
        list<Contact> list_contact = new list<Contact>();       
        map<String, Contact> map_conId_Contact = new map<String, Contact>();
        //map<String, Task> map_taskId_Task = new map<String, Task>();
        map<String, set<String>> map_taskId_set_Emails = new map<String, set<String>>();
        map<String, Task> map_taskId_task = new map<String, Task>();
        map<String, Contact> map_taskId_contact = new map<String, Contact>();
        
        for(Contact contact : [select  Account.Name, Id, NPS_Score__c from Contact 
                                where Id IN : set_contactIds and NPS_Score__c <=6 and NPS_Score__c >= 0 And Campaign_Type__c = 'Industries']) {
            map_conId_Contact.put(contact.Id, contact);
        }
        
        if(map_conId_Contact.isEmpty()) return;
        
        for(Task task :[select Id, whoId, Description, Owner.Name, who.Name from Task 
                        where Id IN : map_Id_task.keySet() and whoId IN : map_conId_Contact.keySet()
                        And Status != 'Completed' And Detraction_Reason__c != null]) {
            map_taskId_task.put(task.Id, task);
            if(map_conId_Contact.containsKey(task.whoId)) {
                map_taskId_contact.put(task.Id, map_conId_Contact.get(task.whoId));
            }
        }
        
        if(map_taskId_task.isEmpty()) return;
        
        for(String taskId : map_taskId_task.keySet()) {
            //String whoId = (map_Id_task.containsKey(taskId) && map_Id_task.get(taskId).WhoId != null ? map_Id_task.get(taskId).WhoId : '');
            //if(whoId != '' && map_conId_Contact.containsKey(whoId)) {      
                //map_taskId_Task.put(taskId, map_Id_task.get(taskId));                     
                if(!map_taskId_set_Emails.containsKey(taskId)) {
                    map_taskId_set_Emails.put(taskId, new set<String>());
                }
                if(map_Id_task.get(taskId).Detraction_Reason__c.contains(';')) {
                    for(String reason : map_Id_task.get(taskId).Detraction_Reason__c.split(';')) {
                        String email = '';                  
                        email = getEmailAsReason(reason);
                        if(email != '' && email != null) {
                            map_taskId_set_Emails.get(taskId).add(email);
                        }
                    }
                }else{
                    String email = '';
                    email = getEmailAsReason(map_Id_task.get(taskId).Detraction_Reason__c);
                    if(email != '' && email != null) {
                        map_taskId_set_Emails.get(taskId).add(email);
                    }
                }
            //}                     
        }
        //system.debug('map_taskId_Task::: '+map_taskId_Task);
        if(map_taskId_Task.size() > 0) {
            setDetractionReasonEmail(map_taskId_task, map_taskId_set_Emails, map_taskId_contact);
        }     
        
    }
    
     /**
    * This method is used to set Detractor Email
    *
    @author     Lili Zhao
    @created    2014-10-09  
    @version    1.0
    @since      28.0 (Force.com ApiVersion)
    *
    @param      contactIds
    *
    @return             
    *
    @changelog
    * 2014-10-09 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */    
    public static void setDetractionReasonEmail(map<String, Task> map_taskId_Task, map<String, set<String>> map_taskId_set_Emails, map<String, Contact> map_taskId_contact) { 
        
        String detractorImageId = '';
        String OId = '';
        String TELogoBottom = '';
        String TELogoTop = '';
        list<Messaging.SingleEmailMessage> list_mails = new list<Messaging.SingleEmailMessage>();
        
        if(NPS_Settings__c.getInstance('Detractor Image') != null && NPS_Settings__c.getInstance('Detractor Image').Value__c != null) {
            detractorImageId = (String) NPS_Settings__c.getInstance('Detractor Image').Value__c;
        }
        if(NPS_Settings__c.getInstance('TE Logo Bottom') != null && NPS_Settings__c.getInstance('TE Logo Bottom').Value__c != null) {
            TELogoBottom = (String) NPS_Settings__c.getInstance('TE Logo Bottom').Value__c;
        }
        if(NPS_Settings__c.getInstance('TE Logo Top') != null && NPS_Settings__c.getInstance('TE Logo Top').Value__c != null) {
            TELogoTop = (String) NPS_Settings__c.getInstance('TE Logo Top').Value__c;
        }
        if(NPS_Settings__c.getInstance('oid') != null && NPS_Settings__c.getInstance('oid').Value__c != null) {
            OId = (String) NPS_Settings__c.getInstance('oid').Value__c;
        }
        
        for(String taskId : map_taskId_Task.keySet()) {            
            if(map_taskId_set_Emails.containsKey(taskId) && map_taskId_set_Emails.get(taskId).size() > 0) {
                
                Task task = map_taskId_Task.get(taskId);
                String head = '<table height=\'535\' width=\'650\' cellpadding=\'0\' cellspacing=\'0\' style=\'padding-left: 80px;padding-right: 50px;\'>';
                head += '<tbody vertical-align=\'middle\' height=\'550\' width=\'550\'>';
                head += '<tr valign=\'top\'><td style=\'vertical-align:middle; height:80; text-align:left; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;\'><img id=\'r1sp1\' blabel=\'headerImage\' border=\'0\' beditid=\'r1sp1\' src=\''+ URL.getSalesforceBaseUrl().toExternalForm() +'/servlet/servlet.ImageServer?id='+TELogoTop+'&oid='+OId+'\'></img></td></tr>';
                head += '<tr valign=\'top\'><td style=\'height:5; background-color:#FF9900;\'></td></tr><tr valign=\'top\'>';
                head += '<td styleinsert=\'1\' height=\'300\' style=\'color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;\'>';
                head += '<table style=\'padding-left:10px;\'><tbody ><tr height=\'50\' valign=\'top\'>';
                head += '<td style=\'color:#000000; font-size:12pt; background-color:#FFFFFF; font-family:arial; bLabel:main; bEditID:r3st1;\' teditid=\'c1r1\' aeditid=\'c1r1\' locked=\'0\'></td></tr><tr><td>';
                                    
                                        
                String emailBody = head + 'Hello,<br><br><div>This Email was sent you from \"' + task.Owner.Name + '\" with the request for improvements for the following Contact:</div><br>';
                emailBody += '<div>\"' + task.who.Name + '\"</div>';
                emailBody += ((map_taskId_contact.containsKey(taskId) && map_taskId_contact.get(taskId).Account.Name != null) ? ('<div> \"' + map_taskId_contact.get(taskId).Account.Name + '\"</div>') : '');
                //String detractorImageBody = '<img src= \'' + URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + detractorImageId + '&oid=' + OId + '\'></img>';
                String taskCommentBody = ''; 
                String taskNPSScoreBody = '';
                String taskLastModifyBody = ''; 
                //system.debug('detractorImageBody:::: '+detractorImageBody);
                //taskNameBody = ((map_conId_Task.containsKey(con.Id) && map_conId_Task.get(con.Id).Who.Name != null) ? '<div>The related task is \'' + map_conId_Task.get(con.Id).Who.Name + '\'</div>': '');
                taskCommentBody = (task.Description != null ? '<div> Please see the comments:<br> \"' + task.Description + '\"</div><br>' : '');
                taskNPSScoreBody = (map_taskId_contact.containsKey(taskId) && map_taskId_contact.get(taskId).NPS_score__c != null ? '<br><div> The overall NPS Score for this contact is: \"' + map_taskId_contact.get(taskId).NPS_score__c + '\"</div><br>' : '');
                //taskLastModifyBody = (task.LastModifiedBy.Name != null ? '<div> The task comment Last Modified By \'' + task.LastModifiedBy.Name + '\'</div>' : '');
                String detractorImageBody = '<div><img src= \'' + URL.getSalesforceBaseUrl().toExternalForm() + '/servlet/servlet.ImageServer?id=' + detractorImageId + '&oid=' + OId + '\'></img></div><br>';
                
                emailBody += taskCommentBody + taskNPSScoreBody + detractorImageBody;  
                emailBody += '<div>Please take any actions to support \"' + task.Owner.Name +'\" improving the customer satisfaction.</div><br>';           
                emailBody += '<div>Kind regards</div><br>';
                emailBody += '<div>System Administrator</div></td></tr></tbody></table></td></tr><tr valign=\'top\'><td style=\'height:5; background-color:#FF9900;\'></td></tr>';
                emailBody += '<tr valign=\'top\'><td style=\'vertical-align:top; height:30; text-align:left; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;\'><img id=\'r5sp1\' blabel=\'footerImage\' border=\'0\' beditid=\'r5sp1\' src=\''+URL.getSalesforceBaseUrl().toExternalForm() +'/servlet/servlet.ImageServer?id='+TELogoBottom+ '&oid='+Oid+'\'></img></td></tr>';
                emailBody += '<tr valign=\'top\'><td style=\'height:5; background-color:#FF9900; \'></td></tr>';
                Messaging.SingleEmailMessage  mail = new Messaging.SingleEmailMessage ();                   
                //mail.setSaveAsActivity(false);
                //mail.setTemplateId(templateId); 
                mail.setHtmlBody(emailBody);
                mail.setSubject('Detractor Follow Up Notification');
                list<String> list_Emails = new list<String>();
                list_Emails.addAll(map_taskId_set_Emails.get(taskId));
                mail.setToAddresses(list_Emails);  
                list_mails.add(mail);  
            }                       
        }
        if(list_mails.size() > 0) {
            system.debug('list_mails::: '+list_mails);
            Messaging.sendEmail(list_mails);
        }      
    }
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    
    /**
    * This method is used to get the email for different reason
    *
    @author     Lili Zhao
    @created    2014-10-09  
    @version    1.0
    @since      28.0 (Force.com ApiVersion)
    *
    @param      reason
    *
    @return             
    *
    @changelog
    * 2014-10-09 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */  
    @TestVisible private static String getEmailAsReason(String  reason) {
        String  email = ''; 
        email = ((reason != null && reason != '' && NPS_Settings__c.getInstance(reason) != null && NPS_Settings__c.getInstance(reason).Value__c != null) ?  (String) NPS_Settings__c.getInstance(reason).Value__c : '' );
        return email;        
    }
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    
    
    
    
    public virtual class NPSDatabase{
        
        public String NPSReport {get; set;}
        public String sfBaseURL {get; set;}   
        public Id contId {get; set;}
        public String leaderId {get; set;}
        public map<Id,Id> map_conId_campaignId {get; set;}
        public map<Id,String> map_camId_campaignName {get; set;}
        public map<String, String> map_rtName_rtId {get; set;}      
        
                     
    }
    
    public class NPSTTIData extends NPSDatabase{
        
        public NPSTTIData() {} 
        public NPSTTIData(String NPSReport, String sfBaseURL, Id contId, String leaderId, map<Id,Id> map_conId_campaignId, map<Id,String> map_camId_campaignName, map<String, String> map_rtName_rtId) {
            this.NPSReport =NPSReport;
            this.sfBaseURL = sfBaseURL;
            this.contId = contId;
            this.leaderId = leaderId;
            this.map_conId_campaignId = map_conId_campaignId;
            this.map_camId_campaignName = map_camId_campaignName;
            this.map_rtName_rtId = map_rtName_rtId;
        }
    }
    
    public class NPSMedicalData extends NPSDatabase{
        
        public String owner {get; set;}
        
        public NPSMedicalData() {}
        
        public NPSMedicalData(String NPSReport, String sfBaseURL, Id contId, String leaderId, map<Id,Id> map_conId_campaignId, map<Id,String> map_camId_campaignName, map<String, String> map_rtName_rtId) {
            this.NPSReport =NPSReport;
            this.sfBaseURL = sfBaseURL;
            this.contId = contId;
            this.leaderId = leaderId;
            this.map_conId_campaignId = map_conId_campaignId;
            this.map_camId_campaignName = map_camId_campaignName;
            this.map_rtName_rtId = map_rtName_rtId;
        }
        
    }
    
    public class NPSApplINDData extends NPSDatabase{
        public decimal score {get; set;}
        public String accountId {get; set;}
        public map<Id, Account> map_accId_Account {get; set;}
        
        public NPSApplINDData() {}
        
        public NPSApplINDData(String NPSReport, String sfBaseURL, Id contId, String leaderId, map<Id,Id> map_conId_campaignId, map<Id,String> map_camId_campaignName, map<String, String> map_rtName_rtId) {
            this.NPSReport =NPSReport;
            this.sfBaseURL = sfBaseURL;
            this.contId = contId;
            this.leaderId = leaderId;
            this.map_conId_campaignId = map_conId_campaignId;
            this.map_camId_campaignName = map_camId_campaignName;
            this.map_rtName_rtId = map_rtName_rtId;
        }
    }
    
    public class TypeBase{
        
        public set<String> set_TTIType {get; set;} 
        public set<String> set_industriesType {get; set;} 
        public set<String> set_applianceType {get; set;} 
        public set<String> set_medicalType {get; set;} 
        
        public TypeBase(set<String> set_TTIType, set<String> set_industriesType, set<String> set_applianceType, set<String> set_medicalType) {
            this.set_TTIType = set_TTIType;
            this.set_industriesType = set_industriesType;
            this.set_applianceType = set_applianceType;
            this.set_medicalType = set_medicalType;
        }
        
        public TypeBase() {
            this.set_TTIType = new set<String>();
            this.set_industriesType = new set<String>();
            this.set_applianceType = new set<String>();
            this.set_medicalType = new set<String>();
        }
    
    }
    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************  
        
    
}