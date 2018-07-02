/***********************************************************************************************************************
      Name : Cls_BatchPartFlagActivationTest1
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods for classes mentioned below
________________________________________________________________________________________________________________________
 Apex class(es) whose code is covered : Cls_RefreshPartConfig, Cls_BatchPartFlagActivation, Trigger_BIAU    
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER         DATE          DETAIL                                  MERCURY REQUEST #
________________________________________________________________________________________________________________________
     1.0 Shantinath        06/26/2013    Initial Developemnt           
***********************************************************************************************************************/
@isTest(SeeAllData=false)
public class Cls_BatchPartFlagActivationTest1 {
@isTest(SeeAllData=false)
    static void validate() {


        ClsTestCustomSettingHelper.getAllSettings();
        
        Account oAccount = ClsTestHelp.createTestAccounts();
        insert oAccount;

        
        
        Opportunity oOPP = ClsTestHelp.createTestOpportunity();
        oOPP.AccountID = oAccount.Id;
        insert oOPP;
        Product_Hierarchy__c oProductHierarchy = new Product_Hierarchy__c();
        insert oProductHierarchy;
        
        Part__c oPart = new Part__c(Product_Hierarchy__c = oProductHierarchy.id);
        insert oPart;
        
        Opportunity_Part__c oOPart = ClsTestHelp.createTestOpportunityPart();
        oOpart.Part__c = oPart.Id;
        oOPart.Opportunity__c = oOPP.Id;
        insert oOPart;
        
        Part_Activation_Configuration__c vPartConfig = new Part_Activation_Configuration__c();
        vPartConfig.Cascade_Schedule__c            = TRUE;
        vPartConfig.Conditional_Query__c           = ' Opportunity__c != null ';
        vPartConfig.Cron_Statement__c              = '0 0 0 16 11 ? ' + (System.Today().year() +1); 
        vPartConfig.Current_Object_Number__c       = 7;
        vPartConfig.Execute_Trigger_Upon_Update__c = TRUE;
        vPartConfig.Max_Number_of_Objects__c       = 7;
        vPartConfig.Next_Schedule_Run_Date__c      = System.Today()-20;
        vPartConfig.Object_API_Name__c             = 'Opportunity_Part__c'; 
        vPartConfig.Object_Field_API_Name__c       = 'Part__c';
        vPartConfig.Schedule_Deactivation_Batch__c = TRUE;

        Test.StartTest();
            insert vPartConfig;
            vPartConfig.Current_Object_Number__c       = 1;
            vPartConfig.Next_Schedule_Run_Date__c      = System.Today()-19;
            update vPartConfig;
            vPartConfig.Next_Schedule_Run_Date__c      = System.Today()-18;
            vPartConfig.Current_Object_Number__c       = 7;
            update vPartConfig;
            TestRefreshPart(vPartConfig.Id);
            
        Test.StopTest();
    }
    
    public static void TestRefreshPart(Id vPartId){
        Cls_RefreshPartConfig.processDetails();
        Cls_RefreshPartConfig.deleteOldLogs(vPartId);
    }
      
    @isTest static void TestInsertTrigger() {
        Part_Activation_Configuration__c vPartConfig = new Part_Activation_Configuration__c();
        vPartConfig.Cascade_Schedule__c            = TRUE;
        vPartConfig.Conditional_Query__c           = 'LastModifiedDate = LAST_N_DAYS:70';
        vPartConfig.Cron_Statement__c              = ''; 
        vPartConfig.Current_Object_Number__c       = 1;
        vPartConfig.Execute_Trigger_Upon_Update__c = TRUE;
        vPartConfig.Max_Number_of_Objects__c       = 7;
        vPartConfig.Next_Schedule_Run_Date__c      = date.Today();
        vPartConfig.Object_API_Name__c             = 'Opportunity_Part__c'; 
        vPartConfig.Object_Field_API_Name__c       = 'Part__c';
        vPartConfig.Schedule_Deactivation_Batch__c = TRUE;
        insert vPartConfig;
    }
}