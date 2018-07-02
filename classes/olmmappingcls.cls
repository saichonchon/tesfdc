/**********************************************************************************************************************************************
*******
Name: olmmappingcls
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This controller prepopulate Fiscal Year and Fiscal Month from OEM Detail record.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0      Padmaja       15/01/2014    Controller                       
***********************************************************************************************************************************************
*****/


public with sharing class olmmappingcls {
public OEM_Mapping_Rule__c omr{get;set;}
public id vVariableName{get;set;}
public string vVariableName1{get;set;}
    public olmmappingcls(){
    vVariableName=Apexpages.Currentpage().getParameters().get('vVariableName');
    vVariableName1=Apexpages.Currentpage().getParameters().get('vVariableName1');
    string dt=string.valueof(System.today().year());
    String mon=string.valueof(System.today().month());
        for(integer i=1;i<=9;i++)
        {
            if(mon==string.valueOf(i))
            {
                mon=string.valueof(i+3);
                omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
                i=10;

                
            }
        }
      /*  if(mon == '1'){
        mon='04';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon == '2'){
        mon='05';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon == '3'){
        mon='06';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        
        }
        else if(mon == '4'){
        mon='07';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon == '5'){
        mon='08';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon == '6'){
        mon='09';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon == '7'){
        mon='10';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon == '8'){
        mon='11';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon == '9'){
        mon='12';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }*/
        if(mon == '10'){
        mon='1';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon == '11'){
        mon='2';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
        else if(mon=='12'){
        mon='3';
        omr=new OEM_Mapping_Rule__c(OEM__c=vVariableName,Fiscal_Year__c = dt,Fiscal_Month__c = mon);
        }
    }
    public PageReference cancel() {
        pagereference ref=new pagereference('/'+vVariableName);    
        return ref;
      }
    
    public PageReference save() {
        try{    
        insert omr; 
        pagereference ref=new pagereference('/'+vVariableName);
        ref.setredirect(true); 
        return ref;
        }
        catch(Exception ex){
        System.debug('************error messages************'+ex.getMessage()); 
        if(ex.getMessage().contains('Please define World Wide Account Number:') ){     
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please define World Wide Account Number'));
        }  
        else if(ex.getMessage().contains('Please define  World Wide Account Number/Part Number:')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please define World Wide Account Number/Part Number'));        
        }
        else if(ex.getMessage().contains('Please Define Sold To Account Code:')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please Define Sold To Account Code'));
        }
        else if(ex.getMessage().contains('Please define Sold To Account Code/ Part Number:')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please define Sold To Account Code/ Part Number'));
        } 
        else if(ex.getMessage().contains('Please define Part Number:')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please define Part Number'));
        } 
        else if(ex.getMessage().contains('Allocation cannot exceed 100%!:')){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Allocation cannot exceed 100%!'));
        } 
        }
      return null;      
      }

}