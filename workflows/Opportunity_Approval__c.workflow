<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Approval_Step</fullName>
        <field>Approval_Step__c</field>
        <formula>Approval_Step__c + 1</formula>
        <name>Update Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity Approval update</fullName>
        <active>true</active>
        <formula>NOT(ISBLANK(Opportunity__c))</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Approval_Step</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Opportunity_Approval__c.Fire_Time__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
