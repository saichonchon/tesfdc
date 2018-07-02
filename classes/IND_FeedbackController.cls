public class IND_FeedbackController {

/*********************************************************************************************************************** 
 Name: IND_FeedbackController
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class is controller for visualforcepage "feedback page". controlling the data in visualforce page and updating the data.                                        
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/ 
  id Trid;
 public Learning_Response_Result__c llr {get;set;}
 public Training__c tr {get;set;}
 public Boolean statusl{get;set;} 
 
 
    public IND_FeedbackController(ApexPages.StandardController controller) { 
    
    statusl=false;
    Trid=ApexPages.currentPage().getParameters().get('Id');
    If(trid != null){
       llr=[select id,Training__c,Training__r.Id,Feedback_Comment__c,Status_of_Participant__c,Feedback_Question_1_Response__c,Feedback_Question_2_Response__c,Feedback_Question_3_Response__c,Feedback_Question_4_Response__c,
               Feedback_Question_6_Response__c,Feedback_Question_5_Response__c from Learning_Response_Result__c where id=:Trid]; //AND User_Record_ID__c=:UserInfo.getUserid()];
               
       tr=[select id,Name_of_the_Trainer__c,name,Feedback_Question_1__c,Feedback_Question_2__c,Feedback_Question_3__c,Feedback_Question_4__c,Feedback_Question_5__c,Feedback_Question_6__c from training__c where id=:llr.Training__r.Id];       
     }  
       if(llr.Status_of_Participant__c=='Feedback Received')
       {
        statusl=true;
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'NOTE: We already received your Feedback. Here is your previous comment please add if you have any other comments.'));
            
       }
       
       
       
         
      }
   

     public List<SelectOption> getTypes1(){
          Schema.sObjectType sobject_type = Learning_Response_Result__c.getSObjectType();

          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
       
          List<Schema.PicklistEntry> pick_list_values = field_map.get('Feedback_Question_1_Response__c').getDescribe().getPickListValues();
          List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
            }
            return options;
         }  
     
     public List<SelectOption> getTypes2(){
          Schema.sObjectType sobject_type = Learning_Response_Result__c.getSObjectType();

          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
       
          List<Schema.PicklistEntry> pick_list_values = field_map.get('Feedback_Question_2_Response__c').getDescribe().getPickListValues();
          List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
            }
            return options;
         }  
         
     public List<SelectOption> getTypes3(){
          Schema.sObjectType sobject_type = Learning_Response_Result__c.getSObjectType();

          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
       
          List<Schema.PicklistEntry> pick_list_values = field_map.get('Feedback_Question_3_Response__c').getDescribe().getPickListValues();
          List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
            }
            return options;
         }  
       
    public List<SelectOption> getTypes4(){
          Schema.sObjectType sobject_type = Learning_Response_Result__c.getSObjectType();

          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
       
          List<Schema.PicklistEntry> pick_list_values = field_map.get('Feedback_Question_4_Response__c').getDescribe().getPickListValues();
          List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
            }
            return options;
         }   
       
    public List<SelectOption> getTypes5(){
          Schema.sObjectType sobject_type = Learning_Response_Result__c.getSObjectType();

          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
       
          List<Schema.PicklistEntry> pick_list_values = field_map.get('Feedback_Question_5_Response__c').getDescribe().getPickListValues();
          List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
            }
            return options;
         }  
       
       
    public List<SelectOption> getTypes6(){
          Schema.sObjectType sobject_type = Learning_Response_Result__c.getSObjectType();

          Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();

          Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
       
          List<Schema.PicklistEntry> pick_list_values = field_map.get('Feedback_Question_6_Response__c').getDescribe().getPickListValues();
          List<selectOption> options = new List<selectOption>();

           for (Schema.PicklistEntry a : pick_list_values) {
                      options.add(new selectOption(a.getLabel(), a.getValue()));
            }
            return options;
         }   
       
  Public PageReference SubmitFeedback()
  {
  llr.Status_of_Participant__c='Feedback Received';
       
  update llr;
  
  Pagereference page= new pagereference('/home/home.jsp');
  
  return (page);
  
  }   
 
       
       
}