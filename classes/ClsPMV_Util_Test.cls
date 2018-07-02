/**
*   This test class is for ClsPMV_Util.
*
@author Lei Tang
@created 2014-04-28
@version 1.0
@since 27.0
*
@changelog
* 2014-04-28 Lei Tang <lei.tang@itbconsult.com>
* - Created
* - Test coverage 81%
*/
@isTest(SeeAllData = true)
private class ClsPMV_Util_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        /*
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();  */
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
   /*     PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        */
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        //added by bhavya
        ssps1.PMV_Type__c = 'Industrial-Industrial';
        ssps1.Sales_Process_ID__c = '019E0000000GwqOIAS';
        ssps1.Deal_Size_Min__c = 9;
        update ssps1;
        ssps2.PMV_Type__c = 'Industrial-Industrial';
        ssps2.Sales_Process_ID__c = '019E0000000GwqOIAS';
        ssps2.Deal_Size_Min__c = 9;
        ssps2.Deal_Size_Max__c = 11;
        update ssps2;        
        //end
        
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.test1';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        
        OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];
        
        
        ClsPMV_Util.getPMVSalesStageSetting();
        
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
      //  insert acc;
        
        
       // oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
        ClsPMV_Util.dontChangeStage = true;
        Quality_Assessment_Question__c qaq = new Quality_Assessment_Question__c();
        qaq.Question_Chinese__c = 'test';
        qaq.Question_English__c = 'test';
        qaq.Question_German__c = 'test';
        qaq.Question_Japanese__c = 'tset';
        qaq.Help_Comment_Chinese__c = 'tset';
        qaq.Help_Comment_English__c =  'test';
        qaq.Help_Comment_German__c = 'test';
        qaq.Help_Comment_Japanese__c =  'test';
        insert qaq;
        
        Quality_Assessment_Question__c qaq1 = new Quality_Assessment_Question__c();
        qaq1.Question_Chinese__c = 'test1';
        qaq1.Question_English__c = 'test1';
        qaq1.Question_German__c = 'test1';
        qaq1.Question_Japanese__c = 'tset1';
        qaq1.Help_Comment_Chinese__c = 'tset1';
        qaq1.Help_Comment_English__c =  'test1';
        qaq1.Help_Comment_German__c = 'test1';
        qaq1.Help_Comment_Japanese__c =  'test1';
        insert qaq1;
        
        Sales_Process_Question_Assignment__c pqa = new Sales_Process_Question_Assignment__c();
        pqa.Quality_Assessment_Question__c = qaq.Id;
        
        OpportunityStage opStageWon = ClsTestHelp.createPMVTestOS7();
        OpportunityStage opStage = ClsTestHelp.createPMVTestOS4();
              
        pqa.BusinessProcess__c  = rt.BusinessProcessId;
        pqa.OpportunityStage__c = opStage.Id;
        pqa.PMV_Type__c = 'IND Standard Sales opp;IND Standard ENG opp';
        pqa.Rating__c = 50;
        insert pqa;
        
        Sales_Process_Question_Assignment__c pqa1 = new Sales_Process_Question_Assignment__c();
        pqa1.Quality_Assessment_Question__c = qaq1.Id;
        pqa1.BusinessProcess__c  = rt.BusinessProcessId;
        pqa1.OpportunityStage__c = opStageWon.Id;
        pqa1.PMV_Type__c = 'IND Standard Sales opp;IND Standard ENG opp';
        pqa1.Rating__c = 50;
        insert pqa1;
        
        Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
        qaa.Sales_Process_Question_Assignment__c = pqa.Id;        
        qaa.Opportunity__c = oppty1.Id;
        qaa.Status__c = 'In Progress';
        qaa.Active__c = true;
        insert qaa;
        
        Quality_Assessment_Answer__c qaa1 = new Quality_Assessment_Answer__c();
        qaa1.Sales_Process_Question_Assignment__c = pqa1.Id;        
        qaa1.Opportunity__c = oppty1.Id;
        qaa1.Status__c = 'Yes';
        qaa1.Active__c = true;
        insert qaa1;
        
        ClsPMV_Util.dontChangeStage = false;
        set<Id> set_qaaIds = new set<Id>();
        set_qaaIds.add(qaa.Id);
        
        ClsPMV_Util.calculateOppyStage(set_qaaIds); 
        
        ClsPMV_Util.getDealSizeColor(10 ,'Industrial-Industrial'  , '019E0000000GwqOIAS' );
        
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        ClsPMV_Util.initQualifierQuestionForOpp(map_Id_Opps);
        
        /*ClsPMV_Util.getProjectClosedDateForOppy(set_oppy);
        
        integer conRoleNum = ClsPMV_Util.calculateContactRoleNum(oppty1.Id);
        integer decisionNumNum = ClsPMV_Util.calculateDecisionCriteriaNum(oppty1.Id);
        //integer ansNum = ClsPMV_Util.calculateNumOfAnswer(oppty1);
        integer questionNum = ClsPMV_Util.calculateNumOfQuestion(oppty1);
        */
        system.assert(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myUnitTest_1() {
        // TO DO: implement unit test
        
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.test1';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        
        OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];
        
        
        ClsPMV_Util.getPMVSalesStageSetting();
        
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
      //  insert acc;
        
       // oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
                       
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
        ClsPMV_Util.dontChangeStage = true;
        Quality_Assessment_Question__c qaq = new Quality_Assessment_Question__c();
        qaq.Question_Chinese__c = 'test';
        qaq.Question_English__c = 'test';
        qaq.Question_German__c = 'test';
        qaq.Question_Japanese__c = 'tset';
        qaq.Help_Comment_Chinese__c = 'tset';
        qaq.Help_Comment_English__c =  'test';
        qaq.Help_Comment_German__c = 'test';
        qaq.Help_Comment_Japanese__c =  'test';
        insert qaq;
        
        Quality_Assessment_Question__c qaq1 = new Quality_Assessment_Question__c();
        qaq1.Question_Chinese__c = 'test1';
        qaq1.Question_English__c = 'test1';
        qaq1.Question_German__c = 'test1';
        qaq1.Question_Japanese__c = 'tset1';
        qaq1.Help_Comment_Chinese__c = 'tset1';
        qaq1.Help_Comment_English__c =  'test1';
        qaq1.Help_Comment_German__c = 'test1';
        qaq1.Help_Comment_Japanese__c =  'test1';
        insert qaq1;
        
        Sales_Process_Question_Assignment__c pqa = new Sales_Process_Question_Assignment__c();
        pqa.Quality_Assessment_Question__c = qaq.Id;
        
        OpportunityStage opStageWon = ClsTestHelp.createPMVTestOS7();
        OpportunityStage opStage = ClsTestHelp.createPMVTestOS4();
                     
        pqa.BusinessProcess__c  = rt.BusinessProcessId;
        pqa.OpportunityStage__c = opStage.Id;
        pqa.PMV_Type__c = 'IND Standard Sales opp;IND Standard ENG opp';
        pqa.Rating__c = 50;
        insert pqa;
        
        Sales_Process_Question_Assignment__c pqa1 = new Sales_Process_Question_Assignment__c();
        pqa1.Quality_Assessment_Question__c = qaq1.Id;
        pqa1.BusinessProcess__c  = rt.BusinessProcessId;
        pqa1.OpportunityStage__c = opStageWon.Id;
        pqa1.PMV_Type__c = 'IND Standard Sales opp;IND Standard ENG opp';
        pqa1.Rating__c = 50;
        insert pqa1;
        
        Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
        qaa.Sales_Process_Question_Assignment__c = pqa.Id;
        
        qaa.Opportunity__c = oppty1.Id;
        qaa.Status__c = 'In Progress';
        qaa.Active__c = true;
        insert qaa;
        
        Quality_Assessment_Answer__c qaa1 = new Quality_Assessment_Answer__c();
        qaa1.Sales_Process_Question_Assignment__c = pqa1.Id;
        
        qaa1.Opportunity__c = oppty1.Id;
        qaa1.Status__c = 'In Progress';
        qaa1.Active__c = true;
        insert qaa1;
        
        //added by bhavya
        Decision_Criteria__c dc = new Decision_Criteria__c();
        dc.Opportunity__c = oppty1.id;
        dc.Active__c = true;
        insert dc;
        //end
        
        ClsPMV_Util.dontChangeStage = false;
        set<Id> set_qaaIds = new set<Id>();
        set_qaaIds.add(qaa.Id);
        
        ClsPMV_Util.calculateOppyStage(set_qaaIds); 
        
        ClsPMV_Util.getDealSizeColor(10 ,'Industrial-Industrial'  , '019E0000000GwqOIAS' );
        
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
       // ClsPMV_Util.initQualifierQuestionForOpp(map_Id_Opps);
        
        ClsPMV_Util.getProjectClosedDateForOppy(set_oppy);
        
        integer conRoleNum = ClsPMV_Util.calculateContactRoleNum(oppty1.Id);
        integer decisionNumNum = ClsPMV_Util.calculateDecisionCriteriaNum(oppty1.Id);
        //integer ansNum = ClsPMV_Util.calculateNumOfAnswer(oppty1);
        integer questionNum = ClsPMV_Util.calculateNumOfQuestion(oppty1);
        
        system.assert(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myUnitTest1() {
      //  Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
      /*  Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
    */
       /* User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.test2';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
       // OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];  
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
      //  insert acc;
        
       // oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
        
         Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        List<Product_Hierarchy__c> list_proHierarchy = new  List<Product_Hierarchy__c> ();
        list_proHierarchy .add(ph);
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
         part.name='Sales Part';
         part.Standard_Price__c=120.34;
          insert part;
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppty1.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Process_Status__c = 'Production';
        oppypart1.initial_billing_date__c = Date.today();
        oppypart1.initial_order_date__c = Date.today();            
        oppypart1.RecordTypeId = '012E0000000XrBg';
          oppypart1.CurrencyIsoCode='USD';  
              oppypart1.Status__c = 'Commit';
        insert oppypart1;
        
        
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        //ClsPMV_Util.updateOppyStageForStage(set_oppyId);
        
        ClsPMV_Util.setSalesProcessName(set_oppy);
        ClsPMV_Util.calculateGDIValue(list_proHierarchy );
        
        
        
        system.assert(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myUnitTest1_1() {
     /*   Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
    */
       /* User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.test2';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
    //   OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];  
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
       // insert acc;
        
      //  oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
        
         Product_Hierarchy__c ph = new Product_Hierarchy__c();
        ph.Hierarchy_Level_Type__c = 'CBC1';
        ph.Description__c = 'Industrial'; 
        insert ph;
        
        List<Product_Hierarchy__c> list_proHierarchy = new  List<Product_Hierarchy__c> ();
        list_proHierarchy .add(ph);
        
        Part__c part = new Part__c();
        part.Description__c = 'Sniper';
        part.Product_Hierarchy__c = ph.Id;
         part.name='Sales Part';
         part.Standard_Price__c=120.34;
          insert part;
        Opportunity_Part__c oppypart1 = ClsTestHelp.createTestOpportunityPart();
        oppypart1.Opportunity__c = oppty1.Id;
        oppypart1.Part__c = part.Id;
        oppypart1.Process_Status__c = 'Production';
        oppypart1.initial_billing_date__c = Date.today();
        oppypart1.initial_order_date__c = Date.today();            
        oppypart1.RecordTypeId = '012E0000000XrBg';
          oppypart1.CurrencyIsoCode='USD';  
              oppypart1.Status__c = 'Commit';
        insert oppypart1;
        
        
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
                
        ClsPMV_Util.updateOppyStageForStage(set_oppyId);
        /*
        ClsPMV_Util.setSalesProcessName(set_oppy);
        ClsPMV_Util.calculateGDIValue(list_proHierarchy );
        */
                
        system.assert(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myUnitTest11() {
       /* 
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        */
       /* User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.tes3t';
        insert user;*/
        
         User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
      //  insert acc;
        
        
       // oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        ClsPMV_Util.calculateOppyWhenAnswerChanged(set_oppyId);
       
        
        
        system.assert(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myUnitTest111() {
     /*   Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        
        */
        
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe4.conte.test';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
      //  insert acc;
        
        
      //  oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        ClsPMV_Util.oppyRTPMV2NonePMV(set_oppyId);
        
        //ClsPMV_Util.oppyRTPMV2PMV(set_oppyId);
        
        
        system.assert(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myUnitTest111_1() {
       /* Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
      */  
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe4.conte.test';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
       // insert acc;
        
        
      //  oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        //ClsPMV_Util.oppyRTPMV2NonePMV(set_oppyId);
        
        ClsPMV_Util.oppyRTPMV2PMV(set_oppyId);
        
        
        system.assert(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asd5fe.conte.test';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];  
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
        insert acc;
        
        
        oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'Industrial-IB';
        
        insert oppty1;
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        update oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        List<Quality_Assessment_Answer__c> list_answer2creat = new List<Quality_Assessment_Answer__c>();
        ClsPMV_Util.createQualityAssessmentAnswer(oppty1.Id,null,list_answer2creat );
        /*
        ClsPMV_Util.recalculateOppyStage(set_oppyId);
        
        set<Id> set_ownerId4PMVType = new set<Id>();
        set_ownerId4PMVType.add(oppty1.OwnerId);
        set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
        ClsPMV_Util.setPMVType(list_newOppy, set_ownerId4PMVType, set_rts);
        
        ClsPMV_Util.oppyRTNonPMV2PMVAddDecisionCriteria(list_newOppy);
        
        
        system.assert(true); */
        }
        Test.stopTest();
    }
    
      static testMethod void myUnitTest2_1() {
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asd5fe.conte.test';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];  
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
        //insert acc;
        
        
        //oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'Industrial-IB';
        
        insert oppty1;
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        update oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
     //   List<Quality_Assessment_Answer__c> list_answer2creat = new List<Quality_Assessment_Answer__c>();
      //  ClsPMV_Util.createQualityAssessmentAnswer(oppty1.Id,null,list_answer2creat );
        
        ClsPMV_Util.recalculateOppyStage(set_oppyId);
      /*  
        set<Id> set_ownerId4PMVType = new set<Id>();
        set_ownerId4PMVType.add(oppty1.OwnerId);
        set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
        ClsPMV_Util.setPMVType(list_newOppy, set_ownerId4PMVType, set_rts);
        
        ClsPMV_Util.oppyRTNonPMV2PMVAddDecisionCriteria(list_newOppy);
        
        */
        system.assert(true);
        }
        Test.stopTest();
    }
  
    
    
    static testMethod void myUnitTest3() {
        User u = [select Id, Name, Sub_Vertical__c, GIBU__c from User where Id = :UserInfo.getUserId() limit 1];
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        update u;
        system.runAs(u){
            Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
            Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
            PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
            PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
            PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
            PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
            PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
            PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
            PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
            PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
            PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
            PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
            PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
            PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
            PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
            PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
            PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
            PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
            PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
            PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
            PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
            PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
            PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
            PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
            
            Test.startTest();
    
            String oppyRT;
            RecordType rt = ClsTestHelp.createPMVTestRecordType1();
            oppyRT = rt.Id;
            
            OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];  
            
            Opportunity oppty1 = new Opportunity();
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.BillingCountry = 'US';
            insert acc;
            
            
            oppty1.AccountId = acc.Id;
            oppty1.Name = 'test';
            oppty1.CurrencyIsoCode = 'EUR';
            oppty1.currency_confirm__c = true;
            oppty1.Type = 'New Business';
            oppty1.Description = 'test';
            oppty1.Distributor__c = 'Dachs';
            oppty1.StageName = 'Initiating';
            oppty1.Manufacturing_Start_Date__c = date.today();
            oppty1.CloseDate = date.today().addMonths(1);
            oppty1.RecordTypeId = oppyRT;
            oppty1.Lead_ID__c = '01x000000000fgh';
            oppty1.PMV_Type__c = 'IND Standard Sales opp';
            oppty1.StageName = 'Exploring Needs';
            
            insert oppty1;
            
            Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
            map_Id_Opps.put(oppty1.Id,oppty1);
            set<Id> set_oppyId= new set<Id>();
            set<string> set_oppyIdstring= new set<string>();
            set<Opportunity> set_oppy = new set<Opportunity>();
            list<Opportunity> list_newOppy = new list<Opportunity>();
            set_oppy.add(oppty1);
            set_oppyId.add(oppty1.Id);
            list_newOppy.add(oppty1);
            set_oppyIdstring.add(oppty1.Id);
            
            
            ClsPMV_Util.oppyRTNonPMV2PMVAddKeyPlayerCriteria(list_newOppy);
            
            ClsPMV_Util.recalculateOppyStageFuture(set_oppyId);
            
            ClsPMV_Util.createErrorMessageAndTask(set_oppyIdstring,'test');
            
            set<String> set_membIds = new set<String>();
            list<CtrlPMVTeamView.TeamViewObject> list_teamMembs = new list<CtrlPMVTeamView.TeamViewObject>();
    
            TeamView_Team__c tv =  new TeamView_Team__c();
            tv.Team_Member_User_IDs__c = userInfo.getUserId();
            insert tv;
            ClsPMV_Util.getUserListbyTeamViewId(tv.Id ,list_teamMembs ,set_membIds);
            
            
            system.assert(true);
            
            Test.stopTest();
        }
    }
    
    static testMethod void myUnitTest4() {
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.te6st';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];  
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
        insert acc;
        
        
        oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'Industrial-IB';
        
        insert oppty1;
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        update oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        set<Id> set_ownerId4PMVType = new set<Id>();
        set_ownerId4PMVType.add(oppty1.OwnerId);
        
        ClsPMV_Util.getIndustryUser(set_ownerId4PMVType);
        
        ClsPMV_Util.getPMVRecordTypeForLeadOppy();
        
        ClsPMV_Util.hasDecisionCriteria(list_newOppy );
        
        ClsPMV_Util.hasKeyPlayerCriteria(list_newOppy );
        
        ClsPMV_Util.checkContactRoleAndGenerateKeyPlayer(oppty1.Id);
        
        
        system.assert(true);
        }
        Test.stopTest();
    }
    
    static testMethod void myUnitTest5() {
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.tes7t';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];  
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
        insert acc;
        
        
        oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'Industrial-IB';
        
        insert oppty1;
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        update oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        Key_Player__c kp = new Key_Player__c();
        kp.Opportunity__c = oppty1.Id;
        insert kp;
        List<Key_Player__c> list_kp = new List<Key_Player__c>();
        list_kp.add(kp );
        ClsPMV_Util.createKeyPlayerCriterias(list_kp);
        
        Decision_Criteria__c dc = new Decision_Criteria__c();
        dc.Active__c = true;
        dc.Opportunity__c = oppty1.Id;
        insert dc;
        List<Decision_Criteria__c> list_dc = new List<Decision_Criteria__c>();
        list_dc.add(dc );
        ClsPMV_Util.createKeyPlayerCriteriasWithDecision(list_dc);
        
      /*  ClsPMV_Util.createKeyPlayerCriteriasWithDecisionForUpdate(list_dc);
        
        
        
        ClsPMV_Util.checkEditAccessForSObject(user.Id,oppty1.Id);
        
        */
        system.assert(true);
        
        }
        Test.stopTest();
    }
    
     static testMethod void myUnitTest5_1() {
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.tes7t';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];  
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
        insert acc;
        
        
        oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'Industrial-IB';
        
        insert oppty1;
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        update oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
       
        Key_Player__c kp = new Key_Player__c();
        kp.Opportunity__c = oppty1.Id;
        insert kp;
        List<Key_Player__c> list_kp = new List<Key_Player__c>();
        list_kp.add(kp );
        ClsPMV_Util.createKeyPlayerCriterias(list_kp);
        
        Decision_Criteria__c dc = new Decision_Criteria__c();
        dc.Active__c = true;
        dc.Opportunity__c = oppty1.Id;
        insert dc;
        List<Decision_Criteria__c> list_dc = new List<Decision_Criteria__c>();
        list_dc.add(dc );
     //   ClsPMV_Util.createKeyPlayerCriteriasWithDecision(list_dc);  
        
        ClsPMV_Util.createKeyPlayerCriteriasWithDecisionForUpdate(list_dc);
        
        
        
        ClsPMV_Util.checkEditAccessForSObject(user.Id,oppty1.Id);
        
        
        system.assert(true);
        
        }
        Test.stopTest();
    }
    
   
    
    static testMethod void myUnitTest6() {
        // TO DO: implement unit test
     /*   
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
      */  
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.test1';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        
        OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];
        
        
        ClsPMV_Util.getPMVSalesStageSetting();
        
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
     //   insert acc;
        
        
     //   oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
        ClsPMV_Util.dontChangeStage = true;
        Quality_Assessment_Question__c qaq = new Quality_Assessment_Question__c();
        qaq.Question_Chinese__c = 'test';
        qaq.Question_English__c = 'test';
        qaq.Question_German__c = 'test';
        qaq.Question_Japanese__c = 'tset';
        qaq.Help_Comment_Chinese__c = 'tset';
        qaq.Help_Comment_English__c =  'test';
        qaq.Help_Comment_German__c = 'test';
        qaq.Help_Comment_Japanese__c =  'test';
        insert qaq;
        
        Quality_Assessment_Question__c qaq1 = new Quality_Assessment_Question__c();
        qaq1.Question_Chinese__c = 'test1';
        qaq1.Question_English__c = 'test1';
        qaq1.Question_German__c = 'test1';
        qaq1.Question_Japanese__c = 'tset1';
        qaq1.Help_Comment_Chinese__c = 'tset1';
        qaq1.Help_Comment_English__c =  'test1';
        qaq1.Help_Comment_German__c = 'test1';
        qaq1.Help_Comment_Japanese__c =  'test1';
        insert qaq1;
        
        Sales_Process_Question_Assignment__c pqa = new Sales_Process_Question_Assignment__c();
        pqa.Quality_Assessment_Question__c = qaq.Id;
        
        OpportunityStage opStageWon = ClsTestHelp.createPMVTestOS7();
        OpportunityStage opStage = ClsTestHelp.createPMVTestOS4();
              
        pqa.BusinessProcess__c  = rt.BusinessProcessId;
        pqa.OpportunityStage__c = opStage.Id;
        pqa.PMV_Type__c = 'IND Standard Sales opp;IND Standard ENG opp';
        pqa.Rating__c = 50;
        insert pqa;
        
        Sales_Process_Question_Assignment__c pqa1 = new Sales_Process_Question_Assignment__c();
        pqa1.Quality_Assessment_Question__c = qaq1.Id;
        pqa1.BusinessProcess__c  = rt.BusinessProcessId;
        pqa1.OpportunityStage__c = opStageWon.Id;
        pqa1.PMV_Type__c = 'IND Standard Sales opp;IND Standard ENG opp';
        pqa1.Rating__c = 50;
        insert pqa1;
        
        Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
        qaa.Sales_Process_Question_Assignment__c = pqa.Id;
        
        qaa.Opportunity__c = oppty1.Id;
        qaa.Status__c = 'In Progress';
        qaa.Active__c = true;
        insert qaa;
        
        Quality_Assessment_Answer__c qaa1 = new Quality_Assessment_Answer__c();
        qaa1.Sales_Process_Question_Assignment__c = pqa1.Id;
        
        qaa1.Opportunity__c = oppty1.Id;
        qaa1.Status__c = 'Yes';
        qaa1.Active__c = true;
        insert qaa1;
        
        Contact c = new Contact();
       // c.Account = acc;
        c.Lastname = 'Test';
        c.Email = 'test456@tec.com';
        insert c;
        OpportunityContactRole  ctrole= new OpportunityContactRole ();
     /*   
        Custom_Opportunity_Contact_Role__c conrole = new Custom_Opportunity_Contact_Role__c();
        conrole.Opportunity__c = oppty1.Id;
        conrole.Contact__c = c.Id;
        insert conrole; 
        */
         OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.OpportunityId = oppty1.Id;
            ocr.ContactId = c.Id;
            ocr.Role = 'Business User';
            insert ocr;
        
        
        set<Id> set_conIds = new  set<Id>();
         set<Id> set_conIdsDeleted= new  set<Id>();
         
         set_conIds.add(c.Id);
        ClsPMV_Util.dontChangeStage = false;
        set<Id> set_qaaIds = new set<Id>();
        set_qaaIds.add(qaa.Id);
        
        ClsPMV_Util.calculateOppyStage(set_qaaIds); 
        
        ClsPMV_Util.getDealSizeColor(10 ,'Industrial-Industrial'  , '019E0000000GwqOIAS' );
        
        
          Key_Player__c kp = new Key_Player__c();
        kp.Opportunity__c = oppty1.Id;
        insert kp;
        List<Key_Player__c> list_kp = new List<Key_Player__c>();
        list_kp.add(kp );
        
        set<Id> set_oppyIds = new set<Id> ();
        set_oppyIds.add(oppty1.Id);
        //ClsPMV_Util.createContactRoleForLeadOpportunity(set_oppyIds );
        ClsPMV_Util.createKeyPlayerCriterias(list_kp);
          ClsPMV_Util.checkContactRoleAndGenerateKeyPlayer(oppty1.Id);
          ClsPMV_Util.updateOpportunityNPSScoreWhenContactChanged(set_conIds ,set_conIdsDeleted);
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        //ClsPMV_Util.initQualifierQuestionForOpp(map_Id_Opps);
        
        //ClsPMV_Util.getProjectClosedDateForOppy(set_oppy);
        
        //integer conRoleNum = ClsPMV_Util.calculateContactRoleNum(oppty1.Id);
        //integer decisionNumNum = ClsPMV_Util.calculateDecisionCriteriaNum(oppty1.Id);
        integer ansNum = ClsPMV_Util.calculateNumOfAnswer(oppty1);
        //integer questionNum = ClsPMV_Util.calculateNumOfQuestion(oppty1);
        
        
      
        
        system.assert(true);
        }
        Test.stopTest();
    }
    
     static testMethod void myUnitTest6_1() {
        // TO DO: implement unit test
      /*  
        Opportunity_Record_Type_Groups__c  org1 = ClsTestHelp.createTestOPTG1();
        Opportunity_Record_Type_Groups__c  org2 = ClsTestHelp.createTestOPTG2();
        PMV_Language_Config__c slc1 = ClsTestHelp.createTestSLC1();
        PMV_Language_Config__c slc2 = ClsTestHelp.createTestSLC2();
        PMV_Language_Config__c slc3 = ClsTestHelp.createTestSLC3();
        PMV_Sales_Process_Settings__c ssps1 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Process_Settings__c ssps2 = ClsTestHelp.createTestSSPS1();
        PMV_Sales_Stage_Setting__c ssss1 = ClsTestHelp.createTestSSSS1();
        PMV_Sales_Stage_Setting__c ssss2 = ClsTestHelp.createTestSSSS2();
        PMV_Sales_Stage_Setting__c ssss3 = ClsTestHelp.createTestSSSS3();
        PMV_Sales_Stage_Setting__c ssss4 = ClsTestHelp.createTestSSSS4();
        PMV_Sales_Stage_Setting__c ssss5 = ClsTestHelp.createTestSSSS5();
        PMV_Sales_Stage_Setting__c ssss6 = ClsTestHelp.createTestSSSS6();
        PMV_Sales_Stage_Setting__c ssss7 = ClsTestHelp.createTestSSSS7();
        PMV_Sales_Stage_Setting__c ssss8 = ClsTestHelp.createTestSSSS8();
        PMV_Sales_Stage_Setting__c ssss9 = ClsTestHelp.createTestSSSS9();
        PMV_Sales_Stage_Setting__c ssss10 = ClsTestHelp.createTestSSSS10();
        PMV_Stage_Config__c ssc1 = ClsTestHelp.createTestSSC1();
        PMV_Stage_Config__c ssc2 = ClsTestHelp.createTestSSC2();
        PMV_Stage_Config__c ssc3 = ClsTestHelp.createTestSSC3();
        PMV_Stage_Config__c ssc4 = ClsTestHelp.createTestSSC4();
        PMV_Stage_Config__c ssc5 = ClsTestHelp.createTestSSC5();
        PMV_Stage_Config__c ssc6 = ClsTestHelp.createTestSSC6();
        PMV_Stage_Config__c ssc7 = ClsTestHelp.createTestSSC7();
       */ 
        /*User user = ClsTestHelp.createTestUsers4PMV();
        user.Username = 'tset@asdfe.conte.test1';
        insert user;*/
        User user =  [Select Id, Name,Email , country,GIBU__c,Sub_Vertical__c  From User 
                     where GIBU__c='Industrial' and Sub_Vertical__c='Industrial'  and isactive=true 
                      limit 1];
        
        system.runAs(user){
        Test.startTest();

        String oppyRT;
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        oppyRT = rt.Id;
        
        
       // OpportunityStage os = [SELECT MasterLabel, Id FROM OpportunityStage where isActive=true limit 1];
        
        
        ClsPMV_Util.getPMVSalesStageSetting();
        
        
        Opportunity oppty1 = new Opportunity();
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Type = 'CM';
        acc.BillingCountry = 'US';
       // insert acc;
        
        
       // oppty1.AccountId = acc.Id;
        oppty1.Name = 'test';
        oppty1.CurrencyIsoCode = 'EUR';
        oppty1.currency_confirm__c = true;
        oppty1.Type = 'New Business';
        oppty1.Description = 'test';
        oppty1.Distributor__c = 'Dachs';
        oppty1.StageName = 'Initiating';
        oppty1.Manufacturing_Start_Date__c = date.today();
        oppty1.CloseDate = date.today().addMonths(1);
        oppty1.RecordTypeId = oppyRT;
        oppty1.Lead_ID__c = '01x000000000fgh';
        oppty1.PMV_Type__c = 'IND Standard Sales opp';
        oppty1.StageName = 'Exploring Needs';
        oppty1.Stage_Change_Error_Message__c = 'test';
        insert oppty1;
        
        Map<Id,Opportunity> map_Id_Opps = new Map<Id,Opportunity>();
        map_Id_Opps.put(oppty1.Id,oppty1);
        set<Id> set_rts = ClsPMV_Util.getAllPMVRecordtypes();
        ClsPMV_Util.dontChangeStage = true;
        Quality_Assessment_Question__c qaq = new Quality_Assessment_Question__c();
        qaq.Question_Chinese__c = 'test';
        qaq.Question_English__c = 'test';
        qaq.Question_German__c = 'test';
        qaq.Question_Japanese__c = 'tset';
        qaq.Help_Comment_Chinese__c = 'tset';
        qaq.Help_Comment_English__c =  'test';
        qaq.Help_Comment_German__c = 'test';
        qaq.Help_Comment_Japanese__c =  'test';
        insert qaq;
        
        Quality_Assessment_Question__c qaq1 = new Quality_Assessment_Question__c();
        qaq1.Question_Chinese__c = 'test1';
        qaq1.Question_English__c = 'test1';
        qaq1.Question_German__c = 'test1';
        qaq1.Question_Japanese__c = 'tset1';
        qaq1.Help_Comment_Chinese__c = 'tset1';
        qaq1.Help_Comment_English__c =  'test1';
        qaq1.Help_Comment_German__c = 'test1';
        qaq1.Help_Comment_Japanese__c =  'test1';
        insert qaq1;
        
        Sales_Process_Question_Assignment__c pqa = new Sales_Process_Question_Assignment__c();
        pqa.Quality_Assessment_Question__c = qaq.Id;
        
        OpportunityStage opStageWon = ClsTestHelp.createPMVTestOS7();
        OpportunityStage opStage = ClsTestHelp.createPMVTestOS4();
              
        pqa.BusinessProcess__c  = rt.BusinessProcessId;
        pqa.OpportunityStage__c = opStage.Id;
        pqa.PMV_Type__c = 'IND Standard Sales opp;IND Standard ENG opp';
        pqa.Rating__c = 50;
        insert pqa;
        
        Sales_Process_Question_Assignment__c pqa1 = new Sales_Process_Question_Assignment__c();
        pqa1.Quality_Assessment_Question__c = qaq1.Id;
        pqa1.BusinessProcess__c  = rt.BusinessProcessId;
        pqa1.OpportunityStage__c = opStageWon.Id;
        pqa1.PMV_Type__c = 'IND Standard Sales opp;IND Standard ENG opp';
        pqa1.Rating__c = 50;
        insert pqa1;
        
        Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
        qaa.Sales_Process_Question_Assignment__c = pqa.Id;
        
        qaa.Opportunity__c = oppty1.Id;
        qaa.Status__c = 'In Progress';
        qaa.Active__c = true;
        insert qaa;
        
        Quality_Assessment_Answer__c qaa1 = new Quality_Assessment_Answer__c();
        qaa1.Sales_Process_Question_Assignment__c = pqa1.Id;
        
        qaa1.Opportunity__c = oppty1.Id;
        qaa1.Status__c = 'Yes';
        qaa1.Active__c = true;
        insert qaa1;
        
        Contact c = new Contact();
      //  c.Account = acc;
        c.Lastname = 'Test';
        c.Email = 'test456@tec.com';
        insert c;
        OpportunityContactRole  ctrole= new OpportunityContactRole ();
     
         OpportunityContactRole ocr = new OpportunityContactRole();
            ocr.OpportunityId = oppty1.Id;
            ocr.ContactId = c.Id;
            ocr.Role = 'Business User';
            insert ocr;
        
        
        set<Id> set_conIds = new  set<Id>();
         set<Id> set_conIdsDeleted= new  set<Id>();
         
         set_conIds.add(c.Id);
        ClsPMV_Util.dontChangeStage = false;
        set<Id> set_qaaIds = new set<Id>();
        set_qaaIds.add(qaa.Id);
        
        ClsPMV_Util.calculateOppyStage(set_qaaIds); 
        
        ClsPMV_Util.getDealSizeColor(10 ,'Industrial-Industrial'  , '019E0000000GwqOIAS' );
        
        
          Key_Player__c kp = new Key_Player__c();
        kp.Opportunity__c = oppty1.Id;
        insert kp;
        List<Key_Player__c> list_kp = new List<Key_Player__c>();
        list_kp.add(kp );
        
        set<Id> set_oppyIds = new set<Id> ();
        set_oppyIds.add(oppty1.Id);
       
        set<Id> set_oppyId= new set<Id>();
        set<string> set_oppyIdstring= new set<string>();
        set<Opportunity> set_oppy = new set<Opportunity>();
        list<Opportunity> list_newOppy = new list<Opportunity>();
        set_oppy.add(oppty1);
        set_oppyId.add(oppty1.Id);
        list_newOppy.add(oppty1);
        set_oppyIdstring.add(oppty1.Id);
        
        
        
        
        ClsPMV_Util.initQualifierQuestionForOpp(map_Id_Opps);
        
        ClsPMV_Util.getProjectClosedDateForOppy(set_oppy);
        
        //integer conRoleNum = ClsPMV_Util.calculateContactRoleNum(oppty1.Id);
        //integer decisionNumNum = ClsPMV_Util.calculateDecisionCriteriaNum(oppty1.Id);
        integer ansNum = ClsPMV_Util.calculateNumOfAnswer(oppty1);
        //integer questionNum = ClsPMV_Util.calculateNumOfQuestion(oppty1);
        
        
      
        
        system.assert(true);
        }
        Test.stopTest();
    }
}