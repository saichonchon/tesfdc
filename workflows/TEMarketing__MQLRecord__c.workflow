<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>MQL_Record_Reminder</fullName>
        <description>MQL Record Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>TEMarketing__MQL_Notifications/MQL_Owner_Reminder</template>
    </alerts>
    <alerts>
        <fullName>TEMarketing__Notify_owner_of_incoming_MQL_Record</fullName>
        <description>Notify owner of incoming MQL Record</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TEMarketing__MQL_Notifications/TEMarketing__MQL_Owner_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Actioned_by_Preferred_Dist</fullName>
        <field>TEMarketing__Is_Actioned_by_Preferred_Dist__c</field>
        <literalValue>1</literalValue>
        <name>Actioned by Preferred Dist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEMarketing__Update_Rejection_Date</fullName>
        <field>TEMarketing__Rejected_Date__c</field>
        <formula>now()</formula>
        <name>Update Rejection Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEMarketing__Update_SAL_Date</fullName>
        <field>TEMarketing__SAL_Date__c</field>
        <formula>now()</formula>
        <name>Update SAL Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEMarketing__Update_SAL_d</fullName>
        <field>TEMarketing__Has_SAL_d__c</field>
        <literalValue>1</literalValue>
        <name>Update SAL&apos;d</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TEMarketing__Update_Weekend_Deadline_Days</fullName>
        <field>TEMarketing__Primary_Action_Deadline_Date__c</field>
        <formula>TEMarketing__Primary_Action_Deadline_Date__c + ( IF( TEXT(TEMarketing__Rating__c) = &apos;Hot&apos;, $Setup.TEMarketing__me_settings__c.TEMarketing__Distributor_Followup_Days_Hot__c,$Setup.TEMarketing__me_settings__c.TEMarketing__Distributor_Followup_Days__c) -  (CASE(MOD( DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) - DATE(1985,6,24),7), 
0 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,2,2,3,3,4,4,5,5,5,6,5,1), 
1 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,2,2,3,3,4,4,4,5,4,6,5,1), 
2 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,2,2,3,3,3,4,3,5,4,6,5,1), 
3 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,2,2,2,3,2,4,3,5,4,6,5,1), 
4 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,1,2,1,3,2,4,3,5,4,6,5,1), 
5 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,0,2,1,3,2,4,3,5,4,6,5,0), 
6 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,1,2,2,3,3,4,4,5,5,6,5,0), 
999) 
+ 
(FLOOR(( TEMarketing__Primary_Action_Deadline_Date__c - TEMarketing__Passed_to_Primary_Date__c )/7)*5) - 1)) + IF(MOD(DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATE(1985,6,24), 7) = 5, 1, 0)</formula>
        <name>Update Deadline Business Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_MQL_Owner_to_Rejected_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Filter_Agent_Rejected_Lead_Queue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update MQL Owner to Rejected Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>MQL Reminder</fullName>
        <active>true</active>
        <criteriaItems>
            <field>TEMarketing__MQLRecord__c.MQL_Owner_GIBU__c</field>
            <operation>equals</operation>
            <value>Appliances,Data &amp; Devices,Medical</value>
        </criteriaItems>
        <criteriaItems>
            <field>TEMarketing__MQLRecord__c.TEMarketing__Assigned_to_Sales_Rep_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>TEMarketing__MQLRecord__c.TEMarketing__Inquiry_Status__c</field>
            <operation>equals</operation>
            <value>Marketing Qualified</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>MQL_Record_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>TEMarketing__MQLRecord__c.TEMarketing__Assigned_to_Sales_Rep_Date__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Rejected MQL Record</fullName>
        <actions>
            <name>Update_MQL_Owner_to_Rejected_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>ISChanged( TEMarketing__Inquiry_Status__c ) &amp;&amp; TEMarketing__Inquiry_Status__c == &apos;Sales Rejected&apos; &amp;&amp;  TEMarketing__BU_Channel__c  &amp;&amp;  C2S_Sales_Channel__c = &quot;Channel&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TEMarketing__Notify MQL Record Owner</fullName>
        <actions>
            <name>TEMarketing__Notify_owner_of_incoming_MQL_Record</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED( OwnerId )) &amp;&amp;  TEMarketing__Inquiry_Status__c &lt;&gt; &apos;Sales Rejected&apos; &amp;&amp; TEMarketing__Inquiry_Status__c &lt;&gt; &apos;Sales Qualified&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TEMarketing__Update Rejection Date</fullName>
        <actions>
            <name>TEMarketing__Update_Rejection_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(TEMarketing__Inquiry_Status__c) &amp;&amp; TEMarketing__Inquiry_Status__c== &apos;Sales Rejected&apos; &amp;&amp;  ISBLANK(TEMarketing__Rejected_Date__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TEMarketing__Update SAL Date</fullName>
        <actions>
            <name>TEMarketing__Update_SAL_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TEMarketing__Update_SAL_d</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISNEW() || ISCHANGED(TEMarketing__Inquiry_Status__c)) &amp;&amp; TEMarketing__Inquiry_Status__c== &apos;Sales Accepted&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TEMarketing__Update Weekend Deadline Date</fullName>
        <actions>
            <name>TEMarketing__Update_Weekend_Deadline_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( TEMarketing__Primary_Action_Deadline_Date__c ) &amp;&amp;  (CASE(MOD( DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) - DATE(1985,6,24),7),  0 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,2,2,3,3,4,4,5,5,5,6,5,1),  1 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,2,2,3,3,4,4,4,5,4,6,5,1),  2 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,2,2,3,3,3,4,3,5,4,6,5,1),  3 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,2,2,2,3,2,4,3,5,4,6,5,1),  4 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,1,2,1,3,2,4,3,5,4,6,5,1),  5 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,0,2,1,3,2,4,3,5,4,6,5,0),  6 , CASE( MOD( DATEVALUE(TEMarketing__Primary_Action_Deadline_Date__c) - DATEVALUE(TEMarketing__Passed_to_Primary_Date__c) ,7),1,1,2,2,3,3,4,4,5,5,6,5,0),  999)  +  (FLOOR(( TEMarketing__Primary_Action_Deadline_Date__c - TEMarketing__Passed_to_Primary_Date__c )/7)*5) - 1)  &lt;=  IF( TEXT(TEMarketing__Rating__c) = &apos;Hot&apos;, $Setup.TEMarketing__me_settings__c.TEMarketing__Distributor_Followup_Days_Hot__c,$Setup.TEMarketing__me_settings__c.TEMarketing__Distributor_Followup_Days__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Actioned By Partner</fullName>
        <actions>
            <name>Actioned_by_Preferred_Dist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEMarketing__Is_Actioned__c &amp;&amp; ( TEMarketing__Primary_Distributor__c != null)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
