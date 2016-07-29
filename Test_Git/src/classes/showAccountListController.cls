/************************************************************************
 Class Name: showAccountListController
 Created Date:3/8/2015
 Description: This is controller for Accounts and contacts pages
*************************************************************************/ 

global with sharing class showAccountListController {
    
    List<String> SearchAlpabet;
    public List<ContainerOfContact> wrapList;
    public boolean rendcon;
    public boolean reVariable {get; set;}
    public set<Id> conId;
    public String searchVariable{get; set;}
    public Contact contactInstance {get; set;}
    public List<Contact> ContactList{get; set;}
    public Id accId {get;set;}
    public string accountName{get; set;}
    
    public Account accObj {get; set;}
    public List<Account> listacc;
    public List<Contact> coList;
    public List<Contact> conList;
    
    public boolean rend ;
    public boolean rendAdd{get; set;}
    public string parentAccount {get;set;}
    public Integer counter{get; set;}
    
    // Constructor for showAccountListController   
    public showAccountListController () {
        ContactList = new List<Contact>();
        wrapList = new List<ContainerOfContact>();
        rend = false;
        conList= new List<Contact>();
        rendcon = false;        
        rendAdd = false;
        contactInstance = new Contact();
        coList = new List<Contact>();
        conId = new set<Id>();
        reVariable = false;
    }
     
    // Remote action to delete contact      
    @RemoteAction
    global static void deleteContact(Id toDel) {
        system.debug('**********************'+toDel);
        contact conObj = new contact(); 
        conObj.id = toDel;
        if(conObj <> null) {
            delete conObj;
        }
        else {
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                                        System.Label.ErrorrForNoRecords));
        }
    } 
    
    // Method to get all related contact    
    public List<Contact> getContactList() {    
        if(!rendcon) {
            system.debug('******into if of getContactList******');
            // Clear contact list
            ContactList.clear();
            accId = apexpages.currentpage().getparameters().get('idofacc');
            system.debug('---------ID OF ACCOUNT ----------'+accId);
            accObj = [select a.Name from Account a where Id = :accId];
            
            // Assigning parent account to contact
            parentAccount = accObj.Name;
            ContactList = [Select c.Id,c.Name,c.Account.Name from Contact c
                           where c.Account.Id = :accId];
            // Calculate size of contact list
            counter= ContactList.size();
            if(!ContactList.isEmpty()) {
                return ContactList;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                                        System.Label.ErrorrForNoRecords));
                system.debug('No records..');
                return ContactList;
            }
        }
        
        
        
        else {
            system.debug('into else of getContactList');
            system.debug('********'+ContactList);
            if(accId != null) {
                ContactList.clear();
                ContactList = [Select Id,Name 
                               from Contact 
                               where Name Like :SearchVariable + '%' AND Account.id = :accId];
                // Displaying size of contact list
                counter = ContactList.size();
                // Check whether list is empty or not
                if(!ContactList.isEmpty())
                    return ContactList;
                else {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                                        System.Label.ErrorrForNoRecords));
                   
                }
             }
             ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                                        System.Label.ErrorrForNoRecords));
             System.debug('No records.');
             return null;
         } 
    }
    // List of wrapper 
    public List<ContainerOfContact> getwrapList() {
        system.debug('into getwrapper');
        if(!reVariable) {
            system.debug('*******into if getwrapper*******');
             wrapList.clear();  
             conList = getContactList();
             // Iterating on conList
             for(Contact con:conList) {
                ContainerOfContact wrObj = new ContainerOfContact(con);
                wrapList.add(wrObj);
             }
             conList.clear();
             reVariable=true;
        }
        return wrapList;
    }
    
    //List of accounts records
    public List<Account> getlistacc() {         
        if(!rend) {
            //Display all the records of account
            listacc = [SELECT a.Name, a.Phone,a.Id,a.Email_ID__c, a.Website FROM Account a Limit 40];
            counter = listacc.size();
        }
        else {
            //display only those records which are searched
            listacc = [SELECT a.Name,a.Phone,a.Id,a.Email_ID__c,a.Website
                       FROM Account a
                       WHERE a.Name
                       like :accountName.trim() +'%' ];
            counter = listacc.size();
        }
        if(!listacc.isEmpty())
            return listacc;
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                                        System.Label.ErrorrForNoRecords));
            System.debug('No records.');
            return null;
        }
    }
    
    // Redirecting to contact page
    public PageReference RedirectTocontactPage() {
        accId = apexpages.currentpage().getparameters().get('Accountid');
        system.debug('*****************************' +accId);
        //Assigning page reference
        PageReference  newpage = Page.showAssiciateContacts;
        newpage.getParameters().put('idofacc',accId);
        newpage.setRedirect(True);
        system.debug('*************newpage****************' +newpage);
        Return newpage;
    }
    
    public void SearchAccount() {
        // Condition for string characters
        if (accountName.contains('@')||accountName.contains('#')||accountName.contains('*')||
            accountName.contains('%')||accountName.contains('$')||accountName.contains(' ')) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                                                System.Label.ErrorMessageForCharacter));
            accountName='';         
        }
        else if(accountName.length() < 3 || accountName.length() > 20 ) {
            rend=false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                     System.Label.ErrorMessageForLengthOfCharacter));
            accountName=''; 
        }      
        else {
            rend = true;
            getlistacc();
        }
    }
    // For refreshing the result 
    public void refreshTheSearch() {
        rend=false;
        accountName= '';
    }
    
    // Search contact using alphabets
    public List<String> getSearchAlpabet() {
        return new List<string>{'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
                                'Q','R','S','T','U','V','W','X','Y','Z'};
    }
    
    // Displaying method
    public void display() {  
        system.debug('@@@@@@@@@into display @@@@@@@@@@');
        rendcon=true; 
        reVariable = false;
        // getwrapList();
    }
    
    public PageReference returnToAccount() {
        // Create the Reference of the page Account
        PageReference AccountPage = Page.showAccountList;
        // Setting redirect true allows to redirect to Account Page.
        AccountPage.setRedirect(true);
        return AccountPage;
    }
    // Adding Contact to the list
    public void AddContacts() {
        rendAdd = true;
    }
    // Saving new record to contact 
    public void saveNewRecord() {
        rendAdd= false;
        contactInstance.AccountId = accId;
        // contactInstance.LastName = 'test';
        insert contactInstance;
        contactInstance.clear();
        reVariable = false;
    }
    
    // Method to select contact records 
    public void getSelected() {
        for(ContainerOfContact wrapObj:wrapList)
            // If select contact
            if(wrapObj.selected) {
                // Add contact to list
                coList.add(wrapObj.contInstance);
            }
            for(Contact co:coList)
                 conId.add(co.Id);
    }
    // Method to delete multiple records
    public void DeleteMultipleRecords() {
        reVariable=false;
        coList.clear();
        // Id of set
        for(ID idVar : conId) {
            Contact con = new Contact();
            con.Id = idVar;
            // Adding id from the set to list
            coList.add(con);
        }
        if(!coList.isEmpty()) {
            // Delete that list
            try {
                List<Database.DeleteResult> results = Database.delete(coList);
            }
            catch(Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.info,
                     System.Label.ErrorMessageOnContactPage));
            }
        }
        else {
              system.debug('No records....');
        }
        //coList=[select c.Name From Contact c where c.Id = :conId];
        //delete coList ;
        ContactList.clear(); 
        conList.clear();
        wrapList.clear();
        conId.clear();
    }
    // Wrapper class
    public with sharing class ContainerOfContact {
        public Contact contInstance{get; set;} 
        public boolean selected{get; set;}
        // Constructor for wrapper class
        public ContainerOfContact(Contact con) {
            contInstance = new Contact();
            contInstance = con;
            selected = false;
        }
    }
}