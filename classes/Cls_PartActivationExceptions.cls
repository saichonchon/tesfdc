/***********************************************************************************************************************
      Name : Cls_PartActivationExceptions
       Org : C2S
 Copyright : © 2013 TE Connectivity 
========================================================================================================================
   Summary : A class to handle exceptions in the Part Activations Batch Class.
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                           
________________________________________________________________________________________________________________________
 VERSION AUTHOR       DATE        DETAIL               User Story #                  
________________________________________________________________________________________________________________________
     1.0 Shantinath   06/21/2013  Initial Development  1177                      
***********************************************************************************************************************/
public class Cls_PartActivationExceptions{
    public static void UpdateNoteWithStatus(String pErrorString, String pAPIName, Id pConfigId){
        if(pErrorString!= null){
            Note vErrorNote = new Note();
            vErrorNote.ParentId = pConfigId;
            Integer i = pErrorString.length();
            if (i > 32000) {
                vErrorNote.Body = pErrorString.subString(0,31999);
            }else{
                vErrorNote.Body = pErrorString.subString(0,i);
            }
            vErrorNote.Title = 'Error '+pAPIName+' @ '+System.now();
            try{
                insert vErrorNote;
            }catch(Exception e){
                System.debug('Exception in creating the Note --> '+e);
            }
        }       
    }
}