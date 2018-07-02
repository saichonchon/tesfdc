/************************************************************************************************************************************************************************************************************************
Name: LiveAgentModel 
===========================================================================================================================================================================================================
Purpose: This class was part of Central org and moved in C2S for PIC Migration for Case object. 
         This is used by AgentFileUploadContExt class which is used to let agent upload file using quick text Url's during live chat for Pic 
===========================================================================================================================================================================================================
******************************************************************************************************************************************************************************************************************/

public class LiveAgentModel {
  private Live_Agent_Files__c record{
        get{
            if (record == null)
                record = new Live_Agent_Files__c();
            return record;
        }
        set{record = value;}
    }
  
  public LiveAgentModel( Id ownerId ){
      record.OwnerId = ownerId;
    }
    
    public void upsertRecord(){
      upsert record;
    }
    
    public Id recordId(){
      return record.Id;
    }
}