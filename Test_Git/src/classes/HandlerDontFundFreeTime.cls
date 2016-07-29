public with sharing class HandlerDontFundFreeTime {
    
    public static boolean firstRun = true;
    //public static set<Id> setAccountIds = new set<Id>();
    public static set<Id> setRelatedContactId = new set<Id>();
    
    public static void makeDontFundTrue(Map<Id,Account> mapAccount) {
        
                
        System.debug('into Account trigger========= ');
        //Set<Id> setAccountId = new Set<Id>();
        Map<Id, List<Id>> mapAccountToContacts = new Map<Id, List<Id>>();
        
        /*
        for(Account acc : lstAccount) {
            setAccountId.add(acc.Id);
        }
        */
        //for(Id ids : mapAccount.keyset()) {
        //    setAccountIds.add(ids );
        //}
        //System.debug('setAccountIds========= '+setAccountIds);
        
        List<Contact> lstContact = [select Id, LastName, dreamMap__Dont_Fund__c ,AccountId from Contact 
                                                              where AccountId IN :mapAccount.keyset()];
                                                              //AND Id NOT IN :HandlerDontFundFreeTimeContact.setContactIds];
        System.debug('lstContact ====='+lstContact )     ;
        
        for(Contact con : lstContact) {
            if(mapAccountToContacts.containsKey(con.AccountId)) {
                mapAccountToContacts.get(con.AccountId).add(con.Id);
                System.debug('mapAccountToContacts========'+mapAccountToContacts.values());
            }
            else {
                mapAccountToContacts.put(con.AccountId, new List<Id>{con.Id});
            }
        }
        
             
        List<Id> lstRelatedContact = new List<Id>();
        List<Contact> lstNewContact = new List<Contact>();
        
        for(Account acc : mapAccount.values()) {
            if(acc.dreamMap__Dont_Fund__c == true) {
                lstRelatedContact = mapAccountToContacts.get(acc.Id);
                System.debug('lstRelatedContact========'+lstRelatedContact);
                
                
                setRelatedContactId.addAll(lstRelatedContact);
                lstRelatedContact.clear();
                System.debug('lstRelatedContact 1========'+lstRelatedContact);
                
                System.debug('setRelatedContactId 1========'+setRelatedContactId);
                
                for(Id conId : HandlerDontFundFreeTimeContact.setContactIds) {
                     if(setRelatedContactId.contains(conId)) {
                        system.debug('into if******');
                        setRelatedContactId.remove(conId);
                        System.debug('setRelatedContactId 2========'+setRelatedContactId);
                    }
                }
                                
                lstRelatedContact.addAll(setRelatedContactId);
                System.debug('lstRelatedContact********'+lstRelatedContact);
                
                
                lstNewContact = [select Id, lastName, dreamMap__Dont_Fund__c from Contact 
                                                where Id IN :lstRelatedContact];
                System.debug('lstNewContact********'+lstNewContact);
                                                
                if(lstNewContact != null) {
                    for(Contact con : lstNewContact) {
                        if(con.dreamMap__Dont_Fund__c != true) {
                            
                            con.dreamMap__Dont_Fund__c = true;
                        }
                    }
                }
            }
        }
        
        if(!lstNewContact.isEmpty()) {
            update lstNewContact;
        }
         
        firstRun = false;
    }
}