public with sharing class HandlerDontFundFreeTimeContact {
    
    public static boolean firstRun = true;
    public static set<Id> setContactIds = new set<Id>();
    
    public static void makeDontFundTrue(List<Contact> lstContact) {
        
        System.debug('into Contact trigger========= ');
        Set<Id> setAccountId = new Set<Id>();
        Map<Id, List<Account>> MapContactToAccount = new Map<Id, List<Account>>();
        
        for(Contact con : lstContact) {
            setAccountId.add(con.AccountId);
            setContactIds.add(con.Id);
            System.debug('setContactIds 1========'+setContactIds);
        }
        
       //List<Account> lstAccount = [select Id, Name from Account where Id IN :setAccountId];
        Map<string,account>  mapAccountIdToAccount = new Map<string,account>([select Id, Name,dreamMap__Dont_Fund__c from                                                                       Account where Id IN :setAccountId
                                                                               ]);
        //System.debug('lstAccount========'+lstAccount);
        
        for(Contact con : lstContact) {
            if(MapContactToAccount.containsKey(con.Id)) {
                MapContactToAccount.get(con.Id).add(mapAccountIdToAccount.get(con.AccountId));
                System.debug('MapContactToAccount 1========'+MapContactToAccount);
            }
            else {
                MapContactToAccount.put(con.Id, new List<Account>{mapAccountIdToAccount.get(con.AccountId)});
                System.debug('MapContactToAccount 2========'+MapContactToAccount);
            }
        }
                
        List<Account> lstParentAccount = new List<Account>();
        for(Contact con : lstContact) {
            if(con.dreamMap__Dont_Fund__c == true) {
                if(MapContactToAccount.containsKey(con.Id)) {
                    System.debug('MapContactToAccount 2========'+MapContactToAccount);
                    lstParentAccount = MapContactToAccount.get(con.Id);
                    System.debug('lstParentAccount11========'+lstParentAccount);
                }
            }
            
            if(!lstParentAccount.isEmpty() ) {
                System.debug('lstParentAccount22========'+lstParentAccount);
                System.debug('into if 1========'+lstParentAccount[0]);
                for(Account acc : lstParentAccount) {
                    if(acc.dreamMap__Dont_Fund__c != true){
                        System.debug('into if 2========'+lstParentAccount[0]);
                        acc.dreamMap__Dont_Fund__c = true;
                    }
                }
            }
        }
        if(!lstParentAccount.isEmpty()) {
            System.debug('lstParentAccount33========'+lstParentAccount);
            update lstParentAccount;
        }
        firstRun = false;
    }   
}