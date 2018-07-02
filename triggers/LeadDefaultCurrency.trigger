trigger LeadDefaultCurrency on Lead (before insert,before update) {
    
    Set<Id> userIdSet = new Set<Id>();
    
    for(Lead l : trigger.new){
        userIdset.add(l.ownerId);
    }
    
    Map<Id,User> userMap = new Map<Id,User>([select Id, DefaultCurrencyIsoCode from User where id in: userIdSet]);
    
    for(Lead l : trigger.new){
        if(userMap.get(l.ownerId) != null){
            l.default_currency__c = userMap.get(l.ownerId).DefaultCurrencyIsoCode;
        }else{
            l.default_currency__c = '';
        }
    }
}