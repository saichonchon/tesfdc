/**************************************************************************************************************************************************
Name:  OEMDetailclsTest
Copyright © 2013 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for OEMDetailcls
---------------------------------------------------------------------------------------------------------------------------------------------------       
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Padmaja Dadi     15/01/2014 Initial Development            
**************************************************************************************************************************************************/
/* changed the accounts name manually to control duplication
    2014-09-18 Harinath Chittala <harinath.chittala@te.com> */  

@istest(SeeAllData=true)
public class OEMDetailclsTest{
/*public static testmethod void method1()
{
    Schema.DescribeSObjectResult cfrAccSchema = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrAccSchema.getRecordTypeInfosByName(); 
    Id CSDAccountrtId = AccountRecordTypeInfo.get('Account').getRecordTypeId();
    Id CSDOEMrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();
    
    Account acc = new Account();
    acc.RecordTypeId = CSDAccountrtId;
    acc.Name = 'Test';
    acc.ownerId = UserInfo.getUserId(); 
    acc.Account_Manager__c = UserInfo.getUserId();
    insert acc;
    
    Account acc1 = new Account();
    acc1.RecordTypeId = CSDAccountrtId;
    acc1.Active__c = true;
    acc1.Name = 'Test1';
    acc1.ownerId = UserInfo.getUserId(); 
    acc1.Account_Manager__c = UserInfo.getUserId();
    insert acc1;
      
    OEMDetailcls controller=new OEMDetailcls();
    
    controller.fiscalyear=string.valueof(System.today().year());
    if(controller.mon==string.valueof(System.today().month()))
    {
    
    OEM_Details__c oem1 = new OEM_Details__c();
    oem1.OEM__c = acc1.id;
    oem1.Cutoff_Date__c=string.valueof((system.today()+100).day());
        try{
    controller.saveoemdetail(); 
    controller.canceloemdetail(); 
        }catch(Exception e){}
    }
}*/

public static testmethod void method2(){
    Schema.DescribeSObjectResult cfrAccSchema = Schema.SObjectType.Account; 
    Map<String,Schema.RecordTypeInfo> AccountRecordTypeInfo = cfrAccSchema.getRecordTypeInfosByName(); 
    Id CSDAccountrtId = AccountRecordTypeInfo.get('Account').getRecordTypeId();
    Id CSDOEMrtId = AccountRecordTypeInfo.get('OEM').getRecordTypeId();

    Account acc = new Account();
   // acc.RecordTypeId = CSDAccountrtId;
    acc.Name = 'Test1';
    acc.ownerId = UserInfo.getUserId(); 
    acc.Account_Manager__c = UserInfo.getUserId();
    acc.BillingCountry='us';
    insert acc;
    
    Account acc1 = new Account();
    acc1.RecordTypeId = CSDAccountrtId;
    acc1.Active__c = true;
    acc1.Name = 'Test2';
    acc1.ownerId = UserInfo.getUserId(); 
    acc1.Account_Manager__c = UserInfo.getUserId();
    insert acc1;
    OEMDetailcls controller=new OEMDetailcls();
    
    controller.fiscalyear=string.valueof(System.today().year());
    controller.mon='3';
    if(controller.mon == '1'){
    controller.ErrorMessage='dfhgfhdefb';
    controller.idval=acc.id;
    
    OEM_Details__c oem1 = new OEM_Details__c(OEM__c=controller.idval);
    //oem1.OEM__c = acc1.id;
    oem1.Cutoff_Date__c=string.valueof((system.today()+100).day());
    
   // oem1.Fiscal_Month__c = '11';
   // oem1.Fiscal_Year__c = '2014';
    //insert oem1;
        controller.oemdetails=oem1;
        test.startTest();

  
    controller.saveoemdetail();
        
    
    controller.canceloemdetail(); 
        test.stopTest();
    }
    
if(controller.mon == '2'){

    OEM_Details__c oem1 = new OEM_Details__c(OEM__c=acc.id);
    controller.oemdetails=oem1;
    controller.DisplayMessage=false;
    controller.ErrorMessage='dfhgfhdefb';
    controller.idval=acc.id;
    test.startTest();

    
controller.saveoemdetail(); 
    
    controller.canceloemdetail();
    test.stopTest();
}    
if(controller.mon == '3'){
    OEM_Details__c oem1 = new OEM_Details__c();
    controller.oemdetails=oem1;
    controller.DisplayMessage=true;
    controller.idval=acc.id;
    test.startTest();
    controller.saveoemdetail(); 
    controller.canceloemdetail(); 
    test.stopTest();
} 
} 
}