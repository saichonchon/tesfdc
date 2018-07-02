global class ClsScheduled_oppPartPropToSales implements Schedulable{
	global void execute(SchedulableContext sc) {
      	ClsBatch_oppPartProposalToSales batch = new ClsBatch_oppPartProposalToSales(); 
 	 	database.executebatch(batch);
   	}
}