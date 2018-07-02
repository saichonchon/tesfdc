<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Bidding_status_changed</fullName>
        <description>updates the field &apos;bidding status changed&apos; on Tender</description>
        <field>Bidding_status_changed__c</field>
        <formula>TODAY()</formula>
        <name>Bidding status changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Tender__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Bidding Status Changed</fullName>
        <actions>
            <name>Bidding_status_changed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Updates date field &apos;bidding status changed&apos;</description>
        <formula>ISCHANGED ( Bidding_Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
