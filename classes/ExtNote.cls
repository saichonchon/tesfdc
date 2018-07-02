/**
 *  Extension class for page ExtNote_newEditEntryPage
 * 
 * @author Yuanyuan Zhang
 * @created 2012-05-18
 * @version 1.0
 * @since 23.0(ForceIDE Version)
 * 
 * 
 *
 * @changelog
 * 2012-05-18 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>
 * - Created   
 *
 */

public class ExtNote {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   	public String mode{get;set;}
   	public Note note{get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    private ApexPages.standardController stdCtrl;
	private map<String, String> map_urlParams;
	private Id noteId;
	private String retUrl;
	private Id parentId;  
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
    /**
     * the constructor
     */
    public ExtNote(ApexPages.StandardController stdCtrl) {
        map_urlParams = ApexPages.currentPage().getParameters();
		this.stdCtrl = stdCtrl;
		if(map_urlParams.containsKey('noteId')){
			mode = 'edit';
			noteId = map_urlParams.get('noteId');
			note = [SELECT Body, 
						   Id, 
						   ParentId, 
						   IsPrivate, 
						   Title 
					FROM Note
					WHERE Id = :noteId LIMIT 1];
		}
		else{
			mode = 'new';
			note = new Note();
		}
		if(map_urlParams.containsKey('parentId')){
			parentId = map_urlParams.get('parentId');
			note.ParentId = parentId;
		}
		if(map_urlParams.containsKey('retURL')){
			retUrl = map_urlParams.get('retURL');
		}
    }
    
    public pageReference save(){
    	upsert note;
    	pageReference pr;
    	if(retUrl != null){
    		pr = new pageReference(retUrl);
    	}
    	else{
    		pr = new pageReference('/' + note.Id);
    	}
    	pr.setRedirect(true);
    	return pr;
    }
    
    public pageReference cancel(){
    	pageReference pr;
    	if(retUrl != null){
    		pr = new pageReference(retUrl);
    	}
    	else if(note.Id != null){
    		pr = new pageReference('/' + note.Id);
    	}
    	else{
    		pr = new pageReference('/home/home.jsp');
    	}
    	pr.setRedirect(true);
    	return pr;
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