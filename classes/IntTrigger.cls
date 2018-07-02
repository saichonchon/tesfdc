/**
 * Interface containing methods. Trigger Handlers must implement to enforce best practice
 * and bulkification of triggers.
 *
 * @author  Tao Yang
 * @created 2016-08-12
 * @version 1.0
 * @since   37.0 (Force.com ApiVersion)
 *
 * @changelog
 * 2016-08-12 Tao Yang <tao.yang@oinio.com>
 * - Created
 */
 
public interface IntTrigger {
 /**
     * This method is called prior to execution of a BEFORE trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     *
     * @author  Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since   37.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    void bulkBefore(ClsWrappers.TriggerContext trgCtx);

    /**
     * This method is called prior to execution of an AFTER trigger. Use this to cache
     * any data required into maps prior execution of the trigger.
     *
     * @author  Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since   37.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    void bulkAfter(ClsWrappers.TriggerContext trgCtx);
    
    /**
     * This method is called for business logic execution of BEFORE trigger.
     *
     * @author  Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since   37.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2016-08-12  Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    void beforeTrigger(ClsWrappers.TriggerContext trgCtx);

    /**
     * This method is called for business logic execution of AFTER trigger.
     *
     * @author  Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since   37.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    void afterTrigger(ClsWrappers.TriggerContext trgCtx);
    
    /**
     * This method is called once all records have been processed by the trigger. Use this
     * method to accomplish any final operations such as creation or updates of other records.
     *
     * @author  Tao Yang
     * @created 2016-08-12
     * @version 1.0
     * @since   37.0 (Force.com ApiVersion)
     *
     * @changelog
     * 2016-08-12 Tao Yang <tao.yang@oinio.com>
     * - Created
     */
    void andFinally(ClsWrappers.TriggerContext trgCtx);
    
}