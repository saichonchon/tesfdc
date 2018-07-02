<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CC_Send_Transcript_to_Customer</fullName>
        <description>CC - Send Transcript to Customer</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/CC_Send_Transcript_To_Customer_HTML</template>
    </alerts>
    <alerts>
        <fullName>ICT_Send_Transcript_to_Customer</fullName>
        <description>ICT - Send Transcript to Customer</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>teconnectivityladd@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Email_Templates/ICT_Send_Transcript_To_Customer_HTML</template>
    </alerts>
    <alerts>
        <fullName>PIC_Send_Transcript_to_Customer</fullName>
        <description>PIC - Send Transcript to Customer</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>pic.noreply@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PIC_Automated_Messages/PIC_Send_Transcript_To_Customer_HTML</template>
    </alerts>
    <rules>
        <fullName>CC - Email Transcript to Customer upon finalization of Chat</fullName>
        <actions>
            <name>CC_Send_Transcript_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LiveChatTranscript.Body</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>9/27/2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.Chat_Type__c</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <description>Customer Care - Email Transcript to Customer upon finalization of Chat</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ICT - Email Transcript to Customer upon finalization of Chat</fullName>
        <actions>
            <name>ICT_Send_Transcript_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LiveChatTranscript.Body</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>9/27/2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.Chat_Type__c</field>
            <operation>notEqual</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.SkillId</field>
            <operation>equals</operation>
            <value>ICT US Team</value>
        </criteriaItems>
        <description>PIC - Email Transcript to Customer upon finalization of Chat</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Email Transcript to Customer upon finalization of Chat</fullName>
        <actions>
            <name>PIC_Send_Transcript_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LiveChatTranscript.Body</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.Email_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>9/27/2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.Chat_Type__c</field>
            <operation>notEqual</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>LiveChatTranscript.SkillId</field>
            <operation>notEqual</operation>
            <value>ICT US Team</value>
        </criteriaItems>
        <description>PIC - Email Transcript to Customer upon finalization of Chat</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
