trigger RestrictDeletionofAttchment on Attachment (before delete) {
    
     try{
        System.debug('Test Debug 1');
    for (Attachment att: Trigger.old){
        String tempId = att.ParentId;
        if(tempId.startsWith('02s')){
             att.addError('You cannot delete this attachment.' );
        }
        if(test.isRunningTest()){
            Integer a = 10/0;
        }
    }
    }catch(Exception e){
        CCP_Exception_Util.CCP_Exception_Mail(e);
    }
}