/**********************************************************************
Name: ADMSOPOppWarning
Copyright © 2017
======================================================
======================================================
Purpose: ADMSOPOppWarning is used for displaying the custom message on a page for opportinities and its child forecast 
records which have Relevant for S&OP marked true, but opportunity is below 90% probability
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR               DATE             DETAIL Description
0.1          Vaibhav  M           10/04/2017       INITIAL DEVELOPMENT
***********************************************************************/

public class ADMSOPOppWarning{
   
    public String showMessage{get; set;}
    public String oppID {get; set;}
    
       
    public ADMSOPOppWarning(ApexPages.StandardController controller) {
     try{
        Date todaydate = System.Today();
        FiscalYearSettings currentfisobj = [select id,name from FiscalYearSettings WHERE StartDate <=: todaydate and EndDate>=: todaydate];
        String currentYear = currentfisobj.name;
        String nextYear = String.valueOf(Integer.ValueOf(currentfisobj.name)+1);
        List <String> yearlist = new List<string>{currentYear,nextYear};
    
        showMessage = '';
        oppID = ApexPages.currentPage().getParameters().get('Id');
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('ADM').getRecordTypeId();
        
        Integer intprob = 90;
        ADM_Custom_Setting__c probaSetting = ADM_Custom_Setting__c.getValues('ADM_JDA_Probability');
        if(probaSetting != null){
             intprob = Integer.valueof(probaSetting.Value__c);
        }        

        sObject sopp = [Select id, Name, RecordTypeId, Probability, Level__c, Method__c, Relevant_for_S_OP__c, (SELECT Id,Name FROM Forecast__r where Fiscal_Year__c in: yearlist AND RecordType.Name = 'Part') from Opportunity where id =: oppID];
        if(sopp.get('RecordTypeId') == oppRecordTypeId){
        if(sopp.get('Relevant_for_S_OP__c') == True && sopp.get('Level__c') =='Monthly' && sopp.get('Method__c') == 'Manual' && (Decimal)sopp.get('Probability') < intprob && sopp.getSObjects('Forecast__r') != null){
             showMessage = System.Label.ADMCustWarningSop;
           } }  
       }
    catch(Exception e){
                System.debug('errMessage' + ': ' + e.getMessage());
                ErrorLogging.Log(e, 'ADMSOPOppWarning', 'ADMSOPOppWarning',oppID);
            
       }
    }    
}