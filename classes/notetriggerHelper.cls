/**
*  This helper class for trigger note_AIUBD_updateOppyLastModifiedDate.
*
@author Pankaj Raijade
@created 2016-03-07
@version 1.0
@since 35.0
*
Test Class: TrgNote_AIUBD_udOppyLastModfyDate_Test 
COde Coverage - 81%
*/

public class notetriggerHelper
{

    Public static void NoteTriggerExceptionhandler(DMLException e, list<note> triggerOld, list<note> triggerNew, boolean isDelete)
    {
          // 2014-12-16 Phil Hiemstra - Added DML Exception handling, mostly to catch Funnel OCR related validation errors.
        Map<Id, String> errorMessages = new Map<Id, String>();
        for (Integer i = 0; i < e.getNumDml(); i++) 
            errorMessages.put(Id.valueOf(e.getDmlId(i)), e.getDmlMessage(i));
        
        if(isDelete)
        {
            for(Note n : triggerOld)
                if (errorMessages.containsKey(n.ParentId))
                    n.addError(errorMessages.get(n.ParentId));
        }
        else
        {
            for(Note n : triggerNew)
                if (errorMessages.containsKey(n.ParentId))
                    n.addError(errorMessages.get(n.ParentId));
        }
    }

}