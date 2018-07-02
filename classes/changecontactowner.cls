/**************************************************************************************************************************************************
Name:  changecontactowner
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: Helps in changing the contact ownership according to Account Owner and to do the reversing functionality.
---------------------------------------------------------------------------------------------------------------------------------------------------       
APEX Classes utilize this class : changecontactowner  
---------------------------------------------------------------------------------------------------------------------------------------------------       
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                   Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Chiranjeevi       24/01/2014 Initial Development                      
**************************************************************************************************************************************************/
public class changecontactowner{
    //Static Collections used for trigger execution  
    public static List<Contact> ConList = new List<Contact>();
    public static map<id, contact> conmap = new map<id, contact>();
    public static Set<String> returnapexhelpmep(){    
        //Custom Setting Apex Helper Settings required info
        Set<String> ApexHelperset = new Set<String>();
        Apex_Helper_Settings__c AHRec;
        List<Apex_Helper_Settings__c> AHRecList = new List<Apex_Helper_Settings__c>();    
        Map<String, Apex_Helper_Settings__c> ApexHelperMaps = Apex_Helper_Settings__c.getall();
        if(ApexHelperMaps.ContainsKey('TEIS_Admin')){
            ApexHelperset.add(Apex_Helper_Settings__c.getInstance('TEIS_Admin').Value__c);
        }
        else{
            AHRec = new Apex_Helper_Settings__c();
            AHRec.Name='TEIS_Admin';
            AHRec.Value__c='TEIS Admin';
            ApexHelperset.add(AHRec.Value__c);
            AHRecList.add(AHRec);
        }
        if(ApexHelperMaps.ContainsKey('Relay_Specialist')){
            ApexHelperset.add(Apex_Helper_Settings__c.getInstance('Relay_Specialist').Value__c);
        }
        else{
            AHRec = new Apex_Helper_Settings__c();
            AHRec.Name='Relay_Specialist';
            AHRec.Value__c='Relay Specialist (IS)';
            ApexHelperset.add(AHRec.Value__c);
            AHRecList.add(AHRec);
        }
        
        if(ApexHelperMaps.ContainsKey('Field_Engineer')){
            ApexHelperset.add(Apex_Helper_Settings__c.getInstance('Field_Engineer').Value__c);
        }
        else{
            AHRec = new Apex_Helper_Settings__c();
            AHRec.Name='Field_Engineer';
            AHRec.Value__c='Field Engineer (FE)';
            ApexHelperset.add(AHRec.Value__c);
            AHRecList.add(AHRec);
        }
        if(AHRecList.size()>0 && AHRecList!= null){insert AHRecList;}
        return ApexHelperset;
    }
}