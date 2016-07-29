/***************************************************************************************************
 Class Name: TestDynamicSOQLStatement
 Created Date:10/8/2015
 Description: This test class performs test cases to check vf page for Dynamic Apex
***************************************************************************************************/  
@isTest
private class TestDynamicSOQLStatement {
    
    // Test method to  check all objects
    static testMethod void retrivingAllObjects() {
        DynamicSOQLStatements contollerInstance = new DynamicSOQLStatements();
        List<Schema.SObjectType> listAllObjects = Schema.getGlobalDescribe().Values();
        List<SelectOption> listSelectedObject = new List<SelectOption>();
        
        for (Schema.SObjectType selectedObjectInstance : listAllObjects) {
            listSelectedObject.add(new SelectOption(selectedObjectInstance.getDescribe().getName(),
                                                selectedObjectInstance.getDescribe().getLabel()));
        }
        contollerInstance.getallObjectName();
        system.assertEquals(listAllObjects.size(), listSelectedObject.size());
    }
    // Test method to check all fields
    static testMethod void retrivingAllFields() {
        PageReference pageref = page.DynamicSOQLStatements;
        Test.setCurrentPage(pageRef);
        DynamicSOQLStatements contollerInstance = new DynamicSOQLStatements();
        
        contollerInstance.strObjectName = 'Account';
        Integer sizeOffieldList = Schema.getGlobalDescribe().get(contollerInstance.strObjectName)
                                    .getDescribe().fields.getMap().keyset().size();
        contollerInstance.getobjectFieldsName();
        Integer fieldsListSize = contollerInstance.listSelectedField.size();
        system.assertEquals(sizeOffieldList, fieldsListSize);
    }
     // Test Method to check radio buttons 
     static testMethod void checkForRadioButtons() {
         DynamicSOQLStatements contollerInstance = new DynamicSOQLStatements();
         List<SelectOption> strSelectSortOptions = contollerInstance.getradioOptions();
         system.assertEquals(2,strSelectSortOptions.size());
     }
     // Test case to check order of records
     static testMethod void checkOrderOfRecords() {
         DynamicSOQLStatements contollerInstance = new DynamicSOQLStatements();
         List<SelectOption> strSelectSortOptions = contollerInstance.getradioOptions();
         system.assertEquals(Constants.strAscendingOrder,contollerInstance.strOrderBy);
     }
     // Test Method to check limits of records
     static testMethod void orderOfRecords() {
         DynamicSOQLStatements contollerInstance = new DynamicSOQLStatements();
         List<SelectOption> strSelectSortOptions = contollerInstance.getlistNumber();
         system.assertNotEquals(null,contollerInstance.strOrderBy);
     }
     // Test Method to check query which is formed
     static testMethod void testShowQuery() {
        PageReference pageref = page.DynamicSOQLStatements;
        Test.setCurrentPage(pageRef);
        DynamicSOQLStatements contollerInstance = new DynamicSOQLStatements();
        String tempList = Constants.strQueryForTestClass;
        contollerInstance.strObjectName = 'Account';
        contollerInstance.listObjectField.add('Name');
        contollerInstance.listObjectField.add('Id');
        contollerInstance.strOrderBy = Constants.strAscendingOrder;
        contollerInstance.intSelectedNumber = 500;
        contollerInstance.displayQuery();
        system.assertNotEquals(tempList,contollerInstance.strquery);
     }
     // Test Method to check query in descending order
     static testMethod void testShowQuery1() {
        PageReference pageref = page.DynamicSOQLStatements;
        Test.setCurrentPage(pageRef);
        DynamicSOQLStatements contollerInstance = new DynamicSOQLStatements();
        String tempList = Constants.strQueryForTestClass;
        contollerInstance.strObjectName = 'Account';
        contollerInstance.listObjectField.add('Name');
        contollerInstance.listObjectField.add('Id');
        contollerInstance.strOrderBy = Constants.strDescendingOrder;
        contollerInstance.intSelectedNumber = 500;
        contollerInstance.displayQuery();
        system.assertNotEquals(tempList,contollerInstance.strquery);
     }
}