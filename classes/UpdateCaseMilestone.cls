/**********************************************************************************************************************************************
*******
Name: UpdateCaseMilestone
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class updates the CaseMilestone as completed when User close the case
        This class is called by keepescalationastrue trigger on case object.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra   13/11/2013    Class   
 1.1   Abhijeet          25/11/2013    Added a logic to complete 4 Hour Milestone on closing of case.                      
***********************************************************************************************************************************************
*****/
public class UpdateCaseMilestone
{
       
    public static void closeMilestone(map<id,case> mapcaseobj,map<id,case> mapoldobj)
    {
      try{  
      set<id> clscaseids=new set<id>(); 
      for(case cs:mapcaseobj.values())
      {
          if((cs.isClosed == true || cs.status=='Closed') && mapoldobj.get(cs.id).IsClosed != true)
          {
              clscaseids.add(cs.id);
          }
          //system.debug('-----c'+clscaseids+'--'+cs.EntitlementId);
      }
       Apex_Helper_Settings__c mlstnType = Apex_Helper_Settings__c.getInstance('24 Hour Response TIme');
       Apex_Helper_Settings__c mlstnType_4hrresponse = Apex_Helper_Settings__c.getInstance('4 Hour Response Time');
       
       List<CaseMilestone> csMlstoneList = new List<CaseMilestone>();
       if(!clscaseids.isEmpty())
       csMlstoneList = [select id,caseid,CompletionDate,MilestoneTypeId,IsCompleted from CaseMilestone where 
       (MilestoneTypeId =: mlstnType_4hrresponse.Value__c OR MilestoneTypeId =: mlstnType.Value__c ) AND caseid in: clscaseids];
               
       List<CaseMilestone> updCSMlst= new List<CaseMilestone>();
        if(!csMlstoneList.isEmpty()){
            for(CaseMilestone cm : csMlstoneList)
            {
                Id hrstouse = mapcaseobj.get(cm.caseid).BusinessHoursid;
                decimal BusHours = BusinessHours.diff(hrstouse, mapcaseobj.get(cm.caseid).CreatedDate, mapcaseobj.get(cm.caseid).ClosedDate)/3600000.0;
                decimal Hours = (decimal.valueof((mapcaseobj.get(cm.caseid).ClosedDate.getTime() - mapcaseobj.get(cm.caseid).CreatedDate.getTime())/(60*60)))/1000;
                //System.debug('BusHours ****'+BusHours );
                //System.debug('Hoursss***'+Hours);
                if(cm.MilestoneTypeId == mlstnType.Value__c && cm.CompletionDate == null && cm.IsCompleted == false && BusHours <=24.0)
                {
                    cm.CompletionDate= mapcaseobj.get(cm.caseid).ClosedDate;
                    updCSMlst.add(cm);
                      
                }
                else if(cm.MilestoneTypeId == mlstnType_4hrresponse.Value__c && cm.CompletionDate == null && cm.IsCompleted == false && BusHours <=4.0)
                {
                    cm.CompletionDate= mapcaseobj.get(cm.caseid).ClosedDate;
                    updCSMlst.add(cm);
                }
            }
        }
        if(!updCSMlst.isEmpty()&& !Test.isRunningTest())
        update updCSMlst;
        }catch(Exception e){
                CCP_Exception_Util.CCP_Exception_Mail(e);
        }
   }
}