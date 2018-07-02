/**
 *  The controller for vf page ExtOpportunityPartnerEntry
 *
 @author Yinfeng Guo
 @created 2012-03-09
 @version 1.0
 @since 23.0 (Force.com ApiVersion)
 *
 @changelog
 * 2012-03-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 */
public without sharing class ExtOpportunityPartnerEntry {

    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public Opportunity_Partner__c oppPartner { set; get; }
    public list<PartnerInnerClass> list_oppyPartners{get;set;} 
    public String subtitle { set; get; }
    
    public Integer addAmount{get;set;}
    public Integer deleteParterIndex{get;set;}
    public Integer selectedIndex{get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private final ApexPages.standardController stdCtrl;
    private Id oppId;
    private map<Id, Opportunity_Partner__c> map_sync_Id_OppyPartners ;
    private Boolean saveCompleted;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
    * The contsructor
    *
    @author Yinfeng Guo
    @created 2012-03-09
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-03-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */
    public ExtOpportunityPartnerEntry(ApexPages.standardController stdCtrl) {

        this.stdCtrl = stdCtrl;
        
        oppPartner = (Opportunity_Partner__c)stdCtrl.getRecord();
        
        if(oppPartner.Id != null){
            subtitle =  system.Label.Edit_Opportunity_Partner;
            for(Opportunity_Partner__c op : [SELECT Id, Opportunity__c, Account__c, Partner_Role__c, Primary__c, Allocation__c FROM Opportunity_Partner__c WHERE Id =: oppPartner.Id]){
                oppPartner = op;
            }
            this.oppId = oppPartner.Opportunity__c;
        }
        else{
            subtitle =  system.Label.New_Opportunity_Partner;
            if(oppPartner.Opportunity__c != null){
                this.oppId = oppPartner.Opportunity__c;
            }
        }
        
        list_oppyPartners = new list<PartnerInnerClass>();
        map_sync_Id_OppyPartners = new map<Id, Opportunity_Partner__c>();
        
        saveCompleted = false;
        GetAllOpportunityPartner();
        
    }
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    /**
     * This method is used to quick save, that's to say save but not back to the opportunity page
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            null
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public PageReference QuickSave(){
        ApexPages.getMessages().clear();    
        list<Opportunity_Partner__c> list_oppyPartner2Update = new list<Opportunity_Partner__c>();
        list<Opportunity_Partner__c> list_oppyPartner2Insert = new list<Opportunity_Partner__c>();
        set<Id> set_accIds2Save = new set<Id>();
        ClsOppyPartUtil.needCheckAlloc = true;
        Savepoint sp = Database.setSavepoint();

        Id IdOpportuntiySalesChannel;
        id idAccountSalesChannel;
        boolean isPOSpartnerDefined = false;
        for(PartnerInnerClass pic : list_oppyPartners){
            if(pic.opc.Account__c != null && String.valueOf(pic.opc.Account__c) != ''){
                if(pic.opc.Partner_Role__c == null || pic.opc.Partner_Role__c ==''){
                    
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Partner Role: You must enter a value')); 
                    ResetList();     
                    return null;
                }
                if(!set_accIds2Save.contains(pic.opc.Account__c)){
                    if(pic.opc.Id != null){
                        set_accIds2Save.add(pic.opc.Account__c);
                        list_oppyPartner2Update.add(pic.opc);
                        map_sync_Id_OppyPartners.remove(pic.opc.Id);    
                    }
                    else{
                        set_accIds2Save.add(pic.opc.Account__c);
                        list_oppyPartner2Insert.add(pic.opc);
                    }
                    IdOpportuntiySalesChannel = pic.opc.Opportunity__c;
                    if(pic.opc.Partner_Role__c == 'POS')
                    {
                        isPOSpartnerDefined = true;
                        idAccountSalesChannel = pic.opc.Account__c;
                    }
                }
            }
        }
        if(idAccountSalesChannel != null && IdOpportuntiySalesChannel != null)
        {
            //try
            //{
                Apex_Helper_Settings__c RTSalesChannelOppy = Apex_Helper_Settings__c.getInstance('Sales Opportunity Channel');
                Opportunity oOpportunity = [select id, NDR_POS_Customer_Country__c, NDR_POS_Customer_Account_Number__c, NDR_POS_Customer_City__c, NDR_POS_Customer_Street__c, recordtypeid from Opportunity where id = :IdOpportuntiySalesChannel];
                if(RTSalesChannelOppy != null && oOpportunity.Recordtypeid == (id)RTSalesChannelOppy.value__c)
                {
                    if(isPOSpartnerDefined )
                    {
                        Account oAccount = [select id, AccountNumber, name, Customer_Region__c, Account_Manager_Name__c, BillingCity, BillingCountry, BillingStreet from account where id =:idAccountSalesChannel];
                        if(oOpportunity.NDR_POS_Customer_Street__c != oAccount.BillingStreet || oOpportunity.NDR_POS_Customer_City__c != oAccount.BillingCity || oOpportunity.NDR_POS_Customer_Account_Number__c != oAccount.AccountNumber || oOpportunity.NDR_POS_Customer_Country__c != oAccount.BillingCountry)
                        {
                            oOpportunity.NDR_POS_Customer_Street__c = oAccount.BillingStreet;
                            oOpportunity.NDR_POS_Customer_City__c = oAccount.BillingCity;
                            oOpportunity.NDR_POS_Customer_Account_Number__c = oAccount.AccountNumber;
                            oOpportunity.NDR_POS_Customer_Country__c = oAccount.BillingCountry;
                            oOpportunity.NDR_POS_Customer_Name__c = oAccount.Name;
                            oOpportunity.NDR_POS_Customer_Region__c = oAccount.Customer_Region__c;
                            oOpportunity.NDR_POS_Customer_Sales_Engineer_s_Name__c = oAccount.Account_Manager_Name__c;
                            update oOpportunity;
                        }
                    }
                    else
                    {
                        oOpportunity.NDR_POS_Customer_Street__c = '';
                        oOpportunity.NDR_POS_Customer_City__c = '';
                        oOpportunity.NDR_POS_Customer_Account_Number__c = '';
                        oOpportunity.NDR_POS_Customer_Country__c = '';
                        oOpportunity.NDR_POS_Customer_Name__c = '';
                        oOpportunity.NDR_POS_Customer_Region__c = '';
                        oOpportunity.NDR_POS_Customer_Sales_Engineer_s_Name__c = '';
                        update oOpportunity;                    
                    }
                }
            //}catch(exception ex){System.debug('POS Update failed' + ex);}
        }
        if(!list_oppyPartner2Update.isEmpty() || !list_oppyPartner2Insert.isEmpty() || !map_sync_Id_OppyPartners.isEmpty()) {
            try {
                // delete partner               
                if(!map_sync_Id_OppyPartners.isEmpty()) {
                    if(!list_oppyPartner2Update.isEmpty() || !list_oppyPartner2Insert.isEmpty()) ClsOppyPartUtil.needCheckAlloc = false;
                    delete map_sync_Id_OppyPartners.values();
                }
                // update partner
                ClsOppyPartUtil.needCheckAlloc = true;                
                if(!list_oppyPartner2Update.isEmpty()) {
                    if(!list_oppyPartner2Insert.isEmpty()) ClsOppyPartUtil.needCheckAlloc = false;
                    
                    ClsOppyPartUtil.needCriteria = false;
                    update list_oppyPartner2Update;
                    ClsOppyPartUtil.needCriteria = true;
                }
                // insert partner
                ClsOppyPartUtil.needCheckAlloc = true;                  
                if(!list_oppyPartner2Insert.isEmpty()) insert list_oppyPartner2Insert;
                
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, system.Label.Save_Completed));  
                saveCompleted = true;
            } 
            catch (DmlException e) {
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getDmlMessage(i)));
                    Database.rollback(sp);
                    ResetList();    
                    return null;
                }
            }
        }
        //list_oppyPartners = new list<PartnerInnerClass>();
        //GetAllOpportunityPartner();
        ResetList();
        return null;
    }
    /**
     * This method is used to save and back to the opportunity page
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            null or the opportunity page
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public PageReference SaveAndReturn(){
        saveCompleted = false;
        QuickSave();
        if(saveCompleted == true) return new pageReference('/'+oppId);
        else return null;
    }
    
    /**
     * This method is used to delete opportunity partner
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            the return Amounts option list
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public void DeleteOpportunityPartner(){
        if(deleteParterIndex != null){
            list_oppyPartners.remove(deleteParterIndex);
        }
        list<PartnerInnerClass> list_opNew = new list<PartnerInnerClass>();
        for(PartnerInnerClass p : list_oppyPartners){
            PartnerInnerClass pic = new PartnerInnerClass();
            pic.opc = p.opc;
            pic.index = list_opNew.size();
            pic.accountName = p.accountName;
            list_opNew.add(pic);
        }
        list_oppyPartners = new list<PartnerInnerClass>();
        list_oppyPartners = list_opNew;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, system.Label.Delete_After_Save_Partner));
        ResetList();
    }
    /**
     * This method is used to add partners
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            the return Amounts option list
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public void AddPartners(){
        for(Integer i = 0; i < addAmount; i++){
            PartnerInnerClass pic = new PartnerInnerClass();
            Opportunity_Partner__c op = new Opportunity_Partner__c();
            op.Opportunity__c = oppId;
            
           // Prabhanjan: 03/21/2016: Case# 00900686 : Adding default value 'POS' for Channel users.
            String UserRoleId = userinfo.getUserRoleId();
            String RoleName='';
            if(UserRoleId<>null)     RoleName=[Select Id,Name from UserRole where Id=:UserRoleId].Name;
            if(RoleName.contains('Channel'))     op.Partner_Role__c ='POS';
           //// Prabhanjan: 03/21/2016: Case# 00900686 : End of Change 
            pic.opc = op;
            pic.accountName = '';
            pic.index = list_oppyPartners.size();
            list_oppyPartners.add(pic);
        }
        ResetList();
    }
    /**
     * This method is used to reset opportunity partner list
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            the return Amounts option list
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    private void ResetList(){
        map_sync_Id_OppyPartners = new map<Id, Opportunity_Partner__c>();
        for(Opportunity_Partner__c op : [select Id, Opportunity__c, Account__c, Account__r.Name, Partner_Role__c, Primary__c, Allocation__c FROM Opportunity_Partner__c where Opportunity__c =: oppId]){
            map_sync_Id_OppyPartners.put(op.Id,op);
        }
        
        set<Id> set_partnerIds = new set<Id>();
        map<Id, String> map_accId_accName = new map<Id, String>();
        for(PartnerInnerClass pic : list_oppyPartners){
            if(pic.opc.Account__c != null && String.valueOf(pic.opc.Account__c) != '') set_partnerIds.add(pic.opc.Account__c);
        }
        for(Account a : [select Id, Name from Account where Id in: set_partnerIds]){
            map_accId_accName.put(a.Id, a.Name);            
        }
        set<Id> set_accIds = new set<Id>();
        list<PartnerInnerClass> list_opNew = new list<PartnerInnerClass>();
        for(PartnerInnerClass pic : list_oppyPartners){
            if(pic.opc.Account__c != null && String.valueOf(pic.opc.Account__c) != '') {
                pic.accountName = map_accId_accName.get(pic.opc.Account__c);
                if(saveCompleted == true && !set_accIds.contains(pic.opc.Account__c)){
                    set_accIds.add(pic.opc.Account__c);
                    
                    PartnerInnerClass picNew = new PartnerInnerClass();
                    picNew.opc = pic.opc;
                    picNew.index = list_opNew.size();
                    picNew.accountName = pic.accountName;
                    //picNew.accountName = pic.accountName;
                    list_opNew.add(picNew);
                } 
            }
            else if(saveCompleted == true){
                PartnerInnerClass picNew = new PartnerInnerClass();
                picNew.opc = pic.opc;
                picNew.index = list_opNew.size();
                //picNew.accountName = pic.accountName;
                list_opNew.add(picNew);
            }
        }
        if(saveCompleted == true){
            list_oppyPartners = new list<PartnerInnerClass>();
            list_oppyPartners = list_opNew;
        }
    }
    
    /**
     * This method is used to get select list for the amount the user want to add partner
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            the return Amounts option list
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public List<SelectOption> getAmounts() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('1', '1'));
        options.add(new SelectOption('2', '2'));
        options.add(new SelectOption('3', '3'));
        options.add(new SelectOption('4', '4'));
        options.add(new SelectOption('5', '5'));
        options.add(new SelectOption('6', '6'));
        options.add(new SelectOption('7', '7'));
        options.add(new SelectOption('8', '8'));
        options.add(new SelectOption('9', '9'));
        options.add(new SelectOption('10', '10'));
        return options;
    }
    
    /**
     * This method is used to check the duplicate partner
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            the return Amounts option list
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    public void checkDuplicatePartner() {
        Set<String> set_accountId = new Set<String>();
        for(PartnerInnerClass pic : list_oppyPartners){
            if(pic.index != selectedIndex && pic.opc.Account__c != null && String.valueOf(pic.opc.Account__c) != '') set_accountId.add(pic.opc.Account__c);
        }
        for(PartnerInnerClass pic : list_oppyPartners){
            if(selectedIndex != null && pic.index == selectedIndex){
                if(pic.opc.Account__c != null && set_accountId.contains(pic.opc.Account__c) && String.valueOf(pic.opc.Account__c) != '') {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Opportunity_Partner_Exist));
                    pic.opc.Account__c = null;
                    pic.accountName = '';
                }               
                break;
            }
        }
        ResetList();
    }
    
    /**
     * This method is used to save Opportunity_Partner__c
     *
     @author Yinfeng Guo
     @created 2012-03-09
     @version 1.0
     @since 23.0
     *
     @return            new pageReference('/'+proId);
     *
     @changelog
     * 2012-03-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */  
     /*   
    public PageReference saveOppPartner() {
        
        Opportunity_Partner__c exist = new Opportunity_Partner__c();
        for(Opportunity_Partner__c o : [SELECT Id, Opportunity__c, Account__c FROM Opportunity_Partner__c WHERE Opportunity__c =: oppId and Account__c =: oppPartner.Account__c]){
            exist = o;
        }
        if(exist.Id == null || exist.Id == oppPartner.Id){
            try{
                upsert oppPartner;
                return new pageReference('/'+oppId);
            }
            catch( Exception e ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Allocation_Error  ));
                return null;
            }
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Opportunity_Partner_Exist  ));
            return null;
        }
    }
    */
    
    
    /**
     * This method is used to save and new Opportunity_Partner__c
     *
     @author Yinfeng Guo
     @created 2012-03-09
     @version 1.0
     @since 23.0
     *
     @return            null
     *
     @changelog
     * 2012-03-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */    
     /*
    public PageReference saveandnewOppPartner() {

        Opportunity_Partner__c exist = new Opportunity_Partner__c();
        for(Opportunity_Partner__c o : [SELECT Id, Opportunity__c, Account__c FROM Opportunity_Partner__c WHERE Opportunity__c =: oppId and Account__c =: oppPartner.Account__c]){
            exist = o;
        }
        if(exist.Id == null){
            try{
                upsert oppPartner;
                //oppPartner = new  Opportunity_Partner__c();
                return null;
            }
            catch( Exception e ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Allocation_Error  ));
                return null;
            }
        }
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, system.Label.Opportunity_Partner_Exist  ));
            return null;
        }
    }
    */
    
    /**
     * This method is used to cancel create new Opportunity_Partner__c
     *
     @author Yinfeng Guo
     @created 2012-03-09
     @version 1.0
     @since 23.0
     *
     @return            new pageReference('/'+oppId);
     *
     @changelog
     * 2012-03-09 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */
    public PageReference cancel() {
        return new pageReference('/'+oppId);
    }

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
     * This method is used to get all opportunity partners according to the Opportunity Id
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            void
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */ 
    private void GetAllOpportunityPartner(){
        for(Opportunity_Partner__c op : [select Id, Opportunity__c, Opportunity__r.recordtypeid, Account__c, Account__r.Name, Partner_Role__c, Primary__c, Allocation__c, Account__r.AccountNumber, Account__r.billingcity, Account__r.billingstreet, Account__r.billingcountry FROM Opportunity_Partner__c where Opportunity__c =: oppId]){
            map_sync_Id_OppyPartners.put(op.Id,op);
            PartnerInnerClass pic = new PartnerInnerClass();
            pic.opc = op;
            pic.accountName = op.Account__r.Name;
            pic.index = list_oppyPartners.size();
            list_oppyPartners.add(pic);
        }
    }    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    /**
     * Inner class contains Opportunity Partner
     *
     @author Yin Feng
     @created 2012-06-15
     @version 1.0
     @since 23.0
     *
     @return            void
     *
     @changelog
     * 2012-06-15 Yinfeng Guo <yinfeng.guo@itbconsult.com>
     * - Created
     */     
    public class PartnerInnerClass{
        public Opportunity_Partner__c opc{get;set;}
        public Integer index{get;set;}
        public String accountName{get;set;}
    }
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}