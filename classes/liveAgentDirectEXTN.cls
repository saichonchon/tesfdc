/************************************************************************************************************************************************************************************************************************
Name: liveAgentDirectEXTN 
===========================================================================================================================================================================================================
Purpose: This class was part of Outbound Chat and for Contact object.
         This is used by liveAgentDirectEXTN class which is used to let agent get customer details. 
===========================================================================================================================================================================================================
******************************************************************************************************************************************************************************************************************/

public class liveAgentDirectEXTN {

// Variable declaration to send Customerdetails to Agent 
public string contactFirstName{get; set;} 
public string contactLastName{get; set;}
public string contactEmail{get; set;}
public string contactid{get; set;}
public string caseid{get; set;}
public string agentid{get; set;}    
public string directchatId{get; set;}
public string dDeplyId{get; set;}
public string directchaturl{get; set;}    
public string dOrgId{get; set;}
public string DeploymentURL{get; set;}
public string initURL{get; set;}    
  public liveAgentDirectEXTN(ApexPages.StandardController controller)
    {
       //Get Case Id,Contact Id, Agent Id from Current page URL.
        contactid = ApexPages.currentPage().getParameters().get('contactid');
        agentid = ApexPages.currentPage().getParameters().get('id');
        caseid = ApexPages.currentPage().getParameters().get('caseid');
        
        //Get Direct chat ID from Custom setting
       /* List<Live_Agent_Org_Settings__c> dirUrl  = [select DeploymentURL__c,initURL__c,Direct_Chat_Button__c,Direct_Chat_URL__c,DeploymentID__c,OrgID__c from Live_Agent_Org_Settings__c Limit 1];
                
        if(dirUrl.size()>0){
                            DeploymentURL=dirUrl[0].DeploymentURL__c;
                            initURL=dirUrl[0].initURL__c;
                            directchatId=dirUrl[0].Direct_Chat_Button__c;
                           string CusURL=dirUrl[0].Direct_Chat_URL__c;
                           string dButton=dirUrl[0].Direct_Chat_Button__c;
                           dDeplyId=dirUrl[0].DeploymentID__c; 
                           dOrgId=dirUrl[0].OrgID__c; 
                           //string agent_id=agentid; 
                           directchaturl=CusURL+dDeplyId+'&'+'org_id='+dOrgId+'&'+'button_id='+dButton;
                            system.debug('directchaturl'+directchaturl);
                           } */
                           
           Live_Agent_Org_Settings__c dirUrl  = Live_Agent_Org_Settings__c.getInstance(); 
             {
                            DeploymentURL=dirUrl.DeploymentURL__c;
                            initURL=dirUrl.initURL__c;
                            directchatId=dirUrl.Direct_Chat_Button__c;
                           string CusURL=dirUrl.Direct_Chat_URL__c;
                           string dButton=dirUrl.Direct_Chat_Button__c;
                            dDeplyId=dirUrl.DeploymentID__c; 
                           dOrgId=dirUrl.OrgID__c; 
                           //string agent_id=agentid; 
                           directchaturl=CusURL+dDeplyId+'&'+'org_id='+dOrgId+'&'+'button_id='+dButton;
                            system.debug('directchaturl'+directchaturl);
                            
                            }
        
        if(caseid!=null && caseid!=''){
              for(case con: [select id,contact.Email,contact.LastName,contact.FirstName from case where id=:caseid])
                 {
                // Map Customer details to variables to use on Visualforce page      
               contactFirstName = con.contact.FirstName;
               contactLastName =  con.contact.LastName;     
               contactEmail =  con.contact.Email;             
          
            }
        }
        
      if(contactid!=null && contactid!=''){
              for(Contact con: [select id,Email,LastName,FirstName from Contact where id=:contactid])
                 {
               // Map Customer details to variables to use on Visualforce page 
               contactFirstName = con.FirstName;
               contactLastName =  con.LastName;     
               contactEmail =  con.Email;             
            
             }
        }
        
    }
    
    

}