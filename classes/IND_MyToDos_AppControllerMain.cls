public class IND_MyToDos_AppControllerMain {

/* -------------------------------------------------------------------------------------
 This Class Written by Deepak Kumar 14/03/2016
 
/**
*   This class is controller class for IND_My_ToDo_s_App Visualforce page .
*
@author Deepak Kumar
@created 14/03/2016
@version 1.0
@since 35.0
*

* ------------------------------------------------------------------------------------- */
  
//*****************************************Variables****************************************************************************************************************************************************
Public User LoginUser{get;set;}
//Public PageReference HomePage{get;Set;} 
public List<ProcessInstance> prosIns{get;set;}
private List<Id> prosInsIds = new List<Id>();    
private List<ProcessInstanceWorkitem>  prosInsWrkItms = new List<ProcessInstanceWorkitem>();    
public List<opportunity> IMSOpp{get;set;}  
public List<opportunity> OnHoldOpp{get;set;}  
public List<TEMarketing__MQLRecord__c> MyMql{get;set;}  
public List<TEMarketing__MQLRecord__c> MqlSqlRecord{get;set;} 
public List<TEMarketing__MQLRecord__c> MySal{get;set;}
public List<Task> MyTask{get;set;}
public List<Task> MyNewTask{get;set;}
//Public PageReference NewTaskPage{get;Set;}
Public List<subClassInvalidDatatInfo> MyInvData{get;set;}
Public List<subClassMissMatchInfo> MYMissMatch{get;set;}
public Map<id,opportunity> InvaldOpp{get;set;} 
public List<Opportunity_Forecast__c> Invldforecast{get;set;}
Public List<opportunity> MyOpp = new  List<opportunity>();
Public Date myDate{get;set;}
Public List<Account_Plan__c> AccPlan{get;set;}
Public String Daystatus{get;set;}
Public List<Engineering_Milestone__c> OppEnggMileS{get;set;}
Public List<Engineering_Milestone__c> ListOppEnggMileS{get;set;}
Public String HideAll{get;set;}
Public String ShowAll{get;set;}
Public List<SIP__c> MySIP{get;set;}
Public List<Contact> MyContactEmail{get;set;}
public List<opportunity> MissMatchOppTEpro{get;set;}
public List<opportunity> MissMatchTEproOpp{get;set;}
public List<IND_Contract__c> Contract{get;set;}
//*****************************************Variables****************************************************************************************************************************************************      



//*****************************************Constractor Class Method****************************************************************************************************************************************************
      public IND_MyToDos_AppControllerMain()  
      {
           LoginUser=[select id,name from user where id =:userinfo.getUserId()];  
           myDate =date.newInstance(Date.today().Year(),Date.today().Month(),1);
           
           mainInit();
          
           MyNewTask = new List<Task>();
           for(Task T:MyTask)
           {
           if(T.ActivityDate<(Date.Today()+7)){MyNewTask.add(T); }
           }
           HotCoolNormal();
           HideAll='slds-hide';
           ShowAll=' ';
      } 

//*****************************************Constractor Class Method****************************************************************************************************************************************************
 
 
//*****************************************Other Methods ****************************************************************************************************************************************************
  
 /*  Public PageReference Helpd{get;set;}
   public PageReference Helpd() {
       
        Helpd=new PageReference('/0692200000006sV');
        Helpd.setRedirect(true);
        return Helpd;
    }
    
   public PageReference NewTaskPage() {
        NewTaskPage=new PageReference('/setup/ui/recordtypeselect.jsp?ent=Task&retURL=%2Fhome%2Fhome.jsp&save_new_url=%2F00T%2Fe%3FretURL%3D%252Fhome%252Fhome.jsp');
        return NewTaskPage;
    }
 */
    Private void mainInit()
   {
            
           prosInsWrkItms =[SELECT Id, ActorId,ProcessInstanceId FROM ProcessInstanceWorkitem where ActorId=:userinfo.getUserId()];
           for(ProcessInstanceWorkitem prInswrk: prosInsWrkItms)
           {
            prosInsIds.add(prInswrk.ProcessInstanceId);
           }
           prosIns = new List<ProcessInstance>();
        
           prosIns = [SELECT Id, Status, TargetObject.Id, TargetObject.Name, TargetObject.Type,LastActor.name,CreatedDate FROM ProcessInstance where id IN :prosInsIds AND Status='Pending'];
                      
           MqlSqlRecord=[select id,TEMarketing__Lead__r.id,TEMarketing__Contact__r.id,TEMarketing__Full_Name__c,TEMarketing__Days_from_MQL_to_SAL__c,Related_to__c,TEMarketing__SAL_Date__c,TEMarketing__Rating__c,TEMarketing__Age__c,TEMarketing__Account__c,TEMarketing__Inquiry_Status__c,TEMarketing__MQL_Date__c,TEMarketing__Lead__r.isConverted,Ownerid from TEMarketing__MQLRecord__c where ownerid=:userinfo.getUserId()AND (TEMarketing__Inquiry_Status__c='Marketing Qualified' OR TEMarketing__Inquiry_Status__c='Sales Accepted') AND TEMarketing__Age__c<=180];
           
           //MySal=[select id,TEMarketing__Lead__r.id,TEMarketing__Full_Name__c,TEMarketing__Days_from_MQL_to_SAL__c,Related_to__c,TEMarketing__SAL_Date__c,TEMarketing__Age__c,TEMarketing__Account__c,TEMarketing__Inquiry_Status__c,TEMarketing__MQL_Date__c,Ownerid from TEMarketing__MQLRecord__c where TEMarketing__Lead__r.isConverted=False AND TEMarketing__Lead__r.TEMarketing__Stage__c='Sales Accepted' AND ownerid=:userinfo.getUserId() AND TEMarketing__Age__c<=180];
           
           MyTask =[Select id,Subject,Priority,Status,What.name,Who.name,Task.Account.Name,ActivityDate from Task where ownerid=:userinfo.getUserId() AND Status!='Completed' AND Status!='Deferred'];
                      
           Invldforecast=[select id,Date__c,Amount__c,Opportunity__c from Opportunity_Forecast__c where Opportunity__r.ownerid = :userinfo.getUserId() AND 
           (Opportunity__r.Opportunity_Group__c in ('Engineering','Sales','NDR')) AND (((Opportunity__r.StageName in ('Exploring Needs','Developing & Differentiating','Contracting','Approved/Active','Concept','Quotation','Sampling')) AND (Opportunity__r.CloseDate < THIS_MONTH OR Opportunity__r.Manufacturing_Start_Date__c < THIS_MONTH OR Opportunity__r.Days_since_last_user_update__c >60 OR (Date__c < THIS_FISCAL_QUARTER AND Amount__c > 0))) OR ((Opportunity__r.StageName in('Won','Commit')) AND (Opportunity__r.Manufacturing_Start_Date__c < THIS_MONTH OR Opportunity__r.Days_since_last_user_update__c >60))) AND (Part_Confidence__c!='Dead' AND Part_Confidence__c!='On Hold' AND Part_Confidence__c!='Lost')];
          
           AccPlan=[select id,name,Active__c,Customer__r.RecordType.DeveloperName,Customer_Record_Type__c,LastModifiedDate,Customer__r.name,Plan_Year__c from Account_Plan__c where Customer__r.OwnerId =:userinfo.getUserId() AND RecordType.DeveloperName='Active' AND Active__c =True]; //LastModifiedDate < Last_n_Days:180 AND
   
           ListOppEnggMileS=[select id,Opportunity__r.PLM_Id__c,Opportunity__c,Actual__c,Gate__c,Opportunity__r.name,Opportunity__r.Project_Status_Level__c,Opportunity__r.id,Opportunity__r.StageName,Opportunity__r.Opportunity_Number__c,Opportunity__r.RecordType.DeveloperName from Engineering_Milestone__c where Opportunity__r.Ownerid = :userinfo.getUserId() AND (Gate__c in ('Design Completion (G3)','Production Completion (G6)','Project Completion')) AND Opportunity__r.PLM_Id__c!=Null AND ( Opportunity__r.RecordType.DeveloperName in ('Opportunity_Product_Platform','IND_Engineering_project'))];
           
           MySIP=[select id,Name,Participants_Manager__c,Plan_Participant__r.name,Status__c from SIP__c  where (NOT (Name like '%test%')) AND ownerid=:userinfo.getUserId() AND Inactive_Plan__c=False AND ((Status__c='Rejected for Target' OR Status__c='Not Submitted') OR (Record_Locked__c=False AND (Status__c='Completed for Target' OR Status__c='Rejected for Results')))];
           
           MyContactEmail=[select id,name,FirstName,Full_Name__c,LastName,Email,Account_Name__c,EmailBouncedDate from Contact where ownerid = :userinfo.getUserId() AND EmailBouncedReason!=Null AND Inactive__c=False];
              
           IMSOpp = new List<opportunity>();
           OnHoldOpp = new List<opportunity>();
           
           //IMSOpp=[select id,name,StageName,Account.Name,Days_since_opportunity_creation__c,Total_Opportunity_Value__c from opportunity where ownerid = :userinfo.getUserId() AND Total_Opportunity_Value__c=null AND TEMarketing__Marketing_Sourced__c='Marketing Sourced' AND (StageName!='Dead' OR StageName!='Lost' OR StageName!='On Hold')];
           
           //OnHoldOpp=[select id,name,StageName,Account.Name,Pause_Reactivation_Date__c,Total_Opportunity_Value__c from opportunity where ownerid = :userinfo.getUserId() AND StageName='On Hold' AND (Pause_Reactivation_Date__c<= TODAY OR Pause_Reactivation_Date__c = NEXT_N_DAYS:30)];
           
           InvaldOpp=new Map<id,opportunity>([select id from Opportunity where ownerid = :userinfo.getUserId() AND (Opportunity_Group__c in ('Engineering','Sales','NDR')) AND (((StageName in ('Exploring Needs','Developing & Differentiating','Contracting','Approved/Active','Concept','Quotation','Sampling')) AND (CloseDate < THIS_MONTH OR Manufacturing_Start_Date__c < THIS_MONTH OR Days_since_last_user_update__c >60)) OR ((StageName in ('Won','Commit')) AND (Manufacturing_Start_Date__c < THIS_MONTH OR Days_since_last_user_update__c >60)))]);
           // I need the above SQL query because i can pull the data based on this month or other date filters. in Loop and if condition it is difficult to add the dynamic date filters.
          
           MyOpp=[select id,ForecastCategoryName,name,StageName,Days_since_opportunity_creation__c,TEMarketing__Marketing_Sourced__c,Opportunity_Group__c,Pause_Reactivation_Date__c,CreatedDate,Account.name,Account_Number__c,Days_since_last_user_update__c,CloseDate,Manufacturing_Start_Date__c,Total_Opportunity_Value__c,Project_Status_Level__c,PLM_Id__c,RecordType.DeveloperName from Opportunity where ownerid = :userinfo.getUserId()];
           
          InvalidDataMethod(); 
          
          MySal = new List<TEMarketing__MQLRecord__c>();
          MyMql = new List<TEMarketing__MQLRecord__c>();
          
          for(TEMarketing__MQLRecord__c mqlsal:MqlSqlRecord)
           {
             //{!If(Mql.Related_to__c=='Lead',Mql.TEMarketing__Lead__r.id,Mql.TEMarketing__Contact__r.id)}
             if(mqlsal.TEMarketing__Inquiry_Status__c=='Sales Accepted'){MySal.add(mqlsal);} else {MyMql.add(mqlsal);}
           }
           Contract=[select id,Action_Status__c,Contract_Status__c,Contract_Types__c,Name,Account__r.name,Account__r.AccountNumber from IND_Contract__c where Account__r.OwnerId = :userinfo.getUserId()AND Contract_Status__c != 'Expired' AND Action_Status__c != 'All Green'];
   
   }
   
   

     
     
     Public Void InvalidDataMethod()
       {
          //OppEnggMileS = new List<Engineering_Milestone__c>();
          double SumOfAmt;
          MyInvData= new List<subClassInvalidDatatInfo>();
         // Map<id,List<Opportunity_Forecast__c>> MapInvldforecast = new Map<id,List<Opportunity_Forecast__c>>();
           MissMatchOppTEpro= new list<opportunity>();
             MissMatchTEproOpp= new list<opportunity>();
            MYMissMatch= new List<subClassMissMatchInfo>(); // taken out of below Opportunity loop  code change on 26th september 2016 by deepak kumar for deployment 1799.
           
          for( opportunity op:MyOpp)
           {
     // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Invalid Data $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
              SumOfAmt=0;
             if(InvaldOpp.get(Op.id)!=null)
              {
              SumOfAmt=0; 
              for(Opportunity_Forecast__c opf:Invldforecast)
                {
                   
                   if( op.id==opf.Opportunity__c)
                      {
                        SumOfAmt=+ opf.Amount__c;
                      }
                
                }
              MyInvData.add(new subClassInvalidDatatInfo(SumOfAmt,op));  
             }
             else
             {
                SumOfAmt=0;
                for(Opportunity_Forecast__c opf:Invldforecast)
                {
                   
                   if( op.id==opf.Opportunity__c)
                      {
                        SumOfAmt=+ opf.Amount__c;
                      }
                
                }
              if(SumOfAmt!=0)MyInvData.add(new subClassInvalidDatatInfo(SumOfAmt,op));  
             
             }  
   // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Invalid data $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$           
              
            
            
           
            
             If(op.Total_Opportunity_Value__c==null && op.TEMarketing__Marketing_Sourced__c=='Marketing Sourced' && (op.StageName!='Dead' && op.StageName!='Lost' && op.StageName!='On Hold' ))
              {
               IMSOpp.add(op);              
              }
             
             If(op.StageName=='On Hold' && (op.Pause_Reactivation_Date__c<= Date.today() || (op.Pause_Reactivation_Date__c <= (Date.today() + 30) && op.Pause_Reactivation_Date__c >= Date.today())))
               {
                OnHoldOpp.add(op);
               }
                       
   
     // $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Invalid data $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$           
            
           
           
    // Comented by deepak on 16/06/2016 need the code for futare use **********************************************************************          
    //Remove the Commented code and used it now 26th Aug 2016        
             //MYMissMatch= new List<subClassMissMatchInfo>(); // Commented the code on 26th september 2016 by deepak kumar for deployment 1799.
           
             integer i=0;
             Date G3;
             for(Engineering_Milestone__c em:ListOppEnggMileS)
              {
                if(op.id==em.Opportunity__r.id)
                {
                
               /* If(em.Gate__c=='Design Completion (G3)' && em.Actual__c==NULL)
                 {
                   i=1;
                 }*/
                if(em.Gate__c=='Design Completion (G3)' && em.Actual__c!=NULL && (em.Opportunity__r.StageName!='Won - Open' || em.Opportunity__r.StageName!='Won - Closed' || em.Opportunity__r.StageName!='Production' || em.Opportunity__r.StageName!='Won') )
                 {
                  G3=em.Actual__c;                 
                 } 
                 if( (em.Gate__c=='Production Completion (G6)' || em.Gate__c=='Project Completion') && em.Actual__c!=NULL  && (em.Opportunity__r.Project_Status_Level__c=='OPEN (1)' || em.Opportunity__r.Project_Status_Level__c=='CLOSED (5)' || em.Opportunity__r.Project_Status_Level__c=='COMPLETED (4)') && (em.Opportunity__r.StageName!='Won - Open' && em.Opportunity__r.StageName!='Won - Closed' && em.Opportunity__r.StageName!='Production' && em.Opportunity__r.StageName!='Won')) 
                    {
                     MYMissMatch.add(new subClassMissMatchInfo(G3,em.Actual__c,em));
                    }
                }
              }
              
            
           
          
             
       // Comented by deepak on 16/06/2016 need the code for futare use **********************************************************************          
        //End of Remove the Commented code and used it now 26th Aug 2016   
            
             
       // Added two new card code to fetch the data based on filters as defined by deepak on 16/06/2016 need the code for futare use **********************************************************************          
              
              if((op.Project_Status_Level__c=='CANCELLED (3)' || op.Project_Status_Level__c=='DELETED (6)') && (op.StageName!='Lost/Dead - closed' && op.StageName!='Dead' && op.StageName!='Lost') && Op.PLM_Id__c!=Null && ( Op.RecordType.DeveloperName=='Opportunity_Product_Platform' || Op.RecordType.DeveloperName=='IND_Engineering_project'))
                 {
                  MissMatchOppTEpro.add(op);
                 }
             if((op.Project_Status_Level__c=='OPEN (1)' || op.Project_Status_Level__c=='ON-HOLD (2)') && (op.StageName=='Lost/Dead - closed' || op.StageName=='Dead' || op.StageName=='Lost') && Op.PLM_Id__c!=Null && ( Op.RecordType.DeveloperName=='Opportunity_Product_Platform' || Op.RecordType.DeveloperName=='IND_Engineering_project'))
                 {
                  MissMatchTEproOpp.add(op);
                 }           
      // Added two new card code to fetch the data based on filters as defined by deepak on 16/06/2016 need the code for futare use **********************************************************************          
          
             
           }   
             
           

       }
//************************************************************************ Method for Task******************************************************************************************************************************************       
     
       
        public String selectedtraining{get;set;}
       
        public PageReference ThisTasknewlist() { //Tasknewlist
         MyNewTask= new list<task>();
         for(Task T:MyTask)
          {
               
               if(selectedtraining=='None')
                {
                  if(T.ActivityDate<(Date.Today()+7)){MyNewTask.add(T); }
                }
               if(selectedtraining=='Overdue')
                {
                  if(T.ActivityDate<Date.Today()){MyNewTask.add(T); }
                }
               else if(selectedtraining=='Today')
                {
                 if(T.ActivityDate==Date.Today()){MyNewTask.add(T); }
                }
               else if(selectedtraining=='Todayoverdue')
                {
                 if(T.ActivityDate<=Date.Today()){MyNewTask.add(T); }
                } 
               else if(selectedtraining=='Tomorrow')
                {
                 if(T.ActivityDate==(Date.Today()+1)){MyNewTask.add(T); }
                }   
              else if(selectedtraining=='Next7Days')
                {
                 if((T.ActivityDate<=(Date.Today()+7) && T.ActivityDate>=(Date.Today()))){MyNewTask.add(T); }
                } 
              else if(selectedtraining=='ThisMonth')
                {
                 if((T.ActivityDate>=myDate && T.ActivityDate<=(myDate + 30))){MyNewTask.add(T); }
                }
              else if(selectedtraining=='AllOpen')
                {
                 MyNewTask=MyTask;
                }          
              
          }
         
         
         
         
         
         /*PageReference NewPage;
         NewPage=new PageReference('/apex/IND_MyToDo_S_APP');
         NewPage.setRedirect(false);*/
         return null;
        }
       
       
       
       
       
//************************************************************************ Method for Task******************************************************************************************************************************************       
        public Void HotCoolNormal() {
         Daystatus='Normal Day';
         Integer Allrecords;
         Allrecords = 0;
         Allrecords = (MyMql.size() + MySal.size() + IMSOpp.size() + prosIns.size() + MissMatchTEproOpp.size() + AccPlan.size() + MyInvData.size() + OnHoldOpp.size() + MissMatchOppTEpro.size() + MyNewTask.size());
         
         If(Allrecords <=15) {Daystatus='Cool Day';}
         If(Allrecords >=15 && Allrecords <=25) {Daystatus='Normal Day';}
         If(Allrecords >25) {Daystatus='Hot Day';}
        
        }
       
      
       
//*****************************************Other Methods ****************************************************************************************************************************************************
 



//*******************************************************************************************************Public Sub Class******************************************************************************************
     public class subClassInvalidDatatInfo{

     public Double PastValue{get;set;}
     public Opportunity Mainopp{get;set;} 
     
     public subClassInvalidDatatInfo(double PV,Opportunity  op){

           PastValue=PV;
           Mainopp=op;
           
     }

}

 public class subClassMissMatchInfo{

     public Date G3Value{get;set;}
     public Date G6Value{get;set;}
     public Engineering_Milestone__c Mainopp{get;set;} 
     
     public subClassMissMatchInfo(Date G3,Date G6,Engineering_Milestone__c  op){

           G3Value=G3;
           G6Value=G6;
           Mainopp=op;
           
     }

}







}