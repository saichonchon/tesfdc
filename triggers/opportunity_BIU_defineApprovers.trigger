/**
* 
*   This retrieves the correct Approver Users.
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |13.03.2012  |Initial Draft
*   Frederic Faisst     |frederic.faisst@itbconsult.com     |23.05.2012  |CCAO Manager definition
*
Test class :TrgOppy_BIU_defineApprovers_Test
*/

trigger opportunity_BIU_defineApprovers on Opportunity (before insert, before update) {
    
    /*
    *   Collections & Variables
    */ 
    if(ClsOppyUtil.cloneOppty == false)
    {   
        Map<String, Opportunity_Approvers__c> map_oppyApprovers = Opportunity_Approvers__c.getAll();
        Map<Id, Id> map_oppyId_gamId = new Map<Id, Id>();
        Map<String, Id> map_gamCode_userId = new Map<String, Id>();
        Map<Id, Id> map_accId_accOwnerId = new Map<Id, Id>();
        Map<Id, Id> map_oppyId_produtManagerId = new Map<Id, Id>();
        Map<Id, Id> map_oppyId_regionalPMId = new Map<Id, Id>();//added by xia 2013-04-09               
        map<Id, Id> map_oppyId_regionalPMUSId = new Map<Id, Id>();//added by lili zhao 2014-11-05
        map<Id, Id> map_oppyId_regionalPMEMEAId = new Map<Id, Id>();//added by lili zhao 2014-11-05
        map<Id, Id> map_oppyId_regionalPMJpanId = new Map<Id, Id>();//added by lili zhao 2014-11-05
        map<Id, Id> map_oppyId_regionalPMIndiaId = new Map<Id, Id>();//added by lili zhao 2014-11-05        
        map<Id, Id> map_oppyId_amHierarchyId = new Map<Id, Id>();
        Map<Id, Id> map_ownerId_ownerManagerId = new Map<Id, Id>();
        Set<Id> set_oppyIds = new Set<Id>();
        Set<String> set_gamCodes = new Set<String>();
        Set<Id> set_accIds = new Set<Id>();
        Set<Id> set_accsWithGlobalAcc = new Set<Id>();
        Id gamRecordTypeId = Apex_Helper_Settings__c.getInstance('GAM Record Type Id').Value__c;
        
        /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom ---start*/

        String strLastModifiedByCustom = UserInfo.getName()+'  '+ dateTime.now().format();//added by xia 2013-04-03
        datetime dtDatetimeNow = Datetime.now();
        if(Last_Modified_Field_Update_Permission__c.getInstance() != null && Last_Modified_Field_Update_Permission__c.getInstance().Allow_Update__c)
            for(Opportunity oppy: trigger.new)
            {
                oppy.Last_Modified_By_Custom__c = strLastModifiedByCustom;
                oppy.Last_Modified_Date__c = dtDatetimeNow;
            }
        /*Case - 00900368: Updated by Pankaj Raijade 2015-12-10 update field last modified by custom ---end*/

        
        List<String> list_AC_GPLs01 = new List<String>();
        List<String> list_AC_GPLs02 = new List<String>();
        List<String> list_IB_GPLs = new List<String>();
        List<String> list_Rail_GPLs = new List<String>();
        List<String> list_Rail_GPLs02 = new List<String>();
        
        if(map_oppyApprovers.get('A&C GPLs 01').GPLs__c != null && map_oppyApprovers.get('A&C GPLs 01').GPLs__c != ''){    
            list_AC_GPLs01 = map_oppyApprovers.get('A&C GPLs 01').GPLs__c.split(',');
        }
        if(map_oppyApprovers.get('A&C GPLs 02').GPLs__c != null && map_oppyApprovers.get('A&C GPLs 02').GPLs__c != ''){    
            list_AC_GPLs02 = map_oppyApprovers.get('A&C GPLs 02').GPLs__c.split(',');
        }
        if(map_oppyApprovers.get('IB GPLs').GPLs__c != null && map_oppyApprovers.get('IB GPLs').GPLs__c != ''){
            list_IB_GPLs = map_oppyApprovers.get('IB GPLs').GPLs__c.split(',');
        }
        if(map_oppyApprovers.get('Rail GPLs').GPLs__c != null && map_oppyApprovers.get('Rail GPLs').GPLs__c != ''){
            list_Rail_GPLs = map_oppyApprovers.get('Rail GPLs').GPLs__c.split(',');
        }
        
        // modified by lili zhao 2014-11-12 due to add the custom setting 'Rail GPLs 02'
        if(map_oppyApprovers.containsKey('Rail GPLs 02') && map_oppyApprovers.get('Rail GPLs 02').GPLs__c != null && map_oppyApprovers.get('Rail GPLs 02').GPLs__c != ''){
            list_Rail_GPLs02 = map_oppyApprovers.get('Rail GPLs 02').GPLs__c.split(',');
        }
        //system.debug('list_Rail_GPLs02:::: '+list_Rail_GPLs02);
        // end 
        
        //modified by BYU 2013-02-28 because the approver could not be updated by trigger defense
        //if(trigger.isInsert && ClsTriggerRecursionDefense.defineApproversInsert || trigger.isUpdate && ClsTriggerRecursionDefense.defineApproversUpdate){// removed by BYU 2013-02-28
        for(Opportunity oppy : Trigger.new){
            //set_oppyIds.add(oppy.Id);
            if(oppy.AccountId != null) set_accIds.add(oppy.AccountId);
            //if(oppy.AM_Hierarchy__c != null) map_oppyId_amHierarchyId.put(oppy.Id, oppy.AM_Hierarchy__c);
            
            // Modified if codition for populating Engineering manager field for ticket  INC0022014  
            // changed oppy.Industry_Code__c to  oppy.Customer_Business_Unit_level2__c
            
            if (map_oppyApprovers.containsKey(oppy.Customer_Business_Unit_level2__c) && map_oppyApprovers.get(oppy.Customer_Business_Unit_level2__c) != null) {
                oppy.Engineering_Manager__c = map_oppyApprovers.get(oppy.Customer_Business_Unit_level2__c).Approver_Id__c;                
            }
            
            if(oppy.GAM_Code__c != null && oppy.GAM_Code__c != ''){
                set_gamCodes.add(oppy.GAM_Code__c);
            }   
            if(Trigger.isUpdate  )       
         {      set_oppyIds.add(oppy.Id);
                   
          }    
            if(Trigger.isUpdate && (oppy.Request_Type__c == 'Cable Assembly - New Dev' || oppy.Request_Type__c == 'Cable Assembly - Extension')){
                Boolean findGPL = false;    
                if(!list_AC_GPLs01.isEmpty()){
                    for(String gpl : list_AC_GPLs01){
                        if(oppy.Defined_GPLs__c != null){
                            if(oppy.Defined_GPLs__c.contains(gpl)){
                                findGPL = true;
                                oppy.CCAO_Manager__c = map_oppyApprovers.get('A&C GPLs 01').Approver_Id__c;
                            }
                        }
                    }
                }
                
                if(!list_AC_GPLs02.isEmpty()){
                    for(String gpl : list_AC_GPLs02){
                        if(oppy.Defined_GPLs__c != null){
                            if(oppy.Defined_GPLs__c.contains(gpl)){
                                findGPL = true;
                                oppy.CCAO_Manager__c = map_oppyApprovers.get('A&C GPLs 02').Approver_Id__c;
                            }
                        }
                    }
                }
                
                if(!list_IB_GPLs.isEmpty()){
                    for(String gpl : list_IB_GPLs){
                        if(oppy.Defined_GPLs__c != null){             
                            if(oppy.Defined_GPLs__c.contains(gpl)){
                                findGPL = true;
                                oppy.CCAO_Manager__c = map_oppyApprovers.get('IB GPLs').Approver_Id__c; 
                            }
                        }
                    }
                }
                
                if(!list_Rail_GPLs.isEmpty()){
                    for(String gpl : list_Rail_GPLs){
                        if(oppy.Defined_GPLs__c != null){
                            if(oppy.Defined_GPLs__c.contains(gpl)){
                                findGPL = true;
                                oppy.CCAO_Manager__c = map_oppyApprovers.get('Rail GPLs').Approver_Id__c; 
                            }
                        }
                    }
                }
                
                // modified by lili zhao 2014-11-12 due to add the custom setting 'Rail GPLs 02'
                if(!list_Rail_GPLs02.isEmpty()) {
                    //system.debug('list_Rail_GPLs02:::'+list_Rail_GPLs02);
                    for(String gpl : list_Rail_GPLs02){
                        if(oppy.Defined_GPLs__c != null && oppy.Defined_GPLs__c.contains(gpl)){
                            findGPL = true;
                            oppy.CCAO_Manager__c = map_oppyApprovers.get('Rail GPLs 02').Approver_Id__c; 
                            //system.debug('oppy:::'+oppy.CCAO_Manager__c);
                        }
                    }
                }
                // end
                
                // other cases
                if(!findGPL){
                    oppy.CCAO_Manager__c = map_oppyApprovers.get('FilterCenter').Approver_Id__c; 
                }
            }
        }
            //if(trigger.isInsert) ClsTriggerRecursionDefense.defineApproversInsert = false; // removed by BYU 2013-02-28
            //else if(trigger.isUpdate) ClsTriggerRecursionDefense.defineApproversUpdate = false;// removed by BYU 2013-02-28
        //}    // removed by BYU 2013-02-28
        
         system.debug(' set_oppyIds OUTSIDE :::::::::::'+set_oppyIds+'\n set_oppyIds.size() ::: '+set_oppyIds.size());
        
        if(trigger.isInsert && ClsTriggerRecursionDefense.defineApproversInsert || trigger.isUpdate && ClsTriggerRecursionDefense.defineApproversUpdate){  
            if(trigger.isInsert) ClsTriggerRecursionDefense.defineApproversInsert = false; // added by BYU 2013-02-28
            else if(trigger.isUpdate) ClsTriggerRecursionDefense.defineApproversUpdate = false;    // added by BYU 2013-02-28     
           
            system.debug(' set_oppyIds INSIDE :::::::::::'+set_oppyIds+'\n set_oppyIds.size() ::: '+set_oppyIds.size());
            
            if(set_oppyIds.size() > 0){     
                if(set_gamCodes.size() > 0){
                    for(User u : [Select Id, Grouped_Account_Code__c From User Where Grouped_Account_Code__c in :set_gamCodes]){
                        map_gamCode_userId.put(u.Grouped_Account_Code__c, u.Id);
                    }  
                }
                if(set_accIds.size() > 0){
                    for(Account acc : [Select Id, OwnerId, ParentId, Parent.RecordTypeId, Parent.Type From Account Where Id in :set_accIds]){
                        map_accId_accOwnerId.put(acc.Id, acc.OwnerId);
                        if(acc.ParentId != null && acc.Parent.RecordTypeId == gamRecordTypeId && acc.Parent.Type == 'Global Account'){
                            set_accsWithGlobalAcc.add(acc.Id);
                        }
                    }
                }
                
                System.debug('map_accId_accOwnerId:::::::'+map_accId_accOwnerId);
                if(set_accIds.size() > 0){
                    for(Account acc : [Select Id,Sales_Hierarchy__c From Account Where Id in :set_accIds]){
                        map_oppyId_amHierarchyId.put(acc.Id, acc.Sales_Hierarchy__c);
                  }
                  }
                  
             
                 System.debug('******* set_accIds:: '+set_accIds + '\n map_oppyId_amHierarchyId::::::::::::'+ map_oppyId_amHierarchyId);
                 
                if(map_oppyId_amHierarchyId.size() > 0){
                    //-- Changed by Rahul(10 Nov 2017)--optimize code-- add Level_7_Assigned_Users__c != null in where clause and commented if condition --//
                    for(Sales_Hierarchy__c sh : [Select Level_7_Assigned_Users__c, Level_6_Assigned_Users__c From Sales_Hierarchy__c Where Id in :map_oppyId_amHierarchyId.values() And Level_7_Assigned_Users__c != null]){
                        List<Id> list_level7Users = sh.Level_7_Assigned_Users__c.split(';');
                        List<Id> list_level6Users = new List<Id>();
                        if(sh.Level_6_Assigned_Users__c != null) list_level6Users = sh.Level_6_Assigned_Users__c.split(';');
                        for(Id level7User :list_level7Users){
                            if(!map_ownerId_ownerManagerId.containsKey(level7User)){
                                if(!list_level6Users.isEmpty()) map_ownerId_ownerManagerId.put(level7User, list_level6Users.get(0));
                                else map_ownerId_ownerManagerId.put(level7User, null);
                            }
                        }
                    }
                }
                
                map<Id,boolean> map_oppyId_isChina = new map<Id,boolean>();//added by xia 2013-04-09 china process
                map<Id,boolean> map_oppyId_isUS = new map<Id,boolean>();//added by lili zhao 2014-11-05 US process
                map<Id,boolean> map_oppyId_isEMEA = new map<Id,boolean>();//added by lili zhao 2014-11-05 EMEA process
                map<Id,boolean> map_oppyId_isIndia = new map<Id,boolean>();//added by lili zhao 2014-11-05 India process
                map<Id,boolean> map_oppyId_isJapan = new map<Id,boolean>();//added by lili zhao 2014-11-05 Japan process
                
                system.debug(' set_oppyIds :::::::::::'+set_oppyIds+'\n set_oppyIds.size() ::: '+set_oppyIds.size());
                // add lili zhao due to populate these field : Regional PM US, Regional PM EMEA , Regional PM Japan, Regional PM India
                system.debug('*************** oppyPart from SQL::'+[select id,Product_Manager_Id__c,Regional_PM_AP_Id__c,GPL__r.Regional_PM_US__c,GPL__r.Regional_PM_EU__c,GPL__r.Regional_PM_India__c,GPL__r.Regional_PM_Japan__c from Opportunity_Part__c where Opportunity__c in :set_oppyIds]);
               
                for(Opportunity_Part__c oppyPart : [select id from Opportunity_Part__c where Opportunity__c in :set_oppyIds]){
					system.debug('*************** oppyPart from SQL::'+oppyPart.id);
                }
             
             
             
            
                for(Opportunity_Part__c oppyPart : [Select GPL__r.Regional_PM_US__c, GPL__r.Regional_PM_EU__c, GPL__r.Regional_PM_India__c, GPL__r.Regional_PM_Japan__c, Opportunity__r.Owner.Region__c, Opportunity__r.OwnerId, 
                                                           Id, Opportunity__c, Opportunity__r.RecordTypeId, Product_Manager_Id__c,Opportunity__r.Account.Customer_Region__c, Opportunity__r.Request_Type__c,Regional_PM_AP_Id__c 
                                                    From Opportunity_Part__c 
                                                    Where Opportunity__c in :set_oppyIds 
                                                    and (Product_Manager_Id__c != null or Regional_PM_AP_Id__c != null or GPL__r.Regional_PM_US__c != null 
                                                        or GPL__r.Regional_PM_EU__c != null or GPL__r.Regional_PM_India__c != null or GPL__r.Regional_PM_Japan__c != null)]){
                    system.debug('oppyPart::: '+oppyPart);
                    System.debug(' Product_Manager_Id__c'+ oppyPart.Product_Manager_Id__c+'\n  Regional_PM_AP_Id__c ::'+ oppyPart.Regional_PM_AP_Id__c +
                         '\n GPL__r.Regional_PM_US__c :: '+ oppyPart.GPL__r.Regional_PM_US__c + '\n GPL__r.Regional_PM_EU__c::'+ oppyPart.GPL__r.Regional_PM_EU__c
                         +' GPL__r.Regional_PM_India__c :: '+ oppyPart.GPL__r.Regional_PM_India__c +  '\n GPL__r.Regional_PM_Japan__c   ::'+oppyPart.GPL__r.Regional_PM_Japan__c                   );
                
                 
                    
                    if(oppyPart.Product_Manager_Id__c != null && !map_oppyId_produtManagerId.containsKey(oppyPart.Opportunity__c)
                	//Added By Yiming Shen <yiming.shen@capgemini.com> at 2018/04/09
            		&& oppyPart.Opportunity__r.RecordTypeId != Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Energy - Sales').getRecordTypeId()
            		//Ended By Yiming Shen <yiming.shen@capgemini.com> at 2018/04/09
                    ) {
                    	map_oppyId_produtManagerId.put(oppyPart.Opportunity__c, oppyPart.Product_Manager_Id__c);
                    }
                    //added by xia 2013-04-09 china process -- start
                    if(oppyPart.Regional_PM_AP_Id__c != null && !map_oppyId_regionalPMId.containsKey(oppyPart.Opportunity__c)) map_oppyId_regionalPMId.put(oppyPart.Opportunity__c, oppyPart.Regional_PM_AP_Id__c);
                    if(!map_oppyId_isChina.containsKey(oppyPart.Opportunity__c)){
                        if(oppyPart.Opportunity__r.Account.Customer_Region__c == ClsOppyPartUtil.CHINA_REGION){
                            map_oppyId_isChina.put(oppyPart.Opportunity__c,true);
                        }else{
                            map_oppyId_isChina.put(oppyPart.Opportunity__c,false);
                        }
                    }
                    //added by xia 2013-04-09 china process -- end
                    
                    //added by lili zhao 2014-11-05 US, EMEA, India, Japan process -- start
                    if(oppyPart.GPL__r.Regional_PM_US__c != null && !map_oppyId_regionalPMUSId.containsKey(oppyPart.Opportunity__c)) {
                        map_oppyId_regionalPMUSId.put(oppyPart.Opportunity__c, oppyPart.GPL__r.Regional_PM_US__c);
                    }
                    if(oppyPart.GPL__r.Regional_PM_EU__c != null && !map_oppyId_regionalPMEMEAId.containsKey(oppyPart.Opportunity__c)) {
                        map_oppyId_regionalPMEMEAId.put(oppyPart.Opportunity__c, oppyPart.GPL__r.Regional_PM_EU__c);
                    }
                    if(oppyPart.GPL__r.Regional_PM_Japan__c != null && !map_oppyId_regionalPMJpanId.containsKey(oppyPart.Opportunity__c)) {
                        map_oppyId_regionalPMJpanId.put(oppyPart.Opportunity__c, oppyPart.GPL__r.Regional_PM_Japan__c);
                    }
                    if(oppyPart.GPL__r.Regional_PM_India__c != null && !map_oppyId_regionalPMIndiaId.containsKey(oppyPart.Opportunity__c)) {
                        map_oppyId_regionalPMIndiaId.put(oppyPart.Opportunity__c, oppyPart.GPL__r.Regional_PM_India__c);
                    }
                    
                    //added by lili zhao 2014-11-05 US process -- end
                }        
                system.debug('map_oppyId_regionalPMId::: '+map_oppyId_regionalPMId);
                for(Opportunity oppy : Trigger.new){            
                    if(Trigger.isInsert){
                        oppy.Account_Owner__c = map_accId_accOwnerId.get(oppy.AccountId);
                    }
                    
                    if(!map_ownerId_ownerManagerId.isEmpty()){
                        if(map_ownerId_ownerManagerId.containsKey(oppy.OwnerId)) oppy.Owners_Manager__c = map_ownerId_ownerManagerId.get(oppy.OwnerId);
                    }
                    
                    if(set_accsWithGlobalAcc.contains(oppy.AccountId)){
                        oppy.Key_Customer__c = true;
                    }
                    else{
                        oppy.Key_Customer__c = false;
                    }
                    
                    if(!map_gamCode_userId.isEmpty()){
                        if(map_gamCode_userId.containsKey(oppy.GAM_Code__c)) oppy.GAM__c = map_gamCode_userId.get(oppy.GAM_Code__c);
                    }
                             
                    if(!map_oppyId_produtManagerId.isEmpty()){
                        if(map_oppyId_produtManagerId.containsKey(oppy.Id)) oppy.Product_Manager__c = map_oppyId_produtManagerId.get(oppy.Id);
                    }
                    //Modified by bin yuan 2015-08-28 According to user story : https://c2s.my.salesforce.com/a0kE0000009MufD
                    //if(!map_oppyId_isChina.isEmpty()){
                    //    if(map_oppyId_isChina.containsKey(oppy.Id)){
                    //if(map_oppyId_isChina.get(oppy.Id) && map_oppyId_regionalPMId.containsKey(oppy.Id)){
                    if(map_oppyId_regionalPMId.containsKey(oppy.Id)){ 
                        oppy.Regional_PM_AP__c = map_oppyId_regionalPMId.get(oppy.Id);
                    }else{
                        oppy.Regional_PM_AP__c = null;
                    }
                    //    }
                    //}
                    
                    //added by lili zhao 2014-11-05 US, EMEA, India, Japan process -- start

                    oppy.Regional_PM_US__c = (map_oppyId_regionalPMUSId.containsKey(oppy.Id) ? map_oppyId_regionalPMUSId.get(oppy.Id) : null);

                    oppy.Regional_PM_EMEA__c = (map_oppyId_regionalPMEMEAId.containsKey(oppy.Id) ? map_oppyId_regionalPMEMEAId.get(oppy.Id) : null);
    
                    oppy.Regional_PM_Japan__c = (map_oppyId_regionalPMJpanId.containsKey(oppy.Id) ? map_oppyId_regionalPMJpanId.get(oppy.Id) : null);
                    
                    oppy.Regional_PM_India__c = (map_oppyId_regionalPMIndiaId.containsKey(oppy.Id) ? map_oppyId_regionalPMIndiaId.get(oppy.Id) : null);

                    //added by lili zhao 2014-11-05 US, EMEA, India, Japan process -- end
                }
            }
        }
    }
    
    
}