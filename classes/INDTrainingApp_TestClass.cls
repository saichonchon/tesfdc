@isTest
/* -------------------------------------------------------------------------------------
 Test Class Written by Deepak Kumar 04/12/2015
 
/**
*   This test class is for IND_PageReferenceLanding_Pagecontroller.
*
@author Deepak Kumar
@created 04/10/2015
@version 1.0
@since 35.0
*

* - Created
* IND_PageReferenceLanding_Pagecontroller- Test coverage 85%
  IND_FeedbackController Test Coverage- 97%
  IND_TrainingroomController Test Coverage 100%
 

* ------------------------------------------------------------------------------------- */
private class INDTrainingApp_TestClass {


static testMethod void myUnitTest2() {

        test.startTest();
//***********Start of Test class for IND_FeedbackController Class **********************************************************************************************************************       
        User currentUser=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:UserInfo.getUserid() AND isactive=true limit 1];
        List<recordtype> trainingrecordtype = new List<recordtype>();
       // Schema.DescribeSObjectResult trrr = Schema.SObjectType.training__c;
       // Map<String,Schema.RecordTypeInfo> rtMapByName = trrr.getRecordTypeInfosByName();
        //recordtypeid=rtMapByName.get('Training with Response & Exam without Date Slots').getRecordTypeId()
       trainingrecordtype=[select id,name,developername from recordtype where isactive=true and SobjectType='training__c']; 
        map<string,id> rtmap = new map<string,id>();
        
        for(recordtype rt:trainingrecordtype)
        {
          rtmap.put(rt.developername,rt.id);
        }
        
        Training__c trwithdate1 = new training__c(name='testtrainig',recordtypeid=rtmap.get('Training_with_Response_without_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        trwithdate1.Training_Date_and_Time1__c=datetime.Now()- 0.00347222;
        trwithdate1.User_Selected_Date_Time_Option_1__c=true;
        trwithdate1.Feedback_Question_1__c='test';
        trwithdate1.Feedback_Question_2__c='test';
        trwithdate1.Feedback_Question_3__c='test';
        trwithdate1.Feedback_Question_4__c='test';
        trwithdate1.Feedback_Question_5__c='test';
        trwithdate1.Feedback_Question_6__c='test';
        insert trwithdate1;
        L_R_Result_Summary__c LRS =new L_R_Result_Summary__c(Participant_User__c=currentUser.id,Salesforce_User_ID__c=currentUser.id); 
        insert LRS;
        
        Learning_Response_Result__c lact1= new Learning_Response_Result__c(	Email_of_Participant__c='test@test.com',Date_Time_Selected_by_User_Slot1__c=datetime.now(),Result_Summary__c=LRS.id,training__c=trwithdate1.id,TE_Network_ID__c=currentUser.Te_Network_Id__c,User_Record_ID__c=currentUser.id);
        insert lact1;
        
        PageReference pageRef1 = Page.INDFeedbackPage;
        pageRef1.getParameters().put('id', String.valueOf(lact1.Id));
        test.setCurrentPage(pageRef1);
        ApexPages.StandardController str1= new ApexPages.StandardController(lact1);
        IND_FeedbackController partiClass1 = new IND_FeedbackController(str1);
         
        partiClass1.getTypes1();
        partiClass1.getTypes2();
        partiClass1.getTypes3();
        partiClass1.getTypes4();
        partiClass1.getTypes5();
        partiClass1.getTypes6();
        partiClass1.SubmitFeedback();
        
//***********End of Test class for IND_FeedbackController Class **********************************************************************************************************************       


//***********Start of Test class for IND_TrainingroomController Class **********************************************************************************************************************       
            
        
        PageReference pageRef2 = Page.IND_Invite_TrainingRoomPage;
        pageRef2.getParameters().put('id', String.valueOf(trwithdate1.Id));
        test.setCurrentPage(pageRef2);
        ApexPages.StandardController str2= new ApexPages.StandardController(trwithdate1);
        IND_TrainingroomController partiClass2 = new IND_TrainingroomController(str2);
        
        partiClass2.clicktoEnter();
        
        
         Test.StopTest();
        
      }  
//***********End of Test class for IND_TrainingroomController Class **********************************************************************************************************************       
       
  //*****************************Test Class for   IND_PageReferenceLanding_Pagecontroller***********************************************************************
   
    static testMethod void myUnitTest3() {

        test.startTest();
//***********Start of Test class for IND_FeedbackController Class **********************************************************************************************************************       
        User currentUser=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:UserInfo.getUserid() AND isactive=true limit 1];
        List<recordtype> trainingrecordtype = new List<recordtype>();
        //Schema.DescribeSObjectResult trrr = Schema.SObjectType.training__c;
        //Map<String,Schema.RecordTypeInfo> rtMapByName = trrr.getRecordTypeInfosByName();
        trainingrecordtype=[select id,name,developername from recordtype where isactive=true and SobjectType='training__c']; 
        map<string,id> rtmap = new map<string,id>();
        
        for(recordtype rt:trainingrecordtype)
        {
          rtmap.put(rt.developername,rt.id);
        }
        L_R_Result_Summary__c LRS =new L_R_Result_Summary__c(Participant_User__c=currentUser.id,Salesforce_User_ID__c=currentUser.id); 
        insert LRS;
        Training__c trwithdate13 = new training__c(name='testtrainig',recordtypeid=rtmap.get('Training_with_Response_Exam_without_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        insert trwithdate13;
        // System.Debug('################################################## the value of Setid is '+'#######'+trwithdate13.id);
       
        
        //System.Debug('################################################## the value of Setid is ' + exam1.id);
       
        Learning_Response_Result__c lact13= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate13.id,Number_of_time_Attempted_Exam__c=2,TE_Network_ID__c=currentUser.Te_Network_Id__c,Status_of_Participant__c='Invited for Training');
        insert lact13;
        
        spExams__Exam__c exam1 =[select id,Training__c,spExams__Exam_Duration__c from spExams__Exam__c where Training__c=:trwithdate13.id];
       
       spExams__User_Exam__c spUserExam1= new spExams__User_Exam__c(spExams__Email__c=CurrentUser.email,spExams__Exam__c=exam1.id,spExams__Remaining_Time__c=3600,Learning_Response_Result__c=lact13.id,spExams__User_Id__c=currentUser.id,spExams__First_Name__c='test',spExams__Last_Name__c='test');    
       insert spUserExam1; 
       
        PageReference pageRef13 = Page.IND_Training_PageReferenceLanding_Page;
        pageRef13.getParameters().put('id', String.valueOf(trwithdate13.Id));
        test.setCurrentPage(pageRef13);
        ApexPages.StandardController str13= new ApexPages.StandardController(trwithdate13);
        IND_PageReferenceLanding_Pagecontroller PageRefClass13 = new IND_PageReferenceLanding_Pagecontroller(str13);
        
        
        
        PageRefClass13.ExamPage();
        
        
        
        Training__c trwithdate15 = new training__c(Training_Date_and_Time5__c=datetime.Now()+1,name='testtrainig',recordtypeid=rtmap.get('Training_with_Response_without_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+50);
        insert trwithdate15;
        
        Learning_Response_Result__c lact15= new Learning_Response_Result__c(Result_Summary__c=LRS.id,training__c=trwithdate15.id,Number_of_time_Attempted_Exam__c=4,TE_Network_ID__c=currentUser.Te_Network_Id__c,Status_of_Participant__c='Invited for Training');
        insert lact15; 
        
        //spExams__Exam__c exam2 =[select id,Training__c,spExams__Exam_Duration__c from spExams__Exam__c where Training__c=:trwithdate15.id]; 
        
        
        //spExams__User_Exam__c spUserExam2= new spExams__User_Exam__c(spExams__Email__c=CurrentUser.email,spExams__Exam__c=exam2.id,spExams__Remaining_Time__c=3600,Learning_Response_Result__c=lact15.id,spExams__User_Id__c=currentUser.id,spExams__First_Name__c='test',spExams__Last_Name__c='test');    
        //insert spUserExam2; 
        
        PageReference pageRef15 = Page.IND_Training_PageReferenceLanding_Page;
        pageRef15.getParameters().put('id', String.valueOf(trwithdate15.Id));
        test.setCurrentPage(pageRef15);
        ApexPages.StandardController str15= new ApexPages.StandardController(trwithdate15);
        IND_PageReferenceLanding_Pagecontroller PageRefClass5 = new IND_PageReferenceLanding_Pagecontroller(str15);
        
        PageRefClass5.ExamPage();
        
 //*****************************Test Class for   IND_PageReferenceLanding_Pagecontroller***********************************************************************
      
   
   
   
   
   
   
   
      Test.StopTest();
     }  
//***********Start of Test class for IND_FeedbackController Class **********************************************************************************************************************       
        
     
     
     
     
     
}