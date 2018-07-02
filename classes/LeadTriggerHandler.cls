/**************************************************************************************************************************************************
Name:  Lead_BI_executeRoute
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This Trigger handler class contains business process methods and technical process methods for sharing LeadMQL & ContactMQL records with CJM Team Members
---------------------------------------------------------------------------------------------------------------------------------------------------       
APEX Triggers utilize this class: Lead_BI_executeRoute and MQLTrigger_CJMRoute
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date             Detail                               Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
1.0 Subramanian       01/05/2018      Initial Development                      Select growth long term project

**************************************************************************************************************************************************/
Public class LeadTriggerHandler{

    public static boolean isExecuted = FALSE;
    Public Static void OwnerAssignment(List<Lead> LeadList, Map<Id,Lead> LeadOldMap){
        
        //List<Lead> list_lead2Init = new List<Lead>(); ----commented out by juillet yuan 2015-02-04
        List<Lead> list_lead2Route = new List<Lead>();
        //Set<String> set_queueIndustry = new Set<String>{'Alternative Energy', 'Lighting', 'Intelligent Building', 'HVAC', 'Appliance', 'Data Comunications', 'Instrumentation', 'Rail', 'Automation & Control', 'other', 'Electrical components'};     
        set<id> set_GrpIds = new set<id>();   
        Id leadResponseTypeID;
        Id leadEventLeadTypeID;
        Id leadCentralTypeID;
        Id leadC2SEventLeadTypeID;
        
        //00888305 - 2015-9-4 Updated by Pankaj Raijade - Start
        Apex_Helper_Settings__c APHResponse = Apex_Helper_Settings__c.getinstance('Lead Response RT Id');
        if (APHResponse != null && APHResponse.Active__c)
            leadResponseTypeId = APHResponse.Value__c;
        
        Apex_Helper_Settings__c APHEventLeadType = Apex_Helper_Settings__c.getinstance('Lead Event Lead RT Id');
        if (APHEventLeadType != null && APHEventLeadType.Active__c)
            leadEventLeadTypeID = APHEventLeadType.Value__c;
        
        Apex_Helper_Settings__c APHCentral = Apex_Helper_Settings__c.getinstance('Lead Central RT Id');
        if (APHCentral != null && APHCentral.Active__c)
            leadCentralTypeID = APHCentral.Value__c;
        
        //00901154 - 2017-01-19 updated by Subramanian Jairam
        Apex_Helper_Settings__c APHC2SEventLead = Apex_Helper_Settings__c.getinstance('Lead C2S Event Id');
        if (APHC2SEventLead != null && APHC2SEventLead.Active__c)
            leadC2SEventLeadTypeID = APHC2SEventLead.Value__c;
            
        List<Lead> selectCustomerList = new List<Lead>();
        List<Lead> targetCustomerList = new List<Lead>();
        List<Lead> nonSelecttargetCustomerList = new List<Lead>();
        RoundRobinCJMRoute CJMUserRoute = new RoundRobinCJMRoute();
        
        //Getting constant values
        Map<String, MQLs_Constant_Variables__c> MQLConstant = MQLs_Constant_Variables__c.getAll();
        //Getting information from Sales Hierarchy for Territory Code mentioned in custom setting
       // Set<String> routeToCJMUser = CJMUserRoute.NonSelectTargetCustomer();
        try{
            for(Lead l :LeadList)
            {  
                if(l.DCT_Flag__c){
                   l.Queue_Reason__c = system.label.Queue_Reason_ZSD_DMM; 
                   continue;
                }                
                
                boolean nonSelectTarget = TRUE;           
                //Checking Key Customer Code - Mandatory        
                if(String.isNotEmpty(l.Key_Customer_Cde__c) && !l.DCT_Flag__c && l.RecordTypeId == leadCentralTypeID){
                    List<String> selectCustomer = new List<String>();
                    List<String> targetCustomer = new List<String>();
                                
                    //Getting Key Customer Code from Custom setting
                     if(MQLConstant.containsKey('selectcustomer')) {
                         selectCustomer = MQLConstant.get('selectcustomer').Constants__c.toLowerCase().split(',');
                     }
                     if(MQLConstant.containsKey('targetcustomer')) {
                         targetCustomer = MQLConstant.get('targetcustomer').Constants__c.toLowerCase().split(',');
                     }
                     
                    //Validating Key Customer Code for Select Customer.
                    for(String s: selectCustomer){
                        //Adding Leads for RoundRobin
                        if(l.Key_Customer_Cde__c.toLowerCase().startsWith(s)){
                            l.Queue_Reason__c= '';
                            nonSelectTarget = FALSE;
                            if(Trigger.isInsert || LeadOldMap.get(l.Id).RecordTypeId != leadCentralTypeID){
                                selectCustomerList.add(l);
                            }
                            if(MQLConstant.get('defaultleadassignment').Constants__c.contains(l.Ownerid)){
                                l.ownerId = LeadOldMap.get(l.Id).ownerId;
                            }
                            break;
                        }
                    }   
                    
                    if(nonSelectTarget){
                        //Validating Key Customer Code for Target Customer. 
                        for(String t: targetCustomer){
                            //Adding MQLRecords for RoundRobin
                            if(l.Key_Customer_Cde__c.toLowerCase().startsWith(t)){
                                l.Queue_Reason__c= '';
                                nonSelectTarget = FALSE;
                                if(Trigger.isInsert || LeadOldMap.get(l.Id).RecordTypeId != leadCentralTypeID){
                                    targetCustomerList.add(l);                            
                                }
                                if(MQLConstant.get('defaultleadassignment').Constants__c.contains(l.Ownerid)){
                                    l.ownerId = LeadOldMap.get(l.Id).ownerId;
                                }
                                break;
                            }                        
                        }
                    }
                }
                
                //Routing Non Select and Target Customer CJM User
                if(nonSelectTarget && !l.DCT_Flag__c){
                  if(string.IsnotEmpty(l.Assignee_Network_Id__c) && MQLConstant.get('assign-cjm-user-territory').Constants__c.toLowerCase().contains(l.Assignee_Network_Id__c.toLowerCase())){ 
                      if(Trigger.isInsert || (LeadOldMap.get(l.Id).RecordTypeId != leadCentralTypeID  && l.RecordTypeId == leadCentralTypeID)){
                          selectCustomerList.add(l);
                      }
                      if(MQLConstant.get('defaultleadassignment').Constants__c.contains(l.Ownerid)){
                          l.ownerId = LeadOldMap.get(l.Id).ownerId;
                      }
                  }else{
                      nonSelecttargetCustomerList.add(l);
                  }                  
                }  
            }
            
            //Assigning MQLRecords to CJM Users on RoundRobin
            if(!selectCustomerList.isEmpty()){
                system.debug('SelectCustomer##');
                CJMUserRoute.SelectCustomer(selectCustomerList, 'LeadMQL');  
                RoundRobin.UserAssignment(selectCustomerList);
            }  
            if(!targetCustomerList.isEmpty()) {
                system.debug('TargetCustomer##');
                CJMUserRoute.TargetCustomer(targetCustomerList);
                RoundRobin.UserAssignment(targetCustomerList);
            }

            if(nonSelecttargetCustomerList != NULL && nonSelecttargetCustomerList.Size() > 0){
                //00888305 - 2015-9-4 Updated by Pankaj Raijade - end
                //Start : Modified by mahesh Babu for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34    
                /*
                //Start : Added by Rajendra for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34    
                if(OldLeadMap.IsEmpty()){
                ClsRouteLeadUtil.channelLeadOwnerAssignment(trigger.new);
                }
                //End : Added by Rajendra for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34
                */
               
                if(Trigger.isUpdate){
                   system.debug('before update trigger check -->');
                   set_GrpIds = ClsRouteLeadUtil.channelFilterLeads();     
                } 
                //End : Modified by mahesh Babu for Lead Routing project phase 2 Req 2 - https://tecentral.my.salesforce.com/a0R1600000b4l34
                
                //Routing Non Select and Target Customer
                for(Lead l: nonSelecttargetCustomerList){   
                    if(l.RecordTypeId == leadResponseTypeId  || l.RecordTypeId == leadEventLeadTypeID || l.RecordTypeId == leadC2SEventLeadTypeID){ //00888305 - 2015-9-4 Updated by Pankaj Raijade
                        continue;
                    }
                    system.debug('before insert check -->');
                    if(trigger.isInsert || (l.Owner_Assigned__c != null && l.Owner_Assigned__c != LeadOldMap.get(l.Id).Owner_Assigned__c) ||
                      (l.RecordTypeId == leadCentralTypeID && LeadOldMap.get(l.Id).RecordTypeId == leadResponseTypeID) ||
                      (trigger.isUpdate && LeadOldMap.get(l.Id) != null && LeadOldMap.get(l.Id).ownerId != null &&   // Mahesh CLR Req-02 Channel ZSD DMM logic   
                       !set_GrpIds.isEmpty() && !set_GrpIds.contains(LeadOldMap.get(l.Id).ownerId) && l.ownerid != null && // Mahesh CLR Req-02 Channel ZSD DMM logic  
                        set_GrpIds.contains(l.ownerId))) // Mahesh CLR Req-02 Channel ZSD DMM logic     
                    {
                        list_lead2Route.add(l); 
                    }                  
                    
                }                                                                                        
            }
            if(!list_lead2Route.isEmpty()){ ClsRouteLeadUtil.routeLead_new(list_lead2Route); }
            
            
        }catch (exception e) {
            String vStrError = 'Error Type = ' + e.getTypeName() + 
                                ' Error Line = ' + e.getLineNumber() + '' + 
                                ' Error Stack = ' + e.getStackTraceString() + 
                                ' Error Message = ' + e.getMessage();
                            
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                     SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        }
    }
}