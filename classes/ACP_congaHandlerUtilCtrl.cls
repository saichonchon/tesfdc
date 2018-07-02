/***************************************************************************************
Name:ACP_congaHandlerUtilCtrl
Test Class:ACP_Performance_Analytics_ctrl_Test
Copyright © 2017 TE Connectivity
========================================================================================
Requirement:
Extension for conga buttons .
========================================================================================
Purpose:
Used for performconga button functionality.
=========================================================================================
History
-------
Version      Author                     Date              Detail
1.0          Ghanshyam Choudhari           11/15/2017          Initial Development

Note:
 * 1. Class is global because we are using here Javascript remoting
 * 2. constructor is created to use this class as extension
 * 3. congaupdateattachh is returning null .
 * 4. congaupdateattachh has 3 soql because it will execute only if condition is satisfied.(do not want to waste soql)

****************************************************************************************/



global with sharing class ACP_congaHandlerUtilCtrl {
    public ACP_congaHandlerUtilCtrl(ApexPages.StandardController controller){  
    }
   
   @RemoteAction global static  ACP_Account_Plan__c congaupdateattachh(String conga ,string acpid) {
        try{     
			system.debug('acpIdxxxxPDF'+acpId); 
			List<ACP_Account_Plan__c> aapchold = [select id ,ACP_Conga_Attachement__c FROM ACP_Account_Plan__c where id=:acpid limit 1];
			if(aapchold.size() >0){
				if(conga=='PDF' || conga=='PPT' || conga=='Revenue Bridge'){
					if(conga=='PDF'){                
						aapchold[0].ACP_Conga_Attachement__c='PDF';                  
					}
					else if(conga=='PPT'){						
						aapchold[0].ACP_Conga_Attachement__c='PPT';        
					}
					else if(conga=='Revenue Bridge'){
						aapchold[0].ACP_Conga_Attachement__c='Revenue Bridge'; 
					}
					update aapchold;
				}
				else{
					System.debug('Not PPT PDF and Revenue');
				}
			}
        }catch(DmlException e){ ErrorLogging.Log(e, 'ACP_congaHandlerUtilCtrl', 'congaupdateattachh', acpid);ApexPages.addMessages(e);         
			
            
        }
		return null;
   }
   
}