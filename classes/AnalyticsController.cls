public class AnalyticsController {
    public String aLink;
    public AnalyticsController() {
        aLink = ApexPages.currentPage().getParameters().get('analyticslink');
    }
    public String getALink(){
        return aLink;
    }
}