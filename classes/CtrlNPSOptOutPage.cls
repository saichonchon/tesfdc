/** 
*    Controller for CtrlTakeSurvey page
*
@author Xia Tong
@created 2013-01-09 
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2013-01-09 Xia Tong <xia.tong@itbconsult.com>
* - Created
*/
global class CtrlNPSOptOutPage {

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global CampaignMember cm{get;set;}
    global boolean isSuccess{get;set;}
    global String salutation{get;private set;}
    global String mode {get; private set;}
    global String introduceBody {get;private set;}
    global String saveBtn {get;private set;}
    global String cancelBtn {get;private set;}
    global String closeBtn {get;private set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<string,string> map_parameters; 
    private Id compaignId;
    private map<string,SurveyLabelConfig__c> map_name_customsetting;
    private static final string DEFAULT_CUSTOM_SETTING_FIELD ='EN_Value_c__c';
    private String csfield;
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /** 
    *    Constructor
    *
    @author Xia Tong
    @created 2012-12-11 
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-12-11 Xia Tong <xia.tong@itbconsult.com>
    * - Created
    */
    global CtrlNPSOptOutPage(){
        isSuccess = false;
        map_parameters = new map<string,string>();
        map_parameters = Apexpages.currentPage().getParameters();
        map_name_customsetting = new map<string,SurveyLabelConfig__c>();
	    map_name_customsetting = SurveyLabelConfig__c.getAll();
	    csfield = DEFAULT_CUSTOM_SETTING_FIELD;
        if(map_parameters.containsKey('Id')){
        	compaignId = map_parameters.get('Id');
        	String cmIdStr = (String)compaignId;
            if(cmIdStr.length() < 15 || cmIdStr.subString(0,3) != CampaignMember.SObjectType.getDescribe().getKeyPrefix()){
                mode = 'Error';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Invalid_ID')));
                return;
            }
        	for(CampaignMember c: [select id, NPS_OPT_OUT__c,Contact.NPS_OPT_OUT__c,Contact.ITBsalutations__Letter_Salutation__c,contact.NPS_Language__c from CampaignMember where id =: compaignId]){
        		cm = c; 
        		cm.NPS_OPT_OUT__c = cm.Contact.NPS_OPT_OUT__c;
        		salutation = cm.Contact.ITBsalutations__Letter_Salutation__c + ',';
        	}
        	if(cm == null){
                mode = 'Error';
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('NPS_Invalid_ID')));
                return;
            }else{
            	if(cm.Contact.NPS_Language__c == null){
	                cm.Contact.NPS_Language__c = 'EN';
	            }
	            csfield = cm.Contact.NPS_Language__c + '_Value_c__c';
	            getCustomLabels();
        	}
        }
    }
 
	global PageReference save(){
		//system.debug('tongxia1');
		try{
			update cm; 
		}catch(Exception ex	){
			isSuccess = false;
			ApexPages.addMessages(ex);
			return null;
		}
		isSuccess = true;
		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, getMessage('Successed')));
		return null;
		//system.debug('tongxia2');
	}
	
	global void init(){
		update cm;
	}
	
	private String getMessage(String name){
	    String msg = '';
	    if(map_name_customsetting.containsKey(name)){
	    	Sobject cs = (Sobject)map_name_customsetting.get(name);
	    	try{
	    		msg = (String)cs.get(csfield);
	    	}catch(Exception ex){
	    		
	    	}
	    	if(msg == null || msg == ''){
		    	msg = (String)cs.get(DEFAULT_CUSTOM_SETTING_FIELD);
		    }
	    }
	    
	    return msg;
    }
   
    private void getCustomLabels(){
    	//system.debug('tongxia: csfield:' + csfield);
    	introduceBody = getMessage('OPT_OUT_Introduction');
    	saveBtn = getMessage('Save');
    	cancelBtn = getMessage('Cancel');
    	closeBtn = getMessage('Close');
    	//system.debug('tongxia: introduceBody:' + introduceBody);
    	//system.debug('tongxia: saveBtn:' + saveBtn);
    	//system.debug('tongxia: cancelBtn:' + cancelBtn);
    	//system.debug('tongxia: closeBtn:' + closeBtn);
    }     
    

}