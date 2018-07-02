<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Optics_Sample_Approved</fullName>
        <description>Optics Sample Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Optics_Sample_Approved</template>
    </alerts>
    <alerts>
        <fullName>Optics_Sample_Committed_Ship_Date</fullName>
        <description>Optics Sample Committed Ship Date</description>
        <protected>false</protected>
        <recipients>
            <field>Opportunity_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Optics_Sample_Ship_Date</template>
    </alerts>
    <alerts>
        <fullName>Optics_Sample_Rejected</fullName>
        <description>Optics Sample Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Optics_Sample_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>OS_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>OS Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OS_In_Approval</fullName>
        <field>Approval_Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>OS In Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OS_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>OS Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Optics_Opportunity_Owner</fullName>
        <field>Opportunity_Owner_Email__c</field>
        <formula>Opportunity__r.Owner.Email</formula>
        <name>Optics Opportunity Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Optics Sample Committed Ship Date</fullName>
        <actions>
            <name>Optics_Sample_Committed_Ship_Date</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Optics_Opportunity_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(Committed_Ship_Date__c)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
