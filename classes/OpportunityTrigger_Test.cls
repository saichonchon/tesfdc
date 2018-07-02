/**
*   This test class covers 
    Trigger :OpportunityTrigger(100%) 
    Classes: OpportunityTriggerHandler(100%), OpportunitytriggerUtils(81%) 
*   Case 00900679.
*
@  author Rajendra Shahane
@  created 2016-02-01
*
*/
@istest(seeAlldata=false)
public class OpportunityTrigger_Test
{
    public static testMethod void TestOpportunitySpanningRelationship()
    {
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        Id EngCSDRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Engineering Opportunity-CSD').getRecordTypeId();
        Id NDROppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('NDR Opportunity').getRecordTypeId();
        Apex_Helper_Settings__c ah =new Apex_Helper_Settings__c(name='Exclude Oppy Revenue Phase',value__c='Dead,Lost,Dead - Closed,Lost - Closed',active__c=true);
        insert ah;
        
        test.startTest();
        
        Opportunity oppy = new Opportunity(CCAO_Manager__c = userinfo.getUserId(),Global_Product_Manager__c = userinfo.getUserId(),CloseDate = date.today().addDays(5), recordtypeid = EngCSDRecordTypeId, name = 'Opportunity Spanning Relationship1', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        Opportunity oppy1 = new Opportunity(CloseDate = date.today().addDays(5), recordtypeid = NDROppRecordTypeId, name = 'Opportunity Spanning Relationship2', StageName = 'New', Type = 'CM', Request_Type__c = 'Extension', Method__c = 'BOM', Level__c = 'Yearly', Amount = 1, Five_Year_Revenue__c = 1, Currency_Confirm__c = true);
        insert new List<Opportunity> {oppy, oppy1};
        
        oppy.Opportunity_Champion__c = null;
        oppy1.NDR_Owner_Manager_Email_Address__c = null;
        update new List<Opportunity> {oppy, oppy1};   
        
        oppy.CCAO_Manager_Alias__c = null;
        oppy.CreatedBy_ProfileId__c = null;
        oppy.Owner_Manager_Email__c = null;
        oppy.Global_Product_Manager__c = null;        
        update oppy;
        
        test.stopTest();
    }
}