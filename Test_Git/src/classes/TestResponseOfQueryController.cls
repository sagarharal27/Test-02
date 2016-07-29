/**************************************************************************************************
 Class Name: TestResponseOfQueryController
 Created Date:6/9/2015
 Description: This test class tests the response of queries
***************************************************************************************************/  
@isTest
private class TestResponseOfQueryController {
    
    // Test method to check response of query
    static testMethod void gettingResponseList() {
        
        Test.setMock(HttpCalloutMock.class, new TestMockForBatchForResponse());
        
        // Inserting Contacts
        List<Contact> conList = new List<Contact>();
        conList=TestDatafactory.contactData(5);
        insert conList; 
        
        // Inserting Emails
        List<Email__c> emailList = new List<Email__c>();
        for( Integer i = 0; i < 5; i++ ) {
            emailList.add(new Email__c (Name = 'pooja@gmail.com'+i,
                                        Contact__c = conList[0].Id));
        }
        insert emailList;
        
        // Insert in Queries
        List<Query__c> queList = new List<Query__c>();
        for( Integer i = 0; i < 5; i++ ) {
            queList.add(new Query__c (EmailandContact__c = emailList[0].Id,
                                      Query_Of_User__c = 'pune'+i));
        }
        insert queList;
        
        // Inserting Responses
        List<Response__c> resList = new List<Response__c>();
        for(Integer i = 0; i < 5; i++) {
            resList.add(new Response__c (Title_Of_query__c = 'pune'+i,
                                         Link_For_Query__c = 'www.google.com'+i,
                                         Description__c = 'aaaaaa',
                                         QueryAndResponse__c = queList[0].Id));
        }
        insert resList;
        
        ResponseOfQueryController con = new ResponseOfQueryController();
        con.IdOfQuery = queList[0].Id;
        
        // Calling method of controller
        List<Response__c> tempList = con.getlistofResponse();
        System.debug('*********111************'+tempList);
        List<Response__c> checkList = new List<Response__c>();
       
        checkList = [select id,Title_Of_query__c from Response__c];
        System.debug('**********222***********'+checkList);
        System.assertEquals(checkList.size(), tempList.size());
    }
}