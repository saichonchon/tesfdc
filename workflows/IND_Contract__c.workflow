<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Contract_cancellation_rejected</fullName>
        <description>Contract cancellation rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IND_Contract_Email_Templates/IND_Contract_Cancellation_rejected</template>
    </alerts>
    <alerts>
        <fullName>IND_Contract_Renewal</fullName>
        <description>IND Contract Renewal</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IND_Contract_Email_Templates/IND_Contract_Review</template>
    </alerts>
    <alerts>
        <fullName>IND_Contract_Renewal_Overdue</fullName>
        <description>IND Contract Renewal Overdue</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>GAM__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>IND_Contract_Email_Templates/IND_Contract_Review_Overdue</template>
    </alerts>
    <fieldUpdates>
        <fullName>IND_Contract_End_Renew_Tp_Start_Term</fullName>
        <description>will store the end date of a renewal period</description>
        <field>End_Date_Renewal_Period__c</field>
        <formula>DATE(
year( Start_Date_Intermediate__c )
+ floor((month(Start_Date_Intermediate__c ) + Renewal_Term_Months__c)/12) + if(and(month(Start_Date_Intermediate__c )=12,Renewal_Term_Months__c&gt;=12),-1,0)
,
if( mod( month(Start_Date_Intermediate__c ) + Renewal_Term_Months__c, 12 ) = 0, 12 , mod( month(Start_Date_Intermediate__c ) + Renewal_Term_Months__c, 12 ))
,
min(
day(Start_Date_Intermediate__c ),
case(
max( mod( month(Start_Date_Intermediate__c ) + Renewal_Term_Months__c, 12 ) , 1),
9,30,
4,30,
6,30,
11,30,
2,if(mod((year(Start_Date_Intermediate__c )
+ floor((month(Start_Date_Intermediate__c ) + Renewal_Term_Months__c)/12) + if(and(month(Start_Date_Intermediate__c )=12,Renewal_Term_Months__c&gt;=12),-1,0)),4)=0,29,28),
31
)
)
)</formula>
        <name>IND Contract End Renew=Int Start+Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_End_Renewal_End_Date</fullName>
        <field>End_Date_Renewal_Period__c</field>
        <formula>Contract_End_Date__c</formula>
        <name>IND Contract End Renewal = End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Int_End_Int_start_term</fullName>
        <field>End_Date_Intermediate__c</field>
        <formula>DATE(
year( Start_Date_Intermediate__c )
+ floor((month( Start_Date_Intermediate__c ) + Renewal_Term_Months__c )/12) + if(and(month( Start_Date_Intermediate__c )=12, Renewal_Term_Months__c&gt;=12),-1,0)
,
if( mod( month( Start_Date_Intermediate__c ) + Renewal_Term_Months__c, 12 ) = 0, 12 , mod( month( Start_Date_Intermediate__c ) + Renewal_Term_Months__c, 12 ))
,
min(
day( Start_Date_Intermediate__c ),
case(
max( mod( month( Start_Date_Intermediate__c ) + Renewal_Term_Months__c, 12 ) , 1),
9,30,
4,30,
6,30,
11,30,
2,if(mod((year( Start_Date_Intermediate__c )
+ floor((month( Start_Date_Intermediate__c ) + Renewal_Term_Months__c)/12) + if(and(month( Start_Date_Intermediate__c )=12, Renewal_Term_Months__c&gt;=12),-1,0)),4)=0,29,28),
31
)
)
)</formula>
        <name>IND Contract Int End=Int start+term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Set_All_Green_Status</fullName>
        <field>Action_Status__c</field>
        <literalValue>All Green</literalValue>
        <name>IND Contract Set All Green Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Set_Auto_Renewal_Check</fullName>
        <field>Action_Status__c</field>
        <literalValue>Auto-Renewal Check</literalValue>
        <name>IND Contract Set Auto Renewal Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Set_Expired_Status</fullName>
        <field>Contract_Status__c</field>
        <literalValue>Expired</literalValue>
        <name>IND Contract Set Expired Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Set_GAM_approved</fullName>
        <field>GAM_Approval__c</field>
        <literalValue>1</literalValue>
        <name>IND Contract Set GAM approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Set_Pending_Termination</fullName>
        <description>this field value is set when an auto-renewal contract is rejected and must be approved by the GAM</description>
        <field>Contract_Status__c</field>
        <literalValue>Active - Pending Termination Approval</literalValue>
        <name>IND Contract Set Pending Termination</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Set_Review_Date</fullName>
        <field>Date_for_next_review__c</field>
        <formula>TODAY()+180</formula>
        <name>IND Contract Set Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Set_status_to_active</fullName>
        <description>this field update will set the contract status to &apos;active&apos; if an Admin changed data and forgot to set the status back</description>
        <field>Contract_Status__c</field>
        <literalValue>Active</literalValue>
        <name>IND Contract Set status to active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_TP_End_Tp_Start_Term</fullName>
        <field>Temp_End_date__c</field>
        <formula>DATE(
year( Temp_Start_Date__c )
+ floor((month( Temp_Start_Date__c ) +  Renewal_Term_Months__c )/12) + if(and(month( Temp_Start_Date__c )=12, Renewal_Term_Months__c&gt;=12),-1,0)
,
if( mod( month( Temp_Start_Date__c ) + Renewal_Term_Months__c, 12 ) = 0, 12 , mod( month( Temp_Start_Date__c ) + Renewal_Term_Months__c, 12 ))
,
min(
day( Temp_Start_Date__c ),
case(
max( mod( month( Temp_Start_Date__c ) + Renewal_Term_Months__c, 12 ) , 1),
9,30,
4,30,
6,30,
11,30,
2,if(mod((year( Temp_Start_Date__c )
+ floor((month( Temp_Start_Date__c ) + Renewal_Term_Months__c)/12) + if(and(month( Temp_Start_Date__c )=12, Renewal_Term_Months__c&gt;=12),-1,0)),4)=0,29,28),
31
)
)
)</formula>
        <name>IND Contract TP End = Tp Start+Term</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Temp_End_Date_End_Date</fullName>
        <field>Temp_End_date__c</field>
        <formula>Contract_End_Date__c</formula>
        <name>IND Contract Temp End Date = End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Temp_Start_Start</fullName>
        <description>field update for Admin change of changed start date</description>
        <field>Temp_Start_Date__c</field>
        <formula>Contract_Start_Date__c</formula>
        <name>IND Contract Temp Start = Start</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Tp_End_End_Renewal</fullName>
        <field>Temp_End_date__c</field>
        <formula>End_Date_Renewal_Period__c</formula>
        <name>IND Contract Tp End=End Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_Update_First_Review_Check</fullName>
        <field>First_Review_Process_Passed__c</field>
        <literalValue>1</literalValue>
        <name>IND Contract Update First Review Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IND_Contract_date_sent_for_Term_approval</fullName>
        <field>Sent_for_termination_approval__c</field>
        <formula>TODAY()</formula>
        <name>IND Contract date sent for Term approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Renewal_Cancelled</fullName>
        <field>Renewal_Cancelled__c</field>
        <literalValue>1</literalValue>
        <name>Renewal Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>IND Contract Admin Edit finish</fullName>
        <actions>
            <name>IND_Contract_Set_status_to_active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>this WF rule will set the contract status back to &apos;Active&apos; if an Admin has changed any relevant fields that would re-schedule the submission into the approval process for review.</description>
        <formula>AND(   OR(   $Profile.Name = &quot;BU Admin&quot;,  $Profile.Name = &quot;System Administrator&quot;,  $Profile.Name = &quot;Systemadministrator&quot; ),   NOT(ISPICKVAL( Contract_Status__c , &quot;Active&quot;)),    OR(   ISCHANGED( Contract_Start_Date__c) ,   ISCHANGED( Contract_End_Date__c) ,   ISCHANGED( Cancel_Contract_XX_days_before_renewal__c) ,   ISCHANGED( Renewal_Term_Months__c),    ISCHANGED(   TESOG_Contract_Number__c  ),   ISCHANGED(  Date_for_next_review__c  ) ,  ISCHANGED( Account__c )   ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IND Contract Admin Edit set back</fullName>
        <active>true</active>
        <description>this WF rule will set the contract status back to &apos;Active&apos; if a user interrupted a flow</description>
        <formula>ISPICKVAL( Contract_Status__c , &quot;Admin Edit&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>IND_Contract_Set_status_to_active</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>IND Contract Renewal Change</fullName>
        <actions>
            <name>IND_Contract_End_Renew_Tp_Start_Term</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IND_Contract_Int_End_Int_start_term</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>after first review</description>
        <formula>OR(First_Review_Process_Passed__c = true, AND(     First_Review_Process_Passed__c = true,    ISCHANGED(  Renewal_Term_Months__c  )  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IND Contract Set Dates</fullName>
        <actions>
            <name>IND_Contract_Tp_End_End_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>after first review</description>
        <formula>AND(    First_Review_Process_Passed__c = true,   OR(   ISCHANGED( Contract_End_Date__c ),    ISCHANGED ( Cancel_Contract_XX_days_before_renewal__c )     )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IND Contract Set Dates after edit</fullName>
        <actions>
            <name>IND_Contract_End_Renewal_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IND_Contract_Temp_End_Date_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IND_Contract_Temp_Start_Start</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>initial runtime</description>
        <formula>AND(  First_Review_Process_Passed__c = false, OR(  ISCHANGED( Contract_Start_Date__c ),  ISCHANGED( Contract_End_Date__c ),   ISCHANGED (  Renewal_Term_Months__c ),  ISCHANGED (  Cancel_Contract_XX_days_before_renewal__c )  ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IND Contract set Temp dates</fullName>
        <actions>
            <name>IND_Contract_End_Renewal_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IND_Contract_Temp_End_Date_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IND_Contract_Temp_Start_Start</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>record creation</description>
        <formula>NOT(ISBLANK(Contract_End_Date__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
