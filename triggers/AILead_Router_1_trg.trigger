trigger AILead_Router_1_trg on Lead (After Insert) {
  // Lead id list 
  List <string> LeadList = new List <String>();
    for (Lead L:Trigger.new) {
      if (L.Id != Null) {LeadList.add(L.Id);}
  }
  // call the lead routing class
  RouteLead.Leadrouter(LeadList);
}