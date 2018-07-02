/************************************************************************************************************************************************************************************************************************
Name: LiveChatTranscriptServices
===========================================================================================================================================================================================================
Purpose: This class was part of Central org and moved in C2S for PIC Migration for Case object. 
         This is used by chat transcript trigger to create case from live chat for Pic 
===========================================================================================================================================================================================================
***********************************************************************************************************************************************************************************************************************/

public class LiveChatTranscriptServices {
  public static final String STATUS_MISSED = 'Missed';
  
  public static List<LiveChatTranscript> filterLiveChatTranscriptsWithoutCases( List<LiveChatTranscript> newLiveChatTranscriptList ){
    List<LiveChatTranscript> listToReturn = new List<LiveChatTranscript>();
    
    for( LiveChatTranscript item : newLiveChatTranscriptList ){
      if( item.CaseId != null || item.Status == STATUS_MISSED ){
        
      } else {
        listToReturn.add( item );
      }
    }
        
    return listToReturn;
  }
  
  public static void createCasesFromLiveChatTranscripts( List<LiveChatTranscript> newLiveChatTranscriptList ){
    Map<LiveChatTranscript,Case> liveChatTranscriptsToCaseMap = new Map<LiveChatTranscript,Case>();
    
    for( LiveChatTranscript item : newLiveChatTranscriptList )
      liveChatTranscriptsToCaseMap.put( item, null );
    
    liveChatTranscriptsToCaseMap = CaseServices.createCaseFromLiveChatTranscript( newLiveChatTranscriptList );
    
    for( LiveChatTranscript item : liveChatTranscriptsToCaseMap.keySet() ){
      Case caseItem = liveChatTranscriptsToCaseMap.get( item );
      
      item.CaseId = caseItem.Id;
      item.ContactId = caseItem.ContactId;
    }
  }
}