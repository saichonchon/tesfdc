/****
************************************************************************************************************************
      Name : CSD_Exception_UtilTest
       Org : C2S
 Copyright : © 2014 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods and negative behavioral test methods for 
             'CSD_Exception_Util'
________________________________________________________________________________________________________________________
 Apex class whose code is covered : CSD_Exception_Util
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER   AUTHOR          DATE       DETAIL                                  
________________________________________________________________________________________________________________________
     1.0            Padmaja        27/04/2014    Test Class
***********************************************************************************************************************
****/

@isTest(seeAllData=true)
class CSD_Exception_UtilTest{
    static testMethod void CSD_Exception_UtilTestMethod() {
    test.startTest();
    try{
    Integer i = 1/0;
    }catch(Exception e){
    CSD_Exception_Util.CSD_Exception_Mail(e);
    }
    test.stopTest();
    }
}