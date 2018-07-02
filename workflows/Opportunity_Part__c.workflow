<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Additonal_Pricing_Information_on_Opp_Part_Received</fullName>
        <ccEmails>vishal.anand@te.com</ccEmails>
        <ccEmails>iibanez@salesforce.com</ccEmails>
        <description>Additional Pricing Information on Opp Part Received</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>NDR_Email_Templates/Additonal_Pricing_Information_on_Opp_Part_Received</template>
    </alerts>
    <alerts>
        <fullName>Risk_Parts_Rail</fullName>
        <ccEmails>elizabeth.dasilva-domingues@te.com</ccEmails>
        <description>Risk Parts Rail</description>
        <protected>false</protected>
        <recipients>
            <recipient>ben.kane@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>graham.brown@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jaap.dijckmans@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jon.hunt@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jrocha@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>r.smeets@te.com.c2s</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Templates/Risk_Parts_Rail</template>
    </alerts>
    <fieldUpdates>
        <fullName>Converted_Email_Alert_Date</fullName>
        <field>Converted_Email_Alert_Date__c</field>
        <formula>TODAY()</formula>
        <name>Converted Email Alert Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_CBC1_to_Oppy</fullName>
        <description>Update the CBC1 code with value 13359 if the related Opportunity Part&apos;s GPL CBC1 code is 13359</description>
        <field>Defined_CBC1__c</field>
        <formula>IF(Opportunity__r.Defined_CBC1__c == NULL,GPL__r.CBC1__c,IF(Opportunity__r.Defined_CBC1__c &lt;&gt; NULL &amp;&amp; NOT(CONTAINS(Opportunity__r.Defined_CBC1__c, GPL__r.CBC1__c)), 
(Opportunity__r.Defined_CBC1__c+&apos;,&apos;+GPL__r.CBC1__c), Opportunity__r.Defined_CBC1__c))</formula>
        <name>Copy CBC1 to Oppy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_CBCs_to_Oppy</fullName>
        <description>This field updated copies defined CBCs to related opportunity.</description>
        <field>Defined_CBC3s__c</field>
        <formula>GPL__r.CBC3__c</formula>
        <name>Copy CBCs to Oppy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_GPLs_to_Oppy</fullName>
        <description>This field updated copies defined GPLs to related opportunity.</description>
        <field>Defined_GPLs__c</field>
        <formula>IF(
	AND(
		NOT(CONTAINS(Opportunity__r.Defined_GPLs__c, GPL__r.Name)),
		NOT(ISBLANK(Opportunity__r.Defined_GPLs__c))
	), 
	Opportunity__r.Defined_GPLs__c &amp; &quot; | &quot; &amp;  GPL__r.Name, GPL__r.Name
)</formula>
        <name>Copy GPLs to Oppy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Product_GIBUs_to_Oppy</fullName>
        <description>This field update saves Product GIBUs on Oppy Level.</description>
        <field>Product_GIBUs__c</field>
        <formula>IF(
	OR(
		ISBLANK(Opportunity__r.Product_GIBUs__c),
		Opportunity__r.Product_GIBUs__c &lt;&gt;  Product_Owning_BU__c 
	), Product_Owning_BU__c, &quot;&quot;
)</formula>
        <name>Copy Product GIBUs to Oppy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DGI_Update</fullName>
        <description>updates the new DGI field with the value of the old one. Value is taken from the DGI field in the product hierarchy</description>
        <field>DGI_Indicator_New__c</field>
        <formula>DGI_indicator__c</formula>
        <name>DGI Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DGI_Update_from_PC</fullName>
        <description>this field updates &apos;DGI indicator new&apos; with the DGI value from the part if we have a similar TE pn or a new SAP pn</description>
        <field>DGI_Indicator_New__c</field>
        <formula>DGI_Indicator_from_PC__c</formula>
        <name>DGI Update from PC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_GPL</fullName>
        <field>GPL_Name__c</field>
        <formula>GPL__r.Name</formula>
        <name>Define GPL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Part_Number</fullName>
        <field>Part_Number__c</field>
        <formula>Part__r.Name</formula>
        <name>Define Part Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Part_Number_defined</fullName>
        <field>Part_Number_defined__c</field>
        <literalValue>1</literalValue>
        <name>Define Part Number defined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Part_Number_not_defined</fullName>
        <field>Part_Number_defined__c</field>
        <literalValue>0</literalValue>
        <name>Define Part Number not defined</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initiate_NDR_SFDC_SAP_Integration</fullName>
        <description>This WF is used to update a field in Opp &quot;Initiate SFDC-SAP Integration&quot; to initiate the Orchestration.</description>
        <field>NDR_Is_Signal_Received__c</field>
        <literalValue>1</literalValue>
        <name>Initiate NDR SFDC-SAP Integration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Part_Update_Oppy_Last_Modified</fullName>
        <description>Updates the Opportunity custom Last Modified Date.</description>
        <field>Last_Modified_Date__c</field>
        <formula>Now()</formula>
        <name>Part Update Oppy Last Modified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rail_Risk_Parts_Flag</fullName>
        <description>Flags an opportunity part as risk part for certain Rail pn</description>
        <field>Risk_Part_Rail__c</field>
        <literalValue>1</literalValue>
        <name>Rail Risk Parts Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_GIBU_Value</fullName>
        <field>GIBU_Count__c</field>
        <formula>GIBU_Check__c</formula>
        <name>Set GIBU Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Converted_Flag</fullName>
        <field>APL_need_to_capture_billing__c</field>
        <literalValue>1</literalValue>
        <name>Update Converted Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_delete_flag</fullName>
        <field>APL_need_to_delete_captured_billing__c</field>
        <literalValue>1</literalValue>
        <name>Update delete flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Additional Pricing Information on Opp Part Received</fullName>
        <actions>
            <name>Additonal_Pricing_Information_on_Opp_Part_Received</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This workflow is used for NDR Opportunity when Pricing system sends rejection info. An email is sent out to the DMM notifying that additional pricing info is received from Pricing system</description>
        <formula>AND( ISPICKVAL(NDR_Current_Stage__c,&apos;Additional Pricing Information received from GPMS&apos;),  NDR_GPMS_Approval_Flag__c = &apos;N&apos; ,  OR(CONTAINS(NDR_Item_Status_Desc__c,&apos;Process&apos;),CONTAINS(NDR_Item_Status_Desc__c,&apos;DMM/DAE Review&apos;)), $Setup.Admin_Profile_Exception__c.Run_Rule__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Converted Opportunity Part</fullName>
        <actions>
            <name>Converted_Email_Alert_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     OR(        ISNULL(Opportunity__r.Converted_Email_Alert_Date__c),        AND( 	 NOT(ISBLANK(Opportunity__r.Converted_Email_Alert_Date__c)),          Opportunity__r.Converted_Email_Alert_Date__c &lt; TODAY()        )     ),     already_sent_convert_email__c = false,     CONTAINS(BU_profit_center__c, &apos;Appliance&apos;),     ISPICKVAL($User.GIBU__c, &apos;Appliances&apos;),     Opportunity__r.Account.Customer_Industry__c = &apos;Appliances&apos;,     NOT(ISBLANK( Won_Date__c )),     ISNULL(PRIORVALUE(Won_Date__c)),      Won_Date__c &gt;= $Setup.IND_Fiscal_Date_Information__c.First_Date_of_fiscal_year__c ,     Won_Date__c &lt;=  $Setup.IND_Fiscal_Date_Information__c.Last_date_of_fiscal_year__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy CBC1s to Oppy</fullName>
        <actions>
            <name>Copy_CBC1_to_Oppy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This wf rules copies defined CBC1s to related opportunity. Used for Sharing Rule.</description>
        <formula>(ISNEW()  ||  ISCHANGED( GPL__c )) &amp;&amp;  (GPL__r.CBC1__c == &apos;13359&apos; || GPL__r.CBC1__c == &apos;13349&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy CBC3s to Oppy</fullName>
        <actions>
            <name>Copy_CBCs_to_Oppy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This wf rules copies defined CBC3s to related opportunity. Used for Approval Processes.</description>
        <formula>(ISNEW()  ||  ISCHANGED( GPL__c ))  &amp;&amp;  RecordTypeId  &lt;&gt; &quot;012E0000000XrBg&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy GPLs to Oppy</fullName>
        <actions>
            <name>Copy_GPLs_to_Oppy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This wf rules copies defined GPLs to related opportunity. Used for Approval Processes.
De-activated 08th January 2014 as trigger exists that does the same. (ML)</description>
        <formula>ISNEW()  ||  ISCHANGED( GPL__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Product GIBUs to Oppy</fullName>
        <actions>
            <name>Copy_Product_GIBUs_to_Oppy</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy Product GIBUs to Oppy</description>
        <formula>ISNEW()  ||  ( ISCHANGED( RecordTypeId ) &amp;&amp; $RecordType.DeveloperName &lt;&gt; &quot;Sales_Parts&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DGI New Update</fullName>
        <actions>
            <name>DGI_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>updates the DGI _New field with the value of the existing DGI field.
This applies to proposal parts for which we only know the GPL</description>
        <formula>ISBLANK( DGI_Indicator_from_PC__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>DGI Update from PC</fullName>
        <actions>
            <name>DGI_Update_from_PC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Fills the field &apos;DGI Indicator New&apos; with the DGI value from the part if we have a similar TE pn or an existing sales pn</description>
        <formula>NOT(ISBLANK( DGI_Indicator_from_PC__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Define Part Number %26 GPL</fullName>
        <actions>
            <name>Define_GPL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Define_Part_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This wf rule saved part number &amp; GPL into text fields. This is used from Offline App</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Define Part Number defined</fullName>
        <actions>
            <name>Define_Part_Number_defined</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF Rule checks &quot;Part Number defined&quot; checkbox in case Part number is defined.

AND(NOT(ISBLANK(Part__c)),  $RecordType.DeveloperName != &quot;Sales_Parts&quot;)</description>
        <formula>NOT(ISBLANK(Part__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Define Part Number not defined</fullName>
        <actions>
            <name>Define_Part_Number_not_defined</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF Rule unchecks &quot;Part Number defined&quot; checkbox in case no Part number is defined</description>
        <formula>AND(ISBLANK(Part__c),  $RecordType.DeveloperName != &quot;Sales_Parts&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HVCB Notification</fullName>
        <active>false</active>
        <description>This workflow rule notifies Jaap Dijckmans when an opportunity part of GPL A76, G56, K97 is entered to an opportunity.</description>
        <formula>OR(
GPL__r.Name = &quot;A76&quot;,
GPL__r.Name = &quot;G56&quot;,
GPL__r.Name = &quot;K97&quot;
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Initiate NDR SFDC-SAP Integration</fullName>
        <actions>
            <name>Initiate_NDR_SFDC_SAP_Integration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity_Part__c.NDR_GPMS_Status__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.NDR_Is_Signal_Received__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This WF is used to update a field in Opp &quot;Initiate SFDC-SAP Integration&quot; to initiate the Orchestration.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Part Update Oppy Last Modified</fullName>
        <active>false</active>
        <description>This WF rule triggers update of custom Opportunity Last Modified Date field in case a part record is created or updated.</description>
        <formula>AND(  $Profile.Name &lt;&gt; &quot;Systemadministrator&quot;,  $Profile.Name &lt;&gt; &quot;System Administrator&quot;,  $Profile.Name &lt;&gt; &quot;BU Admin&quot;,  $Profile.Name &lt;&gt; &quot;Service Account&quot;, $Profile.Name &lt;&gt; &quot;Partner Admin&quot;, $Profile.Name &lt;&gt; &quot;Regional Admin&quot;, $Profile.Name &lt;&gt; &quot;Production Support&quot;, $Profile.Name &lt;&gt; &quot;BU Analyst&quot;,  $Profile.Name &lt;&gt; &quot;Marketing Analyst&quot;, $Profile.Name &lt;&gt; &quot;NPS Admin&quot;, $Profile.Name &lt;&gt; &quot;OwnBackupAdminProfile&quot;, $Profile.Name &lt;&gt; &quot;Regional Admin Channel&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Risk Parts Rail</fullName>
        <actions>
            <name>Risk_Parts_Rail</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Rail_Risk_Parts_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule flags an opportunity part when a certain Rail pn is entered</description>
        <formula>OR(
Part__r.Name = &quot;A47883-000&quot;,
Part__r.Name = &quot;1-2191179-1&quot;,
Part__r.Name = &quot;1-1882606-1&quot;,
Part__r.Name = &quot;1-1882632-1&quot;,
Part__r.Name = &quot;C84149-000&quot;,
Part__r.Name = &quot;C31018-000&quot;,
Part__r.Name = &quot;1-2004391-1&quot;,
Part__r.Name = &quot;1-2004392-1&quot;,
Part__r.Name = &quot;1-2004395-1&quot;,
Part__r.Name = &quot;1-1555040-1&quot;,
Part__r.Name = &quot;1-1555042-1&quot;,
Part__r.Name = &quot;1-1555303-1&quot;,
Part__r.Name = &quot;1-2191020-1&quot;,
Part__r.Name = &quot;1-2191402-1&quot;,
Part__r.Name = &quot;1-2191021-1&quot;,
Part__r.Name = &quot;1-2191259-1&quot;,
Part__r.Name = &quot;1-2191022-1&quot;

)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set GIBU Value</fullName>
        <actions>
            <name>Set_GIBU_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(GIBU_Check__c = 1,ISCHANGED(GIBU_Check__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update APL_need_to_capture_billing%5F%5Fc</fullName>
        <actions>
            <name>Update_Converted_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity_Part__c.Process_Status__c</field>
            <operation>equals</operation>
            <value>Production</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity_Part__c.Status__c</field>
            <operation>equals</operation>
            <value>Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.isAPLOpp__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update APL_need_to_delete_captured_billing%5F%5Fc</fullName>
        <actions>
            <name>Update_delete_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(AND(ISCHANGED( Status__c ) = True,ISCHANGED( Process_Status__c) = True, ISCHANGED( Won_Date__c ) = True, ISBLANK(Won_Date__c) = True),AND(ISCHANGED( Status__c ) = False,ISCHANGED( Process_Status__c ) = True, ISPICKVAL(Process_Status__c, &apos;Pre-prod&apos;), ISPICKVAL(Status__c, &apos;Won&apos;))) = True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
