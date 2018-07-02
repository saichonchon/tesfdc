/*********************************************************************************************************************** 
 Name: IND_PageReferenceLanding_Pagecontroller
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is controller for visualforcepage "IND_Training_PageReferenceLanding_Page". This calss is handling the data for rerefrencing based on user input.
          on the user response user has to select the tarining slot and submit the request.  .                                        
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/    
public class IND_PageReferenceLanding_Pagecontroller {
Public Training__c displaytraining{get;set;}
User currentUser= new user(); //=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:UserInfo.getUserid() AND isactive=true limit 1];
public id Trid{get;set;}
public Learning_Response_Result__c oldLRR{get;set;}
public spExams__Exam__c spExam{get;set;}
Public recordtype trainingrecordtype{get;set;}
public spExams__User_Exam__c spUserExam{get;set;}
Boolean examfalg=false;
Public integer duration{get;set;}


         public IND_PageReferenceLanding_Pagecontroller (ApexPages.StandardController controller) 
           {
             
             Trid=ApexPages.currentPage().getParameters().get('Id');
             
             Try{
     
                 if(Trid!=null)
                     {
                     
                      displaytraining=[select id,RecordTypeid,Active__c,Name from Training__c where id=:Trid AND active__c=true ];
        
                      currentUser=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:UserInfo.getUserid() AND isactive=true limit 1]; 
                     
                      oldLRR =[select id,Status_of_Participant__c,Number_of_time_Attempted_Exam__c,Training__r.Name,Active_Response_Result_Record__c,User_Record_ID__c,TE_Network_ID__c,Training__c from Learning_Response_Result__c where TE_Network_ID__c=:currentUser.Te_Network_Id__c AND Active_Response_Result_Record__c=true AND training__c=:trid];
       
                      trainingrecordtype=[select id,name,developername from recordtype where isactive=true and id=:displaytraining.RecordTypeid]; 
                      
                      spExam=[select id,spExams__Description__c,spExams__Passing_Score__c ,spExams__Exam_Duration__c,spExams__Expiration_Date__c,spExams__No_of_Questions__c,spExams__Title__c,Training__c from spExams__Exam__c  where Training__c=:Trid];
                      
                      spUserExam=[select id,spExams__Email__c,spExams__Exam_URL__c,Learning_Response_Result__c,spExams__Status__c from spExams__User_Exam__c where Learning_Response_Result__c=:oldLRR.id AND spExams__User_Id__c=:currentUser.id];
                     
                      duration=Integer.valueOf(spExam.spExams__Exam_Duration__c/60);
                     
                      if(Oldlrr !=null && oldLRR.Number_of_time_Attempted_Exam__c>3){examfalg=true;}
                      }
                     else
                      {
                          ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Error: There is an error occured in fetching the Exam id please contact your Industrial Admin.'));
                      }
               }
               
               Catch(exception ex)
               {
                  ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Error: There is an error occured in fetching the Exam id please contact your Industrial Admin.'+ ex));
                   
               }
             
            }

  
  
   public PageReference ExamPage()
     {
      if(oldLRR==null)
      {
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please contact your BU Admin You are not invited for training.'));
         return null;  
      }
      else
      {
      if(trainingrecordtype.developername == 'Training_with_Response_Exam_without_Date_Slots' || trainingrecordtype.DeveloperName=='Training_with_Response_Exam_Date_Slots')
       {
      if(examfalg==true)
       {
         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You already have attempted the Exam three times, Please contact your admin if you want to retake the exam.'));
         return null;            
       }
       else
       {
        oldLRR.Status_of_Exam__c='In Progress';
        if(trainingrecordtype.developername == 'Training_with_Response_Exam_without_Date_Slots')
         {
          //oldLRR.Number_of_time_Attempted_Exam__c+=1;
          oldLRR.Status_of_Participant__c='Went through Training Slides';
          
         }  
         update oldlrr;     
        PageReference page1=new PageReference('/apex/spexams__spExamsUserVerification?uId='+spUserExam.id);
        Page1.setRedirect(true);   
        return(page1);
       }
          
      }
     else if(trainingrecordtype.DeveloperName=='Training_with_Response_without_Date_Slots')
      {
        oldLRR.Status_of_Participant__c='Went through Training Slides';
         update oldlrr;
        PageReference page1 = new PageReference('https://c2s--qa.cs14.my.salesforce.com/home/home.jsp');
        Page1.setRedirect(true);   
        return(page1);
      }
      else
      {
      ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please contact your BU Admin an error oocurs in redirecting the page.'));
         return null;  
      }
     }
   
  }


}