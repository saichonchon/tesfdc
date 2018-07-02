/**
* 
*   This after insert/update trigger checks product owning GIBUs of the opportunities parts and 
*   validates that cross BUs are not allowed to submit an opportunity for approval.
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |03.05.2012  |Initial Draft
*
* 2014-05-08 Bin Yu <bin.yu@itbconsult.com>
* - added trigger-defense
*/

trigger opportunityPart_AIU_checkCrossBUupdOppy on Opportunity_Part__c (after insert, after update, after delete) {
    
    /*
    *   Define collections
    */
    //added by BYU 2014-05-08 
    if(ClsPMV_Util.runningTriggerName.indexOf('opportunityPart_AIU_checkCrossBUupdOppy') == -1){
        ClsPMV_Util.runningTriggerName += 'opportunityPart_AIU_checkCrossBUupdOppy';   
        Map<Id, Set<String>> map_OppyId_setProductOwningGIBUs = new Map<Id, Set<String>>();
        Map<String, Map<String, String>> map_customerBU_map_ProductGibu = new Map<String, Map<String, String>>();
        List<Opportunity> list_oppies2Update = new List<Opportunity>();
        Id salesPartsRecordTypeId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        
        //Get all data out of the custom setting "Cross BU Check" which contains the Customer BU vs. Product Owning BU matching table
        for(Cross_BU_Check__c cbucheck : Cross_BU_Check__c.getAll().values()){
            if(!map_customerBU_map_ProductGibu.containsKey(cbucheck.Customer_GIBU__c)){
                map_customerBU_map_ProductGibu.put(cbucheck.Customer_GIBU__c, new Map<String, String>());
            }
            map_customerBU_map_ProductGibu.get(cbucheck.Customer_GIBU__c).put(cbucheck.Product_Owning_GIBU__c, cbucheck.Result__c);
        }
        set<id> setOppyID = new set<id>(); /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
        boolean isLastmodifieddatefieldsupdateallowed = Last_Modified_Field_Update_Permission__c.getInstance() != null ? Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c : false;/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
        //For all Oppy Parts in trigger loop
        if(trigger.isDelete) {
            for(Opportunity_Part__c oppyPart : Trigger.Old){
                if(oppyPart.RecordTypeId != salesPartsRecordTypeId)
                    map_OppyId_setProductOwningGIBUs.put(oppyPart.Opportunity__c, new Set<String>());
                else  if(isLastmodifieddatefieldsupdateallowed)/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                    setOppyID.add(oppyPart.Opportunity__c); /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
            }
        }
        else {
            if(trigger.isInsert){
                for(Opportunity_Part__c oppyPart : Trigger.New){
                    if(oppyPart.RecordTypeId != salesPartsRecordTypeId)
                        map_OppyId_setProductOwningGIBUs.put(oppyPart.Opportunity__c, new Set<String>());
                    else  if(isLastmodifieddatefieldsupdateallowed)/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                        setOppyID.add(oppyPart.Opportunity__c); /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                }
            }
            else{
                for(Opportunity_Part__c oppyPart : Trigger.New){
                    if(oppyPart.RecordTypeId != salesPartsRecordTypeId){
                        if(oppyPart.Product_Owning_BU__c != trigger.oldMap.get(oppyPart.Id).Product_Owning_BU__c)
                            map_OppyId_setProductOwningGIBUs.put(oppyPart.Opportunity__c, new Set<String>());
                        else  if(isLastmodifieddatefieldsupdateallowed)/*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                            setOppyID.add(oppyPart.Opportunity__c); /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                    }
                }               
            }
        }
            
        if(map_OppyId_setProductOwningGIBUs.size() > 0){
            //Get all parts of oppies those new or updated parts are in trigger loop
            for(Opportunity_Part__c oppyPart : [Select Id, Product_Owning_BU__c, Opportunity__c From Opportunity_Part__c Where Opportunity__c in :map_OppyId_setProductOwningGIBUs.keySet() and RecordTypeId != :salesPartsRecordTypeId]){ 
                map_OppyId_setProductOwningGIBUs.get(oppyPart.Opportunity__c).add(oppyPart.Product_Owning_BU__c);
            }
                    
            //Customer BU vs. Product Owning GIBU comparison
            for(Opportunity oppy : [Select Id, Industry_Code__c, Cross_BU_Check__c From Opportunity Where Id in :map_OppyId_setProductOwningGIBUs.keySet() or ID in :setOppyID]){ /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom added set in query where clause*/
                //For single product owning GIBU
                if(map_OppyId_setProductOwningGIBUs.containsKey(oppy.Id)) /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                {
                    if(map_OppyId_setProductOwningGIBUs.get(oppy.Id).size() == 1){
                        String productGibu = '';
                        for(String bbb : map_OppyId_setProductOwningGIBUs.get(oppy.Id)){
                            productGibu = bbb;
                        }
                        if(map_customerBU_map_ProductGibu.containsKey(oppy.Industry_Code__c) && map_customerBU_map_ProductGibu.get(oppy.Industry_Code__c).containsKey(productGibu)){
                            String owningGibu = map_customerBU_map_ProductGibu.get(oppy.Industry_Code__c).get(productGibu);
                            if(owningGibu == 'AP'){
                                oppy.Cross_BU_Check__c = true;
                                list_oppies2Update.add(oppy);
                            }
                            else{
                                oppy.Cross_BU_Check__c = false;
                                list_oppies2Update.add(oppy);
                            }   
                        }
                    }
                    else{
                        if(oppy.Cross_BU_Check__c == true){
                            oppy.Cross_BU_Check__c = false;
                            list_oppies2Update.add(oppy);
                        }
                    }
                }
                else /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
                    list_oppies2Update.add(oppy); /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom */
            }
            if(!list_oppies2Update.isEmpty()){
                update list_oppies2Update;
            }
        }
    }
}