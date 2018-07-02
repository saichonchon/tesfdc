/**
 *  This class used to import csv file
 *
 @author Minghao Li
 @created 2014-11-21
 @version 1.0
 @since 30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
 * - Created
 */
public with sharing class CSD_CtrlImportCSVFile {
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public FileInfo fi{get;set;}
	public String jsons{get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=-   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public CSD_CtrlImportCSVFile(){
		this.fi = new FileInfo();
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    

    
    //********************************* -=BEGIN public methods=- **********************************
    /**
	* This method is used to parse csv file
	*
	@author Minghao Li
	@created 2014-11-21
	@version 1.0
	@since 30.0 (Force.com ApiVersion)
	*
	*
	@return	Pagereference
	*
	@changelog
	* 2014-11-21 Minghao Li <minghao.li@itbconsult.com>
	* - Created
	*/ 
	public Pagereference parseCsvFile(){	
		this.fi.isError = false;
		this.jsons = '';
		try{
			String csv = fi.nameFile.substring(fi.nameFile.lastIndexOf('.')+1, fi.nameFile.length());
			if(csv != fi.FILETYPE || fi.contentFile == null){ throw new CustomException(); }
		}catch(CustomException e){
			this.fi.isError = true;
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Please select csv file.'));
			return null;
		}
		try{
			this.jsons = fi.contentFile.toString();
			fi.contentFile = null;
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
		}
		return null;
	}
	//********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	//********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    public class CustomException extends Exception{}
	
	public class FileInfo{
		public final String COMMA = ',';
		public final String SEMICOLON = ';';
		public final String QUOTE = '"';
		public final String BLANK = ' ';
		public final String FILETYPE = 'csv';
		public final String NEWLINE = '\r\n';
		public final String SPLITTYPE = '___';
		
		public Boolean isError {get;set;}
		public transient String contentType{get;set;}
		public transient String nameFile{get;set;}
		public transient Blob contentFile{get;set;}
		public transient list<list<String>> list_pi{get;set;}
		
		
		public FileInfo(){
			this.isError = false;
		}
		
	}
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}