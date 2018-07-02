/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/MobileVizArt/getFilterCriteria/*')
global class ClsRestGetFilterCriteria {
    global ClsRestGetFilterCriteria() {

    }
    @HttpPost
    global static MobileVizArt.ClsRestGetFilterCriteria.ClsResponse doPost(MobileVizArt.ClsRestGetFilterCriteria.ClsRequest req) {
        return null;
    }
global class ClsMobileObjectInfo {
    @WebService
    webService String filterCriteria;
    @WebService
    webService String objName;
    global ClsMobileObjectInfo() {

    }
}
global class ClsRequest {
    global ClsRequest() {

    }
}
global class ClsResponse {
    @WebService
    webService List<MobileVizArt.ClsRestGetFilterCriteria.ClsMobileObjectInfo> filterCriterias;
    global ClsResponse() {

    }
}
}
