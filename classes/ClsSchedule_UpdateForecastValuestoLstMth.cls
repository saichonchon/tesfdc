global class ClsSchedule_UpdateForecastValuestoLstMth implements Schedulable {
    
    public String email;    
    list <Period> PeriodObj = [select id , StartDate, Type from Period Where Type = 'Month'];
    list<Date> StartDate = new list<Date>();
    public Date todayDate = Date.today();
    
    global void execute(SchedulableContext sc) {
        for (Period p: PeriodObj){
        Startdate.add(p.StartDate);
    }
    for (Date dt: Startdate){
        if (todayDate == dt){
            ClsBatch_UpdateForecastValuestoLastMonth updateovf = new ClsBatch_UpdateForecastValuestoLastMonth();
            updateovf.query = 'select id , Month_0__c, Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c,Month_13__c,Month_14__c,Month_15__c,Month_16__c,Month_17__c,Previous_Month_1__c,Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c,Previous_Month_6__c,Bookings_Month_0__c, Bookings_Month_1__c,Bookings_Month_2__c,Bookings_Month_3__c,Bookings_Month_4__c,Bookings_Month_5__c,Bookings_Month_6__c,Bookings_Month_7__c,Bookings_Month_8__c,Bookings_Month_9__c,Bookings_Month_10__c,Bookings_Month_11__c,Bookings_Month_12__c,Bookings_Month_13__c,Bookings_Month_14__c,Bookings_Month_15__c,Bookings_Month_16__c,Bookings_Month_17__c,Bookings_Previous_Month_1__c,Bookings_Previous_Month_2__c,Bookings_Previous_Month_3__c,Bookings_Previous_Month_4__c,Bookings_Previous_Month_5__c,Bookings_Previous_Month_6__c  from Overall_Forecast__c';
            //updateovf.email='Praveen.Bondalapati@te.com';
            updateovf.ObjectName = 'Overall_Forecast__c';
            ID batchprocessovfid = Database.executeBatch(updateovf);
            
            ClsBatch_UpdateForecastValuestoLastMonth updateaf = new ClsBatch_UpdateForecastValuestoLastMonth();
            updateaf.query = 'select id , Month_0__c, Month_1__c,Month_2__c,Month_3__c,Month_4__c,Month_5__c,Month_6__c,Month_7__c,Month_8__c,Month_9__c,Month_10__c,Month_11__c,Month_12__c,Month_13__c,Month_14__c,Month_15__c,Month_16__c,Month_17__c,Previous_Month_1__c,Previous_Month_2__c,Previous_Month_3__c,Previous_Month_4__c,Previous_Month_5__c,Previous_Month_6__c from Account_Forecast__c';
            //updateaf.email='Praveen.Bondalapati@te.com';
            updateaf.ObjectName = 'Account_Forecast__c';
            ID batchprocessafid = Database.executeBatch(updateaf);
            
            }
        }
    }
}