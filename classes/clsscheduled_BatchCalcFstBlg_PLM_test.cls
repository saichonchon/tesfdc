/**
*  This used as test class for clsscheduled_BatchCalculateFstBlg_PLM .
*
@author Pankaj Raijade
@created 1/2/2016
@changelog

*/
@istest(seeAlldata=false)
public class clsscheduled_BatchCalcFstBlg_PLM_test
{
    static testmethod void clsscheduled_BatchCalculateFstBlg_PLM_TM()
    {
        DateTime currTime = DateTime.now();
        Integer min = currTime.minute();
        Integer hour = currTime.hour();
        String sch;
        
        if(min <= 58)
            sch = '0 '+ (min + 1) + ' ' + hour + ' * * ? '+ currTime.year();
        else          
            sch = '0 0 '+ (hour + 1) + ' * * ? '+ currTime.year();
        clsscheduled_BatchCalculateFstBlg_PLM o = new clsscheduled_BatchCalculateFstBlg_PLM();
        test.starttest();
            System.schedule('cheduled_BatchCalculateFstBlg_PLM' + DateTime.now(), sch,o);
            Batch_size_setting__c oBatchsize = new Batch_size_setting__c(name = 'Cls_BatchCalculateForecastBilling_PLM', Batch_size__c = 100);
            insert oBatchsize;
            o = new clsscheduled_BatchCalculateFstBlg_PLM();
            System.schedule('cheduled_BatchCalculateFstBlg_PLM2' + DateTime.now(), sch,o);    
        test.stoptest();
    }
}