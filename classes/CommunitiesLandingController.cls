/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public PageReference forwardToStartPage() {
        //return Network.communitiesLanding();
        
        string myIdpLogout = 'http://www.te.com/'; 
        string r = System.currentPageReference().getHeaders().get('Referer'); 
        if (string.isNotBlank(r) && r.toLowerCase().contains('/secur/logout.jsp')) { 
            return new PageReference(myIdpLogout); 
        } 
        else { 
            return Network.communitiesLanding(); 
        } 
        
        
    }
    
    public CommunitiesLandingController() {}
}