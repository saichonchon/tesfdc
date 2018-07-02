<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Campaign_ROI_False</fullName>
        <description>Set &apos;Include In Opportunity ROI&apos; to false</description>
        <field>TEMarketing__Include_In_Opportunity_ROI__c</field>
        <literalValue>0</literalValue>
        <name>Campaign ROI False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deactivate_Campaign</fullName>
        <description>If the campaign end date is greater than today, the campaign will be deactivated</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Deactivate Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deactivate_Campaigns</fullName>
        <description>This timebased workflow deactivates Campaigns after campaign end date is reached</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Deactivate Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enddate</fullName>
        <description>Enddate = Startdate +17</description>
        <field>EndDate</field>
        <formula>(StartDate) + 17</formula>
        <name>Enddate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enddate_Startdate_17</fullName>
        <field>EndDate</field>
        <formula>StartDate + 17</formula>
        <name>Enddate = Startdate + 17</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Enddate_Startdate_17_1</fullName>
        <field>EndDate</field>
        <formula>StartDate + 17</formula>
        <name>Enddate = Startdate + 17</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_BU_Code</fullName>
        <description>Update the Business Unit Code field when the Business Unit changes</description>
        <field>Business_Unit_Code__c</field>
        <formula>CASE( TEXT(Business_Unit__c) , &quot;Appliance&quot;, &quot;apl&quot;, &quot;Appliances&quot;, &quot;apl&quot;, 
&quot;Industrial &amp; Commercial Transportations&quot;, &quot;ict&quot;,
LEFT(SUBSTITUTE(TEXT(Business_Unit__c), &quot; &quot;, &quot;_&quot;), 3))</formula>
        <name>Update Campaign BU Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Campaign_Region_Code</fullName>
        <description>Update the Region Code field when the Region changes</description>
        <field>Region_Code__c</field>
        <formula>CASE( TEXT(Region__c) ,
&quot;Americas&quot;,&quot;usa&quot;,
&quot;APAC&quot;,&quot;jpn&quot;,
&quot;China&quot;,&quot;chn&quot;,
&quot;EMEA&quot;,&quot;deu&quot;,
&quot;Global&quot;, &quot;glo&quot;,
&quot;Germany&quot;, &quot;deu&quot;,
&quot;Japan&quot;, &quot;jpn&quot;,
&quot;USA&quot;, &quot;usa&quot;,
LEFT(LOWER(SUBSTITUTE(TEXT( Region__c), &quot; &quot;, &quot;_&quot;)),3))</formula>
        <name>Update Campaign Region Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign ROI - NPS</fullName>
        <actions>
            <name>Campaign_ROI_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>NPS</value>
        </criteriaItems>
        <description>Sets &apos;Include in Opportunity ROI&apos; to false by default for NPS campaigns</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NPS Campaign Deactivation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.EndDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.EndDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If the campaign end date is reached, the campaign will be deactivated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deactivate_Campaigns</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NPS Campaign End Date</fullName>
        <actions>
            <name>Enddate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.StartDate</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>this Workflow calculates Enddate of the campaign (StartDate+17)</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Campaign BU Code</fullName>
        <actions>
            <name>Update_BU_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Business Unit Code field when the Business Unit changes</description>
        <formula>PRIORVALUE( Business_Unit__c ) != TEXT(Business_Unit__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Campaign Region Code</fullName>
        <actions>
            <name>Update_Campaign_Region_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Region Code field when the Region changes</description>
        <formula>PRIORVALUE(  Region__c ) != TEXT(Region__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
