/**
 *  This class is used for Page APL_ForecastChart.
 *  
 * @author Yuda Zheng
 * @created 2015-06-05
 * @version 1.0
 * @since 33.0 (Force.com ApiVersion)  
 * 
 *
 * @changelog
 * 2015-06-05 Yuda Zheng <yuda.zheng@itbconsult.com>
 * - Created
 *
 */
public class APL_CtrlChart {
    
    
    public String currentTerritoryCode {get; set;}
    public String source {get; set;}
    public String url {get; set;}
    public String userId {get; set;}
    
    public APL_CtrlChart(){
        
        if(ApexPages.currentPage().getParameters().get('url') != null) url = ApexPages.currentPage().getParameters().get('url');

    	deCodeUrl(url);
    }
    
    /**
    * This method is used to encode url parameter
    *
    @author Yuda Zheng
    @created 2015-06-05
    @version 1.0
    @since 33.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-05 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public static String enCodeUrl(String source, String tCode, String uId){
        String url = '/apex/APL_ForecastChart?url=';
        String parameter = '';

		if(source.toLowerCase() == 'gam'){
            parameter = 'GAM';
        } 
        else if(source.toLowerCase() == 'rsmrelay'){
            parameter = 'RSMRelay;' + uId;
        }    
        else if(source.toLowerCase() == 'relay'){
            parameter = 'Relay;' + tCode;
        }     
        else if(source.toLowerCase() == 'am'){
            parameter = 'AM;' + tCode;
        }
        else{
            parameter = 'RSM;' + uId;
        }     
        url += EncodingUtil.base64Encode(Blob.valueOf(parameter));
        system.debug('url:'+url);
        return url;
    }
    
    /**
    * This method is used to decode url parameter
    *
    @author Yuda Zheng
    @created 2015-06-05
    @version 1.0
    @since 33.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2015-06-05 Yuda Zheng <yuda.zheng@itbconsult.com>
    * - Created
    */
    public  void deCodeUrl(String url){
        if(url != null){
            String dUrl = EncodingUtil.base64Decode(url).toString();
            List<String> list_s = dUrl.split(';');
            if(list_s.size() > 0){
                source = list_s[0];
            }
            if(list_s.size() > 1){
            	if(source == 'RSM' || source == 'RSMRelay'){
            		userId = list_s[1];
            	}else {
            		currentTerritoryCode = list_s[1];
            	}
            }
        }
    }    
}