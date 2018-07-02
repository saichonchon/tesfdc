@isTest
/* -------------------------------------------------------------------------------------
 Test Class Written by Deepak Kumar 04/12/2015
* ------------------------------------------------------------------------------------- */
/*********************************************************************************************************************** 
 Name: INDTrainingSendmail_TestClass
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is used to Cover the test percentage of all the classes and trigger used for sending MAil.   

INDSendOutlookInviteTriggerClass :test Coverage 100%
INDCancleOutlookInviteTriggerClass :test Coverage 98%
INDSendEmailwithICSAttachment :test Coverage 97%
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/ 



private class INDTrainingSendmail_TestClass {

    static testMethod void myUnitTest1() {
   

        test.startTest();
        Set<ID> ids = new Set<ID>();
        List<recordtype> trainingrecordtype = new List<recordtype>();
        trainingrecordtype=[select id,name,developername from recordtype where isactive=true and SobjectType='training__c'];
        Map<string,id> maprt = new map<string,id>();
        for(recordtype tr:trainingrecordtype)
        {
         maprt.put(tr.developername,tr.id);
        }
        List<Training__c> templisttrr = new List<Training__c>();
        List<Learning_Response_Result__c> templistlrr = new List<Learning_Response_Result__c>();
        
        
        Training__c trwithdate1 = new training__c(name='testtrainig',Body_of_Outlook_Invite_Mail__c='abcdef',Email_of_Trainner__c='def@fdc.com',recordtypeid=maprt.get('Training_with_Response_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        User currentUser=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:UserInfo.getUserid() AND isactive=true limit 1];
        L_R_Result_Summary__c LRS =new L_R_Result_Summary__c(Participant_User__c=currentUser.id,Salesforce_User_ID__c=currentUser.id); 
        insert LRS;
        
        trwithdate1.Training_Date_and_Time1__c=System.Now()+1;
        trwithdate1.Training_Date_and_Time2__c=System.Now()+2;
        trwithdate1.Training_Date_and_Time3__c=System.Now()+3;
        trwithdate1.Training_Date_and_Time4__c=System.Now()+4;
        trwithdate1.Training_Date_and_Time5__c=System.Now()+5;
        trwithdate1.Training_Date_and_Time6__c=System.Now()+6;
        
        
        templisttrr.add(trwithdate1);
        
        Training__c trwithdate2 = new training__c(name='testtrainig',Duration_of_Training__c='1 Hour',Body_of_Outlook_Invite_Mail__c='abcdef',Email_of_Trainner__c='def@fdc.com',recordtypeid=maprt.get('Training_with_Response_Exam_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        trwithdate2.Training_Date_and_Time1__c=system.Now()+1;
        trwithdate2.Training_Date_and_Time2__c=System.Now()+2;
        trwithdate2.Training_Date_and_Time3__c=System.Now()+3;
        trwithdate2.Training_Date_and_Time4__c=System.Now()+4;
        trwithdate2.Training_Date_and_Time5__c=System.Now()+5;
        trwithdate2.Training_Date_and_Time6__c=System.Now()+6;
        trwithdate2.Slot_1_Outlook_UID__c='afsaoodfhiahsidfhihasihdfhasdidfh8934725423';
                
        
        templisttrr.add(trwithdate2);
        
        
        
        insert templisttrr;
        
        
        
        Learning_Response_Result__c lact1= new Learning_Response_Result__c(Number_of_time_Attempted_Exam__c=1,Result_Summary__c=LRS.id,training__c=trwithdate1.id,TE_Network_ID__c=currentUser.Te_Network_Id__c,
                                             Date_Time_Selected_by_User_Slot1__c=datetime.Now(),Date_Time_Selected_by_User_Slot2__c=datetime.Now(),Date_Time_Selected_by_User_Slot3__c=datetime.Now(),Email_of_Participant__c='abc@cde.com');
        templistlrr.add(lact1);
        Learning_Response_Result__c lact2= new Learning_Response_Result__c(Number_of_time_Attempted_Exam__c=1,Result_Summary__c=LRS.id,training__c=trwithdate1.id,TE_Network_ID__c=currentUser.Te_Network_Id__c,Email_of_Participant__c='abc@cde.com',Date_Time_Selected_by_User_Slot5__c=datetime.Now(),Date_Time_Selected_by_User_Slot4__c=datetime.Now(),Date_Time_Selected_by_User_Slot6__c=datetime.Now());
        templistlrr.add(lact2);
        
        Learning_Response_Result__c lact3= new Learning_Response_Result__c(Name_of_Participant__c='test',Number_of_time_Attempted_Exam__c=1,Result_Summary__c=LRS.id,training__c=trwithdate2.id,TE_Network_ID__c=currentUser.Te_Network_Id__c,
                                             Date_Time_Selected_by_User_Slot1__c=datetime.Now(),Date_Time_Selected_by_User_Slot2__c=datetime.Now(),Date_Time_Selected_by_User_Slot3__c=datetime.Now(),Email_of_Participant__c='abc@cde.com');
        templistlrr.add(lact3);
        Learning_Response_Result__c lact4= new Learning_Response_Result__c(Name_of_Participant__c='test',Number_of_time_Attempted_Exam__c=1,Result_Summary__c=LRS.id,training__c=trwithdate2.id,TE_Network_ID__c=currentUser.Te_Network_Id__c,Email_of_Participant__c='abc@cde.com',Date_Time_Selected_by_User_Slot5__c=datetime.Now(),Date_Time_Selected_by_User_Slot4__c=datetime.Now(),Date_Time_Selected_by_User_Slot6__c=datetime.Now());
        templistlrr.add(lact4);
        
        
        insert templistlrr;
        ids.add(lact1.id);
        ids.add(lact2.id);
        
        //INDSendOutlookInviteTriggerClass controller1 =new INDSendOutlookInviteTriggerClass();
        templistlrr.clear();
        templistlrr.add(lact1);
        INDSendOutlookInviteTriggerClass.initMethod(ids,templistlrr);
        templistlrr.clear();
        templistlrr.add(lact2);
        INDSendOutlookInviteTriggerClass.initMethod(ids,templistlrr);
        
        trwithdate2.Cancel_Slot_1__c=true;
        trwithdate2.Cancel_Slot_2__c=true;
        trwithdate2.Cancel_Slot_3__c=true;
        trwithdate2.Cancel_Slot_4__c=true;
        trwithdate2.Cancel_Slot_5__c=true;
        trwithdate2.Cancel_Slot_6__c=true;
        update trwithdate2;
        
        Test.StopTest();
   }
   
}