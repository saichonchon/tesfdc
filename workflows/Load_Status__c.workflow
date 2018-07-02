<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Load_status_update</fullName>
        <description>to update the field status message in load status object when data load has completed</description>
        <field>Status_Message__c</field>
        <formula>&quot;The load of &quot; &amp; Data_Source_Description__c &amp;&quot; for &quot; &amp; TEXT(TODAY()) &amp;&quot; has finished.&quot;</formula>
        <name>Load status update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Data load status change</fullName>
        <actions>
            <name>Load_status_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>when the data load has finished, this workflow will update the field &apos;status message&apos; to trigger a Chatter message to which a user can subscribe</description>
        <formula>ISCHANGED( Fiscal_Days_until_today__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
