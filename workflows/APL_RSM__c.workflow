<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Manager_Name</fullName>
        <field>Name</field>
        <formula>Manager__r.FirstName &amp;&apos;, &apos; &amp;  Manager__r.LastName</formula>
        <name>Populate Manager Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Manager Name</fullName>
        <actions>
            <name>Populate_Manager_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
