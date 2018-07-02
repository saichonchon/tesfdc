/****
************************************************************************************************************************
      Name : CCP_Exception_UtilTest
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods and negative behavioral test methods for 
             'CCP_Exception_Util'
________________________________________________________________________________________________________________________
 Apex class whose code is covered : CCP_Exception_Util
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER   AUTHOR          DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0            Abhijeet         27/01/2014    Test Class
***********************************************************************************************************************
****/

@isTest(seeAllData=true)
class CCP_Exception_UtilTest{
    static testMethod void CCP_Exception_UtilTestMethod() {
    test.startTest();
    try{
    Integer i = 1/0;
    }catch(Exception e){
    CCP_Exception_Util.CCP_Exception_Mail(e);
    }
    test.stopTest();
    }
}