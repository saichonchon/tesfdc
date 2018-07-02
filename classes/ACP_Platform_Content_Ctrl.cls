/****************************************************************************************
Name: ACP_Platform_Content_Ctrl
============================================================================
Requirement: 
Controller for Page ACP_Add_Platform_Content and ACP_Edit_Platform_Content
============================================================================
Purpose:
Allow user to create and edit record in Platform Content
Test Class:
ACP_Platform_Content_Ctrl_Test
============================================================================
History
-------
VERSION AUTHOR DATE     DETAIL
1.0 -   Esther 10/23/17 INITIAL DEVELOPMENT
******************************************************************************************/
public class ACP_Platform_Content_Ctrl {

    

  public String Id {
    get;
    set;
  }
  
  public List < selectOption > getCBC1 {
    get;
    set;
  }
  public List < selectOption > getCBC2 {
    get;
    set;
  }
  public List < selectOption > getCBC3 {
    get;
    set;
  }
  list < AggregateResult > cbc1Desc = new list < AggregateResult > ();
  list < AggregateResult > cbc2Desc = new list < AggregateResult > ();
  list < AggregateResult > cbc3Desc = new list < AggregateResult > ();
  List < selectOption > optionsCBC1 = new List < selectOption > ();
  List < selectOption > optionsCBC2 = new List < selectOption > ();
  List < selectOption > optionsCBC3 = new List < selectOption > ();
  public string cbc1Value {
    get;
    set;
  }
  public string cbc2Value {
    get;
    set;
  }
  public string cbc3Value {
    get;
    set;
  }
  List < String > cbc1Arry = new List < String > ();
  List < String > cbc2Arry = new List < String > ();
  List < String > cbc3Arry = new List < String > ();
  
  Platform_Content__c PlatCont = new Platform_Content__c();
  Public Platform_Content__c getPlatCont() {
    return PlatCont;
  }

  public ACP_Platform_Content_Ctrl(ApexPages.StandardController controller) {
  id = ApexPages.currentPage().getParameters().get('Id');
   if (id != null && id != '') {
      PlatCont = [select id, Name, Program_Opportunity__c, CBC1__c, CBC2__c, CBC3__c, TAM_per_unit__c, PAM_per_unit__c, TAM__c, PAM__c, SAM__c, TE_MS_Trend__c, ACP_Name__c, CurrencyIsoCode, AVL__c, TE_MS__c, Main_Competitor__c, Main_Competitor_Share__c, TAM_CY__c, TAM_LY__c, TAM_NY__c, Comments__c from Platform_Content__c where id =: id];
    }
  }

  public ACP_Platform_Content_Ctrl() {
 
    }

     Map<string,string>CBC1DescriptionMap=new Map<string,string>();
    Map<string,string>CBC2DescriptionMap=new Map<string,string>();
    Map<string,string>CBC3DescriptionMap=new Map<string,string>();
    String CBC1Description;
    String CBC2Description;
    String CBC3Description;
    public Map<String,String> cbcValueMap = new Map<String,String>();
    public Map<String,String> cbcDescMap = new Map<String,String>();
    
  /*To get the picklist valuse for CBC1 */
  Public List < selectOption > getCBC1() {

    cbc1Desc = [select CBC1__c, CBC1_Description__c from Product_Hierarchy__c Group by CBC1__c, CBC1_Description__c];
    optionsCBC1.clear();
    optionsCBC1.add(new SelectOption('', 'Select'));

    for (AggregateResult c1: cbc1Desc) {
      String cbc1 = (string) c1.get('CBC1_Description__c');
      String cbc1Code = (string) c1.get('CBC1__c');
      String cbc1Val = cbc1Code + '--' + cbc1;
      system.debug('cbcVal' + cbc1Val);
      if (cbc1 != null && cbc1 != ''){
          CBC1DescriptionMap.put(cbc1Code,cbc1);
        optionsCBC1.add(new selectOption(cbc1Val, cbc1));
      }
    }
    return optionsCBC1;

  }
  /*To get the picklist valuse for CBC2 */
  Public List < selectOption > getCBC2() {
 
    system.debug('cbc1Value' + cbc1Value);
    if (cbc1Value != null && cbc1Value != '') {
         CBC1Description=CBC1DescriptionMap.get(cbc1Value.substringBefore('--'));
    }
    cbc2Desc = [SELECT CBC2__c, CBC2_Description__c FROM Product_Hierarchy__c WHERE CBC1_Description__c =: CBC1Description Group by CBC2__c, CBC2_Description__c];
    optionsCBC2.clear();
    optionsCBC2.add(new SelectOption('', 'Select'));
    for (AggregateResult c2: cbc2Desc) {

      String cbc2 = (string) c2.get('CBC2_Description__c');
      String cbc2Code = (string) c2.get('CBC2__c');
      String cbc2Val = cbc2Code + '--' + cbc2;
     
      if (cbc2 != null && cbc2 != ''){
          CBC2DescriptionMap.put(cbc2Code,cbc2);
        optionsCBC2.add(new selectOption(cbc2Val, cbc2));
      }

    }
  
    return optionsCBC2;

  }
  /*To get the picklist valuse for CBC3 */
  Public List < selectOption > getCBC3() {
  
    if (cbc2Value != null && cbc2Value != '') {
     CBC2Description=CBC2DescriptionMap.get(cbc2Value.substringBefore('--'));
     CBC1Description=CBC1DescriptionMap.get(cbc1Value.substringBefore('--'));
    }
    cbc3Desc = [SELECT CBC3__c, CBC3_Description__c FROM Product_Hierarchy__c WHERE CBC2_Description__c =: CBC2Description and CBC1_Description__c =: CBC1Description Group by CBC3__c, CBC3_Description__c];
    optionsCBC3.clear();
    optionsCBC3.add(new SelectOption('', 'Select'));

    for (AggregateResult c3: cbc3Desc) {
      String cbc3 = (string) c3.get('CBC3_Description__c');
      String cbc3Code = (string) c3.get('CBC3__c');
      String cbc3Val = cbc3Code + '--' + cbc3;
      if (cbc3 != null && cbc3 != ''){
          CBC3DescriptionMap.put(cbc3Code,cbc3);
        optionsCBC3.add(new selectOption(cbc3Val, cbc3));
      }
    }
    
    return optionsCBC3;
  }

  public void CBCValue() {
    try {

      String cbcValue1;
      String cbcValue2;
      String cbcValue3;
      string strConc1;
      string strConc2;
      string strConc3;
      List < String > strConc3Arry = new List < String > ();
      List < String > strConc2Arry = new List < String > ();
      List < String > strConc1Arry = new List < String > ();

      //Concatenating the Values to store in the object fields
      if (cbc3Value != null) {
                CBC3Description=CBC3DescriptionMap.get(cbc3Value.substringBefore('--')); 
                strConc3 = 'CBC3' + ' - ' + cbc3Value.substringBefore('--') + ' - ' + CBC3Description;
      }
      if (cbc2Value != null) {
                strConc2= 'CBC2' + ' - ' + cbc2Value.substringBefore('--') + ' - ' + CBC2Description;
      }
      if (cbc1Value != null) {
                strConc1 = 'CBC1' + ' - ' + cbc1Value.substringBefore('--') + ' - ' + CBC1Description;

      }
    system.debug('CBC3Description'+CBC3Description);
     system.debug('CBC2Description'+CBC2Description);
      system.debug('CBC1Description'+CBC1Description);
  
        if (cbc3Value != null) {
          PlatCont.ACP_Name__c = strConc3;
          PlatCont.CBC3__c = CBC3Description;
          PlatCont.CBC2__c = CBC2Description;
          PlatCont.CBC1__c = CBC1Description;
        } else if (cbc2Value != null) {
          PlatCont.ACP_Name__c = strConc2;
          PlatCont.CBC3__c = '';
          PlatCont.CBC2__c = CBC2Description;
          PlatCont.CBC1__c = CBC1Description;
        } else {
          PlatCont.ACP_Name__c = strConc1;
          PlatCont.CBC3__c = '';
          PlatCont.CBC2__c = '';
          PlatCont.CBC1__c = CBC1Description;
        }
    
       } catch (Exception e) {      ErrorLogging.Log(e, 'ACP_Platform_Content_Ctrl', 'CBCValue', '');      ApexPages.addMessages(e);    }
  }
  //common method to Insert/Update Platform Content records when clicking add/Edit button
  public void saveCommonPlat() {
    CBCValue();
    try {
      upsert PlatCont;
      system.debug('PlatCont' + PlatCont);    } catch (DMLException e) {      ErrorLogging.Log(e, 'ACP_Platform_Content_Ctrl', 'saveCommonPlat', '');      ApexPages.addMessages(e);    }
  }
  //Upsert Platform Content records when clicking add/Edit button
  public PageReference SavePlatCont() {
    if (cbc1Value == null) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter CBC Description'));
      return null;
    } else {

      saveCommonPlat();
      PageReference savePageRef = new PageReference('/' + PlatCont.Id);
      savePageRef.setRedirect(true);
      return savePageRef;
    }
  }

  public PageReference saveAndNew() {
    if (cbc1Value == null) {
      ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please enter CBC'));
      return null;
    } else {

      saveCommonPlat();
      PageReference pagerefSN = new PageReference('/apex/ACP_Add_Platform_Content?saveURL=/' + PlatCont.Id);

      pagerefSN.setRedirect(true);
      return pagerefSN;
    }
  }
  
  
  public PageReference CancelPlatCont() {
    Schema.DescribeSObjectResult result = Platform_Content__c.SObjectType.getDescribe();
    PageReference savePageRef = new PageReference('/' + result.getKeyPrefix() + '/o');
    savePageRef.setRedirect(true);
    return savePageRef;
  }

  public PageReference CancelPlatContEdit() {
    PageReference savePageRef = new PageReference('/' + PlatCont.Id);
    savePageRef.setRedirect(true);
    return savePageRef;
  }

}