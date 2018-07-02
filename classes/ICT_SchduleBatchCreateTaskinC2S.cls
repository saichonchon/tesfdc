global class ICT_SchduleBatchCreateTaskinC2S implements Schedulable {

   global void execute(SchedulableContext ctx) {
      ICT_CreateTaskInC2S p = new ICT_CreateTaskInC2S ();
        database.executeBatch(p,20);
        
       
       
   }   
}