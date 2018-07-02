public class INDUpdateLRResFromUserExamTriggerClass{

/*********************************************************************************************************************** 
 Name: INDUpdateLRResFromUserExamTriggerClass
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is called by trigger to Update the data from SPExam App to the Learning and Responce Object .                                                   
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                16 March 2016   Initial Development                                         
***********************************************************************************************************************/
      Public static void initMethod(List<spExams__User_Exam__c> UserExam) 
      {
                           
          
          Set<ID> ids = New Set<id>();
          Set<ID> lrrids= New Set<id>();
          Set<ID> examids= New Set<id>();
          
          spExams__Exam__c exam;
          List<spExams__User_Exam_Answer__c> UQA;
          Learning_Response_Result__c llr;
          List<Learning_Response_Result__c> updatellr= new List<Learning_Response_Result__c>();
          
          
  
          
           for(spExams__User_Exam__c userE:UserExam)
            {
             ids.add(userE.id);
             lrrids.add(userE.Learning_Response_Result__c);
             examids.add(userE.spExams__Exam__c);
             
            }
          
          
          map<id,Learning_Response_Result__c> ListLRR = new map<id,Learning_Response_Result__c>([select id,Number_of_time_Attempted_Exam__c,Exam_Result__c,User_Record_ID__c,Status_of_Exam__c,Status_of_Participant__c, Active_Response_Result_Record__c from Learning_Response_Result__c where id IN :lrrids]);
          map<id,spExams__User_Exam_Question__c> ListUEQ = new  map<id,spExams__User_Exam_Question__c>([select id from spExams__User_Exam_Question__c where spExams__User_Exam__c IN :ids]);
          
          UQA = new List<spExams__User_Exam_Answer__c>([select id,spExams__User_Exam_Question__c from spExams__User_Exam_Answer__c where spExams__User_Exam_Question__c IN :ListUEQ.keyset()]);
          map<id,spExams__Exam__c> listexam= new map<id,spExams__Exam__c>([select id,spExams__Exam_Duration__c from spExams__Exam__c where id IN :examids]);


//**********************************resuchedule the Exam**********************************************************************************************    
     
  
    integer tempi=0;
   for(spExams__User_Exam__c ue:UserExam)
   {
   
   exam=new spExams__Exam__c();
   exam=listexam.get(ue.spExams__Exam__c);
   if(ue.Learning_Response_Result__c!=null && ue.spExams__Status__c=='Submitted' )
    {
    llr =New Learning_Response_Result__c();
    llr = ListLRR.get(ue.Learning_Response_Result__c);
    llr.Status_of_Exam__c=ue.spExams__Status__c;
    if(ue.spExams__Status__c=='Submitted' )
      {
       llr.Number_of_time_Attempted_Exam__c++;
      
       if(ue.spExams__Passed__c=='FAILED' && llr.Number_of_time_Attempted_Exam__c<4 && ue.spExams__Submittion_Date__c!=null)
        {
          //ue.spExams__Remaining_Time__c=exam.spExams__Exam_Duration__c;ue.spExams__Passed__c=='FAILED'&& 
          llr.Exam_Result__c='Failed';
          llr.Status_of_Exam__c=ue.spExams__Status__c;
          llr.Status_of_Participant__c='Taken Exam (Failed)';
         // llr.Admin_Rechedule_Flag__c=true;
         if(llr.Number_of_time_Attempted_Exam__c!=3)
           {
            
             tempi=1;
          
           }
          
        }
       else if(ue.spExams__Passed__c=='PASS' && llr.Number_of_time_Attempted_Exam__c<4 )
        {
          llr.Exam_Result__c='Passed';
          llr.Status_of_Exam__c=ue.spExams__Status__c;
          llr.Status_of_Participant__c='Taken Exam (Passed)';
        } 
       
     }
      
     
     updatellr.add(llr);
    }
    
   }
    Update updatellr;
    if (tempi==1)
    {
    delete UQA;
    tempi=0;
    }  
    
    
  }    

}