/**************************************************************************************************************************************************
Name:  SalesforceUtilTest
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for SalesforceUtil 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : SalesforceUtil                                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian 12/12/2011 Initial Development                      1453487                                   
**************************************************************************************************************************************************/
@isTest(seealldata = false)
public class SalesforceUtilTest
{
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Propercase | Positive behavioral test                                                                                         |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ptProperCase()
 {
  /*-- D3. Primitive variable declaration ------------------------------------------*/
  String vStr;
  vStr = 'UMASANKAR SUBBAIAN';
  vStr = SalesforceUtil.toProperCase(vStr);
 } // public static void ptProperCase()
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Propercase | Negative behavioral test | Input : Empty string                                                                  |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ntProperCaseEmptyString()
 {
  /*-- D3. Primitive variable declaration ------------------------------------------*/
  String vStr;
  vStr = '';
  vStr = SalesforceUtil.toProperCase(vStr);
 } // public static void ntProperCaseEmptyString()
 
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Propercase | Negative behavioral test | Input : Empty string                                                                  |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static void ntProperCaseNullString()
 {
  /*-- D3. Primitive variable declaration ------------------------------------------*/
  String vStr;
  vStr = '';
  vStr = SalesforceUtil.toProperCase(vStr);
 } // public static void ntProperCaseNullString()
 /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : Test - Account before update trigger                                                                                                 |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
 public static testMethod void TestTrigger()
 {
  test.StartTest();
  ptProperCase();
  ntProperCaseEmptyString();
  ntProperCaseNullString();
  //start :added 2012/9/25
  list<String> pStrCols = new list<String>();
  pStrCols.add('xxxxxxxxxxx');
  SalesforceUtil.buildHtmlTableCell('xxxxxxxxxxx');
  SalesforceUtil.buildHtmlTableRow(pStrCols);
  SalesforceUtil.toProperCase('xxxxxxxxxxx');
  SalesforceUtil.sendEmail(pStrCols, pStrCols, pStrCols, 'xxxxxxxxxxx', 'xxxxxxxxxxx', 'xxxxxxxxxxx', 'xxxxxxxxxxx');
  system.assert(true);
  
  //end
  test.StopTest();
 } // public static testMethod void TestTrigger()
 
 /*-----------------------------------------------------------------------------------------------------------------------------------------------*/
  
} // public class SalesforceUtilTest