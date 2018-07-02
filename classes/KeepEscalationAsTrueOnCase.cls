/**********************************************************************************************************************************************
*******
Name: KeepEscalationAsTrueOnCase
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class updates case if status is changed then IsEscalated dont turn off
        This class is called by keepescalationastrue trigger on case object.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Narra   18/12/2013    Class                       
***********************************************************************************************************************************************
*****/
public class KeepEscalationAsTrueOnCase
{
    /*public static void setEscalationofCase(map<id,case> newMapCs,map<id,case> oldMapCs)
    {
         set<Id> cIds=new set<Id>();
         for(case c:newMapCs.values())
        {
            if(oldMapCs.get(c.id).IsEscalated && !c.IsEscalated)
            {
                 cIds.add(c.Id);           
            }
        }
        List<Case> updateCaselst=new List<case>();
        for(case c:[SELECT Id,IsEscalated FROM CASE WHERE Id in:cIds])
        {
            c.IsEscalated = true;
            updateCaselst.add(c);
        }
        try
        {
            if(!updateCaselst.isEmpty())
            update updateCaselst;
        }
        catch(Exception e){
              CCP_Exception_Util.CCP_Exception_Mail(e);
        }
        
        
    }*/
}