@isTest
public class ClsOppyTrgRefreshBUProfit_Test{

static testMethod void test_123() {
  ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();

        RecordType rt31 = ClsTestHelp.createTestRecordType31();
        insert (new Opportunity_Record_Type_Groups__c(name = 'ADM sales',RecordTypeID__c = rt31.Id, Group__c = 'ADM Group', active__c = true));
        insert (new Opportunity_Record_Type_Groups__c(name = 'ADM',RecordTypeID__c = rt31.Id, Group__c = 'Engineering Milestones Opportunities', active__c = true));
        //insert (new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true));
   //   Profit_BU_Center_Mapping_Rule1__c pb1 = ClsTestHelp.createTestProfitBUCenterMapping1();
       // Profit_BU_Center_Mapping_Rule2__c pb2 = ClsTestHelp.createTestProfitBUCenterMapping2();
     //   Profit_BU_Center_Mapping_Rule3__c pb3 = ClsTestHelp.createTestProfitBUCenterMapping3();
        
  //  ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();      
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ChannelinsightData_test.ChannelinsightData_test();
      //  ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
       // ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();

  ADMTerritoryCode__c admTerritory= new ADMTerritoryCode__c();
        admTerritory.Name='ADMTerritoryCode';
        admTerritory.Territory_Code__c='101485';
        
        insert admTerritory;
       
         list<Opportunity_Record_Type_Groups__c> lstORTG = new list<Opportunity_Record_Type_Groups__c>();
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Opportunity - Sales Project',RecordTypeID__c = '012E0000000XrBY', Group__c = 'Change Channel Opportunities at header level', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'NDR Opportunity',RecordTypeID__c = '012E0000000egdDIAQ', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'CCR Opportunity',RecordTypeID__c = '0123C000000065gQAA', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Part Std Price Display on Forecast',RecordTypeID__c = '012E0000000eR0c', Group__c = 'Part Std Price Display on Forecast', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'Change Channel Oppy header level',RecordTypeID__c = '012E0000000eR0c', Group__c = 'Change Channel Opportunities at header level', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND_Sales_Project',RecordTypeID__c = '012E0000000fCzm', active__c = true));
        lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'IND_Engineering_project',RecordTypeID__c = '012E0000000fCzr', active__c = true)); 
        
            lstORTG.add(new Opportunity_Record_Type_Groups__c(name = 'DND Opportunity',RecordTypeID__c = '012E0000000NIlV', Group__c = 'Process Status Display', active__c = true)); //Archana : Added
     
        insert lstORTG; 
        
        
        
        Profile p = [Select Id, Name From Profile where Name ='System Administrator' or Name ='Systemadministrator' limit 1];
       
       User u = [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User where ProfileId =:p.id and isactive=true limit 1];
       //User u = [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User where ProfileId =:p.id  and GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true limit 1];
       /*              
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'hellEFD@testCompany1233423.com';
        u.Alias = 'dpED';
        u.CommunityNickname = 'NNDU';
        u.ProfileId = p.Id;
        u.LocaleSidKey= 'de';
        u.country='India';
        u.GIBU__c='Industrial';
                u.Sub_Vertical__c='Industrial';
        insert u;
     */         
       system.runAs(u){  
       ClsTestCustomSettingHelper.getApex_Helper_Settings();  
        RecordType rt = ClsTestHelp.createTestRecordType();
      //  RecordType rt1 = ClsTestHelp.createTestRecordType11();
      RecordType rt1=ClsTestHelp.createPMVTestRecordType1();
        RecordType rt2 = ClsTestHelp.createTestRecordType16();     
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c='Appliances';
        RecordType  oppy_part_sales_part_rt= [select Id,Name from RecordType where SobjectType = 'Opportunity_Part__c' and DeveloperName = 'Sales_Parts'];
        acc.Type = 'CM';
        insert acc;

        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;

        Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
        oppy2.Program_level_Forecasting__c =true; 
        oppy2.Name = 'Pain of Queen';
        oppy2.Type = 'CM';
        oppy2.Request_Type__c = 'IND_Sales_Project';
        oppy2.RecordTypeId = rt2.Id;
        oppy2.stagename= 'Exploring Needs';
        oppy2.PMV_Type__c ='IND Standard Sales opp';
        oppy2.Manufacturing_Start_Date__c=System.today();
      //  oppy2.Industry_Code__c='Appliances';
        insert oppy2;  
          
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Program__c = oppy2.Id;   
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'IND_Sales_Project';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        oppy.RecordTypeId = rt1.Id;
        oppy.stagename= 'Exploring Needs';
        oppy.PMV_Type__c ='IND Standard Sales opp';
                oppy.Manufacturing_Start_Date__c=System.today();
      //  oppy.Industry_Code__c='Appliances';
       // insert oppy;
        
        Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
         part.name='Sales Part';
         part.Standard_Price__c=120.34;
          insert part;
        
        Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
        oppypart.Opportunity__c = oppy2.Id;
        oppypart.Part__c = part.Id;   
        oppypart.Process_Status__c = 'Production';
        oppypart.initial_billing_date__c = Date.today();
        oppypart.initial_order_date__c = Date.today(); 
        oppypart.CurrencyIsoCode='USD';         
        
        oppypart.RecordTypeId = oppy_part_sales_part_rt.id;//'012E0000000XrBg';
//                oppypart.RecordType.Name = 'Sales Part';
        insert oppypart;
        
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppy2.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Process_Status__c = 'Production';
        oppypart1.initial_billing_date__c = Date.today();
        oppypart1.initial_order_date__c = Date.today();            
        oppypart1.RecordTypeId = '012E0000000XrBg';
          oppypart1.CurrencyIsoCode='USD';  
              
        insert oppypart1;
        
        set<Id> oppId =new Set<Id>();
        oppId.add(oppy2.id);
        Test.startTest();
        ClsOppyTrgRefreshBUProfit.UpdateBUProfit(oppId );
        Test.stopTest();
        
        }
            
}
}