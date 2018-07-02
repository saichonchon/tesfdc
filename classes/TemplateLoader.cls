global class TemplateLoader implements Support.EmailTemplateSelector {
    
    global TemplateLoader() {    }
    
    // The main interface method
    global ID getDefaultEmailTemplateId(ID caseId) {
        // Select the case we're interested in, choosing any fields that are relevant to our decision
        Id PICRecordTypeId = Apex_Helper_Settings__c.getInstance('PIC Service Cloud').Value__c; 
        Case c = [SELECT Status,Reason,RecordtypeId,Origin,Country__c FROM Case WHERE Id=:caseId and recordtypeid=:PICRecordTypeId and Origin=:'Web' and Status=:'Assigned' and Country__c=:'Japan'];
        
        Smart_Template_Loader_Conf__c conf = null;
        List<Smart_Template_Loader_Conf__c> confs = null;

        // get template from case status + case reason
        confs = [SELECT Template_Name__c FROM Smart_Template_Loader_Conf__c WHERE Case_Status__c =: c.status and Case_Region__c =: c.Country__c];
        if (!confs.isEmpty()) {
            conf = confs[0];
            System.debug('got template: ' + conf.Template_Name__c);
        }
       
        if (conf==null) {
            System.debug('no template!');
            return null;
        }
        
        // get the template ID
        List<EmailTemplate> ets = [SELECT id FROM EmailTemplate WHERE DeveloperName=:conf.Template_Name__c];
        if (!ets.isEmpty()) {
            EmailTemplate et = ets[0];
            System.debug('template: ' + conf.Template_Name__c + ' -- id: ' + et.id);
            return et.id;
        }
        System.debug('No template with the name: ' + conf.Template_Name__c);        
        return null;
    }
}