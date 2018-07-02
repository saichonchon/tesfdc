/**
 *  This class is CSD interface class.
 *  
 * @author Lei Tang
 * @created 2014-09-19
 * @version 1.0
 * @since 30.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2014-09-19 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 *
 */
public without sharing class CSD_Interface {
    
    public abstract class ACSDRemoteService{
        public virtual String getSearchResult(String sData){ return ''; }
        public virtual String getExistResult(String sData){ return ''; }
        public virtual String saveSObjectData(String sData) { return ''; }
        public virtual String deleteCSDObject(String sData) { return ''; }
        public virtual String getRefData(String sData) { return ''; } 
        public virtual String getBacklogRefData(String sData) { return ''; } 
        public virtual String useASP(String sData) { return ''; }
        public virtual String copyCFTForecast(String sData) { return ''; }
        public virtual String getTotalBillingData(String sData) { return ''; }
            
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
    public virtual interface ICSDControllerService{
        
        //void setUserLocale(CSD_ClsEntityType.LocaleConfig localeConfig, String userLocale);
        void setLevel1Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns);
        void setLevel2Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns);
        void setLevel3Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns);
        void setLevel4Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns);
        void setPageConf(CSD_ClsEntityType.PageConfig PageConf);
        void setAllDateItems(CSD_ClsEntityType.PageConfig PageConf, list<CSD_ClsEntityType.DateItem> list_allDateItems);
        void setTotalRow(list<CSD_ClsEntityType.CSDColumn> list_acctColumns);

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
    public abstract class ACSDCtrlService implements ICSDControllerService{
        
        
        public virtual void setPopUPBoxColumnLevel1(list<Object> list_column){ }
        public virtual void setPopUPBoxColumnLevel2(list<Object> list_column){ }
        public virtual void setPopUPBoxColumnLevel3(list<Object> list_column){ }
        
        public virtual void setLevel1Data(list<Object> list_data, Object config){ }
        public virtual String setChannelForecast(Object config){ return ''; }
        
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
        public virtual void setTotalRow(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
            
            list<CSD_ClsEntityType.CSDColumn> list_t = new list<CSD_ClsEntityType.CSDColumn> {
                new CSD_ClsEntityType.CSDColumn('Current Sales Forecast', 'CurrentSalesForecast $', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Previous Sales Forecast', 'PreviousSalesForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Last Cycle DC Forecast', 'LastCycleDCforecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Statistical Forecast', 'StatisticalForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Billing', 'TotalBilling', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Booking', 'TotalBooking', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Backlog', 'TotalBacklog', '', '', false)
            };
            
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
        public virtual void setLevel1Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
            
            list<CSD_ClsEntityType.CSDColumn> list_t = new list<CSD_ClsEntityType.CSDColumn> {
                new CSD_ClsEntityType.CSDColumn('Current Sales Forecast', 'CurrentSalesForecast $', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Previous Sales Forecast', 'PreviousSalesForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Last Cycle DC Forecast', 'LastCycleDCForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Statistical Forecast', 'StatisticalForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Billing', 'TotalBilling', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Booking', 'TotalBooking', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Backlog', 'TotalBacklog', '', '', false)
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
        public virtual void setLevel2Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
            
            list_acctColumns.addAll(new list<CSD_ClsEntityType.CSDColumn> {
                new CSD_ClsEntityType.CSDColumn('Current Sales Forecast', 'CurrentSalesForecast $', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Previous Sales Forecast', 'PreviousSalesForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Last Cycle DC forecast', 'LastCycleDCForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Statistical forecast', 'StatisticalForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Billing', 'TotalBilling', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Booking', 'TotalBooking', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Backlog', 'TotalBacklog', '', '', false)
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
        public virtual void setLevel3Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
            
            list_acctColumns.addAll(new list<CSD_ClsEntityType.CSDColumn> {
                new CSD_ClsEntityType.CSDColumn('Current Sales Forecast', 'CurrentSalesForecast $', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Previous Sales Forecast', 'PreviousSalesForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Last Cycle DC forecast', 'LastCycleDCForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Statistical forecast', 'StatisticalForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Billing', 'TotalBilling', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Booking', 'TotalBooking', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Backlog', 'TotalBacklog', '', '', false)
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
        public virtual void setLevel4Row(list<CSD_ClsEntityType.CSDColumn> list_acctColumns){
            
            list<CSD_ClsEntityType.CSDColumn> list_t = new list<CSD_ClsEntityType.CSDColumn> {
                new CSD_ClsEntityType.CSDColumn('Current Sales Forecast', 'CurrentSalesForecast $', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Previous Sales Forecast', 'PreviousSalesForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Last Cycle DC Forecast', 'LastCycleDCForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Statistical Forecast', 'StatisticalForecast', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Billing', 'TotalBilling', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Booking', 'TotalBooking', '', '', false),
                new CSD_ClsEntityType.CSDColumn('Total Backlog', 'TotalBacklog', '', '', false)
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
        public virtual void setPageConf(CSD_ClsEntityType.PageConfig PageConf) {
            // set page config
            CSD_ClsUtils.setFiscalMonth(pageConf);
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
        public virtual void setAllDateItems(CSD_ClsEntityType.PageConfig PageConf, list<CSD_ClsEntityType.DateItem> list_allDateItems) {
            //to do set all date items
            CSD_ClsUtils.createDateItem(pageConf, list_allDateItems);
        }
    }
    
}