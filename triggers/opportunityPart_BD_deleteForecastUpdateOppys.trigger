/**
 * 
 *   This trigger will delete the oppy forecasts of a oppy part, if this part has been deleted, and update the total revenue and five years revenue of this part's oppy 
 *
 * @author      Bin Yu  
 * @created     2012-05-08
 * @since       23.0    
 * @version     1.0                                                                 
 * 
 * @changelog
 * 2012-05-08 Bin Yu <bin.yu@itbconsult.com>
 * - Created
 *
 * 2015-11-24 Jinbo Shan <jinbo.shan@oinio.com>
 * - Modified for filling the values of Opportunity Part Id and Opportunity Forecast Id for forecast billing, when Opportunity Part deleted.
 */
 
trigger opportunityPart_BD_deleteForecastUpdateOppys on Opportunity_Part__c (before delete, after delete) {

    public Admin_Profile_Exception__c adm = Admin_Profile_Exception__c.getInstance(); 
    public Opportunity_Record_Type_Groups__c rec = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity');
    if(trigger.isBefore){
        Set<Id> set_partIds = trigger.oldMap.keySet();
        ClsOppyUtil.list_oppysForecast2Del = ClsOppyUtil.deleteForecastUpdateOppys(set_partIds);
        if(ClsOppyUtil.deletePartException != null){
            for(Opportunity_Part__c Part : trigger.old){
                part.addError('Update Oppotunity failed.');
            }
        }
        
         for(Opportunity_Part__c Part : trigger.old){                            
            if(Part.Status__c == 'Won' && part.Opportunity_Record_Type__c == rec.RecordTypeID__c && adm.Skip_Opportuntiy_Validation__c!=true){
                part.addError(System.Label.DND_Won_parts_deletion);
            }            
        }
        
        //Start to add by Jinbo Shan 2015-11-24
        //Fill the values of Opportunity Part Id and Opportunity Forecast Id for forecast billing, when Opportunity Part deleted.
        set<Id> set_partId = new set<Id>();
        map<Id, set<Forecast_Billing__c>> map_opId_set_fbs = new map<Id, set<Forecast_Billing__c>>();
        set<Date> set_ds = new set<Date>();
        //set<Id> set_oppyIds = new set<Id>();
        map<Id, Id> map_oppyId_opId = new map<Id, Id>();
        map<Id, map<Date, Id>> map_oppyId_ofDate_ofId = new map<Id, map<Date, Id>>();
        
        map<Id, map<date, decimal>> map_oppyId_date_amount = new map<Id, map<date, decimal>>();
        
        list<Forecast_Billing__c> list_fbs4update = new list<Forecast_Billing__c>();
        list<Forecast_Billing__c> list_fbs4delete = new list<Forecast_Billing__c>();
        
        Id salesParRTId;
        if(Apex_Helper_Settings__c.getInstance('Sales Parts RT Id') != null) {// Added null check for custom setting Apex_Helper_Settings__c
            salesParRTId = Apex_Helper_Settings__c.getInstance('Sales Parts RT Id').Value__c;
        }
        
        for (Opportunity_Part__c Part : trigger.old){
            if(part.RecordTypeId != salesParRTId) {
                set_partId.add(Part.Id);    
            }
            
        }
        
        if (set_partId.size() > 0) {
            for (Forecast_Billing__c fb : [select Id, Date__c, Opportunity_Part__c, 
                                            Opportunity_Part__r.Opportunity__c, 
                                            Opportunity_Forecast__c, Amount__c 
                                            from Forecast_Billing__c 
                                            where Opportunity_Part__c IN :set_partId]) {
                set_ds.add(fb.Date__c);
                //set_oppyIds.add(fb.Opportunity_Part__r.Opportunity__c);
                if(fb.Amount__c > 0) {
                    if(!map_oppyId_date_amount.containsKey(fb.Opportunity_Part__r.Opportunity__c)) {
                        map_oppyId_date_amount.put(fb.Opportunity_Part__r.Opportunity__c, new map<date, decimal>());
                    }
                    if(!map_oppyId_date_amount.get(fb.Opportunity_Part__r.Opportunity__c).containsKey(fb.Date__c)) {
                        map_oppyId_date_amount.get(fb.Opportunity_Part__r.Opportunity__c).put(fb.Date__c, 0);
                    }
                    map_oppyId_date_amount.get(fb.Opportunity_Part__r.Opportunity__c).put(fb.Date__c, map_oppyId_date_amount.get(fb.Opportunity_Part__r.Opportunity__c).get(fb.Date__c) + fb.Amount__c);
                }
                list_fbs4delete.add(fb);
            }
        }
        
        if(list_fbs4delete.size() > 0) {
            system.debug('##@@list_fbs4delete = ' + list_fbs4delete);
            delete list_fbs4delete;
        }
        
        for(Forecast_Billing__c fb : [select Id, Opportunity_Part__r.Opportunity__c, Date__c, 
                                    Amount__c 
                                    from Forecast_Billing__c 
                                    where Opportunity_Part__r.Opportunity__c IN :map_oppyId_date_amount.keySet()
                                    and Date__c IN :set_ds
                                    and Opportunity_Part__r.RecordTypeId !=:salesParRTId]) {
            if(map_oppyId_date_amount.get(fb.Opportunity_Part__r.Opportunity__c).containsKey(fb.Date__c)) {
                fb.Amount__c += map_oppyId_date_amount.get(fb.Opportunity_Part__r.Opportunity__c).get(fb.Date__c);
                map_oppyId_date_amount.get(fb.Opportunity_Part__r.Opportunity__c).remove(fb.Date__c);
                list_fbs4update.add(fb);
            }
        }
        
        if (list_fbs4update.size() > 0) {
            system.debug('##@@list_fbs4update = ' + list_fbs4update);
            update list_fbs4update;
        }
        //End to add by Jinbo Shan 2015-11-24
                
    }
    else{
        if(ClsOppyUtil.list_oppysForecast2Del.size() >0 ){
            delete ClsOppyUtil.list_oppysForecast2Del;
        }           
    }
}