/**
 *  Virtual controll class for CtrlAPLForecast class
 *
 @author    Lei Tang
 @created   2015-05-07
 @version   1.0
 @since     33.0 (Force.com ApiVersion)
 *
 @changelog
 * 2015-05-07 Lei Tang <lei.tang@itbconsult.com>
 * - Created
 */
global virtual without sharing class APL_CtrlForecastRemoteBase {

	@RemoteAction
	public static String searchAPLsObject(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getSearchResult(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String existAPLsObject(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getExistResult(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String saveAPLsObject(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.saveSObjectData(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String delAPLsOjbect(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.deleteAPLObject(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String getASPData(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.useASP(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String getRefData(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getRefData(sData);
		return result;
	}
	
	
	@RemoteAction
	public static String getCFTData(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.copyCFTForecast(sData);
		return result;
	}
	
	@RemoteAction
	public static String getBacklogRefData(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getBacklogRefData(sData);
		return result;
	}
	
	@RemoteAction
	public static String getTotalBillingData(String clsName, String sData){
		APL_Interface.AAPLRemoteService remoteService =  newClsInstance(clsName);
		String result =  remoteService.getTotalBillingData(sData);
		return result;
	}
	
	public static APL_Interface.AAPLRemoteService newClsInstance(String clsName){
        try{
            Type t = Type.forName(clsName);
            return (APL_Interface.AAPLRemoteService) t.newInstance();
        }catch(Exception e){
            throw new CustomNullException('Not found register class.');
        }
    }
	public class CustomNullException extends Exception {} 
}