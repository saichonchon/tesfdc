/**
 *  This class is used to for testing APL_Interface.
 *  Some methods in the APL_Interface are overridden in all real Extensions
 *  so the default versions in the APL_Interface abstract class are not covered
 *  in the test classes for the real extensions.  Creating Dummy Extension
 *  to get coverage on virtual methods in APL_Interface.
 *  
 * @author Jasmine Ver
 * @created 2016-04-08
 * @since 36.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2016-04-08 Jasmine Ver <jasmine.ver@te.com>
 * - Created
 *
 */
public with sharing class APL_InterfaceDummyExtension extends APL_Interface.AAPLCtrlService {  
   
    //Not overriding any of the virtual classes from APL_Interface.AAPLCtrlService
    public APL_InterfaceDummyExtension() {
    }
   
}