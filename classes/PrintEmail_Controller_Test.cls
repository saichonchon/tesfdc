/************************************************************************************************************************************************************************************************************************************************
Name: PrintEmail_Controller_Test
Copyright © 2014 TE Connectivity | Salesforce Instance : C2S Org
=================================================================================================================================================================================================================================================
   Summary : Summary : This class contain positive behavioral test methods and negative behavioral test methods for 'PrintEmail_Controller_Test'
_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
 Apex class whose code is covered : PrintEmail_Controller
=================================================================================================================================================================================================================================================
 Code Coverage History:                                                        
_________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
VERSION               AUTHOR                    DATE              DETAIL                           
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 1.0               Ramakrishna Singara         10/03/2014        Test Class        
 1.1			   Rajendra Shahane			   11/04/2016
*************************************************************************************************************************************************************************************************************************************************/

@IsTest(Seealldata=false)
private class PrintEmail_Controller_Test{
    public static testMethod void OutOfOfficeTest(){
    
        test.startTest();
        
        MilestoneType vMlType = [Select id,name from MilestoneType where name =:'4 Hour Response Time'];
        //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        /*Apex_Helper_Settings__c QueueType = new Apex_Helper_Settings__c();
        QueueType.Name = '4 Hour Response Time';
        QueueType.Active__c = true;
        QueueType.Description__c = 'This value caontains the id of a 4 Hour Response Time milestone type';
        QueueType.Value__c = vMlType.id;
        insert QueueType;*/
		//End: Rajendra Shahane 04/11/2016  Modified for case - 900786
		        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        //Start : Rajendra Shahane 04/11/2016  Modified for case - 900786
        Apex_Helper_Settings__c QueueType = Apex_Helper_Settings__c.getinstance('4 Hour Response Time');
        QueueType.Value__c = vMlType.id;
        update QueueType;
        //End: Rajendra Shahane 04/11/2016  Modified for case - 900786
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.Case; 
        Map<String,Schema.RecordTypeInfo> CaseRecordTypeInfo = cfrSchema.getRecordTypeInfosByName(); 
        Id CaseId = CaseRecordTypeInfo.get('Customer Care Cloud').getRecordTypeId();
        
        Case vCs = new Case();
        vCs.Origin = 'Email';
        vCs.Inquiry_Type__c = 'Cancellation';
        vCs.Status= 'In Progress';
        vCs.Description = 'Test Description';            
        vCs.recordtypeid = CaseId;
        vCs.ownerId = UserInfo.getUserId();
        insert vCs;
        
        EmailMessage vEMS = new EmailMessage();
        vEMS.parentid = vCs.id;
        vEMS.FromAddress = UserInfo.getUserEmail();
        vEMS.FromName = 'Test Zensar';
        vEMS.incoming = true;
        vEMS.messagedate = System.today()+1; 
        vEMS.subject = 'Test';
        vEMS.textbody = 'Test';
        vEMS.toaddress = 'test@zensar.in';
        insert vEMS;
        PageReference page = new PageReference('/apex/Print_Email_VF'); 
        Test.setCurrentPageReference(page);
        ApexPages.currentPage().getParameters().put('id',vEMS.id);        
        ApexPages.StandardController stdCase = new ApexPages.standardController(vEMS);
        PrintEmail_Controller pdfCon = new PrintEmail_Controller(stdCase);
        test.StopTest();
    }
}