/**********************************************************************************************************************************************
*******
Name: CompleteMilestone_CCP
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class updates the CaseMilestone as completed when User sends mail from SFDC
        This class is called by AI_UpdateCaseMilestone_CCP trigger on EmailMessage object.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   18/10/2013    Class                       
***********************************************************************************************************************************************
*****/
public class CompleteMilestone_CCP{
/***************  Variable declaration ***************/
    public Set<ID> vCaseIDSet;
    public List<CaseMilestone> vCsMlstoneList;
    public Map<Id,Datetime> vCsIDtoEmdatemap;
    public Map<Id,Datetime> vCsIDtoCrtdDatemap;
    public String vMlstoneType='';
    public Apex_Helper_Settings__c vMlstnType = Apex_Helper_Settings__c.getInstance('4 Hour Response Time');
    public CompleteMilestone_CCP(){
        vCaseIDSet = new Set<ID>();
        vCsMlstoneList = new List<CaseMilestone>();
        vCsIDtoEmdatemap = new Map<Id,DateTime>();
        vCsIDtoCrtdDatemap = new Map<Id,DateTime>();
        vMlstoneType = vMlstnType.Value__c;
    }// End of controller
    public void MarkMilestoneasCompleted(List<EmailMessage> pEMLst,Map<Id,Case> mapCs,Set<String> vUserEmailSet,Map<String, Customer_Care_SharedEmailBox__c> vCustCareEmailBoxMap){
      
        try{
           for(case c: mapCs.values())
            {
                if(c.isclosed == false)
                vCsIDtoCrtdDatemap.put(c.id,c.createddate);
            }
            
            for(EmailMessage em : pEMLst){           
                if(em.FromAddress != 'customersupport@te.com' && em.Incoming == false && vCsIDtoCrtdDatemap.containskey(em.parentId)){
                 System.debug('***inside milestone, incoming=false ***');
                    vCaseIDSet.add(em.parentID);
                    vCsIDtoEmdatemap.put(em.parentId,em.messagedate);
                }else if(em.Incoming == true && (vUserEmailSet.contains(em.FromAddress) || vCustCareEmailBoxMap.containsKey(em.FromAddress.toLowerCase())) &&
                         vCsIDtoCrtdDatemap.containskey(em.parentId) && ((mapCs.get(em.parentid).Count_Outgoing_Emails__c > 1) || (mapCs.get(em.parentid).Count_Incoming_Emails__c != 0))){
                     System.debug('***inside milestone, incoming=true***');
                    vCaseIDSet.add(em.parentID);
                    vCsIDtoEmdatemap.put(em.parentId,em.messagedate);
                }else{
                }
            }
            //vCsMlstoneList = [select id,caseid,CompletionDate,MilestoneTypeId,IsCompleted  from CaseMilestone where MilestoneTypeId=:vMlstoneType AND caseid in: vCaseIDSet];
            for(CaseMilestone cm : [select id,caseid,Startdate,CompletionDate,MilestoneTypeId,IsCompleted  from CaseMilestone where MilestoneTypeId=:vMlstoneType AND caseid in: vCaseIDSet]){
                System.debug('*** cm ***'+cm);
                Id hrstouse = mapCs.get(cm.caseid).BusinessHoursid;
                System.debug('*** hrstouse ***'+hrstouse);
                //Get diffrence in Business hours
                if(hrstouse != null){
                    decimal BusHours = BusinessHours.diff(hrstouse, vCsIDtoCrtdDatemap.get(cm.caseid), vCsIDtoEmdatemap.get(cm.caseid))/3600000.0;
                    System.debug('*** BusHours ***'+BusHours);
                    if(vCsIDtoEmdatemap.containskey(cm.caseid) && cm.CompletionDate == null && cm.IsCompleted == false && BusHours <=4.0){
                           System.debug('*** inside milestone IF***'+BusHours);
                            cm.CompletionDate= vCsIDtoEmdatemap.get(cm.caseid);                   
                            vCsMlstoneList.add(cm);  
                    }
                }
            }
           if(! vCsMlstoneList.isEmpty()&& !Test.isRunningTest()) update vCsMlstoneList;
    }catch(Exception e){
        CCP_Exception_Util.CCP_Exception_Mail(e);
    }
    
    }

}