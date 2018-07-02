<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AgileVizArt__Copy_to_Comment_No_HTML</fullName>
        <description>Description (without HTML)</description>
        <field>AgileVizArt__Comment__c</field>
        <formula>AgileVizArt__Comment_With_HTML__c</formula>
        <name>Copy to Comment (without HTML)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Update_Comment_Date</fullName>
        <field>AgileVizArt__Last_Comment_Update__c</field>
        <formula>NOW()</formula>
        <name>Update Comment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
        <targetObject>AgileVizArt__Parent__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>AgileVizArt__Copy Comment into Comment %28without HTML%29</fullName>
        <actions>
            <name>AgileVizArt__Copy_to_Comment_No_HTML</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies HTML comment into a second field to remove HTML tags</description>
        <formula>OR(ISNEW(), ISCHANGED( AgileVizArt__Comment_With_HTML__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Last Comment Update</fullName>
        <actions>
            <name>AgileVizArt__Update_Comment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates last comment date field on user story</description>
        <formula>FALSE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
