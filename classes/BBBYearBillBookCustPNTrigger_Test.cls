/**
 *  This test class is used to test ClsBatch_captureBillingWhenPartConv
 *  
 * @author Mingxing Qiu
 * @created 2016-05-06
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-12 Mingxing Qiu <Mingxing Qiu@itbconsult.com>
   - coverage  93%
 * - Created
 *
 */
 
@isTest
private class BBBYearBillBookCustPNTrigger_Test {

    static testMethod void myUnitTest() {
        User user;
    	User user2;
    	for(User tempuser : [SELECT Id, GIBU__c, Profile.Name FROM User where ((Profile.Name = 'Appliance Standard User' and GIBU__c = 'Appliances') or Profile.name = 'System Administrator') and IsActive = true ]) {
    		if(user == null && tempuser.Profile.Name == 'Appliance Standard User' && tempuser.GIBU__c == 'Appliances') {
    			user = tempuser;
    		}
    		if(user2 == null && tempuser.Profile.Name == 'System Administrator') {
    			user2 = tempuser;
    		}
    		if(user != null && user2 != null) {
    			break;
    		}
    	}
        
        //user user = [SELECT GIBU__c ,Profile.Name FROM User where Profile.Name = 'Appliance Standard User'and GIBU__c = 'Appliances' and IsActive = true limit 1 ];
        //user user2 = [SELECT Profile.name FROM User where Profile.name = 'System Administrator' and IsActive = true limit 1 ];
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
        ClsTestCustomSettingHelper.getProfitBUCenterMapping();
        ClsTestCustomSettingHelper.getOpportunity_Team_Default_Permission();
        Channelinsightdata_test.Channelinsightdata_test();
        /*if (Type.forName('Channelinsight__CI_Configuration__c') != null) {
            Channelinsight__CI_Configuration__c c = new Channelinsight__CI_Configuration__c();
            c.Name = 'Default';
            c.Channelinsight__CONF_Stop_Matching_POS_to_Opportunity__c = 'Opportunity Is Closed';
            c.Channelinsight__CONF_Salesforce_Environment__c = 'Sandbox';
            c.Channelinsight__CONF_Reprocess_Reviewed__c = true;
            c.Channelinsight__CONF_Disable_Address_Type_Matching__c = true;  
            c.Channelinsight__CONF_Auto_mark_POS_Reviewed__c = false; 
            c.Channelinsight__CONF_Acct_Sales_Trending_Default_Address__c = 'Bill-to';
            insert c;
   }*/
        
        test.startTest();
        system.runAs(user2) {

            //RecordType rt = [SELECT Name, Id,BusinessProcessId FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'IND_Engineering_project'];
            Sales_Hierarchy__c sh = new Sales_Hierarchy__c();
            sh.Level_1_Territory_Code__c='102260';
            sh.Level_7_Territory_Code__c='A008937';
            insert sh;
            
            Account acct = new Account();
            acct.Name  = 'testAcct';
            acct.Account_Manager__c = user2.Id;
            acct.BillingCountry = 'China';
            acct.Sales_Hierarchy__c = sh.Id;
            insert acct;
            
            RecordType rt = Clstesthelp.createPMVTestRecordType3();
            //RecordType rt = [SELECT Name, Id,BusinessProcessId FROM RecordType where SobjectType='Opportunity' and DeveloperName = 'IND_Engineering_project'];
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Type = 'CM';
            oppy.RecordTypeId = rt.Id;
            oppy.Approval_Status_PMV__c = 'New';
            oppy.PMV_Type__c = 'IND Standard ENG opp';
            oppy.StageName = 'On Hold';
            oppy.OwnerId = user.Id;
            oppy.PMV_Migration_Setup__c = 'OnHold';
            oppy.Name = 'testjinte';
            insert oppy;
            
            Product_Hierarchy__c proHieray = new Product_Hierarchy__c();
            insert proHieray;
                
            Part__c part = new Part__c();
            part.Product_Hierarchy__c  = proHieray.Id;
            insert part;
            
            Opportunity_Partner__c oppyPartner = new Opportunity_Partner__c();
            oppyPartner.Opportunity__c = oppy.Id;
            oppyPartner.Allocation__c = 100;
            oppyPartner.Account__c = acct.Id;
            //oppyPartner.isAPLOpp__c = true;
            insert oppyPartner;
            
            Opportunity_Part__c oppyPart = new Opportunity_Part__c();
            oppyPart.APL_need_to_capture_billing__c = true;
            oppyPart.APL_need_to_delete_captured_billing__c = true;
            oppyPart.Opportunity__c = oppy.Id;
            oppyPart.Initial_12_months__c = null;
            oppyPart.Part__c = part.Id;
            insert oppyPart;
            
            
            
            BBB_Year_Bill_Book_Cust_PN__c yearBBB = new BBB_Year_Bill_Book_Cust_PN__c();
            yearBBB.Customer__c = acct.Id;
            yearBBB.Part__c = part.Id;
            yearBBB.APL_need_to_capture_billing__c = false;
            //yearBBB.Territory_L1_Code__c = '102260';
            insert yearBBB;
             
            BBB_Year_Bill_Book_Cust_PN__c  bbb = [select id from BBB_Year_Bill_Book_Cust_PN__c where APL_need_to_capture_billing__c = true limit 1] ;
            
            
            
            /*APL_Sales_Split_Result__c sales = new  APL_Sales_Split_Result__c();
            sales.Yearly_Booking_Billings_By_Part__c = bbb.Id;
            sales.Part__c = part.Id;
            sales.Account__c = Acct.Id;
            insert sales;
            */
            
            APL_Billing_Result_of_Covnerted_Opp__c aplBill = new APL_Billing_Result_of_Covnerted_Opp__c ();
            aplBill.opportunity__c = oppy.Id;
            aplBill.Part__c = part.Id;
            aplBill.Opportunity_Partner__c = acct.Id;
            aplBill.Yearly_Booking_Billings_By_Part__c = yearBBB.Id;
            insert aplBill;

            delete bbb;
            
            test.stopTest();
            
        }
        
        
    }
}