/**
 * This apex class use to update Opportunity_Gam_Code__c on Opportunity.
 *
 * @author      Chen Chen
 * @created     2017-01-24
 * @since       37.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2017-01-24 Chen Chen <chen.b.chen@capgemini.com>
 * - Created 
 */
public class ClsOppyPartnerUtil {
    public static map<String,String> map_oppyId_oppyGamCode = new map<String,String>();
	
    public static set<String> getOppyIds(list<Opportunity_Partner__c> list_oppyPartner) {
    	set<String> set_oppyIds = new set<String>();
        set<String> set_oppyIds2Fliter = new set<String>();
        set<String> set_recordTypeIds = new set<String>();
        list<Opportunity_Record_Type_Groups__c> list_oppyRecordType = new list<Opportunity_Record_Type_Groups__c>();      
    	
        list_oppyRecordType = Opportunity_Record_Type_Groups__c.getall().values();
        for(Opportunity_Record_Type_Groups__c oppyRT : list_oppyRecordType) {
            if(oppyRT.RecordTypeID__c != null && oppyRT.RecordTypeID__c != '' && oppyRT.Active__c == true 
               && oppyRT.Group__c == 'GAM Code/Team Member Record Type') {
                set_recordTypeIds.add(oppyRT.RecordTypeID__c);                                                            
            }          
        }
        
    	if(list_oppyPartner != null) {
	    	for(Opportunity_Partner__c OppyPartner : list_oppyPartner) {
	    		set_oppyIds.add(OppyPartner.Opportunity__c);
	    	}
    	}
        
		map_oppyId_oppyGamCode = new map<String,String>();
        for(Opportunity oppy : [select Id, Opportunity_Gam_Code__c, RecordTypeId 
                                From Opportunity 
                                Where Id IN: set_oppyIds and RecordTypeId IN: set_recordTypeIds]) {
            
			set_oppyIds2Fliter.add(oppy.Id);
			map_oppyId_oppyGamCode.put(oppy.Id, oppy.Opportunity_Gam_Code__c);
        }
    	return set_oppyIds2Fliter;
    }
    
    public static list<Opportunity> updateOppyGamCode(set<String> set_oppyIds) {
      	map<String, String> map_oppyId_GamCode = new map<String, String>();
      	list<Opportunity> list_oppys = new list<Opportunity>();
      	list<Opportunity_Partner__c> list_oppyPartners = new list<Opportunity_Partner__c>();
      	
  		for(String oppId : set_oppyIds) {
  			if(!map_oppyId_GamCode.containsKey(oppId)) {
  				map_oppyId_GamCode.put(oppId, '');
  			} 
  		}
  		
  		for(Opportunity_Partner__c OppyPartner : [select id,Opportunity__c,Account__r.GAMCD__c 
  						 						  From Opportunity_Partner__c 
      						 					  Where Opportunity__c IN :set_oppyIds 
                                                  /*order by Account__r.GAMCD__c*/]) {
            
            if(OppyPartner.Account__r.GAMCD__c != null && OppyPartner.Account__r.GAMCD__c != '') {
                String oppyGamCode = map_oppyId_GamCode.get(OppyPartner.Opportunity__c);
                if(!oppyGamCode.contains(OppyPartner.Account__r.GAMCD__c + ';')) {
                    oppyGamCode += (OppyPartner.Account__r.GAMCD__c + ';');
                }
                map_oppyId_GamCode.put(OppyPartner.Opportunity__c, oppyGamCode);                                          
            }  			
  		}
  		
  		/*for(Opportunity oppy : [select id,Opportunity_Gam_Code__c From Opportunity Where id IN :set_oppyIds]) {
  			oppy.Opportunity_Gam_Code__c = map_oppyId_GamCode.get(oppy.Id);
  			list_oppys.add(oppy);
  		}*/
        for(String oppyId : map_oppyId_GamCode.keySet()) {
            Opportunity oppy = new Opportunity();
            oppy.Id = oppyId;
            oppy.Opportunity_Gam_Code__c = map_oppyId_GamCode.get(oppyId);
            list_oppys.add(oppy);
        }
  		
  		return list_oppys;
    }
    
    public static list<Opportunity> updateOppyGamCodebyTriggerData(set<String> set_oppyIds,list<Opportunity_Partner__c> list_newOppyPartners) {
      	map<String, String> map_oppyId_GamCode = new map<String, String>();
      	list<Opportunity> list_oppys = new list<Opportunity>();
      	list<Opportunity_Partner__c> list_oppyPartners = new list<Opportunity_Partner__c>();
      	
		//get map opportunityId,Opportunity_Gam_Code__c
  		for(String oppId : set_oppyIds) {
  			if(!map_oppyId_GamCode.containsKey(oppId)) {
                if(map_oppyId_oppyGamCode.get(oppId) == null || map_oppyId_oppyGamCode.get(oppId) =='') {
                    map_oppyId_GamCode.put(oppId, '');
                }else {
                    map_oppyId_GamCode.put(oppId, map_oppyId_oppyGamCode.get(oppId));
                }  				
  			} 
  		}
  		
  		for(Opportunity_Partner__c OppyPartner : list_newOppyPartners) {            
            if(OppyPartner.Account_GamCode__c != null && OppyPartner.Account_GamCode__c != '') {
                String oppyGamCode = map_oppyId_GamCode.get(OppyPartner.Opportunity__c);
                if(oppyGamCode == null || oppyGamCode == '' || !oppyGamCode.contains(OppyPartner.Account_GamCode__c + ';')) {
                    oppyGamCode += (OppyPartner.Account_GamCode__c + ';');
                }
                map_oppyId_GamCode.put(OppyPartner.Opportunity__c, oppyGamCode);                                          
            }  			
  		}
  		
        for(String oppyId : map_oppyId_GamCode.keySet()) {
            Opportunity oppy = new Opportunity();
            oppy.Id = oppyId;
            oppy.Opportunity_Gam_Code__c = map_oppyId_GamCode.get(oppyId);
            list_oppys.add(oppy);
        }
  		
  		return list_oppys;
    }
}