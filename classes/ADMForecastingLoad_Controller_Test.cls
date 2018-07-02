/**********************************************************************
Name:  ADMForecastingLoad_Controller_Test
Copyright © 2017
======================================================
======================================================
Purpose: Test Class for ADMForecastingLoad_Controller
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION      AUTHOR                DATE             DETAIL               	Description
 1.0        Altaf ur Rahman      10/12/2017      INITIAL DEVELOPMENT
***********************************************************************/

@isTest
public class ADMForecastingLoad_Controller_Test {

    Public static testmethod void ADMforecasting_Load(){       
        
        ADM_Forecast_Page_Customization__c d= new ADM_Forecast_Page_Customization__c();
          d.name ='CommentWidthandColorCoding';
          d.Color_Coding__c ='#008000';
          d.Comment_Width__c = '150';  
          d.GuiFcstDay__c = '88';
          insert d; 
        
        ADMForecastingLoad_Controller adm_LoadController = new ADMForecastingLoad_Controller();
        adm_LoadController.LatestCommentWidth = '';
        adm_LoadController.FrstColorCoding = '';
        adm_LoadController.nonPortfolioTab();
    }
}