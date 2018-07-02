/**************************************************************************************************************************************************
Name:  MQLTriggerHandler
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
Public class MQLTriggerHandler{

    
    Public Static Void AssignToCJMUser(List<TEMarketing__MQLRecord__c> MQLRecords, Map<Id,TEMarketing__MQLRecord__c> OldMQLRecords){
        try{
            //Variable declaration
            List<TEMarketing__MQLRecord__c> selectCustomerList = new List<TEMarketing__MQLRecord__c>();
            List<TEMarketing__MQLRecord__c> targetCustomerList = new List<TEMarketing__MQLRecord__c>();
            RoundRobinCJMRoute CJMUserRoute = new RoundRobinCJMRoute();
            
            //Getting constant values
            Map<String, MQLs_Constant_Variables__c> MQLConstant = MQLs_Constant_Variables__c.getAll();
            Map<Id, TEMarketing__MQLRecord__c> leadMQLRecordMap = new Map<Id, TEMarketing__MQLRecord__c>();
            Set<Id> reMQLLeads = new Set<Id>();
            
            for(TEMarketing__MQLRecord__c MQLRecord: MQLRecords){ 
                
                if(MQLRecord.TEMarketing__Lead__c !=null){                        
                    //Assigning Lead owner as LeadMQL Owner only Select & Target Customers.
                    MQLRecord.OwnerId = MQLRecord.Parent_Owner_Id__c;
                    continue;
                }
                        
                //Checking Key Customer Code - Mandatory
                if(String.isNotEmpty(MQLRecord.Key_Customer_Cde__c) && MQLRecord.DCT_Flag__c == 'false' && MQLRecord.TEMarketing__Contact__c !=null){
                    String fakeId = '';
                    //Populating Account Id
                    MQLRecord.TEMarketing__Account__c = MQLRecord.Contact_Account_Id__c;
                    //Checking John Fake Id - Mandatory
                    fakeId = MQLConstant.get('cjm-network-id').Constants__c.toLowerCase();
                    
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
                        //Adding MQLRecords for RoundRobin                            
                        if(MQLRecord.Key_Customer_Cde__c.toLowerCase().startsWith(s)){
                            if(fakeId.contains(MQLRecord.Contact_Owner_Network_ID__c.toLowerCase())){
                                selectCustomerList.add(MQLRecord);
                             }else{
                                 //Contact owner assigning as MQLRecord owner, if Non - John Fake Id
                                 MQLRecord.OwnerId = MQLRecord.Parent_Owner_Id__c;
                             }        
                        }
                    }
                    
                    //Validating Key Customer Code for Target Customer. 
                    for(String t: targetCustomer){
                        //Adding MQLRecords for RoundRobin
                        if(MQLRecord.Key_Customer_Cde__c.toLowerCase().startsWith(t)){ 
                            targetCustomerList.add(MQLRecord);                            
                        }
                        
                    } 
                }
            }
                        
            //Assigning MQLRecords to CJM Users on RoundRobin
            if(!selectCustomerList.isEmpty()) {
                CJMUserRoute.SelectCustomer(selectCustomerList, 'ContactMQL'); 
                RoundRobin.UserAssignment(selectCustomerList);
            }   
            if(!targetCustomerList.isEmpty()) {
                CJMUserRoute.TargetCustomer(targetCustomerList);
                RoundRobin.UserAssignment(targetCustomerList);
            }
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