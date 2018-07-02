<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Fill_IND_Profit_Centre_Groups</fullName>
        <description>In this field we group the SAP Profit Centres for Industrials in to the subvertical definitions for Industrial.</description>
        <field>IND_Profit_Centre_Groups__c</field>
        <formula>CASE(SAP_Profit_Center_Code__c, 
&apos;0000000268&apos;, &apos;A&amp;C&apos;, 
&apos;0000000292&apos;, &apos;A&amp;C&apos;, 
&apos;0000000266&apos;, &apos;IB&apos;, 
&apos;0000000291&apos;, &apos;IB&apos;, 
&apos;0000000294&apos;, &apos;IB&apos;, 
&apos;0000000254&apos;, &apos;IB&apos;, 
&apos;0000000412&apos;, &apos;Systems&apos;,
&apos;0000000419&apos;, &apos;Devices&apos;,
&apos;0000000418&apos;, &apos;Systems&apos;, 
&apos;0000000265&apos;, &apos;Rail&apos;, 
&apos;0000000293&apos;, &apos;Rail&apos;, 
&apos;0000000290&apos;, &apos;Rail&apos;,  IND_Profit_Centre_Groups__c)</formula>
        <name>Fill IND Profit Centre Groups</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set IND Profit Centre Group</fullName>
        <actions>
            <name>Fill_IND_Profit_Centre_Groups</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>OLD:OR( ISNEW(), ISCHANGED(SAP_Profit_Center_Code__c), ISCHANGED(IND_Profit_Centre_Groups__c), ISCHANGED(IND_Profit_Workflow_Timestamp__c) )</description>
        <formula>OR( ISNEW(), ISCHANGED(SAP_Profit_Center_Code__c),
ISCHANGED(IND_Profit_Workflow_Timestamp__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
