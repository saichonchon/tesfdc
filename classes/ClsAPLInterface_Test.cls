/**
*This is the test class to test ClsAPLInterface.
*
*
@author Lili Zhao
@created 2014-07-18
@version 1.0
@since 30.0
*
@changelog
* coverage  92%
*
2014-08-14 Lili Zhao<lili.zhao@itbconsult.com>
* - Created
*/
@isTest
private class ClsAPLInterface_Test {
	static testMethod void newInterface_test() {
		Test.startTest();
		ClsAPLEntityTypes.PageConfig pageConf = new ClsAPLEntityTypes.PageConfig();
		ClsAPLInterface.IAPLControllerService gamService = new ClsAPLServiceGAM();
		gamService.setPageConf(pageConf);
        gamService.setAllDateItems(pageConf, new list<ClsAPLEntityTypes.DateItem>());
		gamService.setAcctRow(new list<ClsAPLEntityTypes.AcctColumns>());
		gamService.setCBC2Row(new list<ClsAPLEntityTypes.AcctColumns>());
		gamService.setCBC2Data(new list<ClsAPLEntityTypes.Cbc2Object>());
		gamService.setGPLRow(new list<ClsAPLEntityTypes.AcctColumns>());
		gamService.setPartRow(new list<ClsAPLEntityTypes.AcctColumns>());
		gamService.setCBC2Data(new list<ClsAPLEntityTypes.Cbc2Object>());
		gamService.setRelayCBC2Data(new list<ClsAPLEntityTypes.Cbc2Object>());
		Test.stopTest();
	}
}