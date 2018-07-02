/**
   This test class is used to test APL_CtrlSearchForecastBilling
 *  
 * @author Mingxing Qiu
 * @created 2016-06-22
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 **/
@isTest
private class APL_CtrlSearchForecastBilling_Test {

    static testMethod void myUnitTest() {
        
        User user;
        User user2;
        for(User tempuser : [SELECT Id, GIBU__c, Profile.Name FROM User where ((Profile.Name = 'Appliance Standard User' and GIBU__c = 'Appliances') or Profile.name = 'System Administrator') and IsActive = true ]) {
            if(user == null && tempuser.Profile.Name == 'Appliance Standard User' && tempuser.GIBU__c == 'Appliances') {
                user = tempuser;
            }
            if(user2 == null && tempuser.Profile.Name == 'System Administrator') {
                user2 = tempuser;
            }
            if(user != null && user2 != null) {
                break;
            }
        }
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        /*if (Type.forName('Channelinsight__CI_Configuration__c') != null) {
            Channelinsight__CI_Configuration__c c = new Channelinsight__CI_Configuration__c();
            c.Name = 'Default';
            c.Channelinsight__CONF_Stop_Matching_POS_to_Opportunity__c = 'Opportunity Is Closed';
            c.Channelinsight__CONF_Salesforce_Environment__c = 'Sandbox';
            c.Channelinsight__CONF_Reprocess_Reviewed__c = true;
            c.Channelinsight__CONF_Disable_Address_Type_Matching__c = true;  
            c.Channelinsight__CONF_Auto_mark_POS_Reviewed__c = false; 
            c.Channelinsight__CONF_Acct_Sales_Trending_Default_Address__c = 'Bill-to';
            insert c;
        }
         */
        test.startTest();
        system.runAs(user2) {
            list<Load_Status__c> list_loadStatus = new list<Load_Status__c>();
            list<Opportunity_Forecast__c> list_opportunityFore = new list<Opportunity_Forecast__c>();
            //custom setting 
            List<APL_Billing__c> list_APLbilling = new List<APL_Billing__c>();
            list_APLbilling.add(new APL_Billing__c (name = 'Oppy', Column_API_Names__c='Opportunity_Number__c,Name', Column_Names__c ='Opportunity Number,Opportunity Name'));
            list_APLbilling.add(new APL_Billing__c (name = 'OppyPart', Column_API_Names__c ='Part_Number__c,Won_Date__c', Column_Names__c = 'Part Number,Won Date'));
            list_APLbilling.add(new APL_Billing__c (name = 'OppyPartner', Column_API_Names__c ='Allocation__c,Partner_GAM_Code__c,Opportunity_Owner__c', Column_Names__c = 'Allocation,GAM Code,Opp Owner'));
            insert list_APLbilling;
            
            Load_Status__c loadStatus = new  Load_Status__c();
            loadStatus.Data_Source_Description__c = 'Bookings/Billings direct PN detail monthly';
            loadStatus.Current_Fiscal_Month__c = 5;
            list_loadStatus.add(loadStatus);
            
             Load_Status__c loadStatus2 = new  Load_Status__c();
            loadStatus2.Data_Source_Description__c = 'Bookings/Billings POS/CMA PN detail Monthly';
            loadStatus2.Current_Fiscal_Month__c = 6;
            list_loadStatus.add(loadStatus2);
            insert list_loadStatus;
            
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.StageName = 'Won - Closed';
            oppy.OwnerId = user.Id;
            oppy.Name = 'testXing';
            oppy.Probability = 50;
            insert oppy;
            
            
            Opportunity_Part__c oppyPart = new Opportunity_Part__c();
            oppyPart.Opportunity__c = oppy.Id;
            oppyPart.Status__c = 'Won';
            oppyPart.Process_Status__c = 'Production';
            oppyPart.Won_Fiscal_Year__c = '2016';
            oppyPart.Initial_12_months__c = 12;
            insert oppyPart;
            
            
            Opportunity_Forecast__c  oppyFore = new Opportunity_Forecast__c();
            oppyFore.Opportunity__c = oppy.Id;
            oppyFore.part__c = oppyPart.Id;
            oppyFore.Fiscal_Year__c = '2016';
            oppyFore.Fiscal_Quarter__c ='01';
            oppyFore.Amount__c = 10;
            list_opportunityFore.add(oppyFore);
            
            
            Opportunity_Forecast__c  oppyFore2 = new Opportunity_Forecast__c();
            oppyFore2.Opportunity__c = oppy.Id;
            oppyFore2.part__c = oppyPart.Id;
            oppyFore2.Fiscal_Year__c = '2016';
            oppyFore2.Fiscal_Quarter__c ='02';
            oppyFore2.Amount__c = 20;
             list_opportunityFore.add(oppyFore2);
            
            
            Opportunity_Forecast__c  oppyFore3 = new Opportunity_Forecast__c();
            oppyFore3.Opportunity__c = oppy.Id;
            oppyFore3.part__c = oppyPart.Id;
            oppyFore3.Fiscal_Year__c = '2016';
            oppyFore3.Fiscal_Quarter__c ='03';
            oppyFore3.Amount__c = 30;
            list_opportunityFore.add(oppyFore3);
            
            
            Opportunity_Forecast__c  oppyFore4 = new Opportunity_Forecast__c();
            oppyFore4.Opportunity__c = oppy.Id;
            oppyFore4.part__c = oppyPart.Id;
            oppyFore4.Fiscal_Year__c = '2016';
            oppyFore4.Fiscal_Quarter__c ='04';
            oppyFore4.Amount__c = 40;
             list_opportunityFore.add(oppyFore4);
            insert list_opportunityFore;
     
            APL_CtrlSearchForecastBilling apl_ctrlBill = new APL_CtrlSearchForecastBilling();
            APL_CtrlSearchForecastBilling.befYear = true;
            APL_CtrlSearchForecastBilling.fisYear = true;
            APL_CtrlSearchForecastBilling.nextYear = true;
            APL_CtrlSearchForecastBilling.dirBillMonth = 0;
            APL_CtrlSearchForecastBilling.PosBillMonth = 0;
            APL_CtrlSearchForecastBilling.thousandSep = '';
            APL_CtrlSearchForecastBilling.fiscalYear = 2016;
            
            list<APL_CtrlSearchForecastBilling.paramlFilter> list_innerClass = new list<APL_CtrlSearchForecastBilling.paramlFilter>();
            APL_CtrlSearchForecastBilling.paramlFilter paramlFilter = new  APL_CtrlSearchForecastBilling.paramlFilter();
            paramlFilter.objectName='Opportunity_Part__c';
            paramlFilter.queryString = 'Won_Date__c = THIS_FISCAL_YEAR';
            list_innerClass.add(paramlFilter);
          
            String Json_set_oppyIds = '[]';
            APL_CtrlSearchForecastBilling.doSearch(list_innerClass,Json_set_oppyIds);
            
            String Json_set_oppyIds2 = '["'+oppy.Id+'"]';
            String choosePartOrPartner = 'opportunity_part__c,opportunity_partner__c';
            String choosePartOrPartner2 = 'opportunity_part__c';
            String choosePartOrPartner3 = 'opportunity_partner__c';
            APL_CtrlSearchForecastBilling.doSearch(list_innerClass,Json_set_oppyIds2);
            APL_CtrlSearchForecastBilling.searchPartAndPartner(list_innerClass,Json_set_oppyIds2,choosePartOrPartner2);
            APL_CtrlSearchForecastBilling.searchPartAndPartner(list_innerClass,Json_set_oppyIds2,choosePartOrPartner); 
            APL_CtrlSearchForecastBilling.searchPartAndPartner(list_innerClass,Json_set_oppyIds2,choosePartOrPartner3);  
            test.stopTest();
        }
    }
}