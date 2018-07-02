<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Opp_Count_to_zero</fullName>
        <field>Count_of_linked_opportunities__c</field>
        <formula>0</formula>
        <name>Set Opp Count to zero</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Tender Count linked opps zero</fullName>
        <actions>
            <name>Set_Opp_Count_to_zero</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will set the count of linked opportunities to zero when a Tender is created. This prevents clones from having a value in the field when no opp is linked yet.</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
