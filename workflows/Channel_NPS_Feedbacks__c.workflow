<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EC_Survey_Detractor_Thanks</fullName>
        <description>EC Survey Detractor Thanks</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>tecustomersurvey@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Channel_NPS_Survey_templates/EC_Survey_Detractor_Thanks</template>
    </alerts>
    <alerts>
        <fullName>EC_Survey_Promoter_Passive_Thanks</fullName>
        <description>EC Survey Promoter Passive Thanks</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>tecustomersurvey@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Channel_NPS_Survey_templates/EC_Survey_Passive_Promoter_Thanks</template>
    </alerts>
    <alerts>
        <fullName>Internal_Notification_of_Participation_Detractor</fullName>
        <description>Internal Notification of Participation_Detractor</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>tecustomersurvey@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Channel_NPS_Survey_templates/Internal_Notification_of_Participation_Detractor</template>
    </alerts>
    <alerts>
        <fullName>Internal_Notification_of_Participation_Passive_Promoter</fullName>
        <description>Internal Notification of Participation Passive Promoter</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderAddress>tecustomersurvey@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Channel_NPS_Survey_templates/Internal_Notification_of_Participation_Passive_Promoter</template>
    </alerts>
    <rules>
        <fullName>EC Survey Detractor Thanks</fullName>
        <active>true</active>
        <booleanFilter>1 AND (2 or 3)</booleanFilter>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EC Survey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.NPS_Products_Group__c</field>
            <operation>equals</operation>
            <value>Detractor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.NPS_Distributor_Group__c</field>
            <operation>equals</operation>
            <value>Detractor</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EC_Survey_Detractor_Thanks</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Channel_NPS_Feedbacks__c.Survey_Received_DateTime__c</offsetFromField>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>EC Survey Internal Notification of Participation Detractor</fullName>
        <actions>
            <name>Internal_Notification_of_Participation_Detractor</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.NPS_Products_Group__c</field>
            <operation>equals</operation>
            <value>Detractor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.NPS_Distributor_Group__c</field>
            <operation>equals</operation>
            <value>Detractor</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EC Survey Internal Notification of Participation Passive Promoter</fullName>
        <actions>
            <name>Internal_Notification_of_Participation_Passive_Promoter</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.NPS_Products_Group__c</field>
            <operation>equals</operation>
            <value>Passive,Promoter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.NPS_Distributor_Group__c</field>
            <operation>equals</operation>
            <value>Promoter,Passive</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>EC Survey Promoter Passive Thanks</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>EC Survey</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.NPS_Products_Group__c</field>
            <operation>equals</operation>
            <value>Passive,Promoter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Channel_NPS_Feedbacks__c.NPS_Distributor_Group__c</field>
            <operation>equals</operation>
            <value>Promoter,Passive</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>EC_Survey_Promoter_Passive_Thanks</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Channel_NPS_Feedbacks__c.Survey_Received_DateTime__c</offsetFromField>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
