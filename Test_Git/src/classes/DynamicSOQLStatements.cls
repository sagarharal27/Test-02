/***************************************************************************************************
Class: DynamicSOQLStatements
Date : 25/8/2015
Description : This is controller where Dynamic SOQL queries are used 
              to interact with objects and fields  
***************************************************************************************************/
public with sharing class DynamicSOQLStatements {

    public List<SelectOption> listSelectedObject {get;set;}
    public List<SelectOption> listSelectedField {get;set;}
    public String strObjectName {get;set;}
    public List<String> listObjectField {get;set;}
    public String strOrderBy {get;set;}
    public Integer intSelectedNumber {get;set;}
    public String strquery {get;set;}
    public Integer intCount = 0;     
    public Integer intIndex = 0;
    public Integer blockSize = 100;
    public String strNewQuery;
    public String executeQuery {get; set;}
    public List<SObject> listQueryResult {get;set;}
    public List<SelectOption> listSelectSortOptions; 
    public List<SelectOption> listLimitOfRecords;

    public Boolean blHideFields{get; set;}
    public Boolean blHideOrder{get;set;}
    public Boolean blHideQuery{get; set;}
    public Boolean blHideLimit{get; set;}
    public Boolean blHideResult{get; set;}

    // Constructor for the class
    public DynamicSOQLStatements() {
        strOrderBy = Constants.strAscendingOrder;
        intSelectedNumber = 500;
        strquery = '';
        listObjectField = new List<String>();
        blHideFields = false;
        blHideOrder = false;
        blHideQuery = false;
        blHideLimit = false;
        blHideResult = false;
    }
    
    // Method to display all the objects
    public List<SelectOption> getallObjectName() {
        
        List<SelectOption> listSelectedObject = new List<SelectOption>();
        Map<String,Schema.SObjectType> mapGlobalDescribe = Schema.getGlobalDescribe();
        if(mapGlobalDescribe != null) {
            for(String objType : mapGlobalDescribe.keySet()){   
                // Retriving only those objects which are queryable         
                if((mapGlobalDescribe.get(objType).getDescribe().isQueryable()) &&
                  
                  (mapGlobalDescribe.get(objType).getDescribe().isSearchable())) {       
                   
                   listSelectedObject.add(new selectOption(objType,objType));
                }
            }
        }       
        if(!listSelectedObject.isEmpty()) { 
            // Sorting the list of objects
            listSelectedObject.sort();
        }
        System.debug('111111111111111' + listSelectedObject);
        System.debug('222222222222222' + strObjectName);
        return listSelectedObject;
    }
 
    // Method to display Fields of objects
    public void getobjectFieldsName() {
        listSelectedField = new List<SelectOption>();
        listObjectField = new List<String>();
        blHideFields = true;
        blHideOrder = false;
        blHideQuery = true;
        blHideOrder = true;
        blHideLimit = true;
        blHideResult = true;
               
        Map<String, Schema.SObjectType> allObjectMap = Schema.getGlobalDescribe();
        Schema.SObjectType objectSchema = allObjectMap.get(strObjectName);
        if(objectSchema != null ) {
            Map<String, Schema.SObjectField> fieldMap = objectSchema.getDescribe().fields.getMap();
            if(fieldMap != null) {
                for (String fieldName : fieldMap.keySet()) { 
                    if((fieldMap.get(fieldName).getDescribe().isSortable()) && 
                    (fieldMap.get(fieldName).getDescribe().isFilterable()) ) { 
                        listSelectedField.add(new SelectOption(fieldName,fieldName));
                    }
                }
            }
            if(!listSelectedField.isEmpty()) 
                // Sorting the list of fields 
                listSelectedField.sort();
            else {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                        System.Label.ErrorMsgForDynamicApex));
            } 
            System.debug('3333333333333' + listSelectedField);
        }
        else {
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                 System.Label.ErrorMsgForDynamicApex));
        }
    }

    // For sorting records on the  page 
    public List<SelectOption> getradioOptions() {
        listSelectSortOptions = new List<SelectOption>();
        // Selecting Radio button for order of records
        listSelectSortOptions.add(new SelectOption(Constants.strAscendingOrder,
                                                    Constants.strAscendingOrder));
        listSelectSortOptions.add(new SelectOption(Constants.strDescendingOrder,
                                                    Constants.strDescendingOrder));
        return listSelectSortOptions;
    }

    // Method to display limits of records 
    public List<SelectOption> getlistNumber() {
        listLimitOfRecords = new List<SelectOption>();
        // Selecting limits for records
        listLimitOfRecords.add(new SelectOption(Constants.strLimit500,Constants.strLimit500));
        listLimitOfRecords.add(new SelectOption(Constants.strLimit1000,Constants.strLimit1000));
        listLimitOfRecords.add(new SelectOption(Constants.strLimit5000,Constants.strLimit5000));
        listLimitOfRecords.add(new SelectOption(Constants.strLimit50000,Constants.strLimit50000));
        return listLimitOfRecords;
    } 
    
    // Method to display query and result of query
    public void displayQuery() {
        blHideLimit = false;
        executeQuery ='';
        strNewQuery = Constants.strSelectQuery + strObjectName;
        intCount = database.countQuery(strNewQuery);
        System.debug('********count*******' + intCount);
        if (strOrderBy == Constants.strAscendingOrder) {
            strOrderBy = Constants.strAscending;
        }
        else {
            strOrderBy = ' DESC ';
        }
        String temp = '';
        for(String s : listObjectField) {
            temp = temp + s + ',';
        }
        system.debug('-->>'+ temp);
        temp = temp.removeEnd(','); 
        system.debug('-->>'+ temp);
        try{
           
            if(!listSelectedField.isEmpty()) {
                executeQuery = Constants.strSelect +' '+ temp +' ' +Constants.strFrom +
                               strObjectName + Constants.strOrderRecordsBy + listObjectField[0] +
                               strOrderBy + Constants.strRecordLimit + intSelectedNumber + blockSize +
                               Constants.strRecordOffset + intIndex;
                System.debug('****executeQuery****'+executeQuery);
            
                strquery = Constants.strSelect +' ' + temp + Constants.strFrom + strObjectName +
                           Constants.strOrderRecordsBy + listObjectField[0] + strOrderBy +
                           Constants.strRecordLimit + intSelectedNumber;
                           System.debug('****strquery****'+strquery);
                System.debug('---------------->>' + strquery);
                
                if(String.isNotBlank(executeQuery)) {
                    executeQuery = executeQuery.replace(Constants.strOpeningBrackets,' ');
                    executeQuery = executeQuery.replace(Constants.strClosingBrackets,' ');
                }
                if(String.isNotBlank(strquery)) {
                    strquery = strquery.replace(Constants.strOpeningBrackets,' ');
                    strquery = strquery.replace(Constants.strClosingBrackets,' ');
                }
                System.debug('--------------->>' + strquery);
            
                // Executing query
                listQueryResult = Database.query(executeQuery);
                System.debug('queryResult**********' + listQueryResult);
            }
        }
        catch (Exception error) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,
                                 System.Label.ErrorMsgForDynamicApex));
        }
    }
}