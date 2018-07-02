<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Linked_To_Parent_Check</fullName>
        <description>Update the checkbox on Activity Records</description>
        <field>Linked2Parent__c</field>
        <literalValue>1</literalValue>
        <name>Update Linked To Parent Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Activity Records</fullName>
        <actions>
            <name>Update_Linked_To_Parent_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rules updates the Activity Records if they have associated Lead information</description>
        <formula>AND(NOT(ISBLANK(Lead__c)),  NOT(Linked2Parent__c), NOT(ISNULL(CO_Lead_Id__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
