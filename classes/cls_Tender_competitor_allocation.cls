/***********************************************************************************************************************
      Name : cls_Tender_competitor_allocation
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This Class updates the Tender Competitor fields based on the Allocation and tender detail fields,
             Called by Tender_Competitor_allocation Trigger.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    08/14/2013   Initial Development         Tender Competitor
***********************************************************************************************************************/

public class cls_Tender_competitor_allocation
{
    Public static void Tender_competitor_allocation(list<Tender_Competitor__c> TC_list)
    {
    
        map<Id,map<string,Tender_Competitor__c >> map_TenderId_Tendercomp = new map<Id,map<string,Tender_Competitor__c >>();  
        set<ID>TC_Tender_ids=new set<ID>();
        set<string> picklists = new set<string>();
    
        For(Tender_Competitor__c tc :TC_list)
        {
            TC_Tender_ids.add(tc.Tender__c);
            picklists.add(tc.Product_Line__c);
            if(!map_TenderId_Tendercomp.containsKey(tc.tender__c))
            map_TenderId_Tendercomp.put(Tc.Tender__c,new map<string,Tender_Competitor__c >());
            map_TenderId_Tendercomp.get(tc.Tender__c).put(tc.Product_Line__c,tc);
        }
    
        For(Tender_details__c TD :[Select ID,Tender__c,Product_Line__c,TAM_Total__c,Total_TAM__c,TAM__c from Tender_Details__c where Tender__c IN: TC_Tender_ids and Product_Line__c in:picklists])
        {
            //Compare the product line on tender details and tender competior 
            if(td.Product_Line__c == map_TenderId_Tendercomp.get(td.tender__c).get(td.Product_Line__c).Product_Line__c  )
            {
           
                //Calculation starts 
                map_TenderId_Tendercomp.get(td.tender__c).get(td.Product_Line__c).TAM_Per_Car__c=(map_TenderId_Tendercomp.get(td.tender__c).get(td.Product_Line__c).Allocation__c * TD.TAM__c)/100;
                map_TenderId_Tendercomp.get(td.tender__c).get(td.Product_Line__c).TAM_Tender_Total__c=(map_TenderId_Tendercomp.get(td.tender__c).get(td.Product_Line__c).Allocation__c * td.TAM_Total__c)/100;
          
            }       
        //Calculation Ends 
        }                   
    }

}