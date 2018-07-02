/**********************************************************************************************************************************************
*******
Name: UpdateCase
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This trigger updates case for email to case 
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha/Abhijeet    8/10/2013       Trigger 
 2.0    Narasimha            9/6/2014        Added condition on case and email message created dates to stop conflicts of gibu                      
 3.0    Narasimha            20/06/2014      Added condition as it should excute only when contact was null
**********************************************************************************************************************************************/
trigger UpdateCase on EmailMessage (after insert) {
    Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('DataComm - Customer Care');
    Apex_Helper_Settings__c vCaseRT_CCP = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
    Set<Id> vCsId = new Set<Id>();
    public Set<Id> vSetCsOwnerId = new Set<Id>();
    public Set<String> vUserEmailSet = new Set<String>();
    List<Case> vCaselist=new List<Case>();
    List<Case> vupCaseLst = new List<Case>();
    Map<Id,Case> updateCaseMap = new Map<Id,Case>();
    List<Case> vupCaseLst_CCP = new List<Case>();
    List<Case> vInternalConCases = new List<Case>();
    List<Case> vQuickEmail_CsLst = new List<Case>();
    Map<Id,Case> updateQuickCaseMap = new Map<Id,Case>();
    Map<Id,Case> vCsMap = new Map<Id,Case>();
    Map<Id,Case> vQuickEmail_CsMap = new Map<Id,Case>();
    Set<String> vEmailFromAddSet = new Set<String>();
    set<string> quicktomail=new set<string>();
    map<string,contact> map_quickemail_contact=new map<string,contact>();
    Map<String,Apex_Helper_Settings__c> vMapNametoApexHlprSetting = Apex_Helper_Settings__c.getAll();
    //Map<String,TE_Employee__c> vMapEmailtoTEmployee = new Map<String,TE_Employee__c>();
    string strToaddress ='';
    String vEmToCCAddress = '';
    Integer vSharedEmailBoxCount = 0;
    set<string> vSetEmailId = new set<string>();
    Set<String> vEMSubjectSet = new Set<String>();
    Set<String> vEMToaddressSet = new Set<String>();
   
   /* The following portion defines collection for email addresses, cases for Customer Care/Datacomm, users if case not assigned to queue, if case is created through Quick Email */
    Integer strcount=0; 
    if(CaseUtil_CCP.updateCaseboolean1 == false){
       CaseUtil_CCP.updateCaseboolean1 =true;
    Case ca = new Case();
    try{
    for(EmailMessage em2:trigger.new){
    //Create set of caseid
       vCsId.add(em2.parentId);
       vEmailFromAddSet.add(em2.fromAddress);
       strToaddress +=em2.ToAddress;
       if(em2.ToAddress != null)
       vEmToCCAddress += em2.ToAddress;
       if(em2.CCAddress != null)
       vEmToCCAddress  = vEmToCCAddress +';'+em2.CCAddress;
       //quicktomail.add(em2.ToAddress);
         vEMSubjectSet.add(em2.subject);
        vEMToaddressSet.add(em2.Toaddress);
        if(em2.ccaddress != null){
        vEMToaddressSet.add(em2.ccaddress);
        }
     
    }
    for(string str:strToaddress.split(';',-2))
    {
        if(strcount!=0)str=str.substring(1, str.length());
        if(strcount==0)strcount++;
    }
    
    List<String> vEMLst = vEmToCCAddress.split(';',-2);
    System.debug('VEMLSttttttt'+vEMLst);
    for(string str2 : vEMLst)      {    
    str2 = str2.trim();
        if(strcount!=0)str2=str2.substring(0, str2.length());
        if(strcount==0)strcount++;
        if(str2 != null || str2 != '')
       vSetEmailId.add(str2);
       System.debug(str2+'*****'+str2.length());
    }
    
    //Create seperate lists of CCP cases and Datacomm cases
    vCaselist = [Select id,ownerid,Subject,Contact.Email,SuppliedEmail,Region__c,Office__c ,recordtypeid,IsClosed,Description,Status,createddate,contactId,accountId,Quick_Email__c,Entitlementid,Case_Group__c, GIBU__c,Count_Incoming_Emails__c, CaseCount__c from Case where ID in: vCsId];     
    
    
        for(Case cs : vCaselist){
            if(cs.recordtypeId == vCaseRT_CCP.Value__c && cs.Quick_Email__c == false)
            vCsMap.put(cs.id,cs);
            if(cs.recordtypeId == vCaseRT.Value__c)
            ca = cs;
            if(cs.Quick_Email__c == true){
            //Create map of cases created through Quick Email functionality.
                vQuickEmail_CsMap.put(cs.id,cs);
            }
            //To check if email is sent by owner of a case.
            String tOwner = cs.OwnerID;
            if(tOwner.startsWith('005'))
            vSetCsOwnerId.add(cs.ownerId);
        }
   
    if(ca.Id==null){
    
       for(contact con:[select id,email,AccountId from contact where email in: vSetEmailId])
       {
           map_quickemail_contact.put(con.email,con);
       }
       //Create map of Email Addres to TE Employee record
       /*for(TE_Employee__c teemp : [Select id,Email__c  from TE_Employee__c where Email__c != null and (Email__c in: vEmailFromAddSet OR Email__c in:vSetEmailId)]){
           vMapEmailtoTEmployee.put(teemp.Email__c,teemp);
       }*/
    
        //Create set of user email ids
        for(User u : [Select id,email from User where id in: vSetCsOwnerId]){
            vUserEmailSet.add(u.email);
        } 
    }
    System.debug('vQuickEmail_CsMap**'+vQuickEmail_CsMap);
    
    // Only for CCP Cases   
    Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMapAll = Customer_Care_SharedEmailBox__c.getAll();
    Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap = new  Map<String, Customer_Care_SharedEmailBox__c>();
    Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap_BCCAddr = new  Map<String, Customer_Care_SharedEmailBox__c>();
   
    /**/
    for(Customer_Care_SharedEmailBox__c ccs:vCustCareEmailBoxMapAll.values())
    {
        vCustCareEmailBoxMap.put(ccs.Name.toLowerCase(),ccs);
        if(ccs.SFDC_Routing_Address__c != null)
        vCustCareEmailBoxMap_BCCAddr.put(ccs.SFDC_Routing_Address__c.toLowerCase(),ccs);
    } 
    Integer strcount2 = 0;
    System.debug('vEMToaddressSet'+vEMToaddressSet);
    Set<Id> vMultipleCsIdSet = new set<Id>();
    set<string> vCaseGroupSet = new set<string>();
    
    for(string str : vSetEmailId){
        if(vCustCareEmailBoxMap.containsKey(str))
        vSharedEmailBoxCount = vSharedEmailBoxCount + 1;
    }
    if( ca.Id==null){
    //Create set of casesids created with same email havimore than two shared email box in ToAddresss or CC address
       for(Emailmessage e : [Select id,messagedate,parentid,subject,Toaddress,ccaddress from emailmessage where ( messagedate >: (System.now().addminutes(-1))) and (subject != null and subject in: vEMSubjectSet) and ((toaddress!= null OR ccaddress != null) and (toaddress in: vEMToaddressSet OR ccaddress in: vEMToaddressSet)) ]){
            
            vMultipleCsIdSet.add(e.parentid);
        }
        
        for(Case c : [Select id,Case_Group__c,casenumber,GIBU__c from case where id in: vMultipleCsIdSet]){
            vCaseGroupSet.add(c.Case_Group__c);
        }
    }
    
   /* The following portion updates the case fields based on match found */           
    if(vCsMap.isEmpty() == false){
        for(EmailMessage  em : Trigger.new){
            if(vCsMap.containskey(em.parentId)){
            
         
         
                if(vCsMap.get(em.parentId).Count_Incoming_Emails__c <= 1 && em.Incoming == true){
              for(string str : vSetEmailId )
              {        
              //Update Case Group,GIBU,Region etc. on cases
                   if(vCustCareEmailBoxMap.containsKey(str)){
                       if(!vCaseGroupSet.contains(vCustCareEmailBoxMap.get(str).Case_Group__c)){
                           vCsMap.get(em.parentId).GIBU__c = vCustCareEmailBoxMap.get(str).GIBU__c;  
                           vCsMap.get(em.parentId).Region__c =vCustCareEmailBoxMap.get(str).Region__c;
                           vCsMap.get(em.parentId).BusinessHoursId= vCustCareEmailBoxMap.get(str).Business_Hours__c ;
                           vCsMap.get(em.parentId).Case_Group__c=vCustCareEmailBoxMap.get(str).Case_Group__c;
                           if(vCustCareEmailBoxMap.get(str).Office__c != null)
                           vCsMap.get(em.parentId).Office__c=vCustCareEmailBoxMap.get(str).Office__c;                   
                           break;
                       }
                       if(vCustCareEmailBoxMap.containsKey(str) && vSharedEmailBoxCount == 1){
                          vCsMap.get(em.parentId).GIBU__c = vCustCareEmailBoxMap.get(str).GIBU__c;  
                           vCsMap.get(em.parentId).Region__c =vCustCareEmailBoxMap.get(str).Region__c;
                           vCsMap.get(em.parentId).BusinessHoursId= vCustCareEmailBoxMap.get(str).Business_Hours__c ;
                           vCsMap.get(em.parentId).Case_Group__c=vCustCareEmailBoxMap.get(str).Case_Group__c;
                           if(vCustCareEmailBoxMap.get(str).Office__c != null)
                           vCsMap.get(em.parentId).Office__c=vCustCareEmailBoxMap.get(str).Office__c;                   
                           
                       }
                       
                   }else{
                       //Added condition em.messagedate<case.createddate on 9/6/2014
                       if((!vCustCareEmailBoxMap.containsKey(str)) && (vCsMap.get(em.parentId).Case_Group__c == null)&& vSharedEmailBoxCount == 0 && em.headers != null){
                           String vEMHeader= (String)em.headers;
                            vEMHeader = vEMHeader.replaceall('\n','');
                            vEMHeader = vEMHeader.replaceall(',','');
                            vEMHeader = vEMHeader.replaceall('"','');
                            String tempHold = vEMHeader.substring(vEMHeader.indexof('X-SFDC-Original-RCPT:'),vEMHeader.length());
                            tempHold = tempHold.substring(tempHold.indexof('-RCPT:')+7,tempHold.indexof('.com')+4);
                                     System.debug('Shared Email Address in BCC'+tempHold);
                             if(vCustCareEmailBoxMap_BCCAddr.containskey(tempHold)){
                                vCsMap.get(em.parentId).GIBU__c = vCustCareEmailBoxMap_BCCAddr.get(tempHold).GIBU__c;  
                                vCsMap.get(em.parentId).Region__c =vCustCareEmailBoxMap_BCCAddr.get(tempHold).Region__c;
                                vCsMap.get(em.parentId).BusinessHoursId= vCustCareEmailBoxMap_BCCAddr.get(tempHold).Business_Hours__c ;
                                vCsMap.get(em.parentId).Case_Group__c=vCustCareEmailBoxMap_BCCAddr.get(tempHold).Case_Group__c;
                                if(vCustCareEmailBoxMap_BCCAddr.get(tempHold).Office__c != null)
                                vCsMap.get(em.parentId).Office__c=vCustCareEmailBoxMap_BCCAddr.get(tempHold).Office__c;                   
                             }
                       }
                   }
             }  
                //20/06/2014 added condition as it should excute only when contact was null
               //If email is from Internal Employee(if from address contains @te.com) then update Internal contact
                 /*if((em.FromAddress.contains('@te.com') && (vCsMap.get(em.parentId).Quick_Email__c == false) && ( em.FromAddress != vMapNametoApexHlprSetting.get('customercare.us@te.com').Value__c ||
                 em.FromAddress != vMapNametoApexHlprSetting.get('customercare.us-websites@te.com').Value__c ||
                 em.FromAddress != vMapNametoApexHlprSetting.get('customercare.emea@te.com').Value__c ||
                 em.FromAddress != vMapNametoApexHlprSetting.get('customercare.apac@te.com').Value__c ||
                 em.FromAddress != vMapNametoApexHlprSetting.get('cssc.apac@te.com').Value__c ||
                 em.FromAddress != vMapNametoApexHlprSetting.get('CCEWS.EMEA@TE.com').Value__c) 
                 )){
                     if((vCsMap.get(em.parentId).ContactId==null) || ((vCsMap.get(em.parentId).Contact.Email != null && vCsMap.get(em.parentId).SuppliedEmail != null) && (vCsMap.get(em.parentId).Contact.Email != vCsMap.get(em.parentId).SuppliedEmail))){
                     vCsMap.get(em.parentId).AccountId = vMapNametoApexHlprSetting.get('Customer Care Account').Value__c;
                     vCsMap.get(em.parentId).ContactId = vMapNametoApexHlprSetting.get('Customer Care Contact').Value__c;
                     if((!vMapEmailtoTEmployee.isEmpty()) && vMapEmailtoTEmployee.containsKey(em.FromAddress))
                     vCsMap.get(em.parentId).Internal_Contact__c = vMapEmailtoTEmployee.get(em.FromAddress).id;
                     vCsMap.get(em.parentId).EntitlementId = vMapNametoApexHlprSetting.get('Internal Contact Entitlement').Value__c;
                     //vInternalConCases.add(vCsMap.get(em.parentId));
                    }
                 }*/
                 updateCaseMap.put(em.parentId,vCsMap.get(em.parentId));
                 //vupCaseLst_CCP.add(vCsMap.get(em.parentId));
              } 
               
            }    
        }
        //if(vupCaseLst_CCP.isEmpty() == false) update vupCaseLst_CCP;
        //if(vInternalConCases.isEmpty() == false) update vInternalConCases;
        if(!updateCaseMap.isEmpty()) update updateCaseMap.values();
        
     }
     
     //Logic runs for cases created through Quick Email button
     system.debug('---------'+strToaddress+'----'+quicktomail);
     if(vQuickEmail_CsMap.isEmpty() == false){
         System.debug('updating quick emacaseeeee 11111');
         
         Integer contactscount=0;
         Integer strcount1=0;
         for(EmailMessage  em : Trigger.new){
            if(vQuickEmail_CsMap.containskey(em.parentId) && em.Incoming == false){
            
                if(em.Incoming == false &&  vQuickEmail_CsMap.get(em.parentId).Quick_Email__c == true ){
                  vQuickEmail_CsMap.get(em.parentId).Subject=em.subject;
                  //vQuickEmail_CsMap.get(em.parentId).Status = 'Closed';
                  vQuickEmail_CsMap.get(em.parentId).Description = em.TextBody;
                  if(vCustCareEmailBoxMap.containsKey(em.FromAddress))
                  {
                    vQuickEmail_CsMap.get(em.parentId).BusinessHoursId= vCustCareEmailBoxMap.get(em.FromAddress).Business_Hours__c ;
                    vQuickEmail_CsMap.get(em.parentId).GIBU__c = vCustCareEmailBoxMap.get(em.FromAddress).GIBU__c;
                    
                    vQuickEmail_CsMap.get(em.parentId).Region__c =vCustCareEmailBoxMap.get(em.FromAddress).Region__c;
                    
                    vQuickEmail_CsMap.get(em.parentId).Case_Group__c=vCustCareEmailBoxMap.get(em.FromAddress).Case_Group__c;
                    if(vCustCareEmailBoxMap.get(em.FromAddress).Office__c != null)
                    vQuickEmail_CsMap.get(em.parentId).Office__c=vCustCareEmailBoxMap.get(em.FromAddress).Office__c;
                  }
              
              
              for(string str:em.ToAddress.split(';',-2))
              {                      
                  if(strcount1!=0)str=str.substring(1, str.length());
                  if(strcount1==0)strcount1++;
                  if(map_quickemail_contact.containsKey(str) && vQuickEmail_CsMap.get(em.parentId).contactId==null)
                  {
                      vQuickEmail_CsMap.get(em.parentId).contactId=map_quickemail_contact.get(str).Id;
                      vQuickEmail_CsMap.get(em.parentId).AccountId=map_quickemail_contact.get(str).accountId;
                      contactscount=1;
                      break;
                      
                  }
                  //if((!vMapEmailtoTEmployee.isEmpty()) && vMapEmailtoTEmployee.containsKey(str))
                  //vQuickEmail_CsMap.get(em.parentId).Internal_Contact__c = vMapEmailtoTEmployee.get(str).Id;
              }
            /*if(contactscount==0 && vQuickEmail_CsMap.get(em.parentId).contactId==null)
            {  
                vQuickEmail_CsMap.get(em.parentId).AccountId = vMapNametoApexHlprSetting.get('Customer Care Account').Value__c;
                vQuickEmail_CsMap.get(em.parentId).ContactId = vMapNametoApexHlprSetting.get('Customer Care Contact').Value__c;
                //vQuickEmail_CsMap.get(em.parentId).Internal_Contact__c = vMapEmailtoTEmployee.get(str).id;
                vQuickEmail_CsMap.get(em.parentId).EntitlementId = vMapNametoApexHlprSetting.get('Internal Contact Entitlement').Value__c;
            }*/
                 
           updateQuickCaseMap.put(em.parentId,vQuickEmail_CsMap.get(em.parentId));
           //vQuickEmail_CsLst.add(vQuickEmail_CsMap.get(em.parentId));  
           }
         }
        }      
        //if(vQuickEmail_CsLst.isEmpty() == false) update vQuickEmail_CsLst;
        if(updateQuickCaseMap.isEmpty() == false) update updateQuickCaseMap.values();
     }
    }catch(Exception e){
       CCP_Exception_Util.CCP_Exception_Mail(e);
    }  
    }
}