<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DTC_Send_Email_when_Sample_Request_is_Closed</fullName>
        <description>DTC Send Email when Sample Request is Closed</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/DTC_Send_Email_when_Sample_Req_Closed</template>
    </alerts>
    <alerts>
        <fullName>DTC_Send_Notification_to_PM</fullName>
        <description>DTC Send Notification to PM</description>
        <protected>false</protected>
        <recipients>
            <field>Product_Manager_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/DTC_ESR_Email</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_PM_Approved</fullName>
        <description>Email Alert PM Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/PrototypeRequest_Approved</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_PM_Committed</fullName>
        <description>Email Alert PM Committed</description>
        <protected>false</protected>
        <recipients>
            <field>Product_Manager_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/PrototypeRequest_CommitDate</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_PM_Rejection</fullName>
        <description>Email Alert PM Rejection</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/PrototypeRequest_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_PM_Shipped</fullName>
        <description>Email Alert PM Shipped</description>
        <protected>false</protected>
        <recipients>
            <field>Submitted_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/PrototypeRequest_ShipDate</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_PM</fullName>
        <description>Email Alert to PM</description>
        <protected>false</protected>
        <recipients>
            <field>Product_Manager_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/Budget_Approval_Notification</template>
    </alerts>
    <alerts>
        <fullName>Send_Engineering_Sample_Request</fullName>
        <ccEmails>kevin.weidner@te.com</ccEmails>
        <description>Send Engineering Sample Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>dia.siraki@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jahill@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kmccue@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shannon.andreas@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/DTC_ESR_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Notification_Sent_to_PM</fullName>
        <field>Send_Notification_to_PM__c</field>
        <literalValue>1</literalValue>
        <name>Notification Sent to PM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovedCheckboxNo</fullName>
        <field>Approved__c</field>
        <literalValue>0</literalValue>
        <name>UpdateApprovedCheckboxNo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovedCheckboxYes</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>UpdateApprovedCheckboxYes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Pending</fullName>
        <field>Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Update Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Alert Product Manager</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Prototype_Sample_Request__c.Product_Manager_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends an email to the Product Manager</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DTC - Send Sample Request</fullName>
        <actions>
            <name>Send_Engineering_Sample_Request</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Status_to_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Engineering_Sample_Request_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Prototype_Sample_Request__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DTC Sample Record Type</value>
        </criteriaItems>
        <description>Sends email to designated DataComm personnel for entry into RTS.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DTC Send Email when Req is Closed</fullName>
        <actions>
            <name>DTC_Send_Email_when_Sample_Request_is_Closed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Prototype_Sample_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DTC Send Notification to PM C%2FA</fullName>
        <actions>
            <name>DTC_Send_Notification_to_PM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Notification_Sent_to_PM</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Prototype_Sample_Request__c.Product_Manager_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Prototype_Sample_Request__c.Product_Group__c</field>
            <operation>equals</operation>
            <value>Cable Assemblies</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PrototypeRequestCommittedEmail</fullName>
        <actions>
            <name>Email_Alert_PM_Committed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When Prototype Request is updated to contain a Commit Date, email will be sent to Submitted_By__c user.</description>
        <formula>AND( NOT(ISBLANK(Commit_Date__c)) , Approved__c = TRUE ,  $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PrototypeRequestShippedEmail</fullName>
        <actions>
            <name>Email_Alert_PM_Shipped</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When Prototype Request is updated to contain a Ship Date, email will be sent to Submitted_By__c user.</description>
        <formula>AND( NOT(ISBLANK(Ship_Date__c)) , $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Engineering_Sample_Request_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Engineering Sample Request Sent</subject>
    </tasks>
    <tasks>
        <fullName>Notification_Sent_to_PM</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Notification Sent to PM</subject>
    </tasks>
</Workflow>
