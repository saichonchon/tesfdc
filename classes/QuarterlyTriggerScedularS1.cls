/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 *  This Scheduled Class Initiates the Process of Batch Class to Update the Average Cost and Margin Values on Opportunity Part.
 * @author      Chiranjeevi Neelam
 * @created     2013-09-07  
 * @Modifed     2014-08-04 by Nooreen Shaikh - Updated to copy values on Opp Part fields quarterly 
 * @Modified    2015-04-07 by Nooreen Shaikh - Updated Query                                                         
 ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */

/*--Global Schedulable Class Starts Here--*/
global class QuarterlyTriggerScedularS1 implements Schedulable {
 
    global void execute(SchedulableContext sc) {          
      UpdateYBBPartsVsOpptyPartB1 B1=new UpdateYBBPartsVsOpptyPartB1();
      B1.QueryString = 'Select Id from Part__c' ;
      ID batchprocessid = Database.executeBatch(B1,25);   
    }   
}/*--Global  Schedulable Class Ends Here--*/