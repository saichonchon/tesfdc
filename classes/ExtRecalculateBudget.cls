/**
 *  This class is used to run batch of recalculating budget
 *
 * @author Xia Tong
 * @created 2012-07-11
 * @version 2.0
 * @since 24.0
 *
 * @changelog
 * 2012-07-11 Xia Tong <xia.tong@itbconsult.com>
 * - Created
 */
public class ExtRecalculateBudget {
 /**
	 *  Constructor
	 *
	 * @author Xia Tong
	 * @created 2012-07-11
	 * @version 2.0
	 * @since 21.0
	 *
	 * @changelog
	 * 2012-07-11 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */
	public ExtRecalculateBudget(ApexPages.StandardController stdCtl){

	}
	/**
	 *  This method is used to return to Budget Rate  Home page
	 *
	 * @author Xia Tong
	 * @created 2012-07-11
	 * @version 2.0
	 * @since 24.0
	 *
	 * @changelog
	 * 2012-07-11 Xia Tong <xia.tong@itbconsult.com>
	 * - Created
	 */
	public void runBatchJob(){
		ClsBatch_BudgetCalculating bc = new ClsBatch_BudgetCalculating();
    	database.executeBatch(bc);
		//Pagereference page= new Pagereference('/a1A?fcf=00BM0000000ZCob');
		//page.setRedirect(true);
	}
	
}