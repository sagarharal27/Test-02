public with sharing class SOQL_OnFreeTime {
    public Map<String, Map<String, Map<String, dreamMap__Work__c>>> mapOfWorks{get; set;}
    
    public SOQL_OnFreeTime(){
        mapOfWorks = new Map<String, Map<String, Map<String, dreamMap__Work__c>>>();
        displayWorks();
    }
    
    public void getSOQLQoueries() {
        // This will return the Accounts which will have Contacts or Opportunities
        Map<Id, Account> mapAccount = new Map<Id, Account>([SELECT Id, Name, 
                                                           (SELECT Id, Name from Contacts),
                                                           (SELECT Id, Name from Opportunities)
                                                           FROM Account]);
        
        List<Contact> lstContact = new List<Contact>();
        List<Opportunity> lstOpp = new List<Opportunity>();
        for (Account acc : mapAccount.values()) {
            lstContact.addAll(acc.Contacts);
            lstOpp.addAll(acc.Opportunities);
        }
        System.debug('mapAccount====='+mapAccount );
        System.debug('lstContact====='+lstContact );
        System.debug('lstOpp====='+lstOpp );
    }
    /******************************************************************************************/
    public void displayWorks() {
        
        //Map<String, Map<String, dreamMap__Work__c>> innerMap;
        //Map<String, dreamMap__Work__c > innerMostMap;

        List<dreamMap__Work__c> lstWork = [select Id, Name,
                                                dreamMap__Project__c,
                                                dreamMap__Project__r.Name,
                                                dreamMap__Project__r.dreamMap__Client__c,
                                                dreamMap__Project__r.dreamMap__Client__r.Name
                                            from dreamMap__Work__c];
        System.debug('lstWork========'+lstWork);
        
        if(!lstWork.isEmpty()) {
            
            for(dreamMap__Work__c work : lstWork) {
            
            //if(mapOfWorks != null) {
                System.debug('mapOfWorks 1======='+mapOfWorks);
                System.debug('333333333======='+work.dreamMap__Project__r.dreamMap__Client__r.Name);
                
                //if(string.isNotBlank(work.dreamMap__Project__r.dreamMap__Client__r.Name)) {
                if(mapOfWorks.containsKey(work.dreamMap__Project__r.dreamMap__Client__r.Name)) {
                    System.debug('11========');
                    Map<String, Map<String, dreamMap__Work__c>> innerMap = mapOfWorks.get(work.dreamMap__Project__r.dreamMap__Client__r.Name);
            
                    //if(innerMap != null) {
                        if(string.isNotBlank(work.dreamMap__Project__r.Name)) {
                        if(innerMap.containsKey(work.dreamMap__Project__r.Name)) {
                            System.debug('22========');
                           // if(innerMostMap != null ) {
                                
                                //if(innerMostMap.containsKey(work.dreamMap__Project__r.Name)) {
                                    Map<String, dreamMap__Work__c > innerMostMap = innerMap.get(work.dreamMap__Project__r.Name);
                                    
                                //}
                                //else{
                                    // Fill innerMost Map
                                    innerMostMap.put(work.Name, work);
                                    System.debug('innerMostMap======='+innerMostMap);
                                //}
                            //}
                        }
                }
                    //}
                    else{
                        System.debug('33========');
                        // Fill inner Map
                        map<String, dreamMap__Work__c> mapIdToWork = new map<String, dreamMap__Work__c>();
                        mapIdToWork.put(work.Name, work);
                        innerMap.put(work.dreamMap__Project__r.Name, mapIdToWork);
                        System.debug('innerMap======='+innerMap);
                    }
                }
            //}
           // }
            else {
                System.debug('44========');
                // Fill outer Map
                map<String, dreamMap__Work__c> mapIdToWork = new map<String, dreamMap__Work__c>();
                map<String, Map<String, dreamMap__Work__c>> mapProjectToWork = new map<String, Map<String, dreamMap__Work__c>>();
                mapIdToWork.put(work.Name, work);
                mapProjectToWork.put(work.dreamMap__Project__r.Name, mapIdToWork);
                
                mapOfWorks.put(work.dreamMap__Project__r.dreamMap__Client__r.Name, mapProjectToWork);
                System.debug('mapOfWorks======='+mapOfWorks);
            }
            }
        }
    }
}