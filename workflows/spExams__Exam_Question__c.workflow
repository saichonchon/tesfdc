<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>spExams__sp_Set_Question_Type</fullName>
        <field>spExams__Question_Type__c</field>
        <formula>TEXT(spExams__Question__r.spExams__Type__c)</formula>
        <name>sp - Set Question Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>spExams__sp - Set Question Type</fullName>
        <actions>
            <name>spExams__sp_Set_Question_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>spExams__Exam_Question__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
