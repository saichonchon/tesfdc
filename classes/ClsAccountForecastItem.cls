/** 
*    Class to display the Forcast for CtrlAccountForecast.page
*
@author Yuda Zheng
@created 2013-09-18
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2013-09-18 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
*/

public class ClsAccountForecastItem {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public String acctId {get; set;}
    public String acctName {get; set;}
    public String profitCtr {get; set;}  

    public map<Integer, AccountForecastMonthlyItem> map_acctMonthlyFCItem;
  
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public ClsAccountForecastItem(String acctId){
        this.acctId = acctId;
        this.map_acctMonthlyFCItem = new map<Integer, AccountForecastMonthlyItem>();
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
    public class AccountForecastMonthlyItem{

        //public decimal fMonth {get; set;}
        //public decimal fQuarter {get; set;}
        //public decimal fYear {get; set;}
        
        public decimal fc {get; set;}
        //public decimal calcFCProposal {get; set;}
        public decimal prevMonthFC {get; set;}
        public decimal budgetPlanBL {get; set;}
        public decimal bill {get; set;}
        public decimal bookToBill {get; set;}
        public decimal backlog {get; set;}
        public decimal orderBacklog {get; set;}
        public decimal scheAgreements {get; set;}
        public decimal demandShipped {get; set;}
        public decimal demandOpen {get; set;}
        public Integer effectDays {get; set;}
        
        public decimal qtAccuracy {get; set;}
        public decimal forecast2Month {get; set;}
        public decimal forecast6Month {get; set;}
        
        public decimal backlog0 {get; set;}
        public decimal backlog1 {get; set;}
        public decimal backlog2 {get; set;}
        public decimal backlog3 {get; set;}
        
        public decimal currency1 {get; set;}
        public decimal currency2 {get; set;}
        public decimal currency3 {get; set;}
        public decimal currency4 {get; set;}
        public boolean isBudgetCalced {get; set;}
        
        public boolean comtIndicator {get; set;}
        //public map<string, AccountForecastMonthlyItem> map_accountForecastMonthlyItem;
        
        // the constructor
        public AccountForecastMonthlyItem(){
            //this.fMonth = 0;
            //this.fQuarter = 0;
            //this.fYear = 0;
            this.fc = 0;
            //this.calcFCProposal = 0;
            this.prevMonthFC = 0;
            this.budgetPlanBL = 0;
            this.bill = 0;
            this.bookToBill = 0;
            this.backlog = 0;
            this.orderBacklog = 0;
            this.scheAgreements = 0;
            this.backlog0 = 0;
            this.backlog1 = 0;
            this.backlog2 = 0;
            this.backlog3 = 0;
            this.currency1 = 0;
            this.currency2 = 0;
            this.currency3 = 0;
            this.currency4 = 0;
            this.effectDays = 0;
            this.qtAccuracy = 0;
            this.forecast2Month = 0;
            this.forecast6Month = 0;
            this.demandShipped = 0;
            this.demandOpen = 0;
            this.comtIndicator = false;
            this.isBudgetCalced = false;
        }
        
     
    }
    public class AcctForecastSaveItem {
        public String parentAcctId {get; set;}
        public decimal totalForecast {get; set;}
        public String year {get; set;}
        public Integer month {get; set;}
        public list<FCCommentSaveItem> commentList {get; set;}
        
        public AcctForecastSaveItem() {
            this.parentAcctId = '';
            this.totalForecast = 0;
            this.year = '';
            this.month = 0;
            this.commentList = new list<FCCommentSaveItem>();
        }
    }
    public class FCCommentSaveItem{
    	public String acctId {get; set;}
    	public String profitCenter {get; set;}
    	public String comment {get; set;}
    	
    	public FCCommentSaveItem() {
    		this.acctId = '';
    		this.profitCenter = '';
    		this.comment = '';
    	}
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
}