/***************************************************************************************
Name:ACP_Manage_Account_Plan_Ctrl
Test Class:ACP_Manage_Account_Plan_Ctrl_Test
Copyright © 2017 TE Connectivity
=========================================================================================
Requirement:
Controller for ACP Manage Account Plan creation 
=========================================================================================
Purpose:
Allow Users to create new account plan or use the existing one.
=========================================================================================
History
-------
Version      Author                Date              Detail
1.0          Ritika Pahwa          06/05/17          Added methods used to create account plan
****************************************************************************************/
public with sharing class ACP_Manage_Account_Plan_Ctrl {

  /***********************************************Variables**************************************************************************/
  public String mode {
    get;
    set;
  }


  Account acts;

  private map < String, String > map_urlParams;
  private Id accId;
  private Id acpId;
  Account acc;



  Public ACP_Account_Plan__c getaccDet() {

    return accDet;

  }

  public ACP_Account_Plan__c accDet = new ACP_Account_Plan__c();

  /*********************************************the constructor***************************************************************************/
  public ACP_Manage_Account_Plan_Ctrl() {
    accId = ApexPages.currentPage().getParameters().get('accID');
    acts = [Select Id, Name, Account_Manager__c, createdDate, ACP_Account_Type__c from Account where id =: accId];

    if (acts != null) {
      accDet.ACP_Account_Name__c = accId;
      String formattedDate = acts.createdDate.format('MMddyyyy');
      accDet.Name = acts.Name + ' Account Plan ' + formattedDate;
      accDet.Account_Plan_Type__c = acts.ACP_Account_Type__c;
      if (acts.Account_Manager__c != null)
        accDet.ACP_Account_Manager__c = acts.Account_Manager__c;

      else {

        accDet.ACP_Account_Manager__c = UserInfo.getUserId();
      }

    }

  }

  /******************************************************For new account plan page********************************************************************/
  public pageReference newOrViewAccountPlan() {
    this.map_urlParams = ApexPages.currentPage().getParameters();
    if (this.map_urlParams.containsKey('accId')) {
      this.accId = this.map_urlParams.get('accId');

    }

    Id acId = this.accId;
    ACP_Account_Plan__c acpaccountPlan;

    List < ACP_Account_Plan__c > acp = [SELECT Id, ACP_Account_Name__c FROM ACP_Account_Plan__c WHERE ACP_Account_Name__c =: acId];

    if (acp.size() > 0) {
      acpaccountPlan = acp[0];
      system.debug('list of accnt plan ' + acp);
    }

    if (acpaccountPlan == null) {
      this.mode = 'new';
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, system.Label.No_Account_Plan));
    } else {
      this.mode = 'view';
      this.acpId = acpaccountPlan.Id;
      pageReference pr = new pageReference('/apex/ACP_View_Customer_Page?acpId=' + this.acpId);
      pr.setRedirect(true);
      return pr;
    }

    return null;
  }

  /***************************************To Create Account Plan******************************************/

  public pageReference createAccountPlan() {

    if (accDet != null)
      insert accDet;

    {

      pageReference pr = new pageReference('/apex/ACP_View_Customer_Page?acpId=' + accDet.id);
      pr.setRedirect(true);
      return pr;
    }
    return null;
  }
  /*********************************************Created For Cancel Button*************************************************/
  public pageReference cancel() {
    pageReference pr = new pageReference('/' + this.accId);
    pr.setRedirect(true);
    return pr;
  }
  /*****************************************************************************************************************************/
}