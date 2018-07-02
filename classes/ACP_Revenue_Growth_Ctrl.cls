/******************************************************************************************************************
Name: ACP_Revenue_Growth_Ctrl
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
ACP_Revenue_Growth_Ctrl for ACP_Performance_Analytics_Page
=============================================================================
Purpose:
Controller to add and edit ACP_Revenue_Growth_Perf__c records and display data on 
Revenue and Growth table on ACP_Performance_Analytics_Page
Test class:
ACP_Revenue_Growth_Ctrl_Test
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Anushka Bansal 10/06/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments 
********************************************************************************************************************/
public with sharing class ACP_Revenue_Growth_Ctrl {
 public String acpId {
  get;
  set;
 }
 public String refreshBasedOn {
  get;
  set;
 }
 public String revType {
  get;
  set;
 }
 public ACP_Revenue_Growth_Perf__c revenueGrowthTotal {
  get;
  set;
 }
 private final ACP_Account_Plan__c Act;
 public Map < String, List < Reports.SummaryValue >> mapReport1;
 public Map < String, List < Reports.SummaryValue >> mapReport2;
 public List < String > keySet;
 public LIST < Reports.SummaryValue > summaryValues = new LIST < Reports.SummaryValue > ();
 public ACP_Account_Plan__c accplan {
  get;
  set;
 }
 public List < ACP_Revenue_Growth_Perf__c > revenueGrowthList {
  get;
  set;
 }
 public List < ACP_Revenue_Growth_Perf__c > businessPerfList {
  get;
  set;
 }
 public Map < String, ACP_Revenue_Growth_Perf__c > revenueGrowthMap = new Map < String, ACP_Revenue_Growth_Perf__c > ();
 // public String fieldSetStr{get;set;}
 public Integer fiscalyr {
  get;
  set;
 }
 public Integer pastyr {
  get;
  set;
 }
 public Integer pastyr_1 {
  get;
  set;
 }
 String fy = '';
 FiscalYearSettings fiscalYear;
 public ACP_Revenue_Growth_Ctrl() {



  acpid = ApexPages.currentPage().getParameters().get('acpId');

  ACP_Account_Plan__c acntPlan = new ACP_Account_Plan__c();
  fiscalYear = [select name, StartDate from FiscalYearSettings where StartDate <= : date.today() AND EndDate >= : date.today()];
  if (fiscalYear != null) {
   fy = fiscalYear.name;
   fiscalyr = Integer.valueOf(fy);
   pastyr = fiscalyr - 1;
   pastYr_1 = pastyr - 1;
  }

 }
 public Pagereference runReport() {
  try {
   ACP_Account_Plan__c accplan = [select id, Account_Plan_Type__c, ACP_GAMCode__c, ACP_KAMCode__c, ACP_WWAcNo__c, ACP_Account_Name__c from ACP_Account_Plan__c where id = : acpId];

   String acctId = accplan.ACP_Account_Name__c;
   List < Period > p2 = [SELECT Id, PeriodLabel, StartDate, Type FROM Period WHERE StartDate <= today AND StartDate >= : fiscalYear.StartDate and type = 'month'];
    
   String fiscalMonth = '';
   for (Integer i = 1; i < p2.size(); i++) {
    fiscalMonth = fiscalMonth + i + ',';
   }
   if(fiscalMonth.length() > 1)
   fiscalMonth = fiscalMonth.substring(0, fiscalMonth.length() - 1);
   else
   fiscalMonth = '0';
    system.debug('month =-=-=-=-=-=-=-=- '+ fiscalMonth);

   // ------------- Fetching reports and report metadata----------------//
   String reportId = 'ACP_Revenue_Growth_Report1';
   Report report = Database.query('SELECT Id, Developername, format FROM Report WHERE developerName =: reportId');
   Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport((String) report.Id);
   Reports.ReportMetadata reportMd = describe.getReportMetadata();
   Reports.reportResults results;


   String reportId2 = 'ACP_Revenue_Growth_Report2';
   Report report2 = Database.query('SELECT Id, Developername, format FROM Report WHERE developerName =: reportId2');
   Reports.ReportDescribeResult describe2 = Reports.ReportManager.describeReport((String) report2.Id);
   Reports.ReportMetadata reportMd2 = describe2.getReportMetadata();
   Reports.reportResults results2;

   List < Reports.ReportFilter > filters = new List < Reports.ReportFilter > ();
   List < Reports.ReportFilter > filters2 = new List < Reports.ReportFilter > ();

   Map < String, Reports.ReportFilter > filterMap = new Map < String, Reports.ReportFilter > ();

   //--------- setting filters for report 1 -----------------//
   for (Integer i = 0; i < 5; i++) {
    String key = reportMd.getReportFilters()[i].getColumn();
    filterMap.put(key, reportMd.getReportFilters()[i]);
   }
   filterMap.get('BBB_Month_Bill_Book_Cust__c.Fiscal_Year__c').setValue(String.valueof(pastyr) + ',' + String.valueof(pastyr_1));

   if (accplan.Account_Plan_Type__c == 'Gam Account')
    filterMap.get('Account.GAMCD__c').setValue(accplan.ACP_GAMCode__c);

   else if (accplan.Account_Plan_Type__c == 'Kam Account')
    filterMap.get('Account.IND_KAM_Code__c').setValue(accplan.ACP_KAMCode__c);

   else if (accplan.Account_Plan_Type__c == 'WW Account')
    filterMap.get('Account.WWCORPACCT__c').setValue(accplan.ACP_WWAcNo__c);

   else
    filterMap.get('ACCOUNT_ID').setValue(acctId.left(15));


   for (Reports.ReportFilter f: filterMap.values())
    filters.add(f);

   reportMd.setReportFilters(filters);

   results = Reports.ReportManager.runReport((String) report.Id, reportMd, true);
   //--------- setting filters for report 2 -----------------//
   filterMap.clear();
   for (Integer i = 0; i < 6; i++) {
    String key = reportMd2.getReportFilters()[i].getColumn();
    filterMap.put(key, reportMd2.getReportFilters()[i]);
    //filterMap.get(key).setValue('');
   }
   // filterMap.get('BBB_Month_Bill_Book_Cust__c.Bill_Type__c').setValue(revType);
   filterMap.get('BBB_Month_Bill_Book_Cust__c.Fiscal_Year__c').setValue(fy + ',' + String.valueof(pastyr));
   filterMap.get('BBB_Month_Bill_Book_Cust__c.Fiscal_Month__c').setValue(fiscalMonth);

   if (accplan.Account_Plan_Type__c == 'Gam Account')
    filterMap.get('Account.GAMCD__c').setValue(accplan.ACP_GAMCode__c);

   else if (accplan.Account_Plan_Type__c == 'Kam Account')
    filterMap.get('Account.IND_KAM_Code__c').setValue(accplan.ACP_KAMCode__c);

   else if (accplan.Account_Plan_Type__c == 'WW Account')
    filterMap.get('Account.WWCORPACCT__c').setValue(accplan.ACP_WWAcNo__c);

   else
    filterMap.get('ACCOUNT_ID').setValue(acctId.left(15));

   for (Reports.ReportFilter f: filterMap.values())
    filters2.add(f);

   reportMd2.setReportFilters(filters2);
   system.debug('filters  -- ' + reportMd2.getReportFilters());
   results2 = Reports.ReportManager.runReport((String) report2.Id, reportMd2, true);

   Reports.Dimension dim = results.getGroupingsDown(); // fetching column labels from report 1 
   Reports.Dimension dim2 = results.getGroupingsAcross(); // fetching row labels from report 1 
   Reports.Dimension dim3 = results2.getGroupingsDown(); // fetching column labels from report 2
   Reports.Dimension dim4 = results2.getGroupingsAcross(); // fetching row labels from report 2 

   mapReport1 = new Map < String, List < Reports.SummaryValue >> ();
   mapReport2 = new Map < String, List < Reports.SummaryValue >> ();

   keyset = new List < String > ();
   keyset.add('CMA');
   keyset.add('Direct');
   keyset.add('POS');
   //keyset = revType.split(';');
   keyset.add('Combined');

   /* ----------- putting values from report 1 into a map wih key as 'rowLabel-ColumnLabel' eg 'CMA-2017' 
   and value as Reports.SummaryValue since the report contains summarizable fields ---- */
   for (Reports.GroupingValue down: dim2.getGroupings()) {
    String mapkey = '';
    String key = '';
    for (Reports.GroupingValue across: dim.getGroupings()) {
     mapkey = across.getLabel() + '-' + down.getLabel();
     key = across.getKey() + '!' + down.getKey();
     Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results.getFactMap().get(key);
     summaryValues = factDetails.getAggregates();
     mapReport1.put(mapkey, summaryValues);
    }
    key = 'T!' + down.getKey();
    Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results.getFactMap().get(key);
    summaryValues = factDetails.getAggregates();
    mapReport1.put(down.getLabel(), summaryValues);
   }

   /* ----------- putting values from report 2 into a map wih key as 'rowLabel-ColumnLabel' eg 'CMA-2017' 
      and value as Reports.SummaryValue since the report contains summarizable fields ---- */
   for (Reports.GroupingValue down: dim4.getGroupings()) {
    for (Reports.GroupingValue across: dim3.getGroupings()) {
     String mapkey = across.getLabel() + '-' + down.getLabel();
     String key = across.getKey() + '!' + down.getKey();
     //keyset.add(key);
     Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results2.getFactMap().get(key);
     summaryValues = factDetails.getAggregates();
     mapReport2.put(mapkey, summaryValues);
    }

    String key = 'T!' + down.getKey();
    Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails) results2.getFactMap().get(key);
    summaryValues = factDetails.getAggregates();
    mapReport2.put(down.getLabel(), summaryValues);

   }

   List < String > revTypeList = revType.split(';');

    system.debug('hhh --'  + revTypeList);
   // -- Adding existing revenue n growth records into a map with key as a combination of refresh based on and sales mode eg. 'Billing-CMA' ---//
   revenueGrowthList = [Select id, ACP_Past_Year_to_Date__c, ACP_Past_Year_1_Revenue__c, ACP_Past_Year_Revenue__c, ACP_Refresh_Based_on__c, ACP_Sales_Mode__c, ACP_Account_Plan__c, ACP_Current_Year_1_Plan__c, ACP_Current_Year_3_Plan__c, ACP_Current_Year_5_Plan__c, ACP_Current_Year_to_Date__c from ACP_Revenue_Growth_Perf__c where ACP_Account_Plan__c = : acpid order by createdDate];

   // businessPerfList = [Select id, ACP_Past_Year_1_Revenue__c, ACP_Past_Year_to_Date__c, ACP_Past_Year_Revenue__c, ACP_Refresh_Based_on__c, ACP_Sales_Mode__c, ACP_Account_Plan__c, ACP_Current_Year_1_Plan__c, ACP_Current_Year_3_Plan__c,ACP_Current_Year_5_Plan__c, ACP_Current_Year_to_Date__c from ACP_Revenue_Growth_Perf__c where ACP_Account_Plan__c = : acpid and ACP_Sales_Mode__c in :revTypeList  order by createdDate];

   for (ACP_Revenue_Growth_Perf__c r: revenueGrowthList) {
    String mapkey = r.ACP_Refresh_Based_on__c + '-' + r.ACP_Sales_Mode__c;
    revenueGrowthMap.put(mapkey, r);

   }

   // creating or updating a billing and a booking record for each sales mode ie.; CMA, POS, Direct ---//
   for (String s: keyset) {
    ACP_Revenue_Growth_Perf__c revenueBilling = revenueGrowthMap.get('Billing-' + s); //fetching the existing records from the above map
    ACP_Revenue_Growth_Perf__c revenueBooking = revenueGrowthMap.get('Booking-' + s);
    // creating a new record if there is no existing record 
    if (revenueBilling == null) {
     system.debug('null billing ---');
     revenueBilling = new ACP_Revenue_Growth_Perf__c();
     revenueBilling.ACP_Refresh_Based_on__c = 'Billing';
     revenueBilling.ACP_Sales_Mode__c = s;
     revenueBilling.ACP_Account_Plan__c = acpid;
     revenueBilling.ACP_Current_Year_to_Date__c = 0;
     revenueBilling.ACP_Past_Year_1_Revenue__c = 0;
    revenueBilling.ACP_Past_Year_to_Date__c = 0;
    revenueBilling.ACP_Past_Year_Revenue__c = 0;
    revenueBilling.ACP_Current_Year_1_Plan__c = 0;
    revenueBilling.ACP_Current_Year_3_Plan__c = 0;
    revenueBilling.ACP_Current_Year_5_Plan__c = 0; 
    }
    else 
    revenueBilling = revGrowth(revenueBilling);
    if (revenueBooking == null) {
     system.debug('null booking---');
     revenueBooking = new ACP_Revenue_Growth_Perf__c();
     revenueBooking.ACP_Refresh_Based_on__c = 'Booking';
     revenueBooking.ACP_Sales_Mode__c = s;
     revenueBooking.ACP_Account_Plan__c = acpid;
     revenueBooking.ACP_Current_Year_to_Date__c = 0;
    revenueBooking.ACP_Past_Year_1_Revenue__c = 0;
    revenueBooking.ACP_Past_Year_to_Date__c = 0;
    revenueBooking.ACP_Past_Year_Revenue__c = 0;
    revenueBooking.ACP_Current_Year_1_Plan__c = 0;
    revenueBooking.ACP_Current_Year_3_Plan__c = 0;
    revenueBooking.ACP_Current_Year_5_Plan__c = 0; 
    }
    else 
    revenueBooking = revGrowth(revenueBooking);
    
    revenueBilling.ACP_Fiscal_Year__c = String.valueOf(fiscalyr);
    revenueBooking.ACP_Fiscal_Year__c = String.valueOf(fiscalyr);

    //Fetching values from reports and storing them in the respective fields.
    if(s != 'Combined')
    {
         if (mapReport1.get(s + '-' + String.valueof(pastyr_1)) != null) {
     LIST < Reports.SummaryValue > summaryValues = mapReport1.get(s + '-' + String.valueof(pastyr_1));
     revenueBilling.ACP_Past_Year_1_Revenue__c = (Decimal) summaryValues[1].getValue();
     revenueBooking.ACP_Past_Year_1_Revenue__c = (Decimal) summaryValues[0].getValue();
    }

    if (mapReport1.get(s + '-' + String.valueof(pastyr)) != null) {
     LIST < Reports.SummaryValue > summaryValues = mapReport1.get(s + '-' + String.valueof(pastyr));
     revenueBilling.ACP_Past_year_Revenue__c = (Decimal) summaryValues[1].getValue();
     revenueBooking.ACP_Past_year_Revenue__c = (Decimal) summaryValues[0].getValue();
    }

    if (mapReport2.get(s + '-' + String.valueof(fiscalyr)) != null) {
     LIST < Reports.SummaryValue > summaryValues = mapReport2.get(s + '-' + String.valueof(fiscalyr));
     revenueBilling.ACP_Current_Year_to_Date__c = (Decimal) summaryValues[1].getValue();
     system.debug('current yr to date -- '+ s + ' value --' + revenueBilling.ACP_Current_Year_to_Date__c);
     revenueBooking.ACP_Current_Year_to_Date__c = (Decimal) summaryValues[0].getValue();
    }

    if (mapReport2.get(s + '-' + String.valueof(pastyr)) != null) {
     LIST < Reports.SummaryValue > summaryValues = mapReport2.get(s + '-' + String.valueof(pastyr));
     revenueBilling.ACP_Past_Year_to_Date__c = (Decimal) summaryValues[1].getValue();
     system.debug('past yr to date -- '+ s + ' value --' + revenueBilling.ACP_Past_Year_to_Date__c);
     revenueBooking.ACP_Past_Year_to_Date__c = (Decimal) summaryValues[0].getValue();

    }
    }
   
    revenueGrowthMap.put('Billing-' + s, revenueBilling);
    revenueGrowthMap.put('Booking-' + s, revenueBooking);


   }
   
     ACP_Revenue_Growth_Perf__c revenueBilling = revenueGrowthMap.get('Billing-Combined');
     revenueBilling = revGrowthTotal(revenueBilling);
     ACP_Revenue_Growth_Perf__c revenueBooking = revenueGrowthMap.get('Booking-Combined');
     revenueBooking = revGrowthTotal(revenueBooking);
  
   
   for (String s: revTypeList) {
       
    ACP_Revenue_Growth_Perf__c revBilling = revenueGrowthMap.get('Billing-' + s);
    ACP_Revenue_Growth_Perf__c revBooking = revenueGrowthMap.get('Booking-' + s);
    
    
    revenueBilling.ACP_Past_Year_1_Revenue__c += revBilling.ACP_Past_Year_1_Revenue__c;
    revenueBilling.ACP_Past_Year_Revenue__c += revBilling.ACP_Past_Year_Revenue__c;
    revenueBilling.ACP_Current_Year_to_Date__c += revBilling.ACP_Current_Year_to_Date__c;
    revenueBilling.ACP_Current_Year_1_Plan__c += revBilling.ACP_Current_Year_1_Plan__c;
    revenueBilling.ACP_Current_Year_3_Plan__c += revBilling.ACP_Current_Year_3_Plan__c;
    revenueBilling.ACP_Current_Year_5_Plan__c += revBilling.ACP_Current_Year_5_Plan__c;
    revenueBilling.ACP_Past_Year_to_Date__c += revBilling.ACP_Past_Year_to_Date__c;

    revenueBooking.ACP_Past_Year_1_Revenue__c += revBooking.ACP_Past_Year_1_Revenue__c;
    revenueBooking.ACP_Past_Year_Revenue__c += revBooking.ACP_Past_Year_Revenue__c;
    revenueBooking.ACP_Current_Year_to_Date__c += revBooking.ACP_Current_Year_to_Date__c;
    revenueBooking.ACP_Current_Year_1_Plan__c += revBooking.ACP_Current_Year_1_Plan__c;
    revenueBooking.ACP_Current_Year_3_Plan__c += revBooking.ACP_Current_Year_3_Plan__c;
    revenueBooking.ACP_Current_Year_5_Plan__c += revBooking.ACP_Current_Year_5_Plan__c;
    revenueBooking.ACP_Past_Year_to_Date__c += revBooking.ACP_Past_Year_to_Date__c;

   }
   
   revenueGrowthMap.put('Billing-Combined', revenueBilling);
   revenueGrowthMap.put('Booking-Combined', revenueBooking);
   upsert revenueGrowthMap.values();
  } catch (Exception e) {
   ErrorLogging.Log(e, 'ACP_Revenue_Growth_Ctrl', 'runReport', acpId);
  }
  return pageRedirectWithDivId('businessPerf');
 }

 public ACP_Revenue_Growth_Perf__c revGrowthTotal(ACP_Revenue_Growth_Perf__c totalRevenue)
 {
    totalRevenue.ACP_Past_Year_1_Revenue__c = 0;
    totalRevenue.ACP_Past_Year_to_Date__c = 0;
    totalRevenue.ACP_Past_Year_Revenue__c = 0;
    totalRevenue.ACP_Current_Year_to_Date__c = 0;
    totalRevenue.ACP_Current_Year_1_Plan__c = 0;
    totalRevenue.ACP_Current_Year_3_Plan__c = 0;
    totalRevenue.ACP_Current_Year_5_Plan__c = 0;
    
     return totalRevenue;
 }
 public ACP_Revenue_Growth_Perf__c revGrowth(ACP_Revenue_Growth_Perf__c totalRevenue)
 {
    totalRevenue.ACP_Past_Year_1_Revenue__c = 0;
    totalRevenue.ACP_Past_Year_to_Date__c = 0;
    totalRevenue.ACP_Past_Year_Revenue__c = 0;
    totalRevenue.ACP_Current_Year_to_Date__c = 0;
    return totalRevenue;
 }
 

 //Method to update records when Update from Reports button is clicked on the VF page
 public void updatePerformance() {
  try {
       update revenueGrowthList;
       runReport();
   
  }
  Catch(Exception e) {
   ErrorLogging.Log(e, 'ACP_Revenue_Growth_Ctrl', 'updatePerformance', acpId);
  }
  
  // return pageRedirectWithDivId('businessPerf');
 }
 
 public pagereference pageRedirectWithDivId(String divId) {
  PageReference savePageRef = new PageReference('/apex/ACP_Performance_Analytics_page?acpId=' + acpId + '#' + divId);
  savePageRef.setRedirect(true);
  return savePageRef;
 }

}