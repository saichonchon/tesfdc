<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APL_AM_Relay_Unfreeze_Reminder</fullName>
        <description>APL AM/Relay Unfreeze Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/APL_AM_Relay_Unfreeze_Reminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Manager_Name</fullName>
        <field>Name</field>
        <formula>Manager__r.FirstName &amp; &apos;,&apos; +  Manager__r.LastName</formula>
        <name>Set Manager Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>APL RSM Unfreeze Remind</fullName>
        <actions>
            <name>APL_AM_Relay_Unfreeze_Reminder</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>APL_Forecast_Management__c.RSM_Freeze__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>APL_Forecast_Management__c.AM_Freeze__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Manager Name</fullName>
        <actions>
            <name>Set_Manager_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
