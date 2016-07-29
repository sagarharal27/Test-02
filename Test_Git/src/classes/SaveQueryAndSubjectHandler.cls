/***************************************************************************************************
Class : SaveQueryAndSubjectHandler
Created Date : 31/8/2015
Description : This class is handler for trigger EmailTrigger 
***************************************************************************************************/
public with sharing class SaveQueryAndSubjectHandler {
    
    public SaveQueryAndSubjectHandler(List<Query__c> listQuery) {
         for(Query__c queryInstance : listQuery) {
             callingGoogleWebService(queryInstance.Query_Of_User__c);
         }
    }
    public List<Query__C> listQuery = new List<Query__c>();
    
    // Method to call webservice of google
    @future (callout = true)
    public static void callingGoogleWebService(String query) {
        HttpRequest request = new HttpRequest();
        String queryString = query;
        request.setEndpoint(Constants.strEndPoint + 
                            EncodingUtil.urlEncode(queryString, Constants.strCharSet));
        request.setMethod('GET');
        request.setHeader(Constants.strContentType, Constants.strTextPlain); 
        Http http = new Http();
        HttpResponse response = http.send(request); 
        System.debug(' \n\n\n  Response ' + response.getBody()); 
        
        List<Response__c> listInsertResponse = new List<Response__c>();
        List<String> listOfResponse = new List<String>();
        
        // Query on the Query object to get all queries
        List<Query__c> listqueryResult = [select Id,Query_Of_User__c 
                                          from Query__c
                                          where Query_Of_User__c = :query]; 
        
        // Getting th response for webservice
        listOfResponse = response.getBody().split('<li class="g">');
        System.debug('------------------>');
        
        for (String responseInstance : listOfResponse) {  
            Response__c responseObj = new Response__c();
            
            responseObj.QueryAndResponse__c = listqueryResult[0].Id;
            
            responseObj.Title_Of_query__c =
                responseInstance.substringBetween(Constants.strStartTitle,Constants.strEndTitle);
            
            if (String.isNotBlank(responseObj.Title_Of_query__c) == true) {
                responseObj.Title_Of_query__c = responseObj.Title_Of_query__c.stripHtmlTags();
            }
            responseObj.Link_For_Query__c =
                responseInstance.substringBetween(Constants.strStartLink,Constants.strEndLink); 
            
            String description = responseInstance.replace(Constants.strReplaceString1,
                                                  Constants.strReplaceString2);
            String description2 = description.replace(Constants.strReplaceString3,
                                                   Constants.strReplaceString4);
            String description3 = responseObj.Description__c;
            description3 = description2.stripHtmlTags();
            responseObj.Description__c = 
                description3.substringBetween(Constants.strReplaceString2,
                                                Constants.strReplaceString4);
            
            listInsertResponse.add(responseObj);
        }
        // Insert the list if its not empty 
        if(!listInsertResponse.isEmpty()) {   
            insert listInsertResponse;
        }
        listInsertResponse.remove(0);
    }
}