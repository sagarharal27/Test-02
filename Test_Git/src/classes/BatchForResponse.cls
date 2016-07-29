/***************************************************************************************************
Class : BatchForResponse
Created Date : 4/9/2015
Description : This is batch class to send an email to user 
***************************************************************************************************/
global with sharing class BatchForResponse implements 
                          Database.Batchable<sObject>,Database.Stateful {
   
    // start method of batch
    public Database.QueryLocator start(Database.BatchableContext BatchCon) {
        return Database.getQueryLocator([select Id , ContactJunction__c , ContactJunction__r.Id,
                                                QueryJunction__c,QueryJunction__r.Id
                                         from Send_Response__c
                                         where CreatedDate = Today]);
       
    }
    // Execute method for batch
    public void execute(Database.BatchableContext batchCon,List<Send_Response__c> listResponse) {
        EmailTemplate emailTemplate = [SELECT Id, Body  FROM EmailTemplate
                                       WHERE Name = :Constants.strEmailTemplate];
         
        List<Messaging.SingleEmailMessage> listOfMails = new list<Messaging.SingleEmailMessage>();
        
        for(Send_Response__c resInstance :listResponse) {
            Messaging.SingleEmailMessage mailInstance = new Messaging.SingleEmailMessage();
            mailInstance.setTargetObjectId(resInstance.ContactJunction__r.Id);
            mailInstance.setSaveAsActivity(false);
            
            //set the templateId to the VF Email Template 
            mailInstance.setTemplateId(emailTemplate.id);
              
            //set the object what is supposed to be sent in email
            mailInstance.setWhatId(resInstance.QueryJunction__r.Id);
            listOfMails.add(mailInstance);
        } 
        // Sending mail 
        Messaging.sendEmail(listOfMails); 
    } 
    global void finish(Database.BatchableContext BC) {
        system.debug('-----finish----');
    }
    
}