Public Class ACustomerTrigger{
    
    Public Static Void BUlookupfromACTrigger(A_Customer_Profile__c[] oldACust,A_Customer_Profile__c[] newACust){
        List<String> PlanYear = new List<String>();
        List<String> BUnit = new List<String>();
        List<BU_Customer_Plan__c> BUPlanList = new List<BU_Customer_Plan__c>(); 
        Map<String,BU_Customer_Plan__c> BUPlanMap = new Map<String,BU_Customer_Plan__c>();
        
        if(oldACust == null){
            for(A_Customer_Profile__c AC : newACust){
                PlanYear.add(AC.Plan_Year__c);
                BUnit.add(AC.Business_Unit__c);
            }
        } 
        else{
            for(integer i=0; i<newACust.size(); i++){
                //the following if is commented out so that PlanYear and BUnit are populated for all updates, not just change in BU or Year
                //so that the Editor field is updated everytime the ACustomer is saved.
                //if(oldACust[i].Plan_Year__c != newACust[i].Plan_Year__c || oldACust[i].Business_Unit__c != newACust[i].Business_Unit__c){
                    PlanYear.add(newACust[i].Plan_Year__c);
                    BUnit.add(newACust[i].Business_Unit__c);   
                    system.debug('Jill'+newACust[i].Plan_Year__c+newACust[i].Business_Unit__c);   
                //}
            }
        }
        
        if(PlanYear.size()>0 && BUnit.size()>0){
            BUPlanList = [Select id, Business_Unit__c, Plan_Year__c, Editor__c from BU_Customer_Plan__c b Where b.Plan_Year__c In :PlanYear and b.Business_Unit__c In :BUnit];        
        System.Debug('Uma : ' + BUPlanList );
            for(BU_Customer_Plan__c BU : BUPlanList){
                String Key = BU.Plan_Year__c + BU.Business_Unit__c;        
                BUPlanMap.put(key,BU);
            }
            
            for(integer i=0; i<newAcust.size(); i++){
                BU_Customer_Plan__c GetBUPlan =  new BU_Customer_Plan__c();
                String Key = newACust[i].Plan_Year__c + newACust[i].Business_Unit__c; 
                           
                if(BUPlanMap.Containskey(Key)){
                    GetBUPlan = BUPlanMap.get(Key);                                         
                    system.debug('Jilltest1' + newACust[i].id);
                    newACust[i].BU_Customer_Plan__c = GetBUPlan.id;
                    newACust[i].BU_Editor__c        = GetBUPlan.Editor__c;
                    system.debug('Jilltest2' +GetBUPlan.Editor__c);
                }
                else 
                {
                    system.debug('Jilltest3 - hit else condition');
                    newACust[i].BU_Customer_Plan__c = null;
                    newACust[i].BU_Editor__c        = null;
                 }   
            }
        }
    }
    
    Public Static Void BULookupFromBUTrigger(BU_Customer_Plan__c[] oldBUPlan,BU_Customer_Plan__c[] newBUPlan){
        List<BU_Customer_Plan__c> BUPlans = new List<BU_Customer_Plan__c>();
        List<Id> ChangedBUId = new List<Id>();
        List<A_Customer_Profile__c> oldACProfileList = new List<A_Customer_Profile__c>();
        List<A_Customer_Profile__c> newACProfileList = new List<A_Customer_Profile__c>();
        List<String> newPlanYear = new List<String>();
        List<String> newBUnit = new List<String>();
        Map<String,BU_Customer_Plan__c> BUMap = new Map<String,BU_Customer_Plan__c>();
    
        if(oldBUPlan == null){
            for(integer i=0; i<newBUPlan.size(); i++){
                    BUPlans.add(newBUPlan[i]);           
                    newPlanYear.add(newBUPlan[i].Plan_Year__c);
                    newBUnit.add(newBUPlan[i].Business_Unit__c);
            }
        }        
        else{
            for(integer i=0; i<newBUPlan.size(); i++){
                if(oldBUPlan[i].Plan_Year__c != newBUPlan[i].Plan_Year__c || oldBUPlan[i].Business_Unit__c != newBUPlan[i].Business_Unit__c){
                    BUPlans.add(newBUPlan[i]);
                    ChangedBUId.add(oldBUPlan[i].id);
                    newPlanYear.add(newBUPlan[i].Plan_Year__c);
                    newBUnit.add(newBUPlan[i].Business_Unit__c);
                }
            }
            
            for(A_Customer_Profile__c AC : [Select BU_Customer_Plan__c From A_Customer_Profile__c Where BU_Customer_Plan__c In :ChangedBuId]){
                AC.BU_Customer_Plan__c = null;
                oldACProfileList.add(AC);
            }
            update oldACProfileList;
        }
                      
        if(!BUPlans.isEmpty()){
            for(BU_Customer_Plan__c BU : BUPlans){
                String Key = BU.Plan_Year__c;
                Key+= BU.Business_Unit__c;
                BUMap.put(Key,BU); 
            }
            
            for(A_Customer_Profile__c AC : [Select Plan_Year__c, Business_Unit__c From A_Customer_Profile__c Where Plan_Year__c In : newPlanYear and Business_Unit__c In : newBUnit]){
                String Key = AC.Plan_Year__c;
                Key+= AC.Business_Unit__c;
                if(BUMap.Containskey(key)){
                    AC.BU_Customer_Plan__c = BUMap.get(Key).id;
                    newACProfileList.add(AC);                
                }
            }
            update newACProfileList; 
        }   
    }  
    
  /*  Public Static Void RemoveOldBULookup(BU_Customer_Plan__c[] oldBUPlan){
        List<Id> BUId = new List<Id>();
        List<A_customer_Profile__c> OldAcust = new List<A_customer_Profile__c>();
        List<A_customer_Profile__c> updateAcust = new List<A_customer_Profile__c>();        
        
        if(oldBUPlan != null){
        for(BU_Customer_Plan__c BU: oldBUPlan){            
            BUId.add(BU.id);
        }
        OldAcust = [Select Id, BU_Customer_Plan__c from A_customer_Profile__c a Where a.BU_Customer_Plan__c In :BUId];}
        
        if(OldACust.size() != null){
        for(A_customer_Profile__c AC : OldAcust){
            AC.BU_Customer_Plan__c = null;
            updateACust.add(AC);
        }
            update updateACust;}      
    } */
    
    Public Static Void AddBrianCozzensAsReadOnlyUsertoACProfile(A_Customer_Profile__c[] newAcust){
        List<A_Customer_Profile__share> ACShareList = new List<A_Customer_Profile__share>();
    
        User BC = [Select id from User u where u.FirstName Like 'Maic' and u.LastName Like 'Stohr' Limit 1];
        
        for(A_customer_Profile__c AC : newACust){
            A_Customer_Profile__share ACShare = new A_Customer_Profile__share();
            ACShare.ParentId = AC.Id;
            ACShare.UserorGroupId = BC.id;
            ACShare.RowCause = 'Manual';
            ACShare.AccessLevel = 'Read';
            ACShareList.add(ACShare);   
        }
        
        if(!ACShareList.isEmpty())
        upsert ACShareList;
    }
    
    Public Static Void AddBrianCozzensAsReadOnlyUsertoBUPlan(BU_Customer_Plan__c[] newBUPlan){
        List<BU_Customer_Plan__share> BUShareList = new List<BU_Customer_Plan__share>();
    
        User BC = [Select id from User u where u.FirstName Like 'Maic' and u.LastName Like 'Stohr' Limit 1];
        
        for(BU_Customer_Plan__c BU : newBUPlan){
            BU_Customer_Plan__share BUShare = new BU_Customer_Plan__share();
            BUShare.ParentId = BU.Id;
            BUShare.UserorGroupId = BC.id;
            BUShare.RowCause = 'Manual';
            BUShare.AccessLevel = 'Read';
            BUShareList.add(BUShare);   
        }
        
        if(!BUShareList.isEmpty())
        upsert BUShareList;
    }
    
    Public Static Void AddBUPlanSharingUserstoACustSharing(A_Customer_Profile__c[] newACust){
        List<Id> BUIdList = new List<Id>();
        List<Id> ACIdList = new List<Id>();
        List<BU_Customer_Plan__share> BUShareList = new List<BU_Customer_Plan__share>();
        Map<Id,List<BU_Customer_Plan__share>> BUShareMap = new Map<Id,List<BU_Customer_Plan__share>>();
        Map<String,A_Customer_Profile__share> ACShareMAp = new Map<String,A_Customer_Profile__share>();
        List<A_Customer_Profile__share> ACshareList = new List<A_Customer_Profile__share>();
        
        for(A_Customer_Profile__c AC : newACust){
            BUIdList.add(AC.BU_Customer_Plan__c);
            ACIdList.add(AC.Id);
        }
        
        BUShareList = [Select ParentId, UserorGroupId, RowCause, AccessLevel From BU_Customer_Plan__share Where ParentId In : BUIdList];
        
        for(Id bid : BUIdList){
            List<BU_Customer_Plan__share> tempBUShareList = new List<BU_Customer_Plan__share>();
            for(BU_Customer_Plan__share BS : BUShareList){
                if(bid == BS.ParentId){
                    tempBUShareList.add(BS);
                }
            }
            BUShareMap.put(bid,tempBUShareList);
            system.debug(BUShareMap+'BUShareMap');
        } 

        for(A_Customer_Profile__share ASH : [Select ParentId, UserorGroupId, RowCause,AccessLevel From A_Customer_Profile__share Where ParentId In : ACIdList]){
                String Key = ASH.ParentId;
                key+= ASH.UserOrGroupID;
                ACShareMap.put(Key,ASH);
            }       
        
        for(A_Customer_Profile__c AC : newACust){
            List<BU_Customer_Plan__share> GetBUShareList = new List<BU_Customer_Plan__share>();
             GetBUShareList = BUShareMap.get(AC.BU_Customer_Plan__c);
             system.debug(GetBUShareList+'GetBUShareList');
             if(GetBUShareList != null){
                 for(BU_Customer_Plan__share BS : GetBUShareList){
                    String Key = AC.Id;
                    key+= BS.UserOrGroupId;
                    if(!ACShareMap.containskey(Key) && AC.OwnerId != BS.UserorGroupId){
                         A_Customer_Profile__share ACShare = new A_Customer_Profile__share();
                         ACShare.ParentId = AC.Id;
                         ACShare.UserOrGroupId = BS.UserOrGroupId;
                         ACShare.RowCause = 'Manual';
                         if(BS.AccessLevel == 'All')
                           ACShare.AccessLevel = 'Edit';
                         else
                           ACShare.AccessLevel = BS.Accesslevel;
                           ACshareList.add(ACShare);
                     }
                 }
             }
        }
        insert ACshareList;
    }
    
    Public Static Void AddACOwnerManagertoACSharing(A_Customer_Profile__c[] newACust){
            List<Id> ACOwnerIdList = new List<Id>();
            List<User> ManagerIdList = new List<User>();
            Map<Id,Id> ManagerIdMap = new Map<Id,Id>();
            List<A_Customer_Profile__share> ACShareList = new List<A_Customer_Profile__share>();
            
            for(A_Customer_Profile__c AC : newACust){
                ACOwnerIdList.add(AC.OwnerId);
            }
                     
            ManagerIdList = [Select ManagerId From User Where IsActive=true AND Id In :ACOwnerIdList];            
         
            for(USer Mid : ManagerIdList){
                if(Mid.ManagerId != null)
                ManagerIdMap.put(Mid.Id,Mid.ManagerId);
            }            
          
            for(A_Customer_Profile__c AC : newACust){
                if(ManagerIdMAp.Containskey(AC.OwnerId)){
                    A_Customer_Profile__share ACShare = new A_Customer_Profile__share();
                    ACShare.ParentId = AC.Id;
                    ACShare.RowCause = 'Manual';
                    ACShare.USerorGroupId = ManagerIdMAp.get(AC.OwnerId);
                    ACShare.AccessLevel = 'Edit';  
                    ACShareList.add(ACshare); 
                }              
            }
            system.debug(ACShareList);
            upsert ACShareList;
        }
        
    Public Static Void AddBUOwnerManagersToBUSharing(BU_Customer_Plan__c[] newBUPlan){
        Set<Id> BUOwnerSet = new Set<Id>();
        Map<Id,Id> ManagerIdMap = new Map<Id,Id>();
        List<BU_Customer_Plan__share> BUShareList = new List<BU_Customer_Plan__share>();
        
        for(BU_Customer_Plan__c BU : newBUPlan){
            BUOwnerSet.add(BU.OwnerId);
        }
        
        for(USer Mid : [Select u.ManagerId From User u Where u.Manager.IsActive=true AND  Id In :BUOwnerSet]){
                if(Mid.ManagerId != null)
                ManagerIdMap.put(Mid.Id,Mid.ManagerId);
        }
        
        for(BU_Customer_Plan__c BU : newBUPlan){
            if(ManagerIdMAp.Containskey(BU.OwnerId)){
                BU_Customer_Plan__share BUShare = new BU_Customer_Plan__share();
                BUShare.ParentId = BU.Id;
                BUShare.RowCause = 'Manual';
                BUShare.USerorGroupId = ManagerIdMAp.get(BU.OwnerId);
                BUShare.AccessLevel = 'Edit';
                BUShareList.add(BUShare);
            }
        }
        
        if(!BUShareList.isEmpty())
        upsert BUShareList; 
    }        
        
    Public Static Void ThrowStrategicInitiativeError(A_Customer_Profile__c[] newACust){
        for(integer i=0; i<newACust.size(); i++){
           // if(newACust[i].Name == null){newACust[i].Name.addError('Name');}
            if(newACust[i].Strategic_Initiative_2__c != null){
                if(newACust[i].Strategic_Initiative_2_Status__c == null){
                    newACust[i].Strategic_Initiative_2_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_2_Target__c == null){
                    newACust[i].Strategic_Initiative_2_Target__c.addError('You must select a Target for this initiative');
                }
            }            
            if(newACust[i].Strategic_Initiative_3__c != null){
                if(newACust[i].Strategic_Initiative_3_Status__c == null){
                    newACust[i].Strategic_Initiative_3_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_3_Target__c == null){
                    newACust[i].Strategic_Initiative_3_Target__c.addError('You must select a Target for this initiative');
                }
            }            
            if(newACust[i].Strategic_Initiative_4__c != null){
                if(newACust[i].Strategic_Initiative_4_Status__c == null){
                    newACust[i].Strategic_Initiative_4_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_4_Target__c == null){
                    newACust[i].Strategic_Initiative_4_Target__c.addError('You must select a Target for this initiative');
                }
            }
            if(newACust[i].Strategic_Initiative_5__c != null){
                if(newACust[i].Strategic_Initiative_5_Status__c == null){
                    newACust[i].Strategic_Initiative_5_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_5_Target__c == null){
                    newACust[i].Strategic_Initiative_5_Target__c.addError('You must select a Target for this initiative');
                }
            }
            if(newACust[i].Strategic_Initiative_6__c != null){
                if(newACust[i].Strategic_Initiative_6_Status__c == null){
                    newACust[i].Strategic_Initiative_6_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_6_Target__c == null){
                    newACust[i].Strategic_Initiative_6_Target__c.addError('You must select a Target for this initiative');
                }
            }
            if(newACust[i].Strategic_Initiative_7__c != null){
                if(newACust[i].Strategic_Initiative_7_Status__c == null){
                    newACust[i].Strategic_Initiative_7_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_7_Target__c == null){
                    newACust[i].Strategic_Initiative_7_Target__c.addError('You must select a Target for this initiative');
                }
            }
            if(newACust[i].Strategic_Initiative_8__c != null){
                if(newACust[i].Strategic_Initiative_8_Status__c == null){
                    newACust[i].Strategic_Initiative_8_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_8_Target__c == null){
                    newACust[i].Strategic_Initiative_8_Target__c.addError('You must select a Target for this initiative');
                }
            }
            if(newACust[i].Strategic_Initiative_9__c != null){
                if(newACust[i].Strategic_Initiative_9_Status__c == null){
                    newACust[i].Strategic_Initiative_9_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_9_Target__c == null){
                    newACust[i].Strategic_Initiative_9_Target__c.addError('You must select a Target for this initiative');
                }
            }
            if(newACust[i].Strategic_Initiative_10__c != null){
                if(newACust[i].Strategic_Initiative_10_Status__c == null){
                    newACust[i].Strategic_Initiative_10_Status__c.addError('You must select a Status for this initiative');
                }
                if(newACust[i].Strategic_Initiative_10_Target__c == null){
                    newACust[i].Strategic_Initiative_10_Target__c.addError('You must select a Target for this initiative');
                }
            }
        }   
    }
    
    Public Static Void PopulateRevenueSectionUpdateFields(A_Customer_Profile__c[] newACust){
        for(integer i=0; i<newACust.size(); i++){
            newACust[i].Revenue_Section_Last_Updated__c    = system.now();
            newACust[i].Revenue_Section_Last_Updated_By__c = UserInfo.getUserId();
        }
    }
    
    Public Static Void PopulateMonthlyUpdateUpdateFields(A_Customer_Profile__c[] newACust){
        for(integer i=0; i<newACust.size(); i++){
            newACust[i].Monthly_Update_Last_Updated__c    = system.now();
            newACust[i].Monthly_Update_Last_Updated_By__c = UserInfo.getUserId();
        }
    }

    Public static void RevenueSectionUpdate(A_Customer_Profile__c[] oldACust,A_Customer_Profile__c[] newACust){
        String userid = UserInfo.getUserId();
        Datetime lastm = system.now();
        for(integer j=0;j<oldACust.size();j++){
            integer i =0;
            if(oldACust[j].TE_Performance_Status__c != newACust[j].TE_Performance_Status__c)
            i++;
            if(oldACust[j].TE_Revenue_Prior_Yr_Actual_M__c != newACust[j].TE_Revenue_Prior_Yr_Actual_M__c)
            i++;
            if(oldACust[j].TE_Revenue_YTD_Actual_M__c != newACust[j].TE_Revenue_YTD_Actual_M__c)
            i++;
            if(oldACust[j].TE_Revenue_CY_Forecast_M__c != newACust[j].TE_Revenue_CY_Forecast_M__c)
            i++;
            if(oldACust[j].TE_Revenue_Fcst_Plan_Yr_M__c != newACust[j].TE_Revenue_Fcst_Plan_Yr_M__c)
            i++;
            if(oldACust[j].TE_Revenue_Fcst_Plan_Yr_1_M__c != newACust[j].TE_Revenue_Fcst_Plan_Yr_1_M__c)
            i++;
            if(oldACust[j].TE_Revenue_Fcst_Plan_Yr_4_M__c != newACust[j].TE_Revenue_Fcst_Plan_Yr_4_M__c)
            i++;
            if(oldACust[j].BU_Revenue_Prior_Yr_Actual_M__c != newACust[j].BU_Revenue_Prior_Yr_Actual_M__c)
            i++;
            if(oldACust[j].BU_Revenue_YTD_Actual_M__c != newACust[j].BU_Revenue_YTD_Actual_M__c)
            i++;
            if(oldACust[j].BU_Revenue_CY_Forecast_M__c != newACust[j].BU_Revenue_CY_Forecast_M__c)
            i++;
            if(oldACust[j].BU_Revenue_Fcst_Plan_Yr_M__c != newACust[j].BU_Revenue_Fcst_Plan_Yr_M__c)
            i++;
            if(oldACust[j].BU_Revenue_Fcst_Plan_Yr_1_M__c != newACust[j].BU_Revenue_Fcst_Plan_Yr_1_M__c)
            i++;
            if(oldACust[j].BU_Revenue_Fcst_Plan_Yr_4_M__c != newACust[j].BU_Revenue_Fcst_Plan_Yr_4_M__c)
            i++;
            if(oldACust[j].Revenue_TAM_SAM__c != newACust[j].Revenue_TAM_SAM__c)
            i++;
            if(oldACust[j].TAM_Prior_Yr_M__c != newACust[j].TAM_Prior_Yr_M__c)
            i++;
            if(oldACust[j].TAM_Plan_Year_M__c != newACust[j].TAM_Plan_Year_M__c)
            i++;
            if(oldACust[j].TAM_Plan_Yr_1_M__c != newACust[j].TAM_Plan_Yr_1_M__c)
            i++;
            if(oldACust[j].TAM_Plan_Yr_4_M__c != newACust[j].TAM_Plan_Yr_4_M__c)
            i++;
            if(oldACust[j].Gross_Margin_Pct_Prior_Yr__c != newACust[j].Gross_Margin_Pct_Prior_Yr__c)
            i++;
            if(oldACust[j].Gross_Margin_Pct_Plan_Yr__c != newACust[j].Gross_Margin_Pct_Plan_Yr__c)
            i++;
            if(oldACust[j].Gross_Margin_Pct_Plan_Yr_1__c != newACust[j].Gross_Margin_Pct_Plan_Yr_1__c)
            i++;
            if(oldACust[j].Gross_Margin_Pct_Plan_Yr_4__c != newACust[j].Gross_Margin_Pct_Plan_Yr_4__c)
            i++;
            
            if(i>0){
                newACust[j].Revenue_Section_Last_Updated__c = lastm;
                newACust[j].Revenue_Section_Last_Updated_By__c = userid;
            }
        }    
    }
    
    Public static void MonthlyUpdateUpdate(A_Customer_Profile__c[] oldACust,A_Customer_Profile__c[] newACust){
        String userid = UserInfo.getUserId();
        Datetime lastm = system.now();
        for(integer j=0;j<oldACust.size();j++){
            if(oldACust[j].Monthly_Update__c != newACust[j].Monthly_Update__c){
                newACust[j].Monthly_Update_Last_Updated__c = lastm;
                newACust[j].Monthly_Update_Last_Updated_By__c = userid;
            }
        }    
    }
    
    //function to update last time stamp for a-customer profile by updating the field 
    //Hidden_Do_Not_Use__c to Datetime.now(). Currently This function is called 
    //only when A_Customer_Profile_Attachment__c record is deleted
    //Workflow Rules are taking care of Create and Update of A_Customer_Profile_Attachment__c
    Public static void FlagUpdateStatusOnCustomerProfile(A_Customer_Profile_Attachment__c[] attRecs){
        List<String>ProfileIds =  new List<String>();
        for(A_Customer_Profile_Attachment__c att : attRecs){
            ProfileIds.add(att.A_Customer_Profile__c);
            //system.debug('att.A_Customer_Profile__r.Id = ' + att.A_Customer_Profile__r.Id);
            //system.debug('att.A_Customer_Profile__c = ' + att.A_Customer_Profile__c);
        }
        //system.debug('attRecs count = ' + attRecs.size());
        //system.debug('ProfileIds count = ' + ProfileIds.size());
        //system.debug('ProfileIds[0] value = ' + ProfileIds[0]);
        A_Customer_Profile__c[] ProfileColl = [select id, Gross_Margin_Pct_Plan_Yr__c from A_Customer_Profile__c where id in: ProfileIds];
        //system.debug('ProfileColl count = ' + ProfileColl.size());
        if (ProfileColl != null && ProfileColl.size() > 0)
        {
            for(A_Customer_Profile__c ProfileRec : ProfileColl){
                ProfileRec.Hidden_Do_Not_Use__c = Datetime.now();
            }
            
            update ProfileColl;
        }
        
    }

 
}