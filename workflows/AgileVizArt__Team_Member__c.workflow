<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AgileVizArt__Set_Unique_Nick_Name</fullName>
        <field>AgileVizArt__Unique_Nick_Name__c</field>
        <formula>AgileVizArt__Project__c &amp; &quot;|&quot; &amp;  AgileVizArt__Nick_Name__c</formula>
        <name>Set Unique Nick Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>AgileVizArt__Enforce Unique Nickname</fullName>
        <actions>
            <name>AgileVizArt__Set_Unique_Nick_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Checks if nickname already exists by project</description>
        <formula>OR(ISNEW(), ISCHANGED( AgileVizArt__Nick_Name__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
