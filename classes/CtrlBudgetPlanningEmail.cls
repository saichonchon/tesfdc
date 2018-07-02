/**
 * 
 *   This class is used to get the sandbox and production prefix link
 *
 * @author      Min Liu
 * @created     2012-09-04
 * @since       23.0    
 * @version     1.0                                                                 
 * 
 * @changelog
 * 2012-09-04 Min Liu <min.liu@itbconsult.com>
 * - Created
 *    
 */
public class CtrlBudgetPlanningEmail {
	public String Pre_Url_Org{get;private set;}
	public Id BudgetId{get;set;}
	public String EmailType{get;set;}
	public CtrlBudgetPlanningEmail(){
		Pre_Url_Org = URL.getSalesforceBaseUrl().toExternalForm();
 	}
}