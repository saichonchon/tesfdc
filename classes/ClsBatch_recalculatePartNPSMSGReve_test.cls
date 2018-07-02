/**
 *  Test class for ClsBatch_recalculatePartNPSMSGRevenue 
 *  
 * @author Pankaj Raijade
 * @created 2015-07-31
 * @version 1.0
 *
 */
@istest(seeallData=false)
public class ClsBatch_recalculatePartNPSMSGReve_test
{
    static testmethod Void ClsBatch_recalculatePartNPSMSGReve_TM()
    {
        

        ClsTestCustomSettingHelper.getApex_Helper_Settings();
        ClsTestCustomSettingHelper.getConsumer_Device_Opportunity_Record_Types();
        ClsTestCustomSettingHelper.getOpportunity_Record_Type_Groups();
        ClsTestCustomSettingHelper.getOpportunity_Approvers();
        ClsTestCustomSettingHelper.getProfit_BU_Center_Mapping_Rule2();


        set<Id> applOpptyRTId = ClsOppyForecastUtil.applianceOpptyRecordTypeId();
        Id OPRTID;

        User oUser = ClsTestHelp.createTestUsers();
        oUser.Email = 'helloManesfd@testCompany1233423.com';
        oUser.Alias = 'dpse';
        oUser.CommunityNickname = 'TMD';
        oUser.ProfileId = UserInfo.getProfileId();
        oUser.GIBU__c = 'Appliances';
        insert oUser;
    
        System.RunAs(oUser)
        {
            if(applOpptyRTId.size() > 0)
            {
                for(id rTID :applOpptyRTId)
                {
                    OPRTID = rTID;
                    break;
                }
                Opportunity oppy2 = new Opportunity();
                oppy2.StageName = 'New';
                oppy2.Program_level_Forecasting__c =true; 
                oppy2.Name = 'Pain of Queen';
                oppy2.CloseDate = date.today().addDays(5);
                oppy2.Type = 'CM';
                oppy2.Request_Type__c = 'Extension';
                oppy2.RecordTypeId =OPRTID;
                oppy2.ownerID = oUser.ID;
                oppy2.Currency_Confirm__c = true;
                //insert oppy2;  
                  
                Opportunity oppy = new Opportunity();
                oppy.CloseDate = date.today().addDays(5);
                oppy.name = 'Pain of Queen2';
                oppy.StageName = 'New';
                oppy.Program__c = oppy2.Id;   
                oppy.Type = 'CM';
                oppy.Request_Type__c = 'Extension';
                oppy.Method__c = 'BOM';
                oppy.Level__c = 'Yearly';
                oppy.Amount = 1;
                oppy.Five_Year_Revenue__c = 1;
                oppy.RecordTypeId = OPRTID;
                oppy.ownerID = oUser.ID;
                oppy.Currency_Confirm__c = true;
                insert new list<Opportunity>{oppy, oppy2};
                          
                Product_Hierarchy__c ph = new Product_Hierarchy__c();
                ph.Hierarchy_Level_Type__c = 'CBC1';
                ph.Description__c = 'Industrial';
                insert ph;
                  
                Part__c part = new Part__c();
                part.Description__c = 'Sniper';
                part.Product_Hierarchy__c = ph.Id;
                part.Market_Date__c = date.today();
                insert part;
                
                Opportunity_Part__c oppypart = ClsTestHelp.createTestOpportunityPart();
                oppypart.Opportunity__c = oppy.Id;
                oppypart.Part__c = part.Id;
                oppypart.Status__c = 'Won';
                oppypart.Lost_Reason__c = 'Other';
                oppypart.Lost_Reason_Text__c = null;
                oppypart.GPL__c = ph.Id;
                oppypart.Initial_Order_Date__c = date.today();
                oppypart.need_recalculate_PartNPSMSGRevenue__c = true;
                oppypart.BU_profit_center__c = 'Appliances';
                
    
                
                //insert oppypart;
                
                Opportunity_Part__c oppypart2 = ClsTestHelp.createTestOpportunityPart();
                oppypart2.Opportunity__c = oppy.Id;
                //oppypart2.Part__c = part.Id;
                oppypart2.Status__c = 'Lost';
                oppypart2.Lost_Reason__c = 'Other';
                oppypart2.Lost_Reason_Text__c = null;
                oppypart2.GPL__c = ph.Id;
                oppypart2.Initial_Order_Date__c = date.today();
                oppypart2.Proposal_Part_Key_Id__c = -1;
                  
            
                list<Opportunity_Part__c> oppyPartBatch = new list<Opportunity_Part__c>();
                oppyPartBatch.add(oppypart);
                oppyPartBatch.add(oppypart2);
                insert oppyPartBatch;
                
                list<Opportunity_Forecast__c> lstOpportunity_Forecast = new list<Opportunity_Forecast__c>();
                lstOpportunity_Forecast.add(new Opportunity_Forecast__c(Opportunity__c = oppy.Id,amount__c = 1000, Part__c = oppypart2.Id, NPS1__c = 1, NPS2__c = 1, NPS3__c = 1, MSG1__c = 1, MSG2__c = 1, MSG3__c = 1, Date__c = date.today(), Fiscal_Year__c = ''+date.today().year(), Fiscal_Quarter__c = ''+date.today().month()));
                lstOpportunity_Forecast.add(new Opportunity_Forecast__c(Opportunity__c = oppy.Id,amount__c = 1000, Part__c = oppypart.Id, NPS1__c = 1, NPS2__c = 1, NPS3__c = 1, MSG1__c = 1, MSG2__c = 1, MSG3__c = 1, Date__c = date.today(), Fiscal_Year__c = ''+date.today().year(), Fiscal_Quarter__c = ''+date.today().month()));
                lstOpportunity_Forecast.add(new Opportunity_Forecast__c(Opportunity__c = oppy.Id,amount__c = 1000, Part__c = oppypart.Id, NPS1__c = 1, NPS2__c = 1, NPS3__c = 1, MSG1__c = 1, MSG2__c = 1, MSG3__c = 1, Date__c = date.today(), Fiscal_Year__c = ''+(date.today().year() + 1), Fiscal_Quarter__c = ''+date.today().month()));
                lstOpportunity_Forecast.add(new Opportunity_Forecast__c(Opportunity__c = oppy.Id,amount__c = 1000, Part__c = oppypart.Id, NPS1__c = 1, NPS2__c = 1, NPS3__c = 1, MSG1__c = 1, MSG2__c = 1, MSG3__c = 1, Date__c = date.today(), Fiscal_Year__c = ''+(date.today().year() + 2), Fiscal_Quarter__c = ''+date.today().month()));
                lstOpportunity_Forecast.add(new Opportunity_Forecast__c(Opportunity__c = oppy.Id,amount__c = 1000, Part__c = oppypart.Id, NPS1__c = 1, NPS2__c = 1, NPS3__c = 1, MSG1__c = 1, MSG2__c = 1, MSG3__c = 1, Date__c = date.today(), Fiscal_Year__c = ''+(date.today().year() + 3), Fiscal_Quarter__c = ''+date.today().month()));
                lstOpportunity_Forecast.add(new Opportunity_Forecast__c(Opportunity__c = oppy.Id,amount__c = 1000, Part__c = oppypart.Id, NPS1__c = 1, NPS2__c = 1, NPS3__c = 1, MSG1__c = 1, MSG2__c = 1, MSG3__c = 1, Date__c = date.today(), Fiscal_Year__c = ''+(date.today().year() + 4), Fiscal_Quarter__c = ''+date.today().month()));
                lstOpportunity_Forecast.add(new Opportunity_Forecast__c(Opportunity__c = oppy.Id,amount__c = 1000, Part__c = oppypart.Id, NPS1__c = 1, NPS2__c = 1, NPS3__c = 1, MSG1__c = 1, MSG2__c = 1, MSG3__c = 1, Date__c = date.today(), Fiscal_Year__c = ''+(date.today().year() + 5), Fiscal_Quarter__c = ''+date.today().month()));
                insert lstOpportunity_Forecast;
    
      
            }      
            ClsBatch_recalculatePartNPSMSGRevenue o = new ClsBatch_recalculatePartNPSMSGRevenue();      
            o.query = 'SELECT Id,Part__c From Opportunity_Part__c';
            database.executebatch(o);
            
            ClsBatch_recalculatePartNPSMSGRevenue.getQuarterStartEndDate(new set<Date>{date.today()}, new List<Period>{new period(StartDate = date.today().addDays(-1), enddate = date.today().addDays(1))});
            ClsBatch_recalculatePartNPSMSGRevenue.getQuarter(new set<Date>{date.today()}, new List<Period>{new period(StartDate = date.today().addDays(-1), enddate = date.today().addDays(1))});
        }
    }
}