/**************************************************************************************************************************************************
Name:  RoundRobinCJMRoute
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
Public class RoundRobinCJMRoute{   

/*------------------------------------------------------------------------------------------------------------------------------------------------
| Purpose :  Assigning Target Customer to APL queue.                                                   |
|   Input : LeadMQL or ContactMQL                                                                                                                              |  
| Returns : None                                                                                                        |
------------------------------------------------------------------------------------------------------------------------------------------------*/      
    Public Void TargetCustomer(List<SObject> SObjectList){ 
        Map<String, Id> queueMap = getQueueInfo();
        String applianceQueue = MQLs_Constant_Variables__c.getInstance('cjm-appliance-queue').Constants__c.toLowerCase();
        for (SObject sObj: SObjectList){ 
            if(queueMap.containsKey(applianceQueue)) sObj.put('Ownerid', queueMap.get(applianceQueue));
        }
    }

/*------------------------------------------------------------------------------------------------------------------------------------------------
| Purpose : Getting information from SalesHierarchy that 4 Territory present or not in                                                   |
|   Input : None                                                                                                                              |  
| Returns : User Network Id information.                                                                                                      |
------------------------------------------------------------------------------------------------------------------------------------------------*/ 
  /*  Public Set<String> NonSelectTargetCustomer(){
        Set<String> salesHierarchynetworkId = new Set<String>();
        List<String> TerritoryCodes = new List<String>();
        
        if(MQLs_Constant_Variables__c.getInstance('non-select-target-cjm') != NULL){
            TerritoryCodes = MQLs_Constant_Variables__c.getInstance('non-select-target-cjm').Constants__c.Split(',');
        }
        if(!TerritoryCodes.isEmpty()){        
            for(Sales_Hierarchy__c SH: [Select Level_7_Assigned_User_Network_Ids__c From Sales_Hierarchy__c Where Level_7_Territory_Code__c IN: TerritoryCodes AND Level_7_Assigned_User_Network_Ids__c != NULL]){
                salesHierarchynetworkId.add(SH.Level_7_Assigned_User_Network_Ids__c.toLowerCase());
            }
        }
        
        return salesHierarchynetworkId;
    }*/

/*------------------------------------------------------------------------------------------------------------------------------------------------
| Purpose : Get Region, Country & State Code information from Live Agent Country Object                                                     |
|   Input : None                                                                                                                              |  
| Returns : Map of Country information                                                                                                        |
------------------------------------------------------------------------------------------------------------------------------------------------*/ 
    Public Map<String, Live_Agent_Country_List__c> getLiveAgentCountry(){
        
        Map<String, Live_Agent_Country_List__c> liveAgentCountryMap = new Map<String, Live_Agent_Country_List__c>();        
        
        //Adding Country information to Map 
        for(Live_Agent_Country_List__c LAC: [Select English__c, Region_Code__c, Country_Code_2_Digit__c, Country_Code_3_Digit__c From Live_Agent_Country_List__c]){            
            if(String.isNotEmpty(LAC.English__c)) liveAgentCountryMap.put(LAC.English__c.toLowerCase(), LAC);
            if(String.isNotEmpty(LAC.Country_Code_2_Digit__c)) liveAgentCountryMap.put(LAC.Country_Code_2_Digit__c.toLowerCase(), LAC);
            if(String.isNotEmpty(LAC.Country_Code_3_Digit__c)) liveAgentCountryMap.put(LAC.Country_Code_3_Digit__c.toLowerCase(), LAC);
        }
        
        return liveAgentCountryMap;
    }
    
    Set<String> networkIds;
    
/*------------------------------------------------------------------------------------------------------------------------------------------------
| Purpose : Get respective CJM User's assigned based on Country/State from SAP Table                                                |
|   Input : None                                                                                                                               |  
| Returns : Map of CJM Team Memebers                                                                                                            |
------------------------------------------------------------------------------------------------------------------------------------------------*/ 
    Public Map<String,List<ZSD_DMM_SAP__c>> getZSD_DMM_SAP(){
        Map<String, List<ZSD_DMM_SAP__c>> searchCJMUser = new Map<String,List<ZSD_DMM_SAP__c>>();
        Map<String, Map<String, ZSD_DMM_SAP__c>> findduplicate = new Map<String, Map<String, ZSD_DMM_SAP__c>>();
        networkIds = new Set<String>();
        string countryStateUser = '';
        //Getting CJM user information
        List<ZSD_DMM_SAP__c> ZSD_DMM_SAP_List = [SELECT Country_Key__c, Region__c, CJMUser_Network_Id__c, CJMUser_Last_Assignment__c, CJMUser_Millisecond__c 
                                                 FROM ZSD_DMM_SAP__c where CJMUser_Network_Id__c != NULL AND Active_CJM_User__c = TRUE
                                                 ORDER BY CJMUser_Last_Assignment__c, CJMUser_Millisecond__c];
        
        for(ZSD_DMM_SAP__c ZDS: ZSD_DMM_SAP_List){
            try{
                            
                String countryStateKey = '';
                if(String.IsNotEmpty(ZDS.Country_Key__c)){
                    countryStateKey = ZDS.Country_Key__c.toLowerCase();
                }
                
                if(String.IsNotEmpty(ZDS.Region__c)){
                    String Country = MQLs_Constant_Variables__c.getInstance('search-by-state').Constants__c.toLowerCase();
                    if(Country.contains(ZDS.Country_Key__c.toLowerCase())){
                        countryStateKey += ZDS.Region__c.toLowerCase();
                    }
                }
                countryStateUser = countryStateKey+ZDS.CJMUser_Network_Id__c.toLowerCase();
                 
                //Adding CJM Users based on Country Code
                if(!searchCJMUser.containsKey(countryStateKey)){ 
                    searchCJMUser.put(countryStateKey, new List<ZSD_DMM_SAP__c>());
                    findduplicate.put(countryStateKey, new Map<String, ZSD_DMM_SAP__c>());
                }   
                
                if(!findduplicate.get(countryStateKey).containsKey(countryStateUser)){
                    findduplicate.get(countryStateKey).put(countryStateUser, ZDS);
                }else if(findduplicate.get(countryStateKey).get(countryStateUser).CJMUser_Last_Assignment__c == NULL){
                    findduplicate.get(countryStateKey).put(countryStateUser, ZDS);
                }
                                
                List<ZSD_DMM_SAP__c> sortCJMUserlist = new List<ZSD_DMM_SAP__c>();
                sortCJMUserlist = findduplicate.get(countryStateKey).values();
                sortCJMUserlist.Sort();
                //Adding CJM users with their respective Country to Map
                searchCJMUser.get(countryStateKey).clear();
                searchCJMUser.get(countryStateKey).addall(sortCJMUserlist);
               
                //Adding CJM users Network Ids to set to fetch User information
                networkIds.add(ZDS.CJMUser_Network_Id__c.toLowerCase()); 
            }catch (exception e) {
                String vStrError = 'Error Type = ' + e.getTypeName() + 
                                    ' Error Line = ' + e.getLineNumber() + '' + 
                                    ' Error Stack = ' + e.getStackTraceString() + 
                                    ' Error Message = ' + e.getMessage();
                                
                SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                                             SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
            }  
        }
        
        return searchCJMUser;
    }

/*------------------------------------------------------------------------------------------------------------------------------------------------
| Purpose : Get CJM User information from user table                                                                                                      |
|   Input : TE Network Ids                                                                                                                     |  
| Returns : Map of User Information                                                                                                            |
------------------------------------------------------------------------------------------------------------------------------------------------*/ 
    Public Map<String, Id> getUserId(Set<String> networkids){
        Map<String, Id> UserMap = new Map<String, Id>();
        List<User> userList = new List<User>();
        
        if(!networkIds.isEmpty()) userList = [Select Id, Te_Network_Id__c From User where Te_Network_Id__c IN: networkIds AND isActive = TRUE];
        
        //Adding User information to Map based on TE Network Id
        for(User u: userList) {
            UserMap.put(u.Te_Network_Id__c.toLowerCase(), u.Id); 
        }
        return userMap;
    }

    
/*------------------------------------------------------------------------------------------------------------------------------------------------
| Purpose : Get CJM Region Queues information, to assign if country/state not found in DMM table                                                                        |
|   Input : None                                                                                                                       |  
| Returns : Map of Queue Ids                                                                                                            |
------------------------------------------------------------------------------------------------------------------------------------------------*/     
    Public static Map<String, Id> getQueueInfo(){
        Map<String, Id> queueMap = new Map<String, Id>();
        List<String> cjmQueues = MQLs_Constant_Variables__c.getInstance('cjm-queues').Constants__c.Split(',');
        List<Group> queueList = [select Id, DeveloperName from Group where Type = 'Queue' AND DeveloperNAME IN: cjmQueues];
        for(Group g: queueList){
            queueMap.put(g.DeveloperName.toLowerCase(), g.Id);
        }
        return queueMap;
    }

 /*------------------------------------------------------------------------------------------------------------------------------------------------
| Purpose : Round Robin between CJM Users based on County/State for Select Customers                                                                         |
|   Input : Lead/MQL information                                                                                                                       |  
| Returns : None                                                                                                            |
------------------------------------------------------------------------------------------------------------------------------------------------*/     
    Public Void SelectCustomer(List<SObject> SObjectList, String Relatedto){
        try{
            //Variable declaration
            String SearchByState = '';
            String NoCountryState = '';
            Map<Id,ZSD_DMM_SAP__c> updateZSD_DMM_SAP = new Map<Id,ZSD_DMM_SAP__c>();
            Map<Id, datetime> latestAGDateTime = new Map<Id,datetime>();
            Integer idx = 0;
            
            //Getting Country information
            Map<String, Live_Agent_Country_List__c> liveAgentCountryMap = getLiveAgentCountry();
            
            //Getting CJM User information
            Map<String, List<ZSD_DMM_SAP__c>> searchCJMUser = getZSD_DMM_SAP();
            
            //Getting constant values
            Map<String, MQLs_Constant_Variables__c> MQLConstant = MQLs_Constant_Variables__c.getAll();
            
            //Getting User information
            Map<String, Id> UserMap = getUserId(networkIds);
            
            //Getting Queue information
            Map<String, Id> queueMap = getQueueInfo();

            for (SObject sObj: SObjectList){
                //Variable Declaration
                List<ZSD_DMM_SAP__c> ZSD_DMM_SAPList = new List<ZSD_DMM_SAP__c>();
                String country = '';
                String state = '';
                
                //Identifying information comes for LeadMQL or ContactMQL
                if(Relatedto == 'ContactMQL'){
                    country = (String)sObj.get('Lead_Contact_Country__c');  
                    state = (String)sObj.get('Lead_Contact_State__c');
                }else if(Relatedto == 'LeadMQL'){ 
                    country = (String)sObj.get('country');
                    state = (String)sObj.get('state');                    
                }
                
                if(String.isNotEmpty(country) && liveAgentCountryMap.containsKey(country.toLowerCase())){
                    
                    if(MQLConstant.get('search-by-state') != NULL){ SearchByState = MQLConstant.get('search-by-state').Constants__c.toLowerCase();}
                    
                    if(MQLConstant.get('non-country-state') != NULL){ NoCountryState = MQLConstant.get('non-country-state').Constants__c;}
                    
                    if(SearchByState.Contains(country.toLowerCase())){

                        if(state == NULL) {state = '';}
                        ZSD_DMM_SAPList = searchCJMUser.get(liveAgentCountryMap.get(country.toLowerCase()).Country_Code_2_Digit__c.toLowerCase()+state.toLowerCase()); 
                        
                    }else if(NoCountryState.Contains(liveAgentCountryMap.get(country.toLowerCase()).Region_Code__c)){
                        
                        if(queueMap.containsKey(MQLConstant.get('cjm-apac-queue').Constants__c.toLowerCase())){
                            sObj.put('OwnerId', queueMap.get(MQLConstant.get('cjm-apac-queue').Constants__c.toLowerCase()));
                            if(Relatedto == 'LeadMQL'){ sObj.put('Status', 'Unassigned'); }
                            continue;
                        }
                        
                    }else{ 
                        ZSD_DMM_SAPList = searchCJMUser.get(liveAgentCountryMap.get(country.toLowerCase()).Country_Code_2_Digit__c.toLowerCase());
                        
                        if(queueMap.containsKey(MQLConstant.get('cjm-emea-queue').Constants__c.toLowerCase()) && ZSD_DMM_SAPList == null){
                            sObj.put('OwnerId', queueMap.get(MQLConstant.get('cjm-emea-queue').Constants__c.toLowerCase()));  
                            if(Relatedto == 'LeadMQL'){ sObj.put('Status', 'Unassigned'); }
                            continue;                                          
                        }
                    }    
                    
                }
                
                system.debug('ZSD_DMM ####' + ZSD_DMM_SAPList);                
                
                if(ZSD_DMM_SAPList != null){
                    List<ZSD_DMM_SAP__c> activeCJMUsers = new List<ZSD_DMM_SAP__c>();
                    for(ZSD_DMM_SAP__c ZDM: ZSD_DMM_SAPList){
                        if(UserMap.get(ZDM.CJMUser_Network_Id__c.toLowerCase()) != NULL ){
                            activeCJMUsers.add(ZDM);
                        }else{
                            ZDM.Active_CJM_User__c = FALSE;
                            updateZSD_DMM_SAP.put(ZDM.id, ZDM);
                        }
                    }
                    
                    system.debug('activeCJMUsers ####' + activeCJMUsers);
                    
                    if(activeCJMUsers.size()>0){
                        ZSD_DMM_SAPList.Clear();
                        ZSD_DMM_SAPList.addAll(activeCJMUsers);
                    }else{
                        ZSD_DMM_SAPList.Clear();
                    }
                }                               
                
                if(ZSD_DMM_SAPList != null && ZSD_DMM_SAPList.size()>0){
                    //Choose next user in line if user ID has already been used but not committed in this trigger batch 
                    ZSD_DMM_SAP__c ZDS = ZSD_DMM_SAPList[math.mod(idx, ZSD_DMM_SAPList.size())];
                    datetime now = datetime.now();
                      
                    //Assign User to MQL Record as the new owner
                    System.debug('>>>>>Owner changed for MQL Record from '+sObj.get('OwnerId')+' to '+ ZDS.CJMUser_Network_Id__c);            
                    sObj.put('OwnerId', UserMap.get(ZDS.CJMUser_Network_Id__c.toLowerCase()));
                    system.debug('OwnerId####' + (String)sObj.get('OwnerId'));
                    if(Relatedto == 'LeadMQL'){
                        sObj.put('Status', 'Assigned - Unaccepted');
                    }
                    
                    //Set last assignment datetime
                    ZDS.CJMUser_Last_Assignment__c = now;
                    ZDS.CJMUser_Millisecond__c = now.millisecondGMT();
                    
                    //update only latest Assignment Groups per ID
                    if (latestAGDateTime.containsKey(ZDS.id)) {
                        if(latestAGDateTime.get(ZDS.id) < now) {
                            updateZSD_DMM_SAP.put(ZDS.id, ZDS);
                            latestAGDateTime.put(ZDS.id, now);
                        }
                    } else {
                        updateZSD_DMM_SAP.put(ZDS.id, ZDS);
                        latestAGDateTime.put(ZDS.id,now);
                    }
                    idx++;
                }else if(queueMap.containsKey(MQLConstant.get('cjm-americas-queue').Constants__c.toLowerCase())){                    
                    sObj.put('OwnerId', queueMap.get(MQLConstant.get('cjm-americas-queue').Constants__c.toLowerCase()));                    
                    if(Relatedto == 'LeadMQL'){ sObj.put('Status', 'Unassigned'); }
                    continue;
                }              
            }
            
            //Update last assignment for Assignment Group in batch
            if (updateZSD_DMM_SAP.size()>0) {  
                update updateZSD_DMM_SAP.values();               
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