/*------------------------------------------------------------
Author:        Tangyong Li <tangyong.li@capgemini.com>
Description:   Controller class to load Opportunity_Part__c records and save changes in EditAllforopportunity.page.
               The user story number is W-00018.
Inputs:        "stdCtrl" - ApexPages.standardController of Opportunity
Test Class:    EditAllforopportunityTest
History
2017-08-11     Tangyong Li <tangyong.li@capgemini.com> Created
------------------------------------------------------------*/
public class EditAllforopportunity{    
    public Boolean saleshistory       {get;set;}
    public Boolean renderedTotal      {get;set;}
    public Boolean Priceflag1         {get;set;}
    public Boolean renderedTotaldisc  {get;set;}
    public Id      exlID              {get;set;}
    public string  SelectedStatus     {get;set;}
    public String  prodSearchStatus   {get;set;}
    public String  prodSearch         {get;set;}
    public String  myStatus           {get;set;}
    public String  returnOppName      {get;set;}
    public String SearchCriteria      {get;set;}
    public String GPLCode             {get;set;}
    public String GPLDescription      {get;set;}
    public List<opportunitylineitem> opplineitemlist{get;set;}
    public List<Opportunity_Part__c> list_oppyPart{get;set;}
    public List<opportunitylineitem> historyopplineitemlist{get;set;}        
    public Boolean discountflag1=false;    
    public Boolean Priceflag2=false; 
    public String SearchCriteria1;
    public String SearchCriteriastatus;  
    public Opportunity oppy {get; set;}   
    
    public Integer renderpageblock=0; 
    List<Opportunitylineitem> opp;
    List<Opportunitylineitem> seq;
    Set<String> ProdLine=new Set<String>();   
    List<prodlinewrapper> prodlinelist  = new List<prodlinewrapper> ();
    List<prodlinewrapper> prodlinelist1 = new List<prodlinewrapper> ();
    public List<SelectOption> options   = new List<SelectOption>    ();
    List<SelectOption> options1         = new List<SelectOption>    ();         
    PageReference pageRef;      
    SelectOption searchstr1;
    String searchstr;
    String searchstrstatus;
    Id backid=apexpages.currentPage().getParameters().get('Id');  
    
    public decimal dec_totalValue {get; set;}
    public decimal dec_totalCost {get; set;}
    public String str_totalGM {get; set;}
    public String str_thousandSep {get; set;}
    public String str_decimalSep {get; set;}
    
    private Map<String,String> map_GPLCodeDesc_GPLCode = new Map<String,String>();
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to load Opportunity_Part__c Status
    Inputs:        
    Returns:       List<SelectOption> - the list of SelectOption objects
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public List<SelectOption> getprodlinedescpicklistvaluesstatus(){
        options1.clear(); 
        Schema.DescribeFieldResult fieldResult = Opportunity_Part__c.Status__c.getDescribe();    
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options1.add(new SelectOption('-None-', '-None-'));
        for( Schema.PicklistEntry f : ple){
            if(f.getValue() == 'Won' || f.getValue() == 'Lost' || f.getValue() == 'No Bid' || f.getValue() == 'Pending') {
                options1.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }       
        return options1;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   method to format number field
    Inputs:        
    Returns:       
    History
    2018-04-19     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void setThousandAndDecimalSep(){
        Decimal value = 1000.10;
        String formattedValue = value.format();
        String thousandSep = formattedValue.substring(1,2);
        String decimalSep = formattedValue.substring(5,6);
        this.str_thousandSep = thousandSep;
        this.str_decimalSep = decimalSep;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to load Opportunity_Part__c Status
    Inputs:        
    Returns:       List<SelectOption> - the list of SelectOption objects
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public List<selectOption> getstatus() {
        List<selectOption> options = new List<selectOption>();
        options.add(new SelectOption('-None-', '-None-'));
        options.add(new SelectOption('Pending','Pending')); 
        options.add(new SelectOption('Won','Won'));
        options.add(new SelectOption('Lost','Lost'));
        options.add(new SelectOption('No Bid','No Bid'));
        return options;
    }
     
    public String getsearchitem() {
        System.debug('countries-->'+SearchCriteria1);
        return SearchCriteria1;            
    }
            
    public void setsearchitem(String searchstr) {
        this.SearchCriteria1= searchstr;
    }
  
    public void setsearchitem1(String searchstr){
        this.SearchCriteria1= searchstr;
    }
  
    public String getsearchitemstatus() {
        System.debug('countries-->'+SearchCriteriastatus);
        return SearchCriteriastatus;            
    }
  
    public void setsearchitemstatus(String searchstrstaus) {
        this.SearchCriteriastatus= searchstrstatus;
    }
              
    public void setprodlinedescpicklistvalues(string o){
        searchstr=o;
    }
  
    public void setprodlinedescpicklistvaluesstatus(string o){
        searchstrstatus=o;
    }
    
    Id i;
    public ApexPages.StandardController stdCtrl { get; set; }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   The contsructor
    Inputs:        "stdCtrl" - ApexPages.standardController of Opportunity
    Returns:       
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public EditAllforopportunity(ApexPages.StandardController controller) {
        stdCtrl = controller;    
        saleshistory=false;
        renderedTotal = true;
        renderedTotaldisc = false;
        renderpageblock = 0;     
        i=controller.getid();
        exlID = i;
        opportunity varNameOpp=[select id,name,Percentage__c,Quote_Type__c,ERP_For_Pricing__c from opportunity where id=:i];
        oppy = varNameOpp;
        varNameOpp.Percentage__c='0';
        returnOppName=varNameOpp.name;
        
        if(list_oppyPart == null){
            list_oppyPart = [select id,Part_Name__c,Total_Cost__c,Part__r.Product_Hierarchy__r.Name,Part__r.Product_Hierarchy__r.GPL_Description__c,UnitPrice__c,Opportunity__r.AccountID,Quantity__c,ServiceDate__c,Part__r.name,Offered_Price__c,Part__r.Description__c,CurrencyIsoCode,Opportunity__r.CurrencyIsoCode,
                                Customer_Part_Number1__c,Customer_Part_Number1__r.name,Sequence_No__c,Discount_A__c,Discount_B__c,Product_Description__c,Standard_Cost__c,Cost_Set_3__c,Customer_Part_Number__c,sales_price__c,
                                Discount_C__c,DiscountA_A__c,DiscountB_B__c,DiscountC_C__c,Total_Less_Disc_A__c,Total_Less_Disc_B__c,Total_Less_Disc_C__c,Margin_A__c,Margin_B__c,Margin_C__c,Status__c,ANZ_Quantity__c,Lead_Time__c,
                                Gross_Margin_Cost_set_75__c, Ex_Stock__c,No_Bid__c,TotalPrice__c,Lost_Reason__c,Curr_CS_75__c,Prior_Month_Cost_Se_t75__c,Qty_PIP__c,Reason_Lost_Comments__c,NDR_Item_Number__c,Seq_No__c,Product_Line__c,
                                Drawing_Number__c,Margin_CS75__c,Part_Number__c,Min_Order_Qty__c,Primary_Pack_Quantity__c,Stock_UOM__c,Code_for_unit_of_measurement__c,Pieces_in_Pack__c,Drawing_Revision_Number__c,Total_Price__c,
                                Contract_Sfty_Stk_Qty__c,Opportunity__r.Safety_Stock__c,ANZ_Percentage__c,Check_Unit_Price__c,NDR_Competitor_Name__c,NDR_Competitor_Part_Number__c,Competitor_Price__c,Opportunity__r.Quote_Type__c,
                                part__r.Pieces_in_Pack__c,ANZ_Item_Id__c,Comments__c,Part__r.Proposal_Part__c,Part__r.RPN_Part__c ,Part__r.RPN_Description__c,Proposal_Part_Name_Override__c,NDR_Customer_Comments__c
                                from Opportunity_Part__c where Opportunity__c=:i order by NDR_Item_Number__c];
            
            list_oppyPart = customSortOppyPart(list_oppyPart);
            list_oppyPart = populateOppyPartFields(list_oppyPart);
            setTotalCostAndValue();
            
            for(Opportunity_Part__c opp: list_oppyPart){
                system.debug('====product1'+opp.product_description__c);
                system.debug('====product2'+opp.Part_Number__c);
                
                if(opp.No_Bid__c == TRUE){
                    opp.ANZ_Quantity__c = 0;
                    opp.Standard_Cost__c = 0;
                }
                if(opp.Status__c == null) {
                    opp.Status__c = '-None-';
                }
            }

        }
        setThousandAndDecimalSep();
        pageRef = new PageReference('/'+i);
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to update the Opportunity_Part__c records on the page and reload.
    Inputs:        
    Returns:       pagereference
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public pagereference Save2(){
        try{
            List<Opportunity_Part__c> o = new List<Opportunity_Part__c>();
            
            //added by Tangyong Li 2018-04-17
            String str_query = 'SELECT ';
            Schema.FieldSet managePartFieldsForSave = Schema.SObjectType.Opportunity_Part__c.fieldSets.ManagePartFieldsForSave;
            for(Schema.FieldSetMember f : managePartFieldsForSave.getFields()){
                str_query += f.getFieldPath() + ', ';
            }
            str_query += 'Id FROM Opportunity_Part__c Where Opportunity__c =: i';
            list<Opportunity_Part__c> list_originalOppyParts = Database.query(str_query);
            //end
            
            for(Opportunity_Part__c o1 : list_oppyPart){ 
                if( (o1.Qty_PIP__c !=null && o1.Qty_PIP__c !=0 ) && (o1.Pieces_in_Pack__c != null) ){ 
                    if(o1.Pieces_in_Pack__c == 0){
                        o1.Pieces_in_Pack__c=1;
                    }
                    o1.ANZ_Quantity__c = o1.Qty_PIP__c/o1.Pieces_in_Pack__c;
                    o1.ANZ_Quantity__c = o1.ANZ_Quantity__c.round(System.RoundingMode.CEILING);
                }
                system.debug('==sta'+o1.status__c);
                system.debug('==ANZ '+o1.Reason_Lost_Comments__c);
                if(o1.ANZ_Quantity__c==0){
                    o1.UnitPrice__c=0;
                }else{
                } 
                if(o1.Product_Line__c=='Null'){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'product Line should not be Null'));
                    return null;
                }
                if(o1.Status__c == '-None-') {
                    o1.Status__c = null;
                }
                
                //added by Tangyong Li 2017-12-14 
                if(o1.Min_Order_Qty__c != null && o1.Quantity__c < o1.Min_Order_Qty__c) {
                    o1.Quantity__c = o1.Min_Order_Qty__c;
                }
                
                //o.add(o1);     
            }
            OpportunityTrgHandler.isEditingOpportunityPartState = true;
            
            //Modified by Tangyong Li 2018-04-17
            map<Id, Opportunity_Part__c> map_oppyPartId_originalOppyParts = new map<Id, Opportunity_Part__c>(list_originalOppyParts);
            for(Opportunity_Part__c oppyPart : list_oppyPart){
                Opportunity_Part__c updatePart; 
                for(Schema.FieldSetMember f : managePartFieldsForSave.getFields()){
                    if(oppyPart.get(f.getFieldPath()) != map_oppyPartId_originalOppyParts.get(oppyPart.Id).get(f.getFieldPath())) {
                        if(updatePart == null) {
                            updatePart = new Opportunity_Part__c();
                            updatePart.Id = oppyPart.Id;
                        }
                        updatePart.put(f.getFieldPath(), oppyPart.get(f.getFieldPath()));
                    }
                }
                if(updatePart != null) {
                    o.add(updatePart);
                }
            }
            if(o.size() > 0) {
                update o;
            }
            //end
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            //ErrorLogging.Log(e);
            String vStrError = '';
            vStrError += 'Error Type = ' + e.getTypeName() + 
            ' Error Line = ' + e.getLineNumber() + '' + 
            ' Error Stack = ' + e.getStackTraceString() + 
            ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        }
        String pid =ApexPages.currentPage().getParameters().get('id');
        pagereference pagref = new pagereference('/apex/EditAllforopportunity?id='+i);
        pagref.setRedirect(true);
        return pagref ;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to update the Opportunity_Part__c status.
    Inputs:        
    Returns:       pagereference
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public pagereference Massupdate(){
        //List<Opportunity_Part__c> o = new List<Opportunity_Part__c>();
        system.debug('Selectedstatus:::  ' + Selectedstatus);
        for(Opportunity_Part__c mass1 : list_oppyPart){
            if(mass1.status__c != null){        
                mass1.status__c=Selectedstatus;
            }
        }
        save2();
        pagereference Massupdate = new pagereference('/apex/EditAllforopportunity?id='+i);     
        return null;
    }
    
    public pagereference saverefresh(){  
        try {
            for(Opportunity_Part__c oppyPart : list_oppyPart) {
                if(oppyPart.offered_price__c != null && oppyPart.offered_price__c != 0) {
                    decimal targetPrice = oppyPart.offered_price__c + oppyPart.offered_price__c*(Decimal.valueOf(oppy.Percentage__c))*0.01;
                    oppyPart.offered_price__c = targetPrice.setScale(2);
                }
            }
            if(list_oppyPart.size() > 0) {
                update list_oppyPart;
            }
            update oppy;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage()));
            //ErrorLogging.Log(e);
            String vStrError = '';
            vStrError += 'Error Type = ' + e.getTypeName() + 
            ' Error Line = ' + e.getLineNumber() + '' + 
            ' Error Stack = ' + e.getStackTraceString() + 
            ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        }
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Sucessfully Sumbitted the Unit Price%'));
        return Apexpages.currentPage(); 
    }
   
    public void ZeroPercentage(){
        try{
            opportunity varNameOpp=[select id,name,Percentage__c,Check_Unit_Price__c from opportunity where id=:i];
            
            if(varNameOpp.Check_Unit_Price__c==true){
                varNameOpp.Percentage__c='0';
                varNameOpp.Check_Unit_Price__c=false;
                system.debug('=====per1'+varNameOpp.Percentage__c);  
                update varNameOpp; 
            }
        }catch(Exception e){
            //ErrorLogging.Log(e);
            String vStrError = '';
            vStrError += 'Error Type = ' + e.getTypeName() + 
            ' Error Line = ' + e.getLineNumber() + '' + 
            ' Error Stack = ' + e.getStackTraceString() + 
            ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        }
    } 
    
    /*
    public void saveAndRefresh(){
        try{
            List<Opportunity_Part__c> o = new List<Opportunity_Part__c>();
            for(Opportunity_Part__c o1 : list_oppyPart){ 
                //Calculation for Quantity based on Quantity PIP/PIP
                if(o1.Qty_PIP__c !=null && o1.Pieces_in_Pack__c != null){
                    o1.ANZ_Quantity__c = o1.Qty_PIP__c/o1.Pieces_in_Pack__c; 
                    o1.ANZ_Quantity__c = o1.ANZ_Quantity__c.round(System.RoundingMode.CEILING);
                }
                if(o1.ANZ_Quantity__c==0){
                    o1.Quantity__c = 1;
                    o1.UnitPrice__c = 0;
                }else{
                    o1.Quantity__c = o1.ANZ_Quantity__c;
                }
                o.add(o1);
            }

            OpportunityTrgHandler.isEditingOpportunityPartState = true;
            update o;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, e.getMessage()));
            ErrorLogging.Log(e);
            String vStrError = '';
            vStrError += 'Error Type = ' + e.getTypeName() + 
            ' Error Line = ' + e.getLineNumber() + '' + 
            ' Error Stack = ' + e.getStackTraceString() + 
            ' Error Message = ' + e.getMessage();
            SalesforceException.putError('--- The following exception has occurred:', '', vStrError, SalesforceConstant.strSfdc,                   
                SalesforceConstant.strError, '', '', '', '5','','','Exception', e.getLineNumber() + '',e.getStackTraceString());
        }
    }*/
    
    public List<SelectOption> getGPLCodeDescMap(){
        List<SelectOption> list_GPLCodeDescOptions = new List<SelectOption>();
        list_GPLCodeDescOptions.add(new SelectOption('-None-','-None-'));
        map_GPLCodeDesc_GPLCode = new Map<String,String>();
        for(Opportunity_Part__c oppyPart : [SELECT Part__r.Product_Hierarchy__r.Name,Part__r.Product_Hierarchy__r.GPL_Description__c,UnitPrice__c,Opportunity__r.AccountID,Quantity__c,ServiceDate__c,Part__r.name,Offered_Price__c,Part__r.Description__c 
                                            FROM Opportunity_Part__c 
                                            WHERE Opportunity__c =: i]){
            if(oppyPart.Part__r.Product_Hierarchy__r.Name != null){
                map_GPLCodeDesc_GPLCode.put(oppyPart.Part__r.Product_Hierarchy__r.Name + '-' + oppyPart.Part__r.Product_Hierarchy__r.GPL_Description__c, oppyPart.Part__r.Product_Hierarchy__r.Name);
            }
        }
        for(String GPLCodeDesc : map_GPLCodeDesc_GPLCode.keySet()){
            list_GPLCodeDescOptions.add(new SelectOption(map_GPLCodeDesc_GPLCode.get(GPLCodeDesc), GPLCodeDesc));
        }
        list_GPLCodeDescOptions.sort();
        return list_GPLCodeDescOptions;
    }
    
    /* This Method is used to Search Product line items based on Search Input */
    public void searchByGPLCode(){ 
        String str_query = 'select id,Part_Name__c,Total_Cost__c,Part__r.Product_Hierarchy__r.Name,Part__r.Product_Hierarchy__r.GPL_Description__c,UnitPrice__c,Opportunity__r.AccountID,Quantity__c,ServiceDate__c,Part__r.name,Offered_Price__c,Part__r.Description__c,CurrencyIsoCode,Opportunity__r.CurrencyIsoCode,'
                         + 'Customer_Part_Number1__c,Customer_Part_Number1__r.name,Sequence_No__c,Discount_A__c,Discount_B__c,Product_Description__c,Standard_Cost__c,Cost_Set_3__c,Customer_Part_Number__c,sales_price__c,'
                         + 'Discount_C__c,DiscountA_A__c,DiscountB_B__c,DiscountC_C__c,Total_Less_Disc_A__c,Total_Less_Disc_B__c,Total_Less_Disc_C__c,Margin_A__c,Margin_B__c,Margin_C__c,Status__c,ANZ_Quantity__c,Lead_Time__c,'
                         + 'Gross_Margin_Cost_set_75__c, Ex_Stock__c,No_Bid__c,TotalPrice__c,Lost_Reason__c,Curr_CS_75__c,Prior_Month_Cost_Se_t75__c,Qty_PIP__c,Reason_Lost_Comments__c,NDR_Item_Number__c,Seq_No__c,Product_Line__c,'
                         + 'Drawing_Number__c,Margin_CS75__c,Part_Number__c,Min_Order_Qty__c,Primary_Pack_Quantity__c,Stock_UOM__c,Code_for_unit_of_measurement__c,Pieces_in_Pack__c,Drawing_Revision_Number__c,Total_Price__c,'
                         + 'Contract_Sfty_Stk_Qty__c,Opportunity__r.Safety_Stock__c,ANZ_Percentage__c,Check_Unit_Price__c,NDR_Competitor_Name__c,NDR_Competitor_Part_Number__c,Competitor_Price__c,Opportunity__r.Quote_Type__c,'
                         + 'part__r.Pieces_in_Pack__c,ANZ_Item_Id__c,Comments__c,Part__r.Proposal_Part__c,Proposal_Part_Name_Override__c,NDR_Customer_Comments__c '
                         + ' from Opportunity_Part__c where Opportunity__c=:i ';
        if(String.isNotBlank(GPLCode) && GPLCode != '-None-') {
            str_query += ' AND Part__r.Product_Hierarchy__r.Name like \'%' + GPLCode + '%\'';
        }
        str_query += '  order by NDR_Item_Number__c';
        list_oppyPart = dataBase.query(str_query);
        
        list_oppyPart = customSortOppyPart(list_oppyPart);
        list_oppyPart = populateOppyPartFields(list_oppyPart);
        setTotalCostAndValue();
    }
    
    /* This Method is used to Search Product line items based on Search Input */
    public void searchGPLDescription(){ 
        String str_query = 'select id,Part_Name__c,Total_Cost__c,Part__r.Product_Hierarchy__r.Name,Part__r.Product_Hierarchy__r.GPL_Description__c, UnitPrice__c,Opportunity__r.AccountID,Quantity__c,ServiceDate__c,Part__r.name,Offered_Price__c,Part__r.Description__c,CurrencyIsoCode,Opportunity__r.CurrencyIsoCode,'
                         + 'Customer_Part_Number1__c,Customer_Part_Number1__r.name,Sequence_No__c,Discount_A__c,Discount_B__c,Product_Description__c,Standard_Cost__c,Cost_Set_3__c,Customer_Part_Number__c,sales_price__c,'
                         + 'Discount_C__c,DiscountA_A__c,DiscountB_B__c,DiscountC_C__c,Total_Less_Disc_A__c,Total_Less_Disc_B__c,Total_Less_Disc_C__c,Margin_A__c,Margin_B__c,Margin_C__c,Status__c,ANZ_Quantity__c,Lead_Time__c,'
                         + 'Gross_Margin_Cost_set_75__c, Ex_Stock__c,No_Bid__c,TotalPrice__c,Lost_Reason__c,Curr_CS_75__c,Prior_Month_Cost_Se_t75__c,Qty_PIP__c,Reason_Lost_Comments__c,NDR_Item_Number__c,Seq_No__c,Product_Line__c,'
                         + 'Drawing_Number__c,Margin_CS75__c,Part_Number__c,Min_Order_Qty__c,Primary_Pack_Quantity__c,Stock_UOM__c,Code_for_unit_of_measurement__c,Pieces_in_Pack__c,Drawing_Revision_Number__c,Total_Price__c,'
                         + 'Contract_Sfty_Stk_Qty__c,Opportunity__r.Safety_Stock__c,ANZ_Percentage__c,Check_Unit_Price__c,NDR_Competitor_Name__c,NDR_Competitor_Part_Number__c,Competitor_Price__c,Opportunity__r.Quote_Type__c,'
                         + 'part__r.Pieces_in_Pack__c,ANZ_Item_Id__c,Comments__c,Part__r.Proposal_Part__c,Proposal_Part_Name_Override__c,NDR_Customer_Comments__c '
                         + ' from Opportunity_Part__c where Opportunity__c=:i ';
        
        if(GPLDescription != null && GPLDescription != '') {
            str_query += ' AND Part__r.Product_Hierarchy__r.GPL_Description__c like \'%'+GPLDescription+'%\'';
        }
        str_query += ' ORDER BY NDR_Item_Number__c';
        list_oppyPart = dataBase.query(str_query);
        
        list_oppyPart = customSortOppyPart(list_oppyPart);
        list_oppyPart = populateOppyPartFields(list_oppyPart);
        setTotalCostAndValue();
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to get the Opportunity_Part__c records with status filter.
    Inputs:        
    Returns:       
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void Search1(){
        String str_Query = 'select id,Part_Name__c,Total_Cost__c,Part__r.Product_Hierarchy__r.Name,Part__r.Product_Hierarchy__r.GPL_Description__c,UnitPrice__c,Opportunity__r.AccountID,Quantity__c,ServiceDate__c,Part__r.name,Offered_Price__c,Part__r.Description__c,CurrencyIsoCode,Opportunity__r.CurrencyIsoCode,' +
                            'Customer_Part_Number1__c,Customer_Part_Number1__r.name,Sequence_No__c,Discount_A__c,Discount_B__c,Product_Description__c,Standard_Cost__c,Cost_Set_3__c,Customer_Part_Number__c,sales_price__c,' +
                            'Discount_C__c,DiscountA_A__c,DiscountB_B__c,DiscountC_C__c,Total_Less_Disc_A__c,Total_Less_Disc_B__c,Total_Less_Disc_C__c,Margin_A__c,Margin_B__c,Margin_C__c,Status__c,ANZ_Quantity__c,Lead_Time__c,' +
                            'Gross_Margin_Cost_set_75__c, Ex_Stock__c,No_Bid__c,TotalPrice__c,Lost_Reason__c,Curr_CS_75__c,Prior_Month_Cost_Se_t75__c,Qty_PIP__c,Reason_Lost_Comments__c,NDR_Item_Number__c,Seq_No__c,Product_Line__c,' +
                            'Drawing_Number__c,Margin_CS75__c,Part_Number__c,Min_Order_Qty__c,Primary_Pack_Quantity__c,Stock_UOM__c,Code_for_unit_of_measurement__c,Pieces_in_Pack__c,Drawing_Revision_Number__c,Total_Price__c,' +
                            'Contract_Sfty_Stk_Qty__c,Opportunity__r.Safety_Stock__c,ANZ_Percentage__c,Check_Unit_Price__c,NDR_Competitor_Name__c,NDR_Competitor_Part_Number__c,Competitor_Price__c,Opportunity__r.Quote_Type__c,' +
                            'part__r.Pieces_in_Pack__c,ANZ_Item_Id__c,Comments__c,Part__r.Proposal_Part__c,Proposal_Part_Name_Override__c,NDR_Customer_Comments__c ' +
                            ' from Opportunity_Part__c where Opportunity__c=: i ';
        if(String.isNotBlank(GPLCode) && GPLCode != '-None-') {
            str_Query += ' AND Part__r.Product_Hierarchy__r.Name like \'%' + GPLCode + '%\'';
        }
        if(String.isNotBlank(prodSearchStatus) && prodSearchStatus != '-None-'){
            str_Query += 'AND Status__c =: prodSearchStatus';
        }
        str_Query += ' order by NDR_Item_Number__c';
        list_oppyPart = Database.query(str_Query);
        list_oppyPart = customSortOppyPart(list_oppyPart);  
        list_oppyPart = populateOppyPartFields(list_oppyPart);
        setTotalCostAndValue();
    }    
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to get all the Opportunity_Part__c related to the opportunity.
    Inputs:        
    Returns:       
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void showAll(){
        list_oppyPart = [select id,Part_Name__c,Total_Cost__c,Part__r.Product_Hierarchy__r.Name,Part__r.Product_Hierarchy__r.GPL_Description__c,UnitPrice__c,Opportunity__r.AccountID,Quantity__c,ServiceDate__c,Part__r.name,Offered_Price__c,Part__r.Description__c,CurrencyIsoCode,Opportunity__r.CurrencyIsoCode,
                            Customer_Part_Number1__c,Customer_Part_Number1__r.name,Sequence_No__c,Discount_A__c,Discount_B__c,Product_Description__c,Standard_Cost__c,Cost_Set_3__c,Customer_Part_Number__c,sales_price__c,
                            Discount_C__c,DiscountA_A__c,DiscountB_B__c,DiscountC_C__c,Total_Less_Disc_A__c,Total_Less_Disc_B__c,Total_Less_Disc_C__c,Margin_A__c,Margin_B__c,Margin_C__c,Status__c,ANZ_Quantity__c,Lead_Time__c,
                            Gross_Margin_Cost_set_75__c, Ex_Stock__c,No_Bid__c,TotalPrice__c,Lost_Reason__c,Curr_CS_75__c,Prior_Month_Cost_Se_t75__c,Qty_PIP__c,Reason_Lost_Comments__c,NDR_Item_Number__c,Seq_No__c,Product_Line__c,
                            Drawing_Number__c,Margin_CS75__c,Part_Number__c,Min_Order_Qty__c,Primary_Pack_Quantity__c,Stock_UOM__c,Code_for_unit_of_measurement__c,Pieces_in_Pack__c,Drawing_Revision_Number__c,Total_Price__c,
                            Contract_Sfty_Stk_Qty__c,Opportunity__r.Safety_Stock__c,ANZ_Percentage__c,Check_Unit_Price__c,NDR_Competitor_Name__c,NDR_Competitor_Part_Number__c,Competitor_Price__c,Opportunity__r.Quote_Type__c,
                            part__r.Pieces_in_Pack__c,ANZ_Item_Id__c,Comments__c,Part__r.Proposal_Part__c,Proposal_Part_Name_Override__c,NDR_Customer_Comments__c  
                            from Opportunity_Part__c where Opportunity__c=:i order by NDR_Item_Number__c];
                            
        list_oppyPart = customSortOppyPart(list_oppyPart);
        list_oppyPart = populateOppyPartFields(list_oppyPart);
        setTotalCostAndValue();
    }
    
    public String partNo{get; set;}
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to turu to the salesHistory vf page.
    Inputs:        
    Returns:       
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public pagereference SalesHistory() {
        String pid =ApexPages.currentPage().getParameters().get('id');
        pagereference pagref = new pagereference('/apex/EditAllforopportunity?id='+i);
        return pagref ;
    }
    
    public List<prodlinewrapper> getPls(){
        return prodlinelist;
    }
    
    public Integer getrenderpageblock() {
        return renderpageblock;   
    }
    
    public class prodlinewrapper{
        public String pl{get; set;}
        public Decimal discount_A {get; set;}
        public Decimal discount_b {get; set;}
        public Decimal discount_c {get; set;}       
        
        public prodlinewrapper(String str,Decimal a, Decimal b, Decimal c){
            pl= str;
            discount_A= a;
            discount_b= b;
            discount_c= c;
        }
    }
    
    public void cancel1(){
        prodlinelist.clear();
        renderpageblock=0;
    }
    
    // Discounting Logic end.... 
    public pagereference productInfo(){
        String varcopyid=apexpages.currentPage().getParameters().get('proName');
        pagereference pageRef=new pageReference('/'+varcopyid);
        return pageRef;
    }
    
    public pagereference BacktoOLI(){
        pagereference backtoId=new pagereference('/'+backid); 
        return backtoId; 
    }
    
    public class OpportunityPartWrapper implements Comparable {
        public Opportunity_Part__c oppyPart;
        
        public OpportunityPartWrapper(Opportunity_Part__c opPa) {
            oppyPart = opPa;
        }
        
        public Integer compareTo(Object compareTo) {
            OpportunityPartWrapper compareToOppy = (OpportunityPartWrapper)compareTo;
            Integer returnValue = 0;
            
            if ( oppyPart.Seq_No__c > compareToOppy.oppyPart.Seq_No__c) {
                returnValue = 1;
            } else if (oppyPart.Seq_No__c < compareToOppy.oppyPart.Seq_No__c) {
                returnValue = -1;
            }
            return returnValue;       
        }
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to sort the Opportunity_Part__c records on the page.
    Inputs:        list_oppps - the list of Opportunity_Part__c
    Returns:       list_returnResults - the list of Opportunity_Part__c
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public static list<Opportunity_Part__c> customSortOppyPart(list<Opportunity_Part__c> list_oppps){
        list<Opportunity_Part__c> list_returnResults = new list<Opportunity_Part__c>();

        if(list_oppps == null){ return new list<Opportunity_Part__c>(); }
        
        list<OpportunityPartWrapper> list_opppWrapper = new list<OpportunityPartWrapper>();
        for(Opportunity_Part__c oppp : list_oppps){
            OpportunityPartWrapper opw = new OpportunityPartWrapper(oppp);
            list_opppWrapper.add(opw);
        }
        list_opppWrapper.sort();
        
        for(OpportunityPartWrapper opw : list_opppWrapper){
            list_returnResults.add(opw.oppyPart);
        }

        return list_returnResults;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to recaculate currency field by using opportunity__r.currencyIsoCode.
    Inputs:        list_oppps - the list of Opportunity_Part__c
    Returns:       list_returnResults - the list of Opportunity_Part__c
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public static list<Opportunity_Part__c> populateOppyPartFields(list<Opportunity_Part__c> list_oppps){
        list<Opportunity_Part__c> list_returnResults = new list<Opportunity_Part__c>();
        Integer index_counter = 0;
        
        for(Opportunity_Part__c oppp : list_oppps){
            //rebuild index for opp parts
            index_counter = index_counter + 1;
            
            //recaculate currency field by using opportunity__r.currencyIsoCode
            String fromIsoCode = oppp.CurrencyIsoCode;
            String toIsoCode = oppp.Opportunity__r.CurrencyIsoCode;
            oppp.Curr_CS_75__c = ClsAPLForecastUtil.transformIsoCode(oppp.Curr_CS_75__c,fromIsoCode,toIsoCode);
            oppp.Prior_Month_Cost_Se_t75__c = ClsAPLForecastUtil.transformIsoCode(oppp.Prior_Month_Cost_Se_t75__c,fromIsoCode,toIsoCode);
            oppp.sales_price__c = ClsAPLForecastUtil.transformIsoCode(oppp.sales_price__c,fromIsoCode,toIsoCode);
            oppp.Offered_Price__c = ClsAPLForecastUtil.transformIsoCode(oppp.Offered_Price__c,fromIsoCode,toIsoCode);
            oppp.TotalPrice__c = ClsAPLForecastUtil.transformIsoCode(oppp.TotalPrice__c,fromIsoCode,toIsoCode);
            oppp.UnitPrice__c = ClsAPLForecastUtil.transformIsoCode(oppp.UnitPrice__c,fromIsoCode,toIsoCode);
            oppp.Cost_Set_3__c = ClsAPLForecastUtil.transformIsoCode(oppp.Cost_Set_3__c,fromIsoCode,toIsoCode);
            oppp.Standard_Cost__c = ClsAPLForecastUtil.transformIsoCode(oppp.Standard_Cost__c,fromIsoCode,toIsoCode);
            
            //change opp part's currencyIsoCode to opportunity__r.currencyIsoCode
            oppp.currencyIsoCode = oppp.opportunity__r.currencyIsoCode;
            
            system.debug('oppp.reason_lost_comments__c::'+oppp.reason_lost_comments__c);
            system.debug('oppp.Part__r.Description__c::'+oppp.Part__r.Description__c);
            if(String.valueOf(oppp.reason_lost_comments__c) == String.valueOf(oppp.Part__r.Description__c)){
                system.debug('oppp.part__r.Description__c::EQUAL!!');
                oppp.reason_lost_comments__c = '';
            }
            
            list_returnResults.add(oppp);
        }

        return list_returnResults;
    }
    
    /*------------------------------------------------------------
    Author:        Tangyong Li <tangyong.li@capgemini.com>
    Description:   Function to calculate the total cost and value of all the Opportunity_Part__c on the page.
    Inputs:        
    Returns:       
    History
    2017-08-11     Tangyong Li <tangyong.li@capgemini.com> created
    ------------------------------------------------------------*/
    public void setTotalCostAndValue(){
        decimal totalCost = 0;
        decimal totalValue = 0;
        String totalGM = '';
        for(Opportunity_Part__c oppp : [SELECT standard_cost__c,Target_Price__c,Total_Price__c,Quantity__c  
                                        FROM Opportunity_Part__c  
                                        WHERE Opportunity__c =: i]){
            totalCost = totalCost + ((oppp.Standard_cost__c  == null ? 0 : oppp.Standard_cost__c )*oppp.Quantity__c);
            totalValue = totalValue + (oppp.Total_Price__c == null? 0 : oppp.Total_Price__c);
        }
        
        Opportunity varNameOpp = [select id,Margin__c from Opportunity where id =: i limit 1];
        if(varNameOpp.Margin__c != null) {
            decimal tgm = varNameOpp.Margin__c;
            totalGM = tgm.setScale(2) + '%';
        } else {
            totalGM = '0%';
        }
        dec_totalValue = totalValue;
        dec_totalCost = totalCost;
        str_totalGM = totalGM;
    } 
}