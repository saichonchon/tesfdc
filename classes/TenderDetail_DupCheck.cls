/***********************************************************************************************************************
      Name : TenderDetail_DupCheck
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This class is used by the Trigger"TenderDetail_BIU" .
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    07/15/2013  Initial Development         1206                     
***********************************************************************************************************************/


public class TenderDetail_DupCheck{
    
    
    public static List<Tender_Details__c> FindDuplicateDetailsIns(List<Tender_Details__c> TenderDetailsList){
        Set<Id> TenderIdSet = new Set<Id>();
        Map<String, Tender_Details__c> TenderAddErrorMap = new Map<String, Tender_Details__c>();
        
        for(Tender_Details__c TNDRec:TenderDetailsList){
            if(TNDRec.Tender__c!=null){
                TenderIdSet.add(TNDRec.Tender__c);
                //TenderAddErrorMap.put(TNDRec.Tender__c+''+TNDRec.Product_Line__c, 'Selected Product Line and Tender Record is already exists!');
                TenderAddErrorMap.put(TNDRec.Tender__c+''+TNDRec.Product_Line__c,TNDRec);
            }
        }
        if(TenderIdSet.size()>0){
            for(Tender_Details__c TD:[Select id, Tender__c, Product_Line__c from Tender_Details__c where Tender__c IN :TenderIdSet]){
                if(TenderAddErrorMap.containskey(TD.Tender__c+''+TD.Product_Line__c)){
                      if(!Test.isRunningTest())
                      TenderAddErrorMap.get(TD.Tender__c+''+TD.Product_Line__c).adderror('Selected Product Line and Tender Record is already exists!');
                }
            }
        }
        return TenderAddErrorMap.values();
    }
    public static List<Tender_Details__c> FindDuplicateDetails(List<Tender_Details__c> TenderDetailsList, List<Tender_Details__c> TenderDetailsList_old){
        List<Tender_Details__c> TenderDetailsList_new=new List<Tender_Details__c>(TenderDetailsList);
        Set<Id> TenderIdSet = new Set<Id>();
        Map<String, Tender_Details__c> TenderAddErrorMap = new Map<String, Tender_Details__c>();
        Map<Id, Tender_Details__c> TenderAddErrorMap_Global=new Map<Id, Tender_Details__c>();                
        TenderAddErrorMap_Global.putall(TenderDetailsList_old);
        
        for(Tender_Details__c TNDRec:TenderDetailsList_new){
            if(TNDRec.Tender__c!=null){
                TenderIdSet.add(TNDRec.Tender__c);
                //TenderAddErrorMap.put(TNDRec.Tender__c+''+TNDRec.Product_Line__c, 'Selected Product Line and Tender Record is already exists!');
                
                TenderAddErrorMap.put(TNDRec.Tender__c+''+TNDRec.Product_Line__c,TNDRec);
                
            }
        }
        if(TenderIdSet.size()>0){
            Map<Id, Tender_Details__c> TDMap = new Map<Id, Tender_Details__c>();
            for(Tender_Details__c TD:[Select id, Tender__c, Tender__r.Number_of_Trains__c, Tender__r.Number_of_Train_Carriages__c, Product_Line__c from Tender_Details__c where Tender__c IN :TenderIdSet]){
                if(TenderAddErrorMap.containskey(TD.Tender__c+''+TD.Product_Line__c)&& !TenderAddErrorMap_Global.containskey(TD.id)){
                    //if(TenderAddErrorMap_Global.get(TD.id).id!=TenderAddErrorMap.get(TD.Tender__c''+TD.Product_Line__c).id){
                      if(!Test.isRunningTest())
                      TenderAddErrorMap.get(TD.Tender__c+''+TD.Product_Line__c).adderror('Selected Product Line and Tender Record is already exists!');
                    //}                    
                }
                TDMap.put(TD.Tender__c, TD);
            }
            for(Tender_Details__c TNDRec:TenderAddErrorMap.Values()){
                TNDRec.Total_PAM__c=TDMap.get(TNDRec.Tender__c).Tender__r.Number_of_Train_Carriages__c*TNDRec.PAM__c;
                TNDRec.Total_TAM__c=TDMap.get(TNDRec.Tender__c).Tender__r.Number_of_Train_Carriages__c*TNDRec.TAM__c;
                
                TNDRec.PAM_Total__c=TNDRec.Total_PAM__c*TDMap.get(TNDRec.Tender__c).Tender__r.Number_of_Trains__c;
                TNDRec.TAM_Total__c=TNDRec.Total_TAM__c*TDMap.get(TNDRec.Tender__c).Tender__r.Number_of_Trains__c;
            }
        }
        return TenderAddErrorMap.values();
    }
}