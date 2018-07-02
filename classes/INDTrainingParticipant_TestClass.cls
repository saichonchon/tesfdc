@isTest
/* -------------------------------------------------------------------------------------
 Test Class Written by Deepak Kumar 04/12/2015
* ------------------------------------------------------------------------------------- */
/*********************************************************************************************************************** 
 Name: INDTrainingParticipant_TestClass
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is used to Cover the test percentage of all the classes related to invite participant visulaforce page controller.  
IND_TrainingParticipantcontroller : test Coverage 88%
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/ 



private class INDTrainingParticipant_TestClass {

   
   
        
   
   
    static testMethod void myUnitTest1() {

        test.startTest();
        
 //***********Start of Test class for IND_TrainingParticipantcontroller Class **********************************************************************************************************************       
         List<recordtype> trainingrecordtype = new List<recordtype>();
        
         Map<string,id> maprt = new map<string,id>();
         trainingrecordtype=[select id,name,developername from recordtype where isactive=true and SobjectType='training__c'];
         for(recordtype tr:trainingrecordtype)
        {
         maprt.put(tr.developername,tr.id);
        }
        
        
        List<Training__c> templisttrr = new List<Training__c>();
        List<Learning_Response_Result__c> templistlrr = new List<Learning_Response_Result__c>();
        
        
        
        Training__c trwithdate1 = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        
        User currentUser=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:UserInfo.getUserid() AND isactive=true limit 1];
        User ownerUser=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:'005E00000017OYx' AND isactive=true limit 1];
      
        L_R_Result_Summary__c LRS =new L_R_Result_Summary__c(Participant_User__c=currentUser.id,Salesforce_User_ID__c=currentUser.id); 
        insert LRS;
        
        trwithdate1.Training_Date_and_Time1__c=datetime.Now()+1;
        trwithdate1.Training_Date_and_Time2__c=datetime.Now()+2;
        trwithdate1.Training_Date_and_Time3__c=datetime.Now()+3;
        trwithdate1.Training_Date_and_Time4__c=datetime.Now()+4;
        trwithdate1.Training_Date_and_Time5__c=datetime.Now()+5;
        trwithdate1.Training_Date_and_Time6__c=datetime.Now()+6;
        trwithdate1.User_Selected_Date_Time_Option_1__c=false;
        trwithdate1.User_Selected_Date_Time_Option_2__c=false;
        trwithdate1.User_Selected_Date_Time_Option_3__c=false;
        trwithdate1.User_Selected_Date_Time_Option_4__c=false;
        trwithdate1.User_Selected_Date_Time_Option_5__c=false;
        trwithdate1.User_Selected_Date_Time_Option_6__c=true;
        trwithdate1.Admin_flag_training_is_closed__c=false;
        trwithdate1.Admin_flag_User_register__c =true;
           trwithdate1.ownerid=ownerUser.id;
        templisttrr.add(trwithdate1);
       
        Training__c trwithdate8 = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_without_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        templisttrr.add(trwithdate8);
        Training__c trwithdate14 = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Exam_Date_Slots'),Active__c=true,Training_Date_and_Time1__c=datetime.Now()+1,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        templisttrr.add(trwithdate14);
        Training__c trwithdate2 = new training__c(ownerid='005E0000000Xqvg',name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        trwithdate2.Training_Date_and_Time1__c=datetime.Now()+1;
        trwithdate2.User_Selected_Date_Time_Option_1__c=true;
        templisttrr.add(trwithdate2);
        Training__c trwithdate3 = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        trwithdate3.Training_Date_and_Time2__c=datetime.Now()+2;
        trwithdate3.User_Selected_Date_Time_Option_2__c=true;
        templisttrr.add(trwithdate3);
        Training__c trwithdate4 = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50,ownerid=ownerUser.id);
        trwithdate4.Training_Date_and_Time3__c=datetime.Now()+1;
        trwithdate4.User_Selected_Date_Time_Option_3__c=true;
        templisttrr.add(trwithdate4);
        Training__c trwithdate5 = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50,ownerid=ownerUser.id);
        trwithdate5.Training_Date_and_Time4__c=datetime.Now()+1;
        trwithdate5.User_Selected_Date_Time_Option_4__c=true;        
        templisttrr.add(trwithdate5);
        
        insert templisttrr;
            
        Learning_Response_Result__c lact1= new Learning_Response_Result__c(Date_Time_Selected_by_User_Slot1__c=datetime.Now(),Number_of_time_Attempted_Exam__c=1,Result_Summary__c=LRS.id,training__c=trwithdate1.id,TE_Network_ID__c=currentUser.Te_Network_Id__c);
        templistlrr.add(lact1);
        
        Learning_Response_Result__c lact8= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate8.id,Number_of_time_Attempted_Exam__c=2,TE_Network_ID__c=currentUser.Te_Network_Id__c,Status_of_Participant__c='Invited for Training');
        templistlrr.add(lact8);
        Learning_Response_Result__c lact14= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate14.id,Number_of_time_Attempted_Exam__c=1,TE_Network_ID__c=currentUser.Te_Network_Id__c,Status_of_Participant__c='Invited for Training');
        templistlrr.add(lact14); 
        Learning_Response_Result__c lact2= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate2.id,TE_Network_ID__c=currentUser.Te_Network_Id__c);
        templistlrr.add(lact2);
        Learning_Response_Result__c lact3= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate3.id,TE_Network_ID__c=currentUser.Te_Network_Id__c);
        templistlrr.add(lact3);
        Learning_Response_Result__c lact4= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate4.id,TE_Network_ID__c=currentUser.Te_Network_Id__c);
        templistlrr.add(lact4);
        Learning_Response_Result__c lact5= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate5.id,TE_Network_ID__c=currentUser.Te_Network_Id__c,Date_Time_Selected_by_User_Slot4__c=datetime.Now());
        templistlrr.add(lact5);
        
        insert templistlrr;
        spExams__Exam__c relatedexam=[select id,Training__c,spExams__Exam_Duration__c from spExams__Exam__c where Training__c=:trwithdate14.id limit 1];
        spExams__User_Exam__c examuser =new spExams__User_Exam__c(spExams__Remaining_Time__c=1.10,Learning_Response_Result__c=lact14.id,spExams__Exam__c=relatedexam.id,spExams__First_Name__c='test',spExams__User_Id__c=currentUser.id,spExams__Status__c='Pending');  
         insert examuser;       
       
        
 //*****************************Test Class for   IND_PageReferenceLanding_Pagecontroller***********************************************************************
       
        PageReference pageRef10 = Page.IND_Training_PageReferenceLanding_Page;
        pageRef10.getParameters().put('id', String.valueOf(trwithdate1.Id));
        test.setCurrentPage(pageRef10);
        ApexPages.StandardController str10= new ApexPages.StandardController(trwithdate1);
        IND_PageReferenceLanding_Pagecontroller PageRefClass = new IND_PageReferenceLanding_Pagecontroller(str10);
        
        PageRefClass.ExamPage();
 //*****************************Test Class for   IND_PageReferenceLanding_Pagecontroller***********************************************************************
        
        PageReference pageRef8 = Page.IND_Training_InviteLanding_Page;
        pageRef8.getParameters().put('id', String.valueOf(trwithdate8.Id));
        test.setCurrentPage(pageRef8);
        ApexPages.StandardController str8= new ApexPages.StandardController(trwithdate8);
        IND_TrainingParticipantcontroller partiClass8 = new IND_TrainingParticipantcontroller(str8); 
         
        partiClass8.Trainingslide1();
        
        PageReference pageRef110 = Page.IND_Training_PageReferenceLanding_Page;
        pageRef10.getParameters().put('id', String.valueOf(trwithdate8.Id));
        test.setCurrentPage(pageRef110);
        ApexPages.StandardController str110= new ApexPages.StandardController(trwithdate8);
        IND_PageReferenceLanding_Pagecontroller PageRefClass11 = new IND_PageReferenceLanding_Pagecontroller(str110);
         PageRefClass11.ExamPage();
 //*****************************Test Class for   IND_PageReferenceLanding_Pagecontroller***********************************************************************
       
        PageReference pageRef11 = Page.IND_Training_PageReferenceLanding_Page;
        pageRef11.getParameters().put('id', String.valueOf(trwithdate14.Id));
        test.setCurrentPage(pageRef11);
        ApexPages.StandardController str11= new ApexPages.StandardController(trwithdate14);
        IND_PageReferenceLanding_Pagecontroller PageRefClass1 = new IND_PageReferenceLanding_Pagecontroller(str11);
        
        PageRefClass1.ExamPage();
 //*****************************Test Class for   IND_PageReferenceLanding_Pagecontroller***********************************************************************
      
        
 //***********End of Test class for IND_TrainingParticipantcontroller Class **********************************************************************************************************************       
         
        
  //***********start of Test class for INDsendOutlookInvite trigger **********************************************************************************************************************       
        
        
       
       
      
//*********** for INDsendOutlookInvite trigger **********************************************************************************************************************       
      Test.StopTest();
     }
    
    
    static testMethod void myUnitTest2() {

     Test.startTest();
     List<recordtype> trainingrecordtype = new List<recordtype>();
        
         Map<string,id> maprt = new map<string,id>();
         trainingrecordtype=[select id,name,developername from recordtype where isactive=true and SobjectType='training__c'];
         for(recordtype tr:trainingrecordtype)
        {
         maprt.put(tr.developername,tr.id);
        }
      Training__c trwithdate1 = new training__c(Training_Date_and_Time1__c=datetime.Now()+1,name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Exam_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);  
       
        L_R_Result_Summary__c LRS =new L_R_Result_Summary__c(Participant_User__c=UserInfo.getUserid(),Salesforce_User_ID__c=UserInfo.getUserid()); 
        insert LRS;
        User currentUser=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:UserInfo.getUserid() AND isactive=true limit 1];
        
        trwithdate1.Training_Date_and_Time1__c=datetime.Now()+1;
        trwithdate1.Training_Date_and_Time2__c=datetime.Now()+2;
        trwithdate1.Training_Date_and_Time3__c=datetime.Now()+3;
        trwithdate1.Training_Date_and_Time4__c=datetime.Now()+4;
        trwithdate1.Training_Date_and_Time5__c=datetime.Now()+5;
        trwithdate1.Training_Date_and_Time6__c=datetime.Now()+6;
               
       insert trwithdate1;
        
        Learning_Response_Result__c lact1= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate1.id,TE_Network_ID__c=currentUser.Te_Network_Id__c,User_Record_ID__c=currentUser.id);
        
        lact1.Date_Time_Selected_by_User_Slot1__c=datetime.Now()+1;
        lact1.Date_Time_Selected_by_User_Slot2__c=datetime.Now()+2;
        lact1.Date_Time_Selected_by_User_Slot3__c=datetime.Now()+3;
        lact1.Date_Time_Selected_by_User_Slot4__c=datetime.Now()+4;
        lact1.Date_Time_Selected_by_User_Slot5__c=datetime.Now()+5;
        lact1.Date_Time_Selected_by_User_Slot6__c=datetime.Now()+6;
       
        
        insert lact1;
         
         PageReference pageRef = Page.IND_Training_InviteLanding_Page;
        pageRef.getParameters().put('id', String.valueOf(trwithdate1.Id));
        test.setCurrentPage(pageRef);
        ApexPages.StandardController str= new ApexPages.StandardController(trwithdate1);
        IND_TrainingParticipantcontroller partiClass = new IND_TrainingParticipantcontroller(str);
        // Create an instance of the searchCriteria to test all
        // get/set methods and the BuildWhereClause() method
        
        partiClass.Init();
        partiClass.checkregistertraining();
        partiClass.Newsave();
        
     
     Test.StopTest();
     }  
 }