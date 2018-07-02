/***********************************************************************************************************************
      Name : Cls_RefreshPartConfig
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This Class gets called from a Custom button which updates the Part Custom Object with Part Custom Setting.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE       DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   06/19/2013 Initial Development  1177                      
***********************************************************************************************************************/
global class Cls_RefreshPartConfig {
    public static boolean vConfigRefresh = True;
    //METHOD TO REFRESH THE CUSTOM OBJECT RECORD WITH THE CUSTOM SETTING
    webservice static void processDetails(){
        Part_Activation_Configuration__c vPartActiveObj = [SELECT Id, 
                                                                  Current_Object_Number__c,
                                                                  Max_Number_of_Objects__c,
                                                                  Object_API_Name__c,
                                                                  Object_Field_API_Name__c,
                                                                  Cron_Statement__c
                                                             FROM Part_Activation_Configuration__c
                                                            LIMIT 1];
        Parts_Activation_Settings__c vConfig    = Parts_Activation_Settings__c.getValues('1');
        vPartActiveObj.Current_Object_Number__c = Decimal.ValueOf('1');
        vPartActiveObj.Object_API_Name__c       = vConfig.Object_API_Name__c;
        vPartActiveObj.Object_Field_API_Name__c = vConfig.Object_Field_API_Name__c;
        vPartActiveObj.Conditional_Query__c     = vConfig.Conditional_Query__c;
        try {
            vConfigRefresh = false;
            update vPartActiveObj;
        }catch(Exception e) {
            System.debug('Exception in Updating PartConfig '+e);
        }    
    }
    //METHOD TO DELETE OLDER NOTE RECORDS RELATED TO CONFIGURATION RECORD
    webservice static void deleteOldLogs(Id pConfigRecordId){
        if(pConfigRecordId != NULL){
            List<Note> vListNote = [SELECT Id
                                      FROM Note
                                     WHERE ParentId =: pConfigRecordId
                                  ORDER BY CreatedDate DESC
                                    OFFSET 10];  
            if(!vListNote.isEmpty()){
                Delete vListNote;
            }
        }
    }
}