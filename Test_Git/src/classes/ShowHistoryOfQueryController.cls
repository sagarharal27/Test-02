/***************************************************************************************************
Class : ShowHistoryOfQueryController
Created Date : 4/9/2015
Description : This is controller for showing History of Query
***************************************************************************************************/
public with sharing class ShowHistoryOfQueryController {
    
    public List<Response__c> resList{get; set;}
    public Id queryId{get; set;}
    public Integer Counter{get;set;}
    
    public List<Query__c> queryList {
        get{
            return (List<Query__c>) setCon.getRecords();
       }
       set;
    }
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                                        [select id,Query_Of_User__c from Query__c]));
                setCon.setPageSize(10);
            } 
            return setCon;
        }
        set; 
    }
    // Method to get responses of related queries
    public void getResponseList() {
        queryId = apexpages.currentpage().getparameters().get('responseOfQuery');
        resList = [select id,Title_Of_query__c,Link_For_Query__c,Description__c
                   from Response__c where QueryAndResponse__c = :queryId ];
        
        Counter = resList.size();
    }
    // Method to move to previous page
    public void previousRecords() {
        setCon.previous();
    }
    // Method to move to next page
    public void nextRecord() {
        setCon.next(); 
    }
    // Method to move to first page
    public void firstPage() {
        setCon.first();
    }
    // Method to move to last page
    public void lastPage() {
        setCon.last();
    } 
}