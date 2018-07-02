/**
 * This class used to check for duplicate PLM value for Industrial Opportunity.
 * 
 * @author    Mrunal Parate
 * @created    2017-03-20
 * @since     37.0 (Force.com ApiVersion)
 * @version   1.0
 * 
 * @changelog
 * 2017-03-20 Mrunal Parate <Mrunal.Parate@te.com>
 * - Created
 * 
 */
 public class DuplicatePLMValueCheck{
    
    public static void avoidDuplicatePLM(List<Opportunity> list_oppys) {
        set<string> plmIdSet = new set<string>();
        set<Id> opptyIdSet = new set<Id>();
        List<Opportunity> duplicatePlmOpptyList = new List<Opportunity>();

        for(Opportunity oppy:list_oppys){
            plmIdSet.add(Oppy.PLM_Id__c);
            opptyIdSet.add(Oppy.Id);
        }
        if (plmIdSet!=null && plmIdSet.size()>0)    
        duplicatePlmOpptyList = [Select Id, PLM_Id__c From Opportunity where PLM_Id__c =: plmIdSet and id Not in: opptyIdSet];
        
        //system.debug('>>>>duplicatePlmOpptyList '+duplicatePlmOpptyList );
        Set<string> duplicatePLMIds = new Set<string >();
        for(Opportunity dup: duplicatePlmOpptyList )
        {         duplicatePLMIds.add(dup.PLM_Id__c);
        }
        for(Opportunity oppy:list_oppys){
            if(oppy.PLM_Id__c!=null)
            {
                //system.debug('>>>>oppy.PLM_Id__c'+oppy.PLM_Id__c);
               if(duplicatePLMIds.contains(oppy.PLM_Id__c))oppy.addError('Record already exist with same PLM Id');            
            }
        }
    }
}