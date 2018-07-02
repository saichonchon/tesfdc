public class POSDetails_Extn {

public Opportunity_Partner__c POS {get;set;}
public Boolean NoneFound {get;set;}

    public POSDetails_Extn(ApexPages.StandardController controller) {
        string oppId = apexpages.currentpage().getparameters().get('id');
        POS = new Opportunity_Partner__c();
        NoneFound = true;
        datetime dCreateddate;
        for(Opportunity_Partner__c OP:[select id, name,Account__c, Partner_Account_Number__c, Partner_Street__c,Partner_Account__c,Partner_City__c,
            Partner_Account_Manager__c,Partner_Account_Name__c,Partner_Country__c,Partner_Region__c, Opportunity__r.createddate from Opportunity_Partner__c 
            where Opportunity__c = :oppId and Partner_Role__c='POS'] ){
            NoneFound = false;
            POS = OP;
            dCreateddate = OP.Opportunity__r.createddate;
        }
        if(NoneFound){
            if(dCreateddate >= date.newinstance(6, 7, 2016) )
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please Create POS customer By Clicking on \'Add/ Change POS Customer\' Button')); 
        }
     
    } 

}