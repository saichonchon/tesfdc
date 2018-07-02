/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   Class for custom button 'Submit For Approval' of Opportunity
Inputs:        
Test Class:    ClsDynamicApprovalProcessTest
History
2017-10-16 	   Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
global class ClsDynamicApprovalProcess {
	
	/*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   If opportunity.quote_type__c = 'Meet Competitor Price' then check all the OppParts and 
	 			   verify that they all have NDR_Competitor_Name__c and Competitor_Price__c values.  
	 			   If any don't then please show an error message
	Inputs:        oppyId - Opportunity Id
	Returns:       errorMessage - String
	History
	2017-10-16 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    webService static String checkOppyReadyForApproval(string oppyId) {
    	String str_listPartNum = '';
    	String errorMessage = '';
    	Opportunity oppy = [SELECT Id, Quote_Type__c FROM Opportunity WHERE Id =: oppyId];
    	if(oppy.Quote_Type__c == 'Meet Competitor Price') {
    		for(Opportunity_Part__c oppyPart : [SELECT Id, NDR_Competitor_Name__c, NDR_Competitor_Part_Number__c, Competitor_Price__c, Part__r.Name FROM Opportunity_Part__c WHERE Opportunity__c =: oppyId]) {
    			//Modified by Tangyong Li 2018-04-13: IR-04226
    			//if(oppyPart.NDR_Competitor_Name__c == null || oppyPart.Competitor_Price__c == null) {
    			if(oppyPart.NDR_Competitor_Name__c == null) {
    				if(str_listPartNum != '') {
    					str_listPartNum += ',';
    				}
    				str_listPartNum += (' ' + oppyPart.Part__r.Name);
    			}
    		}
    	}
    	if(str_listPartNum != '') {
    		errorMessage += system.label.ErrorMsg_ClsDynamicApprovalProcess1;
    		errorMessage += (str_listPartNum + ' ');
    		errorMessage += system.label.ErrorMsg_ClsDynamicApprovalProcess2;
    	}
    	return errorMessage;
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Method to submit the process for approve
	Inputs:        oppyId - Opportunity Id
	Returns:       error - String
	History
	2017-10-16 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    webService static String dynamicApprovalProcess(string oppyId) {
    	String error = '';
    	try {
    		Opportunity oppy = [SELECT Id, Account.Territory_L4_code__c, Margin__c, Amount, Account_Owner__c FROM Opportunity WHERE Id =: oppyId];
    		error += checkApprovalProcessCriteria(oppy);
    		if(error == '') {
		    	Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
				req.setObjectId(oppyId);
				Approval.ProcessResult result = Approval.process(req);
    		}
    	} catch(Exception e) {
        	SalesforceException.putError('--- The following exception has occurred:', '', ('Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage()), SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
    	}
    	return error;
    }
    
    /*------------------------------------------------------------
	Author:        Tangyong Li <tangyong.li@capgemini.com>
	Description:   Method to check the entrance criteria for opportunity approval process
	Inputs:        oppy - Opportunity
	Returns:       errorMessage - String
	History
	2017-12-11 	   Tangyong Li <tangyong.li@capgemini.com> created
	------------------------------------------------------------*/
    public static String checkApprovalProcessCriteria(Opportunity oppy) {
        Boolean isMatchANZ = false;
        Boolean isMatchAccountOwner = false;
        Boolean isMatchDOA = false;
        set<String> set_matureMarketsL4 = new set<String>{'100326','100248','101876','102831','101838','100071','102831'};
        set<String> set_emergingMarketsL4 = new set<String>{'101925','101926','102709'};
		set<String> set_ANZL4 = new set<String>{'100380','101650','103246'};
		set<String> set_americasL4 = new set<String>{'101594','101595','100437'};
		set<String> set_ChinaL4 = new set<String>{'100342'};
		set<String> set_ROAL4 = new set<String>{'100341','101636','101637','102537'};
        
        String errorMessage = '';
        if(oppy.Amount == null || oppy.Amount == 0) {
    		errorMessage += (system.label.ErrorMsg_ClsDynamicApprovalProcessprefix + ' ' + system.label.ErrorMsg_oppyApprovalProcessAmount);
        }
        if(oppy.Margin__c == null) {
        	if(errorMessage == '') {
        		errorMessage += (system.label.ErrorMsg_ClsDynamicApprovalProcessprefix + ' ' + system.label.ErrorMsg_oppyApprovalProcesMargin);
        	} else {
	    		errorMessage += (', ' + system.label.ErrorMsg_oppyApprovalProcesMargin);
        	}
        }
        if(set_ANZL4.contains(oppy.Account.Territory_L4_code__c)) {
        	isMatchANZ = true;
        	if(oppy.Account_Owner__c != null) isMatchAccountOwner = true;
        } else if(set_matureMarketsL4.contains(oppy.Account.Territory_L4_code__c) 
        	|| set_emergingMarketsL4.contains(oppy.Account.Territory_L4_code__c) 
        	|| set_americasL4.contains(oppy.Account.Territory_L4_code__c)
        	|| set_ChinaL4.contains(oppy.Account.Territory_L4_code__c)
        	|| set_ROAL4.contains(oppy.Account.Territory_L4_code__c)) {
        	isMatchDOA = true;
        }
        if(!isMatchDOA && !isMatchANZ) {
        	if(errorMessage == '') errorMessage += (system.label.ErrorMsg_ClsDynamicApprovalProcessprefix + ' ' + system.label.ErrorMsg_ClsDynamicApprovalProcess3);
        	else errorMessage += (', ' + system.label.ErrorMsg_ClsDynamicApprovalProcess3);
        } else if(isMatchANZ && !isMatchAccountOwner) {
        	if(errorMessage == '') errorMessage += (system.label.ErrorMsg_ClsDynamicApprovalProcessprefix + ' ' + system.label.ErrorMsg_oppyApprovalProcesAccountOwner);
        	else errorMessage += (', ' + system.label.ErrorMsg_oppyApprovalProcesAccountOwner);
        }
        return errorMessage;
    }
    
}