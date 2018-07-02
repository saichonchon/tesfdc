public class ANZClauseController {
    
    public ANZ_Clause__c newANZ;
    Opportunity oppType;
    public ANZClauseController(ApexPages.StandardController controller) {
        
        newANZ=(ANZ_Clause__c)controller.getRecord();
        oppType = [select id,Type__c from Opportunity where id=:newANZ.Opportunity__c];
        //newANZ.Opportynity_Type__c = oppType.Type__c;
        
    }
    public pagereference saveRecords() {
    	try{
	        upsert newANZ;
        	pagereference retToPage=new pagereference('/'+newANZ.Opportunity__c);
        	return retToPage;
    	}catch(Exception e){
    		ErrorLogging.Log(e);
    		return null;
    	}
    }
    public pagereference saveandmore() {
        //pagereference ret=getUrl
        try{
	        upsert newANZ;
        	PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
        	pageRef.setRedirect(true);
        	return pageRef;
        }catch(Exception e){
        	ErrorLogging.Log(e);
        	return null;
        }
    }
    public pagereference cancel() {
        pagereference retToPage=new pagereference('/'+newANZ.Opportunity__c);
        return retToPage;
    }
    
}