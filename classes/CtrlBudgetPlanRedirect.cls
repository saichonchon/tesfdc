/** 
*    Controller for CtrlBudgetPlanRedirect page
*
@author Min Liu
@created 2012-04-25
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2012-04-25 Min Liu <min.liu@itbconsult.com>
* - Created
*/
public without sharing class CtrlBudgetPlanRedirect {
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public Boolean hasBudgets {get; set;}
    public List<Budget__c> list_budgets {get; set;}
    public String selectedBudget{get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private id userId;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public CtrlBudgetPlanRedirect(){
        userId = UserInfo.getUserId();
        list_budgets = new List<Budget__c>();
        selectedBudget = '';
    }
        
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
     /**
    * The method is used to decide the user(AM or Manager) to redirect
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */ 
    public PageReference deterRedirect(){
        String currentYear = ClsBudgetPlanningUtil.getCurrentFiscalYear();
        String nextYear = '';
        if(currentYear != ''){ 
            nextYear = String.valueOf(Integer.valueOf(currentYear) + 1);
            for(Budget__c b: [select id, Name, Manager__c, ownerId, Stage__c, Year__c, Territory__c,Territory__r.Name, Status__c from Budget__c where Manager__c = :userId and (Year__c = :currentYear or Year__c = :nextYear) limit 1]){
                pageReference pf = new pageReference('/apex/CtrlManagerReview');
                pf.setRedirect(true);
                return pf;
            }  
                    
            for(Budget__c b: [select id, Name, Manager__c, ownerId, Stage__c, Year__c, Territory__c,Territory__r.Name, Status__c from Budget__c where ownerId = :userId and (Year__c = :currentYear or Year__c = :nextYear)]){
                list_budgets.add(b);    
            }
            if(list_budgets.isEmpty()){
                pageReference pf = new pageReference('/apex/ExtBudgetPlanning');
                pf.setRedirect(true);
                return pf;          
            }               
            else if(list_budgets.size() == 1){
                pageReference pf = new pageReference('/apex/ExtBudgetPlanning?id=' + list_budgets[0].Id);
                pf.setRedirect(true);
                return pf;          
            }   
                    
        }   
        return null;
    }
    
     /**
    * The method is used to back to budget list view page
    *
    @author Min Liu
    @created 2012-05-29
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @param              
    *
    @return             
    *
    @changelog
    * 2012-05-29 Min Liu <min.liu@itbconsult.com>
    * - Created
    */
    public PageReference backToView(){
        pageReference pf = new pageReference('/' + ClsBudgetPlanningUtil.budgetPrefix);
        pf.setRedirect(true);
        return pf;              
    }  
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************           
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}