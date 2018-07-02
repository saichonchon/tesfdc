/**
 * 
 *   This schedular class is used to run the batch class 'BatchCls_DeleteSObjects'.
 * Please refer to project in teamup: 'C2S Archive and Delete Cases'
 *
 * @author      Prabhanjan Nandyala
 * @created     2016-03-07
 * @since      36.0     
 * @version     1.0                                                                
 * 
 * @changelog
 * 2016-03-07 Prabhanjan Nandyala <prabhanjan.nandyala@te.com>
 * - Created
 *    
 */
global class SchedularCls_DeleteSObjects implements Schedulable{
    global void execute(SchedulableContext sc) {
        database.executebatch(new BatchCls_DeleteSObjects());
    }
}