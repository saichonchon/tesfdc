<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_ESR_Notification_to_PM_CA</fullName>
        <description>Send ESR Notification to PM - CA</description>
        <protected>false</protected>
        <recipients>
            <recipient>cgrant@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>david.stonfer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jahill@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kevin.weidner@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>lgdecker@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>pat.dipaola@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sborgas@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shannon.andreas@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DTC_Send_Notification_of_New_DTC_Request</template>
    </alerts>
    <alerts>
        <fullName>Send_Email_Notification_to_Active_Optics_product_group</fullName>
        <ccEmails>nenad.lalic@te.com</ccEmails>
        <ccEmails>David.Nidelius@te.com</ccEmails>
        <description>Send Email Notification to Active Optics product group</description>
        <protected>false</protected>
        <recipients>
            <recipient>dennis.hess@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>erin.byrne@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>thomas.giunta@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tomas.maj@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DTC_Send_Notification_of_New_DTC_Request_AO</template>
    </alerts>
    <fieldUpdates>
        <fullName>Send_to_RTS_Default_value</fullName>
        <field>Send_to_RTS__c</field>
        <literalValue>1</literalValue>
        <name>Send to RTS Default value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RTS - Send Notification - AO</fullName>
        <actions>
            <name>Send_Email_Notification_to_Active_Optics_product_group</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Notification_sent_to_Active_Optics_Team</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RTS_Request__c.Product_Group__c</field>
            <operation>equals</operation>
            <value>Active Optics</value>
        </criteriaItems>
        <criteriaItems>
            <field>RTS_Request__c.Business_Unit__c</field>
            <operation>contains</operation>
            <value>cis</value>
        </criteriaItems>
        <description>Sends an email notification to Active Optics product group</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RTS - Send Notification to PM - CA</fullName>
        <actions>
            <name>Send_ESR_Notification_to_PM_CA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>RTS_Request_Sent_to_PM</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RTS_Request__c.Request_Type__c</field>
            <operation>equals</operation>
            <value>Engineering Sample Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>RTS_Request__c.Product_Group__c</field>
            <operation>equals</operation>
            <value>Cable Assemblies</value>
        </criteriaItems>
        <description>Sends an email alert to the Cable Assemblies product group when an RTS sample request is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send to RTS Default value</fullName>
        <actions>
            <name>Send_to_RTS_Default_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>User.GIBU__c</field>
            <operation>equals</operation>
            <value>Appliances,Data &amp; Devices</value>
        </criteriaItems>
        <description>Default value for Appliances users</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Notification_sent_to_Active_Optics_Team</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Notification sent to Active Optics Team</subject>
    </tasks>
    <tasks>
        <fullName>RTS_Request_Sent_to_PM</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>RTS Request Sent to PM</subject>
    </tasks>
</Workflow>
