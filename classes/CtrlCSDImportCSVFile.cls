/**
 *  This class used to import csv file
 *
 @author Minghao Li
 @created 2014-09-23
 @version 1.0
 @since 30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-09-23 Minghao Li <minghao.li@itbconsult.com>
 * - Created
 */
public with sharing class CtrlCSDImportCSVFile {
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	public FileInfo fi{get;set;}
	public String jsons{get;set;}
	public String jsonhead{get;set;}
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=-   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	public CtrlCSDImportCSVFile(){
		this.fi = new FileInfo();
	}
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    

    
    //********************************* -=BEGIN public methods=- **********************************
    /**
	* This method is used to parse csv file
	*
	@author Minghao Li
	@created 2014-12-13
	@version 1.0
	@since 30.0 (Force.com ApiVersion)
	*
	*
	@return	Pagereference
	*
	@changelog
	* 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
	* - Created
	*/ 
	public Pagereference parseCsvFile(){	
		this.fi.isError = false;
		this.jsonhead = '[]';
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
			/*
			String fileString = fi.contentFile.toString();
			fi.list_pi = parseCSV(fileString, false);

			this.jsonhead = Json.serialize(fi.list_pi.get(0));
			if(fi.list_pi.size() > 0){
				fi.list_pi.remove(0);
			}
			this.jsons = Json.serialize(fi.list_pi);
			*/
			this.jsons = fi.contentFile.toString();
			fi.contentFile = null;
			//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info, 'this.jsons :: ' + this.jsons));
		}catch(Exception e){
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
		}
		return null;
	}
	//********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    /**
	* This method is used to parse csv file
	*
	@author Minghao Li
	@created 2014-09-24
	@version 1.0
	@since 30.0 (Force.com ApiVersion)
	*
	*
	@return	Pagereference
	*
	@changelog
	* 2014-09-24 Minghao Li <minghao.li@itbconsult.com>
	* - Created
	*/
    private List<List<String>> parseCSV(String contents,Boolean skipHeaders) {
    	
    	this.fi.isError = false;
    	
        List<List<String>> allFields = new List<List<String>>();
        /*contents = contents.replaceAll(',"""',',"DBLQT').replaceall('""",','DBLQT",');
        contents = contents.replaceAll('""','DBLQT');
        List<String> lines = new List<String>();
        
        try {
        	// using carriage return accomodates Linux	(LF '\n' , ASCII code 10, 0x0A.)
        	// using carriage return accomodates windows, unix, and mac files (CR '\r', ASCII 13, 0x0D.)
        	String s = '\r\n';
        	if(contents.contains(s)){
	            lines = contents.split(s); 
        	}else{
        		s = contents.contains('\n') ? '\n' : '\r';
        		lines = contents.split(s); 
        	}
        } catch (System.ListException e) {
        	this.fi.isError = true;
        	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        
        
        Integer num = 0;
        for(String line: lines) {
            if (line.replaceAll(',','').trim().length() == 0) break;	// check for blank CSV lines (only commas)
            
            List<String> fields = line.split(',');  
            List<String> cleanFields = new List<String>();
            String compositeField;
            Boolean makeCompositeField = false;
            for(String field: fields) {
                if (field.startsWith('"') && field.endsWith('"')) {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                } else if (field.startsWith('"')) {
                    makeCompositeField = true;
                    compositeField = field;
                } else if (field.endsWith('"')) {
                    compositeField += ',' + field;
                    cleanFields.add(compositeField.replaceAll('DBLQT','"'));
                    makeCompositeField = false;
                } else if (makeCompositeField) {
                    compositeField +=  ',' + field;
                } else {
                    cleanFields.add(field.replaceAll('DBLQT','"'));
                }
            }
            
            allFields.add(cleanFields);
        }
        if (skipHeaders) allFields.remove(0);*/
        return allFields;       
    }
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