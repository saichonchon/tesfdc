@isTest
/* -------------------------------------------------------------------------------------
 Test Class Written by Deepak Kumar 16/03/2016
* ------------------------------------------------------------------------------------- */
/*********************************************************************************************************************** 
 Name: INDUpdateLLRfromUserexam_TestClass 
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is used to Cover the test percentage of INDUpdateLRResFromUserExamTriggerClass and trigger INDupdateLLRrecord.  
IND_TrainingParticipantcontroller : test Coverage 80%
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                           
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                16 MAR 2016   Initial Development                                         
***********************************************************************************************************************/ 



private class INDUpdateLLRfromUserexam_TestClass {

    static testMethod void myUnitTest1() {

        Test.startTest();
        
        
        List<recordtype> trainingrecordtype = new List<recordtype>();
        trainingrecordtype=[select id,name,developername from recordtype where isactive=true and SobjectType='training__c'];
        Map<string,id> maprt = new map<string,id>();
        for(recordtype tr:trainingrecordtype)
        {
         maprt.put(tr.developername,tr.id);
        }
       
        L_R_Result_Summary__c LRS =new L_R_Result_Summary__c(Participant_User__c=UserInfo.getUserid(),Salesforce_User_ID__c=UserInfo.getUserid()); 
        insert LRS;
        Training__c trwithdate14 = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Exam_Date_Slots'),Active__c=true,Training_Date_and_Time1__c=datetime.Now()+1,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        insert trwithdate14;
        
        Learning_Response_Result__c lact14= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate14.id,Number_of_time_Attempted_Exam__c=1,TE_Network_ID__c=UserInfo.getUserid(),Status_of_Participant__c='Invited for Training');
        insert lact14; 
         
        spExams__Exam__c relatedexam=[select id,Training__c,spExams__Exam_Question__c,spExams__Passing_Score__c,spExams__Expiration_Date__c,spExams__Exam_Duration__c from spExams__Exam__c where Training__c=:trwithdate14.id limit 1];
         spExams__User_Exam__c examuser =new spExams__User_Exam__c(spExams__Remaining_Time__c=1.10,Learning_Response_Result__c=lact14.id,spExams__Exam__c=relatedexam.id,spExams__First_Name__c='test',spExams__User_Id__c=UserInfo.getUserid(),spExams__Status__c='Pending');  
         insert examuser;       
        
         examuser.spExams__Status__c='Submitted';
         examuser.spExams__Submittion_Date__c=DateTime.now();
         //examuser.spExams__No_of_Correct_Questions__c=-8;
         update examuser;
         
         relatedexam.spExams__Expiration_Date__c=system.today()+30;
         relatedexam.spExams__Passing_Score__c=20;
         relatedexam.spExams__Exam_Question__c=10;
         update relatedexam;
         spExams__Question__c q1= new spExams__Question__c(spExams__Content__c='test',spExams__Type__c='Single Choice');
         insert q1;
         
         spExams__Answer__c a1 = new spExams__Answer__c(spExams__Content__c='test',spExams__IsCorrect__c=true,spExams__Question__c=q1.id);
         insert a1;
       
         spExams__User_Exam_Question__c UEQ= new spExams__User_Exam_Question__c(spExams__User_Exam__c=examuser.id,spExams__Question__c=q1.id,spExams__Is_Correct__c='N');
         insert UEQ; 
         
         spExams__User_Exam_Answer__c UEA= new spExams__User_Exam_Answer__c(spExams__User_Exam_Question__c=UEQ.id,spExams__Answer__c=a1.id,spExams__Free_Text_Content__c='test',spExams__Is_Correct__c='N'); 
         insert UEA;
         
         examuser.spExams__Status__c='Submitted';
         update examuser; 
         
        Test.StopTest();
    }
}