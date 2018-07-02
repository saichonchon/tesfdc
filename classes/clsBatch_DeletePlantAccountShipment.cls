/**
*  This class is used to delete old Plant Account shipment records.
*
@author Pankaj Raijade
@created 4/2/2015
@version 1.0   
@since 33.0
*
@changelog
* coverage  93%
* 
* 
4/2/2015 Pankaj Raijade pankaj.raijade@zensar.in
* - Created
*/
global class clsBatch_DeletePlantAccountShipment implements Database.Batchable<sObject>
{
    public map<string, string> mapSurvey_Question_field_mappings = new map<string, string>();
    public date dateShipmentdate;
    public map<ID, string> mapError = new map<ID, string>();
    public string Query;
    public clsBatch_DeletePlantAccountShipment()
    {
        Time_frame_Setting__c AccountSurveyTimeFrame = Time_frame_Setting__c.getValues('Delete_Plant_Account_Shipment_Period');
        if(AccountSurveyTimeFrame != null && AccountSurveyTimeFrame.Period_Type__c != null && AccountSurveyTimeFrame.Period__c != null)
        {
            if('YEAR'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c) || 'MONTH'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c) || 'DAY'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c) )
            {
                dateShipmentdate = date.NewInstance( date.today().year(), date.today().Month(), 1);
                if('YEAR'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                    dateShipmentdate = dateShipmentdate.addYears((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
                if('MONTH'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                    dateShipmentdate = dateShipmentdate .addMonths((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
                if('DAY'.equalsIgnoreCase(AccountSurveyTimeFrame.Period_Type__c))
                    dateShipmentdate = dateShipmentdate .addDays((Integer)(-1 * AccountSurveyTimeFrame.Period__c));
            }
        }
    }
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(Query != null)
            return Database.getQueryLocator(Query);
        if(dateShipmentdate != null) 
            return Database.getQueryLocator([select id from Plant_Account_Shipment__c where Shipped_Date__c < :dateShipmentdate]);
        else
            return null;
    }

    global void execute(Database.BatchableContext BC, List<Plant_Account_Shipment__c> lstPlantAccountShipment)
    {
        try
        {
            delete lstPlantAccountShipment;
        }
        catch(exception ex)
        {
        
        }
    }

    global void finish(Database.BatchableContext BC)
    {
    }
}