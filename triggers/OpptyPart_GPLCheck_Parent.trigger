trigger OpptyPart_GPLCheck_Parent on Opportunity_Part__c (before insert, before update) {

    Set<Id> RecTypeSet = new Set<Id>();
    Map<String, Consumer_Device_Opportunity_Record_Types__c> ConsumerMap = Consumer_Device_Opportunity_Record_Types__c.getall();
    

    Set<Id> InsOpty = new Set<Id>();
    Map<Id, Id> InsOppyGplMap = new Map<Id, Id>();
    Map<Id, Opportunity_Part__c> ErrorOppyGplMap = new Map<Id, Opportunity_Part__c>();
    Set<id> PartIds = new Set<id>();
    
    Id SalesId = ConsumerMap.get('Sales_Parts').Record_Type_Id__c;
    Id NewDevId = ConsumerMap.get('New_Development').Record_Type_Id__c;
    Id CSDEngOppyRT = ConsumerMap.get('Engineering_Opportunity_CSD').Record_Type_Id__c;
    Id CSDSalesOppyRT = ConsumerMap.get('Sales_Opportunity_CSD').Record_Type_Id__c;    
    
    for(Opportunity_Part__c O:trigger.new){
        
        //system.debug ('***** ' + O.Opportunity_Record_Type__c + ' ' + SalesId + ' ' + NewDevId);
        //system.debug ('***** ' + ConsumerMap.containskey(O.Opportunity_Record_Type__c));
        //system.debug(' ***** ' + (SalesId == O.recordtypeid || NewDevId == O.recordtypeid));
                
        if((O.Opportunity_Record_Type__c == CSDEngOppyRT) && (SalesId == O.recordtypeid || NewDevId == O.recordtypeid)){
            if(InsOppyGplMap.Containskey(O.Opportunity__c)){
                if(InsOppyGplMap.get(O.Opportunity__c)!=O.GPL__c){
                    O.addError('Selected GPL should be same as existing GPL in Opportunity Part!');
                }
            }
            else{
                InsOppyGplMap.put(O.Opportunity__c, O.GPL__c);
            }
            InsOpty.add(O.Opportunity__c);
            ErrorOppyGplMap.put(O.Opportunity__c, O);
            if(trigger.isupdate){
                PartIds.add(O.id);
            }
        }
    }
    if(InsOpty.size()>0){
         List<Opportunity_Part__c> Oppart=[Select id, GPL__c,Opportunity__c, Opportunity__r.Name from Opportunity_Part__c where Opportunity__c IN :InsOpty];
         for(Opportunity_Part__c O:Oppart){
             if(ErrorOppyGplMap.containskey(O.Opportunity__c)){
                 if(ErrorOppyGplMap.get(O.Opportunity__c).GPL__c!=O.GPL__c && (!PartIds.contains(O.id))){
                     ErrorOppyGplMap.get(O.Opportunity__c).addError('Selected GPL should be same as existing GPL in Opportunity Part!');
                 }   
             }
         }
    }    
}