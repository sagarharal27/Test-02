public with sharing class PracticeOppRelatedToAccount {
    //public Map<Id,List<String>> mapOppRelatedToAccount{get; set;}
    //public Map<Id,String> mapOfAccToDisplay{get; set;}
    public List<Account> lstToHoldOpp{get; set;}
   
    
    public PracticeOppRelatedToAccount() {
        //mapOppRelatedToAccount = new Map<Id,List<String>>();
        //mapOfAccToDisplay = new  Map<Id,String>();
        lstToHoldOpp = new List<Account>();
        getAccountAndOpp();
    }
    
    public void getAccountAndOpp() {
       
        for(Account acc : [Select a.Phone, a.Id, a.Name, 
                          (Select Id, AccountId, Name, StageName, CloseDate From Opportunities)
                          From Account a]) {
            
            if(acc.Opportunities != null && acc.Opportunities.size() > 0) {
                lstToHoldOpp.add(acc);
            }
        }
        System.debug('lstToHoldOpp--->'+lstToHoldOpp);
        
        /*if(!lstOpp.isEmpty()) {
            for(Account accInstance : lstOpp) {
                if(mapOppRelatedToAccount.containsKey(accInstance.Id)) {
                   // mapOfAccToDisplay.put(oppInstance.Account.Id, oppInstance.Account.Name);
                    
                    lstToHoldOpp = mapOppRelatedToAccount.get(accInstance.Id);
                    lstToHoldOpp.add(accInstance.Opportunities.Name);
                }  
                else {
                    mapOppRelatedToAccount.put(accInstance.Id , new List<String>{accInstance.Opportunity.Name});
                }
            }
        }
        System.debug('mapOppRelatedToAccount--->'+mapOppRelatedToAccount);*/
    }
}