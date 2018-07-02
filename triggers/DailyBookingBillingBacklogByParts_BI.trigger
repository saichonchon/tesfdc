/**
 *  This before insert trigger is used to set Customer_Request_Date_Fiscal_Month__c and Customer_Request_Date_Fiscal_Year__c.
 *
 @  author Lili Zhao
 @  created 2014-06-10
 @  version 1.0
 @  since 27.0 (Force.com ApiVersion)
 *
 @  changelog
 *
 *  2014-06-10 Lili Zhao <lili.zhao@itbconsult.com>
 *  Created
 */
trigger DailyBookingBillingBacklogByParts_BI on BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c (before insert) {
	
	list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_bbbDayBillBookBklgCustPNs = new list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c>();
	Date StartDate;
	Date EndDate;
	for(BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDayBillBookBklgCustPN : trigger.new) {
		
		if(bbbDayBillBookBklgCustPN.Customer_Request_Date_Fiscal_Month__c == null 
			&& bbbDayBillBookBklgCustPN.Customer_Request_Date_Fiscal_Year__c == null 
			&& bbbDayBillBookBklgCustPN.Customer_Request_Date__c != null) {
				
			list_bbbDayBillBookBklgCustPNs.add(bbbDayBillBookBklgCustPN);
			if(StartDate == null || EndDate == null ) {
				StartDate = bbbDayBillBookBklgCustPN.Customer_Request_Date__c;
				EndDate = bbbDayBillBookBklgCustPN.Customer_Request_Date__c;
			}else{
				if(StartDate < bbbDayBillBookBklgCustPN.Customer_Request_Date__c) {
					StartDate = bbbDayBillBookBklgCustPN.Customer_Request_Date__c;
				}
				if(EndDate > bbbDayBillBookBklgCustPN.Customer_Request_Date__c) {
					EndDate = bbbDayBillBookBklgCustPN.Customer_Request_Date__c;
				}
			}
		}				
	}
	if(!list_bbbDayBillBookBklgCustPNs.isEmpty()){
		ClsDailyBookingBillingBacklogByPartsUtil.setBbbDayBillBookBklgCustPNYearAndMonth(list_bbbDayBillBookBklgCustPNs, StartDate, EndDate, false);
	}
}