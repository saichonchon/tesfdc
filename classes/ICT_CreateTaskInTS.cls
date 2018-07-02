/*****************************************

Author : Capgemini Team
Purpose : For ICT BU user,On Opportunity pagelayout once custom button clicked,REST api callout invoke to create Task record in TS org.

**********************************************/

global class ICT_CreateTaskInTS {
    
    
    TS_Org__c csValue1 = TS_Org__c.getInstance('TSIntegration');
    
    String clientId = csValue1.ClientID__c ;
    String clientsecret = csValue1.ClientSecret__c ;
    String username = csValue1.Username__c ;
    String password = csValue1.Password__c ;
    String accesstoken = csValue1.accesstoken_url__c;
    String auth = csValue1.authurl__c;
    
    
    
    String accesstoken_url = accesstoken;
    String authurl = auth;
    
    
    public class deserializeResponse
    {
        public String id;
        public String access_token;   
    }
    
    public class deserializeResponseNew
    {
        public String id;
        public boolean success;   
    }
    
    public String ReturnAccessToken(ICT_CreateTaskInTS t)
    {
        String reqbody = 'grant_type=password&client_id='+clientId+'&client_secret='+clientSecret+'&username='+username+'&password='+password; // String reqbody='{"grant_type":"password","client_id":clientId,"client_secret":clientSecret,"username":username,"password":password}';
        Http h= new Http();
        HttpRequest req= new HttpRequest();
        req.setBody(reqbody);
        req.setMethod('POST');
        
        req.setEndpoint(accesstoken_url);  
        HttpResponse res=h.send(req);
        System.debug(res.getBody()+'###1203res');
        deserializeResponse resp1=(deserializeResponse)JSON.deserialize(res.getBody(),deserializeResponse.class);
        System.debug(resp1+'###123deserializeresponse');
        return resp1.access_token;
    }
    
    
    webservice static void createTask(ID Id)
    {
         
        String emailstr ='';
        String userid = '';
        String jsonstr ='';
        TS_Org__c csValue8 = TS_Org__c.getInstance('TSIntegration');
        String useridstr = csValue8.userid__c;
        
        Contact[] contactList = [ SELECT Id, email,RecordtypeId FROM Contact WHERE Recordtype.Name='TE Internal Contact' and Id IN ( SELECT ContactId FROM OpportunityContactRole WHERE OpportunityId =:Id ) ];
        system.debug('contactlist...'+contactList);
        
         if(contactList.size()>0)
        {
        for( Contact contact : contactList ) 
        {
            emailstr = contact.email;
            
        }  

        }
        try{
        
        User__x u = [select id,email__c from User__x where email__c =:emailstr limit 1];
        
        if(u.email__c == emailstr)
        {
           
           userid = u.id;
           //userid = userid.replace('x080', '0050');
           userid = userid.replace(useridstr,  '005');
           system.debug('New Userid..'+userid);

        }
        }
        catch(exception e){
           system.debug('An Error has Occured. Error:' +e); 
        }
        
        
        
        Opportunity op = [SELECT Id,CloseDate,Name,AccountId,Account.Name,Description,TS_TaskId__c,Amount FROM Opportunity WHERE Id = :Id];
        
        string actname = op.Account.Name;
        
        
        TS_Org__c csValue3 = TS_Org__c.getInstance('TSIntegration');
        String endp = csValue3.EndPoint__c;
        
        ICT_CreateTaskInTS ts= new ICT_CreateTaskInTS();
        string accessToken=ts.ReturnAccessToken(ts);
        
        date d = op.CloseDate;
        string mydate = string.valueof(op.CloseDate).substring(0,10);
        
        
        string name = op.Name;
        system.debug('Opty Name..'+name);
        string accid = op.AccountId;
        
        string de =op.Description;
        system.debug('description..'+de);
        
        decimal cur = op.Amount;
        
        if(cur==null)
            cur=0;
        
        //if(accessToken!=null)
        //{
            //String endPoint='https://tetransportation--qa.cs54.my.salesforce.com/services/data/v32.0/sobjects/Task'; 
            String endPoint = endp;
            try{
                
                if(userid != '' )
                {
                 system.debug('userid..'+userid);
                 jsonstr='{"OwnerId" :  "'+userid+'","OpportunityID_of_C2S__c":"'+ Id+'","Status" : "In Progress","Priority" : "Normal","Subject" : "C2S_'+name+'","ActivityDate" :"'+mydate+'","Opportunity__c" : "'+cur+'","Description" :"'+de+'"}';
                }
                else{
                system.debug('taskid..'+op.TS_TaskId__c); 
                jsonstr='{"OpportunityID_of_C2S__c":"'+ Id+'","Status" : "In Progress","Priority" : "Normal","Subject" : "C2S_'+name+'","ActivityDate" :"'+mydate+'","Opportunity__c" : "'+cur+'","Description" :"'+de+'"}';
                
                system.debug('json...'+jsonstr);
                }
                Http h2= new Http();
                HttpRequest req2= new HttpRequest();
                req2.setHeader('Authorization','Bearer ' + accessToken);
                req2.setHeader('Content-Type','application/json');
                req2.setHeader('accept','application/json');
                
                req2.setBody(jsonstr);
                req2.setMethod('POST');
                req2.setEndpoint(endPoint);
                //req2.setHeader('X-HTTP-METHOD-Override','PATCH');
                HttpResponse res2=h2.send(req2);
                System.debug(res2+'###123createresp');
                system.debug('res2.getBody()..'+res2.getBody());
                deserializeResponseNew deresp2=(deserializeResponseNew)System.JSON.deserialize(res2.getBody(),deserializeResponseNew.class);
                System.debug('###123createdeser'+deresp2);
                
                if(deresp2.success==true)
                {
                    system.debug('1234..'+deresp2.success);
                    op.TS_TaskId__c = id;
                    update op;
                }
            }
            catch(Exception e){
               system.debug('An Error has Occured. Error:' +e); 
             }
             
            if(op.TS_TaskId__c!=null)
            {
                try
                {
                    //String EndPoint1='https://tetransportation--qa.cs54.my.salesforce.com/services/data/v32.0/sobjects/Task/OpportunityID_of_C2S__c/'+id+'?_HttpMethod=PATCH';
                   String EndPoint1 = EndPoint+'/OpportunityID_of_C2S__c/'+id+'?_HttpMethod=PATCH';
                   String jsonstrupdate='{"ActivityDate" :"'+mydate+'","Opportunity__c" : "'+cur+'","Description" :"'+de+'"}'; 
                    system.debug('jsonupdate...'+jsonstrupdate);
                    Http h2= new Http();
                    HttpRequest req2= new HttpRequest();
                    req2.setHeader('Authorization','Bearer ' + accessToken);
                    req2.setHeader('Content-Type','application/json');
                    req2.setHeader('accept','application/json');
                    req2.setHeader('X-HTTP-METHOD-Override','PATCH');
                    req2.setBody(jsonstrupdate);
                    req2.setMethod('POST');
                    req2.setEndpoint(EndPoint1);
                    HttpResponse res2=h2.send(req2);
                    System.debug(res2+'###123createresp');
                }
                catch(Exception e){
                system.debug('An Error has Occured. Error:' +e); 
                }
            }
        //}
    }
    
}