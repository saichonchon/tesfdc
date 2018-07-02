public class Fetch_Records {
    
    public LIST<Reports_Dashboard_Permission_Conf__c> listReport    {get; set;}
    public LIST<Reports_Dashboard_Permission_Conf__c> listDashboard {get; set;}
    public LIST<Reports_Dashboard_Permission_Conf__c> listAnalytics {get; set;}
    public String userType {get; set;}
    Private string reportQuery ;
    private string CurrentUserprofileName; 
    
    public Fetch_Records(){
        User objUser = New User();
        objUser = [SELECT Id, Name,Profile.Name FROM User WHERE Id =: Userinfo.getUserId()];
        CurrentUserprofileName = objUser.Profile.Name;
        //system.debug('******objUser*****'+objUser.Profile.Name);
        //system.debug('******CurrentUserprofileName*****'+CurrentUserprofileName);      
        reportQuery = 'Select ID, Name, recordtype.name,Profile__c,User_Region__c, Dashboard_Report_Link__c,Usertype__c, Dashboard_Report_Link_Label__c, Dashboard_Report_Description__c FROM Reports_Dashboard_Permission_Conf__c WHERE recordtypeId != null ORDER BY User_Region__c DESC ';
        //system.debug('***reportQuery****'+reportQuery);
        loadData(reportQuery);
            
    } 
    
    public void loadData(String strQueryKey){
    listReport = new LIST<Reports_Dashboard_Permission_Conf__c>();
    listDashboard = new LIST<Reports_Dashboard_Permission_Conf__c>(); 
    listAnalytics = new LIST<Reports_Dashboard_Permission_Conf__c>();    
    for(Reports_Dashboard_Permission_Conf__c objReportsDashboardPermissionConf : Database.query(strQueryKey)){           
            Set<String> setProfiles = New Set<String>();            
            setProfiles.addAll((objReportsDashboardPermissionConf.Profile__c != null ? objReportsDashboardPermissionConf.Profile__c.split(';') : New List<String>{null}));
            String recordTypeName = objReportsDashboardPermissionConf.recordtype.name; 
            if(setProfiles.contains(CurrentUserprofileName) || (objReportsDashboardPermissionConf.User_Region__c != null && objReportsDashboardPermissionConf.User_Region__c.containsIgnoreCase('GLOBAL'))){
                if(recordTypeName == 'Dashboard'){
                    listDashboard.add(objReportsDashboardPermissionConf);
                }
                else if(recordTypeName == 'Report'){
                    listReport.add(objReportsDashboardPermissionConf);
                }
                else if(recordTypeName == 'Analytics'){
                    listAnalytics.add(objReportsDashboardPermissionConf);
                }
            }
        }   
    }
    
    public List<SelectOption> getUserTypes(){
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = Reports_Dashboard_Permission_Conf__c.Usertype__c.getDescribe();        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('0', 'Select All'));
        system.debug('********inside Select all if condition');
        for( Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    } 
    
    public void changeUsertype(){
        String userTypeValue = '';
        
        if((CurrentUserprofileName == 'System Administrator' && userType !='0') || userType != '0'){
            userTypeValue = 'WHERE Usertype__c INCLUDES (\''+userType+'\')' ;
        }
        
        String reportQuery = 'Select ID, Name, recordtype.name,Profile__c,User_Region__c, Dashboard_Report_Link__c, Dashboard_Report_Link_Label__c, Dashboard_Report_Description__c FROM Reports_Dashboard_Permission_Conf__c ';
        String querySorting = ' ORDER BY User_Region__c DESC ';
        reportQuery = reportQuery + userTypeValue + querySorting;        
        loadData(reportQuery);    
    }
}