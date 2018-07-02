/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class WSCleanUpData {
    global WSCleanUpData() {

    }
    @ReadOnly
    webService static MobileVizArt.WSCleanUpData.IntegratedDataClass cleanupData(MobileVizArt.WSCleanUpData.LocalData localRecords) {
        return null;
    }
global class IntegratedDataClass {
    @WebService
    webService List<MobileVizArt.WSCleanUpData.IntegratedDataClass> cleanupContents;
    @WebService
    webService List<String> cleanupRecordIds;
    @WebService
    webService List<MobileVizArt.WSCleanUpData.IntegratedDataClass> newContents;
    @WebService
    webService List<SObject> newRecords;
    @WebService
    webService String objName;
    global IntegratedDataClass() {

    }
}
global class LocalData {
    @WebService
    webService String confId;
    @WebService
    webService String objName;
    @WebService
    webService List<String> recordIds;
    global LocalData() {

    }
}
}
