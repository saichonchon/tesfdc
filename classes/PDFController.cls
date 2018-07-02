/**********************************************************************************************************************************************
*******
Name: PDFController
Copyright © 2013 TE Connectivity | Salesforce Instance : C2S Org
===============================================================================================================================================

Purpose: This controller create a case detail PDF file and attaches to case.
===============================================================================================================================================
REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
-----------------------------------------------------------------------------------------------------------------------------------------------
VERSION   AUTHOR              DATE          DETAIL                           
-----------------------------------------------------------------------------------------------------------------------------------------------
 1.0   Abhijeet Manepatil   09/10/2013    Controller                       
***********************************************************************************************************************************************
*****/
global with sharing class PDFController{
    webService static String PDFRelatedList(Id vParentcase) {
        ID parentId;
        String pdfName;
        parentID = vParentcase;
        Case vCase = [Select id,casenumber from Case where id=:parentID limit 1];
        PageReference pdf = Page.CaseDetailPDF;
        // add parent id to the parameters for standardcontroller
        pdf.getParameters().put('id',parentId);
        Attachment attach = new Attachment();
        Blob body;
        try {
        // returns the output of the page as a PDF
            body = pdf.getContent();
        } catch (VisualforceException e) {
            body = Blob.valueOf('Some Text');
        }
        attach.Body = body;
        attach.Name = 'Case No#'+vCase.casenumber+'#Detail.pdf';
        attach.IsPrivate = false;
        attach.ParentId = parentId;
        insert attach;
        attach = null;
        return 'true';
    }
}