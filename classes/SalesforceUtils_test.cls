@istest(seeAllData=false)
public class SalesforceUtils_test
{
    static testmethod void SalesforceUtils_TM()
    {
        test.startTest();
        SalesforceUtils.IsNullOrEmpty('test');
        SalesforceUtils.ReplaceNullStringWithEmpty('test');
        try{
            OrgWideSettings__c OrgSett  = SalesforceUtils.OrgSettings;
            SalesforceUtils.SendEmail('test@test.com', 'test', 'test');
        }catch(exception ex){}
        try{
        SalesforceUtils.SendEmail(new list<string>{'test@test.com'}, new list<String>(), new list<String>{'test@test.com'}, 'Subject', 'pSenderDisplayName', 'test@test.com', 'pBody');
        }catch(exception ex){}
        test.stopTest();
    }
}