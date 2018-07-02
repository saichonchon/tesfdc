public with sharing class ReportController1 {
 
     public List<SelectOption> availableReports { get; set; }
    public Id reportId { get; set; }
    public Id instanceId { get; set; }
    public Boolean reportIsRunning { get; set; }
    private transient Reports.ReportResults reportResults;
    public List<MQLData> MQLs { get; set; }
 
    public ReportController1() {
      MQLs = new List<MQLData>();
        availableReports = retrieveAvailableReports();
        /*if (availableReports.size() >0){
          reportId = availableReports[0].getValue();
          runReport();
          reportId = availableReports[1].getValue();
          runReport();
        }*/
        for (SelectOption so: availableReports){
            try {
                reportId = so.getValue();
            runReport();
            } catch(Exception e){
                system.debug(e.getMessage() + ' ' + e.getStackTraceString());
            }
        }
    }
 
    
    public List<SelectOption> retrieveAvailableReports() {
        List<SelectOption> reptOpts = new List<SelectOption>();
        
        // Get global Config settings 
        TEMarketing__report_settings__c reportSettings = TEMarketing__report_settings__c.getInstance();
        
        if (!String.IsBlank(reportSettings.TEMarketing__My_MQL_Lead_Report__c))
            reptOpts.add(new SelectOption(reportSettings.TEMarketing__My_MQL_Lead_Report__c,reportSettings.TEMarketing__My_MQL_Lead_Report__c));
        if (!String.IsBlank(reportSettings.TEMarketing__My_MQL_Contact_Report__c))
            reptOpts.add(new SelectOption(reportSettings.TEMarketing__My_MQL_Contact_Report__c,reportSettings.TEMarketing__My_MQL_Contact_Report__c));
        if (!String.IsBlank(reportSettings.TEMarketing__My_MQL_Queue_Report_Id__c))
            reptOpts.add(new SelectOption(reportSettings.TEMarketing__My_MQL_Queue_Report_Id__c,reportSettings.TEMarketing__My_MQL_Queue_Report_Id__c));
        system.debug('#####reptOpts'+reptOpts);
        return reptOpts;
    }
    /*
    public List<SelectOption> retrieveAvailableReports() {
        List<SelectOption> reptOpts = new List<SelectOption>();
        for (Report r : [
             Select Id, Name
             From Report
             Where Name like '%My MQLs Dashboard%MQL%' and NamespacePrefix like '%TEMarketing%'
             Order By Name
        ]) {
reptOpts.add(new SelectOption(r.Id, r.Name));
        }
        return reptOpts;
    }*/
 
    public PageReference runReport() {
        reportResults = Reports.ReportManager.runReport(reportId, true);
      
       reportIsRunning = false;
        Reports.ReportFactWithDetails reportDetails = (Reports.ReportFactWithDetails)reportResults.getFactMap().get('T!T');
        system.debug('==reportDetails=>'+reportDetails);
        system.debug('==reportDetails=>'+reportDetails.getRows());
        for(Reports.ReportDetailRow row:reportDetails.getRows()){
            List<Reports.ReportDataCell> cell = row.getDataCells();
            //add to MQLs
            MQLData mql = new MQLData();
            if(cell[0].getLabel().startsWith('00Q')){
                //Leads
                mql.Type = 'Lead';
                mql.Id = cell[0].getLabel();
                mql.FullName = cell[1].getLabel() + ' ' + cell[2].getLabel();
                if (cell[3].getLabel() != '-'){
                    mql.Age = Date.parse(cell[3].getLabel().split(' ')[0]).daysBetween(Date.today());
                    mql.MqlDate = DateTime.parse(cell[3].getLabel());
                }
                mql.AccountName = cell[4].getLabel();
                mql.MQLOwner = cell[5].getLabel();
                mql.Rating = cell[6].getLabel();
                mql.DCTFlag = cell[7].getLabel();
                 system.debug('#####LEAD');
                if (cell.size() > 7)
                    mql.LeadContactOwner = cell[7].getLabel();
            } else {
                //Contacts
                system.debug('#####CONTACT');
                mql.Type = 'Contact';
                mql.Id = cell[0].getLabel();
                mql.FullName = cell[1].getLabel() + ' ' + cell[2].getLabel();
                mql.MQLOwner = cell[6].getLabel();
                mql.Rating = cell[7].getLabel();               
                mql.DCTFlag = cell[8].getLabel();
                if (cell.size() > 8)
                    mql.LeadContactOwner = cell[8].getLabel();
				if (cell[5].getLabel() != '-'){
                    mql.AccountId = cell[5].getLabel();
                }
                mql.AccountName = cell[4].getLabel();
                if (cell[3].getLabel() != '-'){
                    mql.Age = Date.parse(cell[3].getLabel().split(' ')[0]).daysBetween(Date.today());
                    mql.MqlDate = DateTime.parse(cell[3].getLabel());
                }
            }
            
            MQLs.add(mql);
        }
        //Reports.ReportInstance reportInstance = Reports.ReportManager.runAsyncReport(reportId, true);
        //instanceId = reportInstance.getId();
        //processInstance(reportInstance);
         return null;
    }
 /*
    public PageReference checkForReportResults() {
        Reports.ReportInstance reportInstance = Reports.ReportManager.getReportInstance(instanceId);
        processInstance(reportInstance);
 
        return null;
    }
    @TestVisible
    private void processInstance(Reports.ReportInstance reportInstance) {
        reportIsRunning = reportInstance.getStatus() == 'Running' || reportInstance.getStatus() == 'New';
        if (!reportIsRunning) {
            reportResults = reportInstance.getReportResults();
        } else if(reportInstance.getStatus() == 'Error'){
             availableReports.add(new SelectOption('Error', 'Error'));
        }
    }
*/ 
    public Reports.ReportResults getReportResults() { 
        return reportResults;
    }
    
    public class MQLData {

        public string FullName {get; set;}
        public Id Id {get; set;}
        public datetime MqlDate {get; set;}
        public integer Age {get; set;}
        public string AccountName {get; set;}
        public Id AccountId {get; set;}
        public string Type {get; set;}
        public string MQLOwner {get; set;}
        public string DCTFlag {get; set;}
        public string LeadContactOwner {get; set;}
        public string Rating {get; set;}
    }
}