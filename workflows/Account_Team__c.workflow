<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OpportunityAccessupdate</fullName>
        <field>Opportunity_Access__c</field>
        <literalValue>Read-Only</literalValue>
        <name>OpportunityAccessupdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>OpportunityAccessupdate</fullName>
        <actions>
            <name>OpportunityAccessupdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Account_Team__c.Role__c</field>
            <operation>equals</operation>
            <value>Customer Service Rep (CSR)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Team__c.Opportunity_Access__c</field>
            <operation>equals</operation>
            <value>Edit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Team__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC User</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
