/**
 *  Contains a set of static methods used CtrlWithOutToolEnhancementLockUp pages
 *
 @author Minghao Li
 @created 2017-09-19
 @version 1.0
 @since 38.0 (Force.com ApiVersion)
 *
 @changelog
 * 2017-09-19 Minghao Li <minghao.li@capgemini.com>
 * - Created
 */
public without sharing class CtrlWithOutToolEnhancementLockUp {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public transient list<sObject> list_account {get;set;}
    public list<CustomFieldSetMember> list_cfsm {get;set;}
	public String s {get;set;}
	
	public String filterByField {get;set;}
	public String filterByLogic {get;set;}
	public String filterByValue {get;set;}
	public String searchLabel {get;set;}
	public String baseSql {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<String, String> map_parameters {get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CtrlWithOutToolEnhancementLockUp() {
    	
    	this.filterByField = '';
    	this.filterByLogic = '';
    	this.filterByValue = '';
    	this.searchLabel = 'Recently Viewed Products';
    	this.map_parameters = ApexPages.currentPage().getParameters();
    	this.list_account = new list<sObject>();
    	
    	
    	this.list_cfsm = new list<CustomFieldSetMember>{
    		new CustomFieldSetMember('Name', 'Name', 'String', false),
    		new CustomFieldSetMember('AccountNumber', 'Account Number', 'String', false),
    		new CustomFieldSetMember('Owner.Name', 'Owner', 'String', false),
    		new CustomFieldSetMember('BillingCountry', 'Billing Country', 'String', false),
    		new CustomFieldSetMember('BillingCity', 'Billing City', 'String', false),
    		new CustomFieldSetMember('LEVEL_4_INDUSTRY_NM__c', 'Industry Name', 'String', false),
    		new CustomFieldSetMember('STATDESC__c', 'Account Status', 'String', false)
    		
    	};
    	
    	try{
	    	this.s = (String.isNotEmpty(this.map_parameters.get('s')) ? this.map_parameters.get('s') : '');
	    		
			this.baseSql = 'SELECT ';
	        for(CustomFieldSetMember f : list_cfsm) {
	            this.baseSql += (f.apiName+ ', ');
	        }
	        
	        this.baseSql += ' Id FROM Account ';
	        
	        String query = getFilterSql(this.s, '');
	        
	    //    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, query+'' ));
			this.list_account.addAll( Database.query(query) );
    		
    	}catch(Exception e){
    		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
    	}
    	
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
	public void searchProduct(){
		
		this.list_account = new list<sObject>();
		this.searchLabel = 'Search Results';
		try{
			
			String filter=ApexPages.currentPage().getParameters().get('filter');
			String inputS=ApexPages.currentPage().getParameters().get('inputS');

			String query = getFilterSql(inputS, filter);
			
		//	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, query));
			
			this.s = ApexPages.currentPage().getParameters().get('inputS');
			
			this.list_account.addAll( Database.query(query) );
			
		}catch(Exception e){
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, e.getMessage()));
		}
	}
    //********************************* -=END public methods=- ************************************
    
    //********************************* -=BEGIN private methods=- *********************************
    private String getFilterSql(String s, String filter){

		String likeFilter=(String.isNotEmpty(s) ? ' Where Name like \'%'+s+'%\' OR AccountNumber like \'%'+s+'%\' OR Owner.Name like \'%'+s+'%\' ' : ' ');
		
		return (this.baseSql + likeFilter + ' order by Name LIMIT 200');
    }
    
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
	public class CustomFieldSetMember{
    	
    	public String apiName {get;set;}
        public String labelName {get;set;}
        public String gType {get;set;}
        public Boolean required {get;set;}
        public String orderBy {get;set;}
        public String icon {get;set;}
        public String cls {get;set;}
        public Boolean isInternalClass {get;set;}
        
        public CustomFieldSetMember(String apiName, String labelName, String gType, Boolean required){
            this.apiName = apiName;
            this.labelName = labelName;
            this.gType = gType;
            this.required = required;
            this.orderBy = '';
            this.cls = '';
            this.icon = 'utility:arrowup';
            this.isInternalClass = false;
        }
    }

    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}