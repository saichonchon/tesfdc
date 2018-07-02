/**
* 
*   This Before Insert Update Trigger sets Account sales hierarchy
*
*   Author              |Author-Email                       |Date        |Comment
*   --------------------|---------------------------------- |------------|-------------------------------------
*   Xia Tong            |xia.tong@itbconsult.com            |22.03.2013  |Initial Draft
*
*/

trigger Account_BIU_setSalesHierarchy on Account (before insert, before update) {
    Id rt_cis_gam = ClsSharingUtil.gamCustomSetting();
    Id rt_cis_account = ClsSharingUtil.accountCustomSetting();
    map<String, list<Account>> map_code_accounts = new map<String, list<Account>>();
    if(trigger.isInsert){
    	// added by lili 2013-10-08 trigger for account currency Begin
    	// this trigger is used to set the currency field of account as the field of Company_Reporting_Org__c 
    	ClsAccountUtil.setAccountCurrencyIsoCode(trigger.new);
    	// added by lili 2013-10-08 trigger for account currency  End
        for(Account a: trigger.new){
            a.Sales_Hierarchy_GAM__c = null;
            a.Sales_Hierarchy_MM__c = null;
            if(a.RecordTypeId == rt_cis_gam){
                
                if(a.Type == 'Global Account' && a.GAMCD__c != null){
                    if(!map_code_accounts.containsKey(a.GAMCD__c)){
                        map_code_accounts.put(a.GAMCD__c,new list<Account>());
                    }
                    map_code_accounts.get(a.GAMCD__c).add(a);
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                }else if(a.Type == 'Grouped B' && a.IND_KAM_Code__c != null){
                    if(!map_code_accounts.containsKey(a.IND_KAM_Code__c)){
                        map_code_accounts.put(a.IND_KAM_Code__c,new list<Account>());
                    }
                    map_code_accounts.get(a.IND_KAM_Code__c).add(a);
                }               
                /*
                else if(a.Type == 'Grouped B' && a.MKTMGRCDE__c != null){
                    if(!map_code_accounts.containsKey(a.MKTMGRCDE__c)){
                        map_code_accounts.put(a.MKTMGRCDE__c,new list<Account>());
                    }
                    map_code_accounts.get(a.MKTMGRCDE__c).add(a);
                }
                */
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//               
            }else if(a.RecordTypeId == rt_cis_account){
                if(a.GAMCD__c != null){
                    if(!map_code_accounts.containsKey(a.GAMCD__c)){
                        map_code_accounts.put(a.GAMCD__c,new list<Account>());
                    }
                    map_code_accounts.get(a.GAMCD__c).add(a);
                }
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                /*
                if(a.MKTMGRCDE__c != null){
                    if(!map_code_accounts.containsKey(a.MKTMGRCDE__c)){
                        map_code_accounts.put(a.MKTMGRCDE__c,new list<Account>());
                    }
                    map_code_accounts.get(a.MKTMGRCDE__c).add(a);
                }
                */                
                if(a.IND_KAM_Code__c != null){
                    if(!map_code_accounts.containsKey(a.IND_KAM_Code__c)){
                        map_code_accounts.put(a.IND_KAM_Code__c,new list<Account>());
                    }
                    map_code_accounts.get(a.IND_KAM_Code__c).add(a);
                }
                //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
            }   
        }  
          
    }else{  
    	// added by lili 2013-10-08 trigger for account currency Begin
    	// this trigger is used to set the currency field of account as the field of Company_Reporting_Org__c 
    	ClsAccountUtil.setAccountCurrencyIsoCode(trigger.new);
    	// added by lili 2013-10-08 trigger for account currency  End
        for(Account a: trigger.new){
            if(a.RecordTypeId != trigger.oldMap.get(a.Id).RecordTypeId || 
                a.Type != trigger.oldMap.get(a.Id).Type || 
                a.GAMCD__c != trigger.oldMap.get(a.Id).GAMCD__c || 
                //a.MKTMGRCDE__c != trigger.oldMap.get(a.Id).MKTMGRCDE__c || add lili 2013.11.6
                a.IND_KAM_Code__c != trigger.oldMap.get(a.Id).IND_KAM_Code__c || 
                a.Sales_Hierarchy_GAM__c != trigger.oldMap.get(a.Id).Sales_Hierarchy_GAM__c || 
                a.Sales_Hierarchy_MM__c != trigger.oldMap.get(a.Id).Sales_Hierarchy_MM__c){
                a.Sales_Hierarchy_GAM__c = null;
                a.Sales_Hierarchy_MM__c = null;
                if(a.RecordTypeId == rt_cis_gam){
                    if(a.Type == 'Global Account' && a.GAMCD__c != null){
                        if(!map_code_accounts.containsKey(a.GAMCD__c)){
                            map_code_accounts.put(a.GAMCD__c,new list<Account>());
                        }
                        map_code_accounts.get(a.GAMCD__c).add(a);
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                    }else if(a.Type == 'Grouped B' && a.IND_KAM_Code__c != null){
                        if(!map_code_accounts.containsKey(a.IND_KAM_Code__c)){
                            map_code_accounts.put(a.IND_KAM_Code__c,new list<Account>());
                        }
                        map_code_accounts.get(a.IND_KAM_Code__c).add(a);
                    }
                    /*
                    else if(a.Type == 'Grouped B' && a.MKTMGRCDE__c != null){
                        if(!map_code_accounts.containsKey(a.MKTMGRCDE__c)){
                            map_code_accounts.put(a.MKTMGRCDE__c,new list<Account>());
                        }
                        map_code_accounts.get(a.MKTMGRCDE__c).add(a);
                    }
                    */
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                }else if(a.RecordTypeId == rt_cis_account){
                    if(a.GAMCD__c != null){
                        if(!map_code_accounts.containsKey(a.GAMCD__c)){
                            map_code_accounts.put(a.GAMCD__c,new list<Account>());
                        }
                        map_code_accounts.get(a.GAMCD__c).add(a);
                    }
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  begin****//
                    /*
                    if(a.MKTMGRCDE__c != null){
                        if(!map_code_accounts.containsKey(a.MKTMGRCDE__c)){
                            map_code_accounts.put(a.MKTMGRCDE__c,new list<Account>());
                        }
                        map_code_accounts.get(a.MKTMGRCDE__c).add(a);
                    }
                    */
                    if(a.IND_KAM_Code__c != null){
                        if(!map_code_accounts.containsKey(a.IND_KAM_Code__c)){
                            map_code_accounts.put(a.IND_KAM_Code__c,new list<Account>());
                        }
                        map_code_accounts.get(a.IND_KAM_Code__c).add(a);
                    }
                    //****** add lili 2013.11.06, Replace codes MKTMGRCDE__c with IND_KAM_Code__c  end****//
                }
            }
        }
       
    }
    if(!map_code_accounts.isEmpty()){
        ClsSharingUtil.setAccountSalesHierarchy(map_code_accounts);
    } 
}