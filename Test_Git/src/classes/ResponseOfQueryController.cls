/***************************************************************************************************
Class : ResponseOfQueryController
Created Date : 31/8/2015
Description : This is controller for component ResponseOfQueryCompo
***************************************************************************************************/
public with sharing class ResponseOfQueryController {
    public Id IdOfQuery{get; set;}

    // Cretaing list of responses and query
    public List<Response__c> listofResponse;

    // Method to get the list of responses 
    public List<Response__c> getlistofResponse() {
        
        listofResponse = [SELECT Id, Link_For_Query__c, Title_Of_query__c,Description__c 
                           FROM Response__c
                           WHERE QueryAndResponse__c =:IdOfQuery];
        System.debug('**********///////********' + listofResponse);
        // Returning the list
        return listofResponse;
    }
}