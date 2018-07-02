/**
 * This trigger used to validate whether opportunity and opportunity part have the same approver pm.
 *
 * @author      Yinfeng Guo
 * @created     2012-03-19
 * @since 23.0 (Force.com ApiVersion)    
 * @version     1.0 
 *
 * @changelog
 * 2012-03-19 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created 
 * 2015-08-16 Mrunal Parate
 * - Modified For Change Channel Opportunities at header level Project to Update Process status as per 
 *   the Confidence value for Channel record types.
 */
 /*
 modified by Abhijeet 06-08-2013
 Added op.recordTypeId != vNDROppPartRT.Value__c condition 
 */
trigger opportunityPart_BIU_validateApproverPM on Opportunity_Part__c (before insert, before update) {

    String triggerName = 'Opportunity_Part__c';
    //Added by Abhijeet 06-08-2013 
    public Apex_Helper_Settings__c vNDROppPartRT = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');
    public Opportunity_Record_Type_Groups__c rec = Opportunity_Record_Type_Groups__c.getInstance('DND Opportunity');
    //Change start by Mrunal for Change Channel Opportunities at header level Project
    public set<string> set_oppyRecordTypeId = new set<string>();
    for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
                if(rt.Active__c && rt.Group__c == 'Change Channel Opportunities at header level' && rt.RecordTypeID__c!= null)
                    set_oppyRecordTypeId.add(rt.RecordTypeID__c.substring(0, 15));      
    }
    
    public map<string,string> map_status_procSts = new map<string,string>();
    for(Channel_Oppty_Header_Level_Change__c cusSt : Channel_Oppty_Header_Level_Change__c.getall().values()){
                map_status_procSts.put(cusSt.Confidence__c, cusSt.Process_Status__c);                
    }

    //Change End by Mrunal for Change Channel Opportunities at header level Project
    //************************* BEGIN Before Trigger **********************************************
    //if(ClsOppyPartUtil.isRunTrigger){

        map<Id, list<Opportunity_Part__c>> map_oppyId_parts = new map<Id, list<Opportunity_Part__c>>();
        if(Trigger.isBefore) {
            if(trigger.isInsert) {
                for(Opportunity_Part__c op: trigger.new){
                    if(op.Product_Manager_Id__c != null && op.Product_Manager_Id__c != '' && op.recordTypeId != vNDROppPartRT.Value__c){
                        if(!map_oppyId_parts.containsKey(op.Opportunity__c)){
                            map_oppyId_parts.put(op.Opportunity__c,new list<Opportunity_Part__c>());    
                        }
                        map_oppyId_parts.get(op.Opportunity__c).add(op);
                    }
                    system.debug(op.Opportunity__r.RecordType+'testing');            
                    system.debug(String.valueOf(op.Opportunity__r.RecordType)+'testing2');
                    if(op.Status__c == 'Won' && op.Won_Date__c==null && op.Opportunity_Record_Type__c==rec.RecordTypeID__c){
                        op.Won_Date__c = system.today();
                        op.Won_Fiscal_Year__c =  ClsOppyForecastUtil.getForecastYear(op.Won_Date__c);
                        String tmpQuarter =  ClsOppyForecastUtil.getForecastQuarter(op.Won_Date__c);
                        if(tmpQuarter != '') op.Won_Fiscal_Quarter__c = '0' + tmpQuarter;
                        op.Won_Fiscal_Month__c =  ClsOppyForecastUtil.getForecastMonthNum(op.Won_Date__c);
                    }
                    else if(op.Status__c == 'Won' && op.Process_Status__c == 'Production' && op.Opportunity_Record_Type__c!=rec.RecordTypeID__c){
                        op.Won_Date__c = system.today();
                        op.Won_Fiscal_Year__c =  ClsOppyForecastUtil.getForecastYear(op.Won_Date__c);
                        String tmpQuarter =  ClsOppyForecastUtil.getForecastQuarter(op.Won_Date__c);
                        if(tmpQuarter != '') op.Won_Fiscal_Quarter__c = '0' + tmpQuarter;
                        op.Won_Fiscal_Month__c =  ClsOppyForecastUtil.getForecastMonthNum(op.Won_Date__c);
                    }
                    else if(op.Process_Status__c != 'Ramp-down' && op.Process_Status__c != 'EOL' && op.Opportunity_Record_Type__c!=rec.RecordTypeID__c){
                        op.Won_Date__c = null;
                        op.Won_Fiscal_Year__c = null;
                        op.Won_Fiscal_Quarter__c = null;
                        op.Won_Fiscal_Month__c = null;
                    }
                    //added by xia 2013-03-05 add lost date
                    if(op.Status__c == 'Dead' || op.Status__c == 'Lost'){
                        op.Lost_Date__c = system.today();
                        op.Lost_Fiscal_Year__c =  ClsOppyForecastUtil.getForecastYear(op.Lost_Date__c);
                        String tmpQuarter =  ClsOppyForecastUtil.getForecastQuarter(op.Lost_Date__c);
                        if(tmpQuarter != '') op.Lost_Fiscal_Quarter__c = '0' + tmpQuarter;
                        op.Lost_Fiscal_Month__c =  ClsOppyForecastUtil.getForecastMonthNum(op.Lost_Date__c);
                    }else{
                        op.Lost_Date__c = null;
                        op.Lost_Fiscal_Year__c = null;
                        op.Lost_Fiscal_Quarter__c = null;
                        op.Lost_Fiscal_Month__c = null;
                    }
                    //Change start by Mrunal for Change Channel Opportunities at header level Project
                    //system.debug('>>>>>>@@op.Opportunity__r.RecordTypeId'+op.Opportunity_Record_Type__c+'___'+set_oppyRecordTypeId);
                    if(set_oppyRecordTypeId.contains(op.Opportunity_Record_Type__c))
                        op.process_status__c= map_status_procSts.get(op.Status__c);
                    //Change End by Mrunal for Change Channel Opportunities at header level Project
                }
            }
            else if(trigger.isUpdate){
                for(Opportunity_Part__c op: trigger.new){
                    if(op.Product_Manager_Id__c != trigger.oldMap.get(op.Id).Product_Manager_Id__c && op.recordTypeId != vNDROppPartRT.Value__c){
                        if(!map_oppyId_parts.containsKey(op.Opportunity__c)){
                            map_oppyId_parts.put(op.Opportunity__c,new list<Opportunity_Part__c>());    
                        }
                        map_oppyId_parts.get(op.Opportunity__c).add(op);
                    }
                    //Change start by Mrunal for Change Channel Opportunities at header level Project
                    //system.debug('>>>>>>@@op.Opportunity__r.RecordTypeId'+op.Opportunity_Record_Type__c+'___'+set_oppyRecordTypeId);
                    if(set_oppyRecordTypeId.contains(op.Opportunity_Record_Type__c))
                        op.process_status__c= map_status_procSts.get(op.Status__c);
                    //Change End by Mrunal for Change Channel Opportunities at header level Project
                    system.debug(op.Opportunity__r.RecordType+'testing');
                    system.debug(rec.RecordTypeID__c +'testing1');
                    system.debug(String.valueOf(op.Opportunity__r.RecordType)+'testing2');
                    if(op.Status__c == 'Won' && op.Won_Date__c == null && op.Opportunity_Record_Type__c==rec.RecordTypeID__c){
                        op.Won_Date__c = system.today();
                        op.Won_Fiscal_Year__c =  ClsOppyForecastUtil.getForecastYear(op.Won_Date__c);
                        String tmpQuarter =  ClsOppyForecastUtil.getForecastQuarter(op.Won_Date__c);
                        if(tmpQuarter != '') op.Won_Fiscal_Quarter__c = '0' + tmpQuarter;
                        op.Won_Fiscal_Month__c =  ClsOppyForecastUtil.getForecastMonthNum(op.Won_Date__c);
                    }
                    else if(op.Status__c == 'Won' && op.Process_Status__c == 'Production' && op.Opportunity_Record_Type__c!=rec.RecordTypeID__c){
                        if(op.Process_Status__c != trigger.oldMap.get(op.Id).Process_Status__c){
                            op.Won_Date__c = system.today();
                            op.Won_Fiscal_Year__c =  ClsOppyForecastUtil.getForecastYear(op.Won_Date__c);
                            String tmpQuarter =  ClsOppyForecastUtil.getForecastQuarter(op.Won_Date__c);
                            if(tmpQuarter != '') op.Won_Fiscal_Quarter__c = '0' + tmpQuarter;
                            op.Won_Fiscal_Month__c =  ClsOppyForecastUtil.getForecastMonthNum(op.Won_Date__c);
                        }
                    }
                    else if(op.Process_Status__c != 'Ramp-down' && op.Process_Status__c != 'EOL' && op.Opportunity_Record_Type__c!=rec.RecordTypeID__c){
                        op.Won_Date__c = null;
                        op.Won_Fiscal_Year__c = null;
                        op.Won_Fiscal_Quarter__c = null;
                        op.Won_Fiscal_Month__c = null;
                    }
                    //added by xia 2013-03-05 add lost date
                    if(op.Status__c == 'Dead' || op.Status__c == 'Lost'){
                        if(op.Status__c != trigger.oldMap.get(op.Id).Status__c){
                            op.Lost_Date__c = system.today();
                            op.Lost_Fiscal_Year__c =  ClsOppyForecastUtil.getForecastYear(op.Lost_Date__c);
                            String tmpQuarter =  ClsOppyForecastUtil.getForecastQuarter(op.Lost_Date__c);
                            if(tmpQuarter != '') op.Lost_Fiscal_Quarter__c = '0' + tmpQuarter;
                            op.Lost_Fiscal_Month__c =  ClsOppyForecastUtil.getForecastMonthNum(op.Lost_Date__c);
                        }
                    }else{
                        op.Lost_Date__c = null;
                        op.Lost_Fiscal_Year__c = null;
                        op.Lost_Fiscal_Quarter__c = null;
                        op.Lost_Fiscal_Month__c = null;
                    }
                    
                }
            }
        }
        
        if(!map_oppyId_parts.isEmpty() && ClsOppyPartUtil.isRunTrigger){
            map<Id,boolean> map_oppyId_isError = new map<Id,boolean>();
            system.debug('tongxia: trigger call');
            map_oppyId_isError = ClsOppyPartUtil.validatePartManager(map_oppyId_parts,new set<Id>());
            for(Opportunity_Part__c op: trigger.new){
                if(map_oppyId_isError.containsKey(op.Opportunity__c) && map_oppyId_isError.get(op.Opportunity__c)){
                    op.addError(system.Label.Not_same_Approver_PM);
                }
            }
        }
                     
    //}
    
    //************************* END Before Trigger ************************************************
    
    //************************* BEGIN After Trigger ***********************************************
    //************************* END After Trigger *************************************************
}