public class IND_NEED_Controller {

  Public List<Need__c> ListNeed{get;set;}
  Public integer Countneed{get;set;} 
  Public List<Need__c> finalneed=new List<Need__c>();
  Public List<Need__c> deleteneed=new List<Need__c>();
  public id iddcon{get;set;}
  public string URLForPage{get;set;}
  
    public IND_NEED_Controller(ApexPages.StandardController controller) {
     
       ListNeed=[Select id,Contact_Role__c,Need__c,Need_Status__c,Need_Type__c from Need__c where Contact_Role__c=:ApexPages.currentPage().getParameters().get('Id')]; //Removed the LImit 6
       Countneed=ListNeed.size();
       iddcon=ApexPages.currentPage().getParameters().get('Id');
       URLForPage = ApexPages.currentPage().getHeaders().get('Host');
    }
    
   public pagereference AddNeed(){
        Countneed++;
         If(Countneed<=6)
          {
          
         ListNeed.add(new Need__c(Contact_Role__c=ApexPages.currentPage().getParameters().get('Id')));
         
         }
         If(Countneed>6)
          {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'You can enter maximum 6 Needs for a contact Role.'));
          
          }
         return null;
     } 
    
    public pagereference Customsave(){
        for(Need__c n:ListNeed)
         {
           if(n.Need__c!=null)
           {
           finalneed.add(n);
           }
          else if(n.Need__c==null && n.id!=null)
          {
            deleteneed.add(n);
          }
           if(n.id==null && n.Need__c==null)
           {
           Countneed--;
           }
          
         }
        
         
         if(deleteneed.size()!=0)
         {
         Countneed=Countneed-deleteneed.size();
         delete deleteneed;
         }
         
         ListNeed.clear();
         ListNeed=finalneed;
         upsert finalneed;
         //PageReference controlePage = new PageReference('/'+iddcon+ '?inline=1');
        //controlePage.setRedirect(true);
        //return controlePage;
        return null; 
     } 
    
  /*  public pagereference CustomCancel(){
         
         return null;
     } 
    */

}