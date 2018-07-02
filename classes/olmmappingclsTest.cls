/**************************************************************************************************************************************************
Name:  olmmappingclsTest
Copyright © 2013 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for olmmappingcls
---------------------------------------------------------------------------------------------------------------------------------------------------       
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Padmaja Dadi     15/01/2014 Initial Development            
**************************************************************************************************************************************************/
@isTest(seeAlldata=true)
public class olmmappingclsTest{
public static testmethod void method(){
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
    
    
    OEM_Details__c oem1 = new OEM_Details__c();
    oem1.OEM__c = acc1.id;
    oem1.Cutoff_Date__c=string.valueof((system.today()+100).day());
    oem1.Fiscal_Month__c = '11';
    oem1.Fiscal_Year__c = '2014';
    try {insert oem1;}
    catch(Exception e){
    system.debug(e.getmessage());}    
   
   
   olmmappingcls omap = new olmmappingcls();
   OEM_Mapping_Rule__c od = new OEM_Mapping_Rule__c();
    od.OEM__c = oem1.Id;
    od.Fiscal_Month__c = '11';
    od.Fiscal_Year__c = '2014';
    od.Type__c = 'WWAC';
    od.WWAC__c = '12345';
    try {insert od;} 
    catch(Exception e){
    system.debug(e.getmessage());}    
    omap.save();
    omap.cancel();
    
 }
   public static testmethod void method1(){
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
    
    string dt=string.valueof(System.today().year());    
    String mon=string.valueof(System.today().month());
    OEM_Details__c oem = new OEM_Details__c();
    if(mon == '2')
    {
    oem.OEM__c = acc.id;
    oem.Fiscal_Year__c  =  ClsOEMUtil.CurrentFY;
    oem.Fiscal_Month__c = '05';
    oem.Cutoff_Date__c  = String.valueOf(date.today().day()+1);
    }
    try{
    insert oem;
    }
    catch(Exception e){system.debug(e.getmessage());}
            
    OEM_Mapping_Rule__c oemMap = new OEM_Mapping_Rule__c();
    oemMap.OEM__c = oem.id;
    oemMap.Type__c = 'Customer';
    oemMap.Fiscal_Year__c  = '2014';
    oemMap.Fiscal_Month__c = '05';
    
        
         
     olmmappingcls omap = new olmmappingcls();
     omap.omr=oemmap;
       try {omap.save();} 
     catch(Exception e){system.debug(e.getmessage());}
     omap.cancel();
 }
    
public static testmethod void method2(){
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
    
    
    OEM_Details__c oem1 = new OEM_Details__c();
    oem1.OEM__c = acc1.id;
    oem1.Cutoff_Date__c=string.valueof((system.today()+100).day());
    oem1.Fiscal_Month__c = '11';
    oem1.Fiscal_Year__c = '2014';
    try {insert oem1;}
    catch(Exception e){
    system.debug(e.getmessage());}    
   
   
   olmmappingcls omap = new olmmappingcls();
   OEM_Mapping_Rule__c od = new OEM_Mapping_Rule__c();
    od.OEM__c = oem1.Id;
    od.Fiscal_Month__c = '11';
    od.Fiscal_Year__c = '2014';
    od.Type__c = 'WWAC';
   // od.WWAC__c = '12345';
    try {omap.save();} 
    catch(Exception e){
    system.debug(e.getmessage());}    
    omap.cancel();
    
 }
    
public static testmethod void method3(){
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
    
    
    OEM_Details__c oem1 = new OEM_Details__c();
    oem1.OEM__c = acc1.id;
    oem1.Cutoff_Date__c=string.valueof((system.today()+100).day());
    oem1.Fiscal_Month__c = '11';
    oem1.Fiscal_Year__c = '2014';
    try {insert oem1;}
    catch(Exception e){
    system.debug(e.getmessage());}    
   
   
   olmmappingcls omap = new olmmappingcls();
   OEM_Mapping_Rule__c od = new OEM_Mapping_Rule__c();
    od.OEM__c = oem1.Id;
    od.Fiscal_Month__c = '11';
    od.Fiscal_Year__c = '2014';
    od.Type__c = 'WWAC';
    //od.WWAC__c = '12345';
    try {insert od;} 
    catch(Exception e){
    system.debug(e.getmessage());}    
    omap.save();
    omap.cancel();
    
 }


}