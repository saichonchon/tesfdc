<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Competitor_Update_Oppy_Last_Modified</fullName>
        <description>Updates the Opportunity custom Last Modified Date.</description>
        <field>Last_Modified_Date__c</field>
        <formula>Now()</formula>
        <name>Competitor Update Oppy Last Modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Competitor Update Oppy Last Modified</fullName>
        <active>false</active>
        <description>This WF rule triggers update of custom Opportunity Last Modified Date field in case a competitor record is created or updated.</description>
        <formula>AND(  $Profile.Name &lt;&gt; &quot;Systemadministrator&quot;,  $Profile.Name &lt;&gt; &quot;System Administrator&quot;,  $Profile.Name &lt;&gt; &quot;BU Admin&quot;,  $Profile.Name &lt;&gt; &quot;Service Account&quot;,  $Profile.Name &lt;&gt; &quot;Partner Admin&quot;,  $Profile.Name &lt;&gt; &quot;Regional Admin&quot;,  $Profile.Name &lt;&gt; &quot;Production Support&quot;,  $Profile.Name &lt;&gt; &quot;BU Analyst&quot;,   $Profile.Name &lt;&gt; &quot;Marketing Analyst&quot;,  $Profile.Name &lt;&gt; &quot;NPS Admin&quot;,  $Profile.Name &lt;&gt; &quot;OwnBackupAdminProfile&quot;,  $Profile.Name &lt;&gt; &quot;Regional Admin Channel&quot;  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
