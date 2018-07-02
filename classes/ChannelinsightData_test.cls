//This class is to cover Channelinsight Error in test classes.
@istest
public class ChannelinsightData_test
{
    public static void Channelinsightdata_test()
    {
            Type t = Type.forName('Channelinsight__CI_Configuration__c');
            if(t != null)
            {
                Sobject  c =  (Sobject) t.newInstance();
                c.put('Name', 'Default');
                c.put('Channelinsight__CONF_Stop_Matching_POS_to_Opportunity__c', 'Opportunity Is Closed');
                c.put('Channelinsight__CONF_Salesforce_Environment__c', 'Sandbox');
                c.put('Channelinsight__CONF_Reprocess_Reviewed__c', true);
                c.put('Channelinsight__CONF_Disable_Address_Type_Matching__c', true); 
                c.put('Channelinsight__CONF_Auto_mark_POS_Reviewed__c', false); 
                c.put('Channelinsight__CONF_Acct_Sales_Trending_Default_Address__c', 'Bill-to');
                insert c;
            }
    }
}