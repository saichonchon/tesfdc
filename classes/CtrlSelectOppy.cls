/**
 *  Ctrl class for page CtrlSelectOppy_writeDescription
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-16
 * @version 1.0
 * @since 23.0
 * 
 *
 * @changelog
 * 2012-05-16 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */


public with sharing class CtrlSelectOppy {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   	public Opportunity oppy{get;set;}
   	public String oppyId{get;private set;}
   	public String commentId{get;set;}
   	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private map<String, String> map_urlParams;
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
     * the constructor
     */
    public CtrlSelectOppy () 
    {
        map_urlParams = ApexPages.currentPage().getParameters();
        
        if(map_urlParams.containsKey('oppyId'))
        {
        	oppyId = map_urlParams.get('oppyId');
        	if(oppyId != null){
        		oppy = [SELECT Id, Name, Account_Plan_Comment__c FROM Opportunity WHERE Id = :oppyId LIMIT 1];
        	}
        }
        if(map_urlParams.containsKey('commentId')){
        	commentId = map_urlParams.get('commentId');
        }
        
    }
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************
    
    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>InnerClass*/
    
	///*<<<InnerClass*/
    //********************************* -=END inner classes=- *************************************
}