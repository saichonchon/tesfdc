/**************************************************************************************************************************************************
Name:  DTCRequestPageExt 
Copyright © 2013 TE Connectivity
===================================================================================================================================================
Purpose: This class contain method to redirect to VF page based on record type selected and profile of user.
---------------------------------------------------------------------------------------------------------------------------------------------------                                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date         Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
1.0     Mrunal Parate     08/26/2014    Initial Development                     R-1455                     
**************************************************************************************************************************************************/
public with sharing class DTCRequestPageExt {
    private final Case exiCase;
    Id caseRecType;
    Id cId;
    public DTCRequestPageExt(ApexPages.StandardController controller) {
        this.exiCase= (Case)controller.getRecord();
        cId = exiCase.Id;
        caseRecType = exiCase.recordTypeId;
    }
    public PageReference redirectToPage() {
        string selectedRecordType = ApexPages.currentPage().getParameters().get('RecordType');
        if(cId == null){
            if ((selectedRecordType != null && (selectedRecordType == (DTC_Request_page_access__c.getinstance('RecordType')).Id__c)) &&  (((DTC_Request_page_access__c.getinstance('Profiles List')).Id__c).contains(Userinfo.getProfileId().substring(0,15)))){
                return null;
            }else if((selectedRecordType == null &&(((DTC_Request_page_access__c.getinstance('Profiles List')).Id__c).contains(Userinfo.getProfileId().substring(0,15))))){
                return null;
            }else{
                return new PageReference('/500/e?retURL=%2F500%2Fo&nooverride=1');
            }
        }
        else{
            if(caseRecType != null && (caseRecType == (DTC_Request_page_access__c.getinstance('RecordType')).Id__c) && (((DTC_Request_page_access__c.getinstance('Profiles List')).Id__c).contains(Userinfo.getProfileId().substring(0,15))))
                return null;
            else
                return new PageReference('/'+cId+'/e?retURL=%2F'+cId+'&nooverride=1');
            }
        }
    }