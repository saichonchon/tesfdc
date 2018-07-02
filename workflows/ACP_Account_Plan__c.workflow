<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>reset_to_off</fullName>
        <field>ACP_Conga_Attachement__c</field>
        <literalValue>Off</literalValue>
        <name>reset to off</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Conga_Workflow_Email</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>ACP_Account_Manager__c</fields>
        <fields>ACP_Account_Name__c</fields>
        <fields>ACP_Account_Summary__c</fields>
        <fields>ACP_Customer_Challenges_and_Threats__c</fields>
        <fields>ACP_Customer_Major_Growth_Areas__c</fields>
        <fields>ACP_Customer_Strategy_Summary__c</fields>
        <fields>ACP_Customer_Website__c</fields>
        <fields>Account_Plan_Type__c</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>c2sdeployment.user@te.com.c2s</integrationUser>
        <name>Conga Workflow Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Conga_Workflow_PDF_Email</fullName>
        <apiVersion>40.0</apiVersion>
        <description>Outbound for conga pdfemail</description>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>PDF_Account_Plan_workflow_Formula__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>c2sdeployment.user@te.com.c2s</integrationUser>
        <name>Conga Workflow PDF Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Conga_Workflow_PDF_Email_41</fullName>
        <apiVersion>41.0</apiVersion>
        <description>New Outbound Message for ACP PDF Email</description>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>PDF_Account_Plan_workflow_Formula__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>lhartman@te.com.c2s</integrationUser>
        <name>Conga Workflow PDF Email-41</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Conga_Workflow_PDF_Email_Att</fullName>
        <apiVersion>40.0</apiVersion>
        <description>Outbound for conga PDF email</description>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>PDF_Account_Plan_workflow_Formula__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>acct_plan.deploy_user@te.com.c2s</integrationUser>
        <name>Conga Workflow PDF Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Conga_Workflow_PPT_Email</fullName>
        <apiVersion>40.0</apiVersion>
        <description>Outbound for conga ppt email</description>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>PPT_Account_Plan_workflow_formula__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>c2sdeployment.user@te.com.c2s</integrationUser>
        <name>Conga Workflow PPT Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Conga_Workflow_PPT_Email_41</fullName>
        <apiVersion>41.0</apiVersion>
        <description>Updated outbound message for ACP Conga PPT email</description>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>PPT_Account_Plan_workflow_formula__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>lhartman@te.com.c2s</integrationUser>
        <name>Conga Workflow PPT Email-41</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Conga_Workflow_Revenue_Bridge_Email</fullName>
        <apiVersion>41.0</apiVersion>
        <description>Sends outbound message for Revenue Bridge Email</description>
        <endpointUrl>https://workflow.congamerge.com/OBMListener.ashx</endpointUrl>
        <fields>Id</fields>
        <fields>Revenue_Bridge__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>lhartman@te.com.c2s</integrationUser>
        <name>Conga Workflow Revenue Bridge Email</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>ACP Conga assignment reset OFF</fullName>
        <actions>
            <name>reset_to_off</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>ACP_Account_Plan__c.ACP_Conga_Attachement__c</field>
            <operation>equals</operation>
            <value>PPT</value>
        </criteriaItems>
        <criteriaItems>
            <field>ACP_Account_Plan__c.ACP_Conga_Attachement__c</field>
            <operation>equals</operation>
            <value>PDF</value>
        </criteriaItems>
        <criteriaItems>
            <field>ACP_Account_Plan__c.ACP_Conga_Attachement__c</field>
            <operation>equals</operation>
            <value>Revenue Bridge</value>
        </criteriaItems>
        <description>it will reset conga assignment field to off.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Conga Workflow PDF Email</fullName>
        <actions>
            <name>Conga_Workflow_PDF_Email_41</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ACP_Account_Plan__c.ACP_Conga_Attachement__c</field>
            <operation>equals</operation>
            <value>PDF</value>
        </criteriaItems>
        <description>a workflow rule for Conga Workflow. It will send email with PDF attachment.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Conga Workflow PPT Email</fullName>
        <actions>
            <name>Conga_Workflow_PPT_Email_41</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ACP_Account_Plan__c.ACP_Conga_Attachement__c</field>
            <operation>equals</operation>
            <value>PPT</value>
        </criteriaItems>
        <description>a workflow rule for Conga Workflow.It will send email with ppt attachment.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Conga Workflow Revenue Bridge Email</fullName>
        <actions>
            <name>Conga_Workflow_Revenue_Bridge_Email</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ACP_Account_Plan__c.ACP_Conga_Attachement__c</field>
            <operation>equals</operation>
            <value>Revenue Bridge</value>
        </criteriaItems>
        <description>a workflow rule for Conga Workflow. It will send email for Revenue Bridge</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
