/**************************************************************************************************
 Class Name: TestMockForBatchForResponse
 Created Date:6/9/2015
 Description: This is mock test for google callout
***************************************************************************************************/
global with sharing class TestMockForBatchForResponse implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest httpRequest) {
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setBody(Constants.strResponseOfQuery);
        httpResponse.setStatusCode(200);
        return httpResponse;
    }
}