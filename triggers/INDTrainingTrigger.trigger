trigger INDTrainingTrigger on Training__c (Before insert,after insert,before update,after update) {


/*********************************************************************************************************************** 
 Name: INDTrainingTrigger
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This Trigger is fired on Training object and used to call the class for Creating exam and calling cancle email class.                                        
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/ 


//****************************************************** Email Invite******************************************************************************************************************************************
 
 if(trigger.isbefore && trigger.isinsert)
  {
   for(Training__c trr:trigger.new)
   {
    trr.Slot_1_Outlook_UID__c= '3ab45645602asafds985908asdkasd'+ String.valueOf(Crypto.getRandomLong()); //Crypto.generateAesKey(128);
    trr.Slot_2_Outlook_UID__c= '4ikaseyr8wksadhf8a7y9wayriashd0'+String.valueOf(Crypto.getRandomLong());
    trr.Slot_3_Outlook_UID__c= '5nvs98aslfs89sfs4wwfs4ff4g'+String.valueOf(Crypto.getRandomLong());
    trr.Slot_4_Outlook_UID__c= '6adahd8oahfo4439hfdsa9yasdf9'+String.valueOf(Crypto.getRandomLong());
    trr.Slot_5_Outlook_UID__c= '6hdf9s08y7682nksd98455'+String.valueOf(Crypto.getRandomLong());
    trr.Slot_6_Outlook_UID__c= '7hafio7y4ohoas9yhas9yas7has9'+String.valueOf(Crypto.getRandomLong());  
  
  }
 } 
  if(trigger.isafter && trigger.isinsert)
  {
   
        
        List<spExams__Exam__c> listexam=new List<spExams__Exam__c>();

       //recordtype trainingrecordtype; //=[select id,name,developername from recordtype where isactive=true and id=:displaytraining[0].RecordTypeid]; 
     for(Training__c trr:trigger.new)
      {
       Map<id,recordtype> trainingrecordtype = new Map<id,recordtype>([select id,name,developername from recordtype where isactive=true and id=:trr.recordtypeid]); 
       if(trainingrecordtype.get(trr.recordtypeid).DeveloperName=='Training_with_Response_Exam_without_Date_Slots' || trainingrecordtype.get(trr.recordtypeid).DeveloperName=='Training_with_Response_Exam_Date_Slots')
           {
               spExams__Exam__c exam=new spExams__Exam__c();
               exam.Training__c=trr.id;
               exam.spExams__Admin__c=trr.Ownerid;
               exam.spExams__Expiration_Date__c=trr.Date_of_Training__c;
               exam.spExams__Title__c=trr.Name;
               exam.spExams__Exam_Duration__c=(trr.Duration_of_Exam_in_Minutes__c*60);
           listexam.add(exam);
          
           }   
      
     }
     insert listexam;
  }
 
 if(trigger.isafter && trigger.isupdate)
 {
   for(Training__c trr1:trigger.new)
  {
  if(trr1.Cancel_Slot_1__c==true || trr1.Cancel_Slot_2__c==true || trr1.Cancel_Slot_3__c==true ||trr1.Cancel_Slot_4__c==true || trr1.Cancel_Slot_5__c==true || trr1.Cancel_Slot_6__c==true)    
  {
  INDCancleOutlookInviteTriggerClass.initMethod(trr1.id);}
  }  
 }

//****************************************************** Email Invite******************************************************************************************************************************************
  

}