/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seeAllData=true) 
private class BatchCls_recalculatePMVOppyInfo_Test {
	
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    	
	    User u = [select Id, Name, Sub_Vertical__c, GIBU__c from User where Id = :UserInfo.getUserId() limit 1];
        u.GIBU__c = 'Industrial';
        u.Sub_Vertical__c = 'A&C';
        update u;
        system.runAs(u){
        	
        	RecordType rt = [SELECT Name, Id,BusinessProcessId FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'IND_Engineering_project'];
        	
        	Opportunity oppy = ClsTestHelp.createTestOpportunity();
	        oppy.Type = 'CM';
	        oppy.RecordTypeId = rt.Id;
	        oppy.Approval_Status_PMV__c = 'New';
	        oppy.PMV_Type__c = 'IND Standard ENG opp';
	        oppy.StageName = 'Contracting';
	        oppy.PMV_Migration_Setup__c = 'OnHold';
	        oppy.Name = 'testjinbote';
	        insert oppy;
	        
	        List<Opportunity> list_oppys = new List<Opportunity>();
	        list_oppys.add(oppy);
			Test.startTest();
			BatchCls_recalculatePMVOppyInfo batchCls = new BatchCls_recalculatePMVOppyInfo();
			
	        Database.BatchableContext bc;
	        //batchCls.start(bc);
	        batchCls.execute(bc, list_oppys);
	        batchCls.finish(bc);
	        Test.stopTest();
        }
    }
}