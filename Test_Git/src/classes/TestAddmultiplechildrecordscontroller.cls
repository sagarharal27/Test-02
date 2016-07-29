/**
 * A test method to test the functionality of the page AddMultipleChildRecords and check whether 
 * all the methods are executed correctly or not.
 *
 * Initial Draft           Author             Date        
 * Version 1.0            Dhirendra          25/08/2014
 * Version 1.1            Geeta Kushwaha     31/03/2016  
 *
 **/
@isTest(seeAllData = true)
private class TestAddmultiplechildrecordscontroller {

    /** 
     * A test method with all the parameters
     **/
    static testMethod void AddMultipleChildRecordwithParameters() {
        
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
        
        system.assertEquals(objAccount.Id, objController.strSobjectId);
        Test.stopTest();
    }
    
    /**
     * A method to chech when no parameter are passed to the page 
     **/
    static testMethod void AddMultipleChildRecordwithNoParameters() { 
        String strErrorMessage  = 'Inappropriate input prameters provided. Please provide valid input parameters to continue viewing this page.';
        Settings__c objSetting = populateSettings();    
        insert objSetting;
        Integer assignedRowNumber = 1;
        
        Account objAccount = populateAccount();
        insert objAccount;
                                          
        PageReference pageRef = Page.addmultiplechildrecords;
        Test.setCurrentPage(pageRef);
        Test.startTest();
        Addmultiplechildrecordscontroller objController = new Addmultiplechildrecordscontroller();
        //objController.addCloneChildRecord();
        
        Test.stopTest();
        system.assert( Apexpages.getMessages()[0].getSummary().Contains(strErrorMessage));
     }  
    
     /** 
     * A test method to test when the child record is deleted using the delete method 
     **/
    static testMethod void AddMultipleChildRecordDelete() {
        
        Settings__c objSetting = populateSettings();    
        insert objSetting;
        
        Account objAccount = populateAccount();
        insert objAccount;
        
        Contact objContact = new Contact(LastName='testContact',
                                         AccountId= objAccount.Id   );
        Insert objContact;  
                                          
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
        }
        objController.saveChildObject();
        objController.strChildRecId = objContact.Id;
        Addmultiplechildrecordscontroller.deleteChildRecord(objContact.Id, objcontroller.objSetting.Child_Sobject_Name__c);
        List<Contact> lstcontact = [Select Id from Contact where AccountId =:objAccount.Id];
        objController.displayDeleteChildMessage();
        Test.stopTest();
        //system.assertEquals(lstcontact.size(), 1);     
    }
    
    
    /** 
     * A test method to test when the child record is deleted using the delete method 
     **/
    
    static testMethod void AddMultipleChildRecordRemove() {
        
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
        }
        
        Apexpages.currentpage().getparameters().put('pIndex' , '1');
        objController.removeItem();
        system.assertEquals(objController.createNewSobjectList.size(),0);
        Test.stopTest();
        
    }
    
    
     /** 
     * A test method to test when the a record is removed form the list that is to be
     * inserted.
     **/
    static testMethod void AddMultipleChildNoRecordToRemove() {
        
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
        
        Apexpages.currentpage().getparameters().put('pIndex' , '1');
        objController.removeItem(); 
        system.assertEquals(objController.createNewSobjectList.size(),0);
        Test.stopTest();
        
    }
    
    /** 
     * A test method to test to check deletion message.
     **/
    static testMethod void AddMultipleChildNoRecordCancel() {
        
        Settings__c objSetting = populateSettings();    
        insert objSetting;
        
        Account objAccount = populateAccount();
        insert objAccount;
        String strurl = '/'+objAccount.Id;
                                          
        PageReference pageRef = Page.addmultiplechildrecords;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid',objAccount.Id);
        ApexPages.currentPage().getParameters().put('po',objSetting.Id);
        Apexpages.currentpage().getparameters().put('pretURL',objAccount.Id);
        Test.startTest();
        Addmultiplechildrecordscontroller objController = new Addmultiplechildrecordscontroller();
        //objController.rowIndex = 1;
        PageReference objPageRefer = objController.cancelItem();
         Apexpages.currentpage().getparameters().put('pErrorMessage','Record deleted successfully.'); 
        objController.displayDeletionMessage();
        system.assertEquals(strurl,objPageRefer.getUrl());
        Test.stopTest();
        
    }
    
    /** 
     * A test method to test when Settings fields are not properly inserted . 
     **/
    static testMethod void AddMultipleChildWithWrongSettingData() {
        
        Settings__c objSetting = populateSettings();
        objSetting.Parent_Sobject_Name__c = 'My_FirstRecord';   
        insert objSetting;
        
        Account objAccount = populateAccount();
        insert objAccount;
        String strurl = '/'+objAccount.Id;
                                          
        PageReference pageRef = Page.addmultiplechildrecords;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid',objAccount.Id);
        ApexPages.currentPage().getParameters().put('po',objSetting.Id);
        Apexpages.currentpage().getparameters().put('pretURL',objAccount.Id);
        Test.startTest();
        Addmultiplechildrecordscontroller objController = new Addmultiplechildrecordscontroller();
        
        system.assertEquals(Apexpages.getMessages()[0].getSummary(),'Inappropriate Settings values encountered. Please navigate to the Settings tab'+ 
                                                            +' and verify the configured record values or contact your Salesforce administrator.');
        Test.stopTest();
        
     }
        
    /** 
     * A test method to test when the child record is Autopopulated
     **/
    static testMethod void AddMultipleChildRecordPopulate() {
        
        Settings__c objSetting = populateSettings();    
        insert objSetting;
        
        Account objAccount = populateAccount();
        insert objAccount;
        
        Contact objContact = new Contact(LastName='testContact', Birthdate = date.today(),Last_Meeting__c = Datetime.now(),
                                         AccountId= objAccount.Id   );
        Insert objContact;  
                                          
        PageReference pageRef = Page.addmultiplechildrecords;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid',objAccount.Id);
        ApexPages.currentPage().getParameters().put('po',objSetting.Id);
        Apexpages.currentpage().getparameters().put('pretURL',objAccount.Id);
        Apexpages.currentpage().getparameters().put('Birthdate',string.ValueOf((objContact.Birthdate).format()));
        Apexpages.currentpage().getparameters().put('Last_Meeting__c',string.ValueOf((objContact.Last_Meeting__c).format()));
        Apexpages.currentpage().getparameters().put('LastName',objContact.LastName);
        
        Test.startTest();
        Addmultiplechildrecordscontroller objController = new Addmultiplechildrecordscontroller();
        objController.assignedRowNumber = 1;
        objController.addCloneChildRecord();
        Test.stopTest();        
    }
    
    /** 
     * A test method to test when cancel button is clicked on the page.
     **/
    static testMethod void testCancelToEditRecord() {
       
        Settings__c objSetting = populateSettings();
        objSetting.Parent_Sobject_Name__c = 'My_FirstRecord';   
        insert objSetting;
        
        Account objAccount = populateAccount();
        insert objAccount;
        String strurl = '/'+objAccount.Id;
                                                
        Set<Id> setChildID = new Set<Id>();
        List<Contact> lstContact = new List<Contact>();
        Contact objContact;
        
        for(Integer i=0; i<=5; i++) {
            objContact = new Contact();
            objContact.LastName='testContact'+i;
            objContact.Birthdate = date.today();
            objContact.Last_Meeting__c = Datetime.now();
            objContact.AccountId= objAccount.Id;
            lstContact.add(objContact);
            setChildID.add(objContact.Id);
        }
        Insert lstContact;
       
        PageReference pageRef = Page.addmultiplechildrecords;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('pid',objAccount.Id);
        ApexPages.currentPage().getParameters().put('po',objSetting.Id);
        Apexpages.currentpage().getparameters().put('pretURL',objAccount.Id);
        Apexpages.currentpage().getparameters().put('Birthdate',string.ValueOf((objContact.Birthdate).format()));
        Apexpages.currentpage().getparameters().put('Last_Meeting__c',string.ValueOf((objContact.Last_Meeting__c).format()));
        Apexpages.currentpage().getparameters().put('LastName',objContact.LastName);
        
            
        Addmultiplechildrecordscontroller objController = new Addmultiplechildrecordscontroller();
        Addmultiplechildrecordscontroller.childSobjectEditWrapper wrapperInstance = new Addmultiplechildrecordscontroller.childSobjectEditWrapper();
        for(Integer i=0; i<5; i++) {
        	wrapperInstance.rowIndexNo = i;
        	wrapperInstance.editRecord = false;
        	wrapperInstance.objChildSobject = Schema.getGlobalDescribe().get('Contact').getDescribe().sobjectType.newSObject(null,false);
        	
            objController.lstChildWrpMap.put(i, wrapperInstance);
            objController.lstChildWrp.add(wrapperInstance);
            objController.rowIndex = i;
        }
        objController.showInsertedChildRecords();
        objController.saveChildFieldset();
        objController.editChildFieldset();
        objController.cancelChildFieldset();
        for(Integer i=0; i<5; i++) {
        	objController.cancelChildContact(i);
        }
        System.assertEquals(lstContact.size(), 6);
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