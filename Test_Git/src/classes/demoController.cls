public with sharing class demoController {
     
    public List<Lead> listOfLead{get; set;}
    public Date myDate{get; set;}
    public Integer counter;
    public Integer recordNum;
    public Integer recordLimit;
    public Integer countOfRecords;
    
    public List<Account> lstAccount;
    
    public demoController() {
        listOfLead = new List<Lead>();
        counter = 0;
        recordNum = 0;
        recordLimit = 10;
        countOfRecords = 0;
        getlistOfLead();
        lstAccount =  new List<Account>();
    }
    
    public List<Lead> getlistOfLead() {
        System.debug('---into Function-- ');
        listOfLead = [select Name,Email,Company,Phone,Status from Lead limit :recordLimit offset :counter];
        recordNum = listOfLead.size();
        System.debug('---recordNum-- '+recordNum);
        countOfRecords = [select count() from Lead];
        return listOfLead;
    }
    
    public void nextButton() {
        System.debug('---into nextButton-- ');
        counter += recordLimit;
        getlistOfLead();
    }
    
    public void prevButton() {
        System.debug('---into prevButton-- ');
        counter -= recordLimit;
        getlistOfLead();
    }
    
    public void firstButton() {
        System.debug('---into firstButton-- ');
        counter = 0;
        getlistOfLead();
    }
    
    public void lastButton() {
        System.debug('---into lastButton-- ');
        counter = countOfRecords - math.mod(countOfRecords,recordLimit);
        getlistOfLead();
    }
    public boolean getPrev() {
        if(counter == 0) {
            return true;
        }
        else {
            return false;
        }
    }
    public boolean getNext() {
        if((counter + recordLimit) > recordNum) {
            return true;
        }
        else {
            return false;
        }
    }
    
    
    public List<Account> getlstAccount() {
        lstAccount = [select Id, Name, (select Id, Name from Contacts) from Account limit 5];
        System.debug('lstAccount=='+lstAccount);
        return lstAccount;
    }
}