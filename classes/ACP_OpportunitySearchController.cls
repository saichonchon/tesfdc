/******************************************************************************************************************
Name: ACP_OpportunitySearchController
Copyright @ 2017 TE Connectivity
=============================================================================
Requirement:
ACP_OpportunitySearchController for ACP_Opportunity_Search Page
=============================================================================
Purpose:
Controller for Custom Opportunity Search page on ACP_Application_Breakdown__c and ACP_Top_Open_Opportunity__c objects
Test class:
ACP_Opportunity_Search_Test
=============================================================================
History
-------
VERSION   AUTHOR        DATE         DETAIL
1.0 -    Anushka Bansal 06/15/17     INITIAL DEVELOPMENT
2.0 -    Anushka Bansal 11/02/17     Added comments and added errorlogs in to catch block 
********************************************************************************************************************/
public class ACP_OpportunitySearchController {

 private String soql;

 public List < Opportunity > opportunities {
  get;
  set;
 }
 public Opportunity opp = new Opportunity();
 public Opportunity opp2 = new Opportunity();
 public Opportunity getOpp() {
  return opp;
 }

 public Opportunity getOpp2() {
  return opp2;
 }

 public String fieldName1 {
  get;
  set;
 }
 public String fieldName2 {
  get;
  set;
 }
 public String fieldName3 {
  get;
  set;
 }
 public String fieldName4 {
  get;
  set;
 }
 
 public String operator1 {
  get;
  set;
 }
 public String operator2 {
  get;
  set;
 }
 public String operator3 {
  get;
  set;
 }
 public String operator4 {
  get;
  set;
 }
 public String operator5 {
  get;
  set;
 }
 public String operator6 {
  get;
  set;
 }
 public String operator7 {
  get;
  set;
 }
 public String operator8 {
  get;
  set;
 }
 public String value1 {
  get;
  set;
 }
 public String value2 {
  get;
  set;
 }
 public String value3 {
  get;
  set;
 }
 public String value4 {
  get;
  set;
 }
 public String value5 {
  get;
  set;
 }
 public String value6 {
  get;
  set;
 }



 ACP_Account_Plan__c accntPlan = new ACP_Account_Plan__c();
 public String acpId;
 public String progOpp {
  get;
  set;
 }
 public String sortDir {
  get {
   if (sortDir == null) {
    sortDir = 'asc';
   }
   return sortDir;
  }
  set;
 }
 public String sortField {
  get {
   if (sortField == null) {
    sortField = 'createdDate';
   }
   return sortField;
  }
  set;
 }

 //toggles the sort order when the column headers are clicked.
 public void toggleSort() {
  sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
  opportunities = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 100 ');
 }


 public ACP_OpportunitySearchController() {
   acpId = System.currentPageReference().getParameters().get('acpId');
   progOpp = System.currentPageReference().getParameters().get('program');
   runQuery();
  }
  //Fetching fieldset to display fields in the search results from the Opportunity object
 public List < Schema.FieldSetMember > getFields() {
  return SObjectType.Opportunity.FieldSets.ACP_Opportunity_Search.getFields();
 }

 //Adding fields to filter the search
 public List < SelectOption > getFieldNames() {
  List < SelectOption > options = new List < SelectOption > ();
  options.add(new SelectOption('', '--None--'));
  options.add(new SelectOption('name', 'Opportunity Name'));
  options.add(new SelectOption('Account.Account__c', 'Account Name'));
  options.add(new SelectOption('Owner.Name', 'Opportunity Owner'));
  options.add(new SelectOption('Total_Opportunity_Value__c', 'Total Opportunity Value'));
  options.add(new SelectOption('Opportunity_Number__c', 'Opportunity Number'));
  options.add(new SelectOption('ForecastCategoryName', 'Forecast Category'));
  return options;
 }

 //Adding operators to to filter the search
 public List < SelectOption > getOperator() {
  List < SelectOption > options = new List < SelectOption > ();
  options.add(new SelectOption('', '     --None--   '));
  options.add(new SelectOption('=', 'equals'));
  options.add(new SelectOption('%', 'starts with'));
  options.add(new SelectOption('%%', 'contains'));
  options.add(new SelectOption('!=', 'not equal to'));
  options.add(new SelectOption('>', 'greater than'));
  options.add(new SelectOption('>=', 'greater or equal'));
  options.add(new SelectOption('<', 'less than'));
  options.add(new SelectOption('<=', 'less or equal '));
  return options;
 }

 // Adding operators for Close Date field
 public List < SelectOption > getOperatorCloseDate() {
  List < SelectOption > options = new List < SelectOption > ();
  options.add(new SelectOption('', '     --None--   '));
  options.add(new SelectOption('=', 'equals'));
  options.add(new SelectOption('>', 'greater than'));
  options.add(new SelectOption('>=', 'greater or equal'));
  options.add(new SelectOption('<', 'less than'));
  options.add(new SelectOption('<=', 'less or equal '));
  return options;
 }

 //Fetching the picklist values from the stage field
 public List < SelectOption > getCurrentPhaseValues() {

  List < SelectOption > options = new List < SelectOption > ();
  Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
  List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
  options.add(new SelectOption('', '     --None--   '));

  for (Schema.PicklistEntry f: ple) {
   options.add(new SelectOption(f.getLabel(), f.getValue()));
  }

  return options;
 }

 //fetching record types of the Opportunity object
 public List < SelectOption > getRecordTypeValues() {
  List < SelectOption > options = new List < SelectOption > ();
  options.add(new SelectOption('', '     --None--   '));
  Schema.DescribeSObjectResult R = Opportunity.SObjectType.getDescribe();
  List < Schema.RecordTypeInfo > RT = R.getRecordTypeInfos();
  for (Schema.RecordTypeInfo record: RT)
   options.add(new selectOption(record.getName(), record.getName()));
  return options;
 }

 //Method to create the query for search results including all filters 
 public void runQuery() {

  accntPlan = [select Account_Plan_Type__c, ACP_GAMCode__c, ACP_KAMCode__c, ACP_Account_Name__c, ACP_WWAcNo__c from ACP_Account_PLan__c where id = : acpId];
  soql = 'SELECT name, Account.Account__c,Opportunity_Number__c , CloseDate , Total_Opportunity_Value__c ,ForecastCategoryName , Owner.Name, RecordType.DeveloperName,Opportunity.Record_Type_Name__c, RecordType.Name, Opportunity.Current_Phase__c from opportunity ';
  if (accntPlan.Account_Plan_Type__c == 'GAM Account')
   soql += 'where account.GAMCD__c =\'' + accntPlan.ACP_GAMCode__c + '\'';
  else if (accntPlan.Account_Plan_Type__c == 'KAM Account')
   soql += 'where account.IND_KAM_Code__c =\'' + accntPlan.ACP_KAMCode__c + '\'';
  else if (accntPlan.Account_Plan_Type__c == 'WW Account')
   soql += 'where account.WWCORPACCT__c =\'' + accntPlan.ACP_WWAcNo__c + '\'';
  else
   soql += 'where account.id =\'' + accntPlan.ACP_Account_Name__c + '\'';

  if (progOpp == 'yes')
   soql += ' and Record_Type_Name__c = \'Program\' and Id IN (SELECT Program_Opportunity__c from Platform_Content__c WHERE name != \'\') ';
  try {
   opportunities = Database.query(soql + ' order by createdDate, ' + sortField + ' ' + sortDir + ' limit 100 ');
  } catch (Exception e) {
   ErrorLogging.Log(e, 'ACP_OpportunitySearchController', 'runQuery', '');
  }

 }

 //Runs when user enters some filter critera and clicks on the search button
 public PageReference runSearch() {
  runQuery();
  List < String > fieldNameList = new List < String > ();
  List < String > operatorList = new List < String > ();
  List < String > valuesList = new List < String > ();
  String closeDt1 = '';

  fieldNameList.add(fieldName1);
  fieldNameList.add(fieldName2);
  fieldNameList.add(fieldName3);
  fieldNameList.add(fieldName4);
  fieldNameList.add('Current_Phase__c');
  fieldNameList.add('RecordType.Name');
  fieldNameList.add('CloseDate');
  fieldNameList.add('CloseDate');
  operatorList.add(operator1);
  operatorList.add(operator2);
  operatorList.add(operator3);
  operatorList.add(operator4);
  operatorList.add(operator5);
  operatorList.add(operator6);
  operatorList.add(operator7);
  operatorList.add(operator8);
  valuesList.add(value1);
  valuesList.add(value2);
  valuesList.add(value3);
  valuesList.add(value4);
  valuesList.add(value5);
  valuesList.add(value6);
  if (opp.closeDate != null) {
   Date closeDate = date.parse(opp.closeDate.format());
   closeDt1 = DateTime.newInstance(closeDate.year(), closeDate.month(), closeDate.day()).format('YYYY-MM-dd');
  }
  valuesList.add(closeDt1);
  if (opp2.closeDate != null) {
   Date closeDate = date.parse(opp2.closeDate.format());
   closeDt1 = DateTime.newInstance(closeDate.year(), closeDate.month(), closeDate.day()).format('YYYY-MM-dd');
  }
  valuesList.add(closeDt1);

  for (Integer i = 0; i < 8; i++) {
   if (fieldNameList[i] != '' && operatorList[i] != null && fieldNameList[i] != null) {
    createSoqlQuery(fieldNameList[i], operatorList[i], valuesList[i]);
   }
  }
  opportunities = Database.query(soql + ' order by createdDate, ' + sortField + ' ' + sortDir + '  limit 100 ');
  
 return null;
 }

 //adds filter critera selected by the user to the query
 public String createSoqlQuery(String field, String op, String value) {

  if (field == 'Total_Opportunity_Value__c') {
   system.debug('opp number - ' + field + op + String.escapeSingleQuotes(value));

   soql += ' and  ' + field + ' ' + op + ' ' + String.escapeSingleQuotes(value);
  } else if (field == 'CloseDate') {
   soql += ' and  ' + field + ' ' + op + ' ' + value;
  } else {
   if (op == '=')
    soql += ' and ' + field + '=\'' + String.escapeSingleQuotes(value) + '\'';
   else if (op == '%%')
    soql += ' and  ' + field + ' LIKE \'%' + String.escapeSingleQuotes(value) + '%\'';
   else if (op == '%')
    soql += ' and  ' + field + ' LIKE \'' + String.escapeSingleQuotes(value) + '%\'';
   else if (op == '!=')
    soql += ' and  ' + field + ' != \'' + String.escapeSingleQuotes(value) + '\'';
  }
  return soql;

 }
 
 
 public void resetFilters()
 {
 fieldName1 = '';
fieldName2 = '';
fieldName3 = '';
fieldName4 = '';
operator1 = '';
operator2 = '';
operator3 = '';
operator4 = '';
operator5 = '';
operator6 = '';
operator7 = '';
operator8 = '';
value1 = '';
value2 = '';
value3 = '';
value4 = '';
value5 = '';
value6 = '';
opp.closeDate = null;
opp2.closeDate = null;
runQuery();

 }
 
 public string getTextBox() {
  return System.currentPageReference().getParameters().get('txt');
 }


}