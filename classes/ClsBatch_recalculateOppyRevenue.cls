/**
 *  A batch job to ReCalculate Oppy total Revenues and five Revenues. 
 *  
 * @author Yuliang Ye
 * @created 2012-08-30
 * @version 1.0
 * @since 24.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-08-21 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified by bin yuan due to fix null Argument exception   
 * 2012-08-30 Yuliang Ye <yuliang.ye@itbconsult.com>
 * - Created   
 *
 */
global class ClsBatch_recalculateOppyRevenue implements Database.Batchable<SObject>,Database.Stateful {
     /**
     * the email address to tell people the status of the batch class after run the batch class
     * before run the batch class, we can define the email manual
     * if not define email address, after the batch completed, will not send email
     */ 
    //global Map<Id, Opportunity> map_oppyId_oppy = new Map<Id, Opportunity>();
    global string SUCCESS;
    global string ERROR;
    global integer errorNum;
    public list<string> list_emails;
    public set<Id> set_rtIds;
    
    /**
     * the sql query statement that will select the data will be used in this batch class
     */     
    public String query;
    
    global ClsBatch_recalculateOppyRevenue(){
        errorNum = 0;
        if(list_emails == null){
            list_emails = new list<string>();
            for(Batch_Result_To_Emails__c brte : Batch_Result_To_Emails__c.getAll().values()){
                list_emails.add(brte.Name);
            }
        }
        
        if(set_rtIds == null){
            set_rtIds = new set<Id>();
            for(Calculate_Oppy_Revenue_Record_Types__c corrt : Calculate_Oppy_Revenue_Record_Types__c.getAll().values()){
                set_rtIds.add(corrt.Value__c);
            }
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        if (query == '' || query == null){
            query = 'Select Id, Amount, Current_Year_Revenue__c,One_Year_Revenue__c,Five_Year_Value__c, Total_Opportunity_Value__c, '
                    +'Five_Year_Revenue__c, CloseDate, CurrencyIsoCode, Program__c, '
                    +'Manufacturing_Start_Date__c from Opportunity where RecordTypeId IN : set_rtIds';
        }
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, list<Opportunity> list_oppy){   
        Map<Opportunity, list<Opportunity_Forecast__c>> map_oppy_oppyForecast = new Map<Opportunity, list<Opportunity_Forecast__c>>();
        Map<Id, Opportunity> map_oppyId_oppy = new Map<Id, Opportunity>();
        set<Date> set_closeDate = new set<Date>();
        List<Opportunity> list_oppy2Update = new List<Opportunity>();
        
        for(Opportunity oppy : list_oppy){            
            oppy.Amount = 0;
            oppy.Five_Year_Revenue__c = 0;
            // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########
 
            oppy.Total_Opportunity_Value__c= 0;
            oppy.Five_Year_Value__c= 0;
            map_oppyId_oppy.put(oppy.id, oppy); 
        }   
        
        for(Opportunity_Forecast__c fc : [SELECT Amount__c, Five_Year_Amount__c, CurrencyIsoCode, Date__c, Fiscal_Quarter__c, 
                                        Fiscal_Year__c, Fiscal_Year_Quarter__c, Opportunity__c, Opportunity__r.closeDate, 
                                        Opportunity__r.Manufacturing_Start_Date__c, Part__c, Part__r.Status__c, Part__r.CurrencyIsoCode 
                                        FROM Opportunity_Forecast__c 
                                        where Part__c != null 
                                        and Amount__c != null 
                                        and Opportunity__c IN :map_oppyId_oppy.keySet()]){
            if(!map_oppy_oppyForecast.containsKey(map_oppyId_oppy.get(fc.Opportunity__c))){
                map_oppy_oppyForecast.put(map_oppyId_oppy.get(fc.Opportunity__c), new List<Opportunity_Forecast__c>());
            }
            map_oppy_oppyForecast.get(map_oppyId_oppy.get(fc.Opportunity__c)).add(fc);
            set_closeDate.add(fc.Opportunity__r.Manufacturing_Start_Date__c);
        }

       
       
       
        Map<Date, Map<String, Map<Integer, Integer>>> map_date_startEndQuarter = ClsOppyUtil.getFiveYearsInternal(set_closeDate);
         
         
      
      
        for(Opportunity oppy : map_oppy_oppyForecast.keySet()){    
            Decimal tmpTotalAmount = (oppy.Amount==null? 0:oppy.Amount);
            Decimal tmp5YearAmount = (oppy.Five_Year_Revenue__c==null? 0:oppy.Five_Year_Revenue__c);
             // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########               
      
            Decimal tmpTotalAmount_Cust = (oppy.Total_Opportunity_Value__c==null? 0:oppy.Total_Opportunity_Value__c);
            Decimal tmp5YearAmount_Cust = (oppy.Five_Year_Value__c==null? 0:oppy.Five_Year_Value__c);
            
            Integer startYear;
            Integer endYear;
            Integer startQuarter;
            Integer endQuarter;
            if(map_date_startEndQuarter.containsKey(oppy.Manufacturing_Start_Date__c)){                       
                for(Integer y1 :map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get('Start').keySet()){
                    startYear = y1;
                }
                for(Integer y2 :map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get('End').keySet()){
                    endYear = y2;
                }
                startQuarter = map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get('Start').get(startYear);
                endQuarter = map_date_startEndQuarter.get(oppy.Manufacturing_Start_Date__c).get('End').get(endYear);
            }          

             
           
            for(Opportunity_Forecast__c ofc : map_oppy_oppyForecast.get(oppy)){
                Integer y;
                Integer q;
                if(ofc.Fiscal_Year__c != null) y = Integer.valueOf(ofc.Fiscal_Year__c);
                if(ofc.Fiscal_Quarter__c != null) q = Integer.valueOf(ofc.Fiscal_Quarter__c);
                
                // update 5 year revenue and total revenue on oppy.
                if(ofc.Part__r.CurrencyIsoCode != oppy.CurrencyIsoCode){                               
                    if((y != null && y > startYear && y < endYear) || (y != null && q != null && y == startYear && q >= startQuarter) || (y != null && q != null && y == endYear && q <= endQuarter)){ 
                        if(ofc.Part__r.Status__c != 'Dead' && ofc.Part__r.Status__c != 'Lost'){//added by Jinbo 2014-10-08 for calculating revenue
                            tmp5YearAmount += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.Part__r.CurrencyIsoCode, oppy.CurrencyIsoCode);
                        }
                        tmp5YearAmount_Cust += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.Part__r.CurrencyIsoCode, oppy.CurrencyIsoCode);
                    }
                    if(ofc.Part__r.Status__c != 'Dead' && ofc.Part__r.Status__c != 'Lost'){//added by Jinbo 2014-10-08 for calculating revenue
                        tmpTotalAmount += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.Part__r.CurrencyIsoCode, oppy.CurrencyIsoCode); 
                    }
                    tmpTotalAmount_Cust += ClsOppyUtil.transformIsoCode(ofc.Amount__c, ofc.Part__r.CurrencyIsoCode, oppy.CurrencyIsoCode); 
                }
                else{     
                    if((y != null && y > startYear && y < endYear) || (y != null && q != null && y == startYear && q >= startQuarter) || (y != null && q != null && y == endYear && q <= endQuarter)){
                        if(ofc.Part__r.Status__c != 'Dead' && ofc.Part__r.Status__c != 'Lost'){//added by Jinbo 2014-10-08 for calculating revenue
                            tmp5YearAmount += (ofc.Amount__c == null ? 0 : ofc.Amount__c);  //Modified by bin yuan due to fix null Argument exception
                        }
                        tmp5YearAmount_Cust += (ofc.Amount__c == null ? 0 : ofc.Amount__c);     //Modified by bin yuan due to fix null Argument exception
                    }
                    if(ofc.Part__r.Status__c != 'Dead' && ofc.Part__r.Status__c != 'Lost'){//added by Jinbo 2014-10-08 for calculating revenue
                        tmpTotalAmount += (ofc.Amount__c == null ? 0 : ofc.Amount__c);  //Modified by bin yuan due to fix null Argument exception
                    }
                    tmpTotalAmount_Cust += (ofc.Amount__c == null ? 0 : ofc.Amount__c);     //Modified by bin yuan due to fix null Argument exception             
                }
            }
            oppy.Amount =  tmpTotalAmount;
            oppy.Five_Year_Revenue__c = tmp5YearAmount;
            // ######### Added Five Year Value,Total Opportunity value functionality BY RAVI <ravikumar.vasimalla@zensar.in>##########               
          
            oppy.Total_Opportunity_Value__c =  tmpTotalAmount_Cust;
            oppy.Five_Year_Value__c = tmp5YearAmount_Cust;
            
            system.debug('tmp5YearAmount_Cust: ' + tmp5YearAmount_Cust);
            system.debug('tmpTotalAmount_Cust: ' + tmpTotalAmount_Cust);
            list_oppy2Update.add(oppy);   
        }  
        
       if( map_oppyId_oppy!=null)
         {
         IND_RecalOneCurr_RevenueClass reclaOnECurr = new IND_RecalOneCurr_RevenueClass();
         map<id,opportunity> mapcollect = reclaOnECurr.onAfterinsertUpdate(map_oppyId_oppy);
         if(mapcollect !=null){
         // list_oppy2Update.addall(reclaOnECurr.onAfterinsertUpdate(map_oppyId_oppy).values()); if i add directly the list to existing list then we will get an error
          // will updating the list as we may get duplicate id in the list. i need to keep the existing list as well as i need to add my opportunity by replacing the existing list without toching others.
         Map<id,opportunity> Tempmapopp= new Map<id,opportunity>(list_oppy2Update);
         
         for(opportunity opp: mapcollect.values())
          {
            if(Tempmapopp.containskey(opp.id)){Tempmapopp.put(opp.id,opp);}
          }
        
            list_oppy2Update.clear();
            list_oppy2Update.addall(Tempmapopp.values()); // Code added by Deepak Kumar on 15th sep 2016 for TeamUp case number  00901050 
         }
         //system.debug('#####################################################################################################################');            
         }
         
        if(list_oppy2Update.size() > 0) {
            // update opportunity
            Database.SaveResult[] srList = Database.update(list_oppy2Update, false);
    
            // added by Jinbo Shan 2014-10-28
            for (integer i = 0; i < srList.size(); i++) {
                if (srList.get(i).isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    if(SUCCESS == null) {
                        SUCCESS = 'Successfully Calculated Opportunity. Opportunity ID: <br/>';
                    }
                    SUCCESS += srList.get(i).getId() + '<br/>';
                }
                else {
                    // Operation failed, so get all errors     
                    if(ERROR == null) {
                        ERROR = 'The following opportunities has calculated failing: <br/>';
                    }      
                    errorNum ++;
                    ERROR += list_oppy2Update.get(i).Id + ': ';     
                    for(Database.Error err : srList.get(i).getErrors()) {    
                         ERROR += err.getStatusCode() + ': ' + err.getMessage() + '<br/>';
                    }
                }
            }
        }     
        
        //if(!list_oppy2Update.isEmpty()) update list_oppy2Update;
    }

    global void finish(Database.BatchableContext BC){     
        if(!test.isRunningTest()){
            ClsBatch_recalculateOppyProgram cls = new ClsBatch_recalculateOppyProgram();
            database.executeBatch(cls);    
        }
        if(UserInfo.getUserId() != null && (ERROR != null || SUCCESS != null) ){
            if(ERROR == null) {
                ERROR = '';   
            }
            if(SUCCESS == null) {
                SUCCESS = '';
            }
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setTargetObjectId(UserInfo.getUserId());
            if(list_emails.size() > 0){
                mail.setToAddresses(list_emails);
            }
            mail.setSubject('Recalculating all opportunities revenue are completed.');
            system.debug('**@@ ERROR = ' + ERROR);
            string htmlContent = SUCCESS + '<br/><br/> We got the error is ' + errorNum + ':<br/>' + ERROR;
            Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            if(htmlContent != null){
                attach.setContentType('application/pdf');
                attach.setFileName('RecalculateOpportunitiesRevenueResult.pdf');
                attach.setInline(false);
                attach.Body = Blob.toPDF(htmlContent);
                htmlContent = 'Please find in attachment the recalculate result:';
            }
                                
            string htmlBody = htmlContent;
            mail.setHtmlBody(htmlBody);
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC           
            if(attach.Body != null){
                mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach });
            }
            if(!test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            
            /*string htmlBody = SUCCESS + '<br/><br/> We got the error is ' + errorNum + ':<br/>' + ERROR;
            EmailTemplate p;
            for(EmailTemplate temp : [select BrandTemplateId, Name, Id, IsActive,Body, TemplateType, FolderId, TemplateStyle, HtmlValue, DeveloperName from EmailTemplate where DeveloperName = 'Recalculate_Opportunity_Revenue']) {
                p=temp;
            }
            if(p == null) {
                p = new EmailTemplate();
                p.Name = 'Recalculate Opportunity Revenue';
                p.TemplateType='html';
                p.FolderId = '00lE0000000u2yEIAQ';
                p.TemplateStyle = 'freeForm';
                p.DeveloperName = 'Recalculate_Opportunity_Revenue';
                p.BrandTemplateId = '016E0000000Y1UcIAK';
                p.IsActive = true;
                p.Subject = 'Recalculate Opportunity Revenue';
                insert p;
            }
            p.Body = htmlBody;
            update p;
            
            list<Id> list_userIds = new list<Id>();
            list_userIds.add(UserInfo.getUserId());
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(list_userIds);
            //mail.setToAddresses(new list<string>{'jinbo.shan@itbconsult.com'});
            //mail.setSubject('Recalculating all opportunities revenue are completed.');
            system.debug('**@@ ERROR = ' + ERROR);
            
            mail.setTemplateId(p.Id);
            mail.setDescription('Recalculating all opportunities revenue are completed.');
            //mail.setHtmlBody(htmlBody);
            
            mail.setSaveAsActivity(false); //If "yes" Activity will be created for Visit Report, If "no" no Activity will be created
            mail.setUseSignature(false); //Sender Signature from SFDC           
            if(!test.isRunningTest()){
                Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
            }*/
        }
        
    }  
}