/**********************************************************************************************************************************************
*******
Name: Route_NDR_Opportunity   
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This class is called by OpportunityBIU_NDROpportunity_Routing trigger on Opportunity object.
This class route the NDR Opportunity to respective DMM based upon DMM email address.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE       DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   04/22/2013    Class 
 1.1   Mrunal Parate        07/27/2015    Modified 
 1.2   Mrunal Parate       11/05/2015    For NDR Phase II Enhancement project to Update END and POS Account fields 
 1.3   Mrunal Parate       26/07/2015    For Case 900996
 1.4   Mrunal Parate        25/10/2016    For CCR Project:Make NDR Code generic for CCR. Move NDR record type reference from Apex_Helper_Settings__c to 'Opportunity Record type group' custom setting and create new record for CCR record type  in 'Opportunity record type group' custom setting
***********************************************************************************************************************************************
*****/
public class Route_NDR_Opportunity{
/*------------------ D1 Collaection variable declaration --------------------*/
    public List<Opportunity> vLstNDROppty;
    public List<User> vLstUser;
    public Map<String,User> vMapUserEmailtoUser;
    public Map<String,NDR_Opportunity_Default_Owner__c> vMapRegiontoBUAdminId;
    public Set<Id> vSetAccId;// Added by Mrunal for case 00868340
    public Map<Id,Account> vMapAccIdtoAcc; // Added by Mrunal for case 00868340
    public set<ID> cProfileset;// Added by Mrunal for Case 900996
    /*public set<id> opp=new set<id>(); // Added by Pradeepti for Case 900948
    public map<id,string> opp1=new map<id,string>(); // Added by Pradeepti for Case 900948*/
    private Map<String,String> fldValueMapSap = new Map<String,String>(); // Added by Pradeepti for Case 900948
/*------------------ D2 Object iable declaration ----------------------------*/    
    //public Apex_Helper_Settings__c vNDROppRT;//comment for CCR Project
    public Set<Id> rt_id;// added for CCR Project
    
    public Map<String, NDR_Region_Sales_and_Cust_Region_Mapping__c> nrdValues = NDR_Region_Sales_and_Cust_Region_Mapping__c.getall();  // Added by Pradeepti for Case 900948

/*------------------ M1 Constructor method ----------------------------------*/ 
    public Route_NDR_Opportunity(){
/*------------------ I1 Collection Variable Initialisation ------------------*/    
        vLstUser = new List<User>();
        vMapUserEmailtoUser = new Map<String,User>();
        vLstNDROppty =new List<Opportunity>();
        vSetAccId = new set<Id>();//Added by Mrunal for case 00868340
        vMapAccIdtoAcc = new Map<Id,Account>();// Added by Mrunal for case 00868340
/*------------------ I2 Object Variable Initialisation ----------------------*/    
        //vNDROppRT = Apex_Helper_Settings__c.getInstance('NDR Opportunity');//comment for CCR Project
        // change start by Mrunal for Case 900996
        Apex_Helper_Settings__c chnlProfiles = Apex_Helper_Settings__c.getInstance('Channel profile ids');
        system.debug('result'+chnlProfiles);
        cProfileset = new set<ID>();
        if(chnlProfiles != null && chnlProfiles.value__c != null){
            for (string strProfielID :chnlProfiles.value__c.split(','))
            {
                cProfileset.add(strProfielID);
            }
        }
        // change End by Mrunal for Case 900996
        //Change start for CCR Project
        rt_id = new Set<Id>();
        for (Opportunity_Record_Type_Groups__c rt : Opportunity_Record_Type_Groups__c.getall().values()){
            if(rt.Active__c && rt.Group__c == 'RFQ 2.0 Quotes' && rt.RecordTypeID__c!= null)
                rt_id.add(rt.RecordTypeID__c);
        }

        // Get NDR_Region_Sales_and_Cust_Region_Mapping__c custom setting's all values in fldValueMap. Added by Pradeepti for Changes, case-900948
        for(NDR_Region_Sales_and_Cust_Region_Mapping__c fld: nrdValues.values()){
                if(fld.NDR_END_Customer_Country__c != null){
                    for(string str : fld.NDR_END_Customer_Country__c.split(','))
                        fldValueMapSap.put(str ,fld.NDR_SAP_Region_c__c);
                }
        }    
        // Change end for CCR Project
    }// End of constructor
    
/*------------------ M2 AssignDMMtoNDROpportunity method----------------------*/
/**
**Parameter name : pLstOppty
**Parameter Type : List of opportunity
**/
    public void AssignDMMtoNDROpportunity(List<Opportunity> pLstOppty){
        try{
           
           for(Opportunity vOppty : pLstOppty){
                //Create a list of NDR opportunities only.
                //if(vOppty.recordTypeId == vNDROppRT.Value__c){//Comment for CCR Project
                   vOppty.NDR_END_Customer_Region__c = fldValueMapSap.get(vOppty.NDR_END_Customer_Country__c); // Added by Pradeepti for case 900948
                   if(rt_id.contains(vOppty.recordTypeId)){//Added for CCR Project
                    vLstNDROppty.add(vOppty); 
                    vSetAccId.add(vOppty.AccountId);
                }
            }
            if(vLstNDROppty.size() > 0){
            
                vLstUser = [Select id,email,IsActive from User where IsActive =: true];
                vMapRegiontoBUAdminId = NDR_Opportunity_Default_Owner__c.getAll();
                system.debug('vMapRegiontoBUAdminId '+vMapRegiontoBUAdminId);
                if(vLstUser != null){
                    for(User vUser : vLstUser){
                        //Create a map with key as user emailid and value as user.
                        vMapUserEmailtoUser.put(vUser.email,vUser);
                    } 
                }
                
                // Change Start by Mrunal to create AccId to Account Map for case 00868340
                Id userTEISId = (Id) Apex_Helper_Settings__c.getInstance('TEIS Admin User Id').Value__c;
                if(vSetAccId.size()>0)
                    vMapAccIdtoAcc = new map<id, Account>( [select id, Account_Manager__c,Account_Manager__r.profileId, Channel_Target_Account__c from Account where id in:vSetAccId and Account_Manager__c!= null and Account_Manager__c !=: userTEISId]);
                // Change End by Mrunal
                system.debug(' **vLstNDROppty** '+vLstNDROppty);
                for(Opportunity vNDROppty : vLstNDROppty){
                    
                    

                    if(vMapRegiontoBUAdminId.containskey(vNDROppty.NDR_SAP_Region__c))
                    {
                    vNDROppty.Region_Sales__c =vMapRegiontoBUAdminId.get(vNDROppty.NDR_SAP_Region__c).Region_Sales__c;
                    }
                    // Change Start by Mrunal to check Channel_Target_Account__c field before routing Oppty for case 00868340
                    if(vMapAccIdtoAcc.containsKey(vNDROppty.AccountId) && vMapAccIdtoAcc.get(vNDROppty.AccountId).Channel_Target_Account__c && cProfileset.contains(vMapAccIdtoAcc.get(vNDROppty.AccountId).Account_Manager__r.profileId)){// Added condition of cProfileset by Mrunal for Case 900996
                        //Route opportunity to Account Manger
                       vNDROppty.ownerid = vMapAccIdtoAcc.get(vNDROppty.AccountId).Account_Manager__c;
                    }
                    // Change End by Mrunal
                    else if(vMapUserEmailtoUser.containskey(vNDROppty.NDR_DMM_Email_Address__c)){
                       //Route opportunity to respective DMM
                       vNDROppty.ownerid = vMapUserEmailtoUser.get(vNDROppty.NDR_DMM_Email_Address__c).id;
                    }
                    else{
                       //Route opportunity to default DMM if DMM Email address is null or wrong
                       if(vNDROppty.NDR_SAP_Region__c != null){
                           if(vMapRegiontoBUAdminId.containskey(vNDROppty.NDR_SAP_Region__c)){
                               vNDROppty.ownerid = vMapRegiontoBUAdminId.get(vNDROppty.NDR_SAP_Region__c).BU_Admin_UserId__c;
                           }
                       }
                    }

                  System.debug('*****SAP Region******'+vNDROppty.NDR_SAP_Region__c );  
                }
            }
       }//End of try 
       catch(Exception vEx){
           System.debug('**************Exception In DMM Routing'+vEx);
       } 
    }//End of AssignDMMtoNDROpportunity() method
    
    // Method added by Mrunal for case 00790664 to Update Region_Sales__c field based on Customer_Region__c field of account when NDR SAP Region is 'Region Not Found'
    public void UpdateRegSalesForNDROpportunity(List<Opportunity> opptyLst,Map<Id,Opportunity> oldOpptyMap){
        //Apex_Helper_Settings__c vNDROppRT = Apex_Helper_Settings__c.getInstance('NDR Opportunity');//Comment for CCR Project
        Map<Id,Account> vMapAcc;
        Map<String,String> fldValueMap = new Map<String,String>();
        List<Opportunity> vLstNDROppty = new List<Opportunity>();
        Set<Id> ndrOpptyAccIdSet = new Set<Id>();


        for(Opportunity vOppty : opptyLst){
            //Create a list of NDR opportunities only.
            //if(vOppty.recordTypeId == vNDROppRT.Value__c){//Comment for CCR Project
           // vOppty.NDR_SAP_Region__c = nrdValues.get(vOppty.NDR_END_Customer_Country__c).NDR_SAP_Region_c__c; // Added by Pradeepti for case 900948
             vOppty.NDR_END_Customer_Region__c = fldValueMapSap.get(vOppty.NDR_END_Customer_Country__c); // Added by Pradeepti for case 900948

            if(rt_id.contains(vOppty.recordTypeId)){//Added for CCR Project
                vLstNDROppty.add(vOppty);
                ndrOpptyAccIdSet.add(vOppty.accountId);    
            }
        }
        if(ndrOpptyAccIdSet.size() > 0)
                vMapAcc = new Map<Id,Account>([Select id, Customer_region__c from Account where Id IN :ndrOpptyAccIdSet]);

        // Logic to Update Region Sales field based on customer region field value of account.
        if(vLstNDROppty.size() > 0){      
            List<NDR_Region_Sales_and_Cust_Region_Mapping__c> cusRec = nrdValues.values(); // Added by Pradeepti for case 900948
            
            // Get NDR_Region_Sales_and_Cust_Region_Mapping__c custom setting's all values in fldValueMap.
            for(NDR_Region_Sales_and_Cust_Region_Mapping__c fld: cusRec){
                if(fld.Customer_Region__c != null){
                    for(string str : fld.Customer_Region__c.split(';'))
                        fldValueMap.put(str ,fld.Region_Sales__c);
                }
            }     

                

            for(Opportunity vNDROppty : vLstNDROppty){
                if(oldOpptyMap.get(vNDROppty.id).accountId != vNDROppty.accountId && vNDROppty.NDR_SAP_Region__c== 'Region Not Found'){
                    if(vNDROppty.accountid == null){
                        vNDROppty.Region_Sales__c = 'Region Not Found';
                    }else if(vMapAcc.get(vNDROppty.AccountId).Customer_Region__c != null && fldValueMap.get(vMapAcc.get(vNDROppty.AccountId).Customer_Region__c) != null){
                        vNDROppty.Region_Sales__c = fldValueMap.get(vMapAcc.get(vNDROppty.AccountId).Customer_Region__c);
                    }     
                }
            }
        }
    }
    // Change End by Mrunal for case 00790664
    
    // Change Start: Method added by Mrunal for NDR Phase II Enhancement project to Update END and POS Account fields based on Account selected in Account and POS Account lookup fields respectively.
    public void UpdateENDandPOSAccountFields(List<Opportunity> opptyLst,Map<Id,Opportunity> oldOpptyMap){
        //Apex_Helper_Settings__c vNDROppRT = Apex_Helper_Settings__c.getInstance('NDR Opportunity');//Comment for CCR Project
        Map<Id,Account> vMapAcc;
        //Map<String,String> fldValueMap = new Map<String,String>();
        List<Opportunity> vLstNDROppty = new List<Opportunity>();
        Set<Id> ndrOpptyAccIdSet = new Set<Id>();
        for(Opportunity vOppty : opptyLst){
            //Create a list of NDR opportunities only.
            //if(vOppty.recordTypeId == vNDROppRT.Value__c){//Comment for CCR Project
            if(rt_id.contains(vOppty.recordTypeId)){//Added for CCR Project
                vLstNDROppty.add(vOppty);
                if(vOppty.accountId!= null)
                    ndrOpptyAccIdSet.add(vOppty.accountId);  
                if(vOppty.POS_Account__c!= null)
                    ndrOpptyAccIdSet.add(vOppty.POS_Account__c);    
            }
        }
        if(ndrOpptyAccIdSet.size() > 0)
                vMapAcc = new Map<Id,Account>([Select id, Name, AccountNumber, BillingStreet, BillingCity, Billing_Region__c, BillingCountry, BillingPostalCode from Account where Id IN :ndrOpptyAccIdSet]);

        // Logic to Update END Customer section fields of Oppty based on Updated Account.
        if(vLstNDROppty.size() > 0){      
           system.debug('oldOpptyMap' +oldOpptyMap);    
            for(Opportunity vNDROppty : vLstNDROppty){
               
                  if(oldOpptyMap.get(vNDROppty.id).accountId != vNDROppty.accountId && vNDROppty.accountid != null && !vMapAcc.get(vNDROppty.AccountId).Name.contains('Unidentified')){
                    vNDROppty.End_Customer_Name__c = vMapAcc.get(vNDROppty.AccountId).Name;
                    string eAccNo = String.valueof(vMapAcc.get(vNDROppty.AccountId).AccountNumber);
                    if(eAccNo != null) vNDROppty.NDR_END_Customer_Account_Number__c = eAccNo.substring(eAccNo.Length()-8,eAccNo.length());
                    else vNDROppty.NDR_END_Customer_Account_Number__c = null;
                    vNDROppty.NDR_END_Customer_Street__c = vMapAcc.get(vNDROppty.AccountId).BillingStreet;
                    vNDROppty.NDR_END_Customer_City__c = vMapAcc.get(vNDROppty.AccountId).BillingCity;
                    vNDROppty.NDR_END_Customer_Region__c = null;
                    vNDROppty.NDR_END_Customer_Country__c = vMapAcc.get(vNDROppty.AccountId).BillingCountry;
                    vNDROppty.NDR_END_Customer_Zip_Code__c = vMapAcc.get(vNDROppty.AccountId).BillingPostalCode;
                } 
                if(oldOpptyMap.get(vNDROppty.id).POS_Account__c != vNDROppty.POS_Account__c && vNDROppty.POS_Account__c != null && !vMapAcc.get(vNDROppty.POS_Account__c).Name.contains('Unidentified')){
                    vNDROppty.NDR_POS_Customer_Name__c = vMapAcc.get(vNDROppty.POS_Account__c).Name;
                    string pAccNo = String.valueof(vMapAcc.get(vNDROppty.POS_Account__c).AccountNumber);
                    if(pAccNo != null) vNDROppty.NDR_POS_Customer_Account_Number__c = pAccNo.substring(pAccNo.Length()-8,pAccNo.length());
                    else vNDROppty.NDR_POS_Customer_Account_Number__c = null;
                    vNDROppty.NDR_POS_Customer_Street__c = vMapAcc.get(vNDROppty.POS_Account__c).BillingStreet;
                    vNDROppty.NDR_POS_Customer_City__c = vMapAcc.get(vNDROppty.POS_Account__c).BillingCity;
                    vNDROppty.NDR_POS_Customer_Region__c = null;
                    vNDROppty.NDR_POS_Customer_Country__c = vMapAcc.get(vNDROppty.POS_Account__c).BillingCountry;
                    vNDROppty.NDR_POS_Customer_Zip_Code__c = vMapAcc.get(vNDROppty.POS_Account__c).BillingPostalCode;
                }    
            }
        }
      
    
    // Change End by Mrunal for NDR Phase II Enhancement project.


     // Changes added by Pradeepti for case-900948, Logic to Update customer region of Oppturnity based on END Customer country 
       
     /*  for(opportunity op:opptyLst ){
       if(op.NDR_END_Customer_Country__c<>null){
          opp1.put(op.accountId,op.NDR_END_Customer_Country__c);
          opp.add(op.accountId); 
     
        } 
    }
       List<account> aclist=new list<account>();
       for(account ac:[select id, billingcountry from account where id in :opp1.keyset()]){
          ac.billingcountry=opp1.get(ac.id);
          aclist.add(ac);
          
    }
      // if(aclist.size()>0)
        // update aclist; Added by Pradeepti for case 900948
    }*/
    }
}