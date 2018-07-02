/** 
*    Class to display the forecast comments for CtrlAccountForecast.page
*
@author Yuda Zheng
@created 2013-09-25
@version 1.0
@since 27.0 (Force.com ApiVersion)
*
@changelog
* 2013-09-25 Yuda Zheng <yuda.zheng@itbconsult.com>
* - Created
*/

public class ClsForecastComments {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public list<ForecastCommentItem> list_commentItem {get; set;}
	public list<CommentOption> list_childAcctOption {get; set;}
	public map<String, set<String>> map_acctId_set_profitCtrs {get; set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    public ClsForecastComments(){
        this.list_commentItem = new list<ForecastCommentItem>();
        this.list_childAcctOption = new list<CommentOption>();
        this.map_acctId_set_profitCtrs = new map<String, set<String>>();
    }
    
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
        
    //********************************* -=BEGIN public methods=- **********************************
    //********************************* -=END public methods=- ************************************
       
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
        
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************           
    ///*>>>WrapperClass*/
    public class ForecastCommentItem implements Comparable{
    	public String fcId {get; set;}
    	public String acctName {get; set;}
    	public String parentAcctId {get; set;}
	    public String acctId {get; set;}
	    public String profitCenter {get; set;} 
	    public String value {get; set;} 
	    public String comment {get; set;} 
	    public String year {get; set;}
	    public Integer month {get; set;}
	    
	    public ForecastCommentItem() {
	    	this.fcId = '';
	    	this.acctName = '';
	    	this.parentAcctId = '';
	    	this.acctId = '';
	    	this.profitCenter = '';
	    	this.comment = '';
	    	this.value = '';
	    	this.year = '';
	    	this.month = 0;
	    }
	    
	    // Implement the compareTo() method
	    public Integer compareTo(Object compareTo) {
	        ForecastCommentItem compareToEmp = (ForecastCommentItem)compareTo;
	        if (value == compareToEmp.value) return 0;
	        if (value > compareToEmp.value) return -1;
	        return 1;        
	    }
	    
    }
    public class CommentOption {
    	public String selectKey {get; set;}
    	public String selectValue {get; set;}
    	
    	public CommentOption(String key, String value) {
    		this.selectKey = key;
    		this.selectValue = value;
    	}
    }
    
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}