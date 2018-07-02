/**
 * This trigger used to update BU_profit_center__c of Opportunity_Part__c.
 *
 * @author      Xiaona Liu
 * @created     2013-06-17
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2013-06-17 Xiaona Liu <xiaona.liu@itbconsult.com>
 * - Created 
 * 
 */
trigger OpportunityPart_BIU_updateBUprofitcenter on Opportunity_Part__c (before insert, before update) {
	ClsOppyPartUtil.allocateBUProfitCenter(trigger.new);
}