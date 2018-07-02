/**
 *  Virtual controll class for CtrlCSDForecast class
 *
 @author    Lei Tang
 @created   2014-10-16
 @version   1.0
 @since     30.0 (Force.com ApiVersion)
 *
 @changelog
 * 2014-10-16 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 */
global virtual without sharing class CSD_CtrlForecastRemoteBase {
	
	
	
	
	
	@RemoteAction
	public static String searchCSDsObject(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getSearchResult(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String existCSDsObject(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getExistResult(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String saveCSDsObject(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.saveSObjectData(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String delCSDsOjbect(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.deleteCSDObject(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String getASPData(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.useASP(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String getRefData(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getRefData(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String getCFTData(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.copyCFTForecast(sData);
		return result;
	}
	
	@RemoteAction
	public static String getBacklogRefData(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getBacklogRefData(sData);
		return result;
	}
	
	@RemoteAction
	public static String getTotalBillingData(String clsName, String sData){
		CSD_Interface.ACSDRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getTotalBillingData(sData);
		return result;
	}
	
	
	
    public static CSD_Interface.ACSDRemoteService newClsInstance(String clsName){
        try{
            Type t = Type.forName(clsName);
            return (CSD_Interface.ACSDRemoteService) t.newInstance();
        }catch(Exception e){
            throw new CustomNullException('Not found register class.');
        }
    }
	public class CustomNullException extends Exception {} 
}