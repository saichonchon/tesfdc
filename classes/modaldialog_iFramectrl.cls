/**
* This class is for modaldialog_iFrame vf page which pops up messages based on records in popup alert object.
*
@author Prabhanjan N <prabhanjan.nandyala@zensar.in>
@created 12/8/2014
@version 1.0 
*
@changelog
* 12/4/2016 Prabhanjan N <prabhanjan.nandyala@zensar.in>
* - Added new method onload() 
* - moved the constructor logic to onload() method.
* - Added system maintenence logic via SOQL.
*/


public class modaldialog_iFramectrl {
  
    public integer c {get; set;}
    public integer popupscount {get; set;}
    public list<account> accs {get; set;}
    public map<Id,Pop_Up_Alert__c> popups; 
    public list<Pop_Up_Alert_Confirmation__c> popconfirms; 
    public list<Id> popupids; 
    public Pop_Up_Alert__c popup {get; set;}
    
    public string recid {get; set;} 
 
    public pagereference onload(){
    try{
    system.debug('call from javascript');
            if(apexpages.currentpage().getparameters().get('id')!=null){      
                    // system.debug('////////'+apexpages.currentpage().getparameters().get('id'));
                            recid=apexpages.currentpage().getparameters().get('id');
            }
            else{
                    recid = ApexPages.currentPage().getHeaders().get('referer').Split('/')[3].left(15);
            }
          
            // these two variables are used in case of 'case object'
            string accountid = '000';
            string contactid = '000';
            
            //getting the account/contact ids based on the referrer id.
            accountid= ((recid.substring(0,3)=='001') ? recid : '000');    
            
            if(recid.substring(0,3)=='003'){ 
                    contact c = [select accountid from contact where id=:recid];
                    accountid= ((c.accountid==null) ? '000' : c.accountid);
                    contactid= recid; 
             }
              
            
            if(recid.substring(0,3)=='500'){ 
                    case case1 = [select accountid,contactid from case where id=:recid];
                    accountid= ((case1.accountid==null) ? '000' : case1.accountid);
                    contactid= ((case1.contactid==null) ? '000' : case1.contactid); 
             }
            
            popup = new Pop_Up_Alert__c();
            popupids = new list<id>();
            
            c=0;
            popupscount=0;
            
            //Prabhanjan 00900749 adding System_Maintenance_Alert__c field to the OR criteria.
            popups = new map<Id,Pop_Up_Alert__c> ([select id,Message__c, System_Maintenance_Alert__c from Pop_Up_Alert__c where Active__c=true and (account__c=:accountid or contact__c=:contactid or System_Maintenance_Alert__c = true) and start_date__c<=:system.now() and end_date__c>=:system.now() order by System_Maintenance_Alert__c desc]);
            popconfirms = new list<Pop_Up_Alert_Confirmation__c>([select Pop_Up_Alerts__c from Pop_Up_Alert_Confirmation__c 
                    where Dont_Show_Pop_Up_Alert__c=true and User__c=:userinfo.getuserid() and Pop_Up_Alerts__c IN :popups.keyset()]); 
            
            
            // removing the user-unwanted-messages from the map
            for(Pop_Up_Alert_Confirmation__c pac: popconfirms){ 
               popups.remove(pac.Pop_Up_Alerts__c);  
            }
            
            popupscount=popups.size();        
            popupids.addAll(popups.keySet());   
            
            //getting the popup message to show up...
            next();
        }
        catch (exception e){ 
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
         return null;
         } 
         return null;
    }
    
    //CONSTRUCTOR has the logic to get the count of popup records as well as the popup message.
    
    public modaldialog_iFramectrl(ApexPages.StandardController controller){  }
    public modaldialog_iFramectrl(){      
         
    }
     
    // logic to find the next message in the map
    public void next() {
        try{
             popup = popups.get(popupids.get(c));
             //system.debug('>>>>>>>>>>>>>>>>>>>popupids.get(c)'+popupids.get(c));
             //system.debug('>>>>>>>>>>>>>>>>>>>popup'+popup);
             c++;
           } 
         catch (exception e){ 
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
             
         }     
    }
    
    //saving the user preferences to not to show the message  by inserting a record in the detail object of pop alert
    public void userPref() {
       try{
           
            Pop_Up_Alert_Confirmation__c pac = new Pop_Up_Alert_Confirmation__c(Dont_Show_Pop_Up_Alert__c=TRUE, Pop_Up_Alerts__c=popup.id, user__c=userinfo.getuserid());
            upsert pac;
            //popupids.remove(popup.id); 
         }
         catch (exception e){ 
            System.debug('Exception type caught: ' + e.getTypeName());    
            System.debug('Message: ' + e.getMessage());    
            System.debug('Cause: ' + e.getCause());    // returns null
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());
         }     
    }
    
}