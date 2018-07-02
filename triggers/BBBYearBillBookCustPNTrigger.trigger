/**
*  This trigger to mark the yearly bb by part which need to create or delete split result.
*
@author Yimin Zheng
@created 2016-01-12
*
@changelog
coverage 100%

2016-01-12 Yimin Zheng<yimin.zheng@te.com>
* - Created
*/
trigger BBBYearBillBookCustPNTrigger on BBB_Year_Bill_Book_Cust_PN__c (before delete, before insert) {
    
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            for(BBB_Year_Bill_Book_Cust_PN__c yearBBB : Trigger.new){
                //yearBBB.needCeateSplitResult__c = true;
                yearBBB.APL_need_to_capture_billing__c = true;
             }
        }else if(Trigger.isDelete){
            Set<Id> aplYearlyBBIdSet = new Set<Id>();
            Set<Id> aplYearlyBBIdForCaptureSet = new Set<Id>();
            for(BBB_Year_Bill_Book_Cust_PN__c yearly : trigger.Old){
                if(yearly.Territory_L1_Code__c == '102260' || yearly.BU_Profit_Center__c == 'APL' || yearly.BU_Profit_Center__c == 'RPA'){
                    aplYearlyBBIdSet.add(yearly.Id);
                }
                
                aplYearlyBBIdForCaptureSet.add(yearly.Id);
            }
            
            //query the relevent apl sales split result
            //List<APL_Sales_Split_Result__c> spResultList = [select Id from APL_Sales_Split_Result__c where Yearly_Booking_Billings_By_Part__c in: aplYearlyBBIdSet];
            //delete spResultList;   
            
            
            //query the relecent apl capture billing
            List<APL_Billing_Result_of_Covnerted_Opp__c> convertResult = [select Id from APL_Billing_Result_of_Covnerted_Opp__c where Yearly_Booking_Billings_By_Part__c in: aplYearlyBBIdForCaptureSet]; 
            delete convertResult;
            
        }
    }
}