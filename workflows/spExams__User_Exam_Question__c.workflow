<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>spExams__Update_Is_Correct</fullName>
        <field>spExams__Is_Correct__c</field>
        <formula>IF(
AND
(
  spExams__No_of_Answers__c =  spExams__Question__r.spExams__No_of_Correct_Answers__c ,
  spExams__No_of_Correct_Answers__c =  spExams__Question__r.spExams__No_of_Correct_Answers__c
), &apos;Y&apos;, &apos;N&apos;)</formula>
        <name>sp - Update Is Correct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>spExams__sp - Update Is Correct - Question</fullName>
        <actions>
            <name>spExams__Update_Is_Correct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>spExams__User_Exam__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
