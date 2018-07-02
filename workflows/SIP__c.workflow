<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SIP_Plan_Approved</fullName>
        <description>SIP Plan Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SIP_Templates/SIP_Plan_Approved</template>
    </alerts>
    <alerts>
        <fullName>SIP_Plan_Rejected</fullName>
        <description>SIP Plan Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>Initial_Submitter__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>SIP_Templates/SIP_Plan_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>AFG_Conversion_achieved_weighting_FE</fullName>
        <description>calculates the AFG conversion achieved weighting for FE plans</description>
        <field>Business_Driver_achieved_weighting__c</field>
        <formula>IF( Application_Focus_Conversion_Result__c &lt; Level_1_Application_Focus_Target__c , 0,

IF(Application_Focus_Conversion_Result__c &lt;= Level_2_Application_Focus_Target__c ,
((Application_Focus_Conversion_Result__c - Level_1_Application_Focus_Target__c) / (Level_2_Application_Focus_Target__c - Level_1_Application_Focus_Target__c ))*0.2,

IF(Application_Focus_Conversion_Result__c &lt;= Level_3_Application_Focus_Target__c ,
(((Application_Focus_Conversion_Result__c - Level_2_Application_Focus_Target__c) / (Level_3_Application_Focus_Target__c - Level_2_Application_Focus_Target__c ))*0.2)+0.2,0.4

)
)
)</formula>
        <name>AFG Conversion achieved weighting FE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Application_Focus_Achieved_Weighting</fullName>
        <description>calculates the AFG conversion Business Driver for AM,GAM,FE,SE,IS for SIP FY18</description>
        <field>Application_Focus_Achieved_Weighting__c</field>
        <formula>IF( Application_Focus_Conversion_Result__c &lt; Level_1_Application_Focus_Target__c , 0,

IF(Application_Focus_Conversion_Result__c &lt;= Level_2_Application_Focus_Target__c ,
((Application_Focus_Conversion_Result__c - Level_1_Application_Focus_Target__c) / (Level_2_Application_Focus_Target__c - Level_1_Application_Focus_Target__c ))*0.20,

IF(Application_Focus_Conversion_Result__c &lt;= Level_3_Application_Focus_Target__c ,
(((Application_Focus_Conversion_Result__c - Level_2_Application_Focus_Target__c) / (Level_3_Application_Focus_Target__c - Level_2_Application_Focus_Target__c ))*0.20)+0.20,0.4

)
)
)</formula>
        <name>Application Focus Achieved Weighting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calc_EPB_Dir_Rev_Ach_Weighting_FY_18</fullName>
        <field>EPB_Achieved_Weight__c</field>
        <formula>IF(AND(IF( Prev_Year_Dir_Bill_YTD__c == 0, 0,(( Current_Year_Direct_Bill_YTD__c + IF(Revenue_Adjustment_Direct__c &lt;&gt; 0,Revenue_Adjustment_Direct__c,0)) / Prev_Year_Dir_Bill_YTD__c ) -1) 
&gt; Level_3_Direct_Growth_Target__c, IF( Prev_Year_Dir_Bill_YTD__c == 0, 0,(( Current_Year_Direct_Bill_YTD__c + IF(Revenue_Adjustment_Direct__c &lt;&gt; 0,Revenue_Adjustment_Direct__c,0)) / Prev_Year_Dir_Bill_YTD__c ) -1) 
&lt;= Exceptional_Perf_Growth_Reve__c),
 0, 
IF(Exceptional_Perf_DIR_Growth_Target__c &lt; IF( Prev_Year_Dir_Bill_YTD__c == 0, 0,(( Current_Year_Direct_Bill_YTD__c + IF(Revenue_Adjustment_Direct__c &lt;&gt; 0,Revenue_Adjustment_Direct__c,0)) / Prev_Year_Dir_Bill_YTD__c ) -1) 
,0.25,0))</formula>
        <name>Calc EPB Dir. Rev. Ach. Weighting FY 18</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcualte_Exc_Forecast_Attainment_weigh</fullName>
        <field>EPB_Achieved_Weight__c</field>
        <formula>IF(Forecast_Attainment_Result__c &lt;= Level_3_Forecast_Attainment_Target__c,0,
IF(Forecast_Attainment_Result__c &gt;= Exceptional_Forecast_Attainment_Target__c,0.25,
(((Forecast_Attainment_Result__c - Level_3_Forecast_Attainment_Target__c) / 
(Exceptional_Forecast_Attainment_Target__c - Level_3_Forecast_Attainment_Target__c)) * 0.25)
))</formula>
        <name>Calcualte Exc. Forecast Attainment weigh</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calcul_EPB_Rev_Ach_Weig_AM_GAM_FY_18</fullName>
        <description>calculates the EPB Revenue Performance Achieved Weighting for AM and GAM plans.</description>
        <field>EPB_Achieved_Weight__c</field>
        <formula>IF(AND(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1) 
&gt; Level_3_Growth_Target__c, IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1) 
&lt;= Exceptional_Perf_Growth_Reve__c),
 0, 
IF(Exceptional_Perf_Growth_Reve__c &lt; IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1) 
,0.25,0))</formula>
        <name>Calcul. EPB Rev. Ach. Weig. AM/GAM FY 18</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_AFG_BD1_Achieved_Weighting</fullName>
        <description>calculates for SM plans the AFG conversion achieved weighting where AFG is BD 1</description>
        <field>Business_Driver_1_Achieved_Weighting__c</field>
        <formula>IF( Application_Focus_Conversion_Result__c &lt; Level_1_Application_Focus_Target__c , 0,

IF(Application_Focus_Conversion_Result__c &lt;= Level_2_Application_Focus_Target__c ,
((Application_Focus_Conversion_Result__c - Level_1_Application_Focus_Target__c) / (Level_2_Application_Focus_Target__c - Level_1_Application_Focus_Target__c ))*0.15,

IF(Application_Focus_Conversion_Result__c &lt;= Level_3_Application_Focus_Target__c ,
(((Application_Focus_Conversion_Result__c - Level_2_Application_Focus_Target__c) / (Level_3_Application_Focus_Target__c - Level_2_Application_Focus_Target__c ))*0.15)+0.15,0.3

)
)
)</formula>
        <name>Calculate AFG BD1 Achieved Weighting %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_AFG_BD_Achieved_Weighting</fullName>
        <description>calculates for AM and GAM plans the AFG conversion achieved weighting</description>
        <field>Business_Driver_1_Achieved_Weighting__c</field>
        <formula>IF( Application_Focus_Conversion_Result__c &lt; Level_1_Application_Focus_Target__c , 0, 

IF(Application_Focus_Conversion_Result__c &lt;= Level_2_Application_Focus_Target__c , 
((Application_Focus_Conversion_Result__c - Level_1_Application_Focus_Target__c) / (Level_2_Application_Focus_Target__c - Level_1_Application_Focus_Target__c ))*0.20, 

IF(Application_Focus_Conversion_Result__c &lt;= Level_3_Application_Focus_Target__c , 
(((Application_Focus_Conversion_Result__c - Level_2_Application_Focus_Target__c) / (Level_3_Application_Focus_Target__c - Level_2_Application_Focus_Target__c ))*0.2)+0.2,0.4 

) 
) 
)</formula>
        <name>Calculate AFG BD Achieved Weighting %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Appl_focused_result</fullName>
        <description>calculates the % of Application focused result</description>
        <field>Application_Focus__c</field>
        <formula>IF ( Prev_Year_YTD_Appl_Focus_Billings__c  =0,0,
((Plan_Year_YTD_Appl_Focus_Billings__c+
IF(
 Application_Focus_Adjustment__c&lt;&gt;0,
Application_Focus_Adjustment__c,0))
  /  
Prev_Year_YTD_Appl_Focus_Billings__c)-1 )</formula>
        <name>Calculate Appl. focused result %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_BD1_Achieved_weighting_IM</fullName>
        <field>Business_Driver_1_Achieved_Weighting__c</field>
        <formula>IF( Business_Driver_1_Result__c &lt; Level_1_Business_Driver_1__c , 0,

IF(Business_Driver_1_Result__c &lt;= Level_2_Business_Driver_1__c ,
((Business_Driver_1_Result__c - Level_1_Business_Driver_1__c) / (Level_2_Business_Driver_1__c - Level_1_Business_Driver_1__c ))*0.15,

IF(Business_Driver_1_Result__c &lt;= Level_3_Business_Driver_1__c ,
(((Business_Driver_1_Result__c - Level_2_Business_Driver_1__c) / (Level_3_Business_Driver_1__c - Level_2_Business_Driver_1__c ))*0.15)+0.15,0.3

)
)
)</formula>
        <name>Calculate BD1 Achieved weighting% IM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_BD2_Achieved_weighting_IM</fullName>
        <description>updates the achieved weighting for BD 2</description>
        <field>Business_Driver_2_Achieved_Weighting__c</field>
        <formula>IF( Business_Driver_2_Result__c &lt; Level_1_Business_Driver_2__c , 0,

IF(Business_Driver_2_Result__c &lt;= Level_2_Business_Driver_2__c ,
((Business_Driver_2_Result__c - Level_1_Business_Driver_2__c) / (Level_2_Business_Driver_2__c - Level_1_Business_Driver_2__c ))*0.15,

IF(Business_Driver_2_Result__c &lt;= Level_3_Business_Driver_2__c ,
(((Business_Driver_2_Result__c - Level_2_Business_Driver_2__c) / (Level_3_Business_Driver_2__c - Level_2_Business_Driver_2__c ))*0.15)+0.15,0.3

)
)
)</formula>
        <name>Calculate BD2 Achieved weighting% IM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_BD_POS_DSE_achieved_weighting</fullName>
        <description>calculates the weighting for the business driver for DSE - POS in specific region</description>
        <field>BD_POS_achieved_weighting__c</field>
        <formula>IF( Result_POS_in_specific_region__c &lt; Level_1_POS_in_specific_Region__c , 0,

IF(Result_POS_in_specific_region__c &lt;= Level_2_POS_in_specific_Region__c ,
((Result_POS_in_specific_region__c - Level_1_POS_in_specific_Region__c) / (Level_2_POS_in_specific_Region__c - Level_1_POS_in_specific_Region__c ))*0.3,

IF(Result_POS_in_specific_region__c &lt;= Level_3_POS_in_specific_Region__c ,
(((Result_POS_in_specific_region__c - Level_2_POS_in_specific_Region__c) / (Level_3_POS_in_specific_Region__c - Level_2_POS_in_specific_Region__c ))*0.3)+0.3,0.6

)
)
)</formula>
        <name>Calculate BD POS DSE achieved weighting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_BD_achieved_weighting_FAE</fullName>
        <field>Business_Driver_achieved_weighting__c</field>
        <formula>IF( Business_Driver_1_Result__c &lt; Level_1_Business_Driver__c , 0,

IF(Business_Driver_1_Result__c &lt;= Level_2_Business_Driver__c ,
((Business_Driver_1_Result__c - Level_1_Business_Driver__c) / (Level_2_Business_Driver__c - Level_1_Business_Driver__c ))*0.20,

IF(Business_Driver_1_Result__c &lt;= Level_3_Business_Driver__c ,
(((Business_Driver_1_Result__c - Level_2_Business_Driver__c) / (Level_3_Business_Driver__c - Level_2_Business_Driver__c ))*0.20)+0.20,0.4

)
)
)</formula>
        <name>Calculate BD achieved weighting FAE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_BDr1_Achieved_weighting_IM</fullName>
        <description>updates the achieved weighting for BD 1</description>
        <field>Business_Driver_achieved_weighting__c</field>
        <formula>IF( Business_Driver_1_Result__c &lt; Level_1_Business_Driver_1__c , 0,

IF(Business_Driver_1_Result__c &lt;= Level_2_Business_Driver_1__c ,
((Business_Driver_1_Result__c - Level_1_Business_Driver_1__c) / (Level_2_Business_Driver_1__c - Level_1_Business_Driver_1__c ))*0.15,

IF(Business_Driver_1_Result__c &lt;= Level_3_Business_Driver_1__c ,
(((Business_Driver_1_Result__c - Level_2_Business_Driver_1__c) / (Level_3_Business_Driver_1__c - Level_2_Business_Driver_1__c ))*0.15)+0.15,0.3

)
)
)</formula>
        <name>Calculate BDr1 Achieved weighting% IM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_BDriver_Achieved_weighting</fullName>
        <field>Business_Driver_achieved_weighting__c</field>
        <formula>IF(If( Prev_Year_YTD_Appl_Focus_Billings__c  == 0, 0,(( Plan_Year_YTD_Appl_Focus_Billings__c + IF( Application_Focus_Adjustment__c &lt;&gt; 0,Application_Focus_Adjustment__c,0) ) / Prev_Year_YTD_Appl_Focus_Billings__c)-1)&lt; Level_1_Business_Driver__c , 0,

IF(If(Prev_Year_YTD_Appl_Focus_Billings__c == 0, 0,(( Plan_Year_YTD_Appl_Focus_Billings__c + IF( Application_Focus_Adjustment__c &lt;&gt; 0,Application_Focus_Adjustment__c,0) ) / Prev_Year_YTD_Appl_Focus_Billings__c)-1)&lt;= Level_2_Business_Driver__c ,

(((If(Prev_Year_YTD_Appl_Focus_Billings__c == 0, 0,(( Plan_Year_YTD_Appl_Focus_Billings__c + IF( Application_Focus_Adjustment__c &lt;&gt; 0,Application_Focus_Adjustment__c,0) ) / Prev_Year_YTD_Appl_Focus_Billings__c)-1)- Level_1_Business_Driver__c )/
(Level_2_Business_Driver__c - Level_1_Business_Driver__c )) * 0.20),
IF(
If(Prev_Year_YTD_Appl_Focus_Billings__c == 0, 0,(( Plan_Year_YTD_Appl_Focus_Billings__c + IF( Application_Focus_Adjustment__c &lt;&gt; 0,Application_Focus_Adjustment__c,0) ) / Prev_Year_YTD_Appl_Focus_Billings__c)-1)&lt;= Level_3_Business_Driver__c ,

((((If(Prev_Year_YTD_Appl_Focus_Billings__c == 0, 0,(( Plan_Year_YTD_Appl_Focus_Billings__c + IF( Application_Focus_Adjustment__c &lt;&gt; 0,Application_Focus_Adjustment__c,0) ) / Prev_Year_YTD_Appl_Focus_Billings__c)-1)- Level_2_Business_Driver__c )/
(Level_3_Business_Driver__c - Level_2_Business_Driver__c )) * 0.20)+ 0.20), 0.4
)))</formula>
        <name>Calculate BDriver Achieved weighting%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_BDriver_Achieved_weighting_IM</fullName>
        <description>for business driver with 30% weighting</description>
        <field>Business_Driver_achieved_weighting__c</field>
        <formula>IF( Business_Driver_1_Result__c &lt; Level_1_Business_Driver__c , 0,

IF(Business_Driver_1_Result__c &lt;= Level_2_Business_Driver__c ,
((Business_Driver_1_Result__c - Level_1_Business_Driver__c) / (Level_2_Business_Driver__c - Level_1_Business_Driver__c ))*0.3,

IF(Business_Driver_1_Result__c &lt;= Level_3_Business_Driver__c ,
(((Business_Driver_1_Result__c - Level_2_Business_Driver__c) / (Level_3_Business_Driver__c - Level_2_Business_Driver__c ))*0.3)+0.3,0.6

)
)
)</formula>
        <name>Calculate BDriver Achieved weighting% IM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Conv_POS_achieved_weighting</fullName>
        <field>Conversion_Result_Achieved_Weight__c</field>
        <formula>IF(If(Prev_Year_POS_Run_Rate_Result__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_POS_Run_Rate_Result__c)&lt; Level_1_Conversion_target__c , 0,

IF(If(Prev_Year_POS_Run_Rate_Result__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_POS_Run_Rate_Result__c)&lt;= Level_2_Conversion_Target__c ,

(((If(Prev_Year_POS_Run_Rate_Result__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_POS_Run_Rate_Result__c)- Level_1_Conversion_target__c )/
(Level_2_Conversion_Target__c - Level_1_Conversion_target__c )) * 0.20),
IF(
If(Prev_Year_POS_Run_Rate_Result__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_POS_Run_Rate_Result__c)&lt;= Level_3_Conversion_Target__c ,

((((If(Prev_Year_POS_Run_Rate_Result__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_POS_Run_Rate_Result__c)- Level_2_Conversion_Target__c )/
(Level_3_Conversion_Target__c - Level_2_Conversion_Target__c )) * 0.20)+ 0.20), 0.4
)))</formula>
        <name>Calculate Conv POS achieved weighting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Conv_weighting_53_weeks</fullName>
        <description>calculates the Conversion acheived weighting for a 53 weeks year</description>
        <field>Conversion_Result_Achieved_Weight__c</field>
        <formula>IF(If(Prev_Year_53_weeks_result__c== 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_53_weeks_result__c)&lt; Level_1_Conversion_target__c , 0,
IF(If(Prev_Year_53_weeks_result__c== 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_53_weeks_result__c)&lt;= Level_2_Conversion_Target__c ,
(((If(Prev_Year_53_weeks_result__c== 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_53_weeks_result__c)- Level_1_Conversion_target__c )/
(Level_2_Conversion_Target__c - Level_1_Conversion_target__c )) * 0.20),
IF(
If(Prev_Year_53_weeks_result__c== 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_53_weeks_result__c)&lt;= Level_3_Conversion_Target__c ,
((((If(Prev_Year_53_weeks_result__c== 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_53_weeks_result__c)- Level_2_Conversion_Target__c )/
(Level_3_Conversion_Target__c - Level_2_Conversion_Target__c )) * 0.20)+ 0.20), 0.4
)))</formula>
        <name>Calculate Conv weighting % 53 weeks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Conversion_Achieved_weighting</fullName>
        <field>Conversion_Result_Achieved_Weight__c</field>
        <formula>IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt; Level_1_Conversion_target__c , 0, 
IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_2_Conversion_Target__c , 
(((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_1_Conversion_target__c )/ 
(Level_2_Conversion_Target__c - Level_1_Conversion_target__c )) * 0.20), 
IF( 
If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_3_Conversion_Target__c , 
((((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_2_Conversion_Target__c )/ 
(Level_3_Conversion_Target__c - Level_2_Conversion_Target__c )) * 0.20)+ 0.20), 0.4 
)))</formula>
        <name>Calculate Conversion Achieved weighting%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Conversion_Result</fullName>
        <description>calculates the conversion result in %</description>
        <field>Conversion_Result_Percent__c</field>
        <formula>If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)</formula>
        <name>Calculate Conversion Result %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Conversion_Result_53_weeks</fullName>
        <description>calculates the conversion result in % for a 53 weeks year</description>
        <field>Conversion_Result_Percent__c</field>
        <formula>If( Prev_Year_53_weeks_result__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Prev_Year_53_weeks_result__c )</formula>
        <name>Calculate Conversion Result % 53 weeks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Conversion_ach_weighting_IM</fullName>
        <description>conversion achieved weighting Industry Marketing</description>
        <field>Conversion_Result_Achieved_Weight__c</field>
        <formula>IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt; Level_1_Conversion_target__c , 0,

IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_2_Conversion_Target__c ,

(((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_1_Conversion_target__c )/
(Level_2_Conversion_Target__c - Level_1_Conversion_target__c )) * 0.50),
IF(
If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_3_Conversion_Target__c ,
((((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_2_Conversion_Target__c )/
(Level_3_Conversion_Target__c - Level_2_Conversion_Target__c )) * 0.50)+ 0.50), 1
)))</formula>
        <name>Calculate Conversion ach. weighting IM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Direct_Rev_Ach_Weight_FY18</fullName>
        <field>Rev_Perf_Direct_Achieved_Weighting__c</field>
        <formula>IF(IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) / Prev_Year_Dir_Bill_YTD__c) -1) &lt; Level_1_Direct_Growth_Target__c, 0,

IF(IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) / Prev_Year_Dir_Bill_YTD__c) -1) &lt;= Level_2_Direct_Growth_Target__c,

(((IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) / Prev_Year_Dir_Bill_YTD__c) -1) - Level_1_Direct_Growth_Target__c )/
(Level_2_Direct_Growth_Target__c - Level_1_Direct_Growth_Target__c )) * 0.4),

IF(IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) / Prev_Year_Dir_Bill_YTD__c) -1) &lt;= Level_3_Direct_Growth_Target__c ,

((((IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) / Prev_Year_Dir_Bill_YTD__c) -1) - Level_2_Direct_Growth_Target__c )/
(Level_3_Direct_Growth_Target__c - Level_2_Direct_Growth_Target__c )) * 0.4)+ 0.4), 0.8
)))</formula>
        <name>Calculate Direct Rev Ach. Weight FY18</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Direct_Revenue_Achieved_Weight</fullName>
        <description>Calculates the Direct Revenue Achived weighting for IND Channel record types (FY17)</description>
        <field>Rev_Perf_Direct_Achieved_Weighting__c</field>
        <formula>IF(IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) /  Prev_Year_Dir_Bill_YTD__c) -1) &lt; Level_1_Direct_Growth_Target__c, 0, 
IF(IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) /  Prev_Year_Dir_Bill_YTD__c) -1) &lt;= Level_2_Direct_Growth_Target__c, 
(((IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) /  Prev_Year_Dir_Bill_YTD__c) -1) - Level_1_Direct_Growth_Target__c )/ 
(Level_2_Direct_Growth_Target__c - Level_1_Direct_Growth_Target__c )) * 0.15), 
IF(IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) /  Prev_Year_Dir_Bill_YTD__c) -1) &lt;= Level_3_Direct_Growth_Target__c , 
((((IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) /  Prev_Year_Dir_Bill_YTD__c) -1) - Level_2_Direct_Growth_Target__c )/ 
(Level_3_Direct_Growth_Target__c - Level_2_Direct_Growth_Target__c )) * 0.15)+ 0.15), 0.3 
)))</formula>
        <name>Calculate Direct Revenue Achieved Weight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Direct_Revenue_Growth</fullName>
        <description>calculates the direct revenue Growth in %</description>
        <field>Plan_Year_Growth_Direct__c</field>
        <formula>IF(Prev_Year_Dir_Bill_YTD__c== 0, 0,(( Current_Year_Direct_Bill_YTD__c+ IF(Revenue_Adjustment_Direct__c&lt;&gt; 0, Revenue_Adjustment_Direct__c,0)) /  Prev_Year_Dir_Bill_YTD__c) -1)</formula>
        <name>Calculate Direct Revenue Growth %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_EPB_GI_Achieved_Weighting</fullName>
        <field>EPB_Achieved_Weight__c</field>
        <formula>IF( Plan_Year_GI_Bill_YTD__c = 0,0, 
IF( Plan_Year_Total_Bill_YTD__c = 0,0,
IF   (  ((Plan_Year_GI_Bill_YTD__c + GI_result_adjustment__c ) / 
Prev_Year_Total_Bill_YTD__c ) &lt;  Level_3_GI_Target__c, 0 ,
	IF (((Plan_Year_GI_Bill_YTD__c + GI_result_adjustment__c ) / 
Prev_Year_Total_Bill_YTD__c )  &lt;  Exceptional_Perf_GI_Target__c, 
		((((Plan_Year_GI_Bill_YTD__c + GI_result_adjustment__c ) / 
Prev_Year_Total_Bill_YTD__c )- Level_3_GI_Target__c)/( Exceptional_Perf_GI_Target__c - Level_3_GI_Target__c)  *  0.25),0.25
))
))</formula>
        <name>Calculate EPB GI Achieved Weighting %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_EPB_NPS3_Achieved_weighting</fullName>
        <description>calculates the EPB achived weighting based on NPS3 results (for FE)</description>
        <field>EPB_Achieved_Weight__c</field>
        <formula>IF(AND(IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0, ((Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))&gt; Level_3_NPS3_target__c, IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0, ((Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))&lt;= Exceptional_Perf_NPS3_Target__c), 
(((IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0, ((Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))- Level_3_NPS3_target__c )/ 
(Exceptional_Perf_NPS3_Target__c - Level_3_NPS3_target__c )) * 0.25), 
IF(Exceptional_Perf_NPS3_Target__c &lt; IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0, ((Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ))),0.25,0))</formula>
        <name>Calculate EPB NPS3 Achieved weighting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_EPB_Revenue_Achieved_weighting</fullName>
        <description>Calculate the EPB achived weighting rsult for revenue growth EPB elements.</description>
        <field>EPB_Achieved_Weight__c</field>
        <formula>IF(AND(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)
&gt; Level_3_Growth_Target__c, IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)
&lt;= Exceptional_Perf_Growth_Reve__c), 
(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)
- Level_3_Growth_Target__c )/ 
(Exceptional_Perf_Growth_Reve__c - Level_3_Growth_Target__c )) * 0.25), 
IF(Exceptional_Perf_Growth_Reve__c &lt; IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)
,0.25,0))</formula>
        <name>Calculate EPB Revenue Achieved weighting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_EPB_weighting_POS_non_linear</fullName>
        <field>EPB_Achieved_Weight__c</field>
        <formula>IF( Prev_Year_POS_Bill_YTD__c == 0, 0,

IF(((Current_Year_POS_Bill_YTD__c + IF(Revenue_Adjustment_POS__c &lt;&gt; 0,Current_Year_POS_Bill_YTD__c,0)) / Prev_Year_POS_Bill_YTD__c ) -1 &gt;= 0.15, 0.25,0

))</formula>
        <name>Calculate EPB weighting POS non linear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Exp_performance_weighting_POS</fullName>
        <description>exceptional perf Weighting based on POS</description>
        <field>EPB_Achieved_Weight__c</field>
        <formula>IF(AND(
IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1)
&gt; Level_3_POS_Growth_Target__c, 
IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1)
&lt;= Exceptional_Perf_POS_Growth_Target__c), 
(((
IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1)
- Level_3_POS_Growth_Target__c)/ 
(Exceptional_Perf_POS_Growth_Target__c - Level_3_POS_Growth_Target__c)) * 0.25), 
IF(Exceptional_Perf_POS_Growth_Target__c &lt; 
IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1)
,0.25,0))</formula>
        <name>Calculate Exp performance weighting POS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Forecast_Attainment_Ach_Weight</fullName>
        <description>Calculates the Forecast attainment Achived weighting results</description>
        <field>Forecast_Attainment_Achieved_Weighting__c</field>
        <formula>IF(Forecast_Attainment_Result__c &lt; Level_1_Forecast_Attainment_Target__c,0,
IF(Forecast_Attainment_Result__c &lt;= Level_2_Forecast_Attainment_Target__c,
(((Forecast_Attainment_Result__c - Level_1_Forecast_Attainment_Target__c)/ 
(Level_2_Forecast_Attainment_Target__c - Level_1_Forecast_Attainment_Target__c)) * 0.1),
IF(Forecast_Attainment_Result__c &lt;= Level_3_Forecast_Attainment_Target__c,
((((Forecast_Attainment_Result__c - Level_2_Forecast_Attainment_Target__c)/ 
(Level_3_Forecast_Attainment_Target__c - Level_2_Forecast_Attainment_Target__c)) * 0.1)+0.1),0.2
)))</formula>
        <name>Calculate Forecast Attainment Ach Weight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_GI_Achieved_Weighting</fullName>
        <field>GI_Result_Achieved_Weighting__c</field>
        <formula>IF(IF( Plan_Year_GI_Bill_YTD__c = 0,0, 
IF( Plan_Year_Total_Bill_YTD__c = 0,0, 
(((Plan_Year_GI_Bill_YTD__c + GI_result_adjustment__c ) / 
Prev_Year_Total_Bill_YTD__c ) 
)))
&lt; Level_1_GI_Target__c, 0,
 IF(IF( Plan_Year_GI_Bill_YTD__c = 0,0, 
IF( Plan_Year_Total_Bill_YTD__c = 0,0, 
(((Plan_Year_GI_Bill_YTD__c + GI_result_adjustment__c ) / 
Prev_Year_Total_Bill_YTD__c ) 
)))
&lt;= Level_2_GI_Target__c, 
(((IF( Plan_Year_GI_Bill_YTD__c = 0,0, 
IF( Plan_Year_Total_Bill_YTD__c = 0,0, 
(((Plan_Year_GI_Bill_YTD__c + GI_result_adjustment__c ) / 
Prev_Year_Total_Bill_YTD__c ) 
)))- Level_1_GI_Target__c)/ 
(Level_2_GI_Target__c - Level_1_GI_Target__c )) * 0.1), 

IF(IF( Plan_Year_GI_Bill_YTD__c = 0,0, 
IF( Plan_Year_Total_Bill_YTD__c = 0,0, 
(((Plan_Year_GI_Bill_YTD__c + GI_result_adjustment__c ) / 
Prev_Year_Total_Bill_YTD__c ) 
)))
&lt;= Level_3_GI_Target__c , 
((((IF( Plan_Year_GI_Bill_YTD__c = 0,0, 
IF( Plan_Year_Total_Bill_YTD__c = 0,0, 
(((Plan_Year_GI_Bill_YTD__c + GI_result_adjustment__c ) / 
Prev_Year_Total_Bill_YTD__c ) 
)))
- Level_2_GI_Target__c )/ 
(Level_3_GI_Target__c - Level_2_GI_Target__c )) * 0.1)+ 0.1), 0.2 
)))</formula>
        <name>Calculate GI Achieved Weighting %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_GI_Growth</fullName>
        <description>caculate the YTD Grow and Invest Revenue Growth</description>
        <field>Plan_Year_GI_Growth__c</field>
        <formula>IF( Plan_Year_GI_Bill_YTD__c = 0,0,
IF( Plan_Year_Total_Bill_YTD__c = 0,0,
((Plan_Year_GI_Bill_YTD__c  +  GI_result_adjustment__c ) / 
  Prev_Year_Total_Bill_YTD__c  )
))</formula>
        <name>Calculate GI Growth %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_NPS1_result</fullName>
        <description>calculate the NPS1 result as % of total revenue (all YTD)</description>
        <field>Plan_Year_NPS1_Result_Percent__c</field>
        <formula>IF(Plan_Year_Total_Bill_YTD__c == 0, 0,
IF(Plan_Year_NPS1_Result__c ==0,0, 
(Plan_Year_NPS1_Result__c / Plan_Year_Total_Bill_YTD__c)))</formula>
        <name>Calculate NPS1 result%</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_NPS3_Result</fullName>
        <description>calculates the NPS3 results for the plan year as NPS3 revenue as % of total revenue</description>
        <field>Plan_Year_NPS3_Result_Percent__c</field>
        <formula>IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0, ((Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))</formula>
        <name>Calculate NPS3 Result %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_NPS3_achieved_Weighting_FE</fullName>
        <description>calculates the achieved weighting of NPS3 results for FE based on 20% max weighting</description>
        <field>NPS3_Achieved_Weighting__c</field>
        <formula>IF(IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,( (Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))&lt; Level_1_NPS3_target__c , 0, 
IF(IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,( (Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))&lt;= Level_2_NPS3_target__c , 
(((IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,( (Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))- Level_1_NPS3_target__c )/ 
(Level_2_NPS3_target__c - Level_1_NPS3_target__c )) * 0.1), 
IF(IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,((Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))&lt;= Level_3_NPS3_target__c , 
((((IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,( (Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))- Level_2_NPS3_target__c )/ 
(Level_3_NPS3_target__c - Level_2_NPS3_target__c )) * 0.1)+ 0.1), 0.2 
)))</formula>
        <name>Calculate NPS3 achieved Weighting % FE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_NPS3_achieved_Weighting_PM</fullName>
        <field>NPS3_Achieved_Weighting__c</field>
        <formula>IF(IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,( (Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))&lt; Level_1_NPS3_target__c , 0, 
IF(IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,( (Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))&lt;= Level_2_NPS3_target__c , 
(((IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,( (Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))- Level_1_NPS3_target__c )/ 
(Level_2_NPS3_target__c - Level_1_NPS3_target__c )) * 0.05), 
IF(IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,((Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))&lt;= Level_3_NPS3_target__c , 
((((IF(( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c ) = 0,0,( (Plan_Year_NPS3_Result__c + NPS3_Result_Adjustment__c) / ( Current_Year_Direct_Bill_YTD__c + Current_Year_POS_Bill_YTD__c )))- Level_2_NPS3_target__c )/ 
(Level_3_NPS3_target__c - Level_2_NPS3_target__c )) * 0.05)+ 0.05), 0.1 
)))</formula>
        <name>Calculate NPS3 achieved Weighting % PM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_NPS_achieved_Weighting</fullName>
        <description>calculates the achieved weighting of NPS results</description>
        <field>NPS_Achieved_Weighting__c</field>
        <formula>IF(ISBLANK(NPS_Result__c),0,
IF(NPS_Result__c &lt; Level_1_NPS_target__c , 0,
IF(NPS_Result__c &lt;= Level_2_NPS_target__c ,
(((NPS_Result__c - Level_1_NPS_target__c )/
(Level_2_NPS_target__c - Level_1_NPS_target__c )) * 0.05),
IF(
NPS_Result__c &lt;= Level_3_NPS_target__c ,
((((NPS_Result__c - Level_2_NPS_target__c )/
(Level_3_NPS_target__c - Level_2_NPS_target__c )) * 0.05)+ 0.05), 0.1
))))</formula>
        <name>Calculate NPS achieved Weighting %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_POS_BD2_Achieved_Weighting</fullName>
        <description>calculates the weighting for POS in specific Regionfor SM plans as BD2</description>
        <field>Business_Driver_2_Achieved_Weighting__c</field>
        <formula>IF( Result_POS_in_specific_region__c &lt; Level_1_POS_in_specific_Region__c , 0,

IF(Result_POS_in_specific_region__c &lt;= Level_2_POS_in_specific_Region__c ,
((Result_POS_in_specific_region__c - Level_1_POS_in_specific_Region__c) / (Level_2_POS_in_specific_Region__c - Level_1_POS_in_specific_Region__c ))*0.15,

IF(Result_POS_in_specific_region__c &lt;= Level_3_POS_in_specific_Region__c ,
(((Result_POS_in_specific_region__c - Level_2_POS_in_specific_Region__c) / (Level_3_POS_in_specific_Region__c - Level_2_POS_in_specific_Region__c ))*0.15)+0.15,0.3

)
)
)</formula>
        <name>Calculate POS BD2 Achieved Weighting %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_POS_Conversion_Result</fullName>
        <field>Conversion_Result_Percent__c</field>
        <formula>If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)</formula>
        <name>Calculate POS Conversion Result %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_POS_Rev_Achi_weighting_FY18</fullName>
        <field>Rev_Perf_POS_Achieved_Weighting__c</field>
        <formula>IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) &lt; Level_1_POS_Growth_Target__c, 0,

IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) &lt;= Level_2_POS_Growth_Target__c,

(((IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) - Level_1_POS_Growth_Target__c )/
(Level_2_POS_Growth_Target__c - Level_1_POS_Growth_Target__c )) * 0.4),

IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) &lt;= Level_3_POS_Growth_Target__c ,

((((IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) - Level_2_POS_Growth_Target__c )/
(Level_3_POS_Growth_Target__c - Level_2_POS_Growth_Target__c )) * 0.4)+ 0.4), 0.8
)))</formula>
        <name>Calculate POS Rev Achi weighting FY18</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_POS_Revenue_Achieved_Weight</fullName>
        <description>Calculates the POS achieved weighting (For FY17 Channel plans)</description>
        <field>Rev_Perf_POS_Achieved_Weighting__c</field>
        <formula>IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1) &lt; Level_1_POS_Growth_Target__c, 0, 
IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1) &lt;= Level_2_POS_Growth_Target__c, 
(((IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1) - Level_1_POS_Growth_Target__c )/ 
(Level_2_POS_Growth_Target__c - Level_1_POS_Growth_Target__c )) * 0.15), 
IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1) &lt;= Level_3_POS_Growth_Target__c , 
((((IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1) - Level_2_POS_Growth_Target__c )/ 
(Level_3_POS_Growth_Target__c - Level_2_POS_Growth_Target__c )) * 0.15)+ 0.15), 0.3 
)))</formula>
        <name>Calculate POS Revenue Achieved Weight</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_POS_Revenue_Growth</fullName>
        <description>Calcaultes the POS revenue Growth (FY17 IND Channel records)</description>
        <field>Plan_Year_Growth_POS__c</field>
        <formula>IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) /  Prev_Year_POS_Bill_YTD__c) -1)</formula>
        <name>Calculate POS Revenue Growth %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_POS_ach_weight_DSE</fullName>
        <description>POS achieved weighting DSE FY 18</description>
        <field>Rev_Perf_POS_Achieved_Weighting__c</field>
        <formula>IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) &lt; Level_1_POS_Growth_Target__c, 0,

IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) &lt;= Level_2_POS_Growth_Target__c,

(((IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) - Level_1_POS_Growth_Target__c )/
(Level_2_POS_Growth_Target__c - Level_1_POS_Growth_Target__c )) * 0.5),

IF(IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) &lt;= Level_3_POS_Growth_Target__c ,

((((IF(Prev_Year_POS_Bill_YTD__c== 0, 0,(( Current_Year_POS_Bill_YTD__c+ IF(Revenue_Adjustment_POS__c&lt;&gt; 0, Revenue_Adjustment_POS__c,0)) / Prev_Year_POS_Bill_YTD__c) -1) - Level_2_POS_Growth_Target__c )/
(Level_3_POS_Growth_Target__c - Level_2_POS_Growth_Target__c )) * 0.5)+ 0.5), 1
)))</formula>
        <name>Calculate POS ach weight DSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Pipeline_Result</fullName>
        <description>calculates the pipeline results in %</description>
        <field>Pipeline_Result_Percent__c</field>
        <formula>IF(Total_Revenue_Baseline__c == 0, 0,( Pipeline_Result__c + IF(Pipeline_Adjustment__c &lt;&gt; 0,Pipeline_Adjustment__c,0)) / Total_Revenue_Baseline__c)</formula>
        <name>Calculate Pipeline Result %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Plan_year_RevenueGrowth</fullName>
        <description>calculates the billing growth based on run rate, used in FY14 SIP record</description>
        <field>Plan_Year_Growth__c</field>
        <formula>IF(Total_Revenue_Baseline__c == 0, 0,((Plan_Year_Total_Bill_Run_Rate__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Total_Revenue_Baseline__c) -1)</formula>
        <name>Calculate Plan year RevenueGrowth% old</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Plan_year_RevenueGrowth_FY18</fullName>
        <description>caculate the plan year revenue growth based on YTD data</description>
        <field>Plan_Year_Growth__c</field>
        <formula>IF(Prev_Year_Total_Bill_YTD__c  = 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c  ) -1)</formula>
        <name>Calculate Plan year RevenueGrowth %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Rev_Perf_Ach_Weighting_PM18</fullName>
        <field>Rev_Perf_Achieved_Weighting__c</field>
        <formula>IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt; Level_1_Growth_Target__c , 0,

IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_2_Growth_Target__c ,

(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_1_Growth_Target__c )/
(Level_2_Growth_Target__c - Level_1_Growth_Target__c )) * 0.4),

IF( IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_3_Growth_Target__c ,

((((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_2_Growth_Target__c )/
(Level_3_Growth_Target__c - Level_2_Growth_Target__c )) * 0.4)+ 0.4), 0.8
)))</formula>
        <name>Calculate Rev Perf Ach Weighting PM18</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Rev_Perf_Achieved_Weighting</fullName>
        <description>calculates the Revenue Performance Achieved Weighting for AM,GAM,SE,FE,IS for SIP FY18</description>
        <field>Rev_Perf_Achieved_Weighting__c</field>
        <formula>IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)&lt; Level_1_Growth_Target__c , 0, 
IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_2_Growth_Target__c , 
(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)- Level_1_Growth_Target__c )/ 
(Level_2_Growth_Target__c - Level_1_Growth_Target__c )) * 0.6), 
IF( IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_3_Growth_Target__c , 
((((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)- Level_2_Growth_Target__c )/ 
(Level_3_Growth_Target__c - Level_2_Growth_Target__c )) * 0.6)+ 0.6), 1.2
)))</formula>
        <name>Calculate Rev Perf Achieved Weighting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_Rev_Perf_Achieved_Weighting_PM</fullName>
        <field>Rev_Perf_Achieved_Weighting__c</field>
        <formula>IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)&lt; Level_1_Growth_Target__c , 0, 
IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_2_Growth_Target__c , 
(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)- Level_1_Growth_Target__c )/ 
(Level_2_Growth_Target__c - Level_1_Growth_Target__c )) * 0.15), 
IF( IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_3_Growth_Target__c , 
((((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) /  Prev_Year_Total_Bill_YTD__c ) -1)- Level_2_Growth_Target__c )/ 
(Level_3_Growth_Target__c - Level_2_Growth_Target__c )) * 0.15)+ 0.15), 0.3 
)))</formula>
        <name>Calculate Rev Perf Achieved Weighting PM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_SMI_Achieved_Weighting_PM_FY17</fullName>
        <field>GMI_Achieved_Weighting__c</field>
        <formula>IF((IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) &lt; Level_1_SMI_target__c, 0, 
IF((IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) &lt;= Level_2_SMI_target__c , 
((((IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) - Level_1_SMI_target__c )/ 
(Level_2_SMI_target__c - Level_1_SMI_target__c )) * 0.15), 
IF( 
(IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) &lt;= Level_3_SMI_target__c , 
(((((IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) - Level_2_SMI_target__c )/ 
(Level_3_SMI_target__c - Level_2_SMI_target__c )) * 0.15)+ 0.15), 0.3 
)))</formula>
        <name>Calculate SMI Achieved Weighting PM FY17</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_SMI_Achieved_Weighting_PM_FY18</fullName>
        <field>GMI_Achieved_Weighting__c</field>
        <formula>IF((IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) &lt; Level_1_SMI_target__c, 0,

IF((IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) &lt;= Level_2_SMI_target__c ,

((((IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) - Level_1_SMI_target__c )/
(Level_2_SMI_target__c - Level_1_SMI_target__c )) * 0.4),

IF(
(IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) &lt;= Level_3_SMI_target__c ,

(((((IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) / Prev_Year_Standard_Margin_YTD__c) -1)) - Level_2_SMI_target__c )/
(Level_3_SMI_target__c - Level_2_SMI_target__c )) * 0.4)+ 0.4), 0.8
)))</formula>
        <name>Calculate SMI Achieved Weighting PM FY18</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_SMI_Achieved_weighting_PM</fullName>
        <field>GMI_Achieved_Weighting__c</field>
        <formula>IF((IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c ) &lt; Level_1_SMI_target__c, 0, 
IF((IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c)&lt;= Level_2_SMI_target__c , 
((((IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c )- Level_1_SMI_target__c )/ 
(Level_2_SMI_target__c - Level_1_SMI_target__c )) * 0.15), 
IF( 
(IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c ) &lt;= Level_3_SMI_target__c , 
(((((IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c ) - Level_2_SMI_target__c )/ 
(Level_3_SMI_target__c - Level_2_SMI_target__c )) * 0.15)+ 0.15), 0.3 
)))</formula>
        <name>Calculate SMI Achieved weighting % PM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_SMI_Achieved_weighting_Sale</fullName>
        <description>calculate the SMI acheived weighting based on 10% weighting for sales</description>
        <field>GMI_Achieved_Weighting__c</field>
        <formula>IF((IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c  - Prev_Year_Restated_Margin__c) &lt; Level_1_SMI_target__c, 0, 
IF((IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c  - Prev_Year_Restated_Margin__c)&lt;= Level_2_SMI_target__c , 
((((IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c  - Prev_Year_Restated_Margin__c)- Level_1_SMI_target__c )/ 
(Level_2_SMI_target__c - Level_1_SMI_target__c )) * 0.05), 
IF( 
(IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c  - Prev_Year_Restated_Margin__c) &lt;= Level_3_SMI_target__c , 
(((((IF(SMI_Adjustment__c &lt;&gt; 0,SMI_Adjustment__c,0) +  Plan_Year_Standard_Margin_YTD__c  - Prev_Year_Restated_Margin__c) - Level_2_SMI_target__c )/ 
(Level_3_SMI_target__c - Level_2_SMI_target__c )) * 0.05)+ 0.05), 0.1 
)))</formula>
        <name>Calculate SMI Achieved weighting % Sale</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Calculate_SMI_Growth</fullName>
        <description>Calculate the SMI growth in percent based on previous Yaer YTD SMI versus Current Year SMI %</description>
        <field>Plan_Year_SMI_Growth__c</field>
        <formula>IF(Prev_Year_Standard_Margin_YTD__c== 0, 0,(( Plan_Year_Standard_Margin_YTD_Dollar__c + IF(SMI_Adjustment_Dollar__c&lt;&gt; 0, SMI_Adjustment_Dollar__c,0)) /  Prev_Year_Standard_Margin_YTD__c) -1)</formula>
        <name>Calculate SMI Growth %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Conversion_Achieved_Weighting_CCAO</fullName>
        <field>Conversion_Result_Achieved_Weight__c</field>
        <formula>IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt; Level_1_Conversion_target__c , 0,
IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_2_Conversion_Target__c ,
(((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_1_Conversion_target__c )/
(Level_2_Conversion_Target__c - Level_1_Conversion_target__c )) * 0.10),
IF(
If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_3_Conversion_Target__c ,
((((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_2_Conversion_Target__c )/
(Level_3_Conversion_Target__c - Level_2_Conversion_Target__c )) * 0.10)+ 0.10), 0.2
)))</formula>
        <name>Conversion Achieved Weighting CCAO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Conversion_Achieved_Weighting_Inside_sal</fullName>
        <description>Conversion Achieved Weighting  inside sales 30%</description>
        <field>Conversion_Result_Achieved_Weight__c</field>
        <formula>IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt; Level_1_Conversion_target__c , 0,
IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_2_Conversion_Target__c ,
(((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_1_Conversion_target__c )/
(Level_2_Conversion_Target__c - Level_1_Conversion_target__c )) * 0.15),
IF(
If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_3_Conversion_Target__c ,
((((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_2_Conversion_Target__c )/
(Level_3_Conversion_Target__c - Level_2_Conversion_Target__c )) * 0.15)+ 0.15), 0.3
)))</formula>
        <name>Conversion Achieved Weighting Inside sal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Conversion_achieved_weighting_FE</fullName>
        <description>achieved weighting for conversion for FE</description>
        <field>Conversion_Result_Achieved_Weight__c</field>
        <formula>IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt; Level_1_Conversion_target__c , 0,
IF(If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_2_Conversion_Target__c ,
(((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_1_Conversion_target__c )/
(Level_2_Conversion_Target__c - Level_1_Conversion_target__c )) * 0.40),
IF(
If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)&lt;= Level_3_Conversion_Target__c ,
((((If(Total_Revenue_Baseline__c == 0, 0,( Conversion_result__c + IF( Plan_Year_Conversion_Result_Adjustment__c &lt;&gt; 0,Plan_Year_Conversion_Result_Adjustment__c,0) ) / Total_Revenue_Baseline__c)- Level_2_Conversion_Target__c )/
(Level_3_Conversion_Target__c - Level_2_Conversion_Target__c )) * 0.40)+ 0.40), 0.8
)))</formula>
        <name>Conversion achieved weighting % FE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Custom_Record_Lock</fullName>
        <field>Record_Locked__c</field>
        <literalValue>1</literalValue>
        <name>Custom Record Lock</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>In_Approval_Result</fullName>
        <description>updates the status field for in approval (results)</description>
        <field>Status__c</field>
        <literalValue>In Approval for Results</literalValue>
        <name>In Approval Result</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Country</fullName>
        <description>populate the country from the participants user record</description>
        <field>Participants_Country_Text__c</field>
        <formula>Plan_Participant__r.Country</formula>
        <name>Populate Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Region</fullName>
        <description>Populate the Region of the plan participant from the participants user record.</description>
        <field>Participants_Region_Text__c</field>
        <formula>TEXT(Plan_Participant__r.Region__c)</formula>
        <name>Populate Region</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Sub_Vertical</fullName>
        <description>populates the subvertical BU from the participants user record in the related field</description>
        <field>Participants_Subvertical_Text__c</field>
        <formula>TEXT(Plan_Participant__r.Sub_Vertical__c)</formula>
        <name>Populate Sub Vertical</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Status_to_not_submitted</fullName>
        <description>resets the status field on SIP to &apos;not submitted&apos;</description>
        <field>Status__c</field>
        <literalValue>Not Submitted</literalValue>
        <name>Reset Status to not submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rev_Perf_Ach_Weighting_FY18_AMGAM</fullName>
        <description>for AM GAM Inside Sales</description>
        <field>Rev_Perf_Achieved_Weighting__c</field>
        <formula>IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt; Level_1_Growth_Target__c , 0,

IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_2_Growth_Target__c ,

(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_1_Growth_Target__c )/
(Level_2_Growth_Target__c - Level_1_Growth_Target__c )) * 0.6),

IF( IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_3_Growth_Target__c ,

((((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_2_Growth_Target__c )/
(Level_3_Growth_Target__c - Level_2_Growth_Target__c )) * 0.6)+ 0.6), 1.2
)))</formula>
        <name>Rev. Perf. Ach Weighting FY18 AMGAM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rev_Perf_Ach_Weighting_FY18_FE</fullName>
        <description>for FE</description>
        <field>Rev_Perf_Achieved_Weighting__c</field>
        <formula>IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt; Level_1_Growth_Target__c , 0,

IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_2_Growth_Target__c ,

(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_1_Growth_Target__c )/
(Level_2_Growth_Target__c - Level_1_Growth_Target__c )) * 0.4),

IF( IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_3_Growth_Target__c ,

((((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_2_Growth_Target__c )/
(Level_3_Growth_Target__c - Level_2_Growth_Target__c )) * 0.4)+ 0.4), 0.8
)))</formula>
        <name>Rev. Perf. Ach Weighting FY18 FE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rev_Perf_Achieved_Weighting_DSE</fullName>
        <description>for DSE plan</description>
        <field>Rev_Perf_Achieved_Weighting__c</field>
        <formula>IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt; Level_1_Growth_Target__c , 0,

IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_2_Growth_Target__c ,

(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_1_Growth_Target__c )/
(Level_2_Growth_Target__c - Level_1_Growth_Target__c )) * 0.5),

IF( IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_3_Growth_Target__c ,

((((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_2_Growth_Target__c )/
(Level_3_Growth_Target__c - Level_2_Growth_Target__c )) * 0.5)+ 0.5), 1.0
)))</formula>
        <name>Rev. Perf. Achieved Weighting DSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rev_Perf_Achieved_Weighting_FY18_SM</fullName>
        <description>for AM GAM SM Inside Sales</description>
        <field>Rev_Perf_Achieved_Weighting__c</field>
        <formula>IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt; Level_1_Growth_Target__c , 0,

IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_2_Growth_Target__c ,

(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_1_Growth_Target__c )/
(Level_2_Growth_Target__c - Level_1_Growth_Target__c )) * 0.5),

IF( IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_3_Growth_Target__c ,

((((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_2_Growth_Target__c )/
(Level_3_Growth_Target__c - Level_2_Growth_Target__c )) * 0.5)+ 0.5), 1.0
)))</formula>
        <name>Rev. Perf. Ach Weighting FY18 SM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rev_Perf_Achieved_Weighting_IMM</fullName>
        <description>calculated the revenue performance achieved weighting for IMM plans</description>
        <field>Rev_Perf_Achieved_Weighting_IMM__c</field>
        <formula>IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt; Level_1_Growth_Target__c , 0,
IF(IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_2_Growth_Target__c ,
(((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_1_Growth_Target__c )/
(Level_2_Growth_Target__c - Level_1_Growth_Target__c )) * 0.2),
IF( IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)&lt;= Level_3_Growth_Target__c ,
((((IF( Prev_Year_Total_Bill_YTD__c == 0, 0,(( Plan_Year_Total_Bill_YTD__c + IF(Plan_Year_Revenue_Adjustment__c &lt;&gt; 0,Plan_Year_Revenue_Adjustment__c,0)) / Prev_Year_Total_Bill_YTD__c ) -1)- Level_2_Growth_Target__c )/
(Level_3_Growth_Target__c - Level_2_Growth_Target__c )) * 0.2)+ 0.2), 0.4
)))</formula>
        <name>Rev. Perf. Achieved Weighting IMM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SIP_Results_Completed</fullName>
        <description>sets the status field to results completed</description>
        <field>Status__c</field>
        <literalValue>Completed for Results</literalValue>
        <name>SIP Results Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SIP_Results_Rejected</fullName>
        <description>sets the value of the status field to Results rejected</description>
        <field>Status__c</field>
        <literalValue>Rejected for Results</literalValue>
        <name>SIP Results Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SIP_Target_Rejected</fullName>
        <description>resets the status field on SIP to &apos;rejected for target&apos;</description>
        <field>Status__c</field>
        <literalValue>Rejected for Target</literalValue>
        <name>SIP Target Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SIP_Target_approved</fullName>
        <description>resets the status field</description>
        <field>Status__c</field>
        <literalValue>Completed for Target</literalValue>
        <name>SIP Target approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SIP_in_approval</fullName>
        <description>sets the status field on SIP to &apos;in approval&apos;</description>
        <field>Status__c</field>
        <literalValue>In Approval for Target</literalValue>
        <name>SIP in approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SMI_Achieved_weighting_PM_Dollar</fullName>
        <description>SMI achieved weighting for PM&apos;s based on SMI $ targets, valid in FY16</description>
        <field>GMI_Achieved_Weighting__c</field>
        <formula>IF((IF(SMI_Adjustment_Dollar__c &lt;&gt; 0,SMI_Adjustment_Dollar__c,0) +  Plan_Year_Standard_Margin_YTD_Dollar__c ) &lt; Level_1_SMI_target_Dollar__c, 0, 
IF((IF(SMI_Adjustment_Dollar__c &lt;&gt; 0,SMI_Adjustment_Dollar__c,0) +  Plan_Year_Standard_Margin_YTD_Dollar__c)&lt;= Level_2_SMI_target_Dollar__c , 
((((IF(SMI_Adjustment_Dollar__c &lt;&gt; 0,SMI_Adjustment_Dollar__c,0) +  Plan_Year_Standard_Margin_YTD_Dollar__c )- Level_1_SMI_target_Dollar__c )/ 
(Level_2_SMI_target_Dollar__c - Level_1_SMI_target_Dollar__c )) * 0.15), 
IF( 
(IF(SMI_Adjustment_Dollar__c &lt;&gt; 0,SMI_Adjustment_Dollar__c,0) +  Plan_Year_Standard_Margin_YTD_Dollar__c ) &lt;= Level_3_SMI_target_Dollar__c , 
(((((IF(SMI_Adjustment_Dollar__c &lt;&gt; 0,SMI_Adjustment_Dollar__c,0) +  Plan_Year_Standard_Margin_YTD_Dollar__c ) - Level_2_SMI_target_Dollar__c )/ 
(Level_3_SMI_target_Dollar__c - Level_2_SMI_target_Dollar__c )) * 0.15)+ 0.15), 0.3 
)))</formula>
        <name>Calculate SMI Achieved weighting % PM $</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_initial_submitter_mail</fullName>
        <description>updates the field &apos;Initial submitter&apos;</description>
        <field>Initial_Submitter__c</field>
        <formula>$User.Email</formula>
        <name>Set initial submitter mail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>calculate_NPS1_achieved_weighting</fullName>
        <description>calculate the NPS1 achieved weighting for PM records in FY17</description>
        <field>NPS1_Achieved_Weighting__c</field>
        <formula>IF(IF(Plan_Year_Total_Bill_YTD__c == 0, 0, 
IF(Plan_Year_NPS1_Result__c ==0,0, 
(Plan_Year_NPS1_Result__c / Plan_Year_Total_Bill_YTD__c)))
&lt; Level_1_NPS1_target__c , 0, 
IF(IF(Plan_Year_Total_Bill_YTD__c == 0, 0, 
IF(Plan_Year_NPS1_Result__c ==0,0, 
(Plan_Year_NPS1_Result__c / Plan_Year_Total_Bill_YTD__c)))
&lt;= Level_2_NPS1_target__c , 
(((IF(Plan_Year_Total_Bill_YTD__c == 0, 0, 
IF(Plan_Year_NPS1_Result__c ==0,0, 
(Plan_Year_NPS1_Result__c / Plan_Year_Total_Bill_YTD__c)))
- Level_1_NPS1_target__c )/ 
(Level_2_NPS1_target__c - Level_1_NPS1_target__c )) * 0.1), 
IF(IF(Plan_Year_Total_Bill_YTD__c == 0, 0, 
IF(Plan_Year_NPS1_Result__c ==0,0, 
(Plan_Year_NPS1_Result__c / Plan_Year_Total_Bill_YTD__c)))
&lt;= Level_3_NPS1_target__c , 
((((IF(Plan_Year_Total_Bill_YTD__c == 0, 0, 
IF(Plan_Year_NPS1_Result__c ==0,0, 
(Plan_Year_NPS1_Result__c / Plan_Year_Total_Bill_YTD__c)))
- Level_2_NPS1_target__c )/ 
(Level_3_NPS1_target__c - Level_2_NPS1_target__c )) * 0.1)+ 0.1), 0.2 
)))</formula>
        <name>calculate NPS1 achieved weighting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Calculate Conversion Result %25</fullName>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>calculates the conversion results in % in relation to last year revenues, was used for FY14 records and deactivated because all FY14 records are closed.</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate PMIP  Results FY15  PM</fullName>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS3_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS3_achieved_Weighting_PM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting_PM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Achieved_weighting_PM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PM Plan FY15,PM CCAO FY15</value>
        </criteriaItems>
        <description>used in SIP for PMIP FY15 to calculate the results</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate PMIP  Results FY16  PM</fullName>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS3_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS3_achieved_Weighting_FE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting_PM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SMI_Achieved_weighting_PM_Dollar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PM Plan FY16</value>
        </criteriaItems>
        <description>used in SIP for PMIP FY16 to calculate the results</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate PMIP Results FY16  PM CCAO</fullName>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting_PM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Conversion_Achieved_Weighting_CCAO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SMI_Achieved_weighting_PM_Dollar</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PM CCAO FY16</value>
        </criteriaItems>
        <description>used in SIP for PMIP FY16 to calculate the results for the CCAO plans</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate PMIP Results FY17  PM</fullName>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS1_result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting_PM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Achieved_Weighting_PM_FY17</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Growth</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>calculate_NPS1_achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PM Plan FY17</value>
        </criteriaItems>
        <description>used in SIP for PMIP FY17 to calculate the results</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate PMIP Results FY17 PM CCAO</fullName>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting_PM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Achieved_Weighting_PM_FY17</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Growth</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Conversion_Achieved_Weighting_CCAO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PM CCAO FY17</value>
        </criteriaItems>
        <description>used in SIP for PMIP FY17 to calculate the results for the CCAO plans</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate PMIP Results FY18  PM</fullName>
        <actions>
            <name>Calcul_EPB_Rev_Ach_Weig_AM_GAM_FY_18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_BD_achieved_weighting_FAE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Ach_Weighting_PM18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Achieved_Weighting_PM_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Growth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PM Plan FY 18</value>
        </criteriaItems>
        <description>used in SIP for PMIP FY18 to calculate the results</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate Pipeline Result %25</fullName>
        <actions>
            <name>Calculate_Pipeline_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>calculates the pipeline result in %, used in FY14 SIP records, deactivated because all FY14 records are closed and recalculation not required anymore.</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate Plan year RevenueGrowth%25</fullName>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Calculates the Revenue Growth of the plan year in %, used for FY14 SIp records.  Deactivated because all FY14 records are complete and recalcaculation not required anymore</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY15 AM%2FGAM%2FSM</fullName>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS_achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Achieved_weighting_Sale</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>AM Plan FY15,GAM Plan FY15,SM Plan FY15</value>
        </criteriaItems>
        <description>used in SIP FY15, calculate the results and acheived weighting for AM, GAM and SM records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY15 FE</fullName>
        <actions>
            <name>Calculate_Conversion_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_EPB_NPS3_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS3_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS3_achieved_Weighting_FE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS_achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>FE Plan FY15</value>
        </criteriaItems>
        <description>used in SIP FY15, calculate the results and acheived weighting for FE records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY16 AM%2FGAM%2FSM</fullName>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS_achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Achieved_weighting_Sale</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>AM Plan FY16,GAM Plan FY16,SM Plan FY16</value>
        </criteriaItems>
        <description>used in SIP FY16, calculate the results and acheived weighting for AM, GAM and SM records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY16 FE</fullName>
        <actions>
            <name>Calculate_Conv_weighting_53_weeks</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result_53_weeks</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_EPB_GI_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_GI_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_GI_Growth</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS_achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>FE Plan FY16</value>
        </criteriaItems>
        <description>used in SIP FY16, calculate the results and acheived weighting for FE records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY16%2F17 Inside Sales</fullName>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS_achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting_PM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Conversion_Achieved_Weighting_Inside_sal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Inside Sales FY17</value>
        </criteriaItems>
        <description>used in SIP FY16, calculate the results and achieved weighting for Inside Sales records, same rule also for FY17</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY17 AM%2FGAM%2FSM</fullName>
        <actions>
            <name>Calculate_EPB_Revenue_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS_achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_SMI_Achieved_weighting_Sale</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>AM Plan FY17,GAM Plan FY17,SM Plan FY17</value>
        </criteriaItems>
        <description>used in SIP FY17, calculate the results and acheived weighting for AM, GAM and SM records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY17 FE</fullName>
        <actions>
            <name>Calcualte_Exc_Forecast_Attainment_weigh</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Forecast_Attainment_Ach_Weight</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_NPS_achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>FE Plan FY17</value>
        </criteriaItems>
        <description>used in SIP FY17, calculate the results and achieved weighting for FE records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY17 IND Channel</fullName>
        <actions>
            <name>Calculate_Direct_Revenue_Achieved_Weight</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Direct_Revenue_Growth</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Exp_performance_weighting_POS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_POS_Revenue_Achieved_Weight</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_POS_Revenue_Growth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IND Channel FY17</value>
        </criteriaItems>
        <description>used in SIP FY17, calculate the results and achieved weighting for IND Channel record types</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY18 AM%2FGAM</fullName>
        <actions>
            <name>Application_Focus_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calcul_EPB_Rev_Ach_Weig_AM_GAM_FY_18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Rev_Perf_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>AM Plan FY18,GAM Plan FY 18</value>
        </criteriaItems>
        <description>used in SIP FY18, calculate the results and achieved weighting for AM and GAM records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY18 FE%2FSE%2FIS</fullName>
        <actions>
            <name>Application_Focus_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calcul_EPB_Rev_Ach_Weig_AM_GAM_FY_18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Conversion_achieved_weighting_FE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rev_Perf_Ach_Weighting_FY18_FE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>FE/SE/IS Plan FY18</value>
        </criteriaItems>
        <description>used in SIP FY18, calculate the results and achieved weighting for FE records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY18 IND Channel</fullName>
        <actions>
            <name>Calc_EPB_Dir_Rev_Ach_Weighting_FY_18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_BD_achieved_weighting_FAE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Direct_Rev_Ach_Weight_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Direct_Revenue_Growth</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_POS_Rev_Achi_weighting_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_POS_Revenue_Growth</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>IND Channel FY 18</value>
        </criteriaItems>
        <description>used in SIP FY18, calculate the results and achieved weighting for IND Channel record types</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY18 IND DSE</fullName>
        <actions>
            <name>Calcul_EPB_Rev_Ach_Weig_AM_GAM_FY_18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_BD_POS_DSE_achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rev_Perf_Achieved_Weighting_DSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>DSE Plan FY 18</value>
        </criteriaItems>
        <description>used in SIP FY18, calculate the results and achieved weighting for DSE records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY18 IND FAE</fullName>
        <actions>
            <name>Calcul_EPB_Rev_Ach_Weig_AM_GAM_FY_18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_BD_achieved_weighting_FAE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Conversion_achieved_weighting_FE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rev_Perf_Ach_Weighting_FY18_FE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>FAE Plan FY18</value>
        </criteriaItems>
        <description>used in SIP FY18, calculate the results and achieved weighting for FAE records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY18 IND Marketing</fullName>
        <actions>
            <name>Calcul_EPB_Rev_Ach_Weig_AM_GAM_FY_18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_BD1_Achieved_weighting_IM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_BD2_Achieved_weighting_IM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_ach_weighting_IM</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rev_Perf_Achieved_Weighting_IMM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Industry Marketing Plan FY18</value>
        </criteriaItems>
        <description>used in SIP FY18, calculate the results and achieved weighting for Industrial marketing records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Calculate SIP results FY18 SM</fullName>
        <actions>
            <name>Calcul_EPB_Rev_Ach_Weig_AM_GAM_FY_18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_AFG_BD1_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Appl_focused_result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_BDriver_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Achieved_weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Conversion_Result</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_POS_BD2_Achieved_Weighting</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Calculate_Plan_year_RevenueGrowth_FY18</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rev_Perf_Achieved_Weighting_FY18_SM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SIP__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>SM Plan FY 18</value>
        </criteriaItems>
        <description>used in SIP FY18, calculate the results and achieved weighting for SM records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Text filed from Uservertical from participants user records</fullName>
        <actions>
            <name>Populate_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Region</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Populate_Sub_Vertical</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>populates the Sub Vertical, Country and Region of the Plan Participant into Text fields. The text fields are used in criteria based sharing rules.</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
