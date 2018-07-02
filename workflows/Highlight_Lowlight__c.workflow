<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <flowActions>
        <fullName>Fill_account_field_on_HL_LL</fullName>
        <flow>Highlight_Lowlight_Account_Fill</flow>
        <flowInputs>
            <name>varHL_LL_ID</name>
            <value>{!Id}</value>
        </flowInputs>
        <flowInputs>
            <name>varOppID</name>
            <value>{!Opportunity__r.Id}</value>
        </flowInputs>
        <label>Fill account field on HL_LL</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <rules>
        <fullName>Highlight_Lowlight Account_populate</fullName>
        <actions>
            <name>Fill_account_field_on_HL_LL</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Highlight_Lowlight__c.Opportunity_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>this rule triggers a flow that fills the account lookup in a HL/LL when the record is created from an opportunity</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
