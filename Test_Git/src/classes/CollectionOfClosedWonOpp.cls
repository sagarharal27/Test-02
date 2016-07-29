global with sharing class CollectionOfClosedWonOpp implements Database.Batchable<sObject>, Database.stateful{
    global final string queryString;
    map<string,Wrapper> mapOfOpp ;
    
    //----------------------------------------------------------------------------------------------------------------------------------------
     global CollectionOfClosedWonOpp(){
        queryString='SELECT o.Name,o.Amount,o.Account.Primary_Contact__c FROM Opportunity o WHERE o.StageName = \'Closed Won\'';   
                         
                      mapOfOpp  = new  map<string,Wrapper>() ;
   }
   //--------------------------------------------------------------------------------------------------------------------------------------------
    public with sharing class Wrapper
    {
       public list<Opportunity> oppList;
        public Decimal Amount;
        public Wrapper()
        {
         oppList = new list<Opportunity>();
            Amount=0;
        }
        
    }
    //----------------------------------------------------------------------------------------------------------------------------------------------
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(queryString);
    }
     
    //----------------------------------------------------------------------------------------------------------------------------------------------
    global void execute(Database.BatchableContext BC,List<Opportunity> listOpp)
     {
         //system.debug('List '+listOpp);
          for(Opportunity op:listOpp)
               {
                   if(op.Account.Primary_Contact__c <> Null)
                   if(mapOfOpp.containsKey(op.Account.Primary_Contact__c))
                         {
                             mapOfOpp.get(op.Account.Primary_Contact__c).oppList.add(op);
                             Wrapper wrap=mapOfOpp.get(op.Account.Primary_Contact__c);
                             wrap.Amount += op.Amount;
                         }
                  else
                         {     
                             Wrapper wrap = new Wrapper();
                             wrap.oppList.add(op);
                             wrap.Amount= op.Amount;
                             mapOfOpp.put(op.Account.Primary_Contact__c,wrap);
                         }
               }
              system.debug('List '+mapOfOpp  );
       }
                       
                   
      //--------------------------------------------------------------------------------------------------------------------------------------------
      global void finish(Database.BatchableContext BC)
      {
           list<Messaging.SingleEmailMessage> m = new list<Messaging.SingleEmailMessage>();
        
        for(string s:mapOfOpp.keyset())
        {   List<String> toAddresses = new List<String> {s};
           
               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                     mail.setToAddresses(toAddresses); 
                     mail.setSubject('Aggregate Of total Amount');       
            Wrapper wr = new Wrapper();
            wr=mapOfOpp.get(s);
            for(Opportunity op: wr.oppList )   
                {    
                     system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&'+op.Name);  
                     mail.setPlainTextBody
                        ('The Amount for Opportunity name' + op.Name +
                         ' is equals to '+ op.Amount + ' And the total Aggregate Amount is' +mapOfOpp.get(s).Amount );
                         m.add(mail);         
                }   
                
               Messaging.sendEmail( m );    
        }
         
      }
 //----------------------------------------------------------------------------------------------------------------------------------------------------
}