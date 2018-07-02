/***********************************************************************************************************************
      Name : NDR_Distributor_update
       Org : C2S
 Copyright : © 2014 TE Connectivity 
========================================================================================================================
   Summary : This trigger updates the Distributor field on NDR opportunity based on the 'Distributor__c' picklist values and 'NDR_Sold_to_Account_Name__c'
========================================================================================================================
 Algorithm Used:
 
 1) Get all the values from the Distributor__c picklist.
 2) Build a map where key is the picklist value by removing '.' and value is the exact picklist value.Also prepare a 
    total string by concatenating all the picklist values.
 3) Search for the "NDR_Sold_to_Account_Name__c " value in the picklist map
    a) Direct Match: checks for direct match of "NDR_Sold_to_Account_Name__c" value in the constructed map.
    b) contains clause: Split the "NDR_Sold_to_Account_Name__c" by spaces and search it in total string.
    c) If any match is not found then update with "Distributor not Defined" value.
======================================================================================================================== 
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi         1/13/2014   Initial Development         D-1330
     2.0 Anil Attelli 5/22/2014   Enhancement                 D-1330
***********************************************************************************************************************/

trigger NDR_Distributor_update on Opportunity (before insert, before update) {
    //GET ID OF NDR/CCR OPPORTUNITIES 
    //Change start by Mrunal for CCR Project
    //Static Id NDRRecTypeId = Apex_Helper_Settings__c.getinstance('NDR Opportunity').Value__c;
    //String vNDRId = ((String)NDRRecTypeId).substring(0,15); //15 DIGIT ID TO COMPARE
    Set<Id> rt_id = new Set<Id>();

    for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
        if(rt.Active__c && rt.Group__c == 'RFQ 2.0 Quotes' && rt.RecordTypeID__c!= null)
            rt_id.add(rt.RecordTypeID__c);
    }
    //Change End by Mrunal for CCR Project

    // 1) Getting all Picklist Values of Distributor Picklist
    Schema.DescribeFieldResult fieldResult = Opportunity.Distributor__c.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    
    // 2) Building a Map with this picklist values
    String totStr;
    Map<String,String> picklistmap=new Map<String,String>();
    for(Schema.PicklistEntry sp:ple){
        picklistmap.put(sp.getValue().remove('.'),sp.getValue());
        totStr=totstr+','+sp.getValue();
    }
    System.debug('@@@ picklistmap @@@'+ picklistmap.keyset());
    System.debug('@@@ picklistmap @@@'+ picklistmap.values());
       
    if((trigger.isInsert || trigger.isUpdate) && trigger.isBefore){
        for(Opportunity vOpp : Trigger.new){
            //if(vOpp.RecordTypeId != null && (((String)vOpp.RecordTypeId).substring(0,15)).contains(vNDRId)){//Comment for CCR Project
            if(vOpp.RecordTypeId != null && (rt_id.contains(vOpp.RecordTypeId))){// Added for CCR
                if(trigger.isInsert){
                    if(vOpp.NDR_Sold_to_Account_Name__c != null && picklistmap.containsKey((vOpp.NDR_Sold_to_Account_Name__c).remove('.'))){
                        vOpp.Distributor__c = picklistmap.get((vOpp.NDR_Sold_to_Account_Name__c).remove('.'));
                    }
                    else if((vOpp.NDR_Sold_to_Account_Name__c) != null){
                            String updatestr =StringSearchhandlerutil.search(totstr,vOpp.NDR_Sold_to_Account_Name__c);
                            vOpp.Distributor__c = updatestr;
                    }
                }
                else{
                    if((vOpp.NDR_Sold_to_Account_Name__c != Trigger.OldMap.get(vOpp.Id).NDR_Sold_to_Account_Name__c)
                       && vOpp.NDR_Sold_to_Account_Name__c != null 
                       && picklistmap.containsKey((vOpp.NDR_Sold_to_Account_Name__c).remove('.'))){
                        vOpp.Distributor__c = picklistmap.get((vOpp.NDR_Sold_to_Account_Name__c).remove('.'));
                    }
                    else if((vOpp.NDR_Sold_to_Account_Name__c) != null && (vOpp.NDR_Sold_to_Account_Name__c != Trigger.OldMap.get(vOpp.Id).NDR_Sold_to_Account_Name__c) ){
                             String updatestr =StringSearchhandlerutil.search(Totstr,vOpp.NDR_Sold_to_Account_Name__c);
                             vOpp.Distributor__c = updatestr;
                    }
                
                }
            }
        }
    }
}