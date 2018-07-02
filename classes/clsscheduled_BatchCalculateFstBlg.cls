/**
*  This used scheduling batch Cls_BatchCalculateForecastBilling.
*
@author Pankaj Raijade
@created 1/2/2016
@Test Class : clsscheduled_BatchCalcFstBlg_test
@ coverage  100%
@changelog

*/
global class clsscheduled_BatchCalculateFstBlg implements Schedulable 
{
    Batch_size_setting__c oBatchsize = Batch_size_setting__c.getInstance('Cls_BatchCalculateForecastBilling');
    
    global void execute(SchedulableContext sc) 
    {
        if(oBatchsize != null && oBatchsize.Batch_size__c != null && oBatchsize.Batch_size__c > 0)
        {
            Cls_BatchCalculateForecastBilling oCls_BatchCalculateForecastBilling = new Cls_BatchCalculateForecastBilling();
            database.executeBatch(oCls_BatchCalculateForecastBilling, (Integer)oBatchsize.Batch_size__c);
        }
        else
        {
            Cls_BatchCalculateForecastBilling oCls_BatchCalculateForecastBilling = new Cls_BatchCalculateForecastBilling();
            database.executeBatch(oCls_BatchCalculateForecastBilling, 25);
        }
    }
}