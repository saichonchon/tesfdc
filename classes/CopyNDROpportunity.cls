/**********************************************************************************************************************************************
*******
Name: CopyNDROpportunity
Copyright © 2015 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is controller class for VF page CopyNDRPage. It contains Logic to Copy NDR to Channel Sales Opportunity
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Mrunal Parate   18/09/2015    Class                       
***********************************************************************************************************************************************
*****/
public class CopyNDROpportunity{ 
    public opportunity exisOpp = new opportunity(); 
    public opportunity newOpp = new opportunity(); 
    Id exisOppId;
    public CopyNDROpportunity(ApexPages.StandardController controller) { 
        exisOppId = apexpages.currentpage().getparameters().get('id');
    } 
    public PageReference copyNDR(){  
        String ChannelSalesId;
        if(Opportunity_Record_Type_Groups__c.getInstance('Channel- Sales Opportunity') != null && Opportunity_Record_Type_Groups__c.getInstance('Channel- Sales Opportunity').Active__c && Opportunity_Record_Type_Groups__c.getInstance('Channel- Sales Opportunity').RecordTypeID__c != null)
                ChannelSalesId = Opportunity_Record_Type_Groups__c.getInstance('Channel- Sales Opportunity').RecordTypeID__c;
    
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Opportunity.fields.getMap();
        String SOQL = 'Select '; 
        for (String fieldName : M.keySet())
        {       
        if(fieldName != 'NDR_Quote_Document_Number__c')        
                SOQL += fieldName + ',';  
        } 
        SOQL = SOQL.substring(0,SOQL.length()-1);  
        SOQL += ' From Opportunity where id=: exisOppId';
        system.debug('>>>>SOQL'+SOQL);

        Opportunity exisOpp = Database.query(SOQL);
    
        newOpp = exisOpp.clone(false); 
        newOpp.stagename= 'Concept';
        newOpp.recordtypeid = ChannelSalesId;
        newOpp.Currency_Confirm__c= true;  
        try{
        insert newOpp;
        }catch (Exception e){
            ApexPages.addMessages(e);
        }   

        PageReference pr = new ApexPages.StandardController(newOpp).view(); 
        system.debug('>>>>>>>>'+pr); 
        return pr; 
    } 
}