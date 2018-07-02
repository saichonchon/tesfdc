@isTest
public class AccountBTerritoryUtil_Test {
  
    /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : B Territory logic Test                                                                        |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/  
     public static testMethod void accountBTerritoryLogicTest(){
     /*-- 1.0 Collection variable declaration -----------------------------------------*/  
      List<Account> vLstAccounttest;
      List<Sales_Hierarchy__c> vLstSalesHier;
      /*-- 1.1 Object variable declaration ---------------------------------------------*/  
      Account vAccounttest;
      Sales_Hierarchy__c vSalesHier,vSalesHier1;
	  
	  vLstSalesHier                                       = new List<Sales_Hierarchy__c>();
        vSalesHier                                          = new Sales_Hierarchy__c();
        vSalesHier.Name                                     = 'A000001';       
        vSalesHier.Level_7_Territory_Code__c                = 'A000001';
        vSalesHier.Level_7_Assigned_User_Network_Ids__c     = 'TE161266;CAN01506';
        vSalesHier.Level_1_Territory_Name__c = 'Worldwide Aero, Def & Mari';
         vSalesHier.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
         vSalesHier.Level_7_Default_Owner__c  = Userinfo.getUserId();
         vLstSalesHier.add(vSalesHier);
       // insert vSalesHier;
          
        
        vSalesHier1                                          = new Sales_Hierarchy__c();
        vSalesHier1.Name                                     = 'A000002';       
        vSalesHier1.Level_7_Territory_Code__c                = 'A000002';
        vSalesHier1.Level_7_Assigned_User_Network_Ids__c     = 'US081580;US030518';
        vSalesHier1.Level_1_Territory_Name__c = 'Worldwide Aero, Def & Mari';
         vSalesHier1.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
         vSalesHier1.Level_7_Default_Owner__c  = Userinfo.getUserId();
        vLstSalesHier.add(vSalesHier1);
        
        insert vLstSalesHier;
       
         //Adding helper custom settings
         ClsTestHelp.initAPLTestData();
         
         //creating Worldwide_Aero_Def_Mari__c 
         insert new Worldwide_Aero_Def_Mari__c(ADM_BU_Name__c ='Worldwide Aero, Def & Mari');
         
         System.debug('**vSalesHier**' +vSalesHier);      
      
        vAccounttest                        = ClsTestHelp.createTestAccounts();
        vAccounttest.Name                   = 'XXXXX';
        vAccounttest.Type                    ='Account';
        vAccounttest.SALES_TERRITORY_CDE__c = 'A007739';
        vAccounttest.Industry_Code_Description__c ='Worldwide Aero, Def & Mari';
        vAccounttest.B_Territory_Codes__c   = 'A000001';
        vAccounttest.Site                   = '1009:0283490200';
		vAccounttest.Sales_Hierarchy__c = vSalesHier.id;
		insert vAccounttest;
         System.debug('vAccounttest =====' +vAccounttest);
           
		vAccounttest.B_Territory_Codes__c ='A000002'; //Updating the B Territory Code.
        update vAccounttest;
       }
         static testMethod void testEnhancement() {
             Test.startTest();
                        
             Id rt_cis_gam = ClsSharingUtil.gamCustomSetting();
             Id rt_cis_account = ClsSharingUtil.accountCustomSetting();
             Sales_Hierarchy__c salesHir = NEW Sales_Hierarchy__c();
             salesHir.Name  = 'A000001';       
             salesHir.Level_7_Territory_Code__c = 'A000001';
             salesHir.Level_7_Assigned_User_Network_Ids__c = 'TE161266;CAN01506';
             salesHir.Level_1_Territory_Name__c = 'Worldwide Aero, Def & Mari';
             salesHir.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
             salesHir.Level_7_Default_Owner__c  = Userinfo.getUserId();
             //salesHir.Level_7_Territory_Code__c = 'A00000';
             insert salesHir;
             System.debug('salesHir ++++ '+salesHir);

          
             ClsTestHelp.initAPLTestData();
             User U1 = ClsTestHelp.createTestUsers();
             insert U1;
             

             RecordType rt1 = ClsTestHelp.createTestRecordType();
             //Account acc1 = ClsTestHelp.createTestAccounts();
             Account acc1 = NEW Account();
             acc1.RecordTypeId = rt1.Id;
             acc1.Name = 'test 2';
             acc1.Type = 'Global Account';
             acc1.GAMCD__c = 'A000001';
             acc1.Account_Manager__c = U1.Id;   
             acc1.Industry_Code_Description__c ='Worldwide Aero, Def & Mari';           
             acc1.Sales_Hierarchy_GAM__c = salesHir.Id;  
             
             insert acc1;      
             System.debug('Acount Manager before update ' + acc1.Account_Manager__c);
             
             acc1.Account_Manager__c = Userinfo.getUserId(); 
             acc1.Name = 'Rahul';
             System.debug('****** Acc1'+acc1.Account_Manager__c);
             update acc1;             
             System.debug('****** Acc1 no');            
           //  delete acc1;
             Test.stopTest();
         }		
    
    static testMethod void testEnhancement2() {
             Test.startTest();
             Id rt_cis_account = ClsSharingUtil.accountCustomSetting();
             Sales_Hierarchy__c salesHir2 = NEW Sales_Hierarchy__c();
             salesHir2.Name  = 'A000001';       
             //salesHir2.Level_7_Territory_Code__c = 'A000001';
             salesHir2.Level_7_Assigned_User_Network_Ids__c = 'TE161266;CAN01506';
             salesHir2.Level_1_Territory_Name__c = 'Worldwide Aero, Def & Mari';
            // salesHir.Hierarchy_Type__c = 'Sales Hierarchy (AM)';
             salesHir2.Level_7_Default_Owner__c  = Userinfo.getUserId();
             salesHir2.Level_7_Territory_Code__c = 'K2345';
             insert salesHir2;
             System.debug('salesHir2 ++++ '+salesHir2);
             
             Id rt_cis_gam = ClsSharingUtil.gamCustomSetting();
             RecordType rt1 = ClsTestHelp.createTestRecordType();
             Account acc2 = ClsTestHelp.createTestAccounts();
        	 ClsTestHelp.initAPLTestData();
             acc2.RecordTypeId = rt1.Id;
             acc2.Name = 'test 2';
             acc2.Type = 'Grouped B';
             acc2.IND_KAM_Code__c = 'K2345';
             acc2.Sales_Hierarchy_MM__c = salesHir2.Id;
             
             insert acc2;
             delete acc2;
             SYstem.debug('acc2 ++++++++++++++++++++ '+acc2.Sales_Hierarchy_GAM__c);
             Test.stopTest();
         }		

    /*------------------------------------------------------------------------------------------------------------------------------------------------
 | Purpose : B Territory logic Test                                                                        |
 |   Input : None                                                                                                                                 |  
 | Returns : None                                                                                                                                 |
 ------------------------------------------------------------------------------------------------------------------------------------------------*/  
}