public class INDMainUserSearchController {

/*********************************************************************************************************************** 
 Name: INDMainUserSearchController  
 Salesforce Instance : Sandbox
========================================================================================================================
 Purpose: The Class is used for inviting the user fro the training and also used for sending invitaion when selected and create 
          the Learning and response record attach them with the training record..                                                
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Deepak                15 Dec 2015   Initial Development                                         
***********************************************************************************************************************/

    public boolean DebugMode = false;

    // Feb 2015: Need to know when in test mode to limit SOQL query results
    public boolean testMode = false;

    // Collection of search results for displaying
    public List<transferUserSearchResults> searchResults = new List<transferUserSearchResults>();

    // Collection of criteria lines items using Wrapper class
    public List<INDsearchUserConttroller> criteriaLine = New List<INDsearchUserConttroller>();

    // Collection of fields for criteria picklist - build this once and reuse for each line
    public List<SelectOption> cacheFieldSelectValues = new List<SelectOption>();

    // Flag to identify when a transfer was just completed and running the query a second time for additional records
    private Boolean transferJustCompleted = false;

    // Capture a Map and Set of User Fields so we only do the Describe ONCE per instance
    private Map<String, Schema.SObjectField> UserFieldMap = null;
    Public List<Training__c> displaytraining{get;set;}
    Public Training__c selectedtrainingall{get;set;}
    Public Map<id,recordtype> trainingrecordtype{get;set;}
    Public List<recordtype> LLRrecordtype{get;set;}
    public Map<id,id> recordtypeflag= new Map<id,id>();
    public String selectedtraining{get;set;}
    public String selectedrecordtype{get;set;}
    Map<id,id> NewFinalRSMap = new  Map<id,id>();
    // ------------------------------------------------
    // Constructor Method
    // ------------------------------------------------
   
 // *************************************************************** Constractor Method **********************************************************************************************************  
   
    public INDMainUserSearchController() {

        // Build a cached list of user fields for the criteria picklist
        BuildSearchFieldsList();

        // Init the criteria object to be used on the page via <Apex:DataTable>
        for (integer j = 0; j < 5; j++) {
            INDsearchUserConttroller critLine = new INDsearchUserConttroller();
            critLine.SearchField = '';
            critLine.SearchOperator = '';
            critLine.SearchValue = '';
            if (j < 4) critLine.Logical = 'AND';
            criteriaLine.add(critLine);
         
           
        }
          displaytraining=[select id,Active__c,recordtypeid,name from Training__c where active__c=true];
        // Define the private vars of the Map and Set of user Fields
        // so we only do the describe one time
        UserFieldMap = Schema.SObjectType.user.fields.getMap();
        
        trainingrecordtype=new map<id,recordtype >([select id,name,developername from recordtype where isactive=true and SobjectType='training__c']);
        LLRrecordtype=[select id,name,developername from recordtype where isactive=true and SobjectType='Learning_Response_Result__c'];
        RTItems();
        
        
    }
    
 //*************************************************************************Constractor Method ****************************************************************************************************************   


// ****************************************************************************** Custom Function ****************************************************************************************************
  //Start of code for fetching the active training  
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        if(displaytraining!=null)
        {
        for(Training__c tt:displaytraining)
        {
        options.add(new SelectOption(tt.id,tt.name)); 
        }
        }
        return options;
    }
 //End of code for fetching the active training  
 
 //Start of code for maping the learning and response record type id based on training record type id     
    
     Public Void dotrainingsearch() 
    {
    selectedtrainingall=[select id,Duration_of_Exam_in_Minutes__c,recordtypeid,Active__c,name from Training__c where id=:selectedtraining];
    selectedrecordtype=selectedtrainingall.recordtypeid;
    
    }
    
     public void RTItems() 
      {
        
        for(recordtype trt:trainingrecordtype.values())
        {
         for(recordtype llt:LLRrecordtype)
          {
            if(trt.developername=='Training_with_Response_Date_Slots' && llt.developername=='Participant_with_Response_Date_Slots')
             {
               recordtypeflag.put(trt.id,llt.id);
             } 
             if(trt.developername=='Training_with_Response_Exam_Date_Slots' && llt.developername=='Participant_with_Response_Exam_Date_Slots')
             {
              recordtypeflag.put(trt.id,llt.id);
             } 
             if(trt.developername=='Training_with_Response_without_Date_Slots' && llt.developername=='Participant_with_Response_without_Slots')
             {
              recordtypeflag.put(trt.id,llt.id);
             } 
             if(trt.developername=='Training_with_Response_Exam_without_Date_Slots' && llt.developername=='Participant_with_Response_and_Exam_without_Slots')
             {
               recordtypeflag.put(trt.id,llt.id);
             }             
            
          }
        
        }
      }
    
    
 //End of code for maping the learning and response record type id based on training record type id     
     

// ------------------------------------------------

    // Get/Set methods to enable or disable DebugMode on the page.
    // This is called by an InputHidden tag on the page
    public boolean getSetDebugModeTRUE()    { this.DebugMode = true; return TRUE; }
    public boolean getSetDebugModeFALSE()   { this.DebugMode = false; return FALSE; }
    public void setSetDebugModeTRUE(boolean x)  { this.DebugMode = true; }
    public void setSetDebugModeFALSE(boolean x) { this.DebugMode = false; }

    // Returns the date format (MM/DD/YYYY, DD/MM/YYYY, etc.) that criteria should be entered in
    // This is determined in the CriteriaWrapper class by loooking at the users Locale settings
    public string getInputDateFormat() { return criteriaLine[0].getInputDateFormat() ; }

// ------------------------------------------------

   

    // Return the list of User fields for the criteria picklists
    public List<SelectOption> getsearchFields() {
        return this.cacheFieldSelectValues;
    }

    // Create a SelectOption list User fields for a select list
    // Uses a method in the Criteria Class to build the select lists for the two objects
    private void BuildSearchFieldsList() {

        if (cacheFieldSelectValues.size() == 0) {

            // Create the Schema Lists for the User objects
            Schema.DescribeSObjectResult contactDescribe = User.sObjectType.getDescribe();
           // Schema.DescribeSObjectResult accountDescribe = SIP__c.sObjectType.getDescribe();

            // Create the Maps of Fields for the User objects
            Map<String, Schema.SObjectField> contactFields = Schema.SObjectType.User.fields.getMap();
          //  Map<String, Schema.SObjectField> accountFields = Schema.SObjectType.Sip__c.fields.getMap();

            INDsearchUserConttroller critClass = new INDsearchUserConttroller();

            // Return SelectOption lists for the User objects
            List<SelectOption> sel1 = critClass.GetFieldsForObject(contactFields, '', '');
           // List<SelectOption> sel2 = critClass.GetFieldsForObject(accountFields, 'Plan_Participant.', 'Plan_Participant.');

            // Combine the two returned SelectOption[] lists into a single list
            List<SelectOption> options = new List<SelectOption>();
            options.add(new selectOption('', '- select field -'));
            for (Selectoption selOpt : sel1) {
                options.add(selOpt);
            }
            
            // Set the cached value so we only do this once per instance
            cacheFieldSelectValues = options;

        }
    }

    // ------------------------------------------------
    // Returns a List<> of Criteria Objects for use with <Apex:DataTable>
    // to allow multiple lines to be displayed and the values retrievable
    // ------------------------------------------------
    public list<INDsearchUserConttroller> getsearchCriteria() {
        return criteriaLine;
    }

    // -------------------------------------------------------------------------------------
    // SEARCH BUTTON:
    // Builds SOQL Statement based on selection criteria
    // Fills searchResults[] list
    // -------------------------------------------------------------------------------------
    public pageReference doSearch() {
       
         dotrainingsearch();
         Set<id> oldlrr=new set<id>();
         for(Learning_Response_Result__c oldlistLRR:[select id,User_Record_ID__c from Learning_Response_Result__c where Training__c=:selectedtraining]) 
         {
           oldlrr.add(oldlistLRR.User_Record_ID__c);
         }            
        Set <String> UserFlds = UserFieldMap.keySet();
        string contactFieldsList = '';
        for (string f : UserFlds) {
            string fldType = ('' + UserFieldMap.get(f).getDescribe().getType()).replace('Schema.DisplayType.', '') ;
            if (fldType <> 'REFERENCE' && f <> 'IsDeleted' && f <> 'SystemModstamp') {
                if (contactFieldsList <> '') contactFieldsList += ', ';
                contactFieldsList += f;
            }
        }

       // Build the base SOQL String, querying the standard User fields 
        string cSOQL = 'SELECT ' + contactFieldsList + ',Profile.Name FROM USER WHERE isActive = True AND id NOT IN :oldlrr' ;
  
        for (INDsearchUserConttroller cl : criteriaLine) {
                cSOQL += cl.buildWhereClause(DebugMode);
        }

        // Sort the results and limit to the first 250 rows
        cSOQL += ' ORDER BY lastName, Name LIMIT 250' ;

        // Debug: Display the SOQL Query string
        if (DebugMode) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, cSOQL));

        // Run the database query and place results into the transferUserSearchResults class
        try {
            searchResults.clear();
            List<user> results = Database.Query(cSOQL);

            // If zero or more than 250 records returned, display a message
            if (results.size() == 250) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'NOTE: Only the first 250 rows are displayed, User Confirmed once for invite will be not added in next search result, until you clear the previous contact invite.'));
            if (results.size() == 0 && !transferJustCompleted) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'NO RECORDS FOUND.'));

            // Build the searchResults[] list used by the Apex:DataTable tag on the page
            for (user c : results) {
                searchResults.add( new transferUserSearchResults(c) ) ;
            }

        } catch (Exception ex) {
                // ERROR! Display message on screen
            ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Query Error: ' + ex.getMessage()));
        }

        transferJustCompleted = false;     // Reset the flag used to track when a transfer was completed versus a new query
        return null;

    }

    // Return searchResults to the DATAGRID
    public list<transferUserSearchResults> getSearchResults() {
       
            return this.searchResults;
       
    }

    // Used with the Style attribute on the OutputPanel tag show the search results if there are any
    public string getShowBlockIfResults() {
        if (this.searchResults.size() > 0) {
            return 'display: block;' ;
        } else {
            return 'display: none;' ;
        }
    }

    // ----------------------------------------------------------------------
    // Confirm Button:
    // - Query the selected contacts
    // - Change the OwnerID
    // - Call database.update()
    // - Check for errors
    // - Send an eMail if needed
    // - Rerun the query to display any remaining contacts
    // ----------------------------------------------------------------------
    
   Public Void insertlRSummary()
        {
        List<string> IDs = New List<string>();
        for (transferUserSearchResults c : searchResults) {
            if (c.selected) IDs.add(c.user.ID) ;
        }
          
          
          List<user> Listuser = [SELECT Id,Region__c,firstname,lastname,Sub_Vertical__c,Te_Network_Id__c,Name,email FROM user WHERE ID IN :IDs];
          List<L_R_Result_Summary__c> oldrs =[select id,TE_Network_ID__c,Salesforce_User_ID__c,Participant_User__c from L_R_Result_Summary__c where Salesforce_User_ID__c IN :IDs AND TE_Network_ID__c !=null];
           Set<string> OldRSMap = new  set<string>();
          
          if(OldRSMap!=Null){
          for(L_R_Result_Summary__c rs:oldrs)
          {
           
           OldRSMap.add(rs.TE_Network_ID__c); 
           }         
          }
          List<L_R_Result_Summary__c> Newinsertrs= new List<L_R_Result_Summary__c>();
          
          
         for (user currentUser: Listuser ) 
         {
         if(!OldRSMap.contains(currentUser.TE_Network_ID__c))
           {
            L_R_Result_Summary__c newrs = new L_R_Result_Summary__c();
            newrs.Participant_User__c=currentUser.id;
            newrs.Salesforce_User_ID__c=currentUser.id;
            Newinsertrs.add(newrs);
           
           }
         }
        insert Newinsertrs;  
    }
    
          
      
      
      
      Public List<spExams__User_Exam__c> insertexamuser(List<Learning_Response_Result__c> l,List<user> u1)
        {
        
        Set<id> IDs = New set<id>();
        for (user u2: u1) {
           IDs.add(u2.id) ;
        }
        
          List<user> Listuser = u1;        
          List<spExams__User_Exam__c> listexamuser= new List<spExams__User_Exam__c>();
          spExams__User_Exam__c examuser =new spExams__User_Exam__c(); 
          spExams__Exam__c relatedexam=[select id,Training__c,spExams__Exam_Duration__c from spExams__Exam__c where Training__c=:selectedtraining limit 1];
        
         List<Learning_Response_Result__c> listLRR =l; 
         
         
         
         for(Learning_Response_Result__c currentUser:listLRR)
         {
         examuser =new spExams__User_Exam__c();
         examuser.spExams__First_Name__c=currentUser.First_Name__c;
         examuser.spExams__Last_Name__c=currentUser.Last_Name__c;
         examuser.spExams__User_Id__c=currentUser.User_Record_ID__c;
       
         examuser.spExams__Status__c='Pending';
         examuser.spExams__Email__c=currentUser.Email_of_Participant__c;
         examuser.spExams__Remaining_Time__c=relatedexam.spExams__Exam_Duration__c;
         examuser.spExams__Exam__c=relatedexam.id;
         examuser.Learning_Response_Result__c=currentUser.id;
         
         listexamuser.add(examuser);
         }
         return(listexamuser);
        }
        
        
        
  //Start of code for creating the learning and response record for each participant and attaching that record to respeective training      
  //Also creating the exam if the exam reponse record if exam is required for training       
    public pageReference doTransfer() {
        dotrainingsearch();
       // Build a list of Contact ID's to transfer ownership for
        List<string> IDs = New List<string>();
        for (transferUserSearchResults c : searchResults) {
            if (c.selected) IDs.add(c.user.ID) ;
        }
        if (DebugMode) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Selected Count: ' + IDs.size()));
        
        // set a database savepoint that can be used to rollback the changes if it fails
        SavePoint sp = database.setSavepoint();
        
        //List<database.saveresult> srs = null;
       // List<database.saveresult> usersrs = null;
        Integer transferCount = 0;
        
          Learning_Response_Result__c newLRR =new Learning_Response_Result__c();
          List<Learning_Response_Result__c> listNewLRR = new List<Learning_Response_Result__c>();
          List<user> Listuser = [SELECT Id,Region__c,firstname,lastname,Sub_Vertical__c,Te_Network_Id__c,Name,email FROM user WHERE ID IN :IDs];
          List<spExams__User_Exam__c> listexamuser= new List<spExams__User_Exam__c>();
          spExams__User_Exam__c examuser =new spExams__User_Exam__c();  
          list<Learning_Response_Result__c> oldlistLRR =[select id,User_Record_ID__c,recordtypeid,Training__c,TE_Network_ID__c from Learning_Response_Result__c where Training__c=:selectedtraining];
          Map<string,string> Finaloldmap = new  Map<string,string>();
          insertlRSummary();                  
          
          for(Learning_Response_Result__c llr:oldlistLRR )
          {
           Finaloldmap.put(llr.TE_Network_ID__c,'True');          
          }
          
          List<L_R_Result_Summary__c> oldrs =[select id,Salesforce_User_ID__c,TE_Network_ID__c,Participant_User__c from L_R_Result_Summary__c where Salesforce_User_ID__c IN :IDs];
          
          
          for(L_R_Result_Summary__c rs:oldrs)
          {
           NewFinalRSMap.put(rs.Salesforce_User_ID__c,rs.id);          
          }
      
        for (user currentUser: Listuser ) 
        {
         if(Finaloldmap.get(currentUser.TE_Network_ID__c)!='True')
                 {
               newLRR= new Learning_Response_Result__c();
               newLRR.Name_of_Participant__c=currentUser.firstname+' '+currentUser.lastname;
               newLRR.First_Name__c=currentUser.firstname;
               newLRR.Last_Name__c=currentUser.lastname;
               newLRR.Region__c=currentUser.Region__c;
               newLRR.Result_Summary__c=NewFinalRSMap.get(currentUser.id);
               newLRR.Status_of_Participant__c='Invited for Training';
               newLRR.Sub_Vertical_BU__c=currentUser.Sub_Vertical__c;
               newLRR.TE_Network_ID__c=currentUser.Te_Network_Id__c;
             
               newLRR.User_Record_ID__c=currentUser.id;
               newLRR.Email_of_Participant__c=currentUser.email;
               newLRR.Training__c=selectedtraining;
               newLRR.recordtypeid=recordtypeflag.get(selectedrecordtype);
                
              listNewLRR .add(newLRR);
            }
          
        }   
            
            
           
          
     
          // currentUser.Send_Invite__c = True;  
       
       
        // Process Errors and Count the Number of Records Transferred
        List<string> txfrdIDs = New List<string>(); // Remember which contacts were transferred
        try {
           // update(Listuser);
            insert(listNewLRR);
            
            
            if(trainingrecordtype.get(selectedrecordtype).developername=='Training_with_Response_Exam_Date_Slots' || trainingrecordtype.get(selectedrecordtype).developername=='Training_with_Response_Exam_without_Date_Slots') //selectedrecordtype=='012c00000008na4AAA' || selectedrecordtype=='012c00000008nkOAAQ')
              {
               List<spExams__User_Exam__c> listexamparticipant=insertexamuser(listNewLRR,Listuser);
                insert(listexamparticipant);
              }
            
            transferCount = listNewLRR.size();
          
        } catch (DMLexception e) {

           // Catch errors here and try to give a nicer message to the user
            // Log the Errors and Rollback the changes
            for (integer i = 0; i < e.getNumDml(); i++) {
                ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                   e.GetDmlId(i) + ': ' + e.getDmlMessage(i) ));
                for (string f : e.getDmlFieldNames(i)){
                    system.debug(LoggingLevel.Error, '++++ Transfer Error: ' + e.GetDmlId(i) + '/' + f + ': ' + e.getDmlMessage(i));
                }
            }
            database.rollback(sp);
            return null;
        }
       
        if (transferCount <> Listuser.size() && transferCount > 0) {
            // Requery the contacts to figure out which were transferred and which were not.
            List<user> contacts2 = [SELECT ID,Name FROM user WHERE ID IN :IDs];
            Listuser = new List<user>();
            for (user c : contacts2) {
               if (c.id != null) Listuser.add(c);
            }
        }

        // Display the Transfer Count
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, transferCount + ' Invites are sent Successfully to the User who are marked for invite' ));

        transferJustCompleted = true;

        // Re-run the [Search] button functionality.
        doSearch();
      
        return null;
    }

   
    private string null2String(string s) { if (s == null) return ''; else return s; }

    /* -------------------------------------------------------------------------------------
    * transferUserSearchResults: Mass Transfer Search Results Wrapper Class
    * - Used by the Search Class and Page
    * - Main purpose is to return a LIST of user along with a custom checkbox that can
    *   be used to let the user select which rows to transfer and which to ignore.
    *  ------------------------------------------------------------------------------------- */
    Public Class transferUserSearchResults{

        public boolean selected = true;
        public user user = null;

        public transferUserSearchResults() { }
        public transferUserSearchResults(user c) { user = c; }

        public user getuser()         { return this.user ; }
        public void setuser(user c)   { this.user= c; }

        public boolean getselected()        { return this.selected; }
        public void setselected(boolean s)  { this.selected = s; }

        // Returns these DateTime fields as Date types formatted based on the current users Locale setting in SalesForce
       public string getCreatedDate()      { return date.newInstance(this.user.CreatedDate.year(), this.user.CreatedDate.month(), this.user.CreatedDate.day()).format() ; }
       public string getLastModifiedDate() { return date.newInstance(this.user.LastModifiedDate.year(), this.user.LastModifiedDate.month(), this.user.LastModifiedDate.day()).format() ; }
    }
    
    
    
   
    
 
    
}