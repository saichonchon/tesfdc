/**
*  This class is used as test class for clsBatch_NextSurveyFollupCallReminder 
*
@author Pankaj Raijade
@created 1/2/2016
@changelog
Rajendra Shahane 03/29/2016  Modified for case - 900703
*/
@istest(seeAllData=false)
public class clsBatch_NextSurveyFollupCallRem_Test
{
    public static testmethod void clsBatch_NextSurveyFollupCallRem_UT()
    {
    	 //Start: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getCCPTriggerSettings();
        //End: Rajendra Shahane Modified for case - 900703
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();
        
        
        Account oAccount = ClsTestHelp.createTestAccounts();
        oAccount.Name = 'axx';
        insert oAccount;
        
        Date DateStart = system.Today().addMonths(-5);
        Integer nextWaveNumber = system.date.today().Month() + 1;
        if(nextWaveNumber == 13)
            nextWaveNumber = 1;

        Contact oContact = new Contact(lastname = 'test', NPS_Survey_Wave_Number__c = nextWaveNumber, NPS_OPT_OUT__c = false, Accountid = oAccount.id);        
        Insert oContact;
        
        Insert new Task(subject = system.label.NPS_Detractor_GM_Follow_UP, ActivityDate = date.today(), whoid = oContact.id); 
        clsBatch_NextSurveyFollupCallReminder o = new clsBatch_NextSurveyFollupCallReminder();
        
        test.starttest();
            database.executeBatch(o);
        test.stoptest();
    }
}