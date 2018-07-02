/**
 *  Controller class for page CtrlCreateAccountPlan_NewViewAccountPlan
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-15
 * @version 1.0
 * @since 23.0
 * 
 * 
 *
 * @changelog
 * 2012-05-15 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */



public class CtrlCreateAccountPlan {
   
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   	public String mode{get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<String, String> map_urlParams;
    private Id accId;
    private Id apId;  
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
     * the constructor
     */
    public CtrlCreateAccountPlan() {
        
    }
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    //********************************* -=END public methods=- ************************************
    /**
	* Turn to account plan view page
	*
	@author Yuanyuan Zhang
	@created 2012-05-15
	@version 1.0
	@since 23.0
	*
	*
	*
	* 2012-05-15 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
	* - Created
	*/
    public pageReference newOrViewAccountPlan(){
    	this.map_urlParams = ApexPages.currentPage().getParameters();
		if(this.map_urlParams.containsKey('accId')){
			this.accId = this.map_urlParams.get('accId');
		}
		
		Id acId = this.accId;
    	Account_Plan__c accountPlan;
    	for(Account_Plan__c ap : [SELECT Id, Customer__c, RecordType.DeveloperName FROM Account_Plan__c WHERE Customer__c = :acId AND RecordType.DeveloperName != 'Snapshot' LIMIT 1]){
    		accountPlan = ap;
    	}
    	if(accountPlan == null){
    		this.mode = 'new';
    		ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, system.Label.No_Account_Plan)); 
    	}
    	else{
    		this.mode = 'view';
    		this.apId = accountPlan.Id;
    		pageReference pr = new pageReference('/apex/ExtAccountPlanView_showAccountPlanDetail?id=' + this.apId + '&accId=' + this.accId);
	    	pr.setRedirect(true);
	    	return pr;
    	}
    	
    	return null;
    }
    
    /**
	* Turn to account plan edit page
	*
	@author Yuanyuan Zhang
	@created 2012-05-15
	@version 1.0
	@since 23.0
	*
	*
	*
	* 2012-05-15 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
	* - Created
	*/
    public pageReference createAccountPlan(){
    	pageReference pr = new pageReference('/apex/ExtAccountPlanEdit_editAccountPlan?accId=' + this.accId);
    	pr.setRedirect(true);
    	return pr;
    }
    
    
    /**
	* Turn to account detail page
	*
	@author Yuanyuan Zhang
	@created 2012-05-15
	@version 1.0
	@since 23.0
	*
	*
	*
	* 2012-05-15 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
	* - Created
	*/
    public pageReference cancel(){
    	pageReference pr = new pageReference('/' + this.accId);
    	pr.setRedirect(true);
    	return pr;
    }
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
	///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}