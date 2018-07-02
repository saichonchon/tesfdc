/**********************************************************************
Name: ADMForecastingLoad_Controller 
Copyright © 2017
======================================================
======================================================
Purpose: 
-------                                                             
======================================================
TestClass : ADMForecastingLoad_Controller_Test
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL                  Description
1.0        Altaf ur Rahman      08/15/2017      INITIAL DEVELOPMENT
***********************************************************************/
public class ADMForecastingLoad_Controller {
    
    public Boolean displayNonPortfolio {get; set;}
    public String LatestCommentWidth{get;set;}
    public String FrstColorCoding{get;set;}
    
    public void nonPortfolioTab(){
        displayNonPortfolio = true;
        system.debug('displayNonPortfolio--->> '+displayNonPortfolio);        
    }
    
    public ADMForecastingLoad_Controller(){          
        displayNonPortfolio = false;
        system.debug('displayNonPortfolio--> '+displayNonPortfolio); 
        
        ADM_Forecast_Page_Customization__c result = ADM_Forecast_Page_Customization__c.getValues('CommentWidthandColorCoding');
        system.debug('result---> '+result);
        if(result != null){
            LatestCommentWidth = result.Comment_Width__c;  
        	FrstColorCoding = result.Color_Coding__c;  
        }              
        System.Debug('LatestCommentWidth :'+LatestCommentWidth);   
        System.Debug('FrstColorCoding :'+FrstColorCoding);  
    }
}