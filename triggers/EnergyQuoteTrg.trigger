/**
 * @author      Yuan Yao
 * @created     2017-08-24
 * @since       40.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2017-08-24 Yuan Yao <yuan.yao@capgemini.com>
 * - Created 
 **/
trigger EnergyQuoteTrg on Energy_Quote__c (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    
    
    ClsTriggerFactory.createHandler(Energy_Quote__c.sObjectType);
}