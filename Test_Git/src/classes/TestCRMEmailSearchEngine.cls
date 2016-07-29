/**************************************************************************************************
 Class Name: TestCRMEmailSearchEngine
 Created Date:6/9/2015
 Description: This test class tests insertion of email and queries 
***************************************************************************************************/  
@isTest
private class TestCRMEmailSearchEngine {

    static testMethod void testInsertionOfEmailAndQueries() {
        // Calling mopck test
        Test.setMock(HttpCalloutMock.class, new TestMockForBatchForResponse());
        
        // Creating instances of InboundEmail and InboundEnvelope
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        
        // Inserting data 
        env.fromAddress = 'pooja@gmail.com';
        email.subject = 'test';
        email.plainTextBody = '[query:abc]';
        email.FromName = 'pooja jadhav';
        email.fromAddress = 'pooja@gmail.com';
        
        // Calling method of HAndler class      
        CRMEmailSearchEngine testInbound=new CRMEmailSearchEngine ();
        Messaging.InboundEmailResult result = testInbound.handleInboundEmail(email, env);
        
        // Check assertion
        List<Email__c> lstEmail = new List<Email__c>();
        lstEmail = [select Id from Email__c];
        System.assertEquals(true, result.success);
    }
}