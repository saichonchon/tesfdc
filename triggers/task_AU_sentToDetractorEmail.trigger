/** 
*    trigger to sent Detractor Email
*
@author lili zhao
@created 2014-10-08 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2014-10-08 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
trigger task_AU_sentToDetractorEmail on Task (after update) {
    
    set<String> set_contactIds = new set<String>();
    map<String, Task> map_Id_task = new map<String, Task>();
    
        
    for(Task task: trigger.new){
        if(task.Status != 'Completed' && task.Detraction_Reason__c != null && task.Detraction_Reason__c != trigger.oldMap.get(task.Id).Detraction_Reason__c){
            set_contactIds.add(task.whoId);  
            map_Id_task.put(task.Id, task);        
        }
    }
    // the method to set the Detractor Email and sent it
    if(map_Id_task.size() > 0) {
        ClsCampaignMemberUtil.sentDetractorEmail(map_Id_task, set_contactIds);
    }
           
}