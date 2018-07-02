/**
 * This trigger checks if the account team member record is created out of TED and the actual User not equal to TEIS Admin
 * If yes it prevents update or delete the record. 
 * Test Class : accountTeamMember_BUD_preventDel_Test, Code Coverage - 87%
 *
 * @author      Frederic Faisst
 * @created     2012-03-29
 * @since       23.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 * 2012-03-29 Frederic Faisst <frederic.faisst@itbconsult.com>
 * - Created
 * 2016-07-07 Rajendra Shahane <rajendra.shahane@zensar.com>
 * - Modified for case 900718 to not to add error on Account_Team__c object when Team_member__c is inactive
 */

trigger accountTeamMember_BUD_preventUpdateDelete on Account_Team__c (before delete, before update) {
    
    Id integrationUserProfileId = Apex_Helper_Settings__c.getInstance('Service Account Profile Id').Value__c; //Get "Service Account" Profile Id out of Custom Setting
    Id actualUserProfileId = Userinfo.getProfileId(); //Get the Profile Id of actual user
    List<Specialist_Field__c> mcs = Specialist_Field__c.getall().values();// Change added by Mrunal for R-1113
    //If trigger is update
    if(Trigger.isUpdate){
        //for alle records in trigger loop
        for(Account_Team__c accTeam : Trigger.new){
            //Check if the records in the loop are created out of TED (TEIS Admin) & actual user not equal to "TEIS Admin"
            if(accTeam.CreatedById == integrationUserProfileId && actualUserProfileId != integrationUserProfileId){
                //If yes, show error message
                accTeam.addError(System.Label.PreventChangeAccTeamRecord);
            }
        }
    }
    //Else, trigger is delete
    else{
		//Start: Added by rajendra for case 900718
		map<Id,User> mapTeamMemberUser = new map<Id,User>();
		set<Id> setTeamMemberUserId = new set<Id>();
		set<Id> setAccIds = new set<Id>();
		//End: Added by rajendra for case 900718
        //for alle records in trigger loop
        for(Account_Team__c accTeam : Trigger.old){
			setAccIds.add(accTeam.Account__c);
			//Start: Added by rajendra for case 900718
			if(accTeam.Team_member__c != null)
				setTeamMemberUserId.add(accTeam.Team_member__c);
			//End: Added by rajendra for case 900718
            //Check if the records in the loop are created out of TED (TEIS Admin) & actual user not equal to "TEIS Admin"
            if(accTeam.CreatedById == integrationUserProfileId && actualUserProfileId != integrationUserProfileId){
                //If yes, show error message
                accTeam.addError(System.Label.PreventDeletionAccTeamRecord);
            }
        }
        // Change start by Mrunal for R-1113 to show error message if any one tries to delete the account team member
        // of role idento and relay and that respective account have values in idento and relay field. 
        
        List<string> flds = new List<string>();
        String accountDynamicQuery;
		//Start: Commented by rajendra to remove unnecessary for loop for case 900718 
        /*for(Account_Team__c accTeam : Trigger.old){
            setAccIds.add(accTeam.Account__c);
        }*/
		//End
		//Start: Added by rajendra for case 900718
		if(setTeamMemberUserId.size() > 0)
			mapTeamMemberUser = new map<Id,User>([select Id,isactive from user where id in:setTeamMemberUserId]);
		//End: Added by rajendra for case 900718
		
        for(Specialist_Field__c fld: mcs){
            flds.add(fld.API_Name__c);
        }
        if(flds.size() > 0){
        accountDynamicQuery = 'Select id, '+ String.join(flds, ', ') +' from account where id =: setAccIds ' ;
        }else{
        accountDynamicQuery = 'Select id from account where id =: setAccIds ' ;
        }
        Map<id,account> mapAcc = new Map<id,account>((List<account>)Database.query(accountDynamicQuery));
        for(Account_Team__c accTeam : Trigger.old){
            for(Specialist_Field__c fld: mcs){
                sObject actObjT = new Account();
                actObjT = mapAcc.get(accTeam.Account__c);
                if((actObjT.get(fld.API_Name__c) == accTeam.Team_member__c)&&(fld.Role__c == accTeam.Role__c))				
					if(accTeam.Team_member__c != null && mapTeamMemberUser!=null && mapTeamMemberUser.get(accTeam.Team_member__c).isactive)//Added by rajendra for case 900718
						accTeam.addError(System.Label.Prevent_Account_Team_Member_Deletion);				
            } 
        }
        // Change end by Mrunal for R-1113
    }
}