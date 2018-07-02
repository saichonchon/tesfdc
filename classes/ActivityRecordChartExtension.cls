/*********************************************************************************************************************** 
 Name: ActivityRecordChartExtension 
 Copyright © 2013 TE Connectivity | Salesforce Instance : Central Org
========================================================================================================================
 Purpose: Extention class for Activity Record Filter and Charting visualforce page.                                                   
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                     
------------------------------------------------------------------------------------------------------------------------
 VERSION AUTHOR                DATE         DETAIL                                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------
     1.0 Ankit                 05/16/2013   Initial Development                                         
***********************************************************************************************************************/

Public class ActivityRecordChartExtension {

// Declair all the Variables,List,Set and Maps
// Declair Type: String
Public string vRecordId{get;set;}
Public string vParamOrder{get;set;}
Public string vParamDirec{get;set;}
Public string vLikeRecType{get;set;}
Public string vSelectARType{get;set;}
Public string vSelectMultipleARType{get;set;}
Public string vSetChartColor{get;set;}
Public string vsetDateRange{get;set;}
Public string vsetDateRangeAR{get;set;}
Public string vsetDateRangeSoql{get;set;}
Public string vsetDateRangeSoqlAR{get;set;}
Public string sLeadEmail{get;set;}
Public string vSeachActivityDec{get;set;}
Public string vStrLeadField{get;set;}

// Declair Type: Integer
Public Integer vTotalPNRCCount{get;set;}
Public Integer vConSize{get;set;}
Public Integer vCurrentLstSize{get;set;}
Public Integer clickLog{get;set;}

// Declair Type: Set
Public Set<Id> vARCid{get;set;}

// Declair Type: Collections
Public List<wrpChartData> wrppnrcChart{get;set;}
Public List<Activity_Record__c > vArcRecLst{get;set;}
Public List<Activity_Record__c > vArcRecLstupdatdelete{get;set;}
Public List<Activity_Chart_Filter_Criteria__c> vCusMap{get;set;}
Public Map<Id,Activity_Record__c > vArcMap{get;set;}

  // Initialize and Call Methords from Constructors
    Public ActivityRecordChartExtension (ApexPages.StandardController controller) {
        InitializeMethod ();
        if(vRecordId != null && vRecordId != ''){
            ActiRecWrapperFillMethordl();        
            FillChartDataMethord();
        } 
    } 

  // Initialize and Call Methords from Standard Controller 
    Public ActivityRecordChartExtension(ActivityRecordChartController controller) {
        InitializeMethod ();
        if(vRecordId != null && vRecordId != ''){
            ActiRecWrapperFillMethordl();        
            FillChartDataMethord();
        }
    } 
    
  // Methord 1#: Initialize all the variables and collections
  Public void InitializeMethod (){
    vRecordId =ApexPages.currentPage().getParameters().get('Id');
    vStrLeadField = setLeadFieldName();
    
    // Call the retSortedACF to get Sorted List
    vCusMap = new List<Activity_Chart_Filter_Criteria__c> ();
    List<Activity_Chart_Filter_Criteria__c> vTempLstAC = Activity_Chart_Filter_Criteria__c.getAll().values();
    vCusMap = retSortedACF(vTempLstAC); 
    
    vSetChartColor='#85ADFF,#506899,#8FB224,#E69C53,#A3A300,#A366E0,#E3D1F6,#99FF99,#C299AD,#ADC299,#FF944D,#FFFFB8';
    vARCid  = new Set<Id>();
    vTotalPNRCCount=0;
    vParamOrder= 'Activity_Date__c';
    vParamDirec='DESC';
    vConSize=Integer.valueOf( ActivityRecordChartSetting__c.getValues('Default'). ARChartPageSize__c);
    vSelectMultipleARType='';
    vsetDateRange = String.valueOf( ActivityRecordChartSetting__c.getValues('Default'). DateRangeForFirstFilter__c);
    vsetDateRangeAR = String.valueOf( ActivityRecordChartSetting__c.getValues('Default'). DateRangeForSecondFilter__c);
    vsetDateRangeSoql = '';
    vsetDateRangeSoqlAR = '';
    vLikeRecType='';
    vSelectARType='';
    sLeadEmail='';
    vSeachActivityDec='';
    clickLog=0;
    }
    
  // Methord 2#: Populate the Activity Record List
    Public void ActiRecWrapperFillMethordl(){
        vArcMap = new Map<Id,Activity_Record__c > (); 
        List<Activity_Record__c > arcTempRec = new List<Activity_Record__c >();
        arcTempRec = Database.query(retDynQuery());
        List<Activity_Record__c >  arcRecCloneLst = arcTempRec.deepclone();

        for(Activity_Record__c arcRec : arcRecCloneLst ){
            vArcMap.put(arcRec.Id,arcRec );
        }
        con = new ApexPages.StandardSetController(arcTempRec);
        con.setPageSize(vConSize); 
        if(sLeadEmail != null && sLeadEmail != ''){
            vCurrentLstSize=arcTempRec.size();
        }
        vARCid = vArcMap.keySet();
        bindWrptoPage ();
    }
    
  // Methord 3#: Populate the visualforce charts data from Activity Record List's data
  Public void FillChartDataMethord(){
  vArcRecLstupdatdelete = new List<Activity_Record__c > ();

  if(vSelectMultipleARType != null && vSelectMultipleARType != '' && vSelectMultipleARType.length() > 2){
    Set<String> setIds = new Set<String>();
    vSelectMultipleARType = vSelectMultipleARType.remove('[');
    vSelectMultipleARType = vSelectMultipleARType.remove(']');
    vSelectMultipleARType = vSelectMultipleARType.deleteWhitespace();

    Map<Id,Activity_Chart_Lookup_Filter__c> vTempACLMap = new Map<Id,Activity_Chart_Lookup_Filter__c>();
    while(vSelectMultipleARType.length() != 0 ){
      if(vSelectMultipleARType.IndexOf(',') != -1){
        string stemp = vSelectMultipleARType.substring(0,vSelectMultipleARType.IndexOf(','));

        vSelectMultipleARType = vSelectMultipleARType.substring(vSelectMultipleARType.IndexOf(',')+1,vSelectMultipleARType.length());
        String vTempACLStr = Activity_Chart_Lookup_Filter__c.getValues(stemp).ARL_Name__c;
        setIds.add(vTempACLStr);

      }
      else{
        String vTempACLStr = Activity_Chart_Lookup_Filter__c.getValues(vSelectMultipleARType).ARL_Name__c;
        setIds.add(vTempACLStr);
        vSelectMultipleARType = '';
      }  
    }
    vSelectMultipleARType = '';
    //\'' + vSelectMultipleARType +'\''
    if(vsetDateRange != '' && vsetDateRange != null){
      vsetDateRangeSoql = Activity_Chart_Filter_Criteria__c.getValues(vsetDateRange).Soql_Date__c ;
    }
    if((vsetDateRange == null || vsetDateRange == '') && (vsetDateRangeSoql != null || vsetDateRangeSoql != '') ){
      vsetDateRangeSoql = '';
    }

    if(vsetDateRangeSoql == null || vsetDateRangeSoql == '' ){  
      if( vsetDateRange == null && vsetDateRangeSoql == '' ){
        vArcRecLstupdatdelete = Database.query(retDQueryParameter()+
        ' AND Activity_Rating_Desc__c  IN : setIds ' );  
      }
      else{
        vArcRecLstupdatdelete = Database.query(retDQueryParameter()+
        ' AND Activity_Rating_Desc__c  IN : setIds AND Activity_Date__c = '+vsetDateRangeSoql );  
      }  
    }
    else{
      if( vsetDateRange == null || vsetDateRange == '' ){
        vArcRecLstupdatdelete = Database.query(retDQueryParameter()+
        ' AND Activity_Rating_Desc__c  IN : setIds AND Activity_Date__c = '+vsetDateRangeSoql + ' ORDER BY '+vParamOrder+' '+ vParamDirec );  
      }
      else{
        vArcRecLstupdatdelete = Database.query(retDQueryParameter()+
        ' AND Activity_Rating_Desc__c  IN : setIds AND Activity_Date__c = '+vsetDateRangeSoql );  
      }
    }
  }
  else{
    if(vsetDateRange != '' || vsetDateRange != null){
      vsetDateRangeSoql = Activity_Chart_Filter_Criteria__c.getValues(vsetDateRange).Soql_Date__c ;
      }
    if((vsetDateRange == null || vsetDateRange == '') && (vsetDateRangeSoql != null || vsetDateRangeSoql != '') ){
      vsetDateRangeSoql = '';
    }
    if(vsetDateRangeSoql == null || vsetDateRangeSoql == ''){  
      vArcRecLstupdatdelete = Database.query(retDQueryParameter());  
    }
    else{    
      vArcRecLstupdatdelete = Database.query(retDQueryParameter()+' AND Activity_Date__c = '+vsetDateRangeSoql );  
    }
  }

  Map<String,Integer> chartWrpMap = new Map<String,Integer>();
  Integer count = 0;
  Integer vARLLength = Integer.valueof(ActivityRecordChartSetting__c.getValues('Default').Activity_Type_Name_Length__c);
  
  List<wrpChartData> wrppnrcChartTemp = new List<wrpChartData>();
  for(Activity_Chart_Lookup_Filter__c arlRec: [Select Id,name,ARL_Name__c from Activity_Chart_Lookup_Filter__c order by ARL_Name__c]){
    if(arlRec.ARL_Name__c.length() > vARLLength){
        arlRec.ARL_Name__c = arlRec.ARL_Name__c.substring(0,vARLLength);    //Comment and uncomment code
    }
    wrpChartData ch;
    ch = new wrpChartData(arlRec.ARL_Name__c);
    wrppnrcChartTemp.add(ch);
    chartWrpMap.put(arlRec.ARL_Name__c,count );
    count ++;
  }

  for(Activity_Record__c  arcrec: vArcRecLstupdatdelete ){
    string vARLName='';
    if(arcrec.Activity_Rating_Desc__c != null && arcrec.Activity_Rating_Desc__c != ''){
        if(arcrec.Activity_Rating_Desc__c.length() > vARLLength){
          vARLName = arcrec.Activity_Rating_Desc__c.substring(0,vARLLength);    //Comment and uncomment code
        }
        else{
          vARLName = arcrec.Activity_Rating_Desc__c;
        }
        if(chartWrpMap.containsKey(vARLName)){
          wrppnrcChartTemp[chartWrpMap.get(vARLName)].datacount++;
        }
     }
  }
  wrppnrcChart = new List<wrpChartData> ();
  for(wrpChartData wrch: wrppnrcChartTemp){
    if(wrch.datacount > 0 && sLeadEmail != '' && sLeadEmail != null){
      wrppnrcChart.add(wrch);
    }
  }
    vTotalPNRCCount = vArcRecLstupdatdelete.size();
  }

  // Methord 4#: Parse the Dynamic Query Parameters
    Public string retDQueryParameter(){

    if(vRecordId.startsWithIgnoreCase('00Q')){
        sLeadEmail = [Select Id, Email from Lead where Id =: vRecordId].Email;
        system.debug('***sLeadEmail****'+sLeadEmail );
        String dQueryParama = 'Select Id,Name,'+vStrLeadField+',Activity_Rating_Desc__c,'+
                              'ActivityDateTime__c,Related_Part_Number_s__c,Activity_Notes__c,'+
                              'Associated_Email__c,Activity_Date__c from  Activity_Record__c where Associated_Email__c =: sLeadEmail';
        return dQueryParama ;
    }
    else if(vRecordId.startsWithIgnoreCase('003')){
        sLeadEmail = [Select Id,Email from Contact where Id = : vRecordId].Email ;
        system.debug('***sLeadEmail 003****'+sLeadEmail );
        String dQueryParama = 'Select Id,Name,'+vStrLeadField+',Activity_Rating_Desc__c,'+
                              'ActivityDateTime__c,Related_Part_Number_s__c,Activity_Notes__c,'+
                              'Associated_Email__c,Activity_Date__c from  Activity_Record__c where Associated_Email__c =: sLeadEmail';
        return dQueryParama ;
    }
    else{
        return '';
    }    
    }
  
  // Methord 5#: Concatinate the Query String with Parameters.
    Public String retDynQuery(){
     if(vsetDateRangeAR != '' && vsetDateRangeAR != null){
      vsetDateRangeSoqlAR = Activity_Chart_Filter_Criteria__c.getValues(vsetDateRangeAR).Soql_Date__c ;
    }
    else{
      vsetDateRangeSoqlAR = '';
    }
       String dQueryParama = retDQueryParameter();
       String dQuery='';
        if((vLikeRecType == null || vLikeRecType == '')){
            if(vSelectARType == '' || vSelectARType == null){
                if( (vsetDateRangeSoqlAR =='' || vsetDateRangeSoqlAR == null)){
                  dQuery = dQueryParama ;
                }
                else{
                  dQuery = dQueryParama +
                                 ' AND Activity_Date__c = '+vsetDateRangeSoqlAR;
                }   
            }
            else{
                vSeachActivityDec = Activity_Chart_Lookup_Filter__c.getValues(vSelectARType).ARL_Name__c;

                if( (vsetDateRangeSoqlAR =='' || vsetDateRangeSoqlAR == null)){
                  dQuery = dQueryParama  +
                                 ' AND Activity_Rating_Desc__c =: '+
                                 ' vSeachActivityDec';
                }
                else{
                  dQuery = dQueryParama  +
                                 ' AND Activity_Rating_Desc__c =: '+
                                 ' vSeachActivityDec AND Activity_Date__c = '+vsetDateRangeSoqlAR;
                } 
            }
        }
        else if(vLikeRecType != null || vLikeRecType != '' && vParamOrder != null && vParamOrder != ''){
            if(vSelectARType == '' || vSelectARType == null){
        if(vsetDateRangeSoqlAR != null || vsetDateRangeSoqlAR != ''){
          dQuery =dQueryParama +
                        ' AND Name LIKE \'%'+ vLikeRecType +'%\'  '+
                        '  AND Activity_Date__c = '+vsetDateRangeSoqlAR ;
        }
        else{
          dQuery =dQueryParama +
                        ' AND Name LIKE \'%'+ vLikeRecType +'%\'' ;
        }
                
            }
            else{
            vSeachActivityDec = Activity_Chart_Lookup_Filter__c.getValues(vSelectARType).ARL_Name__c;
                dQuery =dQueryParama +
                        ' AND Name LIKE \'%'+ vLikeRecType +'%\'  and Activity_Rating_Desc__c =: '+
                        ' vSeachActivityDec  AND Activity_Date__c = '+vsetDateRangeSoqlAR ;
            }
            
        }
        return dQuery ;
    }

  // Methord 6#: To return the sorted Select List
  Public List<Activity_Chart_Filter_Criteria__c> retSortedACF(List<Activity_Chart_Filter_Criteria__c> vTempLstAC){
    List<Sobject> resultList = new List<Sobject>();
    Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();

    for(Sobject ob : vTempLstAC ){
        if(objectMap.get(ob.get('Name')) == null){  // For non Sobject use obj.ProperyName
          objectMap.put(ob.get('Name'), new List<Sobject>()); 
        }
        objectMap.get(ob.get('Name')).add(ob);
    }       
    //Sort the keys
    List<object> keys = new List<object>(objectMap.keySet());
    keys.sort();

    for(object key : keys){ 
      resultList.addAll(objectMap.get(key)); 
    }

    //Apply the sorted values to the source list
    vTempLstAC .clear();

    for(Sobject ob : resultList){
      vTempLstAC .add((Activity_Chart_Filter_Criteria__c)ob); 
    }
    return vTempLstAC;
  }
    
  // Methord 7#: Methord to check the field name on BU Org.
  Public String setLeadFieldName(){
    String vFieldName = 'Lead__c';
    return vFieldName;
  }

  // Declair the StandardSetController
    Public ApexPages.StandardSetController con{get; set;}
    
  // Methord 8#: Methord to bind the wrapper list to page.
    Public void bindWrptoPage() {  
        vArcRecLst = new List<Activity_Record__c > ();
        if((List<Activity_Record__c>)con.getRecords() != null && (sLeadEmail != '' && sLeadEmail != null) ){
            vArcRecLst = (List<Activity_Record__c>)con.getRecords();
        }
    }  
    
  // List of Ativity Record Filter From Custom Setting
    Public List<SelectOption> ARDateFilter{
    get{
        ARDateFilter = new List<SelectOption>(); 
        ARDateFilter.add(new SelectOption('', 'All'));
        for(Activity_Chart_Filter_Criteria__c ArF: vCusMap){
            ARDateFilter.add(new SelectOption(ArF.name, ArF.name));
        }

        return ARDateFilter ;
    }
    set;
    }   

  // List of All Activity Record Lookups
  Public List<SelectOption> StatusList{
    get{
        StatusList= new List<SelectOption>(); 
        StatusList.add(new SelectOption('', 'All'));
        List<Activity_Chart_Lookup_Filter__c> vTempItrrateLst = Activity_Chart_Lookup_Filter__c.getAll().Values();
        vTempItrrateLst.sort();
        for(Activity_Chart_Lookup_Filter__c arlRec: vTempItrrateLst){
            StatusList.add(new SelectOption(arlRec.Name, arlRec.ARL_Name__c));
        }

        return StatusList;
    }
    set;
    }  
  
  // Methord 9#: Methord to sort the List data and bind it to page
  public void getSort(){
        List<Activity_Record__c >  vLstSortAR = new List<Activity_Record__c > ();
        List<Activity_Record__c >  vLstSortARTemp = new List<Activity_Record__c > ();
        vLstSortARTemp = Database.query(retDynQuery());
        vLstSortAR = vLstSortARTemp.clone();
        List<Sobject> resultList = new List<Sobject>();
        Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
        
        for(Sobject ob : vLstSortAR ){
                if(objectMap.get(ob.get(vParamOrder)) == null){  // For non Sobject use obj.ProperyName
                    objectMap.put(ob.get(vParamOrder), new List<Sobject>()); 
                }
                objectMap.get(ob.get(vParamOrder)).add(ob);
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
       
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
       
        //Apply the sorted values to the source list
        vLstSortAR.clear();

        if(clickLog==0){
        clickLog=1;
            for(Sobject ob : resultList){
                vLstSortAR.add((Activity_Record__c)ob); 
            }
        }
        else{
            for(integer i = resultList.size()-1; i >= 0; i--){
                vLstSortAR.add((Activity_Record__c)resultList[i]);  
            }
            clickLog=0;
        }
        con = new ApexPages.StandardSetController(vLstSortAR);
        con.setPageSize(vConSize); 
        bindWrptoPage();
    }
  
  // Define the Wrapper class   
    Public class wrpChartData{
        Public String stsStatus{get;set;}
        Public Integer datacount{get;set;}
        Public wrpChartData(String sts){
            datacount = 0;
            stsStatus = sts;
        }
    }
    
  // Methords for Pagination
    Public void first() {
        con.first();bindWrptoPage();
    }
 
    Public void last() {
        con.last();bindWrptoPage();
    }
 
    Public void previous() {
        con.previous();bindWrptoPage();
    }
 
    Public void next() {
        con.next();bindWrptoPage();
    }
}