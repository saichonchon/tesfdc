<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>TEACstmrProfile__A_Cust_Approval_Recall_Email</fullName>
        <description>A Customer Approval Recall Email</description>
        <protected>false</protected>
        <recipients>
            <field>TEACstmrProfile__Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TEACstmrProfile__A_Customer_Profile/TEACstmrProfile__A_Customer_Recall_Email</template>
    </alerts>
    <alerts>
        <fullName>TEACstmrProfile__A_Cust_Approval_Request_Email</fullName>
        <description>A Customer Approval Request Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TEACstmrProfile__A_Customer_Profile/TEACstmrProfile__A_Customer_Approval_Request_Email</template>
    </alerts>
    <alerts>
        <fullName>TEACstmrProfile__A_Cust_Approved_Email</fullName>
        <description>A Customer Approved Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TEACstmrProfile__A_Customer_Profile/TEACstmrProfile__A_Customer_Approved_Email</template>
    </alerts>
    <alerts>
        <fullName>TEACstmrProfile__A_Cust_Rejected_Email</fullName>
        <description>A Customer Rejected Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TEACstmrProfile__A_Customer_Profile/TEACstmrProfile__A_Customer_Rejected_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>TEACstmrProfile__Update_Status_to_Approved</fullName>
        <field>TEACstmrProfile__Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEACstmrProfile__Update_Status_to_Not_Submitted</fullName>
        <field>TEACstmrProfile__Approval_Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Update Status to Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEACstmrProfile__Update_Status_to_Pending</fullName>
        <field>TEACstmrProfile__Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Update Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEACstmrProfile__Update_Status_to_Rejected</fullName>
        <field>TEACstmrProfile__Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>TEACstmrProfile__Unique %22A%22 Customer Plan Year</fullName>
        <active>false</active>
        <criteriaItems>
            <field>TEACstmrProfile__A_Customer_Profile__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Enforce uniqueness on &quot;A&quot; Customer Profile/Plan year</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
