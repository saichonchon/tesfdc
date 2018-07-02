public class Industrial_Report_DashboardController {

   Public String UserReportingRole{get;set;}
   Public List<IND_Report_and_Dashboard__c> ListRepDash{get;set;} 
 
 //------------------Start of Creating the Properties to store the reports and dashboard links for each Section and its sub section--------------------------------------
 
    Public List<IND_Report_and_Dashboard__c> DashExecutiveIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashExecutiveDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashExecutiveSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepExecutiveIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepExecutiveDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepExecutiveSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashRSMIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashRSMDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashRSMSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepRSMIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepRSMDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepRSMSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashGSMIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashGSMDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashGSMSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepGSMIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepGSMDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepGSMSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashGAMIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashGAMDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashGAMSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepGAMIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepGAMDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepGAMSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashAMIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashAMDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashAMSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepAMIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepAMDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepAMSystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashFEIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashFEDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> DashFESystems{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepFEIND{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepFEDevices{get;set;}
    Public List<IND_Report_and_Dashboard__c> RepFESystems{get;set;}
 
 //---------------END of Creating the Properties to store the reports and dashboard links for each Section and its sub section--------------------------------------
 
 //----------Constructor Class--------------------------------------------------------------------------------------------------------------------------   
     public Industrial_Report_DashboardController() {
           
      User TempUser =[Select IND_Report_Dashboard_Roles__c from User where id=:Userinfo.getuserId()];
      UserReportingRole=TempUser.IND_Report_Dashboard_Roles__c;
      ListRepDash=[Select Name,Add_in_Systems_Sub_Section__c,Add_in_AM_Section__c,Add_in_Executive_Section__c,Short_Description__c,Is_Dashboard_Link__c,ID_of_Report_or_Dashboard__c,Add_in_RSM_Section__c,Add_in_Other_Section__c,Add_in_Industrial_Sub_Section__c,Add_in_Devices_Sub_Section__c,Add_in_GSM_Section__c,Add_in_FE_Section__c,Add_in_GAM_Section__c from IND_Report_and_Dashboard__c ];
      reportfuction();
      sortreportfunction();
    }
 //----------Constructor Class--------------------------------------------------------------------------------------------------------------------------   

/* 
 public PageReference reporturlfuction()
 {
   PageReference pageRef = new PageReference('/00O/o');
   pageRef.setRedirect(true);
   return(pageRef);
 }

  public PageReference dashboardurlfuction()
 {
   PageReference pageRef1 = new PageReference('/01Z/o');
   pageRef1.setRedirect(true);
   return(pageRef1);
 } 
   */
 //----------------------------------------------Start of Main Fuction for inserting the values into the Properties--------------------------------------------------------------------------------------------------------------------------   
     
  
   Public void reportfuction()
    {
    
 //-------------------------------------------------------------Intializing the Variables-----------------------------------------------------------------------------   
     
    DashExecutiveIND = new List<IND_Report_and_Dashboard__c>();
    RepExecutiveIND = new List<IND_Report_and_Dashboard__c>();
    DashExecutiveDevices = new List<IND_Report_and_Dashboard__c>();
    DashExecutiveSystems = new List<IND_Report_and_Dashboard__c>();
    RepExecutiveDevices = new List<IND_Report_and_Dashboard__c>();
    RepExecutiveSystems = new List<IND_Report_and_Dashboard__c>();
    DashRSMIND = new List<IND_Report_and_Dashboard__c>();
    DashRSMDevices = new List<IND_Report_and_Dashboard__c>();
    DashRSMSystems = new List<IND_Report_and_Dashboard__c>();
    RepRSMIND = new List<IND_Report_and_Dashboard__c>();
    RepRSMDevices = new List<IND_Report_and_Dashboard__c>();
    RepRSMSystems = new List<IND_Report_and_Dashboard__c>();
    DashGSMIND = new List<IND_Report_and_Dashboard__c>();
    DashGSMDevices = new List<IND_Report_and_Dashboard__c>();
    DashGSMSystems = new List<IND_Report_and_Dashboard__c>();
    RepGSMIND = new List<IND_Report_and_Dashboard__c>();
    RepGSMDevices = new List<IND_Report_and_Dashboard__c>();
    RepGSMSystems = new List<IND_Report_and_Dashboard__c>();
    DashGAMIND = new List<IND_Report_and_Dashboard__c>();
    DashGAMDevices = new List<IND_Report_and_Dashboard__c>();
    DashGAMSystems = new List<IND_Report_and_Dashboard__c>();
    RepGAMIND = new List<IND_Report_and_Dashboard__c>();
    RepGAMDevices = new List<IND_Report_and_Dashboard__c>();
    RepGAMSystems = new List<IND_Report_and_Dashboard__c>();
    DashAMIND = new List<IND_Report_and_Dashboard__c>();
    DashAMDevices = new List<IND_Report_and_Dashboard__c>();
    DashAMSystems = new List<IND_Report_and_Dashboard__c>();
    RepAMIND = new List<IND_Report_and_Dashboard__c>();
    RepAMDevices = new List<IND_Report_and_Dashboard__c>();
    RepAMSystems = new List<IND_Report_and_Dashboard__c>();
    DashFEIND = new List<IND_Report_and_Dashboard__c>();
    DashFEDevices = new List<IND_Report_and_Dashboard__c>();
    DashFESystems = new List<IND_Report_and_Dashboard__c>();
    RepFEIND = new List<IND_Report_and_Dashboard__c>();
    RepFEDevices = new List<IND_Report_and_Dashboard__c>();
    RepFESystems = new List<IND_Report_and_Dashboard__c>();

//-------------------------------------------------------------Intializing the Variables-----------------------------------------------------------------------------   
       
       
       
       for(IND_Report_and_Dashboard__c listind:ListRepDash){
          
       if(listind.Is_Dashboard_Link__c==true)
        {
         //--------------------------------------------Executive--------------------------------------------------------     
         
             if(listind.Add_in_Executive_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 DashExecutiveSystems.add(listind);
                 
              }
             if(listind.Add_in_Executive_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 //DashExecutiveDevices.add(Integer.valueOf(Listind.order__c),listind);
                 DashExecutiveDevices.add(listind);
              }
            if(listind.Add_in_Executive_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                DashExecutiveIND.add(listind);
              }

         //--------------------------------------------GSM--------------------------------------------------------     
            if(listind.Add_in_GSM_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 DashGSMDevices.add(listind);
              }
            if(listind.Add_in_GSM_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                 DashGSMIND.add(listind);
              }
            
            if(listind.Add_in_GSM_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 DashGSMSystems.add(listind);
              } 
           //------------------------------------------RSM------------------------------------------------    
            if(listind.Add_in_RSM_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 DashRSMDevices.add(listind);
              }
            if(listind.Add_in_RSM_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                DashRSMIND.add(listind);
              }
           
            if(listind.Add_in_RSM_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 DashRSMSystems.add(listind);
              }  
           //-------------------------------------------GAM---------------------------------------------------- 
            if(listind.Add_in_GAM_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 DashGAMDevices.add(listind);
              }
            if(listind.Add_in_GAM_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                 DashGAMIND.add(listind);
              }
           
            if(listind.Add_in_GAM_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 DashGAMSystems.add(listind);
              } 
           //--------------------------------------------AM------------------------------------------------------
            if(listind.Add_in_AM_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 DashAMDevices.add(listind);
              }
            if(listind.Add_in_AM_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                DashAMIND.add(listind);
              }
            
            if(listind.Add_in_AM_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 DashAMSystems.add(listind);
              } 
           //------------------------------------------------FE-----------------------------------------------------
            if(listind.Add_in_FE_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 DashFEDevices.add(listind);
              }
            if(listind.Add_in_FE_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                DashFEIND.add(listind);
              }
            
            if(listind.Add_in_FE_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 DashFESystems.add(listind);
              } 
           
                  
        }    
       else   
        {
        //--------------------------------------------Executive--------------------------------------------------------     
         
             if(listind.Add_in_Executive_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 RepExecutiveSystems.add(listind);
              }
            if(listind.Add_in_Executive_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 RepExecutiveDevices.add(listind);
              }
            if(listind.Add_in_Executive_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                RepExecutiveIND.add(listind);
              }
            
           //--------------------------------------------GSM--------------------------------------------------------     
            if(listind.Add_in_GSM_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 RepGSMDevices.add(listind);
              }
            if(listind.Add_in_GSM_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                RepGSMIND.add(listind);
              }

            if(listind.Add_in_GSM_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 RepGSMSystems.add(listind);
              } 
           //------------------------------------------RSM------------------------------------------------    
            if(listind.Add_in_RSM_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 RepRSMDevices.add(listind);
              }
            if(listind.Add_in_RSM_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                 RepRSMIND.add(listind);
              }
            
            if(listind.Add_in_RSM_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 RepRSMSystems.add(listind);
              }  
           //-------------------------------------------GAM---------------------------------------------------- 
            if(listind.Add_in_GAM_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 RepGAMDevices.add(listind);
              }
            if(listind.Add_in_GAM_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                RepGAMIND.add(listind);
              }
            
            if(listind.Add_in_GAM_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 RepGAMSystems.add(listind);
              } 
           //--------------------------------------------AM------------------------------------------------------
            if(listind.Add_in_AM_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 RepAMDevices.add(listind);
              }
            if(listind.Add_in_AM_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
               RepAMIND.add(listind);
              }
            
            if(listind.Add_in_AM_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 RepAMSystems.add(listind);
              } 
           //------------------------------------------------FE-----------------------------------------------------
            if(listind.Add_in_FE_Section__c==true && listind.Add_in_Devices_Sub_Section__c==true)
              {
                 RepFEDevices.add(listind);
              }
            if(listind.Add_in_FE_Section__c==true && listind.Add_in_Industrial_Sub_Section__c==true)
              {
                RepFEIND.add(listind);
              }
            
            if(listind.Add_in_FE_Section__c==true && listind.Add_in_Systems_Sub_Section__c==true)
              {
                 RepFESystems.add(listind);
              }    
              
              
              
        }
    
    }
 
 } 
 
//-----------------------------------------------Main Fuction for inserting the values into the Properties--------------------------------------------------------------------------------------------------------------------------   
//-----------------------------------------------Sort Fuction for inserting the values into the Properties--------------------------------------------------------------------------------------------------------------------------   

   
    /*  Public List<IND_Report_and_Dashboard__c> BubbleSort(List<IND_Report_and_Dashboard__c> replist, int array_size)
       {
          List<IND_Report_and_Dashboard__c> templist= new List<IND_Report_and_Dashboard__c>();
     
         int i, j;
         List<IND_Report_and_Dashboard__c> temp = new List<IND_Report_and_Dashboard__c>();
         
         for (i = 0; i < (array_size - 1); ++i)
          {
            for (j = 0; j < array_size - 1 - i; ++j )
            {
               if (replist[j].order__c > replist[j+1].order__c)
               {
                    temp = replist[j+1];
                    replist[j+1] = a[j];
                    a[j] = temp;
               }
            }
          }
        }
     */
   


 Public void sortreportfunction()
    {    
    DashExecutiveIND.sort();
    RepExecutiveIND.sort();
    DashExecutiveDevices.sort();
    DashExecutiveSystems.sort();
    RepExecutiveDevices.sort();
    RepExecutiveSystems.sort();
    DashRSMIND.sort();
    DashRSMDevices.sort();
    DashRSMSystems.sort();
    RepRSMIND.sort();
    RepRSMDevices.sort();
    RepRSMSystems.sort();
    DashGSMIND.sort();
    DashGSMDevices.sort();
    DashGSMSystems.sort();
    RepGSMIND.sort();
    RepGSMDevices.sort();
    RepGSMSystems.sort();
    DashGAMIND.sort();
    DashGAMDevices.sort();
    DashGAMSystems.sort();
    RepGAMIND.sort();
    RepGAMDevices.sort();
    RepGAMSystems.sort();
    DashAMIND.sort();
    DashAMDevices.sort();
    DashAMSystems.sort();
    RepAMIND.sort();
    RepAMDevices.sort();
    RepAMSystems.sort();
    DashFEIND.sort();
    DashFEDevices.sort();
    DashFESystems.sort();
    RepFEIND.sort();
    RepFEDevices.sort();
    RepFESystems.sort();
    } 
 ///-----------------------------------------------Sort Fuction for inserting the values into the Properties--------------------------------------------------------------------------------------------------------------------------   
   
    
}