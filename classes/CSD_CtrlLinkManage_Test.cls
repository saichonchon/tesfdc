/**
*	This test class is for CSD_CtrlLinkManage.
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
private class CSD_CtrlLinkManage_Test {

    static testMethod void myUnitTest() {
        CSD_CtrlLinkManage link = new CSD_CtrlLinkManage();
        CSD_CtrlLinkManage.PageLink pageLink = new CSD_CtrlLinkManage.PageLink('label', 'title', 'url', 'description');
    }
}