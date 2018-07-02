<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ACP_Action_Notification_Email_Alert</fullName>
        <description>Action Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ACP_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ACP_New_Action_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>NPS_set_reminder</fullName>
        <field>IsReminderSet</field>
        <literalValue>1</literalValue>
        <name>NPS set reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NPS_Task_Due_Date</fullName>
        <field>ReminderDateTime</field>
        <formula>NOW()+90</formula>
        <name>Update NPS Task Due Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Next_Reminder_Date</fullName>
        <field>Next_reminder_date__c</field>
        <formula>Next_reminder_date__c + 7</formula>
        <name>Update Next Reminder Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Next_Reminder_Date_1_Day</fullName>
        <description>Update Next Reminder Date 1 Day</description>
        <field>Next_reminder_date__c</field>
        <formula>Next_reminder_date__c + 1</formula>
        <name>Update Next Reminder Date 1 Day</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatereminderSet</fullName>
        <field>IsReminderSet</field>
        <literalValue>1</literalValue>
        <name>UpdatereminderSet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Reminder_Time</fullName>
        <field>ReminderDateTime</field>
        <formula>DATETIMEVALUE(ActivityDate )</formula>
        <name>Updating Reminder Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ACP_New Action Notification</fullName>
        <actions>
            <name>ACP_Action_Notification_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>Account Plan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.ACP_Category__c</field>
            <operation>equals</operation>
            <value>ADM Market &amp; Competition,Application Breakdown,Business Performance,Market and Competition,Stakeholder and Relationship,Supplier Evaluation,Top Open Opportunities</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.ACP_Contact_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.ACP_Contact_Email__c</field>
            <operation>contains</operation>
            <value>@te.com</value>
        </criteriaItems>
        <description>Alka 05/15/17 – Created for Account Plan</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NPS Task Follow-Up Action WF</fullName>
        <actions>
            <name>NPS_set_reminder</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_NPS_Task_Due_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 5 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Called Contact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Action_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Action_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Action_3__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.RecordTypeId</field>
            <operation>equals</operation>
            <value>NPS Task Standard</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Next Reminder Date</fullName>
        <active>true</active>
        <formula>AND (    OR(   AND(    RecordType.Name = &apos;EC Survey&apos;,     Subject = &apos;Detractor Assignment&apos;   ),   OR(     AND(     RecordType.Name = &apos;NPS Task Industrial&apos;,      OR(      Subject = $Label.NPS_Passive_Follow_UP ,       Subject = $Label.NPS_Promoter_Follow_UP      )    ),    AND(     RecordType.Name=&apos;NPS Industrial Functional Follow Up Task&apos;,     OR(      Subject= $Label.NPS_Passive_Functional_Follow_UP,       Subject= $Label.NPS_Promoter_Functional_Follow_UP     )    )   )  ),    DATEVALUE(Next_reminder_date__c) = TODAY(),  TEXT(Status) &lt;&gt; &apos;Completed&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Next_Reminder_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Task.Next_reminder_date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Next Reminder Date 1 Day</fullName>
        <active>true</active>
        <formula>AND (     OR(     AND(     RecordType.Name = &apos;NPS Task Industrial&apos;,      OR(      Subject = $Label.NPS_Detractor_GM_Follow_UP,       Subject = $Label.NPS_Detractor_AM_Follow_UP     )    ),    AND(     RecordType.Name=&apos;NPS Industrial Functional Follow Up Task&apos;,     OR(      Subject= $Label.NPS_Detractor_GM_Functional_Follow_UP ,       Subject= $Label.NPS_Detractor_AM_Functional_Follow_UP      )    )  ),    DATEVALUE(Next_reminder_date__c) = TODAY(),  TEXT(Status) &lt;&gt; &apos;Completed&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Next_Reminder_Date_1_Day</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Task.Next_reminder_date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>UpdateReminderSet</fullName>
        <actions>
            <name>UpdatereminderSet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Updating_Reminder_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>it will update reminderSet for Lightening task alerts</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
