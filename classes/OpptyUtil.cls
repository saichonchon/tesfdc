/**************************************************************************************************************************************************
Name: OpptyUtil 
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This is the utility class for Opportunity based business process methods and technical process methods
---------------------------------------------------------------------------------------------------------------------------------------------------
Classed Called  : 
---------------------------------------------------------------------------------------------------------------------------------------------------
Related Trigger : OpportunityAI, OpportunityBI, OpportunityAU, OpportunityBU                                                
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR              DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Umasankar Subbaian  10/31/2011 Initial Development                               1453487    
    1.1 Sandeep Yadav       7/24/2013  Source BU change related to 
                                       Case # 00438548
**************************************************************************************************************************************************/
public class OpptyUtil {
     /*------------------------------------------------------------------------------------------------------------------------------------------------
     |    Purpose : Filter Opportunity records based on the flag isRestricted                                                                         |
     | Parameters : List of Opportunity records                                                                                                       |
     |    Returns : List of Opportunity records                                                                                                       |
     ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
     public static List<Opportunity> IsParentRestricted (List<Opportunity> pLstOppty, boolean isRestricted){
        List<Opportunity> ParentRestrictedpLstOppty   = new List<Opportunity>();
        List<Opportunity> NOtParentRestrictedpLstOppty= new List<Opportunity>();
        
        Set<Id> AccId=new Set<Id>();
        For(Opportunity c :pLstOppty){ 
            AccId.add(c.AccountId);
        }
      
        Map<ID,Account> Accmap= new Map<ID,Account>([SELECT ID, Name, Legally_Restricted__c from Account where ID IN :AccId]) ;
    
        For(Opportunity con :pLstOppty){ 
            Account TempAcc = Accmap.get(con.AccountId);
            
            if(TempAcc !=null){      
                If (TempAcc.Legally_Restricted__c ==True) {
                    ParentRestrictedpLstOppty.add(con);
                }
                else{
                    NOtParentRestrictedpLstOppty.add(con);
        
                }
            }  
        }
        
        if(isRestricted==true){
            Return ParentRestrictedpLstOppty;
        }
        else
            Return NOtParentRestrictedpLstOppty;
          // Processing if Parent is not restrcted : Do nothing as Owner info is already populated.
          
     }

     public static map<String, List<Opportunity>> IsParentRestricted (List<Opportunity> pLstOppty){
        map<String, List<Opportunity>> map_tmp = new map<String, List<Opportunity>>();
        map_tmp.put('restricted', new List<Opportunity>());
        map_tmp.put('notRestricted', new List<Opportunity>());
        
        Set<Id> set_accIds = new Set<Id>();
        For(Opportunity o :pLstOppty){ 
            if(o.AccountId != null) set_accIds.add(o.AccountId);
        }
        if(set_accIds.size() > 0){
            Map<ID,Account> Accmap = new Map<ID,Account>([SELECT ID, Name, Legally_Restricted__c from Account where ID IN :set_accIds]) ;
        
            For(Opportunity opp :pLstOppty){     
                if(Accmap.containsKey(opp.AccountId)){  
                    Account TempAcc = Accmap.get(opp.AccountId);    
                    If (TempAcc.Legally_Restricted__c ==True) {
                        map_tmp.get('restricted').add(opp);
                    }
                    else{
                        map_tmp.get('notRestricted').add(opp);
                    }
                }  
            }       
        }
        
        return map_tmp;
     }     
      //Processing if Parent is Restricted
      
     /*------------------------------------------------------------------------------------------------------------------------------------------------
     |    Purpose : Make opportunity records as legally restricted as the cascaded effect                                                             |
     | Parameters : List of Opportunity records                                                                                                       |
     |    Returns : None                                                                                                                              |
     ------------------------------------------------------------------------------------------------------------------------------------------------*/   
      public static void Makechildrestricted (List<Opportunity> pLstOppty)
      {   
            For(Opportunity vOppty :pLstOppty)
                { 
                 vOppty.Legally_Restricted__c=True;                
                }          
            
         }
         
     /*------------------------------------------------------------------------------------------------------------------------------------------------
     |    Purpose : Make orphaned opportunity records as legally restricted                                                                           |
     | Parameters : List of Opportunity records                                                                                                       |
     |    Returns : None                                                                                                                              |
     ------------------------------------------------------------------------------------------------------------------------------------------------*/      
  public static void MakeOrphanrestricted (List<Opportunity> pLstOppty)
     {   
        For(Opportunity vOppty :pLstOppty)
            { 
                 if(vOppty.AccountId == null)
                 { 
                 vOppty.Legally_Restricted__c=True;                
                }
            }
        
     }
     
  
     /*------------------------------------------------------------------------------------------------------------------------------------------------
     |    Purpose : Share Opportunities with central org by creating rows in PNRC                                                                     |
     | Parameters : List of Opportunity records                                                                                                       |
     |    Returns : None                                                                                                                              |
     ------------------------------------------------------------------------------------------------------------------------------------------------*/      
    public static void Insert_PNRC (List<Opportunity> pLstOppty) {
        
        List<PartnerNetworkRecordConnection> partnerNetworkRecordList = new List<PartnerNetworkRecordConnection>();
         // Fetching the PartnerNetworkConnection Id from the Custom settings   
        String conId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
        
        for(Opportunity vOppty :pLstOppty){           
            partnerNetworkRecordList.add(SF2SFUtil.newPNRC(conId, vOppty.id, vOppty.AccountId)); // Calling newPNRC method inside Sharing util class
        }
        //Start Auto sharing
        if (partnerNetworkRecordList.size() > 0){
            insert partnerNetworkRecordList;
        }  
    } 
        
           
     /*------------------------------------------------------------------------------------------------------------------------------------------------
     |    Purpose : To get list of Account which are in PNRC                                                                                          |
     | Parameters : Set of Opportunity Id s, List of Opportunities, Flag to Fetch which are in PNRC or not in PNRC                                    |
     |    Returns : List of Opportunity records                                                                                                       |
     ------------------------------------------------------------------------------------------------------------------------------------------------*/  
     public static List<Opportunity> inPNRC (Set<Id> pLstOppty, List<Opportunity> pLstOpptyNew, boolean Flag) {
        Set<Id> inPNRCId= new Set<Id>(); 
        List<Opportunity> NotinPNRC = new List<Opportunity>();       
        List<Opportunity> inPNRC = new List<Opportunity> ();        
        String conId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
        
        for (PartnerNetworkRecordConnection OpptySharingRecord : [SELECT p.Status, p.LocalRecordId, p.ConnectionId FROM PartnerNetworkRecordConnection p WHERE p.LocalRecordId IN :pLstOppty]) {
            // List for inPnrc
            if ( !(OpptySharingRecord.status.equalsignorecase('Deleted') || OpptySharingRecord.status.equalsignorecase('Inactive'))) {                                          
                inPNRCId.add(OpptySharingRecord.LocalRecordId);
            }                                                                                 
        }
                   
        for(Opportunity a: pLstOpptyNew){
            if(inPNRCId.contains(a.id))
                inPNRC.add(a);
            else
                NotinPNRC.add(a);
        }
                     
        
        if(Flag==True)
            Return inPNRC;
        else
            Return NotinPNRC;
    }    
     
     public static map<String, list<Opportunity>> inPNRC (Set<Id> pLstOppty, List<Opportunity> pLstOpptyNew) {
        Set<Id> inPNRCId= new Set<Id>(); 
        List<Opportunity> NotinPNRC = new List<Opportunity>();       
        List<Opportunity> inPNRC = new List<Opportunity> ();        
        String conId  = TE_Connection__c.getInstance('CentralOrg').Id_value__c;
        map<String, list<Opportunity>> map_tmp = new map<String, list<Opportunity>>();
        map_tmp.put('inPNR', new list<Opportunity>());
        map_tmp.put('NotinPNRC', new list<Opportunity>());
        for (PartnerNetworkRecordConnection OpptySharingRecord : [SELECT p.Status, p.LocalRecordId, p.ConnectionId FROM PartnerNetworkRecordConnection p WHERE p.LocalRecordId IN :pLstOppty]) {
            // List for inPnrc
            if ( !(OpptySharingRecord.status.equalsignorecase('Deleted') || OpptySharingRecord.status.equalsignorecase('Inactive'))) {                                          
                inPNRCId.add(OpptySharingRecord.LocalRecordId);
            }                                                                                 
        }
                   
        for(Opportunity a: pLstOpptyNew){
            if(inPNRCId.contains(a.id))
                map_tmp.get('inPNR').add(a);
            else
                map_tmp.get('NotinPNRC').add(a);
        }
        return map_tmp;
    } 
     /*------------------------------------------------------------------------------------------------------------------------------------------------
     |    Purpose : To Populate User information in Opportunity Records                                                                               |
     | Parameters : List of Opportunity records                                                                                                       |
     |    Returns : List of Opportunity records                                                                                                       |
     ------------------------------------------------------------------------------------------------------------------------------------------------*/  
    public static void getUserMap(List<Opportunity> pLstOppty){
        //String strSourceBu  = TE_Connection__c.getInstance('CentralOrg').Source_BU__c;
        Set<Id> UserId = new Set<Id>();
        For(Opportunity a :pLstOppty){ 
            UserId.add(a.OwnerId);
        }
  
        Map<ID,User> Usermap= new Map<ID,User>([SELECT ID, Name, Email, Phone, GIBU__c from User where ID IN :UserId]) ;
            
        For(Opportunity opp:pLstOppty){ 
            User thisUser = UserMap.get(opp.OwnerId);
            If (thisUser != null) {

                opp.BU_Owner_Email__c=thisUser.Email;
                
                opp.BU_Owner_Name__c=thisUser.Name;
                
                opp.BU_Owner_Phone__c=thisUser.Phone ;
        
                //Opportunity Source BU been retrieved from Owner’s user record [Case # 00438548]
                opp.Source_BU__c   = thisUser.GIBU__c;
                
                //opp.Source_BU__c = strSourceBu;
                
            }// end of If (thisUser != null)
           
        }// end of for loop Opp
          
     }    
     
     /*------------------------------------------------------------------------------------------------------------------------------------------------
     |    Purpose : Filter and get the Opportunities where parent id not null and Legally Restricted is false                                         |
     | Parameters : List of Opportunity records                                                                                                       |
     |    Returns : List of Opportunity records                                                                                                       |
     ------------------------------------------------------------------------------------------------------------------------------------------------*/ 
     public static List<Opportunity> getParentedUnrestrictedOpportunities(List<Opportunity> pLstOppty){
        /*-- 1.0 Collection variable declaration --------------------------------------*/
        List<Opportunity> vLstOppty;
        if (pLstOppty.size() > 0){
            vLstOppty = new List<Opportunity>();
            for (Opportunity vOppty: pLstOppty){   
                if((vOppty.AccountId != null) && (vOppty.Legally_Restricted__c == false)){
                    vLstOppty.add(vOppty);
                } // if ((vOppty.ParentId != null) && (vOppty.Legally_Restricted__c == false))
            } // for (Opportunity vOppty: pLstOppty)
        } // if (pLstOppty.size() > 0)

  
        return vLstOppty;   
    } // public static List<Opportunity> getParentedUnrestrictedOpportunities

    /*-----------------------------------------------------------------------------------------------------------------------------------------------*/ 
 
} // End of OpptyUtil