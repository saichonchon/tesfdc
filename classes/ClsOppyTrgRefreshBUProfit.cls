/**
 * This class used to refresh Opportunity Part's BU Profit when Distributor on Opportunity is updated.
 * 
 * @author    Mrunal Parate
 * @created    2016-12-19
 * @since     37.0 (Force.com ApiVersion)
 * @version   1.0
 * 
 * @changelog
 * 2016-12-19 Mrunal Parate <Mrunal.Parate@te.com>
 * - Created
 * 
 */
public class ClsOppyTrgRefreshBUProfit {
    @Future
    public static void UpdateBUProfit(set<Id> oppId) {

        List<Opportunity_Part__c> OppParts= [Select Id,Opportunity__c,CBC5_Code__c,BU_profit_center__c, Account_IBC_code__c, Distributor__c,Part_Number__c  FROM Opportunity_Part__c WHERE Opportunity__c =: oppId];
        
        if (OppParts!=null && OppParts.size()>0){ClsOppyPartUtil.allocateBUProfitCenter(OppParts);
        Update OppParts;
        }
    }
}