/**
 *  Interface class for APL sales forecast
 *
 @author    Bin Yuan
 @created   2014-05-30
 @version   1.0
 @since     29.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-05-30 Bin Yuan <bin.yuan@itbconsult.com>
 * - Created
 */
public without sharing class ClsAPLInterface {
	
   /**
    * Interface for controller service.
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
	public virtual interface IAPLControllerService{
		
	//	void setUserLocale(ClsAPLEntityTypes.LocaleConfig localeConfig, String userLocale);
		void setAcctRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns);
		void setCBC2Row(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns);
		void setGPLRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns);
		void setPartRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns);
		void setProductCodeRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns);
		void setPageConf(ClsAPLEntityTypes.PageConfig PageConf);
		void setAllDateItems(ClsAPLEntityTypes.PageConfig PageConf, list<ClsAPLEntityTypes.DateItem> list_allDateItems);
		void setCBC2Data(list<ClsAPLEntityTypes.Cbc2Object> list_cbcData);
		void setRelayCBC2Data(list<ClsAPLEntityTypes.Cbc2Object> list_cbcData);
		ClsAPLEntityTypes.AcctInfo getAcctInfo(ClsAPLEntityTypes.PageConfig PageConf);
	}
	
    public interface IAPLFCService {
        void saveFC(String str_json);
        ClsAPLEntityTypes.FCResults getFC(String str_json);
    }

    public interface IAPLRefDataService {
        ClsAPLEntityTypes.FCResults getRefData(String str_json);
    }

   /**
    * Abstract class for controller service.
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
	public abstract class AAPLCtrlService implements IAPLControllerService{
		
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
		public virtual void setAcctRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns){
			
			list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve ', '', false),
				//new ClsAPLEntityTypes.AcctColumns(system.label.APL_AM_Sales_Forecast, 'amFC', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_pos_forecast, 'posFC', 'feve', 'nhide', true),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_cma_forecast, 'cmaFC', '', 'nhide', true),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_billing, 'totalBilling', 'feve', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_booking, 'totalBooking', ' ', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_backlog, 'totalBacklog', 'feve', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_total_sa, 'totalSA', '', 'nhide', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_2m_fc_accuracy, 'fc2MAccuracy', 'feve', 'nhide', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_3m_fc_accuracy, 'fc3MAccuracy', '', 'nhide', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_6m_fc_accuracy, 'fc6MAccuracy', 'feve', 'nhide', false)
			};
			
			list_acctColumns.addAll(list_t);
		}
		
	   /**
	    * Method to set CBC forecast view column.
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
		public void setCBC2Row(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns){
			
			list_acctColumns.addAll(new list<ClsAPLEntityTypes.AcctColumns> {
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
				//new ClsAPLEntityTypes.AcctColumns(system.label.APL_AM_Sales_Forecast, 'amFC', ' ', '', false),
				//new ClsAPLEntityTypes.AcctColumns('Schedule Agreement', 'scheduleAgreement', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_billing, 'billing', ' feve ', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_booking, 'booking', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_backlog, 'backlog', ' feve ', '', false)
			});
		}
		
	   /**
	    * Method to set GPL forecast view column.
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
		public void setGPLRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns){
			
			list<ClsAPLEntityTypes.AcctColumns> list_t = new list<ClsAPLEntityTypes.AcctColumns> {
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
				//new ClsAPLEntityTypes.AcctColumns(system.label.APL_AM_Sales_Forecast, 'amFC', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_schedule_agreement, 'scheduleAgreement', ' feve ', 'nhide', false),
				//new ClsAPLEntityTypes.AcctColumns(system.label.APL_forecast_of_rest_parts, 'partFC', 'feve', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_billing, 'billing', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_booking, 'booking', 'feve', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_backlog, 'backlog', '', '', false)
			};
			list_acctColumns.addAll(list_t);
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
		public void setPartRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns){
			
			list_acctColumns.addAll(new list<ClsAPLEntityTypes.AcctColumns> {
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
			//	new ClsAPLEntityTypes.AcctColumns(system.label.APL_AM_Sales_Forecast, 'amFC', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_schedule_agreement, 'scheduleAgreement', 'feve ', 'nhide', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_billing, 'billing', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_booking, 'booking', 'feve', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_backlog, 'backlog', '', '', false)
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
		public void setProductCodeRow(list<ClsAPLEntityTypes.AcctColumns> list_acctColumns){
			
			list_acctColumns.addAll(new list<ClsAPLEntityTypes.AcctColumns> {
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_current_sales_forecast, 'currentFC', '', '', true),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_previous_sales_forecast, 'previousFC', 'feve', '', false),
			//	new ClsAPLEntityTypes.AcctColumns(system.label.APL_AM_Sales_Forecast, 'amFC', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_schedule_agreement, 'scheduleAgreement', 'feve ', 'nhide', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_billing, 'billing', '', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_booking, 'booking', 'feve', '', false),
				new ClsAPLEntityTypes.AcctColumns(system.label.APL_backlog, 'backlog', '', '', false)
			});
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
		public void setPageConf(ClsAPLEntityTypes.PageConfig PageConf) {
			// set page config
			ClsAPLForecastUtil.setFiscalMonth(pageConf);
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
		public void setAllDateItems(ClsAPLEntityTypes.PageConfig PageConf, list<ClsAPLEntityTypes.DateItem> list_allDateItems) {
			//to do set all date items
			ClsAPLForecastUtil.createDateItem(pageConf, list_allDateItems);
		}
		
		/**
	    * This method is used to generate CBC2 data.
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
		public void setCBC2Data(list<ClsAPLEntityTypes.Cbc2Object> list_cbcData) {
			list_cbcData.addAll( new list<ClsAPLEntityTypes.Cbc2Object> {
				
				new ClsAPLEntityTypes.Cbc2Object('[ 30012 ] - Power', '30012',  'Power', ''),
    			new ClsAPLEntityTypes.Cbc2Object('[ 30014 ] - Signal', '30014',  'Signal', ''),
				new ClsAPLEntityTypes.Cbc2Object('[ 30015 ] - RAST', '30015', 'RAST', ''),
				new ClsAPLEntityTypes.Cbc2Object('[ 30016 ] - Terminals & Splices', '30016', 'Terminals & Splices', ''),
				new ClsAPLEntityTypes.Cbc2Object('[ 30017 ] - Tubing', '30017', 'Tubing', '' ),
				new ClsAPLEntityTypes.Cbc2Object('[ 30042 ] - Magnet', '30042', 'Magnet', '' ),
				new ClsAPLEntityTypes.Cbc2Object('Relay', ClsAPLForecastUtil.CBCRELAY, 'Relay', 'cls_relay' ),
				new ClsAPLEntityTypes.Cbc2Object('Other BU Products', ClsAPLForecastUtil.CBCOTHER, 'OTHER', 'cls_other' )
				
				}
			);
		}
		
		/**
	    * This method is used to generate CBC2 data.
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
		public void setRelayCBC2Data(list<ClsAPLEntityTypes.Cbc2Object> list_cbcData) {
			list_cbcData.addAll( new list<ClsAPLEntityTypes.Cbc2Object> {         
	            new ClsAPLEntityTypes.Cbc2Object('[ 13213 ] CBC2 / Automotive Relays', '13213', 'CBC2__c', ''),
	            new ClsAPLEntityTypes.Cbc2Object('[ 30005 ] CBC2 / APPLIANCES GENERAL PURPOSE RELAYS', '30005',  'CBC2__c', ''),
	            new ClsAPLEntityTypes.Cbc2Object('[ 41553 ] CBC3 / Relays IND', '41553', 'CBC3__c', '' )
	            //change to 41553 Lei Tang <lei.tang@capgemini.com> 2017-12-05
	            //new ClsAPLEntityTypes.Cbc2Object('[ 40308 ] CBC3 / Relays A&C', '40308', 'CBC3__c', ''),
	            //new ClsAPLEntityTypes.Cbc2Object('[ 40309 ] CBC3 / Relays IB', '40309', 'CBC3__c', '' )
	        });
		}
		
	}
	
}