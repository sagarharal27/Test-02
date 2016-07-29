/************************************************************************
 Class Name: TestDuplicationOfLead
 Created Date:8/8/2015
 Description: This test class checks duplication of lead record
*************************************************************************/  
@isTest
public class BatchProcessing {
    static testMethod void testOpportunity() {
         List<Account> accList = new List<Account>();
         List<Opportunity> oppList = new List<Opportunity>();
         
         for(Integer i=0;i<5;i++ ) {
             Account testAccount = new Account(Primary_Contact__c = 'Pooja'+i+'@eternussolutions.com',
                                Name = 'Pooja'+i,Email_ID__c='test'+i+'.jadhav@eternussolutions.com');
            accList.add(testAccount); 
        } 
        if(!accList.isEmpty()) 
            insert accList;
        
        for(Integer i=0;i<5;i++ ){  
            Opportunity testOppTemp = new Opportunity(Amount = 30,Name = 'Pooja' +i,
                                  CloseDate = (Date)Date.today() ,
                                  AccountId = accList[0].Id,StageName  = 'Closed Won');
            oppList.add(testOppTemp);
        }
        if(!oppList.isEmpty())
            insert oppList;
        Database.executeBatch(new CollectionOfClosedOpportunity ()); 
        system.assertEquals(0,Limits.getEmailInvocations());
    }
}