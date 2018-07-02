@isTest(seeAllData = false)   
private class Utils_SDF_Methodology_Test {

    static testMethod void TestUtilsSDFMethodology()
    {
        test.startTest();
        
        Utils_SDF_Methodology.canTrigger('CutoffDateUpdate');
        Utils_SDF_Methodology.canTrigger('OEMMappingAfterInsert');
        
        Utils_SDF_Methodology.removeFromRunOnce('CutoffDateUpdate');
        Utils_SDF_Methodology.removeFromRunOnce('OEMMappingAfterInsert');
        
        Utils_SDF_Methodology.restrictquery('CutoffDateUpdate');
        Utils_SDF_Methodology.restrictquery('CutoffDateUpdate');
        
        test.stopTest();
    }
}