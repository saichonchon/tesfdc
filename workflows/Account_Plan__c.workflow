<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Define_Approved_Status</fullName>
        <description>Sets Approval Status to &quot;Approved&quot;.</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Define Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Pending_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Define Pending Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Rejected_Status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Define Rejected Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Flag_Replicate_to_Central_Org</fullName>
        <description>If an account plan record is approved, set Replicate_to_Central_Org__c true</description>
        <field>Replicate_to_Central_Org__c</field>
        <literalValue>1</literalValue>
        <name>Set Flag Replicate to Central Org</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stauts</fullName>
        <description>After recall update status to not submitted</description>
        <field>Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Define Not Submitted Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
