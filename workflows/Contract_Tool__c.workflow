<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>IND_Contract_Set_Tool_Type_Text_field</fullName>
        <field>Tool_Type_Text__c</field>
        <formula>TEXT(Type__c)</formula>
        <name>IND Contract Set Tool Type Text field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>IND Contract Set Tool Type text field</fullName>
        <actions>
            <name>IND_Contract_Set_Tool_Type_Text_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>copies the picklist value from tool type to a text field to make it searchable</description>
        <formula>OR( NOT(ISPICKVAL(Type__c, &apos;&apos;)), ISCHANGED( Type__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
