@isTest

private class ICT_SchduleBatchCreateTaskinC2STest{   
   
   static testmethod void test() {  
    
    Test.startTest();

    ICT_SchduleBatchCreateTaskinC2S sh1 = new ICT_SchduleBatchCreateTaskinC2S ();

    //String sch = '0 0 1 * * ?';
    String sch = '0 0 1 ? * MON-FRI';

    system.schedule('Scheduled Job', sch, sh1);

    Test.stopTest();
}
}