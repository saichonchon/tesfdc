<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Mark_High_Importance_cases</fullName>
        <field>High_Importance__c</field>
        <literalValue>1</literalValue>
        <name>Mark High Importance cases</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_SNU_Update_status_in_prog_agen</fullName>
        <description>PIC - Updated Status to In Progress Agent
Later the In Progress status were excluded</description>
        <field>System_Notes__c</field>
        <formula>Parent.System_Notes__c + &quot; / PIC - Updated Status to Response Received&quot;</formula>
        <name>PIC - SNU - Update status - in prog agen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Case_Emails_Sent</fullName>
        <field>Case_Emails_Sent__c</field>
        <formula>Parent.Case_Emails_Sent__c + 1</formula>
        <name>PIC - Update Case Emails Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Case_Status_to_Closed_NC</fullName>
        <description>Updates the case status to Closed  when an email is sent from the system.
Later the status was decided to be kept to &apos;Waiting for Response&apos;</description>
        <field>Status</field>
        <literalValue>Waiting for Response</literalValue>
        <name>PIC - Update Case Status to Closed - NC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Initial_Response_Time</fullName>
        <field>Initial_Response_TimeStamp__c</field>
        <formula>NOW()</formula>
        <name>PIC - Update Initial Response Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Status_to_Nurturing_Response</fullName>
        <field>Status</field>
        <literalValue>Nurturing-Response Received</literalValue>
        <name>PIC-Update Status to Nurturing Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Status_to_Response_Received</fullName>
        <field>Status</field>
        <literalValue>Response Received</literalValue>
        <name>PIC - Update Status to Response Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateField_Status</fullName>
        <description>Updates the Status field to &quot;New&quot;.</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>UpdateField Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Incoming_Emails_Count_on_Case</fullName>
        <field>Count_Incoming_Emails__c</field>
        <formula>Parent.Count_Incoming_Emails__c + 1</formula>
        <name>Update Incoming Emails Count on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Outgoing_Emails_Count_on_Case</fullName>
        <description>Update Outgoing Emails Count on Case</description>
        <field>Count_Outgoing_Emails__c</field>
        <formula>Parent.Count_Outgoing_Emails__c + 1</formula>
        <name>Update Outgoing Emails Count on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reopen_reason_on_case</fullName>
        <field>Case_Re_Open_Reason__c</field>
        <literalValue>Incomplete Response</literalValue>
        <name>Update Reopen reason on case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_as_Reopen</fullName>
        <field>Status</field>
        <literalValue>ReOpen</literalValue>
        <name>Update case status as Reopen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>case_status_closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>case status=closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Close Quick Email case</fullName>
        <actions>
            <name>case_status_closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Quick_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Count_Outgoing_Emails__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Mark High Importance cases</fullName>
        <actions>
            <name>Mark_High_Importance_cases</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EmailMessage.Headers</field>
            <operation>contains</operation>
            <value>Importance: high</value>
        </criteriaItems>
        <description>Check custom field  &quot;High Importance&quot; on case as true if case header contain keyword Importance: high. this is to capture email importance from outlook into SFDC</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Populate Case on Email Message</fullName>
        <actions>
            <name>PIC_Update_Case_Emails_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>Replied,Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.MessageDate</field>
            <operation>greaterThan</operation>
            <value>9/27/2015</value>
        </criteriaItems>
        <description>To set value in case field &apos;Case Emails Sent&apos;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Set First Response Time on Case</fullName>
        <actions>
            <name>PIC_Update_Initial_Response_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>Replied,Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Initial_Response_TimeStamp__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.MessageDate</field>
            <operation>greaterThan</operation>
            <value>9/27/2015</value>
        </criteriaItems>
        <description>To set value in field &apos;Initial Response TimeStamp&apos;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Update Status to Nurturing Response</fullName>
        <actions>
            <name>PIC_Update_Status_to_Nurturing_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Case open as Nurturing Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <description>Upon receiving an e-mail the case status should go to Nurturing - Response Received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Updated Status to Closed</fullName>
        <actions>
            <name>PIC_Update_Case_Status_to_Closed_NC</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Outgoing_Emails_Count_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>Replied,Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Waiting for Response</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.MessageDate</field>
            <operation>greaterThan</operation>
            <value>9/27/2015</value>
        </criteriaItems>
        <description>Upon sending an e-mail the case status should go to closed.
Later status changed to &apos;Waiting for Response&apos;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Updated Status to Response Received</fullName>
        <actions>
            <name>PIC_SNU_Update_status_in_prog_agen</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PIC_Update_Status_to_Response_Received</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Incoming_Emails_Count_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Other,Closed,Closed (Forwarded non-PIC),Waiting for Response</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.MessageDate</field>
            <operation>greaterThan</operation>
            <value>9/27/2015</value>
        </criteriaItems>
        <description>Upon receiving an e-mail the case status should go to Response Received</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Subsequent Email Messages on Case</fullName>
        <actions>
            <name>UpdateField_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/1901</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.GIBU__c</field>
            <operation>equals</operation>
            <value>DataComm</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This rule is triggered when an Email Message is created (using Email to Case) that is an incoming Email Message AND the GIBU__c equals DataComm.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update case status as Repoen</fullName>
        <actions>
            <name>Update_Reopen_reason_on_case</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_Reopen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>notEqual</operation>
            <value>Replied,Sent,Forwarded,Draft</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Cloud -Case Close,Customer Care Cloud</value>
        </criteriaItems>
        <description>This Rule is triggered when a contact sends an email to the CCP after the case is close.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
