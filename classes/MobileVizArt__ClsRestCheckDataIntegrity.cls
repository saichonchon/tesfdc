/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/MobileVizArt/checkDataIntegrity/*')
global class ClsRestCheckDataIntegrity {
    global ClsRestCheckDataIntegrity() {

    }
    @HttpPost
    global static MobileVizArt.ClsRestCheckDataIntegrity.IntegratedDataClass doPost(String objName, String confId, List<String> recordIds) {
        return null;
    }
global class IntegratedDataClass {
    @WebService
    webService List<MobileVizArt.ClsRestCheckDataIntegrity.IntegratedDataClass> cleanupContents;
    @WebService
    webService List<String> cleanupRecordIds;
    @WebService
    webService List<MobileVizArt.ClsRestCheckDataIntegrity.IntegratedDataClass> newContents;
    @WebService
    webService List<SObject> newRecords;
    @WebService
    webService String objName;
    global IntegratedDataClass() {

    }
}
}
