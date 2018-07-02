/**
 *	Controll class to generate account point on page ctrlnpsmatrix
 *
 @author 	Yuanyuan Zhang
 @created 	2013-09-26
 @version 	1.0
 @since 	28.0 (Force.com ApiVersion)
 *
 @changelog
 * 2013-09-26 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created
 */

public without sharing class CtrlNPSMatrix {
   
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	public Account acc4choose{get;set;}
	public Contact conFromDate{get;set;}
	public Contact conToDate{get;set;}
	public list<accountPoint> list_ap{get;set;}
	public decimal maxProf{get;set;}
	public decimal minProf{get;set;}
	public String list_apJson{get;set;}	
	public decimal maxGrowth{get;set;}
	public decimal minGrowth{get;set;}	
	public String max {get;set;}
	public String min {get;set;}	
	public map<Id,Account> map_accId_allShownAccount{get;set;}
	public String campaignTypeApp{get;set;}	
	public String calType{get;set;}
		
	public static final map<String, Integer> MAP_MONTHLABELNUMBER = new map<String, Integer>{
        'Jan' => 4,
        'Feb' => 5,
        'Mar' => 6,
        'Apr' => 7,
        'May' => 8,
        'Jun' => 9,
        'Jul' => 10,
        'Aug' => 11,
        'Sep' => 12,
        'Oct' => 1,
        'Nov' => 2,
        'Dec' => 3
    };
    
    public String selectedRegion{get;set;}
    public String selectedIndustry{get;set;}
    public Integer averageValue{get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	private Map<String, String> map_urlParams;
	private final Integer decimalScale = 2;
	private map<Id,accountPoint> map_accId_accPonit;
	private String currentYear;
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   
	public CtrlNPSMatrix() {
    	map_urlParams = ApexPages.currentPage().getParameters();
		acc4choose = new Account();  	
		this.maxProf = 0;
		this.minProf = 0;
		this.maxGrowth = 0;
		this.minGrowth = 0;
		this.campaignTypeApp = '';
		this.calType = '';
		this.selectedRegion = '';
		this.selectedIndustry = '';
		this.averageValue = 0;
		init();
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************	
	public void getMatrixData(){
		searchCampaign();
		set<Id> set_accId = map_accId_allShownAccount.keySet();
		String cc = acc4choose.Customer_Classification__c;
		String gam;
		String an;
		String sr;
		String si;
		String queryString = 'SELECT Id, NPS_Score__c, Name, AccountNumber FROM Account WHERE ';
		String queryLimit =  'limit 49000';
		if(this.acc4choose.Customer_Classification__c != null){
			queryString += 'Customer_Classification__c = :cc ';
		}
		if(this.acc4choose.GAMCD__c != null){
			if(!queryString.trim().endsWith('WHERE')){
				queryString += 'AND ';
			}
			gam = this.acc4choose.GAMCD__c;
			queryString += 'GAMCD__c = :gam AND parentId != null ';
		}
		if(this.acc4choose.AccountNumber != null){
			if(!queryString.trim().endsWith('WHERE')){
				queryString += 'AND ';
			}
			an = this.acc4choose.AccountNumber;
			queryString += 'AccountNumber = :an ';
		}
		if(this.selectedRegion != null && this.selectedRegion.trim() != ''){
			if(!queryString.trim().endsWith('WHERE')){
				queryString += 'AND ';
			}
			sr = this.selectedRegion;
			queryString += 'Customer_Region__c = :sr ';
		}
		if(this.selectedIndustry != null && this.selectedIndustry.trim() != ''){
			if(!queryString.trim().endsWith('WHERE')){
				queryString += 'AND ';
			}
			si = this.selectedIndustry;
			queryString += 'Customer_Industry__c = :si ';
		}
		if(!queryString.trim().endsWith('WHERE')){
				queryString += 'AND ';
		}
		queryString += 'NPS_Score__c != null AND Id IN :set_accId ';
		queryString += queryLimit;
		this.list_ap = new list<accountPoint>();
		this.maxProf = 0;
		this.map_accId_accPonit = new map<Id,accountPoint>();

		for(Account acc : database.query(queryString)){
			accountPoint ap = new accountPoint();
			ap.npsScore = acc.NPS_Score__c;
			ap.accountId = acc.Id;
			ap.accountName = acc.Name;
			ap.accountNumber = acc.AccountNumber;
			this.map_accId_accPonit.put(acc.Id,ap);
			
		}
		if(map_accId_accPonit.isEmpty()){
			list_apJson = JSON.serialize('no records!');
		}
		else{
			
			if(this.calType == 'prof'){
				getProfitability();
			}
			else{
				getGrowth();
			}
			list_apJson = JSON.serialize(this.map_accId_accPonit.values());
		}		
	}
	
	public list<SelectOption> getCampaignNameOption(){
		list<SelectOption> list_rtOptions = new list<SelectOption>();
		list_rtOptions.add(new SelectOption('', '--None--'));
		list_rtOptions.add(new SelectOption('NPS IND', 'Industry'));
		list_rtOptions.add(new SelectOption('NPS APPL', 'Appliance'));
		return list_rtOptions;
	}
	
	public list<selectoption> getRegionOption(){
		list<SelectOption> list_return = new list<SelectOption>();
		list_return.add(new Selectoption('', '--None--'));
		Apex_Helper_Settings__c ahs =  Apex_Helper_Settings__c.getInstance('Customer Region');
		if(ahs != null){
			string regioncombi = ahs.Value__c;
			list<String> list_regioncombi = regioncombi.split(',');
			list_regioncombi.sort();
			for(String region : list_regioncombi){
				list_return.add(new selectoption(region,region));
			}
		}
		return list_return;
	}
	
	public list<selectoption> getIndustryOption(){
		list<SelectOption> list_return = new list<SelectOption>();
		list_return.add(new Selectoption('', '--None--'));
		Apex_Helper_Settings__c ahs =  Apex_Helper_Settings__c.getInstance('Customer Industry');
		if(ahs != null){
			string industrycombi = ahs.Value__c;
			list<String> list_industrycombi = industrycombi.split(',');
			list_industrycombi.sort();
			for(String industry : list_industrycombi){
				list_return.add(new selectoption(industry,industry));
			}
		}
		return list_return;
	}
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    public void searchCampaign(){
    	this.map_accId_allShownAccount = new map<Id,Account>();
    	
    	set<Id> set_acctId = new set<Id>();
    	string queryString = 'select Id, StartDate, EndDate from Campaign where Status = \'Completed\' ';
    	if(this.campaignTypeApp != null && this.campaignTypeApp.trim() != ''){
			queryString += 'AND Name like \'' + this.campaignTypeApp + '%\' ' ;
		}
    	queryString += 'AND StartDate != null AND EndDate != null order by Enddate desc NULLS LAST limit ';
    	
    	NPS_Settings__c ns = NPS_Settings__c.getInstance('NPS Matrix Last closed surveries');
    	String limitNumber = ns==null?'3 ':ns.Value__c+' ';
    	queryString += limitNumber;
    	
    	
    	
    	map<Id, date> map_camId_startDate = new map<Id, date>();
    	map<Id, date> map_camId_endDate = new map<Id, date>();
    	for(Campaign cm : database.query(queryString)){
    		
    		map_camId_startDate.put(cm.Id, cm.StartDate);
    		map_camId_endDate.put(cm.Id, cm.EndDate);
    	}
    	
    	for(CampaignMember cm : [SELECT Contact.AccountId, Contact.Survey_Attended_Date__c, CampaignId FROM CampaignMember WHERE CampaignId IN :map_camId_startDate.keySet() AND Contact.AccountId != null ]){
    		Date sd = map_camId_startDate.get(cm.CampaignId);
    		date ed = map_camId_endDate.get(cm.CampaignId);
    		if(cm.Contact.Survey_Attended_Date__c <= ed && cm.Contact.Survey_Attended_Date__c >= sd){
    			set_acctId.add(cm.Contact.AccountId);
    		}
    	}
    	
    	for(Account acc : [SELECT Id, Name, NPS_Score__c FROM Account WHERE Id IN :set_acctId AND NPS_Score__c != null]){
    		map_accId_allShownAccount.put(acc.Id, acc);
    	}
    }
    
    private void init(){
    	getCurrentYear();
    }
    
    private void getCurrentYear(){
    	this.currentYear = [select Year__c from BBB_Year_Bill_Book_Cust_PN__c order by year__c desc limit 1].year__c;
    }
    
    private void getProfitability(){
    	this.maxProf = 0;
    	this.minProf = 0;
    	Integer calcount = 0;
    	Decimal sum = 0;

    	Boolean hasMax = false;
    	if((this.max != null && this.max.trim() != '')|| (this.min != null && this.min.trim() != '')){
    		hasMax = true;
    		this.maxProf = (this.max != null && this.max.trim() != '')?decimal.valueOf(this.max):100;
    		this.minProf = (this.min != null && this.min.trim() != '')?decimal.valueOf(this.min):0;
    	}
    	map<Id,accountPoint> map_accId_accPonitNew = new map<Id,accountPoint>();
    	
    	for(AggregateResult ar : [SELECT sum(Bill_Year_to_Date_Amount_USD__c) billAmount,
    									 sum(Bill_Year_To_Date_Cost_Amount__c) billCost,
    									 sum(Bill_Prior_Year_to_Date_Amount_USD__c) billPriorYear, 
    									 Customer__c
    							  FROM BBB_Year_Bill_Book_Cust_PN__c
    							  WHERE Year__c = :this.currentYear
    							  AND Customer__c IN :this.map_accId_accPonit.keyset()
    							  group by Customer__c]){
    		Id accId = (Id)ar.get('Customer__c');
    		
			decimal profit = 0;
			decimal growth = 0;
			if(ar.get('billAmount') != null && ar.get('billCost') != null && (decimal) ar.get('billAmount') != 0){
				
				profit = (((decimal) ar.get('billAmount') - (decimal) ar.get('billCost'))/(decimal) ar.get('billAmount')).setScale(decimalScale, system.Roundingmode.HALF_UP);
				profit = profit * 100;
			}
			else if(ar.get('billCost') == null){
				profit = 100;
			}
			
			if(ar.get('billAmount') != null && ar.get('billPriorYear') != null){
				decimal billCurrentYear = (decimal) ar.get('billAmount');
				decimal billPriorYear = (decimal) ar.get('billPriorYear');
				if(billCurrentYear != 0){
					growth = (1-billPriorYear/billCurrentYear).setScale(decimalScale, system.Roundingmode.HALF_UP);
					growth = growth * 100;
				}
			}
			else if(ar.get('billPriorYear') == null){
				growth = 100;
			}
			
			this.map_accId_accPonit.get(accId).profitability = profit;
			this.map_accId_accPonit.get(accId).growth = growth;
			if(!hasMax){
				if(profit > this.maxProf) this.maxProf = profit;
				if(profit < this.minProf) this.minProf = profit;
				
				accountPoint ap = this.map_accId_accPonit.get(accId);
				map_accId_accPonitNew.put(accId, ap);
				calcount++;
				sum += profit;
			}
			else{
				
				if(profit <= this.maxProf && profit >= this.minProf){
					accountPoint ap = this.map_accId_accPonit.get(accId);
					map_accId_accPonitNew.put(accId, ap);
					calcount++;
					sum += profit;
				}
				else{
					this.map_accId_accPonit.remove(accId);
				}
			}
			
    			
    					
    	}
    	this.map_accId_accPonit = map_accId_accPonitNew;
    	this.averageValue = calcount==0?0:Integer.valueOf(sum/calcount);
    }
 
    
    private void getGrowth(){
    	this.maxGrowth = 0;
    	this.minGrowth = 0;
    	Boolean hasMax = false;
    	Integer calcount = 0;
    	Decimal sum = 0;
    	
    	if((this.max != null  && this.max.trim() != '')|| (this.min != null && this.min.trim() != '')){
    		hasMax = true;
    		this.maxGrowth = (this.max != null && this.max.trim() != '')?decimal.valueOf(this.max):100;
    		this.minGrowth = (this.min != null && this.min.trim() != '')?decimal.valueOf(this.min):0;
    	}
    	map<Id,accountPoint> map_accId_accPonitNew = new map<Id,accountPoint>();
    	
    	
    	for(AggregateResult ar : [SELECT sum(Bill_Year_to_Date_Amount_USD__c) billYear, 
									     sum(Bill_Prior_Year_to_Date_Amount_USD__c) billPriorYear, 
									     sum(Bill_Year_To_Date_Cost_Amount__c) billCost,
									     Customer__c//,
								  FROM BBB_Year_Bill_Book_Cust_PN__c
								  WHERE Customer__c IN :this.map_accId_accPonit.keyset()
								  AND Year__c = :this.currentYear
								  Group by Customer__c]){
    		Id accId = (Id)ar.get('Customer__c');
			decimal growth = 0;
			decimal profit = 0;
			if(ar.get('billYear') != null && ar.get('billPriorYear') != null){
				decimal billCurrentYear = (decimal) ar.get('billYear');
				decimal billPriorYear = (decimal) ar.get('billPriorYear');
				if(billPriorYear != 0){
					growth = (billCurrentYear/billPriorYear - 1).setScale(decimalScale, system.Roundingmode.HALF_UP);
					growth = growth * 100;
				}
			}
			else if(ar.get('billPriorYear') == null){
				growth = 100;
			}
			
			if(ar.get('billYear') != null && ar.get('billCost') != null && (decimal) ar.get('billYear') != 0){
				
				profit = (((decimal) ar.get('billYear') - (decimal) ar.get('billCost'))/(decimal) ar.get('billYear')).setScale(decimalScale, system.Roundingmode.HALF_UP);
				profit = profit * 100;
			}
			else if(ar.get('billCost') == null){
				profit = 100;
			}
			
			this.map_accId_accPonit.get(accId).growth = growth;
    		this.map_accId_accPonit.get(accId).profitability = profit;
			if(!hasMax){
				if(growth > this.maxGrowth){
					this.maxGrowth = growth;
				}
				if(growth < this.minGrowth){
					this.minGrowth = growth;
				}
    			
    			accountPoint ap = this.map_accId_accPonit.get(accId);
				map_accId_accPonitNew.put(accId, ap);
				calcount++;
				sum += growth;
			}
			else{
				if(growth <= this.maxGrowth && growth >= this.minGrowth){
					accountPoint ap = this.map_accId_accPonit.get(accId);
					map_accId_accPonitNew.put(accId, ap);
					calcount++;
					sum += growth;
				}
				else{
					this.map_accId_accPonit.remove(accId);
				}
			}
    	}
    	this.map_accId_accPonit = map_accId_accPonitNew;
    	this.averageValue = calcount==0?0:Integer.valueOf(sum/calcount);
    }
    
   
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/

    public class accountPoint{
    	public decimal npsScore{get;set;}
    	public decimal profitability{get;set;}
    	public decimal growth{get;set;}
    	public Id accountId{get;set;}
    	public String accountName{get;set;}
    	public String accountNumber{get;set;}
    	
    	public accountPoint(){
    		npsScore = 0;
    		profitability = 0;
    		growth = 0;
    		accountNumber = '';
    	}
    }
	///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}