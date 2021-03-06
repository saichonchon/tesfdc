<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <consoleConfig>
        <componentList>
            <alignment>right</alignment>
            <components>AgentStatus</components>
        </componentList>
        <detailPageRefreshMethod>flag</detailPageRefreshMethod>
        <keyboardShortcuts>
            <defaultShortcuts>
                <action>FOCUS_CONSOLE</action>
                <active>true</active>
                <keyCommand>ESC</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_NAVIGATOR_TAB</action>
                <active>true</active>
                <keyCommand>V</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_DETAIL_VIEW</action>
                <active>true</active>
                <keyCommand>SHIFT+S</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_PRIMARY_TAB_PANEL</action>
                <active>true</active>
                <keyCommand>P</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_SUBTAB_PANEL</action>
                <active>true</active>
                <keyCommand>S</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_LIST_VIEW</action>
                <active>true</active>
                <keyCommand>N</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_FIRST_LIST_VIEW</action>
                <active>true</active>
                <keyCommand>SHIFT+F</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_SEARCH_INPUT</action>
                <active>true</active>
                <keyCommand>R</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>MOVE_LEFT</action>
                <active>true</active>
                <keyCommand>LEFT ARROW</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>MOVE_RIGHT</action>
                <active>true</active>
                <keyCommand>RIGHT ARROW</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>UP_ARROW</action>
                <active>true</active>
                <keyCommand>UP ARROW</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>DOWN_ARROW</action>
                <active>true</active>
                <keyCommand>DOWN ARROW</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>OPEN_TAB_SCROLLER_MENU</action>
                <active>true</active>
                <keyCommand>D</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>OPEN_TAB</action>
                <active>true</active>
                <keyCommand>T</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>CLOSE_TAB</action>
                <active>true</active>
                <keyCommand>C</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>REFRESH_TAB</action>
                <active>false</active>
                <keyCommand>SHIFT+R</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>ENTER</action>
                <active>true</active>
                <keyCommand>ENTER</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>EDIT</action>
                <active>true</active>
                <keyCommand>E</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>SAVE</action>
                <active>true</active>
                <keyCommand>CTRL+S</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>CONSOLE_LINK_DIALOG</action>
                <active>false</active>
                <keyCommand>U</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>HOTKEYS_PANEL</action>
                <active>false</active>
                <keyCommand>SHIFT+K</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_MACRO</action>
                <active>false</active>
                <keyCommand>M</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>FOCUS_FOOTER_PANEL</action>
                <active>false</active>
                <keyCommand>F</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>TOGGLE_LIST_VIEW</action>
                <active>false</active>
                <keyCommand>SHIFT+N</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>TOGGLE_LEFT_SIDEBAR</action>
                <active>false</active>
                <keyCommand>SHIFT+LEFT ARROW</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>TOGGLE_RIGHT_SIDEBAR</action>
                <active>false</active>
                <keyCommand>SHIFT+RIGHT ARROW</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>TOGGLE_TOP_SIDEBAR</action>
                <active>false</active>
                <keyCommand>SHIFT+UP ARROW</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>TOGGLE_BOTTOM_SIDEBAR</action>
                <active>false</active>
                <keyCommand>SHIFT+DOWN ARROW</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>TOGGLE_APP_LEVEL_COMPONENTS</action>
                <active>false</active>
                <keyCommand>Z</keyCommand>
            </defaultShortcuts>
            <defaultShortcuts>
                <action>REOPEN_LAST_TAB</action>
                <active>false</active>
                <keyCommand>SHIFT+C</keyCommand>
            </defaultShortcuts>
        </keyboardShortcuts>
        <listPlacement>
            <location>full</location>
        </listPlacement>
        <listRefreshMethod>refreshListRows</listRefreshMethod>
        <liveAgentConfig>
            <enableLiveChat>true</enableLiveChat>
            <openNewAccountSubtab>false</openNewAccountSubtab>
            <openNewCaseSubtab>false</openNewCaseSubtab>
            <openNewContactSubtab>false</openNewContactSubtab>
            <openNewLeadSubtab>false</openNewLeadSubtab>
            <openNewVFPageSubtab>false</openNewVFPageSubtab>
            <showKnowledgeArticles>false</showKnowledgeArticles>
        </liveAgentConfig>
    </consoleConfig>
    <defaultLandingTab>standard-home</defaultLandingTab>
    <description>Service Cloud Console for PIC</description>
    <isServiceCloudConsole>true</isServiceCloudConsole>
    <label>PIC Service Cloud Console</label>
    <preferences>
        <enableCustomizeMyTabs>false</enableCustomizeMyTabs>
        <enableKeyboardShortcuts>true</enableKeyboardShortcuts>
        <enableListViewHover>true</enableListViewHover>
        <enableListViewReskin>false</enableListViewReskin>
        <enableMultiMonitorComponents>true</enableMultiMonitorComponents>
        <enablePinTabs>true</enablePinTabs>
        <enableTabHover>false</enableTabHover>
        <enableTabLimits>false</enableTabLimits>
        <saveUserSessions>true</saveUserSessions>
    </preferences>
    <tabs>standard-home</tabs>
    <tabs>standard-Case</tabs>
    <tabs>standard-Account</tabs>
    <tabs>standard-Opportunity</tabs>
    <tabs>standard-Contact</tabs>
    <tabs>standard-Lead</tabs>
    <tabs>standard-report</tabs>
    <tabs>standard-LiveAgentSupervisor</tabs>
    <tabs>standard-LiveChatTranscript</tabs>
    <tabs>standard-LiveChatVisitor</tabs>
    <tabs>standard-LiveAgentSession</tabs>
    <tabs>Pop_Up_Alert__c</tabs>
    <tabs>PIC_Language__c</tabs>
    <tabs>Live_Agent_Files__c</tabs>
    <tabs>standard-QuickText</tabs>
    <tabs>Out_of_office</tabs>
    <tabs>Key_Activity_Staging__c</tabs>
    <tabs>Live_Agent_Country_List__c</tabs>
    <tabs>standard-Workspace</tabs>
    <tabs>standard-File</tabs>
    <tabs>ZSD_DMM_SAP__c</tabs>
    <workspaceConfig>
        <mappings>
            <tab>Key_Activity_Staging__c</tab>
        </mappings>
        <mappings>
            <tab>Live_Agent_Country_List__c</tab>
        </mappings>
        <mappings>
            <tab>Live_Agent_Files__c</tab>
        </mappings>
        <mappings>
            <tab>Out_of_office</tab>
        </mappings>
        <mappings>
            <tab>PIC_Language__c</tab>
        </mappings>
        <mappings>
            <tab>Pop_Up_Alert__c</tab>
        </mappings>
        <mappings>
            <tab>ZSD_DMM_SAP__c</tab>
        </mappings>
        <mappings>
            <tab>standard-Account</tab>
        </mappings>
        <mappings>
            <tab>standard-Case</tab>
        </mappings>
        <mappings>
            <tab>standard-Contact</tab>
        </mappings>
        <mappings>
            <tab>standard-File</tab>
        </mappings>
        <mappings>
            <tab>standard-Lead</tab>
        </mappings>
        <mappings>
            <tab>standard-LiveAgentSession</tab>
        </mappings>
        <mappings>
            <tab>standard-LiveAgentSupervisor</tab>
        </mappings>
        <mappings>
            <tab>standard-LiveChatTranscript</tab>
        </mappings>
        <mappings>
            <tab>standard-LiveChatVisitor</tab>
        </mappings>
        <mappings>
            <tab>standard-Opportunity</tab>
        </mappings>
        <mappings>
            <tab>standard-QuickText</tab>
        </mappings>
        <mappings>
            <tab>standard-Workspace</tab>
        </mappings>
        <mappings>
            <tab>standard-home</tab>
        </mappings>
        <mappings>
            <tab>standard-report</tab>
        </mappings>
    </workspaceConfig>
</CustomApplication>
