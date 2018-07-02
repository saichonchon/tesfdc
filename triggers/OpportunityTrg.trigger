/**
 * This trigger used to populate Partner on Opportunity Level.
 * 
 * @author      Jun Yu
 * @created     2016-08-12
 * @since       37.0 (Force.com ApiVersion)
 * @version     1.0
 * 
 * @changelog
 * 2016-08-12 Jun Yu <jun.yu@oinio.com>
 * - Created
 * 
 */
trigger OpportunityTrg on Opportunity (before insert,before update,before delete,after insert,after update,after delete,after undelete)  { 
    
   
    ClsTriggerFactory.createHandler(Opportunity.sObjectType);
}