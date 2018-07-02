/** 
 * 
 *   This class will collect all functions opportunity part and some functions of Opportunity
 *
 * @author      Yinfeng Guo  
 * @created     2012-05-31
 * @since       23.0    
 * @version     1.0                                                                 
 * 
 * @changelog
 * 2012-09-04 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified : add method updateOppyStage 
 * 2012-05-31 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 *
 * @changelog
 * 2013-06-03 Xiaona Liu <xiaona.liu@itbconsult.com>
 * - Modified : update method updateOppyStage 
 * - Created
 *
 * @changelog
 * 2014-03-17 Lili Zhao <lili.zhao@itbconsult.com>
 * - Modified : The method is used to get the default status from custom setting(PMV_Sales_Stage_Setting__c).
 * - Created
 *  
 * @changelog
 * 2014-10-07 Mrunal Parate<Mrunal.Parate@zensar.in>
 * - Modified : added method updateNDROppyStage   
 */
global class ClsOppyPartUtilAPL {
    
    public static final String MODE_INSERT = 'INSERT';
    public static final String MODE_UPDATE = 'UPDATE';
    public static Boolean needCheckAlloc = true;
    public static Boolean needCriteria = true;
    public static boolean isRunTrigger = true;
    public static final set<String> set_chinaIndustry = new set<String>{'A&C','IB','Rail','Solar'};
    public static final string CHINA_REGION = 'China / HK / Taiwan';//added by xia 2013-04-09 china process
    
    //********************-=BEGIN:2013-06-17 added by Xiaona Liu<xiaona.liu@itbconsult.com>=-*****************
    public static Map<String,String> map_ProfitRule1 = new Map<String,String>();
    public static Map<String,String> map_ProfitRule2 = new Map<String,String>();
    public static Map<String,String> map_ProfitRule3 = new Map<String,String>();
    
    
    public static Set<String> setAccountIBCCodes = new Set<String>();
    public static List<Opportunity_Part__c> list_resultOppParts = new List<Opportunity_Part__c>();
    //********************-=END:2013-06-17  Xiaona Liu<xiaona.liu@itbconsult.com>=-***************************

    public static Set<String> setOppPartBUs = new Set<String>();    

   /*
    private static final String ACCOUNT_CM = 'CM';
    private static final String ACCOUNT_DISTRIBUTOR = 'Distributor';
    private static final String ACCOUNT_OEM = 'OEM';*/

   /**
    *  The method is used to get program opportunity record type id
    *
    @author Yinfeng Guo
    @created 2012-07-06
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-07-06 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */
    public static Id ProgramOpportunityRecordTypeId(){
        Id program_rt_id;
        if(Apex_Helper_Settings__c.getInstance('Program Opportunity Record Type Id') != null) program_rt_id = Apex_Helper_Settings__c.getInstance('Program Opportunity Record Type Id').Value__c;
        return program_rt_id;
    }
   
   /**
    *  The method is used to get program opportunity record type id
    *
    @author Yinfeng Guo
    @created 2012-07-06
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @return             void
    *
    @changelog
    * 2012-07-06 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */
    public static Id TenderOpportunityRecordTypeId(){
        Id tender_rt_id;
        if(Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id') != null) tender_rt_id = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        return tender_rt_id;
    }    
         
   /**
    *  The method is used when the field total amount, total revenue changed on program opportunity,
    *  we need to update the total amount, total revenue on Tender Opportunity
    *
    @author Yinfeng Guo
    @created 2012-07-06
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param set_tendarOpportunityIds      tender opportunity id
    *
    @return             void
    *
    @changelog
    * 2012-07-06 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */
    public static void UpdateTenderOpportunity(set<Id> set_tendarOpportunityIds){
        if(!set_tendarOpportunityIds.isEmpty()){
            
            map<Id, set<Id>> map_tenderOppyId_programOppyIds = new map<Id, set<Id>>();
            map<Id, Opportunity> map_tenderOppyId_tenderOppy = new map<Id, Opportunity>();
            map<Id, Opportunity> map_programOppyId_programOppy = new map<Id, Opportunity>();
            Id tender_rt_id = TenderOpportunityRecordTypeId();
            list<Opportunity> list_tenders2Update = new list<Opportunity>();
            
            for(Opportunity tender : [select Id, Amount, Five_Year_Value__c, Total_Opportunity_Value__c, Five_Year_Revenue__c from Opportunity where Id in: set_tendarOpportunityIds and RecordTypeId =: tender_rt_id]){
                map_tenderOppyId_tenderOppy.put(tender.Id, tender);
            }
            
            /*for(Opportunity program : [select Id, Tender__c, Amount, Five_Year_Revenue__c from Opportunity where Tender__c in: set_tendarOpportunityIds]){
                if(!map_tenderOppyId_programOppyIds.containsKey(program.Tender__c)) {
                    map_tenderOppyId_programOppyIds.put(program.Tender__c, new set<Id>());
                    map_tenderOppyId_programOppyIds.get(program.Tender__c).add(program.Id);
                    map_programOppyId_programOppy.put(program.Id, program);
                }
                else {
                    map_tenderOppyId_programOppyIds.get(program.Tender__c).add(program.Id);
                    map_programOppyId_programOppy.put(program.Id, program);
                }
            }*/
            
            for(Id tenderId : map_tenderOppyId_tenderOppy.keySet()){
                Opportunity tender = map_tenderOppyId_tenderOppy.get(tenderId);
                tender.Amount = 0;
                tender.Five_Year_Revenue__c = 0;
                tender.Total_Opportunity_Value__c= 0;
                tender.Five_Year_Value__c= 0;
                if(map_tenderOppyId_programOppyIds.get(tenderId) != null){
                    for(Id programId : map_tenderOppyId_programOppyIds.get(tenderId)){
                        tender.Amount = tender.Amount + map_programOppyId_programOppy.get(programId).Amount;
                        tender.Five_Year_Revenue__c = tender.Five_Year_Revenue__c + map_programOppyId_programOppy.get(programId).Five_Year_Revenue__c;
                        // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
                        
                        tender.Total_Opportunity_Value__c= tender.Total_Opportunity_Value__c+ map_programOppyId_programOppy.get(programId).Total_Opportunity_Value__c;
                        tender.Five_Year_Value__c= tender.Five_Year_Value__c+ map_programOppyId_programOppy.get(programId).Five_Year_Value__c;
                    }   
                }
                list_tenders2Update.add(tender);
            }
            
            if(!list_tenders2Update.isEmpty()) update list_tenders2Update;
        }
    }         
         
   /**
    * The method is used to populate opportunity partner in a opportunity trigger
    *
    @author Yinfeng Guo
    @created 2012-02-28
    @version 1.0
    @since 23.0  (Force.com ApiVersion)
    *
    @param mode                     the mode to invoice trigger
    @param map_oppId_accId_new      map's key is opportunity Id and the value is account Id
    @param map_oppId_accId_old      map's key is opportunity Id and the value is account Id
    *
    @return             void
    *
    @changelog
    * 2012-02-28 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */
    public static void PopulateOpptyPartner(String mode, map<Id,Id> map_oppId_accId_new, map<Id,Id> map_oppId_accId_old){
        needCheckAlloc = true;
        if(mode == MODE_INSERT){           
            if(!map_oppId_accId_new.isEmpty()){
                Opportunity_Partner__c oppPartner;
                list<Opportunity_Partner__c> list_oppPartners = new list<Opportunity_Partner__c>();                
                map<Id, String> map_accId_type = new map<Id, String>();
                Savepoint sp = Database.setSavepoint();
                
                for(Account a : [Select Id, Account_Type__c from Account where Id in: map_oppId_accId_new.values()]){
                    map_accId_type.put(a.Id, a.Account_Type__c);
                }
                for(Id oppId : map_oppId_accId_new.keySet()){
                    if(map_accId_type.containsKey(map_oppId_accId_new.get(oppId) ) && map_accId_type.get(map_oppId_accId_new.get(oppId)) != null){
                        oppPartner = new Opportunity_Partner__c();
                        oppPartner.Opportunity__c = oppId;
                        oppPartner.Account__c = map_oppId_accId_new.get(oppId);
                        oppPartner.Allocation__c = 100.00;
                        oppPartner.Primary__c = true;
                        oppPartner.Partner_Role__c = map_accId_type.get(map_oppId_accId_new.get(oppId));
                        list_oppPartners.add(oppPartner);   
                    }
                }
                try{
                    if(!list_oppPartners.isEmpty()) insert list_oppPartners;
                }
                catch(Exception e){
                    Database.rollback(sp);
                }              
            }
        }
        else if(mode == MODE_UPDATE){
            if(!map_oppId_accId_new.isEmpty() || !map_oppId_accId_old.isEmpty()){               
                list<Opportunity_Partner__c> list_oppPartners2Upsert = new list<Opportunity_Partner__c>();
                list<Opportunity_Partner__c> list_oppPartners2Delete = new list<Opportunity_Partner__c>();                          
                set<id> set_oppyId = new set<id>();
                set_oppyId.addAll(map_oppId_accId_new.keySet());
                set_oppyId.addAll(map_oppId_accId_old.keySet());
                map<Id, String> map_accId_type = new map<Id, String>();
                map<Id, List<Opportunity_Partner__c>> map_oppyId_oppypartners = new map<Id, List<Opportunity_Partner__c>>();
                map<Id, Decimal> map_oppyId_newAlloc =new map<Id, Decimal>();
                Savepoint sp = Database.setSavepoint();
                
                // get account type
                for(Account a : [Select Id, Account_Type__c from Account where Id in: map_oppId_accId_new.values()]){
                    map_accId_type.put(a.Id, a.Account_Type__c);
                }
                for(Id oppyId :set_oppyId){
                    if(!map_oppyId_oppypartners.containsKey(oppyId)) map_oppyId_oppypartners.put(oppyId, new List<Opportunity_Partner__c>());
                }
                // get existing partner
                for(Opportunity_Partner__c opc :[Select Id, Allocation__c, Primary__c, Account__c, Opportunity__c from Opportunity_Partner__c where Opportunity__c in: set_oppyId and (Account__c in :map_oppId_accId_old.values() or Account__c in :map_oppId_accId_new.values())] ){
                    if(map_oppyId_oppypartners.containsKey(opc.Opportunity__c)) map_oppyId_oppypartners.get(opc.Opportunity__c).add(opc);                                       
                }
                
                // no opportunity partner
                for(Id oppyId :map_oppyId_oppypartners.keySet()){
                    Decimal newAlloc = 0;
                    for(Opportunity_Partner__c opc :map_oppyId_oppypartners.get(oppyId)){
                        if(opc.Allocation__c != null) {
                            newAlloc += opc.Allocation__c;
                            opc.Allocation__c = 0;
                        }
                        list_oppPartners2Delete.add(opc);
                    }
                    Opportunity_Partner__c newPartner = new Opportunity_Partner__c();
                    newPartner.Opportunity__c = oppyId;
                    newPartner.Account__c = map_oppId_accId_new.get(oppyId);
                    newPartner.Partner_Role__c = map_accId_type.get(newPartner.Account__c);
                    newPartner.Allocation__c = newAlloc;
                    newPartner.Primary__c = true;
                    list_oppPartners2Upsert.add(newPartner); 
                }               
                
                try{
                    if(!list_oppPartners2Delete.isEmpty()) {
                        if(!list_oppPartners2Upsert.isEmpty()) needCheckAlloc = false;
                        delete list_oppPartners2Delete;
                    }
                    needCheckAlloc = true;               
                    if(!list_oppPartners2Upsert.isEmpty()) insert list_oppPartners2Upsert;
                }
                catch(Exception e){
                    Database.rollback(sp);
                }                              
            }
        }   
    }
    
    /**
    * The method is used to calculate opportunity allocation
    *
    @author Min Liu
    @created 2012-11-14
    @version 1.0
    @since 23.0  (Force.com ApiVersion)
    *
    @param mode                     set of oppy id
    *
    @return             void
    *
    @changelog
    * 2012-11-14 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public static void calOppyAllocation(Map<Id, List<Opportunity_Partner__c>> map_oppyId_oppyPartner){
        Map<Id, Decimal> map_oppyId_alloc = new Map<Id, Decimal>();
        List<Opportunity> list_oppy2Update = new List<Opportunity>();
        Apex_Helper_Settings__c vNDROppRT = Apex_Helper_Settings__c.getInstance('NDR Opportunity');
        Set<Id> set_non_ndr_oppyId_oppyPartner = new Set<Id>();
        for(Opportunity oppty : [select id,recordtypeid from opportunity where id IN: map_oppyId_oppyPartner.keySet()]){
            if(oppty.recordtypeid != vNDROppRT.Value__c){
                set_non_ndr_oppyId_oppyPartner.add(oppty.id);
            }
        } 
        for(Id oppyId :set_non_ndr_oppyId_oppyPartner){
            map_oppyId_alloc.put(oppyId, 0);
        }
        for(Opportunity_Partner__c opc :[Select Allocation__c, Opportunity__c from Opportunity_Partner__c where Opportunity__c IN :map_oppyId_alloc.keySet()]){
            Decimal tmpAlloc = 0;
            if(map_oppyId_alloc.containsKey(opc.Opportunity__c)) tmpAlloc = map_oppyId_alloc.get(opc.Opportunity__c);
            if(opc.Allocation__c != null) tmpAlloc += opc.Allocation__c;
            map_oppyId_alloc.put(opc.Opportunity__c, tmpAlloc);
        }
        if(!map_oppyId_alloc.isEmpty()){
            for(Opportunity oppy :[Select id, Sum_Part_Allocation__c from Opportunity where id IN :map_oppyId_alloc.keySet()]){
                oppy.Sum_Part_Allocation__c = map_oppyId_alloc.get(oppy.id);
                if(oppy.Sum_Part_Allocation__c != 100 && needCheckAlloc) map_oppyId_oppyPartner.get(oppy.id).get(0).addError(system.label.Oppy_Alloc_Msg);
                list_oppy2Update.add(oppy);
            }
            if(!list_oppy2Update.isEmpty()) update list_oppy2Update;
        }       
    }
    
    
    
   /**
    * The method is used to Validate whether Opportunity parts have the same Approver PM before insert
    *
    @author Yinfeng Guo
    @created 2012-05-31
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param map_oppyPartId_oppyId     key is opportunity part id, value is opportunity id
    @param map_oppyPartId_oppyPart    key is opportunity part id, value is opportunity part 
    *
    @return                       void
    *
    @changelog
    * 2012-05-31 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */
    /*public static void ValidatePM(map<Id, Id> map_oppyPartId_oppyId, map<Id, Opportunity_Part__c> map_oppyPartId_oppyPart){
        //system.debug('tongxia validatePM');
        //system.debug('tongxia map_oppyPartId_oppyPart:' + map_oppyPartId_oppyPart);
        map<Id, Opportunity> map_oppyId_oppy = new map<Id, Opportunity>();
        list<Opportunity> list_oppy2Update = new list<Opportunity>();
        map<Id, Integer> map_oppyId_partNumber = new map<Id, Integer>();
        if(map_oppyPartId_oppyId != null && !map_oppyPartId_oppyId.isEmpty()){
            for(Opportunity oppy : [SELECT Id, Product_Manager__c, Request_Type__c FROM Opportunity WHERE Id in: map_oppyPartId_oppyId.values() and  Request_Type__c =: ExtOpportunityPartEntry.REQUESTTYPE_E]){
                map_oppyId_oppy.put(oppy.Id, oppy);
            }
        }
        if(!map_oppyId_oppy.isEmpty()){
            for(Opportunity_Part__c op : [SELECT Id,Opportunity__c FROM Opportunity_Part__c WHERE Opportunity__c in: map_oppyId_oppy.keySet()]){
                if(!map_oppyId_partNumber.containsKey(op.Opportunity__c)){
                    map_oppyId_partNumber.put(op.Opportunity__c, 1);
                }
                else map_oppyId_partNumber.put(op.Opportunity__c, map_oppyId_partNumber.get(op.Opportunity__c)+1 );
            }
        }
        //system.debug('tongxia map_oppyPartId_oppyId:' + map_oppyPartId_oppyId);
        //system.debug('tongxia map_oppyId_partNumber:' + map_oppyId_partNumber);
        for(Id oppyPartId : map_oppyPartId_oppyId.keySet()){
            //system.debug('tongxia map_oppyId_partNumber.get( map_oppyPartId_oppyId.get(oppyPartId) ):' + map_oppyId_partNumber.get( map_oppyPartId_oppyId.get(oppyPartId) ));
            if( map_oppyId_partNumber.get( map_oppyPartId_oppyId.get(oppyPartId) ) >= 1){
                //system.debug('tongxia map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c:' + map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c);
                //system.debug('tongxia map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c):' + map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c);
                if( map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c != null &&  String.valueOf(map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c) != ''){
                    //system.debug('tongxia oppy manager:' + map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c);
                    //system.debug('tongxia part manager:' + map_oppyPartId_oppyPart.get(oppyPartId).Product_Manager_Id__c);
                    if(map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c != map_oppyPartId_oppyPart.get(oppyPartId).Product_Manager_Id__c){
                        map_oppyPartId_oppyPart.get(oppyPartId).addError(system.Label.Not_same_Approver_PM);
                    }
                }   
            }
            else if(map_oppyPartId_oppyPart.get(oppyPartId) != null){
                if(map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ) != null){
                    map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c = map_oppyPartId_oppyPart.get(oppyPartId).Product_Manager_Id__c;
                    list_oppy2Update.add(map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) )); 
                }
            }
        }
        if(!list_oppy2Update.isEmpty())  update list_oppy2Update;
    }*/
    /**
    * The method is used to Validate whether Opportunity parts have the same Approver PM before insert
    *
    @author Xia Tong
    @created 2013-01-09
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param map_oppyId_parts     key is opportunity id, value is opportunity parts
    @param set_deletePartId    opportunity part ids to delete 
    *
    @return                       void
    *
    @changelog
    * 2013-01-09 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */  
    public static  map<Id,boolean>  validatePartManager(map<Id, list<Opportunity_Part__c>> map_oppyId_parts,set<Id> set_deletePartId ){
        system.debug('tongxia: validatePartManager');
        system.debug('----------APL----map_oppyId_parts trigger---------------------' + map_oppyId_parts);
        system.debug('----------APL----map_oppyId_parts.size() trigger---------------------' + map_oppyId_parts.keySet().size());
        system.debug('----------APL----set_deletePartId trigger---------------------' + set_deletePartId);
        map<Id,boolean> map_oppyId_isError = new map<Id,boolean>();
        if(!map_oppyId_parts.isEmpty()){
            map<Id, Opportunity> map_oppyId_oppy = new map<Id, Opportunity>();
            for(Opportunity oppy : [SELECT Id, Product_Manager__c, Request_Type__c,Account.Customer_Region__c,Regional_PM_AP__c,Account.Customer_Industry__c FROM Opportunity WHERE Id in: map_oppyId_parts.keyset() /*and  Request_Type__c =: ExtOpportunityPartEntry.REQUESTTYPE_E*/]){//modified by xia 2013-04-09 china process
            	
                if(oppy.Account.Customer_Region__c == CHINA_REGION){ 
                    map_oppyId_oppy.put(oppy.Id, oppy);
                }else if(oppy.Request_Type__c == ExtOpportunityPartEntry.REQUESTTYPE_E){
                    map_oppyId_oppy.put(oppy.Id, oppy);
                }
                System.debug('---------APL--map_oppyId_oppy temp-----------'+map_oppyId_oppy);
            }
            map<Id, set<Id>> map_oppyId_partIds = new map<Id, set<Id>>();
            map<Id,Id> map_phId_PMId = new map<Id,Id>();
            map<Id,Id> map_phId_RegionalPMId = new map<Id,Id>();
            map<Id,list<Opportunity_Part__c>> map_phId_parts = new map<Id,list<Opportunity_Part__c>>();
            for(Id oppyId:map_oppyId_oppy.keyset()){
                map_oppyId_partIds.put(oppyId,new set<Id>());
                System.debug('---------APL--oppyId-------------'+oppyId);
                System.debug('----------APL-map_oppyId_parts-------------'+map_oppyId_parts);
                for(Opportunity_Part__c op: map_oppyId_parts.get(oppyId)){
                    System.debug('-----------APL--op.Id---------------'+op.Id);
                	System.debug('-----------APL--set_deletePartId---------------'+set_deletePartId);
                    if(op.Id != null && !set_deletePartId.contains(op.Id)) {
                        map_oppyId_partIds.get(oppyId).add(op.Id);
                        
                    }
                    System.debug('-------------APL---map_oppyId_partIds--------------'+map_oppyId_partIds);
                    if(op.GPL__c != null){
                        if(!map_phId_parts.containsKey(op.GPL__c)){
                            map_phId_parts.put(op.GPL__c,new list<Opportunity_Part__c>());
                        }
                        map_phId_parts.get(op.GPL__c).add(op);
                    }
                    
                }
            }
            if(!map_phId_parts.isEmpty()){
                for(Product_Hierarchy__c ph: [select id, Product_Manager__c,Regional_PM_AP__c from Product_Hierarchy__c where id in: map_phId_parts.keySet()]){
                    if(ph.Product_Manager__c != null){
                    	map_phId_PMId.put(ph.Id,ph.Product_Manager__c);
                    }
                    if(ph.Regional_PM_AP__c != null){
                    	map_phId_RegionalPMId.put(ph.Id,ph.Regional_PM_AP__c);
                    }
                }
            }
            
            if(!map_oppyId_oppy.isEmpty()){
                for(Opportunity_Part__c op : [SELECT Id,Opportunity__c,Product_Manager_Id__c,Regional_PM_AP_Id__c,GPL__c FROM Opportunity_Part__c WHERE Opportunity__c in: map_oppyId_oppy.keySet() and RecordType.DeveloperName!='Sales_Parts']){
                    System.debug('----------APL---map_oppyId_partIds1--------------'+map_oppyId_partIds);
                    System.debug('----------APL---map_oppyId_partIds.get(op.Opportunity__c)--------------'+map_oppyId_partIds.get(op.Opportunity__c));
                    System.debug('----------APL---op.Id--------------'+op.Id);
                    if(op.Product_Manager_Id__c != null && !map_oppyId_partIds.get(op.Opportunity__c).contains(op.Id) && !set_deletePartId.contains(op.Id)){
                    	map_oppyId_parts.get(op.Opportunity__c).add(op);
                    }
                }
            }
            
            //system.debug('tongxia: map_oppyId_parts:' + map_oppyId_parts);
           //system.debug('tongxia: map_phId_PMId:' + map_phId_PMId);
            for(Id oppyId: map_oppyId_oppy.keySet()){
                map_oppyId_isError.put(oppyId,false);
                set<Id> set_managers = new set<Id>();
                
                for(Opportunity_Part__c op: map_oppyId_parts.get(oppyId)){
                	
                    if(set_chinaIndustry.contains(map_oppyId_oppy.get(oppyId).Account.Customer_Industry__c) && map_oppyId_oppy.get(oppyId).Account.Customer_Region__c == CHINA_REGION){
                        
                        if(op.GPL__c != null && map_phId_RegionalPMId.containsKey(op.GPL__c)) {
                        //system.debug('tongxia: map_phId_PMId.get(op.GPL__c):' + map_phId_PMId.get(op.GPL__c));
                            set_managers.add(map_phId_RegionalPMId.get(op.GPL__c));
                        }else if(op.Regional_PM_AP_Id__c != null){
                            set_managers.add(op.Regional_PM_AP_Id__c);
                        }   
                    }else{
                        if(op.GPL__c != null && map_phId_PMId.containsKey(op.GPL__c)) {
                            //system.debug('tongxia: map_phId_PMId.get(op.GPL__c):' + map_phId_PMId.get(op.GPL__c));
                            set_managers.add(map_phId_PMId.get(op.GPL__c));
                        }else if(op.Product_Manager_Id__c != null){
                            set_managers.add(op.Product_Manager_Id__c); 
                        }
                    }
                    System.debug('---------APL----------set_managers-------------------'+set_managers);
                    if(set_managers.size() > 1){
                        map_oppyId_isError.put(oppyId,true);
                        break; 
                    }   
                }
                
            }
           
        }
        system.debug('--------------APL-------map_oppyId_isError trigger-----------------' + map_oppyId_isError);  
        return map_oppyId_isError;
        
        
    }
    
    /**
    * The method is used to update opportunity defined GPLs 
    *
    @author Xia Tong
    @created 2013-01-10
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param map_oppyId_gpls     key is opportunity id, value is old gpl and new gpl seperate by comma.
    *
    @return                       void
    *
    @changelog
    * 2013-01-10 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */     
    public static void updateOppyDefinedGPLs(map<Id, set<String>> map_oppyId_gpls){
        //system.debug('tongxia updateOppyDefinedGPLs map_oppyId_gpls: ' + map_oppyId_gpls);
        list<Opportunity> list_oppy = new list<Opportunity>();
        for(Opportunity oppy: [select id, Defined_GPLs__c from Opportunity where id in: map_oppyId_gpls.keyset()]){
            //system.debug('tongxia Defined_GPLs__c: ' + oppy.Defined_GPLs__c);
            set<String> set_definedGPLs= new set<String>();
            if(oppy.Defined_GPLs__c != null){
                for(String gpl: oppy.Defined_GPLs__c.split('\\|')){
                    if(gpl.trim() != null && gpl.trim() != ''){
                        set_definedGPLs.add(gpl);
                    }
                }
            }
            //system.debug('tongxia set_definedGPLs: ' + set_definedGPLs);
            for(String s: map_oppyId_gpls.get(oppy.Id)){
                list<String> gpls= new list<String>();
                gpls = s.split(',');
                
                if(gpls[0].trim() != '' && gpls[0].trim() != null){
                    if(set_definedGPLs.contains(gpls[0])){
                        set_definedGPLs.remove(gpls[0]);
                    }
                }
                if(gpls.size() > 1 && gpls[1].trim() != '' && gpls[1].trim() != null){
                    if(!set_definedGPLs.contains(gpls[1])){
                        set_definedGPLs.add(gpls[1]);
                    }
                }
                
            }
            oppy.Defined_GPLs__c = '';
            //system.debug('tongxia set_definedGPLs after: ' + set_definedGPLs);
            for(String gpl: set_definedGPLs){
                oppy.Defined_GPLs__c += gpl + '|';
            }
            if(oppy.Defined_GPLs__c.length() > 0){
                oppy.Defined_GPLs__c = oppy.Defined_GPLs__c.subString(0,oppy.Defined_GPLs__c.length()-1);
            }
            //system.debug('tongxia Defined_GPLs__c after: ' + oppy.Defined_GPLs__c);
            list_oppy.add(oppy);
            
        }
        //system.debug('tongxia: list_oppy:' + list_oppy);
        if(!list_oppy.isEmpty()) update list_oppy;
    
    }
    
    
        /**
    * The method is used to update opportunity defined GPLs 
    *
    @author Xia Tong
    @created 2013-01-10
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param set_oppyId     opportunity id
    *
    @return                       void
    *
    @changelog
    * 2013-01-10 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */ 
    
    public static void updateOppyDefinedGPLs(set<Id> set_oppyId){
        map<Id,Opportunity> map_oppyId_oppy = new map<Id,Opportunity>();
        for(Opportunity oppy: [select id, Defined_GPLs__c from Opportunity where id in: set_oppyId]){
            oppy.Defined_GPLs__c = '';
            map_oppyId_oppy.put(oppy.Id,oppy);
        }
        
        for(Opportunity_Part__c op: [select id,opportunity__c,GPL__c, GPL__r.Name from Opportunity_Part__c where opportunity__c in: map_oppyId_oppy.keyset()]){
            Opportunity oppy = map_oppyId_oppy.get(op.opportunity__c);
            if(oppy.Defined_GPLs__c == null) oppy.Defined_GPLs__c = '';
            if(op.GPL__r.Name != null && op.GPL__r.Name != '' && !oppy.Defined_GPLs__c.contains(op.GPL__r.Name)){
                oppy.Defined_GPLs__c += op.GPL__r.Name + '|';
            }
        }
        for(Opportunity oppy: map_oppyId_oppy.values()){
            if(oppy.Defined_GPLs__c.length() > 1) oppy.Defined_GPLs__c = oppy.Defined_GPLs__c.subString(0,oppy.Defined_GPLs__c.length()-1);
        }
        
        update map_oppyId_oppy.values();
    }
   /**
    * This method is used to process update Opportunity stage for given Opportunity Id set
    *
    @author Bin Yuan
    @created 2012-09-03
    @version 1.0
    @since 25.0 (Force.com ApiVersion)
    *
    @param set_oppyIdPar    set of Opportunity Id
    *
    *
    @changelog
    * 2012-09-03 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    *
     
    */

    public static void updateOppyStage(set<Id> set_oppyIdPar) {
        set<Id> set_oppyId2Update = new set<Id>();
        map<Id, set<String>> map_oppyId_oppyPartConfidenceSet = new map<Id, set<String>>();
        map<Id, String> map_oppyId_oppyStage = new map<Id, String>();
        set<Id> set_oppyNotNewId = new set<Id>();
        list<Opportunity> list_oppyModified = new list<Opportunity>();
        list<Opportunity> list_oppy2Update = new list<Opportunity>();
        set<String> set_openStatus = new set<String>{'Production', 'Ramp-down' , 'EOL'};
        //********************-=BEGIN:2013-07-30 added by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*****************
        set<id> oppRTIdSet = new set<id>();
        List<Consumer_Device_Opportunity_Record_Types__c> opRTList = Consumer_Device_Opportunity_Record_Types__c.getall().values();
        for(Consumer_Device_Opportunity_Record_Types__c rt: opRTList){
            if(rt.Name == 'Sales_Opportunity_CSD' || rt.Name == 'Engineering_Opportunity_CSD')
            {
                oppRTIdSet.add(rt.Record_Type_Id__c);
            }
        }
        //********************-=End:2013-07-30 added by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*****************
        if(!set_oppyIdPar.isEmpty()) {
            //for(Opportunity oppy : [Select Id, StageName From Opportunity Where Id in :set_oppyIdPar]) {
            //********************-= 2013-07-30 added record type condition in query by Ramakrishna Singara <ramakrishna.singara@zensar.in>=-*****************
            for(Opportunity oppy : [Select Id, StageName, RecordTypeId From Opportunity Where Id in :set_oppyIdPar  and RecordTypeId NOT in : oppRTIdSet]) {
                if(!set_oppyId2Update.contains(oppy.Id)) {
                    set_oppyId2Update.add(oppy.Id);
                    list_oppyModified.add(oppy);
                    if(oppy.StageName != 'New') {
                        if(!set_oppyNotNewId.contains(oppy.Id)) {
                            set_oppyNotNewId.add(oppy.Id);
                        }
                    }
                }
            }
        }
        //***************************-=BEGIN Add xiaona liu <xiaona.liu@itbconsult.com>=-****************************
        map<Id,Set<String>> map_oppyId_OppyPartProcessStatusSet = new Map<Id,Set<String>>();
        set<Id> set_wonOpenOppyId = new set<Id>();
        //***************************-=END Add xiaona liu <xiaona.liu@itbconsult.com>=-****************************
        
        if(!set_oppyId2Update.isEmpty()) {
            for(Opportunity_Part__c oppyPart : [Select Id, Status__c, Opportunity__c,Process_Status__c From Opportunity_Part__c Where Opportunity__c in :set_oppyId2Update ]) {
               
                //***************************-=BEGIN Add xiaona liu <xiaona.liu@itbconsult.com>=-****************************
                //***********************************************************************************************************
                //if oppyPart.Status__c == 'Won' && oppyPart.Process_Status__c == 'Pre-prod'   Phase=='Won - Open'
                if(oppyPart.Status__c == 'Won' && !set_openStatus.contains(oppyPart.Process_Status__c)){
                    set_wonOpenOppyId.add(oppyPart.Opportunity__c);
                }
                //***************************-=END Add xiaona liu <xiaona.liu@itbconsult.com>=-****************************
                //*********************************************************************************************************
                
                if(map_oppyId_oppyPartConfidenceSet.containsKey(oppyPart.Opportunity__c)) {
                    if(!map_oppyId_oppyPartConfidenceSet.get(oppyPart.Opportunity__c).contains(oppyPart.Status__c)) {
                        map_oppyId_oppyPartConfidenceSet.get(oppyPart.Opportunity__c).add(oppyPart.Status__c);
                    }
                } 
                else {
                    map_oppyId_oppyPartConfidenceSet.put(oppyPart.Opportunity__c, new set<String>{oppyPart.Status__c});
                }
                
                //***************************-=BEGIN Add xiaona liu <xiaona.liu@itbconsult.com>=-****************************
                //***********************************************************************************************************
                //new adds
                if(map_oppyId_OppyPartProcessStatusSet.containsKey(oppyPart.Opportunity__c)){
                    if(!map_oppyId_OppyPartProcessStatusSet.get(oppyPart.Opportunity__c).contains(oppyPart.Process_Status__c)) {
                        map_oppyId_OppyPartProcessStatusSet.get(oppyPart.Opportunity__c).add(oppyPart.Process_Status__c);
                    }
                }
                else{
                     map_oppyId_OppyPartProcessStatusSet.put(oppyPart.Opportunity__c, new Set<String>{oppyPart.Process_Status__c});
                }
               //***********************************************************************************************************                 
               //***************************-=END Add xiaona liu <xiaona.liu@itbconsult.com>=-******************************        
            }
        }
        
        //START modifyed 2013-05-30 minghao.li@itbconsult.com
        set<String> set_oppyPartConfidenceClosedDead = new set<String>{'Dead', 'Lost'};
        set<String> set_oppyPartConfidenceWonClosed = new set<String>{'Won', 'Dead', 'Lost'};
        
        for(Id oppyId : map_oppyId_oppyPartConfidenceSet.keySet()) {        
        //***************************-=BEGIN update xiaona liu <xiaona.liu@itbconsult.com>=-*****************************************************   
        //*****************************Modified version-- NEW*************************************************************************************
                
            if(set_wonOpenOppyId.contains(oppyId)){
                map_oppyId_oppyStage.put(oppyId, 'Won - Open');
            }
            else if(set_oppyPartConfidenceClosedDead.containsAll(map_oppyId_oppyPartConfidenceSet.get(oppyId))) {
                map_oppyId_oppyStage.put(oppyId, 'Lost/Dead - closed');
            }
            else if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won') && set_oppyPartConfidenceWonClosed.containsAll(map_oppyId_oppyPartConfidenceSet.get(oppyId)) && !map_oppyId_OppyPartProcessStatusSet.get(oppyId).contains('Pre-prod')) {
                map_oppyId_oppyStage.put(oppyId, 'Won - Closed');
            }
            else{
                if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Weak') || 
                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('50/50') ||
                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Likely') ||
                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Commit') ||
                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('On Hold')) {
                        
                   if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won')) {
                        map_oppyId_oppyStage.put(oppyId, 'Won - Open');
                    }
                    else if(!set_oppyNotNewId.isEmpty()) {
                        if(set_oppyNotNewId.contains(oppyId)) {
                            map_oppyId_oppyStage.put(oppyId, 'Approved/Active');
                        }   
                    }
                    /*  
                    if(!map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won') && set_oppyNotNewId.contains(oppyId)) {
                        map_oppyId_oppyStage.put(oppyId, 'Approved/Active');
                    }
                    */                          
                }
            }
            
           //*************************************************************************************************************************************
           //***************************-=END update xiaona liu <xiaona.liu@itbconsult.com>=-*****************************************************
        } 
        //START modifyed 2013-05-30 minghao.li@itbconsult.com
        
        //***************************-=BEGIN update xiaona liu <xiaona.liu@itbconsult.com>=-*****************************************************
        //***************************-=Modify the previous version=-*****************************************************************************
        /*
        if(!map_oppyId_oppyPartConfidenceSet.isEmpty()) {
            for(Id oppyId : map_oppyId_oppyPartConfidenceSet.keySet()) {
                if(set_oppyPartConfidenceClosedDead.containsAll(map_oppyId_oppyPartConfidenceSet.get(oppyId))) {
                    map_oppyId_oppyStage.put(oppyId, 'Lost/Dead - closed');
                } 
                else if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won') && set_oppyPartConfidenceWonClosed.containsAll(map_oppyId_oppyPartConfidenceSet.get(oppyId))) {
                    map_oppyId_oppyStage.put(oppyId, 'Won - Closed');
                }
                else if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Weak') || 
                        map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('50/50') ||
                        map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Likely') ||
                        map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Commit') ||
                        map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('On Hold')) {
                    if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won')) {
                        map_oppyId_oppyStage.put(oppyId, 'Won - Open');
                    }
                    else if(!set_oppyNotNewId.isEmpty()) {
                        if(set_oppyNotNewId.contains(oppyId)) {
                            map_oppyId_oppyStage.put(oppyId, 'Approved/Active');
                        }   
                    }                           
                }
                else if(!set_oppyNotNewId.isEmpty()) {
                    if(set_oppyNotNewId.contains(oppyId)) {
                        map_oppyId_oppyStage.put(oppyId, 'Approved/Active');
                    }   
                }

            }
        }
        */
        //*************************************************************************************************************************************
        //***************************-=END update xiaona liu <xiaona.liu@itbconsult.com>=-*****************************************************
        if(!map_oppyId_oppyStage.isEmpty()) {
            for(Opportunity oppy : list_oppyModified) {
                oppy.StageName = map_oppyId_oppyStage.get(oppy.Id);
                oppy.isFromCode__c = true;
                list_oppy2Update.add(oppy);
            }
        }
        if(!list_oppy2Update.isEmpty()) {
            update list_oppy2Update;
        }
    }
   /**
    * The method is used to Validate whether Opportunity parts have the same Approver PM before update
    *
    @author Yinfeng Guo
    @created 2012-03-20
    @version 1.0
    @since 18.0 (Force.com ApiVersion)
    *
    @param list_oppyParts         the list of Opportunity_Part__c
    *
    @return                       null or 'success'
    *
    @changelog
    * 2012-03-20 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    * 2012-05-07 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - we should use "Product_Manager__c" instead of "Approver_PM__c"
    */  
    /*
    public static void ValidatePM2(map<Id, Id> map_oppyPartId_oppyId, map<Id, Opportunity_Part__c> map_oppyPartId_oppyPart){
        map<Id, Opportunity> map_oppyId_oppy = new map<Id, Opportunity>();
        map<Id, Integer> map_oppyId_partNumber = new map<Id, Integer>();
        list<Opportunity> list_oppy2Update = new list<Opportunity>();
        if(map_oppyPartId_oppyId != null && !map_oppyPartId_oppyId.isEmpty()){
            for(Opportunity oppy : [SELECT Id,Product_Manager__c FROM Opportunity WHERE Id in: map_oppyPartId_oppyId.values()]){
                map_oppyId_oppy.put(oppy.Id, oppy);
            }
        }
        if(!map_oppyId_oppy.isEmpty()){
            for(Opportunity_Part__c op : [SELECT Id,Opportunity__c FROM Opportunity_Part__c WHERE Opportunity__c in: map_oppyId_oppy.values()]){
                if(!map_oppyId_partNumber.containsKey(op.Opportunity__c)){
                    map_oppyId_partNumber.put(op.Opportunity__c, 1);
                }
                else map_oppyId_partNumber.put(op.Opportunity__c, map_oppyId_partNumber.get(op.Opportunity__c)+1 );
            }
        }
        for(Id oppyPartId : map_oppyPartId_oppyId.keySet()){
            if( map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c != null &&  String.valueOf(map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c)!= ''){
                if( map_oppyId_partNumber.get( map_oppyPartId_oppyId.get(oppyPartId) ) >= 1){
                    if(map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c != map_oppyPartId_oppyPart.get(oppyPartId).Product_Manager_Id__c){
                        map_oppyPartId_oppyPart.get(oppyPartId).addError(system.Label.Not_same_Approver_PM);
                    }   
                }
            }
            else{
                map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ).Product_Manager__c = map_oppyPartId_oppyPart.get(oppyPartId).Product_Manager_Id__c;
                list_oppy2Update.add(map_oppyId_oppy.get( map_oppyPartId_oppyId.get(oppyPartId) ));
            }   
        }
        if(!list_oppy2Update.isEmpty())  update list_oppy2Update;
    }
    */
    /*
    public static String ValidateApproverPM(list<Opportunity_Part__c> list_oppyParts){
        if(list_oppyParts != null && !list_oppyParts.isEmpty()){
            Id id_approverPM ;
            Boolean isError = false;
            set<Id> set_GPLs = new set<Id>();
            set<Id> set_partIds = new set<Id>();
            list<Opportunity_Part__c> list_oppyParts_withApprover = new list<Opportunity_Part__c>();
            Id oppyId;
            String requestType;
            if(list_oppyParts[0].Opportunity__c != null) oppyId = list_oppyParts[0].Opportunity__c;
            for(Opportunity o : [SELECT Id, RecordTypeId, Request_Type__c FROM Opportunity where Id =: oppyId]){
                requestType = o.Request_Type__c;
            }
            for(Opportunity_Part__c op : list_oppyParts){
                if(op.GPL__c != null  && requestType == ExtOpportunityPartEntry.REQUESTTYPE_E){
                    set_GPLs.add(op.GPL__c);
                }
                else if(op.Part__c != null  && requestType == ExtOpportunityPartEntry.REQUESTTYPE_E){
                    set_partIds.add(op.Part__c);
                }
                else if(op.Similar_TE_Part_Number__c != null  && requestType == ExtOpportunityPartEntry.REQUESTTYPE_E){
                    set_partIds.add(op.Similar_TE_Part_Number__c);
                }
                if(oppyId == null) oppyId = op.Opportunity__c;
            }
            if(!set_partIds.isEmpty()){
                for(Part__c p : [SELECT Id, GPL__c from Part__c WHERE Id in: set_partIds]){
                    set_GPLs.add(p.GPL__c);
                }
            }
            Integer partCount = 0;
            
            if(oppyId != null){
                for(Opportunity_Part__c oP : [SELECT Id, GPL__r.Product_Manager__c, Opportunity__c FROM Opportunity_Part__c WHERE Opportunity__c =: oppyId limit 2 ]){
                    if(oP.GPL__r.Product_Manager__c != null && String.valueOf(oP.GPL__r.Product_Manager__c) != '') id_approverPM = oP.GPL__r.Product_Manager__c;
                    partCount = partCount + 1;
                    
                }
            }
            for(Product_Hierarchy__c ph : [SELECT Id, Product_Manager__c FROM Product_Hierarchy__c WHERE Id in: set_GPLs]){
                if(partCount > 1 && id_approverPM != null && String.valueOf(id_approverPM) != '' && ph.Product_Manager__c != id_approverPM){
                     isError = true;
                }
                else id_approverPM = ph.Product_Manager__c;
            }
            if(isError){
                for(Opportunity_Part__c op : list_oppyParts){
                    op.addError(system.Label.Not_same_Approver_PM);
                }
                return null;
            }
            try{
                for(Opportunity oppy : [SELECT Id, Product_Manager__c from Opportunity WHERE Id =: oppyId limit 1]){
                    if(oppy.Product_Manager__c == null || String.valueOf(oppy.Product_Manager__c) ==''){
                        oppy.Product_Manager__c = id_approverPM;
                        upsert oppy;
                    }
                }
            }catch (Exception e){
                return null;
            }
        }
        return 'success';
    }   
    */
    
    /**
    * The method is query custom setting Profit_BU_Center_Mapping__c.
    *
    @author Xiaona Liu
    @created 2013-06-17
    @version 1.0
    @since 18.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2013-06-17 Xiaona Liu <xiaona.liu@itbconsult.com>
    * - Created
    */
    
    public static void getProfitBUCenterMapping(){

        String AccountIBCCodeStr = Profit_BU_Center_Mapping_Rule2__c.getInstance('Account_IBC_code__c').BU_Profit__c;
        
        if(AccountIBCCodeStr != null){
            for(String accIBCCode :AccountIBCCodeStr.split(',')){
                setAccountIBCCodes.add(accIBCCode);
            }
        }
        
        //Rule1 Mapping
        for(Profit_BU_Center_Mapping_Rule1__c rule1:Profit_BU_Center_Mapping_Rule1__c.getAll().Values()){
            map_ProfitRule1.put(rule1.Name,rule1.BU_Profit__c);
        }
        //Rule2 Mapping
        for(Profit_BU_Center_Mapping_Rule2__c rule2:Profit_BU_Center_Mapping_Rule2__c.getAll().Values()){
            map_ProfitRule2.put(rule2.Name,rule2.BU_Profit__c);
        }
        //Rule3 Mapping
        for(Profit_BU_Center_Mapping_Rule3__c rule3:Profit_BU_Center_Mapping_Rule3__c.getAll().Values()){
            map_ProfitRule3.put(rule3.Name,rule3.BU_Profit__c);
        }

    }
    
    /**
    * The method is update BU_profit_center__c(Opportunity_Part__c).
    *
    @author Xiaona Liu
    @created 2013-06-17
    @version 1.0
    @since 18.0 (Force.com ApiVersion)
    *
    *@param list_OppParty         the list of Opportunity_Part__c
    *
    @changelog
    * 2013-06-17 Xiaona Liu <xiaona.liu@itbconsult.com>
    * - Created
    */
    public static void allocateBUProfitCenter(List<Opportunity_Part__c> list_OppParty){
        
        getProfitBUCenterMapping();       
        
        for(Opportunity_Part__c oppPart:list_OppParty){        
            oppPart.BU_profit_center__c = null;
            //Rule1
            if(map_ProfitRule1.containsKey(oppPart.CBC5_Code__c)){
                oppPart.BU_profit_center__c = map_ProfitRule1.get(oppPart.CBC5_Code__c);
            }
            //Rule2
            else if(map_ProfitRule2.containsKey(oppPart.CBC5_Code__c)){
                // add lili 2013.09.30
                 if(oppPart.CBC5_Code__c == '12302' && oppPart.Part_Number__c == '0-0000000-0') {
                    oppPart.BU_profit_center__c = 'undefined';
                }else if(setAccountIBCCodes.contains(oppPart.Account_IBC_code__c) || (oppPart.Distributor__c != null && oppPart.Distributor__c.length()>0 && oppPart.Distributor__c != 'None/Direct Account' && oppPart.Distributor__c != 'None-Direct Business')){
                    oppPart.BU_profit_center__c = map_ProfitRule2.get(oppPart.CBC5_Code__c);
                }
            }
            //Rule3
            if(oppPart.BU_profit_center__c == null){
                if(oppPart.Account_IBC_code__c != null && oppPart.Account_IBC_code__c.length() !=0){                    
                    if(map_ProfitRule3.containsKey(oppPart.Account_IBC_code__c)){ 
                        oppPart.BU_profit_center__c = map_ProfitRule3.get(oppPart.Account_IBC_code__c);
                    }
                }                    
                else if(oppPart.Customer_Industry__c != null){
                    oppPart.BU_profit_center__c = oppPart.Customer_Industry__c;                                  
                } 

            }
            system.debug('oppPart: ' + oppPart);
            setOppPartBUs.add(oppPart.BU_profit_center__c);                   
        }
        
        //***************************-=BEGIN-Populate CDF according to BU Profit center-28-08-14-Nooreen <nooreen.i@zensar.in>=-*************//
        List<Cross_Dashboard_Filter__c> crossDashList = new List<Cross_Dashboard_Filter__c>([SELECT Id,Name,Filter_Value__c,Type__c,Filter_Type_and_Value__c FROM Cross_Dashboard_Filter__c WHERE Filter_Value__c IN : setOppPartBUs]);
        
        Map<String,List<Cross_Dashboard_Filter__c>> crossDashMap = new Map<String,List<Cross_Dashboard_Filter__c>>();
        List<Cross_Dashboard_Filter__c> cdfLst = new List<Cross_Dashboard_Filter__c>();
        
        for(Cross_Dashboard_Filter__c vcros : crossDashList){    
            if(!crossDashMap.containsKey(vcros.Filter_Value__c)){            
                cdfLst.add(vcros);
                crossDashMap.put(vcros.Filter_Value__c,cdfLst);
            }       
            else{           
                cdfLst = crossDashMap.get(vcros.Filter_Value__c);
                cdfLst.add(vcros);
                crossDashMap.put(vcros.Filter_Value__c,cdfLst);
            }
        }

        for(Opportunity_Part__c oppPart:list_OppParty){                    
            System.debug('***setOppPartBUs*****'+setOppPartBUs);
            Map<String,Cross_Dashboard_Filter__c> mapCrossDash = new Map<String,Cross_Dashboard_Filter__c>(); 
            
            if(crossDashMap.containsKey(oppPart.BU_profit_center__c)) {
                for(Cross_Dashboard_Filter__c c : crossDashMap.get(oppPart.BU_profit_center__c)){ 
                    mapCrossDash.put(c.Filter_Value__c,c);           
                }
            }                                   
            if(mapCrossDash.containsKey(oppPart.BU_profit_center__c)) {                                           
                oppPart.SAP_Profit_Center_Short_Desc_Filter__c = mapCrossDash.get(oppPart.BU_profit_center__c).Id;
            }
          
            else{
                oppPart.SAP_Profit_Center_Short_Desc_Filter__c = null;
            }   
            system.debug('***oppPart***' + oppPart);          
        }    
        //***************************-=END-Nooreen <nooreen.i@zensar.in>=-*************//            
    }
         /**
    * The method is used to get the opportunity object with the specified opportunity id
    *
    @author Bin yuan
    @created 2013-11-20
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param             opportunity id
    *
    @return             opportunity object
    *
    @changelog
    * 2013-11-20 Bin yuan <bin.yuan@itbconsult.com>
    * - Created
    */
    public static Opportunity getOpportunityById(Id oppyId){
        Opportunity opportunity = new Opportunity();
        //changed by Nelson Zheng 06/18/2015 for case 00832171. Add Probability,Amount
        //add CreatedDate. by nelson zheng 2015-10-30
        opportunity = [select CreatedDate,Probability,CloseDate,Request_Type__c,NDR_Quote_Status_Description__c,Manufacturing_Start_Date__c, Id, Name, stageName, RecordTypeId, RecordType.DeveloperName, Program__c, Program__r.Program_level_Forecasting__c, Amount, Five_Year_Value__c, Total_Opportunity_Value__c, Five_Year_Revenue__c, Method__c, CurrencyIsoCode, Level__c, Competitor_Count__c,Account.Customer_Region__c,Account.Customer_Industry__c, Industry_Code__c,Owner.GIBU__c from Opportunity where Id = :oppyId];//modified by xia 2013-04-09,add field Account.Customer_Region__c  
        return opportunity;  
    }
    
    /**
    * The method is the get reactive ConfidenceAndProcessStatus of Opportunity Parts by custom setting
    *
    @author Lili Zhao
    @created 2014-03-17
    @version 1.0
    @since 27.0 (Force.com ApiVersion)
    *
    @param  oppyId      string          Opportunity id
    *
    @return         string        custom setting maps (Template: {"ProcessStatus":"Production","Confidence":"Won"} )
    *
    @changelog
    * 2014-03-17 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static map<string,string> getOppyPartDefaultConfidenceAndProcessStatus(string oppyId){
        map<string,string> map_status = new map<string,string>();
        Opportunity tempoppy = null;
            
        for(Opportunity opp : [Select Id,PMV_Type__c,StageName,RecordType.BusinessProcessId  from Opportunity where Id=:oppyId]){
            tempoppy = opp;
        }

        Map<String, PMV_Sales_Stage_Setting__c> allstates = PMV_Sales_Stage_Setting__c.getAll();
        for(PMV_Sales_Stage_Setting__c state : allstates.values()) {
            if(state.Active__c == true
              && state.Sales_Process_ID__c == tempoppy.RecordType.BusinessProcessId
              && state.PMV_Type__c == tempoppy.PMV_Type__c
              && state.Sales_Stage__c == tempoppy.StageName){         
                if(state.Opportunity_Parts_Confidence__c != null){
                    map_status.put('Confidence',state.Opportunity_Parts_Confidence__c);
                }else{
                    map_status.put('Confidence','');
                }
                if(state.Opportunity_Parts_Process_Status__c != null){
                    map_status.put('ProcessStatus', state.Opportunity_Parts_Process_Status__c);
                }else{
                    map_status.put('ProcessStatus', '');
                }
            }
        }
        return map_status;
    }
    
    /**
    * This method is used to process update Opportunity stage for given NDR Opportunity Id set
    *
    @author Mrunal Parate
    @created 2014-10-08
    @version 1.0
    @since 25.0 (Force.com ApiVersion)
    *
    @param set_oppyIdPar    set of NDR Opportunity Id
    *
    *
    @changelog
    * 2014-10-08 Mrunal Parate <Mrunal.Parate@zensar.in>
    * - Created
    *
     
    */
    public static void updateNDROppyStage(set<Id> set_oppyIdPar) {
        set<Id> set_oppyId2Update = new set<Id>();
        list<Opportunity> list_oppyModified = new list<Opportunity>();
        set<Id> set_oppyNotNewId = new set<Id>();
        map<Id, String> map_oppyId_oppyStage = new map<Id, String>();
        map<Id, set<String>> map_oppyId_oppyPartConfidenceSet = new map<Id, set<String>>();
        list<Opportunity> list_oppy2Update = new list<Opportunity>();
        
        Apex_Helper_Settings__c config = Apex_Helper_Settings__c.getInstance('NDR Opportunity');
        Id ndrRecordType = config.Value__c;
        
        if(!set_oppyIdPar.isEmpty()) {
                for(Opportunity oppy : [Select Id, StageName, RecordTypeId From Opportunity Where Id in :set_oppyIdPar  and RecordTypeId =: ndrRecordType]) {
                    if(!set_oppyId2Update.contains(oppy.Id)) {
                        set_oppyId2Update.add(oppy.Id);
                        list_oppyModified.add(oppy);
                        if(oppy.StageName != 'New') {
                            if(!set_oppyNotNewId.contains(oppy.Id)) {
                                set_oppyNotNewId.add(oppy.Id);
                            }
                        }
                    }
                }
            }
        
        if(!set_oppyId2Update.isEmpty()) {
            for(Opportunity_Part__c oppyPart : [Select Id, Status__c, Opportunity__c,Process_Status__c From Opportunity_Part__c Where Opportunity__c in :set_oppyId2Update ]) {
                if(map_oppyId_oppyPartConfidenceSet.containsKey(oppyPart.Opportunity__c)) {
                    if(!map_oppyId_oppyPartConfidenceSet.get(oppyPart.Opportunity__c).contains(oppyPart.Status__c)) {
                        map_oppyId_oppyPartConfidenceSet.get(oppyPart.Opportunity__c).add(oppyPart.Status__c);
                    }
                } 
                else {
                    map_oppyId_oppyPartConfidenceSet.put(oppyPart.Opportunity__c, new set<String>{oppyPart.Status__c});
                }
                    
            }
        }
        
        set<String> set_oppyPartConfidenceClosedDead = new set<String>{'Dead', 'Lost'};
        set<String> set_oppyPartConfidenceWonClosed = new set<String>{'Won', 'Dead', 'Lost'};
        
        for(Id oppyId : map_oppyId_oppyPartConfidenceSet.keySet()) {
            if(set_oppyPartConfidenceClosedDead.containsAll(map_oppyId_oppyPartConfidenceSet.get(oppyId))) {
                map_oppyId_oppyStage.put(oppyId, 'Lost/Dead - closed');
            }
            else if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won') && set_oppyPartConfidenceWonClosed.containsAll(map_oppyId_oppyPartConfidenceSet.get(oppyId))) {
                map_oppyId_oppyStage.put(oppyId, 'Won - Closed');
            }
            else{
                if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Weak') || 
                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('50/50') ||
                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Likely') ||
                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Commit') ||
                    map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('On Hold')) { 
                    
                        if(map_oppyId_oppyPartConfidenceSet.get(oppyId).contains('Won')) {
                            map_oppyId_oppyStage.put(oppyId, 'Won - Open');
                        }
                        else if(!set_oppyNotNewId.isEmpty()) {
                            if(set_oppyNotNewId.contains(oppyId)) {
                                map_oppyId_oppyStage.put(oppyId, 'Approved/Active');
                            }   
                        }
                }
            }       
        }
        
        if(!map_oppyId_oppyStage.isEmpty()) {
            for(Opportunity oppy : list_oppyModified) {
                oppy.StageName = map_oppyId_oppyStage.get(oppy.Id);
                oppy.isFromCode__c = true;
                list_oppy2Update.add(oppy);
            }
        }
        if(!list_oppy2Update.isEmpty()) {
            update list_oppy2Update;
        }
    }
    
    /**
    * The method is the get all CSD Opportunity from Opportunity Record Type Group custom setting.
    *
    @author Jinbo Shan
    @created 2014-11-17
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    @param 
    *
    @return        set<Id>   all csd opportunity record type Ids
    *
    @changelog
    * 2014-11-17 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
    public static set<Id> getAllCSDOppyRecordType(){
        set<Id> set_oppyRTId = new set<Id>();
        
        for(Opportunity_Record_Type_Groups__c ortg : Opportunity_Record_Type_Groups__c.getAll().values()) {
            if(ortg.Group__c == 'CSD') {
                set_oppyRTId.add((Id)ortg.RecordTypeID__c);
            }
        }
        
        return set_oppyRTId;
    }
       
}