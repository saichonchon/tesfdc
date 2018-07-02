/**
 *	Contains a set of static methods used in invoice creation triggers and VF pages
 *
 @author Lili Zhao
 @created 2013-09-12
 @version 1.0
 @since 28.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-09-12 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created
 */
public class Ext_Contact_ResendInvitationEmail {
      
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    /**
	 * map to store global describtion due to limit on describe methodes.
	 */
	private map<String, String> map_urlParams;
	private ApexPages.standardController stdCtrl;   
	private Contact contact;
	private String tempId;  
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
	* The contsructor
	*
	@author Lili Zhao
	@created 2013-09-12
	@version 1.0
	@since 28.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-09-12 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/
    public Ext_Contact_ResendInvitationEmail(ApexPages.standardController stdCtrl) {
    	this.stdCtrl = stdCtrl;
    	map_urlParams = ApexPages.currentPage().getParameters(); 
		this.contact = (Contact) this.stdCtrl.getRecord();		
    }

	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
	* This method is used to send  mass Email
	*
	@created 2013-09-12
	@version 1.0
	@since 28.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-09-12 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/
   
	public PageReference sendEmail(){
		list<Messaging.SingleEmailMessage> list_singleEmailMessages = new list<Messaging.SingleEmailMessage>();	
		Messaging.SingleEmailMessage   mail = new Messaging.SingleEmailMessage();
		String targetObjectId;	
		String name;								
 		Contact contact = (Contact) [select Id, Owner.Name, NPS_Language__c, Campaign_Member_ID__c, OwnerId, Inactive__c From Contact Where Id = : contact.Id and Inactive__c = false];
 		targetObjectId = contact.Id;	
 		name = contact.Owner.Name;	
 		String language = contact.NPS_Language__c;    
		if(targetObjectId != null && contact.Campaign_Member_ID__c != null){
			try{
				CampaignMember campaignMember = (CampaignMember) [select CampaignId, Id,Status from CampaignMember where Id =: contact.Campaign_Member_ID__c];			
				if(campaignMember.Status != 'Responded'){
					try{
						Campaign campaign = (Campaign)	[select Id, IsActive, StartDate, EndDate from Campaign where Id =: campaignMember.CampaignId];	
						if(campaign.IsActive == true && campaign.StartDate <= Date.today() && campaign.EndDate >= Date.today()) {
							mail = ClsContactUtil.contactSendEmail(targetObjectId,name,language);	
							list_singleEmailMessages.add(mail);	
						}
					}catch(Exception ex){
						ApexPages.addMessages(ex);
		             	return null;
					}					
				}
			}catch(Exception ex){
				ApexPages.addMessages(ex);
             	return null;
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
 		}else {
 			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,system.Label.You_cannot_send_email_for_the_contact)); 		
 		}
		return null;
  	}
  	
  	  
    /**
	* This method is used to return contact view
	*
	@created 2013-09-12
	@version 1.0
	@since 28.0 (Force.com ApiVersion)
	*
	@changelog
	* 2013-09-12 Lili Zhao <lili.zhao@itbconsult.com>
	* - Created
	*/ 	
  	public PageReference returnContactView() {
  		pagereference p = new pagereference('/' + contact.Id);
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