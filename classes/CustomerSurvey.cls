/**********************************************************************************************************************************************
*******
Name: customerSurvey
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class updates the contact survey when User close the case
        This class is called by keepescalationastrue trigger on case object.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra   22/11/2013    Class 
 1.1   Padmaja Dadi      19/08/2015    Class                         
***********************************************************************************************************************************************
*****/
public class CustomerSurvey
{
    public static void updateSurveyContact(Map<Id,Case> newCsMap,Map<Id,Case> oldCsMap)
    {
        Set<Id> contactids=new Set<Id>();
        //Added by Padmaja Dadi for PIC project on 19/08/2015 
        Set<Id> piccontactids=new Set<Id>();
        // Set<Id> picISconIds=new Set<Id>(); // Pidikiti, Rajesh has commented this code for case# 00901186
        Map<Id,Case> reopenids=new Map<Id,Case>();
        Map<Id,Case> reopenpicids=new Map<Id,Case>();
        List<Contact> conttoupdate=new List<Contact>();
        List<Case> casetoupdate=new List<Case>();
        Id PICrecId = Apex_Helper_Settings__c.getInstance('PIC Service Cloud').Value__c;     
        Id ccrecId = Apex_Helper_Settings__c.getInstance('Customer Care Cloud').Value__c;
        Id cccrecId = Apex_Helper_Settings__c.getInstance('Customer Care Cloud -Case Close').Value__c;
        
        for(Case c:newCsMap.values()){           
            if(newCsMap.get(c.Id).Survey_Sent__c!= oldCsMap.get(c.Id).Survey_Sent__c && newCsMap.get(c.Id).Survey_Sent__c && c.contactid !=null && c.isClosed == true)
            {
                if(c.RecordtypeId==ccrecId || c.RecordtypeId==cccrecId)               
                    contactids.add(c.contactid);
                if(c.RecordtypeId==PICrecId && c.Status=='Closed')
                    piccontactids.add(c.contactid);  
               /* if(c.RecordtypeId==PICrecId && c.Status=='Closed-Inside Sales')         
                    picISconIds.add(c.contactid);        
               */ // Pidikiti, Rajesh has commented this code for case# 00901186
            }
            if(newCsMap.get(c.Id).Status!= oldCsMap.get(c.Id).Status && c.Survey_Sent__c==true && c.contactid !=null && oldCsMap.get(c.Id).Status == 'Closed' && c.First_Survey__c!=true && c.Case_Reopened__c == true)
            {
                if(c.RecordtypeId==ccrecId || c.RecordtypeId==cccrecId )              
                    reopenids.put(c.contactid,c);  
                if(c.RecordtypeId==PICrecId)   
                    reopenpicids.put(c.contactid,c);              
                
            }   
           
        }
        // for(Contact ct:[select id,Survey_Sent__c,email,Date_of_Last_Survey__c from Contact where (id=:contactids OR id=:piccontactids OR id=:picISconIds) AND Survey_Sent__c = false AND Customer_Survey_Opt_Out__c= false]) // Pidikiti, Rajesh has commented this code for case# 00901186
        //if condition added by Bhavya for code optimization
        if(contactids.size()>0 || piccontactids.size()>0){
        for(Contact ct:[select id,Survey_Sent__c,email,Date_of_Last_Survey__c from Contact where (id=:contactids OR id=:piccontactids) AND Survey_Sent__c = false AND Customer_Survey_Opt_Out__c= false])
        { 
            //added condition on 8/26/2014 for controlling survey emails to internal contacts
            if(ct.email!=null && (!ct.email.contains('@te.com')) && (!ct.email.contains('@tycoelectronics.com'))){
                if(contactids.contains(ct.id)){
                    ct.Survey_Sent__c=true;
                    ct.Date_of_Last_Survey__c=System.Today();
                    conttoupdate.add(ct);
                    System.debug('^^^1111^^^^'+conttoupdate); 
                }
                //Added by Padmaja Dadi for PIC project on 19/08/2015
                if(piccontactids.contains(ct.id)){
                    //ct.Survey_Sent_PIC__c=true; Using the flag Survey Sent to keep generic for CC,PIC,InsideSales
                    ct.Survey_Sent__c=true;
                    ct.Date_of_Last_Survey_PIC__c=System.Today();
                    conttoupdate.add(ct);   
                    System.debug('^^^2222^^^^'+conttoupdate);  
                } 
                
                /*
                //Added by Nooreen for case 900400 on 15/03/2016            
                if(picISconIds.contains(ct.id)){            
                    ct.Survey_Sent__c=true;         
                    ct.Date_of_Last_Survey_IS__c=System.Today();                    
                    conttoupdate.add(ct);    
                    System.debug('^^^3333^^^^'+conttoupdate); 
                } 
                */ // Pidikiti, Rajesh has commented this code for case# 00901186
            }        
                              
            }
                        
        }
        if( reopenids.size()>0 || reopenpicids.size()>0){            
            for(Contact ct:[select id,Survey_Sent__c,email,Date_of_Last_Survey__c from Contact where (id=:reopenids.keyset() OR id=:reopenpicids.keyset()) AND Survey_Sent__c = true AND Customer_Survey_Opt_Out__c= false])
            {                 
                if(ct.email!=null && (!ct.email.contains('@te.com')) && (!ct.email.contains('@tycoelectronics.com'))){
                    if(reopenids.keyset().contains(ct.id)){    
                        ct.Survey_Sent__c=false;                       
                        ct.Date_of_Last_Survey__c=null;
                        reopenids.get(ct.id).Survey_Sent__c = false;
                        casetoupdate.add(reopenids.get(ct.id));
                     }
                     if(reopenpicids.keyset().contains(ct.id)){
                        ct.Survey_Sent__c=false;                       
                        ct.Date_of_Last_Survey_PIC__c=null;
                        reopenpicids.get(ct.id).Survey_Sent__c = false;
                        casetoupdate.add(reopenpicids.get(ct.id));
                     }
                        conttoupdate.add(ct); 
                                              
                 }   
             }        
                              
         }
                
        //Added by Padmaja Dadi for PIC project on 19/08/2015
        /*for(Contact ct:[select id,Survey_Sent_PIC__c,email,Date_of_Last_Survey_PIC__c from Contact where id=:piccontactids AND Survey_Sent_PIC__c = false AND Customer_Survey_Opt_Out__c= false])
        { 
            if(ct.email!=null && (!ct.email.contains('@te.com')) && (!ct.email.contains('@tycoelectronics.com'))){
                ct.Survey_Sent_PIC__c=true;
                ct.Date_of_Last_Survey_PIC__c=System.Today();
                conttoupdate.add(ct);
            }
          System.debug('***conttoupdate********'+conttoupdate);    
            
        }*/
        try
        {
            if(!conttoupdate.isEmpty()){
                Apex_Helper_Settings__c profileId= Apex_Helper_Settings__c.getInstance('Customer Care Service Cloud');
                CCP_Trigger__c tempSkipValidation = CCP_Trigger__c.getInstance(profileId.Value__c);                            
                if(tempSkipValidation == null) {
                    tempSkipValidation = new CCP_Trigger__c();
                }

                tempSkipValidation.Skip_Validation__c = true;
                upsert tempSkipValidation;
                
                update conttoupdate;
                if(!casetoupdate.isEmpty())
                update casetoupdate;
                
                tempSkipValidation.Skip_Validation__c = false;
                update tempSkipValidation;
            }
        }
        catch(Exception e){
            CCP_Exception_Util.CCP_Exception_Mail(e);
        }       
    }
}