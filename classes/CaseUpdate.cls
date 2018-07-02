/************************************************************************************************************************************************************************************************************************
Name: CaseUpdate 
Test Class Name: CaseUpdate_Test coverage 87%
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===========================================================================================================================================================================================================
Purpose: This class is intended for the functionality that was defined in previous two triggers(UpdateCase and AI_UpdateCaseMilestone_CCP) on Email Message. 
         The initial portion is responsible for populating the fields on Case like GIBU,Region,Case Group based on match found in custom setting when the case record gets created normally or through quick email button.
         The second portion defines methods that would update case for fields for email addresses,incoming/outgoing email count and the case milestone as completed if response to user is send within response time.
===========================================================================================================================================================================================================
VERSION       AUTHOR                      DATE                                   
 1.0       Narasimha/Abhijeet             8/10/2013  
 1.1       Nooreen Shaikh                 28/11/2014
 1.2       Narasimha Narra                27/03/2015   updated logic for same email having more than two shared email box in ToAddresss
 1.3       Nooreen Shaikh                 10/08/2015   added Pic recordtype condition to exclude Pic cases from methods defined for CC      
 1.4       Rajendra Shahane               05/05/2016   added logic to update Count_Incoming_Emails__c,Count_Outgoing_Emails__c fields for PIC cases
***********************************************************************************************************************************************************************************************************************/

public class CaseUpdate{

    public void CaseUpdateMethod(List<EmailMessage> pEMessageLst){     
    
        /*** Variable declaration ***/
        Apex_Helper_Settings__c vCaseRT = Apex_Helper_Settings__c.getInstance('DataComm - Customer Care');
        Apex_Helper_Settings__c vCaseRT_CCP = Apex_Helper_Settings__c.getInstance('Customer Care Cloud');
        Apex_Helper_Settings__c vCaseRT_PIC = Apex_Helper_Settings__c.getInstance('PIC Service Cloud');
        Set<Id> vCsId = new Set<Id>();
        Set<Id> vSetCsOwnerId = new Set<Id>();
        Set<String> vUserEmailSet = new Set<String>();
        List<Case> vCaselist=new List<Case>();        
        Map<Id,Case> updateCaseMap = new Map<Id,Case>();
        List<Case> vupCaseLst_CCP = new List<Case>(); //used in commented code
        List<Case> vInternalConCases = new List<Case>(); //used in commented code
        List<Case> vQuickEmail_CsLst = new List<Case>(); //used in commented code
        Map<Id,Case> mapPICCaseToUpdate = new Map<Id,Case>();// added by Rajendra Shahane for Case 900721 5/5/2016
        Map<Id,EmailMessage> mapCaseIdToEmailMessage = new Map<Id,EmailMessage>();// added by Rajendra Shahane for Case 900721 5/5/2016
        Map<Id,Case> updateQuickCaseMap = new Map<Id,Case>();
        Map<Id,Case> vCsMap = new Map<Id,Case>();
        Map<Id,Case> vQuickEmail_CsMap = new Map<Id,Case>();
        Set<String> vEmailFromAddSet = new Set<String>();
        set<string> quicktomail = new set<string>();
        map<string,contact> map_quickemail_contact = new map<string,contact>();
        Map<String,Apex_Helper_Settings__c> vMapNametoApexHlprSetting = Apex_Helper_Settings__c.getAll(); //used in commented code
        string strToaddress ='';
        String vEmToCCAddress = '';
        Integer vSharedEmailBoxCount = 0;
        set<string> vSetEmailId = new set<string>();
        Set<String> vEMSubjectSet = new Set<String>();
        Set<String> vEMToaddressSet = new Set<String>();
        Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMapAll = Customer_Care_SharedEmailBox__c.getAll();
        Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap = new  Map<String, Customer_Care_SharedEmailBox__c>();
        Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap_BCCAddr = new  Map<String, Customer_Care_SharedEmailBox__c>();
        /***  Variable declaration ***/
          
        List<EmailMessage> pEMLst = new List<EmailMessage>();
        Map<Id,Case> vMapCs;
        Set<Id> vSetCsId = new Set<Id>();
        vSetCsOwnerId = new Set<Id>();
        vUserEmailSet = new Set<String>();
        vCsId = new Set<Id>();
        List<EmailMessage> lstEM= new List<EmailMessage>();
        vCaselist=new List<Case>();
        Map<Id,Case> vUpdatedmapfromvGEDC = new map<Id,Case>();
        Map<Id,Case> vUpdatedmapfromvCEC  = new map<Id,Case>();
        Map<Id,Boolean> vcaseWithStatus = new Map<Id,Boolean>();
        Integer strcount=0; 
    
        if(CaseUtil_CCP.updateCaseboolean1 == false){
            CaseUtil_CCP.updateCaseboolean1 =true;
            Case ca = new Case();
            try{    
                /*************** The following portion executes functionality of UpdateCase trigger ***************/
                /*** Collections ***/
                for(EmailMessage em2: pEMessageLst){
                    mapCaseIdToEmailMessage.put(em2.parentId,em2);
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

                for(string str:strToaddress.split(';',-2)){
                    if(strcount!=0)str=str.substring(1, str.length());
                    if(strcount==0)strcount++;
                }

                List<String> vEMLst = vEmToCCAddress.split(';',-2);
                System.debug('VEMLSttttttt'+vEMLst);
                for(string str2 : vEMLst){    
                    str2 = str2.trim();
                    if(strcount!=0)str2=str2.substring(0, str2.length());
                    if(strcount==0)strcount++;
                    if(str2 != null || str2 != '')
                    vSetEmailId.add(str2);
                    System.debug(str2+'*****'+str2.length());
                }

                //Create separate lists of CCP cases and Datacomm cases
                vCaselist = [Select id,ownerid,Subject,Contact.Email,SuppliedEmail,Region__c,Office__c ,recordtypeid,IsClosed,Description,Status,createddate,contactId,accountId,Quick_Email__c,Entitlementid,Case_Group__c, GIBU__c,Count_Incoming_Emails__c,Count_Outgoing_Emails__c, CaseCount__c from Case where ID in: vCsId];            
                for(Case cs : vCaselist){
                    //Start:added by rajendra shahane for case 900721
                    /*if(cs.recordtypeId == vCaseRT_PIC.Value__c)
                    {
                        EmailMessage currentEM = mapCaseIdToEmailMessage.get(cs.id);
                        if(currentEM.Incoming == true)
                            cs.Count_Incoming_Emails__c += 1;
                        else
                            cs.Count_Outgoing_Emails__c += 1;
                        mapPICCaseToUpdate.put(cs.id,cs);
                    }*/
                    //End:added by rajendra shahane for case 900721
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
                    if(!vQuickEmail_CsMap.isEmpty()){    
                        for(contact con:[select id,email,AccountId from contact where email !=null AND email in: vSetEmailId]){
                            map_quickemail_contact.put(con.email,con);
                        }
                    }           
                    //Create set of email addressess of case owners 
                    for(User u : [Select id,email from User where id in: vSetCsOwnerId]){
                        vUserEmailSet.add(u.email);
                    } 
                }
                System.debug('vQuickEmail_CsMap**'+vQuickEmail_CsMap); 
                
                for(Customer_Care_SharedEmailBox__c ccs:vCustCareEmailBoxMapAll.values()){
                    vCustCareEmailBoxMap.put(ccs.Name.toLowerCase(),ccs);
                    if(ccs.SFDC_Routing_Address__c != null)
                        vCustCareEmailBoxMap_BCCAddr.put(ccs.SFDC_Routing_Address__c.toLowerCase(),ccs);
                } 
                System.debug('*** vCustCareEmailBoxMap ***'+vCustCareEmailBoxMap);
                System.debug('*** vCustCareEmailBoxMap_BCCAddr ***'+vCustCareEmailBoxMap_BCCAddr);

                Integer strcount2 = 0;
                System.debug('vEMToaddressSet'+vEMToaddressSet);
                Set<Id> vMultipleCsIdSet = new set<Id>();
                set<string> vCaseGroupSet = new set<string>();

                /*for(string str : vSetEmailId){
                    if(vCustCareEmailBoxMap.containsKey(str))
                    vSharedEmailBoxCount = vSharedEmailBoxCount + 1;
                }
                if(ca.Id==null){
                    //Create set of caseids created with same email having more than two shared email box in ToAddresss or CC address
                    for(Emailmessage e : [Select id,messagedate,parentid,subject,Toaddress,ccaddress from emailmessage where ( messagedate >: (System.now().addminutes(-1))) and (subject != null and subject in: vEMSubjectSet) and ((toaddress!= null OR ccaddress != null) and (toaddress in: vEMToaddressSet OR ccaddress in: vEMToaddressSet)) ]){            
                        vMultipleCsIdSet.add(e.parentid);
                    }
                    for(Case c : [Select id,Case_Group__c,casenumber,GIBU__c from case where id in: vMultipleCsIdSet]){
                        vCaseGroupSet.add(c.Case_Group__c);
                    }
                }*/ //commented on 27/3/2015 by narasimha and modified below logic

                /*** The following portion updates the case fields GIBU,Region,etc based on match found in custom setting ***/           
                if(vCsMap.isEmpty() == false){
                    for(EmailMessage  em : pEMessageLst){
                        if(vCsMap.containskey(em.parentId)){
                            if((vCsMap.get(em.parentId).Count_Incoming_Emails__c == null || vCsMap.get(em.parentId).Count_Incoming_Emails__c == 0) && em.Incoming == true && em.headers != null){
                                /*for(string str : vSetEmailId){        
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
                                            */  //commented on 27/3/2015 by narasimha
                                            String vEMHeader= (String)em.headers;
                                            vEMHeader = vEMHeader.replaceall('\n','');
                                            vEMHeader = vEMHeader.replaceall(',','');
                                            vEMHeader = vEMHeader.replaceall('"','');
                                            String tempHold = vEMHeader.substring(vEMHeader.indexof('X-SFDC-Original-RCPT:'),vEMHeader.length());
                                            tempHold = tempHold.substring(tempHold.indexof('-RCPT:')+7,tempHold.indexof('.com')+4);
                                            System.debug('Shared Email Address in BCC'+tempHold);
                                            if(vCustCareEmailBoxMap_BCCAddr.containskey(tempHold)){
                                                vCsMap.get(em.parentId).GIBU__c = vCustCareEmailBoxMap_BCCAddr.get(tempHold).GIBU__c;
                                                if(vCsMap.get(em.parentId).GIBU__c == 'CSSC'){
                                                    vCsMap.get(em.parentId).Is_CSSC__c = True;    
                                                }                                                                                              
                                                vCsMap.get(em.parentId).Region__c =vCustCareEmailBoxMap_BCCAddr.get(tempHold).Region__c;
                                                vCsMap.get(em.parentId).BusinessHoursId= vCustCareEmailBoxMap_BCCAddr.get(tempHold).Business_Hours__c ;
                                                vCsMap.get(em.parentId).Case_Group__c=vCustCareEmailBoxMap_BCCAddr.get(tempHold).Case_Group__c;
                                                if(vCustCareEmailBoxMap_BCCAddr.get(tempHold).Office__c != null)
                                                vCsMap.get(em.parentId).Office__c=vCustCareEmailBoxMap_BCCAddr.get(tempHold).Office__c;                   
                                            }
                                        //}
                                     //}
                                //}  
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
                                System.debug('*** updateCaseMap ***'+updateCaseMap);                     
                            }                
                        }    
                    }
                    //if(vupCaseLst_CCP.isEmpty() == false) update vupCaseLst_CCP;
                    //if(vInternalConCases.isEmpty() == false) update vInternalConCases;
                    // if(!updateCaseMap.isEmpty()) update updateCaseMap.values();  Commented on 26-11-14        
                }

                //Logic runs for cases created through Quick Email button
                system.debug('---------'+strToaddress+'----'+quicktomail);
                if(vQuickEmail_CsMap.isEmpty() == false){
                    System.debug('updating quick emacaseeeee 11111');

                    Integer contactscount=0;
                    Integer strcount1=0;
                    for(EmailMessage  em : pEMessageLst){
                        if(vQuickEmail_CsMap.containskey(em.parentId) && em.Incoming == false){            
                            if(em.Incoming == false &&  vQuickEmail_CsMap.get(em.parentId).Quick_Email__c == true ){
                                System.debug('Entered if loop 1');
                                vQuickEmail_CsMap.get(em.parentId).Subject=em.subject;
                                //vQuickEmail_CsMap.get(em.parentId).Status = 'Closed';
                                vQuickEmail_CsMap.get(em.parentId).Description = em.TextBody;
                                System.debug('vCustCareEmailBoxMap.containsKey(em.FromAddress)'+vCustCareEmailBoxMap.containsKey(em.FromAddress));                                 
                                if(vCustCareEmailBoxMap.containsKey(em.FromAddress)){
                                    vQuickEmail_CsMap.get(em.parentId).BusinessHoursId= vCustCareEmailBoxMap.get(em.FromAddress).Business_Hours__c ;
                                    vQuickEmail_CsMap.get(em.parentId).GIBU__c = vCustCareEmailBoxMap.get(em.FromAddress).GIBU__c; 
                                    if(vQuickEmail_CsMap.get(em.parentId).GIBU__c == 'CSSC'){
                                       vQuickEmail_CsMap.get(em.parentId).Is_CSSC__c = True;    
                                    }                                     
                                    vQuickEmail_CsMap.get(em.parentId).Region__c =vCustCareEmailBoxMap.get(em.FromAddress).Region__c;

                                    vQuickEmail_CsMap.get(em.parentId).Case_Group__c=vCustCareEmailBoxMap.get(em.FromAddress).Case_Group__c;
                                    if(vCustCareEmailBoxMap.get(em.FromAddress).Office__c != null)
                                    vQuickEmail_CsMap.get(em.parentId).Office__c=vCustCareEmailBoxMap.get(em.FromAddress).Office__c;
                                    System.debug('*** vQuickEmail_CsMap @@@ ***'+vQuickEmail_CsMap);
                                }

                                for(string str:em.ToAddress.split(';',-2)){                      
                                    if(strcount1!=0)str=str.substring(1, str.length());
                                    if(strcount1==0)strcount1++;
                                    if(map_quickemail_contact.containsKey(str) && vQuickEmail_CsMap.get(em.parentId).contactId==null){
                                        vQuickEmail_CsMap.get(em.parentId).contactId=map_quickemail_contact.get(str).Id;
                                        vQuickEmail_CsMap.get(em.parentId).AccountId=map_quickemail_contact.get(str).accountId;
                                        System.debug('*** vQuickEmail_CsMap $$$ ***'+vQuickEmail_CsMap);
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
                                System.debug('*** updateQuickCaseMap ***'+updateQuickCaseMap);
                                //vQuickEmail_CsLst.add(vQuickEmail_CsMap.get(em.parentId));  
                            }
                        }
                    }      
                    //if(vQuickEmail_CsLst.isEmpty() == false) update vQuickEmail_CsLst;
                    // if(updateQuickCaseMap.isEmpty() == false) update updateQuickCaseMap.values(); Commented on 26-11-14
                }

                /*************** The following portion executes functionality as defined in the methods (part of AI_UpdateCaseMilestone_CCP trigger) ***************/               
                
                //Create list of emails excluding auto response
                for(EmailMessage em : pEMessageLst){
                    if(em.FromAddress != 'customersupport@te.com'){
                        vSetCsID.add(em.parentID);
                        pEMLst.add(em);
                    }
                }
                System.debug('*** vSetCsID ***'+vSetCsID);
                System.debug('*** pEMLst ***'+pEMLst);

                if(vSetCsID.size() > 0){
                    //Create a map of case; Pic recordtype condition in query below added by Nooreen Shaikh on 2015-08-10
                    vMapCs = new Map<Id,Case>([Select id,Subject,Case_Re_Open_Reason__c ,Email_Subject__c,Email_CCAddress__c ,Email_ToAddress__c,businesshoursid,createddate,OwnerID,SuppliedEmail,isClosed,status,recordtypeid,contactid,
                    Count_Incoming_Emails__c,Count_Outgoing_Emails__c,First_Response_is_Final_Response__c,Email_SentDate__c,Email_FromAddress__c,Quick_Email__c from Case where id in: vSetCsId and recordtypeid !=: vCaseRT_PIC.Value__c]); 
                    System.debug('*** vMapCs 1 ***'+vMapCs);

                    if(!updateCaseMap.isEmpty() && !vMapCs.isEmpty()){
                        for(Case c : vMapCs.values()){
                            if(updateCaseMap.containskey(c.id)){
                                vMapCs.put(c.id,updateCaseMap.get(c.id));
                            }
                        } 
                    System.debug('*** vMapCs updateCaseMap ***'+vMapCs);  
                    }
                    if(!updateQuickCaseMap.isEmpty() && !vMapCs.isEmpty()){
                        for(Case c : vMapCs.values()){
                            if(updateQuickCaseMap.containskey(c.id)){
                            vMapCs.put(c.id,updateQuickCaseMap.get(c.id));
                            }
                        }
                        System.debug('*** vMapCs updateQuickCaseMap ***'+vMapCs);
                    }

                    //Create set of case ownerids if Owner is user not queue and set of user email id's
                    for(Case cs : vMapCs.values()){
                        String tOwner = cs.OwnerID;
                        if(tOwner.startsWith('005'))
                            vSetCsOwnerId.add(cs.ownerId);
                    }
                    System.debug('*** vSetCsOwnerId ***'+vSetCsOwnerId);

                    for(User u : [Select id,email from User where id in: vSetCsOwnerId]){
                        vUserEmailSet.add(u.email); 
                    }
                    System.debug('*** vUserEmailSet ***'+vUserEmailSet);
                }

                /******  Calling the methods to update fields on Case and the Case Milestone ******/
                if(updateQuickCaseMap.isEmpty() && !vMapCs.isEmpty()){
                    if(CaseUtil_CCP.UpdateCasewithEmailDatails == false){
                        CaseUtil_CCP.UpdateCasewithEmailDatails = true;
                        Get_Email_DetailsonCase vGEDC = new Get_Email_DetailsonCase(); //This method populates some address fields on Case
                        vUpdatedmapfromvGEDC = vGEDC.EmailDetails(pEMLst,vMapCs,vUserEmailSet,vCustCareEmailBoxMap); //Put the values from this method into a new map           
                        System.debug('vUpdatedmapfromvGEDC---- '+vUpdatedmapfromvGEDC ); 
                    }
    
                    /*** Update vMapCs with updated cases from Get_Email_DetailsonCase class ***/
                    for(Case c : vMapCs.values()){
                        if(vUpdatedmapfromvGEDC.containskey(c.id)){
                            vMapCs.put(c.id,vUpdatedmapfromvGEDC.get(c.id));
                            vcaseWithStatus.put(c.Id,true); 
                        }
                    }
                    System.debug('*** vMapCs after Get_Email_DetailsonCase ***'+vMapCs);
                    System.debug('*** vcaseWithStatus Get_Email_DetailsonCase ***'+vcaseWithStatus);
    
                    vUpdatedmapfromvGEDC.clear();
                }
                if(CaseUtil_CCP.Countoncaseboolean==false && !vMapCs.isEmpty()){
                    CaseUtil_CCP.Countoncaseboolean=true;
                    CountEmailsonCase vCEC = new CountEmailsonCase(); //This method checks if email is inbound or sent through outlook and if contact with entitlement exist or not, if yes then associates case with contact and respective account
                    vUpdatedmapfromvCEC = vCEC.CountEmailsMethod(pEMLst,vMapCs,vUserEmailSet,vCustCareEmailBoxMap); //Put the values from this method into a new map           
                    System.debug('vUpdatedmapfromvCEC------  '+vUpdatedmapfromvCEC ); 
                }

                /*** Update vMapCs with updated cases from CountEmailsonCase class ***/
                for(Case c : vMapCs.values()){
                    if(vUpdatedmapfromvCEC != null && vUpdatedmapfromvCEC.containskey(c.id)){//if(vUpdatedmapfromvCEC.containskey(c.id)){ modified by rajendra shahane for case 900721
                        vMapCs.put(c.id,vUpdatedmapfromvCEC.get(c.id));
                        vcaseWithStatus.put(c.Id,true); 
                    }
                }
                System.debug('*** vMapCs after CountEmailsonCase ***'+vMapCs);
                System.debug('*** vcaseWithStatus CountEmailsonCase ***'+vcaseWithStatus);

                if(vUpdatedmapfromvCEC != null)vUpdatedmapfromvCEC.clear();

                /*** Create a final list of cases to update ***/
                //added by rajendra shahane for case 900721
                map<Id,Case> vFinalUpdateList = new map<Id,Case>(); //List<Case> vFinalUpdateList = new List<Case>(); modified by rajendra shahane for case 900721
                for(Case cs: vMapCs.values()){
                    if(vcaseWithStatus.containsKey(cs.Id) && vcaseWithStatus.get(cs.Id)){             
                        vFinalUpdateList.put(cs.Id,vMapCs.get(cs.Id)); //vFinalUpdateList.add(vMapCs.get(cs.Id)); modified by rajendra shahane for case 900721
                    }          
                }
                System.debug('*** vFinalUpdateList ***'+vFinalUpdateList);               
                //update list of cases
                //Start:added by rajendra shahane for case 900721
                /*if(mapPICCaseToUpdate.size() > 0)
                {
                    for(Id caseid: mapPICCaseToUpdate.keyset())
                    {
                        if(!vFinalUpdateList.containskey(caseid))
                            vFinalUpdateList.put(caseid,mapPICCaseToUpdate.get(caseid));
                    }
                }*/
                
                
                //End:added by rajendra shahane for case 900721
                if(vFinalUpdateList != null && vFinalUpdateList.size() > 0){
                    update vFinalUpdateList.values();//update vFinalUpdateList; modified by rajendra shahane for case 900721
                }     

                if(trigger.isafter&& CaseUtil_CCP.EmailMsgboolean == false){
                    CaseUtil_CCP.EmailMsgboolean = true;
                    CompleteMilestone_CCP vCMCCP = new CompleteMilestone_CCP(); //This method updates the Case Milestone as completed if response to user is sent.
                    vCMCCP.MarkMilestoneasCompleted(pEMLst,vMapCs,vUserEmailSet,vCustCareEmailBoxMap);
                    System.debug('*** CountEmailsMethod ***'); 
                }  
            }catch(Exception e){
                System.debug('Exception in email message trigger'+e);
                CCP_Exception_Util.CCP_Exception_Mail(e); 
                } 
        }
    }
}