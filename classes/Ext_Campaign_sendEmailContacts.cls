/**
 *	Contains a set of static methods used in invoice creation triggers and VF pages
 *
@created 2013-09-11
@version 1.0
@since 28.0 (Force.com ApiVersion)
*
@changelog
* 2013-09-11 Lili Zhao <lili.zhao@itbconsult.com>
* - Created        
*/    
public class Ext_Campaign_sendEmailContacts {     
        
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
	 * map to store global describtion due to limit on describe methodes.
	 */
	private map<String, String> map_urlParams;     
	private ApexPages.standardController stdCtrl;
	private Campaign campaign;
	private String tempId;
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
	* The contsructor
	*
	@created 2013-09-11
	@version 1.0
	@since 28.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-09-11 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/
    public Ext_Campaign_sendEmailContacts(ApexPages.standardController stdCtrl) {
    	this.stdCtrl = stdCtrl;
    	map_urlParams = ApexPages.currentPage().getParameters(); 
		this.campaign = (Campaign) this.stdCtrl.getRecord();		
    }

	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
	* This method is used to send mass eamil
	*
	@created 2013-09-11
	@version 1.0
	@since 28.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-09-11 Lili Zhao <lili.zhao@itbconsult.com>  
	* - Created
	*/
   
	public PageReference sendEmail(){	
		list<Messaging.SingleEmailMessage> list_singleEmailMessages = new list<Messaging.SingleEmailMessage>();
		Campaign campaign = (Campaign)	[select Id, IsActive, StartDate, EndDate from Campaign where id =: campaign.Id];
		if(campaign.IsActive == true && campaign.StartDate <= Date.today() && campaign.EndDate >= Date.today()) {
			for(CampaignMember campaignMember:[select CampaignId, Id, Status, Contact.NPS_Language__c, Contact.Owner.Name, Contact.Campaign_Member_ID__c,Contact.Email,Contact.External_NPS_Survey_Link__c, Contact.Japan_External_Survey_Link__c, Contact.Korean_Survey_Link__c, Contact.Trad_Chinese_External_NPS_Survey_Link__c, Contact.Simpl_Chinese_External_NPS_Survey_Link__c, Contact.External_NPS_OPT_OUT_link__c, Contact.ITBsalutations__Letter_Salutation__c, Contact.FirstName, Contact.LastName, Contact.Name, Contact.Account.Name, ContactId, IsDeleted FROM CampaignMember where CampaignId =: campaign.Id and isDeleted = false and Status != 'Responded']){ 			
	 			Messaging.SingleEmailMessage   mail = new Messaging.SingleEmailMessage();
	 			String targetObjectId = campaignMember.ContactId;
	 			String name = campaignMember.Contact.Owner.Name;
	 			String language = campaignMember.Contact.NPS_Language__c;
	 			if(targetObjectId != null) {	 				
	 				mail = ClsContactUtil.contactSendEmail(targetObjectId,name,language);	
	 				list_singleEmailMessages.add(mail);
	 			}					  						 					
	 		}
		 	if(!list_singleEmailMessages.isEmpty()) {
		 		try{
					Messaging.sendEmail(list_singleEmailMessages, false);
		 			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,system.Label.Invitation_has_been_sent_successfully));
				}catch(Exception ex){
					ApexPages.addMessages(ex);
	             	return null;
				}	 			
	 		}else{
	 			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_hava_no_user_to_send));
	 		}		  	 			
		}else{					
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_Cannot_Send_Invitation));
			 
		} 		 			
		return null;    
  	}  
  	
  	/**
	* This method is used to return campaign view
	*   
	@created 2013-09-11
	@version 1.0
	@since 28.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-09-11 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/
  	public PageReference returnCampaignView() {
  		pagereference p = new pagereference('/' + campaign.Id);
  		return p;
  	}
  	
  	
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
       
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}