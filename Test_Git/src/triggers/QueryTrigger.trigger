/***************************************************************************************************
Class : QueryTrigger
Created Date : 31/8/2015
Description :  this trigger fires when query and subject saved to query 
***************************************************************************************************/

trigger QueryTrigger on Query__c (after insert) {
    if(trigger.isInsert && trigger.isafter) {
        SaveQueryAndSubjectHandler s1 = new SaveQueryAndSubjectHandler(trigger.new);
    } 
}