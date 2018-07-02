/**************************************************************************************************************************************************
Name: OpportunityStageValidation 
Copyright Â© 2011 TE Connectivity
===================================================================================================================================================
Purpose: This trigger validates the Opportunity with various conditions                                              
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Ramakrishna Singara   30/06/2013 Initial Development                                 
    1.1 Ramakrishna Singara   22/11/2013 Updated the trigger for Optimization - for Query row exception                                         
    1.2 Shreyas M             02/12/2013 Updated the trigger for Fulfillment Region value update  
    1.3 Nelson Zheng          04/13/2015 Updated the trigger for Currency Confirm
    1.4 Padmaja Dadi          06/09/2015 Updated DND Opportunity record type for DND merge project  
    1.5 Sanghita Das          10/02/2016 Changed phase name from 'Order Received or Mass Production' with 2 spaces between the words Received and or To "Order Received or Mass Production" # Case 00900395
**************************************************************************************************************************************************/
trigger OpportunityStageValidation on Opportunity (before insert, after update,before update){

    //Set<Id> RecTypeIdSet = new Set<Id>();
    
    //Modified by Chiranjeevi Neelam on 23-03-2014
    //To avoid null point exceptions in batch excecutions
    Batch_Helper_Settings__c ExcBhsetng = Batch_Helper_Settings__c.getOrgDefaults();
    Id CustSetngId=ExcBhsetng.Batch_Valid_User__c;
    
    Map<id, String> RTMap = new Map<Id, String>();
    Map<String, Consumer_Device_Opportunity_Record_Types__c> ConsumerMap = Consumer_Device_Opportunity_Record_Types__c.getall();
    Map<String, Opportunity_Record_Type_Groups__c> OppRtMap = Opportunity_Record_Type_Groups__c.getall(); //DND
    RTMap.put(ConsumerMap.get('Engineering Opportunity-CSD').Record_Type_Id__c, ConsumerMap.get('Engineering Opportunity-CSD').Name);
    RTMap.put(ConsumerMap.get('Sales Opportunity-CSD').Record_Type_Id__c, ConsumerMap.get('Sales Opportunity-CSD').Name);
    Apex_Helper_Settings__c RTSalesOppyChaannel = Apex_Helper_Settings__c.getInstance('Sales Opportunity Channel');
    Apex_Helper_Settings__c RTEnggOppyChaannel = Apex_Helper_Settings__c.getInstance('Engineering Opportunity Channel');
    if(OppRtMap.get('DND Opportunity')!=null)RTMap.put(OppRtMap.get('DND Opportunity').RecordTypeID__c,OppRtMap.get('DND Opportunity').Name); //DND
     if(ClsOppyUtil.runUser == null) {
        ClsOppyUtil.runUser = new User();
        ClsOppyUtil.runUser = [select id, CSD_Region__c,GIBU__c from user where id =:  UserInfo.getUserId()];
    }
    User usr = new User();
    usr = ClsOppyUtil.runUser; 
    //Map<Id, Id> OptyValidationMap = new Map<Id, Id>();
    //Map<id, Opportunity_Part__c> OM= new Map<id, Opportunity_Part__c>();
    List<Opportunity> vListOpp = new List<Opportunity>();
    
    /*----------Opportunity Stage vs Forecast Validation Starts here------------*/
    static Map<Id, integer> FTMap = new Map<Id, integer>();
    
    Set<Id> CSDOppRecTypeSet = new Set<id>();
    map<id, list<opportunity>> mapAccountIDSalesNenggOppy = new map<id, list<opportunity>>();
    list<id> listSalesNenggOppy = new list<id>();
	Id salesOppyRtId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Energy - Sales').getRecordTypeId();
    
    for(Opportunity OPP:trigger.new){
        if(trigger.isbefore && trigger.isinsert && OPP.Type__c != null){
            OPP.Type = OPP.Type__c;//this is added for CLR requirement
            OPP.Description = opp.Description__c + ' ' + OPP.Comments__c;
            //opp.Description__c = '';
        }
            
        if(RTMap.keySet() != null && RTMap.containsKey(OPP.RecordTypeId)){   
                CSDOppRecTypeSet.add(OPP.id);
                vListOpp.add(OPP);
        }

        if(((RTSalesOppyChaannel != null && OPP.recordtypeid == RTSalesOppyChaannel.value__c) || (RTEnggOppyChaannel != null && OPP.recordtypeid == RTEnggOppyChaannel.value__c) ))
        {
            if( OPP.POS_Customer_is_same_as_Account__c && (trigger.isInsert || !trigger.oldmap.get(OPP.Id).POS_Customer_is_same_as_Account__c))
            {
                if(mapAccountIDSalesNenggOppy.containsKey(OPP.AccountID))
                    mapAccountIDSalesNenggOppy.get(OPP.AccountID).add(OPP);
                else
                    mapAccountIDSalesNenggOppy.put(OPP.AccountID, new list<opportunity>{OPP});
            }
            listSalesNenggOppy.add(OPP.id);
        }
    }
    if(mapAccountIDSalesNenggOppy.size() > 0 && Trigger.isBefore)
    {
        if(trigger.isupdate)
        {
            set<Id> oppIdsWithPOS = new set<Id>();
            for(opportunity_partner__c op : [select opportunity__c from opportunity_partner__c where opportunity__c in :listSalesNenggOppy and Partner_Role__c = 'POS' ])
                 oppIdsWithPOS.add(op.opportunity__c);                                   
            for(id IdChnlslsNengg : listSalesNenggOppy)
            {
                Opportunity o = trigger.newmap.get(IdChnlslsNengg);
                if(!oppIdsWithPOS.contains(o.Id) && o.createddate>=date.valueOf('2016-07-06')) 
                    o.addError('Please add POS before making changes to opportunity!!!');
            }
        }
        for(Account oAccount :[select id, AccountNumber, name, Customer_Region__c, Account_Manager_Name__c, BillingCity, BillingCountry, BillingStreet from account where id in :mapAccountIDSalesNenggOppy.Keyset()])
        {
            for(Opportunity oOpportunity :mapAccountIDSalesNenggOppy.get(oAccount.id))
            {
                oOpportunity.NDR_POS_Customer_Street__c = oAccount.BillingStreet;
                oOpportunity.NDR_POS_Customer_City__c = oAccount.BillingCity;
                oOpportunity.NDR_POS_Customer_Account_Number__c = oAccount.AccountNumber;
                oOpportunity.NDR_POS_Customer_Country__c = oAccount.BillingCountry;
                oOpportunity.NDR_POS_Customer_Name__c = oAccount.Name;
                oOpportunity.NDR_POS_Customer_Region__c = oAccount.Customer_Region__c;
                oOpportunity.NDR_POS_Customer_Sales_Engineer_s_Name__c = oAccount.Account_Manager_Name__c;
            }
        }
    }
    if(!ClsBatch_calculateOppyWithin2Years.isRunningBatch) {//added by Jinbo Shan at 2014-07-29 for setting trigger defence , when running batch for last 24 months Opportunities
    if(trigger.isafter && Trigger.IsUpdate){
        if(CSDOppRecTypeSet != null && CSDOppRecTypeSet.Size()>0){
            for(Opportunity opp : [SELECT Id, (SELECT Id, Opportunity__c FROM Forecast__r LIMIT 1) FROM Opportunity WHERE Id IN: CSDOppRecTypeSet LIMIT 50000]){
                if(!opp.Forecast__r.isEmpty()){
                    Opportunity_Forecast__c vTempForecast = opp.Forecast__r;
                    if(FTMap != null && (!FTMap.ContainsKey(vTempForecast.Opportunity__c)) && vTempForecast.Id != NULL){
                        FTMap.put(vTempForecast.Opportunity__c, 1);
                    }
                }
            }
        }
      }
    /*----------Opportunity Stage vs Forecast Validation Ends here------------*/
    // Added DND Opportunity record type for DND merge project Padmaja Dadi on 06/09/2015
    if(trigger.isbefore && (Trigger.IsUpdate || trigger.isinsert)){
        for(Opportunity O : vListOpp){
            if((RTMap.get(O.RecordTypeId) == 'Sales Opportunity-CSD') || (RTMap.get(O.RecordTypeId) == 'Engineering Opportunity-CSD') || (RTMap.get(O.RecordTypeId) == 'DND_Opportunity')){
                if(O.StageName=='New Opportunity' && O.Probability==10 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                }
                else if(O.StageName=='Quotation' && O.Probability==25 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                }
                else if(O.StageName=='Sampling' && O.Probability==50 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                }
            }
            
        }
        String exceptUserId = Apex_Helper_Settings__c.getValues('Currency Confirm Except Users').Value__c;
        
        if(exceptUserId.indexOf(UserInfo.getUserId()) == -1){
            for(Opportunity opp : trigger.new){
                //added by nelson zheng 04/13/2015 Updated the trigger for Currency Confirm    
                
                if(trigger.isinsert){
                    if(opp.default_currency__c != null && opp.default_currency__c != ''){
                        opp.currencyIsoCode = opp.default_currency__c;
                    }
                    
                    if(opp.RecordTypeId != salesOppyRtId && !opp.currency_confirm__c){
                        String error = system.label.Currency_Confirm;
                        opp.addError(error.replace('##currency##',opp.CurrencyIsoCode));
                    }
                }
            }
        }
     } 
     if((trigger.isbefore && trigger.isinsert) || (trigger.IsAfter && trigger.IsUpdate))
     {
    for(Opportunity O : vListOpp){
            Boolean Validation=True;
                    
            //'Sales Opportunity-CSD' Record Type Validations Start
            // Added DND Opportunity record type for DND merge project Padmaja Dadi on 06/09/2015
            if((RTMap.get(O.RecordTypeId) == 'Sales Opportunity-CSD' || (RTMap.get(O.RecordTypeId) == 'DND_Opportunity')) && Validation==True){
  
               /* if(O.StageName=='New Opportunity' && O.Probability==10 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                }
                else if(O.StageName=='Quotation' && O.Probability==25 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                }
                else if(O.StageName=='Sampling' && O.Probability==50 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                }*/
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified' && O.Probability==75 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null && Validation==True){
                    O.adderror('Please enter "Fulfillment Region(s)" field!');
                     Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null && Validation==True){  //2016-02-10 - Sanghita change added Case 00900395
                    O.adderror('Please enter "Fulfillment Region(s)" field!');
                     Validation=False;
                }
            // OEM validation   
             
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='New Opportunity' && O.Probability==10 && O.OEM_Name__c==null && Validation==True){
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Quotation' && O.Probability==25 && O.OEM_Name__c==null && Validation==True){
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Sampling' && O.Probability==50 && O.OEM_Name__c==null && Validation==True){
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified' && O.Probability==75 && O.OEM_Name__c==null && Validation==True){
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.OEM_Name__c==null && Validation==True){ // 2016-02-10 - Sanghita change added Case 00900395
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }   
                
               
            // Total Value Validation
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='New Opportunity' && O.Probability==10 && O.Amount==null && Validation==True){
                    O.adderror('Please enter "Total Value" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Quotation' && O.Probability==25 && O.Amount==null && Validation==True){
                    O.adderror('Please enter "Total Value" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Sampling' && O.Probability==50 && Validation==True && O.Amount ==null){
                    O.adderror('Please enter "Total Value" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified' && O.Probability==75 && Validation==True && O.Amount ==null){
                   O.adderror('Please enter "Total Value" field...!');
                   Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && Validation==True && O.Amount ==null){  // 2016-02-10 - Sanghita change added Case 00900395   
                   O.adderror('Please enter "Total Value" field...!');
                   Validation=False;
                }
                
              
                
            // Two Year Revenue Validation
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified' && O.Probability==75 && O.Two_Years_Revenue__c==null && Validation==True){
                    O.adderror('Please enter "Two Year Revenue" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.Two_Years_Revenue__c==null ){  // 2016-02-10 - Sanghita change added Case 00900395

                    O.adderror('Please enter "Two Year Revenue" field!');
                    Validation=False;
                }
            // Provide to customer Quotation Date Validation
               if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified' && O.Probability==75 && O.Provide_to_customer_Quotation_Date__c==null && Validation==True){
                    O.adderror('Please enter "Provide to customer Quotation Date" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.Provide_to_customer_Quotation_Date__c==null && Validation==True){ // 2016-02-10 - Sanghita change added Case 00900395  
                    O.adderror('Please enter "Provide to customer Quotation Date" field!');
                    Validation=False;
                }
            // Rejected Reason Validation                
            // Updated by padmaja on 09/22/2014  by pass Lead conversion validation errors                        
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='Lost/Dead - closed' && O.Probability==0 && O.Lost_Rejected_Dead_On_Hold_Reason__c==null && Validation==True && O.amount!=null){
                    O.adderror('Please enter "Rejected Reason" field!');
                    Validation=False;
                }   
            }
        //'Sales Opportunity-CSD' Record Type Validations End
        //'Engineering Opportunity-CSD' Record Type Validations Start
         // Added DND Opportunity record type for DND merge project Padmaja Dadi on 06/09/2015
            if((RTMap.get(O.RecordTypeId) == 'Engineering Opportunity-CSD' || (RTMap.get(O.RecordTypeId) == 'DND_Opportunity'))){
   
            // Fulfillment Region validation
              /*  if(O.StageName=='New Opportunity' && O.Probability==10 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                    //O.adderror('Please enter "Fulfillment Region(s)" field!');
                    
                }
                else if(O.StageName=='Quotation' && O.Probability==25 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                    //O.adderror('Please enter "Fulfillment Region(s)" field!');
                }
                else if(O.StageName=='Sampling' && O.Probability==50 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null){
                    O.Fulfillment_Region__c = usr.CSD_Region__c;
                    //O.adderror('Please enter "Fulfillment Region(s)" field!');
                }*/
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified/G3 Approved' && O.Probability==75 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null && Validation==True){
                    O.adderror('Please enter "Fulfillment Region(s)" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.Fulfillment_Region__c==null && usr.CSD_Region__c!=null && Validation==True){ //2016-02-10 - Sanghita change added Case 00900395   
                    O.adderror('Please enter "Fulfillment Region(s)" field!');
                    Validation=False;
                } 
            // OEM validation
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='New Opportunity' && O.Probability==10 && O.OEM_Name__c==null && Validation==True){
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Quotation' && O.Probability==25 && O.OEM_Name__c==null && Validation==True){
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Sampling' && O.Probability==50 && O.OEM_Name__c==null && Validation==True){
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified/G3 Approved' && O.Probability==75 && O.OEM_Name__c==null && Validation==True){
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.OEM_Name__c==null && Validation==True){  //2016-02-10 - Sanghita change added Case 00900395  
                    O.adderror('Please enter "OEM" field!');
                    Validation=False;
                }
            // Total Value Validation
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='New Opportunity' && O.Probability==10 && O.Amount==null && Validation==True){
                    O.adderror('Please enter "Total Value" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Quotation' && O.Probability==25 && O.Amount==null && Validation==True){
                    O.adderror('Please enter "Total Value" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Sampling' && O.Probability==50 && O.Amount==null && Validation==True){
                    O.adderror('Please enter "Total Value" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified/G3 Approved' && O.Probability==75 && O.Amount==null && Validation==True){
                    O.adderror('Please enter "Total Value" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.Amount==null && Validation==True){  //2016-02-10 - Sanghita change added Case 00900395  
                    O.adderror('Please enter "Total Value" field!');
                    Validation=False;
                }
            // Two Year Revenue Validation
                if(CustSetngId != Userinfo.getuserid() && O.StageName=='Won/Qualified/G3 Approved' && O.Probability==75 && O.Two_Years_Revenue__c==null && Validation==True){
                    O.adderror('Please enter "Two Year Revenue" field!');
                    Validation=False;
                }
                else if(CustSetngId != Userinfo.getuserid() && O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.Two_Years_Revenue__c==null && Validation==True){ // 2016-02-10 - Sanghita change added Case 00900395 
                    O.adderror('Please enter "Two Year Revenue" field!');
                    Validation=False;
                }
            // Provide to customer Quotation Date Validation
                if(CustSetngId != Userinfo.getuserid() && ((O.StageName=='Won/Qualified/G3 Approved' && O.Probability==75) ||(O.StageName=='Order Received or Mass Production' && O.Probability==100)) && O.Provide_to_customer_Quotation_Date__c==null && Validation==True){   //2016-02-10 - Sanghita change added Case 00900395
                    O.adderror('Please enter "Provide to customer Quotation Date" field!');
                    Validation=False;
                }
                //else if(O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.Provide_to_customer_Quotation_Date__c==null && Validation==True){  //2016-02-10 - Sanghita change added Case 00900395   
                //    O.adderror('Please enter "Provide to customer Quotation Date" field!');
                //    Validation=False;
                //}
            }
        //'Engineering Opportunity-CSD' Record Type Validations End
        
        //by nelson zheng 2015-01-27 for case 00789960
     //   if(Trigger.isBefore && Trigger.isInsert && usr.GIBU__c == 'Data & Devices' && o.StageName <> 'New Opportunity'){
      //      O.StageName.adderror(system.label.phase_should_be_New_Opportunity);//by nelson zheng 2015-01-27 for case 00789960
      //      Validation=False;
       // }
        
        //Opportunity Part GPL Validation
        // Added DND Opportunity record type for DND merge project Padmaja Dadi on 06/09/2015
        if(Validation==True && (RTMap.get(O.RecordTypeId) == 'Engineering Opportunity-CSD' || (RTMap.get(O.RecordTypeId) == 'DND_Opportunity'))){

             if(CustSetngId != Userinfo.getuserid() && O.StageName=='Quotation' && O.Probability==25 && ((O.Opportunity_Part_GPL_Exists__c > 0) || (O.Opportunity_Part_Count__c == 0))){
                //O.adderror('Please enter "GPL Code in Opportunity Part object"!'); //by nelson zheng 2015-01-27 for case 00789960
                O.adderror(system.label.input_Opportunity_Parts);//by nelson zheng 2015-01-27 for case 00789960
                Validation=False;
            }

            //else if(O.StageName=='Quotation' && O.Probability==25 && O.Opportunity_Part_Count__c == 0){
           //     O.adderror('Please enter "GPL Code in Opportunity Part object"!');
           //     Validation=False;
           // }         
        }
        
        //Opportunity Forecast Validation
            if(trigger.isafter){                               
               // New Stage value old stage value comparision for Case 00737273 by Padmaja on 09/16/2014
               // Added DND Opportunity record type for DND merge project Padmaja Dadi on 06/09/2015
                Opportunity oldOpp = Trigger.oldMap.get(O.ID);
                if(CustSetngId != Userinfo.getuserid() && Validation==True && (RTMap.get(O.RecordTypeId) == 'Sales Opportunity-CSD' || (RTMap.get(O.RecordTypeId) == 'DND_Opportunity'))){
                    if((O.StageName=='Won/Qualified' && O.Probability==75 && O.StageName != oldOpp.StageName && !FTMap.Containskey(O.id))  || 
                    (O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.StageName != oldOpp.StageName && !FTMap.Containskey(O.id))){  //2016-02-10 - Sanghita change added Case 00900395   
                        O.adderror('Please Create Forecast!');
                        Validation=False;
                    }
                }
    
                // New Stage value old stage value comparision for Case 00737273 by Padmaja on 09/16/2014
                // Added DND Opportunity record type for DND merge project Padmaja Dadi on 06/09/2015
                if(CustSetngId != Userinfo.getuserid() && Validation==True && (RTMap.get(O.RecordTypeId) == 'Engineering Opportunity-CSD' || (RTMap.get(O.RecordTypeId) == 'DND_Opportunity'))){  
                    if((O.StageName=='Won/Qualified/G3 Approved' && O.Probability==75 && O.StageName != oldOpp.StageName && !FTMap.Containskey(O.id)) || 
                    (O.StageName=='Quotation' && O.Probability==25 && O.StageName != oldOpp.StageName && !FTMap.Containskey(O.id)) ||                 
                    (O.StageName=='Order Received or Mass Production' && O.Probability==100 && O.StageName != oldOpp.StageName && !FTMap.Containskey(O.id))){   // 2016-02-10 - Sanghita change added Case 00900395  
                        O.adderror('Please Create Forecast!');
                        Validation=False;
                    }
                }      
            }
         }
     }
    }
}