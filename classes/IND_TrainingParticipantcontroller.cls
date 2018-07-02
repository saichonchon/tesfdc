public class IND_TrainingParticipantcontroller {

Public Training__c displaytraining{get;set;}
//User currentUser= new user(); //=[select id,email,lastname,firstname,GIBU__c,Region__c,Sub_Vertical__c,Te_Network_Id__c from user where id=:UserInfo.getUserid() AND isactive=true limit 1];
public id Trid{get;set;}
public Learning_Response_Result__c oldLRR= new Learning_Response_Result__c();
public List<Learning_Response_Result__c> listNewLRR = new List<Learning_Response_Result__c>();

Public Boolean checksubmitbutton{get; set;}
Public Boolean checktrainingclosed{get; set;}
Public recordtype trainingrecordtype{get;set;}
//Schema.RecordTypeInfo trainingrecordtypeinfo{get;set;}
Map<id,map<id,list<Learning_Response_Result__c>>> MapTraininginvite= new Map<id,map<id,List<Learning_Response_Result__c>>>();
Integer slot;
Integer selected;
Public Boolean Notinvited{get;set;}
Map<String,Double> Timezoneid = new Map<String,Double>();

public user userownerTr{get;set;}
//****************************************COntroller Class***************************************************************************************************************************************

    public IND_TrainingParticipantcontroller(ApexPages.StandardController controller) {
     
     Trid=ApexPages.currentPage().getParameters().get('Id');
     
     
     if(trid!=null)
     {
     displaytraining= new training__c();
     displaytraining=[select id,Ownerid,Training_Slide_URl1__c,RecordTypeid,Lync_Conference_ID__c,Active__c,Description_of_Training__c,Training_by_Slides__c,Name_of_the_Trainer__c,Duration_of_Training__c,Date_of_Training__c,Name,Training_Date_and_Time1__c,Training_Date_and_Time2__c,Training_Date_and_Time3__c,User_Selected_Date_Time_Option_1__c,
                      Training_Date_and_Time4__c,Training_Date_and_Time5__c,Training_Date_and_Time6__c,User_Selected_Date_Time_Option_2__c,
                      User_Selected_Date_Time_Option_3__c,User_Selected_Date_Time_Option_4__c,User_Selected_Date_Time_Option_5__c,User_Selected_Date_Time_Option_6__c,Admin_flag_training_is_closed__c,
                      Admin_flag_User_register__c from Training__c where id=:Trid AND active__c=true ];
        
      
      userownerTr=[select id,TimeZoneSidKey from user where id=:displaytraining.ownerid];
      
      //currentCon=[select id,email from contact where email=:currentUser.email limit 1];
      Try
      {
      oldLRR =[select id,Status_of_Participant__c,Training__r.Name,Active_Response_Result_Record__c,User_Record_ID__c,TE_Network_ID__c,Training__c,Date_Time_Selected_by_User_Slot1__c,Date_Time_Selected_by_User_Slot2__c,Date_Time_Selected_by_User_Slot3__c,Date_Time_Selected_by_User_Slot4__c,Date_Time_Selected_by_User_Slot5__c,
                
                Date_Time_Selected_by_User_Slot6__c from Learning_Response_Result__c where User_Record_ID__c=:UserInfo.getUserid() AND Active_Response_Result_Record__c=true AND training__c=:trid];
       }
       catch (Exception ex)
       {
         ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Error: An error occured in fetching User id because You are not invited for Training, Please contact your Industrial BU Admin.......'));
         Notinvited=true;
       }
       trainingrecordtype=[select id,name,developername from recordtype where isactive=true and id=:displaytraining.RecordTypeid]; 
       //Schema.DescribeSObjectResult trrrr= Schema.SObjectType.Training__c;
       
      // Map<Id,Schema.RecordTypeInfo> rtMapById = trrrr.getRecordTypeInfosById();
       //trainingrecordtypeinfo =  rtMapById.get(displaytraining.RecordTypeid);
      
      
      slot=0;
      selected=0;
      Init();
      checkregistertraining();  
      }
     else
      {
      ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Error:An error occured in fetching Training id. Please contact your Industrial BU Admin.......'));
     
      }
     
    }
 
 //****************************************COntroller Class***************************************************************************************************************************************
   
    
      // Id userid=ApexPages.currentPage().getParameters().get('xuserid');
      //Contact currentCon =[select id,email from contact where email=:.email limit 1];
      //List<Learning_Response_Result__c> oldLRR =[select id,Status_of_Participant__c,Training__r.Name,Active_Response_Result_Record__c,TE_Network_ID__c,Training__c from Learning_Response_Result__c where TE_Network_ID__c=:currentUser.Te_Network_Id__c AND Active_Response_Result_Record__c=true ];
    
    
    Public datetime converttolocal(datetime dtt)
    {
      
      Return(dtt);
    }
       
    
    Public Void Init()
     {
        if(displaytraining!=Null)
         {
          
           if(system.Today()>displaytraining.Date_of_Training__c )
               {
                    checktrainingclosed=true;
                     // ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You already registered for  ' + oldLRR.Training__r.Name));
               }
              
        
           if(displaytraining.Training_Date_and_Time1__c!=null) { displaytraining.Training_Date_and_Time1__c=converttolocal(displaytraining.Training_Date_and_Time1__c); Slot++; }
           if(displaytraining.Training_Date_and_Time2__c!=null) {displaytraining.Training_Date_and_Time2__c=converttolocal(displaytraining.Training_Date_and_Time2__c);Slot++; }
           if(displaytraining.Training_Date_and_Time3__c!=null) {displaytraining.Training_Date_and_Time3__c=converttolocal(displaytraining.Training_Date_and_Time3__c);Slot++; }
           if(displaytraining.Training_Date_and_Time4__c!=null) {displaytraining.Training_Date_and_Time4__c=converttolocal(displaytraining.Training_Date_and_Time4__c);Slot++; }
           if(displaytraining.Training_Date_and_Time5__c!=null) {displaytraining.Training_Date_and_Time5__c=converttolocal(displaytraining.Training_Date_and_Time5__c);Slot++; }
           if(displaytraining.Training_Date_and_Time6__c!=null) {displaytraining.Training_Date_and_Time6__c=converttolocal(displaytraining.Training_Date_and_Time6__c);Slot++; }
            
                         
              
          }
        }
     
   
   
   
   Public Void checkregistertraining()
   {
    if(oldLRR!=Null)
     {
      
          If(oldLRR.Date_Time_Selected_by_User_Slot1__c != null && oldLRR.Training__c==displaytraining.id)
           {
             displaytraining.User_Selected_Date_Time_Option_1__c=true;
             selected++;
             
           }
           If(oldLRR.Date_Time_Selected_by_User_Slot2__c != null && oldLRR.Training__c==displaytraining.id)
           {
             displaytraining.User_Selected_Date_Time_Option_2__c=true;
             selected++;
           }
           If(oldLRR.Date_Time_Selected_by_User_Slot3__c != null && oldLRR.Training__c==displaytraining.id)
           {
             displaytraining.User_Selected_Date_Time_Option_3__c=true;
             selected++;
           }
           If(oldLRR.Date_Time_Selected_by_User_Slot4__c != null && oldLRR.Training__c==displaytraining.id)
           {
             displaytraining.User_Selected_Date_Time_Option_4__c=true;
             selected++;
           }
           If(oldLRR.Date_Time_Selected_by_User_Slot5__c != null && oldLRR.Training__c==displaytraining.id)
           {
             displaytraining.User_Selected_Date_Time_Option_5__c=true;
             selected++;
           }
           If(oldLRR.Date_Time_Selected_by_User_Slot6__c != null && oldLRR.Training__c==displaytraining.id)
           {
             displaytraining.User_Selected_Date_Time_Option_6__c=true;
             selected++;
           }
     
                   
        }
        if(trainingrecordtype.DeveloperName=='Training_with_Response_without_Date_Slots' || trainingrecordtype.DeveloperName=='Training_with_Response_Exam_without_Date_Slots' || selected == Slot)
               {
                    checksubmitbutton=true;
                     
                     
                     // ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'You already registered for  ' + oldLRR.Training__r.Name));
               } 
   
     }
   
   
   
   
 //************************************************************************************************************************************************************************************************  
   
    public pagereference Newsave() {
       
      
       
        
            if(displaytraining.Date_of_Training__c >= system.Today())
             {
               //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if(oldLRR.training__c==displaytraining.id)
                {
                 If(displaytraining.User_Selected_Date_Time_Option_1__c==true)
                 {
                     //***************************************************************************************************************************************
                    oldLRR.Date_Time_Selected_by_User_Slot1__c=displaytraining.Training_Date_and_Time1__c;
                 }   
                 If(displaytraining.User_Selected_Date_Time_Option_2__c==true)
                 {
                    oldLRR.Date_Time_Selected_by_User_Slot2__c=displaytraining.Training_Date_and_Time2__c;
                 }   
                 If(displaytraining.User_Selected_Date_Time_Option_3__c==true)
                 {
                    oldLRR.Date_Time_Selected_by_User_Slot3__c=displaytraining.Training_Date_and_Time3__c;
                 }   
                 If(displaytraining.User_Selected_Date_Time_Option_4__c==true)
                 {
                    oldLRR.Date_Time_Selected_by_User_Slot4__c=displaytraining.Training_Date_and_Time4__c;
                 }   
                 If(displaytraining.User_Selected_Date_Time_Option_5__c==true)
                 {
                    oldLRR.Date_Time_Selected_by_User_Slot5__c=displaytraining.Training_Date_and_Time5__c;
                 }   
                 If(displaytraining.User_Selected_Date_Time_Option_6__c==true)
                 {
                    oldLRR.Date_Time_Selected_by_User_Slot6__c=displaytraining.Training_Date_and_Time6__c;
                 } 
                 oldLRR.Status_of_Participant__c='Signed for Training';
                 listNewLRR.add(oldLRR);  
                }
                 
             }
             
           
         
                   try{
                        update listNewLRR;
                      }
                   catch(DmlException ex)
                      {
                       ApexPages.addMessages(ex);
                      }
        
             //PageReference nextpage = new PageReference('/apex/IND_Invite_ThankyouPage?id='+System.currentPageReference().getParameters().get('id'));
        //return null;
       PageReference thankyoupage= Page.IND_Invite_ThankyouPage;
    thankyoupage.getParameters().put('id', Trid);
    thankyoupage.setRedirect(true);
    return thankyoupage;
    }
    
 //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Training Slide$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 
 public void Trainingslide1()
    {
      if(oldLRR.Status_of_Participant__c=='Invited for Training' && (trainingrecordtype.DeveloperName=='Training_with_Response_without_Date_Slots' || trainingrecordtype.DeveloperName=='Training_with_Response_Exam_without_Date_Slots'))
       {
      oldLRR.Status_of_Participant__c='Signed for Training';
      update oldLRR;
      }
     //PageReference page1= new PageReference (displaytraining.Training_Slide_URl1__c);
    // Page1.setRedirect(true); 
           
    }   
     
 //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Training Slide$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    
 
}