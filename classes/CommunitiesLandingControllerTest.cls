/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
@IsTest public with sharing class CommunitiesLandingControllerTest {
    @IsTest public static void testCommunitiesLandingController() {
        
        CommunitiesLandingController controller1 = new CommunitiesLandingController();
        controller1.forwardToStartPage();
        
        Apexpages.currentPage().getHeaders().put('Referer', '/secur/logout.jsp');
        // Instantiate a new controller with all parameters in the page
        CommunitiesLandingController controller = new CommunitiesLandingController();
        controller.forwardToStartPage();
      }
}