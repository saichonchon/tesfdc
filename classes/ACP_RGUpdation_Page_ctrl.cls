/****************************************************
Author          : Haripriya Maturi
Created Date    : 07/20/17
Project         : Account Plan
Description     : Controller for updating growth tree data 
*****************************************************/

public with sharing class ACP_RGUpdation_Page_ctrl{
private ApexPages.StandardController rgstdController;
public String acpId{get;set;}
public ACP_Revenue_Growth_Perf__c revenueGrowth{get;set;}
public List <ACP_Revenue_Growth_Perf__c> revenueGrowthList{get;set;}
public List <ACP_Revenue_Growth_Perf__c> growthList = new List <ACP_Revenue_Growth_Perf__c>();
public Map<String,String> labelMap{get;set;}

public String userBU{get;set;}
public ACP_Setting__c buSetting = new ACP_Setting__c(); 
public ACP_Section_Detail__c detrec{
    get{
        detrec = ACP_AccountPlan_Helper.getACPSectionRec(buSetting,'TE Business Performance');
        return detrec;
    }set;
}

public ACP_RGUpdation_Page_ctrl(ApexPages.StandardController stdController) {
    acpId = ApexPages.currentPage().getParameters().get('acpId');
    rgstdController = stdController;
    revenueGrowth = (ACP_Revenue_Growth_Perf__c)rgstdController.getRecord();
    
    userBU = [Select GIBU__c From User Where Id = :UserInfo.getUserId()][0].GIBU__c;
    buSetting = ACP_AccountPlan_Helper.getACPSettingRecord(userBU);
    if(buSetting == null)
    buSetting = ACP_AccountPlan_Helper.getACPSettingRecord(''); 
    
    getGrowthList();
}

public void getGrowthList() {
    revenueGrowthList = new List <ACP_Revenue_Growth_Perf__c>();
    
    growthList = getRevenueGrowthList(acpId);
    
    if (growthList.size() > 0) {
        for (ACP_Revenue_Growth_Perf__c eval: growthList) {
            revenueGrowthList.add(eval);            
        }
    }
}
public List <ACP_Revenue_Growth_Perf__c> getRevenueGrowthList(String acpId) {
    transient String query = 'SELECT ';   
    labelMap = new Map<String,String>(); 
    for (Schema.FieldSetMember f: getRevenueGrowthFields()) {
        query += f.getFieldPath() + ',';
        
        if(f.getLabel() == 'Show this on chart'){
            labelMap.put(f.getLabel(),'Show this on chart');
        }else if(f.getLabel() == 'Past Year + 1 Revenue'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()-2)+ ' Revenue');
        }else if(f.getLabel() == 'Past year Revenue'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()-1)+' Revenue');
        }else if(f.getLabel() == 'Past year To Date'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()-1)+' To Date');
        }else if(f.getLabel() == 'Current Year To Date'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year())+' To Date');
        }else if(f.getLabel() == 'Current Year Run Rate'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year())+' Run Rate');
        }else if(f.getLabel() == 'LY Market Growth'){
            labelMap.put(f.getLabel(),'Market Growth');
        }else if(f.getLabel() == 'LY Price Erosion'){
            labelMap.put(f.getLabel(),'Price Erosion');
        }else if(f.getLabel() == 'Current FY Base'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()) + ' Base');
        }else if(f.getLabel() == 'Base BU'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()+5) + ' Base BU');
        }
     /********************Need To remove**********************************/   
       /** else if(f.getLabel() == 'Project 1'){
            labelMap.put(f.getLabel(),detrec.Growth_Tree_Data_Element_2__c);
        }else if(f.getLabel() == 'Project 2'){
            labelMap.put(f.getLabel(),detrec.Growth_Tree_Data_Element_3__c);
        }else if(f.getLabel() == 'Project 3'){
            labelMap.put(f.getLabel(),detrec.Growth_Tree_Data_Element_4__c);
        }else if(f.getLabel() == 'Project 4'){
            labelMap.put(f.getLabel(),detrec.ACP_Growth_Tree_Data_Element_5__c);
        }else if(f.getLabel() == 'Project 5'){
            labelMap.put(f.getLabel(),detrec.ACP_Growth_Tree_Data_Element_6__c);
        }**/
     /************************************************************/   
        else if(f.getLabel() == 'Current FY Close'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()) + ' Close');
        }else if(f.getLabel() == 'Current Year Plan'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()) + ' Plan');
        }else if(f.getLabel() == 'Current Year + 1 Plan'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()+1) + ' Plan');
        }else if(f.getLabel() == 'Current Year + 3 Plan'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()+3) + ' Plan');
        }else if(f.getLabel() == 'Current Year + 5 Plan'){
            labelMap.put(f.getLabel(),String.valueOf(System.Today().Year()+5) + ' Plan');
        }else{
            labelMap.put(f.getLabel(),f.getLabel());
        }
    }
    query += 'Id,ACP_Account_Plan__c FROM ACP_Revenue_Growth_Perf__c where ACP_Account_Plan__c = \'' + acpId + '\'' ;
    try{
        return Database.query(query);
    }catch(Exception e){
        ErrorLogging.Log(e, 'ACP_RGUpdation_Page_ctrl', 'getRevenueGrowthList',acpId);
        ApexPages.addMessages(e);
        return null;
    }    
}
public List<Schema.FieldSetMember> getRevenueGrowthFields() { 
    List<Schema.FieldSetMember> completeFieldSet = new List<Schema.FieldSetMember>();   
    Map<String, Schema.Fieldset> fieldsetsRevenueMap = Schema.SObjectType.ACP_Revenue_Growth_Perf__c.fieldSets.getMap();
    
    completeFieldSet = fieldsetsRevenueMap.get('ACP_Revenue_Growth_Fieldset').getFields(); 
    completeFieldSet.addAll(fieldsetsRevenueMap.get('ACP_Revenue_Growth_Updation').getFields());
    
    return completeFieldSet;
}
public PageReference saveGrowthRevenue(){
    PageReference pageref;    
    try{        
        upsert revenueGrowthList;
        // pageref.getParameters().put('acpId', acpId);
        pageRef= new PageReference('/apex/ACP_Performance_Analytics_page?acpId='+ acpId+'#businessPerf'); 
    pageref.setRedirect(true);
    return pageref;
    }catch (Exception e) {
        ErrorLogging.Log(e,'ACP_RGUpdation_Page_ctrl', 'saveGrowthRevenue',acpId);
        ApexPages.addMessages(e);
        return null;
    }  
   
}

public pagereference masterPageRedirection(){
    PageReference pageref = new PageReference('/apex/ACP_View_Customer_Page');
    pageref.getParameters().put('acpId', acpId);
    pageref.setRedirect(true);
    return pageref;
}

}