/***********************************************************************************************************************
      Name : Cls_PartActivationExceptionsTest1
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods for classes mentioned below
________________________________________________________________________________________________________________________
 Apex class(es) whose code is covered : Cls_PartActivationExceptions
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER         DATE          DETAIL                                  MERCURY REQUEST #
________________________________________________________________________________________________________________________
     1.0 Shantinath        06/26/2013    Initial Developemnt           
***********************************************************************************************************************/
@isTest(SeeAllData=true)
public class Cls_PartActivationExceptionsTest1 {
    static testMethod void validateError() {
        String vLongString = 'Cloud computing is all the rage. Its become the phrase du jour, '+
                            'says Gartner senior analyst Ben Pring, echoing many of his peers. '+
                            'The problem is that (as with Web 2.0) everyone seems to have a different '+
                            'definition. As a metaphor for the Internet, the cloud is a familiar cliché, '+
                            'but when combined with computing, the meaning gets bigger and fuzzier.  '+
                            'Some analysts and vendors define cloud computing narrowly as an  '+
                            'updated version of utility computing: basically virtual servers  '+
                            'available over the Internet. Others go very broad, arguing  '+
                            'anything you consume outside the firewall is in the cloud,  '+
                            'including conventional outsourcing. ';
       for(Integer i=0; i<10; i++){
           vLongString+=vLongString;
       }
       Part_Activation_Configuration__c vPartConfig = [SELECT Id, 
                                                              Cascade_Schedule__c,
                                                              Conditional_Query__c,
                                                              Cron_Statement__c,
                                                              Current_Object_Number__c,
                                                              Execute_Trigger_Upon_Update__c,
                                                              Max_Number_of_Objects__c,
                                                              Next_Schedule_Run_Date__c,
                                                              Object_API_Name__c,
                                                              Object_Field_API_Name__c,
                                                              Schedule_Deactivation_Batch__c
                                                         FROM Part_Activation_Configuration__c
                                                        LIMIT 1];
       Cls_PartActivationExceptions.UpdateNoteWithStatus('Error', vPartConfig.Object_API_Name__c, vPartConfig.Id);
       Cls_PartActivationExceptions.UpdateNoteWithStatus(vLongString, vPartConfig.Object_API_Name__c, vPartConfig.Id);
    }
}