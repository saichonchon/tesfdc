/*****************************************************************************************************************************************************
Name: insertCurrncyfromOpp 
Copyright Â© 2011 TE Connectivity
======================================================================================================================================================
Purpose: Inserting and updating Oppurtunity Currency to RTS Request Object  

======================================================================================================================================================
History:                                                        
------------------------------------------------------------------------------------------------------------------------------------------------------                                                         
VERSION AUTHOR        DATE         DETAIL                            Mercury Request #
------------------------------------------------------------------------------------------------------------------------------------------------------
    1.0 Gopi       06/07/2012   Initial Development 
*****************************************************************************************************************************************************/

trigger OppurtunityCurrencyToRTSobj on RTS_Request__c (before insert,before update) 
{
    /*-- 1.0 list of variable declaration -----------------*/
    list<id> Oppids=new list<id>();
    list<Opportunity> OppCurrency;
    map<id,String> allOppCurrency=new map<id,string>();
    
    if(Trigger.isbefore)
    {
        if(Trigger.isinsert || Trigger.isUpdate)
        {
            for(RTS_Request__c alloppids:trigger.new)
            {
                Oppids.add(alloppids.OpportunityName__c);
            }
            OppCurrency=[select id,CurrencyIsoCode from Opportunity where id=:Oppids];
            for(integer i=0;i<OppCurrency.size();i++)
            {
                allOppCurrency.put(OppCurrency[i].id,OppCurrency[i].CurrencyIsoCode );
            }
            for(RTS_Request__c alloppids:trigger.new)
            {
                if(allOppCurrency.containskey(alloppids.OpportunityName__c))
                {
                    alloppids.CurrencyIsoCode =allOppCurrency.get(alloppids.OpportunityName__c);
                }
            }
         }
    }  
}