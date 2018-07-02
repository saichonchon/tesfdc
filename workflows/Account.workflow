<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_AccountNumber</fullName>
        <description>Copies AccountNumber into SAP Account Number</description>
        <field>SAP_Account_Number__c</field>
        <formula>AccountNumber</formula>
        <name>Copy AccountNumber</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Account_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>CIS_Account</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Define Account Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Account_Sharing</fullName>
        <description>This field update unchecks the &quot;Restricted Account Sharing&quot;</description>
        <field>Legally_Restricted__c</field>
        <literalValue>0</literalValue>
        <name>Define Account Sharing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Customer_BU</fullName>
        <description>defines the customer BU based on the IBC code</description>
        <field>Customer_BU__c</field>
        <formula>IF(NOT(ISPICKVAL( Industry_Code_Description__c , &quot;&quot;)), TEXT( Industry_Code_Description__c ),
CASE( INDUSTRY_BUSINESS_CDE__c , 
&quot;008&quot;,&quot;Telecom Networks&quot;,
&quot;009&quot;,&quot;Enterprise Networks&quot;,
&quot;038&quot;,&quot;Circuit Protection&quot;,
&quot;049&quot;,&quot;Aerospace Defense &amp; Marine&quot;,
&quot;050&quot;,&quot;Medical&quot;,
&quot;076&quot;,&quot;Electronic Distribution &quot;,
&quot;077&quot;,&quot;Electronic Distribution &quot;,
&quot;078&quot;,&quot;Electronic Distribution &quot;,
&quot;081&quot;,&quot;Electrical Distribution &quot;,
&quot;082&quot;,&quot;Electrical Distribution &quot;,
&quot;083&quot;,&quot;Electronic Distribution &quot;,
&quot;084&quot;,&quot;Electrical Distribution &quot;,
&quot;085&quot;,&quot;Electrical Distribution &quot;,
&quot;105&quot;,&quot;Industrial&quot;,
&quot;106&quot;,&quot;Industrial&quot;,
&quot;107&quot;,&quot;Data Comm&quot;,
&quot;108&quot;,&quot;Data Comm&quot;,
&quot;109&quot;,&quot;Computers &amp; Peripheral Equipment&quot;,
&quot;110&quot;,&quot;Business/Retail Equipment&quot;,
&quot;111&quot;,&quot;Home Entertainment/Consumer Electronics&quot;,
&quot;112&quot;,&quot;Mobile Phones&quot;,
&quot;113&quot;,&quot;Industrial&quot;,
&quot;115&quot;,&quot;Appliances&quot;,
&quot;116&quot;,&quot;Industrial&quot;,
&quot;117&quot;,&quot;Industrial&quot;,
&quot;199&quot;,&quot;Energy&quot;,
&quot;202&quot;,&quot;Energy&quot;,
&quot;203&quot;,&quot;Industrial&quot;,
&quot;204&quot;,&quot;Automotive&quot;,
&quot;205&quot;,&quot;Automotive&quot;,
&quot;211&quot;,&quot;EMS&quot;,
&quot;219&quot;,&quot;Computers &amp; Peripheral Equipment&quot;,
&quot;220&quot;,&quot;Business/Retail Equipment&quot;,
&quot;221&quot;,&quot;Home Entertainment/Consumer Electronics&quot;,
&quot;222&quot;,&quot;Mobile Phones&quot;,
&quot;223&quot;,&quot;Data Comm&quot;,
&quot;224&quot;,&quot;Industrial&quot;,
&quot;225&quot;,&quot;Industrial&quot;,
&quot;226&quot;,&quot;Industrial&quot;,
&quot;227&quot;,&quot;Industrial&quot;,
&quot;228&quot;,&quot;Industrial&quot;,
&quot;229&quot;,&quot;Medical&quot;,
&quot;230&quot;,&quot;Aerospace Defense &amp; Marine&quot;,
&quot;231&quot;,&quot;Appliances&quot;,
&quot;232&quot;,&quot;Automotive&quot;,
&quot;234&quot;,&quot;Automotive&quot;,
&quot;235&quot;,&quot;Automotive&quot;,
&quot;236&quot;,&quot;Automotive&quot;,
&quot;237&quot;,&quot;Automotive&quot;,
&quot;239&quot;,&quot;Aerospace Defense &amp; Marine&quot;,
&quot;240&quot;,&quot;Aerospace Defense &amp; Marine&quot;,
&quot;241&quot;,&quot;Industrial&quot;,
&quot;251&quot;,&quot;IND Electronic Distribution&quot;,
&quot;252&quot;,&quot;IND Electronic Distribution&quot;,
&quot;253&quot;,&quot;IND Electronic Distribution&quot;, 
&quot;Other&quot; 
))</formula>
        <name>Define Customer BU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Customer_Region</fullName>
        <field>Customer_Region__c</field>
        <formula>CASE(BillingCountry, 
&quot;AF&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;AG&quot;, &quot;North America&quot;, 
&quot;AI&quot;, &quot;North America&quot;, 
&quot;AR&quot;, &quot;South America&quot;, 
&quot;AS&quot;, &quot;Australia / New Zealand&quot;, 
&quot;AU&quot;, &quot;Australia / New Zealand&quot;, 
&quot;AW&quot;, &quot;North America&quot;, 
&quot;BB&quot;, &quot;North America&quot;, 
&quot;BD&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;BM&quot;, &quot;North America&quot;, 
&quot;BO&quot;, &quot;South America&quot;, 
&quot;BR&quot;, &quot;South America&quot;, 
&quot;BS&quot;, &quot;North America&quot;, 
&quot;BT&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;BZ&quot;, &quot;North America&quot;, 
&quot;CA&quot;, &quot;North America&quot;, 
&quot;CC&quot;, &quot;Australia / New Zealand&quot;, 
&quot;CK&quot;, &quot;Australia / New Zealand&quot;, 
&quot;CL&quot;, &quot;South America&quot;, 
&quot;CN&quot;, &quot;China / HK / Taiwan&quot;, 
&quot;CO&quot;, &quot;South America&quot;, 
&quot;CR&quot;, &quot;North America&quot;, 
&quot;CU&quot;, &quot;North America&quot;, 
&quot;CX&quot;, &quot;Australia / New Zealand&quot;, 
&quot;DM&quot;, &quot;North America&quot;, 
&quot;DO&quot;, &quot;North America&quot;, 
&quot;EC&quot;, &quot;South America&quot;, 
&quot;FJ&quot;, &quot;Australia / New Zealand&quot;, 
&quot;FM&quot;, &quot;Australia / New Zealand&quot;, 
&quot;GD&quot;, &quot;North America&quot;, 
&quot;GT&quot;, &quot;North America&quot;, 
&quot;GY&quot;, &quot;South America&quot;, 
&quot;HK&quot;, &quot;China / HK / Taiwan&quot;, 
&quot;HN&quot;, &quot;North America&quot;, 
&quot;HT&quot;, &quot;North America&quot;, 
&quot;ID&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;IN&quot;, &quot;India&quot;, 
&quot;JM&quot;, &quot;North America&quot;, 
&quot;JP&quot;, &quot;Japan&quot;, 
&quot;KH&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;KP&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;KR&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;KY&quot;, &quot;Australia / New Zealand&quot;, 
&quot;LA&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;LC&quot;, &quot;North America&quot;, 
&quot;LK&quot;, &quot;India&quot;, 
&quot;MM&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;MN&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;MO&quot;, &quot;China / HK / Taiwan&quot;, 
&quot;MS&quot;, &quot;North America&quot;, 
&quot;MU&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;MV&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;MX&quot;, &quot;North America&quot;, 
&quot;MY&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;NC&quot;, &quot;Australia / New Zealand&quot;, 
&quot;NI&quot;, &quot;North America&quot;, 
&quot;NP&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;NZ&quot;, &quot;Australia / New Zealand&quot;, 
&quot;PA&quot;, &quot;North America&quot;, 
&quot;PE&quot;, &quot;South America&quot;, 
&quot;PG&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;PH&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;PK&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;PR&quot;, &quot;North America&quot;, 
&quot;PY&quot;, &quot;South America&quot;, 
&quot;SG&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;SR&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;SV&quot;, &quot;South America&quot;, 
&quot;TH&quot;, &quot;Asia (excl. China and Japan)&quot;, 
&quot;TO&quot;, &quot;Australia / New Zealand&quot;, 
&quot;TT&quot;, &quot;North America&quot;, 
&quot;TW&quot;, &quot;China / HK / Taiwan&quot;, 
&quot;US&quot;, &quot;North America&quot;, 
&quot;TW&quot;, &quot;China / HK / Taiwan&quot;, 
&quot;USA&quot;, &quot;North America&quot;, 
&quot;UY&quot;, &quot;South America&quot;, 
&quot;VE&quot;, &quot;South America&quot;, 
&quot;VN&quot;, &quot;Asia (excl. China and Japan)&quot;, 
IF(( CONTAINS(Name , &apos;Unidentified&apos;)&amp;&amp; (BillingCountry = &apos;&apos; || BillingCountry = &apos;RN&apos;)), &apos;Region Not Found&apos;, &apos;EMEA (excl. India)&apos;))</formula>
        <name>Define Customer Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Define_Restricted_Account_Sharing</fullName>
        <description>This field update checks the &quot;Restricted Account Sharing&quot;</description>
        <field>Legally_Restricted__c</field>
        <literalValue>1</literalValue>
        <name>Define Restricted Account Sharing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Determine_Plan_Group_Id</fullName>
        <field>Plan_Group_Id__c</field>
        <formula>IF(Individually_Planned__c, Id,  Plan_Group_Account__c)</formula>
        <name>Determine Plan Group Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fill_IND_Billing_Region</fullName>
        <description>Defines the Industrila Billing region based on Industrial Finace definitions</description>
        <field>IND_Billing_Region__c</field>
        <formula>IF(RecordType.DeveloperName = &apos;CIS_Account&apos;,
(CASE(LAYER2_ORGANIZATION_ID__c,
&apos;0002&apos;, &apos;Americas&apos;,
&apos;0933&apos;, &apos;Americas&apos;,
CASE( LAYER3_ORGANIZATION_ID__c,
&apos;0988&apos;, &apos;India&apos;,
&apos;0402&apos;, &apos;EMEA (excl. India)&apos;,
&apos;0414&apos;, &apos;EMEA (excl. India)&apos;,
&apos;0420&apos;, &apos;EMEA (excl. India)&apos;,
CASE(
LAYER3_ORGANIZATION_ID__c,
&apos;0470&apos;, &apos;JP/KR/ANZ&apos;,
&apos;0937&apos;,&apos;JP/KR/ANZ&apos;,
&apos;1682&apos;,&apos;JP/KR/ANZ&apos;,
IF(
AND(
OR(
LAYER3_ORGANIZATION_ID__c =&apos;0449&apos;,
LAYER3_ORGANIZATION_ID__c =&apos;0460&apos;
),
AND(
BillingCountry!= &apos;KR&apos;,
BillingCountry!= &apos;AU&apos;,
BillingCountry!= &apos;NZ&apos;
)),&apos;China/SEA&apos;,
IF(
AND(
OR(
LAYER3_ORGANIZATION_ID__c =&apos;0449&apos;,
LAYER3_ORGANIZATION_ID__c =&apos;0460&apos;
),
OR(
BillingCountry= &apos;KR&apos;,
BillingCountry= &apos;AU&apos;,
BillingCountry= &apos;NZ&apos;
)),&apos;JP/KR/ANZ&apos;,
&apos;&apos;)))))),


IF(OR(RecordType.DeveloperName = &apos;CIS_Prospect&apos;, RecordType.DeveloperName = &apos;CIS_Other&apos;),
(CASE(
Customer_Region__c,
&apos;Asia (excl. China and Japan)&apos;, &apos;China/SEA&apos;,
&apos;Australia / New Zealand&apos;, &apos;JP/KR/ANZ&apos;,
&apos;South America&apos;, &apos;Americas&apos;,
&apos;North America&apos;, &apos;Americas&apos;,
&apos;China / HK / Taiwan&apos;, &apos;China/SEA&apos;,
&apos;Korea&apos;, &apos;JP/KR/ANZ&apos;,
&apos;Japan&apos;, &apos;JP/KR/ANZ&apos;,
&apos;India&apos;, &apos;India&apos;,
&apos;EMEA (excl. India)&apos;, &apos;EMEA (excl. India)&apos;,
&apos; &apos;
)),
&apos; &apos;
)
)</formula>
        <name>Fill IND Billing Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fill_IND_Customer_Classification</fullName>
        <field>IND_Customer_Classification__c</field>
        <formula>CASE(INDUSTRY_BUSINESS_CDE__c,
&apos;081&apos;, &apos;Electrical DIS&apos;,
&apos;082&apos;, &apos;Electrical DIS&apos;,
&apos;084&apos;, &apos;Electrical DIS&apos;,
&apos;085&apos;, &apos;Electrical DIS&apos;,
&apos;076&apos;, &apos;Electronic DIS&apos;,
&apos;077&apos;, &apos;Electronic DIS&apos;,
&apos;078&apos;, &apos;Electronic DIS&apos;,
&apos;079&apos;, &apos;Electronic DIS&apos;,
&apos;080&apos;, &apos;Electronic DIS&apos;,
&apos;251&apos;, &apos;Electronic DIS&apos;,
&apos;252&apos;, &apos;Electronic DIS&apos;,
&apos;253&apos;, &apos;Electronic DIS&apos;,
&apos;083&apos;, &apos;Electronic DIS&apos;,
(CASE(GAMCD__c,
&apos;G030&apos;, &apos;A&apos;,
&apos;G037&apos;, &apos;A&apos;,
&apos;G064&apos;, &apos;A&apos;,
&apos;G046&apos;, &apos;A&apos;,
&apos;G215&apos;, &apos;A&apos;,
&apos;G192&apos;, &apos;A&apos;,
&apos;G038&apos;, &apos;A&apos;,
&apos;G131&apos;, &apos;A&apos;,
&apos;G132&apos;, &apos;A&apos;,
&apos;G130&apos;, &apos;A&apos;,
&apos;G387&apos;, &apos;A&apos;,
(CASE(Territory_L2_Code__c,
&apos;102206&apos;, &apos;CD&apos;,
(CASE(INDUSTRY_BUSINESS_CDE__c,
&apos;105&apos;, &apos;IND B&apos;,
&apos;113&apos;, &apos;IND B&apos;,
&apos;106&apos;, &apos;IND B&apos;,
&apos;117&apos;, &apos;IND B&apos;,
&apos;116&apos;, &apos;IND B&apos;,
&apos;228&apos;, &apos;IND B&apos;,
&apos;225&apos;, &apos;IND B&apos;,
&apos;226&apos;, &apos;IND B&apos;,
&apos;227&apos;, &apos;IND B&apos;,
&apos;241&apos;, &apos;IND B&apos;,
IF(
(INDUSTRY_BUSINESS_CDE__c = &apos;211&apos;)
&amp;&amp; (Territory_L2_Code__c = &apos;102202&apos;),
&apos;IND B&apos;,
&apos;Other BU&apos;
)
)
)
)
)
)
)
)</formula>
        <name>Fill IND Customer Classification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fill_IND_RSM_Forecast_Category</fullName>
        <field>IND_RSM_Forecast_Category__c</field>
        <formula>CASE( GAMCD__c, 
&apos;G030&apos;, GAMCD__c, 
&apos;G046&apos;, GAMCD__c, 
&apos;G037&apos;, GAMCD__c, 
&apos;G064&apos;, GAMCD__c, 
&apos;G215&apos;, GAMCD__c, 
&apos;G192&apos;, GAMCD__c, 
&apos;G135&apos;, GAMCD__c, 
&apos;G038&apos;, GAMCD__c, 
&apos;G130&apos;, GAMCD__c, 
&apos;G131&apos;, GAMCD__c, 
&apos;G132&apos;, GAMCD__c, 
&apos;G387&apos;, GAMCD__c,
IF( NOT(ISBLANK(IND_KAM_Code__c)), IND_KAM_Code__c, &apos;&apos;))</formula>
        <name>Fill IND RSM Forecast Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Source_Parent_ID_update</fullName>
        <field>Source_Parent_ID__c</field>
        <formula>Parent.Id</formula>
        <name>Source Parent ID update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Connection_Record_Type</fullName>
        <field>Connection_Record_Type__c</field>
        <formula>&quot;BU Account&quot;</formula>
        <name>Update Connection Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Industry_Business_Name_Lev1</fullName>
        <field>DD1_Industry_Business_Name__c</field>
        <formula>CASE( Business_Unit_Level_2__c ,
&quot;A&amp;C&quot;,&quot;Industrial&quot;,
&quot;IB&quot;,&quot;Industrial&quot;,
&quot;Rail&quot;,&quot;Industrial&quot;,
CASE(Industry_Code_Description__c ,
&quot;Appliances&quot;,&quot;Appliances&quot;,
&quot;Industrial Commercial Transportation&quot;,&quot;Industrial &amp; Commercial Transportation&quot;,
&quot;Data &amp; Devices&quot;,&quot;Data &amp; Devices&quot;,
&quot;Medical&quot;,&quot;Medical&quot;,
&quot;Aerospace, Defense &amp; Marine&quot;,&quot;Aerospace Defense &amp; Marine&quot;,
&quot;Distribution Channel&quot;,&quot;Distribution Channel&quot;,
&quot;Automotive&quot;,&quot;Automotive&quot;,
&quot;Energy&quot;,&quot;Energy&quot;,
&quot;Other&quot;))</formula>
        <name>Update Industry Business Name Lev1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>get_Account_Owner_Role</fullName>
        <field>Account_Owner_Role__c</field>
        <formula>Owner.UserRole.Name</formula>
        <name>get Account Owner Role</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Industry_Busines_Code</fullName>
        <description>define the Industry business code for prospect and other Accounts based on the Business unit provided by the user</description>
        <field>INDUSTRY_BUSINESS_CDE__c</field>
        <formula>CASE( Business_Unit_Level_2__c,
&quot;A&amp;C&quot;,&quot;116&quot;,
&quot;IB&quot;,&quot;117&quot;,
&quot;Rail&quot;,&quot;113&quot;, 
CASE(Industry_Code_Description__c ,
&quot;Industrial &amp; Commercial Transportation&quot;,&quot;232&quot;,
&quot;Appliances&quot;,&quot;115&quot;,
&quot;Data &amp; Devices&quot;,&quot;107&quot;,
&quot;Medical&quot;,&quot;050&quot;,
&quot;Aerospace, Defense &amp; Marine&quot;,&quot;049&quot;,
&quot;Distribution Channel&quot;,&quot;076&quot;,
&quot;Automotive&quot;,&quot;205&quot;,
&quot;Energy&quot;,&quot;202&quot;,
&quot;Industrial&quot;,&quot;116&quot;,
&quot;076&quot;))</formula>
        <name>update Industry Busines Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Industry_Code_Lev_1</fullName>
        <description>rule to update the Industry Code level 1 filed based on Business Unit for Prospect and Other accounts</description>
        <field>LEVEL_1_INDUSTRY_CDE__c</field>
        <formula>Case( Business_Unit_Level_2__c ,
&quot;A&amp;C&quot;,&quot;0374&quot;,
&quot;IB&quot;,&quot;0194&quot;,
&quot;Rail&quot;,&quot;0108&quot;,
CASE(Industry_Code_Description__c ,
&quot;Appliances&quot;,&quot;0283&quot;,
&quot;Industrial Commercial Transportation&quot;,&quot;0067&quot;,
&quot;Data &amp; Devices&quot;,&quot;0228&quot;,
&quot;Medical&quot;,&quot;1001&quot;,
&quot;Aerospace, Defense &amp; Marine&quot;,&quot;0001&quot;,
&quot;Distribution Channel&quot;,&quot;0551&quot;,
&quot;Automotive&quot;,&quot;0067&quot;,
&quot;Energy&quot;,&quot;0448&quot;,
&quot;Industrial&quot;,&quot;0374&quot;,
&quot;0551&quot;))</formula>
        <name>update Industry Code Lev 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy AccountNumber</fullName>
        <actions>
            <name>Copy_AccountNumber</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow rule copies AccountNumber into unique field &quot;SAP_Account_Number__c&quot;</description>
        <formula>$RecordType.DeveloperName = &quot;CIS_Account&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Define Account Record Type</fullName>
        <actions>
            <name>Define_Account_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF rule triggers a Record Type / Page Layout update after the SAP Customer number is set.</description>
        <formula>NOT(ISBLANK(AccountNumber))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Define Customer BU</fullName>
        <actions>
            <name>Define_Customer_BU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Defines the customer BU based on the IBC code</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Define Customer Region</fullName>
        <actions>
            <name>Define_Customer_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF Rule defines customer region on the basis of billing country.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Define Restricted Account Sharing</fullName>
        <actions>
            <name>Define_Restricted_Account_Sharing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This wf rule checks &quot;Restricted Account Sharing&quot; checkbox in case the account owner is the &quot;TEIS Admin&quot;.</description>
        <formula>AND(OwnerId = &quot;005E0000000XIav&quot;, $RecordType.DeveloperName = &quot;CIS_Account&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Get Account Owner Role</fullName>
        <actions>
            <name>get_Account_Owner_Role</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ischanged( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Connection Record Type - Acct</fullName>
        <actions>
            <name>Update_Connection_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Record Type fields cannot be subscribed to when mapping fields in SF2SF. Therefore this workflow rule will be utilized to update a field called Connection Record Type and that field will be published by this org to central to transmit the record type.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Plan Group Id</fullName>
        <actions>
            <name>Determine_Plan_Group_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For annual budget planning a user can group accounts. This workflow determines a common plan group account id. OLD: OR(Individually_Planned__c, NOT(ISBLANK(Plan_Group_Account__c)))</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate parent Id</fullName>
        <actions>
            <name>Source_Parent_ID_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.ParentId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set IND Forecasting Fields</fullName>
        <actions>
            <name>Define_Customer_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fill_IND_Billing_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fill_IND_Customer_Classification</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fill_IND_RSM_Forecast_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR( ISNEW(), ISCHANGED(RecordTypeId),ISCHANGED(LAYER2_ORGANIZATION_ID__c), ISCHANGED(LAYER3_ORGANIZATION_ID__c), ISCHANGED(Company_Reporting_Org__c), ISCHANGED(BillingCountry), ISCHANGED(INDUSTRY_BUSINESS_CDE__c), (    NOT(ISBLANK(Sales_Hierarchy__c)) &amp;&amp; ISCHANGED(Territory_L2_Code__c)), ISCHANGED(Customer_Region__c), ISCHANGED(GAMCD__c), ISCHANGED(IND_KAM_Code__c), ISCHANGED (IND_Forecasting_Workflow_Timestamp__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Share Account with Central Org</fullName>
        <actions>
            <name>Define_Account_Sharing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This wf rule unchecks &quot;Restricted Account Sharing&quot; checkbox in case the account owner is changed from &quot;TEIS Admin&quot; to another.</description>
        <formula>AND( 	OwnerId &lt;&gt; &quot;005E0000000XIav&quot;, 	$RecordType.DeveloperName = &quot;CIS_Account&quot; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>populate IBC code for Prospect and Other Account record types</fullName>
        <actions>
            <name>Fill_IND_Billing_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Industry_Business_Name_Lev1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_Industry_Busines_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>update_Industry_Code_Lev_1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Other,Prospect,Grouped Accounts</value>
        </criteriaItems>
        <description>populates an IBC code for  Accounts of record type Propect and Other  to help with BU Profit Center on Opportunity and   IND customer classification</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
