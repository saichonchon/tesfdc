/************************************************************************************************************************************************************************************************************************
Name: CaseServices
===========================================================================================================================================================================================================
Purpose: This class was part of Central org and moved in C2S for PIC Migration, used in trigger CaseTrigger on Case object. 
         The methods defined would be used to fill business hours,owner lookup and create case from live chat transcript for Pic.
         
Test Classes: CaseServicesTest, LiveagentCtrl_test         
===========================================================================================================================================================================================================
***********************************************************************************************************************************************************************************************************************/

public with sharing class CaseServices {

    public static CaseFinalVariables__c caseFinalVariables = CaseFinalVariables__c.getInstance('Default');
    public static WebToCaseStrings__c webToCaseStrings = WebToCaseStrings__c.getInstance('Default');
    public static final String CASE_STATUS_NEW_STRING = caseFinalVariables.CASE_STATUS_NEW_STRING__c;
    public static final String CASE_STATUS_IN_PROGRESS_CUSTOMER_STRING = caseFinalVariables.CASE_STATUS_IN_PROGRESS_CUSTOMER_STRING__c;
    public static final String CASE_STATUS_CLOSED_SPAM_STRING = caseFinalVariables.CASE_STATUS_CLOSED_SPAM_STRING__c;
    public static final String CASE_PRIORITY_HIGHT_STRING = caseFinalVariables.CASE_PRIORITY_HIGHT_STRING__c;
    public static final String CASE_PRIORITY_NORMAL_STRING = 'Normal';
    public static final String CASE_SYSTEM_NOTS_TEXT = 'Case has not been found by ref:';
    public static final String TE_PIC_STANDART_CASE_RECORD_TYPE_STRING = caseFinalVariables.TE_PIC_STANDART_CASE_RECORD_TYPE_STRING__c;
    public static final String TE_PIC_CONTACT_RECORD_TYPE_STRING = caseFinalVariables.TE_PIC_CONTACT_RECORD_TYPE_STRING__c;
    public static final String CREATE_BY_LIVE_CHAT_STRING = 'Created by live chat transcript';
    public static final String ORIGIN_CHAT_STRING = 'Chat';
    //public static final String STATUS_CLOSED_CONFIRMED_STRING = 'Closed';
    public static final String STATUS_IN_PROGRESS_CONFIRMED_STRING = 'In Progress';
    public static final String STATUS_OPEN_STRING = 'Waiting for Response';
    
    //srinath  - 2 variables added for CC 
    public static CaseFinalVariablesforCC__c CaseFinalVariablesforCC = CaseFinalVariablesforCC__c.getInstance('Default');
    public static final String Customer_Care_Cloud_Record_Type_String = CaseFinalVariablesforCC.Customer_Care_Cloud_Record_Type_String__c;
    
    public static Id CASE_Customer_Care_Cloud_Record_Type_ID {
        get{
            if( CASE_Customer_Care_Cloud_Record_Type_ID == null )
                return [SELECT Id FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = : Customer_Care_Cloud_Record_Type_String].Id;
            return CASE_Customer_Care_Cloud_Record_Type_ID;
        }
    } 
    
    public static Id CASE_TE_PIC_STANDART_CASE_RECORD_TYPE_ID {
        get{
            if( CASE_TE_PIC_STANDART_CASE_RECORD_TYPE_ID == null )
                return [SELECT Id FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = : TE_PIC_STANDART_CASE_RECORD_TYPE_STRING].Id;
            return CASE_TE_PIC_STANDART_CASE_RECORD_TYPE_ID;
        }
    }
    /*public static Id CONTACT_TE_PIC_CONTACT_RECORD_TYPE_ID {
        get{
            if( CONTACT_TE_PIC_CONTACT_RECORD_TYPE_ID == null )
                return [SELECT Id FROM RecordType WHERE SobjectType = 'Contact' AND DeveloperName = : TE_PIC_CONTACT_RECORD_TYPE_STRING].Id;  system.debug('@@@@sanghita testing '+TE_PIC_CONTACT_RECORD_TYPE_STRING);
            return CONTACT_TE_PIC_CONTACT_RECORD_TYPE_ID;
        }
    }*/

    /*public static void updateCaseTimes( Boolean isInsert,
                                        List<Case> casesToUpdateList,
                                        Map<Id,Case> oldCasesMap ){
        if( isInsert ){
            for( Case caseItem : casesToUpdateList ){
                caseItem.Last_Status_Change__c = System.now();
                caseItem.Time_With_Customer__c = 0;
                caseItem.Time_With_Support__c = 0;
            }
        } else {
            Set<String> stopStatusSet = new Set<String>();
            for (Stop_Status__c stopStatus : [SELECT Name
                                              FROM Stop_Status__c])
                stopStatusSet.add( stopStatus.Name );

            BusinessHours defaultHours = [SELECT Id
                                          FROM BusinessHours
                                          WHERE IsDefault = true];

            Set<String> closedStatusSet = new Set<String>();
            for ( CaseStatus status : [SELECT MasterLabel
                                       FROM CaseStatus
                                       WHERE IsClosed = true] )
                closedStatusSet.add(status.MasterLabel);

            for ( Case updatedCase : casesToUpdateList ) {
                Case oldCase = oldCasesMap.get( updatedCase.Id );

                if ( oldCase.Status != updatedCase.Status && updatedCase.Last_Status_Change__c != null) {
                    if ( !oldCase.IsClosed ){
                        Id hoursToUse = updatedCase.BusinessHoursId != null ? updatedCase.BusinessHoursId : defaultHours.Id;

                        Double timeSinceLastStatus = BusinessHours.diff( hoursToUse, updatedCase.Last_Status_Change__c, System.now() ) / 3600000.0;

                        if ( stopStatusSet.contains( oldCase.Status ) ) {
                            updatedCase.Time_With_Customer__c += timeSinceLastStatus;
                        } else {
                            updatedCase.Time_With_Support__c += timeSinceLastStatus;
                        }

                        if ( closedStatusSet.contains( updatedCase.Status ) ) {
                            updatedCase.Case_Age_In_Business_Hours__c = updatedCase.Time_With_Customer__c + updatedCase.Time_With_Support__c;
                        }
                    }

                    updatedCase.Last_Status_Change__c = System.now();
                }
            }
        }
    }*/

    /*public static void roundRobin( Boolean isUpdate,
                                   List<Case> casesToUpdateList,
                                   Map<Id,Case> oldCasesMap ){

        Map<Integer,Id> queueIds = new Map<Integer,Id>();   //Trigger index --> Queue ID

        Integer idx = 0;
        for ( Case cs : casesToUpdateList )
        {
            if( isUpdate ) {
                if(cs.OwnerId <> oldCasesMap.get(cs.id).OwnerId) {
                    if (cs.TempOwnerId__c == 'SKIP') {
                        casesToUpdateList[idx].TempOwnerId__c = '';
                    } else {
                        queueIds.put(idx, cs.OwnerId);
                    }
                }
            }else {
                queueIds.put(idx, cs.OwnerId);
            }
            idx++;
        }

        if (queueIds.isEmpty()) return;

        //
        //Find active Assignment Group for Queue
        //
        Map<Integer,Id> asgnGroupNameIds = new Map<Integer,Id>();   //Trigger index --> Assignment_Group_Name ID
        Map<Id,Assignment_Group_Queues__c> asgnGroupQueues = new Map<Id,Assignment_Group_Queues__c>(); //Queue ID --> Assignment Group Queues

        for(Assignment_Group_Queues__c[] agq : [SELECT Assignment_Group_Name__c, QueueId__c
                                              FROM Assignment_Group_Queues__c
                                              WHERE QueueId__c in :queueIds.values()
                                              AND Active__c = 'True'])
        {
            for (Integer i = 0; i < agq.size() ; i++) {
                asgnGroupQueues.put(agq[i].QueueId__c, agq[i]);
            }
        }

        if (asgnGroupQueues.isEmpty()) return;

        for (Integer i : queueIds.keySet()) {
            Assignment_Group_Queues__c agq = asgnGroupQueues.get(queueIds.get(i));

            if (agq <> null) {
                asgnGroupNameIds.put(i, agq.Assignment_Group_Name__c);
            }
            //else no active assignment group queue error
        }

        if (asgnGroupNameIds.isEmpty()) return;

        //
        //Determine next valid user in Queue/Assignment Group for round robin
        //User with earliest last assignment date wins.
        //
        Map<Id,Assignment_Groups__c[]> asgnGroups = new Map<Id,Assignment_Groups__c[]>(); // Assignment Group Name ID --> User ID
        for(Assignment_Groups__c[] ags : [SELECT Group_Name__c, User__c, Last_Assignment__c, Millisecond__c
                                       FROM Assignment_Groups__c
                                       WHERE Group_Name__c in :asgnGroupNameIds.values()
                                       AND Active__c = 'True' AND User_Active__c = 'True'
                                       ORDER BY Last_Assignment__c, Millisecond__c])
        {
            if (ags.size()>0) {
                asgnGroups.put(ags[0].Group_Name__c, ags);
            }
        }

        if (asgnGroups.isEmpty()) return;

        Map<Id,Assignment_Groups__c> updateAssignmentGroups = new Map<Id,Assignment_Groups__c>();
        Map<Id, datetime> latestAGDateTime = new Map<Id,datetime>();
        idx = 0;
        for (Integer i : queueIds.keySet())
        {
            Assignment_Groups__c[] ags = asgnGroups.get(asgnGroupNameIds.get(i));
            if (ags.size()>0)
            {
                //Choose next user in line if user ID has already been used but not committed in this trigger batch
                Assignment_Groups__c ag = ags[math.mod(idx, ags.size())];

                //Assign User to Case as the new owner
                casesToUpdateList[i].OwnerId = ag.User__c;
                casesToUpdateList[i].TempOwnerId__c = '';

                //Set last assignment datetime
                datetime now = datetime.now();
                ag.Last_Assignment__c = now;
                ag.Millisecond__c = now.millisecondGMT();

                //update only latest Assignment Groups per ID
                if (latestAGDateTime.containsKey(ag.id)) {
                    if(latestAGDateTime.get(ag.id) < now) {
                        updateAssignmentGroups.put(ag.id, ag);
                        latestAGDateTime.put(ag.id, now);
                    }
                } else {
                    updateAssignmentGroups.put(ag.id, ag);
                    latestAGDateTime.put(ag.id,now);
                }

                idx++;
            }
        }
        //Map --> List/Array for DML update
        List<Assignment_Groups__c> updateAG = new List<Assignment_Groups__c>();
        for (Id agId : updateAssignmentGroups.keySet()) {
            updateAG.add(updateAssignmentGroups.get(agId));
        }

        //
        //Update last assignment for Assignment Group in batch
        //
        if (updateAG.size()>0) {
            try {
                update updateAG;
            } catch (Exception e){
                for (Integer i : queueIds.keySet())
                {
                    casesToUpdateList[i].addError('ERROR: Could not update Assignment Group records ' + ' DETAIL: '+e.getMessage());
                }
            }
        }

       // if( !isUpdate ) fillinBusinessHoursLookup( casesToUpdateList );
    }*/

    /*public static void caseOwnerUpdate( Map<Id,Case> casesToUpdateMap ){
        List<Case> updateCS = new List<Case>();

        if( !casesToUpdateMap.isEmpty() ){
            for ( Case caseItem : [SELECT OwnerId, TempOwnerId__c
                                   FROM Case
                                   WHERE Id IN : casesToUpdateMap.keySet()]) {

                caseItem.OwnerId = casesToUpdateMap.get( caseItem.Id ).TempOwnerId__c;
                caseItem.TempOwnerId__c = 'SKIP'; //flag to stop infinite loop upon update @Dima - From Old code. Do not understand this.
                updateCS.add( caseItem );
            }

            if ( !updateCS.isEmpty() ) {
                try{
                    update updateCS;
                } catch ( DMLException dmlEx ){
                    for ( Integer i = 0; i < dmlEx.getNumDml(); i++ )
                        casesToUpdateMap.get( dmlEx.getDmlId( i ) ).addError( dmlEx.getDmlMessage( i ) );
                }
            }
        }
    }*/

    /*public static Map<Id,Case> filterOwnerUpdatedCases( List<Case> casesToUpdateList ){
        Map<Id,Case> cases = new Map<Id,Case>();
        for ( Case caseItem : casesToUpdateList )
                if( caseItem.TempOwnerId__c != null && caseItem.TempOwnerId__c != '' && caseItem.OwnerId != caseItem.TempOwnerId__c )
                    cases.put( caseItem.id, caseItem);

        return cases;
    }*/

    /*public static void fillinOriginatingQueue( List<Case> newCasesList, Map<Id,Case> oldCasesMap ){
        Map<Id,Group> queueMap = new Map<Id,Group>();
        
        for( Case caseItem : newCasesList ){
            Id ownerOldId = oldCasesMap != null ? oldCasesMap.get( caseItem.Id ).OwnerId : null;
            
            if( caseItem.OwnerId != ownerOldId
                && BluewolfDevUtils.isIdsObjectTypeEqualToStringObjectType( caseItem.OwnerId, BluewolfDevUtils.GROUP_OBJECT_NAME_STRING ) ){
                    System.debug('000 queueMap0 '+queueMap);
                    queueMap.put( caseItem.OwnerId, null );
                    System.debug('000 queueMap '+queueMap);
                    }
        }

        if( !queueMap.keySet().isEmpty() )
            queueMap = new Map<Id,Group>( [SELECT Name
                                           FROM Group
                                           WHERE Id IN : queueMap.keySet() ] );

        for( Case caseItem : newCasesList ){
            if( queueMap.get( caseItem.OwnerId ) != null ){
                System.debug('000 inside IF'); 
                caseItem.Originating_Queue__c = queueMap.get( caseItem.OwnerId ).Name;
                System.debug('000 caseItem.Originating_Queue__c '+caseItem.Originating_Queue__c); 
            }
         }
    }*/
    
     public static void updateContact(List<Case> newCasesList){
        Set<String> emailSet = new Set<String>();
        Map<String,Contact> mapCon = new  Map<String,Contact>(); 
        for(Case cs : newCasesList){
            if(cs.RecordtypeId == CASE_TE_PIC_STANDART_CASE_RECORD_TYPE_ID && cs.contactId == null && cs.Origin=='Web' && (cs.SuppliedEmail != null && cs.SuppliedEmail != '')){
                emailSet.add(cs.SuppliedEmail); 
                System.debug('*******'+emailSet);
            }           
        }
        if(emailSet != null && emailSet.size() > 0){
            for(Contact conObj : [Select Email,Id,FirstName, LastName,Contact.AccountId, RecordTypeId from Contact where Email In: emailSet]){
                    mapCon.put(conObj.Email,conObj);
            }
            // mapCon = new Map<String,Contact>([Select Email,Id,FirstName, LastName,Contact.AccountId, RecordTypeId from Contact where Email In: emailSet]);
            System.debug('***1222****'+mapCon.keySet());
        }
        
        for(Case c : newCasesList){
            if(c.RecordtypeId == CASE_TE_PIC_STANDART_CASE_RECORD_TYPE_ID && c.contactId == null && c.Origin=='Web' && (c.SuppliedEmail != null || c.SuppliedEmail != '')){
               System.debug('***@@****');
                if(mapCon.containsKey(c.SuppliedEmail)){
                    System.debug('***//****');
                    //Contact contactItem = [SELECT Id, FirstName, LastName, Email,Contact.AccountId, RecordTypeId FROM Contact WHERE Email =: c.SuppliedEmail];
                    c.contactId = mapCon.get(c.SuppliedEmail).Id;                
                    c.AccountId = mapCon.get(c.SuppliedEmail).AccountId;
                }
            }
        }
    }

    public static void fillinOwnerLookup( List<Case> newCasesList, Map<Id,Case> oldCasesMap ){
        for( Case caseItem : newCasesList ){
            Id ownerOldId = oldCasesMap != null ? oldCasesMap.get( caseItem.Id ).OwnerId : null;
            System.debug('000 ownerOldId fillinOwnerLookup  '+ownerOldId); 
            System.debug('000 fillinOwnerLookup  '+caseItem.OwnerId); 
            
            if( caseItem.OwnerId != ownerOldId && String.valueOf(caseItem.OwnerId).startsWith('005') ){
                    caseItem.Owner_Lookup__c = caseItem.OwnerId;
                    System.debug('000 caseItem.Owner_Lookup__c  '+caseItem.Owner_Lookup__c); 
            }           
        }
    }

    public static void fillinBusinessHoursLookup( List<Case> newCasesList ){
        Set<Id> userSet = new Set<Id>();
        Map<String, Id> primaryBusinessHoursToUsersMap = new Map<String, Id>();
        Map<Id, Id> userToBAId = new Map<Id, Id>();

        for( Case caseItem : newCasesList )
            if(String.valueOf(caseItem.OwnerId).startsWith('005') && !caseItem.Business_Hous_Are_Set__c )
                    userSet.add( caseItem.OwnerId );

        if( !userSet.isEmpty() ){
            for( User userItem : [SELECT Primary_Business_Hours__c
                                  FROM User
                                  WHERE Id IN : userSet]  ){

                if( userItem.Primary_Business_Hours__c != null && userItem.Primary_Business_Hours__c != '' )
                    primaryBusinessHoursToUsersMap.put( userItem.Primary_Business_Hours__c, userItem.Id );}

            if( !primaryBusinessHoursToUsersMap.keySet().isEmpty() ){
                for( BusinessHours businessHoursItem : [SELECT Name
                                                        FROM BusinessHours
                                                        WHERE Name IN : primaryBusinessHoursToUsersMap.keySet()] ){

                    userToBAId.put( primaryBusinessHoursToUsersMap.get( businessHoursItem.Name ), businessHoursItem.Id );
                    }

                if( !userToBAId.keySet().isEmpty() ){
                    for( Case caseItem : newCasesList )
                        if(userToBAId.containsKey(caseItem.OwnerId)){
                            caseItem.BusinessHoursId = userToBAId.get( caseItem.OwnerId );
                            caseItem.Business_Hous_Are_Set__c = true;
                            System.debug('000 caseItem.BusinessHoursId  '+caseItem.BusinessHoursId); 
                            System.debug('000 caseItem.Business_Hous_Are_Set__c  '+caseItem.Business_Hous_Are_Set__c);
                        }
                }
            }
        }
    }

    /*public static void createCaseFromEmail( Messaging.InboundEmail email ){
        Case caseFromEmail;
        String userInfoString = '';

        if( email.subject.contains(':ref')
            || ( email.plainTextBody != null && email.plainTextBody.contains(':ref') )
            || ( email.htmlBody != null && email.htmlBody.contains(':ref') ) ){
            String refer;

            if( email.subject.contains(':ref') ){
                refer = email.subject;
            } else if( email.plainTextBody.contains(':ref') ){
                refer = email.plainTextBody;
            } else {
                refer = email.htmlBody;
            }

            String caseKey = BluewolfDevUtils.globalDescrideMap.get( 'Case' ).getDescribe().getKeyPrefix();
            String insideRefer = refer.substring( refer.indexOf( 'ref:' ), refer.indexOf( ':ref' ) );
            
            /* 
            * Prabhanjan [01-14-2015]: commenting out as this is not generating the caseid properly. using standard method to get it from thread id
            */
            //string threadId = insideRefer.substring(4);
            
            /*
            system.debug('threadId'+threadId);
            String insideReferFiltered = insideRefer.substring( insideRefer.indexOf( '.' ) + 1 );
            String fullIdFromRef = insideReferFiltered.substring( insideReferFiltered.indexOf( caseKey ) + 3 );
            String firstLetter = fullIdFromRef.substring(  0,  1 );
            String lastLetters = fullIdFromRef.substring( 2,  fullIdFromRef.length() );
            String zeros = '';

            for( Integer i = 0; i < 11 - lastLetters.length(); i++ ){
                zeros += '0';
            }

            String caseId = caseKey + firstLetter + zeros + lastLetters;
            system.debug('caseid from bw'+caseid);
            system.debug('caseid from method'+Cases.getCaseIdFromEmailThreadId(threadId));
            
            */
            
           /* string caseId = Cases.getCaseIdFromEmailThreadId(threadId);
            List <Case> caseListTmp = [SELECT Id, Description
                                       FROM Case
                                       WHERE Id = : caseId];
            if ( caseListTmp.size()>0 ){
                caseFromEmail = caseListTmp[0];
            } else {
                userInfoString += CASE_SYSTEM_NOTS_TEXT + refer.substring( refer.indexOf('ref:') + 4 ,  refer.indexOf(':ref') )+ ' (' + caseId + ')';
            }
        }
        if ( caseFromEmail == null ) {
            List<Contact> contactsList = [SELECT Id, Email
                                          FROM Contact
                                          WHERE Email = : email.fromAddress
                                                AND RecordTypeId = : CONTACT_TE_PIC_CONTACT_RECORD_TYPE_ID
                                          ];

            Id contactId = contactsList.size() > 0 ? contactsList[0].Id : null ;

            caseFromEmail = new Case( SuppliedEmail = email.fromAddress,
                                      Inbound_Email_Address__c = email.toAddresses[0],
                                      SuppliedName = email.fromName,
                                      Subject = email.subject,
                                      Status = CASE_STATUS_NEW_STRING,
                                      RecordTypeId = CASE_TE_PIC_STANDART_CASE_RECORD_TYPE_ID,
                                      Priority = CASE_PRIORITY_NORMAL_STRING,
                                      ContactId = contactId,
                                      Description = email.plainTextBody,
                                      Origin = 'Email');

            if ( userInfoString != null && userInfoString != '')
                caseFromEmail.System_Notes__c = userInfoString;

            caseFromEmail.setOptions( AssignmentRuleServices.createAssignmentRule() );
        }

        try{
            upsert caseFromEmail;
        } catch ( DMLException dmlEx ){
            for ( Integer i = 0; i < dmlEx.getNumDml(); i++ ){}
        }

        if( caseFromEmail.Id != null ){
            try{
 //               MailServices.sendNotification( EmailMessageServices.createEmailMessageFromEmail( email, caseFromEmail.Id ), caseFromEmail.Id );
                  EmailMessageServices.createEmailMessageFromEmail( email, caseFromEmail.Id );
            } catch ( Exception ex ) {
                caseFromEmail = [SELECT System_Notes__c FROM Case WHERE Id = : caseFromEmail.Id];
                caseFromEmail.System_Notes__c += '\n\n' + ex;
                try {
                    update caseFromEmail;
                } catch (DMLException dmlEx) {}
            }
        }

        if( caseFromEmail.Id != null && email.binaryAttachments != null )
            AttachmentServices.createAttachmentsFromMailBinary( email.binaryAttachments, caseFromEmail.Id );

        if( caseFromEmail.Id != null && email.textAttachments != null )
            AttachmentServices.createAttachmentsFromMailText( email.textAttachments, caseFromEmail.Id );
    }*/

    public static Map<LiveChatTranscript,Case> createCaseFromLiveChatTranscript( List<LiveChatTranscript> newLiveChatTranscriptToCaseList ){
        Map<LiveChatTranscript,Case> newLiveChatTranscriptToCaseMap = new Map<LiveChatTranscript,Case>();
        Map<String, Id> emailToContactIdMap = new Map<String, Id>();

        for( LiveChatTranscript item : newLiveChatTranscriptToCaseList ){
            if( item.Email_Address__c != null && item.Email_Address__c != ''){ 
                emailToContactIdMap.put( item.Email_Address__c, null );
                System.debug('***1******'+emailToContactIdMap);
                }
        }        

        for( Contact item : [SELECT Id, Email FROM Contact WHERE Email IN : emailToContactIdMap.keySet() ]){
            emailToContactIdMap.put( item.Email, item.Id );
            System.debug('****2*****'+emailToContactIdMap);
        } 
            Id picId = [select Id,name from RecordType where name='TE PIC Standard Case Record Type' and SObjectType='Case' limit 1].Id;
            Id csId = [select Id,name from RecordType where name='Customer Care Cloud' and SObjectType='Case' limit 1].Id;
          //  LiveagentCtrl cc = new LiveagentCtrl();
          //  string SelectedVal = cc.selectedCCorPIC;
          //  system.debug('SelectedVal'+SelectedVal);
       // string selectedVal;        
        for( LiveChatTranscript item : newLiveChatTranscriptToCaseList ){
            item.Subject__c = (item.Subject__c==null)?CREATE_BY_LIVE_CHAT_STRING:item.Subject__c; // Added for Live chat Phase - 2
            IF(item.Chat_Type__c == 'CUSTOMER CARE'){
            newLiveChatTranscriptToCaseMap.put( item, new Case( Subject = item.Subject__c,    // Modified for Live chat Phase - 2
                                                                Origin = ORIGIN_CHAT_STRING,
                                                                Status = STATUS_IN_PROGRESS_CONFIRMED_STRING,
                                                                Chat_Length__c = item.Chat_Length__c,
                                                                SuppliedEmail = item.Email_Address__c,
                                                                SuppliedCompany = item.Company__c,
                                                                Web_Supplied_First_Name__c  = item.First_Name__c,
                                                                Web_Supplied_Last_Name__c = item.Last_Name__c,
                                                                Campaign__c = item.Campaign__c,
                                                                Wait_Time__c = item.Wait_Time__c,
                                                                No_Initial_Email__c = true,
                                                                ContactId = emailToContactIdMap.get( item.Email_Address__c ),
                                                                Registered_TE_com_Account__c = item.Registered_TE_com_Account__c,
                                                                Chat_Type__c = item.Chat_Type__c , 
                                                                RecordTypeId = CASE_Customer_Care_Cloud_Record_Type_ID 
                                                                 ) );
    system.debug('RecordTypeId1'+newLiveChatTranscriptToCaseMap);
            }
    
    //IF(selectedVal == 'PRODUCT INFORMATION'){
    else{
            newLiveChatTranscriptToCaseMap.put( item, new Case( Subject = item.Subject__c,    // Modified for Live chat Phase - 2
                                                                Origin = ORIGIN_CHAT_STRING,
                                                                Status = STATUS_OPEN_STRING,
                                                                Chat_Length__c = item.Chat_Length__c,
                                                                SuppliedEmail = item.Email_Address__c,
                                                                SuppliedCompany = item.Company__c,
                                                                Web_Supplied_First_Name__c  = item.First_Name__c,
                                                                Web_Supplied_Last_Name__c = item.Last_Name__c,
                                                                Campaign__c = item.Campaign__c,
                                                                Wait_Time__c = item.Wait_Time__c,
                                                                No_Initial_Email__c = true,
                                                                ContactId = emailToContactIdMap.get( item.Email_Address__c ),
                                                                Registered_TE_com_Account__c = item.Registered_TE_com_Account__c,
                                                                Chat_Type__c = item.Chat_Type__c, 
                                                                RecordTypeId = CASE_TE_PIC_STANDART_CASE_RECORD_TYPE_ID 
                                                                 ) );
        system.debug('RecordTypeId2'+newLiveChatTranscriptToCaseMap);
    } 
/*            newLiveChatTranscriptToCaseMap.put( item, new Case( Subject = CREATE_BY_LIVE_CHAT_STRING,
                                                                Origin = ORIGIN_CHAT_STRING,
                                                                Status = STATUS_OPEN_STRING,
                                                                Chat_Length__c = item.Chat_Length__c,
                                                                SuppliedEmail = item.Email_Address__c,
                                                                SuppliedCompany = item.Company__c,
                                                                Web_Supplied_First_Name__c  = item.First_Name__c,
                                                                Web_Supplied_Last_Name__c = item.Last_Name__c,
                                                                Campaign__c = item.Campaign__c,
                                                                Wait_Time__c = item.Wait_Time__c,
                                                                No_Initial_Email__c = true,
                                                                ContactId = emailToContactIdMap.get( item.Email_Address__c ),
                                                                Registered_TE_com_Account__c = item.Registered_TE_com_Account__c,
                                                                Chat_Type__c = item.Chat_Type__c                                                                                                                    
                                                                 ) ); */

        //System.debug('****3*****'+newLiveChatTranscriptToCaseMap);
        }
        try{
            system.debug('newLiveChatTranscriptToCaseMap.values()'+newLiveChatTranscriptToCaseMap.values());
            insert newLiveChatTranscriptToCaseMap.values();
        } catch( DMLException dmlEx ){
            for ( Integer i = 0; i < dmlEx.getNumDml(); i++ )
                for( LiveChatTranscript item : newLiveChatTranscriptToCaseMap.keySet() )
                    if( newLiveChatTranscriptToCaseMap.get( item ).Id == dmlEx.getDmlId( i ) )
                        item.addError( dmlEx.getDmlMessage( i ) );
        }

        return newLiveChatTranscriptToCaseMap;
    }
}