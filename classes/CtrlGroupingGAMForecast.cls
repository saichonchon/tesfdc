/**
 *  Ctrl class for CtrlGroupingGAMForecast
 *
 @author    Lili Zhao
 @created   2014-05-19
 @version   1.0
 @since     27.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-05-19 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created
 */
public class CtrlGroupingGAMForecast extends CtrlGroupingRemoteBase {
	
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public transient ClsAPLEntityTypes.LocaleConfig lc {get;set;}
	
	public transient ClsAPLEntityTypes.GAMAcctInfo accInfo {get;set;}
	
	
	public transient ClsAPLEntityTypes.PageConfig pageConf {get; set;}
	public String chartURL {get;set;}
	public ClsAPLInterface.IAPLControllerService gamService {get;set;}
	public transient list<ClsAPLEntityTypes.TotalFCViewFields> list_totalFC {get; set;}
	
	{
		
		this.lc = new ClsAPLEntityTypes.LocaleConfig();
		ClsAPLForecastUtil.setUserLocale(this.lc, userInfo.getLocale());	//set user locale
	}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public CtrlGroupingGAMForecast(){
		this.chartURL = APL_CtrlChart.enCodeUrl('GAM',  null, UserInfo.getUserId());
		this.gamService = new ClsAPLServiceGAM();	//init gam service interface
		initGAM();
	}
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public void initGAM(){
		try {
			this.pageConf = new ClsAPLEntityTypes.PageConfig();
			this.pageConf.managerId = UserInfo.getUserId();
			this.gamService.setPageConf(this.pageConf);
			getList_allDateItems();
			this.list_totalFC = new list<ClsAPLEntityTypes.TotalFCViewFields>();
			//GAMAcctInfo//
			this.accInfo = (ClsAPLEntityTypes.GAMAcctInfo) this.gamService.getAcctInfo(this.pageConf);
			ClsAPLServiceGAM.getAcctTotalFCQuery(pageConf, list_totalFC);
		}
		catch(Exception ex) {
			ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error, ex.getMessage()));
		}
		
		//this.gamService.getAcctInfo(this.pageConf);
	}

   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.DateItem> getList_allDateItems(){
		list<ClsAPLEntityTypes.DateItem> list_t = new list<ClsAPLEntityTypes.DateItem>();
		this.gamService.setAllDateItems(this.pageConf, list_t);
		return list_t;
	}
	
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.AcctColumns> getRegionViewColumns(){
		list<ClsAPLEntityTypes.AcctColumns> list_acctColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		ClsAPLServiceGAM.setRegionRow(list_acctColumn);
		return list_acctColumn;
	}
	
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.AcctColumns> getAcctViewColumns(){
		list<ClsAPLEntityTypes.AcctColumns> list_acctColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.gamService.setAcctRow(list_acctColumn);
		return list_acctColumn;
	}
	
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.AcctColumns> getCBCViewColumns(){
		list<ClsAPLEntityTypes.AcctColumns> list_cbcColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.gamService.setCBC2Row(list_cbcColumn);
		return list_cbcColumn;
	}
	
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.Cbc2Object> getCBCData() {
		list<ClsAPLEntityTypes.Cbc2Object> list_cbcData = new list<ClsAPLEntityTypes.Cbc2Object>();
		this.gamService.setCBC2Data(list_cbcData);
		return list_cbcData;
	}
	
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.AcctColumns> getGPLViewColumns(){
		list<ClsAPLEntityTypes.AcctColumns> list_gplColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.gamService.setGPLRow(list_gplColumn);
		return list_gplColumn;
	}
	
   /**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.AcctColumns> getPartViewColumns(){
		list<ClsAPLEntityTypes.AcctColumns> list_partColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.gamService.setPartRow(list_partColumn);
		//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_partColumn :: ' +list_partColumn));
		return list_partColumn;
	}
	
	/**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.AcctColumns> getProductCodeViewColumns(){
		list<ClsAPLEntityTypes.AcctColumns> list_productCodeColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		this.gamService.setProductCodeRow(list_productCodeColumn);
		//ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Info, 'list_partColumn :: ' +list_partColumn));
		return list_productCodeColumn;
	}
	
	/**
    * This method is used to generate month filter string for bbb monthly query string
    *
    @author Bin Yuan
    @created 2014-04-22
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-04-22 Bin Yuan <bin.yuan@itbconsult.com>
    * - Created
    */
	public list<ClsAPLEntityTypes.AcctColumns> getOtherViewColumns(){
		list<ClsAPLEntityTypes.AcctColumns> list_otherColumn = new list<ClsAPLEntityTypes.AcctColumns>();
		
		list_otherColumn.addAll(new list<ClsAPLEntityTypes.AcctColumns> {
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_billing, 'billing', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_booking, 'booking', 'feve', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_backlog, 'backlog', '', '', false)
			});
		
		return list_otherColumn;
	}
	
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	//********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
	
	
	
	
	
	
	
	public CtrlGroupingGAMForecast getThis(){
		return this;
	}
	
	
	
	
}