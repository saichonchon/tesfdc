public class IND_Coaching_PDF_Controller {

    Public id Coachingid{get;set;} 
    Public List<Coaching_Topics__c> Topic{get;set;} 
    
    
    public IND_Coaching_PDF_Controller(ApexPages.StandardController controller) {
    
      Coachingid=ApexPages.currentPage().getParameters().get('Id'); 
      
      Topic=[Select id,name,Account__r.name,Account_Plan__r.name,Contact__r.name,Coaching_Result__c,Content_Type__c,Follow_up_Activity__c,Follow_up_Activity_Result__c,Topic__c,Topic_Detail__c,
      Topic_Text_Long__c,View__c,Opportunity__r.name,Call_Plan__r.name,Highlight_Lowlight__r.name from Coaching_Topics__c where Coaching_Record__c=:Coachingid];
       

    }

}