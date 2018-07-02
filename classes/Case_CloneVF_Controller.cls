public class Case_CloneVF_Controller {
    public Id vCaseId;
    public Case_CloneVF_Controller(ApexPages.StandardController controller) {
        vCaseId =  System.currentPageReference().getParameters().get( 'id' );
    }
    
    public pagereference CloneCase(){
         pagereference pageref= new pagereference ('/'+vCaseId+'/e?clone=1&retURL=%2F'+vCaseId+'&00NL0000002iq9k='+0+'&00NL0000002iq9p='+0);
         return  pageref;
    }

}