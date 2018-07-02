/**
*	structure class
*
@author Bin Yu
@created 2012-03-01
@version 1.0
@since 23.0 (Force.com ApiVersion)
*
@changelog
* 2012-03-01 Bin Yu <bin.yu@itbconsult.com>
* - Created
*/

public class ClsOppForecastStructure { 
   
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	public String year {get; set;}
	public Boolean isDeleted {get; set;}	
	public List<PartForecastStructure> partForecasts {get; set;}  
	public ForecastStructure forecastStructure {get; set;}
	//public String saveString {get; set;}	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	/////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
	
    public ClsOppForecastStructure(String y) {  	
    	year = y;
  	    partForecasts = new list<PartForecastStructure>();   	
    } 
	/////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    
    
    //********************************* -=BEGIN public methods=- **********************************

    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************	
	public class PartForecastStructure{
		transient public Id partId {get; set;}
		transient public Decimal totalQuantity {get; set;}
		transient public Decimal totalAmount {get; set;}
		transient public Decimal salesPrice {get; set;}
		public List<Decimal> quantitys {get;set;}		
		
		public PartForecastStructure(){
			quantitys = new list<Decimal>();	
		} 	   	  	  		
	}		
		  
	public class ForecastStructure{
		transient public Id partId {get; set;}
		transient public Decimal totalQuantity {get; set;}
		transient public Decimal totalAmount {get; set;}
		//transient public Decimal salesPrice {get; set;}
		public List<ForecastItemStructure> editForecasts {get;set;}		
		
		public ForecastStructure(){
			editForecasts = new list<ForecastItemStructure>();	
		} 	   	  	  		
	}		
		  
    ///*>>>WrapperClass*/
	public class ForecastItemStructure{
		transient public Decimal quantity {get; set;} //according forecast quantity
		transient public Decimal amount {get; set;}
	}    
	///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
}