<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PIC_Notify_Agent_of_File_Upload</fullName>
        <description>PIC - Notify Agent of File Upload</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pic.info@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PIC_Automated_Messages/PIC_Live_Agent_File_Notification</template>
    </alerts>
    <rules>
        <fullName>PIC - Notify Owner of File</fullName>
        <actions>
            <name>PIC_Notify_Agent_of_File_Upload</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Live_Agent_Files__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notifies the record owner that a new file has been uploaded</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
