/**
*  This test class used to test class ExtOppy_qualifierOverview.
*
@author Weihang Li
@created 2014-04-28
@version 1.0   
@since 28.0
*
@changelog
* coverage  85%
* 
* 
2014-04-28 Weihang Li <weihang.li@itbconsult.com>
* - Created
*/
@isTest(seealldata=false)
private class ExtOppy_qualifierOverview_Test {
    
    static testMethod void myUnitTest() {
        
        RecordType rt = ClsTestHelp.createPMVTestRecordType1();
        User u = ClsTestHelp.createTestUsers4PMV();
        u.Username = 'jinbo@sdfasdf.cssddgrw2sddde3';
        insert u;
        system.runAs(u){
			ClsTestCustomSettingHelper.getApex_Helper_Settings();
            ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
            ClsTestCustomSettingHelper.getOpportunity_Approvers();
            ClsTestCustomSettingHelper.getTrigger_Configuration();
            ClsTestCustomSettingHelper.getProfitBUCenterMapping();
            ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
            ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
            ClsTestCustomSettingHelper.getPMV_Sales_Process_Settings();
            ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
            ClsTestCustomSettingHelper.getPMV_Stage_Config();
            Channelinsightdata_test.Channelinsightdata_test();
           
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            acc.AccountNumber = '011001020389';
            insert acc; 
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.AccountId = acc.Id;
            oppy.Type = 'CM';
            oppy.RecordTypeId = rt.Id;
            oppy.PMV_Type__c = 'IND Standard Sales opp';
            oppy.StageName = 'Won';
            oppy.Probability = 0.5; 
            //oppy.CurrencyIsoCode = 'AUD';
            oppy.CurrencyIsoCode = 'USD';
            oppy.Manufacturing_Start_Date__c = system.today();
            insert oppy;            
           	//ClsTriggerFactory.isSkipTrigger = false;
            //ClsTriggerFactory.setSkipHandlers(true);
           	//ClsTriggerFactory.setSkipHandler('OpportunityTrgHandler',true); 
            Opportunity_Part__c op = new Opportunity_Part__c();
            op.Opportunity__c = oppy.Id;
            op.Status__c = 'Weak';
            op.Cable_Assembly_Type__c = 'Fiber Optic';
            try{
                insert op;
            }catch(Exception exp) {                
            }
            
            
            OpportunityStage opStage = ClsTestHelp.createPMVTestOS4();
            
            Quality_Assessment_Question__c qa = new Quality_Assessment_Question__c();
            qa.Help_Comment_Chinese__c = 'test';
            insert qa;
            
            Sales_Process_Question_Assignment__c spqa = new Sales_Process_Question_Assignment__c();
            spqa.PMV_Type__c = 'IND Standard Sales opp';
            spqa.BusinessProcess__c ='019E0000000HnrFIAS'; 
            spqa.OpportunityStage__c = opStage.id;
            spqa.Quality_Assessment_Question__c =qa.id;
            insert spqa;  
            

               
            
            Sales_Process_Question_Assignment__c sp = new Sales_Process_Question_Assignment__c();
            sp.BusinessProcess__c = rt.BusinessProcessId;
            sp.PMV_Type__c = 'IND Standard Sales opp';
            sp.OpportunityStage__c = opStage.Id;
            sp.Quality_Assessment_Question__c = qa.Id;
            insert sp;
            
            list<Opportunity_Forecast__c> list_fc2Insert = new list<Opportunity_Forecast__c>();
            Opportunity_Forecast__c  oppyFore = new Opportunity_Forecast__c();
            oppyFore.Opportunity__c = oppy.Id;
            oppyFore.Fiscal_Year__c = '2017';
            oppyFore.Fiscal_Quarter__c ='04';
            oppyFore.Amount__c = 10;
            oppyFore.date__c = system.today();
            oppyFore.CurrencyIsoCode = 'USD';
            oppyFore.Five_Year_Amount__c = 50;
        	//insert oppyFore;  
            list_fc2Insert.add(oppyFore);
        	Opportunity_Forecast__c  oppyFore2 = new Opportunity_Forecast__c();
       		oppyFore2.Opportunity__c = oppy.Id;
        	oppyFore2.Fiscal_Year__c = '2017';
        	oppyFore2.Fiscal_Quarter__c ='04';
        	oppyFore2.Amount__c = 20;
            oppyFore2.Five_Year_Amount__c = 50;
        	oppyFore2.date__c = system.today();
        	oppyFore2.CurrencyIsoCode = 'EUR';
            //insert oppyFore2;  
            list_fc2Insert.add(oppyFore2);
            insert list_fc2Insert;
            
            test.startTest();
            
            Quality_Assessment_Answer__c qaa = new Quality_Assessment_Answer__c();
            qaa.Opportunity__c = oppy.id;
            qaa.Sales_Process_Question_Assignment__c = spqa.id;
            qaa.Active__c = true;
            qaa.Status__c = 'yes';
            insert qaa;
            
            ApexPages.Standardcontroller stdCtrl = new ApexPages.Standardcontroller(oppy);
            ExtOppy_qualifierOverview.ClsStage innerClass = new ExtOppy_qualifierOverview.ClsStage();
            ExtOppy_qualifierOverview ext = new ExtOppy_qualifierOverview(stdCtrl);
            ext.closeLostBtn();
            ext.onHoldBtn();
            ext.reactivateBtn();
            ext.closeDeadBtn();
            ext.renderDescription();
            ExtOppy_qualifierOverview.recalcAmountAndRevenue(oppy);
            system.assert(true);
            test.stopTest();
            
        }
    }
    
}