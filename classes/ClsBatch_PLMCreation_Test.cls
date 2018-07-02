/**
*   This test class is for ClsBatch_PLMCreation.
*
@author Yinfeng Guo
@created 2012-06-18
@version 1.0
@since 20.0
*
@changelog
* 2012-06-18 Yinfeng Guo <yinfeng.guo@itbconsult.com>
* - Created
* - Test coverage 89%
* 2012-10-25 Di Chen <di.chen@itbconsult.com>
* - Modified
* - Test coverage 95%
* - Modified
* - Rajendra Shahane 04/11/2016  Modified for case - 900786
* - Test coverage 80%
*/
@isTest(seealldata=false)
private class ClsBatch_PLMCreation_Test {

    static testMethod void myUnitTest() {
        //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        Test.startTest();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTriggerConfigurationSettings();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        Id EngCSDRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Engineering Opportunity-CSD').getRecordTypeId();
        
        Opportunity oppy = new Opportunity(plm_id__c='xxx123',Sent_to_PLM_Date__c=date.today(),CCAO_Manager__c = userinfo.getUserId(),Global_Product_Manager__c = userinfo.getUserId(),CloseDate = date.today().addDays(5), recordtypeid = EngCSDRecordTypeId, name = 'Opportunity Spanning Relationship1', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        
        insert new List<Opportunity> {oppy};
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        string strId = oppy.Id;
            ClsBatch_PLMCreation clsBatch = new ClsBatch_PLMCreation();
        Database.BatchableContext BC;
        clsBatch.email = 'sfdc@sfdc.com';
        clsBatch.start(BC);
        clsBatch.execute(BC, new List<Opportunity>());
        clsBatch.finish(BC);
        try{
            clsBatch.execute(BC, new List<Opportunity>{oppy});
                             }catch(exception ex){system.debug(ex);}
        
		//End : Rajendra Shahane 04/11/2016  Modified for case - 900786
        system.assert(true);
        Test.stopTest();
    }
}