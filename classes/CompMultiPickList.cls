/**
 * The Controller of CompMutliPickList Component 
 * 
 * @author Shanliang Wu 
 * @created 2011-08-30
 * @version 1.0
 * @since 20.0
 * 
 * @changelog
 * 2011-11-22 Shanliang Wu <shanliang.wu@itbconsult.com>
 * - Migrated from old system  
 *
 */
public with sharing class CompMultiPickList {
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	/**
	 * list of select options bound to 'Chosen List' html element
	 */
	public List<Selectoption> selectedFields {get; set;}
    /**
	 * list of select options bound to 'Available List' html element
	 */
	public List<Selectoption> unSelectedFields {get; set;}
	/**
	 * dom id of hidden input html tag. The hidden input is used to submit 
	 */
	public String inputHiddenId {get; set;} 
	/**
	 * sepearator in value of hiddden input. default is ';'
	 */
	public String separator {get; set;}
	/**
	 * if sortable is set true, the order of fields in Chosen List will be kept by saving to databases. 
	 */
	public Boolean sortable {get; set;} 
	/**
	 * dom id bound to 'Chosen List' html element
	 */	
	 public String selectedListId = null;
	/**
	 * dom id bound to 'Available List' html element
	 */	public String unselectedListId = null;
	 
	 public String processid {get; set;} 
	 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	/**
	 * Constructor 
	 *
	 @author Shanliang Wu
	 @created 2011-08-30
	 @version 1.0
	 @since 20.0
	 *
	 @changelog
	 * 2011-08-30 Shanliang Wu <shanliang.wu@itbconsult.com>
	 * - Created
	 */ 
	public CompMultiPickList() {
	}
    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    //********************************* -=BEGIN public methods=- **********************************
	/**
	 * generate a random id. It will be bound to the html element of Chosen List on the componet.
	 * The format is 'selected' + random Long number
	 @author Shanliang Wu
	 @created 2011-08-30
	 @version 1.0
	 @since 20.0	 
	 *
	 @return a random id 
	 @changelog
	 * 2011-08-30 Shanliang Wu <shanliang.wu@itbconsult.com>
	 * - Created	 
	 *
	 */
	public String getSelectedListId() {
		if(selectedListId == null) {
			Long l = generateRandomLong(); 
			selectedListId = 'selected' + String.valueOf(l);
		}
		return selectedListId;
	}
	
	/**
	 * generate a random id. It will be bound to the html element of Available list on the componet.
	 * The format is 'selected' + random Long number
	 @author Shanliang Wu
	 @created 2011-08-30
	 @version 1.0
	 @since 20.0	 
	 *
	 @return a random id 
	 @changelog
	 * 2011-08-30 Shanliang Wu <shanliang.wu@itbconsult.com>
	 * - Created	 
	 *
	 */	
	public String getUnSelectedListId() {
		if(unSelectedListId == null) {
			Long l = generateRandomLong(); 
			unSelectedListId = 'unselected' + String.valueOf(l);
		}
		return unSelectedListId;		
	}	
	
	/**
	 * reeturn a list of select options. it will be used to initialize Chosen list on the componet.
	 * the lable of option is field label, the value of option is field api name
	 @author Shanliang Wu
	 @created 2011-08-30
	 @version 1.0
	 @since 20.0	 
	 *
	 @return  a list of select options of Chosen list on the componet
	 @changelog
	 * 2011-08-30 Shanliang Wu <shanliang.wu@itbconsult.com>
	 * - Created	 
	 *
	 */	
	public List<Field> getSelectedList() {
		return convert(selectedFields);
	}
	
	/**
	 * reeturn a list of select options. it will be used to initialize Available list on the componet.
	 * the lable of option is field label, the value of option is field api name
	 @author Shanliang Wu
	 @created 2011-08-30
	 @version 1.0
	 @since 20.0	 
	 *
	 @return  a list of select options of Available list on the componet
	 @changelog
	 * 2011-08-30 Shanliang Wu <shanliang.wu@itbconsult.com>
	 * - Created	 
	 *
	 */			
	public List<Field> getUnSelectedList() {
		return convert(unSelectedFields);
	}
	//********************************* -=END public methods=- ************************************

    //********************************* -=BEGIN private methods=- *********************************
	
	private Long generateRandomLong() {
		return Crypto.getRandomLong();
	}
	
	private List<Field> convert(List<Selectoption> options) {
		List<Field> list_fields = new List<Field>(); 
		if(options != null && options.size() > 0) {
			Field field; 
			for(Selectoption option: options) {
				field = new Field();
				field.label = option.getLabel(); 
				field.api = option.getValue(); 
				list_fields.add(field);
			}
		}
		return list_fields;
	}
    
    
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
	/**
	 * inner class to encapulate Sobject field
	 */
	public class Field {
		public String label {get;set;}
		public String api {get; set;}
		
		public Field() {
		}
	}
    //********************************* -=END inner classes=- *************************************	

}