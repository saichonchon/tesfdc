<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Channel_email_reminder</fullName>
        <description>Channel email reminder, user should put status to convert or dead now</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Leads/Channel_Reminder_2</template>
    </alerts>
    <alerts>
        <fullName>Channel_first_reminder</fullName>
        <description>Channel first reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Leads/Channel_Reminder_1</template>
    </alerts>
    <alerts>
        <fullName>Email_notification_on_distributor_response</fullName>
        <description>Email notification on distributor response</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>All_Email_Templates/Communities_DistributorResponseTemplate</template>
    </alerts>
    <alerts>
        <fullName>IND_Lead_info_not_completed</fullName>
        <description>IND Lead info not completed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Leads/IND_Lead_info_not_complete</template>
    </alerts>
    <alerts>
        <fullName>New_lead_to_follow_up_notification</fullName>
        <description>New lead to follow up notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>SPS_2013_Thank_You_Mail</fullName>
        <description>SPS 2014 Thank You Mail</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Leads/C2S_Lead_Thank_You_Mail</template>
    </alerts>
    <alerts>
        <fullName>TEMarketing__Send_email_notification_to_sales_rep_of_MQL</fullName>
        <description>Send email notification to sales rep of MQL</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>TEMarketing__MQL_Notifications/TEMarketing__Lead_MQL_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>BU_Owner_Email</fullName>
        <field>BU_Owner_Email__c</field>
        <formula>Owner:User.Email</formula>
        <name>BU_Owner_Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BU_Owner_Name</fullName>
        <field>BU_Owner_Name__c</field>
        <formula>Owner:User.FirstName + &apos; &apos; +Owner:User.LastName</formula>
        <name>BU_Owner_Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BU_Owner_Phone</fullName>
        <field>BU_Owner_Phone__c</field>
        <formula>Owner:User.Phone</formula>
        <name>BU_Owner_Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Lead_Status_Assigned</fullName>
        <description>In case an owner gets assigned and the status is equal to &quot;Sent to BU&quot;, this wf rule will change the status to &quot;Assigned - Unaccepted&quot;.</description>
        <field>Status</field>
        <literalValue>Assigned - Unaccepted</literalValue>
        <name>Change Lead Status -Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Lead_Status_Unassigned</fullName>
        <description>is changing the lead status to unassigned</description>
        <field>Status</field>
        <literalValue>Unassigned</literalValue>
        <name>update Lead Status to Unassigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_assigned</fullName>
        <field>Owner_Assigned__c</field>
        <formula>Owner_Assigned__c + 1</formula>
        <name>Change Owner assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Lead_Description</fullName>
        <field>Initial_Description__c</field>
        <formula>Description</formula>
        <name>Copy Lead Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Status_Reason</fullName>
        <description>Define Status Reason</description>
        <field>STATUS_REASON__c</field>
        <formula>&quot;Distributor&quot;</formula>
        <name>Define Status Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ICT_Update_default_Owner_hours</fullName>
        <field>ICT_Default_Owner_Hours__c</field>
        <literalValue>0</literalValue>
        <name>ICT_Update_default_Owner_hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ICT_Update_last_modified_status</fullName>
        <field>ICT_Last_Modified_Status_Date__c</field>
        <formula>NOW()</formula>
        <name>ICT_Update_last_modified_status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ICT_Update_last_modified_status_datetime</fullName>
        <field>ICT_Last_Modified_Status_Date__c</field>
        <formula>if( ISCHANGED(Status), now(), ICT_Last_Modified_Status_Date__c)</formula>
        <name>ICT_Update_last_modified_status_datetime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsCoLeadRejected</fullName>
        <description>Sets Field &quot;IsCoLeadRejected&quot; to true, when the lead is auto-rejects (due to originating from a distributor)</description>
        <field>IsCoLeadRejected__c</field>
        <literalValue>1</literalValue>
        <name>IsCoLeadRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_Accepted</fullName>
        <field>Status</field>
        <literalValue>Assigned - Accepted</literalValue>
        <name>Lead Status Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_to_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>Lead Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Marketing_Stage_Rejected</fullName>
        <field>TEMarketing__Stage__c</field>
        <formula>&quot;Sales Rejected&quot;</formula>
        <name>Marketing Stage = Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Marketing_Stage_SAL</fullName>
        <field>TEMarketing__Stage__c</field>
        <formula>&quot;Sales Accepted&quot;</formula>
        <name>Marketing Stage = SAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Marketing_Stage_SQO</fullName>
        <field>TEMarketing__Stage__c</field>
        <formula>&quot;Sales Qualified&quot;</formula>
        <name>Marketing Stage = SQO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Campaign_Tracking_Code</fullName>
        <description>Populates the field &apos;Campaign Tracking Code&apos;.
Must be re-set for the next campaign.</description>
        <field>Campaign_Tracking_Code__c</field>
        <formula>&quot;___ets_SPS-IPC-2014_SPS-IPC-2014_701G0000000yeBJIAY&quot;</formula>
        <name>Populate Campaign Tracking Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_owner_assigned_as_false</fullName>
        <field>Onwer_Assigned__c</field>
        <literalValue>1</literalValue>
        <name>Set owner assigned as true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_reason_code</fullName>
        <field>STATUS_REASON_CODE__c</field>
        <name>Status reason code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_reason_code_detail</fullName>
        <field>Bad_Data_Type__c</field>
        <name>Status reason code detail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_IsCoLeadRejected</fullName>
        <description>Update IsCoLeadRejected if the Lead updates again</description>
        <field>IsCoLeadRejected__c</field>
        <literalValue>0</literalValue>
        <name>Update IsCoLeadRejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Rejected_Date</fullName>
        <description>This date is the date when the Lead was Rejected</description>
        <field>LeadRejectedDate__c</field>
        <formula>TODAY()</formula>
        <name>Update Lead Rejected Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Rejected_Date_to_Null</fullName>
        <field>LeadRejectedDate__c</field>
        <name>Update Lead Rejected Date to Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type</fullName>
        <description>This action will update the Record Type to Central Lead</description>
        <field>RecordTypeId</field>
        <lookupValue>Central_Lead</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update  Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>auto_reject</fullName>
        <description>change lead status to rejected if type of company = distributor or Industry = Distributor / Reseller</description>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>auto reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_18_digit_id</fullName>
        <field>X18_Digit_ID__c</field>
        <formula>Id&amp;

CASE(

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,1),1)),1,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,2),1)),2,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,3),1)),4,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,4),1)),8,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,5),1)),16,0),

0,&quot;A&quot;,1,&quot;B&quot;,2,&quot;C&quot;,3,&quot;D&quot;,4,&quot;E&quot;,5,&quot;F&quot;,6,&quot;G&quot;,7,&quot;H&quot;,8,&quot;I&quot;,

9,&quot;J&quot;,10,&quot;K&quot;,11,&quot;L&quot;,12,&quot;M&quot;,13,&quot;N&quot;,14,&quot;O&quot;,15,&quot;P&quot;,16,&quot;Q&quot;,17,&quot;R&quot;,

18,&quot;S&quot;,19,&quot;T&quot;,20,&quot;U&quot;,21,&quot;V&quot;,22,&quot;W&quot;,23,&quot;X&quot;,24,&quot;Y&quot;,25,&quot;Z&quot;,26,&quot;0&quot;,

27,&quot;1&quot;,28,&quot;2&quot;,29,&quot;3&quot;,30,&quot;4&quot;,31,&quot;5&quot;,&quot;0&quot;)&amp;



CASE(

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,6),1)),1,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,7),1)),2,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,8),1)),4,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,9),1)),8,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,10),1)),16,0),

0,&quot;A&quot;,1,&quot;B&quot;,2,&quot;C&quot;,3,&quot;D&quot;,4,&quot;E&quot;,5,&quot;F&quot;,6,&quot;G&quot;,7,&quot;H&quot;,8,&quot;I&quot;,

9,&quot;J&quot;,10,&quot;K&quot;,11,&quot;L&quot;,12,&quot;M&quot;,13,&quot;N&quot;,14,&quot;O&quot;,15,&quot;P&quot;,16,&quot;Q&quot;,17,&quot;R&quot;,

18,&quot;S&quot;,19,&quot;T&quot;,20,&quot;U&quot;,21,&quot;V&quot;,22,&quot;W&quot;,23,&quot;X&quot;,24,&quot;Y&quot;,25,&quot;Z&quot;,26,&quot;0&quot;,

27,&quot;1&quot;,28,&quot;2&quot;,29,&quot;3&quot;,30,&quot;4&quot;,31,&quot;5&quot;,&quot;0&quot;)&amp;



CASE(

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,11),1)),1,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,12),1)),2,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,13),1)),4,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,14),1)),8,0)+

IF(CONTAINS(&quot;ABCDEFGHIJKLMNOPQRSTUVWXYZ&quot;,RIGHT(LEFT(Id,15),1)),16,0),

0,&quot;A&quot;,1,&quot;B&quot;,2,&quot;C&quot;,3,&quot;D&quot;,4,&quot;E&quot;,5,&quot;F&quot;,6,&quot;G&quot;,7,&quot;H&quot;,8,&quot;I&quot;,

9,&quot;J&quot;,10,&quot;K&quot;,11,&quot;L&quot;,12,&quot;M&quot;,13,&quot;N&quot;,14,&quot;O&quot;,15,&quot;P&quot;,16,&quot;Q&quot;,17,&quot;R&quot;,

18,&quot;S&quot;,19,&quot;T&quot;,20,&quot;U&quot;,21,&quot;V&quot;,22,&quot;W&quot;,23,&quot;X&quot;,24,&quot;Y&quot;,25,&quot;Z&quot;,26,&quot;0&quot;,

27,&quot;1&quot;,28,&quot;2&quot;,29,&quot;3&quot;,30,&quot;4&quot;,31,&quot;5&quot;,&quot;0&quot;)</formula>
        <name>update 18 digit id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_status_reason</fullName>
        <description>updates status reason if lead is auto rejected</description>
        <field>STATUS_REASON_CODE__c</field>
        <literalValue>This Lead does not belong to my business unit.</literalValue>
        <name>update status reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>BU Owner Detail</fullName>
        <actions>
            <name>BU_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BU_Owner_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>BU_Owner_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedById</field>
            <operation>contains</operation>
            <value>Connection User</value>
        </criteriaItems>
        <description>This workflow is used to display the BU owner detail, when lead is coming from central</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign tracking code</fullName>
        <actions>
            <name>Populate_Campaign_Tracking_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>C2S Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Trade_Show_Name__c</field>
            <operation>equals</operation>
            <value>SPS 2014</value>
        </criteriaItems>
        <description>this WF rule populates the field &apos;Campaign Tracking Code&apos;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Channel Lead Email reminder</fullName>
        <active>false</active>
        <description>Sending reminder email after 7,14 and 19 days of lead creation date if lead has not been accepted by lead owner.</description>
        <formula>AND( OR(ISPICKVAL(Status,&apos;Assigned - Unaccepted&apos;),ISPICKVAL(Status,&apos;Unassigned&apos;)), Lead_Recipient__c = &apos;Channel&apos;, $Setup.Admin_Profile_Exception__c.Run_Rule__c,   ISNULL( TEMarketing__MQL_Date__c )  ,  RecordTypeId = &apos;012E0000000YIvL&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Channel_first_reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Channel_email_reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.CreatedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Channel_email_reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.CreatedDate</offsetFromField>
            <timeLength>19</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Channel Lead Email reminder - Eloqua MQL</fullName>
        <active>true</active>
        <description>Sending reminder email after 7,14 and 19 days of lead MQL date if lead has not been accepted by lead owner.

NOT sending if the Assigned Distributor is filled in, indicating that the Lead was actually passed to a portal distributor.</description>
        <formula>AND( OR(ISPICKVAL(Status,&apos;Assigned - Unaccepted&apos;),ISPICKVAL(Status,&apos;Unassigned&apos;)), ISPICKVAL(Owner:User.GIBU__c ,&apos;Channel&apos;), $Setup.Admin_Profile_Exception__c.Run_Rule__c,    NOT(ISNULL( TEMarketing__MQL_Date__c )) ,   RecordTypeId = &apos;012E0000000YIvL&apos;,
ISBLANK( TEXT(Communities_Distributor__c) ) 

 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Channel_email_reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.TEMarketing__MQL_Date__c</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Channel_first_reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.TEMarketing__MQL_Date__c</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Channel_email_reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Lead.TEMarketing__MQL_Date__c</offsetFromField>
            <timeLength>19</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email on distributor response</fullName>
        <actions>
            <name>Email_notification_on_distributor_response</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Distributor_Response__c</field>
            <operation>equals</operation>
            <value>Convert to opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ICT_Update_last_modified_status</fullName>
        <actions>
            <name>ICT_Update_default_Owner_hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ICT_Update_last_modified_status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ICT_Update_last_modified_status_datetime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Status )  &amp;&amp; text(Status) !=&quot;Qualified&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IND Lead info not completed</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Lead_Info_Completed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Event Lead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IND_Lead_info_not_completed</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Lead Description</fullName>
        <actions>
            <name>Copy_Lead_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.FirstName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Description</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Accepted</fullName>
        <actions>
            <name>Lead_Status_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Playbooks_Play_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Central Lead</value>
        </criteriaItems>
        <description>Playbook Name not empty then the Lead status is Accepted</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Change - Assigned</fullName>
        <actions>
            <name>Change_Lead_Status_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>In case an owner gets assigned this wf rule will change the status to &quot;Assigned - Unaccepted&quot; if it was prefiously Unassigned (Default and Queue status)</description>
        <formula>AND(
RecordType.DeveloperName = &apos;Central_Lead&apos;,
ISCHANGED(OwnerId),
BEGINS(OwnerId, &apos;005&apos;),
ISPICKVAL(Status,&apos;Unassigned&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Change - Unassinged</fullName>
        <actions>
            <name>Change_Lead_Status_Unassigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a lead is assigned to a queue from a user change the lead status to unassigned</description>
        <formula>AND(ISCHANGED(OwnerId),
RecordType.DeveloperName = &apos;Central_Lead&apos;,
BEGINS(PRIORVALUE(OwnerId), &apos;005&apos;),
BEGINS(OwnerId, &apos;00G&apos;),
OR(ISPICKVAL(Status,&apos;Assigned - Unaccepted&apos;),ISPICKVAL( Status,&apos;Assigned - Accepted&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status to %27Rejected%27</fullName>
        <actions>
            <name>Lead_Status_to_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Playbooks_Play_Status__c</field>
            <operation>equals</operation>
            <value>Unenrolled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Central Lead</value>
        </criteriaItems>
        <description>Playbook status is Unenrolled then convert the status of Lead to Rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead-Status Reason Code</fullName>
        <actions>
            <name>Status_reason_code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Status_reason_code_detail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.STATUS_REASON_CODE__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Bad_Data_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Status Reason Code and Status Reason Code detail fields making blank for Rejected leads</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LeadOwnerChangeNotification</fullName>
        <actions>
            <name>New_lead_to_follow_up_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow for notifying new lead owner when ownership changes(workaround for checking &apos;notify owner&apos; flag).</description>
        <formula>AND(ISCHANGED(OwnerId),
     ISBLANK( TEMarketing__Stage__c ) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Marketing Stage %3D Rejected</fullName>
        <actions>
            <name>Marketing_Stage_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>contains</operation>
            <value>Unqualified,Dropped,Rejected,Dead</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marketing Stage %3D SAL</fullName>
        <actions>
            <name>Marketing_Stage_SAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>contains</operation>
            <value>Assigned - Accepted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Marketing Stage %3D SQO</fullName>
        <actions>
            <name>Marketing_Stage_SQO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>contains</operation>
            <value>Converted - New Opportunity,Converted - Existing Opportunity,Converted - Without Opportunity,Converted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New lead to follow up notification</fullName>
        <actions>
            <name>New_lead_to_follow_up_notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>When a lead owner is a assigned the owner should be informed that he has a new lead to follow up.

## deactivated during clean-up of lead mail notification</description>
        <formula>OR(  AND(  $Profile.Name &lt;&gt; &quot;Service Account&quot;,  $Profile.Name &lt;&gt; &quot;Systemadministrator&quot;,  $Profile.Name &lt;&gt; &quot;System Administrator&quot;,  NOT(BEGINS(OwnerId, &quot;00G&quot;)),  ISBLANK( TEMarketing__Stage__c )  ), AND(ISNEW(),RecordTypeId = &apos;012E0000000f8Rg&apos;), ISCHANGED(OwnerId) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Lead Central Record Type</fullName>
        <actions>
            <name>Update_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Source_BU__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Record Type fields cannot be subscribed to when mapping fields in SF2SF. Therefore this rule will look at a field called Source BU on the Lead which will tell us that it came from Central &amp; we can make the record type Central Lead.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SPS 2014 Thank You Mail</fullName>
        <actions>
            <name>SPS_2013_Thank_You_Mail</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Trade_Show_Name__c</field>
            <operation>equals</operation>
            <value>SPS 2014</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>C2S Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Reject Date</fullName>
        <actions>
            <name>Update_Lead_Rejected_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Lead.IsCoLeadRejected__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadRejectedDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Closed - Won,Rejected,Dead,Dropped</value>
        </criteriaItems>
        <description>Set the Lead Reject Date when the IsCoLeadRejected is set to true.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set the owner assigned</fullName>
        <actions>
            <name>Change_Owner_assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_owner_assigned_as_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the owner assigned flags if the Onwer_Assigned__c field is true, and it&apos;s a newly created record or being updated from a Response record type to a Central Org type.  These flags are used by the Lead_BI_ExecuteRoute trigger logic.</description>
        <formula>Onwer_Assigned__c &amp;&amp;  ( ISNEW() ||  (ISCHANGED(RecordTypeId) &amp;&amp;  PRIORVALUE(RecordTypeId) = &apos;012E0000000NET8&apos; &amp;&amp; RecordTypeId = &apos;012E0000000YIvL&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TEMarketing__Notify Lead Owner - MQL</fullName>
        <actions>
            <name>TEMarketing__Send_email_notification_to_sales_rep_of_MQL</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>(( ISNEW() || ISCHANGED(TEMarketing__Stage__c) ) &amp;&amp; TEMarketing__Stage__c==&apos;Marketing Qualified&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update rejected Date</fullName>
        <actions>
            <name>Update_IsCoLeadRejected</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Rejected_Date_to_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  ISCHANGED(Status),   OR(   ISPICKVAL(PRIORVALUE( Status),&quot;Dropped&quot;),   ISPICKVAL(PRIORVALUE( Status),&quot;Rejected&quot;),    ISPICKVAL(PRIORVALUE( Status),&quot;Dead&quot;),    ISPICKVAL(PRIORVALUE( Status),&quot;Closed - Lost&quot;)   ),  OR(   NOT(ISPICKVAL(Status,&quot;Dropped&quot;)),   NOT(ISPICKVAL(Status,&quot;Rejected&quot;)),    NOT(ISPICKVAL(Status,&quot;Dead&quot;)),    NOT(ISPICKVAL(Status,&quot;Closed - Lost&quot;))  ),  NOT(   ISBLANK(LeadRejectedDate__c)  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>auto reject</fullName>
        <actions>
            <name>Define_Status_Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IsCoLeadRejected</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>auto_reject</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_status_reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR  2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Lead.Type_of_company__c</field>
            <operation>contains</operation>
            <value>Dealer,Distributor,Reseller</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Industry</field>
            <operation>equals</operation>
            <value>Distribution / Reseller</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Email</field>
            <operation>contains</operation>
            <value>ttiinc,arrow,avent,waldom,maproelec,heilind,integ</value>
        </criteriaItems>
        <description>rule to auto reject leads if Industry = Distributor or type of company = Distributor / Reseller</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>update 18 digit id</fullName>
        <actions>
            <name>update_18_digit_id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.X18_Digit_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
