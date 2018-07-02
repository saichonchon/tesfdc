/*
Class written By Deepak Kumar(deepak.kumar89@te.com)
Calss is used as an controller class for IND Opportunity PDF VF Page.
Created date 8th Aug 2015
*/
public class IND_Opportunity_PDF_Controller {

    public set<id> Crid= new Set<id>();
   Public id oppid{get;set;} 
   Public Opportunity Mainopp{get;set;} 
   Public account oppacc{get;set;}
   Public user oppowner{get;set;}
   Public List<Custom_Opportunity_Contact_Role__c> Controle = new List<Custom_Opportunity_Contact_Role__c>();
 // &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     Constructor of Controller &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    
    public IND_Opportunity_PDF_Controller(ApexPages.StandardController controller) {
      oppid=ApexPages.currentPage().getParameters().get('Id');
      
      Mainopp=[select id,name,Opportunity_Number__c,Account_Number__c,StageName,Focus_Opportunity__c,Summary_Ability__c,Summary_Attractiveness__c,Buying_Cycle__c,Record_Type_Name__c,
                    CreatedDate,CloseDate,Manufacturing_Start_Date__c,Growth_Opportunity__c,AccountId,OwnerId,Description,Five_Year_Revenue__c,Amount,Problems_Our_Capabilities_Solve__c,
                     Implications_of_Problems__c,Implementation_Considerations__c,Payoffs_of_Solving_Problems__c,CurrencyIsoCode
                    from Opportunity where id=:ApexPages.currentPage().getParameters().get('Id')];
       Controle=[Select id,name,Business_Issues__c,Concerns__c,Contact__c,Focus_Point__c,Name__c,Resolution_of_Concerns__c,Role__c from Custom_Opportunity_Contact_Role__c where Opportunity__c=:oppid ];
         
       if(Mainopp.AccountId!=null)
       {
       oppacc=[select id,name from account where id = :Mainopp.AccountId];
       }
       if(Mainopp.OwnerId!=null)
       {
       oppowner=[select id,name from User where id = :Mainopp.OwnerId];
       }
       ContinfoMethod();
       NeedinfoMethod();
       DecisioncreteriainfoMethod();
       OppCompetitorMethod();
       HighlowMethod();
       FullForecastMethod();
                   
    }


// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&     Constructor of Controller &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  Start of opportunity related object data retrival $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 

//$$$$$$$$$$$$$$$$$$$ Public Variables $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
 
  public List<subClassContInfo> ContactInfo{get;set;}
  public List<subClassNeedInfo> NeedInfo{get;set;}
  public List<subClassDCKPInfo> DCKPInfo{get;set;}
  Public List<Opportunity_Competitor__c> OppComp{get;set;}
  Public List<Highlight_Lowlight__c> HighLow{get;set;}
  Public List<Opportunity_Part__c> OppPart{get;set;}
  

//$$$$$$$$$$$$$$$$$$$ Public Variables $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
            
//##################################################################### Method for contact Information & Resolution of Concerns ####################################################################################################            
     Public Void ContinfoMethod()
       {
       
       Map<id,Contact> TempContinfo = new Map<id,Contact>();
       Map<id,Contact> TempReptoinfo = new Map<id,Contact>();
       set<id> reptoid= new Set<id>();
       
       set<id> Contid= new Set<id>();
       Map<id,Contact> Continfo= new Map<id,Contact>();
       Map<id,Contact> Reptoinfo= new Map<id,Contact>();
  
        ContactInfo = new List<subClassContInfo>();
         
         
         for(Custom_Opportunity_Contact_Role__c c1:Controle)
           {
             Contid.add(c1.Contact__c);
             Crid.add(c1.id);
           }
         
       
        TempContinfo.putall([select id,NPS_Status__c,ReportsToId,name from Contact where id IN :Contid]);
           
          for(Contact c2:TempContinfo.values())
            {
              reptoid.add(c2.ReportsToId);
            }
        
        TempReptoinfo.putall([select id,name,Full_Name__c from Contact where id IN :reptoid]);
        
        
      
  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Mapping Data for contact information &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&       
        ContactInfo = new List<subClassContInfo>(); 
        for(Custom_Opportunity_Contact_Role__c crole:Controle)
          {
           if(crole.Contact__c!=null)
            {
             
              if(crole.Contact__c==TempContinfo.get(crole.Contact__c).id)
              {
              Continfo.put(crole.id,TempContinfo.get(crole.Contact__c));
              }
              
              if(TempContinfo.get(crole.Contact__c).ReportsToId!=null)
              {
              
                  if(TempReptoinfo.get(TempContinfo.get(crole.Contact__c).ReportsToId).id==TempContinfo.get(crole.Contact__c).ReportsToId)
                  {
                   Reptoinfo.put(TempContinfo.get(crole.Contact__c).ReportsToId,TempReptoinfo.get(TempContinfo.get(crole.Contact__c).ReportsToId));
                   }
                }
              }
              
               ContactInfo.add(new subClassContInfo(Continfo.get(crole.id),Reptoinfo.get(TempContinfo.get(crole.Contact__c).ReportsToId),crole));  
             
            }
          
         }
         
  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ Mapping Data for contact information &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&      
  
     
      
     

//##################################################################### Method for contact Information & Resolution of Concerns ####################################################################################################            
  
//##################################################################### Method for Uncover and Develop Needs  ####################################################################################################            
        
      Public Void NeedinfoMethod()
       {
        // List<Custom_Opportunity_Contact_Role__c> Controle = new List<Custom_Opportunity_Contact_Role__c>();
        // Map<id,List<Need__c>> TempNeedinfo = new Map<id,List<Need__c>>();
         List<Need__c> temlistneed=new List<Need__c>();
         
         //Controle=[Select id,name,Business_Issues__c,Concerns__c,Contact__c,Focus_Point__c,Name__c,Resolution_of_Concerns__c,Role__c from Custom_Opportunity_Contact_Role__c where Opportunity__c=:oppid ];
         List<Need__c> needtemp=[select id,Need__c,Need_Status__c,Need_Type__c,Contact_Role__c from Need__c where Contact_Role__c IN :Crid];
         
                 
         NeedInfo= new List<subClassNeedInfo>();
         for(Custom_Opportunity_Contact_Role__c c1:Controle)
           {
            temlistneed=new List<Need__c>();
            for(Need__c n:needtemp)
             {
              if(c1.id==n.Contact_Role__c)
              {
               temlistneed.add(n);
              }
             }           
             NeedInfo.add(new subClassNeedInfo(temlistneed,c1));
           }
       
       
       
       }

//##################################################################### Method for Uncover and Develop Needs  ####################################################################################################            
 
//##################################################################### Method for Decision Criteria / Customer View of our Position against the Competition / Key-Player Rating ####################################################################################################            
 
                
        Public Void DecisioncreteriainfoMethod()
          {
         Map<id,Decision_Criteria__c> DecisCre = new Map<id,Decision_Criteria__c>();
         //Map<id,List<Need__c>> TempNeedinfo = new Map<id,List<Need__c>>();
         List<Key_Player_Criteria__c> temlistKPC=new List<Key_Player_Criteria__c>();
         
         DecisCre.putall([Select id,name,Active__c,Question_English__c,Position__c,Comment__c from Decision_Criteria__c  where Opportunity__c=:oppid AND Active__c=true]);
         List<Key_Player_Criteria__c> KPCLIST=[select id,Decision_Criteria__c,Key_Player__c,Key_Player_Name__c,Priority__c from Key_Player_Criteria__c where Decision_Criteria__c = :DecisCre.keyset()];
             
          
          DCKPInfo= new List<subClassDCKPInfo>();
         
         for(Decision_Criteria__c D1:DecisCre.values())
           {
            temlistKPC=new List<Key_Player_Criteria__c>();
            for(Key_Player_Criteria__c n:KPCLIST)
             {
               if(D1.id==n.Decision_Criteria__c)
               {
                  temlistKPC.add(n);
               } 
             }          
             DCKPInfo.add(new subClassDCKPInfo(temlistKPC,D1));
           }
       
       
       
       }


//##################################################################### Method for Decision Criteria / Customer View of our Position against the Competition / Key-Player Rating ####################################################################################################            
 
 //##################################################################### Method for Competitor Information ####################################################################################################            
 
       Public Void OppCompetitorMethod()
         {
           OppComp = new List<Opportunity_Competitor__c>();
           OppComp =[Select id,Competitor_txt__c,Opportunity__c,Strengths__c,Weaknesses__c,View__c,Competitor__c from Opportunity_Competitor__c where Opportunity__c=:oppid  ];
         }
 
 //##################################################################### Method for Competitor Information ####################################################################################################            
 
//##################################################################### Method for Highlight/Lowlight   ####################################################################################################            
           
         Public Void HighlowMethod()
         {
           HighLow= new List<Highlight_Lowlight__c>();
           HighLow=[Select id,name,Type__c,Text_and_Pictures__c,CreatedDate from Highlight_Lowlight__c where Opportunity__c=:oppid];
         }
         
 //##################################################################### Method for Highlight/Lowlight   ####################################################################################################            
 
//##################################################################### Method for Full Forecast Information Per Part    ####################################################################################################            
           
         Public Void FullForecastMethod()
         {
           OppPart= new List<Opportunity_Part__c>();
           OppPart=[Select id,name,Part_Number_txt__c,Item_Description__c,Status__c,Current_Year_minus_1__c,Current_Year__c,Current_Year_add_1__c,Current_Year_add_2__c,Current_Year_add_3__c,Current_Year_add_4__c from Opportunity_Part__c where Opportunity__c=:oppid];
         }
         
 //##################################################################### Method for Full Forecast Information Per Part    ####################################################################################################            
 

//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  Classes for Data management $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 

public class subClassContInfo{

     public Contact ContAA{get;set;}
     public Contact Reptoinfo{get;set;}
     public Custom_Opportunity_Contact_Role__c ControleRole{get;set;} 
     
     public subClassContInfo(Contact ContA,Contact ContB,Custom_Opportunity_Contact_Role__c CR ){

           ContAA=ContA;
           Reptoinfo=ContB;
           ControleRole=CR;
     }

}

public class subClassNeedInfo{

     public List<Need__c> ListNeed{get;set;}     
     public Custom_Opportunity_Contact_Role__c ControleRole{get;set;} 
     public integer sizelist{get;set;}
     
     public subClassNeedInfo(List<Need__c> NeedA,Custom_Opportunity_Contact_Role__c CR ){

           ListNeed=NeedA;
           ControleRole=CR;
           sizelist=NeedA.size();
     }

}

public class subClassDCKPInfo{

     public List<Key_Player_Criteria__c> ListKPC{get;set;}     
     public Decision_Criteria__c DCKPin{get;set;} 
     public integer sizelist{get;set;}
     
     public subClassDCKPInfo(List<Key_Player_Criteria__c> NeedA,Decision_Criteria__c CR ){

           ListKPC=NeedA;
           DCKPin=CR;
           sizelist=NeedA.size();
     }

}



//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  Classes for Data management $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ 




}