/*------------------------------------------------------------
Author:        Yuan Yao <yuan.yao@capgemini.com>
Description:   A class for DeepClone custom button on Opportunity object.
Inputs:        controller - ApexPages.StandardController of Opportunity
Test Class:    ExtOpportunityDeepClone_Test.cls
History
2017-09-22 	Yuan Yao <yuan.yao@capgemini.com> Created
2017-09-23 	Yiming Shen <yiming.shen@capgemini.com> Modified
------------------------------------------------------------*/
global class ExtOpportunityDeepClone {
    public static boolean serialhelper = true;
    Pagereference p;
    public Id oppid {get; set;}
    Id newoppid, rectypeid;
    public Opportunity oppy;
    public Opportunity oppyClone {get; set;}
    public Boolean isCompetingOppy {get; set;}
    public Id jobId {get; set;}
    public AsyncApexJob jobInfo {get; set;}
    Map<ID,String> OldNewOppIds = New Map<ID,String>();
    List<ANZ_Clause__c> varANZClause = new List<ANZ_Clause__c>();    
    public static boolean bool_isInOpportunityDeepClone = false;
    
    public ExtOpportunityDeepClone(ApexPages.StandardController controller){
    	bool_isInOpportunityDeepClone = true;
        oppid = controller.getId(); 
        isCompetingOppy = Boolean.valueOf(ApexPages.CurrentPage().getParameters().get('isCompetingOppy'));
        System.debug('---isCompetingOppy:::' + isCompetingOppy); 
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to clone Opportunity except Primary_Opportunity__c(Deep Clone).
				   Function to clone Opportunity including Primary_Opportunity__c(Competing Opportunity).
	Inputs:        
	Returns:       Pagereference - the new Opportunity edit page
	History
	2017-10-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public void cloneOpportunity(){
        //0. set skip trigger handler
        ClsTriggerRecursionDefense.OpportunityAnzClauseTrigger = false;
        ClsTriggerRecursionDefense.isSkipCreateANZClause = true; //added by Tangyong Li 2018-03-16
        //1. deep clone Opportunity
        try{
        	String query = 'SELECT ';
        	Schema.FieldSet oppyFieldSet = (isCompetingOppy)? Schema.SObjectType.Opportunity.fieldSets.Competing_Opportunity : Schema.SObjectType.Opportunity.fieldSets.Deep_Clone;
	        for(Schema.FieldSetMember f : oppyFieldSet.getFields()){
	            query += f.getFieldPath() + ', ';
	        }
	        query += 'Id FROM Opportunity Where Id =: oppid LIMIT 1';
        	System.debug('---query:::' + query);
        	oppy = Database.query(query);
	        oppyClone = oppy.clone(false,true,false,false); 
	        oppyClone.Name += '-Clone';
	        oppyClone.StageName = 'Initiation';
	        oppyClone.Probability__c = '10';
	        oppyClone.Probability = 10;
	        oppyClone.CloseDate = Date.today().addMonths(1);
	        if(isCompetingOppy){
		        //oppyClone.Primary_Opportunity__c = (oppy.Primary_Opportunity__c != null)? oppy.Primary_Opportunity__c : oppy.Id;
		        //if(oppy.Primary_Opportunity__c != null){
		        //	oppyClone.Amount = oppy.Primary_Opportunity__r.Amount;
		        //}
		        oppyClone.Master_Opportunity__c = (oppy.Master_Opportunity__c != null)? oppy.Master_Opportunity__c : oppy.Id;
		        /*if(oppy.Master_Opportunity__c != null){
		        	oppyClone.Amount = oppy.Master_Opportunity__r.Amount;
		        }*/
		        oppyClone.Amount = (oppy.Master_Opportunity__c != null)? oppy.Master_Opportunity__r.Amount : oppy.Amount;
	        }else{
	        	oppyClone.CloseDate = Date.today().addMonths(1);
	        }
	        oppyClone.Approval_Status__c = 'Approval Not Needed';
	        System.debug('---oppyClone.Amount:::' + oppyClone.Amount);
	        System.debug('---oppy limit:::' + limits.getQueries());
	        insert oppyClone;
	        System.debug('---oppy limit:::' + limits.getQueries());
	        //cloneOppyParts(oppyClone.Id, oppy.Id);
	        jobId = System.enqueueJob(new ClsCloneOppyPartQueue(oppyClone.Id, oppy.Id));
	        jobInfo = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id=: jobId];
	        system.debug('jobInfo::::  ' + jobInfo);
	        cloneDetails(oppyClone.Id, oppy.Id);
	        p = new Pagereference('/' + oppyClone.Id + '/e?retURL=%2F' + oppyClone.Id); 
        } catch(Exception e) {
        	String vStrError = 'Error Type = ' + e.getTypeName() + ' Error Line = ' + e.getLineNumber() + '' + ' Error Stack = ' + e.getStackTraceString() + ' Error Message = ' + e.getMessage();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, vStrError));
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc, SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '', e.getStackTraceString());
        	//ErrorLogging.Log(e);
        }
        //return p;
    }
    
    
    public void checkJobStatus(){
    	jobInfo = [SELECT Id, Status, NumberOfErrors FROM AsyncApexJob WHERE Id=: jobId];
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to clone detail records.
	Inputs:        oppyId - the cloned opportunity Id
				   oppyCloneId - the new Opportunity Id
	Returns:       
	History
	2017-10-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    @future
    public static void cloneDetails(Id oppyCloneId, Id oppyId){
    	bool_isInOpportunityDeepClone = true;
    	cloneOpportunityTeamMembers(oppyCloneId, oppyId);
	        
        cloneOpportunityPartners(oppyCloneId, oppyId);
	        
        cloneANZClauses(oppyCloneId, oppyId);
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to clone Opportunity_Part__c records.
	Inputs:        oppyId - the cloned opportunity Id
				   oppyCloneId - the new Opportunity Id
	Returns:       
	History
	2017-10-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public static void cloneOppyParts(Id oppyCloneId, Id oppyId){
    	System.debug('---oppyPart limit:::' + limits.getQueries());
    	String queryOppyPart = 'SELECT ';
    	Schema.FieldSet oppyPartFieldSet = Schema.SObjectType.Opportunity_Part__c.fieldSets.Clone_Opportunity;
        for(Schema.FieldSetMember f : oppyPartFieldSet.getFields()){
            queryOppyPart += f.getFieldPath() + ', ';
        }
    	queryOppyPart += 'Id FROM Opportunity_Part__c WHERE Opportunity__c =: oppyId';
    	List<Opportunity_Part__c> list_OppyParts2Clone = new List<Opportunity_Part__c>();
        for(Opportunity_Part__c oppyPart : Database.query(queryOppyPart)){
            list_OppyParts2Clone.add(oppyPart);
        }
        System.debug('---list_OppyParts2Clone:::' + list_OppyParts2Clone.size());
        if(list_OppyParts2Clone.size() > 0){
            List<Opportunity_Part__c> list_OppyParts2Insert = list_OppyParts2Clone.deepClone(false,false,false);
            for(Opportunity_Part__c oppyPart : list_OppyParts2Insert){
                oppyPart.Opportunity__c = oppyCloneId;
                oppyPart.Status__c = 'Pending';
            }
            System.debug('---list_OppyParts2Insert:::' + list_OppyParts2Insert.size());
        	insert list_OppyParts2Insert;
        }
        System.debug('---oppyPart limit:::' + limits.getQueries());
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to clone related opportunity team members.
	Inputs:        oppyId - the cloned opportunity Id
				   oppyCloneId - the new Opportunity Id
	Returns:       
	History
	2017-10-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public static void cloneOpportunityTeamMembers(Id oppyCloneId, Id oppyId){ 
        List<OpportunityTeamMember> list_OppyTeams2Clone = new List<OpportunityTeamMember>();
        for(OpportunityTeamMember oppyTeam : [SELECT OpportunityAccessLevel, OpportunityId, TeamMemberRole, UserId FROM OpportunityTeamMember WHERE OpportunityId =: oppyId]){
            list_OppyTeams2Clone.add(oppyTeam);
        }
        System.debug('---list_OppyTeams2Clone:::' + list_OppyTeams2Clone.size());
        if(list_OppyTeams2Clone.size() > 0){
            List<OpportunityTeamMember> list_OppyTeams2Insert = list_OppyTeams2Clone.deepClone(false,false,false);
            for(OpportunityTeamMember oppyTeam : list_OppyTeams2Insert){
                oppyTeam.OpportunityId = oppyCloneId;
            }
            System.debug('---list_OppyTeams2Insert:::' + list_OppyTeams2Insert.size());
            insert list_OppyTeams2Insert;
        }
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to clone related opportunity partners.
	Inputs:        oppyId - the cloned opportunity Id
				   oppyCloneId - the new Opportunity Id
	Returns:       
	History
	2017-10-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public static void cloneOpportunityPartners(Id oppyCloneId, Id oppyId){ 
       	List<Opportunity_Partner__c> list_OppyPartners2Clone = new List<Opportunity_Partner__c>();
        String queryOppyPartner = 'SELECT ';
    	Schema.FieldSet oppyPartnerrFieldSet = Schema.SObjectType.Opportunity_Partner__c.fieldSets.Clone_Opportunity;
        for(Schema.FieldSetMember f : oppyPartnerrFieldSet.getFields()){
            queryOppyPartner += f.getFieldPath() + ', ';
        }
    	queryOppyPartner += 'Id FROM Opportunity_Partner__c WHERE Opportunity__c =: oppyId';
    	for(Opportunity_Partner__c oppyPartner : Database.query(queryOppyPartner)){
            list_OppyPartners2Clone.add(oppyPartner);
        }
	    System.debug('---list_OppyPartners2Clone:::' + list_OppyPartners2Clone.size());
	   	if(list_OppyPartners2Clone.size() > 0){
	   		List<Opportunity_Partner__c> list_OppyPartners2Delete = new List<Opportunity_Partner__c>();
	        for(Opportunity_Partner__c oppyPartner : [SELECT Id FROM Opportunity_Partner__c 
	        											WHERE Opportunity__c =: oppyCloneId]){
	        	list_OppyPartners2Delete.add(oppyPartner);
	        }
	        System.debug('---list_OppyPartners2Delete:::' + list_OppyPartners2Delete);
	        
	        List<Opportunity_Partner__c> list_OppyPartners2Insert = list_OppyPartners2Clone.deepClone(false,false,false);
	        Map<String,Decimal> map_ExternalId_Allocation = new Map<String,Decimal>();
	        Integer index = 0;
	        for(Opportunity_Partner__c oppyPartner : list_OppyPartners2Insert){
	            oppyPartner.Opportunity__c = oppyCloneId;
	            if(list_OppyPartners2Delete.size() > 0){
	            	System.debug('---insert oppyPartner.Allocation__c:::' + oppyPartner.Allocation__c);
		        	oppyPartner.Energy_Record_Id__c = (String.isNotBlank(oppyPartner.Energy_Record_Id__c))? codeExternalId(oppyPartner.Energy_Record_Id__c,index) : codeExternalId('',index);
		            System.debug('---oppyPartner.Energy_Record_Id__c:::' + oppyPartner.Energy_Record_Id__c);
		            map_ExternalId_Allocation.put(oppyPartner.Energy_Record_Id__c, oppyPartner.Allocation__c);
		            index++;
		            oppyPartner.Allocation__c = 0;
	            }
	        }
	        System.debug('---map_ExternalId_Allocation:::' + map_ExternalId_Allocation);
	        System.debug('---list_OppyPartners2Insert:::' + list_OppyPartners2Insert);
	        if(list_OppyPartners2Insert.size() > 0){
	        	insert list_OppyPartners2Insert;
	        }
	        if(list_OppyPartners2Delete.size() > 0){
		        List<Opportunity_Partner__c> list_OppyPartners2Update = new List<Opportunity_Partner__c>();
		        for(Opportunity_Partner__c oppyPartner : list_OppyPartners2Insert){
		        	if(map_ExternalId_Allocation.containsKey(oppyPartner.Energy_Record_Id__c)){
		        		oppyPartner.Allocation__c = map_ExternalId_Allocation.get(oppyPartner.Energy_Record_Id__c);
		        	}
		        	System.debug('---oppyPartner.Allocation__c:::' + oppyPartner.Allocation__c);
		        	oppyPartner.Energy_Record_Id__c = decodeExternalId(oppyPartner.Energy_Record_Id__c);
		        }
		        for(Opportunity_Partner__c oppyPartner : list_OppyPartners2Delete){
		        	oppyPartner.Allocation__c = 0;
		        }
		        list_OppyPartners2Update.addAll(list_OppyPartners2Insert);
		        list_OppyPartners2Update.addAll(list_OppyPartners2Delete);
		        System.debug('---list_OppyPartners2Update:::' + list_OppyPartners2Update);
	        	update list_OppyPartners2Update;
	        	System.debug('---list_OppyPartners2Delete:::' + list_OppyPartners2Delete);
        		delete list_OppyPartners2Delete;
	        }
	    }
    }
    
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to clone related ANZClauses.
	Inputs:        oppyId - the cloned opportunity Id
				   oppyCloneId - the new Opportunity Id
	Returns:       
	History
	2017-10-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    public static void cloneANZClauses(Id oppyCloneId, Id oppyId){ 
        List<ANZ_Clause__c> list_ANZClauses2Clone = new List<ANZ_Clause__c>();
        String queryClause = 'SELECT ';
    	Schema.FieldSet clauseFieldSet = Schema.SObjectType.ANZ_Clause__c.fieldSets.Clone_Opportunity;
        for(Schema.FieldSetMember f : clauseFieldSet.getFields()){
            queryClause += f.getFieldPath() + ', ';
        }
    	queryClause += 'Id FROM ANZ_Clause__c WHERE Opportunity__c =: oppyId';
    	for(ANZ_Clause__c clause : Database.query(queryClause)){
            list_ANZClauses2Clone.add(clause);
        }
        System.debug('---list_ANZClauses2Clone:::' + list_ANZClauses2Clone.size());
        if(list_ANZClauses2Clone.size() > 0){
            List<ANZ_Clause__c> list_ANZClauses2Insert = list_ANZClauses2Clone.deepClone(false,false,false);
            for(ANZ_Clause__c clause : list_ANZClauses2Insert){
                clause.Opportunity__c = oppyCloneId;
            }
            System.debug('---list_ANZClauses2Insert:::' + list_ANZClauses2Insert.size());
            insert list_ANZClauses2Insert;
        }
    }

    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to code external Id as unique.
	Inputs:        externalId - the external Id before code
				   listIndex - the unique number
	Returns:       external Id after code
	History
	2018-01-04 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    private static String codeExternalId(String externalId, Integer listIndex){
    	return externalId + '-' + listIndex;
    }
    /*------------------------------------------------------------
	Author:        Yiming Shen <yiming.shen@capgemini.com>
	Description:   Function to decode external Id.
	Inputs:        externalId - the external Id before decode
	Returns:       external Id after decode
	History
	2017-10-10 	Yiming Shen <yiming.shen@capgemini.com> created
	------------------------------------------------------------*/
    private static String decodeExternalId(String externalId){
    	System.debug('---externalId:::' + externalId);
		Integer subStringIndex = externalId.lastIndexOf('-');
		System.debug('---externalId:::' + externalId.subString(0,subStringIndex));
    	return externalId.subString(0,subStringIndex);
    }
}