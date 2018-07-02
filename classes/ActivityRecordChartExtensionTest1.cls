/*********************************************************************************************************************** 
    Name: ActivityRecordChartExtensionTest1 
    Copyright © 2013 TE Connectivity | Salesforce Instance : Central Org
   ========================================================================================================================
    Purpose: Test Class for ActivityRecordChartExtension.                                                   
   ========================================================================================================================
    REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
   ------------------------------------------------------------------------------------------------------------------------
    VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
   ------------------------------------------------------------------------------------------------------------------------
           1.0 Ankit                 05/20/2013   Initial Development                                         
***********************************************************************************************************************/

@isTest(SeeAllData=true)
public class ActivityRecordChartExtensionTest1{
public static Lead leadTestDataLst = new Lead();
public static List<Activity_Record__c > vActivityRecordLst = new List<Activity_Record__c >();

    public static void createTestData(){
        leadTestDataLst.FirstName   = 'xyzc';    
        leadTestDataLst.LastName    = 'VFTestLead1';
        leadTestDataLst.Email       = 'test20.13@sampledomain.com';    
        leadTestDataLst.Company     = 'Company 1';
        leadTestDataLst.Phone       = '+1 8015551212';  
        leadTestDataLst.Description = 'Description Lead test to define limit of fifty charecters to pass test';
        leadTestDataLst.Industry    = 'Aerospace and Defense';      
        leadTestDataLst.LeadSource  = 'Preliminary Talk';  
        leadTestDataLst.Status      = 'Assigned Unaccepted';
        leadTestDataLst.Rating      = 'Hot';  
        Insert leadTestDataLst;
        
        for(Integer i = 0; i<= 21;i++){
            Activity_Record__c vActivityRecord = new Activity_Record__c();
            vActivityRecord.Associated_Email__c      = 'test20.13@sampledomain.com';
            vActivityRecord.Lead__c                  = leadTestDataLst.Id;
            vActivityRecord.Related_Part_Number_s__c = 'Sample part';
            vActivityRecord.Date_Needed__c           = Date.today() + 2;
            vActivityRecord.Activity_Notes__c        = leadTestDataLst.Description;
            vActivityRecord.ActivityDateTime__c      = DateTime.now();
            vActivityRecord.Activity_Date__c         = Date.Today();
            vActivityRecord.Activity_Source__c       = 'IBM';
            vActivityRecord.Activity_Type__c         = 'Hot';
            vActivityRecord.Activity_Rating_Desc__c  = '3D PDF';
            vActivityRecordLst.add(vActivityRecord);
        }
            Activity_Record__c vActivityRecord2 = new Activity_Record__c();
            vActivityRecord2.Associated_Email__c      = 'test20.13@sampledomain.com';
            vActivityRecord2.Lead__c                  = leadTestDataLst.Id;
            vActivityRecord2.Related_Part_Number_s__c = 'Sample part';
            vActivityRecord2.Date_Needed__c           = Date.today() + 2;
            vActivityRecord2.Activity_Notes__c        = leadTestDataLst.Description;
            vActivityRecord2.ActivityDateTime__c      = DateTime.now();
            vActivityRecord2.Activity_Date__c         = Date.Today();
            vActivityRecord2.Activity_Source__c       = 'IBM';
            vActivityRecord2.Activity_Type__c         = 'Hot';
            vActivityRecord2.Activity_Rating_Desc__c  = 'Special Price Request - Follow-up Agreement - Contract Price (FAP)';
            vActivityRecord2.Activity_Notes__c        = 'More then 50 character values must be there to make it truncate the value........';
            vActivityRecordLst.add(vActivityRecord2);
            
            
        Insert vActivityRecordLst ;
    }

    public static testMethod void TestMethodstart(){ 
        test.startTest ();
        createTestData();
        
        PageReference pageRef = Page.LeadActivityRecordChart; 
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('Id', leadTestDataLst.Id);
       
        ActivityRecordChartController acOBJCon = new ActivityRecordChartController();
        
        ApexPages.StandardController controll = new ApexPages.StandardController(leadTestDataLst);
        ActivityRecordChartExtension acob = new ActivityRecordChartExtension(controll);
        
        test.stopTest();
    }
    public static testMethod void TestMethod1(){ 
        test.startTest ();
        createTestData();
        ActivityRecordChartExtension acOBJCon = new ActivityRecordChartExtension(new ActivityRecordChartController());

        PageReference pageRef = Page.LeadActivityRecordChart; 
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('Id', leadTestDataLst.Id);

        test.stopTest();
    }

    public static testMethod void TestMethod2(){ 
        test.startTest ();
        createTestData();
        ActivityRecordChartExtension acOBJ= new ActivityRecordChartExtension(new ActivityRecordChartController());
        acOBJ.vRecordId = leadTestDataLst.Id;

        PageReference pageRef = Page.LeadActivityRecordChart; 
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('Id', leadTestDataLst.Id); 
        
        acOBJ.vArcRecLst = vActivityRecordLst ;
        acOBJ.getSort();
        
        acOBJ.clickLog = 1;
        acOBJ.getSort(); 
                
        acOBJ.vSelectMultipleARType='[1,2]';
        acOBJ.FillChartDataMethord();

        acOBJ.vSelectMultipleARType='[1,2]';
        acOBJ.vsetDateRangeSoql = 'THIS_MONTH';
        acOBJ.vsetDateRange = 'Current Month';
        acOBJ.FillChartDataMethord();

        acOBJ.vsetDateRangeAR ='';
        acOBJ.vLikeRecType = '3D PDF';
        acOBJ.vSelectARType ='';
        acOBJ.retDynQuery();

        acOBJ.vsetDateRangeAR ='';
        acOBJ.vLikeRecType = '';
        acOBJ.vSelectARType ='1';
        system.debug('***Test***'+Activity_Chart_Lookup_Filter__c.getValues(acOBJ.vSelectARType).ARL_Name__c);
        acOBJ.retDynQuery();

        acOBJ.vsetDateRangeAR ='';
        acOBJ.vLikeRecType = '3D PDF';
        acOBJ.vSelectARType ='1';
        system.debug('***Test***'+Activity_Chart_Lookup_Filter__c.getValues(acOBJ.vSelectARType).ARL_Name__c);
        acOBJ.retDynQuery();

        acOBJ.vsetDateRange = null;
        acOBJ.vsetDateRangeSoql = null;
        acOBJ.vSelectMultipleARType='[1,2]';
        acOBJ.FillChartDataMethord();

        acOBJ.vSelectMultipleARType='';
        acOBJ.vsetDateRange = null;
        acOBJ.vsetDateRangeSoql = null;
        acOBJ.FillChartDataMethord();
       
        List<SelectOption> temp1 = acOBJ.ARDateFilter;
        List<SelectOption> temp2 = acOBJ.StatusList;
        test.stopTest();
    }

    public static testMethod void TestMethod3(){ 
        test.startTest ();
        Account acc= new Account();
        acc.Name = 'TestDataName';
        acc.ACCOUNT_CLERK_CDE__c = '';
        acc.Type = 'Distributor';
        acc.Industry_Code_Description__c = 'A&C';
        insert acc;

        Contact testCon = new Contact();
        testCon.AccountId = acc.Id;
        testCon.LastName = 'testCon';
        testCon.Email = 'test20.13@sampledomain.com';
        insert testCon;

        PageReference pageRef = Page.ContactActivityRecordChart; //replace with your VF page name
        Test.setCurrentPage(pageRef); 
        ApexPages.currentPage().getParameters().put('Id', testCon.Id);
        ActivityRecordChartExtension acOBJCon = new ActivityRecordChartExtension(new ActivityRecordChartController());
        acOBJCon.vRecordId = testCon.Id;
        test.stopTest();
    }

    public static testMethod void TestMethod4(){ 
        test.startTest ();
        createTestData();
        ActivityRecordChartExtension acOBJCon = new ActivityRecordChartExtension(new ActivityRecordChartController());

        PageReference pageRef = Page.LeadActivityRecordChart; 
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('Id', leadTestDataLst.Id);
        
        acOBJCon .vRecordId = '111222222222222';
        acOBJCon .retDQueryParameter();
        test.stopTest();
    }

}