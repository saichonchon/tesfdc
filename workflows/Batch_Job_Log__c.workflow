<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Batch_job_Log_via_Email</fullName>
        <description>Send Batch job Log via Email</description>
        <protected>false</protected>
        <recipients>
            <field>Running_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Batch_Job_Log</template>
    </alerts>
    <rules>
        <fullName>Send Batch Job Log</fullName>
        <actions>
            <name>Send_Batch_job_Log_via_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
