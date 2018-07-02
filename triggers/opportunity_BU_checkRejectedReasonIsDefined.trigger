/**
 * This trigger is used to avoid that a project is rejected over approval process without definition of a rejected reason.
 * The actual assigned approver is allowed to edit the opportunity, so before set the oppy to rejected by approval process, this has to be done first.
 *
 * @author      Frederic Faisst
 * @created     2012-04-05
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-04-05 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - Created
 */

trigger opportunity_BU_checkRejectedReasonIsDefined on Opportunity (before update) {
    
    for(Opportunity oppy : Trigger.new){
        if(oppy.StageName == 'Rejected' && (oppy.Lost_Rejected_Dead_On_Hold_Reason__c == '' || oppy.Lost_Rejected_Dead_On_Hold_Reason__c == null)){
			oppy.addError(system.label.No_rejected_reason_is_defined);   
        }
    }
}