public class IND_TrainingroomController {
  
  
  Public integer i{get;set;}
  id Trid;
  Learning_Response_Result__c llr = new Learning_Response_Result__c();
 // Boolean Trainingisnotstarted{get;set;}
 // Boolean TrainingisCompleted{get;set;}
 // Boolean Trainingiscoming{get;set;}
  Training__c tr=new Training__c();
  
    public IND_TrainingroomController(ApexPages.StandardController controller) {
    
       Trid=ApexPages.currentPage().getParameters().get('Id');
        tr=[select id,Training_Room_URL__c from Training__c where id=:Trid];
       llr=[select id,Status_of_Participant__c,Start_Date_Time_for_Slot2__c,Start_Date_Time_for_Slot1__c,Start_Date_Time_for_Slot3__c,Start_Date_Time_for_Slot4__c,Date_Time_Selected_by_User_Slot1__c,Date_Time_Selected_by_User_Slot2__c,Date_Time_Selected_by_User_Slot3__c,Date_Time_Selected_by_User_Slot4__c,Date_Time_Selected_by_User_Slot5__c,Date_Time_Selected_by_User_Slot6__c,End_Date_Time_for_Slot1__c,End_Date_Time_for_Slot2__c,End_Date_Time_for_Slot3__c,End_Date_Time_for_Slot4__c,End_Date_Time_for_Slot5__c,End_Date_Time_for_Slot6__c,
               Start_Date_Time_for_Slot5__c,Start_Date_Time_for_Slot6__c from Learning_Response_Result__c where training__c=:Trid AND User_Record_ID__c=:UserInfo.getUserid()];
     i=0; 
    }
    
    
     public PageReference clicktoEnter()
    {
       
      if((llr.Date_Time_Selected_by_User_Slot1__c!=null && datetime.now()>=(llr.Start_Date_Time_for_Slot1__c - 0.01041667) && datetime.now()<=llr.End_Date_Time_for_Slot1__c) || (llr.Date_Time_Selected_by_User_Slot2__c!=null && datetime.now()>=(llr.Start_Date_Time_for_Slot2__c - 0.01041667) && datetime.now()<=llr.End_Date_Time_for_Slot2__c) || (llr.Date_Time_Selected_by_User_Slot3__c!=null && datetime.now()>=(llr.Start_Date_Time_for_Slot3__c - 0.01041667) && datetime.now()<=llr.End_Date_Time_for_Slot3__c) || (llr.Date_Time_Selected_by_User_Slot4__c!=null && datetime.now()>=(llr.Start_Date_Time_for_Slot4__c - 0.01041667) && datetime.now()<=llr.End_Date_Time_for_Slot4__c) || (llr.Date_Time_Selected_by_User_Slot5__c!=null && datetime.now()>=(llr.Start_Date_Time_for_Slot5__c - 0.01041667) && datetime.now()<=llr.End_Date_Time_for_Slot5__c) || (llr.Date_Time_Selected_by_User_Slot6__c!=null && datetime.now()>=(llr.Start_Date_Time_for_Slot6__c - 0.01041667) && datetime.now()<=llr.End_Date_Time_for_Slot6__c))
      {
      llr.Status_of_Participant__c='Attended Training';
      update llr;
     
     PageReference page1= new PageReference (tr.Training_Room_URL__c);
     Page1.setRedirect(true); 
      return Page1;
      }  
     else
     {
        i=1;
        return Null;
      }    
   } 
    
   
 
    
}