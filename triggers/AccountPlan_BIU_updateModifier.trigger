/**
 *  This trigger is used to update the last updated fields
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-24
 * @version 1.0
 * @since 23.0
 * 
 * return
 *
 * @changelog
 * 2012-05-24 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */

trigger AccountPlan_BIU_updateModifier on Account_Plan__c (before insert, before update) {
	Id userId = UserInfo.getUserId();
	Datetime currentDate = system.now();
	try{
		if(trigger.isInsert){
			for(Account_Plan__c ap : trigger.new){
				ap.Revenue_Section_Last_Updated__c    = currentDate;
	            ap.Revenue_Section_Last_Updated_By__c = userId;
	            ap.Monthly_Update_Last_Updated__c    = currentDate;
	            ap.Monthly_Update_Last_Updated_By__c = userId;
			}
		}
		else{
			for(Account_Plan__c ap : trigger.new){
	            if(trigger.oldMap.get(ap.Id).Monthly_Update__c != ap.Monthly_Update__c){
	                ap.Monthly_Update_Last_Updated__c = currentDate;
	                ap.Monthly_Update_Last_Updated_By__c = userId;
	            }
	            integer i =0;
	            if(trigger.oldMap.get(ap.Id).TE_Performance_Status__c != ap.TE_Performance_Status__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TE_Revenue_Prior_Yr_Actual_M__c != ap.TE_Revenue_Prior_Yr_Actual_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TE_Revenue_YTD_Actual_M__c != ap.TE_Revenue_YTD_Actual_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TE_Revenue_CY_Forecast_M__c != ap.TE_Revenue_CY_Forecast_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TE_Revenue_Fcst_Plan_Yr_M__c != ap.TE_Revenue_Fcst_Plan_Yr_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TE_Revenue_Fcst_Plan_Yr_1_M__c != ap.TE_Revenue_Fcst_Plan_Yr_1_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TE_Revenue_Fcst_Plan_Yr_4_M__c != ap.TE_Revenue_Fcst_Plan_Yr_4_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).BU_Revenue_Prior_Yr_Actual_M__c != ap.BU_Revenue_Prior_Yr_Actual_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).BU_Revenue_YTD_Actual_M__c != ap.BU_Revenue_YTD_Actual_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).BU_Revenue_CY_Forecast_M__c != ap.BU_Revenue_CY_Forecast_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).BU_Revenue_Fcst_Plan_Yr_M__c != ap.BU_Revenue_Fcst_Plan_Yr_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).BU_Revenue_Fcst_Plan_Yr_1_M__c != ap.BU_Revenue_Fcst_Plan_Yr_1_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).BU_Revenue_Fcst_Plan_Yr_4_M__c != ap.BU_Revenue_Fcst_Plan_Yr_4_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).Revenue_TAM_SAM__c != ap.Revenue_TAM_SAM__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TAM_Prior_Yr_M__c != ap.TAM_Prior_Yr_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TAM_Plan_Year_M__c != ap.TAM_Plan_Year_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TAM_Plan_Yr_1_M__c != ap.TAM_Plan_Yr_1_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).TAM_Plan_Yr_4_M__c != ap.TAM_Plan_Yr_4_M__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).Gross_Margin_Pct_Prior_Yr__c != ap.Gross_Margin_Pct_Prior_Yr__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).Gross_Margin_Pct_Plan_Yr__c != ap.Gross_Margin_Pct_Plan_Yr__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).Gross_Margin_Pct_Plan_Yr_1__c != ap.Gross_Margin_Pct_Plan_Yr_1__c)
	            i++;
	            if(trigger.oldMap.get(ap.Id).Gross_Margin_Pct_Plan_Yr_4__c != ap.Gross_Margin_Pct_Plan_Yr_4__c)
	            i++;
	            
	            if(i>0){
	                ap.Revenue_Section_Last_Updated__c = currentDate;
	                ap.Revenue_Section_Last_Updated_By__c = userId;
	            }
	        } 
		}
	}
	catch(Exception ex){}
}