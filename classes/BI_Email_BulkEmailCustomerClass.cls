/**********************************************************************************************************************************************
*******
Name: BI_Email_BulkEmailCustomerClass
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose:This class calling from BI_Email_BulkEmailCustomer trigger for Bulk Email duplicate subjects
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Narasimha Rao Narra    3/4/2014      Class
 
***********************************************************************************************************************************************
*****/
Public class BI_Email_BulkEmailCustomerClass
{
    public static void controlingDuplicateEmails(list<EmailMessage> newLstEms)
    {
        try{
        Map<String,BulkEmailCustomer__c> vMapNametoApexHlprSetting = BulkEmailCustomer__c.getAll();
        map<string,List<Integer>> map_EmListOrder = new map<string,List<Integer>>();
        set<string> toadds=new set<string>();
        for(BulkEmailCustomer__c be:vMapNametoApexHlprSetting.values())
        {
            toadds.add(be.TO__c);
        }
        
        List<EmailMessage> existemlist=[select Id,ParentId,subject,FromAddress,Toaddress from EmailMessage where
                                   Fromaddress in:vMapNametoApexHlprSetting .keySet() AND messagedate >:(System.now().addminutes(-5))
                                   AND Toaddress in: toadds AND subject like '%(@%)'];
                           
        if(existemlist.isEmpty())
        {                           
            Integer i=1;
            for(EmailMessage em:newLstEms)
            {
                if(vMapNametoApexHlprSetting.containsKey(em.fromaddress))
                {
                    if(em.subject!=null && em.subject.contains(vMapNametoApexHlprSetting.get(em.fromaddress).Subject__c) && 
                    em.toaddress==vMapNametoApexHlprSetting.get(em.fromaddress).To__c)
                    {
                        em.subject=em.subject+'(@'+string.valueOf(i)+')';
                        i++;
                    }
                                       
                       
                    
                }
            }
        }
        else
        {
            for(EmailMessage em:existemlist)
            {
                if(em.subject.contains(vMapNametoApexHlprSetting.get(em.fromaddress).Subject__c) && 
                em.toaddress==vMapNametoApexHlprSetting.get(em.fromaddress).To__c){
                    system.debug('-----------sub'+em.subject);
                    integer a=em.subject.lastIndexOf('(@')+2;
                    integer b=em.subject.lastIndexOf(')');
                    
                    Integer count=Integer.valueOf(em.subject.substring(a,b));
                    if(!map_EmListOrder.containsKey(em.fromaddress)){
                        map_EmListOrder.put(em.fromaddress,new List<Integer>{count});
                    }
                    else{
                        map_EmListOrder.get(em.fromaddress).add(count); 
                    }
                }     
            }   
            Integer temp=0;
            for(EmailMessage em:newLstEms)
            {
                system.debug('-----------sub');
                if(vMapNametoApexHlprSetting.containsKey(em.fromaddress)){
                    if(em.subject!=null&&em.subject.contains(vMapNametoApexHlprSetting.get(em.fromaddress).Subject__c) && 
                    em.toaddress==vMapNametoApexHlprSetting.get(em.fromaddress).To__c){
                       if(map_EmListOrder.containsKey(em.fromaddress )){
                           if(temp==0){
                               List<integer> orderLst=map_EmListOrder.get(em.fromaddress);
                               orderLst.sort();
                               system.debug('-----sub'+(orderLst.size()-1));
                               integer highValue=orderLst[orderLst.size()-1]+1;
                               temp=highValue;
                           }
                           em.subject=em.subject+'(@'+string.valueOf(temp)+')';
                           temp++;
                       }
                    }
                }    
            }
        }
    }
    catch(Exception e){
       CCP_Exception_Util.CCP_Exception_Mail(e);
   }
   }
    
}