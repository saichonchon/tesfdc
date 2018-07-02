/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class SPExamsAttachRecipientsToExamCtrl {
    global List<SObject> BasicSObjectList;
    global spExams__Exam__c Exam {
        get;
        set;
    }
    global String ExamIdByParameter {
        get;
        set;
    }
    global spExams__Exam_Recipient_Mapping__c ExamRecipientMapping {
        get;
        set;
    }
    global String ObjectLabel {
        get;
        set;
    }
    global String ObjectLocalName;
    global String ObjectPluralLabel {
        get;
        set;
    }
    global List<spExams.ObjectWrapper> ObjectWrapperList {
        get;
        set;
    }
    global Integer PageSize;
    global Map<String,Schema.SObjectType> schemaMap;
    global String selectedSObjecstIds;
    global List<Id> selectedSObjecstIdsList;
    global Integer SelectedSObjecstListSize {
        get;
        set;
    }
    global ApexPages.StandardSetController standardController {
        get;
        set;
    }
    global Map<Id,spExams__User_Exam__c> userExamMap;
    global spExams.Paginator UserPaginator {
        get;
        set;
    }
    global String userParameter;
    global String UserQuery;
    global Map<Id,User> UsersMap {
        get;
        set;
    }
    global SPExamsAttachRecipientsToExamCtrl(ApexPages.StandardSetController standardController) {

    }
    global Boolean checkIsValidEmail(String inputEmail) {
        return null;
    }
    global static Boolean checkIsValidEmailStatic(String inputEmail) {
        return null;
    }
    global void fillExistingUsersExam() {

    }
    @RemoteAction
    global static List<spExams.SPExamsAttachRecipientsToExamCtrl.ExamStatus> getExistingUsersExamStatus(spExams.SPExamsAttachRecipientsToExamCtrl.UserExamWrapper UserExamWrapperFromUI) {
        return null;
    }
    global List<Id> getSelectedObjectsIdsList() {
        return null;
    }
    global void makeQuery(String queryFieldToSelect, String orderByStatement) {

    }
    global void manageSelectedFieldsToMakeQuery() {

    }
    @RemoteAction
    global static String saveUsersExam(List<spExams__User_Exam__c> userExamList) {
        return null;
    }
global class ExamStatus {
    global ExamStatus() {

    }
}
global class UserExamWrapper {
    global UserExamWrapper() {

    }
}
}
