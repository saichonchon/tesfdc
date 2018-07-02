/*
 * [1/24/17] Prabhanjan N: Case:00901044 Creating a scheduler to call flow
 */ 

global class Schedular_RunFlow_portalemailreminder implements Schedulable {
    global void execute(SchedulableContext SC) {
        Map<String, Object> params = new Map<String, Object>(); 
        Flow.Interview.Email_Notifications_to_community_users F1 = new Flow.Interview.Email_Notifications_to_community_users(params);
        F1.start();
    }
}