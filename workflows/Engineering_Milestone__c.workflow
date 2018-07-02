<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Opportunity_phase_and_TE_project_mismatch</fullName>
        <description>Opportunity phase and TE project mismatch</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/Opportunity_and_Project_Mismatch</template>
    </alerts>
    <rules>
        <fullName>Opportunity and Project Mismatch</fullName>
        <actions>
            <name>Opportunity_phase_and_TE_project_mismatch</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This WF rule will send an email if the &apos;Actual&apos; date is entered for the &apos;G3&apos; or &apos;G6&apos;milestone and the opportunity is not set to won or production.</description>
        <formula>AND(
OR(
Opportunity__r.Owner.Profile.Name = &apos;Industrial User w/ Cost&apos;,
Opportunity__r.Owner.Profile.Name = &apos;Industrial Standard User&apos;,
Opportunity__r.Owner.Profile.Name = &apos;Industrial Engineering User w/Cost&apos;,
Opportunity__r.Owner.Profile.Name = &apos;Channel Standard User&apos;
),
OR(
Opportunity__r.RecordType.DeveloperName = &quot;Channel_Engineering_Opportunity&quot;,
Opportunity__r.RecordType.DeveloperName = &quot;IND_Engineering_project&quot;,
Opportunity__r.RecordType.DeveloperName = &quot;Opportunity_Product_Platform&quot;,
Opportunity__r.RecordType.DeveloperName = &quot;Opportunity_Engineering_Project&quot;
),
 Opportunity__r.Project_Status_Level__c &lt;&gt;&quot;&quot;,
NOT(ISPICKVAL(Opportunity__r.StageName ,&quot;Won&quot;)),
NOT(ISPICKVAL(Opportunity__r.StageName ,&quot;Production&quot;)),
NOT(ISPICKVAL(Opportunity__r.StageName ,&quot;Commit&quot;)),
NOT(ISPICKVAL(Opportunity__r.StageName ,&quot;Won - Open&quot;)),
NOT(ISPICKVAL(Opportunity__r.StageName ,&quot;Won - Closed&quot;)),
OR(
AND(
NOT(ISBLANK( Actual__c )),
ISPICKVAL( Gate__c, &quot;Design Completion (G3)&quot; ),
NOT(Actual__c = DATE(1900,01,01)),
Opportunity__r.Project_Status_Level__c = &apos;OPEN (1)&apos;
),
AND(
NOT(ISBLANK( Actual__c )),
ISPICKVAL( Gate__c, &quot;Production Completion (G6)&quot; ),
NOT(Actual__c = DATE(1900,01,01)),
Opportunity__r.Project_Status_Level__c &lt;&gt; &apos;CANCELLED (3)&apos;
)
)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
