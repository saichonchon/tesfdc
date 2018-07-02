public class AssignmentRuleServices {
  
  public static Database.DMLOptions createAssignmentRule(){
    Id assignmentRuleId;
        assignmentRuleId = [SELECT Id 
                  FROM AssignmentRule 
                  WHERE SobjectType = 'Case' 
                      AND Active = true 
                  LIMIT 1].Id;
        
        Database.DMLOptions dmlOpts = new Database.DMLOptions();
        dmlOpts.assignmentRuleHeader.assignmentRuleId = assignmentRuleId;
        
        return dmlOpts;
  } 
}