/**
*  call the batch class ClsBatch_captureBillingWhenPartConverted 
*
@author Yimin Zheng
@created 2016-02-02
*
@changelog
coverage

2016-2-2 Yimin Zheng<yimin.zheng@te.com>
* - Created
*/
global class ClsSchedule_captureBillWhenPartConverted implements Schedulable{  

    global void execute(SchedulableContext sc) {
       ClsBatch_captureBillingWhenPartConverted convertedBatch = new ClsBatch_captureBillingWhenPartConverted();
       Database.executeBatch(convertedBatch,10);
    }
}