/**************************************************************************************************
 Class Name: TestBatchForQueryResponse
 Created Date:6/9/2015
 Description: This test class tests the batch for sending mails
***************************************************************************************************/  
@isTest
private class TestBatchForQueryResponse {

    static testMethod void checkBatchForSendingResponse() {
        
        Test.setMock(HttpCalloutMock.class, new TestMockForBatchForResponse());
        // Creating data for contact
        List<Contact> conList = new List<Contact>();
        conList=TestDatafactory.contactData(5);
        insert conList; 
        
        // Creating data for Email
        List<Email__c> emailList = new List<Email__c>();
        for( Integer i = 0; i < 5; i++ ) {
            emailList.add(new Email__c (Name = 'pooja@gmail.com'+i, Contact__c = conList[0].Id));
        }
        insert emailList;
                
        // Creating data for query
        List<Query__c> queList = new List<Query__c>();
        for( Integer i = 0; i < 5; i++ ) {
            queList.add(new Query__c (EmailandContact__c = emailList[0].Id,
                                      Query_Of_User__c = 'pune'+i));
        }
        insert queList;
                
        // Creating data for Send Responses
        List<Send_Response__c> resList = new List<Send_Response__c>();
        for(Integer i = 0; i < 5; i++) {
            resList.add(new Send_Response__c (QueryJunction__c = queList[0].Id,
                                              ContactJunction__c = conList[0].Id));
        }
        insert resList;
        
        // Calling batch from controller
        test.startTest();
            Database.executeBatch(new BatchForResponse()); 
        test.stopTest();
        
        system.assertEquals(0,Limits.getEmailInvocations());
    }
}