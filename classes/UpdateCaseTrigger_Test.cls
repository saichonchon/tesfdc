/**************************************************************************************************************************************************
Name:  UpdateCaseTrigger_Test
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for UpdateCase Trigger 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Trigger : UpdateCase                                                             
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Chiranjeevi Neelam 16/07/2013 Initial Development                      1453487                                   
**************************************************************************************************************************************************/
@IsTest
public class UpdateCaseTrigger_Test{
    public static testMethod void TestTrigger(){
        Map<integer, string> CaseEmaiString = new Map<integer, string>();
        CaseEmaiString.put(0, 'benchmark@te.com');
        CaseEmaiString.put(1, 'celestica@te.com');
        CaseEmaiString.put(2, 'flextronics@te.com');
        CaseEmaiString.put(3, 'jabilteam@te.com');
        CaseEmaiString.put(4, 'jabilquotes@te.com');
        CaseEmaiString.put(5, 'sanminateam@te.com');
        CaseEmaiString.put(6, 'test@test.com');
        CaseEmaiString.put(7, 'te_customercare_arrow@te.com');
        CaseEmaiString.put(8, 'consumerteam@te.com');
        CaseEmaiString.put(9, 'tecustomercaresz_apl@te.com');
        CaseEmaiString.put(10, 'cip1@te.com');
        CaseEmaiString.put(11, 'te_customercare_arrow@te.com');
        CaseEmaiString.put(12, 'consumerteam@te.com');
        CaseEmaiString.put(13, 'tecustomercaresz_apl@te.com');
        CaseEmaiString.put(14, 'tecustomercarechina_ind@te.com');
        CaseEmaiString.put(15, 'consumerteam@te.com');
        CaseEmaiString.put(16, 'customercare-1@te.com');
        CaseEmaiString.put(17, 'swathi.gaddam@te.com');
        
        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        
        List<Case> vCsLst = new List<Case>();
        //Case C=new Case();
        
        
        //@Abhijeet -Added this to complete test coverage for CCP recorrdtype classes. 29/10/2013
        
         Id rt = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care Cloud').getRecordTypeId();
         Id vRTData = Schema.SObjectType.Case.getRecordTypeInfosByName().get('DataComm - Customer Care').getRecordTypeId();
        //RecordType rt = [select Id, Name from RecordType where Name = '' and SobjectType = 'Case'];
        //RecordType vRTData = [select Id, Name from RecordType where Name = '' and SobjectType = 'Case'];
        MilestoneType vMlType = [Select id,name from MilestoneType where name =:'4 Hour Response Time'];
        MilestoneType vMlType1 = [Select id,name from MilestoneType where name =:'24 Hour Response Time'];
        
        /*Apex_Helper_Settings__c ahs1 = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c ahs2 : [select Id,Value__c from Apex_Helper_Settings__c where Name = '4 Hour Response Time' limit 1]){
            ahs1 = ahs2;
        }
        if(ahs1.Value__c == null){
            ahs1.Name = '4 Hour Response Time';
            ahs1.Value__c = vMlType.Id;
            insert ahs1;
        }
        
        Apex_Helper_Settings__c ahs15 = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c ahs16 : [select Id,Value__c from Apex_Helper_Settings__c where Name = '24 Hour Response Time' limit 1]){
            ahs15 = ahs16;
        }
        if(ahs15.Value__c == null){
            ahs15.Name = '24 Hour Response Time';
            ahs15.Value__c = vMlType.Id;
            insert ahs15;
        }
        
        Apex_Helper_Settings__c ahs9 = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c ahs10 : [select Id,Value__c from Apex_Helper_Settings__c where Name = 'Customer Care Cloud' limit 1]){
            ahs9 = ahs10;
        }
        if(ahs9.Value__c == null){
            ahs9.Name = 'Customer Care Cloud';
            ahs9.Value__c = rt.Id;
            insert ahs9;
        }
        Apex_Helper_Settings__c ahs11 = new Apex_Helper_Settings__c();
        for(Apex_Helper_Settings__c ahs12 : [select Id,Value__c from Apex_Helper_Settings__c where Name = 'DataComm - Customer Care' limit 1]){
            ahs11 = ahs12;
        }
        if(ahs11.Value__c == null){
            ahs11.Name = 'DataComm - Customer Care';
            ahs11.Value__c = vRTData.id;
            insert ahs11;
        }*/
        Customer_Care_SharedEmailBox__c ccs=new Customer_Care_SharedEmailBox__c();
        ccs.Name='cip1@te.com';
        ccs.Case_Group__c='Email:CIP1';
        insert ccs;
        for(Integer i=0;i<10;i++){
        Case c = new Case();
        C.Status='New';
        C.Origin='Web';
        C.Reason='User attend training';
        C.IsSelfServiceClosed=true;
        C.ClosedDate=date.today()+1;
        C.Priority='High';
        C.Subject='Auto';
        C.Type='Question';   
        C.Case_Group__c = null;
        if(i < 6){
         C.recordtypeid = vRTData;
        }else if(i == 6){
        c.Quick_Email__c = true;
        C.recordtypeid = rt;
        }
        else{
        C.recordtypeid = rt;
        }
        vCsLst.add(c);
        }
           
        insert vCsLst;
        
        test.starttest();
       EmailMessage EM =new EmailMessage(
            ParentId=vCsLst[0].id,
            Incoming = false,
            BccAddress='test@test.com',
            ToAddress = CaseEmaiString.get(0),
            FromAddress= 'chiranjeevi.neelam@zensar.in',
            Subject = 'Test Subject',
            HtmlBody='no body',
            MessageDate=Date.Today(),
            FromName='Zensar',
            CcAddress = 'chiranjeevi.neelam@zensar.in'
            );
           insert EM;
           CaseUtil_CCP.updateCaseboolean = false;
           CaseUtil_CCP.updateCaseboolean1 = false;
       EmailMessage EM1 =new EmailMessage(
            ParentId=vCsLst[1].id,
            Incoming = false,
            BccAddress='test@test.com',
            ToAddress = CaseEmaiString.get(1),
            FromAddress= 'chiranjeevi.neelam@zensar.in',
            Subject = 'Test Subject',
            HtmlBody='no body',
            MessageDate=Date.Today(),
            FromName='Zensar',
            CcAddress = 'chiranjeevi.neelam@zensar.in'
            );
           //insert EM1;
           CaseUtil_CCP.updateCaseboolean = false;
          CaseUtil_CCP.updateCaseboolean1 = false;
       EmailMessage EM2 =new EmailMessage(
            ParentId=vCsLst[2].id,
            Incoming = false,
            BccAddress='test@test.com',
            ToAddress = CaseEmaiString.get(2),
            FromAddress= 'chiranjeevi.neelam@zensar.in',
            Subject = 'Test Subject',
            HtmlBody='no body',
            MessageDate=Date.Today(),
            FromName='Zensar',
            CcAddress = 'chiranjeevi.neelam@zensar.in'
            );
           //insert EM2;
           CaseUtil_CCP.updateCaseboolean = false;
           CaseUtil_CCP.updateCaseboolean1 = false;
           EmailMessage EM3 =new EmailMessage(
            ParentId=vCsLst[3].id,
            Incoming = false,
            BccAddress='test@test.com',
            ToAddress = CaseEmaiString.get(3),
            FromAddress= 'chiranjeevi.neelam@zensar.in',
            Subject = 'Test Subject',
            HtmlBody='no body',
            MessageDate=Date.Today(),
            FromName='Zensar',
            CcAddress = 'chiranjeevi.neelam@zensar.in'
            );
           //insert EM3;
           CaseUtil_CCP.updateCaseboolean = false;
           CaseUtil_CCP.updateCaseboolean1 = false;
           EmailMessage EM4 =new EmailMessage(
            ParentId=vCsLst[4].id,
            Incoming = false,
            BccAddress='test@test.com',
            ToAddress = CaseEmaiString.get(4),
            FromAddress= 'chiranjeevi.neelam@zensar.in',
            Subject = 'Test Subject',
            HtmlBody='no body',
            MessageDate=Date.Today(),
            FromName='Zensar',
            CcAddress = 'chiranjeevi.neelam@zensar.in'
            );
           //insert EM4;
           CaseUtil_CCP.updateCaseboolean = false;
           CaseUtil_CCP.updateCaseboolean1 = false;
           EmailMessage EM5 =new EmailMessage(
            ParentId=vCsLst[5].id,
            Incoming = false,
            BccAddress='test@test.com',
            ToAddress = CaseEmaiString.get(5),
            FromAddress= 'chiranjeevi.neelam@zensar.in',
            Subject = 'Test Subject',
            HtmlBody='no body',
            MessageDate=Date.Today(),
            FromName='Zensar',
            CcAddress = 'chiranjeevi.neelam@zensar.in'
            );
           //insert EM5;
               
           CaseUtil_CCP.updateCaseboolean1 = false;
           
           EmailMessage EM7 =new EmailMessage(
            ParentId=vCsLst[7].id,
            Incoming = true,
            BccAddress='test@test.com',
            ToAddress = CaseEmaiString.get(10),
            FromAddress= 'digi-key@te.com',
            Subject = 'Test Subject',
            HtmlBody='no body',
            MessageDate=Date.Today(),
            FromName='Zensar',
            CcAddress = 'chiranjeevi.neelam@zensar.in'
            );
           //insert EM7;
           
           CaseUtil_CCP.updateCaseboolean1 = false;
           EmailMessage EM8 =new EmailMessage(
            ParentId=vCsLst[6].id,
            Incoming = false,
            BccAddress='test@test.com',
            ToAddress = CaseEmaiString.get(10),
            FromAddress= 'cip1@te.com',
            Subject = 'Test Subject',
            HtmlBody='no body',
            MessageDate=Date.Today(),
            FromName='Zensar',
            CcAddress = 'chiranjeevi.neelam@zensar.in'
            );
           insert new list<EmailMessage>{EM1, EM2, EM3, EM4, EM5, EM7, EM8};
              
               
         
        test.stoptest();
    }// TestTrigger Ends
}// UpdateCaseTrigger_Test Ends