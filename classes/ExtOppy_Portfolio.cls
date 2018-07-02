/**
 *  This class is used to ExtOppy_Portfolio page.
 *  
 * @author Jinbo Shan
 * @created 2014-06-10
 * @version 1.0
 * @since 29.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-06-10 Jinbo Shan <jinbo.shan@itbconsult.com>
 * - Created   
 *
 */
public without sharing class ExtOppy_Portfolio {
	
	public Opportunity opportunity  			{get;set;}
	public list<AttractivenesCls> list_atts		{get;set;}
	public list<AbilityCls> list_abilitys		{get;set;}
	
	public Integer countPoliticalMaps			{get;set;}
	public Integer questionNum					{get;set;}
	public Integer answerNum					{get;set;}
	public Integer countDecisionCriteria        {get;set;}
	
	public decimal fiveYearRevenue				{get;set;}
	
	private ApexPages.standardController stdCtrl;
	private set<string> set_apiNames;
	private static string LOW = 'Low';
	private static string MEDIUM = 'Medium';
	private static string HIGH = 'High';
	
	public ExtOppy_Portfolio(ApexPages.standardController stdCtrl){
		
		this.countPoliticalMaps = 0;
		this.questionNum = 0;
		this.answerNum = 0;
		this.countDecisionCriteria = 0;
					
		this.stdCtrl = stdCtrl;
		this.list_atts = new list<AttractivenesCls>();
		this.list_abilitys = new list<AbilityCls>();
		this.set_apiNames = new set<string>();
		Opportunity oppyTemp = (Opportunity)stdCtrl.getRecord();
		if(oppyTemp != null) {
			
			for(Opportunity oppy : [SELECT Id, PMV_Type__c, CurrencyIsoCode, RecordType.BusinessProcessId, AccountId, Five_Year_Revenue__c 
            				  FROM Opportunity 
            				  WHERE Id = : oppyTemp.Id ]){
           		this.opportunity = oppy;
           	}
			
			this.countPoliticalMaps = ClsPMV_Util.calculateContactRoleNum(opportunity.Id);
			
			this.countDecisionCriteria = ClsPMV_Util.calculateDecisionCriteriaNum(opportunity.Id);
	            
            this.questionNum = ClsPMV_Util.calculateNumOfQuestion(opportunity);
        	
        	this.answerNum = ClsPMV_Util.calculateNumOfAnswer(opportunity);
        	
        	this.fiveYearRevenue = ClsOppyUtil.transformIsoCode(opportunity.Five_Year_Revenue__c, opportunity.CurrencyIsoCode, 'USD');
			
			//get sql String.
			map<string, decimal> map_apiName_value = new map<string, decimal>();
			
			string queryStr = 'SELECT ';
			for(Pipeline_Management_Portfolio__c pmp : getPMPortfolioSetting()) {
				set_apiNames.add(pmp.Name);
			}
			for(string apiName : set_apiNames) {
				queryStr += apiName + ', ';
			}
			queryStr += 'Id FROM Opportunity WHERE Id = \'' + opportunity.Id + '\'';
			
			for(Opportunity oppy : database.query(queryStr)) {
				for(string apiName : set_apiNames) {
					if(oppy.get(apiName) != null) {
						map_apiName_value.put(apiName, decimal.valueOf(string.valueOf(oppy.get(apiName))));
					}else {
						map_apiName_value.put(apiName, 0);
					}
				}
			}
			
			//calculate all fields and related value for Attractivenes and Ability
			if(map_apiName_value.size() > 0) {
				for(string apiName : map_apiName_value.keySet()) {
					Pipeline_Management_Portfolio__c pmp = Pipeline_Management_Portfolio__c.getInstance(apiName);
					if(pmp.Category__c == 'Attractivenes') {
						AttractivenesCls attCls = new AttractivenesCls();
						attCls.apiName = pmp.Name;
						attCls.labelName = pmp.LabelName__c;
						attCls.value = map_apiName_value.get(apiName);
						if(pmp.Description1__c != null){
							attCls.description += pmp.Description1__c;
						}
						if(pmp.Description2__c != null){
							attCls.description += ' ' + pmp.Description2__c;
						}
						if(pmp.Low_Threshold__c != null && map_apiName_value.get(apiName) <= pmp.Low_Threshold__c) {
							attCls.stringVal = LOW;
						} else if(pmp.Medium_Threshold__c != null && map_apiName_value.get(apiName) <= pmp.Medium_Threshold__c) {
							attCls.stringVal = MEDIUM;
						} else if(pmp.High_Threshold__c != null && map_apiName_value.get(apiName) <= pmp.High_Threshold__c) {
							attCls.stringVal = HIGH;
						}
						list_atts.add(attCls);
					} else if(pmp.Category__c == 'Ability') {
						AbilityCls abiliCls = new AbilityCls();
						abiliCls.apiName = pmp.Name;
						abiliCls.labelName = pmp.LabelName__c;
						abiliCls.value = map_apiName_value.get(apiName);
						if(pmp.Description1__c != null){
							abiliCls.description += pmp.Description1__c;
						}
						if(pmp.Description2__c != null){
							abiliCls.description += ' ' + pmp.Description2__c;
						}
						if(pmp.Low_Threshold__c != null && map_apiName_value.get(apiName) <= pmp.Low_Threshold__c) {
							abiliCls.stringVal = LOW;
						} else if(pmp.Medium_Threshold__c != null && map_apiName_value.get(apiName) <= pmp.Medium_Threshold__c) {
							abiliCls.stringVal = MEDIUM;
						} else if(pmp.High_Threshold__c != null && map_apiName_value.get(apiName) <= pmp.High_Threshold__c) {
							abiliCls.stringVal = HIGH;
						}
						list_abilitys.add(abiliCls);
					}
				}
			}
		}
	}
	
	public list<Pipeline_Management_Portfolio__c> getPMPortfolioSetting(){
		list<Pipeline_Management_Portfolio__c> list_pmps = Pipeline_Management_Portfolio__c.getAll().values();
		return list_pmps;
	}
	
	public class AttractivenesCls {
		public string apiName	{get;set;}
		public string labelName	{get;set;}
		public string description	{get;set;}
		public decimal value	{get;set;}
		public string stringVal	{get;set;}
		public AttractivenesCls() {
			apiName = '';
			labelName = '';
			description = '';
			stringVal = '';
		}
	}
	
	public class AbilityCls {
		public string apiName	{get;set;}
		public string labelName	{get;set;}
		public string description	{get;set;}
		public decimal value	{get;set;}
		public string stringVal	{get;set;}
		public AbilityCls() {
			apiName = '';
			labelName = '';
			description = '';
			stringVal = '';
		}
	}
}