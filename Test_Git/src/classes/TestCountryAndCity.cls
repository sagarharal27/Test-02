/************************************************************************
 Class Name: TestCountryAndCity
 Created Date:2/8/2015
 Description: This test class test DependentlistOfCity
*************************************************************************/  
@isTest
private class TestCountryAndCity {
    
    static List<CustomCity__c> listCustomCity = new List<CustomCity__c>();
    static testMethod void initialTest() {
        List<selectoption> checkList  = new List<selectoption>();
        CustomCity__c  instance = new CustomCity__c();
        instance.Name = 'India';
        instance.City__c = 'Pune';
        insert instance;  
        
        DependentListController controllerObj = new DependentListController();
        checkList = controllerObj.getCityList();
        System.assertEquals(1,checkList.size());
    }
    static testMethod void testForList() {
        List<selectoption> checkList  = new List<selectoption>();
        CustomCity__c  instance = new CustomCity__c();
        for(integer i = 0 ; i < 2; i++) {
            instance.Name = 'India'+i;
        }
        insert instance;  
        DependentListController controllerObj = new DependentListController();
        checkList = controllerObj.getCountrylist();
        System.assertEquals(2,checkList.size());
    }
    static testMethod void testForEmptyList() {
        List<selectoption> checkList  = new List<selectoption>();
        List<CustomCity__c> tempList = new List<CustomCity__c>();
        
        CustomCity__c  instance = new CustomCity__c();
        for(integer i = 0 ; i < 2; i++) { 
            instance.Name = 'India'+i;
            instance.City__c = 'Pune,Kolkata';
        }
        tempList.add(instance);
        if(!tempList.isEmpty())
            insert tempList;
        DependentListController controllerObj = new DependentListController();
        controllerObj.country = 'India1';
        controllerObj.city = 'Pune';
        checkList = controllerObj.getCityList();
        
        List<Apexpages.Message> testMessage = Apexpages.getMessages();
        System.assertEquals(0,testMessage.size());
    } 
}