/**********************************************************************************************************************************************
*******
Name: PDFControllerTest
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for PDFControllerTest class.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil  10/16/2013    Test Class                       
***********************************************************************************************************************************************
*****/
@isTest(seeAllData=true)
public class PDFControllerTest{
 static testmethod void PDFControllerTestMethod(){
        test.startTest();
        Case vCs = new Case();
        vCs.Origin = 'Email-cip1';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';
        insert vCs;
        PDFController.PDFRelatedList(vCs.id);
        test.StopTest();
        }
}