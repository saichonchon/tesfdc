/** 
 *  Utility class for account planing and its trigger
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-17
 * @version 1.0
 * @since 24.0
 * 
 * 
 *
 * @changelog
 * 2012-05-17 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */



public without sharing class ClsAccountPlanUtility {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static map<String, String> map_region_kz = new map<String, String> {
       'Americas' => 'AM',
       'Asia Pacific' => 'AS', 
       'EMEA' => 'EU'
    };
    // added Lili Zhao 2014-06-12 begin due to add the BU of Industrial
    public static map<String, String> map_BU_IND = new Map<String, String>{
        'Rail' => 'IND',
        'A&C' => 'IND',
        'IB' => 'IND',
        'Solar' => 'IND'
    };
    // end
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    
    /** 
     *  Generating a map with currencyisocode and rate
     * 
     * @author Yuanyuan Zhang
     * @created 2012-07-13
     * 
     *
     * @changelog
     * 2012-07-13 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
     * - Created   
     *
     */
    public static map<String, Decimal> getRateMap(){
        map<String, Decimal> map_ISOCode_convertRate = new map<String, Decimal>();
        for(CurrencyType ct : [SELECT IsActive, 
                                      ConversionRate, 
                                      IsCorporate, 
                                      IsoCode, 
                                      Id
                               FROM CurrencyType
                               WHERE IsActive = true]){
            map_ISOCode_convertRate.put(ct.IsoCode, ct.ConversionRate);
        }
        return map_ISOCode_convertRate;
    }
    
    
    
    
    /** 
     *  Generating A Customer Profiler record with giving Account Plan
     * 
     * @author Yuanyuan Zhang
     * @created 2012-07-12
     * 
     * Param 1 : list account plan record with new values
     * Param 2 : map with old account plan record values
     *
     * @changelog
     * 2012-07-12 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
     * - Created   
     *
     */
    public static void replicateAccountPlan2ACustomer(list<Account_Plan__c> list_new, map<Id, Account_Plan__c> map_old){
        map<Id, Account_Plan__c> map_accPlanId_accPlan = new map<Id, Account_Plan__c>();
        set<Id> set_managerPhotoId = new set<Id>();//to estimate if a attachment is a manager photo
        set<Id> set_companyLogoId = new set<Id>();//to estimate if a attachment is a company logo
        //Only create A Customer Profile for account plan type a
        if(map_old == null){
            /*for(Account_Plan__c ap : list_new){
                if((ap.Customer_Type__c == 'A' || ap.Customer_Type__c == 'B') && ap.Replicate_to_Central_Org__c){
                    map_accPlanId_accPlan.put(ap.Id, ap);
                }
            }*/
        }
        else{
            system.debug('tongxia list_new:' + list_new);
            for(Account_Plan__c ap : list_new){
                system.debug('tongxia ap.Customer_Type__c:' + ap.Customer_Type__c);
                system.debug('tongxia ap.Replicate_to_Central_Org__c:' + ap.Replicate_to_Central_Org__c);
                if(ap.TE_Inside_Account_Plan__c && ap.Replicate_to_Central_Org__c){// changed by mrunal for R-1468
                //&& map_old.get(ap.Id).Replicate_to_Central_Org__c != ap.Replicate_to_Central_Org__c 
                    map_accPlanId_accPlan.put(ap.Id, ap);
                    if(ap.Company_Logo_Id__c != null){
                        set_companyLogoId.add(ap.Company_Logo_Id__c);
                    }
                    if(ap.Account_Manager_Id__c != null){
                        set_managerPhotoId.add(ap.Account_Manager_Id__c);
                    }
                }
            }
        }
        
        if(!map_accPlanId_accPlan.isEmpty()){
            map<Id, String> map_keyProjectId_keyProject = new map<Id, String>();
            for(Account_Plan__c ap : [SELECT Id, Key_Project_1__c ,Key_Project_1__r.Name,
                                             Key_Project_2__c ,Key_Project_2__r.Name,
                                             Key_Project_3__c ,Key_Project_3__r.Name,
                                             Key_Project_4__c ,Key_Project_4__r.Name,
                                             Key_Project_5__c ,Key_Project_5__r.Name,
                                             Key_Project_6__c ,Key_Project_6__r.Name 
                                      FROM Account_Plan__c 
                                      WHERE Id IN :map_accPlanId_accPlan.keySet()]){
                if(ap.Key_Project_1__c != null){
                    map_keyProjectId_keyProject.put(ap.Key_Project_1__c, ap.Key_Project_1__r.Name);
                }
                if(ap.Key_Project_2__c != null){
                    map_keyProjectId_keyProject.put(ap.Key_Project_2__c, ap.Key_Project_2__r.Name);
                }
                if(ap.Key_Project_3__c != null){
                    map_keyProjectId_keyProject.put(ap.Key_Project_3__c, ap.Key_Project_3__r.Name);
                }
                if(ap.Key_Project_4__c != null){
                    map_keyProjectId_keyProject.put(ap.Key_Project_4__c, ap.Key_Project_4__r.Name);
                }
                if(ap.Key_Project_5__c != null){
                    map_keyProjectId_keyProject.put(ap.Key_Project_5__c, ap.Key_Project_5__r.Name);
                }
                if(ap.Key_Project_6__c != null){
                    map_keyProjectId_keyProject.put(ap.Key_Project_6__c, ap.Key_Project_6__r.Name);
                }
            }
            
            map<Id, list<Attachment>> map_accPlanId_attachments = new map<Id, list<Attachment>>();//Store all attachments for account plan record
            for(Attachment att : [SELECT Id, 
                                         Body, 
                                         BodyLength, 
                                         ContentType, 
                                         IsDeleted, 
                                         Description, 
                                         Name, 
                                         ParentId, 
                                         IsPrivate, 
                                         ConnectionReceivedId, 
                                         ConnectionSentId 
                                  FROM Attachment
                                  WHERE ParentId IN :map_accPlanId_accPlan.keyset()]){
                list<Attachment> list_atts = new list<Attachment>();
                if(map_accPlanId_attachments.containsKey(att.ParentId)){
                    list_atts = map_accPlanId_attachments.get(att.ParentId);
                }
                list_atts.add(att);
                map_accPlanId_attachments.put(att.ParentId, list_atts);
            }
            
            map<Id, list<Note>> map_accPlanId_notes = new map<Id, list<Note>>();//Store all notes for account plan record
            for(Note note : [SELECT Body, 
                                    Id, 
                                    ParentId, 
                                    IsPrivate, 
                                    Title 
                             FROM Note
                             WHERE ParentId IN :map_accPlanId_accPlan.keyset()]){
                list<Note> list_notes = new list<Note>();
                if(map_accPlanId_notes.containsKey(note.ParentId)){
                    list_notes = map_accPlanId_notes.get(note.ParentId);
                }
                list_notes.add(note);
                map_accPlanId_notes.put(note.ParentId, list_notes);
            }
            
            map<Id, Account_Plan_Attachment__c> map_attachmentId_apAttachment = new map<Id, Account_Plan_Attachment__c>();//Store all notes for account plan record
            for(Account_Plan_Attachment__c apa : [SELECT Account_Plan__c, 
                                                         Name, 
                                                         AttachmentId__c, 
                                                         Author__c, 
                                                         Content_Type__c, 
                                                         Description__c, 
                                                         ConnectionReceivedId, 
                                                         Id, 
                                                         Send_Attachment_to_Executive_Dashboard__c, 
                                                         ConnectionSentId, 
                                                         Title__c, 
                                                         Type__c,
                                                         CurrencyIsoCode 
                                                  FROM Account_Plan_Attachment__c
                                                  WHERE Account_Plan__c IN :map_accPlanId_accPlan.keyset() 
                                                  AND Send_Attachment_to_Executive_Dashboard__c = true]){//2012-10-24 added by Yuanyuan Zhang only attachments, which Send To Executive Dashboard true is, will be copy to a customer profile record
                map_attachmentId_apAttachment.put(apa.AttachmentId__c, apa);
            }
            
            map<Id, TEACstmrProfile__A_Customer_Profile__c> map_key_ACustomerProfile = new map<Id, TEACstmrProfile__A_Customer_Profile__c>();
            //map<Id, list<Attachment>> map_key_attachments = new map<Id, list<Attachment>>();
            //map<Id, list<Note>> map_key_notes = new map<Id, list<Note>>();
            
            list<TEACstmrProfile__A_Customer_Profile__c> list_aCustomer2Upsert = new list<TEACstmrProfile__A_Customer_Profile__c>();
            map<Id, TEACstmrProfile__A_Customer_Profile__c> map_accPlanId_aCustomerProfile = new map<Id, TEACstmrProfile__A_Customer_Profile__c>();
            set<Id> set_acusId = new set<Id>();           
            for(TEACstmrProfile__A_Customer_Profile__c acp : [SELECT Name, TEACstmrProfile__Account_Definition__c, TEACstmrProfile__Account_Objective_1__c, 
                                            TEACstmrProfile__Account_Objective_2__c, TEACstmrProfile__Account_Objective_3__c, TEACstmrProfile__Account_Objective_4__c, 
                                            TEACstmrProfile__Account_Objective_5__c, TEACstmrProfile__Approval_Status__c, TEACstmrProfile__BU_Customer_Plan__c, 
                                            TEACstmrProfile__BU_Editor__c, TEACstmrProfile__BU_Revenue_CY_Forecast_M__c, TEACstmrProfile__BU_Revenue_Fcst_Plan_Yr_M__c, 
                                            TEACstmrProfile__BU_Revenue_Fcst_Plan_Yr_1_M__c, TEACstmrProfile__BU_Revenue_Fcst_Plan_Yr_4_M__c, 
                                            TEACstmrProfile__BU_Revenue_Pct_Change_Plan_Yr_1__c, TEACstmrProfile__BU_Revenue_Pct_Change_Plan_Yr_4__c, 
                                            TEACstmrProfile__BU_Revenue_Prior_Yr_Actual_M__c, TEACstmrProfile__BU_Revenue_YTD_Actual_M__c, 
                                            TEACstmrProfile__BU_Revenue_Pct_Change_Plan_Yr__c, TEACstmrProfile__Breakthrough_Pgm_1_Comments__c, 
                                            TEACstmrProfile__Breakthrough_Pgm_1_Status__c, TEACstmrProfile__Breakthrough_Pgm_2_Comments__c, 
                                            TEACstmrProfile__Breakthrough_Pgm_2_Status__c, TEACstmrProfile__Breakthrough_Pgm_3_Comments__c, 
                                            TEACstmrProfile__Breakthrough_Pgm_3_Status__c, TEACstmrProfile__Breakthrough_Pgm_4_Comments__c, 
                                            TEACstmrProfile__Breakthrough_Pgm_4_Status__c, TEACstmrProfile__Breakthrough_Program_1__c, 
                                            TEACstmrProfile__Breakthrough_Program_2__c, TEACstmrProfile__Breakthrough_Program_3__c, 
                                            TEACstmrProfile__Breakthrough_Program_4__c, TEACstmrProfile__Business_Unit__c, TEACstmrProfile__Category1_Name__c, 
                                            TEACstmrProfile__Category1_Rev_Pct_Chg_Plan_Yr_1__c, TEACstmrProfile__Category1_Rev_Pct_Chg_Plan_Yr_2__c, 
                                            TEACstmrProfile__Category1_Revenue_M_Plan_Yr_1__c, TEACstmrProfile__Category1_Revenue_M_Plan_Yr_2__c, 
                                            TEACstmrProfile__Category1_Revenue_M_Plan_Yr_3__c, TEACstmrProfile__Category2_Name__c, 
                                            TEACstmrProfile__Category2_Rev_Pct_Chg_Plan_Yr_1__c, TEACstmrProfile__Category2_Rev_Pct_Chg_Plan_Yr_2__c, 
                                            TEACstmrProfile__Category2_Revenue_M_Plan_Yr_1__c, TEACstmrProfile__Category2_Revenue_M_Plan_Yr_2__c, 
                                            TEACstmrProfile__Category2_Revenue_M_Plan_Yr_3__c, TEACstmrProfile__Category3_Name__c, 
                                            TEACstmrProfile__Category3_Rev_Pct_Chg_Plan_Yr_1__c, TEACstmrProfile__Category3_Rev_Pct_Chg_Plan_Yr_2__c, 
                                            TEACstmrProfile__Category3_Revenue_M_Plan_Yr_1__c, TEACstmrProfile__Category3_Revenue_M_Plan_Yr_2__c, 
                                            TEACstmrProfile__Category3_Revenue_M_Plan_Yr_3__c, TEACstmrProfile__Competitor_1__c, TEACstmrProfile__Competitor_1_Comments__c, 
                                            TEACstmrProfile__Competitor_1_MS_Trend__c, TEACstmrProfile__Competitor_1_Market_Share__c, TEACstmrProfile__Competitor_2__c, 
                                            TEACstmrProfile__Competitor_2_Comments__c, TEACstmrProfile__Competitor_2_MS_Trend__c, TEACstmrProfile__Competitor_2_Market_Share__c, 
                                            TEACstmrProfile__Competitor_3__c, TEACstmrProfile__Competitor_3_Comments__c, TEACstmrProfile__Competitor_3_MS_Trend__c, 
                                            TEACstmrProfile__Competitor_3_Market_Share__c, TEACstmrProfile__Competitor_4__c, TEACstmrProfile__Competitor_4_Comments__c, 
                                            TEACstmrProfile__Competitor_4_MS_Trend__c, TEACstmrProfile__Competitor_4_Market_Share__c, TEACstmrProfile__Competitor_5__c, 
                                            TEACstmrProfile__Competitor_5_Comments__c, TEACstmrProfile__Competitor_5_MS_Trend__c, TEACstmrProfile__Competitor_5_Market_Share__c, 
                                            TEACstmrProfile__Competitor_6__c, TEACstmrProfile__Competitor_6_Comments__c, TEACstmrProfile__Competitor_6_MS_Trend__c, 
                                            TEACstmrProfile__Competitor_6_Market_Share__c, CreatedById, CreatedDate, CurrencyIsoCode, TEACstmrProfile__Customer_Scorecard__c, 
                                            TEACstmrProfile__Customer_Scorecard_Comments__c, TEACstmrProfile__Customer_Type__c, IsDeleted, 
                                            TEACstmrProfile__Engineering_Relationship__c, TEACstmrProfile__Engineering_Relationship_Comments__c, 
                                            TEACstmrProfile__Executive_Relationship__c, TEACstmrProfile__Executive_Relationship_Comments__c, TEACstmrProfile__GAM_Code__c, 
                                            TEACstmrProfile__Gross_Margin_Pct_Plan_Yr__c, TEACstmrProfile__Gross_Margin_Pct_Plan_Yr_1__c, 
                                            TEACstmrProfile__Gross_Margin_Pct_Plan_Yr_4__c, TEACstmrProfile__Gross_Margin_Pct_Prior_Yr__c, TEACstmrProfile__Hidden_Do_Not_Use__c, 
                                            TEACstmrProfile__Industry_Segment__c, TEACstmrProfile__Integration_BU_Org_Key__c, TEACstmrProfile__Integration_Last_Update_Date__c, 
                                            TEACstmrProfile__Is_Updated_Since_Last_Integration__c, TEACstmrProfile__Key_Product_1__c, TEACstmrProfile__Key_Product_1_Outlook__c, 
                                            TEACstmrProfile__Key_Product_1_Pct__c, TEACstmrProfile__Key_Product_2__c, TEACstmrProfile__Key_Product_2_Outlook__c, 
                                            TEACstmrProfile__Key_Product_2_Pct__c, TEACstmrProfile__Key_Product_3__c, TEACstmrProfile__Key_Product_3_Outlook__c, 
                                            TEACstmrProfile__Key_Product_3_Pct__c, TEACstmrProfile__Key_Product_4__c, TEACstmrProfile__Key_Product_4_Outlook__c, 
                                            TEACstmrProfile__Key_Product_4_Pct__c, TEACstmrProfile__Key_Product_5__c, TEACstmrProfile__Key_Product_5_Outlook__c, 
                                            TEACstmrProfile__Key_Product_5_Pct__c, TEACstmrProfile__Key_Product_6__c, TEACstmrProfile__Key_Product_6_Outlook__c, 
                                            TEACstmrProfile__Key_Product_6_Pct__c, TEACstmrProfile__Key_Product_Percent_Title__c, TEACstmrProfile__Key_Project_1__c, 
                                            TEACstmrProfile__Key_Project_1_Start_Date__c, TEACstmrProfile__Key_Project_1_Value_M__c, TEACstmrProfile__Key_Project_2__c, 
                                            TEACstmrProfile__Key_Project_2_Start_Date__c, TEACstmrProfile__Key_Project_2_Value_M__c, TEACstmrProfile__Key_Project_3__c, 
                                            TEACstmrProfile__Key_Project_3_Start_Date__c, TEACstmrProfile__Key_Project_3_Value_M__c, TEACstmrProfile__Key_Project_4__c, 
                                            TEACstmrProfile__Key_Project_4_Start_Date__c, TEACstmrProfile__Key_Project_4_Value_M__c, TEACstmrProfile__Key_Project_5__c, 
                                            TEACstmrProfile__Key_Project_5_Start_Date__c, TEACstmrProfile__Key_Project_5_Value_M__c, TEACstmrProfile__Key_Project_6__c, 
                                            TEACstmrProfile__Key_Project_6_Start_Date__c, TEACstmrProfile__Key_Project_6_Value_M__c, LastModifiedById, LastModifiedDate, 
                                            TEACstmrProfile__Manager__c, TEACstmrProfile__Market_Share_Plan_Yr__c, TEACstmrProfile__Market_Share_Plan_Yr_1__c, 
                                            TEACstmrProfile__Market_Share_Plan_Yr_4__c, TEACstmrProfile__Market_Share_Prior_Yr__c, TEACstmrProfile__Monthly_Update__c, 
                                            TEACstmrProfile__Monthly_Update_Last_Updated__c, TEACstmrProfile__Monthly_Update_Last_Updated_By__c, TEACstmrProfile__Obstacle_1__c, 
                                            TEACstmrProfile__Obstacle_2__c, TEACstmrProfile__Obstacle_3__c, TEACstmrProfile__Obstacle_4__c, TEACstmrProfile__Obstacle_5__c, OwnerId, 
                                            TEACstmrProfile__Plan_Year__c, TEACstmrProfile__Purchasing_Relationship__c, TEACstmrProfile__Purchasing_Relationship_Comments__c, 
                                            ConnectionReceivedId, TEACstmrProfile__Recent_Big_Win_1__c, TEACstmrProfile__Recent_Big_Win_1_Comments__c, 
                                            TEACstmrProfile__Recent_Big_Win_1_Date_Won__c, TEACstmrProfile__Recent_Big_Win_1_Value_M__c, TEACstmrProfile__Recent_Big_Win_2__c, 
                                            TEACstmrProfile__Recent_Big_Win_2_Comments__c, TEACstmrProfile__Recent_Big_Win_2_Date_Won__c, 
                                            TEACstmrProfile__Recent_Big_Win_2_Value_M__c, TEACstmrProfile__Recent_Big_Win_3__c, TEACstmrProfile__Recent_Big_Win_3_Comments__c, 
                                            TEACstmrProfile__Recent_Big_Win_3_Date_Won__c, TEACstmrProfile__Recent_Big_Win_3_Value_M__c, TEACstmrProfile__Recent_Big_Win_4__c, 
                                            TEACstmrProfile__Recent_Big_Win_4_Comments__c, TEACstmrProfile__Recent_Big_Win_4_Date_Won__c, 
                                            TEACstmrProfile__Recent_Big_Win_4_Value_M__c, TEACstmrProfile__Recent_Loss_1__c, TEACstmrProfile__Recent_Loss_1_Comments__c, 
                                            TEACstmrProfile__Recent_Loss_1_Date__c, TEACstmrProfile__Recent_Loss_1_Value_M__c, TEACstmrProfile__Recent_Loss_2__c, 
                                            TEACstmrProfile__Recent_Loss_2_Comments__c, TEACstmrProfile__Recent_Loss_2_Date__c, TEACstmrProfile__Recent_Loss_2_Value_M__c, 
                                            TEACstmrProfile__Recent_Loss_3__c, TEACstmrProfile__Recent_Loss_3_Comments__c, TEACstmrProfile__Recent_Loss_3_Date__c, 
                                            TEACstmrProfile__Recent_Loss_3_Value_M__c, TEACstmrProfile__Recent_Loss_4__c, TEACstmrProfile__Recent_Loss_4_Comments__c, 
                                            TEACstmrProfile__Recent_Loss_4_Date__c, TEACstmrProfile__Recent_Loss_4_Value_M__c, Id, TEACstmrProfile__Revenue_Section_Last_Updated__c, 
                                            TEACstmrProfile__Revenue_Section_Last_Updated_By__c, TEACstmrProfile__Revenue_TAM_SAM__c, 
                                            TEACstmrProfile__Sales_Breakdown_1_Description__c, TEACstmrProfile__Sales_Breakdown_1_Percent__c, 
                                            TEACstmrProfile__Sales_Breakdown_2_Description__c, TEACstmrProfile__Sales_Breakdown_2_Percent__c, 
                                            TEACstmrProfile__Sales_Breakdown_3_Description__c, TEACstmrProfile__Sales_Breakdown_3_Percent__c, 
                                            TEACstmrProfile__Sales_Breakdown_4_Description__c, TEACstmrProfile__Sales_Breakdown_4_Percent__c, 
                                            TEACstmrProfile__Sales_Breakdown_5_Description__c, TEACstmrProfile__Sales_Breakdown_5_Percent__c, 
                                            ConnectionSentId, TEACstmrProfile__Strategic_Initiative_1__c, TEACstmrProfile__Strategic_Initiative_1_Status__c, 
                                            TEACstmrProfile__Strategic_Initiative_1_Target__c, TEACstmrProfile__Strategic_Initiative_10__c, 
                                            TEACstmrProfile__Strategic_Initiative_10_Status__c, TEACstmrProfile__Strategic_Initiative_10_Target__c, 
                                            TEACstmrProfile__Strategic_Initiative_2__c, TEACstmrProfile__Strategic_Initiative_2_Status__c, 
                                            TEACstmrProfile__Strategic_Initiative_2_Target__c, TEACstmrProfile__Strategic_Initiative_3__c, 
                                            TEACstmrProfile__Strategic_Initiative_3_Status__c, TEACstmrProfile__Strategic_Initiative_3_Target__c, 
                                            TEACstmrProfile__Strategic_Initiative_4__c, TEACstmrProfile__Strategic_Initiative_4_Status__c, 
                                            TEACstmrProfile__Strategic_Initiative_4_Target__c, TEACstmrProfile__Strategic_Initiative_5__c, 
                                            TEACstmrProfile__Strategic_Initiative_5_Status__c, TEACstmrProfile__Strategic_Initiative_5_Target__c, 
                                            TEACstmrProfile__Strategic_Initiative_6__c, TEACstmrProfile__Strategic_Initiative_6_Status__c, 
                                            TEACstmrProfile__Strategic_Initiative_6_Target__c, TEACstmrProfile__Strategic_Initiative_7__c, 
                                            TEACstmrProfile__Strategic_Initiative_7_Status__c, TEACstmrProfile__Strategic_Initiative_7_Target__c, 
                                            TEACstmrProfile__Strategic_Initiative_8__c, TEACstmrProfile__Strategic_Initiative_8_Status__c, 
                                            TEACstmrProfile__Strategic_Initiative_8_Target__c, TEACstmrProfile__Strategic_Initiative_9__c, 
                                            TEACstmrProfile__Strategic_Initiative_9_Status__c, TEACstmrProfile__Strategic_Initiative_9_Target__c, 
                                            SystemModstamp, TEACstmrProfile__TAM_Pct_Change_Plan_Yr__c, TEACstmrProfile__TAM_Pct_Change_Plan_Yr_1__c, 
                                            TEACstmrProfile__TAM_Pct_Change_Plan_Yr_4__c, TEACstmrProfile__TAM_Plan_Year_M__c, TEACstmrProfile__TAM_Plan_Yr_1_M__c, 
                                            TEACstmrProfile__TAM_Plan_Yr_4_M__c, TEACstmrProfile__TAM_Prior_Yr_M__c, TEACstmrProfile__TE_Performance_Status__c, 
                                            TEACstmrProfile__TE_Revenue_CY_Forecast_M__c, TEACstmrProfile__TE_Revenue_Fcst_Plan_Yr_M__c, 
                                            TEACstmrProfile__TE_Revenue_Fcst_Plan_Yr_1_M__c, TEACstmrProfile__TE_Revenue_Fcst_Plan_Yr_4_M__c, 
                                            TEACstmrProfile__TE_Revenue_Pct_Change_Plan_Yr__c, TEACstmrProfile__TE_Revenue_Pct_Change_Plan_Yr_1__c, 
                                            TEACstmrProfile__TE_Revenue_Pct_Change_Plan_Yr_4__c, TEACstmrProfile__TE_Revenue_Prior_Yr_Actual_M__c, 
                                            TEACstmrProfile__TE_Revenue_YTD_Actual_M__c, TEACstmrProfile__Sales_Figures_Makeup__c, TEACstmrProfile__Total_Rev_Pct_Chg_Plan_Yr_1__c, 
                                            TEACstmrProfile__Total_Rev_Pct_Chg_Plan_Yr_2__c, TEACstmrProfile__Total_Revenue_M_Plan_Yr_1__c, 
                                            TEACstmrProfile__Total_Revenue_M_Plan_Yr_2__c, TEACstmrProfile__Total_Revenue_M_Plan_Yr_3__c, 
                                            TEACstmrProfile__Unique_A_Customer_Year__c, TEACstmrProfile__Worldwide_Account__c,Account_Plan__c
                                            FROM TEACstmrProfile__A_Customer_Profile__c
                                            WHERE Account_Plan__c IN :map_accPlanId_accPlan.keySet()]){
                
                map_accPlanId_aCustomerProfile.put(acp.Account_Plan__c, acp);
                set_acusId.add(acp.Id);
            }
            
            if(!set_acusId.isEmpty()){
                list<sObject> list_old2Del = new list<sObject>();
                
                for(Attachment att : [SELECT Id, 
                                             Body, 
                                             BodyLength, 
                                             ContentType, 
                                             IsDeleted, 
                                             Description, 
                                             Name, 
                                             ParentId, 
                                             IsPrivate, 
                                             ConnectionReceivedId, 
                                             ConnectionSentId 
                                      FROM Attachment
                                      WHERE ParentId IN :set_acusId]){//AND Name != 'VoiceOverview.wav'
                    list_old2Del.add(att);
                }   
                          
                for(Note note : [SELECT Body, 
                                        Id, 
                                        ParentId, 
                                        IsPrivate, 
                                        Title 
                                 FROM Note
                                 WHERE ParentId IN :set_acusId]){
                    list_old2Del.add(note);
                }               
                if(list_old2Del.size() != 0){
                    delete list_old2Del;
                }
            }                        
            
            list<TEACstmrProfile__A_Customer_Profile__c> list_acp2setOrgKey = new list<TEACstmrProfile__A_Customer_Profile__c>();
            //added by xia 2013-04-11  -- start
            set<String> set_accountObjective = new set<String>();
            map<Integer,String> map_startegicInitiative = new map<Integer,String>();
            //added by xia 2013-04-11  -- end
            for(Account_Plan__c ap : map_accPlanId_accPlan.values()){
                TEACstmrProfile__A_Customer_Profile__c aCustomerProfile;
                if(map_accPlanId_aCustomerProfile.containsKey(ap.Id)){
                    aCustomerProfile = map_accPlanId_aCustomerProfile.get(ap.Id);
                }
                else{
                    aCustomerProfile = new TEACstmrProfile__A_Customer_Profile__c();
                    aCustomerProfile.Account_Plan__c = ap.Id;
                }
                
                aCustomerProfile.TEACstmrProfile__Account_Definition__c = ap.Account_Definition__c;
                
                aCustomerProfile.TEACstmrProfile__Account_Objective_1__c = ap.Account_Objective_1__c;
                /*commented by xia 2013-04-11
                aCustomerProfile.TEACstmrProfile__Account_Objective_2__c = ap.Account_Objective_2__c;
                aCustomerProfile.TEACstmrProfile__Account_Objective_3__c = ap.Account_Objective_3__c;
                aCustomerProfile.TEACstmrProfile__Account_Objective_4__c = ap.Account_Objective_4__c;
                aCustomerProfile.TEACstmrProfile__Account_Objective_5__c = ap.Account_Objective_5__c;*/
                //added by xia 2013-04-11  -- start
                //aCustomerProfile.TEACstmrProfile__Account_Objective_1__c = null;
                aCustomerProfile.TEACstmrProfile__Account_Objective_2__c = null;
                aCustomerProfile.TEACstmrProfile__Account_Objective_3__c = null;
                aCustomerProfile.TEACstmrProfile__Account_Objective_4__c = null;
                aCustomerProfile.TEACstmrProfile__Account_Objective_5__c = null;
                Sobject so = (Sobject)ap;
                Sobject acp = (Sobject)aCustomerProfile;
                for(integer i= 2; i <= 20; i++ ){
                    String aoField = 'Account_Objective_' + String.valueOf(i) + '__c';
                    String aoCheckField = 'Account_Objective_Active_' + String.valueOf(i) + '__c';
                    String siField = 'Strategic_Initiative_' + String.valueOf(i) + '__c';
                    String siCheckField = 'Strategic_Initiative_Active_' + String.valueOf(i) + '__c';
                    if((boolean)so.get(aoCheckField) && (string)so.get(aoField) != null) set_accountObjective.add((string)so.get(aoField)); 
                    if((boolean)so.get(siCheckField) && (string)so.get(siField) != null) map_startegicInitiative.put(i,(string)so.get(siField));    
                    
                }
                integer j=2;
                for(String s: set_accountObjective){
                    String f = 'TEACstmrProfile__Account_Objective_' + String.valueOf(j) + '__c';
                    acp.put(f,s);
                    j++;            
                }
                
                //added by xia 2013-04-11  -- end
                
                aCustomerProfile.TEACstmrProfile__Approval_Status__c = ap.Approval_Status__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Pgm_1_Comments__c = ap.Breakthrough_Pgm_1_Comments__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Pgm_1_Status__c = ap.Breakthrough_Pgm_1_Status__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Program_1__c = ap.Breakthrough_Program_1__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Pgm_2_Comments__c = ap.Breakthrough_Pgm_2_Comments__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Pgm_2_Status__c = ap.Breakthrough_Pgm_2_Status__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Program_2__c = ap.Breakthrough_Program_2__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Pgm_3_Comments__c = ap.Breakthrough_Pgm_3_Comments__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Pgm_3_Status__c = ap.Breakthrough_Pgm_3_Status__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Program_3__c = ap.Breakthrough_Program_3__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Pgm_4_Comments__c = ap.Breakthrough_Pgm_4_Comments__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Pgm_4_Status__c = ap.Breakthrough_Pgm_4_Status__c;
                aCustomerProfile.TEACstmrProfile__Breakthrough_Program_4__c = ap.Breakthrough_Program_4__c;
                //aCustomerProfile.BU_Customer_Plan__c
                //aCustomerProfile.BU_Editor__c
                //if(ap.BU_Revenue_CY_Manual_Forecast_M__c == null) aCustomerProfile.TEACstmrProfile__BU_Revenue_CY_Forecast_M__c = 0;
                //else aCustomerProfile.TEACstmrProfile__BU_Revenue_CY_Forecast_M__c = ap.BU_Revenue_CY_Manual_Forecast_M__c; //ap.BU_Revenue_CY_Forecast_M__c;
                aCustomerProfile.TEACstmrProfile__BU_Revenue_CY_Forecast_M__c = ap.BU_Revenue_CY_Forecast_M__c;//added by min
                aCustomerProfile.TEACstmrProfile__BU_Revenue_Fcst_Plan_Yr_1_M__c = ap.BU_Revenue_Fcst_Plan_Yr_1_M__c;
                aCustomerProfile.TEACstmrProfile__BU_Revenue_Fcst_Plan_Yr_4_M__c = ap.BU_Revenue_Fcst_Plan_Yr_4_M__c;
                aCustomerProfile.TEACstmrProfile__BU_Revenue_Fcst_Plan_Yr_M__c = ap.BU_Revenue_Fcst_Plan_Yr_M__c;
                //aCustomerProfile.BU_Revenue_Pct_Change_Plan_Yr_1__c = ap.BU_Revenue_Pct_Change_Plan_Yr_1__c;
                //aCustomerProfile.BU_Revenue_Pct_Change_Plan_Yr_4__c = ap.BU_Revenue_Pct_Change_Plan_Yr_4__c;
                //aCustomerProfile.BU_Revenue_Pct_Change_Plan_Yr__c = ap.BU_Revenue_Pct_Change_Plan_Yr__c;
                aCustomerProfile.TEACstmrProfile__BU_Revenue_Prior_Yr_Actual_M__c = ap.BU_Revenue_Prior_Yr_Actual_M__c;
                aCustomerProfile.TEACstmrProfile__BU_Revenue_YTD_Actual_M__c = ap.BU_Revenue_YTD_Actual_M__c;
                if(ap.Business_Unit__c == 'Solar' ||
                   ap.Business_Unit__c == 'A&C' ||
                   ap.Business_Unit__c == 'IB' ||
                   ap.Business_Unit__c == 'Rail'){
                    aCustomerProfile.TEACstmrProfile__Business_Unit__c = 'Industrial';
                }
                else if(ap.Business_Unit__c == 'DataComm'){
                    aCustomerProfile.TEACstmrProfile__Business_Unit__c = 'Data Communications';
                }
                else{
                    aCustomerProfile.TEACstmrProfile__Business_Unit__c = ap.Business_Unit__c;//value others?
                }
                
                aCustomerProfile.TEACstmrProfile__Category1_Name__c = ap.Category1_Name__c;
                //aCustomerProfile.Category1_Rev_Pct_Chg_Plan_Yr_1__c = ap.Category1_Rev_Pct_Chg_Plan_Yr_1__c;
                //aCustomerProfile.Category1_Rev_Pct_Chg_Plan_Yr_2__c = ap.Category1_Rev_Pct_Chg_Plan_Yr_2__c;
                aCustomerProfile.TEACstmrProfile__Category1_Revenue_M_Plan_Yr_1__c = ap.Category1_Revenue_M_Plan_Yr_1__c;
                aCustomerProfile.TEACstmrProfile__Category1_Revenue_M_Plan_Yr_2__c = ap.Category1_Revenue_M_Plan_Yr_2__c;
                aCustomerProfile.TEACstmrProfile__Category1_Revenue_M_Plan_Yr_3__c = ap.Category1_Revenue_M_Plan_Yr_3__c;
                aCustomerProfile.TEACstmrProfile__Category2_Name__c = ap.Category2_Name__c;
                //aCustomerProfile.Category2_Rev_Pct_Chg_Plan_Yr_1__c = ap.Category2_Rev_Pct_Chg_Plan_Yr_1__c;
                //aCustomerProfile.Category2_Rev_Pct_Chg_Plan_Yr_2__c = ap.Category2_Rev_Pct_Chg_Plan_Yr_2__c;
                aCustomerProfile.TEACstmrProfile__Category2_Revenue_M_Plan_Yr_1__c = ap.Category2_Revenue_M_Plan_Yr_1__c;
                aCustomerProfile.TEACstmrProfile__Category2_Revenue_M_Plan_Yr_2__c = ap.Category2_Revenue_M_Plan_Yr_2__c;
                aCustomerProfile.TEACstmrProfile__Category2_Revenue_M_Plan_Yr_3__c = ap.Category2_Revenue_M_Plan_Yr_3__c;
                aCustomerProfile.TEACstmrProfile__Category3_Name__c = ap.Category3_Name__c;
                //aCustomerProfile.Category3_Rev_Pct_Chg_Plan_Yr_1__c = ap.Category3_Rev_Pct_Chg_Plan_Yr_1__c;
                //aCustomerProfile.Category3_Rev_Pct_Chg_Plan_Yr_2__c = ap.Category3_Rev_Pct_Chg_Plan_Yr_2__c;
                aCustomerProfile.TEACstmrProfile__Category3_Revenue_M_Plan_Yr_1__c = ap.Category3_Revenue_M_Plan_Yr_1__c;
                aCustomerProfile.TEACstmrProfile__Category3_Revenue_M_Plan_Yr_2__c = ap.Category3_Revenue_M_Plan_Yr_2__c;
                aCustomerProfile.TEACstmrProfile__Category3_Revenue_M_Plan_Yr_3__c = ap.Category3_Revenue_M_Plan_Yr_3__c;
                aCustomerProfile.TEACstmrProfile__Competitor_1__c = ap.Competitor_1__c;
                aCustomerProfile.TEACstmrProfile__Competitor_1_Comments__c = ap.Competitor_1_Comments__c;
                aCustomerProfile.TEACstmrProfile__Competitor_1_Market_Share__c = ap.Competitor_1_Market_Share__c;
                aCustomerProfile.TEACstmrProfile__Competitor_1_MS_Trend__c = ap.Competitor_1_MS_Trend__c;
                aCustomerProfile.TEACstmrProfile__Competitor_2__c = ap.Competitor_2__c;
                aCustomerProfile.TEACstmrProfile__Competitor_2_Comments__c = ap.Competitor_2_Comments__c;
                aCustomerProfile.TEACstmrProfile__Competitor_2_Market_Share__c = ap.Competitor_2_Market_Share__c;
                aCustomerProfile.TEACstmrProfile__Competitor_2_MS_Trend__c = ap.Competitor_2_MS_Trend__c;
                aCustomerProfile.TEACstmrProfile__Competitor_3__c = ap.Competitor_3__c;
                aCustomerProfile.TEACstmrProfile__Competitor_3_Comments__c = ap.Competitor_3_Comments__c;
                aCustomerProfile.TEACstmrProfile__Competitor_3_Market_Share__c = ap.Competitor_3_Market_Share__c;
                aCustomerProfile.TEACstmrProfile__Competitor_3_MS_Trend__c = ap.Competitor_3_MS_Trend__c;
                aCustomerProfile.TEACstmrProfile__Competitor_4__c = ap.Competitor_4__c;
                aCustomerProfile.TEACstmrProfile__Competitor_4_Comments__c = ap.Competitor_4_Comments__c;
                aCustomerProfile.TEACstmrProfile__Competitor_4_Market_Share__c = ap.Competitor_4_Market_Share__c;
                aCustomerProfile.TEACstmrProfile__Competitor_4_MS_Trend__c = ap.Competitor_4_MS_Trend__c;
                aCustomerProfile.TEACstmrProfile__Competitor_5__c = ap.Competitor_5__c;
                aCustomerProfile.TEACstmrProfile__Competitor_5_Comments__c = ap.Competitor_5_Comments__c;
                aCustomerProfile.TEACstmrProfile__Competitor_5_Market_Share__c = ap.Competitor_5_Market_Share__c;
                aCustomerProfile.TEACstmrProfile__Competitor_5_MS_Trend__c = ap.Competitor_5_MS_Trend__c;
                aCustomerProfile.TEACstmrProfile__Competitor_6__c = ap.Competitor_6__c;
                aCustomerProfile.TEACstmrProfile__Competitor_6_Comments__c = ap.Competitor_6_Comments__c;
                aCustomerProfile.TEACstmrProfile__Competitor_6_Market_Share__c = ap.Competitor_6_Market_Share__c;
                aCustomerProfile.TEACstmrProfile__Competitor_6_MS_Trend__c = ap.Competitor_6_MS_Trend__c;
                //aCustomerProfile.ConnectionReceivedId = ap.ConnectionReceivedId;
                //aCustomerProfile.ConnectionSentId
                aCustomerProfile.CurrencyIsoCode = ap.CurrencyIsoCode;
                aCustomerProfile.TEACstmrProfile__Customer_Scorecard__c = ap.Customer_Scorecard__c;
                aCustomerProfile.TEACstmrProfile__Customer_Scorecard_Comments__c = ap.Customer_Scorecard_Comments__c;
                aCustomerProfile.TEACstmrProfile__Customer_Type__c = ap.Customer_Type__c + ' Customer';
                // = ap.Definition__c;
                aCustomerProfile.TEACstmrProfile__Engineering_Relationship__c = ap.Engineering_Relationship__c;
                aCustomerProfile.TEACstmrProfile__Engineering_Relationship_Comments__c = ap.Engineering_Relationship_Comments__c;
                aCustomerProfile.TEACstmrProfile__Executive_Relationship__c = ap.Executive_Relationship__c;
                aCustomerProfile.TEACstmrProfile__Executive_Relationship_Comments__c = ap.Executive_Relationship_Comments__c;
                aCustomerProfile.TEACstmrProfile__GAM_Code__c = ap.GAM_Code__c;
                aCustomerProfile.TEACstmrProfile__Gross_Margin_Pct_Plan_Yr_1__c = ap.Gross_Margin_Pct_Plan_Yr_1__c;
                aCustomerProfile.TEACstmrProfile__Gross_Margin_Pct_Plan_Yr_4__c = ap.Gross_Margin_Pct_Plan_Yr_4__c;
                aCustomerProfile.TEACstmrProfile__Gross_Margin_Pct_Plan_Yr__c = ap.Gross_Margin_Pct_Plan_Yr__c;
                aCustomerProfile.TEACstmrProfile__Gross_Margin_Pct_Prior_Yr__c = ap.Gross_Margin_Pct_Prior_Yr__c;
                aCustomerProfile.TEACstmrProfile__Hidden_Do_Not_Use__c = ap.Hidden_Do_Not_Use__c;
                aCustomerProfile.TEACstmrProfile__Industry_Segment__c = ap.Industry_Segment__c;
                
                aCustomerProfile.TEACstmrProfile__Key_Product_1__c = ap.Key_Product_1__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_1_Outlook__c = ap.Key_Product_1_Outlook__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_1_Pct__c = ap.Key_Product_1_Pct__c;
                
                aCustomerProfile.TEACstmrProfile__Key_Product_2__c = ap.Key_Product_2__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_2_Outlook__c = ap.Key_Product_2_Outlook__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_2_Pct__c = ap.Key_Product_2_Pct__c;
                
                aCustomerProfile.TEACstmrProfile__Key_Product_3__c = ap.Key_Product_3__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_3_Outlook__c = ap.Key_Product_3_Outlook__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_3_Pct__c = ap.Key_Product_3_Pct__c;
                
                aCustomerProfile.TEACstmrProfile__Key_Product_4__c = ap.Key_Product_4__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_4_Outlook__c = ap.Key_Product_4_Outlook__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_4_Pct__c = ap.Key_Product_4_Pct__c;
                
                aCustomerProfile.TEACstmrProfile__Key_Product_5__c = ap.Key_Product_5__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_5_Outlook__c = ap.Key_Product_5_Outlook__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_5_Pct__c = ap.Key_Product_5_Pct__c;
                
                aCustomerProfile.TEACstmrProfile__Key_Product_6__c = ap.Key_Product_6__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_6_Outlook__c = ap.Key_Product_6_Outlook__c;
                aCustomerProfile.TEACstmrProfile__Key_Product_6_Pct__c = ap.Key_Product_6_Pct__c;
                
                aCustomerProfile.TEACstmrProfile__Key_Product_Percent_Title__c = ap.Key_Product_Percent_Title__c;
                               
                if(ap.Key_Project_1__c != null){
                    aCustomerProfile.TEACstmrProfile__Key_Project_1__c = map_keyProjectId_keyProject.get(ap.Key_Project_1__c);
                    aCustomerProfile.TEACstmrProfile__Key_Project_1_Start_Date__c = ap.Key_Project_1_Start_Date__c;
                    aCustomerProfile.TEACstmrProfile__Key_Project_1_Value_M__c = ap.Key_Project_1_Value_M__c;
                }
                if(ap.Key_Project_2__c != null){
                    aCustomerProfile.TEACstmrProfile__Key_Project_2__c = map_keyProjectId_keyProject.get(ap.Key_Project_2__c);
                    aCustomerProfile.TEACstmrProfile__Key_Project_2_Start_Date__c = ap.Key_Project_2_Start_Date__c;
                    aCustomerProfile.TEACstmrProfile__Key_Project_2_Value_M__c = ap.Key_Project_2_Value_M__c;
                }
                if(ap.Key_Project_3__c != null){
                    aCustomerProfile.TEACstmrProfile__Key_Project_3__c = map_keyProjectId_keyProject.get(ap.Key_Project_3__c);
                    aCustomerProfile.TEACstmrProfile__Key_Project_3_Start_Date__c = ap.Key_Project_3_Start_Date__c;
                    aCustomerProfile.TEACstmrProfile__Key_Project_3_Value_M__c = ap.Key_Project_3_Value_M__c;
                }
                if(ap.Key_Project_4__c != null){
                    aCustomerProfile.TEACstmrProfile__Key_Project_4__c = map_keyProjectId_keyProject.get(ap.Key_Project_4__c);
                    aCustomerProfile.TEACstmrProfile__Key_Project_4_Start_Date__c = ap.Key_Project_4_Start_Date__c;
                    aCustomerProfile.TEACstmrProfile__Key_Project_4_Value_M__c = ap.Key_Project_4_Value_M__c;
                }
                if(ap.Key_Project_5__c != null){
                    aCustomerProfile.TEACstmrProfile__Key_Project_5__c = map_keyProjectId_keyProject.get(ap.Key_Project_5__c);
                    aCustomerProfile.TEACstmrProfile__Key_Project_5_Start_Date__c = ap.Key_Project_5_Start_Date__c;
                    aCustomerProfile.TEACstmrProfile__Key_Project_5_Value_M__c = ap.Key_Project_5_Value_M__c;
                }
                if(ap.Key_Project_6__c != null){
                    aCustomerProfile.TEACstmrProfile__Key_Project_6__c = map_keyProjectId_keyProject.get(ap.Key_Project_6__c);
                    aCustomerProfile.TEACstmrProfile__Key_Project_6_Start_Date__c = ap.Key_Project_6_Start_Date__c;
                    aCustomerProfile.TEACstmrProfile__Key_Project_6_Value_M__c = ap.Key_Project_6_Value_M__c;
                }
                               
                //ap.Lost_Project_1__c, Lost_Project_2__c, Lost_Project_3__c, Lost_Project_4__c
                aCustomerProfile.TEACstmrProfile__Manager__c = ap.Manager__c;
                //aCustomerProfile.Market_Share_Plan_Yr_1__c = ap.Market_Share_Plan_Yr_1__c;
                //aCustomerProfile.Market_Share_Plan_Yr_4__c = ap.Market_Share_Plan_Yr_4__c;
                //aCustomerProfile.Market_Share_Plan_Yr__c = ap.Market_Share_Plan_Yr__c;
                //aCustomerProfile.Market_Share_Prior_Yr__c = ap.Market_Share_Prior_Yr__c;
                aCustomerProfile.TEACstmrProfile__Monthly_Update__c = ap.Monthly_Update__c;
                aCustomerProfile.TEACstmrProfile__Monthly_Update_Last_Updated__c = ap.Monthly_Update_Last_Updated__c;
                aCustomerProfile.TEACstmrProfile__Monthly_Update_Last_Updated_By__c = ap.Monthly_Update_Last_Updated_By__c;
                aCustomerProfile.Name = ap.Name;
                aCustomerProfile.TEACstmrProfile__Obstacle_1__c = ap.Obstacle_1__c;
                aCustomerProfile.TEACstmrProfile__Obstacle_2__c = ap.Obstacle_2__c;
                aCustomerProfile.TEACstmrProfile__Obstacle_3__c = ap.Obstacle_3__c;
                aCustomerProfile.TEACstmrProfile__Obstacle_4__c = ap.Obstacle_4__c;
                aCustomerProfile.TEACstmrProfile__Obstacle_5__c = ap.Obstacle_5__c;
                //aCustomerProfile.OwnerId
                aCustomerProfile.TEACstmrProfile__Plan_Year__c = ap.Plan_Year__c;
                aCustomerProfile.TEACstmrProfile__Purchasing_Relationship__c = ap.Purchasing_Relationship__c;
                aCustomerProfile.TEACstmrProfile__Purchasing_Relationship_Comments__c = ap.Purchasing_Relationship_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_1__c = ap.Recent_Big_Win_1__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_1_Comments__c = ap.Recent_Big_Win_1_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_1_Date_Won__c = ap.Recent_Big_Win_1_Date_Won__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_1_Value_M__c = ap.Recent_Big_Win_1_Value_M__c;
                
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_2__c = ap.Recent_Big_Win_2__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_2_Comments__c = ap.Recent_Big_Win_2_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_2_Date_Won__c = ap.Recent_Big_Win_2_Date_Won__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_2_Value_M__c = ap.Recent_Big_Win_2_Value_M__c;
                
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_3__c = ap.Recent_Big_Win_3__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_3_Comments__c = ap.Recent_Big_Win_3_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_3_Date_Won__c = ap.Recent_Big_Win_3_Date_Won__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_3_Value_M__c = ap.Recent_Big_Win_3_Value_M__c;
                
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_4__c = ap.Recent_Big_Win_4__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_4_Comments__c = ap.Recent_Big_Win_4_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_4_Date_Won__c = ap.Recent_Big_Win_4_Date_Won__c;
                aCustomerProfile.TEACstmrProfile__Recent_Big_Win_4_Value_M__c = ap.Recent_Big_Win_4_Value_M__c;
                
                aCustomerProfile.TEACstmrProfile__Recent_Loss_1__c = ap.Recent_Loss_1__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_1_Comments__c = ap.Recent_Loss_1_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_1_Date__c = ap.Recent_Loss_1_Date__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_1_Value_M__c = ap.Recent_Loss_1_Value_M__c;
                
                aCustomerProfile.TEACstmrProfile__Recent_Loss_2__c = ap.Recent_Loss_2__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_2_Comments__c = ap.Recent_Loss_2_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_2_Date__c = ap.Recent_Loss_2_Date__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_2_Value_M__c = ap.Recent_Loss_2_Value_M__c;
                
                aCustomerProfile.TEACstmrProfile__Recent_Loss_3__c = ap.Recent_Loss_3__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_3_Comments__c = ap.Recent_Loss_3_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_3_Date__c = ap.Recent_Loss_3_Date__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_3_Value_M__c = ap.Recent_Loss_3_Value_M__c;
                
                aCustomerProfile.TEACstmrProfile__Recent_Loss_4__c = ap.Recent_Loss_4__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_4_Comments__c = ap.Recent_Loss_4_Comments__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_4_Date__c = ap.Recent_Loss_4_Date__c;
                aCustomerProfile.TEACstmrProfile__Recent_Loss_4_Value_M__c = ap.Recent_Loss_4_Value_M__c;
                
                aCustomerProfile.TEACstmrProfile__Revenue_Section_Last_Updated__c = ap.Revenue_Section_Last_Updated__c;
                aCustomerProfile.TEACstmrProfile__Revenue_Section_Last_Updated_By__c = ap.Revenue_Section_Last_Updated_By__c;
                aCustomerProfile.TEACstmrProfile__Revenue_TAM_SAM__c = ap.Revenue_TAM_SAM__c;
                
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_1_Description__c = ap.Sales_Breakdown_1_Description__c;
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_1_Percent__c = ap.Sales_Breakdown_1_Percent__c;
                
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_2_Description__c = ap.Sales_Breakdown_2_Description__c;
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_2_Percent__c = ap.Sales_Breakdown_2_Percent__c;
                
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_3_Description__c = ap.Sales_Breakdown_3_Description__c;
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_3_Percent__c = ap.Sales_Breakdown_3_Percent__c;
                
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_4_Description__c = ap.Sales_Breakdown_4_Description__c;
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_4_Percent__c = ap.Sales_Breakdown_4_Percent__c;
                
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_5_Description__c = ap.Sales_Breakdown_5_Description__c;
                aCustomerProfile.TEACstmrProfile__Sales_Breakdown_5_Percent__c = ap.Sales_Breakdown_5_Percent__c;
                
                //aCustomerProfile. = ap.Snapshot_Date__c;
                //aCustomerProfile. = ap.Status__c;
                aCustomerProfile.TEACstmrProfile__Sales_Figures_Makeup__c = ap.Sales_Figures_Makeup__c;
               
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_1__c = ap.Strategic_Initiative_1__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_1_Status__c = ap.Strategic_Initiative_1_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_1_Target__c = ap.Strategic_Initiative_1_Target__c;
                /*commented by xia 2013-04-11
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_2__c = ap.Strategic_Initiative_2__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_2_Status__c = ap.Strategic_Initiative_2_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_2_Target__c = ap.Strategic_Initiative_2_Target__c;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_3__c = ap.Strategic_Initiative_3__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_3_Status__c = ap.Strategic_Initiative_3_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_3_Target__c = ap.Strategic_Initiative_3_Target__c;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_4__c = ap.Strategic_Initiative_4__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_4_Status__c = ap.Strategic_Initiative_4_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_4_Target__c = ap.Strategic_Initiative_4_Target__c;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_5__c = ap.Strategic_Initiative_5__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_5_Status__c = ap.Strategic_Initiative_5_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_5_Target__c = ap.Strategic_Initiative_5_Target__c;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_6__c = ap.Strategic_Initiative_6__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_6_Status__c = ap.Strategic_Initiative_6_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_6_Target__c = ap.Strategic_Initiative_6_Target__c;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_7__c = ap.Strategic_Initiative_7__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_7_Status__c = ap.Strategic_Initiative_7_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_7_Target__c = ap.Strategic_Initiative_7_Target__c;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_8__c = ap.Strategic_Initiative_8__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_8_Status__c = ap.Strategic_Initiative_8_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_8_Target__c = ap.Strategic_Initiative_8_Target__c;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_9__c = ap.Strategic_Initiative_9__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_9_Status__c = ap.Strategic_Initiative_9_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_9_Target__c = ap.Strategic_Initiative_9_Target__c;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_10__c = ap.Strategic_Initiative_10__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_10_Status__c = ap.Strategic_Initiative_10_Status__c;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_10_Target__c = ap.Strategic_Initiative_10_Target__c;
                */
                
                
                //added by xia 2013-04-11 -- start;
                //aCustomerProfile.TEACstmrProfile__Strategic_Initiative_1__c = null;
                //aCustomerProfile.TEACstmrProfile__Strategic_Initiative_1_Status__c = null;
                //aCustomerProfile.TEACstmrProfile__Strategic_Initiative_1_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_2__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_2_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_2_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_3__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_3_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_3_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_4__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_4_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_4_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_5__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_5_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_5_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_6__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_6_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_6_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_7__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_7_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_7_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_8__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_8_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_8_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_9__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_9_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_9_Target__c = null;
                
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_10__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_10_Status__c = null;
                aCustomerProfile.TEACstmrProfile__Strategic_Initiative_10_Target__c = null;
                integer k = 2;
                for(Integer i: map_startegicInitiative.keyset()){
                    acp.put('TEACstmrProfile__Strategic_Initiative_' + String.valueOf(k) + '__c',map_startegicInitiative.get(i));
                    acp.put('TEACstmrProfile__Strategic_Initiative_' + String.valueOf(k) + '_Status__c',(String)so.get('Strategic_Initiative_' + String.valueOf(i) + '_Status__c'));
                    acp.put('TEACstmrProfile__Strategic_Initiative_' + String.valueOf(k) + '_Target__c',(String)so.get('Strategic_Initiative_' + String.valueOf(i) + '_Target__c'));
                    
                    k++;            
                }
                //added by xia 2013-04-11
                
                //aCustomerProfile.TAM_Pct_Change_Plan_Yr__c = ap.TAM_Pct_Change_Plan_Yr__c;
                //aCustomerProfile.TAM_Pct_Change_Plan_Yr_1__c = ap.TAM_Pct_Change_Plan_Yr_1__c;
                //aCustomerProfile.TAM_Pct_Change_Plan_Yr_4__c = ap.TAM_Pct_Change_Plan_Yr_4__c;
                aCustomerProfile.TEACstmrProfile__TAM_Plan_Year_M__c = ap.TAM_Plan_Year_M__c;
                
                aCustomerProfile.TEACstmrProfile__TAM_Plan_Yr_1_M__c = ap.TAM_Plan_Yr_1_M__c;
                aCustomerProfile.TEACstmrProfile__TAM_Plan_Yr_4_M__c = ap.TAM_Plan_Yr_4_M__c;
                aCustomerProfile.TEACstmrProfile__TAM_Prior_Yr_M__c = ap.TAM_Prior_Yr_M__c;
                aCustomerProfile.TEACstmrProfile__TE_Performance_Status__c = ap.TE_Performance_Status__c;
                aCustomerProfile.TEACstmrProfile__TE_Revenue_CY_Forecast_M__c = ap.TE_Revenue_CY_Forecast_M__c;
                aCustomerProfile.TEACstmrProfile__TE_Revenue_Fcst_Plan_Yr_M__c = ap.TE_Revenue_Fcst_Plan_Yr_M__c;
                
                aCustomerProfile.TEACstmrProfile__TE_Revenue_Fcst_Plan_Yr_1_M__c = ap.TE_Revenue_Fcst_Plan_Yr_1_M__c;
                aCustomerProfile.TEACstmrProfile__TE_Revenue_Fcst_Plan_Yr_4_M__c = ap.TE_Revenue_Fcst_Plan_Yr_4_M__c;
                //aCustomerProfile.TE_Revenue_Pct_Change_Plan_Yr__c = ap.TE_Revenue_Pct_Change_Plan_Yr__c;
                //aCustomerProfile.TE_Revenue_Pct_Change_Plan_Yr_1__c = ap.TE_Revenue_Pct_Change_Plan_Yr_1__c;
                //aCustomerProfile.TE_Revenue_Pct_Change_Plan_Yr_4__c = ap.TE_Revenue_Pct_Change_Plan_Yr_4__c;
                aCustomerProfile.TEACstmrProfile__TE_Revenue_Prior_Yr_Actual_M__c = ap.TE_Revenue_Prior_Yr_Actual_M__c;
                aCustomerProfile.TEACstmrProfile__TE_Revenue_YTD_Actual_M__c = ap.TE_Revenue_YTD_Actual_M__c;
                //aCustomerProfile.Total_Rev_Pct_Chg_Plan_Yr_1__c = ap.Total_Rev_Pct_Chg_Plan_Yr_1__c;
                //aCustomerProfile.Total_Rev_Pct_Chg_Plan_Yr_2__c = ap.Total_Rev_Pct_Chg_Plan_Yr_2__c;
                aCustomerProfile.TEACstmrProfile__Total_Revenue_M_Plan_Yr_1__c = ap.Total_Revenue_M_Plan_Yr_1__c;
                aCustomerProfile.TEACstmrProfile__Total_Revenue_M_Plan_Yr_2__c = ap.Total_Revenue_M_Plan_Yr_2__c;
                aCustomerProfile.TEACstmrProfile__Total_Revenue_M_Plan_Yr_3__c = ap.Total_Revenue_M_Plan_Yr_3__c;
                aCustomerProfile.TEACstmrProfile__Unique_A_Customer_Year__c = ap.Unique_A_Customer_Year__c;
                //aCustomerProfile. = ap.Won_Project_1__c;Won_Project_2__c, Won_Project_3__c, Won_Project_4__c
                //aCustomerProfile.Worldwide_Account__c = ap.;
                
                //2012-06-29 added by Yuanyuan Zhang for new field on a custom profile object
                String orgId = UserInfo.getOrganizationId();
                aCustomerProfile.TEACstmrProfile__Integration_BU_Org_Key__c = orgId + '/';
                if(aCustomerProfile.Id != null){
                    String aCusId = aCustomerProfile.Id;
                    aCustomerProfile.TEACstmrProfile__Integration_BU_Org_Key__c +=  aCusId;
                }
                else{
                    list_acp2setOrgKey.add(aCustomerProfile);
                }
                //2012-06-29 added by Yuanyuan Zhang for new field on a custom profile object
                list_aCustomer2Upsert.add(aCustomerProfile);
                map_key_ACustomerProfile.put(ap.Id, aCustomerProfile);
                /*if(map_accPlanId_attachments.containsKey(ap.Id)){
                    map_key_attachments.put(ap.Id, map_accPlanId_attachments.get(ap.Id));
                }
                if(map_accPlanId_notes.containsKey(ap.Id)){
                    map_key_notes.put(ap.Id, map_accPlanId_notes.get(ap.Id));
                }*/
                
            }
            if(list_aCustomer2Upsert.size() != 0){
                upsert list_aCustomer2Upsert;
            }
            
            if(list_acp2setOrgKey.size() != 0){
                for(TEACstmrProfile__A_Customer_Profile__c acp : list_acp2setOrgKey){
                    String aCusId = acp.Id;
                    acp.TEACstmrProfile__Integration_BU_Org_Key__c +=  aCusId;
                }
                update list_acp2setOrgKey;
            }
            
            if(!map_key_ACustomerProfile.isEmpty()){
                list<Attachment> list_newAtt2Insert = new list<Attachment>();
                list<Note> list_newNote2Insert = new list<Note>();
                list<TEACstmrProfile__A_Customer_Profile_Attachment__c> list_apa2Insert = new list<TEACstmrProfile__A_Customer_Profile_Attachment__c>();
                map<Integer, Attachment> map_key_att = new map<Integer, Attachment>();
                map<Integer, TEACstmrProfile__A_Customer_Profile_Attachment__c> map_key_acpa = new map<Integer, TEACstmrProfile__A_Customer_Profile_Attachment__c>();
                Integer i = 0;
                for(Id key : map_key_ACustomerProfile.keySet()){
                    Id aCustomerProfileId = map_key_ACustomerProfile.get(key).Id;
                    
                    if(map_accPlanId_attachments.containsKey(key)){
                        for(Attachment att : map_accPlanId_attachments.get(key)){
                            // voice file
                            if(att.name.contains('VoiceOverview.wav')){
                                Attachment attNew = att.clone(false,true);
                                attNew.ParentId = aCustomerProfileId;
                                attNew.Name = att.Name;
                                list_newAtt2Insert.add(attNew);
                            }
                            // company logo
                            else if(set_companyLogoId.contains(att.Id)){
                                Attachment attNew = att.clone(false,true);
                                attNew.ParentId = aCustomerProfileId;
                                attNew.Name = 'Logo.jpg';
                                list_newAtt2Insert.add(attNew);
                            }
                            // manager photo
                            else if(set_managerPhotoId.contains(att.Id)){
                                Attachment attNew = att.clone(false,true);
                                attNew.ParentId = aCustomerProfileId;
                                attNew.Name = 'Photo.jpg';
                                list_newAtt2Insert.add(attNew);
                            }
                            //2012-10-24 added by Yuanyuan Zhang only attachments, which Send To Executive Dashboard true is, will be copy to a customer profile record
                            else if(map_attachmentId_apAttachment.containsKey(att.Id)){
                                Attachment attNew = att.clone(false,true);
                                attNew.ParentId = aCustomerProfileId;                               
                                list_newAtt2Insert.add(attNew);
                                map_key_att.put(i, attNew);
                                Account_Plan_Attachment__c apa = map_attachmentId_apAttachment.get(att.Id);
                                TEACstmrProfile__A_Customer_Profile_Attachment__c acpa = new TEACstmrProfile__A_Customer_Profile_Attachment__c();
                                acpa.TEACstmrProfile__A_Customer_Profile__c = aCustomerProfileId;
                                acpa.Name = apa.Name;
                                acpa.TEACstmrProfile__Author__c = apa.Author__c;
                                acpa.TEACstmrProfile__Content_Type__c = apa.Content_Type__c;
                                acpa.CurrencyIsoCode = apa.CurrencyIsoCode;
                                acpa.TEACstmrProfile__Description__c = apa.Description__c;
                                acpa.TEACstmrProfile__Send_Attachment_to_Executive_Dashboard__c = apa.Send_Attachment_to_Executive_Dashboard__c;
                                acpa.TEACstmrProfile__Title__c = apa.Title__c;
                                acpa.TEACstmrProfile__Type__c = apa.Type__c;
                                map_key_acpa.put(i,acpa);
                                i++;
                            }
                        }
                    }
                    
                    if(map_accPlanId_notes.containsKey(key)){
                        for(Note noteOld : map_accPlanId_notes.get(key)){
                            Note noteNew = noteOld.clone(false,true);
                            noteNew.ParentId = aCustomerProfileId;
                            list_newNote2Insert.add(noteNew);
                        }
                    }                   
                }
                
                if(list_newAtt2Insert.size() != 0) insert list_newAtt2Insert;                
                if(!map_key_acpa.isEmpty()){
                    for(Integer key : map_key_acpa.keySet()){
                        map_key_acpa.get(key).TEACstmrProfile__AttachmentId__c = map_key_att.get(key).Id;
                    }
                }
                               
                if(list_newNote2Insert.size() != 0) insert list_newNote2Insert;                
                if(!map_key_acpa.isEmpty()) insert map_key_acpa.values();
            }
        }
    }
    
    /** 
     *  Utility class to change the number format
     * 
     * @author Yuanyuan Zhang
     * @created 2012-07-12
     * @version 1.0
     * @since 24.0
     * 
     * 
     *
     * @changelog
     * 2012-07-12 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
     * - Created   
     *
     */
     
     public static String setNumberFormat(String locale, Decimal num, Boolean needFractile){
        String numString = String.valueOf(math.abs(num));
        String replaceFrom = '';
        String replaceTo = '';
        String negativeChar = '';
        if(num < 0){
            negativeChar = '-';
        }
        
        num = math.abs(num);
        if(locale == 'de'){
            replaceFrom = '.';
            replaceTo = ',';
        }
        else{
            replaceFrom = ',';
            replaceTo = '.';
        }
        numString = numString.replace(replaceFrom , replaceTo);
        
        
        if(needFractile && num > 1000){
            String intValueString = String.valueOf(num.intValue());
            String scaleValueString = numString.substring(intValueString.length(), numString.length());

            Integer tempLength = 0;
            Integer modTemp = 0;
            Integer countTemp = 0;
            List<String> strList = new List<String>();
            if (intValueString.length() > 0){
                String temp = '';
                temp = intValueString;
                tempLength = temp.length();
                if (tempLength > 3){
                    intValueString = '';
                    modTemp = math.mod(tempLength, 3);
                    countTemp = Integer.valueOf(tempLength / 3);
                    for (Integer i = 0; i < countTemp; i++){
                        strList.add(temp.substring(tempLength - (i + 1) * 3, tempLength-i * 3));
                    }
                    if (modTemp > 0){
                        strList.add(temp.substring(0, modTemp));
                    }
                }
            
                if (strList.size() > 0){
                    for (Integer i = strList.size()-1; i >= 0; i--){
                        if (i != 0){
                            if(locale == 'de'){
                                intValueString += strList[i]+'.';
                            }
                            else{
                                intValueString += strList[i]+',';
                            }
                        }
                        else{
                            intValueString += strList[i];
                        }
                    }
                    numString = intValueString + scaleValueString;
                }
            }
        }
        
        numString = negativeChar + numString;
        
        return numString;
    }
    
    
    /** 
     *  Utility class to get the corresponding fiscal quarter
     * 
     * @author Yuanyuan Zhang
     * @created 2012-07-13
     * @version 1.0
     * @since 24.0
     * 
     * 
     *
     * @changelog
     * 2012-07-13 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
     * - Created   
     *
     */
    public static map<Date, String> getCorrespondingFiscalQuarter(set<date> set_date){
        map<Date, String> map_date_fiscalQuarter = new map<Date, String>();
        list<Period> list_per = new list<Period>();
        for(Period p : [SELECT Type, 
                               EndDate, 
                               FiscalYearSettingsId,
                               FiscalYearSettings.Name, 
                               IsForecastPeriod, 
                               Number, 
                               Id, 
                               PeriodLabel, 
                               QuarterLabel, 
                               StartDate 
                        FROM Period 
                        Where (Type = 'Year' 
                        OR Type = 'Quarter')]){// AND IsForecastPeriod = true?
            list_per.add(p);
        }
        
        for(Date d : set_date){
            String fiscalQuarter = 'FY';
            String year;
            String quarter = 'Q';
            for(Period p : list_per){
                if(d <= p.EndDate && d >= p.StartDate){
                    if(p.Type == 'Year'){
                        year = p.FiscalYearSettings.Name.subString(p.FiscalYearSettings.Name.length() - 2, p.FiscalYearSettings.Name.length());
                    }
                    else{
                        
                        quarter += p.Number;
                    }
                    if(year != null && quarter != 'Q'){
                        fiscalQuarter += year + ' ' + quarter;
                        map_date_fiscalQuarter.put(d, fiscalQuarter);
                        break;
                    }
                }
                
            }
        }
        
        
        return map_date_fiscalQuarter;
    }
    
    
    public static Account_Plan__c getAccountPlanById(Id apId){
        Account_Plan__c accountPlan = new Account_Plan__c();
        for(Account_Plan__c ap:[SELECT Industry_Trends_Indicators__c, Key_Opportunity_Comments__c, Competition__c, Outlook__c, Capacity_Issues__c, Pricing__c, Customer_News__c,Account_Definition__c, Replicate_to_Central_Org__c,Account_Objective_1__c, Account_Objective_2__c, Account_Objective_3__c, Account_Objective_4__c, Account_Objective_5__c, 
                              Account_Objective_6__c, Account_Objective_7__c, Account_Objective_8__c, Account_Objective_9__c, Account_Objective_10__c, Account_Objective_11__c, Account_Objective_12__c, Account_Objective_13__c, 
                              Account_Objective_14__c, Account_Objective_15__c, Account_Objective_16__c,Account_Objective_17__c,Account_Objective_18__c, Account_Objective_19__c, Account_Objective_20__c,
                              Account_Objective_Location_1__c, Account_Objective_Location_2__c, Account_Objective_Location_3__c, Account_Objective_Location_4__c, Account_Objective_Location_5__c, 
                              Account_Objective_Location_6__c, Account_Objective_Location_7__c, Account_Objective_Location_8__c, Account_Objective_Location_9__c, Account_Objective_Location_10__c,
                              Account_Objective_Location_11__c, Account_Objective_Location_12__c, Account_Objective_Location_13__c, Account_Objective_Location_14__c, Account_Objective_Location_15__c,
                              Account_Objective_Location_16__c, Account_Objective_Location_17__c, Account_Objective_Location_18__c, Account_Objective_Location_19__c, Account_Objective_Location_20__c,
                              Name, Active__c, Approval_Status__c, BU_Revenue_CY_Forecast_M__c, BU_Revenue_Fcst_Plan_Yr_M__c, BU_Revenue_Fcst_Plan_Yr_1_M__c, Revenue_TAM_SAM__c,
                              BU_Revenue_Fcst_Plan_Yr_4_M__c, BU_Revenue_Pct_Change_Plan_Yr_1__c, BU_Revenue_Pct_Change_Plan_Yr_4__c, BU_Revenue_Prior_Yr_Actual_M__c, 
                              BU_Revenue_YTD_Actual_M__c, BU_Revenue_Pct_Change_Plan_Yr__c, Breakthrough_Pgm_1_Comments__c, Breakthrough_Pgm_1_Status__c,Revenue_Section_Last_Updated_By__c, 
                              Breakthrough_Pgm_2_Comments__c, Breakthrough_Pgm_2_Status__c, Breakthrough_Pgm_3_Comments__c, Breakthrough_Pgm_3_Status__c, Revenue_Section_Last_Updated__c,
                              Breakthrough_Pgm_4_Comments__c, Breakthrough_Pgm_4_Status__c, Breakthrough_Program_1__c, Breakthrough_Program_2__c, Breakthrough_Program_3__c, 
                              Breakthrough_Program_4__c, Business_Unit__c, Category1_Rev_Pct_Chg_Plan_Yr_1__c, Category1_Rev_Pct_Chg_Plan_Yr_2__c, Category1_Revenue_M_Plan_Yr_1__c, 
                              Category1_Revenue_M_Plan_Yr_2__c, Category1_Revenue_M_Plan_Yr_3__c, Category2_Name__c, Category2_Rev_Pct_Chg_Plan_Yr_1__c, 
                              Category2_Rev_Pct_Chg_Plan_Yr_2__c, Category2_Revenue_M_Plan_Yr_1__c, Category2_Revenue_M_Plan_Yr_2__c, Category2_Revenue_M_Plan_Yr_3__c, 
                              Category3_Name__c, Category3_Rev_Pct_Chg_Plan_Yr_1__c, Category3_Rev_Pct_Chg_Plan_Yr_2__c, Category3_Revenue_M_Plan_Yr_1__c, 
                              Category3_Revenue_M_Plan_Yr_2__c, Category3_Revenue_M_Plan_Yr_3__c, Competitor_1__c, Competitor_1_Comments__c, Competitor_1_MS_Trend__c, 
                              Competitor_1_Market_Share__c, Competitor_2__c, Competitor_2_Comments__c, Competitor_2_MS_Trend__c, Competitor_2_Market_Share__c, Competitor_3__c, 
                              Competitor_3_Comments__c, Competitor_3_MS_Trend__c, Competitor_3_Market_Share__c, Competitor_4__c, Competitor_4_Comments__c, Competitor_4_MS_Trend__c, 
                              Competitor_4_Market_Share__c, Competitor_5__c, Competitor_5_Comments__c, Competitor_5_MS_Trend__c, Competitor_5_Market_Share__c, Competitor_6__c, 
                              Competitor_6_Comments__c, Competitor_6_MS_Trend__c, Competitor_6_Market_Share__c, CurrencyIsoCode, Customer__c, Customer__r.Name,
                              Customer_Scorecard__c, Customer_Scorecard_Comments__c, Customer_Type__c, Definition__c,  Gross_Margin_Pct_Plan_Yr__c, 
                              Gross_Margin_Pct_Plan_Yr_1__c, Gross_Margin_Pct_Plan_Yr_4__c, Gross_Margin_Pct_Prior_Yr__c, Hidden_Do_Not_Use__c, Industry_Segment__c, 
                              Key_Product_1__c, Key_Product_1_Outlook__c, Key_Product_1_Pct__c, Key_Product_2__c, Key_Product_2_Outlook__c, Key_Product_2_Pct__c, Key_Product_3__c, 
                              Key_Product_3_Outlook__c, Key_Product_3_Pct__c, Key_Product_4__c, Key_Product_4_Outlook__c, Key_Product_4_Pct__c, Key_Product_5__c, 
                              Key_Product_5_Outlook__c, Key_Product_5_Pct__c, Key_Product_6__c, Key_Product_6_Outlook__c, Key_Product_6_Pct__c, Key_Product_Percent_Title__c, 
                              Key_Project_1__c, Key_Project_1__r.Name, Key_Project_1_Start_Date__c, Key_Project_1_Value_M__c, Key_Project_2__c, Key_Project_2__r.Name, Key_Project_2_Start_Date__c, Key_Project_2_Value_M__c, 
                              Key_Project_3__c, Key_Project_3__r.Name, Key_Project_3_Start_Date__c, Key_Project_3_Value_M__c, Key_Project_4__c, Key_Project_4__r.Name, Key_Project_4_Start_Date__c, Key_Project_4_Value_M__c, 
                              Key_Project_5__c, Key_Project_5__r.Name, Key_Project_5_Start_Date__c, Key_Project_5_Value_M__c, Key_Project_6__c, Key_Project_6__r.Name, Key_Project_6_Start_Date__c, Key_Project_6_Value_M__c, 
                              LastModifiedById, LastModifiedDate, Lost_Project_1__c, Lost_Project_2__c, Lost_Project_3__c, Lost_Project_4__c, Manager__c, Market_Share_Plan_Yr__c,
                              Market_Share_Plan_Yr_1__c, Market_Share_Plan_Yr_4__c, Market_Share_Prior_Yr__c, Monthly_Update__c, Monthly_Update_Last_Updated__c, Obstacle_1__c, 
                              Obstacle_2__c, Obstacle_3__c, Obstacle_4__c, Obstacle_5__c, Plan_Year__c, Purchasing_Relationship__c, Purchasing_Relationship_Comments__c, 
                              ConnectionReceivedId, Recent_Big_Win_1__c, Recent_Big_Win_1_Comments__c, Recent_Big_Win_1_Date_Won__c, Recent_Big_Win_1_Value_M__c,Monthly_Update_Last_Updated_By__c, 
                              Recent_Big_Win_2__c, Recent_Big_Win_2_Comments__c, Recent_Big_Win_2_Date_Won__c, Recent_Big_Win_2_Value_M__c, Recent_Big_Win_3__c, 
                              Recent_Big_Win_3_Comments__c, Recent_Big_Win_3_Date_Won__c, Recent_Big_Win_3_Value_M__c, Recent_Big_Win_4__c, Recent_Big_Win_4_Comments__c, 
                              Recent_Big_Win_4_Date_Won__c, Recent_Big_Win_4_Value_M__c, Recent_Loss_1__c, Recent_Loss_1_Comments__c, Recent_Loss_1_Date__c, Category1_Name__c ,
                              Recent_Loss_1_Value_M__c, Recent_Loss_2__c, Recent_Loss_2_Comments__c, Recent_Loss_2_Date__c, Recent_Loss_2_Value_M__c, Recent_Loss_3__c, 
                              Recent_Loss_3_Comments__c, Recent_Loss_3_Date__c, Recent_Loss_3_Value_M__c, Recent_Loss_4__c, Recent_Loss_4_Comments__c, Recent_Loss_4_Date__c, 
                              Recent_Loss_4_Value_M__c, Id, Snapshot_Date__c, Status__c,SystemModstamp, TAM_Pct_Change_Plan_Yr__c, 
                              TAM_Pct_Change_Plan_Yr_1__c, TAM_Pct_Change_Plan_Yr_4__c, TAM_Plan_Year_M__c, TAM_Plan_Yr_1_M__c, TAM_Plan_Yr_4_M__c, TAM_Prior_Yr_M__c, 
                              TE_Performance_Status__c, TE_Revenue_CY_Forecast_M__c, TE_Revenue_Fcst_Plan_Yr_M__c, TE_Revenue_Fcst_Plan_Yr_1_M__c, TE_Revenue_Fcst_Plan_Yr_4_M__c, 
                              TE_Revenue_Pct_Change_Plan_Yr__c, TE_Revenue_Pct_Change_Plan_Yr_1__c, TE_Revenue_Pct_Change_Plan_Yr_4__c, TE_Revenue_Prior_Yr_Actual_M__c, 
                              TE_Revenue_YTD_Actual_M__c, Sales_Figures_Makeup__c, Total_Rev_Pct_Chg_Plan_Yr_1__c, Total_Rev_Pct_Chg_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_1__c, 
                              Total_Revenue_M_Plan_Yr_2__c, Total_Revenue_M_Plan_Yr_3__c, Unique_A_Customer_Year__c, Won_Project_1__c, Won_Project_2__c, Won_Project_3__c, 
                              Won_Project_4__c, Executive_Relationship__c, Executive_Relationship_Comments__c, Engineering_Relationship__c, Engineering_Relationship_Comments__c,
                              Won_Project_1__r.Name, Won_Project_2__r.Name, Won_Project_3__r.Name, Won_Project_4__r.Name,
                              Won_Project_1__r.Five_Year_Value__c, Won_Project_2__r.Five_Year_Value__c, Won_Project_3__r.Five_Year_Value__c, Won_Project_4__r.Five_Year_Value__c,
                              Won_Project_1__r.Five_Year_Revenue__c, Won_Project_2__r.Five_Year_Revenue__c, Won_Project_3__r.Five_Year_Revenue__c, Won_Project_4__r.Five_Year_Revenue__c,
                              Won_Project_1__r.Lost_Rejected_Dead_On_Hold_Reason__c, Won_Project_2__r.Lost_Rejected_Dead_On_Hold_Reason__c, Won_Project_3__r.Lost_Rejected_Dead_On_Hold_Reason__c, Won_Project_4__r.Lost_Rejected_Dead_On_Hold_Reason__c,
                              Won_Project_1__r.Account_Plan_Comment__c, Won_Project_2__r.Account_Plan_Comment__c, Won_Project_3__r.Account_Plan_Comment__c, Won_Project_4__r.Account_Plan_Comment__c,
                              Lost_Project_1__r.Name, Lost_Project_2__r.Name, Lost_Project_3__r.Name, Lost_Project_4__r.Name,
                              Lost_Project_1__r.Five_Year_Revenue__c, Lost_Project_2__r.Five_Year_Revenue__c, Lost_Project_3__r.Five_Year_Revenue__c, Lost_Project_4__r.Five_Year_Revenue__c,
                              Lost_Project_1__r.Lost_Rejected_Dead_On_Hold_Reason__c, Lost_Project_2__r.Lost_Rejected_Dead_On_Hold_Reason__c, 
                              Lost_Project_3__r.Lost_Rejected_Dead_On_Hold_Reason__c, Lost_Project_4__r.Lost_Rejected_Dead_On_Hold_Reason__c,
                              Lost_Project_1__r.Five_Year_Value__c, Lost_Project_2__r.Five_Year_Value__c, 
                              Lost_Project_3__r.Five_Year_Value__c, Lost_Project_4__r.Five_Year_Value__c,
                              Lost_Project_1__r.Account_Plan_Comment__c, Lost_Project_2__r.Account_Plan_Comment__c, 
                              Lost_Project_3__r.Account_Plan_Comment__c, Lost_Project_4__r.Account_Plan_Comment__c,
                              Sales_Breakdown_1_Description__c, Sales_Breakdown_1_Percent__c, 
                              Sales_Breakdown_2_Description__c, Sales_Breakdown_2_Percent__c, Sales_Breakdown_3_Description__c, 
                              Sales_Breakdown_3_Percent__c, Sales_Breakdown_4_Description__c, Sales_Breakdown_4_Percent__c, 
                              Sales_Breakdown_5_Description__c, Sales_Breakdown_5_Percent__c,
                              //Strategic_Initiative_1__c, Strategic_Initiative_1_Status__c, Strategic_Initiative_1_Target__c, 
                              //Strategic_Initiative_10__c, Strategic_Initiative_10_Status__c, Strategic_Initiative_10_Target__c, 
                              //Strategic_Initiative_2__c, Strategic_Initiative_2_Status__c, Strategic_Initiative_2_Target__c, Strategic_Initiative_3__c, 
                              //Strategic_Initiative_3_Status__c, Strategic_Initiative_3_Target__c, Strategic_Initiative_4__c, Strategic_Initiative_4_Status__c, 
                              //Strategic_Initiative_4_Target__c, Strategic_Initiative_5__c, Strategic_Initiative_5_Status__c, Strategic_Initiative_5_Target__c, 
                              //Strategic_Initiative_6__c, Strategic_Initiative_6_Status__c, Strategic_Initiative_6_Target__c, Strategic_Initiative_7__c, 
                              //Strategic_Initiative_7_Status__c, Strategic_Initiative_7_Target__c,Strategic_Initiative_8_Status__c,
                              Strategic_Initiative_1__c, Strategic_Initiative_1_Status__c, Strategic_Initiative_1_Target__c, Strategic_Initiative_1_Owner__c,
                              Strategic_Initiative_2__c, Strategic_Initiative_2_Status__c, Strategic_Initiative_2_Target__c, Strategic_Initiative_2_Owner__c,
                              Strategic_Initiative_3__c, Strategic_Initiative_3_Status__c, Strategic_Initiative_3_Target__c, Strategic_Initiative_3_Owner__c,
                              Strategic_Initiative_4__c, Strategic_Initiative_4_Status__c, Strategic_Initiative_4_Target__c, Strategic_Initiative_4_Owner__c,
                              Strategic_Initiative_5__c, Strategic_Initiative_5_Status__c, Strategic_Initiative_5_Target__c, Strategic_Initiative_5_Owner__c,
                              Strategic_Initiative_6__c, Strategic_Initiative_6_Status__c, Strategic_Initiative_6_Target__c, Strategic_Initiative_6_Owner__c,
                              Strategic_Initiative_7__c, Strategic_Initiative_7_Status__c, Strategic_Initiative_7_Target__c, Strategic_Initiative_7_Owner__c,
                              Strategic_Initiative_8__c, Strategic_Initiative_8_Status__c, Strategic_Initiative_8_Target__c, Strategic_Initiative_8_Owner__c,
                              Strategic_Initiative_9__c, Strategic_Initiative_9_Status__c, Strategic_Initiative_9_Target__c, Strategic_Initiative_9_Owner__c,
                              Strategic_Initiative_10__c, Strategic_Initiative_10_Status__c, Strategic_Initiative_10_Target__c, Strategic_Initiative_10_Owner__c,
                              Strategic_Initiative_11__c, Strategic_Initiative_11_Status__c, Strategic_Initiative_11_Target__c, Strategic_Initiative_11_Owner__c,
                              Strategic_Initiative_12__c, Strategic_Initiative_12_Status__c, Strategic_Initiative_12_Target__c, Strategic_Initiative_12_Owner__c,
                              Strategic_Initiative_13__c, Strategic_Initiative_13_Status__c, Strategic_Initiative_13_Target__c, Strategic_Initiative_13_Owner__c,
                              Strategic_Initiative_14__c, Strategic_Initiative_14_Status__c, Strategic_Initiative_14_Target__c, Strategic_Initiative_14_Owner__c,
                              Strategic_Initiative_15__c, Strategic_Initiative_15_Status__c, Strategic_Initiative_15_Target__c, Strategic_Initiative_15_Owner__c,
                              Strategic_Initiative_16__c, Strategic_Initiative_16_Status__c, Strategic_Initiative_16_Target__c, Strategic_Initiative_16_Owner__c,
                              Strategic_Initiative_17__c, Strategic_Initiative_17_Status__c, Strategic_Initiative_17_Target__c, Strategic_Initiative_17_Owner__c,
                              Strategic_Initiative_18__c, Strategic_Initiative_18_Status__c, Strategic_Initiative_18_Target__c, Strategic_Initiative_18_Owner__c,
                              Strategic_Initiative_19__c, Strategic_Initiative_19_Status__c, Strategic_Initiative_19_Target__c, Strategic_Initiative_19_Owner__c,
                              Strategic_Initiative_20__c, Strategic_Initiative_20_Status__c, Strategic_Initiative_20_Target__c, Strategic_Initiative_20_Owner__c,
                              Key_Project_1__r.RecordType.DeveloperName, Key_Project_1__r.Program__r.Name, Key_Project_1__r.Program__c,
                              Key_Project_2__r.RecordType.DeveloperName, Key_Project_2__r.Program__r.Name, Key_Project_2__r.Program__c,
                              Key_Project_3__r.RecordType.DeveloperName, Key_Project_3__r.Program__r.Name, Key_Project_3__r.Program__c,
                              Key_Project_4__r.RecordType.DeveloperName, Key_Project_4__r.Program__r.Name, Key_Project_4__r.Program__c,
                              Key_Project_5__r.RecordType.DeveloperName, Key_Project_5__r.Program__r.Name, Key_Project_5__r.Program__c,
                              Key_Project_6__r.RecordType.DeveloperName, Key_Project_6__r.Program__r.Name, Key_Project_6__r.Program__c,
                              Customer__r.RecordType.DeveloperName,Customer__r.Type,Customer__r.Industry_Code_Description__c, Customer__r.Customer_Industry__c, CreatedById ,CreatedDate,
                              Company_Logo__c, Company_Logo_Id__c,RecordTypeId, RecordType.Name, Account_Manager_Id__c, Account_Manager__c,GAM_Code__c,
                              Competitor1__c, Competitor2__c, Competitor3__c, Competitor4__c, Competitor5__c, Competitor6__c, Account_Manager_Approver__c,
                              Won_Project_1__r.CurrencyIsoCode,Won_Project_2__r.CurrencyIsoCode,Won_Project_3__r.CurrencyIsoCode,Won_Project_4__r.CurrencyIsoCode,
                              //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                              Customer__r.IND_KAM_Code__c,
                              Customer__r.GAMCD__c,
                              //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                              Lost_Project_1__r.CurrencyIsoCode,Lost_Project_2__r.CurrencyIsoCode,Lost_Project_4__r.CurrencyIsoCode,Lost_Project_3__r.CurrencyIsoCode,BU_Revenue_CY_Manual_Forecast_M__c,Customer__r.MKTMGRCDE__c,
                              //added by bin yuan due query exception 2013-11-07

                              //End
                              TE_inside_account_plan__c// added by mrunal for R-1468
                        FROM Account_Plan__c
                        WHERE Id = :apId LIMIT 1]){
           accountPlan = ap;                 
                        
        }
        return accountPlan;
    }
    
    /**
    * This method is used check the BU is IND Or not.
    *
    @author Lili Zhao
    @created 2014-06-13
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-13 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */ 
    public static String checkBU(String industryCode){
      String bu = '';
      if(map_BU_IND.containsKey(industryCode)) {
        bu = 'IND';
      }
      return bu;
    }
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    ///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}