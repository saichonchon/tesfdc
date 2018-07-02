/***********************************************************************************************************************
      Name : TenderdetailRec
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary :This class is used by Trigger"CreateTenderDetails".
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    07/15/2013  Initial Development         1206                     
***********************************************************************************************************************/

Public Class TenderdetailRec
{
    public static void insertTenderDetail(List<Tender__c> lstTender)
    {
        List<Tender_Details__c> TenderDetailList = new List<Tender_Details__c>();
        Tender_Details__c TenderDetailRec;
        
        List<Product_Line_Design__c> ProdDesignList=Product_Line_Design__c.getall().Values(); 
        Integer TriggerCount=0;
        List<Tender_Details__c> TDL=[Select id, Tender__c from Tender_Details__c where Tender__c IN :lstTender];
        if(!TDL.isEmpty())
        update TDL;
        Map<Id, Tender_Details__c> TendMap=new Map<Id, Tender_Details__c>();
        for(Tender_Details__c T:TDL){
            TendMap.put(T.Tender__c, T);
        }
        for(Integer ins=0;ins<=ProdDesignList.size()-1; ins++){
            if(!TendMap.Containskey(lstTender[TriggerCount].id)){
                TenderDetailRec = new Tender_Details__c();
                TenderDetailRec.TAM__c=ProdDesignList[ins].TAM__c;
                TenderDetailRec.PAM__c=ProdDesignList[ins].PAM__c;
                TenderDetailRec.Product_Line__c=ProdDesignList[ins].Name;
                TenderDetailRec.Tender__c=lstTender[TriggerCount].id;
                
                TenderDetailRec.Total_PAM__c=lstTender[TriggerCount].Number_of_Train_Carriages__c*TenderDetailRec.PAM__c;
                TenderDetailRec.Total_TAM__c=lstTender[TriggerCount].Number_of_Train_Carriages__c*TenderDetailRec.TAM__c;

                TenderDetailRec.PAM_Total__c=TenderDetailRec.Total_PAM__c*lstTender[TriggerCount].Number_of_Trains__c;
                TenderDetailRec.TAM_Total__c=TenderDetailRec.Total_TAM__c*lstTender[TriggerCount].Number_of_Trains__c;
                
               if(ins==ProdDesignList.size()-1 && lstTender.size()-1!= TriggerCount){
                    ins=-1;
                    TriggerCount++;
                }     
                TenderDetailList.add(TenderDetailRec);            
            }
        }
        if(TenderDetailList.size()>0){
            insert TenderDetailList;
            
        }        

    } 
}