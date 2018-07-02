/**
 * Class to to schedule ClsBatch_updateMonthlyExternalKey batch.
 *
 @author    Pankaj Raijade
 @created   2016-06-25
 @version   1.0
 @since     37.0 (Force.com ApiVersion)
 *
//Test class :ClsSchdeluleupdateMonthlyExternal_Test
//Code coverage 100%
 @changelog
 * 2016-06-25 Pankaj Raijade <Pankaj.raijade@zensar.in>
 * - Created
 */
global class ClsSchdeluleupdateMonthlyExternalKey Implements Schedulable
    {
        public string strQuery = '';
        public map<string, integer> mapFieldOfsetdays = new map<string, integer>();
        public integer batchSize;
        global void execute(SchedulableContext sc)
        {
            ClsBatch_updateMonthlyExternalKey o = new ClsBatch_updateMonthlyExternalKey();
            o.strquery = strQuery;
            o.mapFieldOfsetdays = mapFieldOfsetdays;
            database.executeBatch(o, 200);
        }

    }