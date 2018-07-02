/**
*trigger used to Reset the Reportsto field of child contacts when its parent contact is set to be 'inActive'
*1.When the parent contact reports to other contact, then its child contacts should all report to the superior one.
*2.When the parent contact doesn't reports to other contact, then its child contacts should all be set to null.
*
*
@author Juillet Yuan
@created 2014-08-29
@version 1.1
@since 31.0
*
@changelog
2014-08-29 Juillet Yuan<juillet.yuan@itbconsult.com>
*-Created
2016-07-13 Rajendra Shahane<rajendra.shahane@zensar.com>
*-Modified trigger for case 900944
*/
trigger Contact_AU_changeSubReportsTo on Contact (after update) {
    
    /**
    * the map which contains all the contacts needed to be processed and their own corresponding children
    */
    map<id,set<Contact>> map_contId_setChildConts = new map<id,set<Contact>>();
    
    /**
    * the map which contains all the contacts that need to be processed
    */
    map<id,Contact> map_contId_Cont = new map<id,Contact>();
    
    /**
    * the map which contains all the child contacts to be updated at the end of this trigger
    */
    list<Contact> list_contact_toUpdate = new list<Contact>();
    
    
    //get all the contact that need to be processed
    for(Contact cont :trigger.new){
        if(cont.Inactive__c == true){
            map_contId_Cont.put(cont.id,cont);
        }
    }
    //added by Bhavya
    if(map_contId_Cont.size()>0){   
    //get the contact->set_childContact map   
    for(Contact contChild : [select Id, ReportsToId from Contact where ReportsToId in :map_contId_Cont.keySet()]){
        if(!map_contId_setChildConts.containsKey(contChild.ReportsToId)){
            map_contId_setChildConts.put(contChild.ReportsToId,new set<Contact>());
        }
        if(map_contId_setChildConts.containsKey(contChild.ReportsToId)){
            map_contId_setChildConts.get(contChild.ReportsToId).add(contChild);
        }
    }
    }
    //main process
    for(Id contId: map_contId_Cont.keySet()){
        //if the contact reports to someone and the contact has a set of children
        if(map_contId_Cont.get(contId).ReportsToId != null&&map_contId_setChildConts.containsKey(contId)){
            for(Contact sub: map_contId_setChildConts.get(contId)){
                if(sub.ReportsToId != map_contId_Cont.get(contId).ReportsToId)//Added by Rajendra for case 900944
                {//Added by Rajendra for case 900944
                    sub.ReportsToId = map_contId_Cont.get(contId).ReportsToId;
                    list_contact_toUpdate.add(sub);
                }//Added by Rajendra for case 900944
            }   
        }
        //if the contact reports to no one and the contact has a set of children
        else if(map_contId_Cont.get(contId).ReportsToId == null && map_contId_setChildConts.containsKey(contId)){
            for(Contact sub: map_contId_setChildConts.get(contId)){
                if(sub.ReportsToId != map_contId_Cont.get(contId).ReportsToId)//Added by Rajendra for case 900944
                if(sub.ReportsToId != null)//Added by Rajendra for case 900944
                {//Added by Rajendra for case 900944
                    sub.ReportsToId = null;
                    list_contact_toUpdate.add(sub);
                }//Added by Rajendra for case 900944
            }
        }
    }
    //update
    if(list_contact_toUpdate.size()>0){
        update list_contact_toUpdate;
    }
}