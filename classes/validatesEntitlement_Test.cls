/**********************************************************************************************************************************************
*******
Name: validatesEntitlement_Test
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This test class covers test coverage for validatesEntitlement trigger on Entitlement.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra     11/11/2013    Test Class                       
***********************************************************************************************************************************************
*****/
@isTest(seeAllData=true)
public class validatesEntitlement_Test
{
    static testmethod void validatesEntitlement()
    {
        test.startTest();
        Account acc = ClsTestHelp.createTestAccounts();
        insert acc;
        Account acc1 = ClsTestHelp.createTestAccounts();
        insert acc1;
        contact con = ClsTestHelp.createTestContacts();
        con.email='test@org.com';
        con.accountid=acc.id;
        insert con;
        contact con1 = ClsTestHelp.createTestContacts();
        con1.email='test1@org.com';
        con1.accountid=acc1.id;
        insert con1;
        Entitlement En1 = new Entitlement();
        En1.name = 'Test Entitlement';
        En1.accountid = acc.id;
        En1.Startdate = System.today();
        insert En1;
        Entitlement En2 = new Entitlement();
        En2.name = 'Test Entitlement';
        En2.accountid = acc.id;
        En2.Startdate = System.today();
        insert En2;
        EntitlementContact encon= new EntitlementContact();
        encon.ContactId=con1.Id;
        encon.EntitlementId=En1.Id;
        insert encon;
        delete encon;
        delete En1;
        
        test.stopTest();
    }
}