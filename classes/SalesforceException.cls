/***********************************************************************************************************************
 Name: SalesforceException 
 Copyright © 2012 TE Connectivity | Salesforce Instance : BU Org
========================================================================================================================
 Purpose: Exception Handling
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR        DATE       DETAIL                                            MERCURY REQUEST #
------------------------------------------------------------------------------------------------------------------------
     1.0 Umasankar   10/25/2011   Initial Development                            Multi Structured Org (1453487)            
***********************************************************************************************************************/
public class SalesforceException extends Exception{
	 /*_____________________________________________________________________________________________________________________
	 | Purpose : To capture salesforce exception in "Error__c"                                                             |
	 |_____________________________________________________________________________________________________________________|
	 | Input Parameter  :                                                                                                  |
	 |_____________________________________________________________________________________________________________________|
	 |  I1. Name        : pStrApex                                                                                         | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Name of Apex Class/Trigger/Web Service/Broker Class/Batch Class/Schedule Class                   |
	 |  I2. Name        : pStrErrorCode                                                                                    | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Error Code in either number 1,2... or Alpha-numeric like E1, E2...                               |
	 |  I3. Name        : pStrErrorMessage                                                                                 | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Error Message. Example:  invalid status for partner network operation                            |
	 |  I4. Name        : pStrErrorSource                                                                                  | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Error Source. Example:  Eloqua, Big Machines or Salesforce.com                                   |
	 |  I5. Name        : pStrErrorType                                                                                    | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Error Type. Example:  error / warning / fatal / info                                             |
	 |  I6. Name        : pStrLogTime                                                                                      | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Time of error. {may be different from 'createdDate'. Time from source system RTS/TOPS/Program    |
	                      Central} Example: 06/05/2012 10:20 AM                                                            |
	 |  I7. Name        : pStrMethodName                                                                                   | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Name of the method . Example: insertPnrc                                                         |
	 |  I8. Name        : pStrServiceName                                                                                  | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Name of the Service .                                                                            | 
	 |  I9. Name        : pStrSeverity                                                                                     | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Severity .                                                                                       | 
	 | I10. Name        : pStrSfdcRecId                                                                                    | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : SFDC record identifier                                                                           | 
	 | I11. Name        : pStrTransactionId                                                                                | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Transaction Id [Unique number across more than 1 system]                                         | 
	 |_____________________________________________________________________________________________________________________|
	 | Output Parameter : None                                                                                             |
	 |____________________________________________________________________________________________________________________*/ 
 	public static void putError(String pStrApex, String pStrErrorCode, String pStrErrorMessage, String pStrErrorSource, 
	  String pStrErrorType, String pStrLogTime, String pStrMethodName, String pStrServiceName, String pStrSeverity, 
	  String pStrSfdcRecId, String pStrTransactionId, String pStrErrorCategory, String pStrLineNumber, 
	  String pStrStackTrace){ 
  		// Method # : 1
	 	/*-- 1 Object variable declaration --------------------------------------*/ 
	  	Error__c         vError;
		Configuration__c vConfig = new Configuration__c();
		  
	  	/*-- 2 Primitive variable declaration -----------------------------------*/ 
	  	String  vStrError         = '';
	  	String  vStrUserId        = UserInfo.getUserId();
	  	String  vStrOrgId         = UserInfo.getOrganizationId();
	  	String  vStrBody          = '';
	  	String  vStrErrorCategory = '';
	  	String  vStrLineNumber    = '';
	  	String  vStrStackTrace    = '';
	  	String  vStrInstance      = '';
	  	String  vStrEmailErrorTo  = '';  
	  	boolean vblnEmail;
	  	Integer vIntErrorLength   = 0; 
  
	  	/*-- 3 Collection variable declaration --------------------------------------*/ 
	  	List<String> vStrLstRow; 
	  	List<String> vStrLstToAddress = new List<String>(); 
		try{
	   		if (pStrErrorMessage != null){
	    		vIntErrorLength = pStrErrorMessage.length();    
	    		if (vIntErrorLength > 32000){
	     			vIntErrorLength = 31999;    
	    		} // if (vIntErrorLength > 32000)
		    	else if (vIntErrorLength == 0 ){
		     		vIntErrorLength = 0;
				} // ei (vIntErrorLength > 32000)
	    		vStrError = pStrErrorMessage.substring(0, vIntErrorLength);  
			} // if (pStrErrorMessage != null)
	   
		   	vStrErrorCategory = pStrErrorCategory;
		   	vStrLineNumber    = pStrLineNumber; 
		   	vStrStackTrace    = pStrStackTrace;
		      
		   	if (!SalesforceUtil.IsNull(pStrApex) && (!SalesforceUtil.IsNull(pStrErrorCode) || !SalesforceUtil.IsNull(vStrError))){
		    	if (!SalesforceUtil.IsNull(vStrErrorCategory)){
		     		vStrErrorCategory = vStrErrorCategory.replace('System.','');
				} // if (!SalesforceUtil.IsNull(vStrErrorCategory))
		    
		    	vConfig  = Configuration__c.getInstance(SalesforceConstant.strDefault);  
		    	vStrInstance     = vConfig.Environment__c;
		    	vStrEmailErrorTo = vConfig.Error_Recipients__c;
		    	if (vStrInstance == SalesforceConstant.strProd) {
		     		if (vStrEmailErrorTo != null) {
		      			vStrLstToAddress = vStrEmailErrorTo.split(',', -1);
		     		} // if (vStrEmailErrorTo != null)      
		    	} // if (vStrInstance == SalesforceConstant.strProd) 
		    
		    	if (vStrLstToAddress.size() == 0){   
		     		vStrLstToAddress.add('umasankar.subbaian@te.com');
		    	} // if (vStrLstToAddress.size() == 0)
		    
		    	vError = new Error__c();
		    	vError.Class__c          = pStrApex;
		    	vError.Error_Code__c     = pStrErrorCode;
		    	vError.Error_Message__c  = vStrError;
		    	vError.Error_Source__c   = pStrErrorSource;
		    	vError.Error_Type__c     = pStrErrorType;
		    	vError.Log_Time__c       = pStrLogTime;
			    vError.Method_Name__c    = pStrMethodName;
			    vError.Org_Id__c         = vStrOrgId;
			    vError.Service_Name__c   = pStrServiceName;
			    vError.Severity__c       = pStrSeverity;
			    if(pStrSfdcRecId.length() > 20){
			    	vError.SFDC_Record_Id__c = pStrSfdcRecId.subString(0, 18);
			    }
			    else vError.SFDC_Record_Id__c = pStrSfdcRecId;
			    vError.Transaction_Id__c = pStrTransactionId;
			    vError.User_Id__c        = vStrUserId;
			    vError.Error_Category__c = vStrErrorCategory;
			    vError.Line_Number__c    = vStrLineNumber;
			    vError.Stack_Trace__c    = vStrStackTrace;
		    	Insert vError;
		   	} // if (!SalesforceUtil.IsNull(pStrApex) && (!SalesforceUtil.IsNull(pStrErrorCode) || ... 
	                                                  
	  	} //try
	  	catch(DmlException vDmlException) {
	  		System.debug('I am in DmlException : Type = ' + vDmlException.getTypeName() + ' Line : ' + 
	   		vDmlException.getLineNumber() + '-----' + vDmlException.getStackTraceString());
	   		vStrErrorCategory += ' : ' + vDmlException.getTypeName();
	   		vStrLineNumber    += ',' + vDmlException.getLineNumber();
	   		vStrStackTrace    += ' : ' + vDmlException.getStackTraceString();
	   		for (Integer i = 0; i < vDmlException.getNumDml(); i++) {
	    		System.debug(vDmlException.getDmlMessage(i)); 
	    		vStrError += vDmlException.getDmlMessage(i);    
	   		} // for (Integer i = 0; i < vDmlException.getNumDml(); i++)       
	  	} // catch(DmlException vDmlException) 
	  	catch(Exception vException){
	   		vStrErrorCategory += ' : ' + vException.getTypeName();
	   		vStrLineNumber    += ','   + vException.getLineNumber();
	   		vStrStackTrace    += ' : ' + vException.getStackTraceString();  
	   		vStrError         += vException.getMessage();
	  	} // catch(Exception vException)
	  	finally{
	   		System.debug('DML Error : ' + vStrError);      
	   		if ((!SalesforceUtil.IsNull(pStrErrorCode)) || (!SalesforceUtil.IsNull(vStrError)) ){
			    vStrLstRow = new List<String>();
			    vStrLstRow.add('<B>' + SalesforceConstant.strInstance + '</B>');   
			    vStrLstRow.add( vStrInstance);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();
			    vStrLstRow.add('<B>' + SalesforceConstant.strApex + '</B>');   
			    vStrLstRow.add( pStrApex);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strErrorCode + '</B>');   
			    vStrLstRow.add(pStrErrorCode);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strErrorMessage + '</B>');   
			    vStrLstRow.add(vStrError);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strErrorSource + '</B>');
			    vStrLstRow.add(pStrErrorSource);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strErrorType + '</B>');
			    vStrLstRow.add(pStrErrorType);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strLogTime + '</B>');
			    vStrLstRow.add(pStrLogTime);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strMethodName + '</B>'); 
			    vStrLstRow.add(pStrMethodName);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();     
			    vStrLstRow.add('<B>' + SalesforceConstant.strOrgId + ' / Organization Name</B>'); 
			    vStrLstRow.add(vStrOrgId + ' / ' + UserInfo.getOrganizationName());   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strServiceName + '</B>'); 
			    vStrLstRow.add(pStrServiceName);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strSeverity + '</B>'); 
			    vStrLstRow.add(pStrSeverity);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();      
			    vStrLstRow.add('<B>' + SalesforceConstant.strSfdcRecId + '</B>');
			    vStrLstRow.add(pStrSfdcRecId);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strTransactionId + '</B>'); 
			    vStrLstRow.add(pStrTransactionId);   
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();   
			    vStrLstRow.add('<B>' + SalesforceConstant.strUserId + ' / User Name</B>');  
			    vStrLstRow.add(vStrUserId + '&nbsp;/&nbsp;' + UserInfo.getUserName());         
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			
			    vStrLstRow.clear();      
			    vStrLstRow.add('<B>' + SalesforceConstant.strErrorCategory + '</B>');  
			    vStrLstRow.add(vStrErrorCategory);         
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			   
			    vStrLstRow.clear();      
			    vStrLstRow.add('<B>' + SalesforceConstant.strLineNumber + '</B>');  
			    vStrLstRow.add(vStrLineNumber);         
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow);
			
			    vStrLstRow.clear();      
			    vStrLstRow.add('<B>' + SalesforceConstant.strStackTrace + '</B>');  
			    vStrLstRow.add(vStrStackTrace);         
			    vStrBody = vStrBody + SalesforceUtil.buildHtmlTableRow(vStrLstRow); 
			   
			    vStrBody = '<HTML><BODY><TABLE border = "1" cellspacing = "2" cellpadding = "0">' + vStrBody +
			               '</TABLE></BODY></HTML>';
			    System.debug(vStrBody);
			    
			    vblnEmail = SalesforceUtil.sendEmail(vStrLstToAddress, null, null, SalesforceConstant.strException, 
			                SalesforceConstant.strExceptionSender, null, vStrBody);
   			} // if ((!SalesforceUtil.IsNull(pStrErrorCode)) || (!SalesforceUtil.IsNull(vStrError)) )    
  		} // finally
	} // Method # : 1 putError
 
	 /*_____________________________________________________________________________________________________________________
	 | Purpose : Simulate throwing DML exception/ Other exception for boosting code coverage.                              |
	 |_____________________________________________________________________________________________________________________|
	 | Input Parameter  :                                                                                                  |
	 |_____________________________________________________________________________________________________________________|
	 |  I1. Name        : pStrExceptionType                                                                                | 
	 |      Data Type   : String                                                                                           | 
	 |      Description : Type of the exception - DmlException or NullPointerException                                     |
	 |_____________________________________________________________________________________________________________________|
	 | Output Parameter : None                                                                                             |
	 |____________________________________________________________________________________________________________________*/ 
	 public static void throwException(string pStrExceptionType){ // Method # : 2
	  	/* ______________________________ D3. PRIMITIVE VARIABLE DECLARATION ____________________________*/
	  	string s;
	
	  	if (pStrExceptionType == SalesforceConstant.strDmlException){	
   			Account vAccount = new Account();
	   		insert vAccount;
	  	} // if (pStrExceptionType == 'DmlException')
	  	else if (pStrExceptionType == SalesforceConstant.strOtherException){	
	   		s = s.toLowerCase();
	  	} // else if (pStrExceptionType == 'OtherException')
	 } // Method # : 2 throwException                                                                                                                          
	 /*___________________________________________________________________________________________________________________*/
 
} // public class SalesforceException