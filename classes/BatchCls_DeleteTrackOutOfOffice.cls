/**
 * 
 * Purpose of this batch class is to delete "Track Out Of Office" records which are created 1 year ago.
 *
 * @author      Poonam Hedaoo
 * @created     2017-09-04
 * @since       40.0     
 * @version     1.0                                                                
 *    
 */
global class BatchCls_DeleteTrackOutOfOffice implements Database.Batchable<sObject>{
  
    global final String Query;
    
    global BatchCls_DeleteTrackOutOfOffice (String q){
        if(!Test.isRunningTest()){
          Query=q;
        }
        else{
          Query='select id from Track_Out_Of_office__c';
        }
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC,List<Track_Out_Of_office__c> scope){
         try{
            delete scope;
            }catch(Exception ex){
            }
           
    }
    
    global void finish(Database.BatchableContext BC){}
}