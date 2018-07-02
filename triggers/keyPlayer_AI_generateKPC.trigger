/**
    *   trigger to generate key player criteria records after key player records are inserted 
    *
    @author Yuanyuan Zhang
    @created 2014-03-17
    @version 1.0
    @since 29.0 (Force.com ApiVersion)
    *
    *
    @changelog
    * 2014-03-17 Yuanyuan Zhang <yuanyuan.zhang@itbconsult.com>  
    * - Created  
    */ 


trigger keyPlayer_AI_generateKPC on Key_Player__c (after insert) {
	if(trigger.isInsert){
		ClsPMV_Util.createKeyPlayerCriterias(trigger.new);
	}
}