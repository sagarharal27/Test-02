/**************************************************************************************************
 Class Name: TestSaveQueryHandler
 Created Date:6/9/2015
 Description: This test class tests the controller for SaveQueryAndSubjectHandler
***************************************************************************************************/ 
@isTest
private class TestSaveQueryHandler {
    static testMethod void checkToGetResponses() {
        
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
        
        // Calling the mock response
        Test.setMock(HttpCalloutMock.class, new TestMockForBatchForResponse());
        
        List<Query__c> queryListTest = [SELECT Id, Query_Of_User__c
                                        FROM Query__c
                                        WHERE Id= :emailList[0].id];   
         
        List<Response__c> responseListTest = [SELECT Id,Name
                                              FROM Response__c 
                                              WHERE QueryAndResponse__c = :queList[0].id];   
        // Verify the result
        System.assert(responseListTest.isEmpty()); 
    }
}