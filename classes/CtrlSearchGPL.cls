/**
 *  This class used to search GPL
 *
 @author Yinfeng Guo
 @created 2012-04-11
 @version 1.0
 @since 23.0 (Force.com ApiVersion)
 *
 @changelog
 * 2012-02-29 Yinfeng Guo <yinfeng.guo@itbconsult.com>
 * - Created
 */
public with sharing class CtrlSearchGPL {
   
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	//public Product_Hierarchy__c productHierarchy{set;get;}
	
	/**
	 * the gpl string value
	 */	
	public String gplString{set;get;}
	
	/**
	 * the variable to tell whether cbc1 is null or not
	 */		
	public Boolean cbc1NotNull{set;get;}
	
	/**
	 * the variable to tell us whether use PM to filter the search condition
	 */		
	public Boolean searchByPM{set;get;}
	
	/**
	 * this map contains the selectlist value, the selectlist will be used on vf page
	 */	
	public map<string, list<selectOption>> map_name_picklist {set;get;}

	/**
	 * the map's key for cbc1
	 */	
    public String cbc1MapKey{get;set;}
    
    /**
	 * the map's key for cbc2
	 */
    public String cbc2MapKey{get;set;}
    
    /**
	 * the map's key for product Manager
	 */
    public String productManagerMapKey{get;set;}
	
	/**
	 * the map's key for gpl
	 */
	public String gplMapKey{get;set;}
	
	/**
	 * the value for cbc1
	 */
	public String cbc1Value{get;set;}
	
	/**
	 * the value for cbc2
	 */
	public String cbc2Value{get;set;}
	
	/**
	 * the value for product Manager
	 */
	public String productManagerValue{get;set;}
	public Integer selectedIndex{get;set;}
	//public List<SelectOption> list_optionGPL{get;set;}
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END public members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=BEGIN private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -=END private members=- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    /////////////////////////////////// -=BEGIN CONSTRUCTOR=- /////////////////////////////////////
   /**
    * The contsructor
    *
    @author Yinfeng Guo
    @created 2012-04-10
    @version 1.0
    @since 23.0 (Force.com ApiVersion)
    *
    @changelog
    * 2012-04-10 YinFeng Guo <yinfeng.guo@itbconsult.com>
    * - Created
    */      
    public CtrlSearchGPL() {
	   	cbc1MapKey = 'CBC1';
	    cbc2MapKey = 'CBC2';
	    productManagerMapKey = 'ProductManager';
	    gplMapKey = 'GPL';
    	gplString = '';
    	cbc1NotNull = true;
    	searchByPM = false;
    	//cbc1Value = '--Select--';
    	//cbc2Value = '';
    	//productHierarchy = new Product_Hierarchy__c();
    	if(ApexPages.currentPage().getParameters().containsKey('index')){
    		selectedIndex = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
    	}   	
    	map_name_picklist = new map<string, list<selectOption>>();
    	map_name_picklist.put(cbc1MapKey, new list<selectOption>()); 
    	map_name_picklist.put(cbc2MapKey, new list<selectOption>()); 
    	map_name_picklist.put(productManagerMapKey, new list<selectOption>()); 
    	map_name_picklist.put(gplMapKey, new list<selectOption>()); 
    	GetCBC1();
    	//GetCBC2(Apex_Helper_Settings__c.getInstance('CBC1 Industrial').Value__c);
    	//GetProductManager(Apex_Helper_Settings__c.getInstance('CBC1 Industrial').Value__c);
    	GetCBC2('');
    	GetProductManager('');
    	
    	//cbc1Value = map_name_picklist.get(cbc1MapKey)[0].getValue();
		//cbc2Value = map_name_picklist.get(cbc2MapKey)[0].getValue();
		//productManagerValue = map_name_picklist.get(productManagerMapKey)[0].getValue();
	
    }

    /////////////////////////////////// -=END CONSTRUCTOR=- ///////////////////////////////////////
    

    
    //********************************* -=BEGIN public methods=- **********************************
	/**
	 * This method is used to search GPL according to CBC1, CBC2, Product Manager
	 *
	 @author Yin Feng
	 @created 2012-04-11
	 @version 1.0
	 @since 23.0
	 *
	 @return 			void
	 *
	 @changelog
	 * 2012-04-11 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
	public void SearchGPL(){
		map_name_picklist.get('GPL').clear();
		List<Product_Hierarchy__c> list_GPLs = new List<Product_Hierarchy__c>();
		List<SelectOption> list_optionGPL = new List<SelectOption>();
		//list_optionGPL = new List<SelectOption>();
		String query = 'Select Id, Name, GPL_Record__c, GPL_Description__c, Product_Manager__c, CBC1__c, CBC2__c,Product_Manager__r.Name  from Product_Hierarchy__c';
        /*string whereClause = ' where CBC1__c =  ' + '\'' + productHierarchy.CBC1__c +'\'';
        
        if(!SalesforceUtils.isNullOrEmpty(productHierarchy.CBC2__c)){
            whereClause = whereClause + ' and CBC2__c =  ' + '\'' +  productHierarchy.CBC2__c + '\'';
        }
        if(!SalesforceUtils.isNullOrEmpty(productHierarchy.Product_Manager__c)){
            whereClause = whereClause + ' and Product_Manager__c =  ' + '\'' +productHierarchy.Product_Manager__c + '\'';
        }
        */
        string whereClause = ' where CBC1__c =  ' + '\'' + cbc1Value +'\'';
        
        if(!SalesforceUtils.isNullOrEmpty(cbc2Value)){
            whereClause = whereClause + ' and CBC2__c =  ' + '\'' +  cbc2Value + '\'';
        }
        if(searchByPM && !SalesforceUtils.isNullOrEmpty(productManagerValue)){
            whereClause = whereClause + ' and Product_Manager__c =  ' + '\'' +productManagerValue + '\'';
        }
        whereClause = whereClause + ' order by Name ASC';
        query = query + whereClause;
        list_GPLs = database.query(query); 
        
        map<Id, String> map_GPL_GPLLabel = new map<Id, String>();
        map<Id, String> map_GPL_GPLName = new map<Id, String>();
    	String label;
    	String value;
    	for (Product_Hierarchy__c ph : list_GPLs)  {
			if(ph.GPL_Record__c != null && ph.GPL_Description__c != null){
				//map_GPL_GPLLabel.put(ph.Id, ph.Name + ' - ' + ph.GPL_Description__c);
				//map_GPL_GPLName.put(ph.Id, ph.Name);
				value = ph.id + ',' + ph.Name + ',' + ph.Product_Manager__r.Name;
		    	label = ph.Name + ' - ' + ph.GPL_Description__c;
		    	SelectOption option = new SelectOption(value,label);
				list_optionGPL.add(option);
			}
		}
		/*
		for (Product_Hierarchy__c ph : list_GPLs)  {
			if(ph.GPL_Record__c != null && ph.GPL_Description__c != null){
				map_GPL_GPLLabel.put(ph.Id, ph.Name + ' - ' + ph.GPL_Description__c);
				map_GPL_GPLName.put(ph.Id, ph.Name);
			}
		}
		for(Id id : map_GPL_GPLLabel.keySet()){
			if(map_GPL_GPLLabel.get(id) != null){
		    	value = id + ',' + map_GPL_GPLName.get(id);
		    	label = map_GPL_GPLLabel.get(id);
		    	SelectOption option = new SelectOption(value,label);
				list_optionGPL.add(option);
			}
		}
		*/
		if(!list_optionGPL.isEmpty()) map_name_picklist.put(gplMapKey, list_optionGPL);  
		else ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, system.Label.No_Records_Found)); 	
    }

	/**
	 * This method is used to reset values according to changed CBC1
	 *
	 @author Yinfeng Guo
	 @created 2012-04-11
	 @version 1.0
	 @since 23.0
	 *
	 @return 			void
	 *
	 @changelog
	 * 2012-04-11 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
    public void ChangeCBC1(){
    	map_name_picklist.get(gplMapKey).clear();
    	map_name_picklist.get(cbc2MapKey).clear();
    	map_name_picklist.get(productManagerMapKey).clear();
    	if(cbc1Value != null && cbc1Value != ''){
    		GetCBC2(cbc1Value);
    		cbc1NotNull = true;
    		GetProductManager(cbc1Value);
    	}
    	else{
    		GetCBC2('');
    		GetProductManager('');
    	}
    }
    
	/**
	 * This method is used to reset values according to changed CBC2
	 *
	 @author Yinfeng Guo
	 @created 2012-05-31
	 @version 1.0
	 @since 23.0
	 *
	 @return 			void
	 *
	 @changelog
	 * 2012-05-31 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
    public void ChangeCBC2(){
    	map_name_picklist.get(gplMapKey).clear();
    	//map_name_picklist.get(cbc2MapKey).clear();
    	map_name_picklist.get(productManagerMapKey).clear();
    	if(cbc2Value != null && cbc2Value != ''){
			GetProductManager(cbc2Value);
    	}
    	else{
    		if(cbc1Value != null && cbc1Value != '') GetProductManager(cbc1Value);
    		else GetProductManager('');
    	}
    }    
    //********************************* -=END public methods=- ************************************
    
    
    //********************************* -=BEGIN private methods=- *********************************
	/**
	 * This method is used to search CBC1
	 *
	 @author Yin Feng
	 @created 2012-04-11
	 @version 1.0
	 @since 23.0
	 *
	 @return 			void
	 *
	 @changelog
	 * 2012-04-11 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
    private void GetCBC1(){
    	List<SelectOption> list_optionCBC1 = new List<SelectOption>();
    	SelectOption optionFirstEmpty = new SelectOption('','--Select--');
		list_optionCBC1.add(optionFirstEmpty);
		if(Apex_Helper_Settings__c.getInstance('CBC1 Industrial') != null){
			SelectOption option = new SelectOption(Apex_Helper_Settings__c.getInstance('CBC1 Industrial').Value__c,Apex_Helper_Settings__c.getInstance('CBC1 Industrial').Description__c);
			list_optionCBC1.add(option);
		}
		if(Apex_Helper_Settings__c.getInstance('CBC1 Appliances') != null){
			SelectOption option = new SelectOption(Apex_Helper_Settings__c.getInstance('CBC1 Appliances').Value__c,Apex_Helper_Settings__c.getInstance('CBC1 Appliances').Description__c);
			list_optionCBC1.add(option);
		}
		if(Apex_Helper_Settings__c.getInstance('CBC1 Data Communications') != null){
			SelectOption option = new SelectOption(Apex_Helper_Settings__c.getInstance('CBC1 Data Communications').Value__c,Apex_Helper_Settings__c.getInstance('CBC1 Data Communications').Description__c);
			list_optionCBC1.add(option);
		}
		if(Apex_Helper_Settings__c.getInstance('CBC1 ADM') != null){
			SelectOption option = new SelectOption(Apex_Helper_Settings__c.getInstance('CBC1 ADM').Value__c,Apex_Helper_Settings__c.getInstance('CBC1 ADM').Description__c);
			list_optionCBC1.add(option);
		}
		SelectOption optionNull = new SelectOption('','-----');
		list_optionCBC1.add(optionNull);
    	String label;
    	String value;
   		List<AggregateResult> list_groupedResults = [SELECT CBC1__c, CBC1_Description__c  FROM Product_Hierarchy__c GROUP BY  CBC1__c, CBC1_Description__c];
   		for (AggregateResult ar : list_groupedResults)  {
		    if(ar.get('CBC1__c') != null && ar.get('CBC1_Description__c') != null && ((String)ar.get('CBC1__c')).trim() != '' && ((String)ar.get('CBC1_Description__c')).trim() != ''){
		    	if(
		    	(String)ar.get('CBC1_Description__c') != Apex_Helper_Settings__c.getInstance('CBC1 Industrial').Description__c
		    	&&
		    	(String)ar.get('CBC1_Description__c') != Apex_Helper_Settings__c.getInstance('CBC1 Appliances').Description__c
		    	&&
		    	(String)ar.get('CBC1_Description__c') != Apex_Helper_Settings__c.getInstance('CBC1 ADM').Description__c
		    	){
			    	value = (String)ar.get('CBC1__c');
			    	label = (String)ar.get('CBC1_Description__c');
			    	SelectOption option = new SelectOption(value,label);
					list_optionCBC1.add(option);	
		    	}
		    }
		}
		if(!list_optionCBC1.isEmpty()) map_name_picklist.put(cbc1MapKey, list_optionCBC1); 
    }

	/**
	 * This method is used to search CBC2 according to CBC1 code
	 *
	 @author Yin Feng
	 @created 2012-04-11
	 @version 1.0
	 @since 23.0
	 *
	 @param cbc1Code    	CBC1 code
	 *
	 @return 				void
	 *
	 @changelog
	 * 2012-04-11 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	 	
    private void GetCBC2(String cbc1Code){
    	if(cbc1Code != null){
    		List<SelectOption> list_optionCBC2 = new List<SelectOption>();
    		SelectOption optionFirstEmpty = new SelectOption('','--Select--');
			list_optionCBC2.add(optionFirstEmpty);
    		if(cbc1Code != ''){
	    		String label;
		    	String value;
		   		List<AggregateResult> list_groupedResults = [SELECT CBC2__c, CBC2_Description__c  FROM Product_Hierarchy__c WHERE CBC1__c =: cbc1Code GROUP BY  CBC2__c, CBC2_Description__c];
				for (AggregateResult ar : list_groupedResults)  {
				    if(ar.get('CBC2__c') != null && ar.get('CBC2_Description__c') != null && ((String)ar.get('CBC2__c')).trim() != '' && ((String)ar.get('CBC2_Description__c')).trim() != ''){
				    	value = (String)ar.get('CBC2__c');
				    	label = (String)ar.get('CBC2_Description__c');
				    	SelectOption option = new SelectOption(value,label);
						list_optionCBC2.add(option);
				    }
				}	
    		}
	    	
			if(!list_optionCBC2.isEmpty()) map_name_picklist.put(cbc2MapKey, list_optionCBC2); 
    	}
    	
    }
    
	/**
	 * This method is used to search Product Manager according to CBC1 code
	 *
	 @author Yin Feng
	 @created 2012-04-11
	 @version 1.0
	 @since 23.0
	 *
	 @param cbc1Code    	CBC1 code
	 *
	 @return 				void
	 *
	 @changelog
	 * 2012-04-11 Yinfeng Guo <yinfeng.guo@itbconsult.com>
	 * - Created
	 */	    
    private void GetProductManager(String cbc1Code){
    	if(cbc1Code != null){
	    	List<SelectOption> list_optionProductManager = new List<SelectOption>();
	    	SelectOption optionFirstEmpty = new SelectOption('','--Select--');
			list_optionProductManager.add(optionFirstEmpty);
	    	map<Id, String> map_id_name = new map<Id, String>();
	    	String label;
	    	String value;
	    	List<Product_Hierarchy__c> list_productManagers;
	    	if(cbc1Code != ''){
	    		list_productManagers = [SELECT Product_Manager__c, Product_Manager__r.Name  FROM Product_Hierarchy__c WHERE CBC1__c =: cbc1Code];
	    	}
	    	else if(cbc1Code == ''){
	    		list_productManagers = [SELECT Product_Manager__c, Product_Manager__r.Name  FROM Product_Hierarchy__c];
	    	}
	    	if(list_productManagers != null && !list_productManagers.isEmpty()){
		    	for (Product_Hierarchy__c ph : list_productManagers)  {
					if(ph.Product_Manager__c != null && ph.Product_Manager__r.Name != null){
						map_id_name.put(ph.Product_Manager__c, ph.Product_Manager__r.Name);
					}
				}	
	    	}
			for(Id uid : map_id_name.keySet()){
				if(map_id_name.get(uid) != null){
			    	value = uid;
			    	label = map_id_name.get(uid);
			    	SelectOption option = new SelectOption(value,label);
					list_optionProductManager.add(option);
				}
			}
			if(!list_optionProductManager.isEmpty()) map_name_picklist.put(productManagerMapKey, list_optionProductManager); 
    	}
    }
    //********************************* -=END private methods=- ***********************************
    
    
    //********************************* -=BEGIN help functions=- **********************************
    //********************************* -=END help functions=- ************************************
    
    //********************************* -=BEGIN inner classes=- ***********************************
    ///*>>>WrapperClass*/
    ///*<<<WrapperClass*/
    //********************************* -=END inner classes=- *************************************
 
}