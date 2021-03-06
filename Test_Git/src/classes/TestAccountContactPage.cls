@isTest
private class TestAccountContactPage {

    // Test Method for account page
    static testMethod void accountPage() {
        showAccountListController Controller = new showAccountListController();
        List<Account> accList = new List<Account>();
        
        List<Account> accountList = new List<Account>();
        accountList=TestDatafactory.accountData(10);
        insert accountList;
          
        Controller.rend = false;
        Controller.getlistacc();
        accList = [select id,name from account];
        System.assertEquals(20,accList.size());
    }
    // Test Method to search account in List
    static testMethod void searchAccountRecord() {
        List<Account> accountList = new List<Account>();
        accountList=TestDatafactory.accountData(10);
        insert accountList;
        
        showAccountListController Controller = new showAccountListController();
        List<Account> accList = new List<Account>();
        Controller.accountName = 'tes';
        Controller.SearchAccount();
        
        accList = [select id,name from account where name Like 'tes%'];
        System.assertEquals(20,accList.size());
    }
    // Test Method to check account with wrong input
    static testMethod void searchAccountRecordWithChar() {
        List<Account> accountList = new List<Account>();
        accountList=TestDatafactory.accountData(10);
        insert accountList;
         
        showAccountListController Controller = new showAccountListController();
        List<Account> accList = new List<Account>();
        Controller.accountName = '@@@';
        Controller.SearchAccount();
        List<Apexpages.Message> testMessage = Apexpages.getMessages();
        accList = [select id,name from account where name Like '@@@%'];
        System.assertEquals(1,testMessage.size());
     } 
    // Test Method to check account with less character
    static testMethod void searchAccountRecordWithLessChar() {
        List<Account> accountList = new List<Account>();
        accountList=TestDatafactory.accountData(10);
        insert accountList;
         
        showAccountListController Controller = new showAccountListController();
        List<Account> accList = new List<Account>();
        Controller.accountName = 't';
        Controller.SearchAccount();
        
        List<Apexpages.Message> testMessage = Apexpages.getMessages();
        accList = [select id,name from account where name Like '@@@%'];
        System.assertEquals(1,testMessage.size());
     }
     // Test Method to to check clear of search
     static testMethod void clearSearchOfAccount() {
        List<Account> accountList = new List<Account>();
        accountList=TestDatafactory.accountData(10);
        insert accountList;
        
        showAccountListController Controller = new showAccountListController();
        List<Account> accList = new List<Account>();
        Controller.accountName = 'test';
        Controller.refreshTheSearch();
        accList = [select id from account];
        System.assertEquals('',Controller.accountName);
     }
    // Test Method to check redirection of account page to contact page
    static testMethod void redirectToContact() {
        Account accountInstance = new Account();
        showAccountListController Controller = new showAccountListController(); 
        PageReference accPage = page.showAccountList;
        accPage.getParameters().put('idofacc',accountInstance.Id);
        PageReference testReference = Controller.RedirectTocontactPage();
        Test.setCurrentPage(testReference);
        system.assertEquals('/apex/showassiciatecontacts',Controller.RedirectTocontactPage().getUrl());
    }
    // Test Method to check contact page 
    static testMethod void ContactPage() {
        List<Contact> contactList = new List<Contact>();
        List<Account> accList = new List<Account>();
        showAccountListController Controller = new showAccountListController(); 
        
        List<Account> accountList = new List<Account>();
        accountList=TestDatafactory.accountData(10);
        insert accountList;
        apexpages.currentpage().getparameters().put('idofacc',accountList[0].Id);
        Id accId = apexpages.currentpage().getparameters().get('idofacc');
        System.debug('/*/*/*/*/*/*/*/*/*/*/*' + accId);
        accList = [select id,Name from Account where id = :accId];
        List<Contact> conList = new List<Contact>();
        for(integer i = 0 ; i < 10 ; i++) {
            conList.add(new Contact (LastName='test'+i,AccountId = accId,Email='pooja'+ i +'@yahoo.com'));
        }
        Controller.rendcon = false;
        insert conList;
        Controller.getContactList();
        contactList = [select id,LastName from Contact where AccountId= :accId]; 
        system.assertEquals(10,contactList.size()); 
    }
    // Test Method to check searching of contact
    static testMethod void searchContact() {
        List<Contact> contactList = new List<Contact>();
        List<Contact> conList = new List<Contact>();
        conList=TestDatafactory.contactData(10);
        insert conList; 
        
        showAccountListController Controller = new showAccountListController();
        Controller.display();
        Controller.rendcon = true;
        Controller.SearchVariable = 't';
        Controller.getContactList();
        contactList = [select id,LastName from Contact];
        system.assertEquals(10,contactList.size()); 
    }
    // Test Method to check deletion of contact
    static testMethod void deleteSingleContact() {
        List<Contact> contactList = new List<Contact>();
        List<Contact> conList = new List<Contact>();
        conList=TestDatafactory.contactData(10);
        insert conList;
        showAccountListController.deleteContact(conList[0].Id);
        contactList = [select id from Contact];
        system.assertEquals(9,contactList.size()); 
    }
    // Test Method to check multiple deletion of contact
    static testMethod void deleteMultipleContact() {
        List<Contact> contactList = new List<Contact>();
        List<Account> accList = new List<Account>();
        showAccountListController Controller = new showAccountListController(); 
        
        List<Account> accountList = new List<Account>();
        accountList=TestDatafactory.accountData(10);
        insert accountList;
        apexpages.currentpage().getparameters().put('idofacc',accountList[0].Id);
        Id accId = apexpages.currentpage().getparameters().get('idofacc');
        System.debug('/*/*/*/*/*/*/*/*/*/*/*' + accId);
        accList = [select id,Name from Account where id = :accId];
        List<Contact> conList = new List<Contact>();
        for(integer i = 0 ; i < 10 ; i++) {
            conList.add(new Contact (LastName='test'+i,AccountId = accId,Email='pooja'+ i +'@yahoo.com'));
        }
        Controller.rendcon = false;
        insert conList;
        Controller.reVariable = false;
        Controller.getwrapList();
        
        Controller.wrapList[0].selected = true;
        Controller.getSelected();
        Controller.DeleteMultipleRecords();
        contactList = [select id from Contact];
        system.assertEquals(9,contactList.size()); 
    }
    // Test Method to save contact
    static testMethod void saveContactRecord() {
        List<Contact> conList = new List<Contact>();
        
        List<Contact> contactList = new List<Contact>();
        contactList=TestDatafactory.contactData(10);
        insert contactList; 
        
        showAccountListController Controller = new showAccountListController();
        Controller.contactInstance.LastName = 'jadhav';
        
        Controller.saveNewRecord();
        conList=[select id,LastName from Contact];
        system.assertEquals(11,conList.size());
    }
    // Test method to return to account page 
    static testMethod void returnToAccount() {
        Contact returnToAccount = new Contact();
        showAccountListController Controller = new showAccountListController(); 
        PageReference accPage = page.showAssiciateContacts;
        accPage.getParameters().put('Accountid',returnToAccount.Id);
        PageReference testReference = Controller.returnToAccount();
        Test.setCurrentPage(testReference);
        system.assertEquals('/apex/showaccountlist',Controller.returnToAccount().getUrl());
    }
    // Test method to check alphabates 
    static testMethod void alphabates() {
         showAccountListController Controller = new showAccountListController();
         List<String> alphaString = Controller.getSearchAlpabet();
         System.assertEquals(26,alphaString.size());
     }
}