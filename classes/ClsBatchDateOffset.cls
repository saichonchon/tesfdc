/**
 * Class to move date forward or backward.
 *
 @author    Pankaj Raijade
 @created   2016-06-25
 @version   1.0
 @since     37.0 (Force.com ApiVersion)
 *
 //Test class: ClsSchdeluleDateOffset_Test
 //code coverage 88%
 @changelog
 * 2016-06-25 Pankaj Raijade <Pankaj.raijade@zensar.in>
 * - Created
 */
global class ClsBatchDateOffset implements Database.Batchable<sObject>, Database.Stateful
{
    public string strQuery = '';
    public map<string, integer> mapFieldOfsetdays = new map<string, integer>();
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(strQuery != null && strQuery != '')
            return Database.getQueryLocator(strQuery );
        else 
            return null;
    }
    global void execute(Database.BatchableContext BC, List<sobject> lstSObject)
    {
        for(sobject oSObj :lstSObject)
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
        }
        update lstSObject;
    }
    global void finish(Database.BatchableContext BC)
    { 
    }
}