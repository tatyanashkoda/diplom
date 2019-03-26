<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Due_date_Milestone</fullName>
        <field>Due_date__c</field>
        <formula>TODAY()</formula>
        <name>Update Due date Milestone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Due date Milestone</fullName>
        <actions>
            <name>Update_Due_date_Milestone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Finished__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
