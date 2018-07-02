/*------------------------------------------------------------
Author:        Yiming Shen <yiming.shen@capgemini.com>
Description:   A factory class for all trigger handlers.
Inputs:        
Test Class:    ClsTriggerFactory_Test.cls
History
2016-10-17 	Jasmine Ver  Created
2017-07-10	Bin Yuan <bin.yuan@capgemini.com> Modified
------------------------------------------------------------*/
public class ClsTriggerFactory {
	/**
     *  Global test run skipper as privat static member
     */
    public static Boolean isSkipTrigger = false; 
	/**
     *  Test run skippers for all trigger handlers as privat static member in form of map
     */
    public static Map<String, Boolean> map_handler_isSkip = new Map<String, Boolean>(); 
    
    
    /**
     *  Public static method to create and execute a trigger handler
     *  Throws a ClsTriggerException if no handler has been registered.
     *
     *  
     * @author Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since 37.0
     *
     * @param   soType      the Sobject Type, on which the current trigger is running
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    public static void createHandler(Schema.sObjectType soType) {

        // Get a handler appropriate to the object being processed
        IntTrigger handler = getHandler(soType);
        
        // Make sure we have a handler registered, 
        //new handlers must be registered in the getHandler method.
        if (handler == null) {
         throw new ClsTriggerException('No Trigger Handler registered for Object Type: ' 
                                     + soType);
        }
        system.debug('***createHandler start getCpuTime()***' + Limits.getCpuTime());
        // Execute the handler to fulfil the trigger
        execute(handler);
    }
    
    /**
     *  Private static method to control the execution of the handler
     * - trigger test run skipper examination
     * - runs in before trigger context
     * - runs in after trigger context
     *
     *  
     * @author Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since 37.0
     *
     * @param   handler     trigger handler interface
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    private static void execute(IntTrigger handler) {
        Boolean skip = false;
		system.debug('***execute start getCpuTime()***' + Limits.getCpuTime());
        // The skip flag in the map has a higher priority than global flag
        if(map_handler_isSkip.containsKey(String.valueOf(handler).split(':')[0])){
            skip = map_handler_isSkip.get(String.valueOf(handler).split(':')[0]);
        }else if(ClsTriggerFactory.isSkipTrigger){
            skip = ClsTriggerFactory.isSkipTrigger;
        }
        
        if(skip){
            // The handler should be skipped
            return;
        }

		system.debug('***trgCtx start getCpuTime()***' + Limits.getCpuTime());
        ClsWrappers.TriggerContext trgCtx = new ClsWrappers.TriggerContext(Trigger.isBefore, Trigger.isAfter, Trigger.isInsert, Trigger.isUpdate, Trigger.isDelete, Trigger.isUndelete, Trigger.new, Trigger.newMap, Trigger.old, Trigger.oldMap);
		system.debug('***trgCtx end getCpuTime()***' + Limits.getCpuTime());
        // Before Trigger
        if(Trigger.isBefore){
            // Call the bulk before to handle any caching of data and enable bulkification
            handler.bulkBefore(trgCtx);
            
            // Execute business logic in before trigger context
            handler.beforeTrigger(trgCtx);
            
        }else{

            // Call the bulk after to handle any caching of data and enable bulkification
            handler.bulkAfter(trgCtx);
            
            // Execute business logic in after trigger context
            handler.afterTrigger(trgCtx);
            
        }
         
        // Perform any post processing
        handler.andFinally(trgCtx);
        system.debug('***execute end getCpuTime()***' + Limits.getCpuTime());
    }
    
    /**
     *  Public static method to set global test run skipper
     *
     *  
     * @author Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since 37.0
     *
     * @param   skip        true or false
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    public static void setSkipHandlers(Boolean skip) {
        isSkipTrigger = skip;
    }
    
    /**
     *  Public static method to set test run skipper a specific trigger handler
     *
     *  
     * @author Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since 37.0
     *
     * @param   handlerName     the hander name as string
     * @param   skip            true or false
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    public static void setSkipHandler(String handlerName, Boolean skip) {
        map_handler_isSkip.put(handlerName, skip);
    }
    
    
    /**
     *  Private static method to get the appropriate handler for the object type.
     *  Modify this method to register any additional handlers.
     *
     *  
     * @author Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since 37.0
     *
     * @param   soType      the Sobject Type, on which the current trigger is running
     * @return  IntTrigger  the trigger handler interface if exists, or null
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     * 2017-09-18 Esther <esther.ethelbert@te.com>
     * - Added to call Trigger handler for the object Market and Competition and Platform Content
     *  2017-11-30 Kartik <kartik.gohad@te.com>
     * - Added to call Trigger handler for the Forecast Object
     */
    private static IntTrigger getHandler(Schema.sObjectType soType) {
        if (soType == Opportunity.sObjectType) {
              return new OpportunityTrgHandler();
        }
        if (soType == Opportunity_Part__c.sObjectType) {
   		    return new OpportunityPartTrgHandler();  
        }
        if (soType == Opportunity_Partner__c.sObjectType) {
   		    return new OpportunityPartnerTrgHandler();
        }
        if (soType == Opportunity_Forecast__c.sObjectType) {
   		    return new OpportunityForecastTrgHandler();
        }
        if (soType == OpportunityTeamMember.sObjectType) {
   		    return new OpportunityTeamMemberTrgHander();
        }
        if (soType == Account.sObjectType) {
   		    return new AccountTrgHandler();
        }
        if (soType == Product_Hierarchy__c.sObjectType) {
   		    return new ProductHierarchyTrgHandler();
        }
        if (soType == Energy_Quote__c.sObjectType) {
   		    return new EnergyQuoteTrgHandler();
        }
        if (soType == Opportunity_Part_Forecast__c.sObjectType) {
   		    return new OpportunityPartForecastTrgHandler();
        }
        if (soType == ACP_Market_and_Competition__c.sObjectType) {
              return new ACP_MarketCompTrgHandler();
        }
        if (soType == Platform_Content__c.sObjectType) {
              return new ACP_PlatformContentTrgHandler();
        }
        if (soType == Inventory__c.sObjectType) {
         	return new InventoryTrgHandler();
        }
        if (soType == Energy_Price_Book_Entry__c.sObjectType) {
         	return new EnergyPriceBookEntryTriggerHandler();
        }
        if (soType == MTO_High_Runner__c.sObjectType) {
        	//Added by Buwen Guo 2017-12-27
         	return new ClsMTOHighRunnerTriggerHandler();
        }
        if (soType == Forecast__c.sObjectType) {
            return new ADMForecastTriggerHandler();
        } 
        return null;
    }
}