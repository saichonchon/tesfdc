/*
 * [1/24/17] Prabhanjan N: Case:00901044 : this is to cover the scheduler class: Schedular_RunFlow_portalemailreminder
 */ 
@istest
public class Schedular_RunFlow_portalemail_test {

    @istest
    public static void runflow1(){
        Schedular_RunFlow_portalemailreminder a = new Schedular_RunFlow_portalemailreminder();
       SchedulableContext SC;
        a.execute(SC); 
    }
}