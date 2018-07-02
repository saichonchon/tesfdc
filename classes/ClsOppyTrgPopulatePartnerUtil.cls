/**
 * This class used to create opportunityPartner and update opportunityPartner.
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
public class ClsOppyTrgPopulatePartnerUtil {
    //this method used to create opportunityPartners when new Opportunities;
    public static void createPartner(list<Opportunity> list_oppys_new) {
        map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
        Apex_Helper_Settings__c vNDRAccId = Apex_Helper_Settings__c.getInstance('Unidentified Account for NDR');
        for(Opportunity oppy : list_oppys_new) {
            //Added 'opp.AccountId != vNDRAccId.Value__c' condition in If to prevent creation of Opportunity partner 
            //when End account 'Unidentified Account for NDR'.
            if(oppy.AccountId != null ) //  && oppy.AccountId != vNDRAccId.Value__c)   //Commented if condition by archana as no suvh value present in custom setting
                {
                map_oppId_accId_new.put(oppy.Id,oppy.AccountId);
            }
        } 
        if(!map_oppId_accId_new.isEmpty()) {
            String mode = ClsOppyPartUtil.MODE_INSERT;
            ClsOppyPartUtil.PopulateOpptyPartner(mode, map_oppId_accId_new, null);
        }
     }
    //this method used to update opportunityPartner's Allocation__c when change opportunity's AccountId
    public static void updatePartner(list<Opportunity> list_oppys_new,Map<Id,Opportunity> map_Id_oppys_old) {
        String mode;
        map<Id,Id> map_oppId_accId_old = new map<Id,Id>();
        map<Id,Id> map_oppId_accId_new = new map<Id,Id>();
        for(Opportunity oppy : list_oppys_new) {
             if(oppy.AccountId != null && oppy.AccountId != map_Id_oppys_old.get(oppy.Id).AccountId){
                    //Whenever account on opportunity changes, we need to update the "primary" account with the new one. 
                 if(map_Id_oppys_old.get(oppy.Id).AccountId != null) {
                      map_oppId_accId_old.put(oppy.Id, map_Id_oppys_old.get(oppy.Id).AccountId);
                 }
                 map_oppId_accId_new.put(oppy.Id, oppy.AccountId);
             }
        } 
        if(!map_oppId_accId_old.isEmpty() || !map_oppId_accId_new.isEmpty()) {
            mode = ClsOppyPartUtil.MODE_UPDATE;
            ClsOppyPartUtil.PopulateOpptyPartner(mode, map_oppId_accId_new, map_oppId_accId_old);
        }
    }
}