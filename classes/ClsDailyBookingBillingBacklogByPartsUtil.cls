/**
 *  Util trigger for MonthlyBillingsBookingsbyPart_BI
 *   
 *
 @author    Lili Zhao
 @created   2014-06-11
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-06-11 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created
 */
public with sharing class ClsDailyBookingBillingBacklogByPartsUtil {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
        'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    /**
    * This method is used get account Id from custom setting.
    *
    @author Lili Zhao
    @created 2014-06-11
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-06-11 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */    
    public static void setBbbDayBillBookBklgCustPNYearAndMonth(list<BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> list_bbbDayBillBookBklgCustPNs, Date maxDate, Date minDate, boolean isBatch) {
        
        map<Id, BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c> map_Id_bbbDayBillBookBklgCustPN = new map<Id, BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c>();
        for (Period period : [select Id, FiscalYearSettings.Name, PeriodLabel, StartDate, EndDate from Period 
                                where Type = 'Month' 
                                and StartDate <=: maxDate 
                                and EndDate >=: minDate]) {
                                    
            //list_Periods.add(period);
            for(BBB_Day_Direct_Bill_Book_Bklg_Cust_PN__c bbbDayBillBookBklgCustPN : list_bbbDayBillBookBklgCustPNs) {
                
                if(period.StartDate <= bbbDayBillBookBklgCustPN.Customer_Request_Date__c 
                    && period.EndDate >= bbbDayBillBookBklgCustPN.Customer_Request_Date__c) {
                    
                    if(period.FiscalYearSettings.Name != null){                         
                        bbbDayBillBookBklgCustPN.Customer_Request_Date_Fiscal_Year__c = period.FiscalYearSettings.Name; 
                        map_Id_bbbDayBillBookBklgCustPN.put(bbbDayBillBookBklgCustPN.Id, bbbDayBillBookBklgCustPN);                 
                    }                   
                    if(period.PeriodLabel != null && MAP_MONTHLABELNUMBER.containsKey(period.PeriodLabel)){                         
                        bbbDayBillBookBklgCustPN.Customer_Request_Date_Fiscal_Month__c = MAP_MONTHLABELNUMBER.get(period.PeriodLabel);
                        map_Id_bbbDayBillBookBklgCustPN.put(bbbDayBillBookBklgCustPN.Id, bbbDayBillBookBklgCustPN);                         
                    }                   
                }
            }
        }
        system.debug('map_Id_bbbDayBillBookBklgCustPN::: '+map_Id_bbbDayBillBookBklgCustPN);
        if(map_Id_bbbDayBillBookBklgCustPN.size() > 0 && isBatch) {
            update map_Id_bbbDayBillBookBklgCustPN.values();
        }
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