<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contact_MQL_Notification_AM</fullName>
        <description>Contact MQL Notification - Account Manager</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TEMarketing__MQL_Notifications/TEMarketing__Contact_MQL_Notification</template>
    </alerts>
    <alerts>
        <fullName>Contact_MQL_Notification_FE</fullName>
        <description>Contact MQL Notification - Field Engineer</description>
        <protected>false</protected>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TEMarketing__MQL_Notifications/TEMarketing__Contact_MQL_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_account_manager_about_non_detractor_Passives</fullName>
        <description>Notify account manager about non detractor Passives</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NPS_Templates/Passives_NonDetractor_Notification</template>
    </alerts>
    <alerts>
        <fullName>Notify_account_manager_about_non_detractor_promoters</fullName>
        <description>Notify account manager about non detractor Promoters</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NPS_Templates/Promoters_NonDetractor_Notification</template>
    </alerts>
    <alerts>
        <fullName>TEMarketing__Contact_MQL_Notification</fullName>
        <description>Contact MQL Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>TEMarketing__MQL_Notifications/TEMarketing__Contact_MQL_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Manager_Email_Update</fullName>
        <field>Account_Manager_Email__c</field>
        <formula>Account.Account_Manager__r.Email</formula>
        <name>Account Manager Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Manager_Email_Update_Promoters</fullName>
        <field>Account_Manager_Email__c</field>
        <formula>Account.Account_Manager__r.Email</formula>
        <name>Account Manager Email Update Promoters</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Account_Name</fullName>
        <field>Account_Name__c</field>
        <formula>Account.Name</formula>
        <name>Define Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Mailing_City</fullName>
        <field>MailingCity</field>
        <formula>Account.BillingCity</formula>
        <name>Define Mailing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Mailing_Country</fullName>
        <field>MailingCountry</field>
        <formula>Account.BillingCountry</formula>
        <name>Define Mailing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Mailing_Street</fullName>
        <field>MailingStreet</field>
        <formula>Account.BillingStreet</formula>
        <name>Define Mailing Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Zip_Postal_Code</fullName>
        <field>MailingPostalCode</field>
        <formula>Account.BillingPostalCode</formula>
        <name>Define Zip/Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_Email_Send_UncheckContact</fullName>
        <description>Is Email Send UncheckContact</description>
        <field>Is_Email_Send__c</field>
        <literalValue>0</literalValue>
        <name>Is Email Send UncheckContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_IS_Survey_Date_Blank</fullName>
        <description>Resets Date of Last Survey field to blank after 60-days.</description>
        <field>Date_of_Last_Survey_IS__c</field>
        <name>Last IS Survey Date Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Last_Survey_Date_Blank</fullName>
        <description>Resets Date of Last Survey field to blank after 90-days.</description>
        <field>Date_of_Last_Survey__c</field>
        <name>Last Survey Date Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>New_Reason_for_Remove_NPS_contact</fullName>
        <description>When a inactive contact is set back to active the reason for remove NPS contact that was set to inactive will be set back to blank.</description>
        <field>Reason_for_remove_NPS_Contact_Flag__c</field>
        <name>New Reason for Remove NPS contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Last_Survey_Date_Blank</fullName>
        <description>Resets Date of Last Survey field to blank after 60-days.</description>
        <field>Date_of_Last_Survey_PIC__c</field>
        <name>PIC Last Survey Date Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PIC_Survey_Sent_Uncheck</fullName>
        <description>resets to FALSE after 60-days</description>
        <field>Survey_Sent_PIC__c</field>
        <literalValue>0</literalValue>
        <name>PIC Survey Sent Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reason_for_Remove_NPS_Contact_Flag</fullName>
        <description>When the NPS Contact Flag is set to unflagged because a contact is was set to inactive the Reason for Remove NPS Contact Flag is automatically set to &quot;inactive&quot;.</description>
        <field>Reason_for_remove_NPS_Contact_Flag__c</field>
        <literalValue>Inactive</literalValue>
        <name>Set Reason for Remove NPS Contact Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Survey_Sent_Uncheck</fullName>
        <description>resets to FALSE after 90-days</description>
        <field>Survey_Sent__c</field>
        <literalValue>0</literalValue>
        <name>Survey Sent Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unflag_NPS_contact</fullName>
        <description>When a contact is set to inactive the field NPS contact should be set to unflagged</description>
        <field>NPS_Contact__c</field>
        <literalValue>0</literalValue>
        <name>Unflag NPS contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unflag_NPS_contact_after_NPS_opt_out</fullName>
        <description>Once the NPS opt out is flagged the field NPS contact is automatically set to unflagged.</description>
        <field>NPS_Contact__c</field>
        <literalValue>0</literalValue>
        <name>Unflag NPS contact after NPS opt out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unflag_NPS_opt_out</fullName>
        <description>Unflag NPS opt out after the contact is set from inactive back to active</description>
        <field>NPS_OPT_OUT__c</field>
        <literalValue>0</literalValue>
        <name>Unflag NPS opt out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Connection_Record_Type</fullName>
        <field>Connection_Record_Type__c</field>
        <formula>&quot;BU Contact&quot;</formula>
        <name>Update Connection Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Reason_for_Remove_NPS_contact</fullName>
        <description>Once the field NPS contact is unflagged by this workflow the Reason for Remove NPS contact is set to &quot;NPS opt out&quot;.</description>
        <field>Reason_for_remove_NPS_Contact_Flag__c</field>
        <literalValue>Opt out</literalValue>
        <name>Update Reason for Remove NPS contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>flag_e_mail_opt_out</fullName>
        <description>turns the flag e-mail opt out to on</description>
        <field>HasOptedOutOfEmail</field>
        <literalValue>1</literalValue>
        <name>flag e-mail opt out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>opt_out_from_customer_surveys</fullName>
        <description>flags the field customer survey opt out</description>
        <field>Customer_Survey_Opt_Out__c</field>
        <literalValue>1</literalValue>
        <name>opt out from customer surveys</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>populate_opt_out_reason</fullName>
        <description>populate the NPS opt out reason with email opt out</description>
        <field>Reason_for_remove_NPS_Contact_Flag__c</field>
        <literalValue>email opt out</literalValue>
        <name>populate opt out reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>remove_invite_for_customer_event_flag</fullName>
        <description>turns the flag Invite for customer events to false</description>
        <field>invite_to_trade_fair_customer_events__c</field>
        <literalValue>0</literalValue>
        <name>remove invite for customer event flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>remove_invite_for_trade_fair_flag</fullName>
        <description>turns the invite to trade fair flag to inactive</description>
        <field>invite_to_trade_fair__c</field>
        <literalValue>0</literalValue>
        <name>remove invite for trade fair flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Customer Survey Uncheck</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Unchecks (resets) Customer Survey sent checkbox on the Contact record 60-days after the survey has been sent.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Last_Survey_Date_Blank</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Survey_Sent_Uncheck</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Date_of_Last_Survey__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Define Contact Address</fullName>
        <actions>
            <name>Define_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Define_Mailing_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Define_Mailing_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Define_Mailing_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Define_Zip_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Contact.MailingCity</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingCountry</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingStreet</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingPostalCode</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This wf rule copies address of the account to the contact in case this wasn&apos;t set while migration.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Inside Sales Survey Uncheck</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Unchecks (resets) Inside Sales Survey sent checkbox on the Contact record 60-days after the survey has been sent.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Last_IS_Survey_Date_Blank</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Survey_Sent_Uncheck</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Date_of_Last_Survey_IS__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Is Email Send Uncheck</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Is_Email_Send__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.LinkExpiration__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Is_Email_Send_UncheckContact</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.LinkExpiration__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Notify Account Manager - MQL</fullName>
        <actions>
            <name>Contact_MQL_Notification_AM</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>(( ISNEW() || ISCHANGED(TEMarketing__Inquiry_Status__c) ) &amp;&amp; TEXT(TEMarketing__Inquiry_Status__c) ==&apos;Marketing Qualified&apos; ) &amp;&amp; (ISNULL(Account.FE_Hierarchy__c) || TRIM(Account.FE_Hierarchy__c) == &apos;&apos;) &amp;&amp;  NOT(ISNULL(Account.Account_Manager__c)) &amp;&amp; TRIM(Account.Account_Manager__c) != &apos;&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Contact Owner - MQL %28v2%29</fullName>
        <actions>
            <name>TEMarketing__Contact_MQL_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>(( ISNEW() || ISCHANGED(TEMarketing__Inquiry_Status__c) ) &amp;&amp; TEXT(TEMarketing__Inquiry_Status__c) ==&apos;Marketing Qualified&apos; ) &amp;&amp; (ISNULL(Account.FE_Hierarchy__c) || TRIM(Account.FE_Hierarchy__c) == &apos;&apos;) &amp;&amp; (ISNULL(Account.Account_Manager__c) || TRIM(Account.Account_Manager__c) == &apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Field Engineer - MQL</fullName>
        <actions>
            <name>Contact_MQL_Notification_FE</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>(( ISNEW() || ISCHANGED(TEMarketing__Inquiry_Status__c) ) &amp;&amp; TEXT(TEMarketing__Inquiry_Status__c) ==&apos;Marketing Qualified&apos; ) &amp;&amp; NOT(ISNULL(Account.FE_Hierarchy__c )) &amp;&amp; TRIM(Account.FE_Hierarchy__c) != &apos;&apos;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIC Survey Uncheck</fullName>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Contact.Survey_Sent_PIC__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Survey_Sent__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Unchecks (resets) PIC Survey sent checkbox on the Contact record 60-days after the survey has been sent.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PIC_Last_Survey_Date_Blank</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>PIC_Survey_Sent_Uncheck</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Survey_Sent_Uncheck</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Contact.Date_of_Last_Survey_PIC__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate Connection Record Type - Cont</fullName>
        <actions>
            <name>Update_Connection_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.LastName</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Record Type fields cannot be subscribed to when mapping fields in SF2SF. Therefore this workflow rule will be utilized to update a field called Connection Record Type and that field will be published by this org to central to transmit the record type.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Passives Non Detractor Email</fullName>
        <actions>
            <name>Notify_account_manager_about_non_detractor_Passives</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Manager_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Survey_Attended_Date__c),ISPICKVAL( Campaign_Type__c, &apos;Industries&apos;), NPS_Status__c  = &apos;Passive&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Promoters Non Detractor Email</fullName>
        <actions>
            <name>Notify_account_manager_about_non_detractor_promoters</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Account_Manager_Email_Update_Promoters</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Survey_Attended_Date__c),  ISPICKVAL( Campaign_Type__c, &apos;Industries&apos;), NPS_Status__c  = &apos;Promoter&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TEMarketing__Notify Contact Owner - MQL</fullName>
        <actions>
            <name>TEMarketing__Contact_MQL_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>(( ISNEW() || ISCHANGED(TEMarketing__Inquiry_Status__c) ) &amp;&amp; TEXT(TEMarketing__Inquiry_Status__c) ==&apos;Marketing Qualified&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Unflag NPS Contact after checking NPS opt out</fullName>
        <actions>
            <name>Unflag_NPS_contact_after_NPS_opt_out</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Reason_for_Remove_NPS_contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the NPS opt out checkbox is flagged the NPS Contact will be set to unflagged and the reason for remove NPS contact will be set to opt out.</description>
        <formula>NPS_OPT_OUT__c  = true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unflag NPS and opt out fields after setting a contact to inactive</fullName>
        <actions>
            <name>Set_Reason_for_Remove_NPS_Contact_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unflag_NPS_contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>flag_e_mail_opt_out</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>opt_out_from_customer_surveys</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>remove_invite_for_customer_event_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>remove_invite_for_trade_fair_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a contact is set to inactive the NPS contact field should be set to unflagged and the reason for remove this flag is inactive. Also e-mail opt out and other fields like invite to trade fair should be updated accordingly</description>
        <formula>Inactive__c  = true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Unflag NPS contact when e-mail opt out has been checked</fullName>
        <actions>
            <name>Unflag_NPS_contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>populate_opt_out_reason</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a contact gets Checked for &quot;email opt ou&quot; the NPS contact field should be set to unflagged and the reason for remove this flag is inactive.</description>
        <formula>HasOptedOutOfEmail = true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Reason for Remove NPS Contact after setting contact from inactive to active</fullName>
        <actions>
            <name>New_Reason_for_Remove_NPS_contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Unflag_NPS_opt_out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Inactive__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updates Reason for Remove NPS Contact to blanc after setting contact from inactive back to active.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
