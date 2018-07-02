/**
 * This class used to identify Opportunity created fiscal year and update in Opportunity record while create and update.
 * 
 * @author    Raghurama Y
 * @created   2017-04-12
 * @since     37.0 (Force.com ApiVersion)
 * @version   1.0
 * 
 * @changelog
 * 2017-04-12 Raghu Rama Y <raghuramachandra.prabhu@te.com>
 * - Created
 * 
 */
public class IdentifyOptyFiscalYear{   
    public static void IdentfyFiscalCreated(List<Opportunity> list_optys) {             
    	//Edit by :Buwen Guo <buwen.guo@capgemini.com> 2017-09-29
    	//Change Reason:This Query will ignore a day such as the day is the StartDate or EndDate for a fiscalYear.
        //FiscalYearSettings fiscalYear = [select name from FiscalYearSettings where StartDate <: date.today() AND EndDate >: date.today()];
        FiscalYearSettings fiscalYear = [select name from FiscalYearSettings where StartDate <=: date.today() AND EndDate >=: date.today()];
        for(Opportunity Op: list_optys){
           Op.Created_FiscalYear__c = fiscalYear.name;
        }
    }
}