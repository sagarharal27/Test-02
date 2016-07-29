public with sharing class CountOperationsInClass {
    
    public void countNoOfOperations() {
        List<Account> lstAccount = [select Id from Account Limit 10];
        if(!lstAccount.isEmpty()) {
            update lstAccount;
            
        }
        
        List<dreamMap__Department__c> lstContact = [select Id from dreamMap__Department__c Limit 10];
        if(!lstAccount.isEmpty()) {
            update lstContact;
        }
        
        List<List<SObject>> searchList = [FIND 'SFDC' IN ALL FIELDS  RETURNING Account(Name), Contact(FirstName,LastName)];
        System.debug('searchList======='+searchList);
        
        Integer DMLOperations = integer.valueOF(Limits.getDMLStatements());
        System.debug('DMLOperations performed========='+DMLOperations);
        System.debug('No of SOQL Query========='+Limits.getQueries());
        System.debug('No of records returned========='+Limits.getQueryRows());
        System.debug('No of SOSL Query========='+Limits.getSoslQueries());
        
    }
}