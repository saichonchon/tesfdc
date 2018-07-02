<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Survey_Name_Survey_Question</fullName>
        <field>Survey_Name_Survey_Question__c</field>
        <formula>Question__r.Survey__r.Name + &apos;-&apos; + Question__r.Name</formula>
        <name>Update Survey Name - Survey Question</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Survey Name - Survey Question</fullName>
        <actions>
            <name>Update_Survey_Name_Survey_Question</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
