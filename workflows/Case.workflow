<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_to_CC_user</fullName>
        <description>Alert to CC user</description>
        <protected>false</protected>
        <recipients>
            <recipient>rebecca.hill@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Customer_Request_Alert</template>
    </alerts>
    <alerts>
        <fullName>Automatic_reply_with_a_ticket_number</fullName>
        <description>Automatic reply with a ticket number</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>chaitra.d@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Care_Emails/Automatic_reply_with_a_ticket_number</template>
    </alerts>
    <alerts>
        <fullName>Case_Nearing_24_Hour_Response_Time</fullName>
        <description>Case Nearing 24 Hour Response Time</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Customer_Care_Emails/CCP_SUPPORT_Cases_are_near_violation_of_a_24Hr_response</template>
    </alerts>
    <alerts>
        <fullName>Case_reassignment_Notification</fullName>
        <description>Case reassignment Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PIC_Automated_Messages/Email_to_Case_Owner_about_new_Mail</template>
    </alerts>
    <alerts>
        <fullName>Customer_Survey_APAC</fullName>
        <description>Customer Survey APAC</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Care_Emails/Combined_CC_Survey_Template_VF</template>
    </alerts>
    <alerts>
        <fullName>Customer_Survey_English</fullName>
        <description>Customer Survey- English</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Care_Emails/Combined_CC_Survey_Template</template>
    </alerts>
    <alerts>
        <fullName>Customer_Survey_Japan</fullName>
        <description>Customer Survey Japan</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Care_Emails/Customer_Survey_Japan</template>
    </alerts>
    <alerts>
        <fullName>Customer_Survey_Spanish</fullName>
        <description>Customer Survey- Spanish</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Care_Emails/Combined_CC_Survey_Template</template>
    </alerts>
    <alerts>
        <fullName>DTC_Send_Email_when_DTC_Request_is_Assigned_Americas</fullName>
        <description>DTC Send Email when DTC Request is Assigned - Americas</description>
        <protected>false</protected>
        <recipients>
            <recipient>weiqiang.liu@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DTC_Send_Notification_of_New_DTC_Request</template>
    </alerts>
    <alerts>
        <fullName>DTC_Send_Email_when_DTC_Request_is_Assigned_Asia</fullName>
        <description>DTC Send Email when DTC Request is Assigned - Asia</description>
        <protected>false</protected>
        <recipients>
            <recipient>shannon.andreas@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>sonja.yang@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DTC_Send_Notification_of_New_DTC_Request</template>
    </alerts>
    <alerts>
        <fullName>DTC_Send_Email_when_DTC_Request_is_Assigned_EMEA</fullName>
        <description>DTC Send Email when DTC Request is Assigned - EMEA</description>
        <protected>false</protected>
        <recipients>
            <recipient>f.reijgers@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shannon.andreas@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DTC_Send_Notification_of_New_DTC_Request</template>
    </alerts>
    <alerts>
        <fullName>Escalation_ICT_Mail</fullName>
        <description>Escalation ICT Mail</description>
        <protected>false</protected>
        <recipients>
            <recipient>ICT_sales_users</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>teconnectivityladd@qicdshoq4olcxv5lfpdjy1lct2vuynhhrhm1gxbfog032bczs.e-hkvemac.na39.case.salesforce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Email_Templates/ICT_15_Min_SLA_Breach</template>
    </alerts>
    <alerts>
        <fullName>ICT_Case_20_Hour_Escalation</fullName>
        <description>ICT Case 20 Hour Escalation</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>gracec@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>teconnectivityladd@qicdshoq4olcxv5lfpdjy1lct2vuynhhrhm1gxbfog032bczs.e-hkvemac.na39.case.salesforce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Email_Templates/ICT_4_hr_Left_for_Resolution</template>
    </alerts>
    <alerts>
        <fullName>ICT_Case_24_Breached_Email</fullName>
        <description>ICT Case 24 Breached Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>gracec@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>teconnectivityladd@qicdshoq4olcxv5lfpdjy1lct2vuynhhrhm1gxbfog032bczs.e-hkvemac.na39.case.salesforce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>All_Email_Templates/ICT_24_hr_Left_for_Resolution</template>
    </alerts>
    <alerts>
        <fullName>Notify_to_owner</fullName>
        <description>Notify to owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>nooreen.i@zensar.in.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PIC_Automated_Messages/Email_to_Case_Owner_about_new_Mail</template>
    </alerts>
    <alerts>
        <fullName>PIC_Email_Customer_on_Case_Creation</fullName>
        <description>PIC - Email Customer on Case Creation</description>
        <protected>false</protected>
        <recipients>
            <field>Workflow_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>pic.info@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PIC_Automated_Messages/PIC_Default_Creation_Template_HTML</template>
    </alerts>
    <alerts>
        <fullName>PIC_IS_Survey</fullName>
        <description>PIC IS Survey</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PIC_Survey/PIC_IS_Survey</template>
    </alerts>
    <alerts>
        <fullName>PIC_Japan_Forward_Case_Case_Information</fullName>
        <description>PIC Japan Forward Case &amp; Case Information</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pic.info@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PIC_Automated_Messages/PICJapan_Forward_Case_Case_Information</template>
    </alerts>
    <alerts>
        <fullName>PIC_New_Case_Email_notify_case_owner</fullName>
        <description>PIC - New Case Email - notify case owner</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>pic.info@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PIC_Automated_Messages/Email_to_Case_Owner_about_new_Mail</template>
    </alerts>
    <alerts>
        <fullName>PIC_Survey</fullName>
        <description>PIC Survey</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>pic.info@te.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PIC_Survey/PIC_Survey_New</template>
    </alerts>
    <alerts>
        <fullName>Send_ICT_Customer_Email_Alert</fullName>
        <description>Send ICT Customer Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>teconnectivityladd@qicdshoq4olcxv5lfpdjy1lct2vuynhhrhm1gxbfog032bczs.e-hkvemac.na39.case.salesforce.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/ICT_Email_to_Case</template>
    </alerts>
    <alerts>
        <fullName>Send_close_case_notification_email_to_Contact</fullName>
        <ccEmails>swathi.gaddam@te.com</ccEmails>
        <description>Send close case notification email to Contact</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Customer_Care_Emails/Case_Closed_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>ActivityNote</fullName>
        <field>Activity_Notes__c</field>
        <name>ActivityNote</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Reopened</fullName>
        <field>Case_Reopened__c</field>
        <literalValue>1</literalValue>
        <name>Case Reopened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_priority_Change_from_Medium_to_High</fullName>
        <field>Priority</field>
        <literalValue>High</literalValue>
        <name>Case priority Change from Medium to High</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Record_type_Customer_Care_Cloud</fullName>
        <description>field update which changes the record type to &quot;Closed Case&quot; when IsClosed is flase.</description>
        <field>RecordTypeId</field>
        <lookupValue>Customer_Care_Cloud</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change Record type - Customer Care Cloud</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_record_type_to_CC_Closed_Case</fullName>
        <description>field update which changes the record type to &quot;Closed Case&quot; when IsClosed is true.</description>
        <field>RecordTypeId</field>
        <lookupValue>Customer_Care_Cloud_Case_feed_View</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Change record type to CC Closed Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_status_from_High_to_Critical</fullName>
        <field>Priority</field>
        <literalValue>Critical</literalValue>
        <name>Change priority from High to Critical</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Nurtured</fullName>
        <field>Nurtured__c</field>
        <literalValue>1</literalValue>
        <name>Check Nurtured</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Customer_Portal_field_Update</fullName>
        <field>Customer_Portal__c</field>
        <formula>Account.Customer_Portal__c</formula>
        <name>Customer Portal field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_on_ICT_Case_Date_Time_after</fullName>
        <field>ICT_Case_Date_Time_after_15_min__c</field>
        <formula>NOW() -  0.03109</formula>
        <name>Field Update on ICT Case Date Time after</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_Survey</fullName>
        <field>First_Survey__c</field>
        <literalValue>1</literalValue>
        <name>First Survey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ICT_Update_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>ICT_Customer_Service</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>ICT Update Case Owner</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_Email_Send_Uncheck_on_Case</fullName>
        <field>Is_Email_Send__c</field>
        <literalValue>0</literalValue>
        <name>Is Email Send Uncheck on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Audit_By_field_update</fullName>
        <description>set the Who last edited the audit fields</description>
        <field>Audit_By__c</field>
        <formula>$User.FirstName + &quot; &quot; + $User.LastName</formula>
        <name>PIC - Audit - By field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Audit_Update_Business_hours</fullName>
        <description>update the business hours when the reason or notes are updated</description>
        <field>Audit_Business_Hours__c</field>
        <formula>Case_Age_In_Business_Hours__c</formula>
        <name>PIC - Audit - Update Business hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Audit_Update_Date_Time_of_Audit</fullName>
        <description>Track the data time the audit occured</description>
        <field>Audit_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>PIC - Audit - Update Date/Time of Audit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Case_closed_time</fullName>
        <field>Survey_send_after_15_min__c</field>
        <formula>NOW()+0.0506944444444444</formula>
        <name>PIC Case closed time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Japan_Close_case</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>PIC Japan Close case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Originating_Queue_Update</fullName>
        <field>Originating_Queue__c</field>
        <formula>TEXT(Queue__c)</formula>
        <name>PIC - Originating Queue Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Populate_Workflow_Email</fullName>
        <description>Populates the workflow email field from the email formula field</description>
        <field>Workflow_Email__c</field>
        <formula>Formula_Email__c</formula>
        <name>PIC - Populate Workflow Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Queue_Update_back_to_blank</fullName>
        <field>Queue__c</field>
        <name>PIC - Queue Update back to blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_SNU_Assign_change</fullName>
        <field>System_Notes__c</field>
        <formula>System_Notes__c + &quot; / PIC - Update Case Status to Assigned [&quot; + Owner_Lookup__r.LastName + &quot;] &quot; + text(Status)</formula>
        <name>PIC - SNU - Assign change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_SNU_New_Case</fullName>
        <field>System_Notes__c</field>
        <formula>System_Notes__c + &quot; / PIC - ***New Case Email [&quot; + Owner_Lookup__r.LastName + &quot;] &quot; + text(Status)</formula>
        <name>PIC - SNU - New Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_SNU_Originating_queue</fullName>
        <description>PIC - Case Chat Originating Queue</description>
        <field>System_Notes__c</field>
        <formula>System_Notes__c + &quot; / PIC - Case Chat Originating Queue&quot;</formula>
        <name>PIC - SNU - Originating queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_SNU_W2C_Guest_to_US</fullName>
        <description>PIC - Update WebToCase Site Guest User to US - PIC</description>
        <field>System_Notes__c</field>
        <formula>System_Notes__c + &quot; / PIC - Update WebToCase Site Guest User to US - PIC [&quot; + Owner_Lookup__r.LastName + &quot;] &quot; + text(Status)</formula>
        <name>PIC - SNU - W2C Guest to US</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_SNU_new_case_note</fullName>
        <description>PIC - Notify Case Owner</description>
        <field>System_Notes__c</field>
        <formula>System_Notes__c + &quot; / PIC - Notify Case Owner [&quot; + Owner_Lookup__r.LastName + &quot;] &quot; + text(Status)</formula>
        <name>PIC - SNU - new case note</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Case_Status_to_Assigned</fullName>
        <field>Status</field>
        <literalValue>Assigned</literalValue>
        <name>PIC - Update Case Status to Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Chat_Originating_Queue</fullName>
        <field>Originating_Queue__c</field>
        <formula>&quot;Web (Chat Sessions)&quot;</formula>
        <name>PIC - Update Chat Originating Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_E2C_Initial_to_PIC_US</fullName>
        <field>OwnerId</field>
        <lookupValue>PIC_US</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PIC - Update E2C Initial to PIC -US</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Hot_Lead_Created_field</fullName>
        <description>Date/Time that the Hot Lead checkbox is checked on the Case, thus signaling the creation of a Hot lead by Eloqua.</description>
        <field>Hot_Lead_Created_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>PIC Update Hot Lead Created field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Update_Initial_Response_BH</fullName>
        <field>Initial_Response_Time_Business_Hours__c</field>
        <formula>Case_Age_In_Business_Hours__c</formula>
        <name>PIC - Update Initial Response (BH)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Updated_Status_Closed_Spam</fullName>
        <field>Status</field>
        <literalValue>Closed (SPAM)</literalValue>
        <name>PIC - Updated Status Closed Spam</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Queue_update</fullName>
        <field>Originating_Queue__c</field>
        <formula>Owner:Queue.QueueName</formula>
        <name>Queue update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sap_Case_Owner_Update</fullName>
        <description>Sap Case Owner Update from TEIS Admin to Fall outs from ZBMT Queue</description>
        <field>OwnerId</field>
        <lookupValue>Fall_outs_from_ZBMT</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Sap Case Owner Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_to_Field_Asia</fullName>
        <field>Assigned_to__c</field>
        <lookupValue>sonja.yang@te.com.c2s</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Assigned to Field - Asia</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Assigned_to_Field_EMEA</fullName>
        <field>Assigned_to__c</field>
        <lookupValue>f.reijgers@te.com.c2s</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Assigned to Field - EMEA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Closed_By_Field</fullName>
        <description>Updates Id of the user(logged in) who closes the case and this user will be assigned as survey owner when a customer survey is created</description>
        <field>Case_Closed_By__c</field>
        <formula>LastModifiedBy.Id</formula>
        <name>Update Case Closed By Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Key_Customer_Code</fullName>
        <field>Key_Customer_Cde__c</field>
        <formula>Account.Key_Customer_Cde__c</formula>
        <name>Update Case Key Customer Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Record_type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Customer_Care_Cloud_Case_feed_View</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Case Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Reopened_Date</fullName>
        <field>Case_Reopened_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Case Reopened Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_Comments</fullName>
        <field>Status_Comments__c</field>
        <formula>&quot;Closed by workload management due to 4 weeks of inactivity comment.&quot;</formula>
        <name>Update Case Status Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Subject_Line_on_DTC_REquest</fullName>
        <field>Subject</field>
        <formula>if ( A_Code_Request__c=true,&quot;New A Code Request&quot;,
if ( Deactivate_User__c =true,&quot;Deactivate User&quot;,
if ( New_User__c = true,&quot;New User Request&quot;,
if ( New_Allocation__c =true,&quot;New Allocation Request&quot;,
if ( New_Feature_Enhancement__c=true, &quot;New Feature/Enhancement Request&quot;,
if ( New_Report_or_Dashboard__c=true, &quot;New Report/Dashboard Request&quot;,
if ( Org_Level_Change_Request__c =true, &quot;Org Level Change Request&quot;,
if ( Opportunity_and_or_Contacts_Reassignment__c =true,&quot;Opportunity and/or Contacts Reassignment&quot;,
if (  Account_Assignment_Reassignment__c =true,&quot;Account Assignment/Reassignment Request&quot;, 
&quot;Other Sales/Enablement Request&quot;)))))))))</formula>
        <name>Update Subject Line on DTC REquest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_Date</fullName>
        <field>Survey_Sent_Date__c</field>
        <formula>Today()</formula>
        <name>Update Survey Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_as_closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Case Status as Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_to_be_closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update case status to be closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_customer_care_case_close</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Customer_Care_Cloud_Case_feed_View</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Case Record type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_status_comment_case_field</fullName>
        <field>Status_Comments__c</field>
        <formula>&quot;Closed due by workload management on no reply to status request&quot;</formula>
        <name>Update status comment case field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Automatic reply with a ticket number</fullName>
        <actions>
            <name>Automatic_reply_with_a_ticket_number</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11 AND 12 AND 13 AND 14 and 15 AND 16 AND 17 AND 18 AND 19 AND 20 AND 21 AND 22 AND 23 AND 24</booleanFilter>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>contains</operation>
            <value>boersig.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>notContain</operation>
            <value>mott</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Phone,Chat</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>[Incident: 1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notEqual</operation>
            <value>ENTER MESSAGE TO BE STOPPED</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>out of office,ENTER MESSAGE TO BE STOPPED</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Auto-Reply,Réponse automatique,FWD: Undelivered Mail Returned to Sender</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.isCentralOldCase__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Out of office,Personal Leave</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Request Received by TE Connectivity CAD Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>9/29/2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>&quot;Abwesenheit &quot;,Easter Holiday</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>&quot;Undeliverable: &quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Delivery failure,Undelivered Mail Returned to Sender</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Risposta automatica</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>New case email notification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>&quot;Automatisch antwoord: &quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Automatic reply</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>postmaster@te.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>THIS EMAIL IS NO LONGER MONITORED</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>On business trip until</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>on leave,Mail delivery failed: returning message to sender</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Vacation,Holiday,Urlaub</value>
        </criteriaItems>
        <description>To Notify the customer when case is created with the ticket number</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CCP Mark Case Reopened as true when Status %3D ReOpen</fullName>
        <actions>
            <name>Case_Reopened</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>ReOpen</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Cloud,Customer Care Cloud -Case Close</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Customer Portal field Update</fullName>
        <actions>
            <name>Customer_Portal_field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Cloud,Customer Care Cloud -Case Close</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Reopened Date</fullName>
        <actions>
            <name>Update_Case_Reopened_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(  (ISPICKVAL(Status,&apos;ReOpen&apos;) &amp;&amp; PRIORVALUE(IsClosed)&amp;&amp; NOT(IsClosed)) ,  (ISPICKVAL(Status,&apos;New Response Received&apos;) &amp;&amp; PRIORVALUE(IsClosed)&amp;&amp; NOT(IsClosed))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Changes the record type to %22Customer Care Cloud Closed Case%22 when IsClosed is true</fullName>
        <actions>
            <name>Change_record_type_to_CC_Closed_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Cloud,Customer Care Cloud -Case Close</value>
        </criteriaItems>
        <description>Changes the record type to &quot;Customer Care Cloud Closed Case&quot; when IsClosed is true</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Changes the record type to %22Customer Care Cloud%22 when IsClosed is false</fullName>
        <actions>
            <name>Change_Record_type_Customer_Care_Cloud</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Changes the record type to &quot;Customer Care Cloud&quot; when IsClosed is false</description>
        <formula>AND(
ISCHANGED(Status), 
( IsClosed =FALSE), 
(RecordType.Name = &apos;Customer Care Cloud -Case Close&apos;)
/*
,
(CASE(TEXT(Status),&apos;Close as Duplicate&apos;,&apos;1&apos;,&apos;Closed&apos;,&apos;1&apos;,&apos;Closed (No Action)&apos;,&apos;1&apos;,&apos;0&apos;)&lt;&gt;&apos;1&apos;)
*/
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Close case status field after 28 days</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,New Response Received,ReOpen,Waiting for Customer,Waiting for Finance,Waiting for GLOG,Waiting for Parts Set Up,Waiting for PIC,Waiting for Planning,Waiting for Pricing,Waiting for Product Management,Waiting for Quality</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting  for sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Customer Care Cloud</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Case_Record_type</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Case_Status_Comments</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_case_status_to_be_closed</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Customer Care Global Survey</fullName>
        <actions>
            <name>PIC_Case_closed_time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Closed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Generates Customer Survey email to Contact when a Case is closed</description>
        <formula>AND( Survey_Sent__c,OR(NOT( CONTAINS( SuppliedEmail ,&quot;@te.com&quot;)) ,ISBLANK(SuppliedEmail)), NOT(CONTAINS(Contact.Email  ,&quot;@te.com&quot;)),NOT( Contact.Customer_Survey_Opt_Out__c), ((Record_Type_Name__c=&quot;Customer_Care_Cloud&quot;)|| (Record_Type_Name__c=&quot;Customer_Care_Cloud_Case_feed_View&quot;)),  ISPICKVAL(Status, &apos;Closed&apos;), NOT(First_Survey__c),ClosedDate  &gt;= DATETIMEVALUE(&quot;2015-04-24 09:30:00&quot;),NOT(Emails_Have_Been_Archived_Deleted__c), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Customer_Survey_APAC</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>First_Survey</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Survey_Sent_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Survey_send_after_15_min__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Customer Request Alert</fullName>
        <actions>
            <name>Alert_to_CC_user</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(NOT(ISBLANK(SuppliedEmail)), CONTAINS($Setup.Customer_Request_Alert__c.Email_Value__c,SuppliedEmail))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Customer Survey- Japan</fullName>
        <actions>
            <name>Customer_Survey_Japan</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>First_Survey</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 3 AND 4 and 5 and 6 and 8 and (2 or 7) and 9</booleanFilter>
        <criteriaItems>
            <field>Case.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>@te.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Customer_Survey_Opt_Out__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>IND Admin Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Cloud,Customer Care Cloud -Case Close</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
            <value>Japan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notContain</operation>
            <value>@te.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.First_Survey__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Reopened__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Generates Customer Survey email to Contact when a Case is closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Survey- Spanish</fullName>
        <actions>
            <name>Customer_Survey_Spanish</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>First_Survey</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 3 AND 4 and 5 and 6 and 8 and (2 or 7) and 9 and 10</booleanFilter>
        <criteriaItems>
            <field>Case.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>@te.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Customer_Survey_Opt_Out__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>IND Admin Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Cloud,Customer Care Cloud -Case Close</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
            <value>Mexico</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notContain</operation>
            <value>@te.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.First_Survey__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ClosedDate</field>
            <operation>greaterOrEqual</operation>
            <value>4/23/2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Reopened__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Generates Customer Survey email to Contact when a Case is closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Survey-English</fullName>
        <actions>
            <name>Customer_Survey_English</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>First_Survey</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 3 AND 4 and 5 and 10)  and (2 or 9) and (6 OR 7) and 8 and 11 and 12 and 13</booleanFilter>
        <criteriaItems>
            <field>Case.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>@te.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Customer_Survey_Opt_Out__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>IND Admin Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care Cloud,Customer Care Cloud -Case Close</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
            <value>EMEA,America</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>notEqual</operation>
            <value>Japan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notContain</operation>
            <value>@te.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.First_Survey__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ClosedDate</field>
            <operation>greaterOrEqual</operation>
            <value>4/24/2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Reopened__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_not_send_survey__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Generates Customer Survey email to Contact when a Case is closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DTC Send Notification to Admin - Asia</fullName>
        <actions>
            <name>DTC_Send_Email_when_DTC_Request_is_Assigned_Asia</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Assigned_to_Field_Asia</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Subject_Line_on_DTC_REquest</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Notification_Sent_to_Admin</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>DataComm Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.User_Region__c</field>
            <operation>equals</operation>
            <value>Asia</value>
        </criteriaItems>
        <description>Sends an email to DTC Admin - Sonja notifying of a new request from user.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DTC Send Notification to Admin - EMEA</fullName>
        <actions>
            <name>DTC_Send_Email_when_DTC_Request_is_Assigned_EMEA</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Assigned_to_Field_EMEA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Subject_Line_on_DTC_REquest</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Notification_Sent_to_Admin</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>DataComm Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.User_Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <description>Sends an email to DTC Admin - EMEA notifying of a new request from user.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Forward PIC Japan Cases to jp-inquiry</fullName>
        <actions>
            <name>PIC_Japan_Forward_Case_Case_Information</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PIC_Japan_Close_case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingCountry</field>
            <operation>equals</operation>
            <value>Japan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Country__c</field>
            <operation>equals</operation>
            <value>Japan</value>
        </criteriaItems>
        <description>Forward PIC Japan Cases to &apos;jp-inquiry@te.com mail box</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ICT Case Date Time after 15 min Workflow</fullName>
        <actions>
            <name>Field_Update_on_ICT_Case_Date_Time_after</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>ICT Customer Service</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Is Email Send Uncheck on Case</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Is_Email_Send__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.LinkExpiration__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Is_Email_Send_Uncheck_on_Case</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.LinkExpiration__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Notify ICT User for Case</fullName>
        <actions>
            <name>Send_ICT_Customer_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>ICT_Update_Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 AND 4 ) OR 5</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Priority</field>
            <operation>equals</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TE_Enquiry_Flag__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>Lesa Hartman Schaefer</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PIC - ***New Case Email</fullName>
        <actions>
            <name>PIC_Email_Customer_on_Case_Creation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PIC_SNU_New_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11 AND 12 AND 13 AND 14 AND 15 and 16 AND 17 AND 18 AND 19 AND 20 AND 21 AND 22 AND 23 AND 24 AND 25</booleanFilter>
        <criteriaItems>
            <field>Case.CreatedById</field>
            <operation>notContain</operation>
            <value>mott</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Phone,Chat</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notContain</operation>
            <value>@qq.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>ENTER MESSAGE TO BE STOPPED</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>notContain</operation>
            <value>uatqjssjmpmhvgwcyjjjwbthpjkcfcwzrfxmopvzcriyi,out of the office,out of office,ENTER MESSAGE TO BE STOPPED,Delivery has failed to these recipients or groups</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Campaign__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.isCentralOldCase__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>[Incident: 1,Regards,Delivery Status,Out of office,Personal Leave,假日,放假一天,Undeliverable:</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Request Received by TE Connectivity CAD Services</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>9/29/2015 9:30 AM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>&quot;Abwesenheit &quot;,Easter Holiday,Holiday</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>&quot;Undeliverable: &quot;,Happy Diwali,Mail delivery failed,Undelivered Mail</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Delivery failure,Undelivered Mail Returned to Sender</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Risposta automatica,Undeliverable: Exeption in CCP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>New case email notification</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>&quot;Automatisch antwoord: &quot;</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>Automatic reply,UPGRADE YOUR EMAIL WITHIN 48HRS,your brain power ? learn how</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>postmaster@te.com,aeronet@1mjobs.org</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>THIS EMAIL IS NO LONGER MONITORED</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>ooo,OOO,out of the office,On business trip until,HELLO</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>on leave,Mail delivery failed: returning message to sender</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>notContain</operation>
            <value>打牌要赢钱加微信qianqily,Auto-Reply,Réponse automatique,FWD: Undelivered Mail Returned to Sender,Vacation,Holiday,Urlaub</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>Lesa Hartman Schaefer,ICT Customer Service</value>
        </criteriaItems>
        <description>To notify the customer that a case has been entered into the system</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Audit - field updates</fullName>
        <actions>
            <name>PIC_Audit_By_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PIC_Audit_Update_Business_hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PIC_Audit_Update_Date_Time_of_Audit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>update the date/time and business hours when the reason or notes are updated</description>
        <formula>$RecordType.Name = &quot;TE PIC Standard Case Record Type&quot; &amp;&amp; (ISCHANGED( Audit_Notes__c ) || ISCHANGED( Audit_Reason__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Case Chat Originating Queue</fullName>
        <actions>
            <name>PIC_SNU_Originating_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PIC_Update_Chat_Originating_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Chat</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Originating_Queue__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sets the Originating Queue to Web (Chat Sessions) for Chat Cases</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Case SPAM Workflow</fullName>
        <actions>
            <name>PIC_Updated_Status_Closed_Spam</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>breast,penis,ejaculation,viagra,suck,nude,fuck,animal,pussy,clit,Penis,rolex,ROLEX</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>breast,penis,ejaculation,viagra,suck,nude,fuck,animal,pussy,clit,Penis,rolex,ROLEX</value>
        </criteriaItems>
        <description>Update Status to closed spam if any of the words match (removed diet, dick)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Email Formula Field Update</fullName>
        <actions>
            <name>PIC_Populate_Workflow_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Formula_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>To update the email formula field into a field of type email address so that it can be used for workflow rules</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Notify Case Owner</fullName>
        <actions>
            <name>PIC_New_Case_Email_notify_case_owner</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PIC_SNU_new_case_note</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Notify the case owner on initial assignment, on re-assignment, or re-open from customer response.</description>
        <formula>$RecordType.Name = &quot;TE PIC Standard Case Record Type&quot; &amp;&amp; BEGINS(OwnerId , &quot;005&quot;) &amp;&amp; (NOT(CONTAINS( Owner:User.Profile.Name,&quot;CC&quot;)) || NOT(CONTAINS(Owner:User.Profile.Name,&quot;Customer Care&quot;))) &amp;&amp; ( ischanged( OwnerId ) || ( ischanged( Status ) &amp;&amp; ISPICKVAL( Status , &quot;Response Received&quot; ) &amp;&amp; NOT(CONTAINS(Owner_Role_Group__c,&quot;PIC Emea&quot;)) ) || (ispickval(Status, &quot;New&quot;) &amp;&amp; NOT(CONTAINS(Owner_Role_Group__c,&quot;PIC Emea&quot;)) ) || ispickval(Status, &quot;Assigned&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Originating Queue Update</fullName>
        <actions>
            <name>PIC_Originating_Queue_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Allow User to update the originating queue field for reporting purposes from a drop down list filed called Queue</description>
        <formula>(RecordType.Name = &quot;TE_PIC_Standard_Case_Record_Type&quot; &amp;&amp; ischanged(Queue__c) &amp;&amp; isblank(Originating_Queue__c) ) || ( isnew() &amp;&amp; RecordType.Name = &quot;TE_PIC_Standard_Case_Record_Type&quot; &amp;&amp; not ISPICKVAL(Queue__c, &quot;&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Queue Update back to blank</fullName>
        <actions>
            <name>PIC_Queue_Update_back_to_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <description>Always reset the Queue field back to bank. This will eliminate the confusion of the agent updating the queue field and the originating queue field is not allowed to be updated. This will prevent the two from having two different values.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Update Initial Response %28BH%29</fullName>
        <actions>
            <name>PIC_Update_Initial_Response_BH</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Initial Response time - Business hours field when the Initial Response time field is changed</description>
        <formula>AND( ISCHANGED( Initial_Response_TimeStamp__c ) , $RecordType.Name = &quot;TE PIC Standard Case Record Type&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Update Status and Queue</fullName>
        <actions>
            <name>PIC_SNU_Assign_change</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PIC_Update_Case_Status_to_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Queue_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Phone,Chat</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Notify the case owner on initial assignment, on re-assignment, or re-open from customer response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIC - Update WebToCase Site Guest User to US - PIC</fullName>
        <actions>
            <name>PIC_SNU_W2C_Guest_to_US</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PIC_Update_E2C_Initial_to_PIC_US</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>WebToCase Site Guest User,WebToCaseML</value>
        </criteriaItems>
        <description>PIC - when someone submits something on the website and somehow a Country isn&apos;t captured, route to US - PIC</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC Case Nurture Lead</fullName>
        <actions>
            <name>Check_Nurtured</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Nurturing_follow_up_required</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Case open as Nurturing Lead</value>
        </criteriaItems>
        <description>Create a task on status change for PIC person</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIC IS Survey</fullName>
        <actions>
            <name>PIC_IS_Survey</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>First_Survey</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Survey_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Generates PIC inside sales  Survey email to Contact when a Case is closed</description>
        <formula>AND( Survey_Sent__c , NOT( Contact.Customer_Survey_Opt_Out__c), (RecordType.Name  = &quot;TE PIC Standard Case Record Type&quot;),((NOT(CONTAINS(Contact.Email ,&quot;@te.com&quot;))) ||(NOT(CONTAINS(Contact.Email ,&quot;.jp&quot;)))), NOT( First_Survey__c), ClosedDate &gt;DATETIMEVALUE(&quot;2015-04-24 09:30:00&quot;),NOT(Case_Reopened__c), ( ISPICKVAL(Status, &quot;Closed-Inside Sales&quot;)), OR(ISPICKVAL(Origin ,&quot;Phone&quot;),ISPICKVAL(Origin ,&quot;Web&quot;),ISPICKVAL(Origin ,&quot;Chat&quot;)),NOT(Emails_Have_Been_Archived_Deleted__c), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIC Japan case</fullName>
        <actions>
            <name>PIC_Japan_Close_case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New,Assigned</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingCountry</field>
            <operation>equals</operation>
            <value>Japan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Country__c</field>
            <operation>equals</operation>
            <value>Japan</value>
        </criteriaItems>
        <description>close the case status for japan Pic cases</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PIC Survey</fullName>
        <actions>
            <name>PIC_Case_closed_time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Closed_By_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Generates PIC Survey email to Contact when a Case is closed</description>
        <formula>AND(Survey_Sent__c,OR(NOT(CONTAINS(SuppliedEmail ,&quot;@te.com&quot;)),  ISBLANK(SuppliedEmail)), NOT(Contact.Customer_Survey_Opt_Out__c), RecordType.Name =&quot;TE PIC Standard Case Record Type&quot;,(NOT(CONTAINS(Contact.Email ,&quot;@te.com&quot;)) || NOT(Do_not_send_survey__c)),NOT(First_Survey__c ),ClosedDate &gt;DATETIMEVALUE(&quot;2015-04-24 09:30:00&quot;),ISPICKVAL(Status,&quot;Closed&quot;), NOT(Emails_Have_Been_Archived_Deleted__c),$Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PIC_Survey</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>First_Survey</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Survey_Sent_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Survey_send_after_15_min__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PIC Update Hot Lead Created Date%2FTime</fullName>
        <actions>
            <name>PIC_Update_Hot_Lead_Created_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Case field &quot;Hot Lead Created Date/Time&quot; when a Case&apos;s Hot Lead checkbox is checked.</description>
        <formula>IsChanged(Hot_Lead__c) &amp;&amp; Hot_Lead__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PICCase reassignment notification</fullName>
        <actions>
            <name>Case_reassignment_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Case Re-assigned by CC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Case Re-assigned by PIC</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PICUpdateActivityNote</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Hot_Lead__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>TE PIC Standard Case Record Type</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>ActivityNote</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Sap Case Owner Change from TEIS Admin to a Queue</fullName>
        <actions>
            <name>Sap_Case_Owner_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>SAP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>TEIS Admin</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Time Dependent Workflow for ICT Escalation</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>contains</operation>
            <value>ICT Customer Service</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Escalation_ICT_Mail</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.ICT_Case_Date_Time_after_15_min__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Update Case Key Customer Code</fullName>
        <actions>
            <name>Update_Case_Key_Customer_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 or 2</booleanFilter>
        <criteriaItems>
            <field>Account.Key_Customer_Cde__c</field>
            <operation>startsWith</operation>
            <value>X04</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Key_Customer_Cde__c</field>
            <operation>startsWith</operation>
            <value>S</value>
        </criteriaItems>
        <description>Select Growth Requirement SD_SFDC_08</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update case status to close after 3 days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting for Fiscal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Customer_Care_Cloud</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_case_status_as_closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_customer_care_case_close</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_status_comment_case_field</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <tasks>
        <fullName>Case_nearing_4_Hour_Response_Time</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Case nearing 4 Hour Response Time</subject>
    </tasks>
    <tasks>
        <fullName>Notification_Sent_to_Admin</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Notification Sent to Admin</subject>
    </tasks>
    <tasks>
        <fullName>Nurturing_follow_up_required</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Nurturing follow up required</subject>
    </tasks>
</Workflow>
