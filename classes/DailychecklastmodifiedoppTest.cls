/***********************************************************************************************************************
      Name : DailychecklastmodifiedoppTest
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods and negative behavioral test methods for 
             Dailychecklastmodifiedopp
________________________________________________________________________________________________________________________
 Apex class(es) whose code is covered : Dailychecklastmodifiedopp, daysemaialert
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER             DATE       DETAIL                                  MERCURY REQUEST #
________________________________________________________________________________________________________________________
     1.0 RamaKrishna          12/24/2013 Initial Development    
                                                                  
***********************************************************************************************************************/

@isTest(seeAllData = true)
public class DailychecklastmodifiedoppTest {
 /*
 _______________________________________________________________________________________________________________________                                                                       
        Scenario : Capture Opportunity records where lastmodified date equal to 30days or greater than 30 days and send 
        e         mail alerts to Opportunity Owner.                               
 _______________________________________________________________________________________________________________________
       Test Type : Positive and Negative behavioral Test.                                                                            
 _______________________________________________________________________________________________________________________
 */   
 public static void testcaptureBatch(){
 /*
  Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
        User u = ClsTestHelp.createTestUsers();
        u.Email = 'helloManesfd@testCompany1233423.com';
        u.Alias = 'dpse';
        u.CommunityNickname = 'TMD';
        u.ProfileId = p.Id;
        insert u;
      */      
            RecordType rt = ClsTestHelp.createTestRecordType();
            RecordType rt2 = ClsTestHelp.createTestRecordType16();
            
            Account acc = ClsTestHelp.createTestAccounts();
            acc.Type = 'CM';
            insert acc;
            
            User ut = [select id,email from user where Name = 'Padmaja Dadi'];
            
            System.debug('test stasrted: prabhan:');
     
            Opportunity oppy2 = ClsTestHelp.createTestOpportunity();
            oppy2.Program_level_Forecasting__c =true; 
            oppy2.Name = 'Pain of Queen';
            oppy2.Type = 'CM';
            oppy2.Request_Type__c = 'Extension';
            oppy2.RecordTypeId = rt2.Id;
            oppy2.OwnerId = ut.id;
            oppy2.StageName='Qualification';
            
            insert oppy2;  
            
            Opportunity oppy = ClsTestHelp.createTestOpportunity();
            oppy.Program__c = oppy2.Id;   
            oppy.Type = 'CM';
            oppy.Request_Type__c = 'Extension';
            oppy.Method__c = 'BOM';
            oppy.Level__c = 'Yearly';
            oppy.Amount = 1;
            oppy.CurrencyIsoCode = 'EUR';
            oppy.OwnerId = ut.id;
            oppy.Five_Year_Revenue__c = 1;
            oppy.RecordTypeId = rt2.Id;
            insert oppy; 
            
            List<Opportunity> opp2 =  [select Id, Name, Owner.Email from Opportunity where Id=:oppy.Id];
            
            System.debug('*****************opp2opp2**********************'+opp2);
            
            for(Opportunity opp3 :opp2)
            {
            System.debug('*****************owner email**********************'+opp3.Owner.Email);
            if(opp3.Owner.Email != null)
            {  
           list<Messaging.SingleEmailMessage> lstmail=new list<Messaging.SingleEmailMessage>(); 
           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();           
           mail.setToAddresses(new String[] {opp3.owner.email});      
                
            System.debug('*****************mail mail **********************'+mail);
           mail.setSaveAsActivity(false);           
           mail.setSubject('30 Days Opportunity Not Updated');           
           mail.setUseSignature(false);           
                 
           mail.setHtmlBody('test');           
           lstmail.add(mail);        
                   
           if(!lstmail.isEmpty() && !test.isRunningTest()){            
           Messaging.SendEmail(lstmail);   

            System.debug('*****************lstmail**********************'+lstmail);     
           }                       
          }
          } 
     
           list<Opportunity> lstopp=new list<Opportunity>();
           lstopp.add(oppy);
      
            System.debug('*****************lstopplstopp**********************'+lstopp);
           daysemaialert clsBatch = new daysemaialert();
                 
           Database.BatchableContext BC;
           clsBatch.start(BC);                  
           clsBatch.execute(BC, lstopp);    
           clsBatch.finish(BC);            
  
     /** 
     ** Testing schedulable class:  Dailychecklastmodifiedopp
     **/
             Dailychecklastmodifiedopp Dailycheck = new Dailychecklastmodifiedopp ();   
             String chron = '0 0 23 * * ?';        
             system.schedule('Test Sched', chron, Dailycheck); 
    }
  
 /*
 _______________________________________________________________________________________________________________________
  Purpose : Call Negative behavioral Tests and Positive behavioral Tests for method(s) of 
            daysemaialertTest
 _______________________________________________________________________________________________________________________  
 */
 public static testMethod void coreTestMethod(){      
  test.StartTest();   
  testcaptureBatch();    
  test.StopTest();
 } // public static testMethod void coreTestMethod()

} //public class DailychecklastmodifiedoppTest