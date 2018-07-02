/***********************************************************************************************************************
      Name :Cls_tender_details_update_test
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Test class for Cls_tender_details_update class
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    08/14/2013   Initial Development         Tender Competitor
***********************************************************************************************************************/


@istest(seealldata=true)
public class Cls_tender_details_update_test
{
    public static testMethod void update_Tender_details()
    {
        List<Product_Line_Design__c> DesignList = new List<Product_Line_Design__c>();
        Product_Line_Design__c NewDesign;
        for(integer ins=0; ins<=14; ins++)
        {
            NewDesign=new Product_Line_Design__c();
            NewDesign.Name='Test Stage'+ins;
            NewDesign.PAM__c=500;
            NewDesign.TAM__c=500;
            DesignList.add(NewDesign);
        }
        insert DesignList;
        
        System.assert(!DesignList.isempty());
        
        List<tender__c> lstTender = new List<tender__c>();
        tender__c t1 = new tender__c();
        t1.name = 'test';
        t1.Country_of_Service__c ='us';
        t1.Number_of_Trains__c=2;
        t1.Number_of_Train_Carriages__c=3;
        lstTender.add(t1);
        
        tender__c t2 = new tender__c();
        t2.name = 'test';
        t2.Country_of_Service__c ='us';
        t2.Number_of_Trains__c=2;
        t2.Number_of_Train_Carriages__c=3;
        lstTender.add(t2);
        insert lstTender;
        System.assert(!lstTender.isempty());
        
        List<Tender_Details__c> TDSList = new List<Tender_Details__c>();
        Tender_Details__c T;
        for(Integer ins=0; ins<=DesignList.size()-1; ins++){
            T=new Tender_Details__c();
            T.Product_Line__c=DesignList[ins].Name;
            T.PAM__c=DesignList[ins].PAM__c;            
            T.TAM__c=DesignList[ins].TAM__c;
            T.Tender__c=lstTender[0].id;
            TDSList.add(T);     
            
            T=new Tender_Details__c();
            T.Product_Line__c=DesignList[ins].Name;
            T.PAM__c=DesignList[ins].PAM__c;            
            T.TAM__c=DesignList[ins].TAM__c;
            T.Tender__c=lstTender[1].id;
            TDSList.add(T);     
        }
       insert TDSList; 
       system.assert(!TDSList.isempty());
       list<Tender_competitor__c> TClist = new list<Tender_competitor__c>();
       Tender_competitor__c TC1 = new Tender_competitor__c();
       
       TC1.tender__c =t1.id;
       TC1.allocation__c=10;
       TC1.product_line__c='others';
       insert TC1;
       
       Tender_competitor__c TC2 = new Tender_competitor__c();
       
       TC2.tender__c =t2.id;
       
       TC2.product_line__c='others';
       insert TC2;
       
       update TClist ;
        
        test.starttest();
        
        Cls_tender_details_update.update_tender_Competitor(TDSList);
        test.stoptest();
        
    }
}