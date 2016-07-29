/***************************************************************************************************
Class: DynamicSOQLStatements
Date : 25/8/2015
Description : This is controller where Dynamic SOQL queries are used 
              to interact with objects and fields  
***************************************************************************************************/
public with sharing class DynamicApex {
    public String strObjectName {get;set;}
    public List<String> listObjectField {get;set;}
    public List<SelectOption> listSelectedObject {get;set;}
    public List<SelectOption> listSelectedField {get;set;}
    //public List<SelectOption> selectedObjectFields {get;set;}
    public String strOrderBy {get;set;}
    public Integer intSelectedNumber {get;set;}
    public String strquery {get;set;}
    public String strNewQuery;
    public String executeQuery {get; set;}
    public List<SObject> listQueryResult {get;set;}
    public List<SelectOption> strSelectSortOptions; 
    public List<SelectOption> listLimitOfRecords;
    public Integer intCount = 0;     
    public Integer intIndex = 0;
    public Integer blockSize = 100;
    
    // Constructor for the class
    public DynamicApex() {
        strOrderBy = 'Ascending';
        intSelectedNumber = 500;
        strquery = '';
        listObjectField = new List<String>();
    }
    
    // Method to display all the objects
    public List<SelectOption> getallObjectName() {
        List<Schema.SObjectType> listAllObjects = Schema.getGlobalDescribe().Values();
        System.debug('===listAllObjects====' + listAllObjects);
        List<SelectOption> listSelectedObject = new List<SelectOption>();
        
        for (Schema.SObjectType selectedObjectInstance : listAllObjects) {
            listSelectedObject.add(new SelectOption(selectedObjectInstance.getDescribe().getName(),
                                                selectedObjectInstance.getDescribe().getLabel()));
        } 
        listSelectedObject.sort();
        System.debug('111111111111111' + listSelectedObject);
        System.debug('222222222222222' + strObjectName);
        return listSelectedObject;
    }
    
    // Method to display Fields of objects
    public void getobjectFieldsName() {
        Map<String, Schema.SObjectType> allObjectMap = Schema.getGlobalDescribe();
        System.debug('*******Objects*******' + strObjectName);
        Schema.SObjectType objectSchema = allObjectMap.get(strObjectName);
        Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
        listSelectedField = new List<SelectOption>();
        for (String fieldName : fieldMap.keySet()) {  
            listSelectedField.add(new SelectOption(fieldName,fieldName));
        }
        listSelectedField.sort();
        System.debug('3333333333333' + listSelectedField);
        //return selectedField;
    }
    
    // For sorting records on the  page
    public List<SelectOption> getradioOptions() {
        strSelectSortOptions = new List<SelectOption>();
        strSelectSortOptions.add(new SelectOption('Ascending','Ascending'));
        strSelectSortOptions.add(new SelectOption('Descending','Descending'));
        return strSelectSortOptions;
    }
    
    // Method to display limits of records 
    public List<SelectOption> getlistNumber() {
        listLimitOfRecords = new List<SelectOption>();
        listLimitOfRecords.add(new SelectOption('500','500'));
        listLimitOfRecords.add(new SelectOption('1000','1000'));
        listLimitOfRecords.add(new SelectOption('5000','5000'));
        listLimitOfRecords.add(new SelectOption('50000','50000'));
        return listLimitOfRecords;
    } 
    
    // Method to display query and result of query
    public void displayQuery() {
        strNewQuery = 'SELECT COUNT() FROM ' + strObjectName;
        intCount = database.countQuery(strNewQuery);
        System.debug('========count of records============' + intCount);
        if (strOrderBy == 'Ascending') {
            strOrderBy =' ASC ';
        } else {
            strOrderBy = ' DESC ';
        }
        try{
            executeQuery = 'SELECT' + listObjectField + 'FROM ' + strObjectName + ' ORDER BY ' + 
                    listObjectField[0] + strOrderBy + ' LIMIT ' + blockSize +' OFFSET '+ intIndex;
             strquery = 'SELECT' + listObjectField + 'FROM ' + strObjectName + ' ORDER BY ' + 
                               listObjectField[0] + strOrderBy + ' LIMIT ' + intSelectedNumber;
            System.debug('queryold===============' + strquery);
            executeQuery = executeQuery.replace('(',' ');
            executeQuery = executeQuery.replace(')',' ');
            strquery = strquery.replace('(',' ');
            strquery = strquery.replace(')',' ');
            System.debug('queryfinal===============' + strquery);
            listQueryResult = Database.query(executeQuery);
            System.debug('queryResult1 ===============' + listQueryResult);
        } catch (Exception error) {
            System.debug('Error Message in query');
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                 'Error occured, You should select 1 object and atleast 1 Field')
            );
        } 
    } 
}