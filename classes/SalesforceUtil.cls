/**************************************************************************************************************************************************
Name: SalesforceUtil
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contains generic purpose utilities which are used at multiple places in Salesforce development. 
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------                                                         
VERSION AUTHOR        DATE       DETAIL                                     Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar     10/25/2010 Initial Development                        Multi Structured Org (1453487)
**************************************************************************************************************************************************/
public class SalesforceUtil{
	 /*------------------------------------------------------------------------------------------------------------------------------------------------
	 | Purpose    : Check if null or empty or just with white spaces                                                                                  |
	 | Parameters : String                                                                                                                            |
	 | Returns    : Boolean                                                                                                                           |
	 ------------------------------------------------------------------------------------------------------------------------------------------------*/
 	public static Boolean isNull(String strInput){
  		Boolean vBoolean = null;
  		if ((strInput == null) || (strInput.trim().length() == 0)) {
   			vBoolean = true;
  		} // if ((strInput == null) || (strInput.trim().length() == 0)) 
  		else{
   			vBoolean = false;
  		} // e ((strInput == null) || (strInput.trim().length() == 0)) 
  		return vBoolean;
 	} // public static Boolean isNull(String strInput) 
   
	 /*------------------------------------------------------------------------------------------------------------------------------------------------
	 |    Purpose : To build HTML Table Cell                                                                                                          |
	 | Parameters : Value of the cell                                                                                                                 |
	 |    Returns : Cell definition of HTML Table                                                                                                     |
	 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
	 public static String buildHtmlTableCell(String pStrCellValue){
	  	/*-- 1 Primitive variable declaration --------------------------------------*/ 
	 	String vStrCell;
	  	/*-- 2 Collection variable declaration -------------------------------------*/ 
	  	List<String> vLstString;
  
  		if ((SalesforceUtil.IsNull(pStrCellValue)) || (pStrCellValue == 'null' )){
   			vStrCell = '&nbsp;';
  		} // if (SalesforceUtil.IsNull(pStrCellValue))
  		else{
   			if (pStrCellValue.startsWith('~')){
    			vLstString = new List<String>();
    			vLstString = pStrCellValue.split('~',3);
   		 		vStrCell = '<A href="' + vLstString[2] +'">' + vLstString[1] + '</A>';
   			} // if (pStrCellValue.startsWith(SalesforceConstant.strHttps))
   			else{   
    			vStrCell = pStrCellValue;
   			} // e (pStrCellValue.startsWith(SalesforceConstant.strHttps))   
  		} // e (SalesforceUtil.IsNull(pStrCellValue))
  
  		return '<TD><Font face = "verdana" size = "2pt">' + vStrCell  + '</Font></TD>';  
 	} // public static String buildHtmlTableCell(String pStrCellValue)
 
	 /*------------------------------------------------------------------------------------------------------------------------------------------------
	 |    Purpose : To build HTML Table Row                                                                                                           |
	 | Parameters : Values of the columns                                                                                                             |
	 |    Returns : Row definition of HTML Table                                                                                                      |
	 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
	 public static String buildHtmlTableRow(String[] pStrCols){
  		/*-- 1 Primitive variable declaration --------------------------------------*/ 
  		String vStrRow;
  		if (pStrCols != null){
   			if (pStrCols.size() > 0){
    			vStrRow = '';
    			for (String s: pStrCols){   
     				vStrRow = vStrRow + buildHtmlTableCell(s); 
    			} // for (String s: pStrCols)
    			vStrRow = '<TR>' + vStrRow + '</TR>';
   			} // if (pStrCols.size() > 0)    
  		} // if (pStrCols != null) 
  		return vStrRow;
 	} // public static String buildHtmlTableRow(String[] pStrCols)
 
	 /*------------------------------------------------------------------------------------------------------------------------------------------------
	 |    Purpose : To convert a string to its proper case                                                                                            |
	 | Parameters : String to be converted                                                                                                            |
	 |    Returns : Proper case String                                                                                                                |
	 ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
	 public static String toProperCase(String pStr)	{
		/*-- 1 Collection variable declaration --------------------------------------*/
	  	List<String> vLstChars = new List<String>();
	  	/*-- 2 Primitive variable declaration ---------------------------------------*/ 
	  	String vStrResult = '';
	  	if (!isNull(pStr)){
	   		pStr = pStr.toLowerCase();
	   		vLstChars = pStr.split('');   
	   		for (Integer i=1; i<vLstChars.size(); i++){
	    		if ( i==1 || vLstChars[i-1] == ' ') {
	     			vStrResult += vLstChars[i].toUpperCase();
    			} // if ( i==1 || vLstChars[i-1] == ' ') 
	    		else{
	     			vStrResult += vLstChars[i];
   		 		} // e ( i==1 || vLstChars[i-1] == ' ') 
   			} // for (Integer i=1; i<vLstChars.size(); i++)
	  	} // e (!isNull(pStr))    
	  	return vStrResult;
	 } // public static String toProperCase(String pStr)
 
	/*-------------------------------------------------------------------------------------------------------------------------------------------------
	 | Purpose    : Send Email                                                                                                                        |
	 | Parameters : To Addresses, CC Addresses, BCC Addresses, Subject, Sender Display Name, Reply To, Body                                           |
	 | Returns    : Boolean                                                                                                                           |
	 ------------------------------------------------------------------------------------------------------------------------------------------------*/
 	public static boolean sendEmail(String[] pToAddresses, String[] pCcAddresses, String[] pBccAddresses, String pSubject, String pSenderDisplayName, String pReplyTo, String pBody){
	    /*-- 1.0 Object variable declaration ------------------------------------*/
	    Messaging.SingleEmailMessage vEmail;
	    /*-- 1.1 Primitive variable declaration ---------------------------------*/
	    boolean vSendStatus;

    	try{
     		vSendStatus = false;

     		if ((pToAddresses != null) && (pSubject != null) && (pBody != null)){
      			if (pToAddresses.size() > 0){
       				vEmail = new Messaging.SingleEmailMessage();   
       				if (pBccAddresses != null ){
        				if (pBccAddresses.size() > 0){
					    	vEmail.setBccSender(true);     
					        vEmail.SetBccAddresses(pBccAddresses);
    					}   // if (pBccAddresses.size() > 0)  
       				} // if (pBccAddresses != null )
	       			vEmail.setToAddresses(pToAddresses);
	      			if (pCcAddresses != null){
	        			if (pCcAddresses.size() > 0){
	         				vEmail.setCcAddresses(pCcAddresses);
	        			} // if (pCcAddresses.size() > 0)       
	       			} // if (pCcAddresses != null)      
	       
	       			if (!SalesforceUtil.IsNull(pReplyTo)){
	        			vEmail.setReplyTo(pReplyTo); 
	       			} // if (!SalesforceUtil.IsNull(pReplyTo))
	           
	       			if (!SalesforceUtil.IsNull(pSenderDisplayName)){
	        			vEmail.setSenderDisplayName(pSenderDisplayName);
	       			} // if (!SalesforceUtil.IsNull(pSenderDisplayName))
	       			vEmail.setSubject(pSubject);    
	       			vEmail.setUseSignature(false);
	       			vEmail.setHtmlBody(pBody);  
	       			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { vEmail });    
	       			vSendStatus = true;
	       			System.debug('Email Utility is sending email');
	      		} // if (pToAddresses.size() > 0)
	 		} // if ((pToAddresses != null) && (pSubject != null) && (pBody != null))
	    } // try
	    catch(Exception vException){
     		System.debug('Exception in "SalesforceUtil.sendEmail" : ' + vException.getMessage());
     		ErrorLogging.Log(vException);
		} // catch(Exception vException)
    	return vSendStatus; 
   	} // public static boolean sendEmail     
   	
 	public static String ReplaceNullStringWithEmpty(String strInput)
	{
    	return (strInput == null ? '' : strInput);
	} 
 	
	/*-----------------------------------------------------------------------------------------------------------------------------------------------*/ 

} // public class SalesforceUtil