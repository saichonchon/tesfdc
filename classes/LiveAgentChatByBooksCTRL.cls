global class LiveAgentChatByBooksCTRL {

public string VisitorRegion {get;set;}
public string VisitorCountry {get;set;}
public string VisitorCountryCode {get;set;}
public string VisitorCountryCode_2_Digit {get;set;}
public string VisitorPrefferedLang {get;set;}
public string VisitorLocaleLang {get;set;} 
//public string VisitorChatType {get;set;}
public boolean CCMessage {get;set;}

// Added for Live chat phase - 2
public Decimal AvgWaitingTime {get;set;}           
String AVERAGE_WAITING_TIME = 'Avg Waiting Time';  

// Parem variables
private string Email;
private string FirstName;
private string LastName;
private string Country;
private string Language;
private string AccountNum;

Public boolean dct {get;set;}
Public boolean nondct {get;set;}

public map<string,string> mapHTMLTranslations {get;set;}

public LiveAgentChatByBooksCTRL () {
    try{                        

        system.debug('ApexPages.currentPage().getURL() -->' + ApexPages.currentPage().getURL());
               
        // For DCT Live Chat Requirement -- Code Added by Rajesh 01 Sep 2017
        system.debug('ButtonId@@@@'+ ApexPages.currentPage().getParameters().get('liveagent.prechat.buttons'));
        LiveChatButton[] queryString = [SELECT DeveloperName from LiveChatButton where id = :ApexPages.currentPage().getParameters().get('liveagent.prechat.buttons') limit 1];
         dct=false;
         nondct=false; 
        if(queryString.size() > 0){
                dct=true;
                system.debug('IF 40' +dct+nondct);     
        }
        else{
                nondct=true;   
                system.debug('ELSE 45' +dct+nondct);     
        }

        mapHTMLTranslations = new map<string,string>(); 
        VisitorCountryCode = ApexPages.currentPage().getParameters().get('countryCode');
        
        string VisitorChatType = ApexPages.currentPage().getParameters().get('liveagent.prechat:ChatType');
        system.debug('liveagent.prechat:ChatType: '+VisitorChatType );
        CCMessage = (VisitorChatType != null && VisitorChatType == 'Customer Care');
        system.debug('CCMessage: '+CCMessage);
        
        if(VisitorCountryCode==''||VisitorCountryCode==null) VisitorCountryCode='US';
        VisitorPrefferedLang = ApexPages.currentPage().getParameters().get('language');
        
        if(VisitorPrefferedLang=='zh')   VisitorLocaleLang = 'CHINESE';
        else if(VisitorPrefferedLang=='de')   VisitorLocaleLang = 'DEUTSCH';
        else if(VisitorPrefferedLang=='es')   VisitorLocaleLang = 'ESPAÃOL';
        else if(VisitorPrefferedLang=='ja')   VisitorLocaleLang = 'JAPANESE';
        else VisitorLocaleLang = 'ENGLISH';
        

        HTMLTranslations();        
                        
        // Live Chat Phase 2 - START
        if(LiveAgent_Average_Waiting_Time__c.getInstance(AVERAGE_WAITING_TIME) != NULL)
            AvgWaitingTime = LiveAgent_Average_Waiting_Time__c.getInstance(AVERAGE_WAITING_TIME).AverageMinutes__c;    
            
        // Live Chat Phase 2 - END   
        
    }
    catch(exception e){     system.debug('failed at contructors ::'+ e.getMessage());}
}            

    // Live Chat Phase 2 - START
    @RemoteAction
    global static void sendRushHourNotification(){

        try{
            List<String> toAddresses = new List<String>();
            List<user> supervisorUserDetail = [select email from user where id in (select UserOrGroupId from GroupMember where group.DeveloperName = 'Supervisor_Queue')];
            for(user u: supervisorUserDetail){
                toAddresses.add(u.email);            
            }
            String messageBody;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            string userId = UserInfo.getUserId();
            string UserName = UserInfo.getName();
            
            mail.setSubject('Live Agent Queue Rush Intimation');
            string str = '<html><body>Hi <br/><br/> Urgent action required to bring more staff on to live chat as we have too many customers queuing<br/> ';
            
             str = str + '<br/>Regards,<br/>'+UserName;
             messageBody = str;
            
             mail.setHtmlBody(messageBody);               
                       
             Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                
            }
            catch(exception e){
                system.debug(e.getMessage()+e.getlineNumber());
            }
    }
    
   @RemoteAction
    global static String insertCase(string mobileNo, string comments, boolean CCMessage, string visitorInfo) {
       String Status = '';
       try{
           String queueName;
           String recordTypeName;
           case cs= new case();
           
           if(CCMessage){
               queueName = 'Global_Channel';
               recordTypeName = 'Customer_Care_Cloud';
           }else{
               queueName = 'Global_PIC';
               recordTypeName = 'TE_PIC_Standard_Case_Record_Type';
           }
           
           Id queueId = [select Id from Group where Type = 'Queue' AND DeveloperNAME = :queueName].Id;
           Id recordtypeId = [Select Id From RecordType where sobjecttype = 'Case' and developername = :recordTypeName].Id;
           
           string[] caseInfo = visitorInfo.Split(',');
           if(caseInfo.size() == 4){
               cs.Subject = caseInfo[0];
               cs.Live_Customer_First_Name__c = caseInfo[1];
               cs.Live_Customer_Last_Name__c = caseInfo[2];
               cs.Live_Customer_Email_Address__c = caseInfo[3];
           }
           
           cs.Live_Customer_Phone_Number__c = mobileNo;
           cs.Live_Agent_Call_Back_Comments__c = comments;
           cs.Livechat_customer_Call_Back__c = true;
           
           
           if(queueId != NULL && recordtypeId != NULL){
               cs.OwnerId=queueId;  
               cs.recordtypeid = recordtypeId;
           }
           
           insert cs; 
           
           Status = 'Success'; 
        }catch(exception e){
            system.debug('####Error Occured:' + e);
            status = 'Error';
            String vStrError = '';
            vStrError += 'Error Type = ' + e.getTypeName() + 
                ' Error Line = ' + e.getLineNumber() + '' + 
                ' Error Stack = ' + e.getStackTraceString() + 
                ' Error Message = ' + e.getMessage();
            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                         SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString()); 
            
        }
        return Status;
    }
    // Live Chat Phase 2 - END

public void HTMLTranslations(){
    try{
        
        for(LA_Metadata_Translations__mdt LAMT:[SELECT Id, Chinese__c, English__c, German__c, HTML_Id__c, Japanese__c, 
                                                German_ext__c FROM LA_Metadata_Translations__mdt])
        {
            
            if(VisitorLocaleLang == 'CHINESE')      mapHTMLTranslations.put(LAMT.HTML_Id__c,LAMT.Chinese__c);   
            if(VisitorLocaleLang == 'ENGLISH')      mapHTMLTranslations.put(LAMT.HTML_Id__c,LAMT.English__c);  
            if(VisitorLocaleLang == 'DEUTSCH'){  
                string extraGerman= '';
                if(LAMT.German_ext__c!=null) extraGerman=LAMT.German_ext__c;
                mapHTMLTranslations.put(LAMT.HTML_Id__c,LAMT.German__c+' '+extraGerman); 
            }
            if(VisitorLocaleLang == 'JAPANESE')     mapHTMLTranslations.put(LAMT.HTML_Id__c,LAMT.Japanese__c);  
        }
    } 
    catch(exception e){     system.debug('failed at HTMLTranslations() ::'+ e.getMessage());}
}
}