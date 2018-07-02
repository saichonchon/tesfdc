/**
 *  This class is meant to test data creation in a sandbox org after refresh.
 *  It creates one account with a name derived from context on the source and target orgs.
 *  
 * @author Sebasten Raffal
 * @created 2016-04-12
 * @version 1.0
 * @since 36.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2016-04-12 Jasmine Ver <jasmine.ver@te.com>
 * - Created
 *
 */

global class Sandbox_Refresh implements SandboxPostCopy { 
    global void runApexClass(SandboxContext context) { 
        insert new Account(name = 'Org Id: ' + context.organizationId() + ' Sandbox Id: ' + context.sandboxId() + ' Sandbox Name: ' + context.sandboxName()); 
        System.debug('Hello Tester Pester123 ' + context.organizationId() + ' ' + context.sandboxId() + context.sandboxName()); 
    } 
}