/**
 *  Test class for ClsSPINCustomSettingUtil
 *
 @author Lei Tang
 @created 2014-05-05
 @version 1.0
 @since 29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-05-05 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 * - coverate 100%
 */
@isTest
private class CompMultiPickList_Test {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Test.startTest();
        
        CompMultiPickList comp = new CompMultiPickList();
        List<Selectoption> sele = new List<Selectoption>();
        List<Selectoption> unsele = new List<Selectoption>();
        
        sele.add(new Selectoption('test1','test1'));
        sele.add(new Selectoption('test2','test2'));
        
        unsele.add(new Selectoption('test3','test2'));
        unsele.add(new Selectoption('test3','test2'));
        
        comp.selectedFields = sele;
        comp.unSelectedFields = unsele;
        
        comp.inputHiddenId = 'hiddenTestId';
        comp.separator = ',';
        
        comp.getSelectedListId();
        comp.getUnSelectedListId();
        comp.getSelectedList();
        comp.getUnSelectedList();
        
        
        Test.stopTest();   
    }
}