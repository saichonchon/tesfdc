public class BluewolfDevUtils {
  public static final String USER_OBJECT_NAME_STRING = 'User';
  public static final String GROUP_OBJECT_NAME_STRING = 'Group';
  public static final String QUEUE_SOBJECT_NAME_STRING = 'QueueSobject';
  
  public static Map<String, Schema.SObjectType> globalDescrideMap = Schema.getGlobalDescribe();
  
  public BluewolfDevUtils()
  {
    
  }
  
  public static Boolean isIdsObjectTypeEqualToStringObjectType( String objectIdString, String objectTypeNameString ){
    Boolean isEqual = false;
        
    Map<String,String> keyPrefixMap = new Map<String,String>{};

    for( String objectItem : globalDescrideMap.keySet() ){
       Schema.DescribeSObjectResult objectDescribe =  globalDescrideMap.get(objectItem).getDescribe();
       keyPrefixMap.put( objectDescribe.getKeyPrefix(), objectDescribe.getName() );
    }
    
    if( keyPrefixMap.get( objectIdString.subString( 0, 3 ) ) == objectTypeNameString ) isEqual = true;
    
    return isEqual;
  }
  /*
   * Start Test Methods
   */
 /* private static testmethod void testIsIdsObjectTypeEqualToStringObjectType(){
      Integer NUMBER_TO_INSERT = 5;
      List<Account> testAccountList = new List<Account>();
      List<Boolean> testEqualsList = new List<Boolean>();
      List<Boolean> testNotEqualsList = new List<Boolean>();
      String accountObjectType = Account.getsObjectType().getDescribe().getName();
      
    testAccountList = TestingUtils.createAccounts( NUMBER_TO_INSERT, true );
    
      Test.startTest();
        for( Account accountItem : testAccountList ){
        testEqualsList.add( isIdsObjectTypeEqualToStringObjectType( ( String )accountItem.Id, accountObjectType ) );
      }
      
      for( Account accountItem : testAccountList ){
        testNotEqualsList.add( isIdsObjectTypeEqualToStringObjectType( ( String )accountItem.Id, 'Account__c' ) );
      }
        Test.stopTest();
        
        for( Boolean testEqualsItem : testEqualsList ){
          System.assertEquals( true , testEqualsItem );
        }
        
        for( Boolean testNotEqualsItem : testNotEqualsList ){
          System.assertEquals( false , testNotEqualsItem );
        }
    }*/
}