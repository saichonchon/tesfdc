trigger EventModule on Events_Exhibitions__c (after insert) {
if(Trigger.isinsert)
  {
     
      list<EventModules__c> oppids = new list<EventModules__c>();
     
      for(Events_Exhibitions__c oppSummaryRecords:trigger.new)
      {
          EventModules__c contractRecords = new EventModules__c();
          contractRecords.Events_Exhibitions__c = oppSummaryRecords.id;
          contractRecords.Module_Name__c='General information';
          oppids.add(contractRecords);
          
           EventModules__c contractRecords1 = new EventModules__c();
          contractRecords1.Events_Exhibitions__c = oppSummaryRecords.id;
          contractRecords1.Module_Name__c='Prospects';
          oppids.add(contractRecords1);
           EventModules__c contractRecords2 = new EventModules__c();
          contractRecords2.Events_Exhibitions__c = oppSummaryRecords.id;
          contractRecords2.Module_Name__c='Booth';
          oppids.add(contractRecords2);
          
           EventModules__c contractRecords3 = new EventModules__c();
          contractRecords3.Events_Exhibitions__c = oppSummaryRecords.id;
          contractRecords3.Module_Name__c='Samples';
          oppids.add(contractRecords3);
           EventModules__c contractRecords4 = new EventModules__c();
          contractRecords4.Events_Exhibitions__c = oppSummaryRecords.id;
          contractRecords4.Module_Name__c='Literature';
          oppids.add(contractRecords4);
           EventModules__c contractRecords5 = new EventModules__c();
          contractRecords5.Events_Exhibitions__c = oppSummaryRecords.id;
          contractRecords5.Module_Name__c='Give aways';
          oppids.add(contractRecords5);
           EventModules__c contractRecords6 = new EventModules__c();
          contractRecords6.Events_Exhibitions__c = oppSummaryRecords.id;
          contractRecords6.Module_Name__c='Report';
          oppids.add(contractRecords6);
          
          EventModules__c contractRecords7 = new EventModules__c();
          contractRecords7.Events_Exhibitions__c = oppSummaryRecords.id;
          contractRecords7.Module_Name__c='Other';
          oppids.add(contractRecords7);
          
        
      }
      
      insert oppids;
    }

}