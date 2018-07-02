/**
*  This used as test class for clsscheduled_BatchCalculateFstBlg .
*
@author Pankaj Raijade
@created 1/2/2016
@changelog

*/
@istest(seeAlldata=false)
public class clsscheduled_BatchCalcFstBlg_test
{
    static testmethod void clsscheduled_BatchCalculateFstBlg_TM()
    {
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        clsscheduled_BatchCalculateFstBlg o = new clsscheduled_BatchCalculateFstBlg();
        test.starttest();
            System.schedule('cheduled_BatchCalculateFstBlg' + DateTime.now(), sch,o);
            Batch_size_setting__c oBatchsize = new Batch_size_setting__c(name = 'Cls_BatchCalculateForecastBilling', Batch_size__c = 100);
            insert oBatchsize;
            o = new clsscheduled_BatchCalculateFstBlg();
            System.schedule('cheduled_BatchCalculateFstBlg2' + DateTime.now(), sch,o);    
        test.stoptest();
    }
}