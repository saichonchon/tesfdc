/**
* This class is Account's class.
* 
* @author    Chen Chen
* @created    2017-03-24
* @since     39.0 (Force.com ApiVersion)
* @version   1.0
* 
* @changelog
* 2017-03-21 Chen Chen <chen.chen@oinio.com>
* - Created
*
* 2017-05-04 Michael Ludwig <michael_ludwig@te.com>
* added changes for Case 809067
*
* 2017-07-31 Michael Ludwig <michael_ludwig@te.com>
* added changes for Case 901409
*/
public class AccountTrgHandler extends ClsTriggerVirtual{
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isAfter) return;  
        // set Business Unit and Business Unit Level 2        
        updateAccountBusinessUnit(trgCtx);
    }
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        if(trgCtx.isBefore) return;
        
        //set Opportunity_Gam_Code__c for OpportunityPartner
        updateOppyGamCode(trgCtx);
    }
    
    public void updateOppyGamCode(ClsWrappers.TriggerContext trgCtx) {
        String currentProfileId = '';
        set<String> set_oppyIds = new set<String>();
        set<String> set_profileIds = new set<String>();
        set<String> set_acctIds = new set<String>();
        list<Opportunity> list_oppys = new list<Opportunity>();
        list<Sobject> list_oppyPartners = new list<Sobject>();
        list<OpportunityPartnerTrgHelper__c> list_oppyPartnerHelpers = new list<OpportunityPartnerTrgHelper__c>();
        
        list_oppyPartnerHelpers = OpportunityPartnerTrgHelper__c.getall().values();
        
        //get usrId in custom setting
        for(OpportunityPartnerTrgHelper__c oppyPH : list_oppyPartnerHelpers) {
            if(String.valueOf(oppyPH.Value__c).length() >= 3) {
                if(oppyPH.Value__c.substring(0,3) == '00e') {//Profile
                    if(String.valueOf(oppyPH.Value__c).length() >= 15)
                        set_profileIds.add(String.valueOf(oppyPH.Value__c).substring(0,15)); 
                }
            }
        }
        
        //get Current User Id
        currentProfileId = UserInfo.getProfileId();
        currentProfileId = currentProfileId.substring(0,15);
        
        //if current not to be allowed, return
        if(!set_profileIds.contains(currentProfileId)) {
            return ;
        }
        
        if(trgCtx.isUpdate) {
            //get acctIds when update
            for(String acctId : trgCtx.newMap.keySet()) {
                if(trgCtx.oldMap.get(acctId).get('GAMCD__c') != trgCtx.newMap.get(acctId).get('GAMCD__c')) {
                    set_acctIds.add(String.valueOf(trgCtx.newMap.get(acctId).get('Id')));
                }
            }
            
            //get Opportunity Partner to get Oppy Id
            for(Opportunity_Partner__c oppPartner : [select Id, Opportunity__c, Account_GamCode__c 
                                                     From Opportunity_Partner__c 
                                                     Where Account__c IN: set_acctIds]) {
                                                         list_oppyPartners.add(oppPartner);                       
                                                     }
            
            //get Opportunity id
            if(list_oppyPartners.size() > 0) {
                set_oppyIds = ClsOppyPartnerUtil.getOppyIds(list_oppyPartners);
            }else {
                return ;
            }
        }else if(trgCtx.isDelete) {
            //get acctIds when Delete
            for(String acctId : trgCtx.oldMap.keySet()) {
                set_acctIds.add(String.valueOf(trgCtx.oldMap.get(acctId).get('Id')));
            }
            
            //get Opportunity Partner to get Oppy Id
            for(Opportunity_Partner__c oppPartner : [select Id,Opportunity__c,Account_GamCode__c 
                                                     From Opportunity_Partner__c 
                                                     Where Account__c IN: set_acctIds]) {
                                                         list_oppyPartners.add(oppPartner);                       
                                                     }
            
            //get Opportunity id
            if(list_oppyPartners.size() > 0) {
                set_oppyIds = ClsOppyPartnerUtil.getOppyIds(list_oppyPartners);
            }else {
                return ;
            }
        }
        
        if(set_oppyIds.size() > 0) {
            //get Opportunity_Gam_Code__c in Opportunity according to OpportunityPartner
            list_oppys = ClsOppyPartnerUtil.updateOppyGamCode(set_oppyIds);
        }
        if(list_oppys.size() > 0) {
            try{
                update list_oppys;
            }catch(exception ex){
                throw new ClsTriggerException('Update Opportunity Fail : '+ ex);
            }
        }
    }
    // Case 901409 Start
    
    public void updateAccountBusinessUnit(ClsWrappers.TriggerContext trgCtx){
        Map<String, Account_Business_Unit_L2__c> IBCMap = Account_Business_Unit_L2__c.getAll();
        Map<String, Account_Business_Unit_L2__c> IBCValues = new Map<String, Account_Business_Unit_L2__c>(); //map to hold values from Custom Setting
        
        for(string d : IBCMap.keyset()) {
            
            IBCValues.put(IBCMap.get(d).IBC__c, IBCMap.get(d));
            
        }
        
        Map<String, Trigger_Configuration__c> TrgConfMap = Trigger_Configuration__c.getAll();
        Map<String, Boolean> TrgConfValues = new Map<String, Boolean>(); //map to hold values from Trigger Configuration Custom Setting
        
        for(string d : TrgConfMap.keyset()) {
            
            TrgConfValues.put(TrgConfMap.get(d).Name, TrgConfMap.get(d).isRun__c);
            
        }
        
        IF(TrgConfValues.get('updateAccountBusinessUnit')){  
            IF(trgCtx.isInsert && trgCtx.isBefore){ 
                FOR(SObject so :trgCtx.newList ){
                    Account acc = (Account)so; 
                    IF(acc.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId()
                       && IBCValues.get(acc.INDUSTRY_BUSINESS_CDE__c) != null                       
                      ){
                          
                          acc.Industry_Code_Description__c = IBCValues.get(acc.INDUSTRY_BUSINESS_CDE__c).Business_Unit__c;
                          acc.Business_Unit_Level_2__c = IBCValues.get(acc.INDUSTRY_BUSINESS_CDE__c).Business_Unit_Level_2__c;
                          
                      }ELSE{
                          acc.Industry_Code_Description__c = null;
                          acc.Business_Unit_Level_2__c = null;
                      }
                    
                }
            }
            IF(trgCtx.isUpdate && trgCtx.isBefore){
                
                FOR(String a: trgCtx.newMap.keySet()){
                    IF(trgCtx.newMap.get(a).get('RecordTypeId') == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account').getRecordTypeId()){
                        IF (trgCtx.newMap.get(a).get('INDUSTRY_BUSINESS_CDE__c') != trgCtx.OldMap.get(a).get('INDUSTRY_BUSINESS_CDE__c')){
                            
                            SObject s = trgCtx.newMap.get(a);
                            Account acc = (Account)s; 
                            IF(IBCValues.get(acc.INDUSTRY_BUSINESS_CDE__c) != null){
                                acc.Industry_Code_Description__c = IBCValues.get(acc.INDUSTRY_BUSINESS_CDE__c).Business_Unit__c;
                                acc.Business_Unit_Level_2__c = IBCValues.get(acc.INDUSTRY_BUSINESS_CDE__c).Business_Unit_Level_2__c;
                            }ELSE{
                                acc.Industry_Code_Description__c = null;
                                acc.Business_Unit_Level_2__c = null;
                            }
                        }
                        
                    }
                } 
            }
        }
        
    } // Case 901409 End
}