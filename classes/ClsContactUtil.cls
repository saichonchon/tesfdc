/**
*   Contains a set of static methods used in send email
*
@author Lili Zhao
@created 2013-09-12
@version 1.0
@since 28.0 (Force.com ApiVersion)
*
@changelog
* 2013-09-12 Lili Zhao <lili.zhao@itbconsult.com>
* - Created  
*/ 
public class ClsContactUtil {
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************


    /**
    * This method is used to send  mass Email for Ext_Contact_sendMassEmail.class and Ext_Campaign_sendMassEmail.class 
    *
    @created 2013-09-12
    @version 1.0
    @since 28.0 (Force.com ApiVersion)
    *
    @changelog  
    * 2013-09-12 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */
    public static Messaging.SingleEmailMessage contactSendEmail(String targetObjectId,String name,String language) {
        Messaging.SingleEmailMessage   mail = new Messaging.SingleEmailMessage();
        
        //String    templateId = '00XE0000000y0Kf'; 
        String  templateId = getTemplateId(language);   
        mail.setSaveAsActivity(false); 
        mail.setTargetObjectId(targetObjectId);
        mail.setTemplateId(templateId); 
        mail.setSenderDisplayName(name);  
        
        return  mail;          
                   
    }
    /**
    * This method is used to Calculate the average NPS_Sore__c for Account when Contact.NPS_Score__c changed.It is used in trigger
    *
    @author     Jinbo Shan
    @created    2013-09-11  
    @version    1.0
    @since      23.0 (Force.com ApiVersion)
    *
    @param      contactIds
    *
    @return             
    *
    @changelog
    * 2013-09-11 Jinbo Shan <jinbo.shan@itbconsult.com>
    * - Created
    */
    public static void AVGForAccountNPSScoreOnContact(set<String> set_accountIds){   
         
        list<Account> list_updateAccounts = new list<Account>();
        list<Account> list_updateGAMAccounts = new list<Account>();
        set<String> set_gamcd = new set<String>();  
        map<String, Double> map_accountId_npss = new map<String, Double>();
        Date fromDate = System.Today().addMonths(-3).toStartOfMonth();
                
        if(!set_accountIds.isEmpty()) { 
            //************************* calculate the AVG of NPS_Score__c ***********************************************       
            for(AggregateResult contact : [Select AVG(NPS_Score__c) avg_NPSScore, AccountId  accId       
                                           From Contact                                               
                                           where AccountId IN :set_accountIds  
                                           and NPS_Score__c != null 
                                           and id in (Select contact__c  
                                                      From answer__c  
                                                      Where contact__r.accountId in : set_accountIds
                                                      And question__r.Name like '01%' 
                                                      And answer_date__c >=  :fromDate 
                                                      And contact__r.NPS_Score__c != null)  
                                           group by  AccountId ]){             
                 map_accountId_npss.put((String)contact.get('accId'),(Double)contact.get('avg_NPSScore'));                
             }
            //************************* set the NPS_Score__c of account as the AVG of NPS_Score__c and get the account if the GAMCD__c is not null******************
            if(!map_accountId_npss.isEmpty()){
                for(Account account : [SELECT NPS_Score__c, Id, GAMCD__c, Type 
                                       FROM Account 
                                       WHERE Id IN :map_accountId_npss.keySet()]){             
                    account.NPS_Score__c = map_accountId_npss.get(account.Id);
                    list_updateAccounts.add(account);
                    if(account.GAMCD__c != null){
                        set_gamcd.add(account.GAMCD__c);    
                    }               
                }            
            }
            
        }
        //************************* update the account list *********************************************** 
        if(!list_updateAccounts.isEmpty()){
            updateAccounts(list_updateAccounts);
        }
        //************************* get the Global Account list  *********************************************** 
        if(!set_gamcd.isEmpty()){
            list_updateGAMAccounts = getUpdateGAMAccounts(set_gamcd);
        }
        //************************* update the Global Account list  *********************************************** 
        if(!list_updateGAMAccounts.isEmpty()){
            updateAccounts(list_updateGAMAccounts); 
        }             
    }   
    /**
    * This method is used to update the batch accounts
    *
    @author     Lili Zhao
    @created    2013-09-24  
    @version    1.0
    @since      28.0 (Force.com ApiVersion)
    *
    @param      contactIds
    *
    @return             
    *
    @changelog
    * 2013-09-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */  
    public static void calculateAllAccountNPSScoreOnContact(set<String> set_accountIds){     
        
        list<Account> list_updateAccounts = new list<Account>();        
        map<String, Double> map_accountId_npss = new map<String, Double>();        
        map<String, date> map_accId_date = new map<String, date>();
        set<String> set_contactIds =  new set<String>();

        //************************* get the maxdate for each account ***********************************************
        for(AggregateResult aggr : [Select contact__r.accountId accId, max(answer_date__c) maxDate   
                                    From answer__c   
                                    Where contact__r.accountId in : set_accountIds  
                                    And question__r.Name like '01%'   
                                    Group by contact__r.accountId ]) {
            
            if(aggr.get('accId') != null) {
                map_accId_date.put((String)aggr.get('accId'), (Date) aggr.get('maxDate'));
            }                               
        }
        //************************* get the contact as the answer_date__c of answer__c object*************************
        for(AggregateResult aggr : [Select  contact__c contId, max(answer_date__c) maxDate, contact__r.accountId accId    
                                    From answer__c  
                                    Where contact__r.accountId in : set_accountIds 
                                    And question__r.Name like '01%'  
                                    And answer_date__c != null 
                                    Group by contact__r.accountId, contact__c ]) {
                                        
            if(aggr.get('accId') != null && map_accId_date.containsKey((String)aggr.get('accId')) ) {
                Date fromDate;
                fromDate = map_accId_date.get((String)aggr.get('accId')).addMonths(-3).toStartOfMonth();
                if((Date)aggr.get('maxDate') >= fromDate && aggr.get('contId') != null) {
                    set_contactIds.add((String) aggr.get('contId'));
                }
            }                           
        }        

        if(!set_contactIds.isEmpty()) {
            //************************* calculate the AVG of NPS_Score__c ***********************************************
            for(AggregateResult contact : [Select AVG(NPS_Score__c) avg_NPSScore, AccountId  accId       
                                           From Contact                                              
                                           where AccountId IN :set_accountIds  
                                           and NPS_Score__c != null 
                                           and id in : set_contactIds     
                                           group by  AccountId ]) {
                map_accountId_npss.put((String)contact.get('accId'), (Double)contact.get('avg_NPSScore'));           
            }
            //************************* set the NPS_Score__c of account as the AVG of NPS_Score__c************************
            if(!map_accountId_npss.isEmpty()){
                for(Account account : [SELECT NPS_Score__c, Id, GAMCD__c, Type 
                                       FROM Account 
                                       WHERE Id IN :map_accountId_npss.keySet()]){             
                    account.NPS_Score__c = map_accountId_npss.get(account.Id);
                    list_updateAccounts.add(account);               
                }            
            }
            //************************* update Account***********************************************               
            if(!list_updateAccounts.isEmpty()){
                updateAccounts(list_updateAccounts); 
            }           
        }                         
    }        
    /**
    * This method is used to update the batch GAM accounts
    *
    @author     Lili Zhao
    @created    2013-09-24  
    @version    1.0
    @since      28.0 (Force.com ApiVersion)
    *
    @param      contactIds
    *
    @return             
    *
    @changelog
    * 2013-09-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */  
    public static void calculateAllAccountGAMNPSScoreOnContact(set<String> set_gamcd){
        
        list<Account> list_updateGAMAccounts = new list<Account>(); 
        
        //************************* get the Global Account list  ***********************************************       
        list_updateGAMAccounts = getUpdateGAMAccounts(set_gamcd);
        //************************* update the Global Account list  *********************************************** 
        if(!list_updateGAMAccounts.isEmpty()) {
            updateAccounts(list_updateGAMAccounts);
        }                     
    }
      
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
    * This method is used to get the TemplateId for different language
    *
    @author     Lili Zhao
    @created    2013-09-24  
    @version    1.0
    @since      28.0 (Force.com ApiVersion)
    *
    @param      contactIds
    *
    @return             
    *
    @changelog
    * 2013-09-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */  
    private static String getTemplateId(String language) {
        String  templateId;     
        if(language == null && NPS_Settings__c.getInstance('Default TemplateId') != null && NPS_Settings__c.getInstance('Default TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('Default TemplateId').Value__c;
        }
        if(language == 'CN' && NPS_Settings__c.getInstance('CHS TemplateId') != null && NPS_Settings__c.getInstance('CHS TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('CHS TemplateId').Value__c;
        }
        if(language == 'CN_SIMPL' && NPS_Settings__c.getInstance('CHT TemplateId') != null && NPS_Settings__c.getInstance('CHT TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('CHT TemplateId').Value__c;
        }
        if(language == 'DE' && NPS_Settings__c.getInstance('DE TemplateId') != null && NPS_Settings__c.getInstance('DE TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('DE TemplateId').Value__c;
        }
        if(language == 'EN' && NPS_Settings__c.getInstance('EN TemplateId') != null && NPS_Settings__c.getInstance('EN TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('EN TemplateId').Value__c;
        }
        if(language == 'ES' && NPS_Settings__c.getInstance('ES TemplateId') != null && NPS_Settings__c.getInstance('ES TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('ES TemplateId').Value__c;
        }
        if(language == 'FR' && NPS_Settings__c.getInstance('FR TemplateId') != null && NPS_Settings__c.getInstance('FR TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('FR TemplateId').Value__c;
        }
        if(language == 'IT' && NPS_Settings__c.getInstance('IT TemplateId') != null && NPS_Settings__c.getInstance('IT TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('IT TemplateId').Value__c;
        }
        if(language == 'JP' && NPS_Settings__c.getInstance('JP TemplateId') != null && NPS_Settings__c.getInstance('JP TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('JP TemplateId').Value__c;
        }       
        if(language == 'KR' && NPS_Settings__c.getInstance('KO TemplateId') != null && NPS_Settings__c.getInstance('KO TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('KO TemplateId').Value__c;
        }
        if(language == 'PT' && NPS_Settings__c.getInstance('PT TemplateId') != null && NPS_Settings__c.getInstance('PT TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('PT TemplateId').Value__c;
        }
        if(language == 'RU' && NPS_Settings__c.getInstance('RU TemplateId') != null && NPS_Settings__c.getInstance('RU TemplateId').Value__c != null) {
            templateId = (String) NPS_Settings__c.getInstance('RU TemplateId').Value__c;
        }       
        return templateId;         
    }
   
    /**
    * This method is used to get the GAM accounts for update
    *
    @author     Lili Zhao
    @created    2013-09-24  
    @version    1.0
    @since      28.0 (Force.com ApiVersion)
    *
    @param      contactIds
    *
    @return             
    *
    @changelog
    * 2013-09-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */      
    private static list<Account> getUpdateGAMAccounts(set<String> set_gamcd) {
        
        list<Account> list_updateGAMAccounts = new list<Account>();     
        map<String, Double> map_gamcd_GAMnpss = new map<String, Double>();
        map<String, Integer> map_gamcd_GAMnum = new map<String, Integer>();  
              
        //************************* calculate the AVG of Global Account NPS_Score__c *****************************************
        for(AggregateResult account : [Select AVG(NPS_Score__c) avg_NPSScore,GAMCD__c gamcd   
                                       From Account    
                                       where GAMCD__c IN :set_gamcd 
                                       and Type != 'Global Account' 
                                       and NPS_Score__c != null 
                                       and GAMCD__c != null 
                                       group by  GAMCD__c ]){           
            map_gamcd_GAMnpss.put((String)account.get('gamcd'), (Double) account.get('avg_NPSScore'));               
        }
        
        //************************* set the NPS_Score__c of Global account as the AVG of NPS_Score__c************************
        if(!map_gamcd_GAMnpss.isEmpty()){        
            for(Account account : [SELECT NPS_Score__c, Id, GAMCD__c, Type 
                                   FROM Account 
                                   WHERE GAMCD__c IN :map_gamcd_GAMnpss.keySet() 
                                   and Type = 'Global Account']){                
                account.NPS_Score__c = map_gamcd_GAMnpss.get(account.GAMCD__c);
                list_updateGAMAccounts.add(account);                
            }        
        }   
        return  list_updateGAMAccounts;         
    }
    
    /**
    * This method is used to update the accounts
    *
    @author     Lili Zhao
    @created    2013-09-24  
    @version    1.0
    @since      28.0 (Force.com ApiVersion)
    *
    @param      contactIds
    *
    @return             
    *
    @changelog
    * 2013-09-24 Lili Zhao <lili.zhao@itbconsult.com>
    * - Created
    */  
    private static void updateAccounts(list<Account> list_accounts) {
        ClsSharingUtil.TriggerRecursionDefense = true;
        Database.update(list_accounts, false);  
        ClsSharingUtil.TriggerRecursionDefense = false;
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************  
}