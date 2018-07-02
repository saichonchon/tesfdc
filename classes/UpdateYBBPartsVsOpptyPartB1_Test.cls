/*********************************************************************************************************************
*  This test class is for Class UpdateYBBPartsVsOpptyPartB1, also covers scheduler QuarterlyTriggerScedularS1.
*
@author Chiranjeevi
@created 2013-08-08
@version 1.0
*
@modified Nooreen (19-05-15) updated for changes done in above classes.
************************************************************************************************************************ */
@isTest(SeeAllData=false)
private class UpdateYBBPartsVsOpptyPartB1_Test {
   
    static testMethod void testBatch1() {
       RecordType rt2 = ClsTestHelp.createTestRecordType10();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        Test.startTest(); 
       
            Product_Hierarchy__c ph = new Product_Hierarchy__c();
            ph.Hierarchy_Level_Type__c = 'CBC1';
            ph.Description__c = 'Industrial';
            insert ph;
              
            Part__c part = new Part__c();
            part.Description__c = 'Sniper1';
            part.Product_Hierarchy__c = ph.Id;
            insert part;
            
            Account vAccount = new Account();
            vAccount.Name = 'PMP Foundries Corp';
            vAccount.AnnualRevenue = 2000000.11; 
            vAccount.Legally_Restricted__c = false;  
            vAccount.BillingCity = 'Musterstadt';
            vAccount.BillingStreet = 'Teststr. 1';
            vAccount.BillingCountry = 'German';
            vAccount.Type = 'Distributor';
            vAccount.BillingPostalCode = '77777';
            vAccount.AccountNumber = '';
            vAccount.Legally_Restricted__c= true; 
            vAccount.AnnualRevenue= 10000.11;         
            vAccount.BillingCity       = 'Beijing';  
            vAccount.BillingCountry     = 'China';
            vAccount.BillingState          = '000001';
            vAccount.BillingStreet       = 'Tiananmen';
            vAccount.BillingPostalCode   = '2000';
            insert vAccount;
            
            BBB_Year_Bill_Book_Cust_PN__c BCS = new BBB_Year_Bill_Book_Cust_PN__c();
            BCS.Customer__c=vAccount.id;
            BCS.Part__c=part.id;
            BCS.CurrencyIsoCode='USD';
            BCS.BBB_Yearly_External_Key__c='Text Value';
            BCS.Bill_Prior_Year_Amount_Document__c=1;
            BCS.Bill_Prior_Year_Amount_USD__c=0;
            BCS.Bill_Prior_Year_Cost_Amount__c=1; 
            BCS.Bill_Prior_Year_Qty__c=0;
            BCS.Bill_Prior_Year_to_Date_Amount_Document__c=1; 
            BCS.Bill_Prior_Year_to_Date_Amount_USD__c=1; 
            BCS.Bill_Prior_Year_To_Date_Cost_Amount__c=1; 
            BCS.Bill_Prior_Year_To_Date_Qty__c=1; 
            BCS.Bill_Type__c='Direct';  
            BCS.Bill_Year_to_Date_Amount_Document__c=1; 
            BCS.Bill_Year_to_Date_Amount_USD__c=0; 
            BCS.Bill_Year_To_Date_Cost_Amount__c=1; 
            BCS.Bill_Year_To_Date_Qty__c=0; 
            BCS.Book_Prior_Year_Amount_Document__c=1; 
            BCS.Book_Prior_Year_Amount_USD__c=1; 
            BCS.Book_Prior_Year_Cost_Amount__c=1;
            BCS.Book_Prior_Year_Qty__c=1;
            BCS.Book_Prior_Year_To_Date_Amount_Document__c=1;
            BCS.Book_Prior_Year_To_Date_Amount_USD__c=1;
            BCS.Book_Prior_Year_To_Date_Cost_Amount__c=1;
            BCS.Book_Prior_Year_To_Date_Qty__c=1;
            BCS.Book_Year_To_Date_Amount_Document__c=1;
            BCS.Book_Year_To_Date_Amount_USD__c=1;
            BCS.Book_Year_To_Date_Cost_Amount__c=1;
            BCS.Book_Year_To_Date_Qty__c=1;
            BCS.BU_Profit_Center__c ='New';
            insert BCS;
            
            
            Apex_Helper_Settings__c olastquarter = Apex_Helper_Settings__c.getInstance('Quarterly-4 Month');
            olastquarter.value__c = '1';
            update olastquarter;
            List<Part__c> prtList = new List<Part__c>();
            prtList.add(part);     
            UpdateYBBPartsVsOpptyPartB1 prtBtch = new UpdateYBBPartsVsOpptyPartB1();
            prtBtch.executionName = 'testrun' + datetime.now();
    
            UpdateYBBPartsVsOpptyPartB1.filter = ' limit 1';    
            prtBtch.istest=true;              
    
            database.executebatch(prtBtch );
        Test.stopTest();    
    }
}