/***************************************************************************************************
 Class Name: CollectionOfClosedOpportunity
 Created Date:10/8/2015
 Description: This class sends mail to Account with Amount of opportunity and aggregate 
***************************************************************************************************/  
global with sharing class CollectionOfClosedOpportunity implements 
                          Database.Batchable<sObject>,Database.Stateful {
    global final string strQuery ;
    map<string,CollectionOfOppContents> mapOfOppAndWrapper ;
    
    //constructor having query string and map
    global CollectionOfClosedOpportunity() {
        strQuery=Constants.strClosedOpp;   
        mapOfOppAndWrapper = new map<string,CollectionOfOppContents>() ;
    }

    //Start method
    global Database.QueryLocator start(Database.BatchableContext batchCon) {
        return Database.getQueryLocator(strQuery);
    }
    
    //Execute method
    global void execute(Database.BatchableContext batchCon,List<Opportunity> listOpp) {
        System.debug('************'+listOpp);
        if(!listOpp.isEmpty()) {
        for(Opportunity oppObj:listOpp) {
            /*if(oppObj.Amount == null) {
                oppObj.Amount = 0;
            }*/
            if(oppObj.Account.Primary_Contact__c <> Null) {
                //If Opp'Account contains primary contact                 
                if(mapOfOppAndWrapper.containsKey(oppObj.Account.Primary_Contact__c)) {
                    
                    //Get that Opp and add to list
                    CollectionOfOppContents wrap = mapOfOppAndWrapper.get(oppObj.Account.Primary_Contact__c);
                    wrap.oppList.add(oppObj);
                    if(oppObj.Amount != null) {
                        wrap.Amount += oppObj.Amount; 
                    }
                    mapOfOppAndWrapper.put(oppObj.Account.Primary_Contact__c,wrap);
                    
                } 
                else {
                    //Create new instance of wrapper
                    //Add that Opp to List 
                    CollectionOfOppContents wrap = new CollectionOfOppContents();
                    wrap.oppList.add(oppObj);
                    //add Opp's amount to wrapper's amount
                    if(oppObj.Amount != null) {
                        wrap.Amount = oppObj.Amount;
                    } 
                    //Add wrapper to list
                    mapOfOppAndWrapper.put(oppObj.Account.Primary_Contact__c,wrap);
                }
            }
            system.debug('List :::'+mapOfOppAndWrapper); 
        }
        }
        else {
            System.debug('No records...');
        }
    } 
    //finish method
    global void finish(Database.BatchableContext BC) {
        List<Messaging.SingleEmailMessage> msgObj = new List<Messaging.SingleEmailMessage>();
        for (string str : mapOfOppAndWrapper.keyset()) {
            List<String> toAddresses = new List<String> {str};
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses); 
            mail.setSubject(Constants.strEmailSubject);       
            CollectionOfOppContents wrapObj = new CollectionOfOppContents();
            wrapObj = mapOfOppAndWrapper.get(str);
            String Body = (Constants.strEmailGreet);
             
            for(Opportunity oppObj: wrapObj.oppList ) {    
                system.debug('**********************'+oppObj.Name);  
                Body += (Constants.strEmailOppName + oppObj.Name + 
                Constants.strEmailAmount + oppObj.Amount);  
            }   
            Body += (Constants.strEmailAggregate + mapOfOppAndWrapper.get(str).Amount );
            system.debug('**********MAIL BODY ***************'+mail  );
            mail.setHtmlBody(Body);
            msgObj.add(mail);   
        }
        Messaging.sendEmail( msgObj ); 
    }
    //wrapper class to use multiple datatype variable
    public with sharing class CollectionOfOppContents {
        public List<Opportunity> oppList;
        public Decimal Amount;
        public CollectionOfOppContents() { 
            oppList = new List<Opportunity>();
            Amount=0;
        }
    }
}