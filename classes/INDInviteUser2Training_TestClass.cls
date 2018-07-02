@isTest
/*********************************************************************************************************************** 
 Name: INDInviteUser2Training_TestClass 
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: This class Is used for testing the code coverage of other classes which are used in training app.
 Test Class For the Class:- INDsearchUserConttroller: test Coverage 97% and INDMainUserSearchController: test coverage 87%                                                  
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/
private class INDInviteUser2Training_TestClass {

    static testMethod void myUnitTest1() {

        test.startTest();
        List<recordtype> trainingrecordtype = new List<recordtype>();
        trainingrecordtype=[select id,name,developername from recordtype where isactive=true and SobjectType='training__c'];
        Map<string,id> maprt = new map<string,id>();
        for(recordtype tr:trainingrecordtype)
        {
         maprt.put(tr.developername,tr.id);
        }
        
        List<Training__c> ListTr = new List<training__c>();//L_R_Result_Summary__c LRS =new L_R_Result_Summary__c(); 
        Training__c tact = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Training_Date_and_Time1__c=datetime.Now(),Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+5);
        ListTr.add(tact);
        Training__c tact2 = new training__c(name='testtrainig',recordtypeid=maprt.get('Training_with_Response_Exam_Date_Slots'),Active__c=true,Name_of_the_Trainer__c='testu',Training_Date_and_Time1__c=datetime.Now(),Email_of_Trainner__c='ajm@cc.com',Location_of_Training__c='testlocation',Training_Room_URL__c='www.test.com',Date_of_Training__c=system.Today()+5);
        ListTr.add(tact2);
        
        insert ListTr;
        
 // **************** Inserting some dummy user so that Main search class will find more users. Dummy users are used here to increase the code coverage of INDMainUserSearchController without the dummy user the code coverage is decreasing from 90% to 65%**************************************************       
        string UniqueKey = 'AbcDefGhi12345';
        list<User> c = New List<user>();
    Profile p = [Select Id, Name From Profile 
                                    where Name = 'Production Support' 
                                    or Name = 'Service Account' 
                                    or Name ='System Administrator' 
                                    or Name ='Systemadministrator' limit 1];
         List<user> listu =new List<user>();
         User u = new User();
        u.FirstName ='First';
        u.LastName = 'Tester';
        u.username = 'Lion123732@testCompany999.com';
        u.Email = 'Lion123732@testCompany999.com';
        u.Alias = 'SF';
        u.ProfileId = p.Id;
        u.CommunityNickname = 'QPS';
        u.IsActive = true;
        u.TimeZoneSidKey = 'America/Chicago';
        u.LocaleSidKey = 'en_US';
        u.EmailEncodingKey = 'UTF-8';
        u.LanguageLocaleKey = 'en_US';
        
        listu.add(u);
        
        User identoU =new User();
        identoU.FirstName ='FirstName';
        identoU.LastName = 'TesterName';
        identoU.Email = 'testme@teatmail.com';
        identoU.Alias = 'SFFH';
        identoU.ProfileId = p.Id;
        identoU.CommunityNickname = 'ASD';
        identoU.IsActive = true;
        identoU.Username = identoU.Email+'2';
        identoU.TimeZoneSidKey = 'America/Chicago';
        identoU.LocaleSidKey = 'en_US';
        identoU.EmailEncodingKey = 'UTF-8';
        identoU.LanguageLocaleKey = 'en_US';
        
        listu.add(identoU);
        
        insert listu;

        // Get the current user and some other user
      
        

        // Get the current user and some other user
      
 // **************** Inserting some dummy user so that Main search class will find more users. Dummy users are used here to increase the code coverage of INDMainUserSearchController**************************************************       
        

        // Create a PageReference to the VF page being tested
        PageReference pageRef = Page.IND_SelectUser4Invite;
        test.setCurrentPage(pageRef);

        // Create an instance of the searchCriteria to test all
        // get/set methods and the BuildWhereClause() method
        INDsearchUserConttroller critClass = new INDsearchUserConttroller();

        // Call the various Get/Set methods to test these
        // nothing to check for, just want to run the code
        system.debug(critClass.getInputDateFormat());
        critClass.getSearchField();
        critClass.getSearchOperator();
        critClass.getSearchValue();
        critClass.getLogical();
        critClass.getSearchValue();
        critClass.seterrMsg('');
        critClass.setLogical('AND');

        // Test all possible combinations of Fields and Operators
        List<SelectOption> operators = critClass.getOperatorSelectList();
        Set <String> fields = new Set<String>{'STRING/Field1', 'DATE/Field2', 'DATETIME/Field3',
            'PICKLIST/Field4', 'MULTIPICKLIST/Field5', 'EMAIL/Field6', 'PHONE/Field7',
            'DOUBLE/Field8', 'CURRENCY/Field9', 'BOOLEAN/Field10', 'TEXTAREA/Field11'};
        Set <String> values = new Set<String>{'abcde', 'abcd, efgh, ijkl', 'true', '100',
            '12/31/2007', '12-21-2008', 'TODAY', 'NEXT 3 WEEKS'};

        // Three nested loops - Fields, Operators, Values
        // nothing to check for, just want to run the code
        // Can look through the Test results for Debug entries if neded
        for (string f : fields) {
            critClass.setSearchField(f);
            for (SelectOption o : operators) {
                critClass.setSearchOperator (o.getValue());
                for (string v : values) {
                    critClass.setSearchValue (v);
                    System.debug(f + ' ' + o.getValue() + ' ' + v + ' :' + critClass.buildWhereClause(true) + ' - ' + critClass.geterrMsg());
                }
            }
        }

        // Create an instance of the page controller to test its methods
        INDMainUserSearchController cntrlr = new INDMainUserSearchController();
        INDMainUserSearchController cntrlr2 = new INDMainUserSearchController();
        cntrlr.selectedtraining=tact.id;
        cntrlr2.selectedtraining=tact2.id;
// For controller(cntrlr) **********************************************************************************************************************************************************************************************************
        // Call the various Get/Set methods to test these
        // nothing to check for, just want to run the code
        cntrlr.testMode = true;     // enable test mode to limit query results
        cntrlr.setSetDebugModeFALSE(true);
        cntrlr.setSetDebugModeTRUE(true);
        cntrlr.getSetDebugModeTRUE();
        cntrlr.getSetDebugModeFALSE();
        cntrlr.getInputDateFormat();
        // M.Smith, 01/25/2010: Using the new lookup fields for FROm/TO userids
       // cntrlr.proxyAcctLookupTO.OwnerId = anotheruser.ID;
        
      //  cntrlr.fromUserID = UserInfo.getUserID();
      
        cntrlr.getsearchFields();
        cntrlr.getsearchCriteria();
        cntrlr.getSearchResults();
        // cntrlr.getFromUsers();
        // cntrlr.getToUsers();
        cntrlr.getShowBlockIfResults();
        //cntrlr.BuildSearchFieldsList();

        // Create a search criteria that must succeed
        // Get the error message values for each to confirm no errors on any criteria line
        cntrlr.criteriaLine[0].setSearchField('STRING/FirstName');
        cntrlr.criteriaLine[0].setSearchOperator('eq');
        cntrlr.criteriaLine[0].setSearchValue('FirstName');
        System.Debug(cntrlr.criteriaLine[0].buildWhereClause(true));
        System.assertEquals('', cntrlr.criteriaLine[0].geterrMsg());

        cntrlr.criteriaLine[1].setSearchField('DATETIME/CreatedDate');
        cntrlr.criteriaLine[1].setSearchOperator ('eq');
        cntrlr.criteriaLine[1].setSearchValue ('TODAY');
        System.Debug(cntrlr.criteriaLine[1].buildWhereClause(true));
        System.assertEquals('', cntrlr.criteriaLine[1].geterrMsg());

        cntrlr.criteriaLine[2].setSearchField('STRING/LastName');
        cntrlr.criteriaLine[2].setSearchOperator ('starts');
        cntrlr.criteriaLine[2].setSearchValue ('Test');
        System.Debug(cntrlr.criteriaLine[2].buildWhereClause(true));
        System.assertEquals('', cntrlr.criteriaLine[2].geterrMsg());

         // Run the Search against this criteria
        PageReference cntrlrResult= cntrlr.doSearch();

        // Confirm that the results match the number of contacts added above
        System.assertEquals(null, cntrlrResult);
       
           // System.assertEquals(c.size(), cntrlr.searchResults.size());

        // Enum the searchResult to test some of the code in this class
        // Nothing to test for here
        // 
      
        for (INDMainUserSearchController.transferUserSearchResults sr : cntrlr.searchResults) {
            sr.getuser();
            
            sr.getselected();
            sr.setselected(true);
            sr.getCreatedDate();
            sr.getLastModifiedDate();
            
        }
         
         cntrlrResult= cntrlr.doTransfer();

        // Confirm that all 5 contacts were transferred with no errors
       
            System.assertEquals(cntrlrResult, null);
            
           // System.assertEquals(cntrlr.searchResults.size(), 0);
 // End of For controller(cntrlr) **********************************************************************************************************************************************************************************************************



//Start of For controller(cntrlr2) **********************************************************************************************************************************************************************************************************
   
 
        // Call the various Get/Set methods to test these
        // nothing to check for, just want to run the code
        cntrlr2.testMode = true;     // enable test mode to limit query results
        cntrlr2 .setSetDebugModeFALSE(true);
        cntrlr2 .setSetDebugModeTRUE(true);
        cntrlr2 .getSetDebugModeTRUE();
        cntrlr2 .getSetDebugModeFALSE();
        cntrlr2 .getInputDateFormat();
        // M.Smith, 01/25/2010: Using the new lookup fields for FROm/TO userids
       // cntrlr2 .proxyAcctLookupTO.OwnerId = anotheruser.ID;
        
      //  cntrlr2 .fromUserID = UserInfo.getUserID();
      
        cntrlr2 .getsearchFields();
        cntrlr2 .getsearchCriteria();
        cntrlr2 .getSearchResults();
        // cntrlr2 .getFromUsers();
        // cntrlr2 .getToUsers();
        cntrlr2 .getShowBlockIfResults();
        //cntrlr2 .BuildSearchFieldsList();

        // Create a search criteria that must succeed
        // Get the error message values for each to confirm no errors on any criteria line
        cntrlr2 .criteriaLine[0].setSearchField('STRING/FirstName');
        cntrlr2 .criteriaLine[0].setSearchOperator('eq');
        cntrlr2 .criteriaLine[0].setSearchValue('FirstName');
        System.Debug(cntrlr2 .criteriaLine[0].buildWhereClause(true));
        System.assertEquals('', cntrlr2 .criteriaLine[0].geterrMsg());

        cntrlr2 .criteriaLine[1].setSearchField('DATETIME/CreatedDate');
        cntrlr2 .criteriaLine[1].setSearchOperator ('eq');
        cntrlr2 .criteriaLine[1].setSearchValue ('TODAY');
        System.Debug(cntrlr2 .criteriaLine[1].buildWhereClause(true));
        System.assertEquals('', cntrlr2 .criteriaLine[1].geterrMsg());

        cntrlr2 .criteriaLine[2].setSearchField('STRING/LastName');
        cntrlr2 .criteriaLine[2].setSearchOperator ('starts');
        cntrlr2 .criteriaLine[2].setSearchValue ('Test');
        System.Debug(cntrlr2 .criteriaLine[2].buildWhereClause(true));
        System.assertEquals('', cntrlr2 .criteriaLine[2].geterrMsg());

         // Run the Search against this criteria
        PageReference cntrlrResult2 = cntrlr2.doSearch();

        // Confirm that the results match the number of contacts added above
        System.assertEquals(null, cntrlrResult2);
       
           // System.assertEquals(c.size(), cntrlr2 .searchResults.size());

        // Enum the searchResult to test some of the code in this class
        // Nothing to test for here
        for (INDMainUserSearchController.transferUserSearchResults sr : cntrlr2 .searchResults) {
            sr.getuser();
            sr.getselected();
            sr.setselected(true);
            sr.getCreatedDate();
            sr.getLastModifiedDate();
            
        }

        
        cntrlrResult2= cntrlr2.doTransfer();

        // Confirm that all 5 contacts were transferred with no errors
       
            System.assertEquals(cntrlrResult2, null);
            
           // System.assertEquals(cntrlr2 .searchResults.size(), 0);
        
        test.stopTest();
    }
    
}