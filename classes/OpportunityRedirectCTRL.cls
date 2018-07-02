public class OpportunityRedirectCTRL{
    public String recordId;
    public String conid;
    public String accid;
    public String recordTypeId;
    List<String> oldid = new List<String>();
    List<String> newid = new List<String>();
  List<String> oldselectid = new List<String>();
    List<String> newselectid = new List<String>();
    List<String> Opppid11 = new List<String>();
            List<String> Dndid11 = new List<String>();
      List<String> oldOpppid11 = new List<String>();
            List<String> newDndid11 = new List<String>();
            List<String> oldid11 = new List<String>();
            List<String> newid11 = new List<String>();
            List<String> oldselectid11 = new List<String>();
            List<String> newselectid11 = new List<String>();
    public opportunity opp {get;set;}
    private final ApexPages.StandardController stdController;

    public OpportunityRedirectCTRL(ApexPages.StandardController str){
        this.stdController = stdController;
        opp = (Opportunity)str.getRecord();
        recordId = str.getId();
        recordTypeId=ApexPages.currentPage().getParameters().get('RecordType');
        conid=ApexPages.currentPage().getParameters().get('conid');
        accid=ApexPages.currentPage().getParameters().get('accid');
        
        system.debug('====recordTypeId ====>'+recordTypeId);
        
    }
    
    
    /* Override the Custom Page only for 'DND' & 'Appliance Standard User' */
    public PageReference redirect() {
            List<String> Opppid = new List<String>();
            List<String> Dndid = new List<String>();
      List<String> oldOpppid = new List<String>();
            List<String> newDndid = new List<String>();
          
        PageReference pgRef;
        string recordtypename;
        if(opp.recordtypeid<>null)
        recordtypename= Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opp.recordtypeid).getname();
        system.debug('====recordtypename ====>'+recordtypename);
        Profile pr = [select name from Profile where id   =:UserInfo.getProfileId()]; // This for getting the logedin user profile 
         // Redirect to custom opportunity new page for  'DND Standard User' and 'Appliance Standard User' profiles .
        if ('DND Standard User'.equals(pr.name)|| 'Appliance Standard User'.equals(pr.name)||
           'DND Insidesales Power-Dailer'.equals(pr.name)|| 'DND Partner Community'.equals(pr.name)||
           'DND FAE User'.equals(pr.name)|| 'DND Engineering User w/Cost'.equals(pr.name)||(
           'BU Admin'.equals(pr.name) && recordtypename=='DND Opportunity')|| 'Appliance Engineering User w/Cost'.equals(pr.name)||
           'Appliance User w/ Cost'.equals(pr.name)){
             /*  SelectedRecordType__c opRec=new SelectedRecordType__c();
             if(recordTypeId != null){
            // SelectedRecordType__c opRec=new SelectedRecordType__c();
            opRec.Name=userinfo.getUserId();
           opRec.SelRecordType__c=recordTypeId;
           upsert opRec Name; 
             }
             else{
                   List<Schema.RecordTypeInfo> infos = Schema.SObjectType.Opportunity.RecordTypeInfos;
                 Id defaultRecordTypeId;
                   //check each one
                for (Schema.RecordTypeInfo info : infos) {
                  if (info.DefaultRecordTypeMapping) {
                  defaultRecordTypeId = info.RecordTypeId;
              } */
            //}

      //here is the default Opportunity RecordType Id for the current user
        //System.debug(defaultRecordTypeId);
               //}
          // system.debug('====Opportunity ====>'+opRec);  
           pgRef= page.OpportunityPopup;
           pgRef.setRedirect(true);
           pgRef.getParameters().put('id', recordId);
           pgRef.getParameters().put('RecordType', recordTypeId);
           pgRef.getParameters().put('conid', conid);
           pgRef.getParameters().put('accid', accid);
          
      system.debug('====pageRef2 ====>'+pgRef);
            return pgRef;
        }
        else {
            // Redirect to New page with preselect record type
            //Id orderId = [select Id from RecordType where id='012E0000000XrBX'].Id;
            //PageReference p = new PageReference('/006/e');
            List<String> Opppid1 = new List<String>();
            List<String> Dndid1 = new List<String>();
      List<String> oldOpppid1 = new List<String>();
            List<String> newDndid1 = new List<String>();
            List<String> oldid = new List<String>();
            List<String> newid1 = new List<String>();
            List<String> oldselectid1 = new List<String>();
            List<String> newselectid1 = new List<String>();
            pgRef=new PageReference('/006/e');
            Map<String, String> mapParams = pgRef.getParameters();
            mapParams.putAll(ApexPages.currentPage().getParameters());
            if (recordTypeId != null) mapParams.put('RecordType', recordTypeId);
            mapParams.put('nooverride', '1');
            mapParams.put('conid', conid);
            mapParams.put('accid', accid);
            mapParams.remove('save_new'); // Prevent the page from trying to save the opp and create a new one
            mapParams.remove('sfdc.override');
            system.debug('====pageRef2 ====>'+pgRef);
            return pgRef;
            
        }
        
    }  
}