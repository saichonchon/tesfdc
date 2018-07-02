/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest (SeeAllData = true)
private class OpptyNDRForecastUtilTest {

    static testMethod void testOpptyNDRForecastUtil() {
        //Create Product Hierarchy
        Product_Hierarchy__c Gpl = new Product_Hierarchy__c();                
        insert Gpl;
        
        //Create Part records
        List<Part__c> lstParts = new List<Part__c>(); 
        Part__c part1 = new Part__c();
        part1.Name = 'Test Part 1';
        part1.Product_Hierarchy__c = Gpl.Id;
        lstParts.add(part1);
        
        Part__c part2 = new Part__c();
        part2.Name = 'Test Part 2';
        part2.Product_Hierarchy__c = Gpl.Id;
        lstParts.add(part2);
        
        Part__c part3 = new Part__c();
        part3.Name = 'Test Part 3';
        part3.Product_Hierarchy__c = Gpl.Id;
        lstParts.add(part3);        
        
        insert lstParts;           
        
        //Create opportunity record
        Opportunity_Record_Type_Groups__c configNDROppty = Opportunity_Record_Type_Groups__c.getInstance('NDR Opportunity');
        Id ndrRecordType = configNDROppty.RecordTypeID__c;
        
        List<Opportunity> lstOppties = new List<Opportunity>();
        
        Opportunity oppty1 = new Opportunity();
        oppty1.RecordTypeId = ndrRecordType;
        oppty1.Name = 'Test Opportunity 1';
        oppty1.CloseDate = Date.today().addDays(60);
        oppty1.currency_confirm__c = true;
        oppty1.Opportunity_Already_Exist__c = false; // add lili 2014.1.24
     
        oppty1.StageName = 'New';
        //oppty1.NDR_Quote_Status_Description__c = 'complete';  
        oppty1.Level__c = ClsOppyForecastUtil.MONTHLY;
        oppty1.Life_of_Program_in_Years__c = '3';
        lstOppties.add(oppty1);
        
        Opportunity oppty2 = new Opportunity();
        oppty2.RecordTypeId = ndrRecordType;
        oppty2.Name = 'Test Opportunity 2';
        oppty2.currency_confirm__c = true;
        oppty2.CloseDate = Date.today().addDays(60);
        oppty2.Opportunity_Already_Exist__c = false; // add lili 2014.1.24
        
        oppty2.StageName = 'New';
        oppty2.Level__c = ClsOppyForecastUtil.QUARTERLY;
        oppty2.Life_of_Program_in_Years__c = '3';
        lstOppties.add(oppty2);
        
        Opportunity oppty3 = new Opportunity();
        oppty3.RecordTypeId = ndrRecordType;
        oppty3.Name = 'Test Opportunity 3';
        oppty3.CloseDate = Date.today().addDays(60);
        oppty3.currency_confirm__c = true;
        oppty3.Opportunity_Already_Exist__c = false; // add lili 2014.1.24
        
        oppty3.StageName = 'New';
        oppty3.Manufacturing_Start_Date__c = Date.newInstance(2014, 5, 3);
        oppty3.Level__c = ClsOppyForecastUtil.YEARLY;
        oppty3.Life_of_Program_in_Years__c = '3';
        lstOppties.add(oppty3);
        //insert oppty3;
        insert lstOppties;        
        
        //Create Opportunity Part records
        Apex_Helper_Settings__c configNDROpptyPart = Apex_Helper_Settings__c.getInstance('NDR Opportunity Parts');
        Id ndrOpptyPartRecordType = configNDROpptyPart.Value__c;
        
        List<Opportunity_Part__c> lstOpptyParts = new List<Opportunity_Part__c >();    
        
        for(Opportunity oppty : lstOppties){
            for(Part__c part : lstParts){
                Opportunity_Part__c opptyPart = new Opportunity_Part__c();
                opptyPart.Opportunity__c = oppty.Id;
                opptyPart.Part__c = part.Id;
                opptyPart.RecordTypeId = ndrOpptyPartRecordType;
                opptyPart.Quantity__c = 150;
                opptyPart.NDR_GPMS_Approval_Price__c = 15;
                opptyPart.NDR_GPMS_Approval_Flag__c = 'A';
                // add lili 2014.1.24 begin
                opptyPart.NDR_Item_Status_Desc__c = 'Complete';
                opptyPart.NDRForecastCreated__c = false;
                opptyPart.NDR_Ship_and_Debit_Price__c = '10';
                opptyPart.NDR_Ship_and_Debit_Price_Per__c = '10';
                opptyPart.NDR_Range__c = 10;
                opptyPart.NDR_GPMS_Approval_Price__c = 0;// Mrunal 
            opptyPart.NDR_Item_Unit_Price_Quoted_Price__c = '0';// Mrunal
            opptyPart.NDR_Item_Price_Per__c = '10';
                
                // add lili 2014.1.24 begin end
                lstOpptyParts.add(opptyPart);               
            }
        }
        Opportunity_Part__c opptyPart = new Opportunity_Part__c();
        opptyPart.Opportunity__c = oppty3.Id;
        opptyPart.Part__c = part3.Id;
        opptyPart.RecordTypeId = ndrOpptyPartRecordType;
        opptyPart.NDR_GPMS_Approval_Price__c = 15;
        opptyPart.NDR_GPMS_Approval_Flag__c = 'A';
        // add lili 2014.1.24 begin
        opptyPart.NDR_Item_Status_Desc__c = 'Complete';
        opptyPart.NDR_Ship_and_Debit_Price__c = '100';
        opptyPart.NDRForecastCreated__c = false;
        opptyPart.NDR_Ship_and_Debit_Price__c = '10';
        opptyPart.NDR_Ship_and_Debit_Price_Per__c = '10';
        opptyPart.NDR_Range__c = 10;
        opptyPart.NDR_GPMS_Approval_Price__c = 10;
    opptyPart.NDR_Item_Unit_Price_Quoted_Price__c = '10';
    opptyPart.NDR_Item_Price_Per__c = '10';
        
        // add lili 2014.1.24 begin end
        lstOpptyParts.add(opptyPart);   
                    
        insert lstOpptyParts;
        test.starttest();
        //Call method to test
        OpptyNDRForecastUtil.addPartsToOpptyForecast(lstOppties);
        
        lstOppties.clear();
        oppty2.NDR_Quote_Status_Description__c = 'complete';
        lstOppties.add(oppty2); 
        oppty3.NDR_Quote_Status_Description__c = 'complete';
        lstOppties.add(oppty3); 
        
        update lstOppties;  
        
        ClsTriggerRecursionDefense.isFirstrun = true;
        oppty1.StageName = 'Commit';
        update oppty1;
        
        String LOP = oppty3.Life_of_Program_in_Years__c;
        Date d1 = date.newInstance(2014, 5, 22);
        OpptyNDRForecastUtil.calculateQantityForeCurrentNextYear(10, 4, d1, LOP);
        test.stoptest();              
    }
}