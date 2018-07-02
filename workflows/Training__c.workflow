<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Deactive_Training_active_flag</fullName>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Deactive Training active flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Calender_Body_Invite</fullName>
        <field>Body_of_Outlook_Invite_Mail__c</field>
        <formula>&apos;Hi,&apos;&amp; BR() &amp; Br() &amp;

&apos;Please Click on below Link to go to the Training Room Page:&apos; &amp; BR() &amp; Br() &amp; &apos;https://c2s.my.salesforce.com/apex/IND_Invite_TrainingRoomPage?id=&apos;&amp;Id &amp; Br() &amp;Br()&amp;
&apos;Trainer Name:  &apos;+Name_of_the_Trainer__c  &amp;Br()&amp;
&apos;Email of Trainer: &apos;+ Email_of_Trainner__c &amp; Br()&amp;Br()

 &amp; BR() &amp; Br() &amp;
&apos;Regards&apos;&amp; BR() &amp; 
&apos;Industrial&apos;&amp;&apos;  &apos;&amp; &apos;Team&apos;</formula>
        <name>Update Calender Body Invite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Deactive Training when Last day crossed</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Training__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Training__c.Date_of_Training__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Training__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deactive_Training_active_flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Training__c.Date_of_Training__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Calender Invite Body</fullName>
        <actions>
            <name>Update_Calender_Body_Invite</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Training__c.Location_of_Training__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
