/***********************************************************************************************************************
      Name : Cls_SchedularPartFlagDeactivationTest1 
       Org : C2S
 Copyright : © 2013 TE Connectivity
========================================================================================================================
   Summary : This class contain positive behavioral test methods for classes mentioned below
________________________________________________________________________________________________________________________
 Apex class(es) whose code is covered : Cls_SchedularPartFlagDeactivation    
========================================================================================================================
 Code Coverage History:                                                        
________________________________________________________________________________________________________________________
 VERSION DEVELOPER         DATE          DETAIL                                  MERCURY REQUEST #
________________________________________________________________________________________________________________________
     1.0 Shantinath        06/26/2013    Initial Developemnt           
***********************************************************************************************************************/
@isTest(SeeAllData=true)
public class Cls_SchedularPartFlagDeactivationTest1 {
    static testMethod void validateError() {
        List<Part__c> vPartUpdate = new List<Part__c>();
        List<Part__c> vPartList = [SELECT Id, 
                                          IsActive__c, 
                                          Date_of_Activation__c 
                                     FROM Part__c 
                                    LIMIT 4];
        for(Part__c vTempPart : vPartList){
            vTempPart.IsActive__c = TRUE;
            vTempPart.Date_of_Activation__c = date.Today()-6;
            vPartUpdate.add(vTempPart);
        }
        update vPartUpdate;
        SchedulableContext SC;
        Cls_SchedularPartFlagDeactivation vSch = new Cls_SchedularPartFlagDeactivation();
        vSch.execute(SC);
    }
}