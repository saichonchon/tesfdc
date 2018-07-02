/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A trigger handler class for Opportunity.
               Related user story numbers: W-00456,W-00145
Inputs:        
Test Class:    OpportunityTrgHandler_Test
History
2016-08-12  Jun Yu <jun.yu@oinio.com>   Created
2017-01-20  Mrunal Parate   Modified
------------------------------------------------------------*/
public class OpportunityTrgHandler extends ClsTriggerVirtual{
    public static boolean isEditingOpportunityPartState = false;
    public static boolean isSkipGenerateOppyPartner = false;
    public static boolean isSkipSetOppyTerritoryAndERPPricing = false;
    public static boolean isUpdateQuoteStatusFromOppyTrg = false;
    public static boolean isUpdateOppyApprovalStatus = false;
    public static map<Id, Boolean> map_oppyId_isFromAutoCreateQuoteForSmallQuote;
    public static User currUser;
    public static list<Opportunity_Part__c> list_oppyPartsForApprovedOppy;
    public static map<Id, Sales_Hierarchy__c> map_shId_salesHierarchy;
    
    public static boolean isMultipleBeforeInsert = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleBeforeUpdate = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleBeforeDelete = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleAfterInsert = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleAfterUpdate = false; //added by Tangyong Li 2017-12-28
    public static boolean isMultipleAfterDelete = false; //added by Tangyong Li 2017-12-28
    
    private static Id EnergySalesTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Energy - Sales').getRecordTypeId();
    public static map<Id, Boolean> map_oppyId_isSkipCalOppyApprovalStatus = new map<Id, Boolean>(); //added by Tangyong Li 2018-01-29
    
    public override void beforeTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        //added by Tangyong Li 2017-12-28
        if(avoidOppyMultipleRunning(trgCtx)) return;
        if(trgCtx.isAfter) return;
        //end
        Boolean RunDNDLeadInit ;
        Trigger_Configuration__c tc = Trigger_Configuration__c.getInstance('DND Lead Conversion Initialization');
        if(tc != null) RunDNDLeadInit = tc.isRun__c;
        // Added by Mrunal for Case 901189
        Boolean runDuplicatePLmCheck ;
        Trigger_Configuration__c tc1 = Trigger_Configuration__c.getInstance('Avoid Duplicate PLM Id');
        if(tc1 != null) runDuplicatePLmCheck = tc1.isRun__c;
        
        // Added by Raghu for Case 901269
        Boolean identifyFiscalYear ;
        Trigger_Configuration__c tc2 = Trigger_Configuration__c.getInstance('Identify Fiscal Year');
        if(tc2 != null) identifyFiscalYear = tc2.isRun__c; 
        
        //Added by Kartik to check ADMSOP relevant conditions
        Boolean runADMSOPCheck ;
        Trigger_Configuration__c tc3 = Trigger_Configuration__c.getInstance('ADMSOPCheck');
        if(tc3 != null) runADMSOPCheck = tc3.isRun__c; 
        //system.debug('runADMSOPCheck..'+runADMSOPCheck);
        
        list<Opportunity> lstOppty = new list<Opportunity>();
       // list<Opportunity> lstOpty = new list<Opportunity>();
        Set<Id> UniqueProjectOpptyRt = new Set<Id>();
        for(Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
                if(rt.Active__c && rt.Group__c == 'Enforce Unique Project Id' && rt.RecordTypeID__c!= null)
                    UniqueProjectOpptyRt.add(rt.RecordTypeID__c);
            }
        Opportunity_Record_Type_Groups__c vDndId = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity');
        CSD_Configuration__c nonOemAcc = CSD_Configuration__c.getInstance('Non OEM Account');
        //opportunity_BI_defineInitialOwner     --set the opportunity creator (Owner) as "Initial Owner"
        
        //Start: Added by ADM Team
        //Get List of ADM Optys
        list<Opportunity> list_ADMOppys = new list<Opportunity>();
        //Get account record type of respective opportunity
        Set<Id> associatedAccId = new Set<Id>();
        //Get opportunity record type id of Name-ADM
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
        //Get Account record type id of Name-Account
        Id accountRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Account').getRecordTypeId();
        // Finish: Added by ADM Team
        if(trgCtx.isInsert) {
            //transform sobject type for opportunity type
            list<Opportunity> list_oppys = new list<Opportunity>();
            for(SObject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if(oppy.Lead_ID__c!= null && oppy.recordtypeid == vDndId.RecordTypeID__c && RunDNDLeadInit){                     
                    oppy.OEM_Name__c= nonOemAcc.Value__c;
                    oppy.type= 'New Business';
                }
                list_oppys.add(oppy);
                
                //Start: code added by ADM Team  
                if(runADMSOPCheck==true && oppy.RecordTypeId == oppRecordTypeId && oppy.Relevant_for_S_OP__c  == True)
                {
                    list_ADMOppys.add(oppy);
                    if(oppy.AccountId != null)
                    {
                        associatedAccId.add(oppy.AccountId) ;
                    }
                }
            }
            if(list_ADMOppys.size()>0)
            {
                //getting helper class for checking Relevant for SOP logic
                ADMOpportunityHelper.oppyTrigger(associatedAccId,list_ADMOppys,trgCtx);               
            }
            // End: Code finished by ADM Team  
            
            if(runDuplicatePLmCheck == true){
                for(Opportunity oppty:list_oppys){ 
                    if(UniqueProjectOpptyRt.contains(oppty.recordtypeId) && oppty.PLM_Id__c!=null) 
                        lstOppty.add(oppty); 
                } 
                if(lstOppty!=null && lstOppty.size()>0)DuplicatePLMValueCheck.avoidDuplicatePLM(lstOppty);
            }
            // Added by Raghu for Case 901269
            if(identifyFiscalYear != null && identifyFiscalYear && list_oppys!=null && list_oppys.size()>0) {
                IdentifyOptyFiscalYear.IdentfyFiscalCreated(list_oppys);
            }            
            
            //ClsOppyTrgDefineInitialOwnerUtil.setInitialOwner(list_oppys);
        }
        if(trgCtx.isUpdate){
            Set<Id> oppId = new Set<Id>();
            list<Opportunity> list_oppys = new list<Opportunity>();
            Map<Id, Opportunity> map_Id_oppys = new  Map<Id, Opportunity>();
            for(Id oppy_Id : trgCtx.oldMap.keySet()) {
                Opportunity oppy = (Opportunity)trgCtx.oldMap.get(oppy_Id);
                map_Id_oppys.put(oppy_Id,oppy);
            }    
            for(SObject so : trgCtx.newList) {
                 Opportunity oppy = (Opportunity)so;
                 list_oppys.add(oppy);
                 
                 // Start: code added by ADM Team
                
                if (runADMSOPCheck==true && oppy.RecordTypeId == oppRecordTypeId && oppy.Relevant_for_S_OP__c  == True)
                {
                    list_ADMOppys.add(oppy);
                    if(oppy.AccountId != null)
                    {
                        associatedAccId.add(oppy.AccountId) ;
                    }
                }
                
            }
            if(list_ADMOppys.size()>0)
            {
                //getting helper class for checking Relevant for SOP logic
                ADMOpportunityHelper.oppyTrigger(associatedAccId,list_ADMOppys,trgCtx);              
            }
            // End: Code finished by ADM Team 
        
            if(runDuplicatePLmCheck == true){
                for (Opportunity oppty: list_oppys){
                     if(oppty.PLM_Id__c != null && oppty.PLM_Id__c != map_Id_oppys.get(oppty.Id).PLM_Id__c && UniqueProjectOpptyRt.contains(oppty.recordtypeId))
                     lstOppty.add(oppty);
                }    
                if(lstOppty!=null && lstOppty.size()>0) DuplicatePLMValueCheck.avoidDuplicatePLM(lstOppty);
             } 
             // Change end by Mrunal for Case 901189 
        }
        
       
       //=====================   START - Energy logic  ============================
        /**
        * 1.All opporutnity query records map and all opportunity_part__c query records map
        */
        map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
        map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts = new map<Id, Opportunity_Part__c>();
        map_oppyId_allOppys.putAll(getOpportunitiesBaseupId(trgCtx));
        map_oppyPartId_allOppyParts.putAll(getOpportunityPartsBaseupId(map_oppyId_allOppys));
        
        /**
        * 2.Insert & Undelete, Update, Delete
        */
        if(trgCtx.isInsert || trgCtx.isUndelete){
            List<Opportunity> list_NewOppys = new List<Opportunity>();
            for(SObject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if(oppy.RecordTypeId == EnergySalesTypeId){
                    list_NewOppys.add(oppy);
                }
            }
            //START - execute methods
            validateOppyIncoPaymentCode(trgCtx, list_NewOppys, true);
            
            updateConfidenceLevelForOppy(list_NewOppys);
            
            assignPrimaryOppy(list_NewOppys, map_oppyId_allOppys);
            
            setOppyTerritoryAndERPPricingBI(list_NewOppys);

            setSAPQuoteType(list_NewOppys);
            
            initOppyMarginAndAmount(list_NewOppys);
            
            setOppyApprovalStatusBI(list_NewOppys);
            //END - execute methods
        }else if(trgCtx.isUpdate){
            List<Opportunity> list_UpdateOppys = new List<Opportunity>();
            for(SObject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if(oppy.RecordTypeId == EnergySalesTypeId){
                    list_UpdateOppys.add(oppy);
                }
            }
            //START - execute methods
            validateOppyIncoPaymentCode(trgCtx, list_UpdateOppys, false);
            
            updateApprovedTotalIfOppApprove(trgCtx, list_UpdateOppys);
            
            updateConfidenceLevelForOppy(list_UpdateOppys);
            
            setOppyTerritoryAndERPPricingBU(trgCtx, list_UpdateOppys);

            setSAPQuoteType(list_UpdateOppys);

            checkQuoteStatusForOppyStage(trgCtx, list_UpdateOppys);

            initOppyMarginAndAmount(list_UpdateOppys);
            
            setOppyApprovalStatusBU(trgCtx, list_UpdateOppys, map_oppyPartId_allOppyParts);
            //END - execute methods 
        }else if(trgCtx.isDelete){
            List<Opportunity> list_DeleteOppys = new List<Opportunity>();
            for(SObject so : trgCtx.oldList) {
                Opportunity oldOppy = (Opportunity)so;
                if(oldOppy.RecordTypeId == EnergySalesTypeId){
                    list_DeleteOppys.add(oldOppy);
                }
            }
            //START - execute methods
            
            
            //END - execute methods 
        }
        //=====================   END - Energy logic    ============================
    }
    
    public override void afterTrigger(ClsWrappers.TriggerContext trgCtx) {
        
        //added by Tangyong Li 2018-12-28
        if(avoidOppyMultipleRunning(trgCtx)) return;
        if(trgCtx.isBefore) return;
        //end
        
        //opportunity_AIUDUD_populatePartner   -- Populate Opportunity Partner for opportunity.
        Boolean isRun;
        Trigger_Configuration__c tc = Trigger_Configuration__c.getInstance('Populate Opportunity Partner');
        if(tc != null) isRun = tc.isRun__c;
        if(isRun != null && isRun)
           {
            if(trgCtx.isInsert || trgCtx.isUnDelete) {
                 //transform sobject type for opportunity type
                list<Opportunity> list_oppys = new list<Opportunity>();
                for(SObject so : trgCtx.newList) {
                    Opportunity oppy = (Opportunity)so;
                    list_oppys.add(oppy);
                }
                ClsOppyTrgPopulatePartnerUtil.createPartner(list_oppys);
            } 
            else if(trgCtx.isUpdate) {
                //transform sobject type for opportunity type  
                Set<Id> oppId = new Set<Id>();           
                list<Opportunity> list_oppys = new list<Opportunity>();
                for(SObject so : trgCtx.newList) {
                     Opportunity oppy = (Opportunity)so;
                     list_oppys.add(oppy);
                }
                Map<Id, Opportunity> map_Id_oppys = new  Map<Id, Opportunity>();
                for(Id oppy_Id : trgCtx.oldMap.keySet()) {
                    Opportunity oppy = (Opportunity)trgCtx.oldMap.get(oppy_Id);
                    map_Id_oppys.put(oppy_Id,oppy);
                }
                ClsOppyTrgPopulatePartnerUtil.updatePartner(list_oppys,map_Id_oppys);
                // Added by Mrunal for Case 851907 to update BU Profit Centre on Distributor Update
                for(Opportunity oppy : list_oppys) {
                    if(oppy.Distributor__c != null && oppy.Distributor__c != map_Id_oppys.get(oppy.Id).Distributor__c){
                    oppId.add(oppy.Id);
                    }
                }
                //system.debug('>>>@@!!!oppId'+oppId); 
                if (oppId!=null && oppId.size()>0) ClsoppyTrgRefreshBUProfit.UpdateBUProfit(oppId);
                // Change end by Mrunal for Case 851907
            }
        }
        
        //=====================   START - Energy logic  ============================
        /**
        * 1.All opporutnity query records map and all opportunity_part__c query records map
        */
        map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
        map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts = new map<Id, Opportunity_Part__c>();
        map_oppyId_allOppys.putAll(getOpportunitiesBaseupId(trgCtx));
        map_oppyPartId_allOppyParts.putAll(getOpportunityPartsBaseupId(map_oppyId_allOppys));
        //Added by Tangyong Li 2018-01-15
        map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts = new map<Id, Opportunity_Part__c>();
        map<Id, Opportunity_Part__c> map_pId_oppyParts = new map<Id, Opportunity_Part__c>();
        /**
        * 2.Insert & Undelete, Update, Delete
        */
        if(trgCtx.isInsert || trgCtx.isUndelete){
            List<Opportunity> list_NewOppys = new List<Opportunity>();
            for(SObject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if(oppy.RecordTypeId == EnergySalesTypeId){
                    list_NewOppys.add(oppy);
                }
            }
            
            //START - execute methods
            map_pId_oppyParts = syncDetailRecordsForWonOrLostOppyAI(list_NewOppys, map_oppyPartId_oppyParts, map_oppyPartId_allOppyParts);
            if(map_pId_oppyParts != null) {
                map_oppyPartId_oppyParts = map_pId_oppyParts;
            }
            
            createANZClausesAI(list_NewOppys);
            
            emailNotificationSent(list_NewOppys, map_oppyId_allOppys);
            //END - execute methods
        }else if(trgCtx.isUpdate){
            List<Opportunity> list_UpdateOppys = new List<Opportunity>();
            for(SObject so : trgCtx.newList) {
                Opportunity oppy = (Opportunity)so;
                if(oppy.RecordTypeId == EnergySalesTypeId){
                    list_UpdateOppys.add(oppy);
                }
            }
            //START - execute methods
            createANZClausesAU(trgCtx, list_UpdateOppys);
            
            map_pId_oppyParts = syncDetailRecordsForWonOrLostOppyAU(trgCtx, list_UpdateOppys, map_oppyPartId_oppyParts, map_oppyPartId_allOppyParts);
            if(map_pId_oppyParts != null) {
                map_oppyPartId_oppyParts = map_pId_oppyParts;
            }
            
            System.debug('*** Always APPEAR');
            Admin_Profile_Exception__c adm = Admin_Profile_Exception__c.getInstance(); 
            if (!adm.skip_recalculate_prices__c) {
                System.debug('*** DO NOT APPEAR IF CHECKED');
                map_pId_oppyParts = recalculateOppyPartPricing(trgCtx, list_UpdateOppys, map_oppyId_allOppys, map_oppyPartId_allOppyParts, map_oppyPartId_oppyParts);
                if(map_pId_oppyParts != null) {
                    map_oppyPartId_oppyParts = map_pId_oppyParts;
                }
            }
            
            map_pId_oppyParts = sendClonedOppyPartsToERP(trgCtx, list_UpdateOppys, map_oppyId_allOppys, map_oppyPartId_allOppyParts, map_oppyPartId_oppyParts);
            if(map_pId_oppyParts != null) {
                map_oppyPartId_oppyParts = map_pId_oppyParts;
            }
            
            createQuoteForSmallQuoteType(trgCtx, list_UpdateOppys, map_oppyId_allOppys, map_oppyPartId_allOppyParts);
            
            map_pId_oppyParts = setAllPartsChangedSinceQuoteIntegration(trgCtx, list_UpdateOppys, map_oppyPartId_oppyParts, map_oppyPartId_allOppyParts);
            if(map_pId_oppyParts != null) {
                map_oppyPartId_oppyParts = map_pId_oppyParts;
            }
            
            updateAccountFields(trgCtx, list_UpdateOppys);
            
            map_pId_oppyParts = updateOppyPartToApproved(trgCtx, map_oppyPartId_oppyParts);
            if(map_pId_oppyParts != null) {
                map_oppyPartId_oppyParts = map_pId_oppyParts;
            }
            
            map_pId_oppyParts = syncRelatedListCurrency(trgCtx, list_UpdateOppys, map_oppyPartId_oppyParts, map_oppyPartId_allOppyParts); 
            if(map_pId_oppyParts != null) {
                map_oppyPartId_oppyParts = map_pId_oppyParts;
            }
            //END - execute methods
        }else if(trgCtx.isDelete){
            List<Opportunity> list_DeleteOppys = new List<Opportunity>();
            for(SObject so : trgCtx.oldList) {
                Opportunity oldOppy = (Opportunity)so;
                if(oldOppy.RecordTypeId == EnergySalesTypeId){
                    list_DeleteOppys.add(oldOppy);
                }
            }
            
            //START - execute methods
            
            
            //END - execute methods
        }
        
        //system.debug('map_oppyPartId_oppyParts::::   ' + map_oppyPartId_oppyParts.size());
        //DML
        if(map_oppyPartId_oppyParts != null && !map_oppyPartId_oppyParts.isEmpty()) {
            try{
                update map_oppyPartId_oppyParts.values();
            }catch(Exception e){
                String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
                System.debug('---vStrError:::' + vStrError);                    
                SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
                //ErrorLogging.Log(e);
            }
        }
        //=====================   END - Energy logic    ============================
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   validate that the code exists in the custom setting.  If it doesn't exist then you throw an error 
                   ("This code is not valid.  Please contact your BU Admin if you believe you're getting this message in error")
    Returns:       
    History
    2018-02-08     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void validateOppyIncoPaymentCode(ClsWrappers.TriggerContext trgCtx, list<Opportunity> list_NewOppys, Boolean isInsert) {
        map<String, IncoPayment_Terms__c> map_incoPaymentName_IncoPaymentTerm = IncoPayment_Terms__c.getAll();
        for(Opportunity o : list_NewOppys) {
            if(isInsert) {
                if((o.Override_Incoterms_Code__c != null && !map_incoPaymentName_IncoPaymentTerm.containsKey(o.Override_Incoterms_Code__c)) || 
                    (o.Override_Payment_Terms_Code__c != null &&!map_incoPaymentName_IncoPaymentTerm.containsKey(o.Override_Payment_Terms_Code__c))) {
                    o.addError(system.label.Error_IncotermsCode);
                }
            } else {
                Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(o.Id);
                if((oldOppy.Override_Incoterms_Code__c != o.Override_Incoterms_Code__c && o.Override_Incoterms_Code__c != null && !map_incoPaymentName_IncoPaymentTerm.containsKey(o.Override_Incoterms_Code__c)) || 
                    (oldOppy.Override_Payment_Terms_Code__c != o.Override_Payment_Terms_Code__c && o.Override_Payment_Terms_Code__c != null &&!map_incoPaymentName_IncoPaymentTerm.containsKey(o.Override_Payment_Terms_Code__c))) {
                    o.addError(system.label.Error_IncotermsCode);
                }
            }
            
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Create ANZClause records after insert
    Returns:       
    History
    2018-02-05  Yiming Shen <yiming.shen@capgemini.com> created
    ------------------------------------------------------------*/
    public void createANZClausesAI(List<Opportunity> list_NewOppys) {
        if(ClsTriggerRecursionDefense.isSkipCreateANZClause) return; //added by Tangyong Li 2018-03-16
        set<Id> set_acctIds = new set<Id>();
        map<Id, Account> map_acctId_acct = new map<Id, Account>();
        List<Opportunity> opp = new List<Opportunity>();
        
        for(Opportunity o : list_NewOppys) {
            if(o.AccountId != null) {
                set_acctIds.add(o.AccountId);
            }
        }
        if(!set_acctIds.isEmpty()) {
            for(Account acct : [SELECT Id, Source_System__c,Sales_Organization_ID__c FROM Account WHERE Id IN: set_acctIds]) {
                map_acctId_acct.put(acct.Id, acct);
            }
        }
        
        List<ANZ_Clause_Master__c> clause_master = new List<ANZ_Clause_Master__c>();
        for(ANZ_Clause_Master__c clauseMaster : [select Id, Name, Insurance__c, Opportynity_Type__c, Sequence_No__c 
                                                from ANZ_Clause_Master__c 
                                                order by Sequence_No__c]){
            clause_master.add(clauseMaster);
        }
        
        List<ANZ_Clause__c> anz = new List<ANZ_Clause__c>(); 
        for(Opportunity op : list_NewOppys) {
            if(op.ERP_for_Pricing__c == 'ANZPAC' 
            || (op.AccountId != null && map_acctId_acct.get(op.AccountId) != null 
                && map_acctId_acct.get(op.AccountId).Source_System__c == 42)
            || (op.AccountId != null && map_acctId_acct.get(op.AccountId) != null 
                && map_acctId_acct.get(op.AccountId).Source_System__c == 1  //Added by Buwen Guo 2018-03-08 from email:ANZ prospect account scenario
                && ( map_acctId_acct.get(op.AccountId).Sales_Organization_ID__c == '0114' || map_acctId_acct.get(op.AccountId).Sales_Organization_ID__c == '0116' ) )
                ) {
                for(ANZ_Clause_Master__c az : clause_master) {
                    if((op.Quote_Type__c == 'Standard' 
                        && az.Opportynity_Type__c == 'Quote')
                    ||(op.Quote_Type__c == 'Blanket/Tender' 
                        && az.Opportynity_Type__c == 'Tender')){
                        ANZ_Clause__c clause = new ANZ_Clause__c();
                        clause.Name = az.Name;
                        clause.ANZ_Clause_Master__c = az.id;
                        clause.Opportunity__c = op.id;
                        clause.Insurance__c = az.Insurance__c;
                        clause.Opportynity_Type__c = az.Opportynity_Type__c;
                        clause.Sequence_No__c = az.Sequence_No__c;
                        anz.add(clause);
                    }
                }
            }
        }   
        
        if(anz.size() > 0) {
            insert anz;    
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Create ANZClause records after update
    Returns:       
    History
    2018-02-05  Yiming Shen <yiming.shen@capgemini.com> created
    ------------------------------------------------------------*/
    public void createANZClausesAU(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys) {
        if(ClsTriggerRecursionDefense.isSkipCreateANZClause) return; //added by Tangyong Li 2018-03-16
        set<Id> set_acctIds = new set<Id>();
        map<Id, Account> map_acctId_acct = new map<Id, Account>();
        
        for(Opportunity o : list_UpdateOppys) {
            if(o.AccountId != null) {
                set_acctIds.add(o.AccountId);
            }
        }
        if(!set_acctIds.isEmpty()) {
            for(Account acct : [SELECT Id, Source_System__c,Sales_Organization_ID__c FROM Account WHERE Id IN: set_acctIds]) {
                map_acctId_acct.put(acct.Id, acct);
            }
        }
        map<Id, Opportunity> map_oppyId_updateClauseOppy = new map<Id, Opportunity>();
        for(Opportunity o : list_UpdateOppys) {
            if(o.ERP_for_Pricing__c == 'ANZPAC' 
            || (o.AccountId != null && map_acctId_acct.get(o.AccountId) != null 
                && map_acctId_acct.get(o.AccountId).Source_System__c == 42)
            || (o.AccountId != null && map_acctId_acct.get(o.AccountId) != null 
                && map_acctId_acct.get(o.AccountId).Source_System__c == 1 // Added by Buwen Guo 2018-03-08 from email:ANZ prospect account scenario
                && (map_acctId_acct.get(o.AccountId).Sales_Organization_ID__c == '0114' || map_acctId_acct.get(o.AccountId).Sales_Organization_ID__c == '0116'))
            ) {
                if(o.Quote_Type__c != trgCtx.oldMap.get(o.Id).get('Quote_Type__c')) {
                    map_oppyId_updateClauseOppy.put(o.id, o);
                }
            } 
        }
        
        List<ANZ_Clause__c> delclause = new List<ANZ_Clause__c>();
        for(ANZ_Clause__c clause : [select id, Opportunity__c, Opportynity_Type__c 
                                    from ANZ_Clause__c 
                                    where Opportunity__c IN: map_oppyId_updateClauseOppy.keySet()]){
            delclause.add(clause);
        }
        if(delclause.size() > 0) {
            delete delclause;
        }
        List<ANZ_Clause_Master__c> clause_master = new List<ANZ_Clause_Master__c>();
        for(ANZ_Clause_Master__c clauseMaster : [select id, Name, Insurance__c, Opportynity_Type__c, Sequence_No__c 
                                                from ANZ_Clause_Master__c 
                                                order by Sequence_No__c]){
            clause_master.add(clauseMaster);
        }
        List<ANZ_Clause__c> anz = new List<ANZ_Clause__c>();    
        for(Opportunity op : map_oppyId_updateClauseOppy.values()) {
            for(ANZ_Clause_Master__c az : clause_master) {
                if((op.Quote_Type__c == 'Standard' 
                    && az.Opportynity_Type__c == 'Quote')
                ||(op.Quote_Type__c == 'Blanket/Tender' 
                    && az.Opportynity_Type__c == 'Tender')){
                    ANZ_Clause__c clause = new ANZ_Clause__c();
                    clause.Name = az.Name;
                    clause.ANZ_Clause_Master__c = az.id;
                    clause.Opportunity__c = op.id;
                    clause.Insurance__c = az.Insurance__c;
                    clause.Opportynity_Type__c = az.Opportynity_Type__c;
                    clause.Sequence_No__c = az.Sequence_No__c;
                    anz.add(clause);
                }
            }
        }
        if(anz.size() > 0) {
            insert anz;    
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   If currency of Opportunity is changed, sync currency of all related objects
    Returns:       
    History
    2018-01-05  Yiming Shen <yiming.shen@capgemini.com> created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> syncRelatedListCurrency(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts,map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts) {
        Map<String,String> map_OppyId_OppyCurrencyCode = new Map<String,String>();
        List<Opportunity_Part__c> list_OppyParts2Update = new List<Opportunity_Part__c>();
        for(Opportunity oppy : list_UpdateOppys) {
            Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            if(oldOppy.CurrencyISOCode != oppy.CurrencyISOCode){
                map_OppyId_OppyCurrencyCode.put(oppy.Id, oppy.CurrencyISOCode);
            }
        }
        if(!map_OppyId_OppyCurrencyCode.isEmpty()){
            Map<Id,List<Opportunity_Part__c>> map_OppyId_ListOppyParts = new Map<Id,List<Opportunity_Part__c>>();
            for(Opportunity_Part__c oppyPart : map_oppyPartId_allOppyParts.values()){
                if(!map_OppyId_ListOppyParts.containsKey(oppyPart.Opportunity__c)){
                    map_OppyId_ListOppyParts.put(oppyPart.Opportunity__c, new List<Opportunity_Part__c>());
                }
                map_OppyId_ListOppyParts.get(oppyPart.Opportunity__c).add(oppyPart);
            }
            for(Id oppyId : map_OppyId_OppyCurrencyCode.keySet()){
                if(map_OppyId_ListOppyParts.containsKey(oppyId)
                && map_OppyId_ListOppyParts.get(oppyId).size() > 0){
                    List<Opportunity_Part__c> list_OppyParts = map_OppyId_ListOppyParts.get(oppyId);
                    for(Opportunity_Part__c oppyPart : list_OppyParts){
                        Opportunity_Part__c updateOppyPart;
                        if(map_oppyPartId_oppyParts.containsKey(oppyPart.Id)) {
                            updateOppyPart = map_oppyPartId_oppyParts.get(oppyPart.Id);
                        }else{
                            updateOppyPart = new Opportunity_Part__c();
                            updateOppyPart.Id = oppyPart.Id;
                            map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
                        }
                        updateOppyPart.CurrencyISOCode = map_OppyId_OppyCurrencyCode.get(oppyId);
                    }
                }
            }
        }
        return map_oppyPartId_oppyParts;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   When an opportunity ApprovalStatus is changed to be "Approved" (compare the trigger.oldMap and the trigger.
                   new values of the Opportunity.ApprovalStatus field) then all the oppParts are set to Approved.
    Returns:       
    History
    2017-12-18  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> updateOppyPartToApproved(ClsWrappers.TriggerContext trgCtx, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts) {
        if(list_oppyPartsForApprovedOppy != null && list_oppyPartsForApprovedOppy.size() > 0) {
            for(Opportunity_Part__c part : list_oppyPartsForApprovedOppy) {
                Opportunity oppy = (Opportunity)trgCtx.newMap.get(part.Opportunity__c);
                Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(part.Opportunity__c);
                if(oldOppy.Approval_Status__c != 'Approved' && oppy.Approval_Status__c == 'Approved' && part.Approval_Status__c != 'Approved') {
                    Opportunity_Part__c updateOppyPart;
                    if(map_oppyPartId_oppyParts.containsKey(part.Id)) {
                        updateOppyPart = map_oppyPartId_oppyParts.get(part.Id);
                    } else {
                        updateOppyPart = new Opportunity_Part__c();
                        updateOppyPart.Id = part.Id;
                        map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
                    }
                    updateOppyPart.Approval_Status__c = 'Approved';
                    map_oppyId_isSkipCalOppyApprovalStatus.put(part.Opportunity__c, true);
                }
            }
        }
        return map_oppyPartId_oppyParts;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   If an oppy.Margin__c and oppy.Amount is null then set the values to 0;
    Returns:       
    History
    2017-12-13  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void initOppyMarginAndAmount(List<Opportunity> list_Oppys) {
        for(Opportunity oppy : list_Oppys) {
            /*
            if(oppy.Margin__c == null
            && oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)') {
                oppy.Margin__c = 0;
            }*/
            if(oppy.Amount == null) {
                //oppy.Amount = 0;
            }
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   If an opportunity is marked as Won or Won-Prospect,If the opportunity has multiple pending quotes 
                   then show an error message that says: "Please mark the winning quote as won in order to set this opportunity to Won".  
                   Leave the opp.stage as it is (don't change it to won or won-prospect) 
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-03  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void checkQuoteStatusForOppyStage(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys){
        set<Id> set_oppyIds = new set<Id>();
        list<Energy_Quote__c> list_updateQuotes = new list<Energy_Quote__c>();
        map<Id, list<Energy_Quote__c>> map_oppyId_listQuotes = new map<Id, list<Energy_Quote__c>>();
        map<Id, list<Energy_Quote__c>> map_oppyId_listPendingQuotes = new map<Id, list<Energy_Quote__c>>();
        map<Id, Opportunity> map_oppyId_oppty = new map<Id, Opportunity>(); //added by Tangyong Li 2018-03-16
        for(Opportunity oppy : list_UpdateOppys) {
            Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            if((oppy.StageName == 'Won' || oppy.StageName == 'Won - Prospect') && oppy.StageName != oldOppy.StageName) {
                set_oppyIds.add(oppy.Id);
                map_oppyId_oppty.put(oppy.Id, oppy);
                if(oppy.Account_RecordType__c == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId() && !EnergyQuoteTrgHandler.isFromQuoteRecreateParts){
                    if(oppy.StageName != 'Won - Prospect') {
                        oppy.StageName = 'Won - Prospect';
                    }else if(oppy.StageName != 'Won') {
                        oppy.StageName = 'Won';
                    }
                }
            }
        }
        for(Energy_Quote__c quo : [SELECT Id, Approval_Status__c, Opportunity_Name__c, opportunity_name__r.Reason_of_Win__c FROM Energy_Quote__c WHERE Opportunity_Name__c IN: set_oppyIds]) {
            if(quo.Approval_Status__c == 'Pending') {
                if(!map_oppyId_listPendingQuotes.containsKey(quo.Opportunity_Name__c)) {
                    map_oppyId_listPendingQuotes.put(quo.Opportunity_Name__c, new list<Energy_Quote__c>());
                }
                map_oppyId_listPendingQuotes.get(quo.Opportunity_Name__c).add(quo);
            }
            if(!map_oppyId_listQuotes.containsKey(quo.Opportunity_Name__c)) {
                map_oppyId_listQuotes.put(quo.Opportunity_Name__c, new list<Energy_Quote__c>());
            }
            map_oppyId_listQuotes.get(quo.Opportunity_Name__c).add(quo);
        }
        for(Id oppyId : map_oppyId_listQuotes.keySet()) {
            if(map_oppyId_listQuotes.get(oppyId) != null && map_oppyId_listQuotes.get(oppyId).size() == 1) {
                Energy_Quote__c engQuote = map_oppyId_listQuotes.get(oppyId)[0];
                if(engQuote.Approval_Status__c != 'Won') {
                    engQuote.Approval_Status__c = 'Won';
                    //engQuote.Reason_of_Win__c = engQuote.opportunity_name__r.Reason_of_Win__c;
                    engQuote.Reason_of_Win__c = map_oppyId_oppty.get(engQuote.opportunity_name__c).Reason_of_Win__c;
                    //modified by Tangyong Li 2018-03-20
                    if(engQuote.Reason_of_Win__c == null || engQuote.Reason_of_Win__c == '') {
                        trgCtx.newMap.get(oppyId).addError(system.label.Error_SingleQuoteReasonWon);
                    } else {
                        list_updateQuotes.add(engQuote);
                    }
                }
            } else if(map_oppyId_listPendingQuotes.get(oppyId) != null && map_oppyId_listPendingQuotes.get(oppyId).size() > 1) {
                trgCtx.newMap.get(oppyId).addError(system.label.Error_multiQuoteReasonWon);
            }
        }
        if(list_updateQuotes.size() > 0) {
            isUpdateQuoteStatusFromOppyTrg = true;
            update list_updateQuotes;
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to specifically checks to see if the Account is set on the Opportunity,
                   set Opportunity.Territory__c and Opportunity.ERP_For_Pricing__c based on Account.SalesHierarchy__c 
                   and Account.Source_System__c.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-30  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void setOppyTerritoryAndERPPricingBI(List<Opportunity> list_NewOppys) {
        if(!isSkipSetOppyTerritoryAndERPPricing){
            set<Id> set_acctIds = new set<Id>();
            map<Id, Account> map_acctId_acct = new map<Id, Account>();
            for(Opportunity oppy : list_NewOppys) {
                if(oppy.AccountId != null) {
                    set_acctIds.add(oppy.AccountId);
                }
            }
            if(!set_acctIds.isEmpty()) {
                for(Account acct : [SELECT Id, Sales_Hierarchy__c, Source_System__c,Sales_Organization_ID__c 
                                    FROM Account 
                                    WHERE Id IN: set_acctIds]) {
                    map_acctId_acct.put(acct.Id, acct);
                }
            }
            for(Opportunity oppy : list_NewOppys) {
                if(oppy.AccountId != null) {
                    Account oppyAcct = map_acctId_acct.get(oppy.AccountId);
                    if(oppyAcct != null) {
                        if(oppyAcct.Sales_Hierarchy__c != null && oppy.Territory__c == null) {
                            oppy.Territory__c = oppyAcct.Sales_Hierarchy__c;
                        }
                        if(oppyAcct.Source_System__c != null && oppy.ERP_for_Pricing__c == null) {
                            if(oppyAcct.Source_System__c == 1) {
                                oppy.ERP_for_Pricing__c = 'SAP (except ANZPAC)';
                                //Added by Buwen Guo 2018-03-08 from email:ANZ prospect account scenario
                                if(oppyAcct.Sales_Organization_ID__c == '0114' || oppyAcct.Sales_Organization_ID__c == '0116'){oppy.ERP_for_Pricing__c = 'ANZPAC';}
                            } else if(oppyAcct.Source_System__c == 42) {
                                oppy.ERP_for_Pricing__c = 'ANZPAC';
                            } else if(oppyAcct.Source_System__c == 51) {
                                oppy.ERP_for_Pricing__c = 'MFGPRO';
                            } else {
                                oppy.ERP_for_Pricing__c = 'No ERP';
                            }
                        }
                    }
                }
            }
            isSkipSetOppyTerritoryAndERPPricing = true;
        }
    }
    
    public void setOppyTerritoryAndERPPricingBU(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys) {
        if(!isSkipSetOppyTerritoryAndERPPricing){
            set<Id> set_acctIds = new set<Id>();
            map<Id, Account> map_acctId_acct = new map<Id, Account>();
            for(Opportunity oppy : list_UpdateOppys) {
                if(oppy.AccountId != null && oppy.AccountId != trgCtx.oldMap.get(oppy.Id).get('AccountId')) {
                    set_acctIds.add(oppy.AccountId);
                }
            }
            if(!set_acctIds.isEmpty()) {
                for(Account acct : [SELECT Id, Sales_Hierarchy__c, Source_System__c,Sales_Organization_ID__c 
                                    FROM Account 
                                    WHERE Id IN: set_acctIds]) {
                    map_acctId_acct.put(acct.Id, acct);
                }
            }
            for(Opportunity oppy : list_UpdateOppys) {
                Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
                if(oppy.AccountId != null) {
                    Account oppyAcct = map_acctId_acct.get(oppy.AccountId);
                    if(oppyAcct != null) {
                        if(oppyAcct.Sales_Hierarchy__c != null && oppy.Territory__c == oldOppy.Territory__c) {
                            oppy.Territory__c = oppyAcct.Sales_Hierarchy__c;
                        }
                        if(oppyAcct.Source_System__c != null && oppy.ERP_for_Pricing__c == oldOppy.ERP_for_Pricing__c) {
                            if(oppyAcct.Source_System__c == 1) {
                                //Added by buwen guo  2018-04-27 IR-04400 Update- Please apply a check that if ERP was changed from blank to some valid value, then no pricing call should be triggered
                                ExtOppyPartDiscounting.bool_isInEditERPForPricing = true;
                                oppy.ERP_for_Pricing__c = 'SAP (except ANZPAC)';
                                //Added by Buwen Guo 20180308 from email:ANZ prospect account scenario
                                if(oppyAcct.Sales_Organization_ID__c == '0114' || oppyAcct.Sales_Organization_ID__c == '0116'){oppy.ERP_for_Pricing__c = 'ANZPAC';}
                            } else if(oppyAcct.Source_System__c == 42) {
                                ExtOppyPartDiscounting.bool_isInEditERPForPricing = true;
                                oppy.ERP_for_Pricing__c = 'ANZPAC';
                            } else if(oppyAcct.Source_System__c == 51) {
                                ExtOppyPartDiscounting.bool_isInEditERPForPricing = true;
                                oppy.ERP_for_Pricing__c = 'MFGPRO';
                            } else {
                                ExtOppyPartDiscounting.bool_isInEditERPForPricing = true;
                                oppy.ERP_for_Pricing__c = 'No ERP';
                            }
                        }
                    }
                }
            }
            isSkipSetOppyTerritoryAndERPPricing = true;
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to When an EMEA opportunity is created then email notification will be sent to.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-16  Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void emailNotificationSent(List<Opportunity> list_NewOppys, map<Id, Opportunity> map_oppyId_allOppys) {
        list<Opportunity> list_EMEAOppys = new list<Opportunity>();
        set<Id> set_userOrGroupId = new set<Id>();
        list<Id> list_userOrGroupId = new list<Id>();
        set<Id> set_level4UserId = new set<Id>();
        set<Id> set_emailUserId = new set<Id>();
        list<String> list_userGroupEmailAddress = new list<String>();
        list<Messaging.SingleEmailMessage> list_mails = new list<Messaging.SingleEmailMessage>();
        map<Id, String> map_userId_email = new map<Id, String>();
        map<Id, Contact> map_oppyId_cont = new map<Id, Contact>();
        Set<Id> set_OppyIds = new Set<Id>();
        for(Opportunity oppy : list_NewOppys) {
            set_OppyIds.add(oppy.Id);
        }
        
        for(Id oppyId : set_OppyIds){
            if(map_oppyId_allOppys.containsKey(oppyId)){
                Opportunity oppy = map_oppyId_allOppys.get(oppyId);
                if(oppy.Account.Sales_Hierarchy__r.Level_2_Territory_Code__c == '100325') {
                    list_EMEAOppys.add(oppy);
                    if(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c != null && oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c != '') {
                        set_level4UserId.add(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c);
                    }
                }
            }
        }
        /*
        for(Opportunity oppy : map_oppyId_allOppys.values()){
            if(set_OppyIds.contains(oppy.Id)
            && oppy.Account.Sales_Hierarchy__r.Level_2_Territory_Code__c == '100325') {
                list_EMEAOppys.add(oppy);
                if(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c != null && oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c != '') {
                    set_level4UserId.add(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c);
                }
            }
        }*/
        EmailTemplate emeaTemp;
        for(EmailTemplate e : [SELECT Id, Name, Subject, Body, CreatedDate FROM EmailTemplate WHERE DeveloperName = 'Email_Notification_on_the_New_Opportunity' limit 1]) {
            emeaTemp = e;
        }
        for(GroupMember gm : [SELECT UserOrGroupId, Id, GroupId FROM GroupMember WHERE Group.Name = 'EMEA Opportunity Pricing Team']) {
            set_userOrGroupId.add(gm.UserOrGroupId);
            list_userOrGroupId.add(gm.UserOrGroupId);
        }
        set_emailUserId.addAll(set_userOrGroupId);
        set_emailUserId.addAll(set_level4UserId);
        for(User u : [SELECT Email, Id FROM User WHERE Id IN: set_emailUserId]) {
            if(set_userOrGroupId.contains(u.Id)) {
                list_userGroupEmailAddress.add(u.Email);
            }
            if(set_level4UserId.contains(u.Id)) {
                map_userId_email.put(u.Id, u.Email);
            }
        }
        /*
        map<String, list<Contact>> map_email_listConts = new map<String, list<Contact>>();
        for(Contact cont : [SELECT Email, Id FROM Contact WHERE Email IN: map_userId_email.values()]) {
            if(!map_email_listConts.containsKey(cont.Email)) {
                map_email_listConts.put(cont.Email, new list<Contact>());
            }
            map_email_listConts.get(cont.Email).add(cont);
        }
        for(Opportunity oppy : list_EMEAOppys) {
            Contact cont;
            if(map_userId_email.containsKey(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c) && 
              map_email_listConts.containsKey(map_userId_email.get(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c))) {
                cont = map_email_listConts.get(map_userId_email.get(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c))[0];
            } else if(map_email_listConts.containsKey(list_userGroupEmailAddress[0])){
                cont = map_email_listConts.get(list_userGroupEmailAddress[0])[0];
            }
            map_oppyId_cont.put(oppy.Id, cont);
            
            Contact newCont = new Contact();
            newCont.AccountId = oppy.AccountId;
            newCont.LastName = 'test';
            if(map_userId_email.containsKey(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c)) {
                newCont.Email = map_userId_email.get(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c);
            } else {
                newCont.Email = list_userGroupEmailAddress[0];
            }
            map_oppyId_cont.put(oppy.Id, newCont);
        }*/
        try{
            /*
            if(map_oppyId_cont.size() > 0) {
                insert map_oppyId_cont.values();
            }*/
            for(Opportunity oppy : list_EMEAOppys) {
                if(emeaTemp != null) {
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    list<String> list_emailAddress = new list<String>();
                    list_emailAddress.addAll(list_userGroupEmailAddress);
                    if(map_userId_email.containsKey(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c)) {
                        list_emailAddress.add(map_userId_email.get(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c));
                    }
                    if(list_emailAddress.size() > 0) {
                        mail.setWhatId(oppy.Id);
                        //mail.setTargetObjectId(map_oppyId_cont.get(oppy.Id).Id);
                        if(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c != null && oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c != '') {
                            mail.setTargetObjectId(oppy.Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c);
                        } else {
                            mail.setTargetObjectId(list_userOrGroupId[0]);
                        }
                        mail.setToAddresses(list_emailAddress);
                        mail.setTemplateID(emeaTemp.Id);
                        list_mails.add(mail);
                    }

                }
            }
            if(list_mails.size() > 0) {
                Messaging.sendEmail(list_mails);
            }
            //if(map_oppyId_cont.size() > 0) {
            //    delete map_oppyId_cont.values();
            //}
        }catch(Exception e){
            String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
            //ErrorLogging.Log(e);
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to assign Primary_Opportunity__c on Opportunity object.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-10-13 Yiming Shen <yiming.shen@capgemini.com> created
    ------------------------------------------------------------*/
    public void assignPrimaryOppy(List<Opportunity> list_NewOppys, map<Id, Opportunity> map_oppyId_allOppys){
        Map<Id,List<Opportunity>> map_PriamryOppyId_ListNewOppys = new Map<Id,List<Opportunity>>();
        Map<Id,Id> map_PrimaryOppyId_TopPrimaryOppyId = new Map<Id,Id>();
        for(Opportunity oppy : list_NewOppys) {
            //if(oppy.Primary_Opportunity__c != null){
            //    if(!map_PriamryOppyId_ListNewOppys.containsKey(oppy.Primary_Opportunity__c)){
            //        map_PriamryOppyId_ListNewOppys.put(oppy.Primary_Opportunity__c, new List<Opportunity>());
            //    }
            //    map_PriamryOppyId_ListNewOppys.get(oppy.Primary_Opportunity__c).add(oppy);
            //}
            if(oppy.Master_Opportunity__c != null){
                if(!map_PriamryOppyId_ListNewOppys.containsKey(oppy.Master_Opportunity__c)){
                    map_PriamryOppyId_ListNewOppys.put(oppy.Master_Opportunity__c, new List<Opportunity>());
                }
                map_PriamryOppyId_ListNewOppys.get(oppy.Master_Opportunity__c).add(oppy);
            }
        }
        //System.debug('---map_PriamryOppyId_ListNewOppys:::' + map_PriamryOppyId_ListNewOppys);
        if(map_PriamryOppyId_ListNewOppys.size() > 0){
            Set<Id> set_PrimaryOppyIds = new Set<Id>();
            set_PrimaryOppyIds.addAll(map_PriamryOppyId_ListNewOppys.keySet());
            for(Id oppyId : set_PrimaryOppyIds){
                if(map_oppyId_allOppys.containsKey(oppyId)){
                    //map_PrimaryOppyId_TopPrimaryOppyId.put(oppyId, map_oppyId_allOppys.get(oppyId).Primary_Opportunity__c);
                    map_PrimaryOppyId_TopPrimaryOppyId.put(oppyId, map_oppyId_allOppys.get(oppyId).Master_Opportunity__c);
                }
            }
        }
        //System.debug('---map_PrimaryOppyId_TopPrimaryOppyId:::' + map_PrimaryOppyId_TopPrimaryOppyId);
        if(map_PriamryOppyId_ListNewOppys.size() > 0){
            for(Id primaryOppyId : map_PriamryOppyId_ListNewOppys.keySet()){
                if(map_PrimaryOppyId_TopPrimaryOppyId.containsKey(primaryOppyId)){
                    for(Opportunity newOppy : map_PriamryOppyId_ListNewOppys.get(primaryOppyId)){
                        //newOppy.Primary_Opportunity__c = (map_PrimaryOppyId_TopPrimaryOppyId.get(primaryOppyId) != null) ? map_PrimaryOppyId_TopPrimaryOppyId.get(primaryOppyId) : primaryOppyId;
                        newOppy.Master_Opportunity__c = (map_PrimaryOppyId_TopPrimaryOppyId.get(primaryOppyId) != null) ? map_PrimaryOppyId_TopPrimaryOppyId.get(primaryOppyId) : primaryOppyId;
                    }
                }
            }
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to when the Opportunity.Account is changed then you need to recalculate all the pricing.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-23  Tangyong Li <tangyong.li@capgemini.com> Created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> recalculateOppyPartPricing(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys, map<Id, Opportunity> map_oppyId_allOppys, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts) {
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        set<String> set_MFGProOppyIds = new set<String>();
        list<Opportunity> list_MFGProOppys = new list<Opportunity>();
        map<String, list<Opportunity_Part__c>> map_oppyId_listOppyPart = new map<String, list<Opportunity_Part__c>>();
        list<opportunity_part__c> list_tempOppyParts = new list<opportunity_part__c>();
        
        //Added by buwen guo  2018-04-27 IR-04400 Update- Please apply a check that if ERP was changed from blank to some valid value, then no pricing call should be triggered
        if(ExtOppyPartDiscounting.bool_isInEditERPForPricing || EnergyQuoteTrgHandler.isFromQuoteRecreateParts){
            return map_oppyPartId_oppyParts;
        }
        
        if(currUser == null) {
            currUser = [select Id, MED_Region__c from user where id=:UserInfo.getUserId()];
        }
        String sessionId = UserInfo.getSessionId();
        
        for(Opportunity oppy : list_UpdateOppys) {
            Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            if(oppy.AccountId != oldOppy.AccountId){
                set_MFGProOppyIds.add(oppy.Id);
                if(map_oppyId_allOppys.containsKey(oppy.Id)){
                    list_MFGProOppys.add(map_oppyId_allOppys.get(oppy.Id));
                }
            }
        }
        
        for(Opportunity_Part__c oppyPart : map_oppyPartId_allOppyParts.values()){
            if(set_MFGProOppyIds.contains(oppyPart.Opportunity__c) && oppyPart.Part_Number_txt__c != null && !set_dummyPartNames.contains(oppyPart.Part_Number_txt__c) && !oppyPart.Part_Number_txt__c.toLowerCase().contains('proposal')){
                if(!map_oppyId_listOppyPart.containsKey(oppyPart.Opportunity__c)) {
                    map_oppyId_listOppyPart.put(oppyPart.Opportunity__c, new list<Opportunity_Part__c>());
                }
                map_oppyId_listOppyPart.get(oppyPart.Opportunity__c).add(oppyPart);
            }
        }
        
        list<Opportunity_Part__c> list_ampics_oppyParts = new list<Opportunity_Part__c>();
        for(Opportunity oppy : list_MFGProOppys) {
            if(map_oppyId_listOppyPart.get(oppy.Id) != null) {
                if(oppy.ERP_for_Pricing__c == 'SAP (except ANZPAC)' || oppy.ERP_for_Pricing__c == 'MFGPRO' || oppy.ERP_for_Pricing__c == 'ANZPAC'){
                    String str_accName = oppy.Account.Name;
                    
                    /*if(oppy.ERP_for_Pricing__c == 'SAP (except ANZPAC)' 
                        //&& str_accName != null 
                        //&& str_accName.toLowerCase().contains('prospect')
                        && oppy.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId()
                        //Modified by Yiming Shen at 2017-12-03 from email: Issues 12/01 point 6
                        ){
                        //Modified by Buwen Guo 2017-12-01 from email: Issues 11/30 point 6
                        //InventoryAndPricing.getPrice(Json.serialize(oppy),Json.serialize(map_oppyId_listOppyPart.get(oppy.Id)));
                    }else{
                        InventoryAndPricing.getPrice(Json.serialize(oppy),Json.serialize(map_oppyId_listOppyPart.get(oppy.Id)));
                    }*/
                    //Added by Buwen Guo 2018-01-26 requirement from email:SAP integration clarification
                    if(!(oppy.ERP_for_Pricing__c == 'SAP (except ANZPAC)' && oppy.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())) {
                        system.debug('O1042LineCallout::');
                        InventoryAndPricing.getPrice(Json.serialize(oppy),Json.serialize(map_oppyId_listOppyPart.get(oppy.Id)));
                        list_tempOppyParts.addAll(map_oppyId_listOppyPart.get(oppy.Id));
                    }
                }
                if(oppy.ERP_for_Pricing__c == 'ANZPAC' || (oppy.Account.recordtype.name == 'Prospect' && currUser.MED_Region__c == 'Aus / New Zlnd')){
                    //list_ampics_oppyParts.addAll(map_oppyId_listOppyPart.get(oppy.Id));
                }
            }
        }
        //Added by Buwen Guo 2018-03-23 requirement from email:Bug in Awaiting Data
        Energy_Control__c isNotAllowRestCallout = Energy_Control__c.getInstance('Energy Control');
        Energy_Control__c isNotAllowCalloutUser = Energy_Control__c.getInstance('Limit User');
        
        for(Opportunity_Part__c oppyPart : list_tempOppyParts){
            //Added by Buwen Guo 2018-03-22 requirement from email:Bugs to Fix... point 4
            opportunity_part__c updateOppyPart;
            if(map_oppyPartId_oppyParts.containsKey(oppyPart.Id)) {
                updateOppyPart = map_oppyPartId_oppyParts.get(oppyPart.Id);
            } else {
                updateOppyPart = new Opportunity_Part__c();
                updateOppyPart.Id = oppyPart.Id;
                map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
            }
            if(isNotAllowRestCallout != null && isNotAllowRestCallout.Disable_Integrations__c != true && oppyPart.opportunity__r.createdDate >= isNotAllowRestCallout.Callout_Start_Date__c){
                if(isNotAllowCalloutUser != null && isNotAllowCalloutUser.Limit_User__c != null && isNotAllowCalloutUser.Limit_User__c != '' && isNotAllowCalloutUser.Disable_Integrations__c == true){
                    List<String> list_userNames = isNotAllowCalloutUser.Limit_User__c.split(';');
                    if(!list_userNames.contains(UserInfo.getName())){
                        system.debug('o1082:Awaiting::');
                        updateOppyPart.ERP_Pricing_Status__c = 'Awaiting Data';
                    }
                }else{
                    system.debug('o1086:Awaiting::');
                    updateOppyPart.ERP_Pricing_Status__c = 'Awaiting Data';
                }
            }
        }
        
        if(list_ampics_oppyParts.size() > 0){
            list<opportunity_part__c> list_opp2Update = new list<opportunity_part__c>();
            for(opportunity_part__c opp : list_ampics_oppyParts){
                if(opp.part__r.Curr_CS_75__c != null){
                    opportunity_part__c updateOppyPart;
                    if(map_oppyPartId_oppyParts.containsKey(opp.Id)) {
                        updateOppyPart = map_oppyPartId_oppyParts.get(opp.Id);
                    } else {
                        updateOppyPart = new Opportunity_Part__c();
                        updateOppyPart.Id = opp.Id;
                        map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
                    }
                    updateOppyPart.Standard_Cost__c = ClsAPLForecastUtil.transformIsoCode(opp.part__r.Curr_CS_75__c,opp.part__r.CurrencyIsoCode,opp.CurrencyIsoCode);
                    //list_opp2Update.add(opp);
                }
            }
            //if(list_opp2Update.size() > 0){
            //    update list_opp2Update;
            //}
        }
        return map_oppyPartId_oppyParts;
    }
    
    /*------------------------------------------------------------
    Author:         Buwen Guo <buwen.guo@capgemini.com>
    Description:    When an opp is updated you should look for all parts where isCloned = true and send them to the ERP for pricing.
                    Requirement from email:Cloning Opportunities: IR-03861 point 3
    Inputs:         trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2018-03-27      Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> sendClonedOppyPartsToERP(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys, map<Id, Opportunity> map_oppyId_allOppys, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts) {
        Set<String> set_dummyPartNames = new Set<String>{'Transportation Costs', 'Installation Costs', 'Training Costs','Freight Costs','Commission Costs','Distribution Costs','Other Costs'};
        set<String> set_MFGProOppyIds = new set<String>();
        list<Opportunity> list_MFGProOppys = new list<Opportunity>();
        map<String, list<Opportunity_Part__c>> map_oppyId_listOppyPart = new map<String, list<Opportunity_Part__c>>();
        list<opportunity_part__c> list_tempOppyParts = new list<opportunity_part__c>();
        system.debug('ClsCloneOppyPartQueue.bool_isInCloneOppyPartQueue::'+ClsCloneOppyPartQueue.bool_isInCloneOppyPartQueue);
        system.debug('ExtOpportunityDeepClone.bool_isInOpportunityDeepClone::'+ExtOpportunityDeepClone.bool_isInOpportunityDeepClone);
        
        //Added by buwen guo  2018-04-27 IR-04400 Update- Please apply a check that if ERP was changed from blank to some valid value, then no pricing call should be triggered
        if(ClsCloneOppyPartQueue.bool_isInCloneOppyPartQueue || ExtOpportunityDeepClone.bool_isInOpportunityDeepClone || ExtOppyPartDiscounting.bool_isInEditERPForPricing || EnergyQuoteTrgHandler.isFromQuoteRecreateParts){
            return map_oppyPartId_oppyParts;
        }
        
        system.debug('sendClonedOppyPartsToERP::');
        if(currUser == null) {
            currUser = [select Id, MED_Region__c from user where id=:UserInfo.getUserId()];
        }
        String sessionId = UserInfo.getSessionId();
        Set<String> set_tempOppyIds = new Set<String>();
        for(Opportunity oppy : list_UpdateOppys) {
            set_tempOppyIds.add(oppy.Id);
        }
        
        for(Opportunity_Part__c oppyPart : map_oppyPartId_allOppyParts.values()){
            if(set_tempOppyIds.contains(oppyPart.Opportunity__c) && oppyPart.isCloned__c == true){
                set_MFGProOppyIds.add(oppyPart.Opportunity__c);
            }
        }
        for(String str_oppyId : set_MFGProOppyIds){
            if(map_oppyId_allOppys.containsKey(str_oppyId)){
                list_MFGProOppys.add(map_oppyId_allOppys.get(str_oppyId));
            }
        }
        
        for(Opportunity_Part__c oppyPart : map_oppyPartId_allOppyParts.values()){
            if(set_MFGProOppyIds.contains(oppyPart.Opportunity__c)&& 
                    oppyPart.Part_Number_txt__c != null && 
                    !set_dummyPartNames.contains(oppyPart.Part_Number_txt__c) && 
                    !oppyPart.Part_Number_txt__c.toLowerCase().contains('proposal') && 
                    oppyPart.isCloned__c == true ){
                        
                if(!map_oppyId_listOppyPart.containsKey(oppyPart.Opportunity__c)) {
                    map_oppyId_listOppyPart.put(oppyPart.Opportunity__c, new list<Opportunity_Part__c>());
                }
                map_oppyId_listOppyPart.get(oppyPart.Opportunity__c).add(oppyPart);
            }
        }
        system.debug('oppyPart::map::'+map_oppyId_listOppyPart);
        
        list<Opportunity_Part__c> list_ampics_oppyParts = new list<Opportunity_Part__c>();
        for(Opportunity oppy : list_MFGProOppys) {
            if(map_oppyId_listOppyPart.get(oppy.Id) != null) {
                if(oppy.ERP_for_Pricing__c == 'SAP (except ANZPAC)' || oppy.ERP_for_Pricing__c == 'MFGPRO' || oppy.ERP_for_Pricing__c == 'ANZPAC'){
                    String str_accName = oppy.Account.Name;
                    system.debug('oppy.ERP_for_Pricing__c::'+oppy.ERP_for_Pricing__c);
                    system.debug('oppy.Account.RecordTypeId::'+oppy.Account.RecordTypeId);
                    system.debug('aaa::'+Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId());
                    
                    //Added by Buwen Guo 2018-01-26 requirement from email:SAP integration clarification
                    if(!(oppy.ERP_for_Pricing__c == 'SAP (except ANZPAC)' && oppy.Account.RecordTypeId == Schema.SObjectType.Account.getRecordTypeInfosByName().get('Prospect').getRecordTypeId())) {
                        system.debug('O1154LineCallout::');
                        InventoryAndPricing.getPrice(Json.serialize(oppy),Json.serialize(map_oppyId_listOppyPart.get(oppy.Id)));
                        list_tempOppyParts.addAll(map_oppyId_listOppyPart.get(oppy.Id));
                    }
                }
                if(oppy.ERP_for_Pricing__c == 'ANZPAC' || (oppy.Account.recordtype.name == 'Prospect' && currUser.MED_Region__c == 'Aus / New Zlnd')){
                    //list_ampics_oppyParts.addAll(map_oppyId_listOppyPart.get(oppy.Id));
                }
            }
        }
        //Added by Buwen Guo 2018-03-23 requirement from email:Bug in Awaiting Data
        Energy_Control__c isNotAllowRestCallout = Energy_Control__c.getInstance('Energy Control');
        Energy_Control__c isNotAllowCalloutUser = Energy_Control__c.getInstance('Limit User');
        
        for(Opportunity_Part__c oppyPart : list_tempOppyParts){
            //Added by Buwen Guo 2018-03-22 requirement from email:Bugs to Fix... point 4
            opportunity_part__c updateOppyPart;
            if(map_oppyPartId_oppyParts.containsKey(oppyPart.Id)) {
                updateOppyPart = map_oppyPartId_oppyParts.get(oppyPart.Id);
            } else {
                updateOppyPart = new Opportunity_Part__c();
                updateOppyPart.Id = oppyPart.Id;
                map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
            }
            if(isNotAllowRestCallout != null && isNotAllowRestCallout.Disable_Integrations__c != true && oppyPart.opportunity__r.createdDate >= isNotAllowRestCallout.Callout_Start_Date__c){
                if(isNotAllowCalloutUser != null && isNotAllowCalloutUser.Limit_User__c != null && isNotAllowCalloutUser.Limit_User__c != '' && isNotAllowCalloutUser.Disable_Integrations__c == true){
                    List<String> list_userNames = isNotAllowCalloutUser.Limit_User__c.split(';');
                    if(!list_userNames.contains(UserInfo.getName())){
                        system.debug('o1212:Awaiting::');
                        updateOppyPart.ERP_Pricing_Status__c = 'Awaiting Data';
                    }
                }else{
                    system.debug('o1216:Awaiting::');
                    updateOppyPart.ERP_Pricing_Status__c = 'Awaiting Data';
                }
            }
        }
        
        if(list_ampics_oppyParts.size() > 0){
            list<opportunity_part__c> list_opp2Update = new list<opportunity_part__c>();
            for(opportunity_part__c opp : list_ampics_oppyParts){
                if(opp.part__r.Curr_CS_75__c != null){
                    opportunity_part__c updateOppyPart;
                    if(map_oppyPartId_oppyParts.containsKey(opp.Id)) {
                        updateOppyPart = map_oppyPartId_oppyParts.get(opp.Id);
                    } else {
                        updateOppyPart = new Opportunity_Part__c();
                        updateOppyPart.Id = opp.Id;
                        map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
                    }
                    updateOppyPart.Standard_Cost__c = ClsAPLForecastUtil.transformIsoCode(opp.part__r.Curr_CS_75__c,opp.part__r.CurrencyIsoCode,opp.CurrencyIsoCode);
                    //list_opp2Update.add(opp);
                }
            }
        }
        
        
        return map_oppyPartId_oppyParts;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to when the Opportunity.Account is changed then you need to recalculate all the pricing.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-23  Tangyong Li <tangyong.li@capgemini.com> Created
    ------------------------------------------------------------*/
    public void setOppyApprovalStatusBI(List<Opportunity> list_NewOppys) {
        for(Opportunity oppy : list_NewOppys) {
            if(oppy.Approval_Status__c == null || oppy.Approval_Status__c == '') {
                oppy.Approval_Status__c = 'Approval Not Needed';
            }
            //added by Tangyong Li 2018-03-23 for email DOA for SAP
            //if(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)' || oppy.Quote_Type__c == 'Blanket/Tender'){
            //    oppy.Approval_Status__c = 'Approval Required';
            //}
            //end
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to when the Opportunity.Account is changed then you need to recalculate all the pricing.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-23  Tangyong Li <tangyong.li@capgemini.com> Created
    ------------------------------------------------------------*/
    public void setOppyApprovalStatusBU(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts) {
        //isUpdateOppyApprovalStatus = true;
        if(EnergyQuoteTrgHandler.isFromQuoteRecreateParts) return;
        set<String> set_oppyIds = new set<String>();
        set<String> set_amountMarginOppyIds = new set<String>();
        list_oppyPartsForApprovedOppy = new list<Opportunity_Part__c>();
        set<Id> set_awaitingApprovalOppyIds = new set<Id>();
        set<Id> set_rejectedOppyIds = new set<Id>();
        for(Opportunity oppy : list_UpdateOppys) {
            if(oppy.Approval_Status__c == null || oppy.Approval_Status__c == '') {
                oppy.Approval_Status__c = 'Approval Not Needed';
            } else if(trgCtx.oldMap.get(oppy.Id).get('Approval_Status__c') != oppy.Approval_Status__c) {
                if(oppy.Approval_Status__c == 'Awaiting Approval') {
                    isUpdateOppyApprovalStatus = true;
                    set_awaitingApprovalOppyIds.add(oppy.Id);
                } else if(oppy.Approval_Status__c == 'Rejected') {
                    isUpdateOppyApprovalStatus = true;
                    set_rejectedOppyIds.add(oppy.Id);
                }
            }
            if(!OpportunityPartTrgHandler.isUpdateNotNeededPart) {
                Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            
                //added by Tangyong Li 2018-01-23
                //comment by Tangyong Li 2018-04-02 issue IR-03983
                /*
                if(oppy.NDR_Quote_Document_Number__c != oldOppy.NDR_Quote_Document_Number__c 
                    && oppy.NDR_Quote_Document_Number__c != null && oppy.NDR_Quote_Document_Number__c != '' 
                    && (oppy.SAP_Quote_Create_Message__c == null || oppy.SAP_Quote_Create_Message__c == '') 
                    && oppy.SAP_Quote_Type__c == 'Small Quote'){
                    oppy.Approval_Status__c = 'Approved';
                } //end
                else if(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)' && oppy.SAP_Quote_Type__c == 'Small Quote' && !(map_oppyId_isFromAutoCreateQuoteForSmallQuote != null && map_oppyId_isFromAutoCreateQuoteForSmallQuote.containsKey(oppy.Id))){
                    //system.debug('oppy status null::::222  ');
                    oppy.Approval_Status__c = 'Approval Not Needed';
                } else {*/
                    set_oppyIds.add(oppy.Id);
                    if(((oppy.Amount != oldOppy.Amount || oppy.Margin__c != oldOppy.Margin__c)|| OpportunityPartTrgHandler.isInCheckIfUpdatedPastQuote == true)
                       && (oppy.Amount > oppy.Approved_Total__c || oppy.Margin__c > oppy.Approved_Margin__c)){
                        //system.debug('approval status::::  ' + oppy.Approval_Status__c);
                        set_amountMarginOppyIds.add(oppy.Id);
                    }
                //}
            }
        }
        
        if(OpportunityPartTrgHandler.isUpdateNotNeededPart) return;
        map<String, Integer> map_oppyId_PartsWithoutQuoteLineItemCounter = new map<String, Integer>();
        map<String, Integer> map_oppyId_PartsTargetPriceEqualStandardPriceCounter = new map<String, Integer>();
        map<String, list<Opportunity_Part__c>> map_oppyId_Parts = new map<String, list<Opportunity_Part__c>>();
        map<String, Integer> map_oppyId_hasbookSales = new map<String, Integer>();
        
        for(Opportunity_Part__c part : map_oppyPartId_allOppyParts.values()){
            if(set_oppyIds.contains(part.Opportunity__c)){
                if(trgCtx.newMap.get(part.Opportunity__c).get('Approval_Status__c') == 'Approved') {
                    list_oppyPartsForApprovedOppy.add(part);
                }
                decimal salesPrice;
                decimal offeredPrice;
                if(part.Sales_Price__c != null) salesPrice = part.Sales_Price__c.setScale(2);
                if(part.Offered_Price__c != null) offeredPrice = part.Offered_Price__c.setScale(2);
                if(!map_oppyId_Parts.containsKey(part.opportunity__c)) {
                    map_oppyId_Parts.put(part.opportunity__c, new list<Opportunity_Part__c>());
                }
                map_oppyId_Parts.get(part.opportunity__c).add(part);
                if(!map_oppyId_PartsWithoutQuoteLineItemCounter.containsKey(part.opportunity__c)) {
                    map_oppyId_PartsWithoutQuoteLineItemCounter.put(part.opportunity__c, 0);
                }
                if(part.Energy_Quote_Line_Item__c == null) {
                    Integer counter = map_oppyId_PartsWithoutQuoteLineItemCounter.get(part.opportunity__c);
                    map_oppyId_PartsWithoutQuoteLineItemCounter.put(part.opportunity__c, counter+1);
                }
                if(!map_oppyId_PartsTargetPriceEqualStandardPriceCounter.containsKey(part.opportunity__c)) {
                    map_oppyId_PartsTargetPriceEqualStandardPriceCounter.put(part.opportunity__c, 0);
                }
                //Modified by Yiming Shen 2018-03-23
                //if(salesPrice == offeredPrice) {
                if(salesPrice != null && offeredPrice != null 
                && salesPrice != 0 && offeredPrice != 0 
                && salesPrice == offeredPrice) {
                    Integer counter = map_oppyId_PartsTargetPriceEqualStandardPriceCounter.get(part.opportunity__c);
                    map_oppyId_PartsTargetPriceEqualStandardPriceCounter.put(part.opportunity__c, counter+1);
                }
                if(!map_oppyId_hasbookSales.containsKey(part.opportunity__c)) {
                    map_oppyId_hasbookSales.put(part.opportunity__c, 0);
                }
                if(part.Sales_Price__c != 0 && part.Sales_Price__c != null) {
                    map_oppyId_hasbookSales.put(part.opportunity__c, map_oppyId_hasbookSales.get(part.opportunity__c)+1);
                }
            }
        }
        //system.debug('map_oppyId_hasbookSales::::   ' + map_oppyId_hasbookSales);
        for(Opportunity oppy : list_UpdateOppys) {
            if(!set_awaitingApprovalOppyIds.contains(oppy.Id) && !set_rejectedOppyIds.contains(oppy.Id)) {
                Integer totalParts = 0;     
                Integer amountOfPartNoQLI = 0;     
                Integer amountSamePrice = 0;     
                Integer amountSalesPriceNotNull = 0;     
                if(map_oppyId_Parts.containsKey(oppy.Id)) {
                    totalParts = map_oppyId_Parts.get(oppy.Id).size();
                    amountOfPartNoQLI = map_oppyId_PartsWithoutQuoteLineItemCounter.get(oppy.Id);
                    amountSamePrice = map_oppyId_PartsTargetPriceEqualStandardPriceCounter.get(oppy.Id);
                    amountSalesPriceNotNull = map_oppyId_hasbookSales.get(oppy.Id);
                }          
                if(totalParts > 0 && OpportunityPartTrgHandler.isInUpdateOppyMargin == true 
                    && amountSamePrice == totalParts && amountSalesPriceNotNull == totalParts) {
                    oppy.Approval_Status__c = 'Approval Not Needed';     
                } else if(set_amountMarginOppyIds.contains(oppy.Id)) {
                    Boolean isUpdatePastQuote = OpportunityPartTrgHandler.isInCheckIfUpdatedPastQuote;
                    System.debug('---amountSamePrice == totalParts:::' + amountSamePrice +'---'+ totalParts);
                    System.debug('---isUpdatePastQuote:::' + isUpdatePastQuote);
                    System.debug('---amountOfPartNoQLI == 0:::' + amountOfPartNoQLI);
                    if((totalParts != 0 && amountSamePrice == totalParts) || (isUpdatePastQuote == true && amountOfPartNoQLI == 0)) {
                        oppy.Approval_Status__c = 'Approval Not Needed';
                    } else {
                        //system.debug('approval status::::11  ' + oppy.Approval_Status__c);
                        oppy.Approval_Status__c = 'Approval Required';
                    }
                }
                //system.debug('approval status::::22  ' + oppy.Approval_Status__c);
                
                //added by Tangyong Li 2018-03-23 for email DOA for SAP
                //if(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)' || oppy.Quote_Type__c == 'Blanket/Tender') {
                //  oppy.Approval_Status__c = 'Approval Required';
                //}
                //end
            }
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yuan Yao <yuan.yao@capgemini.com>
    Description:   Function to when a opportunity changed to 'approved' ,auto update Approved Total and Approved Margin.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-09-23  Yuan Yao <yuan.yao@capgemini.com> Created
    ------------------------------------------------------------*/
    @TestVisible
    private void updateApprovedTotalIfOppApprove(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_Oppys2Update){
        for(Opportunity oppy : list_Oppys2Update) {
            Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            //System.debug('oppy.Approval_Status__c+++'+ oppy.Approval_Status__c);
            //System.debug('oldOppy.Approval_Status__c+++'+ oldOppy.Approval_Status__c);
            if(oppy.Approval_Status__c != oldOppy.Approval_Status__c && oppy.Approval_Status__c == 'Approved'){
                oppy.Approved_Total__c = oppy.Amount;
                oppy.Approved_Margin__c = oppy.Margin__c;
                //System.debug('oppy+++++'+ oppy.Approved_Total__c+ oppy.Approved_Margin__c);
            }
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to if Opportunity is marked as lost then we must update all OF % values to 0% for that opportunity.
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-08-08  Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    @TestVisible
    private void updateConfidenceLevelForOppy(List<Opportunity> list_NewOppys) {
        for(Opportunity oppy : list_NewOppys) {
            if(oppy.StageName != null && oppy.StageName.containsIgnoreCase('Lost') 
            && oppy.Probability == 0
            ){                     
                oppy.Probability__c = '0';
            }else if(oppy.StageName != null && oppy.StageName.containsIgnoreCase('Won') 
            && oppy.Probability == 100 
            ){
                oppy.Probability__c = '100';
            } 
        }
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to if Opportunity is marked as lost then we must update all OF % values to 0% for that opportunity.
                   Currently, When an opportunity is marked lost you should delete all the OppForecast records for that opportunity.
                   Function to when an opp is marked as Won, set all Pending OppPart records to Won.  Don't update NoBid, Lost, or Won status values though. Only Pending.
                   This Requirement in email : Updates to Part Mgmt and Opportunities (and Create Quote).
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-08-08  Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> syncDetailRecords(Set<Id> set_OpportunityIds4Won, Set<Id> set_OpportunityIds4Lost, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts){
        List<Energy_Quote__c> list_EnergyQuotes2Lost = new List<Energy_Quote__c>();
        List<Opportunity_Forecast__c> list_OppyForecasts2Update = new List<Opportunity_Forecast__c>();
        List<Opportunity_Part_Forecast__c> list_OppyPartForecasts2Delete = new List<Opportunity_Part_Forecast__c>();
        //1.EnergyQuote
        if(set_OpportunityIds4Lost.size() > 0){
            for(Energy_Quote__c energyQuote : [SELECT Approval_Status__c FROM Energy_Quote__c 
                                               WHERE Opportunity_Name__c IN: set_OpportunityIds4Lost
                                               AND Approval_Status__c != 'Lost']){
                energyQuote.Approval_Status__c = 'Lost';
                list_EnergyQuotes2Lost.add(energyQuote);
            } 
        }
        if(set_OpportunityIds4Won.size() > 0 || set_OpportunityIds4Lost.size() > 0){
            //2.OpportunityPart
            if(!isEditingOpportunityPartState){
                for(Opportunity_Part__c oppPart : map_oppyPartId_allOppyParts.values()){
                    if(set_OpportunityIds4Lost.contains(oppPart.Opportunity__c)
                    && oppPart.Status__c != 'Lost'){
                        Opportunity_Part__c updateOppyPart;
                        if(map_oppyPartId_oppyParts.containsKey(oppPart.Id)) {
                            updateOppyPart = map_oppyPartId_oppyParts.get(oppPart.Id);
                        } else {
                            updateOppyPart = new Opportunity_Part__c();
                            updateOppyPart.Id = oppPart.Id;
                            map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
                        }
                        //oppPart.Status__c = 'Lost';
                        updateOppyPart.Status__c = 'Lost';
                    }else if(set_OpportunityIds4Won.contains(oppPart.Opportunity__c)
                    && oppPart.Status__c != 'Won'){
                        Opportunity_Part__c updateOppyPart;
                        if(map_oppyPartId_oppyParts.containsKey(oppPart.Id)) {
                            updateOppyPart = map_oppyPartId_oppyParts.get(oppPart.Id);
                        } else {
                            updateOppyPart = new Opportunity_Part__c();
                            updateOppyPart.Id = oppPart.Id;
                            map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
                        }
                        //oppPart.Status__c = 'Won';
                        updateOppyPart.Status__c = 'Won';
                    }
                }
                isEditingOpportunityPartState = true;
            }
            //3.OpportunityForecast
            Set<Id> set_OppyForecastIds2Lost = new Set<Id>();
            for(Opportunity_Forecast__c oppyForecast : [SELECT Confidence_Level__c,Opportunity__c,
                                                        Opportunity__r.StageName
                                                        FROM Opportunity_Forecast__c 
                                                        WHERE Opportunity__c IN: set_OpportunityIds4Won
                                                        OR Opportunity__c IN: set_OpportunityIds4Lost]){
                if(set_OpportunityIds4Lost.contains(oppyForecast.Opportunity__c)
                && oppyForecast.Confidence_Level__c != '0'){
                    oppyForecast.Confidence_Level__c = '0'; 
                    set_OppyForecastIds2Lost.add(oppyForecast.Id);
                }else if(set_OpportunityIds4Won.contains(oppyForecast.Opportunity__c)
                && oppyForecast.Confidence_Level__c != '100'){
                    oppyForecast.Confidence_Level__c = '100';
                }
                list_OppyForecasts2Update.add(oppyForecast);
            } 
            //4.OpportunityPartForecast
            if(set_OppyForecastIds2Lost.size() > 0){
                for(Opportunity_Part_Forecast__c oppyPartForecast : [SELECT Id
                                                        FROM Opportunity_Part_Forecast__c 
                                                        WHERE Opportunity_Forecast__c IN: set_OppyForecastIds2Lost]){
                    list_OppyPartForecasts2Delete.add(oppyPartForecast);
                } 
            }
        }
        
        //DML
        Savepoint sp = Database.setSavepoint();
        try{
            if(list_OppyPartForecasts2Delete.size() > 0) {delete list_OppyPartForecasts2Delete;}
            if(list_OppyForecasts2Update.size() > 0) {update list_OppyForecasts2Update;}
            if(list_EnergyQuotes2Lost.size() > 0) {update list_EnergyQuotes2Lost;}
        }catch(Exception e){
            Database.rollback(sp);
            String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
            //ErrorLogging.Log(e);
        }
        return map_oppyPartId_oppyParts;
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to if Opportunity is marked as lost then we must update all OF % values to 0% for that opportunity.
                   Currently, When an opportunity is marked lost you should delete all the OppForecast records for that opportunity.
                   Function to when an opp is marked as Won, set all Pending OppPart records to Won.  Don't update NoBid, Lost, or Won status values though. Only Pending.
                   This Requirement in email : Updates to Part Mgmt and Opportunities (and Create Quote).
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-08-08  Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> syncDetailRecordsForWonOrLostOppyAI(List<Opportunity> list_NewOppys, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts) {
        Set<Id> set_OpportunityIds4Won = new Set<Id>();
        Set<Id> set_OpportunityIds4Lost = new Set<Id>();
        
        for(Opportunity oppy : list_NewOppys) {
            if(oppy.StageName.containsIgnoreCase('Won')){                     
                set_OpportunityIds4Won.add(oppy.Id);
            }else if(oppy.StageName.containsIgnoreCase('Lost')){
                set_OpportunityIds4Lost.add(oppy.Id);
            }
        }
        map_oppyPartId_oppyParts = syncDetailRecords(set_OpportunityIds4Won, set_OpportunityIds4Lost, map_oppyPartId_oppyParts, map_oppyPartId_allOppyParts);
        return map_oppyPartId_oppyParts; 
    }
    
    /*------------------------------------------------------------
    Author:        Yiming Shen <yiming.shen@capgemini.com>
    Description:   Function to if Opportunity is marked as lost then we must update all OF % values to 0% for that opportunity.
                   Currently, When an opportunity is marked lost you should delete all the OppForecast records for that opportunity.
                   Function to when an opp is marked as Won, set all Pending OppPart records to Won.  Don't update NoBid, Lost, or Won status values though. Only Pending.
                   This Requirement in email : Updates to Part Mgmt and Opportunities (and Create Quote).
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-08-08  Yiming Shen <yiming.shen@capgemini.com> Created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> syncDetailRecordsForWonOrLostOppyAU(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts) {
        Set<Id> set_OpportunityIds4Won = new Set<Id>();
        Set<Id> set_OpportunityIds4Lost = new Set<Id>();
        
        for(Opportunity oppy : list_UpdateOppys) {
            Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            if(oppy.StageName != oldOppy.StageName){
                if(oppy.StageName.containsIgnoreCase('Won')){                     
                    set_OpportunityIds4Won.add(oppy.Id);
                }else if(oppy.StageName.containsIgnoreCase('Lost')){
                    set_OpportunityIds4Lost.add(oppy.Id);
                }
            }
        }
        map_oppyPartId_oppyParts = syncDetailRecords(set_OpportunityIds4Won, set_OpportunityIds4Lost, map_oppyPartId_oppyParts, map_oppyPartId_allOppyParts);
        return map_oppyPartId_oppyParts; 
    }
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   If QuoteType = OneTimeTender then set SAP Quote Type = One Time Tender
                    else if Total_Opportunity_Value__c > 10k set SAP Quote Type = Big Quote
                    else SAP Quote Type = Small Quote
    Inputs:        Trigger Context
    Returns:       
    History
    2017-09-15  Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public void setSAPQuoteType(List<Opportunity> list_NewOppys){
        for(Opportunity oppy : list_NewOppys) {
            if(oppy.ERP_For_Pricing__c == 'SAP (except ANZPAC)'){
                //modified by Tangyong Li 2018-03-23: 'One Time Tender' -> 'Blanket/Tender'
                /*
                if(oppy.Quote_Type__c == 'One Time Tender'){
                    oppy.SAP_Quote_Type__c = 'One Time Tender';
                */
                if(oppy.Quote_Type__c == 'Blanket/Tender'){
                    oppy.SAP_Quote_Type__c = 'Blanket/Tender';
                }else if(oppy.Total_Opportunity_Value__c > 10000){
                    oppy.SAP_Quote_Type__c = 'Big Quote';
                }else{
                    oppy.SAP_Quote_Type__c = 'Small Quote';
                }
            }else{
                oppy.SAP_Quote_Type__c = null;
            }
            //system.debug('oppyTrigger:::setSAPQuoteType::1::'+oppy);
            //system.debug('oppyTrigger:::setSAPQuoteType::2::'+oppy.SAP_Quote_Type__c);
        }
    }
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   If the Quote Number field has changed and currently has a value AND the SAP Quote Error Message is null
                     AND the SAP Quote Type is "Small Quote" then you should create a new Energy Quote record from the Opportunity records
    Inputs:        Trigger Context
    Returns:       
    History
    2017-12-01  Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public void createQuoteForSmallQuoteType(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateNewOppys, map<Id, Opportunity> map_oppyId_allOppys, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts){
        map_oppyId_isFromAutoCreateQuoteForSmallQuote = new map<Id, Boolean>();
        set<String> set_oppyIds = new set<String>();
        for(Opportunity oppy : list_UpdateNewOppys) {
            Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            
            if( oppy.NDR_Quote_Document_Number__c != oldOppy.NDR_Quote_Document_Number__c 
                && oppy.NDR_Quote_Document_Number__c != null && oppy.NDR_Quote_Document_Number__c != '' 
                && (oppy.SAP_Quote_Create_Message__c == null || oppy.SAP_Quote_Create_Message__c == '') 
                && oppy.SAP_Quote_Type__c == 'Small Quote'){
                
                set_oppyIds.add(oppy.Id);
                map_oppyId_isFromAutoCreateQuoteForSmallQuote.put(oppy.Id, true);
            }
        }
        
        list<Opportunity> list_updateOppys = new list<Opportunity>();
        if(set_oppyIds.size() > 0){
            list<Energy_Quote__c> list_quote2Insert = new list<Energy_Quote__c>();
            
            for(Id oppyId : set_oppyIds){
                if(map_oppyId_allOppys.containsKey(oppyId)){
                    Opportunity currentOpp = map_oppyId_allOppys.get(oppyId);
                    //currentOpp.Approval_Status__c = 'Approved';
                    list_updateOppys.add(currentOpp);                   
                    Energy_Quote__c newQuote = new Energy_Quote__c();
                    if(currentOpp.recordtype.DeveloperName == 'Energy_Sales'){
                        Id salesQuoteId = Schema.SObjectType.Energy_Quote__c.getRecordTypeInfosByName().get('Sales Quote').getRecordTypeId();
                        if(salesQuoteId != null) {
                            newQuote.RecordTypeId = salesQuoteId;
                        }
                    }
                   
                    newQuote.Contact__c = currentOpp.Customer_Contact_Name__c;
                    newQuote.Name = currentOpp.Name + String.valueOf(Date.today()).substring(0, 10);
                    newQuote.Contract__c = currentOpp.ContractId;
                    newQuote.Account_Name__c = currentOpp.AccountId;
                    newQuote.End_Customer__c = currentOpp.End_Customer__c;
                    newQuote.Opportunity_Name__c = currentOpp.Id;
                    //Added by Buwen Guo 2017-10-20 by email:When Creating a Quote from an Opportunity
                    newQuote.CurrencyIsoCode = currentOpp.CurrencyIsoCode;
                    newQuote.Override_Incoterms_Details__c = (currentOpp.Override_Incoterms_Details__c == null)?currentOpp.Account_Incoterms_Details__c:currentOpp.Override_Incoterms_Details__c;
                    
                    //commented by Tangyong Li 2018-02-08 by email Let's do some REAL coding again! 1)d)
                    //newQuote.Override_Payment_Terms_Description__c = (currentOpp.Override_Payment_Terms_Description__c == null)?currentOpp.Account_Payment_Terms_Desc__c:currentOpp.Override_Payment_Terms_Description__c;
                    
                    //Added by Buwen Guo 2017-10-12 by email:Create Quote Button on Opportunity
                    newQuote.Valid_From__c = currentOpp.Valid_From__c;
                    newQuote.Days_prices_valid__c = currentOpp.Days_prices_valid__c;
                    newQuote.Customer_Ref_Number__c = currentOpp.Customer_Ref_Number__c;          // added by yuan yao 2017-10-13
                    newQuote.Contract_start_date__c = currentOpp.Contract_start_date__c;          // added by yuan yao 2017-11-07
                    newQuote.Contract_Finish_Date__c = currentOpp.Contract_Finish_Date__c;
                    newQuote.Language__c = currentOpp.Language_of_Quote__c;                       //Added by Buwen Guo 2017-11-28 from email:Issues to fix 11/21 point 8
                    newQuote.Header_Level_Comments__c = currentOpp.Header_Level_Comments__c;      //Added by Tangyong Li 2018-01-18
                    newQuote.Comments__c = currentOpp.Pricing_price_comment__c;                   //Added by Buwen Guo 2018-05-03 requirement from email:Lots of new issues that need fixing point 9
                    list_quote2Insert.add(newQuote);
                }
            }
            
            if(list_quote2Insert.size() > 0) {
                insert list_quote2Insert;
            }
            
            List<Opportunity_Part__c> list_oppParts = new List<Opportunity_Part__c>();
           
            for(Opportunity_Part__c oppPart : map_oppyPartId_allOppyParts.values()){
                if(set_oppyIds.contains(oppPart.Opportunity__c)
                && oppPart.Status__c != 'No Bid'){
                    list_oppParts.add(oppPart);  
                }
            }
            
            list<Energy_Quote_Line_Item__c> list_quoteLine = new list<Energy_Quote_Line_Item__c>();
            for(Energy_Quote__c newQuote : list_quote2Insert){
                if(list_oppParts.size() > 0){
                    //System.debug('list_oppPartssize+++');
                    
                    for(Opportunity_Part__c oppPart : list_oppParts){
                        Energy_Quote_Line_Item__c item = new Energy_Quote_Line_Item__c();
                        item.Energy_Quote_Name__c = newQuote.Id;
                        item.CurrencyIsoCode = newQuote.CurrencyIsoCode;
                        item.Quantity__c = oppPart.Quantity__c;
                        String str_comments = (oppPart.Comments__c == null || oppPart.Comments__c == '')?oppPart.Name:(oppPart.Comments__c.length()>255)?oppPart.Comments__c.substring(0,254):oppPart.Comments__c;
                        //System.debug('in list_oppPartssize+++');
                        item.Part_Number__c = (oppPart.Part__r.Proposal_Part__c)?str_comments:oppPart.Name;
                        item.Part__c = oppPart.Part__c;
                        item.Seq_No__c = oppPart.Seq_No__c;
                        item.Opportunity_Part__c = oppPart.Id;
                        item.UnitPrice__c = (oppPart.Offered_Price__c == null)? 0 :oppPart.Offered_Price__c;
                        item.Price_List__c = oppPart.Sales_Price__c;
                        item.Product_Hierarchy__c = oppPart.GPL__c;
                        item.TotalPrice__c = (item.UnitPrice__c == null?0:item.UnitPrice__c) * (item.Quantity__c == null?0:item.Quantity__c);
                        item.Max_Qty_in_Standard_lead_time__c = oppPart.Max_Qty_in_Standard_lead_time__c;   // added by yuan yao 2017-10-13
                        item.Lead_Time__c = oppPart.Lead_Time__c;   // added by yuan yao 2017-10-13
                        item.LineNumber__c = oppPart.NDR_Item_Number__c;
                        item.Past_RSQ__c = oppPart.Energy_Quote_Line_Item__c; //Added by Buwen Guo 2017-10-16 from email:Some things to fix and improve point 3
                        item.Unit_of_measure__c = oppPart.Code_for_unit_of_measurement__c; //Added by Buwen Guo 2017-10-20 by email:When Creating a Quote from an Opportunity
                        item.Competitor__c = oppPart.NDR_Competitor_Name__c;    //added by yuan yao 2017-10-31
                        item.Competitor_Part__c = oppPart.NDR_Competitor_Part_Number__c;
                        item.Customer_Part_Number1__c = oppPart.Customer_Part_Number1__c;
                        item.Customer_Part_Number__c = oppPart.Customer_Part_Number__c;
                        item.NDR_Minimum_Order_Quantity__c = oppPart.NDR_Minimum_Order_Quantity__c;
                        item.NDR_Unit_Package_Type__c = oppPart.NDR_Unit_Package_Type__c;     //added by yuan yao 2017-11-07
                        item.Primary_Pack_Quantity__c = oppPart.Primary_Pack_Quantity__c ;
                        item.Description__c = oppPart.Part__r.Description__c;
                        
                        //added by Tangyong Li 2017-11-16
                        if(oppPart.Opportunity__r.ERP_For_Pricing__c == 'SAP (except ANZPAC)') {
                            item.Country_of_Origin__c = oppPart.Country_of_Origin__c;
                            item.NDR_Delivery_Unit__c = oppPart.NDR_Delivery_Unit__c;
                            item.NDR_Minimum_Delivery_Quantity__c = oppPart.NDR_Minimum_Delivery_Quantity__c;
                        }
                        
                        list_quoteLine.add(item);
                    }
                }
            }
            if(list_quoteLine.size() > 0){
                //System.debug('list_quoteLine++++');
                insert list_quoteLine;
            }
            
            //commented by Tangyong Li 2018-01-23
            /*
            if(list_updateOppys.size() > 0) {
                system.debug('approval status::::  ' + list_updateOppys);
                update list_updateOppys;
            }*/
        }
    }
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   when the Opportunity.Quote_Created_time__c is updated,all OppParts.Changed_Since_Quote_Integration__c should always be set to FALSE 
    Inputs:        Trigger Context
    Returns:       
    History
    2017-12-08  Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> setAllPartsChangedSinceQuoteIntegration(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys, map<Id, Opportunity_Part__c> map_oppyPartId_oppyParts, map<Id, Opportunity_Part__c> map_oppyPartId_allOppyParts){
        set<String> set_oppyIds = new set<String>();
        for(Opportunity oppy : list_UpdateOppys) {
            Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            if(oppy.Quote_Created_time__c != oldOppy.Quote_Created_time__c){
                set_oppyIds.add(oppy.Id);
            }
        }
        
        List<Opportunity_Part__c> list_oppParts2Update = new List<Opportunity_Part__c>();
        if(set_oppyIds.size() > 0){
           for(Opportunity_Part__c opp : map_oppyPartId_allOppyParts.values()){
                if(set_oppyIds.contains(opp.opportunity__c)){
                    Opportunity_Part__c updateOppyPart;
                    if(map_oppyPartId_oppyParts.containsKey(opp.Id)) {
                        updateOppyPart = map_oppyPartId_oppyParts.get(opp.Id);
                    } else {
                        updateOppyPart = new Opportunity_Part__c();
                        updateOppyPart.Id = opp.Id;
                        map_oppyPartId_oppyParts.put(updateOppyPart.Id, updateOppyPart);
                    }
                    updateOppyPart.Changed_Since_Quote_Integration__c = false;
                }
            }
        }
        return map_oppyPartId_oppyParts;
    }
    
    /*------------------------------------------------------------
    Author:        Buwen Guo <buwen.guo@capgemini.com>
    Description:   Please update the Sales_hierarchy__c on the Opportunity.Account when the user selects a territory for the opportunity.  
                   Also, please update the Opportunity.Account.source_system__c for the Prospect account also.
                   Requirement from email:12/6 Part Mgmt Issues point 7 feedback
    Inputs:        trgCtx - ClsWrappers.TriggerContext
    Returns:       
    History
    2017-12-13     Buwen Guo <buwen.guo@capgemini.com> Created
    ------------------------------------------------------------*/
    public void updateAccountFields(ClsWrappers.TriggerContext trgCtx, List<Opportunity> list_UpdateOppys){
        Set<String> set_acctIds2Update = new Set<String>();
        set<Id> set_shIds = new set<Id>();
        map<String,Opportunity> map_acctId_oppy = new map<String,Opportunity>();
        if(map_shId_salesHierarchy == null) {
            map_shId_salesHierarchy = new map<Id, Sales_Hierarchy__c>();
        }
        for(Opportunity oppy : list_UpdateOppys) {
            Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
            if(oppy.Territory__c != oldOppy.Territory__c && !map_shId_salesHierarchy.containsKey(oppy.Territory__c)) {
                set_shIds.add(oppy.Territory__c);
            }
            if((oppy.Territory__c != oldOppy.Territory__c || oppy.ERP_for_Pricing__c != oldOppy.ERP_for_Pricing__c) && oppy.AccountId != null){
                set_acctIds2Update.add(oppy.AccountId);
                map_acctId_oppy.put(oppy.AccountId,oppy);
            }
        }
        if(set_shIds.size() != 0) {
            for(Sales_Hierarchy__c sh : [SELECT Id, Level_7_Territory_Code__c FROM Sales_Hierarchy__c WHERE Id IN: set_shIds]) {
                map_shId_salesHierarchy.put(sh.Id, sh);
            }
        }
        list<Account> list_acct2Update = new list<Account>();
        for(Account acct : [select id,Source_System__c,Sales_Hierarchy__c,SALES_TERRITORY_CDE__c, RecordType.Name from Account where Id IN:set_acctIds2Update]){
            if(map_acctId_oppy.containsKey(acct.id)){
                Opportunity oppy = map_acctId_oppy.get(acct.id);
                Opportunity oldOppy = (Opportunity)trgCtx.oldMap.get(oppy.Id);
                //modified by Tangyong Li 2018-03-23 IR-03869: add 'Prospect' recordType filter
                //if(oppy.ERP_for_Pricing__c != oldOppy.ERP_for_Pricing__c){
                if(oppy.ERP_for_Pricing__c != oldOppy.ERP_for_Pricing__c && acct.RecordType.Name == 'Prospect'){
                    if(oppy.ERP_for_Pricing__c == 'SAP (except ANZPAC)'){
                        acct.Source_System__c = 1;
                    }else if(oppy.ERP_for_Pricing__c == 'ANZPAC'){
                        acct.Source_System__c = 1;  //Added by Buwen Guo 2018-03-08 from email:ANZ prospect account scenario
                    }else if(oppy.ERP_for_Pricing__c == 'MFGPRO'){
                        acct.Source_System__c = 51;
                    }else if(oppy.ERP_for_Pricing__c == 'No ERP'){
                        acct.Source_System__c = 2;
                    }
                }
                if(oppy.Territory__c != oldOppy.Territory__c && oppy.Territory__c != null){
                    acct.SALES_TERRITORY_CDE__c = map_shId_salesHierarchy.get(oppy.Territory__c).Level_7_Territory_Code__c;
                    acct.Sales_Hierarchy__c = oppy.Territory__c;
                }
                list_acct2Update.add(acct);
            }
        }
        
        if(list_acct2Update.size() > 0) {
            //system.debug('list_acct2Update:::  ' + list_acct2Update);
            update list_acct2Update;
        } 
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   get opportunity parts base up Opportunity_Part__c.Opportunity__c
    Returns:       map<Id, Opportunity_Part__c>
    History
    2018-01-15     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public map<Id, Opportunity_Part__c> getOpportunityPartsBaseupId(Map<Id,Opportunity> map_OppyId_Oppy) {
        Map<Id, Opportunity_Part__c> map_OppyPartId_OppyPart = new Map<Id, Opportunity_Part__c>();
        Set<Id> set_OppyIds = map_OppyId_Oppy.keySet();
        if(!set_OppyIds.isEmpty()) {
            for(Opportunity_Part__c oppyPart : [SELECT Id, Status__c, Opportunity__r.StageName, 
                                                Changed_Since_Quote_Integration__c, Offered_Price__c,
                                                Sales_Price__c, Standard_Cost__c, Energy_Quote_Line_Item__c, 
                                                Opportunity__c, Approval_Status__c, CurrencyISOCode,
                                                Part__r.Name, Quantity__c, NDR_Item_Number__c,
                                                Code_for_unit_of_measurement__c, part__r.Curr_CS_75__c, 
                                                part__r.CurrencyIsoCode, Seq_No__c, Name,
                                                List_Price__c, GPL__c,Part__c, Comments__c, Part__r.Proposal_Part__c,
                                                Max_Qty_in_Standard_lead_time__c, Lead_Time__c,
                                                NDR_Competitor_Name__c, NDR_Competitor_Part_Number__c, 
                                                Customer_Part_Number1__c, Customer_Part_Number__c,  
                                                NDR_Minimum_Order_Quantity__c, NDR_Unit_Package_Type__c,
                                                Part__r.Description__c, Primary_Pack_Quantity__c,
                                                Country_of_Origin__c, NDR_Delivery_Unit__c,
                                                NDR_Minimum_Delivery_Quantity__c,Opportunity__r.Approval_Status__c,
                                                Total_Price__c,Opportunity__r.RecordType.DeveloperName,
                                                Opportunity__r.ERP_For_Pricing__c,isCloned__c,Part_Number_txt__c,
                                                Opportunity__r.createdDate
                                                FROM Opportunity_Part__c
                                                WHERE Opportunity__c IN: set_OppyIds
                                                ]){
                map_OppyPartId_OppyPart.put(oppyPart.Id, oppyPart);
            }
        }
        return map_OppyPartId_OppyPart; 
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   get opportunities base up Opportunity_Part__c.Opportunity__c
    Returns:       map<Id, Opportunity>
    History
    2018-01-10     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public map<Id, Opportunity> getOpportunitiesBaseupId(ClsWrappers.TriggerContext trgCtx) {
        set<Id> set_oppyIds = new set<Id>();
        map<Id, Opportunity> map_oppyId_allOppys = new map<Id, Opportunity>();
        if(trgCtx.isDelete) {
            for(Sobject sobj : trgCtx.oldList) {
                Opportunity oppy = (Opportunity)sobj;
                if(oppy.RecordTypeId == EnergySalesTypeId){
                    set_oppyIds.add(oppy.Id);
                }
            }
        }else{
            for(Sobject sobj : trgCtx.newList) {
                Opportunity oppy = (Opportunity)sobj;
                if(oppy.RecordTypeId == EnergySalesTypeId){
                    set_oppyIds.add(oppy.Id);
                    //if(trgCtx.isInsert && oppy.Primary_Opportunity__c != null){
                    if(trgCtx.isInsert && oppy.Master_Opportunity__c != null){
                        //set_oppyIds.add(oppy.Primary_Opportunity__c);
                        set_oppyIds.add(oppy.Master_Opportunity__c);
                    }
                }
            }
        }
        if(!set_oppyIds.isEmpty()) {
            for(Opportunity oppy : [SELECT Id, AccountId, Account.Sales_Hierarchy__c, 
                                    Account.Sales_Hierarchy__r.Level_2_Territory_Code__c,
                                    Account.Sales_Hierarchy__r.Level_4_Assigned_Users__c, 
                                    //Primary_Opportunity__c, Account.Source_System__c,
                                    Master_Opportunity__c, Account.Source_System__c,
                                    Account.Distribution_Channel_Cde__c, Account.Name,
                                    ERP_For_Pricing__c, Account.RecordType.Name, Account_Number__c,
                                    Account.AccountNumber, Account.Sales_Organization_ID__c, 
                                    
                                    //modified by Tangyong Li 2018-02-08 by email Let's do some REAL coding again! 1)d)
                                    //Account.RecordTypeId,Name, Override_Payment_Terms_Description__c,
                                    Account.RecordTypeId,Name, createdDate,
                                    Override_Incoterms_Details__c, CurrencyIsoCode, Customer_Contact_Name__c, 
                                    Account_Payment_Terms_Desc__c, Account_Incoterms_Details__c, ContractId, 
                                    RecordType.DeveloperName, End_Customer__c, Header_Level_Comments__c, 
                                    Valid_From__c, Days_prices_valid__c, Customer_Ref_Number__c,
                                    Contract_start_date__c, Contract_Finish_Date__c, Language_of_Quote__c,
                                    Margin__c,Approval_Status__c,Quote_Type__c, SAP_Quote_Type__c,
                                    Pricing_price_comment__c
                                    FROM Opportunity 
                                    WHERE Id IN: set_oppyIds
                                    ]){
                map_oppyId_allOppys.put(oppy.Id, oppy);
            }
        }
        return map_oppyId_allOppys;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Trigger defense for OpportunityTrgHandler.
    Returns:       true - skip triggers
                   false - not skip       
    History
    2017-12-28     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public Boolean avoidOppyMultipleRunning(ClsWrappers.TriggerContext trgCtx) {
        Boolean isAvoidRunning = false;
        if(trgCtx.isBefore) {
            if(trgCtx.isInsert || trgCtx.isUndelete) {
                if(isMultipleBeforeInsert) {
                    isAvoidRunning = true;
                } else {
                    isMultipleBeforeInsert = true;
                }
            } else if(trgCtx.isUpdate) {
                if(isMultipleBeforeUpdate) {
                    isAvoidRunning = true;
                } else {
                    isMultipleBeforeUpdate = true;
                }
            } else if(trgCtx.isDelete) {
                if(isMultipleBeforeDelete) {
                    isAvoidRunning = true;
                } else {
                    isMultipleBeforeDelete = true;
                }
            }
        } else if(trgCtx.isAfter) {
            if(trgCtx.isInsert || trgCtx.isUndelete) {
                if(isMultipleAfterInsert) {
                    isAvoidRunning = true;
                } else {
                    isMultipleAfterInsert = true;
                }
            } else if(trgCtx.isUpdate) {
                if(isMultipleAfterUpdate) {
                    isAvoidRunning = true;
                } else {
                    isMultipleAfterUpdate = true;
                }
            } else if(trgCtx.isDelete) {
                if(isMultipleAfterDelete) {
                    isAvoidRunning = true;
                } else {
                    isMultipleAfterDelete = true;
                }
            }
        }
        return isAvoidRunning;
    }
}