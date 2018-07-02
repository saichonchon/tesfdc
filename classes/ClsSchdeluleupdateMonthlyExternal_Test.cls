/**
 * Test class for :ClsSchdeluleupdateMonthlyExternalKey
 *
 @author    Pankaj Raijade
 @created   2016-06-25
 @version   1.0
 @since     37.0 (Force.com ApiVersion)
 *
 @changelog
 * 2016-06-25 Pankaj Raijade <Pankaj.raijade@zensar.in>
 * - Created
 */
@istest(seeAlldata=false)
public class ClsSchdeluleupdateMonthlyExternal_Test
{
    Public static testmethod void ClsSchdeluleupdateMonthlyExternal_UT()
    {
         test.starttest();
            ClsSchdeluleupdateMonthlyExternalKey o = new ClsSchdeluleupdateMonthlyExternalKey();
            o.strquery = 'select id, sales_Period__c from BBB_Month_Bill_Book_Cust__c ';
            o.mapFieldOfsetdays = new map<string, integer>{'sales_Period__c' => 7};
            o.batchSize = 200;
            system.schedule('Test check ClsSchdeluleupdateM', '0 0 23 * * ?', o);
        test.stoptest();
    }

}