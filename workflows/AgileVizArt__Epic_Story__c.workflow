<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AgileVizArt__Copy_to_Description_No_HTML</fullName>
        <field>AgileVizArt__Description_No_HTML__c</field>
        <formula>AgileVizArt__Description__c</formula>
        <name>Copy to Description (without HTML)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <rules>
        <fullName>AgileVizArt__Copy Description into Description %28without HTML%29</fullName>
        <actions>
            <name>AgileVizArt__Copy_to_Description_No_HTML</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies HTML description into a second field to remove HTML tags</description>
        <formula>OR(ISNEW(), ISCHANGED( AgileVizArt__Description__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
