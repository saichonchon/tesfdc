/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/MobileVizArt/logDeviceStatus/*')
global class ClsRestLogDeviceStatus {
    global ClsRestLogDeviceStatus() {

    }
    @HttpPost
    global static MobileVizArt.ClsRestLogDeviceStatus.ClsResponse doPost(MobileVizArt.ClsRestLogDeviceStatus.ClsRequest req) {
        return null;
    }
global class ClsRequest {
    @WebService
    webService String AppName;
    @WebService
    webService String AppVersion;
    @WebService
    webService String DeviceType;
    @WebService
    webService Datetime LastClenaup;
    @WebService
    webService Datetime LastConfigurationUpdate;
    @WebService
    webService Datetime LastInitialization;
    @WebService
    webService Datetime LastSynchronization;
    @WebService
    webService String MobileKernelVersion;
    @WebService
    webService String MobileLibraryVersion;
    @WebService
    webService String OperatingSystem;
    global ClsRequest() {

    }
}
global class ClsResponse {
    @WebService
    webService String Status;
    global ClsResponse() {

    }
}
}
