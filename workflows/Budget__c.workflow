<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Approval_Email_to_Account_Manager</fullName>
        <description>Send Approval Email to Account Manager</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/Budget_ApprovalReply_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Budget_Approved_Email_to_Account_Manager</fullName>
        <description>Send budget approved Email to Account Manager</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/Budget_Approved_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Notification_to_Budget_Manager</fullName>
        <description>Send Notification to Budget Manager</description>
        <protected>false</protected>
        <recipients>
            <field>Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/Budget_Approval_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Define_Approved_Status</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Define Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Draft_Status</fullName>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>Define Draft Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Submitted_Status</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Define Submitted Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Budget Planning Approval Reply</fullName>
        <actions>
            <name>Send_Approval_Email_to_Account_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Budget Planning Approval reply</description>
        <formula>AND(NOT(ISNEW()),  ISCHANGED( Status__c ), ISPICKVAL(Status__c,&apos;Draft&apos;),$Setup.Admin_Profile_Exception__c.Run_Rule__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Budget Planning Approved</fullName>
        <actions>
            <name>Send_Budget_Approved_Email_to_Account_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Budget Planning Approved</description>
        <formula>AND(NOT(ISNEW()),  ISCHANGED( Status__c ),  ISPICKVAL(Status__c,&apos;Approved&apos;), $Setup.Admin_Profile_Exception__c.Run_Rule__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Submit Original Budget for Approval</fullName>
        <actions>
            <name>Send_Notification_to_Budget_Manager</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Submit Original Budget for Approval</description>
        <formula>AND(NOT(ISNEW()),  ISCHANGED(Status__c), ISPICKVAL(Status__c, &apos;Submitted&apos;) , $Setup.Admin_Profile_Exception__c.Run_Rule__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
