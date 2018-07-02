public without sharing class SharingUtils 
{
    /****
  public static void CreateAccountTeamMembers(Id AccountId, string GlobalAccountName)
  {
    Id targetUserId; 
    //targetUserId = '005E0000000VsJ1';
    targetUserId = '005E0000000WEh6IAG';    // test user
    
    AccountTeamMember newTeamMember;
    newTeamMember = new AccountTeamMember();
    newTeamMember.AccountId = AccountId;
    //newTeamMember.AccountAccessLevel = 'Edit';     // Edit, Read, None
    newTeamMember.UserId = targetUserId;
    newTeamMember.TeamMemberRole = 'Field Engineer (FE)';
    
    insert newTeamMember; 
    
    List<AccountShare> newShares = new List<AccountShare>();
    AccountShare z = CreateAccountShare(AccountId, targetUserId);
    if (z != null)
      newShares.Add(z);
    try {  
    insert newShares;
    }
    catch (Exception ex)
    {
      //ex.getMessage();
      ErrorLogging.Log(ex);
    }
    
  }
  ****/
 
  public static AccountTeamMember CreateAccountTeamMember(Id AccountId, Id UserId, string RoleName)
  {
    AccountTeamMember newTeamMember;
    newTeamMember = new AccountTeamMember();
    newTeamMember.AccountId = AccountId;
    //newTeamMember.AccountAccessLevel = 'Edit';     // Edit, Read, None
    newTeamMember.UserId = UserId;
    newTeamMember.TeamMemberRole = RoleName;
    return newTeamMember;
  }
  /***
  public static List<AccountShare> CreateHierarchyShares(Id AccountId, string newTerritoryCode)
  {
    // Get the SalesHierarchy object
    Sales_Hierarchy__c hierObj;
    hierObj = GetSalesHierarchy(newTerritoryCode);
    Set<string> UserIdsToCreate;
    List<AccountShare> newShares = new List<AccountShare>();
    
    UserIdsToCreate = UserIdsForTerritory(hierObj);
      
      // Before I create them, remove any shares which used to have access.  These are those from the old territory
      
    for (string s : UserIdsToCreate)
      newShares.Add(CreateAccountShare(AccountId, s));
    
    return newShares;
  }
  ***/
  /***
  public static Set<string> UserIdsForTerritory(Sales_Hierarchy__c hierObj)
  {
    Set<string> UserIdSet = new Set<string>();
    if (hierObj != null)
    {
      for (integer level=1; level <= 7; level++)
      {
        string levelUsers;
        if (level == 1)
          levelUsers = hierObj.Level_1_Assigned_Users__c;
        else if (level == 2)
          levelUsers = hierObj.Level_2_Assigned_Users__c;
        else if (level == 3)
          levelUsers = hierObj.Level_3_Assigned_Users__c;
        else if (level == 4)
          levelUsers = hierObj.Level_4_Assigned_Users__c;
        else if (level == 5)
          levelUsers = hierObj.Level_5_Assigned_Users__c;
        else if (level == 6)
          levelUsers = hierObj.Level_6_Assigned_Users__c;
        else if (level == 7)
          levelUsers = hierObj.Level_7_Assigned_Users__c;
        string[] UserIds;
        if (!SalesforceUtils.isNullOrEmpty(levelUsers))
        {
          UserIds = levelUsers.split(';');
          UserIdSet.addAll(UserIds);
          //for (string s : UserIds)
          //  UserIdSet.add(s);
        }
      }
    }
    
    return UserIdSet;      
  }
  ***/
  public static List<User> GetSFUserIdNameByNetworkId(Set<String> NetworkIds)
  {
    List<User> SFUsers = new List<User>([Select Te_Network_Id__c, Id, Name from User where Te_Network_Id__c in : NetworkIds and IsActive = true and UserType = 'Standard']);
    return SFUsers;
  }
  
  public static Map<String, User> GetSFUserByNetworkIdMap(List<User> SFUsers)
  {
    Map<String, User> SFUserIds = new Map<String, User>();
    
    for(User SFUser : SFUsers)
    {
        SFUserIds.put(SFUser.Te_Network_Id__c, SFUser);
    }
    
    return SFUserIds;     
  }
  
  public static AccountShare CreateAccountShare(Id AccountId, Id targetUserId)
  {
    AccountShare newShare;
    newShare = new AccountShare();
    newShare.AccountId = AccountId;
    newShare.UserOrGroupId  = targetUserId;
    newShare.AccountAccessLevel = 'Edit';
    newShare.OpportunityAccessLevel = 'Edit';
    //newShare.CaseAccessLevel = 'None';
    
    return newShare;     
  }
  
   /* public static ContactShare CreateContactShare(Id ContactId, Id targetUserId)
  {
    ContactShare newShare; 
    newShare = new ContactShare();
    newShare.ContactId = ContactId;
    newShare.UserOrGroupId  = targetUserId;
    newShare.ContactAccessLevel = 'Edit';
    //newShare.RowCause = 'Manual';
    
    return newShare;     
  } */
  
  public static Global_Account__Share CreateGlobalAccountShare(Id GlobalAccountId, Id targetUserId)
  {
    Global_Account__Share newShare;
    newShare = new Global_Account__Share();
    newShare.ParentId = GlobalAccountId;
    newShare.UserOrGroupId  = targetUserId;
    newShare.AccessLevel = 'Read';
    
    return newShare;     
  }
  
  public static Market__Share CreateMarketShare(Id MarketId, Id targetUserId)
  {
    Market__Share newShare;
    newShare = new Market__Share();
    newShare.ParentId = MarketId;
    newShare.UserOrGroupId  = targetUserId;
    newShare.AccessLevel = 'Read';
    
    return newShare;     
  }     
  
  /***
  public static Map<Id, AccountShare> GetAccountSharesMap(Set<Id> AccountIdSet)
  {
    
    Map<Id, AccountShare> queryResult;
    queryResult = new  Map<Id, AccountShare>(
      [
       SELECT 
        Id, 
        UserOrGroupId, 
        RowCause, 
        OpportunityAccessLevel, 
        ContactAccessLevel, 
        CaseAccessLevel, 
        AccountId, 
        AccountAccessLevel 
       FROM AccountShare 
       WHERE AccountId in :AccountIdSet
      ]);
      
      return queryResult;
  }
  ***/
  /***
  public static Set<string> BuildTerritoryCodeList(List<Account> accountList1, List<Account> accountList2)
  {
    Set<string> terrCodes = new Set<string>();
    // Get a list of territory codes
    if (accountList1 != null)
    {
      for (Account a : accountList1)
      { 
        if (!SalesforceUtils.isNullOrEmpty(a.SALES_TERRITORY_CDE__c))
          terrCodes.add(a.SALES_TERRITORY_CDE__c);
      }
    }
    if (accountList2 != null)
    {
      for (Account a : accountList2)
      { 
        if (!SalesforceUtils.isNullOrEmpty(a.SALES_TERRITORY_CDE__c))
          terrCodes.add(a.SALES_TERRITORY_CDE__c);
      }
    }
    
    return terrCodes;
  }
  
  public static Map<Id, Sales_Hierarchy__c> GetSalesHierarchyMap(Set<string> TerritoryCodes)
  {
    
    // TODO - handle process where TerritoryCodes is null, return all 
    Map<Id, Sales_Hierarchy__c> queryResult;
    queryResult = new  Map<Id, Sales_Hierarchy__c>(
      [
       SELECT Id, 
              Level_1_Territory_code__c,
              Level_1_Assigned_Users__c,
              Level_2_Territory_code__c,
              Level_2_Assigned_Users__c,
              Level_3_Territory_code__c,
              Level_3_Assigned_Users__c,
              Level_4_Territory_code__c,
              Level_4_Assigned_Users__c,
              Level_5_Territory_code__c,
              Level_5_Assigned_Users__c,
              Level_6_Territory_code__c,
              Level_6_Assigned_Users__c,
              Level_7_Territory_code__c,
              Level_7_Assigned_Users__c
         FROM Sales_Hierarchy__c
         WHERE Level_7_Territory_Code__c = :TerritoryCodes
      ]);
      
      return queryResult;
  }
  ***/
  public static Sales_Hierarchy__c GetSalesHierarchy(string TerritoryCode)
  {
    List<Sales_Hierarchy__c> queryResult;
    Sales_Hierarchy__c result;
      try
      {
       queryResult = 
        [
         SELECT Id, 
              Level_1_Territory_code__c,
              Level_1_Assigned_Users__c,
              Level_2_Territory_code__c,
              Level_2_Assigned_Users__c,
              Level_3_Territory_code__c,
              Level_3_Assigned_Users__c,
              Level_4_Territory_code__c,
              Level_4_Assigned_Users__c,
              Level_5_Territory_code__c,
              Level_5_Assigned_Users__c,
              Level_6_Territory_code__c,
              Level_6_Assigned_Users__c,
                Level_7_Territory_code__c,
                Level_7_Assigned_Users__c
           FROM Sales_Hierarchy__c
           WHERE Level_7_Territory_Code__c = :TerritoryCode
        ];
    
        if (queryResult != null && queryResult.size() > 0)
          result = queryResult[0];
      } // try
      catch(Exception vException)
      {
       System.debug('Exception in get salesHierarchy : ' + vException.getMessage());
       result =  null;
      } // catch(Exception vException)

    return result;
  }  // End method GetSalesHierarchy()
  
  public static Map<Id, Customer_Focus_Team_Member__c> GetCFTMembersMap(Set<Id> GlobalAccountIdSet)
  {
    Map<Id, Customer_Focus_Team_Member__c> queryResult;
    queryResult = new  Map<Id, Customer_Focus_Team_Member__c>(
      [
       SELECT 
        Id, 
        Name, 
        TE_Network_User_Id__c, 
        Salesforce_User_Name__c, 
        Role__c,
        Global_Account__c 
        From Customer_Focus_Team_Member__c 
       WHERE Global_Account__c in :GlobalAccountIdSet
      ]);
      
      return queryResult;
  }
  
  public static Map<Id, Sales_Team__c> GetMarketTeamMembersMap(Set<Id> MarketIdSet)
  {
    Map<Id, Sales_Team__c> queryResult;
    queryResult = new  Map<Id, Sales_Team__c>(
      [
       SELECT 
        Id, 
        Name, 
        Team_Member__c, 
        Team_Role__c,
        Market__c 
        From Sales_Team__c
       WHERE Market__c in :MarketIdSet
      ]);
      
      return queryResult;
  }  
  
  public static Map<Id, AccountTeamMember> GetAcctTeamMembersMap(Set<Id> AccountIdSet)
  {
    Map<Id, AccountTeamMember> queryResult;
    queryResult = new  Map<Id, AccountTeamMember>(
      [
        SELECT 
        Id, 
        AccountId, 
        UserId, 
        TeamMemberRole, 
        AccountAccessLevel        
        From AccountTeamMember 
       WHERE AccountId in :AccountIdSet
      ]);
      
      return queryResult;
  }
     
     
  public static OpportunityTeamMember CreateOpptyTeamMember(Id OpptyId, Id UserId, string RoleName)
  {
    OpportunityTeamMember newTeamMember;
    newTeamMember = new OpportunityTeamMember();
    newTeamMember.OpportunityId = OpptyId;
    //newTeamMember.AccountAccessLevel = 'Edit';     // Edit, Read, None
    newTeamMember.UserId = UserId;
    newTeamMember.TeamMemberRole = RoleName;
    return newTeamMember;
  }
  
  public static OpportunityShare CreateOpportunityShare(Id OpportunityId, Id targetUserId)
  {
    OpportunityShare newShare = new OpportunityShare();
    newShare.OpportunityId = OpportunityId;
    newShare.UserOrGroupId  = targetUserId;
    //newShare.AccountAccessLevel = 'Edit';
    newShare.OpportunityAccessLevel = 'Edit';
    //newShare.CaseAccessLevel = 'None';
    
    return newShare;     
  }
  
  // added by nelson zheng 11/09/2015 for case 00897724
  public static void sentEmailWhenAMChanged(Map<String,Opportunity_partner__c> oppPartnerMap){
    
        //query the stageName of the relevent Opportunity
        Set<Id> oppIdSet = new Set<Id>();
        for(String key : oppPartnerMap.keySet()){
            if(key.split(';').size() >= 2){
                oppIdSet.add(key.split(';')[1]);
            }
        }
        Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>([select Id,stageName from Opportunity where Id in: oppIdSet]);
        
        //query the opportunityStage
        List<OpportunityStage> OpportunityStageList= [Select o.MasterLabel, o.IsWon, o.IsClosed, o.IsActive, o.Id, o.ForecastCategoryName, o.ForecastCategory, o.Description, o.DefaultProbability From OpportunityStage o];
        //change to map
        Map<String,String> stageMap = new Map<String,String>();
        for(OpportunityStage stage : OpportunityStageList){
            stageMap.put(stage.MasterLabel,stage.ForecastCategoryName);
        }
        
        //a list to hold the final email
        List<Messaging.SingleEmailMessage> singleEmailList = new List<Messaging.SingleEmailMessage>();
        //get the header and footer pic
        Apex_Helper_Settings__c helperSettings = Apex_Helper_Settings__c.getInstance('APL_Email_Alert_Template');
        String letterHead = '<table id="topTable" height="450" width="500" cellpadding="0" cellspacing="0" ><tr valign="top" ><td  style=" vertical-align:middle; height:80; text-align:left; background-color:#FFFFFF; bLabel:header; bEditID:r1st1;"><img id="r1sp1" bLabel="headerImage" border="0" bEditID="r1sp1" src="#head#" ></img></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF9900; bLabel:accent1; bEditID:r2st1;"></td></tr></table>';
        String letterBottom = '<table><tr valign="top" ><td  style=" height:5; background-color:#FF9900; bLabel:accent2; bEditID:r4st1;"></td></tr><tr valign="top" ><td  style=" vertical-align:top; height:30; text-align:left; background-color:#FFFFFF; bLabel:footer; bEditID:r5st1;"><img id="r5sp1" bLabel="footerImage" border="0" bEditID="r5sp1" src="#foot#" ></img></td></tr><tr valign="top" ><td  style=" height:5; background-color:#FF9900; bLabel:accent3; bEditID:r6st1;"></td></tr></table>';
        String ipAddress = '';
        if(helperSettings != null){
            String[] headAndFoot = helperSettings.value__c.split(';');
            if(headAndFoot.size() == 5){
                letterHead = letterHead.replace('#head#',headAndFoot[0]+headAndFoot[1]+headAndFoot[3]);
                letterBottom = letterBottom.replace('#foot#',headAndFoot[0]+headAndFoot[2]+headAndFoot[3]);
                ipAddress = headAndFoot[4];
            }
        }
        //query the email template
        EmailTemplate emailTemplate = [Select e.Id, e.HtmlValue, e.Body,e.Subject,e.BrandTemplateId From EmailTemplate e where e.name = 'Opportunity Team Member Notification'];
        String initialemailTemplate = emailTemplate.HtmlValue;
        initialemailTemplate = initialemailTemplate.replace('<![CDATA[','');
        initialemailTemplate = initialemailTemplate.replace(']]>','');
        initialemailTemplate = letterHead+initialemailTemplate+letterBottom;
        
        //get the profile name which not send email 
        Opportunity_Team_Default_Permission__c ProfileNotSendEmail = Opportunity_Team_Default_Permission__c.getValues('ProfileNotSendEmail');
        if(!oppPartnerMap.isEmpty()){
            for(String key : oppPartnerMap.keySet()){
                Opportunity_partner__c oppPartner = oppPartnerMap.get(key);
                Opportunity oppy = oppMap.get(oppPartner.Opportunity__c);
                String stageForecastCategory = stageMap.get(oppy.StageName);
                //changede by nelson zheng, add "&& stageForecastCategory != 'Omitted' && stageForecastCategory != 'Closed'"
                if(ProfileNotSendEmail.permission__c.indexOf(oppPartner.Partner_AM_Profile_Name__c) == -1 && stageForecastCategory != 'Omitted' && stageForecastCategory != 'Closed'){
                    String htmlBody = initialemailTemplate;//initialise
                    htmlBody = htmlBody.replace('#Opportunity Owner#',oppPartner.Opportunity_Owner__c);
                    htmlBody = htmlBody.replace('#Opportunity Number#',oppPartner.Opportunity_Number__c);
                    htmlBody = htmlBody.replace('#Opportunity Name#',oppPartner.Opportunity_Name__c);
                    htmlBody = htmlBody.replace('#Created Date#',oppPartner.Opportunity_Created_Date__c.format()+'');
                    htmlBody = htmlBody.replace('https://#####',ipAddress+oppPartner.Opportunity__c);
                    
                    String[] target = key.split(';');
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.setTargetObjectId(target[0]);
                    mail.setSubject(emailTemplate.Subject);
                    mail.setHtmlBody(htmlBody);
                    mail.setSenderDisplayName(oppPartner.Opportunity_Owner__c);
                    mail.saveAsActivity = false;
                    singleEmailList.add(mail);
                }
            }
        }
        try{
            //send email
            Messaging.sendEmail(singleEmailList);
        }catch(Exception e){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject('opportunity team Email send failed.');
            mail.setPlainTextBody('Exception: '+e);
            if(CSD_Exception_Email__c.getInstance('Exception User') != null){
                mail.setTargetObjectId(CSD_Exception_Email__c.getInstance('Exception User').User_Id__c);
            }else{
                mail.setTargetObjectId('005E0000000XIav');//TEIS admin
            }
            mail.saveAsActivity = false;
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
        }
    }
    
    // added by nelson zheng 11/09/2015 for case 00897724
    public static void addOpportunityPartnerAMToOppTeam(List<Opportunity_Partner__c> needToInsert){
        Map<String,Opportunity_Team_Default_Permission__c> defaultPermissions = Opportunity_Team_Default_Permission__c.getAll();
        Map<String,String> GIBUDefaultPermission = new Map<String,String>();
        //a map to hold the oppotunity partner which need to be sent email. Same user for one opportunity will be sent only once
        //the key is userid+';'+opportunityId
        Map<String,Opportunity_Partner__c> needToSentMailMap = new Map<String,Opportunity_Partner__c>();
        
        Set<Id> oppIdSet = new Set<Id>();
        List<OpportunityTeamMember> newTeamMember = new List<OpportunityTeamMember>();
        for(Opportunity_Partner__c oppPartner : needToInsert){
            if(oppPartner.Partner_AM_ID__c != null){
                OpportunityTeamMember teamMember = new OpportunityTeamMember();
                teamMember.UserId = oppPartner.Partner_AM_ID__c;
                teamMember.TeamMemberRole = 'Partner SE';
                teamMember.OpportunityId = oppPartner.Opportunity__c;
                if(defaultPermissions.get(oppPartner.Partner_AM_GIBU__c) != null){
                    GIBUDefaultPermission.put(oppPartner.Partner_AM_ID__c,defaultPermissions.get(oppPartner.Partner_AM_GIBU__c).permission__c);
                }else{
                    GIBUDefaultPermission.put(oppPartner.Partner_AM_ID__c,'Read');
                }oppIdSet.add(oppPartner.Opportunity__c);
                needToSentMailMap.put(oppPartner.Partner_AM_ID__c+';'+oppPartner.Opportunity__c,oppPartner);
                newTeamMember.add(teamMember);
            }
        }
        
        if(newTeamMember.size() > 0){
            insert newTeamMember;
            sentEmailWhenAMChanged(needToSentMailMap);
        }
        
        //since OpportunityAccessLevel is not writerable, so we need to update the sharing rule.
        List<OpportunityShare> opportunityShareList = [select Id,OpportunityAccessLevel,UserOrGroupId from OpportunityShare where OpportunityId in: oppIdSet and RowCause = 'Team'];
        for(OpportunityShare oppShare : opportunityShareList){
                
            if(GIBUDefaultPermission.get(oppShare.UserOrGroupId) != null){
                oppShare.OpportunityAccessLevel = GIBUDefaultPermission.get(oppShare.UserOrGroupId);
            }
        }
        
        update opportunityShareList;
        
    }
    
    // added by nelson zheng 11/09/2015 for case 00897724
    public static void removeOpportunityPartnerAMFromOppTeam(List<Opportunity_Partner__c> needToDelete){
        
        Set<Id> oppyIdSet = new Set<Id>();
        Set<Id> amIdSet = new Set<Id>();
        for(Opportunity_Partner__c oppPartner : needToDelete){
            oppyIdSet.add(oppPartner.Opportunity__c);
            amIdSet.add(oppPartner.Partner_AM_ID__c);
        }
        
        //query the rest of Opportunity partners
        List<AggregateResult> checkResult = [select Opportunity__c oppy,Account__r.Account_Manager__c amId,COUNT(Id)num from Opportunity_Partner__c 
            where Opportunity__c in: oppyIdSet and Account__r.Account_Manager__c in: amIdSet
            group by Opportunity__c,Account__r.Account_Manager__c];
        
        //change to map to reduce loop
        Map<String,Integer> aggreResultMap = new Map<String,Integer>();
        for(AggregateResult result : checkResult){
            aggreResultMap.put((String)result.get('oppy')+';'+(String)result.get('amId'),(Integer)result.get('num'));
        }
        
        oppyIdSet.clear();
        amIdSet.clear();
        for(Opportunity_Partner__c oppPartner : needToDelete){
            if(aggreResultMap.get(oppPartner.Opportunity__c+';'+oppPartner.Partner_AM_ID__c) == null){
                //ther is no more opportunity partner of which the am is current oppPartner.Partner_AM_ID__c
                oppyIdSet.add(oppPartner.Opportunity__c);
                amIdSet.add(oppPartner.Partner_AM_ID__c);
            }
        }
        
        //query the opportunity team member
        List<OpportunityTeamMember> shouldDelete = [select Id from OpportunityTeamMember where UserId in: amIdSet and OpportunityId in: oppyIdSet];
        delete shouldDelete;
    }
    
    // added by nelson zheng 11/09/2015 for case 00897724
    public static void updateOppyTeamWhenAccountAMChanged(Map<Id,Id> newAMIdMap,Map<Id,Id> oldAMIdMap){
        
        Set<Id> oppIdSet = new Set<Id>();
        Set<Id> oldAMIdSet = new Set<Id>();
        Map<Id, Set<id>> oldOppAMIdMap = new Map<Id, set<Id>>();  //Added for Case#00900741 by Subramanian on 06/06/2016
        
        List<Opportunity_Partner__c> oppPartnerList = [select Id, Opportunity__c, Account__c,Opportunity_Created_Date__c,Opportunity_Name__c,Opportunity_Number__c,Opportunity_Owner__c,Partner_Account_Manager__c,Partner_AM_Profile_Name__c from Opportunity_Partner__c where Account__c in: newAMIdMap.keySet()];
        //begin to deal with the old am
        
        for(Opportunity_Partner__c oppPartner : oppPartnerList){
            oppIdSet.add(oppPartner.Opportunity__c);
            oldAMIdSet.add(oldAMIdMap.get(oppPartner.Account__c));
        }
        
        //query the rest of Opportunity partners
        List<AggregateResult> checkResult = [select Opportunity__c oppy,Account__r.Account_Manager__c amId,COUNT(Id)num from Opportunity_Partner__c 
            where Opportunity__c in: oppIdSet and Account__r.Account_Manager__c in: oldAMIdSet
            group by Opportunity__c,Account__r.Account_Manager__c];
        
        //change to map to reduce loop
        Map<String,Integer> aggreResultMap = new Map<String,Integer>();
        for(AggregateResult result : checkResult){
            aggreResultMap.put((String)result.get('oppy')+';'+(String)result.get('amId'),(Integer)result.get('num'));
        }
        
        Set<Id> needRemoveOppId = new Set<Id>();
        Set<Id> needRemoveAMId = new Set<Id>();
        for(Opportunity_Partner__c oppPartner : oppPartnerList){
            if(aggreResultMap.get(oppPartner.Opportunity__c+';'+oldAMIdMap.get(oppPartner.Account__c)) == null){
                needRemoveOppId.add(oppPartner.Opportunity__c);
                needRemoveAMId.add(oldAMIdMap.get(oppPartner.Account__c));
                
                // Begins - Added for Case#00900741 by Subramanian on 06/06/2016
                if(!oldOppAMIdMap.containskey(oppPartner.Opportunity__c)){
                    oldOppAMIdMap.put(oppPartner.Opportunity__c, new Set<Id>());
                }
                oldOppAMIdMap.get(oppPartner.Opportunity__c).add(oldAMIdMap.get(oppPartner.Account__c));                
                // Ends for Case#00900741
            }
        }
        
        List<OpportunityTeamMember> deleteOldTeamMember = new List<OpportunityTeamMember>();
        //query the opportunity team member
        List<OpportunityTeamMember> shouldDelete = [select Id, UserId, OpportunityId from OpportunityTeamMember where UserId in: needRemoveAMId and OpportunityId in: needRemoveOppId And OpportunityId In: oldOppAMIdMap.keySet()];
        
        //Begins - Added for Case#00900741 by Subramanian on 06/06/2016
        for(OpportunityTeamMember otm: shouldDelete){
            if(oldOppAMIdMap.get(otm.OpportunityId).contains(otm.UserId)){
                deleteOldTeamMember.add(otm);
            } 
        }
        
        if(deleteOldTeamMember.size() > 0){
            delete deleteOldTeamMember;
        }
        //Ends for Case#00900741
        
        //begin to deal with the new am 
        //get the gibu of the new ams
        Map<Id,User> newAMMap = new Map<Id,User>([select Id,gibu__c from User where Id in: newAMIdMap.values()]);
        
        Map<String,Opportunity_Team_Default_Permission__c> defaultPermissions = Opportunity_Team_Default_Permission__c.getAll();
        // Map<String,String> GIBUDefaultPermission = new Map<String,String>(); Commented for Case#00900741 by Subramanian on 06/06/2016
        //a map to hold the oppotunity partner which need to be sent email. Same user for one opportunity will be sent only once
        //the key is userid+';'+opportunityId
        Map<String,Opportunity_Partner__c> needToSentMailMap = new Map<String,Opportunity_Partner__c>();

        List<OpportunityTeamMember> newTeamMember = new List<OpportunityTeamMember>();
        for(Opportunity_Partner__c oppPartner : oppPartnerList){
            if(newAMIdMap.get(oppPartner.Account__c) != null && oppPartner.Partner_Account_Manager__c != oppPartner.Opportunity_Owner__c){
                OpportunityTeamMember teamMember = new OpportunityTeamMember();
                teamMember.UserId = newAMIdMap.get(oppPartner.Account__c);
                teamMember.TeamMemberRole = 'Partner SE';
                teamMember.OpportunityId = oppPartner.Opportunity__c;
                
                if(defaultPermissions.get(newAMMap.get(newAMIdMap.get(oppPartner.Account__c)).gibu__c) != null){
                   // GIBUDefaultPermission.put(newAMIdMap.get(oppPartner.Account__c),defaultPermissions.get(newAMMap.get(newAMIdMap.get(oppPartner.Account__c)).gibu__c).permission__c); Commented for Case#00900741 by Subramanian on 06/06/2016
                    teamMember.OpportunityAccessLevel = defaultPermissions.get(newAMMap.get(newAMIdMap.get(oppPartner.Account__c)).gibu__c).permission__c; //Added for Case#00900741 by Subramanian on 06/06/2016
                }else{
                   // GIBUDefaultPermission.put(newAMIdMap.get(oppPartner.Account__c),'Read'); Commented for Case#00900741 by Subramanian on 06/06/2016
                    teamMember.OpportunityAccessLevel = 'Read'; //Added for Case#00900741 by Subramanian on 06/06/2016
                }
                oppIdSet.add(oppPartner.Opportunity__c);
                newTeamMember.add(teamMember);
                needToSentMailMap.put(newAMIdMap.get(oppPartner.Account__c)+';'+oppPartner.Opportunity__c,oppPartner);
            }
        }
        
        if(newTeamMember.size() > 0){                       
            insert newTeamMember;
            sentEmailWhenAMChanged(needToSentMailMap);
        }
        
        /* Commented for Case#00900741 by Subramanian on 06/06/2016
        //since OpportunityAccessLevel is not writerable, so we need to update the sharing rule.
        List<OpportunityShare> opportunityShareList = [select Id,OpportunityAccessLevel,UserOrGroupId from OpportunityShare where OpportunityId in: oppIdSet and RowCause = 'Team'];
        for(OpportunityShare oppShare : opportunityShareList){
                
            if(GIBUDefaultPermission.get(oppShare.UserOrGroupId) != null){
                oppShare.OpportunityAccessLevel = GIBUDefaultPermission.get(oppShare.UserOrGroupId);
            }
        }
        
        update opportunityShareList;
        */
        
    }
         
}