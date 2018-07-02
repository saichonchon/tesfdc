/** 
*    Controller for CtrlManagerReview page
*
@author Min Liu
@created 2012-04-25 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2012-04-25 Min Liu <min.liu@itbconsult.com>
* - Created
*/
public with sharing class CtrlManagerReview {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public BudgetReviewRecord totalBudgetReviewRecord {get; set;}
    public String view {get; set;}
    public String format {get; private set;}
    public Boolean findLast{get; private set;}
    public Boolean isInit{get; private set;}    
    /* the fields are used in total line*/  
    public Decimal totalFinalBudget {get; set;}
    public Decimal totalOriginalBudget {get; set;}
    public Decimal totalFinalBudgetTBRNY {get; set;}
    public String totalGrowth {get; set;}
    /**/
    public Budget__c budget4Reason {get; set;}
    public String currentYear {get; set;}
    public List<SelectOption> list_years {get; set;}
    
    public map<Id, BudgetReviewRecord> map_budgetId_BudgetReviewRecords = new map<Id, BudgetReviewRecord>();
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private List<Id> list_budgetIds;
    private id userId;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CtrlManagerReview(){       
        totalFinalBudget = 0;
        totalOriginalBudget = 0;
        totalFinalBudgetTBRNY = 0;
        userId = UserInfo.getUserId();
        isInit = true;
        list_years = new List<SelectOption>();
        
        // get number format
        if(UserInfo.getLocale().indexOf('de') != -1){
            format = 'de';
        }
        else{
            format = 'other';
        }
        currentYear = ClsBudgetPlanningUtil.getCurrentFiscalYear();
        list_budgetIds = new list<Id>();
        //currentYear = '2012'; //only for test
        buildYears();
        rebuildRecordsByYear();
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    /**
    * The method is used to init manager review records according to the budget
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public pageReference getBudgetRecordViewByAM(){
    	list_budgetIds.clear();
        map_budgetId_BudgetReviewRecords.clear();   
        Budget__c tb = new Budget__c();
        tb.Manager_CMA_Budget__c = 0;
        tb.Manager_Direct_Budget__c = 0;
        tb.Manager_POS_Budget__c = 0;
        tb.Manager_Final_Budget__c = 0;
        totalBudgetReviewRecord = new BudgetReviewRecord(tb, 'total');
                    
        for(Budget__c b :[select Id,
                                 Manager__c,
                                 ownerId,
                                 Territory_Code__c,
                                 owner.Name,
                                 Name,
                                 Stage__c,
                                 Status__c,
                                 Year__c,
                                 Final_CMA_Budget__c,
                                 Final_Direct_Budget__c,
                                 Final_POS_Budget__c,
                                 Final_Total_Budget__c,
                                 Original_CMA_Budget__c,
                                 Original_Direct_Budget__c,
                                 Original_POS_Budget__c,
                                 Original_Total_Budget__c,
                                 Manager_CMA_Budget__c,
                                 Manager_Direct_Budget__c,
                                 Manager_POS_Budget__c,
                                 Manager_Total_Budget__c,
                                 Manager_Final_Budget__c,
                                 //Start by Bin Yuan due to change field to roll up field
                                 /*	
                                 Total_CMA_Budget_TBR_NY__c,
                                 Total_Direct_Budget_TBR_NY__c,
                                 Total_POS_Budget_TBR_NY__c,
                                 Total_Budget_TBR_NY__c,
                                 */
                                 Total_Direct_Budget_TBR_NY_Rollup__c,
                                 Total_POS_Budget_TBR_NY_Rollup__c, 
                                 Total_CMA_Budget_TBR_NY_Rollup__c,
                                 Total_Budget_TBR_NY_Rollup__c,
                                 //End
                                 Final_Total_Budget_TBR_NY__c,
                                 FQ1_Direct__c,
                                 FQ2_Direct__c,
                                 FQ3_Direct__c,
                                 FQ4_Direct__c,
                                 FQ1_POS__c,
                                 FQ2_POS__c,
                                 FQ3_POS__c,
                                 FQ4_POS__c,
                                 FQ1_CMA__c,
                                 FQ2_CMA__c,
                                 FQ3_CMA__c,
                                 FQ4_CMA__c,
                                 Original_Total_Budget_TBR_NY__c
                          from Budget__c
                          where Manager__c = :userId and Year__c = :currentYear order by Owner.Name, Status__c]){ //and Year__c = :currentYear 
            BudgetReviewRecord record = new BudgetReviewRecord(b, view);
            record.myBudget4Total = b.Manager_Total_Budget__c;
            if(record.budget.Manager_CMA_Budget__c != null){
                totalBudgetReviewRecord.budget.Manager_CMA_Budget__c += record.budget.Manager_CMA_Budget__c;
            }
            if(record.budget.Manager_Direct_Budget__c != null){
                totalBudgetReviewRecord.budget.Manager_Direct_Budget__c += record.budget.Manager_Direct_Budget__c;
            }
            if(record.budget.Manager_POS_Budget__c != null){
                totalBudgetReviewRecord.budget.Manager_POS_Budget__c += record.budget.Manager_POS_Budget__c;
            }               
            list_budgetIds.add(b.Id);               
            map_budgetId_BudgetReviewRecords.put(b.Id, record);         
        }
        // decide the last record
        for(Integer i=list_budgetIds.size()-1; i>=0; i--){
            if(map_budgetId_BudgetReviewRecords.get(list_budgetIds[i]).budget.Status__c == 'Submitted'){
                map_budgetId_BudgetReviewRecords.get(list_budgetIds[i]).isLast = true;
                findLast = true;
                // set the myBudget value for the last record
                map_budgetId_BudgetReviewRecords.get(list_budgetIds[i]).myBudget4LastDirect = map_budgetId_BudgetReviewRecords.get(list_budgetIds[i]).budget.Manager_Direct_Budget__c;
                map_budgetId_BudgetReviewRecords.get(list_budgetIds[i]).myBudget4LastPOS = map_budgetId_BudgetReviewRecords.get(list_budgetIds[i]).budget.Manager_POS_Budget__c;
                map_budgetId_BudgetReviewRecords.get(list_budgetIds[i]).myBudget4LastCMA = map_budgetId_BudgetReviewRecords.get(list_budgetIds[i]).budget.Manager_CMA_Budget__c;
                break;
            }
        }
        
        return null;
    }   

    public PageReference backToView(){
        pageReference pf = new pageReference('/' + ClsBudgetPlanningUtil.budgetPrefix);
        pf.setRedirect(true);
        return pf;              
    }  
        
    /**
    * The method is used to get the manager review records displayed on the page
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public list<BudgetReviewRecord> getBugetReviewRecords(){
        list<BudgetReviewRecord> list_tmp = new list<BudgetReviewRecord>();
        if(list_budgetIds.size() > 0){
            for(Id bId :list_budgetIds){
                list_tmp.add(map_budgetId_BudgetReviewRecords.get(bId));
            }   
        }
        return list_tmp;
    }
    
    /**
    * The method is used to build the manager review records
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public void buildManagerReviewRcords(){
        //******************************************************************
        //START: save the final budget of manager
        //******************************************************************
        totalBudgetReviewRecord.budget.Manager_Final_Budget__c = 0;
        if(totalBudgetReviewRecord.budget.Manager_CMA_Budget__c != null) totalBudgetReviewRecord.budget.Manager_Final_Budget__c  += totalBudgetReviewRecord.budget.Manager_CMA_Budget__c;
        if(totalBudgetReviewRecord.budget.Manager_Direct_Budget__c != null) totalBudgetReviewRecord.budget.Manager_Final_Budget__c  += totalBudgetReviewRecord.budget.Manager_Direct_Budget__c;
        if(totalBudgetReviewRecord.budget.Manager_POS_Budget__c != null) totalBudgetReviewRecord.budget.Manager_Final_Budget__c  += totalBudgetReviewRecord.budget.Manager_POS_Budget__c;
        //******************************************************************
        //END: save the final budget of manager
        //******************************************************************    
        String queryString = '';
        totalFinalBudget = 0;
        totalOriginalBudget = 0;
        totalFinalBudgetTBRNY = 0;
        Decimal tmpGrowth = 0;
        if(!list_budgetIds.isEmpty()){
            queryString = 'select Budget__c, Budget__r.owner.name name, sum(Billings_LY__c) sumBLY, sum(Billings_CYTD__c) sumBCYTD, sum(Billings_CYRR__c) sumBCYRR, sum(Forecast_CY__c) sumFCY, Budget__r.ownerId, Budget__r.Territory__c ';
            queryString += 'from Budget_Detail__c ';
            queryString += 'where Budget__c IN :list_budgetIds ';
            if(view != 'Total') queryString += 'and Type__c = :view ';
            queryString += 'group by Budget__c, Budget__r.ownerId, Budget__r.owner.name, Budget__r.Territory__c, Budget__r.Territory__r.Level_7_Territory_Code__c ';
            queryString += 'order by Budget__r.owner.name, Budget__r.Territory__r.Level_7_Territory_Code__c ';
            for(AggregateResult ar :dataBase.query(queryString)){
                Budget_Detail__c bd = new Budget_Detail__c();
                bd.Billings_LY__c = (Decimal)ar.get('sumBLY');
                bd.Billings_CYTD__c = (Decimal)ar.get('sumBCYTD');
                bd.Billings_CYRR__c = (Decimal)ar.get('sumBCYRR');
                bd.Forecast_CY__c = (Decimal)ar.get('sumFCY');  
                BudgetReviewRecord record = map_budgetId_BudgetReviewRecords.get((Id) ar.get('Budget__c'));
                record.bType = view;
                record.budgetDetail = bd;
            }
            
            // calculate total manager review record
            Budget_Detail__c totalBD = new Budget_Detail__c();
            for(Integer i= 0; i< list_budgetIds.size(); i++){
                Id bId = list_budgetIds[i];
                BudgetReviewRecord record = map_budgetId_BudgetReviewRecords.get(bId);              
                // calculate my budget for total
                if(view == 'Total'){
                    record.myBudget4Total = 0;
                    if(!record.isLast){
                        if(record.budget.Manager_Direct_Budget__c != null) record.myBudget4Total += record.budget.Manager_Direct_Budget__c;
                        if(record.budget.Manager_POS_Budget__c != null) record.myBudget4Total += record.budget.Manager_POS_Budget__c;
                        if(record.budget.Manager_CMA_Budget__c != null) record.myBudget4Total += record.budget.Manager_CMA_Budget__c;
                    }
                    else{
                        if(record.myBudget4LastDirect != null) record.myBudget4Total += record.myBudget4LastDirect;
                        if(record.myBudget4LastPOS != null) record.myBudget4Total += record.myBudget4LastPOS;
                        if(record.myBudget4LastCMA != null) record.myBudget4Total += record.myBudget4LastCMA;
                        
                    }
                }
                // calculate budget detail field
                // Billings LY
                if(record.budgetDetail.Billings_LY__c != null){
                    totalBD.Billings_LY__c = totalBD.Billings_LY__c==null? record.budgetDetail.Billings_LY__c : totalBD.Billings_LY__c + record.budgetDetail.Billings_LY__c;
                }
                // Billings CYTD
                if(record.budgetDetail.Billings_CYTD__c != null){
                    totalBD.Billings_CYTD__c = totalBD.Billings_CYTD__c==null ? record.budgetDetail.Billings_CYTD__c : totalBD.Billings_CYTD__c + record.budgetDetail.Billings_CYTD__c;
                }
                // Billings CYRR
                if(record.budgetDetail.Billings_CYRR__c != null){
                    totalBD.Billings_CYRR__c = totalBD.Billings_CYRR__c==null ? record.budgetDetail.Billings_CYRR__c : totalBD.Billings_CYRR__c + record.budgetDetail.Billings_CYRR__c;
                }
                // Estimated Final CY
                if(record.budgetDetail.Forecast_CY__c != null){
                    totalBD.Forecast_CY__c = totalBD.Forecast_CY__c==null ? record.budgetDetail.Forecast_CY__c : totalBD.Forecast_CY__c + record.budgetDetail.Forecast_CY__c;
                }
                // calculate budget field               
                if(view == 'Direct'){
                    // Final Budget
                    if(record.budget.Final_Direct_Budget__c != null){
                        totalFinalBudget += record.budget.Final_Direct_Budget__c;
                    }
                    // Original Budget
                    if(record.budget.Original_Direct_Budget__c != null){
                        totalOriginalBudget += record.budget.Original_Direct_Budget__c;
                    }
                    // Final Budget TBR NY
                    //Start by Bin Yuan due to change field to roll up field
                    /*
                    if(record.budget.Total_Direct_Budget_TBR_NY__c != null){
                    	totalFinalBudgetTBRNY += record.budget.Total_Direct_Budget_TBR_NY__c;
                    } 
                    */         
                    if(record.budget.Total_Direct_Budget_TBR_NY_Rollup__c != null){
                    	totalFinalBudgetTBRNY += record.budget.Total_Direct_Budget_TBR_NY_Rollup__c;
                    }          
                    //End
                }
                else if(view == 'POS'){
                    if(record.budget.Final_POS_Budget__c != null){
                        totalFinalBudget += record.budget.Final_POS_Budget__c;
                    }
                    if(record.budget.Original_POS_Budget__c != null){
                        totalOriginalBudget += record.budget.Original_POS_Budget__c;
                    }
                    //Start by Bin Yuan due to change field to roll up field
                    /*
                    if(record.budget.Total_POS_Budget_TBR_NY__c != null){
                    	totalFinalBudgetTBRNY += record.budget.Total_POS_Budget_TBR_NY__c;
                    } 
                    */
                    if(record.budget.Total_POS_Budget_TBR_NY_Rollup__c != null){
                    	totalFinalBudgetTBRNY += record.budget.Total_POS_Budget_TBR_NY_Rollup__c;
                    } 
                                       
                }           
                else if(view == 'CMA'){
                    if(record.budget.Final_CMA_Budget__c != null){
                        totalFinalBudget += record.budget.Final_CMA_Budget__c;
                    }
                    if(record.budget.Original_CMA_Budget__c != null){
                        totalOriginalBudget += record.budget.Original_CMA_Budget__c;
                    }
                    //Start by Bin Yuan due to change field to roll up field
                    /*
                    if(record.budget.Total_CMA_Budget_TBR_NY__c != null){
                    	totalFinalBudgetTBRNY += record.budget.Total_CMA_Budget_TBR_NY__c;
                    }  
                    */               
                    if(record.budget.Total_CMA_Budget_TBR_NY_Rollup__c != null){
                    	totalFinalBudgetTBRNY += record.budget.Total_CMA_Budget_TBR_NY_Rollup__c;
                    }  
                    //End       
                }
                // when view is total
                else{
                    if(record.budget.Final_Total_Budget__c != null){
                        totalFinalBudget += record.budget.Final_Total_Budget__c;
                    }
                    if(record.budget.Original_Total_Budget__c != null){
                        totalOriginalBudget += record.budget.Original_Total_Budget__c;
                    }
                    //Start by Bin Yuan due to change field to roll up field
                    /*
                 	if(record.budget.Total_Budget_TBR_NY__c != null){
                    	totalFinalBudgetTBRNY += record.budget.Total_Budget_TBR_NY__c;
                    } 
                    */                                                  
                 	if(record.budget.Total_Budget_TBR_NY_Rollup__c != null){
                    	totalFinalBudgetTBRNY += record.budget.Total_Budget_TBR_NY_Rollup__c;
                    } 
                    //End
                }                                               
            }
            // Growth %
            Decimal managerTotalBudget = 0;
            if(view == 'Direct') managerTotalBudget = totalBudgetReviewRecord.budget.Manager_Direct_Budget__c;
            else if(view == 'POS') managerTotalBudget = totalBudgetReviewRecord.budget.Manager_POS_Budget__c;
            else if(view == 'CMA') managerTotalBudget = totalBudgetReviewRecord.budget.Manager_CMA_Budget__c;
            else managerTotalBudget = totalBudgetReviewRecord.budget.Manager_Final_Budget__c;
            if(managerTotalBudget == null) managerTotalBudget = 0;
            if(totalBD.Forecast_CY__c != null && totalBD.Forecast_CY__c != 0 && managerTotalBudget != 0){
                tmpGrowth = (managerTotalBudget / totalBD.Forecast_CY__c - 1) * 100;    
            }
            tmpGrowth = tmpGrowth.setScale(1);
            totalGrowth = String.valueOf(tmpGrowth);
            
            totalBudgetReviewRecord.budgetDetail = totalBD;
        }       
    }
    
     /**
    * The method is used to used to save budget records
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public void save(){
        saveBudgetRecords('Save');
    }
    
    /**
    * The method is used to save, approve or reject the manager review records
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    private void saveBudgetRecords(String action){
        ApexPages.getMessages().clear();
        Savepoint sp = Database.setSavepoint();         
        List<Budget__c> list_updateBudgets = new List<Budget__c>();
        List<Budget__c> list_budgets = new List<Budget__c>();
        //******************************************************************
        //START: save the final budget of manager
        //******************************************************************
        totalBudgetReviewRecord.budget.Manager_Final_Budget__c = 0;
        if(totalBudgetReviewRecord.budget.Manager_CMA_Budget__c != null) totalBudgetReviewRecord.budget.Manager_Final_Budget__c  += totalBudgetReviewRecord.budget.Manager_CMA_Budget__c;
        if(totalBudgetReviewRecord.budget.Manager_Direct_Budget__c != null) totalBudgetReviewRecord.budget.Manager_Final_Budget__c  += totalBudgetReviewRecord.budget.Manager_Direct_Budget__c;
        if(totalBudgetReviewRecord.budget.Manager_POS_Budget__c != null) totalBudgetReviewRecord.budget.Manager_Final_Budget__c  += totalBudgetReviewRecord.budget.Manager_POS_Budget__c;
        //******************************************************************
        //END: save the final budget of manager
        //******************************************************************        
        for(BudgetReviewRecord record: map_budgetId_BudgetReviewRecords.values()){
            if(record.budget.Status__c == 'Submitted') {
                if(record.isChecked){
                    if(action == 'Approved'){
                        if(record.budget.Stage__c == 'Original'){
                            record.budget.Status__c = 'Draft';
                            record.budget.Stage__c = 'Final';
                            // added: set original values when approved
                            record.budget.Original_Direct_Budget__c = 0;
			                record.budget.Original_Direct_Budget__c += record.budget.FQ1_Direct__c==null?0:record.budget.FQ1_Direct__c;
			                record.budget.Original_Direct_Budget__c += record.budget.FQ2_Direct__c==null?0:record.budget.FQ2_Direct__c;
			                record.budget.Original_Direct_Budget__c += record.budget.FQ3_Direct__c==null?0:record.budget.FQ3_Direct__c;
			                record.budget.Original_Direct_Budget__c += record.budget.FQ4_Direct__c==null?0:record.budget.FQ4_Direct__c;
			
			                record.budget.Original_POS_Budget__c = 0;
			                record.budget.Original_POS_Budget__c += record.budget.FQ1_POS__c==null?0:record.budget.FQ1_POS__c;
			                record.budget.Original_POS_Budget__c += record.budget.FQ2_POS__c==null?0:record.budget.FQ2_POS__c;
			                record.budget.Original_POS_Budget__c += record.budget.FQ3_POS__c==null?0:record.budget.FQ3_POS__c;
			                record.budget.Original_POS_Budget__c += record.budget.FQ4_POS__c==null?0:record.budget.FQ4_POS__c;
			                
			                record.budget.Original_CMA_Budget__c = 0;
			                record.budget.Original_CMA_Budget__c += record.budget.FQ1_CMA__c==null?0:record.budget.FQ1_CMA__c;
			                record.budget.Original_CMA_Budget__c += record.budget.FQ2_CMA__c==null?0:record.budget.FQ2_CMA__c;
			                record.budget.Original_CMA_Budget__c += record.budget.FQ3_CMA__c==null?0:record.budget.FQ3_CMA__c;
			                record.budget.Original_CMA_Budget__c += record.budget.FQ4_CMA__c==null?0:record.budget.FQ4_CMA__c;
			                //Start by Bin Yuan due to change field to roll up field
			                //record.budget.Original_Total_Budget_TBR_NY__c = record.budget.Total_Budget_TBR_NY__c;                           
			                record.budget.Original_Total_Budget_TBR_NY__c = record.budget.Total_Budget_TBR_NY_Rollup__c;   
			                //End                        
                        }
                        else{
                            record.budget.Status__c = 'Approved';
                        }
                        // added: override the budget values in BBBMonthly when the budget is approved
                        list_budgets.add(record.budget);
                        
                        
                        record.budget.Is_Reject__c = false;
                        record.budget.Reject_Reason__c = null;
                    }
                    else if(action == 'Rejected'){
                        // clear original values
                        if(record.budget.Stage__c == 'Original'){   
                        	record.budget.Original_Direct_Budget__c = null;
                        	record.budget.Original_POS_Budget__c = null;
                        	record.budget.Original_CMA_Budget__c = null;
                        	record.budget.Original_Total_Budget_TBR_NY__c = null;
                        }
                        record.budget.Status__c = 'Draft';
                        record.budget.Is_Reject__c = true;
                        record.budget.Reject_Reason__c = budget4Reason.Reject_Reason__c;
                    }
                }
                // save the last record
                if(record.isLast){
                    record.budget.Manager_Direct_Budget__c = record.myBudget4LastDirect;
                    record.budget.Manager_POS_Budget__c = record.myBudget4LastPOS;
                    record.budget.Manager_CMA_Budget__c = record.myBudget4LastCMA;
                }
                //comment by Bin Yuan 2015-07-29 due to fix manager target issue in the budget planning page
                //if(totalBudgetReviewRecord.budget.Manager_Final_Budget__c != null) record.budget.Manager_Final_Budget__c = totalBudgetReviewRecord.budget.Manager_Final_Budget__c;
                if(totalBudgetReviewRecord.budget.Manager_Final_Budget__c != null) {
                	record.budget.Manager_Final_Budget__c = (record.budget.Manager_Direct_Budget__c == null ? 0 : record.budget.Manager_Direct_Budget__c);
                	record.budget.Manager_Final_Budget__c += (record.budget.Manager_POS_Budget__c == null ? 0 : record.budget.Manager_POS_Budget__c);
                	record.budget.Manager_Final_Budget__c += (record.budget.Manager_CMA_Budget__c == null ? 0 : record.budget.Manager_CMA_Budget__c);
                }
                list_updateBudgets.add(record.budget);              
            }
        }
        
        // added: override the budget values in BBBMonthly when the budget is approved (done in trigger) 
        try{
            if(list_updateBudgets.size() > 0) update list_updateBudgets;  
        	//if(!list_bbbM2Update.isEmpty()) update list_bbbM2Update;
        	if(!list_budgets.isEmpty()) ClsBudgetPlanningUtil.setBBBMonthlyValuesByBudgets(list_budgets);
        }
        catch(exception ex){
            ApexPages.addMessages(ex);
            Database.rollback(sp);                      
        }     
    }
    
    /**
    * The method is used to used to save records and submit for approval
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public PageReference saveAndApproval(){
        saveBudgetRecords('Approved');
        if(ApexPages.hasMessages()){
            return null;         
        }
        PageReference pageRef = new PageReference('/apex/CtrlManagerReview');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
    * The method is used to used to save records and reject the records
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public PageReference saveAndReject(){
        saveBudgetRecords('Rejected');
        if(ApexPages.hasMessages()){
            return null;         
        }
        PageReference pageRef = new PageReference('/apex/CtrlManagerReview');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    /**
    * The method is used to get the view select list
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public List<SelectOption> getViews(){
        List<SelectOption> list_views = new List<SelectOption>();
        list_views.add(new SelectOption('Direct', 'Direct'));
        list_views.add(new SelectOption('POS', 'POS'));
        list_views.add(new SelectOption('CMA', 'CMA'));
        list_views.add(new SelectOption('Total', 'Total'));
        return list_views;      
    }
    
    /**
    * The method is used to get years
    *
    @author Min Liu
    @created 2012-10-18
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-10-18 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public void buildYears(){
        List<String> list_strYears = new List<String>();
        list_strYears.add(currentYear);
        for(AggregateResult ar :[select Year__c year
                				 from Budget__c
                          	     where Manager__c = :userId group by Year__c order by Year__c]){
            if(currentYear != String.valueOf(ar.get('year'))){
            	list_strYears.add(String.valueOf(ar.get('year')));
            }         	     	
        }
        
        if(currentYear != '') list_strYears.sort();
        for(String y :list_strYears){
        	if(y != '') list_years.add(new SelectOption(y, y));
        	else list_years.add(new SelectOption(y, '--None--'));
        }          
    }
    
    /**
    * The method is used to rebuild the mananger review records by selected year
    *
    @author Min Liu
    @created 2012-10-18
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-10-18 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public void rebuildRecordsByYear(){
    	view = 'Direct';
    	findLast = false;      
        budget4Reason = new Budget__c();
        getBudgetRecordViewByAM();
        buildManagerReviewRcords();         
    }
       
    //********************************* -=END public methods=- ************************************   
    
    //********************************* -=BEGIN private methods=- *********************************   
    //********************************* -=END private methods=- ***********************************
        
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************           
    ///*>>>WrapperClass*/
    public class BudgetReviewRecord{
        public Boolean isChecked {get; set;}
        public Budget_Detail__c budgetDetail {get; set;}
        public Budget__c budget {get; set;}
        public Boolean isLast {get; private set;}
        public String bType {get; private set;}
        public Decimal myBudget4Total {get; set;}
        public Decimal myBudget4LastDirect {get; set;}
        public Decimal myBudget4LastPOS {get; set;}
        public Decimal myBudget4LastCMA {get; set;}
        
        // constructor
        public BudgetReviewRecord(Budget__c b, String t){
            isChecked = false;
            budgetDetail = new Budget_Detail__c();
            budget = b;         
            isLast = false;
            bType = t;
            myBudget4Total = 0;
        }
        // calculate the growth of every manager review records
        public String getGrowth(){
            Decimal growth = 0;
            Decimal myBudget;
            if(bType == 'Direct'){
                if(isLast) myBudget = myBudget4LastDirect;
                else myBudget = budget.Manager_Direct_Budget__c;
            }
            else if (bType == 'POS'){
                if(isLast) myBudget = myBudget4LastPOS;
                else myBudget = budget.Manager_POS_Budget__c;
            }
            else if (bType == 'CMA'){
                if(isLast) myBudget = myBudget4LastCMA;
                else myBudget = budget.Manager_CMA_Budget__c;
            }
            else{
                myBudget = myBudget4Total;
            }
            if(myBudget == null) myBudget = 0;
            if(budgetDetail.Forecast_CY__c != null && budgetDetail.Forecast_CY__c != 0 && myBudget != 0){
                growth = (myBudget / budgetDetail.Forecast_CY__c - 1) * 100;
            }
            //if(growth != null) return String.valueOf(growth.setScale(1));
            return String.valueOf(growth.setScale(1));
        }
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
    
}