/************************************************************************************************************************************************************************************************************************************************
Name: OutOfOffice_Controller
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
=================================================================================================================================================================================================================================================
Purpose: This controller will update the loggedIn user with selected user/Queue, when the loggedIn user wants to go, out of office.This controller 
         is used by OutOfOffice VF page.
=================================================================================================================================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
VERSION               AUTHOR                    DATE              DETAIL                           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 1.0               Ramakrishna Singara         25/02/2014        Controller                         
*************************************************************************************************************************************************************************************************************************************************/
public class OutOfOffice_Controller {

    /*-----------Variable Declaration-------*/
    public String vUser_Id{get;set;}
    public User vUser{get;set;}
    public List<User> vUserLst{get;set;}
    public List<Case> vCaseLst{get;set;}
    public List<QueueSobject> vQueueLst{get;set;}
    public List<Group> vGrpLst{get;set;}
    public String vSelect_Owner{get;set;}
    public String vSelectedId{get;set;}
    public boolean table{get;set;}
    public boolean table1{get;set;}
    public boolean IsUserSelected;
    public String UserName{get;set;}
    public String SearchText{get;set;}  
    boolean updatecheck;    

    /*---Constructor Definition----*/
    public OutOfOffice_Controller (){
        
        /*--Logged in user info "Id"--*/
        vUser_Id = UserInfo.getUserId();
        
        /*-----Logged in user Query for ----*/
        vUser = [Select id, Name, Out_Of_Office__c, Alternate_User1__c from User where id =: vUser_Id];
        if(vUser.Out_Of_Office__c){
            String vtempId = vUser.Alternate_User1__c;
            if(vtempId!=null)
            if(vtempId.startsWith('005')){
                User AltUser = [Select id, name from user where id=:vUser.Alternate_User1__c];            
                SearchText = AltUser.Name;
            }
            else{
                QueueSobject AltQue = [select queue.Name, QueueId, SobjectType From QueueSobject where QueueId=:vUser.Alternate_User1__c];
                SearchText = AltQue.queue.Name;
            }
        }
        
        table = false;
        table1 = false;
        IsUserSelected = false;
    }

    public void ClearSearch(){
        if(vUser.Out_Of_Office__c==False){
            SearchText='';
        }
    }
    
    public List<SelectOption> getOwners(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new selectOption('User', 'User'));
        options.add(new selectOption('QueueSobject', 'Queue'));
        return options;
    }
    
    public void runsearch(){
        vUserLst=new List<User>();
        vQueueLst = new List<QueueSobject>();
        String csstatus = Apexpages.currentPage().getParameters().get('casestatus');

        if(vSelect_Owner == 'User'){
            String soql = 'select id,name,email, out_of_office__c from User where'+'  name LIKE \''+String.escapeSingleQuotes(SearchText)+'%\' limit 20';
            table=true;
            table1 = false;
            vUserLst= Database.query(soql);
        }
        else{
            String soql = 'select queue.Name, QueueId,q.SobjectType, q.Id From QueueSobject q where'+'  q.queue.Name LIKE \''+String.escapeSingleQuotes(SearchText)+'%\'';
            table=false;
            table1 = true;
            vQueueLst = Database.query(soql);
        }
    }


    public PageReference Assign_New_Owner() {
        updatecheck=false;
        if(vUser.Out_Of_Office__c){
            if(vSelectedId != null){
                vUser.Alternate_User1__c = vSelectedId ;
                string vtempId = vSelectedId;
                if(vtempId.startsWith('005')){
                    User u = [Select id,out_of_office__c from user where id =: vSelectedId limit 1];
                    if(u.out_of_office__c){
                        updatecheck=true;
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.CC_OOO_Warning_Message1));
                        return null;
                    }
                }
            }
            else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, Label.CC_OOO_Warning_Message));
                return null;
            }
        }
    return null;
    }

    public PageReference save() {
        system.debug('..............000......................'+vUser.Out_Of_Office__c+'..................'+vSelectedId);
        if(SearchText.length()==0){
            vSelectedId = '';
        }
        
        Assign_New_Owner();
        if(vUser.Out_Of_Office__c==TRUE && vSelectedId.length() != 0){
            if(updatecheck == false){
                if(vUser.Out_Of_Office__c){
                    if(vSelectedId != null){
                        vUser.Alternate_User1__c = vSelectedId ;                    
                    }
                }

                update vUser; 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.info, Label.CC_OOO_Info_Message +UserName));            
                vUserLst = new List<User>();
                vQueueLst = new List<QueueSobject>();
                if(vSelect_Owner == 'User'){
                    table=true;
                    table1 = false;
                
                }
                else{
                    table=false;
                    table1 = true;
                } 
                PageReference pageRef = new PageReference('/home/home.jsp');
                pageRef.setRedirect(true);
                return pageRef;
            }
            system.debug('..............111......................');
        }
        else if(vUser.Out_Of_Office__c==FALSE && vSelectedId.length() == 0){
            vUser.Out_Of_Office__c=FALSE;
            vUser.Alternate_User1__c='';
            update vUser;
            PageReference pageRef = new PageReference('/home/home.jsp');
            pageRef.setRedirect(true);
            return pageRef;
            system.debug('..............222......................');
        }
        else if(vUser.Out_Of_Office__c==FALSE && vSelectedId.length() > 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, Label.CC_OOO_Error_Message));             
            
        }
        else if(vUser.Out_Of_Office__c == TRUE && vSelectedId.length() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.error, Label.CC_OOO_Warning_Message));             
            
        }
    return null;
    }    
}