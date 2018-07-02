/***********************************************************************************************************************
      Name :  TenderdetailRec_Test
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : Test class for "TenderdetailRec" class
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    07/15/2013  Initial Development         1206                     
***********************************************************************************************************************/



@isTest (seealldata=true)
Public Class TenderdetailRec_Test
{
    public static testMethod void TenderdetailRec_TestMath()
    {
        List<Product_Line_Design__c> DesignList = new List<Product_Line_Design__c>();
        Product_Line_Design__c NewDesign;
        for(integer ins=0; ins<=14; ins++){
            NewDesign=new Product_Line_Design__c();
            NewDesign.Name='Test Stage'+ins;
            NewDesign.PAM__c=500;
            NewDesign.TAM__c=500;
            DesignList.add(NewDesign);
        }
        insert DesignList;

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
        
        //ApexPages.StandardController controller = new ApexPages.StandardController(t1);
        //Tenderdetailpickedlist TenderDetailAct=new Tenderdetailpickedlist(controller);
        Test.starttest();
        TenderdetailRec.insertTenderDetail(lstTender);
        Test.stoptest();
    }    
}