<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_External_Id</fullName>
        <field>External_ID__c</field>
        <formula>Opportunity__c &amp;&apos;|&apos;&amp; Contact__c</formula>
        <name>Update External Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update External Id For Contact Role</fullName>
        <actions>
            <name>Update_External_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Custom_Opportunity_Contact_Role__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
