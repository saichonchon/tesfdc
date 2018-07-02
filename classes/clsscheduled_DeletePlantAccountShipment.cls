/**
*  This class used for scheduling batch class clsBatch_DeletePlantAccountShipment.
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
global class clsscheduled_DeletePlantAccountShipment  implements Schedulable 
{
    Batch_size_setting__c oBatchsize = Batch_size_setting__c.getInstance('clsBatch_DeletePlantAccountShipment');
    
    global void execute(SchedulableContext sc) 
    {
        if(oBatchsize != null && oBatchsize.Batch_size__c != null && oBatchsize.Batch_size__c > 0)
        {
            clsBatch_DeletePlantAccountShipment oclsBatch_DeletePlantAccountShipment = new clsBatch_DeletePlantAccountShipment();
            database.executeBatch(oclsBatch_DeletePlantAccountShipment, (Integer)oBatchsize.Batch_size__c);
        }
        else
        {
            clsBatch_DeletePlantAccountShipment oclsBatch_DeletePlantAccountShipment = new clsBatch_DeletePlantAccountShipment();
            database.executeBatch(oclsBatch_DeletePlantAccountShipment);
        }
    }
}