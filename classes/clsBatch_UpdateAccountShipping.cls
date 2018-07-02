/**
*  This class used update plant account shipping infromation from delivery infromation .
*
@author Pankaj Raijade
@created 4/3/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  93%
* 
* 
4/3/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
*/

global class clsBatch_UpdateAccountShipping implements Database.Batchable<sObject>
{
    public string Query;
    //public Date Currentdate = date.today().adddays(-1);
    public list<Manufacturing_Plant__c> lstPlanttoInsert = new list<Manufacturing_Plant__c>();
    public map<ID, string> mapError = new map<ID, string>();
    public date dateSurveyStart = date.today().addMonths(-6);
    public date dateSurveyEnd = date.today();
    public date dateSurvey = date.today();
    public clsBatch_UpdateAccountShipping()
    {
        dateSurveyEnd = date.NewInstance( dateSurveyEnd.year(), dateSurveyEnd.Month(), 1);
        Time_frame_Setting__c AccountSurveyTimeFrame = Time_frame_Setting__c.getValues('ACCOUNT_SURVEY');
        if(AccountSurveyTimeFrame != null && AccountSurveyTimeFrame.Period_Type__c != null && AccountSurveyTimeFrame.Period__c != null)
        {
            if('YEAR'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addYears((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            if('MONTH'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addMonths((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            if('DAY'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addDays((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
        }
    }
    public clsBatch_UpdateAccountShipping(Date TempCurrentdate)
    {
        dateSurveyEnd = date.NewInstance( TempCurrentdate.year(), TempCurrentdate.Month(), 1);
        Time_frame_Setting__c AccountSurveyTimeFrame = Time_frame_Setting__c.getValues('ACCOUNT_SURVEY');
        if(AccountSurveyTimeFrame != null && AccountSurveyTimeFrame.Period_Type__c != null && AccountSurveyTimeFrame.Period__c != null)
        {
            if('YEAR'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addYears((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            if('MONTH'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addMonths((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            if('DAY'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                dateSurveyStart = dateSurveyEnd.addDays((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
        }
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        if(Query != null)
            return Database.getQueryLocator(Query);
        else 
            return Database.getQueryLocator([select id, Account__c, Manufacturing_Organization_Id__c, Shipped_Date__c, BUILDING_NAME_MFG__c, BUILDING_NBR_MFG__c, LONG_NAME_MFG_ORG__c, VENDOR_ID__c, Vendor_Name__c from Delivery_Performance__c where BUILDING_NBR_MFG__c != null AND Shipped_Date__c >= :dateSurveyStart AND Shipped_Date__c < :dateSurveyEnd and Account__r.NPS_Overall_Score__c != null]);// and account__c = :'001E000000Oow8B'
    }

    global void execute(Database.BatchableContext BC, List<Delivery_Performance__c> lstDeliveryPerformance)
    {
        dateSurvey = date.NewInstance( dateSurveyEnd.year(),dateSurveyEnd.Month() - 1, 15);
        
        string strdateSurvey = '-' + dateSurvey.year() + '-' + dateSurvey.Month() + '-' + '15'; 

        map<string, Delivery_Performance__c> mapDeliveryPerformance = new map<string, Delivery_Performance__c>();
        map<string, Delivery_Performance__c> mapNewPlantShipping = new map<string, Delivery_Performance__c>();
        map<string, Delivery_Performance__c> mapOrgIDDeliveryPerformance = new map<string, Delivery_Performance__c>();
        string strSurveyDatestring = date.today().year() + '-' + (date.today().Month() - 1)  + '-15';
        // Put delivery performance records according to its plant and account in map.
        for(Delivery_Performance__c oDeliveryPerformance :lstDeliveryPerformance)
            if(oDeliveryPerformance.BUILDING_NBR_MFG__c != null && oDeliveryPerformance.BUILDING_NBR_MFG__c != '')
                if(!mapDeliveryPerformance.containsKey(oDeliveryPerformance.BUILDING_NBR_MFG__c + '-' + oDeliveryPerformance.Account__c))
                    mapDeliveryPerformance.put(oDeliveryPerformance.BUILDING_NBR_MFG__c + '-' + oDeliveryPerformance.Account__c + strdateSurvey, oDeliveryPerformance);
        //Quert existing Plant Account shipment records 
        list<Plant_Account_Shipment__c> lstPlantAccountShipment = [select id, name, Account__c, Manufacturing_Plant__c, Manufacturing_Plant__r.BUILDING_NBR_MFG__c  from Plant_Account_Shipment__c where Plant_Account__c in :mapDeliveryPerformance.Keyset() and Shipped_Date__c = :dateSurvey];
        map<string, Plant_Account_Shipment__c> mapPlantAccountShipmentUpsert = new map<string, Plant_Account_Shipment__c>();
        map<string, Plant_Account_Shipment__c> mapPlantAccountShipment = new map<string, Plant_Account_Shipment__c>();
        
        for(Plant_Account_Shipment__c oPlantAccountShipment :lstPlantAccountShipment)
            mapPlantAccountShipment.put(oPlantAccountShipment.Name, oPlantAccountShipment);
        
        // check plant account shipment record shipment date and update shipment date.
        for(string strKey :mapDeliveryPerformance.Keyset())
        {
            system.debug('asdf'+strKey );
            Delivery_Performance__c oDeliveryPerformance = mapDeliveryPerformance.get(strKey);
            
            if(mapPlantAccountShipment.containsKey(strKey))
            {
                Plant_Account_Shipment__c oPlantAccountShipment = mapPlantAccountShipment.get(strKey);
                   oPlantAccountShipment.Shipped_Date__c = dateSurvey;
                   mapPlantAccountShipmentUpsert.put(oPlantAccountShipment.Manufacturing_Plant__r.BUILDING_NBR_MFG__c + '-' + oPlantAccountShipment.Account__c + strdateSurvey, oPlantAccountShipment);
            }
            else
            {
                // collect delivery performance records where Plant is not found.
                mapNewPlantShipping.put(strKey, oDeliveryPerformance);
                mapOrgIDDeliveryPerformance.put(oDeliveryPerformance.BUILDING_NBR_MFG__c, oDeliveryPerformance);
            }
        }
        map<string, Manufacturing_Plant__c> mapPlant = new map<string, Manufacturing_Plant__c>();
        //Check existing Plant and create new plant records if it does not exists.
        if(mapNewPlantShipping.size() > 0)
        {
            list<Manufacturing_Plant__c> lstPlant = [select id, BUILDING_NBR_MFG__c from Manufacturing_Plant__c where BUILDING_NBR_MFG__c in :mapOrgIDDeliveryPerformance.Keyset()];
            for(Manufacturing_Plant__c oPlant :lstPlant)
            {
                mapPlant.put(oPlant.BUILDING_NBR_MFG__c, oPlant);
                mapOrgIDDeliveryPerformance.remove(oPlant.BUILDING_NBR_MFG__c);
            }
            if(mapOrgIDDeliveryPerformance.size() > 0)
            {
                for(Delivery_Performance__c oDeliveryPerformance :mapOrgIDDeliveryPerformance.values())
                    lstPlanttoInsert.add(new Manufacturing_Plant__c(MANUFACTURING_ORGANIZATION_ID__c = oDeliveryPerformance.MANUFACTURING_ORGANIZATION_ID__c, BUILDING_NAME_MFG__c = oDeliveryPerformance.BUILDING_NAME_MFG__c, BUILDING_NBR_MFG__c = oDeliveryPerformance.BUILDING_NBR_MFG__c, LONG_NAME_MFG_ORG__c = oDeliveryPerformance.LONG_NAME_MFG_ORG__c, VENDOR_ID__c = oDeliveryPerformance.VENDOR_ID__c, Vendor_Name__c = oDeliveryPerformance.Vendor_Name__c));
                
                if(lstPlanttoInsert.size() > 0)
                {
                    list<Database.SaveResult> lstSaveResult = database.insert(lstPlanttoInsert, false);
                    for (Database.SaveResult sr : lstSaveResult) 
                        if (!sr.isSuccess()) 
                            for(Database.Error err : sr.getErrors()) 
                                mapError.put(sr.getId(),  (mapError.get(sr.getId()) + err.getStatusCode() + ': ' + err.getMessage()));
                }
                for(Manufacturing_Plant__c oPlant :lstPlanttoInsert)
                    if(oPlant.Id != null)
                        mapPlant.put(oPlant.BUILDING_NBR_MFG__c, oPlant);
            }
            
            //Create new Plant account records.
            for(Delivery_Performance__c oDeliveryPerformance :mapNewPlantShipping.values())
            {
                if(mapPlant.containsKey(oDeliveryPerformance.BUILDING_NBR_MFG__c))
                    mapPlantAccountShipmentUpsert.put(oDeliveryPerformance.BUILDING_NBR_MFG__c  + '-' + oDeliveryPerformance.Account__c + strdateSurvey, new Plant_Account_Shipment__c( Plant_Account__c = oDeliveryPerformance.BUILDING_NBR_MFG__c + '-' + oDeliveryPerformance.Account__c  + strdateSurvey, Account__c = oDeliveryPerformance.Account__c, Manufacturing_Plant__c = mapPlant.get(oDeliveryPerformance.BUILDING_NBR_MFG__c).Id, Shipped_Date__c = dateSurvey));
                else
                    mapError.put(oDeliveryPerformance.ID,  'Plant not found.');
            }
        }
            if(mapPlantAccountShipmentUpsert.size() > 0)
            {
                //upsert mapPlantAccountShipmentUpsert.values();
                list<Database.UpsertResult> lstUpsertResult = database.upsert(mapPlantAccountShipmentUpsert.values(), false);
                
                for (Database.UpsertResult sr : lstUpsertResult)
                {
                    system.debug('asdf'+sr);
                    if (!sr.isSuccess() ) 
                        for(Database.Error err : sr.getErrors()) 
                            if(err.getStatusCode() != StatusCode.DUPLICATE_VALUE)
                                mapError.put(sr.getId(),  (mapError.get(sr.getId()) + err.getStatusCode() + ': ' + err.getMessage()));
                }
            }
        
    }

    global void finish(Database.BatchableContext BC)
    {
    
        Batch_size_setting__c oBatchsize = Batch_size_setting__c.getInstance('clsBatch_UpdatePlantSurveyScore');
        if(oBatchsize != null && oBatchsize.Batch_size__c != null && oBatchsize.Batch_size__c > 0)
        {
            clsBatch_UpdatePlantSurveyScore oclsBatch_UpdatePlantSurveyScore = new clsBatch_UpdatePlantSurveyScore();
            database.executeBatch(oclsBatch_UpdatePlantSurveyScore, (Integer)oBatchsize.Batch_size__c);
        }
        else
        {
            clsBatch_UpdatePlantSurveyScore oclsBatch_UpdatePlantSurveyScore = new clsBatch_UpdatePlantSurveyScore();
            database.executeBatch(oclsBatch_UpdatePlantSurveyScore);
        }
        if(mapError.size() > 0)
        {
            Batch_Email_message_Users__c oBatchEmailmessageUsers = Batch_Email_message_Users__c.getValues('Error_clsBatch_CalculateSurveyScore');
            if(oBatchEmailmessageUsers != null && oBatchEmailmessageUsers.Email_ID__c != null)
            {
                string strEmailBody = '';
                for(string strAccountID :mapError.keyset())
                    strEmailBody += strAccountID + '-' + mapError.get(strAccountID) + '\n';
                    
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                List<String> lstToAddresses = oBatchEmailmessageUsers.Email_ID__c.split(';');
                mail.setToAddresses(lstToAddresses );
                mail.setSubject('Some error occurred during clsBatch_CalculateSurveyScore');
                mail.setPlainTextBody('Hi, \n\nSome error occurred during clsBatch_CalculateSurveyScore. Please see details below. \n\n' + strEmailBody + '\n\n Regards,');
                
                if(!test.isRunningTest()) { 
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                } 
            }
        }
    }
}