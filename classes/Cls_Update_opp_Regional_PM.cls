/***********************************************************************************************************************
      Name : Cls_Update_opp_Regional_PM
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : This class is using for updating the Regional_pm value on opportunity and using on "OPP_Region_pm_Update" 
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Ravi    11/11/2013  Initial Development         R-1316
***********************************************************************************************************************/

Public class Cls_Update_opp_Regional_PM
{
     public static void Update_Regional_pm(List<Opportunity_Part__c>PartList)
    {
        map<id,id> mapopp_prod=new map<id,id>();
        set<id> oppownids=new set<id>();
        list<Opportunity> lstopps=new list<Opportunity>();
        list<Opportunity> updatelstopps=new list<Opportunity>();

    if(!PartList.isEmpty()){
        for(Opportunity_part__c part:PartList){
        //Modified By Nooreen to avoid the null exceptions
            if(part.GPL__c!=null){
                mapopp_prod.put(part.Opportunity__c,part.GPL__c);                
            }            
        }
    }

    map<Id,Product_Hierarchy__c> mapprodfield=new map<Id,Product_Hierarchy__c>([select id,Regional_PM_AP__c,Regional_PM_US__c,Regional_PM_EU__c from Product_Hierarchy__c where Id in:mapopp_prod.values()]);  
    
    for(Opportunity opp:[select id,ownerid,Regional_PM__c,owner.Region__c from Opportunity where id in:mapopp_prod.keyset()]){
        //Modified By Chiranjeevi, to avoid the null point exceptions
        //Added condition "mapopp_prod.ContainsKey(opp.id)" on 23-03-2014        
        if(!mapprodfield.isempty() && mapopp_prod.ContainsKey(opp.id)){
            Product_Hierarchy__c ph= mapprodfield.get(mapopp_prod.get(opp.id));  
            //Modified By Nooreen to avoid the null exceptions         
            if(ph.Regional_PM_AP__c!=null || ph.Regional_PM_EU__c!=null || ph.Regional_PM_US__c!=null){
                if(opp.owner.Region__c=='Asia Pacific' || opp.owner.Region__c=='Japan' || opp.owner.Region__c=='China'){
                    opp.Regional_PM__c=mapprodfield.get(mapopp_prod.get(opp.id)).Regional_PM_AP__c;}
                if(opp.owner.Region__c=='EMEA'){
                    opp.Regional_PM__c=mapprodfield.get(mapopp_prod.get(opp.id)).Regional_PM_EU__c;}
                if(opp.owner.Region__c=='Americas' || opp.owner.Region__c =='Others'){
                    opp.Regional_PM__c=mapprodfield.get(mapopp_prod.get(opp.id)).Regional_PM_US__c;}
                updatelstopps.add(opp);               
            }            
        }    
    }
         if(!updatelstopps.isEmpty()){
            //changed by BYU based on the requirement https://c2s.my.salesforce.com/a0kE0000004hPpT
             try{
                update updatelstopps;
             }
             catch(Exception ex){
                 System.debug('***Exception***'+ex); 
                 //ApexPages.addMessages(ex);
                   
             }
         }
    } 

    public static void Update_Regional_pm_del(List<Opportunity_Part__c>PartList_del) {
        set<id> oppids=new set<id>();
        list<Opportunity> updatelstopps=new list<Opportunity>();
         
        for(Opportunity_part__c part:PartList_del)
        {
            if(!PartList_del.isEmpty())
            oppids.add(part.Opportunity__c);
        }
        
        for(Opportunity opp:[select id,ownerid,Regional_PM__c,Opportunity_Part_Count__c from Opportunity where id in:oppids])
        {
            if(opp.Opportunity_Part_Count__c==1){
                opp.Regional_PM__c=null;
                updatelstopps.add(opp);
            }            
        }
         if(!updatelstopps.isEmpty()){
            //changed by BYU based on the requirement https://c2s.my.salesforce.com/a0kE0000004hPpT
             try{
                update updatelstopps;
             }
             catch(Exception ex){
                 System.debug('***Exception***'+ex); 
                 //ApexPages.addMessages(ex);  
             }
         }
    }                

}