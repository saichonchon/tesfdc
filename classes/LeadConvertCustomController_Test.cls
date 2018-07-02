@istest
public class LeadConvertCustomController_Test {

    public static testmethod void leadConvertion(){
        Consumer_Device_Opportunity_Record_Types__c opp5=new Consumer_Device_Opportunity_Record_Types__c();
        opp5.Name='Engineering Opportunity-CSD';
        opp5.Record_Type_Id__c='012E0000000JOQLIA4';   
        insert opp5;
         
        Consumer_Device_Opportunity_Record_Types__c opp=new Consumer_Device_Opportunity_Record_Types__c();
        opp.Name='OEM';
        opp.Record_Type_Id__c='012E0000000JOQLIA4';   
        insert opp;
        
        Consumer_Device_Opportunity_Record_Types__c opp4=new Consumer_Device_Opportunity_Record_Types__c();
        opp4.Name='Sales Opportunity-CSD';
        opp4.Record_Type_Id__c='012E0000000JOQLIA4';   
        insert opp4;
        
        Opportunity_Record_Type_Groups__c opp1=new Opportunity_Record_Type_Groups__c();
        opp1.Name='ADM';
        opp1.RecordTypeID__c='012E0000000JOQLIA4';
        opp1.Group__c='Engineering Milestones Opportunities';
        opp1.Active__c=true;
        opp1.API_Name__c='ADM';
        insert opp1;
     ClsTestCustomSettingHelper.getTrigger_Configuration();
     
        Opportunity_Approvers__c oa = ClsTestHelp.createTestOpportunityApprovers();        
        Opportunity_Approvers__c oa2 = ClsTestHelp.createTestOpportunityApprovers2();        
        Opportunity_Approvers__c oa3 = ClsTestHelp.createTestOpportunityApprovers3();
        Opportunity_Approvers__c oa4 = ClsTestHelp.createTestOpportunityApprovers4();
        
        Opportunity_Approvers__c oppApproval= new Opportunity_Approvers__c();
        oppApproval.Name='Rail';
        oppApproval.Approver_Id__c='005E0000002HaAs';
        oppApproval.Approver_Name__c='Jonathan Hunt';
        oppApproval.GPLs__c='';
        oppApproval.Test_Approver__c='';        
        insert oppApproval;
        
        Opportunity_Approvers__c railGPL2= new Opportunity_Approvers__c();
        railGPL2.Name='Rail GPLs 02';
        railGPL2.Approver_Id__c='005E0000006EWCY';
        railGPL2.Approver_Name__c='Judy Lim';
        railGPL2.GPLs__c='LT2';
        railGPL2.Test_Approver__c='';        
        insert railGPL2;
        
        Apex_Helper_Settings__c ah = new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
		insert ah; 
        
        Apex_Helper_Settings__c Apexsett = new Apex_Helper_Settings__c();
        Apexsett.Name = 'System Admin Profile Id';
        Apexsett.Value__c = '012E0000000JOQLIA4';
        Apexsett.Active__c = true;
        insert Apexsett;
        
        Apex_Helper_Settings__c Apexsett1 = new Apex_Helper_Settings__c();
        Apexsett1.Name = 'Service Account Profile Id';
        Apexsett1.Value__c = '012E0000000JOQLIA4';
        Apexsett1.Active__c = true;
        insert Apexsett1;
        
        Apex_Helper_Settings__c Apexsett2 = new Apex_Helper_Settings__c();
        Apexsett2.Name = 'TEIS Admin User Id';
        Apexsett2.Value__c = '012E0000000JOQLIA4';
        Apexsett2.Active__c = true;
        insert Apexsett2;
        
        Apex_Helper_Settings__c Apexsett3 = new Apex_Helper_Settings__c();
        Apexsett3.Name = 'Account Record Type Id';
        Apexsett3.Value__c = '012E0000000JOQLIA4';
        Apexsett3.Active__c = true;
        insert Apexsett3;
        
        Apex_Helper_Settings__c Apexsett4 = new Apex_Helper_Settings__c();
        Apexsett4.Name = 'GAM Record Type Id';
        Apexsett4.Value__c = '012E0000000J6k0IAC';
        Apexsett4.Active__c = true;
        insert Apexsett4;
        
        Apex_Helper_Settings__c Apexsett5 = new Apex_Helper_Settings__c();
        Apexsett5.Name = 'Currency Confirm Except Users';
        Apexsett5.Value__c = 'test';
        Apexsett5.Active__c = true;
        insert Apexsett5;
        
        Apex_Helper_Settings__c Apexsett6 = new Apex_Helper_Settings__c();
        Apexsett6.Name = 'Forecast Snapshot Oppy RT Id';
        Apexsett6.Value__c = '012E0000000XrPAIA0';
        Apexsett6.Active__c = true;
        Apexsett6.Description__c = 'This setting contains the "Forecast Snapshot Oppy" Record Type Id';   
        insert Apexsett6;
        
        Apex_Helper_Settings__c Apexsett7= new Apex_Helper_Settings__c();
        Apexsett7.Name ='Forecast Snapshot Part RT Id';
        Apexsett7.Value__c ='012E0000000XrPAIA0';
        Apexsett7.Active__c = true;         
        Apexsett7.Description__c = 'This setting contains the "Forecast Snapshot Oppy" Record Type Id';   
        insert Apexsett7;
        
        Apex_Helper_Settings__c Apexsett8 = new Apex_Helper_Settings__c();
        Apexsett8.Name = 'TEIS_Admin';
        Apexsett8.Active__c = false;
        Apexsett8.Value__c = 'TEIS Admin';
        insert Apexsett8;
        
        Apex_Helper_Settings__c Apexsett9 = new Apex_Helper_Settings__c();
        Apexsett9.Name = 'Relay_Specialist';
        Apexsett9.Active__c = false;
        Apexsett9.Value__c = 'Relay Specialist (IS)';
        insert Apexsett9;
        
        Apex_Helper_Settings__c Apexsett10 = new Apex_Helper_Settings__c();
        apexsett10.Name = 'Field_Engineer';
        apexsett10.Active__c = false;
        apexsett10.Value__c = 'Field Engineer (FE)';
        insert Apexsett10;
        
        
        ADMTerritoryCode__c ADM = new ADMTerritoryCode__c();
        ADM.Name = 'ADMTerritoryCode';
        ADM.Territory_Code__c = '101485';
        insert ADM;
 
        Lead leadInsrt = new Lead();
        leadInsrt.FirstName = 'FirstTest';
        leadInsrt.Street = 'TCS';
        leadInsrt.LastName = 'Test';
        leadInsrt.Status = 'Assigned - Accepted';
        leadInsrt.Company = 'test';
        leadInsrt.CurrencyIsoCode = 'USD';
        leadInsrt.City = 'bangalore';
        leadInsrt.Email = 'mama.d@gmail.com';
        insert leadInsrt;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          User u = new User(Alias = 'ktest', Email='kartik.test@te.com', 
                          UserName='sree.test@te.com.admdev',EmailEncodingKey='UTF-8', LastName='Testing', 
                          LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles');
        insert u;
        
        ID accRecid = [Select Id,Name from RecordType where Name = 'Prospect'].Id;
        ID oRTid = [Select Id,Name from RecordType where Name = 'Opportunity - Sales Project'].Id;
        //Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Opportunity - Engineering Project').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 't'+system.now().millisecond()+math.round(math.random()*10000);//Modified by Harinath to get Unique AccountName for each Account.
        acc.AnnualRevenue = 2000000.11; 
        acc.Legally_Restricted__c = false;  
        acc.BillingCity = 'Musterstadt';
        acc.BillingStreet = 'Teststr. 1';
        acc.BillingCountry = 'CN';
        acc.Type = 'Distributor';
        acc.BillingPostalCode = '77777';
        acc.Sales_Hierarchy__c=ClsTestHelp.createTestSalesHierarchy().Id;
        acc.Industry_Code_Description__c='Industrial';
        acc.Business_Unit_Level_2__c='Rail';
        acc.AccountNumber = '';
        acc.Name = 'NON OEM';
        acc.Active__c = true;
        acc.RecordTypeId =  accRecid;
        acc.Type = 'prospect';
        acc.Business_Unit_Level_2__c = 'IB';
        acc.CurrencyIsoCode = 'USD';
        acc.Account_Manager__c = u.id;
        acc.Design_In_Region__c = 'KOREA';
        acc.STATDESC__c = 'Active';
        acc.Active__c = true;
        insert acc;
        
        Contact con = new contact();
        con.LastName = 'Test';
        con.AccountId = acc.id;
        con.Email = 'test@gmail.com';
        insert con;
        
        Opportunity o = ClsTestHelp.createTestOpportunity();  
        o.AccountId = acc.id;
        o.OEM__c = acc.id;
        o.RecordTypeId = oRTid;
        o.StageName = 'Approved/Active'; 
        insert o;
        
        Opportunity_Record_Type_Groups__c optg4return = Opportunity_Record_Type_Groups__c.getinstance('IND_Sales_Project');
        if(optg4return == null || optg4return.RecordTypeID__c  == null){
            optg4return = new Opportunity_Record_Type_Groups__c();
            RecordType salesPMV = ClsTestHelp.createPMVTestRecordType1();
            RecordType sales = ClsTestHelp.createPMVTestRecordType2();
            optg4return.Name = 'IND_Sales_Project';
            optg4return.Active__c = true;
            optg4return.Default_Record_Type_Lead_Conversion__c = true;
            optg4return.Group__c = 'PMV';
            optg4return.Is_Sales_Only__c = true;
            optg4return.Migration_Record_Type__c = sales.Id;
            optg4return.RecordTypeID__c  = salesPMV.Id;
            insert optg4return;
        }
                
        Opportunity_Record_Type_Groups__c optg4return1 = Opportunity_Record_Type_Groups__c.getinstance('IND_Engineering_project');
        if(optg4return1 == null || optg4return1.RecordTypeID__c  == null){
            optg4return1 = new Opportunity_Record_Type_Groups__c();
            RecordType salesPMV = ClsTestHelp.createPMVTestRecordType3();
            RecordType sales = ClsTestHelp.createPMVTestRecordType4();
            optg4return1.Name = 'IND_Engineering_project';
            optg4return1.Active__c = true;
            optg4return1.Default_Record_Type_Lead_Conversion__c = true;
            optg4return1.Group__c = 'PMV';
            optg4return1.Is_Sales_Only__c = false;
            optg4return1.Migration_Record_Type__c = sales.Id;
            optg4return1.RecordTypeID__c  = salesPMV.Id;
            insert optg4return1;
        }
        
        CSD_Configuration__c setting = new CSD_Configuration__c();
        setting.Name = 'Samsung OEM Account';
        setting.Value__c = acc.Id;
        insert setting;
        
        CSD_Configuration__c setting2 = new CSD_Configuration__c();
        setting2.Name = 'Non OEM Account';
        setting2.Value__c = acc.Id;
        insert setting2;   
       
                
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        insert t;
        List<SelectOption> opt = new  List<SelectOption>();
        List<SelectOption> opt1 = new List<SelectOption>();
        List<SelectOption> opt2 = new List<SelectOption>();
        date dt = system.today();
        string st = '11:46 AM';
        string error = 'testerror';
 
        apexpages.StandardController sc = new apexpages.StandardController(leadInsrt);
        leadConvertCustomController leadConv = new leadConvertCustomController(sc);
        leadConv.accountChanged();
        leadConv.accountLookedUp();
       // try{
        leadConv.populateAccounts();
        //}catch (exception e){
           // e.getMessage();
        //}
        //Database.Error[] errors;
        //leadConv.PrintErrors(errors);
        
        leadConv.DueDateChanged();
        leadConv.convertLead();
        leadConv.selectedContact='';
        leadConv.selectedAccount='';
        leadConv.convertToDatetime(dt, st);
        leadConv.accounts = opt;
        leadConv.leadConvert = leadInsrt;
        leadConv.doNotCreateOppty = true;
        leadConv.sendOwnerEmail = true;
        leadConv.reminder = true;
        leadConv.reminderTime = 'rem';
        leadConv.contactID = con;
        leadConv.redirectLeadDetailPage();
        leadConv.PrintError('error');
        leadConv.contactChanged();
        //leadConv.PrintErrors('errors');
        leadConv.findContacts('test@gmail.com');
        leadConv.LeadStatusOption = null;
        List<SelectOption> LeadStatusOptionTest = new List<SelectOption>();
        LeadStatusOptionTest = leadConv.LeadStatusOption;
        
        leadConv.TaskStatusOption = null;
        List<SelectOption> TaskStatusOptionTest = new List<SelectOption>();
        TaskStatusOptionTest = leadConv.TaskStatusOption;
        
        leadConv.TaskPriorityOption = null;
        List<SelectOption> TaskPriorityOptionTest = new List<SelectOption>();
        TaskPriorityOptionTest = leadConv.TaskPriorityOption;
 
    }
    
    public static testmethod void leadConvertTask(){
     leadConvertTaskRemindComponentController leadConvTask = new leadConvertTaskRemindComponentController();   
     leadConvTask.reminderTime = 'test';   
        string st = 'test';
        //time t = 11:46;
         try{
        leadConvTask.ReminderTimeOption = null;
       List<SelectOption> ReminderTimeOptionTest1 = new List<SelectOption>();
        ReminderTimeOptionTest1 = leadConvTask.ReminderTimeOption;
        
       }catch(exception e){
       List<SelectOption> ReminderTimeOptionTest11 = new List<SelectOption>();
        leadConvTask.ReminderTimeOption = ReminderTimeOptionTest11;
        ReminderTimeOptionTest11 = leadConvTask.ReminderTimeOption;
       }
        List<SelectOption> ReminderTimeOptionTest2 = new List<SelectOption>();
        leadConvTask.disabledActivityDate = 'test';
        leadConvTask.ReminderAddMeridiem(ReminderTimeOptionTest2, 'meridiem');
        leadConvTask.ReminderOption('st');
       // leadConvTask.ReminderAddHour(ReminderTimeOptionTest1, hr, 'meridiem');
        
    }
    public static testmethod void leadConvertTask1(){
     leadConvertTaskRemindComponentController leadConvTask = new leadConvertTaskRemindComponentController();   
     leadConvTask.reminderTime = '8:00AM';   
        string st = 'test';
        //time t = 11:46;
         try{
        leadConvTask.ReminderTimeOption = null;
       List<SelectOption> ReminderTimeOptionTest1 = new List<SelectOption>();
        ReminderTimeOptionTest1 = leadConvTask.ReminderTimeOption;
        
       }catch(exception e){
       List<SelectOption> ReminderTimeOptionTest11 = new List<SelectOption>();
        leadConvTask.ReminderTimeOption = ReminderTimeOptionTest11;
        ReminderTimeOptionTest11 = leadConvTask.ReminderTimeOption;
       }
        List<SelectOption> ReminderTimeOptionTest2 = new List<SelectOption>();
        leadConvTask.disabledActivityDate = 'test';
        leadConvTask.ReminderAddMeridiem(ReminderTimeOptionTest2, 'meridiem');
        leadConvTask.ReminderOption('st');
       // leadConvTask.ReminderAddHour(ReminderTimeOptionTest1, hr, 'meridiem');
        
    }
    
}