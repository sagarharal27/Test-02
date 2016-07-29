/**
 * A test method to test the functionality of the page AddMultipleChildRecords and check whether 
 * all the methods are executed correctly or not.
 *
 * Initial Draft           Author             Date
 * Version 1.0            Siddharth          21/04/2015
 *
 **/
@isTest (seeAllData=true)
private class TestCsvDownload {
    /** 
     * A test method to test when the records is save the records gets inserted or not
     **/
    static testMethod void AddMultipleChildRecordSave() {
        
        Settings__c objSetting = populateSettings();    
        insert objSetting;
        
        Account objAccount = populateAccount();
        insert objAccount;
        
        
        Contact objContact = new Contact();
        objContact.FirstName = 'Test1';
        objContact.LastName = 'Test2';
        objContact.Birthdate = date.today();
        objContact.MobilePhone = '9876564323';
        objContact.MailingStreet = 'TST'; 
        objContact.MailingState = 'MH';
        objContact.MailingPostalCode = '400034';
        objContact.MailingCountry = 'India';
        objContact.isActive__c = false;
        objContact.AccountId = objAccount.Id;
        insert objContact;
                                          
        PageReference pageRef = Page.addmultiplechildrecords;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid',objAccount.Id);
        ApexPages.currentPage().getParameters().put('po',objSetting.Id);
        Apexpages.currentpage().getparameters().put('pretURL',objAccount.Id);
        Test.startTest();
        Addmultiplechildrecordscontroller objController = new Addmultiplechildrecordscontroller();
        objController.listChildFieldSetMember= SObjectType.Contact.FieldSets.ChildFIELDS.getFields();
        for(Integer i = 0; i < objController.createNewSobjectList.size(); i++) {
            Contact convertedContact = (Contact)objController.createNewSobjectList[i].objCreateSobject;
            convertedContact.FirstName = 'Test1';
            convertedContact.LastName = 'Test2';
            convertedContact.MobilePhone = '9876564323';
            convertedContact.MailingStreet = 'TST'; 
            convertedContact.MailingState = 'MH';
            convertedContact.MailingPostalCode = '400034';
            convertedContact.MailingCountry = 'India';
            convertedContact.IsActive__c = true;
            convertedContact.Birthdate = date.today();
            convertedContact.Last_Meeting__c= system.now();
        }
        
       
        Blob csvBody = Blob.valueOf(' FirstName, LastName, Email, LeadSource, Isactive__c, Birthdate, Last_Meeting__c \n FirstName, LastName, Birthdate, Email, LeadSource, Isactive__c, Birthdate, Last_Meeting__c');
      
        Set<Id> setIds = new set<Id>();
        setIds.add(objContact.Id);
        objController.csvFileBody = csvBody;
        objController.importCSVFile();
        objController.retrieveChildFieldset(setIds);
        objController.saveChildObject();
        objController.exportDetailReport();
        objController.createNewChildRecord();
       // objController.strHeaderRow = new List<String> {'FirstName','LastName','Birthdate','Email','LeadSource','active__c','Birthdate','Last_Meeting__c'};
        List<Contact> lstcontact = [Select Id, LastName from Contact where LastName =:'Test2' limit 1];
        system.debug('lstcotnct***'+lstcontact.size());
        Test.stopTest();
        
    }
    
    /** 
     * A test method to test when the records is save the records gets inserted or not
     **/
    static testMethod void AddMultipleChildRecordtoQuickSave() {
        
        Settings__c objSetting = populateSettings();    
        insert objSetting;
        
        Account objAccount = populateAccount();
        insert objAccount;
                                          
        PageReference pageRef = Page.addmultiplechildrecords;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid',objAccount.Id);
        ApexPages.currentPage().getParameters().put('po',objSetting.Id);
        Apexpages.currentpage().getparameters().put('pretURL',objAccount.Id);
        Test.startTest();
        Addmultiplechildrecordscontroller objController = new Addmultiplechildrecordscontroller();
        for(Integer i = 0; i < objController.createNewSobjectList.size(); i++) {
            Contact convertedContact = (Contact)objController.createNewSobjectList[i].objCreateSobject;
            convertedContact.FirstName = 'Test1';
            convertedContact.LastName = 'Test2';
            convertedContact.MobilePhone = '9876564323';
            convertedContact.MailingStreet = 'TST'; 
            convertedContact.MailingState = 'MH';
            convertedContact.MailingPostalCode = '400034';
            convertedContact.MailingCountry = 'India';
        }
        objController.retrieveChildFieldset(NULL);
        objController.quickSaveChildRecords();
        objController.displayDeleteChildMessage_QuickSave();
        objController.showInsertedChildRecords();
        objController.csvFileBody = null;
        objController.importCSVFile();
        objController.getChildData();
        objController.editChildFieldset();
        objController.cancelChildFieldset();
        objController.saveChildFieldset();
        List<Contact> lstcontact = [Select Id from Contact where LastName =:'Test2'];
        system.debug('lstcotnct***'+lstcontact.size());
        Test.stopTest();
        //system.assertEquals(lstcontact.size(), 1);
    }

    /**
     *  A method to populate the data for the settings object record and return that record to the 
     * back from where it was called
     **/
     public static Settings__c populateSettings(){
        Settings__c objSetting = new Settings__c(Child_Fieldset_Name__c = 'mmg01__ChildFields',
                                                 Child_Section_Title__c = 'Related Contacts Records',
                                                 Child_Sobject_Name__c = 'Contact',
                                                 Parent_Fieldset_Name__c = 'mmg01__ParentChildRelation',
                                                 Parent_Section_Title__c = 'Account Description',
                                                 Parent_Sobject_Name__c = 'Account',
                                                 Related_Field_API_Name__c = 'AccountId');  
       return objSetting;
     }
     
     /**
      *  A method to populate the data for the account and return that record back from where
      *  it was called
      **/
     public Static Account populateAccount(){
         Account objAccount = new Account(Name = 'Test Account', 
                                         Phone = '020334455', 
                                         BillingStreet = 'Test',
                                         BillingCountry = 'India',  
                                         BillingCity = 'Pune');
         return objAccount;
     }
}