<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Intercontec_Sample_Request</fullName>
        <description>Intercontec Sample Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Inside Sales Intercontec</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Intercontec_Samples</template>
    </alerts>
    <alerts>
        <fullName>Intercontec_Sample_Request2</fullName>
        <description>Intercontec Sample Request</description>
        <protected>false</protected>
        <recipients>
            <field>Intercontec_Inside_Sales__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Sample_Request_IC_Created</template>
    </alerts>
    <alerts>
        <fullName>Sample_request_approved</fullName>
        <description>Sample request approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Sample_Request_Approval</template>
    </alerts>
    <alerts>
        <fullName>Sample_request_rejected</fullName>
        <description>Sample request rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Sample_Request_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Samples_approved</fullName>
        <description>Samples approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <field>Engineering__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Project_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/Sample_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Samples_built</fullName>
        <description>Samples built</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Samples_are_built</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Status_to_in_approval</fullName>
        <field>Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>Change Status to in approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Change status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_New</fullName>
        <field>Status__c</field>
        <literalValue>New</literalValue>
        <name>Change status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_to_rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Change status to rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Samples_build_date_on_opp</fullName>
        <field>Samples_Build_Date__c</field>
        <formula>TODAY()</formula>
        <name>Samples build date on opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_or_Rejection_Date</fullName>
        <description>sets the date when a sample request is approved or rejected</description>
        <field>Sample_Request_Appr_Rej_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Approval or Rejection Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Samples_Built_Date</fullName>
        <description>sets the date when samples are built</description>
        <field>Samples_Built_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Samples Built Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Submission_Date</fullName>
        <field>Sample_Request_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Submission Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Samples Built Date</fullName>
        <actions>
            <name>Samples_build_date_on_opp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Samples_Built_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Sample_Request__c.Samples_Built__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>sets the current date value when samples are marked as &apos;built&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
