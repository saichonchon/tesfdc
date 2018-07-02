/**
 * Class to update fiscal Year, Fiscal month fields based on Period object in Monthly BBB by customer records based on Sales_Period__c field.
 *
 @author    Pankaj Raijade
 @created   2016-06-25
 @version   1.0
 @since     37.0 (Force.com ApiVersion)
 *
//Test class :ClsBatch_fixFiscalMonthYearQuarter_Test
//COde coverage : 94%
 @changelog
 * 2016-06-25 Pankaj Raijade <Pankaj.raijade@zensar.in>
 * - Created
 */
global class ClsBatch_fixFiscalMonthYearQuarter implements Database.Batchable<sObject>, Database.Stateful
{

    public string strQuery = '';
    public map<string, integer> mapFieldOfsetdays = new map<string, integer>();
    public string strControllingfield;
    public string strFiscalMonthfield;
    public string strFiscalQuarterfield;
    public string strFiscalYearfield;
    public date periodStartdate;
    public date periodEnddate;
    public map<date, period> mapDatePeriodYear = new map<date, period>();
    public map<date, period> mapDatePeriodQuarter = new map<date, period>();
    public map<date, period> mapDatePeriodMonth = new map<date, period>();
    public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4, 'Feb' => 5, 'Mar' => 6, 'Apr' => 7, 'May' => 8, 'Jun' => 9,
        'Jul' => 10, 'Aug' => 11, 'Sep' => 12, 'Oct' => 1, 'Nov' => 2, 'Dec' => 3
    };
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        set<string> setType = new set<string>();
        
        if(strFiscalMonthfield != null && strFiscalMonthfield != '')
            setType.add('Month');
        if(strFiscalQuarterfield != null && strFiscalQuarterfield != '')
            setType.add('Quarter');
        if(strFiscalYearfield != null && strFiscalYearfield != '')
            setType.add('Year');
                        
        list<period> LstPeriod = database.query(' select ID, FISCALYEARSETTINGSID, FiscalYearSettings.name, TYPE, STARTDATE, ENDDATE, QUARTERLABEL, PERIODLABEL, NUMBER from period where Type in : setType and startdate >= :periodStartdate and enddate <= :periodenddate');
        for(period oPeriod :lstPeriod)
        {
            if(oPeriod.Type == 'Month')
                updateDatePeriodmap(oPeriod ,mapDatePeriodMonth);
            if(oPeriod.Type == 'Quarter')
                updateDatePeriodmap(oPeriod ,mapDatePeriodQuarter);
            if(oPeriod.Type == 'Year')
                updateDatePeriodmap(oPeriod ,mapDatePeriodYear);
        }
        if(strQuery != null && strQuery != '')
            return Database.getQueryLocator(strQuery );
        else 
            return null;
    }
    public void updateDatePeriodmap(Period oPeriod, map<date, period> mapDatePeriod)
    {
        date dDay = oPeriod.startDate;
        while(dDay <= oPeriod.endDate)
        {
            mapDatePeriod.put(dDay, oPeriod);
            dDay = dDay.addDays(1);
        }
    }
    global void execute(Database.BatchableContext BC, List<sObject> lstSObject)
    {
        list<sObject> lstSObjectUpdate = new list<sObject>();
        for(sObject oSObj :lstSObject)
        {
            boolean isObjectUpdate = false;
            Object ControllingDate = oSObj.get(strControllingfield);
            if(ControllingDate != null)
            {
                if(strFiscalMonthfield != null && strFiscalMonthfield != '')
                {
                    if(mapDatePeriodMonth.containsKey((date)ControllingDate))
                    {
                        Object ActualFieldValue = oSObj.get(strFiscalMonthfield);
                        string PERIODLABEL = mapDatePeriodMonth.get((date)ControllingDate).PERIODLABEL;

                        if(integer.valueOf(ActualFieldValue) != integer.valueOf(MAP_MONTHLABELNUMBER.get(PERIODLABEL)))
                        {
                            oSObj.put(strFiscalMonthfield, integer.valueOf(MAP_MONTHLABELNUMBER.get(PERIODLABEL)));
                            isObjectUpdate = true;
                        }
                    }
                }
                if(strFiscalYearfield != null && strFiscalYearfield != '')
                {
                    if(mapDatePeriodYear.containsKey((date)ControllingDate))
                    {
                        Object ActualFieldValue = oSObj.get(strFiscalYearfield );
                         string PERIODLABEL = mapDatePeriodYear.get((date)ControllingDate).FiscalYearSettings.name;
                        if(string.valueOf(ActualFieldValue) != PERIODLABEL )
                        {
                            oSObj.put(strFiscalYearfield , PERIODLABEL);
                            isObjectUpdate = true;
                        }
                    }
                }
            }
           
            
            if(isObjectUpdate)
                lstSObjectUpdate.add(oSObj);
        }
        if(lstSObjectUpdate .size() > 0)
            update lstSObjectUpdate;
    }
    global void finish(Database.BatchableContext BC)
    { 
    }
}