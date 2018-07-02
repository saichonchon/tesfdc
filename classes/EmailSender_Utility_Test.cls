/**
 * 
 *   This is the test class for the class - EmailSender_Utility
 *
 * @author      Prabhanjan Nandyala
 * @created     2016-03-07
 * @since      36.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2016-03-07 Prabhanjan Nandyala <prabhanjan.nandyala@te.com>
 * - Created
 * - test coverage - 100%
 */

@isTest
public class EmailSender_Utility_Test{
    static testMethod void Cls_Test1(){
        Test.startTest();
        list<string> toAddres = new list<string>();
        toAddres.add('administrator@te.com');
        EmailSender_Utility.EmailSender('test', toAddres, 'test' );
        Test.stopTest();
    }    
}