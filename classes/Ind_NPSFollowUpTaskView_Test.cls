/**
*  This used as test class for Ind_NPSFollowUpTaskView.
*
@author Pankaj Raijade
@created 1/2/2016

@changelog

*/
@istest(seeAllData=false)
public class Ind_NPSFollowUpTaskView_Test
{
    public static testmethod void Ind_NPSFollowUpTaskView_UT()
    {
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        task oTask = new task(subject = 'test');
        insert oTask;
        ApexPages.StandardController stdController = new ApexPages.StandardController(oTask);
        Ind_NPSFollowUpTaskView o = new Ind_NPSFollowUpTaskView(stdController);
    }
}