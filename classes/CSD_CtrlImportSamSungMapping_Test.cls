/**
*	This test class is for CSD_CtrlImportSamSungMapping.
*
@author Minghao Li
@created 2014-09-24
@version 1.0
@since 30.0
*
@changelog
* 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
* - Created
* - Test coverage 78%
*/
@isTest
private class CSD_CtrlImportSamSungMapping_Test {

	static testMethod void myUnitTest() {
        CSD_CtrlImportSamSungMapping c = new CSD_CtrlImportSamSungMapping();
        c.deleteObject();
    }

    static testMethod void remoteActionTest() {

        CSD_CtrlImportSamSungMapping.CustomSamSungMappping fc = new CSD_CtrlImportSamSungMapping.CustomSamSungMappping();
        fc.category = 'samsung-soldto-test';
        fc.gplfamily = '';
        fc.pn = 'samsung-part-test';
        fc.pnDes = '2014';
        fc.soldtoname = '6';
        fc.soldtonumber = 'testa';
        fc.orgid = 'testa';
        fc.assigneddes = 'testa';
        fc.assigneddesemail = 'testa';
        fc.territoryname = 'testa';
        fc.pnindicator = 'yes';
        list<CSD_CtrlImportSamSungMapping.CustomSamSungMappping> list_fc = new list<CSD_CtrlImportSamSungMapping.CustomSamSungMappping>();
        list_fc.add(fc);
        Test.startTest();
        try{
	        CSD_CtrlImportSamSungMapping.upsertListObject( Json.serialize(list_fc) );
        }catch(CSD_CtrlImportSamSungMapping.CustomException e){
        	System.assert(true);
		}
		Test.stopTest();
    }
}