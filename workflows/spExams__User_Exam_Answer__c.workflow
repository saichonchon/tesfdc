<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>spExams__Set_Is_Correct</fullName>
        <field>spExams__Is_Correct__c</field>
        <formula>IF( spExams__Answer__r.spExams__IsCorrect__c , &apos;Y&apos;, &apos;N&apos;)</formula>
        <name>sp - Set Is Correct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>spExams__Set_if_question_is_correct</fullName>
        <field>spExams__Is_Correct__c</field>
        <formula>IF(  spExams__User_Exam_Question__r.spExams__No_of_Correct_Answers__c = spExams__User_Exam_Question__r.spExams__Question__r.spExams__No_of_Correct_Answers__c , &apos;Y&apos;, &apos;N&apos;)</formula>
        <name>sp - Set if question is correct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>spExams__User_Exam_Question__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>spExams__sp_Set_Correct_Answer</fullName>
        <field>spExams__Is_Correct__c</field>
        <formula>&apos;Y&apos;</formula>
        <name>sp - Set Correct Answer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>spExams__sp_Set_Incorrect_Answer</fullName>
        <field>spExams__Is_Correct__c</field>
        <formula>&apos;N&apos;</formula>
        <name>sp - Set Incorrect Answer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>spExams__sp - Update Is Correct - Answer</fullName>
        <actions>
            <name>spExams__Set_Is_Correct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>spExams__User_Exam_Answer__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
