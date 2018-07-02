<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NPS_2nd_Mail_to_Contact_Owner</fullName>
        <description>NPS 2nd Mail to Contact Owner</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NPS_Templates/NPS_Contact_Owner_Notification</template>
    </alerts>
    <alerts>
        <fullName>NPS_Contact_Owner_Notification</fullName>
        <description>NPS Contact Owner Notification</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NPS_Templates/NPS_Contact_Owner_Notification</template>
    </alerts>
    <alerts>
        <fullName>NPS_Contact_Owner_Notification_HTML</fullName>
        <description>NPS Contact Owner Notification HTML</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NPS_Templates/NPS_Reminder_Contact_Owner</template>
    </alerts>
    <alerts>
        <fullName>X1st_Reminder_to_participate_in_Survey</fullName>
        <description>1st Reminder to participate in Survey</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NPS_Templates/NPS_First_ReminderHTML</template>
    </alerts>
    <alerts>
        <fullName>X2nd_Email_Reminder_to_the_contact_to_participate_the_NPS_Survey</fullName>
        <description>2nd Email Reminder to the contact to participate the NPS Survey</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NPS_Templates/NPS_Second_Reminder_HTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>Qualtrics_App_Field_Update</fullName>
        <field>Actual_sent_date__c</field>
        <formula>NOW()</formula>
        <name>Qualtrics App Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Qualtrics_IND_Field_Update</fullName>
        <field>Actual_sent_date__c</field>
        <formula>NOW()</formula>
        <name>Qualtrics IND Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Outbound_to_Qualtrics_Appliances2</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://teconnectivity.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_1H3ZfmWOU0bwm21&amp;s=SV_6A9xOonWBLM94qh&amp;t=TR_eOKLUrztVrRL2Kx</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>qualtrics@te.com</integrationUser>
        <name>Outbound to Qualtrics Appliances</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Outbound_to_Qualtrics_IND_NPS</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://teconnectivity.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_8Bt6ttp3eUX12Zf&amp;s=SV_7aHuz1McDo6Tbox&amp;t=TR_3RiJrvbJnW1hbIF</endpointUrl>
        <fields>CampaignId</fields>
        <fields>ContactId</fields>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>prabhanjan.nandyala@te.com.c2s</integrationUser>
        <name>Outbound to Qualtrics IND NPS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Qualtrics_Outbound_IND</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://teconnectivity.co1.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_8Bt6ttp3eUX12Zf&amp;s=SV_7aHuz1McDo6Tbox&amp;t=TR_3RiJrvbJnW1hbIF</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>qualtrics@te.com</integrationUser>
        <name>Qualtrics - Outbound - IND</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>NPS 1st Reminder to Contact</fullName>
        <active>true</active>
        <description>Time Based Workflow which sends out an Email Reminder to the contact to participate in the NPS Survey. This mai is triggered by field: first_reminder_customer_date__c</description>
        <formula>AND(
HasResponded = False,
Contact.Inactive__c = False,
Campaign.IsActive = True,
Contact.NPS_OPT_OUT__c = False,
Contact.NPS_Contact__c = True)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X1st_Reminder_to_participate_in_Survey</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CampaignMember.First_Reminder_Customer_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NPS 2nd Reminder to Contact</fullName>
        <active>true</active>
        <description>Time Based Workflow which sends out an Email Reminder to the contact to participate in the NPS Survey. This mai is triggered by field: second_reminder_customer_date__c.</description>
        <formula>AND(
HasResponded = False,
Contact.Inactive__c = False,
Campaign.IsActive = True,
Contact.NPS_OPT_OUT__c = False,
Contact.NPS_Contact__c = True)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X2nd_Email_Reminder_to_the_contact_to_participate_the_NPS_Survey</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CampaignMember.Second_Reminder_Customer_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NPS Contactowner Notification</fullName>
        <active>true</active>
        <description>An Email to the Contact Owner showing contacts who did not respond the survey yet. Trigger Dates are: First reminder contact owner date and Second reminder contact owner date</description>
        <formula>AND(
Campaign.IsActive = True,
HasResponded = False,
NPS_OPT_OUT__c = False,
Contact.NPS_Contact__c = True,
Contact.Inactive__c = False,
Campaign.RecordType.DeveloperName = &apos;NPS&apos;
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NPS_Contact_Owner_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CampaignMember.First_Reminder_Contact_Owner_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>NPS_2nd_Mail_to_Contact_Owner</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CampaignMember.Second_Reminder_Contact_Owner_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Qualtrics - NPS Survey - IND</fullName>
        <active>true</active>
        <description>This is to send the Survey invocation Qualtrics with Outbound message</description>
        <formula>AND(  ISPICKVAL(Campaign.Campaign_Type__c, &quot;Industries&quot;),  Campaign.IsActive,  NOT(Contact.IND_Qualtrics_Survey_Taken__c), Qualtrics_Survey_Sent__c  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Qualtrics_IND_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Qualtrics_Outbound_IND</name>
                <type>OutboundMessage</type>
            </actions>
            <offsetFromField>CampaignMember.Qualtrics_Schedule_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Qualtrics - NPS Survey Appliances1</fullName>
        <active>true</active>
        <description>This is to send the Survey invocation Qualtrics with Outbound message</description>
        <formula>AND(  ISPICKVAL(Campaign.Campaign_Type__c, &quot;Appliance&quot;), Campaign.IsActive,  NOT(Contact.IND_Qualtrics_Survey_Taken__c), Qualtrics_Survey_Sent__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Qualtrics_App_Field_Update</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Outbound_to_Qualtrics_Appliances2</name>
                <type>OutboundMessage</type>
            </actions>
            <offsetFromField>CampaignMember.Qualtrics_Schedule_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
