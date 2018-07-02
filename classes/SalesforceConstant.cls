/***********************************************************************************************************************
 Name: SalesforceConstant
 Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
========================================================================================================================
 Purpose: Holds all constants required for the APEX classes
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR        DATE       DETAIL                                            MERCURY REQUEST #
------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar   10/25/2011   Initial                     						Multi Structured Org (1453487)
***********************************************************************************************************************/
Global class SalesforceConstant
{
 /* __________________ D0. GLOBAL VARIABLE/CONSTANT COMMON FOR ALL ENVIRONMENTS __________________*/
 public static final String strSfdc                = 'Salesforce.com'; 
 public static final String strConfirm             = 'confirm';
 public static final String strError               = 'error';
 public static final String strFatal               = 'fatal';
 public static final String strInfo                = 'info';
 public static final String strWarning             = 'warning';
 public static final String strDmlException        = 'DmlException';
 public static final String strOtherException      = 'OtherException';
 public static final String strException           = 'Exception';
 public static final String strExceptionSender     = 'TE Connectivity - SFDC';
 public static final String strDefault             = 'Default';
 public static final String strProd                = 'PROD';
 public static       String CURRENT_EXCEPTION      = strOtherException;
 public static final String strInstance            = '<B>Instance</B>';
 public static final String strApex                = '<B>Apex</B>';
 public static final String strErrorCode           = '<B>Error Code</B>';
 public static final String strErrorMessage        = '<B>Error Message</B>';
 public static final String strErrorSource         = '<B>Error Source</B>';
 public static final String strErrorType           = '<B>Error Type</B>';
 public static final String strLogTime             = '<B>Log Time</B>';
 public static final String strMethodName          = '<B>Method Name</B>';
 public static final String strOrgId               = '<B>Organization Id</B>';
 public static final String strServiceName         = '<B>Service Name</B>';
 public static final String strSeverity            = '<B>Severity</B>';
 public static final String strSfdcRecId           = '<B>SFDC Record Id</B>';
 public static final String strTransactionId       = '<B>Transaction Id</B>';   
 public static final String strUserId              = '<B>User Id</B>';      
 public static final String strErrorCategory       = '<B>Error Category</B>';  
 public static final String strLineNumber          = '<B>Line Number</B>';  
 public static final String strStackTrace          = '<B>Stack Trace</B>';
   
 /*___________________________________________________________________________________________________________________*/ 

} // Global class SalesforceConstant