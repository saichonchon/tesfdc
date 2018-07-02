<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APL_Ten_days_notification</fullName>
        <description>APL 10 days notification</description>
        <protected>false</protected>
        <recipients>
            <field>Owner_Manager_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>All_Email_Templates/APL_Opportunity_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Appliances_Engineer_Project_EM_Approved</fullName>
        <description>Appliances Engineer Project EM Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Product_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_is_approved</template>
    </alerts>
    <alerts>
        <fullName>Appliances_Engineer_Project_G1_Rejected</fullName>
        <description>Appliances Engineer Project G1 Rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Engineering</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Enginner (SE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>mark.westen@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Appliances_Engineer_Project_PM_Approved</fullName>
        <description>Appliances Engineer Project PM Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Enginner (SE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_is_approved</template>
    </alerts>
    <alerts>
        <fullName>Appliances_Engineer_Project_REM_Approved</fullName>
        <description>Appliances Engineer Project REM Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Engineering</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Enginner (SE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_is_approved</template>
    </alerts>
    <alerts>
        <fullName>Appliances_Engineer_Project_Rejected_by_Global_EM</fullName>
        <description>Appliances Engineer Project Rejected by Global EM</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Engineering</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Enginner (SE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Appliances_Engineer_Project_Rejected_by_Global_PM</fullName>
        <description>Appliances Engineer Project Rejected by Global PM</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Appliances_Engineer_Project_Rejected_by_REM</fullName>
        <description>Appliances Engineer Project Rejected by REM</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Engineering</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Enginner (SE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>mark.westen@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Appliances_Opportunity_transfer_in_notification</fullName>
        <description>Appliances Opportunity transfer in notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>eric_wu@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>franklin.shang@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Opportunity_Billing_Region_Change</template>
    </alerts>
    <alerts>
        <fullName>CCR_Email_to_AMER_BU_Admin_to_inform_no_action_on_CCR_part_after_10_day</fullName>
        <description>CCR Email to AMER BU Admin to inform no action on CCR part after 10 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template_for_CCR</template>
    </alerts>
    <alerts>
        <fullName>CCR_Email_to_AMER_BU_Admin_to_inform_no_action_on_CCR_part_after_5_day</fullName>
        <description>CCR Email to AMER BU Admin to inform no action on CCR part after 5 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template_for_CCR</template>
    </alerts>
    <alerts>
        <fullName>CCR_Email_to_AP_BU_Admin_to_inform_no_action_on_CCR_part_after_10_day</fullName>
        <description>CCR Email to AP BU Admin to inform no action on CCR part after 10 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template_for_CCR</template>
    </alerts>
    <alerts>
        <fullName>CCR_Email_to_AP_BU_Admin_to_inform_no_action_on_CCR_part_after_5_day</fullName>
        <description>CCR Email to AP BU Admin to inform no action on CCR part after 5 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template_for_CCR</template>
    </alerts>
    <alerts>
        <fullName>CCR_Email_to_EMEA_BU_Admin_to_inform_no_action_on_CCR_part_after_10_day</fullName>
        <description>CCR Email to EMEA BU Admin to inform no action on CCR part after 10 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template_for_CCR</template>
    </alerts>
    <alerts>
        <fullName>CCR_Email_to_EMEA_BU_Admin_to_inform_no_action_on_CCR_part_after_5_day</fullName>
        <description>CCR Email to EMEA BU Admin to inform no action on CCR part after 5 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template_for_CCR</template>
    </alerts>
    <alerts>
        <fullName>CSDECRequestTypeafterStep1approval</fullName>
        <description>CSDECRequestTypeafterStep1approval</description>
        <protected>false</protected>
        <recipients>
            <field>Engineerning_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Opportunity_EGM_Request_Approval</template>
    </alerts>
    <alerts>
        <fullName>CSDECRequestTypeafterStep3Approval</fullName>
        <description>CSDECRequestTypeafterStep3Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Final_Approved</template>
    </alerts>
    <alerts>
        <fullName>CSDECRequestTypeafterStep3Reject</fullName>
        <description>CSDECRequestTypeafterStep3Reject</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/CSD_Eng_Approval_Rejected_by_EGM</template>
    </alerts>
    <alerts>
        <fullName>CSDNonECRequestTypeafterStep1approval</fullName>
        <description>CSDNonECRequestTypeafterStep1approval</description>
        <protected>false</protected>
        <recipients>
            <field>Product_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Opportunity_PGM_Request_Approval</template>
    </alerts>
    <alerts>
        <fullName>CSDNonECRequestTypeafterStep3Reject</fullName>
        <description>CSDNonECRequestTypeafterStep3Reject</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Product_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/CSD_Eng_Approval_Rejected_by_EGM</template>
    </alerts>
    <alerts>
        <fullName>CSDPLMComplexityType0forEGM</fullName>
        <description>CSDPLMComplexityType0forEGM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Engineerning_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Opportunity_EGM_Request_Approval_Type0</template>
    </alerts>
    <alerts>
        <fullName>CSDPLMComplexityType12forEGM</fullName>
        <description>CSDPLMComplexityType12forEGM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Engineerning_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Opportunity_EGM_Request_Approval_Type12</template>
    </alerts>
    <alerts>
        <fullName>CSD_Opportunity_PM_Action_Notification</fullName>
        <description>CSD Opportunity PM Action Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/CSD_Opportunity_PM_Action</template>
    </alerts>
    <alerts>
        <fullName>Create_RTS_for_APL_ENG_Request_Follow_up</fullName>
        <description>Create RTS for APL ENG Request Follow up</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/RTS_required_for_ENG_OPP</template>
    </alerts>
    <alerts>
        <fullName>Currency_Changed_Notification</fullName>
        <description>Currency Changed Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/Oppy_Currency_Changed_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_CCROppPart_Approval_day1</fullName>
        <description>Email Alert for CCROppPart Approval-day1</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>NDR_Email_Templates/Email_Alert_for_CCR_Opp_Part_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_CCROppPart_Approval_day14</fullName>
        <description>Email Alert for CCROppPart Approval-day14</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>NDR_Email_Templates/Email_Alert_for_CCR_Opp_Part_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_CCROppPart_Approval_day19</fullName>
        <description>Email Alert for CCROppPart Approval-day19</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>NDR_Email_Templates/Email_Alert_for_CCR_Opp_Part_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_CCROppPart_Approval_day7</fullName>
        <description>Email Alert for CCROppPart Approval-day7</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/Email_Alert_for_CCR_Opp_Part_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_NDROppPart_Approval_day1</fullName>
        <description>Email Alert for NDROppPart Approval-day1</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>NDR_Email_Templates/Email_Alert_for_Opp_Part_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_NDROppPart_Approval_day14</fullName>
        <description>Email Alert for NDROppPart Approval-day14</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>NDR_Email_Templates/Email_Alert_for_Opp_Part_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_NDROppPart_Approval_day19</fullName>
        <description>Email Alert for NDROppPart Approval-day19</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>NDR_Email_Templates/Email_Alert_for_Opp_Part_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_for_NDROppPart_Approval_day7</fullName>
        <description>Email Alert for NDROppPart Approval-day7</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/Email_Alert_for_Opp_Part_Approval</template>
    </alerts>
    <alerts>
        <fullName>Email_Alert_to_Opportunity_Owner_and_his_Manager</fullName>
        <description>Email Alert to Opportunity Owner and his Manager</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/Two_days_before_opportunity_closed_Notification</template>
    </alerts>
    <alerts>
        <fullName>Email_Notification_on_the_New_Opportunity</fullName>
        <description>Email Notification on the New Opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>ataylor@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>hmopty@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jhlavaty@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Owners_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/Email_Notification_on_the_New_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Final_Approved</fullName>
        <description>Final Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Product_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/Final_Approved</template>
    </alerts>
    <alerts>
        <fullName>Initial_Email_Alert</fullName>
        <description>Initial Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/NDR_Opportunity_Reminder</template>
    </alerts>
    <alerts>
        <fullName>Intercontec_D_D</fullName>
        <description>Intercontec D&amp;D</description>
        <protected>false</protected>
        <recipients>
            <recipient>Inside Sales Intercontec</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pricing</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Intercontec_D_D</template>
    </alerts>
    <alerts>
        <fullName>Intercontec_Won</fullName>
        <description>Intercontec Won</description>
        <protected>false</protected>
        <recipients>
            <recipient>Customer Care Professional</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Engineering</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Inside Sales Intercontec</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pricing</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Supply Chain</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Intercontec_Won</template>
    </alerts>
    <alerts>
        <fullName>MED_Notify_Opp_Owner_120</fullName>
        <description>Med Notify Opp Owner 120</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>MED_Notify_Opp_Owner_150</fullName>
        <description>Med Notify Opp Owner 150</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>MED_Notify_Opp_Owner_90</fullName>
        <description>Med Notify Opp Owner 90</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Med_Alert_Opp_Not_Upd_in_50Days</fullName>
        <description>Med Alert Opp Not Upd in 50Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_50_days_no_update</template>
    </alerts>
    <alerts>
        <fullName>Med_Notify_Account_Owner_120</fullName>
        <description>Med Notify Account Owner 120</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Med_Notify_Account_Owner_150</fullName>
        <description>Med Notify Account Owner 150</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Med_Notify_Account_Owner_60</fullName>
        <description>Med Notify Account Owner 60</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Med_Notify_Account_Owner_90</fullName>
        <description>Med Notify Account Owner 90</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Med_Notify_Opp_Owner_60</fullName>
        <description>Med Notify Opp Owner 60</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/MED_Opp_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Med_Notify_Opp_Owner_7_Days_before_Go_No_Go</fullName>
        <ccEmails>lhartman@te.com</ccEmails>
        <description>Med Notify Opp Owner 7 Days before Go-No Go</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>dave.greer@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/MED_Go_No_Go_in_7_Days</template>
    </alerts>
    <alerts>
        <fullName>NDR_Email_to_AMER_BU_Admin_to_inform_no_action_on_NDR_part_after_10_day</fullName>
        <description>NDR Email to AMER BU Admin to inform no action on NDR part after 10 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>NDR_Email_to_AMER_BU_Admin_to_inform_no_action_on_NDR_part_after_5_day</fullName>
        <description>NDR Email to AMER BU Admin to inform no action on NDR part after 5 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>NDR_Email_to_AP_BU_Admin_to_inform_no_action_on_NDR_part_after_10_day</fullName>
        <description>NDR Email to AP BU Admin to inform no action on NDR part after 10 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>NDR_Email_to_AP_BU_Admin_to_inform_no_action_on_NDR_part_after_5_day</fullName>
        <description>NDR Email to AP BU Admin to inform no action on NDR part after 5 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>NDR_Email_to_EMEA_BU_Admin_to_inform_no_action_on_NDR_part_after_10_day</fullName>
        <description>NDR Email to EMEA BU Admin to inform no action on NDR part after 10 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>NDR_Email_to_EMEA_BU_Admin_to_inform_no_action_on_NDR_part_after_5_day</fullName>
        <description>NDR Email to EMEA BU Admin to inform no action on NDR part after 5 day</description>
        <protected>false</protected>
        <recipients>
            <field>NDR_Owner_Manager_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NDR_Email_Templates/BU_Admin_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Near_Overdue_Notification</fullName>
        <description>Near Overdue Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>All_Email_Templates/Opportunity_Near_Overdue_Notification_For_DND</template>
    </alerts>
    <alerts>
        <fullName>No_Update_Notification</fullName>
        <description>No Update Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>All_Email_Templates/Opportunity_Overdue_Notification_For_DND</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Bret_Miller</fullName>
        <description>Notification to Bret Miller</description>
        <protected>false</protected>
        <recipients>
            <recipient>bcmiller@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_is_approved</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Bret_Miller_rejected</fullName>
        <description>Notification to Bret Miller_rejected</description>
        <protected>false</protected>
        <recipients>
            <recipient>bcmiller@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_is_rejected</template>
    </alerts>
    <alerts>
        <fullName>Notification_to_Nick_Lucariello</fullName>
        <description>Notification to Nick Lucariello</description>
        <protected>false</protected>
        <recipients>
            <recipient>nlucarie@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_is_approved</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Overdue_80_Days_Notification_NDR_Opportunity</fullName>
        <description>Opportunity Overdue 80 Days Notification - NDR Opportunity</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/Opportunity_Overdue_Notification_NDR_Opportunity</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Rejection</fullName>
        <description>Opportunity Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Reminder_For_opportunities_created_from_Leads</fullName>
        <description>Opportunity Reminder For opportunities created from Leads</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Opportunity_Reminders</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_is_rejected_by_EGM</fullName>
        <description>Opportunity is rejected by EGM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Product_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/CSD_Eng_Approval_Rejected_by_EGM</template>
    </alerts>
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
    <alerts>
        <fullName>Opportunity_was_Approved</fullName>
        <description>Opportunity was Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_is_approved</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_was_G1_Approved</fullName>
        <description>Opportunity was G1 Approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Engineering</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Partner SE</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Management</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Enginner (SE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_is_approved</template>
    </alerts>
    <alerts>
        <fullName>PLMIDgeneratednotification</fullName>
        <description>PLMIDgeneratednotification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Engineerning_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Product_General_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/PLMIDgeneratenotification</template>
    </alerts>
    <alerts>
        <fullName>Quote_is_attached_to_opportunity</fullName>
        <description>Quote is attached to opportunity</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager (AM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Customer Care Professional</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Engineering</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Field Engineer (FE)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Global Account Manager (GAM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Pricing</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Project Manager (PjM)</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Quote_attached</template>
    </alerts>
    <alerts>
        <fullName>ROA_Email_Notification_on_Project_Related_to_World_Bank_Financed</fullName>
        <description>ROA - Email Notification on Project Related to World Bank Financed</description>
        <protected>false</protected>
        <recipients>
            <recipient>energy_prj_deployment_user@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ROA_Email_Templates/ROA_Email_notification_on_Project_Related_to_World_Bank_Financed</template>
    </alerts>
    <alerts>
        <fullName>Reject_by_PGM</fullName>
        <description>Reject by PGM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Global_Product_Manager__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/CSD_Eng_Approval_Rejected_by_PGM</template>
    </alerts>
    <alerts>
        <fullName>Rejected_by_GPM</fullName>
        <description>Rejected by GPM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/CSD_Eng_Approval_Rejected_by_GPM</template>
    </alerts>
    <alerts>
        <fullName>Rejection_by_Global_PM</fullName>
        <description>Rejection by Global PM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>frederic.faisst@itbconsult.com.cis</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Rejection_by_Regional_EM</fullName>
        <description>Rejection by Regional EM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>frederic.faisst@itbconsult.com.cis</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/Opportunity_Approval_Rejection</template>
    </alerts>
    <alerts>
        <fullName>SalesEmailNotofication</fullName>
        <description>SalesEmailNotofication</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Templates/SalesNotification</template>
    </alerts>
    <alerts>
        <fullName>Set_Project_Complexity_by_CTL</fullName>
        <description>Set Project Complexity by CTL</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>frederic.faisst@itbconsult.com.cis</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/CTL_set_Project_Complexity</template>
    </alerts>
    <alerts>
        <fullName>Set_Project_Complexity_by_LCE</fullName>
        <description>Set Project Complexity by LCE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>frederic.faisst@itbconsult.com.cis</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>All_Email_Templates/LCE_set_Project_Complexity</template>
    </alerts>
    <alerts>
        <fullName>TEMarketing__Notify_owner_of_opportunity_created_by_Distributor</fullName>
        <description>Notify owner of opportunity created by Distributor</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>TEMarketing__MQL_Notifications/TEMarketing__Opportunity_Notification</template>
    </alerts>
    <alerts>
        <fullName>TE_Project_required_for_ENG_request</fullName>
        <description>TE Project required for ENG request</description>
        <protected>false</protected>
        <recipients>
            <field>Regional_PM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Approval_Email_Templates/TE_Project_required_for_ENG_OPP</template>
    </alerts>
    <alerts>
        <fullName>Ten_days_notification</fullName>
        <description>10 days notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>All_Email_Templates/Opportunity_Overdue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Your_SFDC_Opportunity_Approval_Approved</fullName>
        <description>Your SFDC Opportunity Approval - Approved</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Energy_Emails/Your_SFDC_Opportunity_Approval_Approved</template>
    </alerts>
    <alerts>
        <fullName>Your_SFDC_Opportunity_Approval_Rejected</fullName>
        <description>Your SFDC Opportunity Approval - Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Energy_Emails/Your_SFDC_Opportunity_Approval_Rejected</template>
    </alerts>
    <alerts>
        <fullName>big_deal_alert_template_For_All</fullName>
        <description>big deal alert template For All</description>
        <protected>false</protected>
        <recipients>
            <recipient>weiqiang.liu@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/Big_Deal_Alerts</template>
    </alerts>
    <alerts>
        <fullName>big_deal_alert_template_For_Americas</fullName>
        <description>big deal alert template For Americas</description>
        <protected>false</protected>
        <recipients>
            <recipient>dia.siraki@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jglahn@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Opportunity_Templates/Big_Deal_Alerts</template>
    </alerts>
    <fieldUpdates>
        <fullName>AMR_Opportunity_Closed_Date</fullName>
        <field>Closed_date_Counter__c</field>
        <formula>IF((PRIORVALUE(CloseDate)!= CloseDate),
IF(ISNULL(Closed_date_Counter__c),0, Closed_date_Counter__c) + 1,0)</formula>
        <name>AMR - Opportunity Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status - Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Status</fullName>
        <description>Approval Status is changed to Approved</description>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CPM_Image</fullName>
        <description>Field Update for the Stage_Name_URL__c field on the Opportunity Object. Updates the field based on the StageName field to a URL that references images in the document library so that the Stage__c field can render the image.</description>
        <field>Phase_Image_URL__c</field>
        <formula>IF(TEXT(StageName)=&quot;Concept&quot;, &quot;/servlet/servlet.FileDownload?file=015E0000000ovSa&quot;,
IF(TEXT(StageName)=&quot;Design&quot;, &quot;/servlet/servlet.FileDownload?file=015E0000000ovSf&quot;,
IF(TEXT(StageName)=&quot;Prototype&quot;, &quot;/servlet/servlet.FileDownload?file=015E0000000ovSk&quot;,
IF(TEXT(StageName)=&quot;Manufacturing&quot;, &quot;/servlet/servlet.FileDownload?file=015E0000000ovSp&quot;, &quot;/servlet/servlet.FileDownload?file=015E0000000ovoW&quot; ))))</formula>
        <name>CPM_Image</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSDApprovalsetNull</fullName>
        <field>Csd_PLM_Approval__c</field>
        <name>CSDApprovalsetNull</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSD_Explanation_alerts</fullName>
        <field>Alert_Validation__c</field>
        <formula>IF( (ISCHANGED(Amount) || ISCHANGED(Two_Years_Revenue__c))&amp;&amp; User_Updated_Date__c = today() ,&apos;1&apos; , IF( (ISCHANGED(Amount) || ISCHANGED(Two_Years_Revenue__c))&amp;&amp; User_Updated_Date__c &lt;&gt; today() ,&apos;2&apos;,CASE(
Alert_Validation__c,
&apos;1&apos;, IF(ISCHANGED(Explanation_of_Change__c),&apos;&apos;,   Alert_Validation__c ),
&apos;2&apos;,IF( ISCHANGED(Explanation_of_Change__c)&amp;&amp;ISCHANGED(User_Updated_Date__c),&apos;&apos;,IF(ISCHANGED(Explanation_of_Change__c),&apos;3&apos;,IF( ISCHANGED(User_Updated_Date__c),&apos;1&apos;,Alert_Validation__c ) ) ),
&apos;3&apos;,IF( ISCHANGED(User_Updated_Date__c),&apos;&apos;,Alert_Validation__c),null)))</formula>
        <name>CSD Explanation alerts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSD_PLM_Rejection_TimeStamp</fullName>
        <description>to get the timestamp of Rection, It is supposed to generate the now timestamp in every rejection of all the steps, so reused!</description>
        <field>CSD_PLM_Rejection_Time__c</field>
        <formula>NOW()</formula>
        <name>CSD PLM Rejection TimeStamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSD_PLM_approval_status</fullName>
        <description>This is to set the status null when the record is cloned</description>
        <field>Csd_PLM_Approval__c</field>
        <name>CSD PLM approval status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSD_Reset_PM_Weekly_Update_to_False</fullName>
        <description>Added for CSD case 00717369</description>
        <field>PM_Weekly_Update__c</field>
        <literalValue>0</literalValue>
        <name>CSD Reset PM Weekly Update to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSD_Set_Rejection_Reasons_To_NULL</fullName>
        <description>Nullifying Rejection reasons as it is a submission.</description>
        <field>Lost_Rejected_Dead_On_Hold_Reason__c</field>
        <name>CSD Set Rejection Reasons To NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSD_Update_FAE_Name</fullName>
        <field>FAE_Name__c</field>
        <formula>$User.FirstName &amp; &apos; &apos; &amp;  $User.LastName</formula>
        <name>CSD Update FAE Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Check_Customer_Pays_Tooling_Contributio</fullName>
        <field>Customer_Pays_Tooling_Contribution__c</field>
        <literalValue>1</literalValue>
        <name>Check Customer Pays Tooling Contributio</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Date_when_quote_requested</fullName>
        <field>Date_when_quote_requested__c</field>
        <name>Clear Date when quote requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Med_Quote_Released_Date</fullName>
        <description>Set MED Quote Released Date to nothing.</description>
        <field>MED_Quote_Released_Date__c</field>
        <name>Clear Med Quote Released Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Date_Override</fullName>
        <description>today&apos;s date when opportunities are closed won</description>
        <field>CloseDate</field>
        <name>Close Date Override</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Count_of_Rejection</fullName>
        <field>Is_Rejected__c</field>
        <formula>+1</formula>
        <name>Count of Rejection</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Criteria_is_met</fullName>
        <field>Criteria_Meet__c</field>
        <literalValue>1</literalValue>
        <name>Criteria is met</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Csd_PLM_Step1_Approval</fullName>
        <field>Csd_PLM_Approval__c</field>
        <literalValue>Step 1</literalValue>
        <name>Csd PLM Step1 Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Csd_PLM_Step2_Approval</fullName>
        <field>Csd_PLM_Approval__c</field>
        <literalValue>Step 2</literalValue>
        <name>Csd PLM Step2 Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Csd_PLM_Step3_Approval</fullName>
        <field>Csd_PLM_Approval__c</field>
        <literalValue>Step 3</literalValue>
        <name>Csd PLM Step3 Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_CTL_Approval</fullName>
        <field>CTL_Approval__c</field>
        <literalValue>1</literalValue>
        <name>Define CTL Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Mass_prod</fullName>
        <description>This field updates sets oppy stage to &quot;Mass-prod&quot;.</description>
        <field>StageName</field>
        <literalValue>Won - Closed</literalValue>
        <name>Define Mass-prod</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Pre_prod</fullName>
        <description>Updates Oppy Stage to &quot;Rejected&quot;.</description>
        <field>StageName</field>
        <literalValue>Rejected</literalValue>
        <name>Define Pre-prod</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ENG_Approval_Status_Awaiting_Approval</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Awaiting Approval</literalValue>
        <name>ENG_Approval Status_Awaiting Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval</fullName>
        <field>StageName</field>
        <literalValue>Approved/Active</literalValue>
        <name>Final Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approver</fullName>
        <description>Sets the name of the final approver for CCAO opportunities</description>
        <field>Final_Approver_Name__c</field>
        <formula>CCAO_Manager_Alias__c</formula>
        <name>Final Approver</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Rejected</fullName>
        <field>StageName</field>
        <literalValue>Rejected - Closed</literalValue>
        <name>Final Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Get_OEM_Name</fullName>
        <field>OEM__c</field>
        <formula>OEM_Name__r.Name</formula>
        <name>Get OEM Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Set_Won_Date</fullName>
        <field>Won_Date_G3_Reporting__c</field>
        <formula>TODAY()</formula>
        <name>IND Set Won Date G3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>In_Approval_Status</fullName>
        <description>Approval Status is changed to In Approval</description>
        <field>Approval_Status__c</field>
        <literalValue>In Approval</literalValue>
        <name>In Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Phase</fullName>
        <field>StageName</field>
        <literalValue>In Approval</literalValue>
        <name>Initial Phase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Reminder_Update</fullName>
        <field>Initial_Reminder__c</field>
        <formula>IF( 
CASE( 
MOD( 
(TODAY()+2)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(TODAY()+2),
IF( 
CASE( 
MOD( 
(TODAY()+3)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(TODAY()+3),
IF( 
CASE( 
MOD( 
(TODAY()+4)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(TODAY()+4),
IF( 
CASE( 
MOD( 
(TODAY()+5)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(TODAY()+5),NULL)
)
)
)</formula>
        <name>Initial Reminder Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Is_approved_Regional_Sales_Director</fullName>
        <field>Is_approved_Regional_Sales_Director__c</field>
        <literalValue>1</literalValue>
        <name>Is approved Regional Sales Director</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MED_Set_Med_Conf</fullName>
        <description>Set Med Conf to 100</description>
        <field>MED_Opp_Confidence__c</field>
        <literalValue>100</literalValue>
        <name>MED Set Med Conf</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MED_Update_Probability</fullName>
        <description>Updates the probability to the MED Opp Confidence</description>
        <field>Probability</field>
        <formula>VALUE(TEXT( MED_Opp_Confidence__c )) * 0.01</formula>
        <name>MED Update Probability</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MED_set_Med_Quote_Released_Date</fullName>
        <description>Set MED_Quote_Released_Date__c to today&apos;s date</description>
        <field>MED_Quote_Released_Date__c</field>
        <formula>Now()</formula>
        <name>MED set Med Quote Released Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Med_Set_Stage_to_Approved_Active</fullName>
        <description>Set opportunity Stage to Approved/Active when Med Opp Status, for sales opp, goes from closed back to open.</description>
        <field>StageName</field>
        <literalValue>Approved/Active</literalValue>
        <name>Med Set Stage to Approved/Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Med_Set_Stage_to_New</fullName>
        <description>Set Stage back to New when Med engineering opp goes from closed back to open Med Opp Status</description>
        <field>StageName</field>
        <literalValue>New</literalValue>
        <name>Med Set Stage to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Med_set_Phase_to_Lead_Dead_closed</fullName>
        <field>StageName</field>
        <literalValue>Lost/Dead - closed</literalValue>
        <name>Med set Phase to Lead/Dead - closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Med_set_Phase_to_Won_Closed</fullName>
        <field>StageName</field>
        <literalValue>Won - Closed</literalValue>
        <name>Med set Phase to Won - Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NDR_Third_Reminder</fullName>
        <field>Third_Reminder__c</field>
        <formula>IF( 
CASE( 
MOD( 
(Secondary_Reminder__c+5)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(Secondary_Reminder__c+5), 
IF( 
CASE( 
MOD( 
(Secondary_Reminder__c+6)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(Secondary_Reminder__c+6), 
IF( 
CASE( 
MOD( 
(Secondary_Reminder__c+7)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(Secondary_Reminder__c+7), 
IF( 
CASE( 
MOD( 
(Secondary_Reminder__c+8)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(Secondary_Reminder__c+8),NULL) 
) 
) 
)</formula>
        <name>NDR Third Reminder</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Approved</fullName>
        <field>StageName</field>
        <literalValue>Approved/Active</literalValue>
        <name>Opportunity Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Counter</fullName>
        <description>This field update counts the number field on opportunity, one up per day. Once the value 7 is reached, an email is sent out to the oppy owner</description>
        <field>Counter_for_Opportunity_reminder__c</field>
        <formula>Counter_for_Opportunity_reminder__c +1</formula>
        <name>Opportunity Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Rejected</fullName>
        <field>StageName</field>
        <literalValue>Rejected - Closed</literalValue>
        <name>Opportunity Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLM_Admin_Approval</fullName>
        <field>PLM_Approval__c</field>
        <literalValue>1</literalValue>
        <name>PLM Admin Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLM_Created_By_Id</fullName>
        <field>PLM_Created_By_Id__c</field>
        <formula>LEFT( TEXT( CTL__c ) , 8)</formula>
        <name>PLM Created By Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Project_Rejected</fullName>
        <description>Project status is changed to Rejected</description>
        <field>StageName</field>
        <literalValue>Rejected - Closed</literalValue>
        <name>Project Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_follow_up_date_update</fullName>
        <field>Quote_Follow_up_Date__c</field>
        <formula>now()</formula>
        <name>Quote follow up date update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_requested_date</fullName>
        <description>is set when the opportunity receives final approval</description>
        <field>Date_when_quote_requested__c</field>
        <formula>TODAY()</formula>
        <name>Quote requested date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Quote_required</fullName>
        <description>is set when the opportunity receives final approval</description>
        <field>Quote_attached__c</field>
        <literalValue>Quote required</literalValue>
        <name>Quote required</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Recall_Status_Update</fullName>
        <field>StageName</field>
        <literalValue>New</literalValue>
        <name>Recall Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Regional_Sales_Director_to_Flase</fullName>
        <field>Is_approved_Regional_Sales_Director__c</field>
        <literalValue>0</literalValue>
        <name>Regional Sales Director to Flase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Relay_AE_Start_Date</fullName>
        <description>This date field is automatically updated when the field Relay application support required equals true.</description>
        <field>Relay_AE_Start_Date__c</field>
        <formula>TODAY()</formula>
        <name>Relay AE Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_IND_Won_Date_G3</fullName>
        <field>Won_Date_G3_Reporting__c</field>
        <name>Remove IND Won Date G3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_IND_won_date</fullName>
        <description>this removes any entry in the IND won date fields in case an opportunity had been set to won previously, we don&apos;t want to keep the won date if the opportunity is then cancelled.</description>
        <field>Won_Date__c</field>
        <name>Remove IND won date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Relay_AE_Start_Date</fullName>
        <description>When the field Relay application support required equals false the field Relay AE Start Date is blanc.</description>
        <field>Relay_AE_Start_Date__c</field>
        <name>Remove Relay AE Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Approval_Step</fullName>
        <field>Approval_Step__c</field>
        <formula>0</formula>
        <name>Reset Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_CCAO_regional_approval_checkbox</fullName>
        <field>CCAO_Regional_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Reset CCAO regional approval checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_CTL_Approval</fullName>
        <field>CTL_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Reset CTL Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Criteria_is_Met</fullName>
        <field>Criteria_Meet__c</field>
        <literalValue>0</literalValue>
        <name>Reset Criteria is Met</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Opportunity_Counter</fullName>
        <description>This field is used to reset the opportunity counter to 0 when a reminder mail has been sent</description>
        <field>Counter_for_Opportunity_reminder__c</field>
        <formula>0</formula>
        <name>Reset Opportunity Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_PLM_Approval</fullName>
        <field>PLM_Approval__c</field>
        <literalValue>0</literalValue>
        <name>Reset PLM Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Quote_Status</fullName>
        <description>this field update resets the quote status</description>
        <field>Quote_attached__c</field>
        <name>Reset Quote Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_StageName</fullName>
        <field>StageName</field>
        <literalValue>Approved/Active</literalValue>
        <name>Reset StageName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Secondary_Reminder_Update</fullName>
        <field>Secondary_Reminder__c</field>
        <formula>IF( 
CASE( 
MOD( 
(Initial_Reminder__c+2)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(Initial_Reminder__c+2), 
IF( 
CASE( 
MOD( 
(Initial_Reminder__c+3)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(Initial_Reminder__c+3), 
IF( 
CASE( 
MOD( 
(Initial_Reminder__c+4)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(Initial_Reminder__c+4), 
IF( 
CASE( 
MOD( 
(Initial_Reminder__c+5)- DATE(1900, 1, 7), 
7), 
0, &apos;FALSE&apos;, 
1, &apos;TRUE&apos;, 
2, &apos;TRUE&apos;, 
3, &apos;TRUE&apos;, 
4, &apos;TRUE&apos;, 
5, &apos;TRUE&apos;, 
6, &apos;FALSE&apos;, 
&apos;FALSE&apos; 
)==&apos;TRUE&apos;,(Initial_Reminder__c+5),NULL) 
) 
) 
)</formula>
        <name>Secondary Reminder Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Send_To_PLM</fullName>
        <description>Send_to_PLM__c field update as true.</description>
        <field>Send_to_PLM__c</field>
        <literalValue>1</literalValue>
        <name>Send To PLM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Date</fullName>
        <description>sets the final approval date</description>
        <field>Final_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Status_to_Req</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approval Required</literalValue>
        <name>Set Approval Status to Req</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Asia_Pacific_Sales_Pct</fullName>
        <description>Set Asia/Pacific Sales % to 100 or 0 depending on value in Main Region of Consumption. New Mar 2014: Selection of &apos;Global&apos; gives A/P 20%</description>
        <field>Asia_Pacific__c</field>
        <formula>IF(OR(ISPICKVAL(Main_Region_of_consumption__c, &quot;Asia-Pacific&quot;), 
      ISPICKVAL(Main_Region_of_consumption__c, &quot;Japan&quot;), 
      ISPICKVAL(Main_Region_of_consumption__c, &quot;Taiwan&quot;), 
      ISPICKVAL(Main_Region_of_consumption__c, &quot;Korea&quot;)
      ), 
    1, 
    IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;Global&quot;), 0.2, 0)
  )</formula>
        <name>Set Asia Pacific Sales Pct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Australia_NZ_Sales_Pct</fullName>
        <description>Set Australia/New Zealand Sales % to 100 or 0 depending on value in Main Region of Consumption. New Mar 2014: selection of Global gives ANZ 15%</description>
        <field>Australia_NewZealand__c</field>
        <formula>IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;Australia/New Zealand&quot;), 
   1, 
   IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;Global&quot;), 0.15, 0)
   )</formula>
        <name>Set Australia NZ Sales Pct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_China_Sales_Pct</fullName>
        <description>Set China Sales % to 100 or 0 depending on value in Main Region of Consumption, New Mar 2014: selection of Global gives China 15%.</description>
        <field>China__c</field>
        <formula>IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;China&quot;), 
   1, 
   IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;Global&quot;), 0.15, 0)
   )</formula>
        <name>Set China Sales Pct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_EMEA_Pacific_Sales_Pct</fullName>
        <description>Set EMEA Sales % to 100 or 0 depending on value in Main Region of Consumption. New Mar 2014: selection of Global gives EMEA 15%</description>
        <field>EMEA__c</field>
        <formula>IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;EMEA&quot;), 
   1, 
   IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;Global&quot;), 0.15, 0)
   )</formula>
        <name>Set EMEA Pacific Sales Pct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_IND_Lost_Date</fullName>
        <description>sets the data when an opportunity is set to Lost or Dead</description>
        <field>IND_Lost_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set IND Lost Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_IND_Won_Date</fullName>
        <field>Won_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set IND Won Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Initial_submission_date</fullName>
        <description>sets first submission date</description>
        <field>Initial_Approval_Submission_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set Initial submission date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_MED_Win_Loss_Date</fullName>
        <description>Set MED Win Loss Date to current date/time</description>
        <field>MED_Quote_Approval_Date__c</field>
        <formula>Now()</formula>
        <name>Set MED Win/Loss Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Mass_prod_status_to_inactive</fullName>
        <description>Sets Mass-prod status to &quot;Inactive&quot; in case opportunity stage changes to &quot;Mass-prod&quot;.</description>
        <field>Mass_prod_Status__c</field>
        <literalValue>0</literalValue>
        <name>Set Mass-prod status to inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Med_Loss_Code</fullName>
        <field>MED_Loss_Code__c</field>
        <literalValue>15 - Go/No-Go date realized</literalValue>
        <name>Set Med Loss Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Med_Opp_Stat_to_Lost</fullName>
        <field>MED_Opp_Status__c</field>
        <literalValue>LS - Lost</literalValue>
        <name>Set Med Opp Stat to Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_North_America_Sales_Pct</fullName>
        <description>Set North America Sales % to 100 or 0 depending on value in Main Region of Consumption. New Mar 2014: selection of Global gives North America 20%</description>
        <field>North_America__c</field>
        <formula>IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;North America&quot;), 
   1, 
   IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;Global&quot;), 0.2, 0)
   )</formula>
        <name>Set North America Sales Pct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Due_date_5_days</fullName>
        <description>this sets the field quote due date to 5 days in the future (IND)</description>
        <field>Quote_Due_Date__c</field>
        <formula>CASE(MOD( TODAY() - DATE(1985,6,24),7),
5 , TODAY()+6,
6 , TODAY()+5,

TODAY()+7)</formula>
        <name>Set Quote Due date +5 days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_South_America_Sales_Pct</fullName>
        <description>Set South America Sales % to 100 or 0 depending on value in Main Region of Consumption. New Mar 2014: selection of Global gives South America 15%</description>
        <field>South_America__c</field>
        <formula>IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;South America&quot;), 
   1, 
   IF(ISPICKVAL(Main_Region_of_consumption__c, &quot;Global&quot;), 0.15, 0)
   )</formula>
        <name>Set South America Sales Pct</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Stage_Entry_Date</fullName>
        <description>stores the date when an opportunity has a stage change or was created</description>
        <field>Date_when_stage_entered__c</field>
        <formula>TODAY()</formula>
        <name>Set Stage Entry Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WF_Health_Check</fullName>
        <description>Used to set the overall health check status</description>
        <field>WF_Health_Check__c</field>
        <formula>IF(
	OR(
		ISPICKVAL(StageName, &apos;On Hold&apos;),
		ISPICKVAL(StageName, &apos;Production&apos;)
		),
	&apos;good&apos;,
		IF(
			OR(
				Number_of_Opportunity_Forecasts__c = 0,
				AND(
					RecordType.DeveloperName = &apos;IND_Engineering_project&apos;,
					OR(
						ISPICKVAL(Approval_Status_PMV__c, &apos;New&apos;),
						ISPICKVAL(Approval_Status_PMV__c, &apos;G0 In Approval&apos;),
						ISPICKVAL(Approval_Status_PMV__c, &apos;G0 Rejected&apos;)
						),
					OR(
						ISPICKVAL(StageName, &apos;Refining &amp; Resolving&apos;),
						ISPICKVAL(StageName, &apos;Contracting&apos;)
						)
					),
				AND(
					Five_Year_Revenue__c = 0,
					OR(
						ISPICKVAL(StageName, &apos;Refining &amp; Resolving&apos;),
						ISPICKVAL(StageName, &apos;Contracting&apos;)
						)					
					)
				),
		&apos;bad&apos;,
		IF(
			OR(
				AND(
					RecordType.DeveloperName = &apos;IND_Engineering_project&apos;,
					OR(
						ISPICKVAL(Approval_Status_PMV__c, &apos;New&apos;),
						ISPICKVAL(Approval_Status_PMV__c, &apos;G0 In Approval&apos;),
						ISPICKVAL(Approval_Status_PMV__c, &apos;G0 Rejected&apos;)
						),
					ISPICKVAL(StageName, &apos;Developing &amp; Differentiating&apos;)
					),
				AND(
					Five_Year_Revenue__c = 0,
					ISPICKVAL(StageName, &apos;Developing &amp; Differentiating&apos;)
					)
				),
			&apos;medium&apos;,
			&apos;good&apos;
			)
		)
)</formula>
        <name>Set WF Health Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_WF_Health_Check_Comment</fullName>
        <description>Sets the health check comment, based on the health check criteria for PMV.</description>
        <field>WF_Overall_Health_Check_Comment__c</field>
        <formula>IF(
Number_of_Opportunity_Forecasts__c = 0,
&apos;Please add a Forecast &apos;,
&apos;&apos;
)&amp;

If(
AND(
RecordType.DeveloperName = &apos;IND_Engineering_project&apos;,
OR(
ISPICKVAL(Approval_Status_PMV__c, &apos;New&apos;),
ISPICKVAL(Approval_Status_PMV__c, &apos;G0 In Approval&apos;),
ISPICKVAL(Approval_Status_PMV__c, &apos;G0 Rejected&apos;)
),
OR(
ISPICKVAL(StageName, &apos;Refining &amp; Resolving&apos;),
ISPICKVAL(StageName, &apos;Contracting&apos;),
ISPICKVAL(StageName, &apos;Developing &amp; Differentiating&apos;)
)
),
&apos;Engineering opportunity, G0 approval missing &apos;,
&apos;&apos;
)&amp;

IF(
AND(
Five_Year_Revenue__c = 0,
OR(
ISPICKVAL(StageName, &apos;Developing &amp; Differentiating&apos;),
ISPICKVAL(StageName, &apos;Refining &amp; Resolving&apos;),
ISPICKVAL(StageName, &apos;Contracting&apos;)
)
),
&apos;The Opportunity has no value. Please add parts and/or add Forecast&apos;,
&apos;&apos;
)</formula>
        <name>Set WF Health Check Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_G0_In_Approval</fullName>
        <description>this field is used in the IND opportunity approval process for SPIN record types</description>
        <field>Approval_Status_Spin__c</field>
        <literalValue>G0 In Approval</literalValue>
        <name>Set approval status G0 In Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_G0_approved</fullName>
        <description>used by the IND SPIN process</description>
        <field>Approval_Status_Spin__c</field>
        <literalValue>G0 Approved</literalValue>
        <name>Set approval status G0 approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_G0_rejected</fullName>
        <description>this field is used in the IND SPIN process</description>
        <field>Approval_Status_Spin__c</field>
        <literalValue>G0 Rejected</literalValue>
        <name>Set approval status G0 rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_PMV_G0_In_Approval</fullName>
        <field>Approval_Status_PMV__c</field>
        <literalValue>G0 In Approval</literalValue>
        <name>Set approval status PMV G0 In Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_PMV_G0_approved</fullName>
        <description>used by the IND PMV process</description>
        <field>Approval_Status_PMV__c</field>
        <literalValue>G0 Approved</literalValue>
        <name>Set approval status PMV G0 approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_PMV_G0_rejected</fullName>
        <description>this field is used in the IND PMV process</description>
        <field>Approval_Status_PMV__c</field>
        <literalValue>G0 Rejected</literalValue>
        <name>Set approval status PMV G0 rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_PMV_conv_approved</fullName>
        <description>used for IND PMV</description>
        <field>Approval_Status_PMV__c</field>
        <literalValue>Conversion Approved</literalValue>
        <name>Set approval status PMV conv approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_PMV_conv_in_approval</fullName>
        <description>used for IND PMV approval process</description>
        <field>Approval_Status_PMV__c</field>
        <literalValue>Conversion In Approval</literalValue>
        <name>Set approval status PMV conv in approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_PMV_to_New</fullName>
        <description>this field is used in the IND PMV process</description>
        <field>Approval_Status_PMV__c</field>
        <literalValue>New</literalValue>
        <name>Set approval status PMV to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_conv_approved</fullName>
        <description>used for IND SPIN</description>
        <field>Approval_Status_Spin__c</field>
        <literalValue>Conversion Approved</literalValue>
        <name>Set approval status conv approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_conv_in_approval</fullName>
        <description>used for IND SPIN approval process</description>
        <field>Approval_Status_Spin__c</field>
        <literalValue>Conversion In Approval</literalValue>
        <name>Set approval status conv in approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_approval_status_to_New</fullName>
        <description>this field is used in the IND SPIN process</description>
        <field>Approval_Status_Spin__c</field>
        <literalValue>New</literalValue>
        <name>Set approval status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_subsequent_submission_date</fullName>
        <description>sets subsequent submission dates in the approval process</description>
        <field>Last_Approval_Submission_Date__c</field>
        <formula>TODAY()</formula>
        <name>Set subsequent submission date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StageName_to_In_Approval</fullName>
        <description>Defines opportunity phase &quot;In Approval&quot;.</description>
        <field>StageName</field>
        <literalValue>In Approval</literalValue>
        <name>StageName to In Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_name_New</fullName>
        <description>This sets the stage name to &apos;New&apos; (Only for recalled opportunities)</description>
        <field>StageName</field>
        <literalValue>New</literalValue>
        <name>Stage name New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step1_Rejected</fullName>
        <field>Csd_PLM_Approval__c</field>
        <literalValue>Step 1 Rejected</literalValue>
        <name>Step1 Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_2_Rejected</fullName>
        <field>Csd_PLM_Approval__c</field>
        <literalValue>Step 2 Rejected</literalValue>
        <name>Step 2 Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Step_3_Rejected</fullName>
        <field>Csd_PLM_Approval__c</field>
        <literalValue>Step 3 Rejected</literalValue>
        <name>Step 3 Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submission_Counter</fullName>
        <description>counts the number of submissions into an approval process</description>
        <field>Approval_Submission_Counter__c</field>
        <formula>Approval_Submission_Counter__c +1</formula>
        <name>Submission Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UnCheck_Customer_Pays_Tooling_Contribut</fullName>
        <field>Customer_Pays_Tooling_Contribution__c</field>
        <literalValue>0</literalValue>
        <name>UnCheck Customer Pays Tooling Contribut</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unique_Opportunity</fullName>
        <field>TOPS_ID__c</field>
        <formula>IF(
AND( 
$Profile.Name &lt;&gt; &quot;Service Account&quot;, 
$Profile.Name &lt;&gt; &quot;Systemadministrator&quot;, 
$Profile.Name &lt;&gt; &quot;System Administrator&quot;), Account.AccountNumber &amp; &quot;|&quot; &amp; Name, &quot;&quot;)</formula>
        <name>Unique Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Unset_Med_Win_Loss_Date</fullName>
        <description>Set Med Win Loss Date to null</description>
        <field>MED_Quote_Approval_Date__c</field>
        <name>Unset Med Win Loss Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Step</fullName>
        <field>Approval_Step__c</field>
        <formula>IF(Approval_Step__c==null, 1,  Approval_Step__c  + 1)</formula>
        <name>Update Approval Step</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_date</fullName>
        <description>Update Closed date with today&apos;s Date</description>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>Update Closed date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Connection_Record_Type</fullName>
        <field>Connection_Record_Type__c</field>
        <formula>&quot;BU Opportunity&quot;</formula>
        <name>Update Connection Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Key_Customer_Code</fullName>
        <field>Key_Customer_Cde__c</field>
        <formula>Account.Key_Customer_Cde__c</formula>
        <name>Update Opportunity Key Customer Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Oppy_Last_Modified</fullName>
        <description>Updates the Opportunity custom Last Modified Date.</description>
        <field>Last_Modified_Date__c</field>
        <formula>Now()</formula>
        <name>Update Oppy Last Modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Phase_to_Lost_Dead_closed</fullName>
        <field>StageName</field>
        <literalValue>Dead - Closed</literalValue>
        <name>Update Phase to Lost/Dead - closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Quote_Attached_Date</fullName>
        <field>Quote_attached_date__c</field>
        <formula>TODAY()</formula>
        <name>Update Quote Attached Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rule_Fired_checkbox</fullName>
        <field>Quote_attached_rule_triggered__c</field>
        <literalValue>1</literalValue>
        <name>Update &apos;Rule Fired&apos; checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Rule_Fired_checkbox_false</fullName>
        <field>Quote_attached_rule_triggered__c</field>
        <literalValue>0</literalValue>
        <name>Update &apos;Rule Fired&apos; checkbox false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>csdvalidationstampnow</fullName>
        <description>get the now timestamp of changes</description>
        <field>alert_validation_time__c</field>
        <formula>IF( (ISCHANGED(Amount) || ISCHANGED(Two_Years_Revenue__c)),NOW(),NULL)</formula>
        <name>csdvalidationstampnow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>field_updat</fullName>
        <field>LeadSource</field>
        <name>field updat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>PreviousValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_approval_status_PMV_conv_rejected</fullName>
        <description>for IND PMV</description>
        <field>Approval_Status_PMV__c</field>
        <literalValue>Conversion Rejected</literalValue>
        <name>set approval status PMV conv rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>set_approval_status_conv_rejected</fullName>
        <description>for IND SPIN</description>
        <field>Approval_Status_Spin__c</field>
        <literalValue>Conversion Rejected</literalValue>
        <name>set approval status conv rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>test</fullName>
        <field>Amount</field>
        <name>test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updateIsFromCode</fullName>
        <description>set the default value false to isFromCode field</description>
        <field>isFromCode__c</field>
        <literalValue>0</literalValue>
        <name>updateIsFromCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_CCAO_regional_approval_checkbox</fullName>
        <field>CCAO_Regional_Approval__c</field>
        <literalValue>1</literalValue>
        <name>update CCAO regional approval checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <flowActions>
        <fullName>CCAO_Chatter_Note</fullName>
        <flow>CCAO_Chatter_Message</flow>
        <flowInputs>
            <name>varOppID</name>
            <value>{!Id}</value>
        </flowInputs>
        <label>CCAO Chatter Note</label>
        <language>en_US</language>
        <protected>false</protected>
    </flowActions>
    <outboundMessages>
        <fullName>My_Message</fullName>
        <apiVersion>24.0</apiVersion>
        <description>My message for my orch</description>
        <endpointUrl>https://www.testme.com/?CIOrch=Orchname</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>chris.roberts@te.com.c2s</integrationUser>
        <name>My Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Testmessage</fullName>
        <apiVersion>24.0</apiVersion>
        <description>for testing</description>
        <endpointUrl>http://https//sfdcinmound.te.com/castiron/message/?endpoint=testmessage</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>chris.roberts@te.com.c2s</integrationUser>
        <name>Testmessage</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>50 days no update - IND record types</fullName>
        <active>true</active>
        <description>This WF rule will be triggered if an opportunity was not updated for 50 days. Applies to the IND record types and Product Platforms for Industrial.</description>
        <formula>AND(
OR(ISPICKVAL(StageName,&apos;Initiating&apos;),ISPICKVAL(StageName,&apos;Exploring Needs&apos;),ISPICKVAL(StageName,&apos;Developing &amp; Differentiating&apos;),ISPICKVAL(StageName,&apos;Refining &amp; Resolving&apos;),ISPICKVAL(StageName,&apos;Contracting&apos;)),
OR(Record_Type_Name__c = &apos;IND_Engineering_project&apos; , Record_Type_Name__c = &apos;IND_Sales_Project&apos;),
Industry_Code__c &lt;&gt; &apos;Appliances&apos;,
$Setup.Admin_Profile_Exception__c.Run_Rule__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Ten_days_notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>50</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>50 days no update notification</fullName>
        <active>true</active>
        <description>This WF rule will be triggered if an opportunity was not updated for 50 days</description>
        <formula>AND ( 	OR 	( ISPICKVAL(StageName,&apos;Open&apos;), 		ISPICKVAL(StageName,&apos;Concept&apos;), 		ISPICKVAL(StageName,&apos;Sampling&apos;), 		ISPICKVAL(StageName,&apos;Quotation&apos;), 		ISPICKVAL(StageName,&apos;Commit&apos;), 		ISPICKVAL(StageName,&apos;Won - Open&apos;), 		ISPICKVAL(StageName,&apos;New&apos;), 		ISPICKVAL(StageName,&apos;In Approval&apos;), 		ISPICKVAL(StageName,&apos;Approved/Active&apos;)  	), 	Industry_Code__c &lt;&gt; &apos;Appliances&apos; , 	Record_Type_Name__c &lt;&gt; &apos;TAM&apos; , 	Record_Type_Name__c &lt;&gt; &apos;NDR_Opportunity&apos;, 	NOT(ISPICKVAL(Owner.GIBU__c,&apos;Medical&apos;)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Ten_days_notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>50</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>50 days no update notification_APL</fullName>
        <active>true</active>
        <formula>AND(  OR(  ISPICKVAL(StageName,&apos;Won - Open&apos;),  ISPICKVAL(StageName,&apos;New&apos;),  ISPICKVAL(StageName,&apos;In Approval&apos;),  ISPICKVAL(StageName,&apos;Approved/Active&apos;)  ),  OR(   RecordTypeId = &apos;012E0000000XrBX&apos;,  RecordTypeId = &apos;012E0000000XrBY&apos;   ),   ISPICKVAL(Owner.GIBU__c , &apos;Appliances&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>50</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>80 days no update notification - NDR Opportunity</fullName>
        <active>true</active>
        <description>This WF rule will be triggered if an opportunity was not updated for 80 days</description>
        <formula>AND ( 	OR 	( ISPICKVAL(StageName,&apos;Open&apos;), 		ISPICKVAL(StageName,&apos;Concept&apos;), 		ISPICKVAL(StageName,&apos;Sampling&apos;), 		ISPICKVAL(StageName,&apos;Quotation&apos;), 		ISPICKVAL(StageName,&apos;Commit&apos;), 		ISPICKVAL(StageName,&apos;Won - Open&apos;), 		ISPICKVAL(StageName,&apos;New&apos;), 		ISPICKVAL(StageName,&apos;In Approval&apos;), 		ISPICKVAL(StageName,&apos;Approved/Active&apos;)  	), 	 	OR 	(Record_Type_Name__c = &apos;NDR_Opportunity&apos;, Record_Type_Name__c = &apos;CCR_Opportunity&apos;), 	NDR_Quote_Status_Description__c = &apos;Complete&apos; 	)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Overdue_80_Days_Notification_NDR_Opportunity</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>80</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>AMR - Opportunity Closed Date</fullName>
        <actions>
            <name>AMR_Opportunity_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(DATEVALUE(LastModifiedDate) = TODAY() &amp;&amp;  ISCHANGED(CloseDate), OR( Record_Type__c =&quot;Energy Sales&quot;, Record_Type__c =&quot;Energy Tender&quot;, AND( Record_Type__c=&quot;Opportunity - Product Platform&quot; ,  ISPICKVAL( Business_Unit__c , &quot;Energy&quot;) ) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APL transfer in project</fullName>
        <actions>
            <name>Appliances_Opportunity_transfer_in_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 4 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Account.Customer_Region__c</field>
            <operation>notEqual</operation>
            <value>China / HK / Taiwan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.APL_Billing_Region_1__c</field>
            <operation>equals</operation>
            <value>China / HK / Taiwan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.APL_Billing_Region_2__c</field>
            <operation>equals</operation>
            <value>China / HK / Taiwan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Customer_Industry__c</field>
            <operation>equals</operation>
            <value>Appliances</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Blanket Breakout</fullName>
        <actions>
            <name>Breakout_Blanket_Tender</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Record_Type__c</field>
            <operation>equals</operation>
            <value>Energy Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Annual_Blanket__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <description>once the master blanket/tender has been awarded, it needs to be loaded as monthly opportunities</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CCAO Chatter Message</fullName>
        <actions>
            <name>CCAO_Chatter_Note</name>
            <type>FlowAction</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Request_Type__c</field>
            <operation>equals</operation>
            <value>Cable Assembly - New Dev,Cable Assembly - Extension</value>
        </criteriaItems>
        <description>This workflow triggers a Chatter message creation when a cable assembly opportunity is created. The Chatter message is in the opportunity feed and will point to a document stored in a library.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CCR Escalation BU AMER</fullName>
        <active>true</active>
        <description>This WF is used to notify BU Admins of no action takes places on CCR Opportunity after three days from the day from creation</description>
        <formula>AND(   Record_Type_Name__c = &apos;CCR_Opportunity&apos;, NDR_Is_Signal_Received__c = TRUE, ISBLANK(NDR_Initiate_SFDC_SAP_Integration__c), ISPICKVAL(Region_Sales__c,&apos;Americas&apos;), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CCR_Email_to_AMER_BU_Admin_to_inform_no_action_on_CCR_part_after_5_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CCR_Email_to_AMER_BU_Admin_to_inform_no_action_on_CCR_part_after_10_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CCR Escalation BU AP</fullName>
        <active>true</active>
        <description>This WF is used to notify BU Admins of no action takes places on CCR Opportunity after three days from the day from creation</description>
        <formula>AND( Record_Type_Name__c = &apos;CCR_Opportunity&apos;, NDR_Is_Signal_Received__c = TRUE, ISBLANK(NDR_Initiate_SFDC_SAP_Integration__c), ISPICKVAL(Region_Sales__c,&apos;Asia Pacific&apos;), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CCR_Email_to_AP_BU_Admin_to_inform_no_action_on_CCR_part_after_5_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CCR_Email_to_AP_BU_Admin_to_inform_no_action_on_CCR_part_after_10_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CCR Escalation BU EMEA</fullName>
        <active>true</active>
        <description>This WF is used to notify BU Admins of no action takes places on CCR Opportunity after three days from the day from creation</description>
        <formula>AND( Record_Type_Name__c = &apos;CCR_Opportunity&apos;, NDR_Is_Signal_Received__c = TRUE, ISBLANK(NDR_Initiate_SFDC_SAP_Integration__c), ISPICKVAL(Region_Sales__c,&apos;EMEA&apos;), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CCR_Email_to_EMEA_BU_Admin_to_inform_no_action_on_CCR_part_after_5_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>CCR_Email_to_EMEA_BU_Admin_to_inform_no_action_on_CCR_part_after_10_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CSD Check Customer Pays Tooling Contribution</fullName>
        <actions>
            <name>Check_Customer_Pays_Tooling_Contributio</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Max_Customer_Tool_Price__c</field>
            <operation>greaterThan</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering_Opportunity_CSD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>DND_Opportunity</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSD Opportunity PM Action</fullName>
        <actions>
            <name>CSD_Opportunity_PM_Action_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.PM_Weekly_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Global_Product_Manager__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PM_Action__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>CSD Opportunity PM Action Notification</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSD PLM approval status</fullName>
        <actions>
            <name>CSD_PLM_approval_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Csd_PLM_Approval__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This is to set the status null when the record is cloned</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CSD Reset PM Weekly Update to False</fullName>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering_Opportunity_CSD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Sales_Opportunity_CSD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PM_Weekly_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CSD_Reset_PM_Weekly_Update_to_False</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CSD Reset PM Weekly Update to False 30 Days</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 4) AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering_Opportunity_CSD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Sales_Opportunity_CSD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.PM_Weekly_Update__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>DND_Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>CSD_Reset_PM_Weekly_Update_to_False</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>CSD Update FAE Name</fullName>
        <actions>
            <name>CSD_Update_FAE_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>OR(AND($Profile.Name = &quot;DND FAE User&quot;, ISNEW(),         OR(RecordType.Name = &apos;Engineering Opportunity-CSD&apos;,             RecordType.Name = &apos;Sales Opportunity-CSD&apos;,RecordType.Name = &apos;DND_Opportunity&apos;),OR( LEN(FAE_Comments__c)&gt;0,FAE_Weekly_update__c = TRUE,         NOT(ISNULL(FAE_Weekly_update_Date__c)))),     AND($Profile.Name = &quot;DND FAE User&quot;,NOT(ISNEW()),         OR(RecordType.Name = &apos;Engineering Opportunity-CSD&apos;,           RecordType.Name = &apos;Sales Opportunity-CSD&apos;,RecordType.Name = &apos;DND_Opportunity&apos;),OR( ISCHANGED(FAE_Comments__c),                ISCHANGED(FAE_Weekly_update__c),              ISCHANGED(FAE_Weekly_update_Date__c))) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSD alerts</fullName>
        <actions>
            <name>CSD_Explanation_alerts</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>csdvalidationstampnow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(Amount),ISCHANGED(Two_Years_Revenue__c), ISCHANGED(Explanation_of_Change__c),ISCHANGED(User_Updated_Date__c),ISCHANGED(Csd_PLM_Approval__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSD unCheck Customer Pays Tooling Contribution</fullName>
        <actions>
            <name>UnCheck_Customer_Pays_Tooling_Contribut</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Max_Customer_Tool_Price__c</field>
            <operation>lessOrEqual</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering_Opportunity_CSD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>DND_Opportunity</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDECRequestTypeafterStep1approval</fullName>
        <actions>
            <name>CSDECRequestTypeafterStep1approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Request_Type__c</field>
            <operation>equals</operation>
            <value>Engineering Change</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Csd_PLM_Approval__c</field>
            <operation>equals</operation>
            <value>Step 1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering Opportunity-CSD</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CSDECRequestTypeafterStep3approval</fullName>
        <actions>
            <name>CSDECRequestTypeafterStep3Approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Request_Type__c</field>
            <operation>equals</operation>
            <value>Engineering Change</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Csd_PLM_Approval__c</field>
            <operation>equals</operation>
            <value>Step 3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering Opportunity-CSD</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDECRequestTypeafterStep3reject</fullName>
        <actions>
            <name>CSDECRequestTypeafterStep3Reject</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Csd_PLM_Approval__c</field>
            <operation>equals</operation>
            <value>Step 3 Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Request_Type__c</field>
            <operation>equals</operation>
            <value>Engineering Change</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering Opportunity-CSD</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDNonECRequestTypeafterStep1approval</fullName>
        <actions>
            <name>CSDNonECRequestTypeafterStep1approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND( Record_Type_Name__c = &apos;Engineering_Opportunity_CSD&apos;, PLM_Project_Complexity__c  &lt;&gt;  &apos;Type 0&apos; , ISCHANGED(Csd_PLM_Approval__c), TEXT(Csd_PLM_Approval__c) = &apos;Step 1&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDNonECRequestTypeafterStep3Reject</fullName>
        <actions>
            <name>CSDNonECRequestTypeafterStep3Reject</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Csd_PLM_Approval__c</field>
            <operation>equals</operation>
            <value>Step 3 Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Request_Type__c</field>
            <operation>equals</operation>
            <value>New Development,Extension,Market Share Gain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering Opportunity-CSD</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDNonECRequestTypeafterStep3approval</fullName>
        <actions>
            <name>Final_Approved</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Request_Type__c</field>
            <operation>equals</operation>
            <value>New Development,Extension,Market Share Gain</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Csd_PLM_Approval__c</field>
            <operation>equals</operation>
            <value>Step 3</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Engineering Opportunity-CSD</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDPLMComplexityType0</fullName>
        <actions>
            <name>CSDPLMComplexityType0forEGM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SalesEmailNotofication</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND( Record_Type_Name__c = &apos;Engineering_Opportunity_CSD&apos;, PLM_Project_Complexity__c = &apos;Type 0&apos; , ISCHANGED(Csd_PLM_Approval__c), TEXT(Csd_PLM_Approval__c) = &apos;Step 1&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDPLMComplexityType12</fullName>
        <actions>
            <name>CSDPLMComplexityType12forEGM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( Record_Type_Name__c = &apos;Engineering_Opportunity_CSD&apos;,  ISCHANGED(Csd_PLM_Approval__c), TEXT(Csd_PLM_Approval__c) = &apos;Step 1&apos;,  Global_Product_Manager__c =  Product_General_Manager__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDPLMComplexityType12PGMApprved</fullName>
        <actions>
            <name>CSDPLMComplexityType12forEGM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( Record_Type_Name__c = &apos;Engineering_Opportunity_CSD&apos;,  ISCHANGED(Csd_PLM_Approval__c), TEXT(Csd_PLM_Approval__c) = &apos;Step 2&apos;, Global_Product_Manager__c &lt;&gt; Product_General_Manager__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDPLMIdcreatedbyEGM</fullName>
        <actions>
            <name>PLM_Created_By_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Send_To_PLM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( Record_Type_Name__c = &apos;Engineering_Opportunity_CSD&apos;, OR( TEXT(Csd_PLM_Approval__c) = &apos;Step 2&apos;,TEXT(Csd_PLM_Approval__c) = &apos;Step 1&apos; ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CSDPLMIdgenerateEmailnotification</fullName>
        <actions>
            <name>PLMIDgeneratednotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( Record_Type_Name__c = &apos;Engineering_Opportunity_CSD&apos;,  ISCHANGED( PLM_Id__c ),  PLM_Id__c  &lt;&gt; null )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Close Date Override</fullName>
        <actions>
            <name>Close_Date_Override</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Won,Lost</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type__c</field>
            <operation>equals</operation>
            <value>Energy Sales,Energy Tender</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>Energy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.User_Region__c</field>
            <operation>equals</operation>
            <value>AMERICAS</value>
        </criteriaItems>
        <description>change the close date to today&apos;s date when opportunities are labeled close won.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Currency Changed Notification</fullName>
        <actions>
            <name>Currency_Changed_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>This wf rule sends out an email to a user to inform him, that he has changed the Oppy currency and because of that, the forecast has to be opened and saved to recalculate.</description>
        <formula>ISCHANGED(CurrencyIsoCode)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EMEA - Opps close date passed</fullName>
        <actions>
            <name>Close_date_to_be_updated</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>Energy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_RSD_Region__c</field>
            <operation>equals</operation>
            <value>CIS/RUSSIA,FRANCE,GERMANY,INDIA,MEA,NORDIC,SWITZERLAND,&quot;UK, SPAIN &amp; BENELUX&quot;,UK/MEA DSS,WEST EUROPE,EAST EUROPE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Status__c</field>
            <operation>equals</operation>
            <value>ACTIVE</value>
        </criteriaItems>
        <description>When close date is before today AND Status is Active AND RSD Region is CIS/RUSSIA,FRANCE,GERMANY,INDIA,MEA,NORDIC,SWITZERLAND,&quot;UK, SPAIN &amp; BENELUX&quot;,UK/MEA DSS,WEST EUROPE,EAST EUROPE… assign a task to Opportunity Owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Alert for CCROppPart Approval</fullName>
        <actions>
            <name>Email_Alert_for_CCROppPart_Approval_day1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This WF is used to notify DMM about the new CCR Opportunity awaiting their approval</description>
        <formula>AND( Record_Type_Name__c = &apos;CCR_Opportunity&apos;, NDR_Is_Signal_Received__c = TRUE, ISBLANK(NDR_Initiate_SFDC_SAP_Integration__c),
OR($Setup.Admin_Profile_Exception__c.Run_Rule__c, $User.Username = &apos;teis.admin@te.com.cis&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_for_CCROppPart_Approval_day7</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_for_NDROppPart_Approval_day14</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_for_CCROppPart_Approval_day19</name>
                <type>Alert</type>
            </actions>
            <timeLength>19</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email Alert for NDROppPart Approval</fullName>
        <actions>
            <name>Email_Alert_for_NDROppPart_Approval_day1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This WF is used to notify DMM about the new NDR Opportunity awaiting their approval</description>
        <formula>AND( Record_Type_Name__c = &apos;NDR_Opportunity&apos;, NDR_Is_Signal_Received__c = TRUE, ISBLANK(NDR_Initiate_SFDC_SAP_Integration__c), 
OR($Setup.Admin_Profile_Exception__c.Run_Rule__c, $User.Username = &apos;teis.admin@te.com.cis&apos;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_for_NDROppPart_Approval_day7</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_for_NDROppPart_Approval_day14</name>
                <type>Alert</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_for_NDROppPart_Approval_day19</name>
                <type>Alert</type>
            </actions>
            <timeLength>19</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email Alter EMEA Opps</fullName>
        <actions>
            <name>Email_Notification_on_the_New_Opportunity</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Energy_Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Region__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <description>When Record Type is Project (EMEA) and User Region is EMEA send an email alert to Ann Taylor, Hombeline Mopty, Related User: Product Manager, Related User: RSM Manager</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Get OEM Name</fullName>
        <actions>
            <name>Get_OEM_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Record_Type_Name__c  = &apos;DND_Opportunity&apos;,OR(ISCHANGED( OEM_Name__c ) , OEM_Name__c  &lt;&gt; NULL))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MED 50 Days No Update Notification</fullName>
        <active>true</active>
        <description>This rule will be triggered for Medical opportunities if an open opportunity (P0, P3, or QR status) has not been updated in the last 50 days.</description>
        <formula>AND(  OR(  ISPICKVAL(MED_Opp_Status__c,&apos;P0 - Pre-Opportunity&apos;),  ISPICKVAL(MED_Opp_Status__c,&apos;P3 - In Quoting Opportunity&apos;),  ISPICKVAL(MED_Opp_Status__c,&apos;QR - Quote Released&apos;)  )  ,  ISPICKVAL(Owner.GIBU__c,&apos;Medical&apos;)  ,  $Setup.Admin_Profile_Exception__c.Run_Rule__c  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Med_Alert_Opp_Not_Upd_in_50Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>50</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MED Go No Go Alert%2C Upd%2C Task</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.MED_Go_No_Go_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>equals</operation>
            <value>P0 - Pre-Opportunity,P3 - In Quoting Opportunity,QR - Quote Released,PG - Win-Pending KO,HL - Hold</value>
        </criteriaItems>
        <description>If MED Go No Go Date is reached or almost reached and opp has not been won, take action.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Med_Notify_Opp_Owner_7_Days_before_Go_No_Go</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Go_No_Go_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Med_Loss_Code</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Set_Med_Opp_Stat_to_Lost</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Follow_Up_Lost_Opp</name>
                <type>Task</type>
            </actions>
            <actions>
                <name>Update_Med_Loss_Code</name>
                <type>Task</type>
            </actions>
            <offsetFromField>Opportunity.MED_Go_No_Go_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>MED Set Med Conf to 100 based on Med Stat</fullName>
        <actions>
            <name>MED_Set_Med_Conf</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set Med Opp Confidence to 100 when Med Opp Status is Won, Active, or Complete. For Med profiles only.</description>
        <formula>AND(   OR( ISPICKVAL(MED_Opp_Status__c, &quot;WN - Win&quot;)  ,      ISPICKVAL(MED_Opp_Status__c, &quot;AC - Active Project&quot;),        ISPICKVAL(MED_Opp_Status__c, &quot;CM - Complete&quot;)      ) ,  OR(  $Profile.Name  = &quot;Medical Standard User&quot;,       $Profile.Name  = &quot;Medical User w/Cost&quot;     ) ,  NOT(ISPICKVAL(MED_Opp_Confidence__c,&quot;100&quot;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MED Unset MED Win%2FLoss Date</fullName>
        <actions>
            <name>Unset_Med_Win_Loss_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.MED_Quote_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>equals</operation>
            <value>P0 - Pre-Opportunity,P3 - In Quoting Opportunity,QR - Quote Released</value>
        </criteriaItems>
        <description>If MED Win/Loss Date is set but the Med Opp Status is P0, P3, or QR, then clear out the date. This indicates that the project has slid backwards.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>MED set MED Win%2FLoss Date</fullName>
        <actions>
            <name>Set_MED_Win_Loss_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>equals</operation>
            <value>AC - Active Project,CN - Lost (Canceled),LS - Lost,CM - Complete</value>
        </criteriaItems>
        <description>If the MED Opp Status is set to &quot;WN - Win&quot;, &quot;AC - Active Project&quot;, &quot;LS - Lost&quot;, or &quot;CN - Lost (Canceled)&quot;, set the MED Win/Loss Date to the current date/time. Reflects the date we know we either will or will not proceed with the project.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Med Eng Opp Closed Back to Open</fullName>
        <actions>
            <name>Med_Set_Stage_to_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Opportunity_Engineering_Project</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>Lost/Dead - closed,Rejected - Closed,Won - Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>contains</operation>
            <value>P0 - Pre-Opportunity,P3 - In Quoting Opportunity,QR - Quote Released,PG - Win-Pending KO,WN - Win,AC - Active Project,HL - Hold</value>
        </criteriaItems>
        <description>If user changes Med Opp Status from a closed status back to an open one, change Phase back to New</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Med Opp Stat CM updates Phase</fullName>
        <actions>
            <name>Med_set_Phase_to_Won_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>equals</operation>
            <value>CM - Complete</value>
        </criteriaItems>
        <description>When Med Opp Status reaches positive end of life status, change Phase (StageName) to be in sync.
CM - Complete ==&gt; Won - Closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Med Opp Stat LS CN updates Phase</fullName>
        <actions>
            <name>Med_set_Phase_to_Lead_Dead_closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>equals</operation>
            <value>CN - Lost (Canceled),LS - Lost</value>
        </criteriaItems>
        <description>When Med Opp Status reaches negative end of life status, change Phase (StageName) to be in sync.
LS - Lost ==&gt; Lost/Dead - closed
CN - Lost (Canceled) ==&gt;  Lost/Dead - closed</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Med Opp Stat QR Alerts Acct Owner</fullName>
        <active>false</active>
        <description>If opp sits at QR status for 60, 90, 120, 150 days (based on Med Quote Released Date) send email alerts to account owner, if they belong to Medical GIBU</description>
        <formula>AND(ISPICKVAL(MED_Opp_Status__c , &quot;QR - Quote Released&quot;),  ISPICKVAL(Account.Owner.GIBU__c , &quot;Medical&quot;) ,$Setup.Admin_Profile_Exception__c.Run_Rule__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Med_Notify_Account_Owner_60</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Quote_Released_Date__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Med_Notify_Account_Owner_120</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Quote_Released_Date__c</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Med_Notify_Account_Owner_90</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Quote_Released_Date__c</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Med_Notify_Account_Owner_150</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Quote_Released_Date__c</offsetFromField>
            <timeLength>150</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Med Opp Stat QR Alerts Opp People</fullName>
        <active>false</active>
        <description>If opp sits at QR status for 60, 90, 120, 150 days (based on Med Quote Released Date) send email alerts to opp owner, if they are not the same person as the account owner. (Account owner will get notified via separate workflow)</description>
        <formula>AND(ISPICKVAL(MED_Opp_Status__c , &quot;QR - Quote Released&quot;),(OwnerId &lt;&gt; Account.OwnerId) , $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Med_Notify_Opp_Owner_60</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Quote_Released_Date__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>MED_Notify_Opp_Owner_150</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Quote_Released_Date__c</offsetFromField>
            <timeLength>150</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>MED_Notify_Opp_Owner_120</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Quote_Released_Date__c</offsetFromField>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>MED_Notify_Opp_Owner_90</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.MED_Quote_Released_Date__c</offsetFromField>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Med Opp Stat Upd Quote Rel Dt</fullName>
        <actions>
            <name>MED_set_Med_Quote_Released_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>equals</operation>
            <value>QR - Quote Released,PG - Win-Pending KO,WN - Win,AC - Active Project,HL - Hold,CM - Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MED_Quote_Released_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>As soon as Med Opp Status changes to QR or beyond, populate MED Quote Released Date with today&apos;s date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Med Probability and Confidence</fullName>
        <actions>
            <name>MED_Update_Probability</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the standard Probability when the MED Opp Confidence is updated.  Only update if the probability is lagging behind the MED Opp Confidence.</description>
        <formula>ISCHANGED( MED_Opp_Confidence__c ) &amp;&amp;  (Probability * 100) &lt;  VALUE(TEXT(MED_Opp_Confidence__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Med Sales Opp Closed Back to Open</fullName>
        <actions>
            <name>Med_Set_Stage_to_Approved_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Opportunity_Sales_Parts_Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>contains</operation>
            <value>Lost/Dead - closed,Rejected - Closed,Won - Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>contains</operation>
            <value>P0 - Pre-Opportunity,P3 - In Quoting Opportunity,QR - Quote Released,PG - Win-Pending KO,WN - Win,AC - Active Project,HL - Hold</value>
        </criteriaItems>
        <description>For a Med Sales Opp, set the Stage back to Approved/Active if the Med Opp Status goes from a closed stage to an open one.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Med Unset Quote Rel Dt</fullName>
        <actions>
            <name>Clear_Med_Quote_Released_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.MED_Opp_Status__c</field>
            <operation>equals</operation>
            <value>P0 - Pre-Opportunity,P3 - In Quoting Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.MED_Quote_Released_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If Med Opp Status is set back to P0 or P3 and Quote Rel Dt is filled in, blank it out.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mismatch Opp Phase and Project Status</fullName>
        <actions>
            <name>Opportunity_phase_and_TE_project_mismatch</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(
OR(
Owner.Profile.Name = &apos;Industrial User w/ Cost&apos;,
Owner.Profile.Name = &apos;Industrial Standard User&apos;,
Owner.Profile.Name = &apos;Industrial Engineering User w/Cost&apos;,
Owner.Profile.Name = &apos;Channel Standard User&apos;
),
OR(
RecordType.DeveloperName = &quot;Channel_Engineering_Opportunity&quot;,
RecordType.DeveloperName = &quot;IND_Engineering_project&quot;,
RecordType.DeveloperName = &quot;Opportunity_Product_Platform&quot;,
RecordType.DeveloperName = &quot;Opportunity_Engineering_Project&quot;
),
PLM_Id__c &lt;&gt;&quot;&quot;,
OR(
AND(
NOT(ISPICKVAL(StageName ,&quot;Lost/Dead - closed&quot;)),
NOT(ISPICKVAL(StageName ,&quot;Rejected - Closed&quot;)),
NOT(ISPICKVAL(StageName ,&quot;Lost - Closed&quot;)),
NOT(ISPICKVAL(StageName ,&quot;Dead - Closed&quot;)),
NOT(ISPICKVAL(StageName ,&quot;Dead&quot;)),
NOT(ISPICKVAL(StageName ,&quot;Lost&quot;)),
Project_Status_Level__c = &apos;CANCELLED (3)&apos;
),
AND(
OR(
ISPICKVAL(StageName ,&quot;Lost/Dead - closed&quot;),
ISPICKVAL(StageName ,&quot;Rejected - Closed&quot;),
ISPICKVAL(StageName ,&quot;Lost - Closed&quot;),
ISPICKVAL(StageName ,&quot;Dead - Closed&quot;),
ISPICKVAL(StageName ,&quot;Dead&quot;),
ISPICKVAL(StageName ,&quot;Lost&quot;)
),
Project_Status_Level__c &lt;&gt; &apos;CANCELLED (3)&apos;
)
)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NDR Escalation BU AMER</fullName>
        <active>true</active>
        <description>This WF is used to notify BU Admins of no action takes places on NDR Opportunity after three days from the day from creation</description>
        <formula>AND(   Record_Type_Name__c = &apos;NDR_Opportunity&apos;, NDR_Is_Signal_Received__c = TRUE, ISBLANK(NDR_Initiate_SFDC_SAP_Integration__c), ISPICKVAL(Region_Sales__c,&apos;Americas&apos;), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NDR_Email_to_AMER_BU_Admin_to_inform_no_action_on_NDR_part_after_5_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>NDR_Email_to_AMER_BU_Admin_to_inform_no_action_on_NDR_part_after_10_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NDR Escalation BU AP</fullName>
        <active>true</active>
        <description>This WF is used to notify BU Admins of no action takes places on NDR Opportunity after three days from the day from creation</description>
        <formula>AND( Record_Type_Name__c = &apos;NDR_Opportunity&apos;, NDR_Is_Signal_Received__c = TRUE, ISBLANK(NDR_Initiate_SFDC_SAP_Integration__c), ISPICKVAL(Region_Sales__c,&apos;Asia Pacific&apos;), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NDR_Email_to_AP_BU_Admin_to_inform_no_action_on_NDR_part_after_5_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>NDR_Email_to_AP_BU_Admin_to_inform_no_action_on_NDR_part_after_10_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NDR Escalation BU EMEA</fullName>
        <active>true</active>
        <description>This WF is used to notify BU Admins of no action takes places on NDR Opportunity after three days from the day from creation</description>
        <formula>AND( Record_Type_Name__c = &apos;NDR_Opportunity&apos;, NDR_Is_Signal_Received__c = TRUE, ISBLANK(NDR_Initiate_SFDC_SAP_Integration__c), ISPICKVAL(Region_Sales__c,&apos;EMEA&apos;), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NDR_Email_to_EMEA_BU_Admin_to_inform_no_action_on_NDR_part_after_5_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>NDR_Email_to_EMEA_BU_Admin_to_inform_no_action_on_NDR_part_after_10_day</name>
                <type>Alert</type>
            </actions>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>NDR Opportunity Reminder</fullName>
        <actions>
            <name>Initial_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Initial_Reminder_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NDR_Third_Reminder</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Secondary_Reminder_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) OR (1 AND 3) OR (1 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>NDR_Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Region_Sales__c</field>
            <operation>equals</operation>
            <value>Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Region_Sales__c</field>
            <operation>equals</operation>
            <value>Asia Pacific</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Region_Sales__c</field>
            <operation>equals</operation>
            <value>EMEA</value>
        </criteriaItems>
        <description>1st email immediately 
2nd &quot;reminder&quot; 2 days later - this notice would be sent on work day #3 
3rd &quot;reminder&quot; 2 days later - this notice would be sent on work day #5 
4th &quot;reminder&quot; 5 days later - this notice would be sent on work day #10</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Initial_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Third_Reminder__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Initial_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Secondary_Reminder__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Initial_Email_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Initial_Reminder__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>No update notification on DND Opportunity</fullName>
        <active>true</active>
        <formula>AND(   Record_Type_Name__c = &apos;DND_Opportunity&apos;, Active_Opportunity_Parts__c&gt;0,  CloseDate &gt; Today())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>No_Update_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>50</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>No_Update_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>55</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>No_Update_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>No_Update_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.Last_Modified_Date__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Notify two days before closed Date</fullName>
        <active>true</active>
        <description>This workflow will run 2 Days before any oppty close date is reached and will send email alerts to sales Engineer and sales lead</description>
        <formula>AND(
(NOT( ISBLANK(CloseDate) ))
,
(
OR(
( Record_Type_Name__c = &apos;Engineering_Opportunity_CSD&apos;),(Record_Type_Name__c = &apos;Sales_Opportunity_CSD&apos;))
) 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_to_Opportunity_Owner_and_his_Manager</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Health Check</fullName>
        <actions>
            <name>Set_WF_Health_Check</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_WF_Health_Check_Comment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to set the health check and health check comment. (Created by PMV)</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Near Overdue Notification for DND</fullName>
        <active>true</active>
        <description>To send notification 7 days and 1 day prior to closed date.</description>
        <formula>AND(  Record_Type_Name__c = &apos;DND_Opportunity&apos;,  Active_Opportunity_Parts__c&gt;0,  CloseDate &gt; Today())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Near_Overdue_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Near_Overdue_Notification</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Reminder WF2</fullName>
        <active>false</active>
        <description>This WF counts the reminder counter field up. Valid for odd numbers.</description>
        <formula>IF
(
AND
(
OR
(
Counter_for_Opportunity_reminder__c =1,
Counter_for_Opportunity_reminder__c =3,
Counter_for_Opportunity_reminder__c =5
),
Lead_ID__c &lt;&gt; &quot;&quot;,
AND
(
IsClosed=false,
IsWon=false
),

OR
(
Amount =0, ISBLANK(Amount))
),
true, false
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Counter</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Reminder WF3</fullName>
        <actions>
            <name>Opportunity_Reminder_For_opportunities_created_from_Leads</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends out a mail after 7 days.</description>
        <formula>IF(AND
(
Counter_for_Opportunity_reminder__c =7,
Lead_ID__c &lt;&gt; &quot;&quot;,
AND
(
IsClosed=false,
IsWon=false
),
OR
(
Amount =0, ISBLANK(Amount))
),
true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reset_Opportunity_Counter</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity reminder WF1</fullName>
        <active>false</active>
        <description>This WF counts the reminder counter field up. Valid for even numbers.</description>
        <formula>IF
(
AND
(
OR
(
Counter_for_Opportunity_reminder__c =0,
Counter_for_Opportunity_reminder__c =2,
Counter_for_Opportunity_reminder__c =4,
Counter_for_Opportunity_reminder__c =6
),
Lead_ID__c &lt;&gt; &quot;&quot;,
AND
(
IsClosed=false,
IsWon=false
), 
 
OR
(
Amount =0, ISBLANK(Amount))
),
true, false
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Opportunity_Counter</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Populate Connection Record Type - Oppt</fullName>
        <actions>
            <name>Update_Connection_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Record Type fields cannot be subscribed to when mapping fields in SF2SF. Therefore this workflow rule will be utilized to update a field called Connection Record Type and that field will be published by this org to central to transmit the record type.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Quote attached date</fullName>
        <actions>
            <name>Quote_is_attached_to_opportunity</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Quote_Attached_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Rule_Fired_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Quote_attached__c</field>
            <operation>equals</operation>
            <value>Quote attached</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Quote_attached_rule_triggered__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>sets the quote attached date and sends email to oppy owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Quote follow up date update</fullName>
        <actions>
            <name>Quote_follow_up_date_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Source__c</field>
            <operation>equals</operation>
            <value>Quote Follow up</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>Energy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.User_Region__c</field>
            <operation>equals</operation>
            <value>AMERICAS</value>
        </criteriaItems>
        <description>When Opportunity Source is Quote Follow Up update Quote Follow Up Date to now</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ROA - Email Notification on World Bank Financed related Project</fullName>
        <actions>
            <name>ROA_Email_Notification_on_Project_Related_to_World_Bank_Financed</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 3) AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Is_this_Related_to_World_Bank_Financed__c</field>
            <operation>equals</operation>
            <value>YES</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type__c</field>
            <operation>equals</operation>
            <value>Energy - Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type__c</field>
            <operation>equals</operation>
            <value>Energy - Tender</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Business_Unit__c</field>
            <operation>equals</operation>
            <value>Energy</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Owner_Region__c</field>
            <operation>equals</operation>
            <value>ROA</value>
        </criteriaItems>
        <description>When the Is Related to World Bank Financed? Field equals YES… send an email notification to Doris Hwan Hwa Tang</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Relay AE Start Date</fullName>
        <actions>
            <name>Relay_AE_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Relay_Application_Support_requested__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>This date field is automatically created with todays date when the field Relay Application support required is true.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Remove Relay AE Start Date</fullName>
        <actions>
            <name>Remove_Relay_AE_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Relay_Application_Support_requested__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the field Relay application support required equals false the field Relay AE Start Date is blanc.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Date for stage Won</fullName>
        <actions>
            <name>IND_Set_Won_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>IND_Engineering_project,IND_Sales_Project,Opportunity_Engineering_Project,Opportunity_Product_Platform,Opportunity_Sales_Parts_Only</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Won,Won - Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>Channel_Engineering_Opportunity,Channel_Sales_Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Commit</value>
        </criteriaItems>
        <description>sets the date when an IND Opportunity was set to Won</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set IND Lost Date</fullName>
        <actions>
            <name>Remove_IND_Won_Date_G3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_IND_won_date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_IND_Lost_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>IND_Engineering_project,IND_Sales_Project,NDR_Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Dead,Lost,Lost - Closed,Dead - Closed</value>
        </criteriaItems>
        <description>sets the date when an IND Opportunity was set to lost or dead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set IND Won Date</fullName>
        <actions>
            <name>Set_IND_Won_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Record_Type_Name__c</field>
            <operation>equals</operation>
            <value>IND_Engineering_project,IND_Sales_Project,Opportunity_Engineering_Project,Opportunity_Product_Platform,Opportunity_Sales_Parts_Only,Channel_Engineering_Opportunity,Channel_Sales_Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Production,Won - Closed</value>
        </criteriaItems>
        <description>sets the date when an IND Opportunity was set to Production</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Regional Sales Percentage</fullName>
        <actions>
            <name>Set_Asia_Pacific_Sales_Pct</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Australia_NZ_Sales_Pct</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_China_Sales_Pct</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_EMEA_Pacific_Sales_Pct</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_North_America_Sales_Pct</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_South_America_Sales_Pct</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The PLM interface requires a sales percentage value for 6 predefined regions (Asia Pacific, Australia/New Zealand, China, North America, South America).  This rule allocates 100% to the opportunity Main Region of Consumption and 0% to all others.</description>
        <formula>NOT(ISPICKVAL( Main_Region_of_consumption__c , &quot;&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Stage Entry Date</fullName>
        <actions>
            <name>Set_Stage_Entry_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets the date when an opportunity changes stage</description>
        <formula>OR ( ISCHANGED( StageName ), ISNEW() )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TEMarketing__Notify Opportunity Owner</fullName>
        <actions>
            <name>TEMarketing__Notify_owner_of_opportunity_created_by_Distributor</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>$User.TEMarketing__User_License_Type__c == &apos;Partner Community&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Closed date for DND</fullName>
        <actions>
            <name>Update_Closed_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(  Record_Type_Name__c = &quot;DND_Opportunity&quot;, Active_Opportunity_Parts__c=0,   Opportunity_Part_Count__c &gt; 0, CloseDate != Today())</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Key Customer Code</fullName>
        <actions>
            <name>Update_Opportunity_Key_Customer_Code</name>
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
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Oppy Last Modified</fullName>
        <active>false</active>
        <description>This WF rule triggers update of custom Opportunity Last Modified Date field in case a opportunity record is created or updated.</description>
        <formula>AND(  $Profile.Name &lt;&gt; &quot;Systemadministrator&quot;,  $Profile.Name &lt;&gt; &quot;System Administrator&quot;,  $Profile.Name &lt;&gt; &quot;BU Admin&quot;,  $Profile.Name &lt;&gt; &quot;Service Account&quot;, $Profile.Name &lt;&gt; &quot;Partner Admin&quot;, $Profile.Name &lt;&gt; &quot;Regional Admin&quot;, $Profile.Name &lt;&gt; &quot;Production Support&quot;, $Profile.Name &lt;&gt; &quot;BU Analyst&quot;,  $Profile.Name &lt;&gt; &quot;Marketing Analyst&quot;, $Profile.Name &lt;&gt; &quot;NPS Admin&quot;, $Profile.Name &lt;&gt; &quot;OwnBackupAdminProfile&quot;, $Profile.Name &lt;&gt; &quot;Regional Admin Channel&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Phase when Oppty already exist</fullName>
        <actions>
            <name>Update_Phase_to_Lost_Dead_closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>NDR Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.NDR_Quote_Status_Description__c</field>
            <operation>equals</operation>
            <value>Complete</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Opportunity_Already_Exist__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Current_NDR_quote_number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>notEqual</operation>
            <value>Dead - Closed</value>
        </criteriaItems>
        <description>Update Phase to Lost/Dead - Closed when OPPORTUNITY ALREADY EXIST or Renew Existing NDR fields are true</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage Image</fullName>
        <actions>
            <name>CPM_Image</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>greaterThan</operation>
            <value>1/1/1901</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>setDefaultIsFromCode</fullName>
        <actions>
            <name>updateIsFromCode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>set the field isFromCode to false</description>
        <formula>AND(ISCHANGED(isFromCode__c), isFromCode__c=true)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Breakout_Blanket_Tender</fullName>
        <assignedTo>energy_prj_deployment_user@te.com.c2s</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Please reach out to Energy Sales/opportunity owner to get the monthly release amount for the child opportunities.</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Opportunity.CloseDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Breakout Blanket/Tender</subject>
    </tasks>
    <tasks>
        <fullName>Close_date_to_be_updated</fullName>
        <assignedToType>owner</assignedToType>
        <description>Close date needs to be updated on this opportunitie</description>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Close date to be updated</subject>
    </tasks>
    <tasks>
        <fullName>Follow_Up_Lost_Opp</fullName>
        <assignedToType>owner</assignedToType>
        <description>Your opportunity was automatically set to LS - Lost because it reached the Go-No Go Date. Please follow up in 90 days.</description>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Opportunity.MED_Go_No_Go_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow Up Lost Opp</subject>
    </tasks>
    <tasks>
        <fullName>Update_Med_Loss_Code</fullName>
        <assignedToType>owner</assignedToType>
        <description>The related opportunity has been automatically set to LS - Lost. Please revise the MED Loss Code with an appropriate value.</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <offsetFromField>Opportunity.MED_Go_No_Go_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Med Loss Code</subject>
    </tasks>
</Workflow>
