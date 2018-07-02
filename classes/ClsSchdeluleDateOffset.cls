/**
 * Class to to schedule ClsBatchDateOffset batch.
 *
 @author    Pankaj Raijade
 @created   2016-06-25
 @version   1.0
 @since     37.0 (Force.com ApiVersion)
 *
//Test class: ClsSchdeluleDateOffset_Test
//code coverage 100%
 @changelog
 * 2016-06-25 Pankaj Raijade <Pankaj.raijade@zensar.in>
 * - Created
 */
global class ClsSchdeluleDateOffset Implements Schedulable
{
    public string strQuery = '';
    public map<string, integer> mapFieldOfsetdays = new map<string, integer>();
    public integer batchSize;
    global void execute(SchedulableContext sc)
    {
        ClsBatchDateOffset o = new ClsBatchDateOffset();
        o.strquery = strquery ;
        o.mapFieldOfsetdays = mapFieldOfsetdays;
        database.executeBatch(o, batchSize);
    }

}