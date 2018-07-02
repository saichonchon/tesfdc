/**
 * @author      Chen Chen
 * @created     2017-03-24
 * @since       37.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2017-02-06 Chen Chen <chen.chen@oinio.com>
 * - Created 
 **/
trigger OpportunityPartnerTrigger on Opportunity_Partner__c (before insert, before update,before delete, after delete, after insert, after undelete, 
after update) {
	ClsTriggerFactory.createHandler(Opportunity_Partner__c.sObjectType);
}