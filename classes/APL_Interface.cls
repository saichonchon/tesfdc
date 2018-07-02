/**
 *  This class is APL interface class.
 *  
 * @author Lei Tang
 * @created 2015-05-07
 * @version 1.0
 * @since 33.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-05-07 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 *
 */
public without sharing class APL_Interface {
	public abstract class AAPLRemoteService{
		public virtual String getSearchResult(String sData){ return ''; }
		public virtual String getExistResult(String sData){ return ''; }
		public virtual String saveSObjectData(String sData) { return ''; }
		public virtual String deleteAPLObject(String sData) { return ''; }
		public virtual String getRefData(String sData) { return ''; } 
		public virtual String getBacklogRefData(String sData) { return ''; } 
		public virtual String useASP(String sData) { return ''; }
		public virtual String copyCFTForecast(String sData) { return ''; }
		public virtual String getTotalBillingData(String sData) { return ''; }
		
		
		public virtual void setCBC2Column(list<APL_ClsEntityType.Cbc2Object> list_cbc2column)  {
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('Other BU Products', ClsAPLForecastUtil.CBCOTHER, 'OTHER', 'cls_other' ));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('Relay', ClsAPLForecastUtil.CBCRELAY, 'Relay', 'cls_relay' ));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 30042 ] - Magnet', '30042', 'Magnet', '' ));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 30017 ] - Tubing', '30017', 'Tubing', '' ));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 30016 ] - Terminals & Splices', '30016', 'Terminals & Splices', ''));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 30015 ] - RAST', '30015', 'RAST', ''));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 30014 ] - Signal', '30014',  'Signal', ''));
			list_cbc2column.add(new APL_ClsEntityType.Cbc2Object('[ 30012 ] - Power', '30012',  'Power', ''));
		}
		
	}


    /**
    * Interface for controller service.
    *
    @author Lei Tang
    @created 2014-10-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-10-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
	public virtual interface IAPLControllerService{
		
		//void setUserLocale(APL_ClsEntityType.LocaleConfig localeConfig, String userLocale);
		void setLevel1Row(list<APL_ClsEntityType.APLColumn> list_acctColumns);
		void setLevel2Row(list<APL_ClsEntityType.APLColumn> list_acctColumns);
		void setLevel3Row(list<APL_ClsEntityType.APLColumn> list_acctColumns);
		void setLevel4Row(list<APL_ClsEntityType.APLColumn> list_acctColumns);
		void setLevel5Row(list<APL_ClsEntityType.APLColumn> list_acctColumns);
		void setPageConf(APL_ClsEntityType.PageConfig PageConf);
		void setAllDateItems(APL_ClsEntityType.PageConfig PageConf, list<APL_ClsEntityType.DateItem> list_allDateItems);
		void setTotalRow(list<APL_ClsEntityType.APLColumn> list_acctColumns, Object config);
		void setOverRelayProductsForecast(list<Object> list_data, Object config);
	}

	/**
    * Abstract class for controller service.
    *
    @author Lei Tang
    @created 2014-10-10
    @version 1.0
    @since 30.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-10-10 Lei Tang <lei.tang@itbconsult.com>
    * - Created
    */
	public abstract class AAPLCtrlService implements IAPLControllerService{
		
		
		public virtual void setPopUPBoxColumnLevel1(list<Object> list_column){ }
		public virtual void setPopUPBoxColumnLevel2(list<Object> list_column){ }
		public virtual void setPopUPBoxColumnLevel3(list<Object> list_column){ }
		
		public virtual void setLevel1Data(list<Object> list_data, Object config){ }
		public virtual void setGroupForecast(list<Object> list_data, Object config){ }
		public virtual void setOverRelayProductsForecast(list<Object> list_data, Object config){ }
		
		
		public virtual void setTotalRow(list<APL_ClsEntityType.APLColumn> list_acctColumns, Object config){ 
			list<APL_ClsEntityType.APLColumn> list_ref1 = new list<APL_ClsEntityType.APLColumn> {
	            new APL_ClsEntityType.APLColumn('Total Billing', 'TotalBilling', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Booking', 'TotalBooking', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Backlog', 'TotalBacklog', '', '', false)
			};
			
			list<APL_ClsEntityType.APLColumn> list_ref2 = new list<APL_ClsEntityType.APLColumn> {
	            new APL_ClsEntityType.APLColumn('Total Billing', 'TotalBilling', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Booking', 'TotalBooking', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Backlog', 'TotalBacklog', '', '', false)
			};
			
			
			APL_ClsEntityType.APLColumn totalT = new APL_ClsEntityType.APLColumn(APL_ClsUtils.getHexUID(),'Total Forecast Current Cycle', 'TotalForecastCurrentCycle', ' trt_0 trt_trt col ', '', true);
			APL_ClsEntityType.APLColumn total = new APL_ClsEntityType.APLColumn('Total', 'Total', totalT.id, '', false);
			APL_ClsEntityType.APLColumn TCProducts = new APL_ClsEntityType.APLColumn(APL_ClsUtils.getHexUID(),'T&CProducts', 'TCProducts', totalT.id, '', true);
			APL_ClsEntityType.APLColumn RelayProducts = new APL_ClsEntityType.APLColumn(APL_ClsUtils.getHexUID(),'Relay Products', 'RelayProducts', totalT.id, '', true);
			APL_ClsEntityType.APLColumn OverallRelayProducts = new APL_ClsEntityType.APLColumn('Overall Relay Products', 'OverallRelayProducts', totalT.id, '', false);
			
			TCProducts.list_ChildColumn.addAll(list_ref1);
			RelayProducts.list_ChildColumn.addAll(list_ref2);
			
			list<APL_ClsEntityType.APLColumn> list_t = new list<APL_ClsEntityType.APLColumn>();
			list_t.add(totalT);
			list_t.add(total);
			list_t.add(TCProducts);
			list_t.add(RelayProducts);
			list_t.add(OverallRelayProducts);
			
			
			list_acctColumns.addAll(list_t);
		}
		
	    /**
	    * Method to set account forecast view column.
	    *
	    @author Bin Yuan
	    @created 2014-05-30
	    @version 1.0
	    @since 29.0 (Force.com ApiVersion)
	    *
	    *
	    @changelog
	    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
	    * - Created
	    */
		public virtual void setLevel1Row(list<APL_ClsEntityType.APLColumn> list_acctColumns){
			
			list<APL_ClsEntityType.APLColumn> list_t = new list<APL_ClsEntityType.APLColumn> {
				new APL_ClsEntityType.APLColumn('Current Cycle Forecast', 'CurrentCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Previous Cycle Forecast', 'PreviousCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Billing', 'TotalBilling', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Booking', 'TotalBooking', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Backlog', 'TotalBacklog', '', '', false)
			};
			
			list_acctColumns.addAll(list_t);
		}
		
	   /**
	    * Method to set OEM forecast view column.
	    *
	    @author Bin Yuan
	    @created 2014-05-30
	    @version 1.0
	    @since 29.0 (Force.com ApiVersion)
	    *
	    *
	    @changelog
	    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
	    * - Created
	    */
		public virtual void setLevel2Row(list<APL_ClsEntityType.APLColumn> list_acctColumns){
			
			list_acctColumns.addAll(new list<APL_ClsEntityType.APLColumn> {
				new APL_ClsEntityType.APLColumn('Current Cycle Forecast', 'CurrentCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Previous Cycle Forecast', 'PreviousCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Billing', 'TotalBilling', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Booking', 'TotalBooking', '', '', false),
	            new APL_ClsEntityType.APLColumn('Total Backlog', 'TotalBacklog', '', '', false)
			});
		}

		 
	   /**
	    * Method to set part forecast view column.
	    *
	    @author Bin Yuan
	    @created 2014-05-30
	    @version 1.0
	    @since 29.0 (Force.com ApiVersion)
	    *
	    *
	    @changelog
	    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
	    * - Created
	    */
		public virtual void setLevel3Row(list<APL_ClsEntityType.APLColumn> list_acctColumns){
			
			list_acctColumns.addAll(new list<APL_ClsEntityType.APLColumn> {
				new APL_ClsEntityType.APLColumn('Current Cycle Forecast', 'CurrentCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Previous Cycle Forecast', 'PreviousCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Billing', 'Billing', '', '', false),
	            new APL_ClsEntityType.APLColumn('Booking', 'Booking', '', '', false),
	            new APL_ClsEntityType.APLColumn('Backlog', 'Backlog', '', '', false)
			});
		}
		
		
		/**
	    * Method to set region forecast view column.
	    *
	    @author Bin Yuan
	    @created 2014-05-30
	    @version 1.0
	    @since 29.0 (Force.com ApiVersion)
	    *
	    *
	    @changelog
	    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
	    * - Created
	    */
		public virtual void setLevel4Row(list<APL_ClsEntityType.APLColumn> list_acctColumns){
			
			list<APL_ClsEntityType.APLColumn> list_t = new list<APL_ClsEntityType.APLColumn> {
				new APL_ClsEntityType.APLColumn('Current Cycle Forecast', 'CurrentCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Previous Cycle Forecast', 'PreviousCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Billing', 'Billing', '', '', false),
	            new APL_ClsEntityType.APLColumn('Booking', 'Booking', '', '', false),
	            new APL_ClsEntityType.APLColumn('Backlog', 'Backlog', '', '', false)
			};
			
			list_acctColumns.addAll(list_t);
		}

		/**
	    * Method to set region forecast view column.
	    *
	    @author Bin Yuan
	    @created 2014-05-30
	    @version 1.0
	    @since 29.0 (Force.com ApiVersion)
	    *
	    *
	    @changelog
	    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
	    * - Created
	    */
		public virtual void setLevel5Row(list<APL_ClsEntityType.APLColumn> list_acctColumns){
			
			list<APL_ClsEntityType.APLColumn> list_t = new list<APL_ClsEntityType.APLColumn> {
				new APL_ClsEntityType.APLColumn('Current Cycle Forecast', 'CurrentCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Previous Cycle Forecast', 'PreviousCycleForecast', '', '', false),
	            new APL_ClsEntityType.APLColumn('Billing', 'Billing', '', '', false),
	            new APL_ClsEntityType.APLColumn('Booking', 'Booking', '', '', false),
	            new APL_ClsEntityType.APLColumn('Backlog', 'Backlog', '', '', false)
			};
			
			list_acctColumns.addAll(list_t);
		}
	   	
	   	/**
	    * Method to set page config.
	    *
	    @author Bin Yuan
	    @created 2014-05-30
	    @version 1.0
	    @since 29.0 (Force.com ApiVersion)
	    *
	    *
	    @changelog
	    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
	    * - Created
	    */
		public virtual void setPageConf(APL_ClsEntityType.PageConfig PageConf) {
			// set page config
			APL_ClsUtils.setFiscalMonth(pageConf);
		}

	   /**
	    * Method to set date Items.
	    *
	    @author Bin Yuan
	    @created 2014-05-30
	    @version 1.0
	    @since 29.0 (Force.com ApiVersion)
	    *
	    *
	    @changelog
	    * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
	    * - Created
	    */
		public virtual void setAllDateItems(APL_ClsEntityType.PageConfig PageConf, list<APL_ClsEntityType.DateItem> list_allDateItems) {
			//to do set all date items
			APL_ClsUtils.createDateItem(pageConf, list_allDateItems);
		}
	}
}