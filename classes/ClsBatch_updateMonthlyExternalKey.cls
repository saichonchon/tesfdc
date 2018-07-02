/**
 * Class to update Monthly_BBB_External_Key__c fields in Monthly BBB by customer records based on Sales_Period__c field.
 *
 @author    Pankaj Raijade
 @created   2016-06-25
 @version   1.0
 @since     37.0 (Force.com ApiVersion)
 *
//Test class :ClsBatch_updateMonthlyExternalKey
//Code coverage :94%
 @changelog
 * 2016-06-25 Pankaj Raijade <Pankaj.raijade@zensar.in>
 * - Created
 */
global class ClsBatch_updateMonthlyExternalKey implements Database.Batchable<sObject>, Database.Stateful
{
    public string strQuery = '';
    public map<string, integer> mapFieldOfsetdays = new map<string, integer>();
    public boolean updateTempKey = true;
    public map<integer, string> mapMonth = new map<integer, string>{
        1 => 'JAN',
        2 => 'FEB',
        3 => 'MAR',
        4 => 'APR',
        5 => 'MAY',
        6 => 'JUN',
        7 => 'JUL',
        8 => 'AUG',
        9 => 'SEP',
        10 => 'OCT',
        11 => 'NOV',
        12 => 'DEC'
    };
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(strQuery != null && strQuery != '')
            return Database.getQueryLocator(strQuery );
        else 
            return null;
    }
    global void execute(Database.BatchableContext BC, List<BBB_Month_Bill_Book_Cust__c> lstSObject)
    {
        for(BBB_Month_Bill_Book_Cust__c oSObj :lstSObject)
        {
            for(string strField :mapFieldOfsetdays.keyset())
            {
                if(oSObj.get(strField) != null)
                {
                    try{
                        oSObj.put(strField, (object)((date)oSObj.get(strField)).addDays(mapFieldOfsetdays.get(strfield)));
                    }catch(exception ex){}
                }
                
            }
            string strDate = oSObj.Sales_Period__c.day() + '-' + mapMonth.get(oSObj.Sales_Period__c.month()) + '-' + (oSObj.Sales_Period__c.year() - 2000);
            string strMonthlyKey = string.valueOf(integer.valueOf(oSObj.Customer__r.TE_Customer_Key_Id__c)) + oSObj.Bill_Type__c + oSObj.SAP_Profit_Center_Code__c + strDate  + oSObj.CURRENCYISOCODE + (oSObj.RESELLER_CUSTOMER__r.TE_Customer_Key_Id__c != null ? string.valueOf(integer.valueOf(oSObj.RESELLER_CUSTOMER__r.TE_Customer_Key_Id__c)): '');
            
            if(oSObj.Monthly_BBB_External_Key__c != strDate )
            {
                if(updateTempKey)
                    oSObj.put('Monthly_BBB_External_Key_temp__c', oSObj.Monthly_BBB_External_Key__c);
                oSObj.Monthly_BBB_External_Key__c = strMonthlyKey ;
            }
             
            system.debug('asdf'+oSObj.id);
        }
        update lstSObject;
    } 
    global void finish(Database.BatchableContext BC)
    { 
    }
}