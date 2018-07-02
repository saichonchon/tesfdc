/**************************************************************************************************************************************************
Name: OpportunityBU 
Copyright © 2011 TE Connectivity | Salesforce Instance : BU Org
===================================================================================================================================================
Purpose: This trigger populate user information (BU Owner Name, BU Owner Email, BU Owner Phone) and Source BU in the Opportunity custom fields.                                                  
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
VERSION AUTHOR                DATE       DETAIL                                            Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Rahul Gharat          10/25/2011 Initial Development - SF2SF                       1453487 
    1.1 Umasankar Subbaian    12/06/2011 Make opportunity can be created with account      1453487 
    1.2 Sandeep yadav         07/26/2013 Removed "OpptyUtil.getUserMap(vLstOppty);" from
                                         the "if(set_opp.size() > 0){" condition
                                         and added it outside the IF condition
                                         REASON - Owners data should be populated everytime
                                         irrespective of Owner is getting changed or not
**************************************************************************************************************************************************/
trigger OpportunityBU on Opportunity(before update) {
    
    if (!ExecuteOnce.SF2SF_OPPORTUNITY){
        /*-- 1 Collection variable declaration --------------------------------------*/  
        List<Opportunity > vLstOppty;
        List<Opportunity > inPNRC;
        List<Opportunity > notinPNRC;       
        vLstOppty = trigger.new; // Use this variable for future coding   
        inPNRC    = new List<Opportunity>();
        notinPNRC = new List<Opportunity>();
        set<Id> set_opp = new set<Id>();
        
        for(Opportunity oppy : trigger.new){
            if(oppy.OwnerId != trigger.oldMap.get(oppy.Id).OwnerId){
                set_opp.add(oppy.Id);
            }
        }
        
        if(set_opp.size() > 0){
            // Get the list of Opportunity which are already shared with the central org
            // by calling inPNRC method    
            inPNRC = OpptyUtil.inPNRC(Trigger.newmap.keySet(),trigger.new).get('inPNR');
            System.debug('in PNRC size : ' + inPNRC);
        
            // Similary get list of Opportunity which are not in central org   
            notinPNRC = OpptyUtil.inPNRC(Trigger.newmap.keySet(),trigger.new).get('NotinPNRC');
            System.debug('Not in PNRC size' + notinPNRC);
        
            // not in PNRC precessing...
        
            List<Opportunity> ParentedUnrestrictedOpportunitys =  new List<Opportunity >();
            List<Opportunity> ParentedrestrictedOpportunitys =  new List<Opportunity >(); 
      
           
            // Get list of ParentedUnrestrictedOpportunitys 
            ParentedUnrestrictedOpportunitys = OpptyUtil.getParentedUnrestrictedOpportunities(notinPNRC);
         
            // Make Opportunity restricted if new Parent is restricted  
            if (ParentedUnrestrictedOpportunitys != null){ 
                ParentedrestrictedOpportunitys = OpptyUtil.IsParentRestricted(ParentedUnrestrictedOpportunitys,true );
                if(ParentedrestrictedOpportunitys !=null){
                    OpptyUtil.Makechildrestricted(ParentedrestrictedOpportunitys );  
                }
            } // if (ParentedUnrestrictedOpportunitys != null)
      
          
            // To copy User data if Parent is not restricted
            if (ParentedUnrestrictedOpportunitys !=null) {
                OpptyUtil.getUserMap(OpptyUtil.IsParentRestricted(ParentedUnrestrictedOpportunitys,false)); 
             } // if (ParentedUnrestrictedOpportunitys !=null) 
             
            //....end of not in PNRC processing     
             
            // In PNRC processing >>>>    
         
            // If record is not restricted but Orphan make it restricted
            OpptyUtil.MakeOrphanrestricted(inPNRC);
         
            List<Opportunity > ParentedUnrestrictedOpportunitys_OwnerChk =  new List<Opportunity >();
           
            // to get list of records where parent id not null and Legally Restricted is false
         
            ParentedUnrestrictedOpportunitys_OwnerChk = OpptyUtil.getParentedUnrestrictedOpportunities(inPNRC);
              
            // check for owner change
            // if (ParentedUnrestrictedOpportunitys_OwnerChk != null) 
             
            
            //OpptyUtil.getUserMap(vLstOppty);
        }
        //Sandeep - added the below "Source BU" related mapping outside the "if(set_opp.size() > 0){" condition
        OpptyUtil.getUserMap(vLstOppty);
        
        // if (ParentedUnrestrictedOpportunitys_OwnerChk != null)         
    } // if (!ExecuteOnce.SF2SF_OPPORTUNITY)
 
 /*----------------------------------------------------------------------------------------------------------------------------------------------*/
 
} // End of trigger OpportunityBU on Opportunity(before update)