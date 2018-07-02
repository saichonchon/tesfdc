/*
Copyright © 2016 TE Connectivity | Salesforce Instance : C2S Org

Name                : LiveChatAvgCountBatch
Related Test Class  :
Created Date        : 05 Oct 2017
Created by          : Subramanian Jairam
Description         : This batch class used to calculate Average Waiting Time from Live Chat Transcript Object .

***********************************************************************************************************
Audit               
***********************************************************************************************************
Last Modified by    :
Last Modified Date  :
TeampUpCase$        :
JiraCase#           :
***********************************************************************************************************
*/
global class LiveChatAvgCountBatch implements Database.Batchable<sObject>, Database.Stateful{


global Long AvgMins= 0;
global integer total_Rec_Count = 0;
    global Database.querylocator start(Database.BatchableContext BC){
        String query = '';
        if(Test.isRunningTest())
            query = 'select EndTime,StartTime from LiveChatTranscript where StartTime != null LIMIT 100';
        else
            query = 'select EndTime,StartTime from LiveChatTranscript where EndTime = LAST_n_DAYS:7 and StartTime != null';                
                
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<LiveChatTranscript> scope){
        
        for(LiveChatTranscript obj : scope){
            Long dt1Long = obj.StartTime.getTime();
            Long dt2Long = obj.EndTime.getTime();
            Long milliseconds = dt2Long - dt1Long;
            Long seconds = milliseconds / 1000;
            Long minutes = seconds / 60;
            AvgMins += minutes;
        }
        total_Rec_Count += scope.size();        
    }
    global void finish(Database.BatchableContext BC){
        AvgMins = AvgMins/total_Rec_Count;
        LiveAgent_Average_Waiting_Time__c cs = [select AverageMinutes__c from LiveAgent_Average_Waiting_Time__c limit 1];
        cs.AverageMinutes__c = AvgMins;
        update cs;
    }
}