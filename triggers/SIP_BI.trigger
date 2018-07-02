/**
 * This trigger used to .
 *
 * @author      Lili Zhao
 * @created     2013-08-07
 * @since       24.0 (Force.com ApiVersion)      
 * @version     1.0 
 *
 * @changelog
 *  2013-08-07 Lili Zhao <lili.zhao@itbconsult.com>
 * - Created 
 *  2014-09-26 Bin Yuan <bin.yuan@itbconsult.com>
 * - Modified to generate sip report link
 * 
 */
 
trigger SIP_BI on SIP__c (before insert, before update) {   
    String triggerName = 'SIP_BI';
    list<SIP__c> list_sips = new list<SIP__c>();
     //************************* BEGIN Pre-Processing **********************************************
     //System.debug('************************* ' + triggerName + ': BEGIN Pre-Processing ********');
     //************************* END Pre-Processing ************************************************
     //System.debug('************************* ' + triggerName + ': END Pre-Processing **********');
     
     //************************* BEGIN Before Trigger **********************************************
    if(Trigger.isInsert) {   
        ClsSIPUitl.sipDataPopulation(trigger.new);   
        ClsSIPUitl.populatReportLinkForSIP(trigger.new[0]);
    }else if(Trigger.isUpdate){
    
        for(SIP__c sip: trigger.new) {
            if(sip.Plan_Participant__c != trigger.oldMap.get(sip.Id).Plan_Participant__c && ClsSIPUitl.isUpdate) {
                list_sips.add(sip);
            }
        }
        
        if(!list_sips.isEmpty()) {
            ClsSIPUitl.isUpdate = false;
            ClsSIPUitl.sipDataPopulation(list_sips);                        
        }
    }
     //************************* END Before Trigger ************************************************  
///   *****************   Application Split Start ************************************//
     if(Trigger.isInsert || Trigger.isUpdate)
     {
     
      for(SIP__c sip: trigger.new) {
String App_String='';
sip.Application_Text_part1__c ='';
sip.Application_Text_part2__c ='';
sip.Application_Text_part3__c ='';



System.debug('Application :'+sip.Application__c);
if(sip.Application__c != null)
 if(sip.Application__c.length()<200){
 sip.Application_Text_part1__c = sip.Application__c;
  sip.Application_Text_part2__c = sip.Application__c;
   sip.Application_Text_part3__c = sip.Application__c;}
 else
 {
for(String App_Sub_string :sip.Application__c.split(';') )
{
 App_String +=App_Sub_string+';';

 if(App_String.length()< 200  )
 {
 System.debug('App_Sub_string 1 ::'+App_Sub_string  + ':: App_String   1 length() ::'+ App_String.length() ) ;
  //System.debug('App_String before delete ::'+App_String);
  
  sip.Application_Text_part1__c = App_String.substring(0,App_String.length()-1) ;
  sip.Application_Text_part2__c = App_String.substring(0,App_String.length()-1) ;
   sip.Application_Text_part3__c = App_String.substring(0,App_String.length()-1) ;
  
  continue;
 }
 else if(App_String.length () > 200  && App_String.length()< 400 ){
  
  System.debug(' Sip Appl length 2, 1 : '+sip.Application_Text_part1__c.length() + ':: App_String 2 length()  ::'+ App_String.length() ) ;
  Integer length_2= sip.Application__c.substring(sip.Application_Text_part1__c.length(),App_String.length()-1).length() ;
 
 System.debug('sip.Application__c.substring(sip.Application_Text_part1__c.length()-1,App_String.length()-1).length()< 200  ::'+length_2 );
  
  if(sip.Application__c.substring(sip.Application_Text_part1__c.length()-1,App_String.length()-1).length()< 200 ){
   sip.Application_Text_part2__c = sip.Application__c.substring(sip.Application_Text_part1__c.length()+1,App_String.length()-1) ;
   sip.Application_Text_part3__c =  sip.Application__c.substring(sip.Application_Text_part1__c.length()+1,App_String.length()-1) ;
   }
  
  continue;
  }
  else if(App_String.length () > 400 ){
  System.debug(':: App_String  length :'+App_String.length()+'::App_String 3:: '+App_String  );
   System.debug(':: sip.Application_Text_part2__c. .length() 3::'+ sip.Application_Text_part2__c.length() + ' :: Sip Appl length 2,3  : '+sip.Application_Text_part2__c  ) ;
   Integer startLimit= sip.Application_Text_part1__c.length()+1+sip.Application_Text_part2__c.length()+1;
   sip.Application_Text_part3__c=sip.Application__c.substring( startLimit,App_String.length() -1);
  }

}
   }                

     }   
     }
     
     ///   *****************   Application Split end************************************//
     
}