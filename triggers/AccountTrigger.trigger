/**
 * @author      Chen Chen
 * @created     2017-02-06
 * @since       37.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2017-02-06 Chen Chen <chen.chen@oinio.com>
 * - Created 
 **/
trigger AccountTrigger on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    ClsTriggerFactory.createHandler(Account.sObjectType);
}