/**
 *  This test class is used to test APL_Interface
 *  
 * @author Jasmine Ver
 * @created 2016-04-08
 * @since 36.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2016-04-08 Jasmine Ver <jasmine.ver@te.com>
 * - Created
 *
 */
 @isTest
private class APL_Interface_Test{
    static testMethod void test1(){
        Test.startTest();
        
        //Instantiate Dummy extention, which does not override any methods from abstract AAPLCtrlService interface
        APL_InterfaceDummyExtension aide = new APL_InterfaceDummyExtension();
        
        //Create parameters
        list<APL_ClsEntityType.APLColumn> list_acctColumns = new list<APL_ClsEntityType.APLColumn>();
        list<APL_ClsEntityType.DateItem> list_allDateItems = new list<APL_ClsEntityType.DateItem>();
        APL_ClsEntityType.PageConfig PageConf = new APL_ClsEntityType.PageConfig();
        
        //run default interface versions of all classes in AAPLCtrlService 
        aide.setPopUPBoxColumnLevel1(list_acctColumns);
        aide.setPopUPBoxColumnLevel2(list_acctColumns);
        aide.setPopUPBoxColumnLevel3(list_acctColumns);
        
        aide.setLevel1Data(list_acctColumns, PageConf);
        aide.setGroupForecast(list_acctColumns, PageConf);
        aide.setOverRelayProductsForecast(list_acctColumns, PageConf);
        
        aide.setTotalRow(list_acctColumns, PageConf);
        
        aide.setLevel1Row(list_acctColumns);
        aide.setLevel2Row(list_acctColumns);
        aide.setLevel3Row(list_acctColumns);
        aide.setLevel4Row(list_acctColumns);
        aide.setLevel5Row(list_acctColumns);
        
        aide.setPageConf(PageConf);
        
        aide.setAllDateItems(PageConf, list_allDateItems );
        
        Test.stopTest();

    }
}