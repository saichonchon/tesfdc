@istest(seeAlldata=false)
public class POSDetails_Extn_Test 
{
    public static testmethod void POSDetails_Extn_UT()
    {
         ClsTestCustomSettingHelper.getAllSettings();
        ClsTestCustomSettingHelper.getPMV_Sales_Stage_Setting();
        ChannelinsightData_test.ChannelinsightData_test();
        ClsTestCustomSettingHelper.getTrigger_Configuration();
    
        
        Account acc1 = ClsTestHelp.createTestAccounts();
        acc1.Type = 'TE Dummy Account';
        acc1.Name = 'Test Account11';
        acc1.AccountNumber = 'test11';
        acc1.Industry_Code_Description__c = 'Rail'; 
        acc1.INDUSTRY_BUSINESS_CDE__c = '113';       
        insert new list<Account>{ acc1};
            
        
        Opportunity oppy = ClsTestHelp.createTestOpportunity();
        oppy.Defined_GPLs__c = 'asdf\\|adfa'; 
        oppy.Type = 'CM';
        oppy.Request_Type__c = 'Extension';
        oppy.Method__c = 'BOM';
        oppy.Level__c = 'Yearly';
        oppy.Amount = 1;
        oppy.CurrencyIsoCode = 'EUR';
        oppy.Five_Year_Revenue__c = 1;
        //oppy.Tender__c = oppy2.Id; 
        oppy.AccountId = acc1.Id;
        oppy.Distributor__c = 'Future';
        oppy.RecordTypeId = Apex_Helper_Settings__c.getInstance('Tender Opportunity Record Type Id').Value__c;
        oppy.stagename = 'concept';
        oppy.POS_Customer_is_same_as_Account__c = true;
        insert new list<opportunity>{oppy};

        ApexPages.StandardController controller = new ApexPages.StandardController(oppy);

        ApexPages.currentPage().getParameters().put('id',oppy.id);

        POSDetails_Extn o = new POSDetails_Extn(controller);
        
    }
}