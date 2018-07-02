/**
 * 
 *   structure class for budget planning
 *
 * @author      Min Liu
 * @created     2012-04-25
 * @since       23.0    
 * @version     1.0                                                                 
 * 
 * @changelog
 * 2012-04-25 Min Liu <min.liu@itbconsult.com>
 * - Created
 *    
 */  

public class ClsAnnualBudgetPlanStructure { 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String accountId {get; set;}
    public transient String accountName {get; set;}
    public transient String accountInfo {get; set;}   
    public String type {get; set;}
    public transient List<String> list_childIds;
	public transient String comment {get;set;}
	public map<String, BudgetPlanningAccountStructure> map_accountStructure {get; set;} 
	 
    public BudgetPlanningItem detailDirect {get; set;}
    public BudgetPlanningItem detailPOS {get; set;}
    public BudgetPlanningItem detailCMA {get; set;}
    public transient BudgetPlanningItem detailTotal {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public ClsAnnualBudgetPlanStructure(String accountId){
        type = 'Account';
        list_childIds = new List<String>();
        map_accountStructure = new map<String, BudgetPlanningAccountStructure>();
        this.accountId = accountId;
        accountName = '';
        accountInfo = '';
        
        detailDirect = new BudgetPlanningItem();
        detailPOS = new BudgetPlanningItem();
        detailCMA = new BudgetPlanningItem();
        detailTotal = new BudgetPlanningItem();
    }

    public String getAccountId4Report(){
    	if(accountId != null){
	        String tmpAccId = String.valueOf(accountId);
	        tmpAccId = tmpAccId.subString(0, 15);
	        return tmpAccId;
    	}
    	return '';
    }
        

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
        
    //********************************* -=BEGIN public methods=- **********************************
    //********************************* -=END public methods=- ************************************
       
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
        
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************               
    ///*>>>WrapperClass*/
    public class BudgetPlanningAccountStructure{
    	public String AccountId;
	    public BudgetPlanningAccountItem detailDirect;
	    public BudgetPlanningAccountItem detailPOS;
	    public BudgetPlanningAccountItem detailCMA;
	    public BudgetPlanningAccountItem detailTotal; 
	    
	    public BudgetPlanningAccountStructure(String accId) {
	    	AccountId = accId;
	    	detailDirect = new BudgetPlanningAccountItem();
	    	detailPOS = new BudgetPlanningAccountItem();
	    	detailCMA = new BudgetPlanningAccountItem();
	    	detailTotal = new BudgetPlanningAccountItem();
	    }	
    }
    
    public class BudgetPlanningAccountItem{  	    
	    public Decimal BillingsLY {get;set;}
	    public Decimal BillingsYTDCY {get;set;}
	    public Decimal BillingsRRCY {get;set;}
	    public Decimal Backlog {get;set;}
	    public Decimal OpportunitiesWon {get;set;}
	    public Decimal OpportunitiesCommit {get;set;}
	    public Decimal OpportunitiesLikely {get;set;}
	    public Decimal Opportunities5050 {get;set;}
	    public Decimal OpportunitiesWeak {get;set;}
	    public transient Decimal EstimatedFinalCY {get;set;}
	    public transient Decimal ObsoletionEOL {get;set;}
	    public transient Decimal TransferOut {get;set;}
	    public transient Decimal TransferIn {get;set;}
	    public transient Decimal TAMDTAM  {get;set;}
	    public transient Decimal CustomerGrowth {get;set;}
	    public transient Decimal MarketPriceChange {get;set;}
	    public transient Decimal PriceIncrease {get;set;}
	    public transient Decimal Adjustment {get;set;}	    
	    	    	   
		public BudgetPlanningAccountItem(){			
		    BillingsLY = 0;
		    BillingsYTDCY = 0;
		    BillingsRRCY = 0;
		    Backlog = 0;
		    OpportunitiesWon = 0;
		    OpportunitiesCommit = 0;
		    OpportunitiesLikely = 0;
		    Opportunities5050 = 0;
		    OpportunitiesWeak = 0;
		    EstimatedFinalCY = 0;
		    ObsoletionEOL = 0;
		    TransferOut = 0;
		    TransferIn = 0;
		    TAMDTAM  = 0;
		    CustomerGrowth = 0;
		    MarketPriceChange = 0;
		    PriceIncrease = 0;		
		    Adjustment = 0;   
		     
	    }	    	    	    
    }
    
    public class BudgetPlanningItem{
	    public transient Decimal TotalBudget {get; set;}// total budget	    	    
	    public transient Decimal BillingsLY {get;set;}
	    public transient Decimal BillingsYTDCY {get;set;}
	    public Decimal BillingsRRCY {get;set;}
	    public transient Decimal Backlog {get;set;}
	    public Decimal EstimatedFinalCY {get;set;}
	    public Decimal ObsoletionEOL {get;set;}
	    public Decimal TransferOut {get;set;}
	    public Decimal TransferIn {get;set;}
	    public Decimal TAMDTAM  {get;set;}
	    public Decimal CustomerGrowth {get;set;}
	    public Decimal MarketPriceChange {get;set;}
	    public Decimal PriceIncrease {get;set;}	    
	    public Decimal Adjustment {get;set;}	    
	    public transient Decimal RepeatBusiness {get;set;}
	    public transient Decimal validRepeatBusiness {get;set;}
	    public transient Decimal AdjRepeatBusiness {get;set;}
	    public transient Decimal OpportunitiesWon {get;set;}
	    public transient Decimal Forecast {get;set;}
	    public transient Decimal OpportunitiesCommit {get;set;}
	    public transient Decimal OpportunitiesLikely {get;set;}
	    public transient Decimal Opportunities5050 {get;set;}
	    public transient Decimal OpportunitiesWeak {get;set;}
	    public transient Decimal Growth {get; set;} 
	    public transient Decimal TotalAccountBudget {get; set;}
	    public transient Decimal TotalOtherBudget {get; set;}
	    public String comments {get; set;}
	    //Start by Bin Yuan 2013-10-21 due to fix Budget NY bug
	    public transient Decimal budgetNY {get; set;}
	    //ENd

	    public BudgetPlanningItem(){
	    	TotalBudget = 0;
	    	TotalOtherBudget = 0;
	    	TotalAccountBudget = 0; 
		    BillingsLY = 0;
		    BillingsYTDCY = 0;
		    BillingsRRCY = 0;
		    Backlog = 0;
		    EstimatedFinalCY = 0;
		    ObsoletionEOL = 0;
		    TransferOut = 0;
		    TransferIn = 0;
		    TAMDTAM  = 0;
		    RepeatBusiness = 0;
		    CustomerGrowth = 0;
		    MarketPriceChange = 0;
		    PriceIncrease = 0;
		    AdjRepeatBusiness = 0;
		    validRepeatBusiness = 0;
		    OpportunitiesWon = 0;
		    Forecast = 0;
		    OpportunitiesCommit = 0;
		    OpportunitiesLikely = 0;
		    Opportunities5050 = 0;
		    OpportunitiesWeak = 0;
		    Adjustment = 0;
		    Growth = 0; 	
		    comments = '';    
		    this.budgetNY = 0;	

	    }	    
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}