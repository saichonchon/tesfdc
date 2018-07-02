/***********************************************************************************************************************
 Name: PICMLanguage
 Org : Migrated from Central QA
 Copyright : © 2015 TE Connectivity 
========================================================================================================================
 Summary : Logic for multi language translations to WebTocaseML site page in TE.site  
 -----------------------------------------------------------------------------------------------------------------------
 VERSION  AUTHOR    DATE DETAIL  MERCURY REQUEST #
 -----------------------------------------------------------------------------------------------------------------------
   1.0   Santhosh Kumar    05/02/2015 WebTocase-multi langual Page    4043673
***********************************************************************************************************************/ 
//Migrated By Sanghita 
/***********************************************************************************************************************/ 
global without sharing class PICMLanguage
{
 /* _____________________________ D1. COLLECTION VARIABLE DECLARATION ____________________________*/
 global List<PIC_Language__c> vLstPICLan{get;set;}
 global PIC_Language__c  vPICLan   {get;set;}
 global List<String>vLstTollNum    {get;set;}
 global List<String>vLstCountry    {get;set;}
 global List<String>vLstCountryLabel    {get;set;}
 global List<String>vLstTypeOfCust {get;set;}
 global List<String>vLstTypeOfCustLabel {get;set;}
 global List<String>vLstProduct    {get;set;}
 global List<String>vLstProductLabel    {get;set;}
 global List<String>vLstCategory   {get;set;}
 global List<String>vLstCategoryLabel   {get;set;}
 global List<String>vLstIndustry   {get;set;}
 global List<String>vLstIndustryLabel   {get;set;}
 global List<SelectOption>    vLstCountrySO  {get;set;}
 global List<SelectOption>    vLstTypeOfCustSO    {get;set;}
 global List<SelectOption>    vLstProductSO  {get;set;}
 global List<SelectOption>    vLstCategorySO {get;set;}
 global List<SelectOption>    vLstIndustrySO {get;set;}
 
 /* _____________________________ D2. PRIMITIVE VARIABLE DECLARATION _____________________________*/
 global String vSelectedIndustry   {get;set;}
 global String vLanguage {get;set;}
 global String vRegion   {get;set;}
 global String vLangCode {get;set;}
 global String lang {get;set;}
 
 //constructor for Extracting Language info and translation label values from map of URL parameters.
 global PICMLanguage(ApexPages.StandardController controller)
 {

    map<string,string> mapParams = WebToCaseContExtML.mapParams;
    if(!mapParams.isEmpty() && mapParams.keySet().size()>0)
    {
 vLanguage = mapParams.get('p_lg');
 vRegion   = mapParams.get('Region');
    }    
    if(vRegion != null)
    {
    This.vLanguage = vLanguage + vRegion;
    }
 
    if(ApexPages.currentPage().getParameters().containsKey('endpoint'))
    {
    string endpoint = ApexPages.currentPage().getParameters().get('endpoint');
    PageReference pg = new PageReference(endpoint);
    if(pg.getParameters().containsKey('p_lg'))
    {
  This.vLangCode = pg.getParameters().get('p_lg');
  
  vLstPICLan = [SELECT Id,Name,Key_LanguageRegion__c,Language_Code__c,Chat_Display__c,M_Call_toll_free_number__c,M_Call_us_body__c,M_Call_us_label__c,M_Chat_Call_or_Email__c,M_Chat_Now__c,M_Chat_with_us_body_Active__c,M_Chat_with_us_body_InActive__c,M_Chat_with_us_label__c,M_Email_Ask_a_question__c,M_Email_us_body__c,M_Email_us_label__c,M_Chat_Button_Id__c,E_Product_PickList__c,E_Product_PickList_Trans__c,E_Type_of_Customer_PickList__c,E_Type_of_Customer_PickList_Trans__c,E_Category_PickList__c,E_Category_PickList_Trans__c,E_Country_PickList__c,E_Country_PickList_Trans__c,E_Pl_Enter_Subject__c,E_File_Size_Cannot_be_more__c,E_Error_Uploading_Att__c,E_Your_Question_Submitted__c,E_Welcome_Back__c,E_Please_fill_in_Additional__c,E_First_Name_Existing_Contact__c,E_Last_Name_Existing_Contact__c,E_Address__c,E_Attach_Document__c,E_Category__c,E_City__c,E_Company_Name__c,E_Competitor_Name__c,E_Competitor_Part__c,E_Continue__c,E_Country__c,E_Country_Error_msg__c,E_Email_Address__c,E_First_Name__c,E_Last_Name__c,E_Note_for_Attachment__c,E_Note__c,E_None__c,E_None_Trans_label__c,E_Part_Number__c,E_Phone__c,E_Product__c,E_Question__c,E_State__c,E_Subject__c,E_Submit_a_question_to_our_support_team__c,E_Type_Of_Customer__c,E_Zip__c,C_Chat_Now__c,C_Industry_PickList__c,C_Industry_PickList_Trans__c,C_Company__c,C_Email__c,C_First_Name__c,C_Industry__c,C_Last_Name__c,C_Required__c,C_Thanks_for_contacting_Header__c,C_Title__c FROM PIC_Language__c WHERE Language_Code__c = :This.vLangCode LIMIT 1];  
 
if(vLstPICLan != null)
{
 if(vLstPICLan.size() > 0)
 {
  This.vLanguage = vLstPICLan[0].Key_LanguageRegion__c;
 }
}

    }
 }
  
  vLstPICLan = [SELECT Id,Name,Key_LanguageRegion__c,Language_Code__c,Chat_Display__c,M_Call_toll_free_number__c,M_Call_us_body__c,M_Call_us_label__c,M_Chat_Call_or_Email__c,M_Chat_Now__c,M_Chat_with_us_body_Active__c,M_Chat_with_us_body_InActive__c,M_Chat_with_us_label__c,M_Email_Ask_a_question__c,M_Email_us_body__c,M_Email_us_label__c,M_Chat_Button_Id__c,E_Product_PickList__c,E_Product_PickList_Trans__c,E_Type_of_Customer_PickList__c,E_Type_of_Customer_PickList_Trans__c,E_Category_PickList__c,E_Category_PickList_Trans__c,E_Country_PickList__c,E_Country_PickList_Trans__c,E_Pl_Enter_Subject__c,E_File_Size_Cannot_be_more__c,E_Error_Uploading_Att__c,E_Your_Question_Submitted__c,E_Welcome_Back__c,E_Please_fill_in_Additional__c,E_First_Name_Existing_Contact__c,E_Last_Name_Existing_Contact__c,E_Address__c,E_Attach_Document__c,E_Category__c,E_City__c,E_Company_Name__c,E_Competitor_Name__c,E_Competitor_Part__c,E_Continue__c,E_Country__c,E_Country_Error_msg__c,E_Email_Address__c,E_First_Name__c,E_Last_Name__c,E_Note_for_Attachment__c,E_Note__c,E_None__c,E_None_Trans_label__c,E_Part_Number__c,E_Phone__c,E_Product__c,E_Question__c,E_State__c,E_Subject__c,E_Submit_a_question_to_our_support_team__c,E_Type_Of_Customer__c,E_Zip__c,C_Chat_Now__c,C_Industry_PickList__c,C_Industry_PickList_Trans__c,C_Company__c,C_Email__c,C_First_Name__c,C_Industry__c,C_Last_Name__c,C_Required__c,C_Thanks_for_contacting_Header__c,C_Title__c FROM PIC_Language__c  WHERE Key_LanguageRegion__c = :This.vLanguage  LIMIT 1  ];  
  if(vLstPICLan.isEmpty())
  {
   vLstPICLan = [
  SELECT Id,Name,Key_LanguageRegion__c,Language_Code__c,Chat_Display__c,M_Call_toll_free_number__c,M_Call_us_body__c,M_Call_us_label__c,M_Chat_Call_or_Email__c,M_Chat_Now__c,M_Chat_with_us_body_Active__c,M_Chat_with_us_body_InActive__c,M_Chat_with_us_label__c,M_Email_Ask_a_question__c,M_Email_us_body__c,M_Email_us_label__c,M_Chat_Button_Id__c,E_Product_PickList__c,E_Product_PickList_Trans__c,E_Type_of_Customer_PickList__c,E_Type_of_Customer_PickList_Trans__c,E_Category_PickList__c,E_Category_PickList_Trans__c,E_Country_PickList__c,E_Country_PickList_Trans__c,E_Pl_Enter_Subject__c,E_File_Size_Cannot_be_more__c,E_Error_Uploading_Att__c,E_Your_Question_Submitted__c,E_Welcome_Back__c,E_Please_fill_in_Additional__c,E_First_Name_Existing_Contact__c,E_Last_Name_Existing_Contact__c,E_Address__c,E_Attach_Document__c,E_Category__c,E_City__c,E_Company_Name__c,E_Competitor_Name__c,E_Competitor_Part__c,E_Continue__c,E_Country__c,E_Country_Error_msg__c,E_Email_Address__c,E_First_Name__c,E_Last_Name__c,E_Note_for_Attachment__c,E_Note__c,E_None__c,E_None_Trans_label__c,E_Part_Number__c,E_Phone__c,E_Product__c,E_Question__c,E_State__c,E_Subject__c,E_Submit_a_question_to_our_support_team__c,E_Type_Of_Customer__c,E_Zip__c,C_Chat_Now__c,C_Industry_PickList__c,C_Industry_PickList_Trans__c,C_Company__c,C_Email__c,C_First_Name__c,C_Industry__c,C_Last_Name__c,C_Required__c,C_Thanks_for_contacting_Header__c,C_Title__c FROM PIC_Language__c   WHERE Key_LanguageRegion__c = 'EnglishUS'   LIMIT 1 ];
  }
  
  if(vLstPICLan != null)
  {
  if(vLstPICLan.size() > 0)
  {
  vPICLan = vLstPICLan[0];
  if(vPICLan.M_Call_toll_free_number__c != null)
  {
  vLstTollNum = vPICLan.M_Call_toll_free_number__c.split('\r\n', -1);
  } 
 
  // =====================Country PickList Preparation============================================
   
  if(vPICLan.E_Country_PickList__c != null)
  {
  vLstCountry = vPICLan.E_Country_PickList__c.split('\r\n', -1);
  } 
   
  if(vPICLan.E_Country_PickList_Trans__c != null)
  {
  vLstCountryLabel = vPICLan.E_Country_PickList_Trans__c.split('\r\n', -1);
  }
   
  vLstCountrySO = new List<SelectOption>();
  vLstCountrySO.add(new SelectOption('',vPICLan.E_None_Trans_label__c));
  
  if(vLstCountry != null && vLstCountryLabel != null)
  {
  if(vLstCountry.size() == vLstCountryLabel.size())
  {
  for(Integer i=0; i<vLstCountry.size(); i++)
  {
  vLstCountrySO.add(new SelectOption((String)vLstCountry[i], (String)vLstCountryLabel[i]));
  } 
  } 
  } 
   
  // =====================Type Of Customer PickList Preparation===================================
   
  if(vPICLan.E_Type_of_Customer_PickList__c != null)
  {
vLstTypeOfCust = vPICLan.E_Type_of_Customer_PickList__c.split('\r\n', -1);
  } 
   
  if(vPICLan.E_Type_of_Customer_PickList_Trans__c != null)
  {
   
vLstTypeOfCustLabel = vPICLan.E_Type_of_Customer_PickList_Trans__c.split('\r\n', -1); 
  } 
   
  vLstTypeOfCustSO = new List<SelectOption>();
  
  if(vLstTypeOfCust != null && vLstTypeOfCustLabel != null)
  {
 if(vLstTypeOfCust.size() == vLstTypeOfCustLabel.size())
 {
  for(Integer i=0; i<vLstTypeOfCust.size(); i++)
  {
  vLstTypeOfCustSO.add(new SelectOption((String)vLstTypeOfCust[i], (String)vLstTypeOfCustLabel[i]));
  } 
  } 
  } 
   
  // =====================Product Category PickList Preparation===================================
   
  if(vPICLan.E_Product_PickList__c != null)
  {
    vLstProduct = vPICLan.E_Product_PickList__c.split('\r\n', -1);
  } 
   
  if(vPICLan.E_Product_PickList_Trans__c != null)
  {
   vLstProductLabel = vPICLan.E_Product_PickList_Trans__c.split('\r\n', -1);
  } 
  vLstProductSO = new List<SelectOption>();
   
  if(vLstProduct != null && vLstProductLabel != null)
  {
  if(vLstProduct.size() == vLstProductLabel.size())
  {
  for(Integer i=0; i<vLstProduct.size(); i++)
  {
  vLstProductSO.add(new SelectOption(String.valueOf(vLstProduct[i]), String.valueOf(vLstProductLabel[i])));
  } 
  } 
 } 
   
  // =====================Category PickList Preparation===========================================
   
  if(vPICLan.E_Category_PickList__c != null)
  {
   vLstCategory = vPICLan.E_Category_PickList__c.split('\r\n', -1);
  } 
  if(vPICLan.E_Category_PickList_Trans__c != null)
  {
   vLstCategoryLabel = vPICLan.E_Category_PickList_Trans__c.split('\r\n', -1);
  }
  vLstCategorySO = new List<SelectOption>();
   
  if(vLstCategory != null && vLstCategoryLabel != null)
  {
  if(vLstCategory.size() == vLstCategoryLabel.size())
  {
  for(Integer i=0; i<vLstCategory.size(); i++)
  {
  vLstCategorySO.add(new SelectOption(String.valueOf(vLstCategory[i]), String.valueOf(vLstCategoryLabel[i])));
  } 
  } 
 } 
   
 // =====================Industry PickList Preparation===========================================
   
  if(vPICLan.C_Industry_PickList__c != null)
  {
   vLstIndustry = vPICLan.C_Industry_PickList__c.split('\r\n', -1);
  } 
   
  if(vPICLan.C_Industry_PickList_Trans__c != null)
  {
   vLstIndustryLabel = vPICLan.C_Industry_PickList_Trans__c.split('\r\n', -1);
  }
   
  vLstIndustrySO = new List<SelectOption>();
   
  if(vLstIndustry != null && vLstIndustryLabel != null)
  {
  if(vLstIndustry.size() == vLstIndustryLabel.size())
  {
  for(Integer i=0; i<vLstIndustry.size(); i++)
  {
  vLstIndustrySO.add(new SelectOption((String)vLstIndustry[i], (String)vLstIndustryLabel[i]));
  } 
  } 
 } 
   
  }
   }
  }
}