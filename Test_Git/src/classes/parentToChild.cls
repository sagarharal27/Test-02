/****************************************************************************
 Class Name: parentToChild
 Created Date:14/7/2015
 Description: This class performs Parent to child functions.
*****************************************************************************/ 

public class parentToChild {
    //Displaying opportunity record which are closed        
    public void ClosedWonOpportunity() {        
        list<account> lstaccount=[Select a.Name,  (Select Id, StageName From Opportunities) 
                                  From Account a where  a.id IN (Select AccountId from Opportunity
                                  where StageName Like 'Closed Won')];
        if(lstaccount!=null && lstaccount.size()>0){
            System.debug(lstaccount+'Displaying records...'); 
        }
        else{
            system.debug('Records not found');
        } 
    }
    //displayind record having name as john
    public void recordHavingNameJohn() {
        

        list<Account> Listaccount = [select a.Name,a.Id, (select Name from Contacts where Name Like '%John%') 
                                    From Account a where a.Id IN
                                    (Select AccountId from Contact where Name Like '%john%') ];
        if(Listaccount!=null && Listaccount.size()>0){
        for(Account acn:Listaccount) {
           system.debug(acn+'Diplaying Records');
           if(acn.contacts!=null && acn.contacts.size()>0){
                for(contact con: acn.contacts) {
                    system.debug(con+'Displaying records of contact'); 
                }
           }
           else{
                system.debug('Records not found');
           }
         }
        }
        else{
             system.debug('Records not found');
         }
   }
   //displayind record having name as john  in custome object
    public void recordHavingJohnInchild() {
        list<A__c> myList = [Select a.Name, a.Id, (Select Name From C__r) 
                              From A__c a  
                              where  A__c.id IN (Select C_to_A__c from C__c where Name Like '%john%')];
                              
        if(myList!=null && myList.size()>0){                  
            for(A__c aobj:myList) {
                system.debug(aobj+'Records of account');
                    
                    if(aobj.C__r!=null && aobj.C__r.size()>0){
                        for(C__c cobj: aobj.C__r) {
                             system.debug(cobj+'Displaying records.');
                        }
                    }
                    else{
                        system.debug('Record not found');
                    }
              }
          }
          else{
              system.debug('Record not found');
          }
    }
}