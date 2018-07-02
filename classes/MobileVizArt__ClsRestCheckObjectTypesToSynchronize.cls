/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/MobileVizArt/checkObjectTypesToSynchronize/*')
global class ClsRestCheckObjectTypesToSynchronize {
    global ClsRestCheckObjectTypesToSynchronize() {

    }
    @HttpPost
    global static MobileVizArt.ClsRestCheckObjectTypesToSynchronize.ObjectTypeClass doPost(MobileVizArt.ClsRestCheckObjectTypesToSynchronize.ClsRequest clsRequest) {
        return null;
    }
global class ClsRequest {
    @WebService
    webService String confId;
    @WebService
    webService Datetime timeStamp;
    global ClsRequest() {

    }
}
global class ObjectInfoClass {
    @WebService
    webService Integer count;
    @WebService
    webService String error;
    @WebService
    webService String filterCriteria;
    @WebService
    webService String objectType;
    @WebService
    webService String parent;
    @WebService
    webService Datetime timeStamp;
    global ObjectInfoClass() {

    }
}
global class ObjectTypeClass {
    @WebService
    webService List<MobileVizArt.ClsRestCheckObjectTypesToSynchronize.ObjectInfoClass> objectTypes;
    @WebService
    webService Datetime timeStamp;
    global ObjectTypeClass() {

    }
}
}
