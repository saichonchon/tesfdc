/**
*  This used for scheduling batch Cls_BatchCalculateForecastBilling_PLM .
*
@author Pankaj Raijade
@created 1/2/2016
@Test Class : clsscheduled_BatchCalcFstBlg_PLM_test
@ coverage  100%
@changelog

*/
global class clsscheduled_BatchCalculateFstBlg_PLM implements Schedulable 
{
    Batch_size_setting__c oBatchsize = Batch_size_setting__c.getInstance('Cls_BatchCalculateForecastBilling_PLM');
    
    global void execute(SchedulableContext sc) 
    {
        if(oBatchsize != null && oBatchsize.Batch_size__c != null && oBatchsize.Batch_size__c > 0)
        {
            Cls_BatchCalculateForecastBilling_PLM oCls_BatchCalculateForecastBilling_PLM = new Cls_BatchCalculateForecastBilling_PLM();
            database.executeBatch(oCls_BatchCalculateForecastBilling_PLM, (Integer)oBatchsize.Batch_size__c);
        }
        else
        {
            Cls_BatchCalculateForecastBilling_PLM oCls_BatchCalculateForecastBilling_PLM = new Cls_BatchCalculateForecastBilling_PLM();
            database.executeBatch(oCls_BatchCalculateForecastBilling_PLM, 15);
        }
    }
}