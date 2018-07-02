/**
*  This class used for scheduling batch class clsBatch_UpdateAccountShipping.
*
@author Pankaj Raijade
@created 4/2/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  93%
* 
* 
4/2/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
*/
global class clsscheduled_UpdateAccountShipping implements Schedulable 
{
    Batch_size_setting__c oBatchsize = Batch_size_setting__c.getInstance('clsBatch_UpdateAccountShipping');
    
    global void execute(SchedulableContext sc) 
    {
        if(oBatchsize != null && oBatchsize.Batch_size__c != null && oBatchsize.Batch_size__c > 0)
        {
            clsBatch_UpdateAccountShipping oclsBatch_UpdateAccountShipping = new clsBatch_UpdateAccountShipping();
            database.executeBatch(oclsBatch_UpdateAccountShipping, (Integer)oBatchsize.Batch_size__c);
        }
        else
        {
            clsBatch_UpdateAccountShipping oclsBatch_UpdateAccountShipping = new clsBatch_UpdateAccountShipping();
            database.executeBatch(oclsBatch_UpdateAccountShipping );
        }
    }
}