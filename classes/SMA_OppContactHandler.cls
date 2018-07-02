public class SMA_OppContactHandler{

public static void OppContactRole(list <Opportunity> opps){
list<OpportunityContactRole > listOppConRole = new list<OpportunityContactRole>();
    list<string>contacIds=new list<string>();
    string selContacts ;
    string primaryCon;
    string contactRole;
    string userid;
    userid = userinfo.getUserId();
    //--here featch the customsetting value --
    List<OppotunityContactRoletemp__c> cs = [Select UserId__c,PrimaryId__c,Role__c,SlectedContacts__c from OppotunityContactRoletemp__c where UserId__c =: userid limit 1];
    OppotunityContactRoletemp__c opcon;
    if(cs.size() > 0){
        opcon = cs[0];
    }
    //OppotunityContactRoletemp__c cs = [Select UserId__c,PrimaryId__c,Role__c,SlectedContacts__c from OppotunityContactRoletemp__c where UserId__c =: userid limit 1];
    
        //OppotunityContactRole__c.getInstance(userinfo.getUserId());
    system.debug('===cs===>'+cs);
     if(opcon!=null){
        selContacts= opcon.SlectedContacts__c;
        primaryCon=opcon.PrimaryId__c;
        contactRole=opcon.Role__c;
        system.debug('Primary'+opcon.PrimaryId__c);
        system.debug('Role>>>'+opcon.Role__c);
    }
    system.debug('===selContacts===>'+selContacts);
    for (Opportunity opp:opps){
        if(selContacts!= null){  
            for (String str : selContacts.split(';')){
                System.debug('****str '+str);
                if (str != null && str != ''){
                    OpportunityContactRole oppConRole = new OpportunityContactRole(); 
                    oppConRole.OpportunityId = opp.Id;
                    oppConRole.Role=opcon.Role__c;
                    // str=str.substring(0, 15);
                    oppConRole.ContactId = Id.valueOf(str);
                    string primaryId=primaryCon.trim();
                    //if(primaryCon !=Null)                     
                    system.debug('===str===>'+str);
                    // if (opp.OpportunityContactRole_Contacts_Primary__c != null && opp.OpportunityContactRole_Contacts_Primary__c != '' 
                    //&& primaryId==str.substring(0, 15))
                    if(primaryId==str.substring(0, 15)){ // Here compare 15 digit id with selected contact
                        oppConRole.IsPrimary = true; 
                    }else if(primaryId==str){ // Here compare 18 digit id with selected contacts
                        oppConRole.IsPrimary = true; 
                                           }
                    listOppConRole.add(oppConRole);
                }
            }
        }
        
    }
    
    if (!listOppConRole.isEmpty()){
        system.debug('===crole===>'+listOppConRole);
        insert listOppConRole;
        opcon.clear();
    }
    }
 }