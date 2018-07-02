<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AgileVizArt__Notifies_creator_user_story_update</fullName>
        <description>Notifies created by user about user story update</description>
        <protected>false</protected>
        <recipients>
            <field>AgileVizArt__Created_by__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AgileVizArt__AgileVizArt/AgileVizArt__User_Story_Update_Creator</template>
    </alerts>
    <alerts>
        <fullName>AgileVizArt__Notifies_raiser_user_story_update</fullName>
        <description>Notifies raised by user about user story update</description>
        <protected>false</protected>
        <recipients>
            <field>AgileVizArt__Raised_By__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AgileVizArt__AgileVizArt/AgileVizArt__User_Story_Update_Raiser</template>
    </alerts>
    <alerts>
        <fullName>AgileVizArt__Notify_assignee_about_new_user_story</fullName>
        <description>Notify assignee about new user story</description>
        <protected>false</protected>
        <recipients>
            <field>AgileVizArt__Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AgileVizArt__AgileVizArt/AgileVizArt__New_User_Story_Assignment1</template>
    </alerts>
    <alerts>
        <fullName>AgileVizArt__Notify_assignee_about_user_story_update</fullName>
        <description>Notifies assignee about user story update</description>
        <protected>false</protected>
        <recipients>
            <field>AgileVizArt__Assigned_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AgileVizArt__AgileVizArt/AgileVizArt__User_Story_Update_Assignee</template>
    </alerts>
    <alerts>
        <fullName>AgileVizArt__Notify_delegate_about_new_user_story</fullName>
        <description>Notify delegate about new user story</description>
        <protected>false</protected>
        <recipients>
            <field>AgileVizArt__Delegated_To__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AgileVizArt__AgileVizArt/AgileVizArt__New_User_Story_Assignment_for_Delegate1</template>
    </alerts>
    <alerts>
        <fullName>AgileVizArt__Notify_delegate_about_user_story_update</fullName>
        <description>Notifies delegate about user story update</description>
        <protected>false</protected>
        <recipients>
            <field>AgileVizArt__Delegated_To__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AgileVizArt__AgileVizArt/AgileVizArt__User_Story_Update_Delegate</template>
    </alerts>
    <fieldUpdates>
        <fullName>AgileVizArt__Copy_Story_Number</fullName>
        <field>AgileVizArt__Story_Number_Text__c</field>
        <formula>AgileVizArt__Story_Id__c</formula>
        <name>Copy Story Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Copy_to_Description_No_HTML</fullName>
        <field>AgileVizArt__Description_No_HTML__c</field>
        <formula>SUBSTITUTE(AgileVizArt__Description__c, &apos;&lt;br&gt;&apos;,&apos;br&apos;)</formula>
        <name>Copy to Description (without HTML)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Default_Sprint_Rank</fullName>
        <field>AgileVizArt__Sprint_Rank__c</field>
        <formula>AgileVizArt__Rank__c</formula>
        <name>Default Sprint Rank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Define_Doing_Date</fullName>
        <field>AgileVizArt__Doing_Date__c</field>
        <formula>IF(ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;), TODAY(), NULL)</formula>
        <name>Define Doing Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Define_Done_Date</fullName>
        <field>AgileVizArt__Done_Date__c</field>
        <formula>IF(OR(ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;), AND(ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;), ISBLANK(AgileVizArt__Done_Date__c))), 
TODAY(), 
IF(ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;), AgileVizArt__Done_Date__c, NULL))</formula>
        <name>Define Done Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Define_Open_Date</fullName>
        <field>AgileVizArt__Open_Date__c</field>
        <formula>IF(ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;), TODAY(),  NULL)</formula>
        <name>Define Open Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Define_Review_Date</fullName>
        <field>AgileVizArt__Review_Date__c</field>
        <formula>IF(ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;), TODAY(), NULL)</formula>
        <name>Define Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Define_User_Story_Doing_Date</fullName>
        <description>- At the beginning:empty
- Status changes from Open, On Hold, Duplicate, or Rejected:TODAY()
- Status changes to Open, On Hold, Duplicate, or Rejected,null</description>
        <field>AgileVizArt__Doing_Date__c</field>
        <formula>IF(
	AND(
		OR(
			ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;)
		),
		ISNULL(AgileVizArt__Doing_Date__c)
	)
	,TODAY()
	,IF(
		AND(
			OR(
				ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;On Hold&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Duplicate&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Rejected&quot;)
			)
		)
		,NULL
		,AgileVizArt__Doing_Date__c
	)
)</formula>
        <name>Define User Story Doing Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Define_User_Story_Done_Date</fullName>
        <description>- At the beginning empty.
- Status changes from any other status not equal to Closed or Done to Done or Closed:TODAY()
- Status changes to any other status not equal to Closed or Done:Null</description>
        <field>AgileVizArt__Done_Date__c</field>
        <formula>IF(
	AND(
		OR(
			ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;)
		),
		ISNULL(AgileVizArt__Done_Date__c)
	)
	,TODAY()
	,IF(
		AND(
			OR(				
				ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;On Hold&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Duplicate&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Rejected&quot;)
			)
		)
		,NULL
		,AgileVizArt__Done_Date__c
	)
)</formula>
        <name>Define User Story Done Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Define_User_Story_Open_Date</fullName>
        <description>- User story is created:TODAY()
- Status changes to On Hold, Duplicate, or Rejected :Null
- Status changes from On Hold, Duplicate, or Rejected:TODAY()</description>
        <field>AgileVizArt__Open_Date__c</field>
        <formula>IF(
	AND(
		OR(
			ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;)
		),
		ISNULL(AgileVizArt__Open_Date__c)
	)
	,TODAY()
	,IF(
		AND(
			OR(
				ISPICKVAL(AgileVizArt__Status__c, &quot;On Hold&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Duplicate&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Rejected&quot;)
			)
		)
		,NULL
		,AgileVizArt__Open_Date__c
	)
)</formula>
        <name>Define User Story Open Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Define_User_Story_Review_Date</fullName>
        <description>- At the beginning empty.
- Status changes from Open, Doing, On Hold, Duplicate, or Rejected:TODAY(). 
- Status changes to Open, Doing, On Hold, Duplicate, or Rejected:null</description>
        <field>AgileVizArt__Review_Date__c</field>
        <formula>IF(
	AND(
		OR(
			ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;)
		),
		ISNULL(AgileVizArt__Review_Date__c)
	)
	,TODAY()
	,IF(
		AND(
			OR(				
				ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;On Hold&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Duplicate&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Rejected&quot;)
			)
		)
		,NULL
		,AgileVizArt__Review_Date__c
	)
)</formula>
        <name>Define User Story Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Set_Sync_Priority</fullName>
        <field>AgileVizArt__Sync_Priority__c</field>
        <literalValue>0</literalValue>
        <name>Set Sync Priority</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__Sprint_Assignment_Date_Update</fullName>
        <description>sets sprint assignment date to TODAY() whenever sprint lookup is changed and populated (even during insert), set it to null whenever sprint lookup is empty.</description>
        <field>AgileVizArt__Sprint_Assignment_Date__c</field>
        <formula>IF(  ISBLANK(AgileVizArt__Sprint__c)  ,  NULL , TODAY())</formula>
        <name>Sprint Assignment Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__User_Story_Doing_Date</fullName>
        <description>- At the beginning:empty
- Status changes from Open, On Hold, Duplicate, or Rejected:TODAY()
- Status changes to Open, On Hold, Duplicate, or Rejected,null</description>
        <field>AgileVizArt__Doing_Date__c</field>
        <formula>IF(
AND(
OR(
ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;)
),
ISNULL(AgileVizArt__Doing_Date__c)
)
,TODAY()
,IF(
AND(
OR(
ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;On Hold&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Duplicate&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Rejected&quot;)
)
)
,NULL
,AgileVizArt__Doing_Date__c
)
)</formula>
        <name>User Story Doing Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__User_Story_Done_Date</fullName>
        <description>- At the beginning empty.
- Status changes from any other status not equal to Closed or Done to Done or Closed:TODAY()
- Status changes to any other status not equal to Closed or Done:Null</description>
        <field>AgileVizArt__Done_Date__c</field>
        <formula>IF(
AND(
OR(
ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;)
),
ISNULL(AgileVizArt__Done_Date__c)
)
,TODAY()
,IF(
AND(
OR(
ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;On Hold&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Duplicate&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Rejected&quot;)
)
)
,NULL
,AgileVizArt__Done_Date__c
)
)</formula>
        <name>User Story Done Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__User_Story_Open_Date</fullName>
        <description>- User story is created:TODAY()
- Status changes to On Hold, Duplicate, or Rejected :Null
- Status changes from On Hold, Duplicate, or Rejected:TODAY()</description>
        <field>AgileVizArt__Open_Date__c</field>
        <formula>IF(
	AND(
		OR(
			ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;),
			ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;)
		),
		ISNULL(AgileVizArt__Open_Date__c)
	)
	,TODAY()
	,IF(
		AND(
			OR(
				ISPICKVAL(AgileVizArt__Status__c, &quot;On Hold&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Duplicate&quot;),
				ISPICKVAL(AgileVizArt__Status__c, &quot;Rejected&quot;)
			)
		)
		,NULL
		,AgileVizArt__Open_Date__c
	)
)</formula>
        <name>User Story Open Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AgileVizArt__User_Story_Review_Date</fullName>
        <description>- At the beginning empty.
- Status changes from Open, Doing, On Hold, Duplicate, or Rejected:TODAY().
- Status changes to Open, Doing, On Hold, Duplicate, or Rejected:null</description>
        <field>AgileVizArt__Review_Date__c</field>
        <formula>IF(
AND(
OR(
ISPICKVAL(AgileVizArt__Status__c, &quot;Review&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Done&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Closed&quot;)
),
ISNULL(AgileVizArt__Review_Date__c)
)
,TODAY()
,IF(
AND(
OR(
ISPICKVAL(AgileVizArt__Status__c, &quot;Open&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Doing&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;On Hold&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Duplicate&quot;),
ISPICKVAL(AgileVizArt__Status__c, &quot;Rejected&quot;)
)
)
,NULL
,AgileVizArt__Review_Date__c
)
)</formula>
        <name>User Story Review Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Default_Description</fullName>
        <field>AgileVizArt__Description__c</field>
        <formula>&quot;&lt;strong&gt;Requirements&lt;/strong&gt;&lt;img&gt;&lt;/img&gt;&lt;br&gt;&lt;br&gt;&lt;strong&gt;Schema Design&lt;/strong&gt;&lt;br&gt;&lt;br&gt;&lt;strong&gt;Process Design&lt;/strong&gt;&lt;br&gt;&lt;br&gt;&lt;strong&gt;Configuration Considerations&lt;/strong&gt;&lt;br&gt;&lt;br&gt;&lt;strong&gt;Implementation Considerations&lt;/strong&gt;&lt;br&gt;&lt;br&gt;&lt;strong&gt;Estimate&lt;/strong&gt;&lt;br&gt;&lt;br&gt;&lt;strong&gt;Recommendation&lt;/strong&gt;&lt;br&gt;&lt;br&gt;&quot;</formula>
        <name>Default Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AgileVizArt__Copy Description into Description %28without HTML%29</fullName>
        <actions>
            <name>AgileVizArt__Copy_to_Description_No_HTML</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies  HTML description into a second field to remove HTML tags</description>
        <formula>OR(ISNEW(), ISCHANGED( AgileVizArt__Description__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Default Sprint Rank</fullName>
        <actions>
            <name>AgileVizArt__Default_Sprint_Rank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Defaults sprint rank with rank</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Define Sync Priority</fullName>
        <actions>
            <name>AgileVizArt__Set_Sync_Priority</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Defaults Sync Priority checkbox in case epic story is empty.</description>
        <formula>AND(ISBLANK( AgileVizArt__Epic_Story__c ), ISBLANK( AgileVizArt__Master__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Enable Story Number Global Search</fullName>
        <actions>
            <name>AgileVizArt__Copy_Story_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies story number into a text field to enable global search by story number</description>
        <formula>OR(ISBLANK( AgileVizArt__Story_Number_Text__c ), ISNEW(), ISCHANGED( RecordTypeId ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__New User Story Assignment</fullName>
        <actions>
            <name>AgileVizArt__Notify_assignee_about_new_user_story</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends a notification when assignment changes, but only if assignee is different from modifier</description>
        <formula>AND(OR(ISNEW(), ISCHANGED( AgileVizArt__Assigned_To__c)),  LastModifiedById !=  AgileVizArt__Assigned_To__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__New User Story Assignment for Delegate</fullName>
        <actions>
            <name>AgileVizArt__Notify_delegate_about_new_user_story</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends a notification to delegate</description>
        <formula>OR( AND(ISNEW(), NOT( ISNULL(AgileVizArt__Delegated_To__c)) ), ISCHANGED(  AgileVizArt__Delegated_To__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Populate Done Date</fullName>
        <actions>
            <name>AgileVizArt__User_Story_Doing_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AgileVizArt__User_Story_Done_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AgileVizArt__User_Story_Open_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>AgileVizArt__User_Story_Review_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Calculates done date when story status changed(Open/Doing/Review/Done/Closed) .</description>
        <formula>OR(ISNEW(), ISCHANGED(AgileVizArt__Status__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Populate Sprint Assignment Date</fullName>
        <actions>
            <name>AgileVizArt__Sprint_Assignment_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Add a workflow rule that sets sprint assignment date to TODAY() whenever sprint lookup is changed and populated (even during insert), set it to null whenever sprint lookup is empty.</description>
        <formula>OR(ISNEW(), ISCHANGED(AgileVizArt__Sprint__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Update - Notify Assignee</fullName>
        <actions>
            <name>AgileVizArt__Notify_assignee_about_user_story_update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends a notification assigned to user when user story record is updated</description>
        <formula>AND( 	NOT(ISNEW()),  	NOT(ISCHANGED( AgileVizArt__Assigned_To__c )), 	LastModifiedById !=  AgileVizArt__Assigned_To__c,  	OR( 		ISCHANGED(AgileVizArt__Assigned_To__c),  		ISCHANGED(AgileVizArt__Delegated_To__c),  		ISCHANGED(AgileVizArt__Status__c),  		ISCHANGED(Name),  		ISCHANGED(AgileVizArt__Description__c),  		ISCHANGED(AgileVizArt__Last_Comment_Update__c) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Update - Notify Creator</fullName>
        <actions>
            <name>AgileVizArt__Notifies_creator_user_story_update</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends a notification to creator when user story record is updated</description>
        <formula>AND( 	NOT(ISNEW()), 	LastModifiedById != CreatedById,  	CreatedById !=  AgileVizArt__Assigned_To__c,  CreatedById  !=  AgileVizArt__Raised_By__c, 	OR( 		ISCHANGED(AgileVizArt__Assigned_To__c),  		ISCHANGED(AgileVizArt__Delegated_To__c),  		ISCHANGED(AgileVizArt__Status__c),  		ISCHANGED(Name),  		ISCHANGED(AgileVizArt__Description__c),  		ISCHANGED(AgileVizArt__Last_Comment_Update__c) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Update - Notify Delegate</fullName>
        <actions>
            <name>AgileVizArt__Notify_delegate_about_user_story_update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends a notification delegated to user when user story record is updated</description>
        <formula>AND( 	NOT(ISNEW()),  	NOT(ISCHANGED( AgileVizArt__Delegated_To__c )), 	OR( 		ISCHANGED(AgileVizArt__Assigned_To__c),  		ISCHANGED(AgileVizArt__Delegated_To__c),  		ISCHANGED(AgileVizArt__Status__c),  		ISCHANGED(Name),  		ISCHANGED(AgileVizArt__Description__c),  		ISCHANGED(AgileVizArt__Last_Comment_Update__c) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AgileVizArt__Update - Notify Raiser</fullName>
        <actions>
            <name>AgileVizArt__Notifies_raiser_user_story_update</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends a notification to raised by user when user story record is updated</description>
        <formula>AND( 	NOT(ISNEW()), 	LastModifiedById !=  AgileVizArt__Raised_By__c, 	AgileVizArt__Raised_By__c !=  AgileVizArt__Assigned_To__c, 	OR( 		ISCHANGED(AgileVizArt__Assigned_To__c),  		ISCHANGED(AgileVizArt__Delegated_To__c),  		ISCHANGED(AgileVizArt__Status__c),  		ISCHANGED(Name),  		ISCHANGED(AgileVizArt__Description__c),  		ISCHANGED(AgileVizArt__Last_Comment_Update__c) 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Default Headings</fullName>
        <actions>
            <name>Default_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AgileVizArt__User_Story__c.AgileVizArt__Description__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
