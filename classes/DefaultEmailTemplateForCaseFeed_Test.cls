/**************************************************************************************************************************************************
Name:  DefaultEmailTemplateForCaseFeed_Test
Copyright © 2011 TE Connectivity
===================================================================================================================================================
Purpose: This class contain Test Methods for DefaultEmailTemplateForCaseFeed class 
---------------------------------------------------------------------------------------------------------------------------------------------------       
Related APEX Class : DefaultEmailTemplateForCaseFeed                                                             
===================================================================================================================================================
History:                                                        
---------------------------------------------------------------------------------------------------------------------------------------------------
Version Developer          Date       Detail                                  Mercury Request #
---------------------------------------------------------------------------------------------------------------------------------------------------
  1.0 Narasimha Narra    30/10/2013    Initial Development                      1453487                                   
**************************************************************************************************************************************************/
@isTest(seealldata=false)
public class DefaultEmailTemplateForCaseFeed_Test
{
    static testmethod void testTemplate()
    {
        test.startTest();
        
        DefaultEmailTemplateForCaseFeed ob=new DefaultEmailTemplateForCaseFeed();
        Id id11=ob.getDefaultEmailTemplateId(userinfo.getUserId());
        
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'DefaultEmailTemplate';
        validEmailTemplate.DeveloperName = 'DefaultEmailTemplate';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();
        insert validEmailTemplate;
        
        Id id12=ob.getDefaultEmailTemplateId(userinfo.getUserId());
        
        test.stopTest();
    }
}