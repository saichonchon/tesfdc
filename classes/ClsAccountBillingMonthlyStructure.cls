/**
 * 
 *   structure class for account
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

public class ClsAccountBillingMonthlyStructure {
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public AccountBillingMonthlyItem parent {get; set;}
	public List<AccountBillingMonthlyItem> children {get; set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
  
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
        
    //********************************* -=BEGIN public methods=- **********************************
	//********************************* -=END public methods=- ************************************
       
    //********************************* -=BEGIN private methods=- *********************************
	//********************************* -=END private methods=- ***********************************
        
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************           
    ///*>>>WrapperClass*/
    public class AccountBillingMonthlyItem{
		public Decimal Budget4Direct {get; set;}
		public Decimal Budget4POS {get; set;}
		public Decimal Budget4CMA {get; set;}
		public Decimal Budget4Total {get; set;}	
		public Decimal ForecastCY {get; set;}	
		public Decimal BillingsLY {get; set;}
		public Decimal BillingsCY {get; set;}
		public Decimal BillingsCYRR {get; set;}
		public String accountId  {get; set;}			
		public String accountName {get; set;}   
		public Boolean isLast {get;set;} 
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************	
}