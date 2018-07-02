/*
 * 2012-08-09: Dmytro Smirnov - Initial Development.
 Migrated from TE central - Migrated by Sanghita - PIC migration 
*/
@isTest
public with sharing class TestingUtils {
  public static final Id SYS_ADMIN_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id;
  
  public static User ADMIN_USER {
        get{
            if ( ADMIN_USER == null ){
                ADMIN_USER = [SELECT Id FROM User WHERE ProfileId = :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
            }
            return ADMIN_USER;
        }
        private set;
    }
    
    public static User INTERNAL_USER {
        get{
            if ( INTERNAL_USER == null ){
                INTERNAL_USER = [SELECT Id FROM User WHERE ProfileId != :SYS_ADMIN_PROFILE_ID and IsActive = true LIMIT 1];
            }
            return INTERNAL_USER;
        }
        private set;
    }
  
  public static List<Account> createAccounts( Integer numberToCreate, 
                            Boolean doInsert ){
        List<Account> testAccountList = new List<Account>();
        
        for( Integer i = 0 ; numberToCreate > i; i++ )
            testAccountList.add( new Account ( Name = 'Test Account' + i,
                                             BillingCountry = 'USA') );

        if( doInsert && !testAccountList.isEmpty() )
            insert testAccountList;

        return testAccountList;
    }
  
  public static List<Contact> createContacts( Integer numberToCreate,
                        String firstName,
                        String secondName,
                        Boolean doInsert ){
        List<Contact> testContactList = new List<Contact>();
        
        for( Integer i = 0 ; numberToCreate > i; i++ )
            testContactList.add( new Contact ( FirstName = firstName,
                                             LastName = secondName) );

        if( doInsert && !testContactList.isEmpty() )
            insert testContactList;

        return testContactList;
    }
  
  public static List<Case> createTestCasesList( Integer numberToCreate,
                            Boolean doInsert ){
                                   
    List<Case> newTestCasesList = new List<Case>();
    
    for( Integer i = 0 ; numberToCreate > i; i++ )
      newTestCasesList.add( new Case() );  
    
    if( doInsert && !newTestCasesList.isEmpty()  )
      insert newTestCasesList;
    
    return newTestCasesList;
    }
    
    public static List<Stop_Status__c> createTestStopStatusList( Integer numberToCreate,
                                   String nameString,
                                     Boolean doInsert ){
                                   
    List<Stop_Status__c> newTestStopStatusList = new List<Stop_Status__c>();
    
    for( Integer i = 0 ; numberToCreate > i; i++ )
      newTestStopStatusList.add( new Stop_Status__c( Name = nameString != null ? nameString : 'Test Name') );
    
    if( doInsert && !newTestStopStatusList.isEmpty() )
      insert newTestStopStatusList;
    
    return newTestStopStatusList;
    }
    
    public static List<Attachment> createAttachments( Integer numberToCreate,
                                                      Id parentId,
                                                      String objectName,
                                                      Blob objectBody,
                                                      Boolean doInsert ){
                                                                    
        List<Attachment> newAttachmentsList = new List<Attachment>();
        
        for( Integer i = 0 ; numberToCreate > i ; i++ ){
            newAttachmentsList.add( new Attachment( Name = objectName != null ? objectName : 'Test Attachment',
                                                    ParentId = parentId,
                                                    Body = objectBody != objectBody ? objectBody : Blob.valueOf( 'Test Attachment' ) ) );       
        }
        
        if( doInsert && newAttachmentsList.size() > 0  )
            insert newAttachmentsList;
        
        return newAttachmentsList;
    }
    
    public static List<LiveChatVisitor> createLiveChatVisitors( Integer numberToCreate,
                                   Boolean doInsert ){
                                                                    
        List<LiveChatVisitor> newLiveChatVisitorList = new List<LiveChatVisitor>();
        
        for( Integer i = 0 ; numberToCreate > i ; i++ ){
            newLiveChatVisitorList.add( new LiveChatVisitor() );       
        }
        
        if( doInsert && newLiveChatVisitorList.size() > 0  )
            insert newLiveChatVisitorList;
        
        return newLiveChatVisitorList;
    }
    
    public static List<LiveChatTranscript> createLiveChatTranscripts( Integer numberToCreate,
                                                                Id liveChatVisitorId,
                                                                Boolean doInsert ){
                                                                    
        List<LiveChatTranscript> newLiveChatTranscriptList = new List<LiveChatTranscript>();
        
        for( Integer i = 0 ; numberToCreate > i ; i++ ){
            newLiveChatTranscriptList.add( new LiveChatTranscript( LiveChatVisitorId = liveChatVisitorId ) );       
        }
        
        if( doInsert && newLiveChatTranscriptList.size() > 0  )
            insert newLiveChatTranscriptList;
        
        return newLiveChatTranscriptList;
    }
    
    public static User createUser( Id profileId, Boolean doInsert ){
                                                                    
        User testUser = new User();

    testUser.ProfileId = profileId;
    testUser.Username = 'picTestUser@test.test';
    testUser.LastName = 'LastName';
    testUser.Email = 'test@test.test';
    testUser.Alias = 'ttest';
    testUser.CommunityNickname = 'picTestUser';
    testUser.TimeZoneSidKey = 'GMT';
    testUser.LocaleSidKey = 'en_US';
    testUser.EmailEncodingKey = 'ISO-8859-1';
    testUser.LanguageLocaleKey = 'en_US';
    testUser.TE_Network_UserID__c = 'Test';
    testUser.Primary_Business_Hours__c = 'PIC - US';
    
        if( doInsert ){
            insert testUser;
        }
        
        return testUser;
    }
}