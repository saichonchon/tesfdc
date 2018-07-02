@isTest(seealldata=true)
Private class LeadConversionUtil_Test {
    static testMethod void testLeadConversionUtil() {
        // 2015-09-25 Phil Hiemstra - Removed because connections are disabled
        //List<PartnerNetworkRecordConnection> lstcon =[Select Id, ConnectionId from PartnerNetworkRecordConnection limit 1];
        //system.debug('@@lstcon' + lstcon);
        //insert new TE_Connection__c(Name='CentralOrg',Source_BU__c='test',Id_value__c=lstcon[0].ConnectionId);
        
        Lead led = new Lead();
        led.LastName= 'Test Lead';
        led.Company = 'Test Company';
        led.Status ='Passed to Distributor';
         led.Communities_Distributor__c ='Future Electronics';
         led.Phone= '23456';
         led.FirstName ='Test';
         led.Email = 'test.test@ymail.com';
         led.OwnerId = Userinfo.getUserId();
        //insert led;
        
        test.startTest();
        
        LeadConversionUtil.buildLeadConversionMap(new List<Lead>{led});
        
        test.stopTest();
    }

}