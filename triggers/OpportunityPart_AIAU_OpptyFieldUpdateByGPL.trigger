/***********************************************************************************************************************
      Name : OpportunityPart_AIAU_OpptyFieldUpdateByGPL
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : populate PGM,EGM,GPM values on Opportunity from added Oppty Part's GPL. 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL                                            User Story #                  
________________________________________________________________________________________________________________________
   1.0 Rama krishna    
   2.0 Ravi           12/17/2013   Modification                                     D-1328
   3.0 Padmaja        03/20/2014   Modification                                     D-0625
   4.0 Mrunal         06/30/2014   Modified complete code to remove dependancy on
                                   Manager_Hierarchy__c field and changed its name
                                   from Globla_Product_Manage_Name_By_GPL_Code
***********************************************************************************************************************/
    /** Update opportunity fields PGM, EGM, GPM with GPL field values on insert and update of Opportunity Part **/
    /**
    1. Check whether trigger is executing first time or not.
    2. Loop on all parts and check for records type i.e. sales or proposal type. Only those opportunity part whose record type not equal to sales OR if it is equal to sales then Number of proposal type opportunity should be zero. Only in these 2 cases it will check for non null GPL value and add ids in Set.
    3. Query on GPL for the set of gpl ids.
    4. Query on Opportunity for the set of opportunity Id and oppty stage not 'Rejected - Closed' .
    5. Loop on the Opportunity List.Update PGM, EGM, GPM field values of opportunity the GPL field value of opportunity part.    
    **/
trigger OpportunityPart_AIAU_OpptyFieldUpdateByGPL on Opportunity_Part__c (After insert, After update) {
    Set<Id> gplIdSet = new Set<Id>();
    Set<Id> oppIdSet = new Set<Id>();
    list<Opportunity> opptyList = new list<Opportunity>();
    list<Product_Hierarchy__c> gplList = new list<Product_Hierarchy__c>();
    Map<id, id> prodIdRecMap = new Map<id, id>();
    Map<id, id> mapOpptyIdTogplId = new Map<id, id>();
    list<Opportunity> opptyListToUpdate = new list<Opportunity>();
    Map<id, Product_Hierarchy__c> mapGPLidToObject = new map<id, Product_Hierarchy__c>();
    
    // 1. Check whether trigger is executing first time or not.
    if(CSD_One_Time_Execution.canTrigger('OpportunityPart_AIAU_OpptyFieldUpdateByGPL')){ 
    
        // 2. Loop on all parts and check for records type i.e. sales or proposal type. Only those opportunity part whose record type not equal to sales OR if it is equal to sales then Number of proposal type opportunity should be zero. Only in these 2 cases it will check for non null GPL value and add ids in Set.
        for(Opportunity_Part__c opptyPart: trigger.new){
            if(opptyPart.RecordTypeId != Consumer_Device_Opportunity_Record_Types__c.getinstance('Sales_Parts').Record_Type_Id__c || (opptyPart.RecordTypeId == Consumer_Device_Opportunity_Record_Types__c.getinstance('Sales_Parts').Record_Type_Id__c && opptyPart.Proposal_Part_Count__c == 0)){
                if(opptyPart.GPL__c!=null){
                    gplIdSet.add(opptyPart.GPL__c);
                    oppIdSet.add(opptyPart.Opportunity__c);
                    mapOpptyIdTogplId.put(opptyPart.Opportunity__c, opptyPart.GPL__c);  
                }
            }
        }
    }
    
    // 3. Query on GPL for the set of gpl ids.
    if(gplIdSet != null && gplIdSet.size()>0){
        gplList = [Select Id, Global_PM__c, CSD_EGM__c, Product_Manager__c, CBC1__c from Product_Hierarchy__c where Id in: gplIdSet];
        mapGPLidToObject.putAll(gplList);
    }
    
    // 4. Query on Opportunity for the set of opportunity Id.
    if(oppIdSet != null && oppIdSet.size()>0){
        opptyList = [Select id, name, Global_Product_Manager__c, Engineerning_General_Manager__c, Product_General_Manager__c,StageName from Opportunity where id in: oppIdSet AND StageName != 'Rejected - Closed'];
        
        // 5. Loop on the Opportunity List.Update PGM, EGM, GPM field values of opportunity whose stage is not 'Rejected - Closed' with the GPL field value of Oppty part.
        for(Opportunity oppty : opptyList){
            if(mapOpptyIdTogplId.get(oppty.Id) != null && mapGPLidToObject.get(mapOpptyIdTogplId.get(oppty.Id))!= null){
                oppty.Global_Product_Manager__c = mapGPLidToObject.get(mapOpptyIdTogplId.get(oppty.Id)).Global_PM__c;
                oppty.Engineerning_General_Manager__c = mapGPLidToObject.get(mapOpptyIdTogplId.get(oppty.Id)).CSD_EGM__c;
                oppty.Product_General_Manager__c = mapGPLidToObject.get(mapOpptyIdTogplId.get(oppty.Id)).Product_Manager__c;
                if(mapGPLidToObject.get(mapOpptyIdTogplId.get(oppty.Id)).Global_PM__c != null || mapGPLidToObject.get(mapOpptyIdTogplId.get(oppty.Id)).CSD_EGM__c != null || mapGPLidToObject.get(mapOpptyIdTogplId.get(oppty.Id)).Product_Manager__c != null){
                    opptyListToUpdate.add(oppty);
                }
            }
                
        }
        if(opptyListToUpdate!= null || opptyListToUpdate.size()>0){
            update opptyListToUpdate;
        }
    }
}