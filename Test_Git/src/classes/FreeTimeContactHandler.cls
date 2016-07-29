public with sharing class FreeTimeContactHandler {
    
    public static void assignOnAccountStatus(List<Contact> lstContact) {
        
        Set<String> setOfStatus = new Set<String>();
        List<Contact> lstInsertContact = new List<Contact>();
        Map<Id, List<Contact>> mapAccountIdToContact = new Map<Id, List<Contact>>();
        
        List<Contact> lstExistingContact = [select Id, LastName, dreamMap__Account_status__c,
                                                    Account.Name, AccountId, Account.dreamMap__Email_ID__c
                                            from Contact where AccountId != null];
        System.debug('lstExistingContact======='+lstExistingContact);
        
        if(!lstExistingContact.isEmpty()) {
            for(Contact con : lstExistingContact) {
                if(mapAccountIdToContact.containsKey(con.AccountId)) {
                    mapAccountIdToContact.get(con.AccountId).add(con);
                }
                else{
                    mapAccountIdToContact.put(con.AccountId, new List<Contact>{con});
                }
            }
            System.debug('mapAccountIdToContact======='+mapAccountIdToContact);
        }
        
        if(mapAccountIdToContact != null) {
            
        }
        /*
        if(!lstExistingContact.isEmpty()) {
            for(Contact con : lstExistingContact) {
                setOfStatus.add(con.dreamMap__Account_status__c);
            }
        }
        
        if(!lstContact.isEmpty()) {
            for(Contact conNew : lstContact) {
                if(!setOfStatus.contains(conNew.dreamMap__Account_status__c)) {
                    lstInsertContact.add(conNew);
                }
            }
        }
        
        if(!lstInsertContact.isEmpty()) {
            insert lstInsertContact;
        }
        */
    }
}