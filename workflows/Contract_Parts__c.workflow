<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IND_Contract_update_Part_text_field</fullName>
        <field>Part_Number_Text__c</field>
        <formula>Part_Number__r.Name</formula>
        <name>IND Contract update Part text field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IND Contract Copy Part Name</fullName>
        <actions>
            <name>IND_Contract_update_Part_text_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>copies that part name in a free text field to enable global search</description>
        <formula>OR( NOT(ISBLANK(Part_Number__c)), ISCHANGED( Part_Number__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
