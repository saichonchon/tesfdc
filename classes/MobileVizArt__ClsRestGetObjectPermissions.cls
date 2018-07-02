/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
@RestResource(urlMapping='/MobileVizArt/getObjectPermissions/*')
global class ClsRestGetObjectPermissions {
    global ClsRestGetObjectPermissions() {

    }
    @HttpPost
    global static MobileVizArt.ClsRestGetObjectPermissions.EffectiveObjectPermissions doPost(String userId, String profileId, List<String> objectNames) {
        return null;
    }
global class EffectiveObjectPermissions {
    @WebService
    webService List<MobileVizArt.ClsRestGetObjectPermissions.ObjectPermission> list_ObjectPermission;
    global EffectiveObjectPermissions() {

    }
}
global class ObjectPermission {
    @WebService
    webService Boolean PermissionsCreate;
    @WebService
    webService Boolean PermissionsDelete;
    @WebService
    webService Boolean PermissionsEdit;
    @WebService
    webService Boolean PermissionsModifyAllRecords;
    @WebService
    webService Boolean PermissionsRead;
    @WebService
    webService Boolean PermissionsViewAllRecords;
    @WebService
    webService String SobjectType;
    global ObjectPermission() {

    }
}
}
