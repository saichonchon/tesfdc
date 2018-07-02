<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>TEACstmrProfile__Update_A_Customer_Last_Updated</fullName>
        <description>This field update action will be fired to update the Last Updated on &quot;A&quot; Customer Profile object whenever attachments are created or updated</description>
        <field>TEACstmrProfile__Hidden_Do_Not_Use__c</field>
        <formula>Now()</formula>
        <name>Update A Customer Last Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>TEACstmrProfile__A_Customer_Profile__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>TEACstmrProfile__Update A Customer Last Updated</fullName>
        <actions>
            <name>TEACstmrProfile__Update_A_Customer_Last_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This field update action will be fired to update the Last Updated on &quot;A&quot; Customer Profile object whenever attachments are created or updated</description>
        <formula>1 = 1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
