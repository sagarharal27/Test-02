<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SendLiveChatEmail</fullName>
        <description>Send email to wechat account owner when receive message from wechat</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WeChat_Email_Templates/LiveChatNotification</template>
    </alerts>
    <rules>
        <fullName>Send Chat Email</fullName>
        <actions>
            <name>SendLiveChatEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WeChatChatHistory__c.SendEmailAlert__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
