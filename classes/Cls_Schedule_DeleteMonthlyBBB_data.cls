/***********************************************************************************************************************
      Name : Cls_Schedule_DeleteMonthlyBBB_data
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This Class is schedule class . Using this class execute the "ClsBatch_DeleteMonthlyBBB_data" batch class for 
             deleting old data from "BBB_Month_Bill_Book_Cust_PN__c " and "BBB_Month_Bill_Book_Cust__c " objects . Based on the 
             custom Setting "Monthly_Data_delete__c" value.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi     09/06/2013   Initial Development        R-1244                   
***********************************************************************************************************************/



global class Cls_Schedule_DeleteMonthlyBBB_data implements Schedulable{
    
    global void execute(SchedulableContext sc) {
       // Retrieve the current Fisical year  
        Period p=[select FiscalYearSettingsId, FiscalYearSettings.Name, PeriodLabel, Number, StartDate, EndDate from Period where type = 'Year' and FiscalYearSettings.IsStandardYear = false and StartDate <= :Date.Today() and EndDate >= :Date.Today() order by FiscalYearSettings.Name Limit 1];
        //calculating the deleting year 
        String CalcYear=String.valueof(integer.valueof(p.FiscalYearSettings.Name)-Integer.valueof(Monthly_Data_delete__c.getinstance('No of years').No_of_years_to_keep_data__c));
        
        //Query for retrieving the "BBB_Month_Bill_Book_Cust_PN__c" object data.    
        String Query= 'select Fiscal_Year__c from  BBB_Month_Bill_Book_Cust_PN__c WHERE Fiscal_Year__c <'+'\''+CalcYear+'\'';
       
        if(Test.isRunningTest()){
            if (query != '' || query != null){
                query+= ' LIMIT 1';
            }
        }
      
        
       // Batch class execution.
        ClsBatch_DeleteMonthlyBBB_data Batchcls1 = new ClsBatch_DeleteMonthlyBBB_data(Query);
        if(Batchcls1!=null)
        system.debug('@@');
        Database.executeBatch(Batchcls1);
        
        //Query for retrieving the "BBB_Month_Bill_Book_Cust__c " object data. 
        Query= 'SELECT Id, Fiscal_Year__c FROM BBB_Month_Bill_Book_Cust__c WHERE Fiscal_Year__c <'+'\''+CalcYear+'\'';
       
        if(Test.isRunningTest()){
            if (query != '' || query != null){
                query+= ' LIMIT 1';
            }
        }
        // Batch class execution.
        ClsBatch_DeleteMonthlyBBB_data Batchcls2 = new ClsBatch_DeleteMonthlyBBB_data(Query);
        Batchcls2.Call_Query=true;
        Database.executeBatch(Batchcls2);
    }
}