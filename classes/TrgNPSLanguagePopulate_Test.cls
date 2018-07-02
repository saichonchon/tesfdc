/**
*  This test class used to test class ExtRecalculateBudget.
*
@author Lili Zhao
@created 2014-10-10
@version 1.0   
@since 28.0
*
@changelog
* coverage 100% 
* 
* 
2014-10-10 Lili Zhao <lili.zhao@itbconsult.com>
* - Created
*/
@isTest(seeAllData = true)
private class TrgNPSLanguagePopulate_Test {

    static testMethod void myUnitTest() {
        Account acc = ClsTestHelp.createTestAccounts();
        acc.Industry_Code_Description__c = 'A&C';
        acc.LEVEL_1_INDUSTRY_CDE__c = '0108';
        acc.Account_Manager__c = UserInfo.getUserId();
        insert acc;        
                
        list<NPS_Templates_All_Languages__c> list_nps = new list<NPS_Templates_All_Languages__c>();
        
        for(NPS_Templates_All_Languages__c nps : [select id,Language__c,NPS_Invitation_1__c,NPS_Invitation_2__c,NPS_Invitation_3__c,
                                                    NPS_Invitation_3_2__c,NPS_Invitation_4__c,NPS_Invitation_5__c,NPS_Invitation_6__c,NPS_Invitation_7__c,NPS_Invitation_8__c,
                                                    NPS_Salutation__c,NPS_Salutation_2__c,NPS_Subjects__c from NPS_Templates_All_Languages__c]){
            list_nps.add(nps);
        }
        if(list_nps.isEmpty()){
            NPS_Templates_All_Languages__c nps = new NPS_Templates_All_Languages__c();
            nps.Name = 'CN';
            nps.Language__c = 'CN';
            nps.NPS_Invitation_1__c = '為客戶提供絕佳的體驗對 TE Connectivity 來說非常重要，我們也一直努力在這方面做到最好。';
            nps.NPS_Invitation_2__c = '因此，我們對各位最重要的客戶進行一系列的意見調查，以追蹤瞭解我們的服務表現並視需要作出改善。';
            nps.NPS_Invitation_3__c = '我們藉由這封郵件，邀請您參與這項意見調查並分享您對 TE Connectivity 的意見與看法。';
            nps.NPS_Invitation_3_2__c = '由於您有數個與 TE Connectivity 聯絡的窗口，我們特別挑選您參加這項自願性的意見調查，這次是您為我們提供真實建言的獨特機會。';
            nps.NPS_Invitation_4__c = '本意見調查應該在 5 分鐘內就能完成。請點選以下其中一個連結或將該連結貼至瀏覽器中：';
            nps.NPS_Invitation_5__c = '由於我們希望準確地掌握本公司的概觀，因此請如實說出您的觀點及意見。';
            nps.NPS_Invitation_6__c = '在某些情況下，我們可能需要在完成意見調查後與您聯絡，以確保完全瞭解您對某些問題的回答和意見。';
            nps.NPS_Invitation_7__c = '如果您想取消訂閱 TE NPS 意見調查，請點選以下的連結以設定 "Opt Out" (退出) 旗標。';
            nps.NPS_Invitation_8__c = '請不要回复此郵件。';
            nps.NPS_Salutation__c = '親愛的';
            nps.NPS_Salutation_2__c = '';
            nps.NPS_Subjects__c = '請參與我們的 TE Connectivity 客戶調查';
            list_nps.add(nps);
            
            insert list_nps;
        }
        
        Test.startTest(); 
        Contact con = new Contact();
        con.AccountId = acc.Id;
        //con.NPS_Language__c = 'DE';
        con.Email = 'sdf@dsafj.com';
        con.LastName = 'Sand';
        con.OwnerId = UserInfo.getUserId();
        con.MailingCity = 'Musterstadt';
        con.MailingStreet = 'Teststr. 1';
        con.MailingCountry = 'Germany';
        con.MailingPostalCode = '77777';
        con.Salutation = 'Mr.';
        con.Phone = '12365478';
        con.NPS_Language__c = 'CN';
        //con.NPS_Result_Report__c = 'test';
        insert con;

        Test.stopTest();
        
        
    }
}