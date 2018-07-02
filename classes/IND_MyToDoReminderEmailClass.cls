/*********************************************************************************************************************** 
 Name: IND_MyToDoReminderEmailClass
 Salesforce Instance : QA Sandbox
========================================================================================================================
 Purpose: This class is called by the schedule methode to send the mytodo pending for each user.                                                   
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                2 August 2016   Initial Development                                         


For deleting the schedule job need to add code to developer console.
CronTrigger ct = [select id, NextFireTime from CronTrigger where Id = '08e22000000aTikAAE'];
 Delete the schedule job
System.abortJob(ct.id); 

select Id, NextFireTime,CronJobDetail.Id, CronJobDetail.Name, CronJobDetail.JobType from CronTrigger where CronJobDetail.JobType ='7'
***********************************************************************************************************************/

global class IND_MyToDoReminderEmailClass 

{

public set<id> usrid{get;set;} //



public Map<id,User> Map_usr{get;set;}

public List<subClassMytodoVariables> MytodoIndualInfo{get;set;}

Public String Emailadmin;
 Public OrgWideEmailAddress owea;


global String execute(list<user> listuser )

{
         owea = [select Id from OrgWideEmailAddress where DisplayName= 'Industrial MyToDo Admin' limit 1]; // added by deepak kumar on 2nd jan 2017 to set the from address of email.
         List<Messaging.SingleEmailMessage> Massemail = new List<Messaging.SingleEmailMessage>();
        usrid=new set<id>();
        usrid.clear();
        Emailadmin=' '+'\n';
        
        Map_usr=new Map<id,User>();
        
        for(user uu1:listuser)
         {
          Map_usr.put(uu1.id,uu1);         
         }

        usrid= Map_usr.keyset();
        
        Mytododataprocess(usrid);
        
    if(MytodoIndualInfo.size()!=0)    
    {
    for(subClassMytodoVariables varM:MytodoIndualInfo)
         {
           Massemail.add(sendmail(Map_usr.get(varM.myuserid),varM));
           Emailadmin+='<font size="3" color="red">User Name: </font>'+Map_usr.get(varM.myuserid).name+'<br/>';
           Emailadmin+='<font size="3" color="red">UserID: </font>'+ varM.myuserid+'<br/><br/>';
            
           if(varM.Approval>0)Emailadmin+='My Pending Approval('+varM.Approval+')<br/>';
           if(varM.MQL>0)Emailadmin+='My Pending MQL('+varM.MQL+') <br/>';
           if(varM.SAL>0)Emailadmin+='My Pending SAL('+varM.SAL+') <br/>';
           if(varM.MyTask>0)Emailadmin+='My Pending Task('+varM.MyTask+') <br/>';
           if(varM.InvaldOpp>0)Emailadmin+='My Pending Invalid Opportunity('+varM.InvaldOpp+') <br/>';
           if(varM.AccPlan>0)Emailadmin+='My Pending Account plan('+varM.AccPlan+') <br/>';
           if(varM.MySIP>0)Emailadmin+='My Pending SIP plan('+varM.MySIP+') <br/>';
           if(varM.MyContactEmail>0)Emailadmin+='My Invalid Contact('+varM.MyContactEmail+') <br/>';
           if(varM.IMSOpp>0)Emailadmin+='My Incomplete Marketing Sourced Opportunity('+varM.IMSOpp+') <br/>';
           if(varM.onhold>0)Emailadmin+='My OnHold Opportunity('+varM.onhold+') <br/>';
           if(varM.MissMatchOppTEpro>0)Emailadmin+='My Eng. Opp open in SFDC => closed in TE project('+varM.MissMatchOppTEpro+') <br/>';
           if(varM.MissMatchTEproOpp>0)Emailadmin+='My Eng. Opp closed in SFDC => Open in TE project('+varM.MissMatchTEproOpp+') <br/>';
           if(varM.Contract>0)Emailadmin+='My Pending Contracts('+varM.Contract+')<br/>';
           
           
           Emailadmin+='<br/>*************************************************************************************************<br/><br/>';
                    
         
         } 
       
         Messaging.sendEmail(Massemail);
    } 
    return(Emailadmin);    
}

//***************************************************** Method to process the my to do data******************************************************************

   public void Mytododataprocess(set<id> uid)
   {
    
    //***************************************** Variables to count the data for Mytodo************************************************************************
      MytodoIndualInfo= new List<subClassMytodoVariables>(); 
      
      map<id,Integer>CusApproval= new map<id,Integer>();     
      map<id,Integer>CusMQL= new map<id,Integer>(); 
      map<id,Integer>CusSAL= new map<id,Integer>(); 
      map<id,Integer>CusMyTask= new map<id,Integer>(); 
      map<id,Integer>Cusonhold= new map<id,Integer>(); 
      map<id,Integer>CusAccPlan= new map<id,Integer>(); 
      map<id,Integer>CusMySIP= new map<id,Integer>(); 
      map<id,Integer>CusMyContactEmail= new map<id,Integer>(); 
      map<id,Integer>CusIMSOpp= new map<id,Integer>(); 
      map<id,Integer>CusInvaldOpp= new map<id,Integer>(); 
      map<id,Integer>CusMissMatchOppTEpro= new map<id,Integer>(); 
      map<id,Integer>CusMissMatchTEproOpp= new map<id,Integer>(); 
      map<id,Integer>CusContract= new map<id,Integer>(); 
      
 //***********************************************************************************************************************************************************    
     List<ProcessInstance> prosIns= new List<ProcessInstance>();
     List<Id> prosInsIds = new List<Id>(); 
     List<ProcessInstanceWorkitem>  prosInsWrkItms = new List<ProcessInstanceWorkitem>();    
     List<TEMarketing__MQLRecord__c> MqlSqlRecord = new List<TEMarketing__MQLRecord__c>();
     List<Task> MyTask= new List<Task>();
     List<opportunity> InvaldOpp = new list<opportunity>();
     List<Account_Plan__c> AccPlan = new List<Account_Plan__c>();
     List<SIP__c> MySIP = new List<SIP__c>();
     List<Contact> MyContactEmail = new List<Contact>();
     List<opportunity> MyOpp = new List<opportunity>();
     List<IND_Contract__c> Contract= new List<IND_Contract__c>();
    
     
     
     
 //***************************************** Variables to count the data for Mytodo************************************************************************

     prosInsWrkItms =[SELECT Id, ActorId,ProcessInstanceId FROM ProcessInstanceWorkitem where ActorId IN :uid];
           for(ProcessInstanceWorkitem prInswrk: prosInsWrkItms)
           {
            prosInsIds.add(prInswrk.ProcessInstanceId);
           }
   prosIns = [SELECT Id FROM ProcessInstance where id IN :prosInsIds AND Status='Pending'];
   
   MqlSqlRecord=[select id,TEMarketing__Inquiry_Status__c,Ownerid from TEMarketing__MQLRecord__c where ownerid IN :uid AND (TEMarketing__Inquiry_Status__c in ('Marketing Qualified','Sales Accepted')) AND TEMarketing__Age__c<=180];
   MyTask =[Select id,ownerid from Task where ownerid IN :uid AND Status!='Completed' AND Status!='Deferred' AND ActivityDate< NEXT_N_DAYS:7]; // added by deepak kumar on 2nd jan 2017 to remove the issue of diffrence in mytodo and email funtionality.
   InvaldOpp=new list<opportunity>([select id, ownerid from Opportunity where ownerid in :uid AND (Opportunity_Group__c in ('Engineering','Sales','NDR')) AND (((StageName in ('Exploring Needs','Developing & Differentiating','Contracting','Approved/Active','Concept','Quotation','Sampling')) AND (CloseDate < THIS_MONTH OR Manufacturing_Start_Date__c < THIS_MONTH OR Days_since_last_user_update__c >60)) OR ((StageName in ('Won','Commit')) AND (Manufacturing_Start_Date__c < THIS_MONTH OR Days_since_last_user_update__c >60)))]);
   AccPlan=[select id,Customer__r.OwnerId from Account_Plan__c where Customer__r.OwnerId IN :uid AND RecordType.DeveloperName='Active' AND Active__c =True]; //LastModifiedDate < Last_n_Days:180 AND
   MySIP=[select id,ownerid from SIP__c  where (NOT (Name like '%test%')) AND ownerid IN :uid AND Inactive_Plan__c=False AND ((Status__c in ('Rejected for Target','Not Submitted')) OR (Record_Locked__c=False AND (Status__c in ('Completed for Target','Rejected for Results'))))];
   MyContactEmail=[select id,ownerid from Contact where ownerid IN :uid AND EmailBouncedReason!=Null AND Inactive__c=False];
   MyOpp=[select id,ForecastCategoryName,name,StageName,Days_since_opportunity_creation__c,TEMarketing__Marketing_Sourced__c,Opportunity_Group__c,Pause_Reactivation_Date__c,CreatedDate,Account.name,Account_Number__c,Days_since_last_user_update__c,CloseDate,Manufacturing_Start_Date__c,Total_Opportunity_Value__c,Project_Status_Level__c,PLM_Id__c,RecordType.DeveloperName,ownerid from Opportunity where ownerid IN :uid];
   Contract=[select id,Account__r.OwnerId from IND_Contract__c where Account__r.OwnerId IN :uid];
                                                   
     
     
 //***************************************** Placing the Countvariables with userid ***********************************************************    
     
      for(user u1:Map_usr.values())
       {
  //************************** Count for Approval********************************************************************
         integer tempappr=0;
         for(ProcessInstanceWorkitem prInswrk: prosInsWrkItms)
           {
             
             if(prInswrk.ActorId ==u1.id)
              {
                for(ProcessInstance pi:prosIns)
                 {
                   if(pi.id==prInswrk.ProcessInstanceId) tempappr++;
               
                 }
              }
           }
        CusApproval.put(u1.id,tempappr);  
          
       
 //************************** Count for Approval********************************************************************
   
  //*************************************Count for MQL & SAL **********************************************************
         integer tempsal=0;
         integer tempmql=0;
         
         for(TEMarketing__MQLRecord__c mqlsal: MqlSqlRecord)
           {
            if(mqlsal.ownerid==u1.id && mqlsal.TEMarketing__Inquiry_Status__c=='Sales Accepted')
             {
              tempsal++;
             }
            else if(mqlsal.ownerid==u1.id && mqlsal.TEMarketing__Inquiry_Status__c=='Marketing Qualified')
            {
             tempmql++;
            } 
 
           }
        CusMQL.put(u1.id,tempmql);
        CusSAL.put(u1.id,tempsal);
 //*************************************Count for MQL & SAL **********************************************************
   
 //*************************************Count for MyTask **********************************************************
       integer temptask=0;
         
        for(Task t1: MyTask)
           {
              if(u1.id==t1.ownerid)
               {
                temptask++;
               }
           }
 
         CusMyTask.put(u1.id,temptask);
 
 //*************************************Count for MyTask **********************************************************
 
 //*************************************Count for Invalid opportunity**********************************************************
 
  integer tempinvopp=0;
         
        for(opportunity o1: InvaldOpp)
           {
              if(u1.id==o1.ownerid)
               {
                tempinvopp++;
               }
           }
 
         CusInvaldOpp.put(u1.id,tempinvopp);
 
 //*************************************End of Count for Invalid opportunity**********************************************************

//*************************************Count for Account plan**********************************************************
 
       integer tempaccplan=0;
         
        for(Account_Plan__c aa1: AccPlan)
           {
              if(u1.id==aa1.Customer__r.OwnerId)
               {
                tempaccplan++;
               }
           }
 
         CusAccPlan.put(u1.id,tempaccplan);
 
//*************************************End of Count for Account plan********************************************************** 

//*************************************Count for Account Contract**********************************************************
 
       integer tempContract=0;
         
        for(IND_Contract__c aac1: Contract)
           {
              if(u1.id==aac1.Account__r.OwnerId)
               {
                tempContract++;
               }
           }
 
         CusContract.put(u1.id,tempContract);
 
//*************************************End of Count for Account Contract********************************************************** 
 
//************************************* Count for SIP and Contact********************************************************** 
 
 
        integer tempsip=0;
         
        for(SIP__c sip: MySIP)
           {
              if(u1.id==sip.ownerid )
               {
                tempsip++;
               }
           }
 
         CusMySIP.put(u1.id,tempsip);
 
 
       integer tempcont=0;
         
        for(contact con: MyContactEmail)
           {
              if(u1.id==con.ownerid )
               {
                tempcont++;
               }
           }
 
         CusMyContactEmail.put(u1.id,tempcont);
 //************************************* End of Count for SIP and Contact********************************************************** 
 
  
 
 //************************************* Count for IMS and Onhold Opportunity**********************************************************
 
            integer tempimsopp=0;
            integer temponhold=0;
            integer tempopppro=0;
            integer tempproopp=0;   
          
           for( opportunity op:MyOpp)
           {
            if(u1.id==op.ownerid)
             {
            
             If(op.Total_Opportunity_Value__c==null && op.TEMarketing__Marketing_Sourced__c=='Marketing Sourced' && (op.StageName!='Dead' && op.StageName!='Lost' && op.StageName!='On Hold' ))
              {
               tempimsopp++;              
              }
            
             If(op.StageName=='On Hold' && (op.Pause_Reactivation_Date__c<= Date.today() || (op.Pause_Reactivation_Date__c <= (Date.today() + 30) && op.Pause_Reactivation_Date__c >= Date.today())))
               {
                  temponhold++;
               }
            
             if((op.Project_Status_Level__c=='CANCELLED (3)' || op.Project_Status_Level__c=='DELETED (6)') && (op.StageName!='Lost/Dead - closed' && op.StageName!='Dead' && op.StageName!='Lost') && Op.PLM_Id__c!=Null && ( Op.RecordType.DeveloperName=='Opportunity_Product_Platform' || Op.RecordType.DeveloperName=='IND_Engineering_project'))
                 {
                  tempopppro++;
                 }
             
             if((op.Project_Status_Level__c=='OPEN (1)' || op.Project_Status_Level__c=='ON-HOLD (2)') && (op.StageName=='Lost/Dead - closed' || op.StageName=='Dead' || op.StageName=='Lost') && Op.PLM_Id__c!=Null && ( Op.RecordType.DeveloperName=='Opportunity_Product_Platform' || Op.RecordType.DeveloperName=='IND_Engineering_project'))
                 {
                  tempproopp++;
                 }     
             }
           }
          Cusonhold.put(u1.id,temponhold); 
          CusIMSOpp.put(u1.id,tempimsopp);
          CusMissMatchOppTEpro.put(u1.id,tempopppro);
          CusMissMatchTEproOpp.put(u1.id,tempproopp);     
        
 
    
 //************************************* END of Count for IMS and Onhold Opportunity********************************************************** 
 
 //********************************************************** add subclass variable data*****************************************************  
 
         if(CusMyTask.get(u1.id)!=0 || CusApproval.get(u1.id)!=0 || CusMQL.get(u1.id)!=0 || CusSAL.get(u1.id)!=0 || Cusonhold.get(u1.id)!=0 || CusAccPlan.get(u1.id)!=0 || CusMySIP.get(u1.id)!=0 || CusMyContactEmail.get(u1.id)!=0 || CusIMSOpp.get(u1.id)!=0 || CusInvaldOpp.get(u1.id)!=0 || CusMissMatchOppTEpro.get(u1.id)!=0 || CusMissMatchTEproOpp.get(u1.id)!=0 || CusContract.get(u1.id)!=0)
         {
          
           MytodoIndualInfo.add(new subClassMytodoVariables(u1.id,CusApproval.get(u1.id),CusMQL.get(u1.id),CusSAL.get(u1.id),CusMyTask.get(u1.id),Cusonhold.get(u1.id),CusAccPlan.get(u1.id),CusMySIP.get(u1.id),CusMyContactEmail.get(u1.id),CusIMSOpp.get(u1.id),CusInvaldOpp.get(u1.id),CusMissMatchOppTEpro.get(u1.id),CusMissMatchTEproOpp.get(u1.id),CusContract.get(u1.id)));  
         }
 
  //********************************************************** End of add subclass variable data*****************************************************  
     
    
   }
} 
//***************************************** Placing the Countvariables with userid ***********************************************************    
  

//*****************************************************End of Method to process the my to do data******************************************************************

//************************************************************Send Email Method************************************



public Messaging.SingleEmailMessage sendmail(user usendE, subClassMytodoVariables mytodo)

{

    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

   
    email.setOrgWideEmailAddressId(owea.Id); // added by deepak kumar on 2nd jan 2017 to set the from address of email.
     
    
    string [] toaddress= new String[]{usendE.email};

    //String[] ccAddresses=new String[]{'deepak.kumar89@te.com'};

    email.setSubject('My Pending MyToDo App Notification');
    
    String topBody='Dear '+usendE.Firstname+',<br/><br/>There are open records in salesforce.com assigned to you for an action. Please use the attached link to  <a href="https://c2s.my.salesforce.com/home/home.jsp">Visit your My to do’s App</a>  in Salesforce to check the record details.<br/>You receive this mail because you did not log in into salesforce for more than 14 days.<br/><br/> Below are the MytoDo app Pending Items:<br/><br/> ';

    email.setHtmlBody(topBody + 'My Pending Approval('+mytodo.Approval+')<br/> My Pending MQL('+mytodo.MQL+') <br/>My Pending SAL('+mytodo.SAL+') <br/>My Pending Task('+mytodo.MyTask+') <br/>My Pending Invalid Opportunity('+mytodo.InvaldOpp+') <br/>My Pending Account plan('+mytodo.AccPlan+') <br/>My Pending SIP plan('+mytodo.MySIP+') <br/>My Invalid Contact('+mytodo.MyContactEmail+') <br/>My Incomplete Marketing Sourced Opportunity('+mytodo.IMSOpp+') <br/>My OnHold Opportunity('+mytodo.onhold+') <br/>My Eng. Opp open in SFDC => closed in TE project ('+mytodo.MissMatchOppTEpro+') <br/>My Eng. Opp closed in SFDC => Open in TE project('+mytodo.MissMatchTEproOpp+')<br/>My Pending Contracts('+mytodo.Contract+')<br/> <br/>Sincerely,<br/>Industrial BU Admin<br/><br/>Date :'+string.valueof(system.today()));

    email.setToAddresses(toaddress);

   // email.setCcAddresses(ccAddresses);

   // Messaging.sendEmail(New Messaging.SingleEmailMessage[]{email});

  return(email);

}  









//***************************************************** Class for club the data******************************************************************

public class subClassMytodoVariables{

     public Integer Approval{get;set;}     
     public Integer MQL{get;set;} 
     public Integer SAL{get;set;}
     public Integer MyTask{get;set;}
     public Integer onhold{get;set;}
     public Integer AccPlan{get;set;}
     public Integer MySIP{get;set;}
     public Integer MyContactEmail{get;set;}
     public Integer IMSOpp{get;set;}
     public Integer InvaldOpp{get;set;}
     public Integer MissMatchOppTEpro{get;set;}
     public Integer MissMatchTEproOpp{get;set;}
     public Integer Contract{get;set;}
     public id myuserid{get;set;}
     
     public subClassMytodoVariables(id uid,Integer varApproval,Integer varMQL,Integer varSAL,Integer varMyTask,Integer varonhold,Integer varAccPlan,Integer varMySIP,Integer varMyContactEmail,Integer varIMSOpp,Integer varInvaldOpp,Integer varMissMatchOppTEpro,Integer varMissMatchTEproOpp,Integer VarContract)
     
     {

     myuserid=uid;
     Approval=varApproval;  
     MQL=varMQL; 
     SAL=varSAL;
     MyTask=varMyTask;
     onhold=varonhold;
     AccPlan=varAccPlan;
     MySIP=varMySIP;
     MyContactEmail=varMyContactEmail;
     IMSOpp=varIMSOpp;
     InvaldOpp=varInvaldOpp;
     MissMatchOppTEpro=varMissMatchOppTEpro;
     MissMatchTEproOpp=varMissMatchTEproOpp;
     Contract=VarContract;
     
     }
     
    
 } 

 //***************************************************** Class for club the data******************************************************************



}