/**************************************************************************************************************************************************
Name: ExecuteOnce
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: Holds static variables which contrlos second time execution of triggers for Account, Contact and Opportunity
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------    
VERSION AUTHOR             DATE         DETAIL                                                                             Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 RAHUL GHARAT       10/25/2011   Initial                                                                             1453487
    1.1 UMASANKAR SUBBAIAN 12/06/2011   To allow creating account and child records                                         1453487
**************************************************************************************************************************************************/
public class ExecuteOnce 
{
 public static boolean SF2SF_ACCOUNT     = false;
 public static boolean SF2SF_OPPORTUNITY = false;
 public static boolean SF2SF_CONTACT     = false;
 public static boolean SF2SF_LEAD        = false;
 public static boolean SF2SF_TASK        = false;
} // public class ExecuteOnce